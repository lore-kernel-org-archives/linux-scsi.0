From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] add a request_queue argument to scsi_cmd_ioctl()
Date: Tue, 20 Mar 2007 23:48:54 +0900 (JST)
Message-ID: <20070320213111L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43678 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbXCTOtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 10:49:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

bsg uses scsi_cmd_ioctl() for some SCSI/sg ioctl
commands. scsi_cmd_ioctl() gets a request queue from a gendisk
arguement. This prevents bsg being bound to SCSI devices that don't
have a gendisk (like OSD). This adds a request_queue argument to
scsi_cmd_ioctl(). The SCSI/sg ioctl commands doesn't use a gendisk so
it's safe for any SCSI devices to use scsi_cmd_ioctl().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c            |    2 +-
 block/scsi_ioctl.c     |   10 +++-------
 drivers/block/ub.c     |    2 +-
 drivers/cdrom/cdrom.c  |    3 ++-
 drivers/ide/ide.c      |    2 +-
 drivers/scsi/sd.c      |    2 +-
 drivers/scsi/st.c      |    3 ++-
 include/linux/blkdev.h |    3 ++-
 8 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index c85d961..0427ece 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -900,7 +900,7 @@ bsg_ioctl(struct inode *inode, struct fi
 	case SG_EMULATED_HOST:
 	case SCSI_IOCTL_SEND_COMMAND: {
 		void __user *uarg = (void __user *) arg;
-		return scsi_cmd_ioctl(file, bd->disk, cmd, uarg);
+		return scsi_cmd_ioctl(file, bd->queue, bd->disk, cmd, uarg);
 	}
 	case SG_IO: {
 		struct request *rq;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 18e935f..31bbbb4 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -546,16 +546,12 @@ static inline int blk_send_start_stop(re
 	return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);
 }
 
-int scsi_cmd_ioctl(struct file *file, struct gendisk *bd_disk, unsigned int cmd, void __user *arg)
+int scsi_cmd_ioctl(struct file *file, struct request_queue *q,
+		   struct gendisk *bd_disk, unsigned int cmd, void __user *arg)
 {
-	request_queue_t *q;
 	int err;
 
-	q = bd_disk->queue;
-	if (!q)
-		return -ENXIO;
-
-	if (blk_get_queue(q))
+	if (!q || blk_get_queue(q))
 		return -ENXIO;
 
 	switch (cmd) {
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 2098eff..20bdbbf 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1713,7 +1713,7 @@ static int ub_bd_ioctl(struct inode *ino
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	void __user *usermem = (void __user *) arg;
 
-	return scsi_cmd_ioctl(filp, disk, cmd, usermem);
+	return scsi_cmd_ioctl(filp, disk->queue, disk, cmd, usermem);
 }
 
 /*
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 3105ddd..ef51aac 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2695,11 +2695,12 @@ int cdrom_ioctl(struct file * file, stru
 {
 	void __user *argp = (void __user *)arg;
 	int ret;
+	struct gendisk *disk = ip->i_bdev->bd_disk;
 
 	/*
 	 * Try the generic SCSI command ioctl's first.
 	 */
-	ret = scsi_cmd_ioctl(file, ip->i_bdev->bd_disk, cmd, argp);
+	ret = scsi_cmd_ioctl(file, disk->queue, disk, cmd, argp);
 	if (ret != -ENOTTY)
 		return ret;
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index e260259..d51212c 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1277,7 +1277,7 @@ int generic_ide_ioctl(ide_drive_t *drive
 	void __user *p = (void __user *)arg;
 	int err;
 
-	err = scsi_cmd_ioctl(file, bdev->bd_disk, cmd, p);
+	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
 	if (err != -ENOTTY)
 		return err;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b781a90..63d6eef 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -705,7 +705,7 @@ static int sd_ioctl(struct inode * inode
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			return scsi_ioctl(sdp, cmd, p);
 		default:
-			error = scsi_cmd_ioctl(filp, disk, cmd, p);
+			error = scsi_cmd_ioctl(filp, disk->queue, disk, cmd, p);
 			if (error != -ENOTTY)
 				return error;
 	}
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3d2e023..d92384f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3548,7 +3548,8 @@ static int st_ioctl(struct inode *inode,
 			    !capable(CAP_SYS_RAWIO))
 				i = -EPERM;
 			else
-				i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
+				i = scsi_cmd_ioctl(file, STp->disk->queue,
+						   STp->disk, cmd_in, p);
 			if (i != -ENOTTY)
 				return i;
 			break;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aa000d2..6370d44 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -643,7 +643,8 @@ extern void blk_requeue_request(request_
 extern void blk_plug_device(request_queue_t *);
 extern int blk_remove_plug(request_queue_t *);
 extern void blk_recount_segments(request_queue_t *, struct bio *);
-extern int scsi_cmd_ioctl(struct file *, struct gendisk *, unsigned int, void __user *);
+extern int scsi_cmd_ioctl(struct file *, struct request_queue *,
+			  struct gendisk *, unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct file *, struct request_queue *,
 		struct gendisk *, struct scsi_ioctl_command __user *);
 
-- 
1.4.3.2

