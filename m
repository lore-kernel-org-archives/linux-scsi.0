From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 4/7] scsi: sr: runtime pm when ODD is open/closed
Date: Tue, 24 Jul 2012 17:37:42 +0800
Message-ID: <1343122665-18711-5-git-send-email-aaron.lu@amd.com>
References: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

The ODD can either be runtime resumed by the user or by a software
request. And for the latter part, we only support runtime resume the ODD
when the eject request is received. We did this in sr's block ioctl
function, this looks ugly.

Change this by runtime resuming the ODD in its open function and runtime
suspending it in its release function.

The downside of this approach is that in old distros with old udisk
daemon, the ODD will be polled by udisk daemon so open/close will
constantly be called, which will cause the ODD frequently resume from
suspend state, breaking the effect of power saving. User with such a
distro is advised to issue a udisk command to inhibit polling of the
disk like this:
$ udisks --inhibit-polling /dev/sr0
And since newer kernel has in kernel polling, there is no problem
regarding ODD's event report.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e54945a..2aa50c3 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -152,8 +152,12 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
+	if (scsi_autopm_get_device(cd->device))
+		goto out_pm;
 	goto out;
 
+ out_pm:
+	scsi_device_put(cd->device);
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
 	cd = NULL;
@@ -169,6 +173,7 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
@@ -652,10 +657,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	/* Make sure the ODD is not suspended */
-	if (scsi_autopm_get_device(sdev))
-		return -EACCES;
-
 	mutex_lock(&sr_mutex);
 
 	/*
@@ -687,7 +688,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
-	scsi_autopm_put_device(sdev);
 	return ret;
 }
 
-- 
1.7.11.3


