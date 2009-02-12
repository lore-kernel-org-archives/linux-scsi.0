From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] [RFC] block: Don't let blk_put_request leak BIOs
Date: Thu, 12 Feb 2009 14:19:39 +0200
Message-ID: <499413DB.2020208@panasas.com>
References: <4993DCCA.8080508@panasas.com>	<20090212174124S.fujita.tomonori@lab.ntt.co.jp>	<4993E85A.20805@panasas.com> <20090212184208X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3993 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089AbZBLMTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 07:19:47 -0500
In-Reply-To: <20090212184208X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>


If a block ULD had allocated a request and mapped some memory into it,
using one of blk_rq_map_xxx routines, but then for some reason failed to
execute the request through one of the blk_execute_request routines.
Then the associated BIO would leak, unless ULD resorts to low-level loops
intimate of block internals.

[RFC]
  This code will also catch situations where LLD failed to complete
  the request before aborting it. Such situations are a BUG. Should we
  use WARN_ON_ONCE() in that case. The situation above is possible and
  can happen normally in memory pressure situations so maybe we should
  devise a bit-flag that ULD denotes that the request was aborted and
  only WARN_ON if flag was not set.

  I'm sending this before any-tests so people can comment on possible
  pitfalls.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c                 |   16 ++++++++++++++++
 drivers/scsi/osd/osd_initiator.c |   17 +----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a824e49..eac96c2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1055,6 +1055,21 @@ void part_round_stats(int cpu, struct hd_struct *part)
 EXPORT_SYMBOL_GPL(part_round_stats);
 
 /*
+ * If one of the blk_rq_map_xxx() was called but the request was not
+ * executed by the block layer, then we must release BIOs. Otherwise they
+ * will leak.
+ */
+static void _abort_unexecuted_bios(struct request *req)
+{
+	struct bio *bio;
+
+	while ((bio = req->bio) != NULL) {
+		req->bio = bio->bi_next;
+		bio_endio(bio, 0);
+	}
+}
+
+/*
  * queue lock must be held
  */
 void __blk_put_request(struct request_queue *q, struct request *req)
@@ -1066,6 +1081,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 
 	elv_completed_request(q, req);
 
+	_abort_unexecuted_bios(req);
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
 	 * it didn't come out of our reserved rq pools
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0bbbf27..8b1cf72 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -335,20 +335,6 @@ struct osd_request *osd_start_request(struct osd_dev *dev, gfp_t gfp)
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
@@ -370,11 +356,10 @@ void osd_end_request(struct osd_request *or)
 
 	if (rq) {
 		if (rq->next_rq) {
-			_abort_unexecuted_bios(rq->next_rq);
 			blk_put_request(rq->next_rq);
+			rq->next_rq = NULL;
 		}
 
-		_abort_unexecuted_bios(rq);
 		blk_put_request(rq);
 	}
 	_osd_request_free(or);
-- 
1.6.0.1


