From: James Bottomley <James.Bottomley@suse.de>
Subject: [RFC 1/2] block: implement an unprep function corresponding
 directly to prep
Date: Wed, 30 Jun 2010 12:01:04 -0500
Message-ID: <1277917264.2839.153.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab0F3RBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 13:01:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.or>

So this is more directly what I'm thinking.  It gives us an exactly
correct place to hang the discard allocation in SCSI.  The next patch
shows a potential implementation in sd.

I think it should avoid all the leaks people have been seeing trying to
move the discard allocation/free into scsi.  I also think it should
facilitate sending discard through SCSI as a REQ_TYPE_FS.

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..aab798e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -608,6 +608,7 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
+	q->unprep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 	q->queue_lock		= lock;
@@ -2119,6 +2120,26 @@ static bool blk_update_bidi_request(struct request *rq, int error,
 	return false;
 }
 
+/**
+ * blk_unprep_request - unprepare a request
+ * @req:	the request
+ *
+ * This function makes a request ready for complete resubmission (or
+ * completion).  It happens only after all error handling is complete,
+ * so represents the appropriate moment to deallocate any resources
+ * that were allocated to the request in the prep_rq_fn.  The queue
+ * lock is held when calling this.
+ */
+void blk_unprep_request(struct request *req)
+{
+	struct request_queue *q = req->q;
+
+	req->cmd_flags &= ~REQ_DONTPREP;
+	if (q->unprep_rq_fn)
+		q->unprep_rq_fn(q, req);
+}
+EXPORT_SYMBOL_GPL(blk_unprep_request);
+
 /*
  * queue lock must be held
  */
@@ -2134,6 +2155,10 @@ static void blk_finish_request(struct request *req, int error)
 
 	blk_delete_timer(req);
 
+	if (req->cmd_flags & REQ_DONTPREP)
+		blk_unprep_request(req);
+
+
 	blk_account_io_done(req);
 
 	if (req->end_io)
diff --git a/block/blk-settings.c b/block/blk-settings.c
index f5ed5a1..a234f4b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -37,6 +37,23 @@ void blk_queue_prep_rq(struct request_queue *q, prep_rq_fn *pfn)
 EXPORT_SYMBOL(blk_queue_prep_rq);
 
 /**
+ * blk_queue_unprep_rq - set an unprepare_request function for queue
+ * @q:		queue
+ * @ufn:	unprepare_request function
+ *
+ * It's possible for a queue to register an unprepare_request callback
+ * which is invoked before the request is finally completed. The goal
+ * of the function is to deallocate any data that was allocated in the
+ * prepare_request callback.
+ *
+ */
+void blk_queue_unprep_rq(struct request_queue *q, unprep_rq_fn *ufn)
+{
+	q->unprep_rq_fn = ufn;
+}
+EXPORT_SYMBOL(blk_queue_unprep_rq);
+
+/**
  * blk_queue_merge_bvec - set a merge_bvec function for queue
  * @q:		queue
  * @mbfn:	merge_bvec_fn
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1646fe7..868b2f2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -85,7 +85,7 @@ static void scsi_unprep_request(struct request *req)
 {
 	struct scsi_cmnd *cmd = req->special;
 
-	req->cmd_flags &= ~REQ_DONTPREP;
+	blk_unprep_request(req);
 	req->special = NULL;
 
 	scsi_put_command(cmd);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..16d97ee 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -264,6 +264,7 @@ struct request_pm_state
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
+typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
 
 struct bio_vec;
@@ -346,6 +347,7 @@ struct request_queue
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
+	unprep_rq_fn		*unprep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
@@ -915,6 +917,7 @@ extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_abort_queue(struct request_queue *);
+extern void blk_unprep_request(struct request *);
 
 /*
  * Access functions for manipulating queue properties
@@ -959,6 +962,7 @@ extern int blk_queue_dma_drain(struct request_queue *q,
 extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
+extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);



