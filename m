From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 03/10] blk-mq: rename blk_mq_[freeze|unfreeze]_queue
Date: Tue, 19 Sep 2017 11:49:18 +0800
Message-ID: <20170919034925.9894-4-ming.lei@redhat.com>
References: <20170919034925.9894-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919034925.9894-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

We will support to freeze queue on block legacy path too.

No functional change.

Tested-by: Cathy Avery <cavery@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bfq-iosched.c      |  2 +-
 block/blk-cgroup.c       |  8 ++++----
 block/blk-mq.c           | 27 +++++++++------------------
 block/blk-mq.h           |  1 -
 block/elevator.c         |  4 ++--
 drivers/block/loop.c     | 24 ++++++++++++------------
 drivers/block/rbd.c      |  2 +-
 drivers/nvme/host/core.c |  6 +++---
 include/linux/blk-mq.h   |  4 ++--
 9 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a4783da90ba8..a18f36bfbdf0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4758,7 +4758,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	 * The invocation of the next bfq_create_group_hierarchy
 	 * function is the head of a chain of function calls
 	 * (bfq_create_group_hierarchy->blkcg_activate_policy->
-	 * blk_mq_freeze_queue) that may lead to the invocation of the
+	 * blk_freeze_queue) that may lead to the invocation of the
 	 * has_work hook function. For this reason,
 	 * bfq_create_group_hierarchy is invoked only after all
 	 * scheduler data has been initialized, apart from the fields
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d3f56baee936..ffc984381e4b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1298,7 +1298,7 @@ int blkcg_activate_policy(struct request_queue *q,
 		return 0;
 
 	if (q->mq_ops)
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 	else
 		blk_queue_bypass_start(q);
 pd_prealloc:
@@ -1339,7 +1339,7 @@ int blkcg_activate_policy(struct request_queue *q,
 	spin_unlock_irq(q->queue_lock);
 out_bypass_end:
 	if (q->mq_ops)
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 	else
 		blk_queue_bypass_end(q);
 	if (pd_prealloc)
@@ -1365,7 +1365,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 		return;
 
 	if (q->mq_ops)
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 	else
 		blk_queue_bypass_start(q);
 
@@ -1390,7 +1390,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	spin_unlock_irq(q->queue_lock);
 
 	if (q->mq_ops)
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 	else
 		blk_queue_bypass_end(q);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 10c1f49f663d..1acebbd1fbd4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -162,18 +162,9 @@ void blk_freeze_queue(struct request_queue *q)
 	blk_freeze_queue_start(q);
 	blk_mq_freeze_queue_wait(q);
 }
+EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
-void blk_mq_freeze_queue(struct request_queue *q)
-{
-	/*
-	 * ...just an alias to keep freeze and unfreeze actions balanced
-	 * in the blk_mq_* namespace
-	 */
-	blk_freeze_queue(q);
-}
-EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
-
-void blk_mq_unfreeze_queue(struct request_queue *q)
+void blk_unfreeze_queue(struct request_queue *q)
 {
 	int freeze_depth;
 
@@ -184,7 +175,7 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 		wake_up_all(&q->mq_freeze_wq);
 	}
 }
-EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
+EXPORT_SYMBOL_GPL(blk_unfreeze_queue);
 
 /*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
@@ -2192,9 +2183,9 @@ static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
 	lockdep_assert_held(&set->tag_list_lock);
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 		queue_set_hctx_shared(q, shared);
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 	}
 }
 
@@ -2625,7 +2616,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	if (!set)
 		return -EINVAL;
 
-	blk_mq_freeze_queue(q);
+	blk_freeze_queue(q);
 
 	ret = 0;
 	queue_for_each_hw_ctx(q, hctx, i) {
@@ -2650,7 +2641,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	if (!ret)
 		q->nr_requests = nr;
 
-	blk_mq_unfreeze_queue(q);
+	blk_unfreeze_queue(q);
 
 	return ret;
 }
@@ -2668,7 +2659,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		return;
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
-		blk_mq_freeze_queue(q);
+		blk_freeze_queue(q);
 
 	set->nr_hw_queues = nr_hw_queues;
 	blk_mq_update_queue_map(set);
@@ -2678,7 +2669,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	}
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 }
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index ef15b3414da5..41044a8662ca 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -26,7 +26,6 @@ struct blk_mq_ctx {
 } ____cacheline_aligned_in_smp;
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
diff --git a/block/elevator.c b/block/elevator.c
index 153926a90901..c3524091138f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -950,7 +950,7 @@ static int elevator_switch_mq(struct request_queue *q,
 {
 	int ret;
 
-	blk_mq_freeze_queue(q);
+	blk_freeze_queue(q);
 
 	if (q->elevator) {
 		if (q->elevator->registered)
@@ -977,7 +977,7 @@ static int elevator_switch_mq(struct request_queue *q,
 		blk_add_trace_msg(q, "elv switch: none");
 
 out:
-	blk_mq_unfreeze_queue(q);
+	blk_unfreeze_queue(q);
 	return ret;
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 85de67334695..1791a0ea8ad9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -211,7 +211,7 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 	 * LO_FLAGS_READ_ONLY, both are set from kernel, and losetup
 	 * will get updated by ioctl(LOOP_GET_STATUS)
 	 */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 	lo->use_dio = use_dio;
 	if (use_dio) {
 		queue_flag_clear_unlocked(QUEUE_FLAG_NOMERGES, lo->lo_queue);
@@ -220,7 +220,7 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 		queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, lo->lo_queue);
 		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
 	}
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 }
 
 static int
