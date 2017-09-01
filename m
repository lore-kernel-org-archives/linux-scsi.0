From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 4/8] blk-mq: rename blk_mq_freeze_queue_wait as blk_freeze_queue_wait
Date: Sat,  2 Sep 2017 02:49:54 +0800
Message-ID: <20170901184958.19452-6-ming.lei@redhat.com>
References: <20170901184958.19452-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901184958.19452-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The only change on legacy is that blk_drain_queue() is run
from blk_freeze_queue(), which is called in blk_cleanup_queue().

So this patch removes the explicite __blk_drain_queue() in
blk_cleanup_queue().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c         | 17 +++++++++++++++--
 block/blk-mq.c           |  8 +++++---
 block/blk.h              |  1 +
 drivers/nvme/host/core.c |  2 +-
 include/linux/blk-mq.h   |  2 +-
 5 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d579501f24ba..ce2d3b6f6c62 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -530,6 +530,21 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 }
 
 /**
+ * blk_drain_queue - drain requests from request_queue
+ * @q: queue to drain
+ *
+ * Drain requests from @q.  All pending requests are drained.
+ * The caller is responsible for ensuring that no new requests
+ * which need to be drained are queued.
+ */
+void blk_drain_queue(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	__blk_drain_queue(q, true);
+	spin_unlock_irq(q->queue_lock);
+}
+
+/**
  * blk_queue_bypass_start - enter queue bypass mode
  * @q: queue of interest
  *
@@ -653,8 +668,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_freeze_queue(q);
 	spin_lock_irq(lock);
-	if (!q->mq_ops)
-		__blk_drain_queue(q, true);
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c532d8612e1..24de78afbe9a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -131,11 +131,13 @@ void blk_freeze_queue_start(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
-void blk_mq_freeze_queue_wait(struct request_queue *q)
+void blk_freeze_queue_wait(struct request_queue *q)
 {
+	if (!q->mq_ops)
+		blk_drain_queue(q);
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
 }
-EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
+EXPORT_SYMBOL_GPL(blk_freeze_queue_wait);
 
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout)
@@ -160,7 +162,7 @@ void blk_freeze_queue(struct request_queue *q)
 	 * exported to drivers as the only user for unfreeze is blk_mq.
 	 */
 	blk_freeze_queue_start(q);
-	blk_mq_freeze_queue_wait(q);
+	blk_freeze_queue_wait(q);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
diff --git a/block/blk.h b/block/blk.h
index 6847c5435cca..242486e26a81 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -64,6 +64,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 void blk_queue_bypass_start(struct request_queue *q);
 void blk_queue_bypass_end(struct request_queue *q);
+void blk_drain_queue(struct request_queue *q);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 void blk_freeze_queue(struct request_queue *q);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 986f2b4f9760..d34a9ffaa940 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2778,7 +2778,7 @@ void nvme_wait_freeze(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
-		blk_mq_freeze_queue_wait(ns->queue);
+		blk_freeze_queue_wait(ns->queue);
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
 EXPORT_SYMBOL_GPL(nvme_wait_freeze);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8ae77e088c01..f90d78eb85df 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,7 +259,7 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 void blk_freeze_queue(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
-void blk_mq_freeze_queue_wait(struct request_queue *q);
+void blk_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
 int blk_mq_reinit_tagset(struct blk_mq_tag_set *set,
-- 
2.9.5
