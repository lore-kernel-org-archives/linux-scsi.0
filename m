From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 3/4] New blk_make_request(), takes bio, returns a request
Date: Thu, 07 May 2009 19:16:28 +0300
Message-ID: <4A03095C.7030008@panasas.com>
References: <4A0307F4.50205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:13919 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753524AbZEGQQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 12:16:36 -0400
In-Reply-To: <4A0307F4.50205@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>


New block API:
given a struct bio allocates a new request. This is the parallel of
generic_make_request for BLOCK_PC commands users.

The passed bio may be a chained-bio. The bio is bounced if needed
inside the call to this member.

This is in the effort of un-exporting blk_rq_append_bio().

Requested-comments-by: Boaz Harrosh <bharrosh@panasas.com>
TO: Jens Axboe <Jens.Axboe@oracle.com>
CC: Tejun Heo <tj@kernel.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Jeff Garzik <jeff@garzik.org>
---
 block/blk-core.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2998fe3..d79c6e8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -902,6 +902,52 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 EXPORT_SYMBOL(blk_get_request);
 
 /**
+ * blk_make_request - given a bio, allocate a corresponding struct request.
+ *
+ * @bio:  The bio describing the memory mappings that will be submitted for IO.
+ *        It may be a chained-bio properly constructed by block/bio layer.
+ *
+ * blk_make_request is the parallel of generic_make_request for BLOCK_PC
+ * type commands. Where the struct request needs to be farther initialized by
+ * the caller. It is passed a &struct bio, which describes the memory info to
+ * be read/written to/from.
+ *
+ * The caller of blk_make_request must make sure that bi_io_vec
+ * are set to describe the memory buffers. That bio_data_dir() will return
+ * the needed direction of the request. (And all bio's in the passed bio-chain
+ * are properly set accordingly), the passed total_bytes may be shorter then
+ * the passed total_bytes(bio-chain).
+ *
+ * If called under none-sleepable conditions, mapped bio buffers must not
+ * need bouncing, by calling the appropriate masked or flagged allocator,
+ * suitable for the target device. Otherwise the call to blk_queue_bounce will
+ * BUG.
+ */
+struct request *blk_make_request(struct request_queue *q, struct bio *bio,
+				 gfp_t gfp_mask)
+{
+	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
+
+	if (unlikely(!rq))
+		return ERR_PTR(-ENOMEM);
+
+	for_each_bio(bio) {
+		struct bio *bounce_bio = bio;
+		int ret;
+
+		blk_queue_bounce(q, &bounce_bio);
+		ret = blk_rq_append_bio(q, rq, bounce_bio);
+		if (unlikely(ret)) {
+			blk_put_request(rq);
+			return ERR_PTR(ret);
+		}
+	}
+
+	return rq;
+}
+EXPORT_SYMBOL(blk_make_request);
+
+/**
  * blk_start_queueing - initiate dispatch of requests to device
  * @q:		request queue to kick into gear
  *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b4f71f1..19728b0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -752,6 +752,8 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
+extern struct request *blk_make_request(struct request_queue *, struct bio *,
+					gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
-- 
1.6.2.1


