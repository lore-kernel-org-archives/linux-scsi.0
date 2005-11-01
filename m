From: brking@us.ibm.com
Subject: [PATCH 10/26] ipr: Write caching state host attribute
Date: Tue, 01 Nov 2005 17:01:14 -0600
Message-ID: <200511012301.jA1N1Ekm024185@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:55756 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751406AbVKAXBQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:01:16 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1FeI026960
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:15 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N1FXg189692
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:15 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1FVn024202
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds a scsi_host sysfs attribute and module parm to enable/disable
the write cache on an ipr adapter.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |  201 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ipr.h |   18 ++++
 2 files changed, 210 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_caching_host_attr drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_caching_host_attr	2005-10-31 21:53:07.826598536 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:07.875591088 -0600
@@ -91,6 +91,7 @@ static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
 static unsigned int ipr_fastfail = 0;
 static unsigned int ipr_transop_timeout = IPR_OPERATIONAL_TIMEOUT;
+static unsigned int ipr_enable_cache = 1;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -150,6 +151,8 @@ module_param_named(fastfail, ipr_fastfai
 MODULE_PARM_DESC(fastfail, "Reduce timeouts and retries");
 module_param_named(transop_timeout, ipr_transop_timeout, int, 0);
 MODULE_PARM_DESC(transop_timeout, "Time in seconds to wait for adapter to come operational (default: 300)");
+module_param_named(enable_cache, ipr_enable_cache, int, 0);
+MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
@@ -1937,6 +1940,103 @@ static struct bin_attribute ipr_trace_at
 };
 #endif
 
