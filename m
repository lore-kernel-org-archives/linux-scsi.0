From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 6/9] blk: split the reclaim of req from blk_finish_request()
Date: Fri, 30 May 2014 16:15:44 +0800
Message-ID: <1401437747-2097-7-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:42799 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbaE3INW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:13:22 -0400
Received: by mail-yh0-f42.google.com with SMTP id t59so1299416yho.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:13:21 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

Later, the low layer (scsi) can decide when to turn back the mem of
req by blk_reclaim_request()

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 block/blk-core.c       | 52 +++++++++++++++++++++++++++++++++-----------------
 include/linux/blkdev.h |  6 ++++--
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index beaca2e..7e8a8ae 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2495,7 +2495,7 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
 /*
  * queue lock must be held
  */
-static void blk_finish_request(struct request *req, int error, int *drop_ref)
+static void __blk_finish_request(struct request *req, int error, int *drop_ref)
 {
 	bool ref;
 
@@ -2517,7 +2517,10 @@ static void blk_finish_request(struct request *req, int error, int *drop_ref)
 		blk_unprep_request(req);
 
 	blk_account_io_done(req);
+}
 
+void blk_reclaim_request(struct request *req, int error)
+{
 	if (req->end_io)
 		req->end_io(req, error);
 	else {
@@ -2528,6 +2531,12 @@ static void blk_finish_request(struct request *req, int error, int *drop_ref)
 	}
 }
 
+static void blk_finish_request(struct request *req, int error, int *drop_ref)
+{
+	__blk_finish_request(req, error, drop_ref);
+	blk_reclaim_request(req, error);
+}
+
 /**
  * blk_end_bidi_request - Complete a bidi request
  * @rq:         the request to complete
@@ -2555,7 +2564,11 @@ static bool blk_end_bidi_request(struct request *rq, int error,
 		return true;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	blk_finish_request(rq, error, drop_ref);
+	/* low level wants to manage ref, so not to reclaim rq */
+	if (drop_ref)
+		__blk_finish_request(rq, error, drop_ref);
+	else
+		blk_finish_request(rq, error, drop_ref);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return false;
@@ -2608,25 +2621,15 @@ bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 EXPORT_SYMBOL(blk_end_request);
 
 /**
- * blk_end_request_ref - Helper function for drivers to complete the request.
- * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete
- *
- * Description:
- *     Ends I/O on a number of bytes attached to @rq.
- *     If @rq has leftover, sets it up for the next range of segments.
- *
- * Return:
- *     %false - we are done with this request
- *     %true  - still buffers pending for this request
+ * blk_end_request_noreclaim - same as blk_end_request, but not reclaim rq
  **/
-bool blk_end_request_ref(struct request *rq, int error, unsigned int nr_bytes,
-	int *drop_ref)
+bool blk_end_request_noreclaim(struct request *rq, int error,
+	unsigned int nr_bytes, int *drop_ref)
 {
+	BUG_ON(!drop_ref);
 	return blk_end_bidi_request(rq, error, nr_bytes, 0, drop_ref);
 }
-EXPORT_SYMBOL(blk_end_request_ref);
+EXPORT_SYMBOL(blk_end_request_noreclaim);
 
 /**
  * blk_end_request_all - Helper function for drives to finish the request.
@@ -2650,6 +2653,21 @@ void blk_end_request_all(struct request *rq, int error)
 }
 EXPORT_SYMBOL(blk_end_request_all);
 
+void blk_end_request_all_noreclaim(struct request *rq, int error)
+{
+	bool pending;
+	unsigned int bidi_bytes = 0;
+	int ref;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
+
+	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes,
+		&ref);
+	BUG_ON(pending);
+}
+EXPORT_SYMBOL(blk_end_request_all_noreclaim);
+
 /**
  * blk_end_request_cur - Helper function to finish the current request chunk.
  * @rq: the request to finish the current chunk for
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7a2e79f..70c65d2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -772,6 +772,7 @@ extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
+extern void blk_reclaim_request(struct request *req, int error);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
@@ -934,11 +935,12 @@ extern struct request *blk_fetch_request(struct request_queue *q);
  */
 extern bool blk_update_request(struct request *rq, int error,
 			       unsigned int nr_bytes);
-extern bool blk_end_request_ref(struct request *rq, int error,
-	unsigned int nr_bytes, int *drop_ref);
 extern bool blk_end_request(struct request *rq, int error,
 			    unsigned int nr_bytes);
+extern bool blk_end_request_noreclaim(struct request *rq, int error,
+	unsigned int nr_bytes, int *drop_ref);
 extern void blk_end_request_all(struct request *rq, int error);
+extern void blk_end_request_all_noreclaim(struct request *rq, int error);
 extern bool blk_end_request_cur(struct request *rq, int error);
 extern bool blk_end_request_err(struct request *rq, int error);
 extern bool __blk_end_request(struct request *rq, int error,
-- 
1.8.1.4

