From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] [RFC] libosd: Don't let osd abuse block internals, now
 that it's fixed
Date: Thu, 12 Feb 2009 19:30:08 +0200
Message-ID: <49945CA0.7070603@panasas.com>
References: <4993DCCA.8080508@panasas.com>	<20090212174124S.fujita.tomonori@lab.ntt.co.jp>	<4993E85A.20805@panasas.com> <20090212184208X.fujita.tomonori@lab.ntt.co.jp> <499413DB.2020208@panasas.com> <499428E1.1000009@panasas.com> <49942A9E.8090405@panasas.com> <49945C0F.8040704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:10272 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbZBLRaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 12:30:14 -0500
In-Reply-To: <49945C0F.8040704@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>


blk_put_request will delete any BIOs that where mapped but not
executed, so osd_initiator does not have to take care of this situation
any more.

This patch is dependent on block patch titled:

  [PATCH 1/2] block: Don't let blk_put_request leak BIOs

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

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

