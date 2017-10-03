From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 6/8] blk-mq: return if queue is frozen via current blk_freeze_queue_start
Date: Tue,  3 Oct 2017 22:04:04 +0800
Message-ID: <20171003140406.26060-7-ming.lei@redhat.com>
References: <20171003140406.26060-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003140406.26060-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

We need this return value in the following patch to decide
if a explicit synchronize_rcu() is needed.

Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 13 ++++++++-----
 block/blk-mq.h         |  1 -
 block/blk.h            |  2 +-
 include/linux/blk-mq.h |  4 ++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index bf89549074bb..80d6dd99d7f1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -118,7 +118,7 @@ void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
 }
 
-void blk_freeze_queue_start(struct request_queue *q)
+bool blk_freeze_queue_start(struct request_queue *q)
 {
 	int freeze_depth;
 
@@ -127,7 +127,9 @@ void blk_freeze_queue_start(struct request_queue *q)
 		percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
 			blk_mq_run_hw_queues(q, false);
+		return true;
 	}
+	return false;
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
@@ -150,7 +152,7 @@ EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait_timeout);
  * Guarantee no request is in use, so we can change any data structure of
  * the queue afterward.
  */
-void blk_freeze_queue(struct request_queue *q)
+bool blk_freeze_queue(struct request_queue *q)
 {
 	/*
 	 * In the !blk_mq case we are only calling this to kill the
@@ -159,17 +161,18 @@ void blk_freeze_queue(struct request_queue *q)
 	 * no blk_unfreeze_queue(), and blk_freeze_queue() is not
 	 * exported to drivers as the only user for unfreeze is blk_mq.
 	 */
-	blk_freeze_queue_start(q);
+	bool ret = blk_freeze_queue_start(q);
 	blk_mq_freeze_queue_wait(q);
+	return ret;
 }
 
-void blk_mq_freeze_queue(struct request_queue *q)
+bool blk_mq_freeze_queue(struct request_queue *q)
 {
 	/*
 	 * ...just an alias to keep freeze and unfreeze actions balanced
 	 * in the blk_mq_* namespace
 	 */
-	blk_freeze_queue(q);
+	return blk_freeze_queue(q);
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
 
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
diff --git a/block/blk.h b/block/blk.h
index fcb9775b997d..fa1b33d3fcbd 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -65,7 +65,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 void blk_queue_bypass_start(struct request_queue *q);
 void blk_queue_bypass_end(struct request_queue *q);
 void __blk_queue_free_tags(struct request_queue *q);
-void blk_freeze_queue(struct request_queue *q);
+bool blk_freeze_queue(struct request_queue *q);
 
 static inline void blk_queue_enter_live(struct request_queue *q)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 50c6485cb04f..d6195925e6c3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -253,9 +253,9 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
-void blk_mq_freeze_queue(struct request_queue *q);
+bool blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_unfreeze_queue(struct request_queue *q);
-void blk_freeze_queue_start(struct request_queue *q);
+bool blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
-- 
2.9.5
