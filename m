From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert 53c700 driver to use change_queue_depth API
Date: Sat, 11 Dec 2004 18:54:07 -0600
Message-ID: <1102812847.5232.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8650 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262043AbULLAyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 19:54:14 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id iBC0sDp29221
	for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2004 19:54:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

rather than using an attribute override.

James

===== drivers/scsi/53c700.c 1.58 vs edited =====
--- 1.58/drivers/scsi/53c700.c	2004-10-20 19:41:52 -05:00
+++ edited/drivers/scsi/53c700.c	2004-12-11 17:48:57 -06:00
@@ -176,6 +176,7 @@
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
+static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
 
@@ -338,6 +339,7 @@
 	tpnt->use_clustering = ENABLE_CLUSTERING;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
+	tpnt->change_queue_depth = NCR_700_change_queue_depth;
 	
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
@@ -2102,18 +2104,14 @@
 	/* to do here: deallocate memory */
 }
 
-static ssize_t
-NCR_700_store_queue_depth(struct device *dev, const char *buf, size_t count)
+static int
+NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
 {
-	int depth;
-
-	struct scsi_device *SDp = to_scsi_device(dev);
-	depth = simple_strtoul(buf, NULL, 0);
 	if(depth > NCR_700_MAX_TAGS)
-		return -EINVAL;
+		depth = NCR_700_MAX_TAGS;
 	scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, depth);
 
-	return count;
+	return depth;
 }
 
 static ssize_t
@@ -2124,14 +2122,6 @@
 	return snprintf(buf, 20, "%d\n", NCR_700_get_depth(SDp));
 }
 
-static struct device_attribute NCR_700_queue_depth_attr = {
-	.attr = {
-		.name = 	"queue_depth",
-		.mode =		S_IWUSR,
-	},
-	.store = NCR_700_store_queue_depth,
-};
-
 static struct device_attribute NCR_700_active_tags_attr = {
 	.attr = {
 		.name =		"active_tags",
@@ -2141,7 +2131,6 @@
 };
 
 STATIC struct device_attribute *NCR_700_dev_attrs[] = {
-	&NCR_700_queue_depth_attr,
 	&NCR_700_active_tags_attr,
 	NULL,
 };


