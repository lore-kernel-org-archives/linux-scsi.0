From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 13/16] libosd: SCSI/OSD Sense decoding support
Date: Sun, 25 Jan 2009 17:15:16 +0200
Message-ID: <1232896516-19829-1-git-send-email-bharrosh@panasas.com>
References: <497C7B33.4080105@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:31453 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752085AbZAYPPV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 10:15:21 -0500
In-Reply-To: <497C7B33.4080105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

Implementation of the osd_req_decode_sense() API. Can be called by
library users to decode what failed in command executions.

Add SCSI_OSD_DPRINT_SENSE Kconfig variable. Possible values are:
0 - Do not print any errors to messages file <KERN_ERR>
1 - (Default) Print only decoded errors that are not recoverable.
    Recoverable errors are those that the target has complied with
    the request but with a warning. For example read passed end of
    object will return zeros after the last valid byte.
2- Print all errors.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/Kbuild          |    6 +
 drivers/scsi/osd/osd_initiator.c |  191 ++++++++++++++++++++++++++++
 include/scsi/osd_initiator.h     |   49 +++++++
 include/scsi/osd_sense.h         |  260 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 506 insertions(+), 0 deletions(-)
 create mode 100644 include/scsi/osd_sense.h

diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
index 9d38248..0e207aa 100644
--- a/drivers/scsi/osd/Kbuild
+++ b/drivers/scsi/osd/Kbuild
@@ -20,6 +20,12 @@ ccflags-y += -DCONFIG_SCSI_OSD_INITIATOR -DCONFIG_SCSI_OSD_INITIATOR_MODULE
 CONFIG_SCSI_OSD_ULD=m
 ccflags-y += -DCONFIG_SCSI_OSD_ULD -DCONFIG_SCSI_OSD_ULD_MODULE
 
+# CONFIG_SCSI_OSD_DPRINT_SENSE =
+#	0 - no print of errors
+#	1 - print errors
+#	2 - errors + warrnings
+ccflags-y += -DCONFIG_SCSI_OSD_DPRINT_SENSE=1
+
 # Uncomment to turn debug on
 # ccflags-y += -DCONFIG_SCSI_OSD_DEBUG
 
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index f6340c2..0bbbf27 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -42,6 +42,8 @@
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
 #include <scsi/osd_attributes.h>
+#include <scsi/osd_sense.h>
+
 #include <scsi/scsi_device.h>
 
 #include "osd_debug.h"
@@ -1339,6 +1341,195 @@ int osd_finalize_request(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_finalize_request);
 