+static const struct {
+	enum ipr_cache_state state;
+	char *name;
+} cache_state [] = {
+	{ CACHE_NONE, "none" },
+	{ CACHE_DISABLED, "disabled" },
+	{ CACHE_ENABLED, "enabled" }
+};
+
+/**
+ * ipr_show_write_caching - Show the write caching attribute
+ * @class_dev:	class device struct
+ * @buf:		buffer
+ *
+ * Return value:
+ *	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_write_caching(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	unsigned long lock_flags = 0;
+	int i, len = 0;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	for (i = 0; i < ARRAY_SIZE(cache_state); i++) {
+		if (cache_state[i].state == ioa_cfg->cache_state) {
+			len = snprintf(buf, PAGE_SIZE, "%s\n", cache_state[i].name);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return len;
+}
+
+
+/**
+ * ipr_store_write_caching - Enable/disable adapter write cache
+ * @class_dev:	class_device struct
+ * @buf:		buffer
+ * @count:		buffer size
+ *
+ * This function will enable/disable adapter write cache.
+ *
+ * Return value:
+ * 	count on success / other on failure
+ **/
+static ssize_t ipr_store_write_caching(struct class_device *class_dev,
+					const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	unsigned long lock_flags = 0;
+	enum ipr_cache_state new_state = CACHE_INVALID;
+	int i;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	if (ioa_cfg->cache_state == CACHE_NONE)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(cache_state); i++) {
+		if (!strncmp(cache_state[i].name, buf, strlen(cache_state[i].name))) {
+			new_state = cache_state[i].state;
+			break;
+		}
+	}
+
+	if (new_state != CACHE_DISABLED && new_state != CACHE_ENABLED)
+		return -EINVAL;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	if (ioa_cfg->cache_state == new_state) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return count;
+	}
+
+	ioa_cfg->cache_state = new_state;
+	dev_info(&ioa_cfg->pdev->dev, "%s adapter write cache.\n",
+		 new_state == CACHE_ENABLED ? "Enabling" : "Disabling");
+	if (!ioa_cfg->in_reset_reload)
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+
+	return count;
+}
+
+static struct class_device_attribute ipr_ioa_cache_attr = {
+	.attr = {
+		.name =		"write_cache",
+		.mode =		S_IRUGO | S_IWUSR,
+	},
+	.show = ipr_show_write_caching,
+	.store = ipr_store_write_caching
+};
+
 /**
  * ipr_show_fw_version - Show the firmware version
  * @class_dev:	class device struct
@@ -2406,6 +2506,7 @@ static struct class_device_attribute *ip
 	&ipr_diagnostics_attr,
 	&ipr_ioa_reset_attr,
 	&ipr_update_fw_attr,
+	&ipr_ioa_cache_attr,
 	NULL,
 };
 
@@ -4148,6 +4249,36 @@ static int ipr_set_supported_devs(struct
 }
 
 /**
+ * ipr_setup_write_cache - Disable write cache if needed
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function sets up adapters write cache to desired setting
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_setup_write_cache(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	ipr_cmd->job_step = ipr_set_supported_devs;
+	ipr_cmd->u.res = list_entry(ioa_cfg->used_res_q.next,
+				    struct ipr_resource_entry, queue);
+
+	if (ioa_cfg->cache_state != CACHE_DISABLED)
+		return IPR_RC_JOB_CONTINUE;
+
+	ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
+	ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
+	ipr_cmd->ioarcb.cmd_pkt.cdb[0] = IPR_IOA_SHUTDOWN;
+	ipr_cmd->ioarcb.cmd_pkt.cdb[1] = IPR_SHUTDOWN_PREPARE_FOR_NORMAL;
+
+	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
+
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
  * ipr_get_mode_page - Locate specified mode page
  * @mode_pages:	mode page buffer
  * @page_code:	page code to find
@@ -4358,10 +4489,7 @@ static int ipr_ioafp_mode_select_page28(
 			      ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, mode_pages),
 			      length);
 
-	ipr_cmd->job_step = ipr_set_supported_devs;
-	ipr_cmd->u.res = list_entry(ioa_cfg->used_res_q.next,
-				    struct ipr_resource_entry, queue);
-
+	ipr_cmd->job_step = ipr_setup_write_cache;
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
 	LEAVE;
@@ -4581,6 +4709,27 @@ static void ipr_ioafp_inquiry(struct ipr
 }
 
 /**
+ * ipr_inquiry_page_supported - Is the given inquiry page supported
+ * @page0:		inquiry page 0 buffer
+ * @page:		page code.
+ *
+ * This function determines if the specified inquiry page is supported.
+ *
+ * Return value:
+ *	1 if page is supported / 0 if not
+ **/
+static int ipr_inquiry_page_supported(struct ipr_inquiry_page0 *page0, u8 page)
+{
+	int i;
+
+	for (i = 0; i < min_t(u8, page0->len, IPR_INQUIRY_PAGE0_ENTRIES); i++)
+		if (page0->page[i] == page)
+			return 1;
+
+	return 0;
+}
+
+/**
  * ipr_ioafp_page3_inquiry - Send a Page 3 Inquiry to the adapter.
  * @ipr_cmd:	ipr command struct
  *
@@ -4593,6 +4742,36 @@ static void ipr_ioafp_inquiry(struct ipr
 static int ipr_ioafp_page3_inquiry(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;
+
+	ENTER;
+
+	if (!ipr_inquiry_page_supported(page0, 1))
+		ioa_cfg->cache_state = CACHE_NONE;
+
+	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+
+	ipr_ioafp_inquiry(ipr_cmd, 1, 3,
+			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, page3_data),
+			  sizeof(struct ipr_inquiry_page3));
+
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
+ * ipr_ioafp_page0_inquiry - Send a Page 0 Inquiry to the adapter.
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function sends a Page 0 inquiry to the adapter
+ * to retrieve supported inquiry pages.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_ioafp_page0_inquiry(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	char type[5];
 
 	ENTER;
@@ -4602,11 +4781,11 @@ static int ipr_ioafp_page3_inquiry(struc
 	type[4] = '\0';
 	ioa_cfg->type = simple_strtoul((char *)type, NULL, 16);
 
-	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
+	ipr_cmd->job_step = ipr_ioafp_page3_inquiry;
 
-	ipr_ioafp_inquiry(ipr_cmd, 1, 3,
-			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, page3_data),
-			  sizeof(struct ipr_inquiry_page3));
+	ipr_ioafp_inquiry(ipr_cmd, 1, 0,
+			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, page0_data),
+			  sizeof(struct ipr_inquiry_page0));
 
 	LEAVE;
 	return IPR_RC_JOB_RETURN;
@@ -4626,7 +4805,7 @@ static int ipr_ioafp_std_inquiry(struct 
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
 	ENTER;
-	ipr_cmd->job_step = ipr_ioafp_page3_inquiry;
+	ipr_cmd->job_step = ipr_ioafp_page0_inquiry;
 
 	ipr_ioafp_inquiry(ipr_cmd, 0, 0,
 			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, ioa_vpd),
@@ -5629,6 +5808,10 @@ static void __devinit ipr_init_ioa_cfg(s
 	INIT_WORK(&ioa_cfg->work_q, ipr_worker_thread, ioa_cfg);
 	init_waitqueue_head(&ioa_cfg->reset_wait_q);
 	ioa_cfg->sdt_state = INACTIVE;
+	if (ipr_enable_cache)
+		ioa_cfg->cache_state = CACHE_ENABLED;
+	else
+		ioa_cfg->cache_state = CACHE_DISABLED;
 
 	ipr_initialize_bus_attr(ioa_cfg);
 
diff -puN drivers/scsi/ipr.h~ipr_caching_host_attr drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_caching_host_attr	2005-10-31 21:53:07.829598080 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-31 21:53:07.877590784 -0600
@@ -541,6 +541,15 @@ struct ipr_inquiry_page3 {
 	u8 patch_number[4];
 }__attribute__((packed));
 
+#define IPR_INQUIRY_PAGE0_ENTRIES 20
+struct ipr_inquiry_page0 {
+	u8 peri_qual_dev_type;
+	u8 page_code;
+	u8 reserved1;
+	u8 len;
+	u8 page[IPR_INQUIRY_PAGE0_ENTRIES];
+}__attribute__((packed));
+
 struct ipr_hostrcb_device_data_entry {
 	struct ipr_vpd vpd;
 	struct ipr_res_addr dev_res_addr;
@@ -731,6 +740,7 @@ struct ipr_resource_table {
 
 struct ipr_misc_cbs {
 	struct ipr_ioa_vpd ioa_vpd;
+	struct ipr_inquiry_page0 page0_data;
 	struct ipr_inquiry_page3 page3_data;
 	struct ipr_mode_pages mode_pages;
 	struct ipr_supported_device supp_dev;
@@ -813,6 +823,13 @@ enum ipr_sdt_state {
 	DUMP_OBTAINED
 };
 
+enum ipr_cache_state {
+	CACHE_NONE,
+	CACHE_DISABLED,
+	CACHE_ENABLED,
+	CACHE_INVALID
+};
+
 /* Per-controller data */
 struct ipr_ioa_cfg {
 	char eye_catcher[8];
@@ -829,6 +846,7 @@ struct ipr_ioa_cfg {
 	u8 allow_cmds:1;
 	u8 allow_ml_add_del:1;
 
+	enum ipr_cache_state cache_state;
 	u16 type; /* CCIN of the card */
 
 	u8 log_level;
_
