From: Greg KH <gregkh@suse.de>
Subject: [22/27] block: add and use scsi_blk_cmd_ioctl
Date: Mon, 23 Jan 2012 15:41:08 -0800
Message-ID: <20120123234203.558382347@clark.kroah.org>
References: <20120123234224.GA19510@kroah.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
List-Id: linux-scsi@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 577ebb374c78314ac4617242f509e2f5e7156649 upstream.

Introduce a wrapper around scsi_cmd_ioctl that takes a block device.

The function will then be enhanced to detect partition block devices
and, in that case, subject the ioctls to whitelisting.

Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[bwh: Backport to 2.6.32 - adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/scsi_ioctl.c             |    7 +++++++
 drivers/block/cciss.c          |    6 +++---
 drivers/block/ub.c             |    3 +--
 drivers/block/virtio_blk.c     |    4 ++--
 drivers/cdrom/cdrom.c          |    3 +--
 drivers/ide/ide-floppy_ioctl.c |    3 +--
 drivers/scsi/sd.c              |    2 +-
 include/linux/blkdev.h         |    2 ++
 8 files changed, 18 insertions(+), 12 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -689,6 +689,13 @@ int scsi_cmd_ioctl(struct request_queue
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
+int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
+		       unsigned int cmd, void __user *arg)
+{
+	return scsi_cmd_ioctl(bd->bd_disk->queue, bd->bd_disk, mode, cmd, arg);
+}
+EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
+
 int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1583,7 +1583,7 @@ static int cciss_ioctl(struct block_devi
 			return status;
 		}
 
-	/* scsi_cmd_ioctl handles these, below, though some are not */
+	/* scsi_cmd_blk_ioctl handles these, below, though some are not */
 	/* very meaningful for cciss.  SG_IO is the main one people want. */
 
 	case SG_GET_VERSION_NUM:
@@ -1594,9 +1594,9 @@ static int cciss_ioctl(struct block_devi
 	case SG_EMULATED_HOST:
 	case SG_IO:
 	case SCSI_IOCTL_SEND_COMMAND:
-		return scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
+		return scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
 
-	/* scsi_cmd_ioctl would normally handle these, below, but */
+	/* scsi_cmd_blk_ioctl would normally handle these, below, but */
 	/* they aren't a good fit for cciss, as CD-ROMs are */
 	/* not supported, and we don't have any bus/target/lun */
 	/* which we present to the kernel. */
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1726,10 +1726,9 @@ static int ub_bd_release(struct gendisk
 static int ub_bd_ioctl(struct block_device *bdev, fmode_t mode,
     unsigned int cmd, unsigned long arg)
 {
-	struct gendisk *disk = bdev->bd_disk;
 	void __user *usermem = (void __user *) arg;
 
-	return scsi_cmd_ioctl(disk->queue, disk, mode, cmd, usermem);
+	return scsi_cmd_blk_ioctl(bdev, mode, cmd, usermem);
 }
 
 /*
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -200,8 +200,8 @@ static int virtblk_ioctl(struct block_de
 	if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
 		return -ENOTTY;
 
-	return scsi_cmd_ioctl(disk->queue, disk, mode, cmd,
-			      (void __user *)data);
+	return scsi_cmd_blk_ioctl(bdev, mode, cmd,
+				  (void __user *)data);
 }
 
 /* We provide getgeo only to please some old bootloader/partitioning tools */
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2684,12 +2684,11 @@ int cdrom_ioctl(struct cdrom_device_info
 {
 	void __user *argp = (void __user *)arg;
 	int ret;
-	struct gendisk *disk = bdev->bd_disk;
 
 	/*
 	 * Try the generic SCSI command ioctl's first.
 	 */
-	ret = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
+	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
 	if (ret != -ENOTTY)
 		return ret;
 
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -287,8 +287,7 @@ int ide_floppy_ioctl(ide_drive_t *drive,
 	 * and CDROM_SEND_PACKET (legacy) ioctls
 	 */
 	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
-		err = scsi_cmd_ioctl(bdev->bd_disk->queue, bdev->bd_disk,
-				mode, cmd, argp);
+		err = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
 
 	if (err == -ENOTTY)
 		err = generic_ide_ioctl(drive, bdev, cmd, arg);
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -838,7 +838,7 @@ static int sd_ioctl(struct block_device
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			return scsi_ioctl(sdp, cmd, p);
 		default:
-			error = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, p);
+			error = scsi_cmd_blk_ioctl(bdev, mode, cmd, p);
 			if (error != -ENOTTY)
 				return error;
 	}
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -777,6 +777,8 @@ extern void blk_plug_device(struct reque
 extern void blk_plug_device_unlocked(struct request_queue *);
 extern int blk_remove_plug(struct request_queue *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
+extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
+			      unsigned int, void __user *);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			  unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