+#define OSD_SENSE_PRINT1(fmt, a...) \
+	do { \
+		if (__cur_sense_need_output) \
+			OSD_ERR(fmt, ##a); \
+	} while (0)
+
+#define OSD_SENSE_PRINT2(fmt, a...) OSD_SENSE_PRINT1("    " fmt, ##a)
+
+int osd_req_decode_sense_full(struct osd_request *or,
+	struct osd_sense_info *osi, bool silent,
+	struct osd_obj_id *bad_obj_list __unused, int max_obj __unused,
+	struct osd_attr *bad_attr_list, int max_attr)
+{
+	int sense_len, original_sense_len;
+	struct osd_sense_info local_osi;
+	struct scsi_sense_descriptor_based *ssdb;
+	void *cur_descriptor;
+#if (CONFIG_SCSI_OSD_DPRINT_SENSE == 0)
+	const bool __cur_sense_need_output = false;
+#else
+	bool __cur_sense_need_output = !silent;
+#endif
+
+	if (!or->request->errors)
+		return 0;
+
+	ssdb = or->request->sense;
+	sense_len = or->request->sense_len;
+	if ((sense_len < (int)sizeof(*ssdb) || !ssdb->sense_key)) {
+		OSD_ERR("Block-layer returned error(0x%x) but "
+			"sense_len(%u) || key(%d) is empty\n",
+			or->request->errors, sense_len, ssdb->sense_key);
+		return -EIO;
+	}
+
+	if ((ssdb->response_code != 0x72) && (ssdb->response_code != 0x73)) {
+		OSD_ERR("Unrecognized scsi sense: rcode=%x length=%d\n",
+			ssdb->response_code, sense_len);
+		return -EIO;
+	}
+
+	osi = osi ? : &local_osi;
+	memset(osi, 0, sizeof(*osi));
+	osi->key = ssdb->sense_key;
+	osi->additional_code = be16_to_cpu(ssdb->additional_sense_code);
+	original_sense_len = ssdb->additional_sense_length + 8;
+
+#if (CONFIG_SCSI_OSD_DPRINT_SENSE == 1)
+	if (__cur_sense_need_output)
+		__cur_sense_need_output = (osi->key > scsi_sk_recovered_error);
+#endif
+	OSD_SENSE_PRINT1("Main Sense information key=0x%x length(%d, %d) "
+			"additional_code=0x%x\n",
+			osi->key, original_sense_len, sense_len,
+			osi->additional_code);
+
+	if (original_sense_len < sense_len)
+		sense_len = original_sense_len;
+
+	cur_descriptor = ssdb->ssd;
+	sense_len -= sizeof(*ssdb);
+	while (sense_len > 0) {
+		struct scsi_sense_descriptor *ssd = cur_descriptor;
+		int cur_len = ssd->additional_length + 2;
+
+		sense_len -= cur_len;
+
+		if (sense_len < 0)
+			break; /* sense was truncated */
+
+		switch (ssd->descriptor_type) {
+		case scsi_sense_information:
+		case scsi_sense_command_specific_information:
+		{
+			struct scsi_sense_command_specific_data_descriptor
+				*sscd = cur_descriptor;
+
+			osi->command_info =
+				get_unaligned_be64(&sscd->information) ;
+			OSD_SENSE_PRINT2(
+				"command_specific_information 0x%llx \n",
+				_LLU(osi->command_info));
+			break;
+		}
+		case scsi_sense_key_specific:
+		{
+			struct scsi_sense_key_specific_data_descriptor
+				*ssks = cur_descriptor;
+
+			osi->sense_info = get_unaligned_be16(&ssks->value);
+			OSD_SENSE_PRINT2(
+				"sense_key_specific_information %u"
+				"sksv_cd_bpv_bp (0x%x)\n",
+				osi->sense_info, ssks->sksv_cd_bpv_bp);
+			break;
+		}
+		case osd_sense_object_identification:
+		{ /*FIXME: Keep first not last, Store in array*/
+			struct osd_sense_identification_data_descriptor
+				*osidd = cur_descriptor;
+
+			osi->not_initiated_command_functions =
+				le32_to_cpu(osidd->not_initiated_functions);
+			osi->completed_command_functions =
+				le32_to_cpu(osidd->completed_functions);
+			osi->obj.partition = be64_to_cpu(osidd->partition_id);
+			osi->obj.id = be64_to_cpu(osidd->object_id);
+			OSD_SENSE_PRINT2(
+				"object_identification pid=0x%llx oid=0x%llx\n",
+				_LLU(osi->obj.partition), _LLU(osi->obj.id));
+			OSD_SENSE_PRINT2(
+				"not_initiated_bits(%x) "
+				"completed_command_bits(%x)\n",
+				osi->not_initiated_command_functions,
+				osi->completed_command_functions);
+			break;
+		}
+		case osd_sense_response_integrity_check:
+		{
+			struct osd_sense_response_integrity_check_descriptor
+				*osricd = cur_descriptor;
+			const unsigned len =
+					  sizeof(osricd->integrity_check_value);
+			char key_dump[len*4 + 2]; /* 2nibbles+space+ASCII */
+
+			hex_dump_to_buffer(osricd->integrity_check_value, len,
+				       32, 1, key_dump, sizeof(key_dump), true);
+			OSD_SENSE_PRINT2("response_integrity [%s]\n", key_dump);
+		}
+		case osd_sense_attribute_identification:
+		{
+			struct osd_sense_attributes_data_descriptor
+				*osadd = cur_descriptor;
+			int len = min(cur_len, sense_len);
+			int i = 0;
+			struct osd_sense_attr *pattr = osadd->sense_attrs;
+
+			while (len < 0) {
+				u32 attr_page = be32_to_cpu(pattr->attr_page);
+				u32 attr_id = be32_to_cpu(pattr->attr_id);
+
+				if (i++ == 0) {
+					osi->attr.attr_page = attr_page;
+					osi->attr.attr_id = attr_id;
+				}
+
+				if (bad_attr_list && max_attr) {
+					bad_attr_list->attr_page = attr_page;
+					bad_attr_list->attr_id = attr_id;
+					bad_attr_list++;
+					max_attr--;
+				}
+				OSD_SENSE_PRINT2(
+					"osd_sense_attribute_identification"
+					"attr_page=0x%x attr_id=0x%x\n",
+					attr_page, attr_id);
+			}
+		}
+		/*These are not legal for OSD*/
+		case scsi_sense_field_replaceable_unit:
+			OSD_SENSE_PRINT2("scsi_sense_field_replaceable_unit\n");
+			break;
+		case scsi_sense_stream_commands:
+			OSD_SENSE_PRINT2("scsi_sense_stream_commands\n");
+			break;
+		case scsi_sense_block_commands:
+			OSD_SENSE_PRINT2("scsi_sense_block_commands\n");
+			break;
+		case scsi_sense_ata_return:
+			OSD_SENSE_PRINT2("scsi_sense_ata_return\n");
+			break;
+		default:
+			if (ssd->descriptor_type <= scsi_sense_Reserved_last)
+				OSD_SENSE_PRINT2(
+					"scsi_sense Reserved descriptor (0x%x)",
+					ssd->descriptor_type);
+			else
+				OSD_SENSE_PRINT2(
+					"scsi_sense Vendor descriptor (0x%x)",
+					ssd->descriptor_type);
+		}
+
+		cur_descriptor += cur_len;
+	}
+
+	return (osi->key > scsi_sk_recovered_error) ? -EIO : 0;
+}
+EXPORT_SYMBOL(osd_req_decode_sense_full);
+
 /*
  * Implementation of osd_sec.h API
  * TODO: Move to a separate osd_sec.c file at a later stage.
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 24edeae..b24d961 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -217,6 +217,55 @@ int osd_execute_request_async(struct osd_request *or,
 	osd_req_done_fn *done, void *private);
 
 /**
+ * osd_req_decode_sense_full - Decode sense information after execution.
+ *
+ * @or:           - osd_request to examine
+ * @osi           - Recievs a more detailed error report information (optional).
+ * @silent        - Do not print to dmsg (Even if enabled)
+ * @bad_obj_list  - Some commands act on multiple objects. Failed objects will
+ *                  be recieved here (optional)
+ * @max_obj       - Size of @bad_obj_list.
+ * @bad_attr_list - List of failing attributes (optional)
+ * @max_attr      - Size of @bad_attr_list.
+ *
+ * After execution, sense + return code can be analyzed using this function. The
+ * return code is the final disposition on the error. So it is possible that a
+ * CHECK_CONDITION was returned from target but this will return NO_ERROR, for
+ * example on recovered errors. All parameters are optional if caller does
+ * not need any returned information.
+ * Note: This function will also dump the error to dmsg according to settings
+ * of the SCSI_OSD_DPRINT_SENSE Kconfig value. Set @silent if you know the
+ * command would routinely fail, to not spam the dmsg file.
+ */
+struct osd_sense_info {
+	int key;		/* one of enum scsi_sense_keys */
+	int additional_code ;	/* enum osd_additional_sense_codes */
+	union { /* Sense specific information */
+		u16 sense_info;
+		u16 cdb_field_offset; 	/* scsi_invalid_field_in_cdb */
+	};
+	union { /* Command specific information */
+		u64 command_info;
+	};
+
+	u32 not_initiated_command_functions; /* osd_command_functions_bits */
+	u32 completed_command_functions; /* osd_command_functions_bits */
+	struct osd_obj_id obj;
+	struct osd_attr attr;
+};
+
+int osd_req_decode_sense_full(struct osd_request *or,
+	struct osd_sense_info *osi, bool silent,
+	struct osd_obj_id *bad_obj_list, int max_obj,
+	struct osd_attr *bad_attr_list, int max_attr);
+
+static inline int osd_req_decode_sense(struct osd_request *or,
+	struct osd_sense_info *osi)
+{
+	return osd_req_decode_sense_full(or, osi, false, NULL, 0, NULL, 0);
+}
+
+/**
  * osd_end_request - return osd_request to free store
  *
  * @or:		osd_request to free
diff --git a/include/scsi/osd_sense.h b/include/scsi/osd_sense.h
new file mode 100644
index 0000000..ff9b33c
--- /dev/null
+++ b/include/scsi/osd_sense.h
@@ -0,0 +1,260 @@
+/*
+ * osd_sense.h - OSD Related sense handling definitions.
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ * This file contains types and constants that are defined by the protocol
+ * Note: All names and symbols are taken from the OSD standard's text.
+ */
+#ifndef __OSD_SENSE_H__
+#define __OSD_SENSE_H__
+
+#include <scsi/osd_protocol.h>
+
+/* SPC3r23 4.5.6 Sense key and sense code definitions table 27 */
+enum scsi_sense_keys {
+	scsi_sk_no_sense        = 0x0,
+	scsi_sk_recovered_error = 0x1,
+	scsi_sk_not_ready       = 0x2,
+	scsi_sk_medium_error    = 0x3,
+	scsi_sk_hardware_error  = 0x4,
+	scsi_sk_illegal_request = 0x5,
+	scsi_sk_unit_attention  = 0x6,
+	scsi_sk_data_protect    = 0x7,
+	scsi_sk_blank_check     = 0x8,
+	scsi_sk_vendor_specific = 0x9,
+	scsi_sk_copy_aborted    = 0xa,
+	scsi_sk_aborted_command = 0xb,
+	scsi_sk_volume_overflow = 0xd,
+	scsi_sk_miscompare      = 0xe,
+	scsi_sk_reserved        = 0xf,
+};
+
+/* SPC3r23 4.5.6 Sense key and sense code definitions table 28 */
+/* Note: only those which can be returned by an OSD target. Most of
+ *       these errors are taken care of by the generic scsi layer.
+ */
+enum osd_additional_sense_codes {
+	scsi_no_additional_sense_information			= 0x0000,
+	scsi_operation_in_progress				= 0x0016,
+	scsi_cleaning_requested					= 0x0017,
+	scsi_lunr_cause_not_reportable				= 0x0400,
+	scsi_logical_unit_is_in_process_of_becoming_ready	= 0x0401,
+	scsi_lunr_initializing_command_required			= 0x0402,
+	scsi_lunr_manual_intervention_required			= 0x0403,
+	scsi_lunr_operation_in_progress				= 0x0407,
+	scsi_lunr_selftest_in_progress				= 0x0409,
+	scsi_luna_asymmetric_access_state_transition		= 0x040a,
+	scsi_luna_target_port_in_standby_state			= 0x040b,
+	scsi_luna_target_port_in_unavailable_state		= 0x040c,
+	scsi_lunr_notify_enable_spinup_required			= 0x0411,
+	scsi_logical_unit_does_not_respond_to_selection		= 0x0500,
+	scsi_logical_unit_communication_failure			= 0x0800,
+	scsi_logical_unit_communication_timeout			= 0x0801,
+	scsi_logical_unit_communication_parity_error		= 0x0802,
+	scsi_error_log_overflow					= 0x0a00,
+	scsi_warning						= 0x0b00,
+	scsi_warning_specified_temperature_exceeded		= 0x0b01,
+	scsi_warning_enclosure_degraded				= 0x0b02,
+	scsi_write_error_unexpected_unsolicited_data		= 0x0c0c,
+	scsi_write_error_not_enough_unsolicited_data		= 0x0c0d,
+	scsi_invalid_information_unit				= 0x0e00,
+	scsi_invalid_field_in_command_information_unit		= 0x0e03,
+	scsi_read_error_failed_retransmission_request		= 0x1113,
+	scsi_parameter_list_length_error			= 0x1a00,
+	scsi_invalid_command_operation_code			= 0x2000,
+	scsi_invalid_field_in_cdb				= 0x2400,
+	osd_security_audit_value_frozen				= 0x2404,
+	osd_security_working_key_frozen				= 0x2405,
+	osd_nonce_not_unique					= 0x2406,
+	osd_nonce_timestamp_out_of_range			= 0x2407,
+	scsi_logical_unit_not_supported				= 0x2500,
+	scsi_invalid_field_in_parameter_list			= 0x2600,
+	scsi_parameter_not_supported				= 0x2601,
+	scsi_parameter_value_invalid				= 0x2602,
+	scsi_invalid_release_of_persistent_reservation		= 0x2604,
+	osd_invalid_dataout_buffer_integrity_check_value	= 0x260f,
+	scsi_not_ready_to_ready_change_medium_may_have_changed	= 0x2800,
+	scsi_power_on_reset_or_bus_device_reset_occurred	= 0x2900,
+	scsi_power_on_occurred					= 0x2901,
+	scsi_scsi_bus_reset_occurred				= 0x2902,
+	scsi_bus_device_reset_function_occurred			= 0x2903,
+	scsi_device_internal_reset				= 0x2904,
+	scsi_transceiver_mode_changed_to_single_ended		= 0x2905,
+	scsi_transceiver_mode_changed_to_lvd			= 0x2906,
+	scsi_i_t_nexus_loss_occurred				= 0x2907,
+	scsi_parameters_changed					= 0x2a00,
+	scsi_mode_parameters_changed				= 0x2a01,
+	scsi_asymmetric_access_state_changed			= 0x2a06,
+	scsi_priority_changed					= 0x2a08,
+	scsi_command_sequence_error				= 0x2c00,
+	scsi_previous_busy_status				= 0x2c07,
+	scsi_previous_task_set_full_status			= 0x2c08,
+	scsi_previous_reservation_conflict_status		= 0x2c09,
+	osd_partition_or_collection_contains_user_objects	= 0x2c0a,
+	scsi_commands_cleared_by_another_initiator		= 0x2f00,
+	scsi_cleaning_failure					= 0x3007,
+	scsi_enclosure_failure					= 0x3400,
+	scsi_enclosure_services_failure				= 0x3500,
+	scsi_unsupported_enclosure_function			= 0x3501,
+	scsi_enclosure_services_unavailable			= 0x3502,
+	scsi_enclosure_services_transfer_failure		= 0x3503,
+	scsi_enclosure_services_transfer_refused		= 0x3504,
+	scsi_enclosure_services_checksum_error			= 0x3505,
+	scsi_rounded_parameter					= 0x3700,
+	osd_read_past_end_of_user_object			= 0x3b17,
+	scsi_logical_unit_has_not_self_configured_yet		= 0x3e00,
+	scsi_logical_unit_failure				= 0x3e01,
+	scsi_timeout_on_logical_unit				= 0x3e02,
+	scsi_logical_unit_failed_selftest			= 0x3e03,
+	scsi_logical_unit_unable_to_update_selftest_log		= 0x3e04,
+	scsi_target_operating_conditions_have_changed		= 0x3f00,
+	scsi_microcode_has_been_changed				= 0x3f01,
+	scsi_inquiry_data_has_changed				= 0x3f03,
+	scsi_echo_buffer_overwritten				= 0x3f0f,
+	scsi_diagnostic_failure_on_component_nn_first		= 0x4080,
+	scsi_diagnostic_failure_on_component_nn_last		= 0x40ff,
+	scsi_message_error					= 0x4300,
+	scsi_internal_target_failure				= 0x4400,
+	scsi_select_or_reselect_failure				= 0x4500,
+	scsi_scsi_parity_error					= 0x4700,
+	scsi_data_phase_crc_error_detected			= 0x4701,
+	scsi_scsi_parity_error_detected_during_st_data_phase	= 0x4702,
+	scsi_asynchronous_information_protection_error_detected	= 0x4704,
+	scsi_protocol_service_crc_error				= 0x4705,
+	scsi_phy_test_function_in_progress			= 0x4706,
+	scsi_invalid_message_error				= 0x4900,
+	scsi_command_phase_error				= 0x4a00,
+	scsi_data_phase_error					= 0x4b00,
+	scsi_logical_unit_failed_self_configuration		= 0x4c00,
+	scsi_overlapped_commands_attempted			= 0x4e00,
+	osd_quota_error						= 0x5507,
+	scsi_failure_prediction_threshold_exceeded		= 0x5d00,
+	scsi_failure_prediction_threshold_exceeded_false	= 0x5dff,
+	scsi_voltage_fault					= 0x6500,
+};
+
+enum scsi_descriptor_types {
+	scsi_sense_information			= 0x0,
+	scsi_sense_command_specific_information	= 0x1,
+	scsi_sense_key_specific			= 0x2,
+	scsi_sense_field_replaceable_unit	= 0x3,
+	scsi_sense_stream_commands		= 0x4,
+	scsi_sense_block_commands		= 0x5,
+	osd_sense_object_identification		= 0x6,
+	osd_sense_response_integrity_check	= 0x7,
+	osd_sense_attribute_identification	= 0x8,
+	scsi_sense_ata_return			= 0x9,
+
+	scsi_sense_Reserved_first		= 0x0A,
+	scsi_sense_Reserved_last		= 0x7F,
+	scsi_sense_Vendor_specific_first	= 0x80,
+	scsi_sense_Vendor_specific_last		= 0xFF,
+};
+
+struct scsi_sense_descriptor { /* for picking into desc type */
+	u8	descriptor_type; /* one of enum scsi_descriptor_types */
+	u8	additional_length; /* n - 1 */
+	u8	data[];
+} __packed;
+
+/* OSD deploys only scsi descriptor_based sense buffers */
+struct scsi_sense_descriptor_based {
+/*0*/	u8 	response_code; /* 0x72 or 0x73 */
+/*1*/	u8 	sense_key; /* one of enum scsi_sense_keys (4 lower bits) */
+/*2*/	__be16	additional_sense_code; /* enum osd_additional_sense_codes */
+/*4*/	u8	Reserved[3];
+/*7*/	u8	additional_sense_length; /* n - 7 */
+/*8*/	struct	scsi_sense_descriptor ssd[0]; /* variable length, 1 or more */
+} __packed;
+
+/* some descriptors deployed by OSD */
+
+/* SPC3r23 4.5.2.3 Command-specific information sense data descriptor */
+/* Note: this is the same for descriptor_type=00 but with type=00 the
+ *        Reserved[0] == 0x80 (ie. bit-7 set)
+ */
+struct scsi_sense_command_specific_data_descriptor {
+/*0*/	u8	descriptor_type; /* (00h/01h) */
+/*1*/	u8	additional_length; /* (0Ah) */
+/*2*/	u8	Reserved[2];
+/*4*/	__be64  information;
+} __packed;
+/*12*/
+
+struct scsi_sense_key_specific_data_descriptor {
+/*0*/	u8	descriptor_type; /* (02h) */
+/*1*/	u8	additional_length; /* (06h) */
+/*2*/	u8	Reserved[2];
+/* SKSV, C/D, Reserved (2), BPV, BIT POINTER (3) */
+/*4*/	u8	sksv_cd_bpv_bp;
+/*5*/	__be16	value; /* field-pointer/progress-value/retry-count/... */
+/*7*/	u8	Reserved2;
+} __packed;
+/*8*/
+
+/* 4.16.2.1 OSD error identification sense data descriptor - table 52 */
+/* Note: these bits are defined LE order for easy definition, this way the BIT()
+ * number is the same as in the documentation. Below members at
+ * osd_sense_identification_data_descriptor are therefore defined __le32.
+ */
+enum osd_command_functions_bits {
+	OSD_CFB_COMMAND		 = BIT(4),
+	OSD_CFB_CMD_CAP_VERIFIED = BIT(5),
+	OSD_CFB_VALIDATION	 = BIT(7),
+	OSD_CFB_IMP_ST_ATT	 = BIT(12),
+	OSD_CFB_SET_ATT		 = BIT(20),
+	OSD_CFB_SA_CAP_VERIFIED	 = BIT(21),
+	OSD_CFB_GET_ATT		 = BIT(28),
+	OSD_CFB_GA_CAP_VERIFIED	 = BIT(29),
+};
+
+struct osd_sense_identification_data_descriptor {
+/*0*/	u8	descriptor_type; /* (06h) */
+/*1*/	u8	additional_length; /* (1Eh) */
+/*2*/	u8	Reserved[6];
+/*8*/	__le32	not_initiated_functions; /*osd_command_functions_bits*/
+/*12*/	__le32	completed_functions; /*osd_command_functions_bits*/
+/*16*/ 	__be64	partition_id;
+/*24*/	__be64	object_id;
+} __packed;
+/*32*/
+
+struct osd_sense_response_integrity_check_descriptor {
+/*0*/	u8	descriptor_type; /* (07h) */
+/*1*/	u8	additional_length; /* (20h) */
+/*2*/	u8	integrity_check_value[32]; /*FIXME: OSDv2_CRYPTO_KEYID_SIZE*/
+} __packed;
+/*34*/
+
+struct osd_sense_attributes_data_descriptor {
+/*0*/	u8	descriptor_type; /* (08h) */
+/*1*/	u8	additional_length; /* (n-2) */
+/*2*/	u8	Reserved[6];
+	struct osd_sense_attr {
+/*8*/		__be32	attr_page;
+/*12*/		__be32	attr_id;
+/*16*/	} sense_attrs[0]; /* 1 or more */
+} __packed;
+/*variable*/
+
+/* Dig into scsi_sk_illegal_request/scsi_invalid_field_in_cdb errors */
+
+/*FIXME: Support also field in CAPS*/
+#define OSD_CDB_OFFSET(F) offsetof(struct osd_cdb_head, F)
+
+enum osdv2_cdb_field_offset {
+	OSDv1_CFO_STARTING_BYTE	= OSD_CDB_OFFSET(v1.start_address),
+	OSD_CFO_STARTING_BYTE	= OSD_CDB_OFFSET(v2.start_address),
+	OSD_CFO_PARTITION_ID	= OSD_CDB_OFFSET(partition),
+	OSD_CFO_OBJECT_ID	= OSD_CDB_OFFSET(object),
+};
+
+#endif /* ndef __OSD_SENSE_H__ */
-- 
1.6.0.1

