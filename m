From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/8] blk-mq: rename blk_mq_freeze_queue as blk_freeze_queue
Date: Sat,  2 Sep 2017 02:49:52 +0800
Message-ID: <20170901184958.19452-4-ming.lei@redhat.com>
References: <20170901184958.19452-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901184958.19452-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This APIs will be used by legacy path too.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bfq-iosched.c      |  2 +-
 block/blk-cgroup.c       |  4 ++--
 block/blk-mq.c           | 17 ++++-------------
 block/blk-mq.h           |  1 -
 block/elevator.c         |  2 +-
 drivers/block/loop.c     |  8 ++++----
 drivers/block/rbd.c      |  2 +-
 drivers/nvme/host/core.c |  2 +-
 include/linux/blk-mq.h   |  2 +-
 9 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 509f39998011..ce2b00e897e2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4757,7 +4757,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	 * The invocation of the next bfq_create_group_hierarchy
 	 * function is the head of a chain of function calls
 	 * (bfq_create_group_hierarchy->blkcg_activate_policy->
-	 * blk_mq_freeze_queue) that may lead to the invocation of the
+	 * blk_freeze_queue) that may lead to the invocation of the
 	 * has_work hook function. For this reason,
 	 * bfq_create_group_hierarchy is invoked only after all
 	 * scheduler data has been initialized, apart from the fields
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 02e8a47ac77c..87c15f3947d5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1296,7 +1296,7 @@ int blkcg_activate_policy(struct request_queue *q,
 		return 0;
 
 	if (q->mq_ops)
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 	else
 		blk_queue_bypass_start(q);
 pd_prealloc:
@@ -1363,7 +1363,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 		return;
 
 	if (q->mq_ops)
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 	else
 		blk_queue_bypass_start(q);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 82136e83951d..8cf1f7cbef2b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -161,16 +161,7 @@ void blk_freeze_queue(struct request_queue *q)
 	blk_freeze_queue_start(q);
 	blk_mq_freeze_queue_wait(q);
 }
-
-void blk_mq_freeze_queue(struct request_queue *q)
-{
-	/*
-	 * ...just an alias to keep freeze and unfreeze actions balanced
-	 * in the blk_mq_* namespace
-	 */
-	blk_freeze_queue(q);
-}
-EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
+EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
 void blk_unfreeze_queue(struct request_queue *q)
 {
@@ -2248,7 +2239,7 @@ static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
 	lockdep_assert_held(&set->tag_list_lock);
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 		queue_set_hctx_shared(q, shared);
 		blk_unfreeze_queue(q);
 	}
@@ -2683,7 +2674,7 @@ static int __blk_mq_update_nr_requests(struct request_queue *q,
 	if (!set)
 		return -EINVAL;
 
-	blk_mq_freeze_queue(q);
+	blk_freeze_queue(q);
 
 	ret = 0;
 	queue_for_each_hw_ctx(q, hctx, i) {
@@ -2747,7 +2738,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		return;
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 
 	set->nr_hw_queues = nr_hw_queues;
 	blk_mq_update_queue_map(set);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 1b9742eb7399..7ce29ef1e6f3 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -30,7 +30,6 @@ struct blk_mq_ctx {
 } ____cacheline_aligned_in_smp;
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
diff --git a/block/elevator.c b/block/elevator.c
index 371c8165c9e8..1164c8a3720f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -967,7 +967,7 @@ static int elevator_switch_mq(struct request_queue *q,
 {
 	int ret;
 
-	blk_mq_freeze_queue(q);
+	blk_freeze_queue(q);
 
 	if (q->elevator) {
 		if (q->elevator->registered)
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5c11ea44d470..b2e708b7e1e6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -211,7 +211,7 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 	 * LO_FLAGS_READ_ONLY, both are set from kernel, and losetup
 	 * will get updated by ioctl(LOOP_GET_STATUS)
 	 */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 	lo->use_dio = use_dio;
 	if (use_dio)
 		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
@@ -599,7 +599,7 @@ static int loop_switch(struct loop_device *lo, struct file *file)
 	w.file = file;
 
 	/* freeze queue and wait for completion of scheduled requests */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 
 	/* do the switch action */
 	do_loop_switch(lo, &w);
@@ -1046,7 +1046,7 @@ static int loop_clr_fd(struct loop_device *lo)
 		return -EINVAL;
 
 	/* freeze request queue during the transition */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_state = Lo_rundown;
@@ -1116,7 +1116,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		return -EINVAL;
 
 	/* I/O need to be drained during transfer transition */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 
 	err = loop_release_xfer(lo);
 	if (err)
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b008b6a98098..3a97ffcb3a81 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6347,7 +6347,7 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
 		 * Prevent new IO from being queued and wait for existing
 		 * IO to complete/fail.
 		 */
-		blk_mq_freeze_queue(rbd_dev->disk->queue);
+		blk_freeze_queue(rbd_dev->disk->queue);
 		blk_set_queue_dying(rbd_dev->disk->queue);
 	}
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5c76b0a96be2..986f2b4f9760 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1210,7 +1210,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	bs = 1 << ns->lba_shift;
 	ns->noiob = le16_to_cpu(id->noiob);
 
-	blk_mq_freeze_queue(disk->queue);
+	blk_freeze_queue(disk->queue);
 
 	if (ctrl->ops->flags & NVME_F_METADATA_SUPPORTED)
 		nvme_prep_integrity(disk, id, bs);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2572e5641568..8ae77e088c01 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -256,7 +256,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
-void blk_mq_freeze_queue(struct request_queue *q);
+void blk_freeze_queue(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
-- 
2.9.5
