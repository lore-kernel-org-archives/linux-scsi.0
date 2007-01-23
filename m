From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] add bsg queue resize
Date: Tue, 23 Jan 2007 16:23:49 +0100
Message-ID: <20070123152348.GD11995@kernel.dk>
References: <20070120232518E.fujita.tomonori@lab.ntt.co.jp> <20070123083403.GC5486@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:22905 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbXAWPWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 10:22:15 -0500
Content-Disposition: inline
In-Reply-To: <20070123083403.GC5486@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 23 2007, Jens Axboe wrote:
> On Sat, Jan 20 2007, FUJITA Tomonori wrote:
> > This enables bsg to resize the queue depth via
> > SG_SET_COMMAND_Q. bsg_command structures are allocated via mempool
> > because the previous way to use contiguous memory makes it difficult
> > to resize the queue depth when a bsg_device has outstanding commands.
> 
> Overall the patch looks fine. I don't think we need a mempool though,
> and allocations could just use GFP_USER from the user invoked queuing
> paths. Just make it GFP_USER, we can always extend the
> bsg_alloc_command() to take a gfp_t argument as well If you get rid of
> the mempool, then resizing is simply just adjusting bd->max_queue.

Like so.

diff --git a/block/bsg.c b/block/bsg.c
index 9d77a0c..c56618a 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -33,8 +33,6 @@
 
 static char bsg_version[] = "block layer sg (bsg) 0.4";
 
