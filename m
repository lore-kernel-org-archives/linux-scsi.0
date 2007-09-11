From: Kay Sievers <kay.sievers@vrfy.org>
Subject: switch sdev sysfs attributes to default attributes
Date: Tue, 11 Sep 2007 17:00:14 +0200
Message-ID: <1189522814.4564.12.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:36312 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752619AbXIKOzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 10:55:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [SCSI] switch sdev sysfs attributes to default attributes

This removes the unused sysfs attribute overwriting logic for most of
the attributes, and plugs them into the driver core default attribute
creation.

Without this patch, at the time of the events for the SCSI LUN's, there
will be no sysfs files, because their creation is delayed until the sd
driver has spun up the disks, which might take several seconds. It is the
last WAIT_FOR_SYSFS rule in the default udev setup which can be removed
with this change.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---

 scsi_sysfs.c |  136 ++++++++++++++++++++++-------------------------------------
 1 file changed, 52 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 34cdce6..cfdc5f8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -576,24 +576,31 @@ sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
 /* Default template for device attributes.  May NOT be modified */
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
-	&dev_attr_iocounterbits,
-	&dev_attr_iorequest_cnt,
-	&dev_attr_iodone_cnt,
-	&dev_attr_ioerr_cnt,
-	&dev_attr_modalias,
+static struct attribute *scsi_sdev_attrs[] = {
+	&dev_attr_device_blocked.attr,
+	&dev_attr_type.attr,
+	&dev_attr_scsi_level.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_model.attr,
+	&dev_attr_rev.attr,
+	&dev_attr_rescan.attr,
+	&dev_attr_delete.attr,
+	&dev_attr_state.attr,
+	&dev_attr_timeout.attr,
+	&dev_attr_iocounterbits.attr,
+	&dev_attr_iorequest_cnt.attr,
+	&dev_attr_iodone_cnt.attr,
+	&dev_attr_ioerr_cnt.attr,
+	&dev_attr_modalias.attr,
+	NULL
+};
+
+static struct attribute_group scsi_sdev_attr_group = {
+	.attrs =	scsi_sdev_attrs,
+};
+
+static struct attribute_group *scsi_sdev_attr_groups[] = {
+	&scsi_sdev_attr_group,
 	NULL
 };
 
@@ -655,56 +662,6 @@ static struct device_attribute sdev_attr_queue_type_rw =
 	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 	       sdev_store_queue_type_rw);
 
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
-
-
-static struct device_attribute *attr_overridden(
-		struct device_attribute **attrs,
-		struct device_attribute *attr)
-{
-	int i;
-
-	if (!attrs)
-		return NULL;
-	for (i = 0; attrs[i]; i++)
-		if (!strcmp(attrs[i]->attr.name, attr->attr.name))
-			return attrs[i];
-	return NULL;
-}
-
-static int attr_add(struct device *dev, struct device_attribute *attr)
-{
-	struct device_attribute *base_attr;
-
-	/*
-	 * Spare the caller from having to copy things it's not interested in.
-	 */
-	base_attr = attr_overridden(scsi_sysfs_sdev_attrs, attr);
-	if (base_attr) {
-		/* extend permissions */
-		attr->attr.mode |= base_attr->attr.mode;
-
-		/* override null show/store with default */
-		if (!attr->show)
-			attr->show = base_attr->show;
-		if (!attr->store)
-			attr->store = base_attr->store;
-	}
-
-	return device_create_file(dev, attr);
-}
-
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -736,6 +693,24 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
 
+	/* create queue files, which may be writable, depending on the host */
+	if (sdev->host->hostt->change_queue_depth)
+		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
+	else
+		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
+	if (error) {
+		__scsi_remove_device(sdev);
+		goto out;
+	}
+	if (sdev->host->hostt->change_queue_type)
+		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
+	else
+		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
+	if (error) {
+		__scsi_remove_device(sdev);
+		goto out;
+	}
+
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
 
 	if (error)
@@ -746,9 +721,10 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	 * nothing went wrong */
 	error = 0;
 
+	/* add additional host specific attributes */
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
-			error = attr_add(&sdev->sdev_gendev,
+			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
 				__scsi_remove_device(sdev);
@@ -756,20 +732,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 			}
 		}
 	}
-	
-	for (i = 0; scsi_sysfs_sdev_attrs[i]; i++) {
-		if (!attr_overridden(sdev->host->hostt->sdev_attrs,
-					scsi_sysfs_sdev_attrs[i])) {
-			struct device_attribute * attr = 
-				attr_changed_internally(sdev->host, 
-							scsi_sysfs_sdev_attrs[i]);
-			error = device_create_file(&sdev->sdev_gendev, attr);
-			if (error) {
-				__scsi_remove_device(sdev);
-				goto out;
-			}
-		}
-	}
 
 	transport_add_device(&sdev->sdev_gendev);
  out:
@@ -956,6 +918,12 @@ int scsi_sysfs_add_host(struct Scsi_Host *shost)
 	return 0;
 }
 
+static struct device_type scsi_dev_type = {
+	.name =		"scsi_device",
+	.release =	scsi_device_dev_release,
+	.groups =	scsi_sdev_attr_groups,
+};
+
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
 	unsigned long flags;
@@ -964,7 +932,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
-	sdev->sdev_gendev.release = scsi_device_dev_release;
+	sdev->sdev_gendev.type = &scsi_dev_type;
 	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id,
 		sdev->lun);

