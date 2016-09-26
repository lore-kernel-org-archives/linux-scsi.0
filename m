From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/9] block: Move blk_freeze_queue() and blk_unfreeze_queue()
 code
Date: Mon, 26 Sep 2016 11:27:28 -0700
Message-ID: <f990694e-76ea-f6b1-10a4-c23b9a738b39@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Move the blk_freeze_queue() and blk_unfreeze_queue() implementations
from block/blk-mq.c to block/blk-core.c. Drop "_mq" from the name of
the functions that have been moved.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 block/blk-core.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq.c   | 41 +++--------------------------------------
 block/blk.h      |  3 +++
 3 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b75d688..8cc8006 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -682,6 +682,51 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	wake_up_all(&q->mq_freeze_wq);
 }
 
+void blk_freeze_queue_start(struct request_queue *q)
+{
+	int freeze_depth;
+
+	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
+	if (freeze_depth == 1) {
+		percpu_ref_kill(&q->q_usage_counter);
+		blk_mq_run_hw_queues(q, false);
+	}
+}
+
+void blk_freeze_queue_wait(struct request_queue *q)
+{
+	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
+}
+
+/*
+ * Guarantee no request is in use, so we can change any data structure of
+ * the queue afterward.
+ */
+void blk_freeze_queue(struct request_queue *q)
+{
+	/*
+	 * In the !blk_mq case we are only calling this to kill the
+	 * q_usage_counter, otherwise this increases the freeze depth
+	 * and waits for it to return to zero.  For this reason there is
+	 * no blk_unfreeze_queue(), and blk_freeze_queue() is not
+	 * exported to drivers as the only user for unfreeze is blk_mq.
+	 */
+	blk_freeze_queue_start(q);
+	blk_freeze_queue_wait(q);
+}
+
+void blk_unfreeze_queue(struct request_queue *q)
+{
+	int freeze_depth;
+
+	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
+	WARN_ON_ONCE(freeze_depth < 0);
+	if (!freeze_depth) {
+		percpu_ref_reinit(&q->q_usage_counter);
+		wake_up_all(&q->mq_freeze_wq);
+	}
+}
+
 static void blk_rq_timed_out_timer(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *)data;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 98d4812..50b26df 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -60,38 +60,10 @@ static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
 
 void blk_mq_freeze_queue_start(struct request_queue *q)
 {
-	int freeze_depth;
-
-	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
-	if (freeze_depth == 1) {
-		percpu_ref_kill(&q->q_usage_counter);
-		blk_mq_run_hw_queues(q, false);
-	}
+	blk_freeze_queue_start(q);
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_start);
 
-static void blk_mq_freeze_queue_wait(struct request_queue *q)
-{
-	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
-}
-
-/*
- * Guarantee no request is in use, so we can change any data structure of
- * the queue afterward.
- */
-void blk_freeze_queue(struct request_queue *q)
-{
-	/*
-	 * In the !blk_mq case we are only calling this to kill the
-	 * q_usage_counter, otherwise this increases the freeze depth
-	 * and waits for it to return to zero.  For this reason there is
-	 * no blk_unfreeze_queue(), and blk_freeze_queue() is not
-	 * exported to drivers as the only user for unfreeze is blk_mq.
-	 */
-	blk_mq_freeze_queue_start(q);
-	blk_mq_freeze_queue_wait(q);
-}
-
 void blk_mq_freeze_queue(struct request_queue *q)
 {
 	/*
@@ -104,14 +76,7 @@ EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
 
 void blk_mq_unfreeze_queue(struct request_queue *q)
 {
-	int freeze_depth;
-
-	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
-	WARN_ON_ONCE(freeze_depth < 0);
-	if (!freeze_depth) {
-		percpu_ref_reinit(&q->q_usage_counter);
-		wake_up_all(&q->mq_freeze_wq);
-	}
+	blk_unfreeze_queue(q);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
@@ -2177,7 +2142,7 @@ static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 	list_for_each_entry(q, &all_q_list, all_q_node)
 		blk_mq_freeze_queue_start(q);
 	list_for_each_entry(q, &all_q_list, all_q_node) {
-		blk_mq_freeze_queue_wait(q);
+		blk_freeze_queue_wait(q);
 
 		/*
 		 * timeout handler can't touch hw queue during the
diff --git a/block/blk.h b/block/blk.h
index c37492f..12f7366 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -71,6 +71,9 @@ void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
 			    unsigned int nr_bytes, unsigned int bidi_bytes);
 void blk_freeze_queue(struct request_queue *q);
+void blk_freeze_queue_start(struct request_queue *q);
+void blk_freeze_queue_wait(struct request_queue *q);
+void blk_unfreeze_queue(struct request_queue *q);
 
 static inline void blk_queue_enter_live(struct request_queue *q)
 {
-- 
2.10.0

