From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] blk-mq: allow drivers to hook into I/O completion
Date: Wed, 16 Apr 2014 09:44:52 +0200
Message-ID: <1397634299-7466-2-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Split out the bottom half of blk_mq_end_io so that drivers can perform
work when they know a request has been completed, but before it has been
freed.  This also obsoletes blk_mq_end_io_partial as drivers can now
pass any value to blk_update_request directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   16 ++++++++++------
 include/linux/blk-mq.h |    9 ++-------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 360a1d9..e921085 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -294,20 +294,24 @@ void blk_mq_clone_flush_request(struct request *flush_rq,
 		hctx->cmd_size);
 }
 
-bool blk_mq_end_io_partial(struct request *rq, int error, unsigned int nr_bytes)
+inline void __blk_mq_end_io(struct request *rq, int error)
 {
-	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
-		return true;
-
 	blk_account_io_done(rq);
 
 	if (rq->end_io)
 		rq->end_io(rq, error);
 	else
 		blk_mq_free_request(rq);
-	return false;
 }
-EXPORT_SYMBOL(blk_mq_end_io_partial);
+EXPORT_SYMBOL(__blk_mq_end_io);
+
+void blk_mq_end_io(struct request *rq, int error)
+{
+	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
+		BUG();
+	__blk_mq_end_io(rq, error);
+}
+EXPORT_SYMBOL(blk_mq_end_io);
 
 static void __blk_mq_complete_request_remote(void *data)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a4ea0ce..a81b474 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -149,13 +149,8 @@ struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_ind
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int);
 void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
 
-bool blk_mq_end_io_partial(struct request *rq, int error,
-		unsigned int nr_bytes);
-static inline void blk_mq_end_io(struct request *rq, int error)
-{
-	bool done = !blk_mq_end_io_partial(rq, error, blk_rq_bytes(rq));
-	BUG_ON(!done);
-}
+void blk_mq_end_io(struct request *rq, int error);
+void __blk_mq_end_io(struct request *rq, int error);
 
 void blk_mq_complete_request(struct request *rq);
 
-- 
1.7.10.4
