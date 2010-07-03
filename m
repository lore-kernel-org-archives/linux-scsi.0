From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/6] scsi/sd: remove big kernel lock
Date: Sat,  3 Jul 2010 23:47:20 +0200
Message-ID: <1278193640-24223-7-git-send-email-arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278193640-24223-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

Every user of the BKL in the sd driver is the
result of the pushdown from the block layer
into the open/close/ioctl functions.

None of them seem to rely on the BKL, since they
do not touch global data without holding
another lock, and the open/close functions are
still protected from concurrent execution using
the bdev->bd_mutex.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
---
 drivers/scsi/sd.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 92702b3..2733068 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -758,7 +758,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
 
-	lock_kernel();
 	sdev = sdkp->device;
 
 	/*
@@ -802,12 +801,10 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
-	unlock_kernel();
 	return 0;
 
 error_out:
 	scsi_disk_put(sdkp);
-	unlock_kernel();
 	return retval;	
 }
 
@@ -829,7 +826,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
-	lock_kernel();
 	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
@@ -840,7 +836,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 	scsi_disk_put(sdkp);
-	unlock_kernel();
 	return 0;
 }
 
@@ -921,18 +916,6 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	return scsi_ioctl(sdp, cmd, p);
 }
 
-static int sd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
-			     unsigned int cmd, unsigned long arg)
-{
-	int ret;
-
-	lock_kernel();
-	ret = sd_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
-
-	return ret;
-}
-
 static void set_media_not_present(struct scsi_disk *sdkp)
 {
 	sdkp->media_present = 0;
@@ -1113,7 +1096,7 @@ static const struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
 	.release		= sd_release,
-	.ioctl			= sd_unlocked_ioctl,
+	.ioctl			= sd_ioctl,
 	.getgeo			= sd_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sd_compat_ioctl,
-- 
1.7.1
