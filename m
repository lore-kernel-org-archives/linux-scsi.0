From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [RFC] blktrace interface for sg devices
Date: Thu, 13 Dec 2007 10:09:48 +0100
Message-ID: <20071213090946.GA32110@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:22933 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbXLMJJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 04:09:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org

I am referring to the discussion of introducing statistics in the SCSI
layer and the conclusion that blktrace already provides the data:
http://lkml.org/lkml/2006/10/21/72
http://lkml.org/lkml/2006/11/2/141

While blktrace works fine for disk devices, it currently does not
provide data for non-disk devices like tape drives. To close this gap,
i am looking for a way to get the same trace data also from other SCSI
devices.

Since the SCSI layer internally uses the same request queuest for all
devices and the queues already use the blktrace interface, the main
missing part is the interface to enable the tracing for all SCSI
devices.

Attached is a patch that adds the ioctl interface for blktrace to the
sg generic scsi interface. This already allows to get some trace data
for SCSI tape drives, although i have to do more testing.

For testing, any sg device file can be passed to blktrace, e.g.:
# blktrace -d /dev/sg1 -o - | blkparse -i -

I am seeking input in this approach: Is this approach worth pursuing
to enable blktrace to trace SCSI tape drives? Would there be a better
approach to get this trace data?

Christof Schmitt

---
 block/blktrace.c       |   19 +++++++++++--------
 drivers/scsi/sg.c      |   12 ++++++++++++
 include/linux/blkdev.h |   10 ++++++++++
 3 files changed, 33 insertions(+), 8 deletions(-)

--- a/block/blktrace.c	2007-12-13 08:48:23.000000000 +0100
+++ b/block/blktrace.c	2007-12-13 08:48:25.000000000 +0100
@@ -231,7 +231,7 @@ static void blk_trace_cleanup(struct blk
 	kfree(bt);
 }
 
-static int blk_trace_remove(struct request_queue *q)
+int blk_trace_remove(struct request_queue *q)
 {
 	struct blk_trace *bt;
 
@@ -245,6 +245,7 @@ static int blk_trace_remove(struct reque
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_trace_remove);
 
 static int blk_dropped_open(struct inode *inode, struct file *filp)
 {
@@ -312,13 +313,11 @@ static struct rchan_callbacks blk_relay_
 /*
  * Setup everything required to start tracing
  */
-static int blk_trace_setup(struct request_queue *q, struct block_device *bdev,
-			   char __user *arg)
+int blk_trace_setup(struct request_queue *q, char *name, dev_t dev, char __user *arg)
 {
 	struct blk_user_trace_setup buts;
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
-	char b[BDEVNAME_SIZE];
 	int ret, i;
 
 	if (copy_from_user(&buts, arg, sizeof(buts)))
@@ -327,7 +326,7 @@ static int blk_trace_setup(struct reques
 	if (!buts.buf_size || !buts.buf_nr)
 		return -EINVAL;
 
-	strcpy(buts.name, bdevname(bdev, b));
+	strcpy(buts.name, name);
 
 	/*
 	 * some device names have larger paths - convert the slashes
@@ -355,7 +354,7 @@ static int blk_trace_setup(struct reques
 		goto err;
 
 	bt->dir = dir;
-	bt->dev = bdev->bd_dev;
+	bt->dev = dev;
 	atomic_set(&bt->dropped, 0);
 
 	ret = -EIO;
@@ -400,8 +399,9 @@ err:
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_trace_setup);
 
-static int blk_trace_startstop(struct request_queue *q, int start)
+int blk_trace_startstop(struct request_queue *q, int start)
 {
 	struct blk_trace *bt;
 	int ret;
@@ -434,6 +434,7 @@ static int blk_trace_startstop(struct re
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_trace_startstop);
 
 /**
  * blk_trace_ioctl: - handle the ioctls associated with tracing
@@ -446,6 +447,7 @@ int blk_trace_ioctl(struct block_device 
 {
 	struct request_queue *q;
 	int ret, start = 0;
+	char b[BDEVNAME_SIZE];
 
 	q = bdev_get_queue(bdev);
 	if (!q)
@@ -455,7 +457,8 @@ int blk_trace_ioctl(struct block_device 
 
 	switch (cmd) {
 	case BLKTRACESETUP:
-		ret = blk_trace_setup(q, bdev, arg);
+		strcpy(b, bdevname(bdev, b));
+		ret = blk_trace_setup(q, b, bdev->bd_dev, arg);
 		break;
 	case BLKTRACESTART:
 		start = 1;
--- a/drivers/scsi/sg.c	2007-12-13 08:48:23.000000000 +0100
+++ b/drivers/scsi/sg.c	2007-12-13 08:48:25.000000000 +0100
@@ -55,6 +55,8 @@ static int sg_version_num = 30534;	/* 2 
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
+#include <linux/blktrace_api.h>
+
 #include "scsi_logging.h"
 
 #ifdef CONFIG_SCSI_PROC_FS
@@ -1066,6 +1068,16 @@ sg_ioctl(struct inode *inode, struct fil
 	case BLKSECTGET:
 		return put_user(sdp->device->request_queue->max_sectors * 512,
 				ip);
+	case BLKTRACESETUP:
+	{
+		return blk_trace_setup(sdp->device->request_queue , sdp->device->sdev_gendev.bus_id, &sdp->device->sdev_gendev, arg);
+	}
+	case BLKTRACESTART:
+		return blk_trace_startstop(sdp->device->request_queue, 1);
+	case BLKTRACESTOP:
+		return blk_trace_startstop(sdp->device->request_queue, 0);
+	case BLKTRACETEARDOWN:
+		return blk_trace_remove(sdp->device->request_queue);
 	default:
 		if (read_only)
 			return -EPERM;	/* don't know so take safe approach */
--- a/include/linux/blkdev.h	2007-12-13 08:48:23.000000000 +0100
+++ b/include/linux/blkdev.h	2007-12-13 08:48:25.000000000 +0100
@@ -747,6 +747,16 @@ static inline void blkdev_dequeue_reques
 	elv_dequeue_request(req->q, req);
 }
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+extern int blk_trace_setup(request_queue_t *q,  char * name, dev_t dev, char __user *arg);
+extern int blk_trace_startstop(request_queue_t *q, int start);
+extern int blk_trace_remove(request_queue_t *q);
+#else
+#define blk_trace_setup(q, name, dev, arg) do { } while(0)
+#define blk_trace_startstop(q, start) do { } while(0)
+#define blk_trace_remove(q) do { } while(0)
+#endif
+
 /*
  * Access functions for manipulating queue properties
  */
