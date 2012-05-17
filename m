From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC v2 PATCH 4/4] [SCSI] sd: change to auto suspend mode
Date: Thu, 17 May 2012 23:48:06 +0800
Message-ID: <1337269686-3781-5-git-send-email-ming.m.lin@intel.com>
References: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Now we don't need to do runtime pm get/put on open/release/remove path.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c |    7 ++++---
 drivers/scsi/sd.c      |   14 +++++---------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index c467064..a133345 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -171,9 +171,10 @@ static int scsi_runtime_idle(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-	if (scsi_is_sdev_device(dev))
-		err = pm_schedule_suspend(dev, 100);
-	else
+	if (scsi_is_sdev_device(dev)) {
+		pm_runtime_mark_last_busy(dev);
+		err = pm_request_autosuspend(dev);
+	} else
 		err = pm_runtime_suspend(dev);
 	return err;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c3c8e7..97b5a67 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -985,10 +985,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 	sdev = sdkp->device;
 
-	retval = scsi_autopm_get_device(sdev);
-	if (retval)
-		goto error_autopm;
-
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -1033,8 +1029,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 
 error_out:
-	scsi_autopm_put_device(sdev);
-error_autopm:
 	scsi_disk_put(sdkp);
 	return retval;	
 }
@@ -1069,7 +1063,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_autopm_put_device(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
@@ -2638,6 +2631,10 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	blk_queue_runtime_pm(sdp->request_queue,
 		sd_block_runtime_suspend, sd_block_runtime_resume);
 
+	pm_runtime_use_autosuspend(&sdp->sdev_gendev);
+	/* Set to 10 secs for test only, user can reset it via sysfs */
+	pm_runtime_set_autosuspend_delay(&sdp->sdev_gendev, 10 * 1000);
+
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
 	if (sdp->removable) {
@@ -2652,7 +2649,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-	scsi_autopm_put_device(sdp);
+	pm_runtime_put_sync_autosuspend(&sdp->sdev_gendev);
 	put_device(&sdkp->dev);
 }
 
@@ -2776,7 +2773,6 @@ static int sd_remove(struct device *dev)
 	struct scsi_disk *sdkp;
 
 	sdkp = dev_get_drvdata(dev);
-	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full();
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
-- 
1.7.2.5
