From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] libosd: Don't let osd abuse block internals, now that
 it's fixed
Date: Thu, 19 Mar 2009 12:26:56 +0200
Message-ID: <49C21DF0.90306@panasas.com>
References: <49C21C5A.6030105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:22455 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753929AbZCSK2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 06:28:10 -0400
In-Reply-To: <49C21C5A.6030105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


blk_put_request will delete any BIOs that where mapped but not
executed, so osd_initiator does not have to take care of this situation
any more.

This patch is dependent on block patch titled:

  [BLOCK] Don't let blk_put_request leak BIOs

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 45c154f..6c921ce 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -339,20 +339,6 @@ struct osd_request *osd_start_request(struct osd_dev *dev, gfp_t gfp)
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
@@ -374,11 +360,10 @@ void osd_end_request(struct osd_request *or)
 
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
1.6.2.1


