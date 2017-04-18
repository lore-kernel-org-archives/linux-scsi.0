From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: blktrace: remove the unused block_rq_abort tracepoint
Date: Tue, 18 Apr 2017 08:52:28 -0700
Message-ID: <20170418155229.5977-23-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/trace/events/block.h | 44 ++++++++++----------------------------------
 kernel/trace/blktrace.c      |  9 ---------
 2 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index a88ed13446ff..99ed69fad041 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -61,7 +61,16 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
 	TP_ARGS(bh)
 );
 
-DECLARE_EVENT_CLASS(block_rq_with_error,
+/**
+ * block_rq_requeue - place block IO request back on a queue
+ * @q: queue holding operation
+ * @rq: block IO operation request
+ *
+ * The block operation request @rq is being placed back into queue
+ * @q.  For some reason the request was not completed and needs to be
+ * put back in the queue.
+ */
+TRACE_EVENT(block_rq_requeue,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
 
@@ -94,39 +103,6 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 );
 
 /**
- * block_rq_abort - abort block operation request
- * @q: queue containing the block operation request
- * @rq: block IO operation request
- *
- * Called immediately after pending block IO operation request @rq in
- * queue @q is aborted. The fields in the operation request @rq
- * can be examined to determine which device and sectors the pending
- * operation would access.
- */
-DEFINE_EVENT(block_rq_with_error, block_rq_abort,
-
-	TP_PROTO(struct request_queue *q, struct request *rq),
-
-	TP_ARGS(q, rq)
-);
-
-/**
- * block_rq_requeue - place block IO request back on a queue
- * @q: queue holding operation
- * @rq: block IO operation request
- *
- * The block operation request @rq is being placed back into queue
- * @q.  For some reason the request was not completed and needs to be
- * put back in the queue.
- */
-DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
-
-	TP_PROTO(struct request_queue *q, struct request *rq),
-
-	TP_ARGS(q, rq)
-);
-
-/**
  * block_rq_complete - block IO operation completed by device driver
  * @q: queue containing the block operation request
  * @rq: block operations request
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b2058a7f94bd..9f3624dadb09 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -716,12 +716,6 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 			rq->cmd_flags, what, rq->errors, 0, NULL);
 }
 
-static void blk_add_trace_rq_abort(void *ignore,
-				   struct request_queue *q, struct request *rq)
-{
-	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_ABORT);
-}
-
 static void blk_add_trace_rq_insert(void *ignore,
 				    struct request_queue *q, struct request *rq)
 {
@@ -974,8 +968,6 @@ static void blk_register_tracepoints(void)
 {
 	int ret;
 
-	ret = register_trace_block_rq_abort(blk_add_trace_rq_abort, NULL);
-	WARN_ON(ret);
 	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
 	WARN_ON(ret);
 	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
@@ -1028,7 +1020,6 @@ static void blk_unregister_tracepoints(void)
 	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
 	unregister_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
 	unregister_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
-	unregister_trace_block_rq_abort(blk_add_trace_rq_abort, NULL);
 
 	tracepoint_synchronize_unregister();
 }
-- 
2.11.0
