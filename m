From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] add change_queue_depth API to scsi host template
Date: Sat, 11 Dec 2004 18:52:00 -0600
Message-ID: <1102812720.5232.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:59545
	"EHLO redscar") by vger.kernel.org with ESMTP id S261985AbULLAwE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 19:52:04 -0500
Received: from mulgrave-w.il.steeleye.com (mulgrave-w.il.steeleye.com [153.66.150.222])
	by redscar (Postfix) with ESMTP id 73DB5940B
	for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2004 18:52:02 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Originally, the 53c700 driver implemented queue_depth changing as an
attribute override, primarily as a demonstration of how it should be
done.  Now that a large number of drivers wish to implement this
functionality, it should become an API rather than an attribute
override, since the latter are supposed to be used as one off extensions
rather than the de-facto API.

James

===== drivers/scsi/scsi_sysfs.c 1.58 vs edited =====
--- 1.58/drivers/scsi/scsi_sysfs.c	2004-10-24 06:09:42 -05:00
+++ edited/drivers/scsi/scsi_sysfs.c	2004-12-11 16:35:29 -06:00
@@ -388,7 +388,7 @@
 	return snprintf(buf, 20, "%s\n", name);
 }
 
-DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
+static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
 
 
 /* Default template for device attributes.  May NOT be modified */
@@ -407,6 +407,38 @@
 	NULL
 };
 
+static ssize_t sdev_store_queue_depth_rw(struct device *dev, const char *buf,
+					 size_t count)
+{
+	int depth, retval;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_host_template *sht = sdev->host->hostt;
+
+	if (!sht->change_queue_depth)
+		return -EINVAL;
+
+	depth = simple_strtoul(buf, NULL, 0);
+	retval = sht->change_queue_depth(sdev, depth);
+	if (retval < 0)
+		return retval;
+
+	return count;
+}
+
+static struct device_attribute sdev_attr_queue_depth_rw =
+	__ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
+	       sdev_store_queue_depth_rw);
+
+static struct device_attribute *attr_changed_internally(
+		struct Scsi_Host *shost,
+		struct device_attribute * attr)
+{
+	if (!strcmp("queue_depth", attr->attr.name)
+	    && shost->hostt->change_queue_depth)
+		return &sdev_attr_queue_depth_rw;
+	return attr;
+}
+
 
 static struct device_attribute *attr_overridden(
 		struct device_attribute **attrs,
@@ -547,8 +579,10 @@
 	for (i = 0; scsi_sysfs_sdev_attrs[i]; i++) {
 		if (!attr_overridden(sdev->host->hostt->sdev_attrs,
 					scsi_sysfs_sdev_attrs[i])) {
-			error = device_create_file(&sdev->sdev_gendev,
-					scsi_sysfs_sdev_attrs[i]);
+			struct device_attribute * attr = 
+				attr_changed_internally(sdev->host, 
+							scsi_sysfs_sdev_attrs[i]);
+			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
 				scsi_remove_device(sdev);
 				goto out;
===== include/scsi/scsi_host.h 1.21 vs edited =====
--- 1.21/include/scsi/scsi_host.h	2004-10-05 10:47:13 -05:00
+++ edited/include/scsi/scsi_host.h	2004-12-11 16:35:32 -06:00
@@ -216,6 +216,18 @@
 	void (* slave_destroy)(struct scsi_device *);
 
 	/*
+	 * fill in this function to allow the queue depth of this host
+	 * to be changeable (on a per device basis).  returns either
+	 * the current queue depth setting (may be different from what
+	 * was passed in) or an error.  An error should only be
+	 * returned if the requested depth is legal but the driver was
+	 * unable to set it.  If the requested depth is illegal, the
+	 * driver should set and return the closest legal queue depth.
+	 *
+	 */
+	int (* change_queue_depth)(struct scsi_device *, int);
+
+	/*
 	 * This function determines the bios parameters for a given
 	 * harddisk.  These tend to be numbers that are made up by
 	 * the host adapter.  Parameters:


