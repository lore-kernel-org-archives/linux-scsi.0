From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Wed, 11 Feb 2009 10:17:23 +0200
Message-ID: <49928993.70002@panasas.com>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1234287784.3268.31.camel@localhost.localdomain> <1234289973.3268.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:2830 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753467AbZBKIR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 03:17:28 -0500
In-Reply-To: <1234289973.3268.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2009-02-10 at 17:43 +0000, James Bottomley wrote:
>> There's a current barrier to this: osd_initiator has also become a
>> consumer of blk_rq_append_bio().
>>
>> It seems to be emulating block internals, so I think the fix is twofold:
>>
>>      1. adjust blk_rq_map_kern to call blk_rq_append_bio() instead of
>>         blk_rq_prep_bio() (with an extra failure path).
>>      2. make osd_initiator simply call it for additions.
>>
>> I can code up a patch to see if it works.
> 
> So this is the patch to allow blk_rq_map_kern to append to requests,
> which is what I think is needed.
> 
> Unfortunately unwinding osd_initator's bio dependence and putting it
> back on data buffers looks to be a bit of a longer chore.
> 
> James
> 
> ---
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 25d15ff..1a1e26d 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -289,6 +289,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>  	int reading = rq_data_dir(rq) == READ;
>  	int do_copy = 0;
>  	struct bio *bio;
> +	int ret;
>  
>  	if (len > (q->max_hw_sectors << 9))
>  		return -EINVAL;
> @@ -310,7 +311,13 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>  	if (do_copy)
>  		rq->cmd_flags |= REQ_COPY_USER;
>  
> -	blk_rq_bio_prep(q, rq, bio);
> +	ret = blk_rq_append_bio(q, rq, bio);
> +	if (unlikely(ret)) {
> +		/* request is too big */
> +		bio_put(bio);
> +		return ret;
> +	}
> +		
>  	blk_queue_bounce(q, &rq->bio);
>  	rq->buffer = rq->data = NULL;
>  	return 0;
> 
> 

This works, with your patch and below code
I'm passing my tests. I would say it is pretty safe too,
since blk_rq_bio_prep would leak the bio if it was called
twice on same request, before.

Thanks, I'll send a proper patch after some more testing.

---
git diff --stat -p
 drivers/scsi/osd/osd_initiator.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 1696130..9cfdce4 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -824,18 +824,12 @@ EXPORT_SYMBOL(osd_req_add_set_attr_list);
 static int _append_map_kern(struct request *req,
 	void *buff, unsigned len, gfp_t flags)
 {
-	struct bio *bio;
 	int ret;
 
-	bio = bio_map_kern(req->q, buff, len, flags);
-	if (IS_ERR(bio)) {
-		OSD_ERR("Failed bio_map_kern(%p, %d) => %ld\n", buff, len,
-			PTR_ERR(bio));
-		return PTR_ERR(bio);
-	}
-	ret = blk_rq_append_bio(req->q, req, bio);
+	ret = blk_rq_map_kern(req->q, req, buff, len, flags);
 	if (ret) {
-		OSD_ERR("Failed blk_rq_append_bio(%p) => %d\n", bio, ret);
+		OSD_DEBUG("Failed blk_rq_map_kern(%p, %u) => %d\n",
+			buff, len, ret);
 		bio_put(bio);
 	}
 	return ret;

