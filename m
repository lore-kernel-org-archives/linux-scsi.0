From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/5] blk-mq: free hw queues in queue's release handler
Date: Sun, 31 Mar 2019 11:09:52 +0800
Message-ID: <20190331030954.22320-4-ming.lei@redhat.com>
References: <20190331030954.22320-1-ming.lei@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190331030954.22320-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, James Smart <james.smart@broadcom.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, jianchao wang <jianchao.w.wang@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Once blk_cleanup_queue() returns, tags shouldn't be used any more,
because blk_mq_free_tag_set() may be called. Commit 45a9c9d909b2
("blk-mq: Fix a use-after-free") fixes this issue exactly.

However, that commit introduces another issue. Before 45a9c9d909b2,
we are allowed to run queue during cleaning up queue if the queue
refcount is held. After this commit, queue can't be run during
queue cleaning up, otherwise oops can be triggered easily because
some fields of hctx are freed by blk_mq_free_queue() in blk_cleanup_queue().

We have invented ways for addressing this kind of issue before, such as:

	8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
	c2856ae2f315 ("blk-mq: quiesce queue before freeing queue")

But still can't cover all cases, recently James reports another such
kind of issue:

	https://marc.info/?l=linux-scsi&m=155389088124782&w=2

This issue can be quite hard to address by previous way, given
scsi_run_queue() may run requeues for other LUNs.

Fixes the above issue by splitting blk_mq_free_queue() into two parts:
one part is for exit hw queues, another is for free hw queues. The latter
is moved to queue's release handler, and this way is safe becasue tags
isn't needed for the freeing hw queues.

Cc: James Smart <james.smart@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org,
Cc: Martin K . Petersen <martin.petersen@oracle.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>,
Cc: jianchao wang <jianchao.w.wang@oracle.com>
Reported-by: James Smart <james.smart@broadcom.com>
Fixes: 45a9c9d909b2 ("blk-mq: Fix a use-after-free")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 2 +-
 block/blk-mq.c   | 8 +++++---
 block/blk-mq.h   | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4673ebe42255..b3bbf8a5110d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -375,7 +375,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_exit_queue(q);
 
 	if (queue_is_mq(q))
-		blk_mq_free_queue(q);
+		blk_mq_exit_queue(q);
 
 	percpu_ref_exit(&q->q_usage_counter);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a264d1967396..14a8db13ba73 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2269,7 +2269,7 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
 	}
 }
 
-static void blk_mq_free_hw_queues(struct request_queue *q)
+void blk_mq_free_hw_queues(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
@@ -2625,6 +2625,8 @@ void blk_mq_release(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 
+	blk_mq_free_hw_queues(q);
+
 	/* hctx kobj stays in hctx */
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (!hctx)
@@ -2896,13 +2898,13 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 }
 EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 
-void blk_mq_free_queue(struct request_queue *q)
+/* tags can _not_ be used after returning from blk_mq_exit_queue */
+void blk_mq_exit_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set	*set = q->tag_set;
 
 	blk_mq_del_queue_tag_set(q);
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
-	blk_mq_free_hw_queues(q);
 }
 
 static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 0ed8e5a8729f..46f8b14c8d1d 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -37,7 +37,8 @@ struct blk_mq_ctx {
 	struct kobject		kobj;
 } ____cacheline_aligned_in_smp;
 
-void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_exit_queue(struct request_queue *q);
+void blk_mq_free_hw_queues(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
 bool blk_mq_dispatch_rq_list(struct request_queue *, struct list_head *, bool);
-- 
2.9.5
