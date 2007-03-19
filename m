From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Mon, 19 Mar 2007 19:25:34 +0900
Message-ID: <20070319192534A.fujita.tomonori@lab.ntt.co.jp>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
	<20070214212456.GA17937@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:49011 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXCSKZg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 06:25:36 -0400
In-Reply-To: <20070214212456.GA17937@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com, hch@infradead.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Wed, 14 Feb 2007 22:25:00 +0100

> On Wed, Feb 14 2007, FUJITA Tomonori wrote:
> > It seems that it would be better to bind bsg devices to request_queue
> > instead of gendisk. This enables any objects to define own
> > request_handler and create own bsg device (under sysfs).
> > 
> > Possible enhancements:
> > 
> > - I removed gendisk but it would be better for objects having gendisk
> > to keep it for nice features like disk stats.
> > 
> > - Objects that wants to use bsg need to setup a request_queue. Maybe
> > wrapper functions to setup a request_queue for them would be useful.
> > 
> > This patch was tested only with disk drivers.
> 
> Looks good, as discussed in-person I just want to change the _rq name as
> that usually implies "struct request" in the block layer. _queue is much
> better.

Here is a resend though including the following updates.

- bsg_register/unregister_rq are renamed bsg_register/unregister_queue

- fix !CONFIG_BLK_DEV_BSG compilation

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This binds bsg devices to request_queue instead of gendisk. It enables
any objects (like transport entities) to define own request_handler
and create own bsg device.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c            |   37 +++++++++++++++++--------------------
 block/ll_rw_blk.c      |    4 ++--
 include/linux/blkdev.h |    5 +++++
 include/linux/bsg.h    |   10 +++++-----
 include/linux/genhd.h  |    2 --
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index c85d961..b64d004 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -34,7 +34,6 @@ #include <scsi/sg.h>
 static char bsg_version[] = "block layer sg (bsg) 0.4";
 
 struct bsg_device {
-	struct gendisk *disk;
 	request_queue_t *queue;
 	spinlock_t lock;
 	struct list_head busy_list;
@@ -46,7 +45,7 @@ struct bsg_device {
 	int done_cmds;
 	wait_queue_head_t wq_done;
 	wait_queue_head_t wq_free;
-	char name[BDEVNAME_SIZE];
+	char name[BUS_ID_SIZE];
 	int max_queue;
 	unsigned long flags;
 };
@@ -375,7 +374,7 @@ static void bsg_add_command(struct bsg_d
 	dprintk("%s: queueing rq %p, bc %p\n", bd->name, rq, bc);
 
 	rq->end_io_data = bc;
-	blk_execute_rq_nowait(q, bd->disk, rq, 1, bsg_rq_end_io);
+	blk_execute_rq_nowait(q, NULL, rq, 1, bsg_rq_end_io);
 }
 
 static inline struct bsg_command *bsg_next_done_cmd(struct bsg_device *bd)
@@ -741,7 +740,7 @@ out:
 }
 
 static struct bsg_device *bsg_add_device(struct inode *inode,
-					 struct gendisk *disk,
+					 struct request_queue *rq,
 					 struct file *file)
 {
 	struct bsg_device *bd = NULL;
@@ -753,17 +752,16 @@ #endif
 	if (!bd)
 		return ERR_PTR(-ENOMEM);
 
-	bd->disk = disk;
-	bd->queue = disk->queue;
-	kobject_get(&disk->queue->kobj);
+	bd->queue = rq;
+	kobject_get(&rq->kobj);
 	bsg_set_block(bd, file);
 
 	atomic_set(&bd->ref_count, 1);
 	bd->minor = iminor(inode);
 	mutex_lock(&bsg_mutex);
-	hlist_add_head(&bd->dev_list,&bsg_device_list[bsg_list_idx(bd->minor)]);
+	hlist_add_head(&bd->dev_list, &bsg_device_list[bsg_list_idx(bd->minor)]);
 
-	strncpy(bd->name, disk->disk_name, sizeof(bd->name) - 1);
+	strncpy(bd->name, rq->bsg_dev.class_dev->class_id, sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
 		format_dev_t(buf, inode->i_rdev), bd->max_queue);
 
@@ -817,7 +815,7 @@ static struct bsg_device *bsg_get_device
 	if (!bcd)
 		return ERR_PTR(-ENODEV);
 
-	return bsg_add_device(inode, bcd->disk, file);
+	return bsg_add_device(inode, bcd->queue, file);
 }
 
 static int bsg_open(struct inode *inode, struct file *file)
