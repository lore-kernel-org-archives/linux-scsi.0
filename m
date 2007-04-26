From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 8/8] ipr: Enable multi-initator RAID support
Date: Thu, 26 Apr 2007 16:00:16 -0500
Message-ID: <200704262101.l3QL1Rek004656@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40342 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbXDZVB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 17:01:29 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QL1Snf026588
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:28 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1T2x542624
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:29 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1Sfh004680
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Enables multi-initiator support on ipr RAID adapters that support it.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ipr.h |   26 +++++++++
 2 files changed, 159 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_enable_dual_adapters drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_enable_dual_adapters	2007-04-26 09:39:00.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-04-26 09:39:00.000000000 -0500
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.3.2"
-#define IPR_DRIVER_DATE "(March 23, 2007)"
+#define IPR_DRIVER_VERSION "2.4.0"
+#define IPR_DRIVER_DATE "(April 24, 2007)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -180,6 +180,7 @@
 #define IPR_SHUTDOWN_TIMEOUT			(ipr_fastfail ? 60 * HZ : 10 * 60 * HZ)
 #define IPR_VSET_RW_TIMEOUT			(ipr_fastfail ? 30 * HZ : 2 * 60 * HZ)
 #define IPR_ABBREV_SHUTDOWN_TIMEOUT		(10 * HZ)
+#define IPR_DUAL_IOA_ABBR_SHUTDOWN_TO	(2 * 60 * HZ)
 #define IPR_DEVICE_RESET_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_CANCEL_ALL_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
 #define IPR_ABORT_TASK_TIMEOUT		(ipr_fastfail ? 10 * HZ : 30 * HZ)
@@ -603,6 +604,12 @@ struct ipr_mode_page28 {
 	struct ipr_dev_bus_entry bus[0];
 }__attribute__((packed));
 
