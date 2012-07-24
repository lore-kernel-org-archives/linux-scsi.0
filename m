From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 3/7] scsi: sr: use scsi layer autopm in sr driver
Date: Tue, 24 Jul 2012 17:37:41 +0800
Message-ID: <1343122665-18711-4-git-send-email-aaron.lu@amd.com>
References: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

Use scsi_autopm_* whenever possible instead of the pm_runtime_* in sr
driver as suggested by Alan Stern.

The reason pm_runtime_get_noresume in sr_suspend is used is that we
can't do sync resume call in suspend callback, or rpm_resume will wait
forever for the suspend request to finish.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
V2:
Use scsi_autopm_* instead of pm_runtime_* in sr driver as suggested
by Alan Stern.

 drivers/scsi/sr.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 225848c..e54945a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -377,10 +377,8 @@ do_tur:
 		 * thread (in-kernel polling) and old versions of udisks,
 		 * to avoid put the device twice, an atomic operation is used.
 		 */
-		if (poweroff && atomic_add_unless(&cd->suspend_count, -1, 0)) {
-			pm_runtime_mark_last_busy(&cd->device->sdev_gendev);
-			pm_runtime_put_autosuspend(&cd->device->sdev_gendev);
-		}
+		if (poweroff && atomic_add_unless(&cd->suspend_count, -1, 0))
+			scsi_autopm_put_device(cd->device);
 	}
 
 	if (cd->ignore_get_event)
@@ -655,11 +653,8 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	int ret;
 
 	/* Make sure the ODD is not suspended */
-	ret = pm_runtime_get_sync(&sdev->sdev_gendev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(&sdev->sdev_gendev);
+	if (scsi_autopm_get_device(sdev))
 		return -EACCES;
-	}
 
 	mutex_lock(&sr_mutex);
 
@@ -692,8 +687,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
-	pm_runtime_mark_last_busy(&cd->device->sdev_gendev);
-	pm_runtime_put_autosuspend(&cd->device->sdev_gendev);
+	scsi_autopm_put_device(sdev);
 	return ret;
 }
 
@@ -1121,7 +1115,7 @@ static int sr_remove(struct device *dev)
 
 	/* disable runtime pm and possibly resume the device */
 	if (!atomic_dec_and_test(&cd->suspend_count))
-		pm_runtime_get_sync(dev);
+		scsi_autopm_get_device(cd->device);
 
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
-- 
1.7.11.3
