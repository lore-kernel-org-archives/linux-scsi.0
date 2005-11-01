From: brking@us.ibm.com
Subject: [PATCH 14/26] ipr: Provide reset_adapter retry method for offlined adapters
Date: Tue, 01 Nov 2005 17:01:40 -0600
Message-ID: <200511012301.jA1N1f4a031918@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47572 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751410AbVKAXBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:01:42 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1gWM030150
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:42 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N1g5c121918
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:42 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1fYP031936
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


If an ipr adapter repeatedly fails its initialization
the ipr driver will take the adapter offline and never talk
to it again. This provides a method for the user to manually
try the initialization again through sysfs.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_bring_back_online drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_bring_back_online	2005-10-31 21:53:17.477131432 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:17.529123528 -0600
@@ -2180,6 +2180,74 @@ static struct class_device_attribute ipr
 };
 
 /**
+ * ipr_show_adapter_state - Show the adapter's state
+ * @class_dev:	class device struct
+ * @buf:		buffer
+ *
+ * Return value:
+ * 	number of bytes printed to buffer
+ **/
+static ssize_t ipr_show_adapter_state(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	unsigned long lock_flags = 0;
+	int len;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	if (ioa_cfg->ioa_is_dead)
+		len = snprintf(buf, PAGE_SIZE, "offline\n");
+	else
+		len = snprintf(buf, PAGE_SIZE, "online\n");
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return len;
+}
+
+/**
+ * ipr_store_adapter_state - Change adapter state
+ * @class_dev:	class_device struct
+ * @buf:		buffer
+ * @count:		buffer size
+ *
+ * This function will change the adapter's state.
+ *
+ * Return value:
+ * 	count on success / other on failure
+ **/
+static ssize_t ipr_store_adapter_state(struct class_device *class_dev,
+				       const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	unsigned long lock_flags;
+	int result = count;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	if (ioa_cfg->ioa_is_dead && !strncmp(buf, "online", 6)) {
+		ioa_cfg->ioa_is_dead = 0;
+		ioa_cfg->reset_retries = 0;
+		ioa_cfg->in_ioa_bringdown = 0;
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+	}
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+
+	return result;
+}
+
+static struct class_device_attribute ipr_ioa_state_attr = {
+	.attr = {
+		.name =		"state",
+		.mode =		S_IRUGO | S_IWUSR,
+	},
+	.show = ipr_show_adapter_state,
+	.store = ipr_store_adapter_state
+};
+
+/**
  * ipr_store_reset_adapter - Reset the adapter
  * @class_dev:	class_device struct
  * @buf:		buffer
@@ -2515,6 +2583,7 @@ static struct class_device_attribute *ip
 	&ipr_fw_version_attr,
 	&ipr_log_level_attr,
 	&ipr_diagnostics_attr,
+	&ipr_ioa_state_attr,
 	&ipr_ioa_reset_attr,
 	&ipr_update_fw_attr,
 	&ipr_ioa_cache_attr,
_
