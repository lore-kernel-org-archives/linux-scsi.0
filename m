From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] scsi/sd: remove big kernel lock
Date: Wed,  7 Jul 2010 16:51:29 +0200
Message-ID: <1278514289-21054-8-git-send-email-arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab0GGOvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 10:51:51 -0400
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <James.Bottomley@suse.de>

Every user of the BKL in the sd driver is the
result of the pushdown from the block layer
into the open/close/ioctl functions.

The only place that used to rely on the BKL is
the sdkp->openers variable, which gets converted
into an atomic_t.

Nothing else seems to rely on the BKL, since the
functions do not touch global data without holding
another lock, and the open/close functions are
still protected from concurrent execution using
the bdev->bd_mutex.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
---
 drivers/scsi/sd.c |   17 +++++++----------
 drivers/scsi/sd.h |    2 +-
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cf1441f..a0142a7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -746,6 +746,8 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
  *	or from within the kernel (e.g. as a result of a mount(1) ).
  *	In the latter case @inode and @filp carry an abridged amount
  *	of information as noted above.
+ *
+ *	Locking: called with bdev->bd_mutex held.
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
@@ -758,7 +760,6 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
 
-	lock_kernel();
 	sdev = sdkp->device;
 
 	/*
@@ -797,17 +798,15 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	if (!scsi_device_online(sdev))
 		goto error_out;
 
-	if (!sdkp->openers++ && sdev->removable) {
+	if ((atomic_inc_return(&sdkp->openers) == 1) && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
-	unlock_kernel();
 	return 0;
 
 error_out:
 	scsi_disk_put(sdkp);
-	unlock_kernel();
 	return retval;	
 }
 
@@ -821,6 +820,8 @@ error_out:
  *
  *	Note: may block (uninterruptible) if error recovery is underway
  *	on this disk.
+ *
+ *	Locking: called with bdev->bd_mutex held.
  **/
 static int sd_release(struct gendisk *disk, fmode_t mode)
 {
@@ -829,8 +830,7 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
-	lock_kernel();
-	if (!--sdkp->openers && sdev->removable) {
+	if (atomic_dec_return(&sdkp->openers) && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
@@ -840,7 +840,6 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 	scsi_disk_put(sdkp);
-	unlock_kernel();
 	return 0;
 }
 
@@ -893,7 +892,6 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
 						disk->disk_name, cmd));
 
-	lock_kernel();
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
 	 * else try and use this device.  Also, if error recovery fails, it
@@ -923,7 +921,6 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 			break;
 	}
 out:
-	unlock_kernel();
 	return error;
 }
 
@@ -2317,7 +2314,7 @@ static int sd_probe(struct device *dev)
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
 	sdkp->index = index;
-	sdkp->openers = 0;
+	atomic_set(&sdkp->openers, 0);
 	sdkp->previous_state = 1;
 
 	if (!sdp->request_queue->rq_timeout) {
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 43d3caf..f81a930 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -47,7 +47,7 @@ struct scsi_disk {
 	struct scsi_device *device;
 	struct device	dev;
 	struct gendisk	*disk;
-	unsigned int	openers;	/* protected by BKL for now, yuck */
+	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		index;
 	unsigned short	hw_sector_size;
-- 
1.7.0.4

