From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] blktrace: Add blktrace ioctls to SCSI generic devices
Date: Tue, 18 Dec 2007 10:06:48 +0100
Message-ID: <20071218090648.GA6178@schmichrtp.de.ibm.com>
References: <20071213090946.GA32110@schmichrtp.de.ibm.com> <20071213091942.GB10113@kernel.dk> <20071213162332.GA16902@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:51646 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbXLRJGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 04:06:52 -0500
Content-Disposition: inline
In-Reply-To: <20071213162332.GA16902@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org

Since the SCSI layer uses the request queues from the block layer,
blktrace can also be used to trace the requests to all SCSI devices
(like SCSI tape drives), not only disks. The only missing part is the
ioctl interface to start and stop tracing.

This patch adds the SETUP, START, STOP and TEARDOWN ioctls from
blktrace to the sg device files. With this change, blktrace can be
used for SCSI devices like for disks, e.g.:
blktrace -d /dev/sg1 -o - | blkparse -i -

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 block/blktrace.c             |   24 ++++++++++++++----------
 block/compat_ioctl.c         |    5 ++++-
 drivers/scsi/sg.c            |   12 ++++++++++++
 include/linux/blktrace_api.h |   12 ++++++++++--
 4 files changed, 40 insertions(+), 13 deletions(-)

--- a/block/blktrace.c	2007-12-17 21:51:45.000000000 +0100
+++ b/block/blktrace.c	2007-12-17 21:51:45.000000000 +0100
@@ -236,7 +236,7 @@ static void blk_trace_cleanup(struct blk
 	kfree(bt);
 }
 
