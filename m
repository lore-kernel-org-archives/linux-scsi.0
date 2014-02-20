From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] blk-mq: support partial I/O completions
Date: Thu, 20 Feb 2014 15:32:38 -0800
Message-ID: <20140220233352.536068886@bombadil.infradead.org>
References: <20140220233235.443299098@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0003-blk-mq-support-partial-I-O-completions.patch
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a new blk_mq_end_io_partial function to partially complete requests
as needed by the SCSI layer.  We do this by reusing blk_update_request
to advance the bio instead of having a simplified version of it in
the blk-mq code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   37 +++++--------------------------------
 include/linux/blk-mq.h |    8 +++++++-
 2 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2af8405..1b8b50d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -283,38 +283,10 @@ void blk_mq_free_request(struct request *rq)
 	__blk_mq_free_request(hctx, ctx, rq);
 }
 
-static void blk_mq_bio_endio(struct request *rq, struct bio *bio, int error)
+bool blk_mq_end_io_partial(struct request *rq, int error, unsigned int nr_bytes)
 {
-	if (error)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
-
-	if (unlikely(rq->cmd_flags & REQ_QUIET))
-		set_bit(BIO_QUIET, &bio->bi_flags);
-
-	/* don't actually finish bio if it's part of flush sequence */
-	if (!(rq->cmd_flags & REQ_FLUSH_SEQ))
-		bio_endio(bio, error);
-}
-
-void blk_mq_end_io(struct request *rq, int error)
-{
-	struct bio *bio = rq->bio;
-	unsigned int bytes = 0;
-
-	trace_block_rq_complete(rq->q, rq);
-
-	while (bio) {
-		struct bio *next = bio->bi_next;
-
-		bio->bi_next = NULL;
-		bytes += bio->bi_iter.bi_size;
-		blk_mq_bio_endio(rq, bio, error);
-		bio = next;
-	}
-
-	blk_account_io_completion(rq, bytes);
+	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
+		return true;
 
 	blk_account_io_done(rq);
 
@@ -322,8 +294,9 @@ void blk_mq_end_io(struct request *rq, int error)
 		rq->end_io(rq, error);
 	else
 		blk_mq_free_request(rq);
+	return false;
 }
-EXPORT_SYMBOL(blk_mq_end_io);
+EXPORT_SYMBOL(blk_mq_end_io_partial);
 
 static void __blk_mq_complete_request_remote(void *data)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ff28fe3..2ff2e8d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -133,7 +133,13 @@ struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_ind
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_reg *, unsigned int);
 void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
 
-void blk_mq_end_io(struct request *rq, int error);
+bool blk_mq_end_io_partial(struct request *rq, int error,
+		unsigned int nr_bytes);
+static inline void blk_mq_end_io(struct request *rq, int error)
+{
+	bool done = !blk_mq_end_io_partial(rq, error, blk_rq_bytes(rq));
+	BUG_ON(!done);
+}
 
 void blk_mq_complete_request(struct request *rq);
 
-- 
1.7.10.4
