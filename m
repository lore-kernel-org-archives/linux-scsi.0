From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] update 3ware to use change_queue_depth API
Date: Thu, 23 Dec 2004 15:21:18 -0600
Message-ID: <1103836878.5290.51.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:48006 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261298AbULWVV0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 16:21:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Instead of doing an attribute override.

James

===== drivers/scsi/3w-9xxx.c 1.5 vs edited =====
--- 1.5/drivers/scsi/3w-9xxx.c	2004-11-18 15:55:58 -06:00
+++ edited/drivers/scsi/3w-9xxx.c	2004-12-23 15:11:09 -06:00
@@ -155,33 +155,15 @@
 } /* End twa_show_stats() */
 
 /* This function will set a devices queue depth */
-static ssize_t twa_store_queue_depth(struct device *dev, const char *buf, size_t count)
+static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
-	int queue_depth;
-	struct scsi_device *sdev = to_scsi_device(dev);
-
-	queue_depth = simple_strtoul(buf, NULL, 0);
 	if (queue_depth > TW_Q_LENGTH-2)
-		return -EINVAL;
-	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
-
-	return count;
-} /* End twa_store_queue_depth() */
+		queue_depth = TW_Q_LENGTH-2;
 
-/* Create sysfs 'queue_depth' entry */
-static struct device_attribute twa_queue_depth_attr = {
-	.attr = {
-		.name =		"queue_depth",
-		.mode =		S_IRUSR | S_IWUSR,
-	},
-	.store = twa_store_queue_depth
-};
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
 
-/* Device attributes initializer */
-static struct device_attribute *twa_dev_attrs[] = {
-	&twa_queue_depth_attr,
-	NULL,
-};
+	return queue_depth;
+} /* End twa_change_queue_depth() */
 
 /* Create sysfs 'stats' entry */
 static struct class_device_attribute twa_host_stats_attr = {
@@ -1949,6 +1931,7 @@
 	.eh_abort_handler	= twa_scsi_eh_abort,
 	.eh_host_reset_handler	= twa_scsi_eh_reset,
 	.bios_param		= twa_scsi_biosparam,
+	.change_queue_depth	= twa_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
 	.this_id		= -1,
 	.sg_tablesize		= TW_APACHE_MAX_SGL_LENGTH,
@@ -1956,7 +1939,6 @@
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twa_host_attrs,
-	.sdev_attrs		= twa_dev_attrs,
 	.emulated		= 1
 };
 
===== drivers/scsi/3w-xxxx.c 1.48 vs edited =====
--- 1.48/drivers/scsi/3w-xxxx.c	2004-11-18 15:55:31 -06:00
+++ edited/drivers/scsi/3w-xxxx.c	2004-12-23 15:11:03 -06:00
@@ -509,33 +509,15 @@
 } /* End tw_show_stats() */
 
 /* This function will set a devices queue depth */
-static ssize_t tw_store_queue_depth(struct device *dev, const char *buf, size_t count)
+static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
-	int queue_depth;
-	struct scsi_device *sdev = to_scsi_device(dev);
-
-	queue_depth = simple_strtoul(buf, NULL, 0);
 	if (queue_depth > TW_Q_LENGTH-2)
-		return -EINVAL;
-	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
-
-	return count;
-} /* End tw_store_queue_depth() */
+		queue_depth = TW_Q_LENGTH-2;
 
-/* Create sysfs 'queue_depth' entry */
-static struct device_attribute tw_queue_depth_attr = {
-	.attr = {
-		.name =		"queue_depth",
-		.mode =		S_IRUSR | S_IWUSR,
-	},
-	.store = tw_store_queue_depth
-};
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
 
-/* Device attributes initializer */
-static struct device_attribute *tw_dev_attrs[] = {
-	&tw_queue_depth_attr,
-	NULL,
-};
+	return queue_depth;
+} /* End tw_change_queue_depth() */
 
 /* Create sysfs 'stats' entry */
 static struct class_device_attribute tw_host_stats_attr = {
@@ -2304,6 +2286,7 @@
 	.queuecommand		= tw_scsi_queue,
 	.eh_host_reset_handler	= tw_scsi_eh_reset,
 	.bios_param		= tw_scsi_biosparam,
+	.change_queue_depth	= tw_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
 	.this_id		= -1,
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
@@ -2311,7 +2294,6 @@
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= tw_host_attrs,
-	.sdev_attrs		= tw_dev_attrs,
 	.emulated		= 1
 };
 


