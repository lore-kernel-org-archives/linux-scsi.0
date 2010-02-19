From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [patch 6/9] ipr: implement shutdown changes and remove obsolete write
 cache parameter
Date: Fri, 19 Feb 2010 13:24:21 -0800
Message-ID: <4B7F0185.8070808@linux.vnet.ibm.com>
References: <20100219210900.066268168@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33905 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0BSVYY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 16:24:24 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e3.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1JLDZq1023222
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:13:35 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1JLON6h1921038
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:24:23 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1JLOML4024190
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 19:24:22 -0200
In-Reply-To: <20100219210900.066268168@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

This patch adds a reboot notifier that will issue a shutdown prepare command
to all adapters.  This helps to prevent a problem where the primary adapter can
get shut down before the secondary adapter and cause the secondary adapter to
fail over and log and error.
This patch also removes the "enable_cache" paramater as it is obsolete.  Write
cache for an adapter is now controlled from the iprconfig utility.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  208 ++++++++++++++++-------------------------------------
 drivers/scsi/ipr.h |   10 --
 2 files changed, 66 insertions(+), 152 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-02-19 08:08:37.000000000 -0800
+++ b/drivers/scsi/ipr.c	2010-02-19 08:08:40.000000000 -0800
@@ -72,6 +72,7 @@
 #include <linux/moduleparam.h>
 #include <linux/libata.h>
 #include <linux/hdreg.h>
+#include <linux/reboot.h>
 #include <linux/stringify.h>
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -92,7 +93,6 @@ static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
 static unsigned int ipr_fastfail = 0;
 static unsigned int ipr_transop_timeout = 0;
-static unsigned int ipr_enable_cache = 1;
 static unsigned int ipr_debug = 0;
 static unsigned int ipr_max_devs = IPR_DEFAULT_SIS64_DEVS;
 static unsigned int ipr_dual_ioa_raid = 1;