-struct bsg_command;
-
 struct bsg_device {
 	struct gendisk *disk;
 	request_queue_t *queue;
@@ -46,8 +44,6 @@ struct bsg_device {
 	int minor;
 	int queued_cmds;
 	int done_cmds;
-	unsigned long *cmd_bitmap;
-	struct bsg_command *cmd_map;
 	wait_queue_head_t wq_done;
 	wait_queue_head_t wq_free;
 	char name[BDEVNAME_SIZE];
@@ -60,14 +56,7 @@ enum {
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
+#define BSG_DEFAULT_CMDS	64
 
 #undef BSG_DEBUG
 
@@ -94,6 +83,8 @@ static struct hlist_head bsg_device_list[BSG_LIST_SIZE];
 static struct class *bsg_class;
 static LIST_HEAD(bsg_class_list);
 
+static struct kmem_cache *bsg_cmd_cachep;
+
 /*
  * our internal command type
  */
@@ -111,14 +102,12 @@ struct bsg_command {
 static void bsg_free_command(struct bsg_command *bc)
 {
 	struct bsg_device *bd = bc->bd;
-	unsigned long bitnr = bc - bd->cmd_map;
 	unsigned long flags;
 
-	dprintk("%s: command bit offset %lu\n", bd->name, bitnr);
+	kmem_cache_free(bsg_cmd_cachep, bc);
 
 	spin_lock_irqsave(&bd->lock, flags);
 	bd->queued_cmds--;
-	__clear_bit(bitnr, bd->cmd_bitmap);
 	spin_unlock_irqrestore(&bd->lock, flags);
 
 	wake_up(&bd->wq_free);
@@ -127,32 +116,29 @@ static void bsg_free_command(struct bsg_command *bc)
 static struct bsg_command *__bsg_alloc_command(struct bsg_device *bd)
 {
 	struct bsg_command *bc = NULL;
-	unsigned long *map;
-	int free_nr;
 
 	spin_lock_irq(&bd->lock);
 
 	if (bd->queued_cmds >= bd->max_queue)
 		goto out;
 
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
+	bc = kmem_cache_alloc(bsg_cmd_cachep, GFP_USER);
+	if (unlikely(!bc)) {
+		spin_lock_irq(&bd->lock);
+		goto alloc_fail;
+	}
+
 	memset(bc, 0, sizeof(*bc));
 	bc->bd = bd;
 	INIT_LIST_HEAD(&bc->list);
-	dprintk("%s: returning free cmd %p (bit %d)\n", bd->name, bc, free_nr);
+	dprintk("%s: returning free cmd %p\n", bd->name, bc);
 	return bc;
+alloc_fail:
+	bd->queued_cmds--;
 out:
-	dprintk("%s: failed (depth %d)\n", bd->name, bd->queued_cmds);
 	spin_unlock_irq(&bd->lock);
 	return bc;
 }
@@ -356,8 +342,8 @@ static void bsg_rq_end_io(struct request *rq, int uptodate)
 	struct bsg_device *bd = bc->bd;
 	unsigned long flags;
 
-	dprintk("%s: finished rq %p bc %p, bio %p offset %Zd stat %d\n",
-		bd->name, rq, bc, bc->bio, bc - bd->cmd_map, uptodate);
+	dprintk("%s: finished rq %p bc %p, bio %p stat %d\n",
+		bd->name, rq, bc, bc->bio, uptodate);
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
@@ -703,21 +689,9 @@ bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	return bytes_read;
 }
 
-static void bsg_free_device(struct bsg_device *bd)
-{
-	if (bd->cmd_map)
-		free_pages((unsigned long) bd->cmd_map, BSG_CMDS_PAGE_ORDER);
-
-	kfree(bd->cmd_bitmap);
-	kfree(bd);
-}
-
 static struct bsg_device *bsg_alloc_device(void)
 {
-	struct bsg_command *cmd_map;
-	unsigned long *cmd_bitmap;
 	struct bsg_device *bd;
-	int bits;
 
 	bd = kzalloc(sizeof(struct bsg_device), GFP_KERNEL);
 	if (unlikely(!bd))
@@ -725,19 +699,7 @@ static struct bsg_device *bsg_alloc_device(void)
 
 	spin_lock_init(&bd->lock);
 
-	bd->max_queue = BSG_CMDS;
-
-	bits = (BSG_CMDS / BSG_CMDS_PER_LONG) + 1;
-	cmd_bitmap = kzalloc(bits * sizeof(unsigned long), GFP_KERNEL);
-	if (!cmd_bitmap)
-		goto out_free_bd;
-	bd->cmd_bitmap = cmd_bitmap;
-
-	cmd_map = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-						BSG_CMDS_PAGE_ORDER);
-	if (!cmd_map)
-		goto out_free_bitmap;
-	bd->cmd_map = cmd_map;
+	bd->max_queue = BSG_DEFAULT_CMDS;
 
 	INIT_LIST_HEAD(&bd->busy_list);
 	INIT_LIST_HEAD(&bd->done_list);
@@ -746,12 +708,6 @@ static struct bsg_device *bsg_alloc_device(void)
 	init_waitqueue_head(&bd->wq_free);
 	init_waitqueue_head(&bd->wq_done);
 	return bd;
-
-out_free_bitmap:
-	kfree(cmd_bitmap);
-out_free_bd:
-	kfree(bd);
-	return NULL;
 }
 
 static int bsg_put_device(struct bsg_device *bd)
@@ -779,7 +735,7 @@ static int bsg_put_device(struct bsg_device *bd)
 
 	blk_put_queue(bd->queue);
 	hlist_del(&bd->dev_list);
-	bsg_free_device(bd);
+	kfree(bd);
 out:
 	mutex_unlock(&bsg_mutex);
 	return ret;
@@ -918,15 +874,17 @@ bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		 */
 	case SG_GET_COMMAND_Q:
 		return put_user(bd->max_queue, uarg);
-		case SG_SET_COMMAND_Q: {
+	case SG_SET_COMMAND_Q: {
 		int queue;
 
 		if (get_user(queue, uarg))
 			return -EFAULT;
-		if (queue > BSG_CMDS || queue < 1)
+		if (queue < 1)
 			return -EINVAL;
 
+		spin_lock_irq(&bd->lock);
 		bd->max_queue = queue;
+		spin_unlock_irq(&bd->lock);
 		return 0;
 	}
 
@@ -1035,15 +993,25 @@ static int __init bsg_init(void)
 {
 	int ret, i;
 
+	bsg_cmd_cachep = kmem_cache_create("bsg_cmd",
+				sizeof(struct bsg_command), 0, 0, NULL, NULL);
+	if (!bsg_cmd_cachep) {
+		printk(KERN_ERR "bsg: failed creating slab cache\n");
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < BSG_LIST_SIZE; i++)
 		INIT_HLIST_HEAD(&bsg_device_list[i]);
 
 	bsg_class = class_create(THIS_MODULE, "bsg");
-	if (IS_ERR(bsg_class))
+	if (IS_ERR(bsg_class)) {
+		kmem_cache_destroy(bsg_cmd_cachep);
 		return PTR_ERR(bsg_class);
+	}
 
 	ret = register_chrdev(BSG_MAJOR, "bsg", &bsg_fops);
 	if (ret) {
+		kmem_cache_destroy(bsg_cmd_cachep);
 		class_destroy(bsg_class);
 		return ret;
 	}


-- 
Jens Axboe

