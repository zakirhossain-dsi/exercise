CREATE PROCEDURE mlff_core.transfer_data_for_daily_reports (IN postedDate date)

BEGIN
    SET SQL_SAFE_UPDATES = 0;

    DELETE FROM rpt_transactions WHERE cut_off_date = postedDate;
    DELETE FROM rpt_transaction_commissions WHERE cut_off_date = postedDate;
    DELETE FROM rpt_violations WHERE cut_off_date = postedDate;
    DELETE FROM rpt_vehicle_recognition WHERE cut_off_date = postedDate;
    DELETE FROM rpt_orders WHERE cut_off_date = postedDate;
    DELETE FROM rpt_payment_notifications WHERE cut_off_date = postedDate;

    INSERT INTO rpt_transactions(cut_off_date, account_no, account_sub_type, account_type, advance_payment, agency_id, app_id, buffered_flag, collector_id, counter, created_date, cust_id_number, entry_data_source, entry_gantry_id, entry_lane_id, entry_plaza_id, entry_sp_id, entry_timestamp, error_code_id, error_description, ewallet_error_code, ewallet_error_msg, exempt_has_fare, exit_gantry_id, exit_lane_id, exit_plaza_id, exit_sp_id, exit_timestamp, failed_error_rule, fare, fare_id, fare_source, group_id, has_apportionment, has_settlement, id, image_captured, ind_axles_offset, ind_veh_axles, ind_veh_class, is_from_vector, is_mha_class, is_passable_future_date, is_short_journey, is_tag_inactive, is_tag_inactive_allowable_range, is_vehicle_class_mismatch, is_within_allowable_period, is_zero_fare, lane_mode, lane_serial_num, mx_account_id, original_amt, pairing_date, pairing_status, payment_datetime, payment_id, payment_type, post_write_trx_num, posted_date, pre_write_trx_num, processed_timestamp, read_agency_data, read_performance, read_tag_class_rear_tires, read_tag_class_veh_axles, read_tag_class_veh_type, read_tag_class_veh_weight, received_timestamp, response_code, response_description, response_status, revenue_type, sc_spid, serial_num, si_code, source_of_fund, sp_code, sp_sent_timestamp, std_plan_description, std_plan_id, summary_id, t_type_fk, tag_serial_num, tag_serial_num_ref, tc_response_timestamp, tc_serial_num, tc_transaction_id, tp_reason_code, tran_amt, transaction_status, transaction_type, txn_ack_queue, txn_response_queue, type, validation_status, veh_speed, vehicle_class, vehicle_class_from_vector, vehicle_entitlement, vehicle_plate_num, vehicle_recognition_id, viol_observed, wallet_account_no, wallet_uuid, write_agency_data, write_tag_class_rear_tires, write_tag_class_veh_axles, write_tag_class_veh_type, write_tag_class_veh_weight)
    SELECT postedDate, account_no, account_sub_type, account_type, advance_payment, agency_id, app_id, buffered_flag, collector_id, counter, sysdate(), cust_id_number, entry_data_source, entry_gantry_id, entry_lane_id, entry_plaza_id, entry_sp_id, entry_timestamp, error_code_id, error_description, ewallet_error_code, ewallet_error_msg, exempt_has_fare, exit_gantry_id, exit_lane_id, exit_plaza_id, exit_sp_id, exit_timestamp, failed_error_rule, fare, fare_id, fare_source, group_id, has_apportionment, has_settlement, id, image_captured, ind_axles_offset, ind_veh_axles, ind_veh_class, is_from_vector, is_mha_class, is_passable_future_date, is_short_journey, is_tag_inactive, is_tag_inactive_allowable_range, is_vehicle_class_mismatch, is_within_allowable_period, is_zero_fare, lane_mode, lane_serial_num, mx_account_id, original_amt, pairing_date, pairing_status, payment_datetime, payment_id, payment_type, post_write_trx_num, posted_date, pre_write_trx_num, processed_timestamp, read_agency_data, read_performance, read_tag_class_rear_tires, read_tag_class_veh_axles, read_tag_class_veh_type, read_tag_class_veh_weight, received_timestamp, response_code, response_description, response_status, revenue_type, sc_spid, serial_num, si_code, source_of_fund, sp_code, sp_sent_timestamp, std_plan_description, std_plan_id, summary_id, t_type_fk, tag_serial_num, tag_serial_num_ref, tc_response_timestamp, tc_serial_num, tc_transaction_id, tp_reason_code, tran_amt, transaction_status, transaction_type, txn_ack_queue, txn_response_queue, type, validation_status, veh_speed, vehicle_class, vehicle_class_from_vector, vehicle_entitlement, vehicle_plate_num, vehicle_recognition_id, viol_observed, wallet_account_no, wallet_uuid, write_agency_data, write_tag_class_rear_tires, write_tag_class_veh_axles, write_tag_class_veh_type, write_tag_class_veh_weight
    FROM mlff_transactions
    WHERE DATE(created_date) = postedDate AND deleted = false;

    INSERT INTO rpt_transaction_commissions (cut_off_date, commission, created_date, fare, gst, id, net, original_fare, spid, transaction_id_fk)
    SELECT postedDate, tc.commission, sysdate(), tc.fare, tc.gst, tc.id, tc.net, tc.original_fare, tc.spid, tc.transaction_id_fk
    FROM mlff_transaction_commissions tc
    INNER JOIN mlff_transactions t ON t.id = tc.transaction_id_fk AND t.deleted = false
    WHERE tc.deleted = false AND date(t.created_date) = postedDate;

    INSERT INTO rpt_violations (cut_off_date, created_date, id, mlff_status, mlff_transaction_id, publish_status, regis_tag_serial_number, regis_tag_status, regis_vehicle_class, regis_vehicle_number, supplemental_info, tag_serial_number, vehicle_class, vehicle_number, vehicle_recognition_id, violation_ref_id, violation_status)
    SELECT postedDate, sysdate(), v.id, v.mlff_status, v.mlff_transaction_id, v.publish_status, v.regis_tag_serial_number, v.regis_tag_status, v.regis_vehicle_class, v.regis_vehicle_number, v.supplemental_info, v.tag_serial_number, v.vehicle_class, v.vehicle_number, v.vehicle_recognition_id, v.violation_ref_id, v.violation_status
    FROM mlff_violations v
    WHERE v.deleted = false AND date(v.created_date) = postedDate;

    INSERT INTO rpt_vehicle_recognition (cut_off_date, act_reg_tag_serial_num, anpr_image_file_path, created_date, gantry_id, id, lane_id, plaza_id, received_timestamp, recognition_no, recognition_timestamp, sp_id, sp_sent_timestamp, tc_response_timestamp, tc_transaction_id, tp_reason_code, transaction_status, vehicle_class, vehicle_plate_num, vehicle_speed, vehicle_weight)
    SELECT postedDate, act_reg_tag_serial_num, anpr_image_file_path, sysdate(), gantry_id, id, lane_id, plaza_id, received_timestamp, recognition_no, recognition_timestamp, sp_id, sp_sent_timestamp, tc_response_timestamp, tc_transaction_id, tp_reason_code, transaction_status, vehicle_class, vehicle_plate_num, vehicle_speed, vehicle_weight
    FROM mlff_vehicle_recognition
    WHERE deleted = false AND date(created_date) = postedDate;

    INSERT INTO rpt_orders (cut_off_date, acquirement_id, cashier_request_id, created_date, credit_finish_time, id, invocation_count, merchant_trans_id, mx_account_id, notify_url, order_amount, order_number, order_status, order_title, order_type, payment_option_id_fk, payment_type, req_created_time, request_end, request_start, request_text, resp_created_time, result_code, result_code_id, result_msg, result_status, retry_count, sof_id_fk, tag_serial_number, user_id)
    SELECT postedDate, acquirement_id, cashier_request_id, sysdate(), credit_finish_time, id, invocation_count, merchant_trans_id, mx_account_id, notify_url, order_amount, order_number, order_status, order_title, order_type, payment_option_id_fk, payment_type, req_created_time, request_end, request_start, request_text, resp_created_time, result_code, result_code_id, result_msg, result_status, retry_count, sof_id_fk, tag_serial_number, user_id
    FROM mlff_orders
    WHERE deleted = false AND date(created_date) = postedDate;

    INSERT INTO rpt_payment_notifications (cut_off_date, acquirement_id, advance_payment, cashier_request_id, created_date, created_time, finished_time, id, is_order_query, merchant_id, notify_config_id_fk, order_amount, order_id_fk, order_number, order_status, paid_time, pay_amount, pay_method, payment_datetime, payment_error_code, payment_id, payment_status, posted_date, res_acquirer, res_authcode, res_bank_ref_no, res_card_expire, res_card_holder, res_card_no_mask, res_card_type, res_currency_code, res_issuing_bank, res_time, res_token, res_token_type, res_txn_id, res_txn_status_code, res_txn_status_message, sof, status)
    SELECT postedDate, acquirement_id, advance_payment, cashier_request_id, sysdate(), created_time, finished_time, id, is_order_query, merchant_id, notify_config_id_fk, order_amount, order_id_fk, order_number, order_status, paid_time, pay_amount, pay_method, payment_datetime, payment_error_code, payment_id, payment_status, posted_date, res_acquirer, res_authcode, res_bank_ref_no, res_card_expire, res_card_holder, res_card_no_mask, res_card_type, res_currency_code, res_issuing_bank, res_time, res_token, res_token_type, res_txn_id, res_txn_status_code, res_txn_status_message, sof, status
    FROM mlff_payment_notifications
    WHERE deleted = false AND date(created_date) = postedDate;

    SET SQL_SAFE_UPDATES = 1;
END