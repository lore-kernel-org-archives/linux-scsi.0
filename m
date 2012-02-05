From: Willy Tarreau <w@1wt.eu>
Subject: [PATCH 90/91] block: fail SCSI passthrough ioctls on partition devices
Date: Sun, 05 Feb 2012 23:11:19 +0100
Message-ID: <20120205220953.312427771@pcw.home.local>
References: <0635750f5f06ed2ca212b91fcb5c4483@local>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 0bfc96cb77224736dfa35c3c555d37b3646ef35e upstream.

[ Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_ioctl
  and -ENOIOCTLCMD from sd_compat_ioctl. ]

Linux allows executing the SG_IO ioctl on a partition or LVM volume, and
will pass the command to the underlying block device.  This is
well-known, but it is also a large security problem when (via Unix
permissions, ACLs, SELinux or a combination thereof) a program or user
needs to be granted access only to part of the disk.

This patch lets partitions forward a small set of harmless ioctls;
others are logged with printk so that we can see which ioctls are
actually sent.  In my tests only CDROM_GET_CAPABILITY actually occurred.
Of course it was being sent to a (partition on a) hard disk, so it would
have failed with ENOTTY and the patch isn't changing anything in
practice.  Still, I'm treating it specially to avoid spamming the logs.

In principle, this restriction should include programs running with
CAP_SYS_RAWIO.  If for example I let a program access /dev/sda2 and
/dev/sdb, it still should not be able to read/write outside the
boundaries of /dev/sda2 independent of the capabilities.  However, for
now programs with CAP_SYS_RAWIO will still be allowed to send the
ioctls.  Their actions will still be logged.

This patch does not affect the non-libata IDE driver.  That driver
however already tests for bd != bd->bd_contains before issuing some
ioctl; it could be restricted further to forbid these ioctls even for
programs running with CAP_SYS_ADMIN/CAP_SYS_RAWIO.

Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ Make it also print the command name when warning - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backport to 2.6.32 - ENOIOCTLCMD does not get converted to
 ENOTTY, so we must return ENOTTY directly]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[wt: no scsi_cmd_blk_ioctl in 2.6.27, change callers instead. cciss is OK,
 ub,virtio_blk,ide-floppy,sd need fixing, cdrom&st can be ignored ]

---
 block/scsi_ioctl.c     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      |   11 +++++++++--
 include/linux/blkdev.h |    1 +
 3 files changed, 55 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/block/scsi_ioctl.c
===================================================================
--- longterm-2.6.27.orig/block/scsi_ioctl.c	2012-02-05 22:34:32.181915026 +0100
+++ longterm-2.6.27/block/scsi_ioctl.c	2012-02-05 22:39:32.090915159 +0100
@@ -653,3 +653,43 @@
 }
 
 EXPORT_SYMBOL(scsi_cmd_ioctl);
+
+int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
+{
+	if (bd && bd == bd->bd_contains)
+		return 0;
+
+	/* Actually none of these is particularly useful on a partition,
+	 * but they are safe.
+	 */
+	switch (cmd) {
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+	case SCSI_IOCTL_GET_PCI:
+	case SCSI_IOCTL_PROBE_HOST:
+	case SG_GET_VERSION_NUM:
+	case SG_SET_TIMEOUT:
+	case SG_GET_TIMEOUT:
+	case SG_GET_RESERVED_SIZE:
+	case SG_SET_RESERVED_SIZE:
+	case SG_EMULATED_HOST:
+		return 0;
+	case CDROM_GET_CAPABILITY:
+		/* Keep this until we remove the printk below.  udev sends it
+		 * and we do not want to spam dmesg about it.   CD-ROMs do
+		 * not have partitions, so we get here only for disks.
+		 */
+		return -ENOTTY;
+	default:
+		break;
+	}
+
+	/* In particular, rule out all resets and host-specific ioctls.  */
+	if (printk_ratelimit())
+		printk(KERN_WARNING
+			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
+
+	return capable(CAP_SYS_RAWIO) ? 0 : -ENOTTY;
+}
+EXPORT_SYMBOL(scsi_verify_blk_ioctl);
+
Index: longterm-2.6.27/drivers/scsi/sd.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/sd.c	2012-02-05 22:34:32.191915216 +0100
+++ longterm-2.6.27/drivers/scsi/sd.c	2012-02-05 22:34:47.717916292 +0100
@@ -749,6 +749,10 @@
 	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
 						disk->disk_name, cmd));
 
