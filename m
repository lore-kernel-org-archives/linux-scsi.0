From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] update ipr to use the change_queue_depth API
Date: Thu, 23 Dec 2004 15:19:32 -0600
Message-ID: <1103836773.5290.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62093 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261305AbULWV1O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 16:27:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Instead of doing an attribute override.

James

===== drivers/scsi/ipr.c 1.31 vs edited =====
--- 1.31/drivers/scsi/ipr.c	2004-12-14 17:06:35 -06:00
+++ edited/drivers/scsi/ipr.c	2004-12-23 15:15:01 -06:00
@@ -2610,23 +2610,19 @@
 #endif
 
 /**
- * ipr_store_queue_depth - Change the device's queue depth
- * @dev:	device struct
- * @buf:	buffer
+ * ipr_change_queue_depth - Change the device's queue depth
+ * @dsev:	scsi device struct
+ * @qdepth:	depth to set
  *
  * Return value:
- * 	number of bytes printed to buffer
+ * 	actual depth set
  **/
-static ssize_t ipr_store_queue_depth(struct device *dev,
-				    const char *buf, size_t count)
+static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
 	struct ipr_resource_entry *res;
-	int qdepth = simple_strtoul(buf, NULL, 10);
 	int tagged = 0;
 	unsigned long lock_flags = 0;
-	ssize_t len = -ENXIO;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
@@ -2635,23 +2631,13 @@
 
 		if (ipr_is_gscsi(res) && res->tcq_active)
 			tagged = MSG_ORDERED_TAG;
-
-		len = strlen(buf);
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	scsi_adjust_queue_depth(sdev, tagged, qdepth);
-	return len;
+	return qdepth;
 }
 
-static struct device_attribute ipr_queue_depth_attr = {
-	.attr = {
-		.name = 	"queue_depth",
-		.mode =		S_IRUSR | S_IWUSR,
-	},
-	.store = ipr_store_queue_depth
-};
-
 /**
  * ipr_show_tcq_enable - Show if the device is enabled for tcqing
  * @dev:	device struct
@@ -2760,7 +2746,6 @@
 };
 
 static struct device_attribute *ipr_dev_attrs[] = {
-	&ipr_queue_depth_attr,
 	&ipr_tcqing_attr,
 	&ipr_adapter_handle_attr,
 	NULL,
@@ -3961,6 +3946,7 @@
 	.slave_alloc = ipr_slave_alloc,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
+	.change_queue_depth = ipr_change_queue_depth,
 	.bios_param = ipr_biosparam,
 	.can_queue = IPR_MAX_COMMANDS,
 	.this_id = -1,


