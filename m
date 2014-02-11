From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] scsi_sysfs: Implement 'is_visible' callback
Date: Tue, 11 Feb 2014 15:34:53 +0100
Message-ID: <1392129294-55235-2-git-send-email-hare@suse.de>
References: <1392129294-55235-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaBKOe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Feb 2014 09:34:57 -0500
In-Reply-To: <1392129294-55235-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Instead of modifying attributes after the device has been created
we should be using the 'is_visible' callback to avoid races.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 195 ++++++++++++++++++++++++----------------------
 1 file changed, 102 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..9aee0e3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -579,7 +579,6 @@ static int scsi_sdev_check_buf_bit(const char *buf)
  * Create the actual show/store functions and data structures.
  */
 sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (device_busy, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
@@ -723,7 +722,37 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, 20, "%s\n", name);
 }
 
-static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
+static ssize_t
+store_queue_type_field(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
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
+static DEVICE_ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
+		   store_queue_type_field);
 
 static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
@@ -797,46 +826,9 @@ DECLARE_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED_REPORTED)
 DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
 DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
 
-/* Default template for device attributes.  May NOT be modified */
-static struct attribute *scsi_sdev_attrs[] = {
-	&dev_attr_device_blocked.attr,
-	&dev_attr_type.attr,
-	&dev_attr_scsi_level.attr,
-	&dev_attr_device_busy.attr,
-	&dev_attr_vendor.attr,
-	&dev_attr_model.attr,
-	&dev_attr_rev.attr,
-	&dev_attr_rescan.attr,
-	&dev_attr_delete.attr,
-	&dev_attr_state.attr,
-	&dev_attr_timeout.attr,
-	&dev_attr_eh_timeout.attr,
-	&dev_attr_iocounterbits.attr,
-	&dev_attr_iorequest_cnt.attr,
-	&dev_attr_iodone_cnt.attr,
-	&dev_attr_ioerr_cnt.attr,
-	&dev_attr_modalias.attr,
-	REF_EVT(media_change),
-	REF_EVT(inquiry_change_reported),
-	REF_EVT(capacity_change_reported),
-	REF_EVT(soft_threshold_reached),
-	REF_EVT(mode_parameter_change_reported),
-	REF_EVT(lun_change_reported),
-	NULL
-};
-
-static struct attribute_group scsi_sdev_attr_group = {
-	.attrs =	scsi_sdev_attrs,
-};
-
-static const struct attribute_group *scsi_sdev_attr_groups[] = {
-	&scsi_sdev_attr_group,
-	NULL
-};
-
 static ssize_t
-sdev_store_queue_depth_rw(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t count)
+sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
 {
 	int depth, retval;
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -859,10 +851,10 @@ sdev_store_queue_depth_rw(struct device *dev, struct device_attribute *attr,
 
 	return count;
 }
+sdev_show_function(queue_depth, "%d\n");
 
-static struct device_attribute sdev_attr_queue_depth_rw =
-	__ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
-	       sdev_store_queue_depth_rw);
+static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
+		   sdev_store_queue_depth);
 
 static ssize_t
 sdev_show_queue_ramp_up_period(struct device *dev,
@@ -890,39 +882,79 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 	return period;
 }
 
-static struct device_attribute sdev_attr_queue_ramp_up_period =
-	__ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
-	       sdev_show_queue_ramp_up_period,
-	       sdev_store_queue_ramp_up_period);
+static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
+		   sdev_show_queue_ramp_up_period,
+		   sdev_store_queue_ramp_up_period);
 
-static ssize_t
-sdev_store_queue_type_rw(struct device *dev, struct device_attribute *attr,
-			 const char *buf, size_t count)
+static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
+					 struct attribute *attr, int i)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
-	int tag_type = 0, retval;
-	int prev_tag_type = scsi_get_tag_type(sdev);
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct scsi_device *sdev = to_scsi_device(dev);			\
 