-static int blk_trace_remove(struct request_queue *q)
+int blk_trace_remove(struct request_queue *q)
 {
 	struct blk_trace *bt;
 
@@ -250,6 +250,7 @@ static int blk_trace_remove(struct reque
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_trace_remove);
 
 static int blk_dropped_open(struct inode *inode, struct file *filp)
 {
@@ -317,18 +318,17 @@ static struct rchan_callbacks blk_relay_
 /*
  * Setup everything required to start tracing
  */
-int do_blk_trace_setup(struct request_queue *q, struct block_device *bdev,
+int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 			struct blk_user_trace_setup *buts)
 {
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
-	char b[BDEVNAME_SIZE];
 	int ret, i;
 
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
 
-	strcpy(buts->name, bdevname(bdev, b));
+	strcpy(buts->name, name);
 
 	/*
 	 * some device names have larger paths - convert the slashes
@@ -353,7 +353,7 @@ int do_blk_trace_setup(struct request_qu
 		goto err;
 
 	bt->dir = dir;
-	bt->dev = bdev->bd_dev;
+	bt->dev = dev;
 	atomic_set(&bt->dropped, 0);
 
 	ret = -EIO;
@@ -400,8 +400,8 @@ err:
 	return ret;
 }
 
-static int blk_trace_setup(struct request_queue *q, struct block_device *bdev,
-			   char __user *arg)
+int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+		    char __user *arg)
 {
 	struct blk_user_trace_setup buts;
 	int ret;
@@ -410,7 +410,7 @@ static int blk_trace_setup(struct reques
 	if (ret)
 		return -EFAULT;
 
-	ret = do_blk_trace_setup(q, bdev, &buts);
+	ret = do_blk_trace_setup(q, name, dev, &buts);
 	if (ret)
 		return ret;
 
@@ -419,8 +419,9 @@ static int blk_trace_setup(struct reques
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_trace_setup);
 
-static int blk_trace_startstop(struct request_queue *q, int start)
+int blk_trace_startstop(struct request_queue *q, int start)
 {
 	struct blk_trace *bt;
 	int ret;
@@ -453,6 +454,7 @@ static int blk_trace_startstop(struct re
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_trace_startstop);
 
 /**
  * blk_trace_ioctl: - handle the ioctls associated with tracing
@@ -465,6 +467,7 @@ int blk_trace_ioctl(struct block_device 
 {
 	struct request_queue *q;
 	int ret, start = 0;
+	char b[BDEVNAME_SIZE];
 
 	q = bdev_get_queue(bdev);
 	if (!q)
@@ -474,7 +477,8 @@ int blk_trace_ioctl(struct block_device 
 
 	switch (cmd) {
 	case BLKTRACESETUP:
-		ret = blk_trace_setup(q, bdev, arg);
+		strcpy(b, bdevname(bdev, b));
+		ret = blk_trace_setup(q, b, bdev->bd_dev, arg);
 		break;
 	case BLKTRACESTART:
 		start = 1;
--- a/drivers/scsi/sg.c	2007-12-17 21:51:45.000000000 +0100
+++ b/drivers/scsi/sg.c	2007-12-17 22:36:30.000000000 +0100
@@ -48,6 +48,7 @@ static int sg_version_num = 30534;	/* 2 
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/blktrace_api.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -1063,6 +1064,17 @@ sg_ioctl(struct inode *inode, struct fil
 	case BLKSECTGET:
 		return put_user(sdp->device->request_queue->max_sectors * 512,
 				ip);
+	case BLKTRACESETUP:
+		return blk_trace_setup(sdp->device->request_queue,
+				       sdp->disk->disk_name,
+				       sdp->device->sdev_gendev.devt,
+				       (char *)arg);
+	case BLKTRACESTART:
+		return blk_trace_startstop(sdp->device->request_queue, 1);
+	case BLKTRACESTOP:
+		return blk_trace_startstop(sdp->device->request_queue, 0);
+	case BLKTRACETEARDOWN:
+		return blk_trace_remove(sdp->device->request_queue);
 	default:
 		if (read_only)
 			return -EPERM;	/* don't know so take safe approach */
--- a/include/linux/blktrace_api.h	2007-12-17 21:51:45.000000000 +0100
+++ b/include/linux/blktrace_api.h	2007-12-17 21:53:59.000000000 +0100
@@ -148,7 +148,7 @@ extern int blk_trace_ioctl(struct block_
 extern void blk_trace_shutdown(struct request_queue *);
 extern void __blk_add_trace(struct blk_trace *, sector_t, int, int, u32, int, int, void *);
 extern int do_blk_trace_setup(struct request_queue *q,
-	struct block_device *bdev, struct blk_user_trace_setup *buts);
+	char *name, dev_t dev, struct blk_user_trace_setup *buts);
 
 
 /**
@@ -282,6 +282,11 @@ static inline void blk_add_trace_remap(s
 	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
 }
 
+extern int blk_trace_setup(request_queue_t *q, char *name, dev_t dev,
+			   char __user *arg);
+extern int blk_trace_startstop(request_queue_t *q, int start);
+extern int blk_trace_remove(request_queue_t *q);
+
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 #define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 #define blk_trace_shutdown(q)			do { } while (0)
@@ -290,7 +295,10 @@ static inline void blk_add_trace_remap(s
 #define blk_add_trace_generic(q, rq, rw, what)	do { } while (0)
 #define blk_add_trace_pdu_int(q, what, bio, pdu)	do { } while (0)
 #define blk_add_trace_remap(q, bio, dev, f, t)	do {} while (0)
-#define do_blk_trace_setup(q, bdev, buts)	(-ENOTTY)
+#define do_blk_trace_setup(q, name, dev, buts)	(-ENOTTY)
+#define blk_trace_setup(q, name, dev, arg)	(-ENOTTY)
+#define blk_trace_startstop(q, start)		(-ENOTTY)
+#define blk_trace_remove(q)			(-ENOTTY)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 #endif /* __KERNEL__ */
 #endif
--- a/block/compat_ioctl.c	2007-12-17 21:51:45.000000000 +0100
+++ b/block/compat_ioctl.c	2007-12-17 21:51:44.000000000 +0100
@@ -545,6 +545,7 @@ static int compat_blk_trace_setup(struct
 	struct blk_user_trace_setup buts;
 	struct compat_blk_user_trace_setup cbuts;
 	struct request_queue *q;
+	char b[BDEVNAME_SIZE];
 	int ret;
 
 	q = bdev_get_queue(bdev);
@@ -554,6 +555,8 @@ static int compat_blk_trace_setup(struct
 	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
 		return -EFAULT;
 
+	strcpy(b, bdevname(bdev, b));
+
 	buts = (struct blk_user_trace_setup) {
 		.act_mask = cbuts.act_mask,
 		.buf_size = cbuts.buf_size,
@@ -565,7 +568,7 @@ static int compat_blk_trace_setup(struct
 	memcpy(&buts.name, &cbuts.name, 32);
 
 	mutex_lock(&bdev->bd_mutex);
-	ret = do_blk_trace_setup(q, bdev, &buts);
+	ret = do_blk_trace_setup(q, b, bdev->bd_dev, &buts);
 	mutex_unlock(&bdev->bd_mutex);
 	if (ret)
 		return ret;
