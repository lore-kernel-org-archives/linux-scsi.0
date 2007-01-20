From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] add bsg queue resize
Date: Sat, 20 Jan 2007 23:25:18 +0900
Message-ID: <20070120232518E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:40677 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965276AbXATOYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jan 2007 09:24:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com

This enables bsg to resize the queue depth via
SG_SET_COMMAND_Q. bsg_command structures are allocated via mempool
because the previous way to use contiguous memory makes it difficult
to resize the queue depth when a bsg_device has outstanding commands.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |  112 +++++++++++++++++++++++-----------------------------------
 1 files changed, 45 insertions(+), 67 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 9d77a0c..af46f54 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -33,8 +33,6 @@ #include <scsi/sg.h>
 
 static char bsg_version[] = "block layer sg (bsg) 0.4";
 
-struct bsg_command;
-
 struct bsg_device {
 	struct gendisk *disk;
 	request_queue_t *queue;
@@ -46,8 +44,7 @@ struct bsg_device {
 	int minor;
 	int queued_cmds;
 	int done_cmds;
-	unsigned long *cmd_bitmap;
-	struct bsg_command *cmd_map;
+	mempool_t *bsg_cmd_q;
 	wait_queue_head_t wq_done;
 	wait_queue_head_t wq_free;
 	char name[BDEVNAME_SIZE];
@@ -55,19 +52,26 @@ struct bsg_device {
 	unsigned long flags;
 };
 
+/*
+ * our internal command type
+ */
+struct bsg_command {
+	struct bsg_device *bd;
+	struct list_head list;
+	struct request *rq;
+	struct bio *bio;
+	int err;
+	struct sg_io_v4 hdr;
+	struct sg_io_v4 __user *uhdr;
+	char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
 enum {
 	BSG_F_BLOCK		= 1,
 	BSG_F_WRITE_PERM	= 2,
 };
 
-/*
- * command allocation bitmap defines
- */
-#define BSG_CMDS_PAGE_ORDER	(1)
-#define BSG_CMDS_PER_LONG	(sizeof(unsigned long) * 8)
-#define BSG_CMDS_MASK		(BSG_CMDS_PER_LONG - 1)
-#define BSG_CMDS_BYTES		(PAGE_SIZE * (1 << BSG_CMDS_PAGE_ORDER))
-#define BSG_CMDS		(BSG_CMDS_BYTES / sizeof(struct bsg_command))
+#define BSG_DEFAULT_CMDS	(64)
 
 #undef BSG_DEBUG
 
@@ -94,31 +98,18 @@ static struct hlist_head bsg_device_list
 static struct class *bsg_class;
 static LIST_HEAD(bsg_class_list);
 
-/*
- * our internal command type
- */
-struct bsg_command {
-	struct bsg_device *bd;
-	struct list_head list;
-	struct request *rq;
-	struct bio *bio;
-	int err;
-	struct sg_io_v4 hdr;
-	struct sg_io_v4 __user *uhdr;
-	char sense[SCSI_SENSE_BUFFERSIZE];
-};
+static struct kmem_cache *bsg_cmd_cachep;
 
 static void bsg_free_command(struct bsg_command *bc)
 {
 	struct bsg_device *bd = bc->bd;
-	unsigned long bitnr = bc - bd->cmd_map;
 	unsigned long flags;
 
-	dprintk("%s: command bit offset %lu\n", bd->name, bitnr);
+	dprintk("%s: command free %p\n", bd->name, bc);
 
+	mempool_free(bc, bd->bsg_cmd_q);
 	spin_lock_irqsave(&bd->lock, flags);
 	bd->queued_cmds--;
-	__clear_bit(bitnr, bd->cmd_bitmap);
 	spin_unlock_irqrestore(&bd->lock, flags);
 
 	wake_up(&bd->wq_free);
@@ -127,29 +118,18 @@ static void bsg_free_command(struct bsg_
 static struct bsg_command *__bsg_alloc_command(struct bsg_device *bd)
 {
 	struct bsg_command *bc = NULL;
-	unsigned long *map;
-	int free_nr;
 
 	spin_lock_irq(&bd->lock);
-
 	if (bd->queued_cmds >= bd->max_queue)
 		goto out;
-
-	for (free_nr = 0, map = bd->cmd_bitmap; *map == ~0UL; map++)
-		free_nr += BSG_CMDS_PER_LONG;
-
-	BUG_ON(*map == ~0UL);
-
 	bd->queued_cmds++;
-	free_nr += ffz(*map);
-	__set_bit(free_nr, bd->cmd_bitmap);
 	spin_unlock_irq(&bd->lock);
 
-	bc = bd->cmd_map + free_nr;
+	bc = mempool_alloc(bd->bsg_cmd_q, GFP_NOWAIT);
 	memset(bc, 0, sizeof(*bc));
 	bc->bd = bd;
 	INIT_LIST_HEAD(&bc->list);
-	dprintk("%s: returning free cmd %p (bit %d)\n", bd->name, bc, free_nr);
+	dprintk("%s: returning free cmd %p\n", bd->name, bc);
 	return bc;
 out:
 	dprintk("%s: failed (depth %d)\n", bd->name, bd->queued_cmds);
@@ -356,8 +336,8 @@ static void bsg_rq_end_io(struct request
 	struct bsg_device *bd = bc->bd;
 	unsigned long flags;
 
-	dprintk("%s: finished rq %p bc %p, bio %p offset %Zd stat %d\n",
-		bd->name, rq, bc, bc->bio, bc - bd->cmd_map, uptodate);
+	dprintk("%s: finished rq %p bc %p, bio %p stat %d\n",
+		bd->name, rq, bc, bc->bio, uptodate);
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
@@ -705,19 +685,13 @@ bsg_write(struct file *file, const char
 
 static void bsg_free_device(struct bsg_device *bd)
 {
-	if (bd->cmd_map)
-		free_pages((unsigned long) bd->cmd_map, BSG_CMDS_PAGE_ORDER);
-
-	kfree(bd->cmd_bitmap);
+	mempool_destroy(bd->bsg_cmd_q);
 	kfree(bd);
 }
 
 static struct bsg_device *bsg_alloc_device(void)
 {
-	struct bsg_command *cmd_map;
-	unsigned long *cmd_bitmap;
 	struct bsg_device *bd;
-	int bits;
 
 	bd = kzalloc(sizeof(struct bsg_device), GFP_KERNEL);
 	if (unlikely(!bd))
@@ -725,19 +699,10 @@ static struct bsg_device *bsg_alloc_devi
 
 	spin_lock_init(&bd->lock);
 
-	bd->max_queue = BSG_CMDS;
-
-	bits = (BSG_CMDS / BSG_CMDS_PER_LONG) + 1;
-	cmd_bitmap = kzalloc(bits * sizeof(unsigned long), GFP_KERNEL);
-	if (!cmd_bitmap)
+	bd->max_queue = BSG_DEFAULT_CMDS;
+	bd->bsg_cmd_q = mempool_create_slab_pool(bd->max_queue, bsg_cmd_cachep);
+	if (unlikely(!bd->bsg_cmd_q))
 		goto out_free_bd;
-	bd->cmd_bitmap = cmd_bitmap;
-
-	cmd_map = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-						BSG_CMDS_PAGE_ORDER);
-	if (!cmd_map)
-		goto out_free_bitmap;
-	bd->cmd_map = cmd_map;
 
 	INIT_LIST_HEAD(&bd->busy_list);
 	INIT_LIST_HEAD(&bd->done_list);
@@ -747,8 +712,6 @@ static struct bsg_device *bsg_alloc_devi
 	init_waitqueue_head(&bd->wq_done);
 	return bd;
 
-out_free_bitmap:
-	kfree(cmd_bitmap);
 out_free_bd:
 	kfree(bd);
 	return NULL;
@@ -918,15 +881,22 @@ bsg_ioctl(struct inode *inode, struct fi
 		 */
 	case SG_GET_COMMAND_Q:
 		return put_user(bd->max_queue, uarg);
-		case SG_SET_COMMAND_Q: {
-		int queue;
+	case SG_SET_COMMAND_Q: {
+		int queue, ret;
 
 		if (get_user(queue, uarg))
 			return -EFAULT;
-		if (queue > BSG_CMDS || queue < 1)
+
+		if (queue < 1)
 			return -EINVAL;
 
+		ret = mempool_resize(bd->bsg_cmd_q, queue, GFP_KERNEL);
+		if (ret)
+			return ret;
+
+		spin_lock_irq(&bd->lock);
 		bd->max_queue = queue;
+		spin_unlock_irq(&bd->lock);
 		return 0;
 	}
 
@@ -1048,6 +1018,14 @@ static int __init bsg_init(void)
 		return ret;
 	}
 
+	bsg_cmd_cachep = kmem_cache_create("bsg_cmd", sizeof(struct bsg_command),
+					   0, 0, NULL, NULL);
+	if (!bsg_cmd_cachep) {
+		class_destroy(bsg_class);
+		unregister_chrdev(BSG_MAJOR, "bsg");
+		return -ENOMEM;
+	}
+
 	printk(KERN_INFO "%s loaded\n", bsg_version);
 	return 0;
 }
-- 
1.4.3.2

