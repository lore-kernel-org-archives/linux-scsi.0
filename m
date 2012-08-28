From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] scsi: sr: add may_power_off flag
Date: Tue, 28 Aug 2012 16:39:57 +0800
Message-ID: <1346143197-2558-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab2H1Ikf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Aug 2012 04:40:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Add a new flag may_power_off to scsi_device to let user decide if they
want the scsi device to be powered off when runtime suspended.

For ODD, if the ODD is capable of zero power, a device attribute file
will be created for user to control the value.

And if user sets 0 to may_power_off, we will disable runtime suspend
for this ODD since there is no benefit if power can't be removed when
suspended.

Apply on top of the previous sent ZPODD scsi tree patches:
https://lkml.org/lkml/2012/7/27/71

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sr.c          | 55 +++++++++++++++++++++++++++++++++++++++++-----
 include/scsi/scsi_device.h |  1 +
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e6e5549..bc9df62 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -158,7 +158,7 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
-	if (cd->device->can_power_off && scsi_autopm_get_device(cd->device))
+	if (scsi_autopm_get_device(cd->device))
 		goto out_pm;
 	goto out;
 
@@ -179,11 +179,50 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
-	if (sdev->can_power_off)
-		scsi_autopm_put_device_autosuspend(sdev);
+	scsi_autopm_put_device_autosuspend(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static ssize_t
+may_power_off_show(struct device *dev, struct device_attribute *attr,
+		   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	return snprintf(buf, 10, "%d\n", sdev->may_power_off);
+}
+
+static ssize_t
+may_power_off_store(struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	int value = -EINVAL;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	if (buf[1] == '\0' || (buf[1] == '\n' && buf[2] == '\0')) {
+		if (buf[0] == '1')
+			value = 1;
+		else if (buf[0] == '0')
+			value = 0;
+	}
+
+	if (value >= 0) {
+		if (sdev->may_power_off != value) {
+			if (value == 0) {
+				if (!atomic_dec_and_test(&cd->suspend_count))
+					scsi_autopm_get_device(cd->device);
+			} else
+				atomic_set(&cd->suspend_count, 1);
+			sdev->may_power_off = value;
+		}
+		value = count;
+	}
+
+	return value;
+}
+DEVICE_ATTR(may_power_off, S_IRUGO | S_IWUSR,
+		may_power_off_show, may_power_off_store);
+
 static int sr_suspend(struct device *dev, pm_message_t msg)
 {
 	int poweroff;
@@ -342,7 +381,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 		return 0;
 
 	/* if the logical unit just finished loading/unloading, do a TUR */
-	if (cd->device->can_power_off && cd->dbml && sr_unit_load_done(cd)) {
+	if (cd->device->may_power_off && cd->dbml && sr_unit_load_done(cd)) {
 		events = 0;
 		goto do_tur;
 	}
@@ -396,7 +435,7 @@ do_tur:
 		cd->tur_changed = true;
 	}
 
-	if (cd->device->can_power_off && !cd->media_present) {
+	if (cd->device->may_power_off && !cd->media_present) {
 		if (cd->cdi.mask & CDC_CLOSE_TRAY)
 			poweroff = 1;
 		else
@@ -850,6 +889,8 @@ static int sr_probe(struct device *dev)
 		pm_runtime_set_autosuspend_delay(dev, 180 * 1000);
 		pm_runtime_use_autosuspend(dev);
 		atomic_set(&cd->suspend_count, 1);
+		sdev->may_power_off = 1;
+		device_create_file(dev, &dev_attr_may_power_off);
 	}
 
 	disk->driverfs_dev = &sdev->sdev_gendev;
@@ -1138,10 +1179,12 @@ static int sr_remove(struct device *dev)
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
 	/* disable runtime pm and possibly resume the device */
-	if (cd->device->can_power_off &&
+	if (cd->device->may_power_off &&
 			!atomic_dec_and_test(&cd->suspend_count))
 		scsi_autopm_get_device(cd->device);
 
+	device_remove_file(dev, &dev_attr_may_power_off);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4bc4ac4..0bfc17f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,6 +157,7 @@ struct scsi_device {
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wakeup_by_user:1;	/* User wakes up the ODD */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned may_power_off:1;	/* power off is allowed by user */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.5