@@ -659,14 +659,14 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 		goto out_putf;
 
 	/* and ... switch */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
 	lo->lo_backing_file = file;
 	lo->old_gfp_mask = mapping_gfp_mask(file->f_mapping);
 	mapping_set_gfp_mask(file->f_mapping,
 			     lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 	loop_update_dio(lo);
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	fput(old_file);
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
@@ -1017,7 +1017,7 @@ static int loop_clr_fd(struct loop_device *lo)
 		return -EINVAL;
 
 	/* freeze request queue during the transition */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_state = Lo_rundown;
@@ -1053,7 +1053,7 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
 		loop_reread_partitions(lo, bdev);
@@ -1089,7 +1089,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		return -EINVAL;
 
 	/* I/O need to be drained during transfer transition */
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 
 	err = loop_release_xfer(lo);
 	if (err)
@@ -1147,7 +1147,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	__loop_update_dio(lo, lo->use_dio);
 
  exit:
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	if (!err && (info->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(lo->lo_flags & LO_FLAGS_PARTSCAN)) {
@@ -1329,14 +1329,14 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	if (arg < 512 || arg > PAGE_SIZE || !is_power_of_2(arg))
 		return -EINVAL;
 
-	blk_mq_freeze_queue(lo->lo_queue);
+	blk_freeze_queue(lo->lo_queue);
 
 	blk_queue_logical_block_size(lo->lo_queue, arg);
 	blk_queue_physical_block_size(lo->lo_queue, arg);
 	blk_queue_io_min(lo->lo_queue, arg);
 	loop_update_dio(lo);
 
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	return 0;
 }
@@ -1598,8 +1598,8 @@ static void lo_release(struct gendisk *disk, fmode_t mode)
 		 * Otherwise keep thread (if running) and config,
 		 * but flush possible ongoing bios in thread.
 		 */
-		blk_mq_freeze_queue(lo->lo_queue);
-		blk_mq_unfreeze_queue(lo->lo_queue);
+		blk_freeze_queue(lo->lo_queue);
+		blk_unfreeze_queue(lo->lo_queue);
 	}
 
 	mutex_unlock(&lo->lo_ctl_mutex);
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b640ad8a6d20..3bcaebc5c3a8 100644
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
index acc816b67582..a0075d40cfef 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1209,7 +1209,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	bs = 1 << ns->lba_shift;
 	ns->noiob = le16_to_cpu(id->noiob);
 
-	blk_mq_freeze_queue(disk->queue);
+	blk_freeze_queue(disk->queue);
 
 	if (ctrl->ops->flags & NVME_F_METADATA_SUPPORTED)
 		nvme_prep_integrity(disk, id, bs);
@@ -1225,7 +1225,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 
 	if (ctrl->oncs & NVME_CTRL_ONCS_DSM)
 		nvme_config_discard(ns);
-	blk_mq_unfreeze_queue(disk->queue);
+	blk_unfreeze_queue(disk->queue);
 }
 
 static int nvme_revalidate_disk(struct gendisk *disk)
@@ -2882,7 +2882,7 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
-		blk_mq_unfreeze_queue(ns->queue);
+		blk_unfreeze_queue(ns->queue);
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
 EXPORT_SYMBOL_GPL(nvme_unfreeze);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 50c6485cb04f..355d74507656 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -253,8 +253,8 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
-void blk_mq_freeze_queue(struct request_queue *q);
-void blk_mq_unfreeze_queue(struct request_queue *q);
+void blk_freeze_queue(struct request_queue *q);
+void blk_unfreeze_queue(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
-- 
2.9.5
