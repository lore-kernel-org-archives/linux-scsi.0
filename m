From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2] scsi: sr: use block layer runtime PM
Date: Fri, 06 Sep 2013 10:01:07 +0800
Message-ID: <52293763.5070206@intel.com>
References: <Pine.LNX.4.44L0.1309051007220.1121-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41611 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3IFCAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 22:00:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.1309051007220.1121-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <JBottomley@parallels.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Migrate SCSI Optical Disk Drive(ODD) driver sr to make use of block
layer runtime PM. Accordingly, the SCSI bus layer runtime PM callback is
simplified as all SCSI devices that implement runtime PM are now request
based.

Note that due to ODD will be polled every 2 seconds, for suspend to
actually happen, the autosuspend_delay can not be set to more than 2
seconds or the polling interval has to be increased.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
v2: scsi_dev_type_suspend/resume should be covered by CONFIG_PM_SLEEP,
suggested by Alan Stern.

Make sure to use the util-linux utility of version 2.23.2 or later if
a ATA host is in use, as there is a bug fix for eject command to
correctly update the ODD's locked state. If the fix is not applied,
after the ODD is ejected with the eject command, it will not be able to
enter runtime suspend state any more due to SCSI EH code will submit a
lock door command for the ODD right after its parent ATA port is runtime
suspended.
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=12272030e563201e0b06732d8a87d8cea7157a04

 drivers/scsi/scsi_pm.c | 62 +++++++++++++-------------------------------------
 drivers/scsi/sr.c      | 37 +++++++++++-------------------
 2 files changed, 29 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 4c5aabe..bb31fc9 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -16,6 +16,8 @@
 
 #include "scsi_priv.h"
 
+#ifdef CONFIG_PM_SLEEP
+
 static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
 {
 	int err;
@@ -43,8 +45,6 @@ static int scsi_dev_type_resume(struct device *dev, int (*cb)(struct device *))
 	return err;
 }
 
-#ifdef CONFIG_PM_SLEEP
-
 static int
 scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
 {
@@ -144,38 +144,22 @@ static int scsi_bus_restore(struct device *dev)
 
 #ifdef CONFIG_PM_RUNTIME
 
-static int sdev_blk_runtime_suspend(struct scsi_device *sdev,
-					int (*cb)(struct device *))
+static int sdev_runtime_suspend(struct device *dev)
 {
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	struct scsi_device *sdev = to_scsi_device(dev);
 	int err;
 
 	err = blk_pre_runtime_suspend(sdev->request_queue);
 	if (err)
 		return err;
-	if (cb)
-		err = cb(&sdev->sdev_gendev);
+	if (pm && pm->runtime_suspend)
+		err = pm->runtime_suspend(dev);
 	blk_post_runtime_suspend(sdev->request_queue, err);
 
 	return err;
 }
 
-static int sdev_runtime_suspend(struct device *dev)
-{
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int (*cb)(struct device *) = pm ? pm->runtime_suspend : NULL;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err;
-
-	if (sdev->request_queue->dev)
-		return sdev_blk_runtime_suspend(sdev, cb);
-
-	err = scsi_dev_type_suspend(dev, cb);
-	if (err == -EAGAIN)
-		pm_schedule_suspend(dev, jiffies_to_msecs(
-					round_jiffies_up_relative(HZ/10)));
-	return err;
-}
-
 static int scsi_runtime_suspend(struct device *dev)
 {
 	int err = 0;
@@ -189,31 +173,20 @@ static int scsi_runtime_suspend(struct device *dev)
 	return err;
 }
 
-static int sdev_blk_runtime_resume(struct scsi_device *sdev,
-					int (*cb)(struct device *))
+static int sdev_runtime_resume(struct device *dev)
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err = 0;
 
 	blk_pre_runtime_resume(sdev->request_queue);
-	if (cb)
-		err = cb(&sdev->sdev_gendev);
+	if (pm && pm->runtime_resume)
+		err = pm->runtime_resume(dev);
 	blk_post_runtime_resume(sdev->request_queue, err);
 
 	return err;
 }
 
