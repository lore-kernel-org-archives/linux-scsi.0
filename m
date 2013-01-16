From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 4/4] sd: change to auto suspend mode
Date: Wed, 16 Jan 2013 17:02:21 +0800
Message-ID: <1358326941-3725-5-git-send-email-aaron.lu@intel.com>
References: <1358326941-3725-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1358326941-3725-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Uses block layer runtime pm helper functions in
scsi_runtime_suspend/resume.
Remove scsi_autopm_* from sd open/release path and check_events path.
And remove the quiesce call in runtime suspend path, as we know there is
no request to quiesce for the device.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_pm.c    | 35 +++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c |  2 ++
 drivers/scsi/sd.c         | 12 ------------
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 8f6b12c..d5ddc2c 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -147,15 +147,19 @@ static int scsi_bus_restore(struct device *dev)
 static int scsi_runtime_suspend(struct device *dev)
 {
 	int err = 0;
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_suspend\n");
 	if (scsi_is_sdev_device(dev)) {
-		err = scsi_dev_type_suspend(dev,
-				pm ? pm->runtime_suspend : NULL);
-		if (err == -EAGAIN)
-			pm_schedule_suspend(dev, jiffies_to_msecs(
-				round_jiffies_up_relative(HZ/10)));
+		struct scsi_device *sdev = to_scsi_device(dev);
+		struct request_queue *q = sdev->request_queue;
+
+		err = blk_pre_runtime_suspend(q);
+		if (err)
+			return err;
+
+		err = pm_generic_runtime_suspend(dev);
+
+		blk_post_runtime_suspend(q, err);
 	}
 
 	/* Insert hooks here for targets, hosts, and transport classes */
@@ -166,11 +170,16 @@ static int scsi_runtime_suspend(struct device *dev)
 static int scsi_runtime_resume(struct device *dev)
 {
 	int err = 0;
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
-	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+		struct request_queue *q = sdev->request_queue;
+
+		blk_pre_runtime_resume(q);
+		err = pm_generic_runtime_resume(dev);
+		blk_post_runtime_resume(q, err);
+	}
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
@@ -185,10 +194,12 @@ static int scsi_runtime_idle(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-	if (scsi_is_sdev_device(dev))
-		err = pm_schedule_suspend(dev, 100);
-	else
+	if (scsi_is_sdev_device(dev)) {
+		pm_runtime_mark_last_busy(dev);
+		err = pm_runtime_autosuspend(dev);
+	} else {
 		err = pm_runtime_suspend(dev);
+	}
 	return err;
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..fff7637 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -893,6 +893,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	 */
 	scsi_autopm_get_device(sdev);
 
+	blk_pm_runtime_init(rq, &sdev->sdev_gendev);
+
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca160e..70c202c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1121,10 +1121,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 	sdev = sdkp->device;
 
-	retval = scsi_autopm_get_device(sdev);
-	if (retval)
-		goto error_autopm;
-
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -1169,8 +1165,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 
 error_out:
-	scsi_autopm_put_device(sdev);
-error_autopm:
 	scsi_disk_put(sdkp);
 	return retval;	
 }
@@ -1205,7 +1199,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_autopm_put_device(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
@@ -1367,14 +1360,9 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	retval = -ENODEV;
 
 	if (scsi_block_when_processing_errors(sdp)) {
-		retval = scsi_autopm_get_device(sdp);
-		if (retval)
-			goto out;
-
 		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
 					      sshdr);
-		scsi_autopm_put_device(sdp);
 	}
 
 	/* failed to execute TUR, assume media not present */
-- 
1.8.0.2

