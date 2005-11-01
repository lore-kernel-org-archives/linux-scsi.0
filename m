From: brking@us.ibm.com
Subject: [PATCH 15/26] ipr: handle new adapter errors
Date: Tue, 01 Nov 2005 17:01:47 -0600
Message-ID: <200511012301.jA1N1mIq025311@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:20966 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751411AbVKAXBt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:01:49 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1n8M008399
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:49 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N2qDC519480
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:52 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1m06025330
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Add support for handling some new errors that may be returned
by ipr adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   83 +++++++++++++++++++++++++++++------
 linux-2.6-bjking1/drivers/scsi/ipr.h |   10 ++++
 2 files changed, 81 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_new_errors drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_new_errors	2005-11-01 16:08:02.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-01 16:08:02.000000000 -0600
@@ -81,6 +81,8 @@
 #define	IPR_IOASC_IOASC_MASK			0xFFFFFF00
 #define	IPR_IOASC_SCSI_STATUS_MASK		0x000000FF
 #define IPR_IOASC_IR_RESOURCE_HANDLE		0x05250000
+#define IPR_IOASC_IR_NO_CMDS_TO_2ND_IOA		0x05258100
+#define IPR_IOASA_IR_DUAL_IOA_DISABLED		0x052C8000
 #define IPR_IOASC_BUS_WAS_RESET			0x06290000
 #define IPR_IOASC_BUS_WAS_RESET_BY_OTHER		0x06298000
 #define IPR_IOASC_ABORTED_CMD_TERM_BY_HOST	0x0B5A0000
