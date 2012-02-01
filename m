From: Greg KH <gregkh@linuxfoundation.org>
Subject: [08/20] block: fail SCSI passthrough ioctls on partition devices
Date: Wed, 01 Feb 2012 12:14:10 -0800
Message-ID: <20120201201531.749434206@clark.kroah.org>
References: <20120201210055.GA25374@kroah.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54374 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757234Ab2BAVL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2012 16:11:59 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 130F921218
	for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2012 16:07:56 -0500 (EST)
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Ben Hutchings <ben@decadent.org.uk>

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Paolo Bonzini <pbonzini@redhat.com>

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

---
 block/scsi_ioctl.c     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      |   11 +++++++++--
 include/linux/blkdev.h |    1 +
 3 files changed, 55 insertions(+), 2 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -24,6 +24,7 @@
 #include <linux/capability.h>
 #include <linux/completion.h>
 #include <linux/cdrom.h>
+#include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/times.h>
 #include <asm/uaccess.h>
@@ -689,9 +690,53 @@ int scsi_cmd_ioctl(struct request_queue
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
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
+	printk_ratelimited(KERN_WARNING
+			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
+
+	return capable(CAP_SYS_RAWIO) ? 0 : -ENOTTY;
+}
+EXPORT_SYMBOL(scsi_verify_blk_ioctl);
+
 int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
 		       unsigned int cmd, void __user *arg)
 {
+	int ret;
+
+	ret = scsi_verify_blk_ioctl(bd, cmd);
+	if (ret < 0)
+		return ret;
+
 	return scsi_cmd_ioctl(bd->bd_disk->queue, bd->bd_disk, mode, cmd, arg);
 }
 EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -817,6 +817,10 @@ static int sd_ioctl(struct block_device
 	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
 						disk->disk_name, cmd));
 
+	error = scsi_verify_blk_ioctl(bdev, cmd);
+	if (error < 0)
+		return error;
+
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
 	 * else try and use this device.  Also, if error recovery fails, it
@@ -996,6 +1000,11 @@ static int sd_compat_ioctl(struct block_
 			   unsigned int cmd, unsigned long arg)
 {
 	struct scsi_device *sdev = scsi_disk(bdev->bd_disk)->device;
+	int ret;
+
+	ret = scsi_verify_blk_ioctl(bdev, cmd);
+	if (ret < 0)
+		return -ENOIOCTLCMD;
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
@@ -1007,8 +1016,6 @@ static int sd_compat_ioctl(struct block_
 		return -ENODEV;
 	       
 	if (sdev->host->hostt->compat_ioctl) {
-		int ret;
-
 		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 
 		return ret;
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -777,6 +777,7 @@ extern void blk_plug_device(struct reque
 extern void blk_plug_device_unlocked(struct request_queue *);
 extern int blk_remove_plug(struct request_queue *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
+extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
 			      unsigned int, void __user *);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,


