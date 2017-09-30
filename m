From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 5/7] blk-mq-sched: move actual dispatching into one helper
Date: Sat, 30 Sep 2017 18:27:18 +0800
Message-ID: <20170930102720.30219-6-ming.lei@redhat.com>
References: <20170930102720.30219-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930102720.30219-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

So that it becomes easy to support to dispatch from
sw queue in the following patch.

No functional change.

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Tom Nguyen <tom81094@gmail.com>
Tested-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index eca011fdfa0e..538f363f39ca 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -89,6 +89,22 @@ static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
 	return false;
 }
 
+static void blk_mq_do_dispatch_sched(struct request_queue *q,
+				     struct elevator_queue *e,
+				     struct blk_mq_hw_ctx *hctx)
+{
+	LIST_HEAD(rq_list);
+
+	do {
+		struct request *rq;
+
+		rq = e->type->ops.mq.dispatch_request(hctx);
+		if (!rq)
+			break;
+		list_add(&rq->queuelist, &rq_list);
+	} while (blk_mq_dispatch_rq_list(q, &rq_list));
+}
+
 void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
@@ -136,16 +152,8 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 	 * on the dispatch list or we were able to dispatch from the
 	 * dispatch list.
 	 */
-	if (do_sched_dispatch && has_sched_dispatch) {
-		do {
-			struct request *rq;
-
-			rq = e->type->ops.mq.dispatch_request(hctx);
-			if (!rq)
-				break;
-			list_add(&rq->queuelist, &rq_list);
-		} while (blk_mq_dispatch_rq_list(q, &rq_list));
-	}
+	if (do_sched_dispatch && has_sched_dispatch)
+		blk_mq_do_dispatch_sched(q, e, hctx);
 }
 
 bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
-- 
2.9.5
