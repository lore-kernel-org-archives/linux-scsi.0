From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 1/2 remove attr_changed_internally
Date: Wed, 2 Mar 2005 11:45:53 -0800
Message-ID: <20050302194553.GA9776@us.ibm.com>
References: <20050302194432.GA9743@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e31.co.us.ibm.com ([32.97.110.129]:30691 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262409AbVCBTqF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 14:46:05 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j22Jk3ua272404
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 14:46:03 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j22Jk3XV164586
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 12:46:03 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j22Jk2Ej025766
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 12:46:02 -0700
Content-Disposition: inline
In-Reply-To: <20050302194432.GA9743@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

Get rid of the attr_changed_internally(), and always create queue_type and
queue_depth as read/write, and then writes fail if not supported.

Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>

--- linux-2.6.11/drivers/scsi/scsi_sysfs.c	2005-03-02 02:59:50.000000000 -0800
+++ sattrs-linux-2.6.11/drivers/scsi/scsi_sysfs.c	2005-03-02 09:27:15.000000000 -0800
@@ -312,7 +312,6 @@
  * Create the actual show/store functions and data structures.
  */
 sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
@@ -392,41 +391,9 @@
 
 static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
 
-static ssize_t
-show_queue_type_field(struct device *dev, char *buf)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	const char *name = "none";
-
-	if (sdev->ordered_tags)
-		name = "ordered";
-	else if (sdev->simple_tags)
-		name = "simple";
-
-	return snprintf(buf, 20, "%s\n", name);
-}
-
-static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
-
-
-/* Default template for device attributes.  May NOT be modified */
-static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
-	&dev_attr_device_blocked,
-	&dev_attr_queue_depth,
-	&dev_attr_queue_type,
-	&dev_attr_type,
-	&dev_attr_scsi_level,
-	&dev_attr_vendor,
-	&dev_attr_model,
-	&dev_attr_rev,
-	&dev_attr_rescan,
-	&dev_attr_delete,
-	&dev_attr_state,
-	&dev_attr_timeout,
-	NULL
-};
+sdev_show_function (queue_depth, "%d\n");
 
-static ssize_t sdev_store_queue_depth_rw(struct device *dev, const char *buf,
+static ssize_t sdev_store_queue_depth(struct device *dev, const char *buf,
 					 size_t count)
 {
 	int depth, retval;
@@ -448,11 +415,25 @@
 	return count;
 }
 
-static struct device_attribute sdev_attr_queue_depth_rw =
+static struct device_attribute dev_attr_queue_depth =
 	__ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
-	       sdev_store_queue_depth_rw);
+	       sdev_store_queue_depth);
 
-static ssize_t sdev_store_queue_type_rw(struct device *dev, const char *buf,
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
+static ssize_t sdev_store_queue_type(struct device *dev, const char *buf,
 					size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -480,23 +461,26 @@
 	return count;
 }
 
-static struct device_attribute sdev_attr_queue_type_rw =
+static struct device_attribute dev_attr_queue_type =
 	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
-	       sdev_store_queue_type_rw);
-
-static struct device_attribute *attr_changed_internally(
-		struct Scsi_Host *shost,
-		struct device_attribute * attr)
-{
-	if (!strcmp("queue_depth", attr->attr.name)
-	    && shost->hostt->change_queue_depth)
-		return &sdev_attr_queue_depth_rw;
-	else if (!strcmp("queue_type", attr->attr.name)
-	    && shost->hostt->change_queue_type)
-		return &sdev_attr_queue_type_rw;
-	return attr;
-}
+	       sdev_store_queue_type);
 
+/* Default template for device attributes.  May NOT be modified */
+static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
+	&dev_attr_device_blocked,
+	&dev_attr_queue_depth,
+	&dev_attr_queue_type,
+	&dev_attr_type,
+	&dev_attr_scsi_level,
+	&dev_attr_vendor,
+	&dev_attr_model,
+	&dev_attr_rev,
+	&dev_attr_rescan,
+	&dev_attr_delete,
+	&dev_attr_state,
+	&dev_attr_timeout,
+	NULL
+};
 
 static struct device_attribute *attr_overridden(
 		struct device_attribute **attrs,
@@ -602,10 +586,8 @@
 	for (i = 0; scsi_sysfs_sdev_attrs[i]; i++) {
 		if (!attr_overridden(sdev->host->hostt->sdev_attrs,
 					scsi_sysfs_sdev_attrs[i])) {
-			struct device_attribute * attr = 
-				attr_changed_internally(sdev->host, 
-							scsi_sysfs_sdev_attrs[i]);
-			error = device_create_file(&sdev->sdev_gendev, attr);
+			error = device_create_file(&sdev->sdev_gendev,
+						   scsi_sysfs_sdev_attrs[i]);
 			if (error) {
 				scsi_remove_device(sdev);
 				goto out;