-	if (!sdev->tagged_supported || !sht->change_queue_type)
-		return -EINVAL;
 
-	if (strncmp(buf, "ordered", 7) == 0)
-		tag_type = MSG_ORDERED_TAG;
-	else if (strncmp(buf, "simple", 6) == 0)
-		tag_type = MSG_SIMPLE_TAG;
-	else if (strncmp(buf, "none", 4) != 0)
-		return -EINVAL;
+	if (attr == &dev_attr_queue_depth.attr) {
+		if (sdev->host->hostt->change_queue_depth)
+			return S_IRUGO | S_IWUSR;
+		else
+			return S_IRUGO;
+	}
+	if (attr == &dev_attr_queue_ramp_up_period.attr) {
+		if (sdev->host->hostt->change_queue_depth)
+			return S_IRUGO | S_IWUSR;
+		else
+			return 0;
+	}
+	if (attr == &dev_attr_queue_type.attr) {
+		if (sdev->host->hostt->change_queue_type)
+			return S_IRUGO | S_IWUSR;
+		else
+			return S_IRUGO;
+	}
 
-	if (tag_type == prev_tag_type)
-		return count;
+	return attr->mode;
+}
 
-	retval = sht->change_queue_type(sdev, tag_type);
-	if (retval < 0)
-		return retval;
+/* Default template for device attributes.  May NOT be modified */
+static struct attribute *scsi_sdev_attrs[] = {
+	&dev_attr_device_blocked.attr,
+	&dev_attr_type.attr,
+	&dev_attr_scsi_level.attr,
+	&dev_attr_device_busy.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_model.attr,
+	&dev_attr_rev.attr,
+	&dev_attr_rescan.attr,
+	&dev_attr_delete.attr,
+	&dev_attr_state.attr,
+	&dev_attr_timeout.attr,
+	&dev_attr_eh_timeout.attr,
+	&dev_attr_iocounterbits.attr,
+	&dev_attr_iorequest_cnt.attr,
+	&dev_attr_iodone_cnt.attr,
+	&dev_attr_ioerr_cnt.attr,
+	&dev_attr_modalias.attr,
+	&dev_attr_queue_depth.attr,
+	&dev_attr_queue_type.attr,
+	&dev_attr_queue_ramp_up_period.attr,
+	REF_EVT(media_change),
+	REF_EVT(inquiry_change_reported),
+	REF_EVT(capacity_change_reported),
+	REF_EVT(soft_threshold_reached),
+	REF_EVT(mode_parameter_change_reported),
+	REF_EVT(lun_change_reported),
+	NULL
+};
 
-	return count;
-}
+static struct attribute_group scsi_sdev_attr_group = {
+	.attrs =	scsi_sdev_attrs,
+	.is_visible =	scsi_sdev_attr_is_visible,
+};
+
+static const struct attribute_group *scsi_sdev_attr_groups[] = {
+	&scsi_sdev_attr_group,
+	NULL
+};
 
 static int scsi_target_add(struct scsi_target *starget)
 {
@@ -946,10 +978,6 @@ static int scsi_target_add(struct scsi_target *starget)
 	return 0;
 }
 
-static struct device_attribute sdev_attr_queue_type_rw =
-	__ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
-	       sdev_store_queue_type_rw);
-
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -1003,25 +1031,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
-	/* create queue files, which may be writable, depending on the host */
-	if (sdev->host->hostt->change_queue_depth) {
-		error = device_create_file(&sdev->sdev_gendev,
-					   &sdev_attr_queue_depth_rw);
-		error = device_create_file(&sdev->sdev_gendev,
-					   &sdev_attr_queue_ramp_up_period);
-	}
-	else
-		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
-	if (error)
-		return error;
-
-	if (sdev->host->hostt->change_queue_type)
-		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
-	else
-		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
-	if (error)
-		return error;
-
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
 	if (error)
-- 
1.7.12.4

