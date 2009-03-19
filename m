From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC B 1/2] Export new blk_make_request() which takes bio and returns
 request
Date: Thu, 19 Mar 2009 16:30:17 +0200
Message-ID: <49C256F9.5000800@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:7699 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752766AbZCSObb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:31:31 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


given a struct bio allocates a new request. This is the parallel of
generic_make_request for BLOCK_PC commands users.

The new API is:
+struct request *blk_make_request(struct request_queue *q, struct bio *bio,
+				 gfp_t gfp_mask);

This is in the effort of un-exporting blk_rq_append_bio()

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |   13 +++++++++++++
 include/linux/blkdev.h |    5 ++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9ee243e..7136c11 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -903,6 +903,19 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(blk_get_request);
 
+struct request *blk_make_request(struct request_queue *q, struct bio *bio,
+				 gfp_t gfp_mask)
+{
+	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
+
+	if (rq) {
+		blk_rq_bio_prep(q, rq, bio);
+		blk_queue_bounce(q, &rq->bio);
+	}
+	return rq;
+}
+EXPORT_SYMBOL(blk_make_request);
+
 /**
  * blk_start_queueing - initiate dispatch of requests to device
  * @q:		request queue to kick into gear
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..22dcdde 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -729,6 +729,8 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
+extern struct request *blk_make_request(struct request_queue *, struct bio *,
+					gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);