@@ -900,7 +898,7 @@ bsg_ioctl(struct inode *inode, struct fi
 	case SG_EMULATED_HOST:
 	case SCSI_IOCTL_SEND_COMMAND: {
 		void __user *uarg = (void __user *) arg;
-		return scsi_cmd_ioctl(file, bd->disk, cmd, uarg);
+		return scsi_cmd_ioctl(file, NULL, cmd, uarg);
 	}
 	case SG_IO: {
 		struct request *rq;
@@ -915,7 +913,7 @@ bsg_ioctl(struct inode *inode, struct fi
 			return PTR_ERR(rq);
 
 		bio = rq->bio;
-		blk_execute_rq(bd->queue, bd->disk, rq, 0);
+		blk_execute_rq(bd->queue, NULL, rq, 0);
 		blk_complete_sgv4_hdr_rq(rq, &hdr, bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
@@ -945,24 +943,23 @@ static struct file_operations bsg_fops =
 	.owner		=	THIS_MODULE,
 };
 
-void bsg_unregister_disk(struct gendisk *disk)
+void bsg_unregister_queue(struct request_queue *q)
 {
-	struct bsg_class_device *bcd = &disk->bsg_dev;
+	struct bsg_class_device *bcd = &q->bsg_dev;
 
 	if (!bcd->class_dev)
 		return;
 
 	mutex_lock(&bsg_mutex);
-	sysfs_remove_link(&bcd->disk->queue->kobj, "bsg");
+	sysfs_remove_link(&q->kobj, "bsg");
 	class_device_destroy(bsg_class, MKDEV(BSG_MAJOR, bcd->minor));
 	bcd->class_dev = NULL;
 	list_del_init(&bcd->list);
 	mutex_unlock(&bsg_mutex);
 }
 
-int bsg_register_disk(struct gendisk *disk)
+int bsg_register_queue(struct request_queue *q, char *name)
 {
-	request_queue_t *q = disk->queue;
 	struct bsg_class_device *bcd;
 	dev_t dev;
 
@@ -972,7 +969,7 @@ int bsg_register_disk(struct gendisk *di
 	if (!q->request_fn)
 		return 0;
 
-	bcd = &disk->bsg_dev;
+	bcd = &q->bsg_dev;
 	memset(bcd, 0, sizeof(*bcd));
 	INIT_LIST_HEAD(&bcd->list);
 
@@ -980,8 +977,8 @@ int bsg_register_disk(struct gendisk *di
 	dev = MKDEV(BSG_MAJOR, bsg_device_nr);
 	bcd->minor = bsg_device_nr;
 	bsg_device_nr++;
-	bcd->disk = disk;
-	bcd->class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", disk->disk_name);
+	bcd->queue = q;
+	bcd->class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
 	if (!bcd->class_dev)
 		goto err;
 	list_add_tail(&bcd->list, &bsg_class_list);
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a08e9ca..fccc3a1 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -4038,7 +4038,7 @@ int blk_register_queue(struct gendisk *d
 		return ret;
 	}
 
-	ret = bsg_register_disk(disk);
+	ret = bsg_register_queue(q, disk->disk_name);
 	if (ret) {
 		elv_unregister_queue(q);
 		kobject_unregister(&q->kobj);
@@ -4053,7 +4053,7 @@ void blk_unregister_queue(struct gendisk
 	request_queue_t *q = disk->queue;
 
 	if (q && q->request_fn) {
-		bsg_unregister_disk(disk);
+		bsg_unregister_queue(q);
 		elv_unregister_queue(q);
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aa000d2..b114d7e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -14,6 +14,7 @@ #include <linux/mempool.h>
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/stringify.h>
+#include <linux/bsg.h>
 
 #include <asm/scatterlist.h>
 
@@ -469,6 +470,10 @@ #endif
 	unsigned int		bi_size;
 
 	struct mutex		sysfs_lock;
+
+#if defined(CONFIG_BLK_DEV_BSG)
+	struct bsg_class_device bsg_dev;
+#endif
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 2154a6d..0475a6d 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -47,16 +47,16 @@ struct bsg_class_device {
 	struct class_device *class_dev;
 	struct device *dev;
 	int minor;
-	struct gendisk *disk;
 	struct list_head list;
+	struct request_queue *queue;
 };
 
-extern int bsg_register_disk(struct gendisk *);
-extern void bsg_unregister_disk(struct gendisk *);
+extern int bsg_register_queue(struct request_queue *, char *);
+extern void bsg_unregister_queue(struct request_queue *);
 #else
 struct bsg_class_device { };
-#define bsg_register_disk(disk)		(0)
-#define bsg_unregister_disk(disk)	do { } while (0)
+#define bsg_register_queue(disk, name)		(0)
+#define bsg_unregister_queue(disk)	do { } while (0)
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0dcfc3b..2c65da7 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -66,7 +66,6 @@ #include <linux/device.h>
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/bsg.h>
 
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
@@ -139,7 +138,6 @@ #ifdef	CONFIG_SMP
 #else
 	struct disk_stats dkstats;
 #endif
-	struct bsg_class_device bsg_dev;
 };
 
 /* Structure for sysfs attributes on block devices */
-- 
1.4.3.2

