From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add queue_type entry in sysfs
Date: Thu, 23 Dec 2004 12:23:54 -0600
Message-ID: <1103826234.5290.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:43989 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261221AbULWSYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 13:24:01 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id iBNINxF23413
	for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2004 13:23:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This adds an extra attribute to tell you what type of queueing the
driver is using: none, simple or ordered.  If the driver supplies the
change_queue_type API, you can also alter this (which would allow the
turning on or off of TCQ).

I also fixed the change_queue_depth not to allow the user to go below
one.

James

===== drivers/scsi/scsi_sysfs.c 1.62 vs edited =====
--- 1.62/drivers/scsi/scsi_sysfs.c	2004-12-19 13:18:37 -06:00
+++ edited/drivers/scsi/scsi_sysfs.c	2004-12-23 12:15:46 -06:00
@@ -15,6 +15,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 
 #include "scsi_priv.h"
@@ -393,11 +394,28 @@
 
 static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
 
+static ssize_t
+show_queue_type_field(struct device *dev, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const char *name = "none";
+
+	if (sdev->ordered_tags)
+		name = "ordered";
+	else if (sdev->simple_tags)
+		name = "simple";
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+
+static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
+
 
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,
 	&dev_attr_queue_depth,
+	&dev_attr_queue_type,
 	&dev_attr_type,
 	&dev_attr_scsi_level,
 	&dev_attr_vendor,
@@ -421,6 +439,10 @@
 		return -EINVAL;
 
 	depth = simple_strtoul(buf, NULL, 0);
+
+	if (depth < 1)
+		return -EINVAL;
+
 	retval = sht->change_queue_depth(sdev, depth);
 	if (retval < 0)
 		return retval;
@@ -432,6 +454,38 @@
 	__ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
 	       sdev_store_queue_depth_rw);
 
+static ssize_t sdev_store_queue_type_rw(struct device *dev, const char *buf,
+					size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_host_template *sht = sdev->host->hostt;
+	int tag_type = 0, retval;
+	int prev_tag_type = scsi_get_tag_type(sdev);
+
+	if (!sdev->tagged_supported || !sht->change_queue_type)
+		return -EINVAL;
+
+	if (strncmp(buf, "ordered", 7) == 0)
+		tag_type = MSG_ORDERED_TAG;
+	else if (strncmp(buf, "simple", 6) == 0)
+		tag_type = MSG_SIMPLE_TAG;
+	else if (strncmp(buf, "none", 4) != 0)
+		return -EINVAL;
+
+	if (tag_type == prev_tag_type)
+		return count;
+
+	retval = sht->change_queue_type(sdev, tag_type);
+	if (retval < 0)
+		return retval;
+
+	return count;
+}
+
+static struct device_attribute sdev_attr_queue_type_rw =
+	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
+	       sdev_store_queue_type_rw);
+
 static struct device_attribute *attr_changed_internally(
 		struct Scsi_Host *shost,
 		struct device_attribute * attr)
@@ -439,6 +493,9 @@
 	if (!strcmp("queue_depth", attr->attr.name)
 	    && shost->hostt->change_queue_depth)
 		return &sdev_attr_queue_depth_rw;
+	else if (!strcmp("queue_type", attr->attr.name)
+	    && shost->hostt->change_queue_type)
+		return &sdev_attr_queue_type_rw;
 	return attr;
 }
 
===== include/scsi/scsi_host.h 1.23 vs edited =====
--- 1.23/include/scsi/scsi_host.h	2004-12-19 13:18:37 -06:00
+++ edited/include/scsi/scsi_host.h	2004-12-23 10:30:34 -06:00
@@ -228,13 +228,23 @@
 	int (* change_queue_depth)(struct scsi_device *, int);
 
 	/*
+	 * fill in this function to allow the changing of tag types
+	 * (this also allows the enabling/disabling of tag command
+	 * queueing).  An error should only be returned if something
+	 * went wrong in the driver while trying to set the tag type.
+	 * If the driver doesn't support the requested tag type, then
+	 * it should set the closest type it does support without
+	 * returning an error.  Returns the actual tag type set.
+	 */
+	int (* change_queue_type)(struct scsi_device *, int);
+
+	/*
 	 * This function determines the bios parameters for a given
 	 * harddisk.  These tend to be numbers that are made up by
 	 * the host adapter.  Parameters:
 	 * size, device, list (heads, sectors, cylinders)
 	 *
-	 * Status: OPTIONAL
-	 */
+	 * Status: OPTIONAL */
 	int (* bios_param)(struct scsi_device *, struct block_device *,
 			sector_t, int []);
 
===== include/scsi/scsi_tcq.h 1.2 vs edited =====
--- 1.2/include/scsi/scsi_tcq.h	2003-09-16 06:58:31 -05:00
+++ edited/include/scsi/scsi_tcq.h	2004-12-22 16:20:15 -06:00
@@ -13,6 +13,43 @@
 #define SCSI_NO_TAG	(-1)    /* identify no tag in use */
 
 
+
+/**
+ * scsi_get_tag_type - get the type of tag the device supports
+ * @sdev:	the scsi device
+ *
+ * Notes:
+ *	If the drive only supports simple tags, returns MSG_SIMPLE_TAG
+ *	if it supports all tag types, returns MSG_ORDERED_TAG.
+ */
+static inline int scsi_get_tag_type(struct scsi_device *sdev)
+{
+	if (!sdev->tagged_supported)
+		return 0;
+	if (sdev->ordered_tags)
+		return MSG_ORDERED_TAG;
+	if (sdev->simple_tags)
+		return MSG_SIMPLE_TAG;
+	return 0;
+}
+
+static inline void scsi_set_tag_type(struct scsi_device *sdev, int tag)
+{
+	switch (tag) {
+	case MSG_ORDERED_TAG:
+		sdev->ordered_tags = 1;
+		/* fall through */
+	case MSG_SIMPLE_TAG:
+		sdev->simple_tags = 1;
+		break;
+	case 0:
+		/* fall through */
+	default:
+		sdev->ordered_tags = 0;
+		sdev->simple_tags = 0;
+		break;
+	}
+}
 /**
  * scsi_activate_tcq - turn on tag command queueing
  * @SDpnt:	device to turn on TCQ for
@@ -25,11 +62,13 @@
  **/
 static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 {
-        if (sdev->tagged_supported) {
-		if (!blk_queue_tagged(sdev->request_queue))
-			blk_queue_init_tags(sdev->request_queue, depth, NULL);
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
-        }
+	if (!sdev->tagged_supported)
+		return;
+
+	if (!blk_queue_tagged(sdev->request_queue))
+		blk_queue_init_tags(sdev->request_queue, depth, NULL);
+
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 }
 
 /**
@@ -56,9 +95,10 @@
 static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char *msg)
 {
         struct request *req = cmd->request;
+	struct scsi_device *sdev = cmd->device;
 
         if (blk_rq_tagged(req)) {
-		if (req->flags & REQ_HARDBARRIER)
+		if (sdev->ordered_tags && req->flags & REQ_HARDBARRIER)
         	        *msg++ = MSG_ORDERED_TAG;
         	else
         	        *msg++ = MSG_SIMPLE_TAG;