@@ -175,8 +175,6 @@ module_param_named(fastfail, ipr_fastfai
 MODULE_PARM_DESC(fastfail, "Reduce timeouts and retries");
 module_param_named(transop_timeout, ipr_transop_timeout, int, 0);
 MODULE_PARM_DESC(transop_timeout, "Time in seconds to wait for adapter to come operational (default: 300)");
-module_param_named(enable_cache, ipr_enable_cache, int, 0);
-MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
 module_param_named(debug, ipr_debug, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable device driver debugging logging. Set to 1 to enable. (default: 0)");
 module_param_named(dual_ioa_raid, ipr_dual_ioa_raid, int, 0);
@@ -3097,105 +3095,6 @@ static struct bin_attribute ipr_trace_at
 };
 #endif

-static const struct {
-	enum ipr_cache_state state;
-	char *name;
-} cache_state [] = {
-	{ CACHE_NONE, "none" },
-	{ CACHE_DISABLED, "disabled" },
-	{ CACHE_ENABLED, "enabled" }
-};
-
-/**
- * ipr_show_write_caching - Show the write caching attribute
- * @dev:	device struct
- * @buf:	buffer
- *
- * Return value:
- *	number of bytes printed to buffer
- **/
-static ssize_t ipr_show_write_caching(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
-	unsigned long lock_flags = 0;
-	int i, len = 0;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	for (i = 0; i < ARRAY_SIZE(cache_state); i++) {
-		if (cache_state[i].state == ioa_cfg->cache_state) {
-			len = snprintf(buf, PAGE_SIZE, "%s\n", cache_state[i].name);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return len;
-}
-
-
-/**
- * ipr_store_write_caching - Enable/disable adapter write cache
- * @dev:	device struct
- * @buf:	buffer
- * @count:	buffer size
- *
- * This function will enable/disable adapter write cache.
- *
- * Return value:
- * 	count on success / other on failure
- **/
-static ssize_t ipr_store_write_caching(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t count)
-{
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
-	unsigned long lock_flags = 0;
-	enum ipr_cache_state new_state = CACHE_INVALID;
-	int i;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (ioa_cfg->cache_state == CACHE_NONE)
-		return -EINVAL;
-
-	for (i = 0; i < ARRAY_SIZE(cache_state); i++) {
-		if (!strncmp(cache_state[i].name, buf, strlen(cache_state[i].name))) {
-			new_state = cache_state[i].state;
-			break;
-		}
-	}
-
-	if (new_state != CACHE_DISABLED && new_state != CACHE_ENABLED)
-		return -EINVAL;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	if (ioa_cfg->cache_state == new_state) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		return count;
-	}
-
-	ioa_cfg->cache_state = new_state;
-	dev_info(&ioa_cfg->pdev->dev, "%s adapter write cache.\n",
-		 new_state == CACHE_ENABLED ? "Enabling" : "Disabling");
-	if (!ioa_cfg->in_reset_reload)
-		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-
-	return count;
-}
-
-static struct device_attribute ipr_ioa_cache_attr = {
-	.attr = {
-		.name =		"write_cache",
-		.mode =		S_IRUGO | S_IWUSR,
-	},
-	.show = ipr_show_write_caching,
-	.store = ipr_store_write_caching
-};
-
 /**
  * ipr_show_fw_version - Show the firmware version
  * @dev:	class device struct
@@ -3797,7 +3696,6 @@ static struct device_attribute *ipr_ioa_
 	&ipr_ioa_state_attr,
 	&ipr_ioa_reset_attr,
 	&ipr_update_fw_attr,
-	&ipr_ioa_cache_attr,
 	NULL,
 };

@@ -6293,36 +6191,6 @@ static int ipr_set_supported_devs(struct
 }

 /**
- * ipr_setup_write_cache - Disable write cache if needed
- * @ipr_cmd:	ipr command struct
- *
- * This function sets up adapters write cache to desired setting
- *
- * Return value:
- * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
- **/
-static int ipr_setup_write_cache(struct ipr_cmnd *ipr_cmd)
-{
-	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-
-	ipr_cmd->job_step = ipr_set_supported_devs;
-	ipr_cmd->u.res = list_entry(ioa_cfg->used_res_q.next,
-				    struct ipr_resource_entry, queue);
-
-	if (ioa_cfg->cache_state != CACHE_DISABLED)
-		return IPR_RC_JOB_CONTINUE;
-
-	ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
-	ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
-	ipr_cmd->ioarcb.cmd_pkt.cdb[0] = IPR_IOA_SHUTDOWN;
-	ipr_cmd->ioarcb.cmd_pkt.cdb[1] = IPR_SHUTDOWN_PREPARE_FOR_NORMAL;
-
-	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
-
-	return IPR_RC_JOB_RETURN;
-}
-
-/**
  * ipr_get_mode_page - Locate specified mode page
  * @mode_pages:	mode page buffer
  * @page_code:	page code to find
@@ -6522,7 +6390,9 @@ static int ipr_ioafp_mode_select_page28(
 			      ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, mode_pages),
 			      length);

-	ipr_cmd->job_step = ipr_setup_write_cache;
+	ipr_cmd->job_step = ipr_set_supported_devs;
+	ipr_cmd->u.res = list_entry(ioa_cfg->used_res_q.next,
+				    struct ipr_resource_entry, queue);
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);

 	LEAVE;
@@ -6590,10 +6460,13 @@ static int ipr_reset_cmd_failed(struct i
  **/
 static int ipr_reset_mode_sense_failed(struct ipr_cmnd *ipr_cmd)
 {
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);

 	if (ioasc == IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT) {
-		ipr_cmd->job_step = ipr_setup_write_cache;
+		ipr_cmd->job_step = ipr_set_supported_devs;
+		ipr_cmd->u.res = list_entry(ioa_cfg->used_res_q.next,
+					    struct ipr_resource_entry, queue);
 		return IPR_RC_JOB_CONTINUE;
 	}

@@ -6944,13 +6817,9 @@ static int ipr_ioafp_cap_inquiry(struct 
 static int ipr_ioafp_page3_inquiry(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;

 	ENTER;

-	if (!ipr_inquiry_page_supported(page0, 1))
-		ioa_cfg->cache_state = CACHE_NONE;
-
 	ipr_cmd->job_step = ipr_ioafp_cap_inquiry;

 	ipr_ioafp_inquiry(ipr_cmd, 1, 3,
@@ -8209,10 +8078,6 @@ static void __devinit ipr_init_ioa_cfg(s
 	init_waitqueue_head(&ioa_cfg->reset_wait_q);
 	init_waitqueue_head(&ioa_cfg->msi_wait_q);
 	ioa_cfg->sdt_state = INACTIVE;
-	if (ipr_enable_cache)
-		ioa_cfg->cache_state = CACHE_ENABLED;
-	else
-		ioa_cfg->cache_state = CACHE_DISABLED;

 	ipr_initialize_bus_attr(ioa_cfg);
 	ioa_cfg->max_devs_supported = ipr_max_devs;
@@ -8842,6 +8707,61 @@ static struct pci_driver ipr_driver = {
 };

 /**
+ * ipr_halt_done - Shutdown prepare completion
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_halt_done(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+}
+
+/**
+ * ipr_halt - Issue shutdown prepare to all adapters
+ *
+ * Return value:
+ * 	NOTIFY_OK on success / NOTIFY_DONE on failure
+ **/
+static int ipr_halt(struct notifier_block *nb, ulong event, void *buf)
+{
+	struct ipr_cmnd *ipr_cmd;
+	struct ipr_ioa_cfg *ioa_cfg;
+	unsigned long flags = 0;
+
+	if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
+		return NOTIFY_DONE;
+
+	spin_lock(&ipr_driver_lock);
+
+	list_for_each_entry(ioa_cfg, &ipr_ioa_head, queue) {
+		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+		if (!ioa_cfg->allow_cmds) {
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+			continue;
+		}
+
+		ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
+		ipr_cmd->ioarcb.res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
+		ipr_cmd->ioarcb.cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
+		ipr_cmd->ioarcb.cmd_pkt.cdb[0] = IPR_IOA_SHUTDOWN;
+		ipr_cmd->ioarcb.cmd_pkt.cdb[1] = IPR_SHUTDOWN_PREPARE_FOR_NORMAL;
+
+		ipr_do_req(ipr_cmd, ipr_halt_done, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	}
+	spin_unlock(&ipr_driver_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ipr_notifier = {
+	ipr_halt, NULL, 0
+};
+
+/**
  * ipr_init - Module entry point
  *
  * Return value:
@@ -8852,6 +8772,7 @@ static int __init ipr_init(void)
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);

+	register_reboot_notifier(&ipr_notifier);
 	return pci_register_driver(&ipr_driver);
 }

@@ -8865,6 +8786,7 @@ static int __init ipr_init(void)
  **/
 static void __exit ipr_exit(void)
 {
+	unregister_reboot_notifier(&ipr_notifier);
 	pci_unregister_driver(&ipr_driver);
 }

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-02-19 08:08:37.000000000 -0800
+++ b/drivers/scsi/ipr.h	2010-02-19 08:08:40.000000000 -0800
@@ -136,7 +136,7 @@

 /* We need resources for HCAMS, IOA reset, IOA bringdown, and ERP */
 #define IPR_NUM_INTERNAL_CMD_BLKS	(IPR_NUM_HCAMS + \
-                                     ((IPR_NUM_RESET_RELOAD_RETRIES + 1) * 2) + 3)
+                                     ((IPR_NUM_RESET_RELOAD_RETRIES + 1) * 2) + 4)

 #define IPR_MAX_COMMANDS		IPR_NUM_BASE_CMD_BLKS
 #define IPR_NUM_CMD_BLKS		(IPR_NUM_BASE_CMD_BLKS + \
@@ -1284,13 +1284,6 @@ enum ipr_sdt_state {
 	DUMP_OBTAINED
 };

-enum ipr_cache_state {
-	CACHE_NONE,
-	CACHE_DISABLED,
-	CACHE_ENABLED,
-	CACHE_INVALID
-};
-
 /* Per-controller data */
 struct ipr_ioa_cfg {
 	char eye_catcher[8];
@@ -1321,7 +1314,6 @@ struct ipr_ioa_cfg {
 	unsigned long *array_ids;
 	unsigned long *vset_ids;

-	enum ipr_cache_state cache_state;
 	u16 type; /* CCIN of the card */

 	u8 log_level;

