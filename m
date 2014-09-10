From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 08:41:44 -0700
Message-ID: <20140910154144.GA22296@infradead.org>
References: <540FCB96.8000606@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaIJPlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 11:41:45 -0400
Content-Disposition: inline
In-Reply-To: <540FCB96.8000606@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

While it might not help with a blown stack, can you give the patch below
a try?  I tries to solve a problem where the timeout handler hits
before we've fully set up a command.  While I'd like to understand the
root cause of why we're hitting it as well, I'd also really to fix that
race. It would also be good to get a gdb listing of the exact area in
scsi_times_out listed in the oops.

---
From: Christoph Hellwig <hch@lst.de>
Subject: blk-mq: call blk_mq_start_request from ->queue_rq

When we call blk_mq_start_request from the core blk-mq code before calling into
->queue_rq there is a racy window where the timeout handler can hit before we've
fully set up the driver specific part of the command.

Move the call to blk_mq_start_request into the driver so the driver can start
the request only once it is fully set up.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5189cb1..db9990b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -374,7 +374,7 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-static void blk_mq_start_request(struct request *rq, bool last)
+void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
@@ -405,29 +405,18 @@ static void blk_mq_start_request(struct request *rq, bool last)
 		 */
 		rq->nr_phys_segments++;
 	}
-
-	/*
-	 * Flag the last request in the series so that drivers know when IO
-	 * should be kicked off, if they don't do it on a per-request basis.
-	 *
-	 * Note: the flag isn't the only condition drivers should do kick off.
-	 * If drive is busy, the last request might not have the bit set.
-	 */
-	if (last)
-		rq->cmd_flags |= REQ_END;
 }
+EXPORT_SYMBOL(blk_mq_start_request);
 
 static void __blk_mq_requeue_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
 	trace_block_rq_requeue(q, rq);
-	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
-
-	rq->cmd_flags &= ~REQ_END;
-
-	if (q->dma_drain_size && blk_rq_bytes(rq))
-		rq->nr_phys_segments--;
+	if (test_and_clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags)) {
+		if (q->dma_drain_size && blk_rq_bytes(rq))
+			rq->nr_phys_segments--;
+	}
 }
 
 void blk_mq_requeue_request(struct request *rq)
@@ -735,9 +724,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		rq = list_first_entry(&rq_list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 
-		blk_mq_start_request(rq, list_empty(&rq_list));
-
-		ret = q->mq_ops->queue_rq(hctx, rq);
+		ret = q->mq_ops->queue_rq(hctx, rq, list_empty(&rq_list));
 		switch (ret) {
 		case BLK_MQ_RQ_QUEUE_OK:
 			queued++;
@@ -1177,14 +1164,13 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		int ret;
 
 		blk_mq_bio_to_request(rq, bio);
-		blk_mq_start_request(rq, true);
 
 		/*
 		 * For OK queue, we are done. For error, kill it. Any other
 		 * error (busy), just add it to our list as we previously
 		 * would have done
 		 */
-		ret = q->mq_ops->queue_rq(data.hctx, rq);
+		ret = q->mq_ops->queue_rq(data.hctx, rq, true);
 		if (ret == BLK_MQ_RQ_QUEUE_OK)
 			goto done;
 		else {
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index db1e956..9b0127a 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3775,13 +3775,16 @@ static bool mtip_check_unal_depth(struct blk_mq_hw_ctx *hctx,
 	return false;
 }
 
-static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq,
+		bool last)
 {
 	int ret;
 
 	if (unlikely(mtip_check_unal_depth(hctx, rq)))
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
+	blk_mq_start_request(rq);
+
 	ret = mtip_submit_request(hctx, rq);
 	if (likely(!ret))
 		return BLK_MQ_RQ_QUEUE_OK;
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index a3b042c..d098adfbb 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -313,10 +313,13 @@ static void null_request_fn(struct request_queue *q)
 	}
 }
 
-static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq,
+		bool last)
 {
 	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
+	blk_mq_start_request(rq);
+
 	cmd->rq = rq;
 	cmd->nq = hctx->driver_data;
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0a58140..4b08906 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -164,14 +164,14 @@ static void virtblk_done(struct virtqueue *vq)
 	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 }
 
-static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
+		bool last)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
 	unsigned int num;
 	int qid = hctx->queue_num;
-	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
 	bool notify = false;
 
@@ -213,6 +213,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 	}
 
+	blk_mq_start_request(req);
+
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
 	err = __virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
 	if (err) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c44392..dd6e912 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1856,7 +1856,8 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 	blk_mq_complete_request(cmd->request);
 }
 
-static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
+		bool last)
 {
 	struct request_queue *q = req->q;
 	struct scsi_device *sdev = q->queuedata;
@@ -1890,6 +1891,8 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
+	blk_mq_start_request(req);
+
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eb726b9..aed92d5 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -77,7 +77,7 @@ struct blk_mq_tag_set {
 	struct list_head	tag_list;
 };
 
-typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
+typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *, bool);
 typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
@@ -160,6 +160,7 @@ struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
 
+void blk_mq_start_request(struct request *rq);
 void blk_mq_end_io(struct request *rq, int error);
 void __blk_mq_end_io(struct request *rq, int error);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 66c2167..bb7d664 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -188,7 +188,6 @@ enum rq_flag_bits {
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_PM,		/* runtime pm request */
-	__REQ_END,		/* last of chain of requests */
 	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_MQ_INFLIGHT,	/* track inflight for MQ */
 	__REQ_NR_BITS,		/* stops here */
@@ -242,7 +241,6 @@ enum rq_flag_bits {
 #define REQ_SECURE		(1ULL << __REQ_SECURE)
 #define REQ_KERNEL		(1ULL << __REQ_KERNEL)
 #define REQ_PM			(1ULL << __REQ_PM)
-#define REQ_END			(1ULL << __REQ_END)
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
 
