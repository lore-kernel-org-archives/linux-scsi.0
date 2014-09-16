From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] blk-mq: avoid infite recursion with the FUA
Date: Tue, 16 Sep 2014 14:44:07 -0700
Message-ID: <1410903847-18519-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We should not insert requests into the flush state machine from
blk_mq_insert_request.  All incoming flush requests come through
blk_{m,s}q_make_request and are handled there, while blk_execute_rq_nowait
should only be called for BLOCK_PC requests.  All other callers
deal with requests that already went through the flush statemchine
and shouldn't be reinserted into it.

Reported-by: Robert Elliott  <Elliott@hp.com>
Debugged-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c |  1 +
 block/blk-mq.c   | 11 +++--------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index f4d27b1..9924725 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -56,6 +56,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	bool is_pm_resume;
 
 	WARN_ON(irqs_disabled());
+	WARN_ON(rq->cmd_type == REQ_TYPE_FS);
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383ea0c..7373949 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -957,14 +957,9 @@ void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
 
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA) &&
-	    !(rq->cmd_flags & (REQ_FLUSH_SEQ))) {
-		blk_insert_flush(rq);
-	} else {
-		spin_lock(&ctx->lock);
-		__blk_mq_insert_request(hctx, rq, at_head);
-		spin_unlock(&ctx->lock);
-	}
+	spin_lock(&ctx->lock);
+	__blk_mq_insert_request(hctx, rq, at_head);
+	spin_unlock(&ctx->lock);
 
 	if (run_queue)
 		blk_mq_run_hw_queue(hctx, async);
-- 
1.9.1
