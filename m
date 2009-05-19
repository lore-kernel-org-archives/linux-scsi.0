From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/5] New blk_make_request(), takes bio, returns a	request
Date: Tue, 19 May 2009 13:07:51 +0300
Message-ID: <4A1284F7.2050703@panasas.com>
References: <4A1032B0.5000003@panasas.com> <4A1033DB.2030908@panasas.com> <20090519094130.GW4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:38447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZESKH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 06:07:58 -0400
Received: by fg-out-1718.google.com with SMTP id d23so816534fga.17
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 03:07:57 -0700 (PDT)
In-Reply-To: <20090519094130.GW4140@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 05/19/2009 12:41 PM, Jens Axboe wrote:
> On Sun, May 17 2009, Boaz Harrosh wrote:
>> New block API:
>> given a struct bio allocates a new request. This is the parallel of
>> generic_make_request for BLOCK_PC commands users.
>>
>> The passed bio may be a chained-bio. The bio is bounced if needed
>> inside the call to this member.
>>
>> This is in the effort of un-exporting blk_rq_append_bio().
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> CC: Jeff Garzik <jeff@garzik.org>
>> ---
>>  block/blk-core.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/blkdev.h |    2 ++
>>  2 files changed, 47 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index a2d97de..89261d2 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -891,6 +891,51 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
>>  EXPORT_SYMBOL(blk_get_request);
>>  
>>  /**
>> + * blk_make_request - given a bio, allocate a corresponding struct request.
>> + *
>> + * @bio:  The bio describing the memory mappings that will be submitted for IO.
>> + *        It may be a chained-bio properly constructed by block/bio layer.
>> + *
>> + * blk_make_request is the parallel of generic_make_request for BLOCK_PC
>> + * type commands. Where the struct request needs to be farther initialized by
>> + * the caller. It is passed a &struct bio, which describes the memory info of
>> + * the I/O transfer.
>> + *
>> + * The caller of blk_make_request must make sure that bi_io_vec
>> + * are set to describe the memory buffers. That bio_data_dir() will return
>> + * the needed direction of the request. (And all bio's in the passed bio-chain
>> + * are properly set accordingly)
>> + *
>> + * If called under none-sleepable conditions, mapped bio buffers must not
>> + * need bouncing, by calling the appropriate masked or flagged allocator,
>> + * suitable for the target device. Otherwise the call to blk_queue_bounce will
>> + * BUG.
>> + */
>> +struct request *blk_make_request(struct request_queue *q, struct bio *bio,
>> +				 gfp_t gfp_mask)
>> +{
>> +	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
>> +
>> +	if (unlikely(!rq))
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	for_each_bio(bio) {
>> +		struct bio *bounce_bio = bio;
>> +		int ret;
>> +
>> +		blk_queue_bounce(q, &bounce_bio);
>> +		ret = blk_rq_append_bio(q, rq, bounce_bio);
>> +		if (unlikely(ret)) {
>> +			blk_put_request(rq);
>> +			return ERR_PTR(ret);
>> +		}
>> +	}
>> +
>> +	return rq;
>> +}
>> +EXPORT_SYMBOL(blk_make_request);
> 
> Generally the patchset looks good, my only worry is that interfaces like
> the above may be asking for trouble. To generate a chained list of
> bio's, you need to be careful with how you allocate them. In particular,
> you cannot use __GFP_WAIT for anything but the first bio in the chain.
> Otherwise you risk deadlocking waiting for a bio to be returned to the
> pool, which it never will since you haven't submitted it yet.
> 
> 

Thanks Jens, for your comment.

I have three sources of bio allocations.
1. bio_map_kern which uses bio_kmalloc (recently fixed by Tejun)
2. by osdblk which does a clone and will not ever wait.
   (I've fixed the code to split up the IO on allocation failure into
    smaller requests (will repost soon))
3. Future code in exofs and pNFS-Client that will only ever use bio_kmalloc.

Should we add something to the Documentation, and/or above doc_book comment
to warn off users?

Boaz
