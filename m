From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Tue, 10 Feb 2009 18:19:33 +0000
Message-ID: <1234289973.3268.37.camel@localhost.localdomain>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1234287784.3268.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60224 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455AbZBJSTf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2009 13:19:35 -0500
In-Reply-To: <1234287784.3268.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>

On Tue, 2009-02-10 at 17:43 +0000, James Bottomley wrote:
> There's a current barrier to this: osd_initiator has also become a
> consumer of blk_rq_append_bio().
> 
> It seems to be emulating block internals, so I think the fix is twofold:
> 
>      1. adjust blk_rq_map_kern to call blk_rq_append_bio() instead of
>         blk_rq_prep_bio() (with an extra failure path).
>      2. make osd_initiator simply call it for additions.
> 
> I can code up a patch to see if it works.

So this is the patch to allow blk_rq_map_kern to append to requests,
which is what I think is needed.

Unfortunately unwinding osd_initator's bio dependence and putting it
back on data buffers looks to be a bit of a longer chore.

James

---

diff --git a/block/blk-map.c b/block/blk-map.c
index 25d15ff..1a1e26d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -289,6 +289,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
+	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -310,7 +311,13 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
 
-	blk_rq_bio_prep(q, rq, bio);
+	ret = blk_rq_append_bio(q, rq, bio);
+	if (unlikely(ret)) {
+		/* request is too big */
+		bio_put(bio);
+		return ret;
+	}
+		
 	blk_queue_bounce(q, &rq->bio);
 	rq->buffer = rq->data = NULL;
 	return 0;