-static int sdev_runtime_resume(struct device *dev)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int (*cb)(struct device *) = pm ? pm->runtime_resume : NULL;
-
-	if (sdev->request_queue->dev)
-		return sdev_blk_runtime_resume(sdev, cb);
-	else
-		return scsi_dev_type_resume(dev, cb);
-}
-
 static int scsi_runtime_resume(struct device *dev)
 {
 	int err = 0;
@@ -234,14 +207,11 @@ static int scsi_runtime_idle(struct device *dev)
 	/* Insert hooks here for targets, hosts, and transport classes */
 
 	if (scsi_is_sdev_device(dev)) {
-		struct scsi_device *sdev = to_scsi_device(dev);
-
-		if (sdev->request_queue->dev) {
-			pm_runtime_mark_last_busy(dev);
-			pm_runtime_autosuspend(dev);
-			return -EBUSY;
-		}
+		pm_runtime_mark_last_busy(dev);
+		pm_runtime_autosuspend(dev);
+		return -EBUSY;
 	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 119d67f..40d8592 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -161,14 +161,10 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 		goto out;
 	cd = scsi_cd(disk);
 	kref_get(&cd->kref);
-	if (scsi_device_get(cd->device))
-		goto out_put;
-	if (!scsi_autopm_get_device(cd->device))
-		goto out;
-
- out_put:
-	kref_put(&cd->kref, sr_kref_release);
-	cd = NULL;
+	if (scsi_device_get(cd->device)) {
+		kref_put(&cd->kref, sr_kref_release);
+		cd = NULL;
+	}
  out:
 	mutex_unlock(&sr_ref_mutex);
 	return cd;
@@ -180,7 +176,6 @@ static void scsi_cd_put(struct scsi_cd *cd)
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
-	scsi_autopm_put_device(sdev);
 	scsi_device_put(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
@@ -558,8 +553,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	scsi_autopm_get_device(cd->device);
-
 	mutex_lock(&sr_mutex);
 
 	/*
@@ -591,7 +584,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
-	scsi_autopm_put_device(cd->device);
 	return ret;
 }
 
@@ -599,17 +591,11 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	unsigned int ret;
 
-	if (atomic_read(&cd->device->disk_events_disable_depth) == 0) {
-		scsi_autopm_get_device(cd->device);
-		ret = cdrom_check_events(&cd->cdi, clearing);
-		scsi_autopm_put_device(cd->device);
-	} else {
-		ret = 0;
-	}
+	if (atomic_read(&cd->device->disk_events_disable_depth))
+		return 0;
 
-	return ret;
+	return cdrom_check_events(&cd->cdi, clearing);
 }
 
 static int sr_block_revalidate_disk(struct gendisk *disk)
@@ -617,8 +603,6 @@ static int sr_block_revalidate_disk(struct gendisk *disk)
 	struct scsi_cd *cd = scsi_cd(disk);
 	struct scsi_sense_hdr sshdr;
 
-	scsi_autopm_get_device(cd->device);
-
 	/* if the unit is not ready, nothing more to do */
 	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
 		goto out;
@@ -626,7 +610,6 @@ static int sr_block_revalidate_disk(struct gendisk *disk)
 	sr_cd_check(&cd->cdi);
 	get_sectorsize(cd);
 out:
-	scsi_autopm_put_device(cd->device);
 	return 0;
 }
 
@@ -747,6 +730,12 @@ static int sr_probe(struct device *dev)
 	if (register_cdrom(&cd->cdi))
 		goto fail_put;
 
+	/*
+	 * Initialize block layer runtime PM stuffs before the
+	 * periodic event checking request gets started in add_disk.
+	 */
+	blk_pm_runtime_init(sdev->request_queue, dev);
+
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
-- 
1.8.3.2.10.g43d11f4

