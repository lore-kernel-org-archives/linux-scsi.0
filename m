From: brking@us.ibm.com
Subject: [PATCH 19/26] ipr: New adapter error types
Date: Tue, 01 Nov 2005 17:02:15 -0600
Message-ID: <200511012302.jA1N2FHZ022706@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58823 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751415AbVKAXCR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:02:17 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2Hig001951
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:17 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2HXg538078
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:17 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2G8O022738
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:02:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Handle some new types of ipr errors that can be returned by the adapter.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |  175 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ipr.h |   67 +++++++++++++++++++-
 2 files changed, 241 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_new_error_types drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_new_error_types	2005-10-31 21:53:34.941476448 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-31 21:53:34.998467784 -0600
@@ -254,6 +254,11 @@ struct ipr_vpd {
 	u8 sn[IPR_SERIAL_NUM_LEN];
 }__attribute__((packed));
 
+struct ipr_ext_vpd {
+	struct ipr_vpd vpd;
+	__be32 wwid[2];
+}__attribute__((packed));
+
 struct ipr_std_inq_data {
 	u8 peri_qual_dev_type;
 #define IPR_STD_INQ_PERI_QUAL(peri) ((peri) >> 5)
@@ -553,14 +558,31 @@ struct ipr_hostrcb_device_data_entry {
 	__be32 ioa_data[5];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_device_data_entry_enhanced {
+	struct ipr_ext_vpd vpd;
+	u8 ccin[4];
+	struct ipr_res_addr dev_res_addr;
+	struct ipr_ext_vpd new_vpd;
+	u8 new_ccin[4];
+	struct ipr_ext_vpd ioa_last_with_dev_vpd;
+	struct ipr_ext_vpd cfc_last_with_dev_vpd;
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_array_data_entry {
 	struct ipr_vpd vpd;
 	struct ipr_res_addr expected_dev_res_addr;
 	struct ipr_res_addr dev_res_addr;
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_array_data_entry_enhanced {
+	struct ipr_ext_vpd vpd;
+	u8 ccin[4];
+	struct ipr_res_addr expected_dev_res_addr;
+	struct ipr_res_addr dev_res_addr;
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_type_ff_error {
-	__be32 ioa_data[246];
+	__be32 ioa_data[502];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_01_error {
@@ -578,6 +600,14 @@ struct ipr_hostrcb_type_02_error {
 	__be32 ioa_data[3];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_type_12_error {
+	struct ipr_ext_vpd ioa_vpd;
+	struct ipr_ext_vpd cfc_vpd;
+	struct ipr_ext_vpd ioa_last_attached_to_cfc_vpd;
+	struct ipr_ext_vpd cfc_last_attached_to_ioa_vpd;
+	__be32 ioa_data[3];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_type_03_error {
 	struct ipr_vpd ioa_vpd;
 	struct ipr_vpd cfc_vpd;
@@ -587,6 +617,14 @@ struct ipr_hostrcb_type_03_error {
 	struct ipr_hostrcb_device_data_entry dev[3];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_type_13_error {
+	struct ipr_ext_vpd ioa_vpd;
+	struct ipr_ext_vpd cfc_vpd;
+	__be32 errors_detected;
+	__be32 errors_logged;
+	struct ipr_hostrcb_device_data_entry_enhanced dev[3];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_type_04_error {
 	struct ipr_vpd ioa_vpd;
 	struct ipr_vpd cfc_vpd;
@@ -602,12 +640,30 @@ struct ipr_hostrcb_type_04_error {
 	u8 protection_level[8];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_type_14_error {
+	struct ipr_ext_vpd ioa_vpd;
+	struct ipr_ext_vpd cfc_vpd;
+	__be32 exposed_mode_adn;
+	__be32 array_id;
+	struct ipr_res_addr last_func_vset_res_addr;
+	u8 vset_serial_num[IPR_SERIAL_NUM_LEN];
+	u8 protection_level[8];
+	__be32 num_entries;
+	struct ipr_hostrcb_array_data_entry_enhanced array_member[18];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_type_07_error {
 	u8 failure_reason[64];
 	struct ipr_vpd vpd;
 	u32 data[222];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_type_17_error {
+	u8 failure_reason[64];
+	struct ipr_ext_vpd vpd;
+	u32 data[476];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_error {
 	__be32 failing_dev_ioasc;
 	struct ipr_res_addr failing_dev_res_addr;
@@ -620,6 +676,10 @@ struct ipr_hostrcb_error {
 		struct ipr_hostrcb_type_03_error type_03_error;
 		struct ipr_hostrcb_type_04_error type_04_error;
 		struct ipr_hostrcb_type_07_error type_07_error;
+		struct ipr_hostrcb_type_12_error type_12_error;
+		struct ipr_hostrcb_type_13_error type_13_error;
+		struct ipr_hostrcb_type_14_error type_14_error;
+		struct ipr_hostrcb_type_17_error type_17_error;
 	} u;
 }__attribute__((packed, aligned (4)));
 
@@ -654,6 +714,11 @@ struct ipr_hcam {
 #define IPR_HOST_RCB_OVERLAY_ID_4				0x04
 #define IPR_HOST_RCB_OVERLAY_ID_6				0x06
 #define IPR_HOST_RCB_OVERLAY_ID_7				0x07
+#define IPR_HOST_RCB_OVERLAY_ID_12				0x12
+#define IPR_HOST_RCB_OVERLAY_ID_13				0x13
+#define IPR_HOST_RCB_OVERLAY_ID_14				0x14
+#define IPR_HOST_RCB_OVERLAY_ID_16				0x16
+#define IPR_HOST_RCB_OVERLAY_ID_17				0x17
 #define IPR_HOST_RCB_OVERLAY_ID_DEFAULT			0xFF
 
 	u8 reserved1[3];
diff -puN drivers/scsi/ipr.c~ipr_new_error_types drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_new_error_types	2005-10-31 21:53:34.943476144 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:35.003467024 -0600
@@ -936,6 +936,52 @@ static void ipr_log_vpd(struct ipr_vpd *
 }
 
 /**
+ * ipr_log_ext_vpd - Log the passed extended VPD to the error log.
+ * @vpd:		vendor/product id/sn/wwn struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_ext_vpd(struct ipr_ext_vpd *vpd)
+{
+	ipr_log_vpd(&vpd->vpd);
+	ipr_err("    WWN: %08X%08X\n", be32_to_cpu(vpd->wwid[0]),
+		be32_to_cpu(vpd->wwid[1]));
+}
+
+/**
+ * ipr_log_enhanced_cache_error - Log a cache error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_enhanced_cache_error(struct ipr_ioa_cfg *ioa_cfg,
+					 struct ipr_hostrcb *hostrcb)
+{
+	struct ipr_hostrcb_type_12_error *error =
+		&hostrcb->hcam.u.error.u.type_12_error;
+
+	ipr_err("-----Current Configuration-----\n");
+	ipr_err("Cache Directory Card Information:\n");
+	ipr_log_ext_vpd(&error->ioa_vpd);
+	ipr_err("Adapter Card Information:\n");
+	ipr_log_ext_vpd(&error->cfc_vpd);
+
+	ipr_err("-----Expected Configuration-----\n");
+	ipr_err("Cache Directory Card Information:\n");
+	ipr_log_ext_vpd(&error->ioa_last_attached_to_cfc_vpd);
+	ipr_err("Adapter Card Information:\n");
+	ipr_log_ext_vpd(&error->cfc_last_attached_to_ioa_vpd);
+
+	ipr_err("Additional IOA Data: %08X %08X %08X\n",
+		     be32_to_cpu(error->ioa_data[0]),
+		     be32_to_cpu(error->ioa_data[1]),
+		     be32_to_cpu(error->ioa_data[2]));
+}
+
+/**
  * ipr_log_cache_error - Log a cache error.
  * @ioa_cfg:	ioa config struct
  * @hostrcb:	hostrcb struct
@@ -968,6 +1014,46 @@ static void ipr_log_cache_error(struct i
 }
 
 /**
+ * ipr_log_enhanced_config_error - Log a configuration error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_enhanced_config_error(struct ipr_ioa_cfg *ioa_cfg,
+					  struct ipr_hostrcb *hostrcb)
+{
+	int errors_logged, i;
+	struct ipr_hostrcb_device_data_entry_enhanced *dev_entry;
+	struct ipr_hostrcb_type_13_error *error;
+
+	error = &hostrcb->hcam.u.error.u.type_13_error;
+	errors_logged = be32_to_cpu(error->errors_logged);
+
+	ipr_err("Device Errors Detected/Logged: %d/%d\n",
+		be32_to_cpu(error->errors_detected), errors_logged);
+
+	dev_entry = error->dev;
+
+	for (i = 0; i < errors_logged; i++, dev_entry++) {
+		ipr_err_separator;
+
+		ipr_phys_res_err(ioa_cfg, dev_entry->dev_res_addr, "Device %d", i + 1);
+		ipr_log_ext_vpd(&dev_entry->vpd);
+
+		ipr_err("-----New Device Information-----\n");
+		ipr_log_ext_vpd(&dev_entry->new_vpd);
+
+		ipr_err("Cache Directory Card Information:\n");
+		ipr_log_ext_vpd(&dev_entry->ioa_last_with_dev_vpd);
+
+		ipr_err("Adapter Card Information:\n");
+		ipr_log_ext_vpd(&dev_entry->cfc_last_with_dev_vpd);
+	}
+}
+
+/**
  * ipr_log_config_error - Log a configuration error.
  * @ioa_cfg:	ioa config struct
  * @hostrcb:	hostrcb struct
@@ -1015,6 +1101,57 @@ static void ipr_log_config_error(struct 
 }
 
 /**
+ * ipr_log_enhanced_array_error - Log an array configuration error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_enhanced_array_error(struct ipr_ioa_cfg *ioa_cfg,
+					 struct ipr_hostrcb *hostrcb)
+{
+	int i, num_entries;
+	struct ipr_hostrcb_type_14_error *error;
+	struct ipr_hostrcb_array_data_entry_enhanced *array_entry;
+	const u8 zero_sn[IPR_SERIAL_NUM_LEN] = { [0 ... IPR_SERIAL_NUM_LEN-1] = '0' };
+
+	error = &hostrcb->hcam.u.error.u.type_14_error;
+
+	ipr_err_separator;
+
+	ipr_err("RAID %s Array Configuration: %d:%d:%d:%d\n",
+		error->protection_level,
+		ioa_cfg->host->host_no,
+		error->last_func_vset_res_addr.bus,
+		error->last_func_vset_res_addr.target,
+		error->last_func_vset_res_addr.lun);
+
+	ipr_err_separator;
+
+	array_entry = error->array_member;
+	num_entries = min_t(u32, be32_to_cpu(error->num_entries),
+			    sizeof(error->array_member));
+
+	for (i = 0; i < num_entries; i++, array_entry++) {
+		if (!memcmp(array_entry->vpd.vpd.sn, zero_sn, IPR_SERIAL_NUM_LEN))
+			continue;
+
+		if (be32_to_cpu(error->exposed_mode_adn) == i)
+			ipr_err("Exposed Array Member %d:\n", i);
+		else
+			ipr_err("Array Member %d:\n", i);
+
+		ipr_log_ext_vpd(&array_entry->vpd);
+		ipr_phys_res_err(ioa_cfg, array_entry->dev_res_addr, "Current Location");
+		ipr_phys_res_err(ioa_cfg, array_entry->expected_dev_res_addr,
+				 "Expected Location");
+
+		ipr_err_separator;
+	}
+}
+
+/**
  * ipr_log_array_error - Log an array configuration error.
  * @ioa_cfg:	ioa config struct
  * @hostrcb:	hostrcb struct
@@ -1094,6 +1231,31 @@ static void ipr_log_hex_data(u32 *data, 
 }
 
 /**
+ * ipr_log_enhanced_dual_ioa_error - Log an enhanced dual adapter error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_enhanced_dual_ioa_error(struct ipr_ioa_cfg *ioa_cfg,
+					    struct ipr_hostrcb *hostrcb)
+{
+	struct ipr_hostrcb_type_17_error *error;
+
+	error = &hostrcb->hcam.u.error.u.type_17_error;
+	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
+
+	ipr_err("%s\n", error->failure_reason);
+	ipr_err("Remote Adapter VPD:\n");
+	ipr_log_ext_vpd(&error->vpd);
+	ipr_log_hex_data(error->data,
+			 be32_to_cpu(hostrcb->hcam.length) -
+			 (offsetof(struct ipr_hostrcb_error, u) +
+			  offsetof(struct ipr_hostrcb_type_17_error, data)));
+}
+
+/**
  * ipr_log_dual_ioa_error - Log a dual adapter error.
  * @ioa_cfg:	ioa config struct
  * @hostrcb:	hostrcb struct
@@ -1221,6 +1383,19 @@ static void ipr_handle_log_data(struct i
 	case IPR_HOST_RCB_OVERLAY_ID_7:
 		ipr_log_dual_ioa_error(ioa_cfg, hostrcb);
 		break;
+	case IPR_HOST_RCB_OVERLAY_ID_12:
+		ipr_log_enhanced_cache_error(ioa_cfg, hostrcb);
+		break;
+	case IPR_HOST_RCB_OVERLAY_ID_13:
+		ipr_log_enhanced_config_error(ioa_cfg, hostrcb);
+		break;
+	case IPR_HOST_RCB_OVERLAY_ID_14:
+	case IPR_HOST_RCB_OVERLAY_ID_16:
+		ipr_log_enhanced_array_error(ioa_cfg, hostrcb);
+		break;
+	case IPR_HOST_RCB_OVERLAY_ID_17:
+		ipr_log_enhanced_dual_ioa_error(ioa_cfg, hostrcb);
+		break;
 	case IPR_HOST_RCB_OVERLAY_ID_1:
 	case IPR_HOST_RCB_OVERLAY_ID_DEFAULT:
 	default:
_
