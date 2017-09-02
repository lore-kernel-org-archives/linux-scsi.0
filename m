From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 1/8] blk-mq: rename blk_mq_unfreeze_queue as blk_unfreeze_queue
Date: Sat,  2 Sep 2017 21:08:33 +0800
Message-ID: <20170902130840.24609-2-ming.lei@redhat.com>
References: <20170902130840.24609-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170902130840.24609-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

We will support to freeze queue on block legacy path too.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-cgroup.c       |  4 ++--
 block/blk-mq.c           | 10 +++++-----
 block/elevator.c         |  2 +-
 drivers/block/loop.c     |  8 ++++----
 drivers/nvme/host/core.c |  4 ++--
 include/linux/blk-mq.h   |  2 +-
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0480892e97e5..02e8a47ac77c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1337,7 +1337,7 @@ int blkcg_activate_policy(struct request_queue *q,
 	spin_unlock_irq(q->queue_lock);
 out_bypass_end:
 	if (q->mq_ops)
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 	else
 		blk_queue_bypass_end(q);
 	if (pd_prealloc)
@@ -1388,7 +1388,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	spin_unlock_irq(q->queue_lock);
 
 	if (q->mq_ops)
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 	else
 		blk_queue_bypass_end(q);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d935f15c54da..82136e83951d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -172,7 +172,7 @@ void blk_mq_freeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
 
-void blk_mq_unfreeze_queue(struct request_queue *q)
+void blk_unfreeze_queue(struct request_queue *q)
 {
 	int freeze_depth;
 
@@ -183,7 +183,7 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 		wake_up_all(&q->mq_freeze_wq);
 	}
 }
-EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
+EXPORT_SYMBOL_GPL(blk_unfreeze_queue);
 
 /*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
@@ -2250,7 +2250,7 @@ static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
 		blk_mq_freeze_queue(q);
 		queue_set_hctx_shared(q, shared);
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 	}
 }
 
@@ -2708,7 +2708,7 @@ static int __blk_mq_update_nr_requests(struct request_queue *q,
 	if (!ret)
 		q->nr_requests = nr;
 
-	blk_mq_unfreeze_queue(q);
+	blk_unfreeze_queue(q);
 
 	return ret;
 }
@@ -2757,7 +2757,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	}
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
-		blk_mq_unfreeze_queue(q);
+		blk_unfreeze_queue(q);
 }
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
diff --git a/block/elevator.c b/block/elevator.c
index 0e465809d3f3..371c8165c9e8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -994,7 +994,7 @@ static int elevator_switch_mq(struct request_queue *q,
 		blk_add_trace_msg(q, "elv switch: none");
 
 out:
-	blk_mq_unfreeze_queue(q);
+	blk_unfreeze_queue(q);
 	return ret;
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 2fbd4089c20e..5c11ea44d470 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -217,7 +217,7 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
 	else
 		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 }
 
 static int
@@ -605,7 +605,7 @@ static int loop_switch(struct loop_device *lo, struct file *file)
 	do_loop_switch(lo, &w);
 
 	/* unfreeze */
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	return 0;
 }
@@ -1079,7 +1079,7 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
 		loop_reread_partitions(lo, bdev);
@@ -1191,7 +1191,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	__loop_update_dio(lo, lo->use_dio);
 
  exit:
-	blk_mq_unfreeze_queue(lo->lo_queue);
+	blk_unfreeze_queue(lo->lo_queue);
 
 	if (!err && (info->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(lo->lo_flags & LO_FLAGS_PARTSCAN)) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 37046ac2c441..5c76b0a96be2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1226,7 +1226,7 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 
 	if (ctrl->oncs & NVME_CTRL_ONCS_DSM)
 		nvme_config_discard(ns);
-	blk_mq_unfreeze_queue(disk->queue);
+	blk_unfreeze_queue(disk->queue);
 }
 
 static int nvme_revalidate_disk(struct gendisk *disk)
@@ -2753,7 +2753,7 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
-		blk_mq_unfreeze_queue(ns->queue);
+		blk_unfreeze_queue(ns->queue);
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
 EXPORT_SYMBOL_GPL(nvme_unfreeze);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 13f6c25fa461..2572e5641568 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -257,7 +257,7 @@ void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_mq_freeze_queue(struct request_queue *q);
-void blk_mq_unfreeze_queue(struct request_queue *q);
+void blk_unfreeze_queue(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
-- 
2.9.5
