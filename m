From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] REQ-flags to/from BIO-flags bugfix
Date: Wed, 12 Dec 2007 13:03:10 +0200
Message-ID: <475FBFEE.9010009@panasas.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <47462F3C.3040700@googlemail.com>	 <20071122201250.f957e280.akpm@linux-foundation.org>	 <47466B5D.90607@googlemail.com>	 <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain> <475FB316.6040804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1076 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754019AbXLLLDj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 06:03:39 -0500
In-Reply-To: <475FB316.6040804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>


 - BIO flags bio->bi_rw and REQ flags req->cmd_flags no longer match.
   Remove comments and do a proper translation between the 2 systems.

 (Please look in ll_rw_blk.c/blk_rq_bio_prep() below if we need more flags)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/ll_rw_blk.c            |   23 +++++++++++++++++------
 include/linux/blktrace_api.h |    8 +++++++-
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..c6a84bb 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1990,10 +1990,6 @@ blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
 	if (!rq)
 		return NULL;
 
-	/*
-	 * first three bits are identical in rq->cmd_flags and bio->bi_rw,
-	 * see bio.h and blkdev.h
-	 */
 	rq->cmd_flags = rw | REQ_ALLOCED;
 
 	if (priv) {
@@ -3772,8 +3768,23 @@ EXPORT_SYMBOL(end_request);
 static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			    struct bio *bio)
 {
-	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
-	rq->cmd_flags |= (bio->bi_rw & 3);
+	if (bio_data_dir(bio))
+		rq->cmd_flags |= REQ_RW;
+	else
+		rq->cmd_flags &= ~REQ_RW;
+
+	if (bio->bi_rw & (1<<BIO_RW_SYNC))
+		rq->cmd_flags |= REQ_RW_SYNC;
+	else
+		rq->cmd_flags &= ~REQ_RW_SYNC;
+	/* FIXME: what about other flags, should we sync these too? */
+	/*
+	BIO_RW_AHEAD	==> ??
+	BIO_RW_BARRIER	==> REQ_SOFTBARRIER/REQ_HARDBARRIER
+	BIO_RW_FAILFAST	==> REQ_FAILFAST
+	BIO_RW_SYNC	==> REQ_RW_SYNC
+	BIO_RW_META	==> REQ_RW_META
+	*/
 
 	rq->nr_phys_segments = bio_phys_segments(q, bio);
 	rq->nr_hw_segments = bio_hw_segments(q, bio);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 7e11d23..9e7ce65 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -165,7 +165,13 @@ static inline void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 				    u32 what)
 {
 	struct blk_trace *bt = q->blk_trace;
-	int rw = rq->cmd_flags & 0x03;
+	/* blktrace.c prints them according to bio flags */
+	int rw = (((rq_rw_dir(rq) == WRITE) << BIO_RW) |
+	          (((rq->cmd_flags & (REQ_SOFTBARRIER|REQ_HARDBARRIER)) != 0) <<
+	           BIO_RW_BARRIER) |
+	          (((rq->cmd_flags & REQ_FAILFAST) != 0) << BIO_RW_FAILFAST) |
+	          (((rq->cmd_flags & REQ_RW_SYNC) != 0) << BIO_RW_SYNC) |
+	          (((rq->cmd_flags & REQ_RW_META) != 0) << BIO_RW_META));
 
 	if (likely(!bt))
 		return;
-- 
1.5.3.3