+	error = scsi_verify_blk_ioctl(bdev, cmd);
+	if (error < 0)
+		return error;
+
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
 	 * else try and use this device.  Also, if error recovery fails, it
@@ -927,6 +931,11 @@
 	struct block_device *bdev = file->f_path.dentry->d_inode->i_bdev;
 	struct gendisk *disk = bdev->bd_disk;
 	struct scsi_device *sdev = scsi_disk(disk)->device;
+	int ret;
+
+	ret = scsi_verify_blk_ioctl(bdev, cmd);
+	if (ret < 0)
+		return -ENOIOCTLCMD;
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
@@ -938,8 +947,6 @@
 		return -ENODEV;
 	       
 	if (sdev->host->hostt->compat_ioctl) {
-		int ret;
-
 		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 
 		return ret;
Index: longterm-2.6.27/include/linux/blkdev.h
===================================================================
--- longterm-2.6.27.orig/include/linux/blkdev.h	2012-02-05 22:34:32.200915634 +0100
+++ longterm-2.6.27/include/linux/blkdev.h	2012-02-05 22:34:47.724916417 +0100
@@ -669,6 +669,7 @@
 extern void blk_plug_device_unlocked(struct request_queue *);
 extern int blk_remove_plug(struct request_queue *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
+extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_ioctl(struct file *, struct request_queue *,
 			  struct gendisk *, unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct file *, struct request_queue *,
Index: longterm-2.6.27/drivers/block/ub.c
===================================================================
--- longterm-2.6.27.orig/drivers/block/ub.c	2012-02-05 22:34:32.188915006 +0100
+++ longterm-2.6.27/drivers/block/ub.c	2012-02-05 22:34:47.731916501 +0100
@@ -1731,7 +1731,11 @@
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	void __user *usermem = (void __user *) arg;
+	int ret;
 
+	ret = scsi_verify_blk_ioctl(inode->i_bdev, cmd);
+	if (ret < 0)
+		return ret;
 	return scsi_cmd_ioctl(filp, disk->queue, disk, cmd, usermem);
 }
 
Index: longterm-2.6.27/drivers/block/virtio_blk.c
===================================================================
--- longterm-2.6.27.orig/drivers/block/virtio_blk.c	2012-02-05 22:34:32.185914704 +0100
+++ longterm-2.6.27/drivers/block/virtio_blk.c	2012-02-05 22:34:47.735917527 +0100
@@ -149,6 +149,12 @@
 static int virtblk_ioctl(struct inode *inode, struct file *filp,
 			 unsigned cmd, unsigned long data)
 {
+	int ret;
+
+	ret = scsi_verify_blk_ioctl(inode->i_bdev, cmd);
+	if (ret < 0)
+		return ret;
+
 	return scsi_cmd_ioctl(filp, inode->i_bdev->bd_disk->queue,
 			      inode->i_bdev->bd_disk, cmd,
 			      (void __user *)data);
Index: longterm-2.6.27/drivers/ide/ide-floppy.c
===================================================================
--- longterm-2.6.27.orig/drivers/ide/ide-floppy.c	2012-02-05 22:34:32.195915402 +0100
+++ longterm-2.6.27/drivers/ide/ide-floppy.c	2012-02-05 22:34:47.741917013 +0100
@@ -1336,9 +1336,12 @@
 	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
 	 * and CDROM_SEND_PACKET (legacy) ioctls
 	 */
-	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
-		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
-					bdev->bd_disk, cmd, argp);
+	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND) {
+		err = scsi_verify_blk_ioctl(bdev, cmd);
+		if (err == 0)
+			err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
+			                     bdev->bd_disk, cmd, argp);
+	}
 	else
 		err = -ENOTTY;
 
