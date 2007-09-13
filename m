From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: switch sdev sysfs attributes to default attributes
Date: Thu, 13 Sep 2007 23:27:39 +0200
Message-ID: <1189718859.4558.9.camel@lov.localdomain>
References: <1189522814.4564.12.camel@lov.localdomain>
	 <20070913132925.GA30622@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:60559 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754333AbXIMVWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2007 17:22:50 -0400
In-Reply-To: <20070913132925.GA30622@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>

On Thu, 2007-09-13 at 14:29 +0100, Christoph Hellwig wrote:
> On Tue, Sep 11, 2007 at 05:00:14PM +0200, Kay Sievers wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: [SCSI] switch sdev sysfs attributes to default attributes
> > 
> > This removes the unused sysfs attribute overwriting logic for most of
> > the attributes, and plugs them into the driver core default attribute
> > creation.
> > 
> > Without this patch, at the time of the events for the SCSI LUN's, there
> > will be no sysfs files, because their creation is delayed until the sd
> > driver has spun up the disks, which might take several seconds. It is the
> > last WAIT_FOR_SYSFS rule in the default udev setup which can be removed
> > with this change.
> 
> Looks good for to me.  How does sysfs react if some driver would add the
> same attribute the core has already added?  If it give back a sane error
> (and maybe even prints a message) then it's fine, otherwise we might have
> to add some debug code to error out if a driver tries to add an existing
> attribute because it sneaked through review or similar.

Greg just added:
  printk(KERN_WARNING, "sysfs: duplicate filename '%s' "
         "can not be created\n", sd->s_name);
  WARN_ON(1);
  return -EEXIST;
  
now to sysfs, so this should be fine.

Here is an updated patch, I missed the conversion of the release
function match.

Thanks,
Kay




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

 drivers/scsi/scsi_sysfs.c |  138 +++++++++++++++++-----------------------------
 1 file changed, 53 insertions(+), 85 deletions(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -571,24 +571,31 @@ sdev_show_modalias(struct device *dev, s
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
 
@@ -650,56 +657,6 @@ static struct device_attribute sdev_attr
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
@@ -731,6 +688,24 @@ int scsi_sysfs_add_sdev(struct scsi_devi
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
@@ -741,9 +716,10 @@ int scsi_sysfs_add_sdev(struct scsi_devi
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
@@ -751,20 +727,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
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
@@ -951,6 +913,12 @@ int scsi_sysfs_add_host(struct Scsi_Host
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
@@ -959,7 +927,7 @@ void scsi_sysfs_device_initialize(struct
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
-	sdev->sdev_gendev.release = scsi_device_dev_release;
+	sdev->sdev_gendev.type = &scsi_dev_type;
 	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id,
 		sdev->lun);
@@ -980,7 +948,7 @@ void scsi_sysfs_device_initialize(struct
 
 int scsi_is_sdev_device(const struct device *dev)
 {
-	return dev->release == scsi_device_dev_release;
+	return dev->type == &scsi_dev_type;
 }
 EXPORT_SYMBOL(scsi_is_sdev_device);
 

