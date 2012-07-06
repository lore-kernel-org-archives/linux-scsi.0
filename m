From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v5 4/4] [SCSI] sd: change to auto suspend mode
Date: Fri,  6 Jul 2012 12:04:32 +0800
Message-ID: <1341547472-6863-5-git-send-email-ming.m.lin@intel.com>
References: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Uses block layer runtime pm helper functions in scsi_runtime_suspend/resume.
Remove scsi_autopm_* from sd open/release path.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c    |   38 ++++++++++++++++++++++++++++++--------
 drivers/scsi/scsi_sysfs.c |    2 ++
 drivers/scsi/sd.c         |    7 -------
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..f0b279a 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -74,6 +74,7 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 
 static int scsi_bus_resume_common(struct device *dev)
 {
+	struct request_queue *q = NULL;
 	int err = 0;
 
 	/*
@@ -84,14 +85,22 @@ static int scsi_bus_resume_common(struct device *dev)
 	 */
 	pm_runtime_get_sync(dev->parent);
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+		q = sdev->request_queue;
+
+		blk_pre_runtime_resume(q);
 		err = scsi_dev_type_resume(dev);
+	}
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
 
+	if (q)
+		blk_post_runtime_resume(q, err);
+
 	pm_runtime_put_sync(dev->parent);
 
 	return err;
@@ -143,10 +152,16 @@ static int scsi_runtime_suspend(struct device *dev)
 
 	dev_dbg(dev, "scsi_runtime_suspend\n");
 	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+		struct request_queue *q = sdev->request_queue;
+
+		err = blk_pre_runtime_suspend(q);
+		if (err)
+			return err;
+
 		err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
-		if (err == -EAGAIN)
-			pm_schedule_suspend(dev, jiffies_to_msecs(
-				round_jiffies_up_relative(HZ/10)));
+
+		blk_post_runtime_suspend(q, err);
 	}
 
 	/* Insert hooks here for targets, hosts, and transport classes */
@@ -159,8 +174,14 @@ static int scsi_runtime_resume(struct device *dev)
 	int err = 0;
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+		struct request_queue *q = sdev->request_queue;
+
+		blk_pre_runtime_resume(q);
 		err = scsi_dev_type_resume(dev);
+		blk_post_runtime_resume(q, err);
+	}
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
@@ -175,9 +196,10 @@ static int scsi_runtime_idle(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-	if (scsi_is_sdev_device(dev))
-		err = pm_schedule_suspend(dev, 100);
-	else
+	if (scsi_is_sdev_device(dev)) {
+		pm_runtime_mark_last_busy(dev);
+		err = pm_runtime_autosuspend(dev);
+	} else
 		err = pm_runtime_suspend(dev);
 	return err;
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..1e8975f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -895,6 +895,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	 */
 	scsi_autopm_get_device(sdev);
 
+	blk_pm_runtime_init(rq, &sdev->sdev_gendev);
+
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ce03a0a..db45bda 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -967,10 +967,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 	sdev = sdkp->device;
 
-	retval = scsi_autopm_get_device(sdev);
-	if (retval)
-		goto error_autopm;
-
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -1015,8 +1011,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 
 error_out:
-	scsi_autopm_put_device(sdev);
-error_autopm:
 	scsi_disk_put(sdkp);
 	return retval;	
 }
@@ -1051,7 +1045,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_autopm_put_device(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
-- 
1.7.10