@@ -593,6 +595,12 @@ struct ipr_hostrcb_type_04_error {
 	u8 protection_level[8];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_type_07_error {
+	u8 failure_reason[64];
+	struct ipr_vpd vpd;
+	u32 data[222];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_error {
 	__be32 failing_dev_ioasc;
 	struct ipr_res_addr failing_dev_res_addr;
@@ -604,6 +612,7 @@ struct ipr_hostrcb_error {
 		struct ipr_hostrcb_type_02_error type_02_error;
 		struct ipr_hostrcb_type_03_error type_03_error;
 		struct ipr_hostrcb_type_04_error type_04_error;
+		struct ipr_hostrcb_type_07_error type_07_error;
 	} u;
 }__attribute__((packed, aligned (4)));
 
@@ -637,6 +646,7 @@ struct ipr_hcam {
 #define IPR_HOST_RCB_OVERLAY_ID_3				0x03
 #define IPR_HOST_RCB_OVERLAY_ID_4				0x04
 #define IPR_HOST_RCB_OVERLAY_ID_6				0x06
+#define IPR_HOST_RCB_OVERLAY_ID_7				0x07
 #define IPR_HOST_RCB_OVERLAY_ID_DEFAULT			0xFF
 
 	u8 reserved1[3];
diff -puN drivers/scsi/ipr.c~ipr_new_errors drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_new_errors	2005-11-01 16:08:02.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-01 16:08:02.000000000 -0600
@@ -291,12 +291,18 @@ struct ipr_error_table_t ipr_error_table
 	"3110: Device bus error, message or command phase"},
 	{0x04670400, 0, 1,
 	"9091: Incorrect hardware configuration change has been detected"},
+	{0x04678000, 0, 1,
+	"9073: Invalid multi-adapter configuration"},
 	{0x046E0000, 0, 1,
 	"FFF4: Command to logical unit failed"},
 	{0x05240000, 1, 0,
 	"Illegal request, invalid request type or request packet"},
 	{0x05250000, 0, 0,
 	"Illegal request, invalid resource handle"},
+	{0x05258000, 0, 0,
+	"Illegal request, commands not allowed to this device"},
+	{0x05258100, 0, 0,
+	"Illegal request, command not allowed to a secondary adapter"},
 	{0x05260000, 0, 0,
 	"Illegal request, invalid field in parameter list"},
 	{0x05260100, 0, 0,
@@ -305,6 +311,8 @@ struct ipr_error_table_t ipr_error_table
 	"Illegal request, parameter value invalid"},
 	{0x052C0000, 0, 0,
 	"Illegal request, command sequence error"},
+	{0x052C8000, 1, 0,
+	"Illegal request, dual adapter support not enabled"},
 	{0x06040500, 0, 1,
 	"9031: Array protection temporarily suspended, protection resuming"},
 	{0x06040600, 0, 1,
@@ -321,18 +329,26 @@ struct ipr_error_table_t ipr_error_table
 	"3029: A device replacement has occurred"},
 	{0x064C8000, 0, 1,
 	"9051: IOA cache data exists for a missing or failed device"},
+	{0x064C8100, 0, 1,
+	"9055: Auxiliary cache IOA contains cache data needed by the primary IOA"},
 	{0x06670100, 0, 1,
 	"9025: Disk unit is not supported at its physical location"},
 	{0x06670600, 0, 1,
 	"3020: IOA detected a SCSI bus configuration error"},
 	{0x06678000, 0, 1,
 	"3150: SCSI bus configuration error"},
+	{0x06678100, 0, 1,
+	"9074: Asymmetric advanced function disk configuration"},
 	{0x06690200, 0, 1,
 	"9041: Array protection temporarily suspended"},
 	{0x06698200, 0, 1,
 	"9042: Corrupt array parity detected on specified device"},
 	{0x066B0200, 0, 1,
 	"9030: Array no longer protected due to missing or failed disk unit"},
+	{0x066B8000, 0, 1,
+	"9071: Link operational transition"},
+	{0x066B8100, 0, 1,
+	"9072: Link not operational transition"},
 	{0x066B8200, 0, 1,
 	"9032: Array exposed but still protected"},
 	{0x07270000, 0, 0,
@@ -1051,32 +1067,70 @@ static void ipr_log_array_error(struct i
 }
 
 /**
- * ipr_log_generic_error - Log an adapter error.
- * @ioa_cfg:	ioa config struct
- * @hostrcb:	hostrcb struct
+ * ipr_log_hex_data - Log additional hex IOA error data.
+ * @data:		IOA error data
+ * @len:		data length
  *
  * Return value:
  * 	none
  **/
-static void ipr_log_generic_error(struct ipr_ioa_cfg *ioa_cfg,
-				  struct ipr_hostrcb *hostrcb)
+static void ipr_log_hex_data(u32 *data, int len)
 {
 	int i;
-	int ioa_data_len = be32_to_cpu(hostrcb->hcam.length);
 
-	if (ioa_data_len == 0)
+	if (len == 0)
 		return;
 
-	for (i = 0; i < ioa_data_len / 4; i += 4) {
+	for (i = 0; i < len / 4; i += 4) {
 		ipr_err("%08X: %08X %08X %08X %08X\n", i*4,
-			be32_to_cpu(hostrcb->hcam.u.raw.data[i]),
-			be32_to_cpu(hostrcb->hcam.u.raw.data[i+1]),
-			be32_to_cpu(hostrcb->hcam.u.raw.data[i+2]),
-			be32_to_cpu(hostrcb->hcam.u.raw.data[i+3]));
+			be32_to_cpu(data[i]),
+			be32_to_cpu(data[i+1]),
+			be32_to_cpu(data[i+2]),
+			be32_to_cpu(data[i+3]));
 	}
 }
 
 /**
+ * ipr_log_dual_ioa_error - Log a dual adapter error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_dual_ioa_error(struct ipr_ioa_cfg *ioa_cfg,
+				   struct ipr_hostrcb *hostrcb)
+{
+	struct ipr_hostrcb_type_07_error *error;
+
+	error = &hostrcb->hcam.u.error.u.type_07_error;
+	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
+
+	ipr_err("%s\n", error->failure_reason);
+	ipr_err("Remote Adapter VPD:\n");
+	ipr_log_vpd(&error->vpd);
+	ipr_log_hex_data(error->data,
+			 be32_to_cpu(hostrcb->hcam.length) -
+			 (offsetof(struct ipr_hostrcb_error, u) +
+			  offsetof(struct ipr_hostrcb_type_07_error, data)));
+}
+
+/**
+ * ipr_log_generic_error - Log an adapter error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_generic_error(struct ipr_ioa_cfg *ioa_cfg,
+				  struct ipr_hostrcb *hostrcb)
+{
+	ipr_log_hex_data(hostrcb->hcam.u.raw.data,
+			 be32_to_cpu(hostrcb->hcam.length));
+}
+
+/**
  * ipr_get_error - Find the specfied IOASC in the ipr_error_table.
  * @ioasc:	IOASC
  *
@@ -1161,6 +1215,9 @@ static void ipr_handle_log_data(struct i
 	case IPR_HOST_RCB_OVERLAY_ID_6:
 		ipr_log_array_error(ioa_cfg, hostrcb);
 		break;
+	case IPR_HOST_RCB_OVERLAY_ID_7:
+		ipr_log_dual_ioa_error(ioa_cfg, hostrcb);
+		break;
 	case IPR_HOST_RCB_OVERLAY_ID_1:
 	case IPR_HOST_RCB_OVERLAY_ID_DEFAULT:
 	default:
@@ -3886,6 +3943,7 @@ static void ipr_erp_start(struct ipr_ioa
 		scsi_cmd->result |= (DID_IMM_RETRY << 16);
 		break;
 	case IPR_IOASC_IR_RESOURCE_HANDLE:
+	case IPR_IOASC_IR_NO_CMDS_TO_2ND_IOA:
 		scsi_cmd->result |= (DID_NO_CONNECT << 16);
 		break;
 	case IPR_IOASC_HW_SEL_TIMEOUT:
@@ -3898,6 +3956,7 @@ static void ipr_erp_start(struct ipr_ioa
 		scsi_cmd->result |= (DID_IMM_RETRY << 16);
 		break;
 	case IPR_IOASC_MED_DO_NOT_REALLOC: /* prevent retries */
+	case IPR_IOASA_IR_DUAL_IOA_DISABLED:
 		scsi_cmd->result |= (DID_PASSTHROUGH << 16);
 		break;
 	case IPR_IOASC_BUS_WAS_RESET:
_