+struct ipr_mode_page24 {
+	struct ipr_mode_page_hdr hdr;
+	u8 flags;
+#define IPR_ENABLE_DUAL_IOA_AF 0x80
+}__attribute__((packed));
+
 struct ipr_ioa_vpd {
 	struct ipr_std_inq_data std_inq_data;
 	u8 ascii_part_num[12];
@@ -625,6 +632,19 @@ struct ipr_inquiry_page3 {
 	u8 patch_number[4];
 }__attribute__((packed));
 
+struct ipr_inquiry_cap {
+	u8 peri_qual_dev_type;
+	u8 page_code;
+	u8 reserved1;
+	u8 page_length;
+	u8 ascii_len;
+	u8 reserved2;
+	u8 sis_version[2];
+	u8 cap;
+#define IPR_CAP_DUAL_IOA_RAID		0x80
+	u8 reserved3[15];
+}__attribute__((packed));
+
 #define IPR_INQUIRY_PAGE0_ENTRIES 20
 struct ipr_inquiry_page0 {
 	u8 peri_qual_dev_type;
@@ -963,6 +983,7 @@ struct ipr_misc_cbs {
 	struct ipr_ioa_vpd ioa_vpd;
 	struct ipr_inquiry_page0 page0_data;
 	struct ipr_inquiry_page3 page3_data;
+	struct ipr_inquiry_cap cap;
 	struct ipr_mode_pages mode_pages;
 	struct ipr_supported_device supp_dev;
 };
@@ -1069,6 +1090,7 @@ struct ipr_ioa_cfg {
 	u8 allow_cmds:1;
 	u8 allow_ml_add_del:1;
 	u8 needs_hard_reset:1;
+	u8 dual_raid:1;
 
 	enum ipr_cache_state cache_state;
 	u16 type; /* CCIN of the card */
diff -puN drivers/scsi/ipr.c~ipr_enable_dual_adapters drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_enable_dual_adapters	2007-04-26 09:39:00.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:39:00.000000000 -0500
@@ -92,6 +92,7 @@ static unsigned int ipr_fastfail = 0;
 static unsigned int ipr_transop_timeout = 0;
 static unsigned int ipr_enable_cache = 1;
 static unsigned int ipr_debug = 0;
+static unsigned int ipr_dual_ioa_raid = 1;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -158,6 +159,8 @@ module_param_named(enable_cache, ipr_ena
 MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
 module_param_named(debug, ipr_debug, int, 0);
 MODULE_PARM_DESC(debug, "Enable device driver debugging logging. Set to 1 to enable. (default: 0)");
+module_param_named(dual_ioa_raid, ipr_dual_ioa_raid, int, 0);
+MODULE_PARM_DESC(dual_ioa_raid, "Enable dual adapter RAID support. Set to 1 to enable. (default: 1)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -5888,6 +5891,94 @@ static int ipr_ioafp_mode_sense_page28(s
 }
 
 /**
+ * ipr_ioafp_mode_select_page24 - Issue Mode Select to IOA
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function enables dual IOA RAID support if possible.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_RETURN
+ **/
+static int ipr_ioafp_mode_select_page24(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ipr_mode_pages *mode_pages = &ioa_cfg->vpd_cbs->mode_pages;
+	struct ipr_mode_page24 *mode_page;
+	int length;
+
+	ENTER;
+	mode_page = ipr_get_mode_page(mode_pages, 0x24,
+				      sizeof(struct ipr_mode_page24));
+
+	if (mode_page)
+		mode_page->flags |= IPR_ENABLE_DUAL_IOA_AF;
+
+	length = mode_pages->hdr.length + 1;
+	mode_pages->hdr.length = 0;
+
+	ipr_build_mode_select(ipr_cmd, cpu_to_be32(IPR_IOA_RES_HANDLE), 0x11,
+			      ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, mode_pages),
+			      length);
+
+	ipr_cmd->job_step = ipr_ioafp_mode_sense_page28;
+	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
+
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
+ * ipr_reset_mode_sense_page24_failed - Handle failure of IOAFP mode sense
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function handles the failure of a Mode Sense to the IOAFP.
+ * Some adapters do not handle all mode pages.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_mode_sense_page24_failed(struct ipr_cmnd *ipr_cmd)
+{
+	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+
+	if (ioasc == IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT) {
+		ipr_cmd->job_step = ipr_ioafp_mode_sense_page28;
+		return IPR_RC_JOB_CONTINUE;
+	}
+
+	return ipr_reset_cmd_failed(ipr_cmd);
+}
+
+/**
+ * ipr_ioafp_mode_sense_page24 - Issue Page 24 Mode Sense to IOA
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function send a mode sense to the IOA to retrieve
+ * the IOA Advanced Function Control mode page.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_RETURN
+ **/
+static int ipr_ioafp_mode_sense_page24(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	ENTER;
+	ipr_build_mode_sense(ipr_cmd, cpu_to_be32(IPR_IOA_RES_HANDLE),
+			     0x24, ioa_cfg->vpd_cbs_dma +
+			     offsetof(struct ipr_misc_cbs, mode_pages),
+			     sizeof(struct ipr_mode_pages));
+
+	ipr_cmd->job_step = ipr_ioafp_mode_select_page24;
+	ipr_cmd->job_step_failed = ipr_reset_mode_sense_page24_failed;
+
+	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
+
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
  * ipr_init_res_table - Initialize the resource table
  * @ipr_cmd:	ipr command struct
  *
@@ -5955,7 +6046,10 @@ static int ipr_init_res_table(struct ipr
 		}
 	}
 
-	ipr_cmd->job_step = ipr_ioafp_mode_sense_page28;
+	if (ioa_cfg->dual_raid && ipr_dual_ioa_raid)
+		ipr_cmd->job_step = ipr_ioafp_mode_sense_page24;
+	else
+		ipr_cmd->job_step = ipr_ioafp_mode_sense_page28;
 
 	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
@@ -5977,8 +6071,11 @@ static int ipr_ioafp_query_ioa_cfg(struc
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 	struct ipr_inquiry_page3 *ucode_vpd = &ioa_cfg->vpd_cbs->page3_data;
+	struct ipr_inquiry_cap *cap = &ioa_cfg->vpd_cbs->cap;
 
 	ENTER;
+	if (cap->cap & IPR_CAP_DUAL_IOA_RAID)
+		ioa_cfg->dual_raid = 1;
 	dev_info(&ioa_cfg->pdev->dev, "Adapter firmware version: %02X%02X%02X%02X\n",
 		 ucode_vpd->major_release, ucode_vpd->card_type,
 		 ucode_vpd->minor_release[0], ucode_vpd->minor_release[1]);
@@ -6062,6 +6159,37 @@ static int ipr_inquiry_page_supported(st
 }
 
 /**
+ * ipr_ioafp_cap_inquiry - Send a Page 0xD0 Inquiry to the adapter.
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function sends a Page 0xD0 inquiry to the adapter
+ * to retrieve adapter capabilities.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_ioafp_cap_inquiry(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;
+	struct ipr_inquiry_cap *cap = &ioa_cfg->vpd_cbs->cap;
+
+	ENTER;
+	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+	memset(cap, 0, sizeof(*cap));
+
+	if (ipr_inquiry_page_supported(page0, 0xD0)) {
+		ipr_ioafp_inquiry(ipr_cmd, 1, 0xD0,
+				  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, cap),
+				  sizeof(struct ipr_inquiry_cap));
+		return IPR_RC_JOB_RETURN;
+	}
+
+	LEAVE;
+	return IPR_RC_JOB_CONTINUE;
+}
+
+/**
  * ipr_ioafp_page3_inquiry - Send a Page 3 Inquiry to the adapter.
  * @ipr_cmd:	ipr command struct
  *
@@ -6081,7 +6209,7 @@ static int ipr_ioafp_page3_inquiry(struc
 	if (!ipr_inquiry_page_supported(page0, 1))
 		ioa_cfg->cache_state = CACHE_NONE;
 
-	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+	ipr_cmd->job_step = ipr_ioafp_cap_inquiry;
 
 	ipr_ioafp_inquiry(ipr_cmd, 1, 3,
 			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, page3_data),
@@ -6685,12 +6813,14 @@ static int ipr_reset_shutdown_ioa(struct
 		ipr_cmd->ioarcb.cmd_pkt.cdb[0] = IPR_IOA_SHUTDOWN;
 		ipr_cmd->ioarcb.cmd_pkt.cdb[1] = shutdown_type;
 
-		if (shutdown_type == IPR_SHUTDOWN_ABBREV)
-			timeout = IPR_ABBREV_SHUTDOWN_TIMEOUT;
+		if (shutdown_type == IPR_SHUTDOWN_NORMAL)
+			timeout = IPR_SHUTDOWN_TIMEOUT;
 		else if (shutdown_type == IPR_SHUTDOWN_PREPARE_FOR_NORMAL)
 			timeout = IPR_INTERNAL_TIMEOUT;
+		else if (ioa_cfg->dual_raid && ipr_dual_ioa_raid)
+			timeout = IPR_DUAL_IOA_ABBR_SHUTDOWN_TO;
 		else
-			timeout = IPR_SHUTDOWN_TIMEOUT;
+			timeout = IPR_ABBREV_SHUTDOWN_TIMEOUT;
 
 		ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, timeout);
 
_
