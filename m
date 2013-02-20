From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v10 4/4] sd: change to auto suspend mode
Date: Wed, 20 Feb 2013 14:11:57 +0800
Message-ID: <1361340717-8991-5-git-send-email-aaron.lu@intel.com>
References: <1361340717-8991-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1361340717-8991-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Uses block layer runtime pm helper functions in
scsi_runtime_suspend/resume for devices that take advantage of it.

Remove scsi_autopm_* from sd open/release path and check_events path.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_pm.c | 84 ++++++++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/sd.c      | 13 +-------
 2 files changed, 72 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 8f6b12c..90b12d9 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -144,33 +144,83 @@ static int scsi_bus_restore(struct device *dev)
 
 #ifdef CONFIG_PM_RUNTIME
 
+static int sdev_blk_runtime_suspend(struct scsi_device *sdev,
+					int (*cb)(struct device *))
+{
+	int err;
+
+	err = blk_pre_runtime_suspend(sdev->request_queue);
+	if (err)
+		return err;
+	if (cb)
+		err = cb(&sdev->sdev_gendev);
+	blk_post_runtime_suspend(sdev->request_queue, err);
+
+	return err;
+}
+
+static int sdev_runtime_suspend(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int (*cb)(struct device *) = pm ? pm->runtime_suspend : NULL;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int ret;
+
+	if (sdev->request_queue->dev)
+		return sdev_blk_runtime_suspend(sdev, cb);
+
+	ret = scsi_dev_type_suspend(dev, cb);
+	if (err == -EAGAIN)
+		pm_schedule_suspend(dev, jiffies_to_msecs(
+					round_jiffies_up_relative(HZ/10)));
+	return ret;
+}
+
 static int scsi_runtime_suspend(struct device *dev)
 {
 	int err = 0;
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_suspend\n");
-	if (scsi_is_sdev_device(dev)) {
-		err = scsi_dev_type_suspend(dev,
-				pm ? pm->runtime_suspend : NULL);
-		if (err == -EAGAIN)
-			pm_schedule_suspend(dev, jiffies_to_msecs(
-				round_jiffies_up_relative(HZ/10)));
-	}
+	if (scsi_is_sdev_device(dev))
+		err = sdev_runtime_suspend(dev);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
 	return err;
 }
 
-static int scsi_runtime_resume(struct device *dev)
+static int sdev_blk_runtime_resume(struct scsi_device *sdev,
+					int (*cb)(struct device *))
 {
 	int err = 0;
+
+	blk_pre_runtime_resume(sdev->request_queue);
+	if (cb)
+		err = cb(&sdev->sdev_gendev);
+	blk_post_runtime_resume(sdev->request_queue, err);
+
+	return err;
+}
+
+static int sdev_runtime_resume(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int (*cb)(struct device *) = pm ? pm->runtime_resume : NULL;
+
+	if (sdev->request_queue->dev)
+		return sdev_blk_runtime_resume(sdev, cb);
+	else
+		return scsi_dev_type_resume(dev, cb);
+}
+
+static int scsi_runtime_resume(struct device *dev)
+{
+	int err = 0;
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
+		err = sdev_runtime_resume(dev);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
@@ -185,10 +235,18 @@ static int scsi_runtime_idle(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-	if (scsi_is_sdev_device(dev))
-		err = pm_schedule_suspend(dev, 100);
-	else
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+
+		if (sdev->request_queue->dev) {
+			pm_runtime_mark_last_busy(dev);
+			err = pm_runtime_autosuspend(dev);
+		} else {
+			err = pm_runtime_suspend(dev);
+		}
+	} else {
 		err = pm_runtime_suspend(dev);
+	}
 	return err;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c6e2b34..5000bec 100644
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
@@ -2839,6 +2827,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	blk_pm_runtime_init(sdp->request_queue, dev);
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }
-- 
1.8.1.2

