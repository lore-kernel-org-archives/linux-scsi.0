From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/2] libosd: BUG: blk_put_request called from within request_end_io
Date: Tue, 31 Mar 2009 20:05:29 +0300
Message-ID: <49D24D59.90807@panasas.com>
References: <49D24BD3.2030801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:12287 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753071AbZCaRID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 13:08:03 -0400
In-Reply-To: <49D24BD3.2030801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xu Yang <onlyxuyang@qq.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Jens Axboe <axboe@kernel.dk>


A fix for a very serious and stupid bug in osd_initiator. It
used to call blk_put_request() regardless of if it was from
the end_io callback or if called after a sync execution.
It should call the unlocked version __blk_put_request() instead.

Also fixed is the remove of _abort_unexecuted_bios hack, and use of
blk_end_request(,-ERROR,) to deallocate half baked requests. I've
audited the code and it should be safe.

Reported and
Tested-by: Xu Yang <onlyxuyang@qq.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   42 +++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 552f58b..2a5f077 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -338,20 +338,6 @@ struct osd_request *osd_start_request(struct osd_dev *dev, gfp_t gfp)
 }
 EXPORT_SYMBOL(osd_start_request);
 
-/*
- * If osd_finalize_request() was called but the request was not executed through
- * the block layer, then we must release BIOs.
- */
-static void _abort_unexecuted_bios(struct request *rq)
-{
-	struct bio *bio;
-
-	while ((bio = rq->bio) != NULL) {
-		rq->bio = bio->bi_next;
-		bio_endio(bio, 0);
-	}
-}
-
 static void _osd_free_seg(struct osd_request *or __unused,
 	struct _osd_req_data_segment *seg)
 {
@@ -363,9 +349,30 @@ static void _osd_free_seg(struct osd_request *or __unused,
 	seg->alloc_size = 0;
 }
 
+static void _put_request(struct request *rq , bool is_async)
+{
+	if (is_async) {
+		WARN_ON(rq->bio);
+		__blk_put_request(rq->q, rq);
+	} else {
+		/*
+		 * If osd_finalize_request() was called but the request was not
+		 * executed through the block layer, then we must release BIOs.
+		 * TODO: Keep error code in or->async_error. Need to audit all
+		 *       code paths.
+		 */
+		if (unlikely(rq->bio))
+			blk_end_request(rq, -ENOMEM, blk_rq_bytes(rq));
+		else
+			blk_put_request(rq);
+	}
+}
+
 void osd_end_request(struct osd_request *or)
 {
 	struct request *rq = or->request;
+	/* IMPORTANT: make sure this agrees with osd_execute_request_async */
+	bool is_async = (or->request->end_io_data == or);
 
 	_osd_free_seg(or, &or->set_attr);
 	_osd_free_seg(or, &or->enc_get_attr);
@@ -373,12 +380,11 @@ void osd_end_request(struct osd_request *or)
 
 	if (rq) {
 		if (rq->next_rq) {
-			_abort_unexecuted_bios(rq->next_rq);
-			blk_put_request(rq->next_rq);
+			_put_request(rq->next_rq, is_async);
+			rq->next_rq = NULL;
 		}
 
-		_abort_unexecuted_bios(rq);
-		blk_put_request(rq);
+		_put_request(rq, is_async);
 	}
 	_osd_request_free(or);
 }
-- 
1.6.2.1


