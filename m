From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH RESEND 6/7] ipr: Format HCAM overlay ID 0x21
Date: Wed, 12 Mar 2014 16:08:51 -0500
Message-ID: <20140312210906.627616363@vmlinux.vnet.ibm.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60439 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752802AbaCLVML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:12:11 -0400
Content-Disposition: inline; filename=overlay_21
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

This patch adds formatting error overlay 0x21 to improve debug capabilities.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ipr.h |   14 ++++++++++++++
 2 files changed, 53 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-03-11 17:18:20.169018184 -0500
+++ b/drivers/scsi/ipr.c	2014-03-11 17:20:48.289943030 -0500
@@ -2368,6 +2368,42 @@ static void ipr_log_generic_error(struct
 }
 
 /**
+ * ipr_log_sis64_device_error - Log a cache error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_sis64_device_error(struct ipr_ioa_cfg *ioa_cfg,
+					 struct ipr_hostrcb *hostrcb)
+{
+	struct ipr_hostrcb_type_21_error *error;
+	char buffer[IPR_MAX_RES_PATH_LENGTH];
+
+	error = &hostrcb->hcam.u.error64.u.type_21_error;
+
+	ipr_err("-----Failing Device Information-----\n");
+	ipr_err("World Wide Unique ID: %08X%08X%08X%08X\n",
+		be32_to_cpu(error->wwn[0]), be32_to_cpu(error->wwn[1]),
+		 be32_to_cpu(error->wwn[2]), be32_to_cpu(error->wwn[3]));
+	ipr_err("Device Resource Path: %s\n",
+		__ipr_format_res_path(error->res_path,
+				      buffer, sizeof(buffer)));
+	error->primary_problem_desc[sizeof(error->primary_problem_desc) - 1] = '\0';
+	error->second_problem_desc[sizeof(error->second_problem_desc) - 1] = '\0';
+	ipr_err("Primary Problem Description: %s\n", error->primary_problem_desc);
+	ipr_err("Secondary Problem Description:  %s\n", error->second_problem_desc);
+	ipr_err("SCSI Sense Data: \n");
+	ipr_log_hex_data(ioa_cfg, error->sense_data, sizeof(error->sense_data));
+	ipr_err("SCSI Command Descriptor Block: \n");
+	ipr_log_hex_data(ioa_cfg, error->cdb, sizeof(error->cdb));
+
+	ipr_err("Additional IOA Data: \n");
+	ipr_log_hex_data(ioa_cfg, error->ioa_data, be32_to_cpu(error->length_of_error));
+}
+
+/**
  * ipr_get_error - Find the specfied IOASC in the ipr_error_table.
  * @ioasc:	IOASC
  *
@@ -2468,6 +2504,9 @@ static void ipr_handle_log_data(struct i
 	case IPR_HOST_RCB_OVERLAY_ID_20:
 		ipr_log_fabric_error(ioa_cfg, hostrcb);
 		break;
+	case IPR_HOST_RCB_OVERLAY_ID_21:
+		ipr_log_sis64_device_error(ioa_cfg, hostrcb);
+		break;
 	case IPR_HOST_RCB_OVERLAY_ID_23:
 		ipr_log_sis64_config_error(ioa_cfg, hostrcb);
 		break;
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2014-03-11 17:13:24.279949356 -0500
+++ b/drivers/scsi/ipr.h	2014-03-11 17:20:48.289943030 -0500
@@ -899,6 +899,18 @@ struct ipr_hostrcb_type_01_error {
 	__be32 ioa_data[236];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_type_21_error {
+	__be32 wwn[4];
+	u8 res_path[8];
+	u8 primary_problem_desc[32];
+	u8 second_problem_desc[32];
+	__be32 sense_data[8];
+	__be32 cdb[4];
+	__be32 residual_trans_length;
+	__be32 length_of_error;
+	__be32 ioa_data[236];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_type_02_error {
 	struct ipr_vpd ioa_vpd;
 	struct ipr_vpd cfc_vpd;
@@ -1128,6 +1140,7 @@ struct ipr_hostrcb64_error {
 		struct ipr_hostrcb_type_ff_error type_ff_error;
 		struct ipr_hostrcb_type_12_error type_12_error;
 		struct ipr_hostrcb_type_17_error type_17_error;
+		struct ipr_hostrcb_type_21_error type_21_error;
 		struct ipr_hostrcb_type_23_error type_23_error;
 		struct ipr_hostrcb_type_24_error type_24_error;
 		struct ipr_hostrcb_type_30_error type_30_error;
@@ -1171,6 +1184,7 @@ struct ipr_hcam {
 #define IPR_HOST_RCB_OVERLAY_ID_16				0x16
 #define IPR_HOST_RCB_OVERLAY_ID_17				0x17
 #define IPR_HOST_RCB_OVERLAY_ID_20				0x20
+#define IPR_HOST_RCB_OVERLAY_ID_21				0x21
 #define IPR_HOST_RCB_OVERLAY_ID_23				0x23
 #define IPR_HOST_RCB_OVERLAY_ID_24				0x24
 #define IPR_HOST_RCB_OVERLAY_ID_26				0x26

-- 
