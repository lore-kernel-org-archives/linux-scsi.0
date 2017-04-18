From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: block: remove the errors field from struct request
Date: Tue, 18 Apr 2017 08:52:29 -0700
Message-ID: <20170418155229.5977-24-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57441 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757451AbdDRPwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:52:49 -0400
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 block/blk-core.c             | 14 +-------------
 block/blk-exec.c             |  3 +--
 block/blk-mq.c               | 10 +++-------
 block/blk-timeout.c          |  1 -
 include/linux/blkdev.h       |  2 --
 include/trace/events/block.h | 17 +++++++----------
 kernel/trace/blktrace.c      | 26 ++++++++++++--------------
 7 files changed, 24 insertions(+), 49 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8654aa0cef6d..48f522a02f54 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1633,7 +1633,6 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	if (bio->bi_opf & REQ_RAHEAD)
 		req->cmd_flags |= REQ_FAILFAST_MASK;
 
-	req->errors = 0;
 	req->__sector = bio->bi_iter.bi_sector;
 	blk_rq_set_prio(req, rq_ioc(bio));
 	if (ioprio_valid(bio_prio(bio)))
@@ -2567,22 +2566,11 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
 	int total_bytes;
 
-	trace_block_rq_complete(req->q, req, nr_bytes);
+	trace_block_rq_complete(req, error, nr_bytes);
 
 	if (!req->bio)
 		return false;
 
-	/*
-	 * For fs requests, rq is just carrier of independent bio's
-	 * and each partial completion should be handled separately.
-	 * Reset per-request error on each partial completion.
-	 *
-	 * TODO: tj: This is too subtle.  It would be better to let
-	 * low level drivers do what they see fit.
-	 */
-	if (!blk_rq_is_passthrough(req))
-		req->errors = 0;
-
 	if (error && !blk_rq_is_passthrough(req) &&
 	    !(req->rq_flags & RQF_QUIET)) {
 		char *error_type;
diff --git a/block/blk-exec.c b/block/blk-exec.c
index afa383248c7c..a9451e3b8587 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -69,8 +69,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (unlikely(blk_queue_dying(q))) {
 		rq->rq_flags |= RQF_QUIET;
-		rq->errors = -ENXIO;
-		__blk_end_request_all(rq, rq->errors);
+		__blk_end_request_all(rq, -ENXIO);
 		spin_unlock_irq(q->queue_lock);
 		return;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1f98db082da3..f5e3cf153ad7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -213,7 +213,6 @@ void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 #endif
 	rq->special = NULL;
 	/* tag was already set */
-	rq->errors = 0;
 	rq->extra_len = 0;
 
 	INIT_LIST_HEAD(&rq->timeout_list);
@@ -624,8 +623,7 @@ void blk_mq_abort_requeue_list(struct request_queue *q)
 
 		rq = list_first_entry(&rq_list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
-		rq->errors = -EIO;
-		blk_mq_end_request(rq, rq->errors);
+		blk_mq_end_request(rq, -EIO);
 	}
 }
 EXPORT_SYMBOL(blk_mq_abort_requeue_list);
@@ -1032,8 +1030,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
 		case BLK_MQ_RQ_QUEUE_ERROR:
 			errors++;
-			rq->errors = -EIO;
-			blk_mq_end_request(rq, rq->errors);
+			blk_mq_end_request(rq, -EIO);
 			break;
 		}
 
