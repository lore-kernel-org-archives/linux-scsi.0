From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH version 2] New blk_make_request(), takes bio, returns a request
Date: Tue, 19 May 2009 16:35:05 +0300
Message-ID: <4A12B589.1070003@panasas.com>
References: <4A1032B0.5000003@panasas.com> <4A1033DB.2030908@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:12902 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752903AbZESNfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 09:35:09 -0400
In-Reply-To: <4A1033DB.2030908@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


New block API:
given a struct bio allocates a new request. This is the parallel of
generic_make_request for BLOCK_PC commands users.

The passed bio may be a chained-bio. The bio is bounced if needed
inside the call to this member.

This is in the effort of un-exporting blk_rq_append_bio().

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Jeff Garzik <jeff@garzik.org>
---
 block/blk-core.c       |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    2 +
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a2d97de..3145a37 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -891,6 +891,60 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 EXPORT_SYMBOL(blk_get_request);
 
 /**
+ * blk_make_request - given a bio, allocate a corresponding struct request.
+ *
+ * @bio:  The bio describing the memory mappings that will be submitted for IO.
+ *        It may be a chained-bio properly constructed by block/bio layer.
+ *
+ * blk_make_request is the parallel of generic_make_request for BLOCK_PC
+ * type commands. Where the struct request needs to be farther initialized by
+ * the caller. It is passed a &struct bio, which describes the memory info of
+ * the I/O transfer.
+ *
+ * The caller of blk_make_request must make sure that bi_io_vec
+ * are set to describe the memory buffers. That bio_data_dir() will return
+ * the needed direction of the request. (And all bio's in the passed bio-chain
+ * are properly set accordingly)
+ *
+ * If called under none-sleepable conditions, mapped bio buffers must not
+ * need bouncing, by calling the appropriate masked or flagged allocator,
+ * suitable for the target device. Otherwise the call to blk_queue_bounce will
+ * BUG.
+ *
+ * WARNING: When allocating/cloning a bio-chain, careful consideration should be
+ * given to how you allocate bios. In particular, you cannot use __GFP_WAIT for
+ * anything but the first bio in the chain. Otherwise you risk waiting for IO
+ * completion of a bio that hasn't been submitted yet, thus resulting in a
+ * deadlock. Alternatively bios should be allocated using bio_kmalloc() instead
+ * of bio_alloc(), as that avoids the mempool deadlock.
+ * If possible a big IO should be split into smaller parts when allocation
+ * fails. Partial allocation should not be an error, or you risk a live-lock.
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
  * blk_requeue_request - put a request back on queue
  * @q:		request queue where request should be inserted
  * @rq:		request to be inserted
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f9d60a7..88a83e1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -740,6 +740,8 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
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