@@ -1484,8 +1481,7 @@ static void __blk_mq_try_issue_directly(struct request *rq, blk_qc_t *cookie,
 
 	if (ret == BLK_MQ_RQ_QUEUE_ERROR) {
 		*cookie = BLK_QC_T_NONE;
-		rq->errors = -EIO;
-		blk_mq_end_request(rq, rq->errors);
+		blk_mq_end_request(rq, -EIO);
 		return;
 	}
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index a30441a200c0..cbff183f3d9f 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -89,7 +89,6 @@ static void blk_rq_timed_out(struct request *req)
 		ret = q->rq_timed_out_fn(req);
 	switch (ret) {
 	case BLK_EH_HANDLED:
-		/* Can we use req->errors here? */
 		__blk_complete_request(req);
 		break;
 	case BLK_EH_RESET_TIMER:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e618164462e8..d40ac947ae26 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -220,8 +220,6 @@ struct request {
 
 	void *special;		/* opaque pointer available for LLD use */
 
-	int errors;
-
 	unsigned int extra_len;	/* length of alignment and padding */
 
 	unsigned long deadline;
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 99ed69fad041..d0dbe60d8a6d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -80,7 +80,6 @@ TRACE_EVENT(block_rq_requeue,
 		__field(  dev_t,	dev			)
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
-		__field(  int,		errors			)
 		__array(  char,		rwbs,	RWBS_LEN	)
 		__dynamic_array( char,	cmd,	1		)
 	),
@@ -89,7 +88,6 @@ TRACE_EVENT(block_rq_requeue,
 		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
-		__entry->errors    = rq->errors;
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		__get_str(cmd)[0] = '\0';
@@ -99,13 +97,13 @@ TRACE_EVENT(block_rq_requeue,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+		  __entry->nr_sector, 0)
 );
 
 /**
  * block_rq_complete - block IO operation completed by device driver
- * @q: queue containing the block operation request
  * @rq: block operations request
+ * @error: status code
  * @nr_bytes: number of completed bytes
  *
  * The block_rq_complete tracepoint event indicates that some portion
@@ -116,16 +114,15 @@ TRACE_EVENT(block_rq_requeue,
  */
 TRACE_EVENT(block_rq_complete,
 
-	TP_PROTO(struct request_queue *q, struct request *rq,
-		 unsigned int nr_bytes),
+	TP_PROTO(struct request *rq, int error, unsigned int nr_bytes),
 
-	TP_ARGS(q, rq, nr_bytes),
+	TP_ARGS(rq, error, nr_bytes),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
-		__field(  int,		errors			)
+		__field(  int,		error			)
 		__array(  char,		rwbs,	RWBS_LEN	)
 		__dynamic_array( char,	cmd,	1		)
 	),
@@ -134,7 +131,7 @@ TRACE_EVENT(block_rq_complete,
 		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
 		__entry->sector    = blk_rq_pos(rq);
 		__entry->nr_sector = nr_bytes >> 9;
-		__entry->errors    = rq->errors;
+		__entry->error     = error;
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, nr_bytes);
 		__get_str(cmd)[0] = '\0';
@@ -144,7 +141,7 @@ TRACE_EVENT(block_rq_complete,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+		  __entry->nr_sector, __entry->error)
 );
 
 DECLARE_EVENT_CLASS(block_rq,
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 9f3624dadb09..bd8ae8d5ae9c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -690,8 +690,8 @@ void blk_trace_shutdown(struct request_queue *q)
 
 /**
  * blk_add_trace_rq - Add a trace for a request oriented action
- * @q:		queue the io is for
  * @rq:		the source request
+ * @error:	return status to log
  * @nr_bytes:	number of completed bytes
  * @what:	the action
  *
@@ -699,10 +699,10 @@ void blk_trace_shutdown(struct request_queue *q)
  *     Records an action against a request. Will log the bio offset + size.
  *
  **/
-static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
+static void blk_add_trace_rq(struct request *rq, int error,
 			     unsigned int nr_bytes, u32 what)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt = rq->q->blk_trace;
 
 	if (likely(!bt))
 		return;
@@ -713,34 +713,32 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 		what |= BLK_TC_ACT(BLK_TC_FS);
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), nr_bytes, req_op(rq),
-			rq->cmd_flags, what, rq->errors, 0, NULL);
+			rq->cmd_flags, what, error, 0, NULL);
 }
 
 static void blk_add_trace_rq_insert(void *ignore,
 				    struct request_queue *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_INSERT);
+	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT);
 }
 
 static void blk_add_trace_rq_issue(void *ignore,
 				   struct request_queue *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_ISSUE);
+	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_ISSUE);
 }
 
 static void blk_add_trace_rq_requeue(void *ignore,
 				     struct request_queue *q,
 				     struct request *rq)
 {
-	blk_add_trace_rq(q, rq, blk_rq_bytes(rq), BLK_TA_REQUEUE);
+	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_REQUEUE);
 }
 
-static void blk_add_trace_rq_complete(void *ignore,
-				      struct request_queue *q,
-				      struct request *rq,
-				      unsigned int nr_bytes)
+static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
+			int error, unsigned int nr_bytes)
 {
-	blk_add_trace_rq(q, rq, nr_bytes, BLK_TA_COMPLETE);
+	blk_add_trace_rq(rq, error, nr_bytes, BLK_TA_COMPLETE);
 }
 
 /**
@@ -935,7 +933,7 @@ static void blk_add_trace_rq_remap(void *ignore,
 	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
-			rq_data_dir(rq), 0, BLK_TA_REMAP, !!rq->errors,
+			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
 			sizeof(r), &r);
 }
 
@@ -960,7 +958,7 @@ void blk_add_driver_data(struct request_queue *q,
 		return;
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), blk_rq_bytes(rq), 0, 0,
-				BLK_TA_DRV_DATA, rq->errors, len, data);
+				BLK_TA_DRV_DATA, 0, len, data);
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
-- 
2.11.0
