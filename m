From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Wed, 11 Feb 2009 11:15:53 +0200
Message-ID: <49929749.5020109@panasas.com>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1234287784.3268.31.camel@localhost.localdomain> <1234289973.3268.37.camel@localhost.localdomain> <49928993.70002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:1732 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbZBKJP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 04:15:57 -0500
In-Reply-To: <49928993.70002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> James Bottomley wrote:
>> On Tue, 2009-02-10 at 17:43 +0000, James Bottomley wrote:
>>> There's a current barrier to this: osd_initiator has also become a
>>> consumer of blk_rq_append_bio().
>>>
>>> It seems to be emulating block internals, so I think the fix is twofold:
>>>
>>>      1. adjust blk_rq_map_kern to call blk_rq_append_bio() instead of
>>>         blk_rq_prep_bio() (with an extra failure path).
>>>      2. make osd_initiator simply call it for additions.
>>>
>>> I can code up a patch to see if it works.
>> So this is the patch to allow blk_rq_map_kern to append to requests,
>> which is what I think is needed.
>>
>> Unfortunately unwinding osd_initator's bio dependence and putting it
>> back on data buffers looks to be a bit of a longer chore.
>>
>> James
>>
>> ---
>>
>> diff --git a/block/blk-map.c b/block/blk-map.c
>> index 25d15ff..1a1e26d 100644
>> --- a/block/blk-map.c
>> +++ b/block/blk-map.c
>> @@ -289,6 +289,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>>  	int reading = rq_data_dir(rq) == READ;
>>  	int do_copy = 0;
>>  	struct bio *bio;
>> +	int ret;
>>  
>>  	if (len > (q->max_hw_sectors << 9))
>>  		return -EINVAL;
>> @@ -310,7 +311,13 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
>>  	if (do_copy)
>>  		rq->cmd_flags |= REQ_COPY_USER;
>>  
>> -	blk_rq_bio_prep(q, rq, bio);
>> +	ret = blk_rq_append_bio(q, rq, bio);
>> +	if (unlikely(ret)) {
>> +		/* request is too big */
>> +		bio_put(bio);
>> +		return ret;
>> +	}
>> +		
>>  	blk_queue_bounce(q, &rq->bio);
>>  	rq->buffer = rq->data = NULL;
>>  	return 0;
>>
>>
> 
> This works, with your patch and below code
> I'm passing my tests. I would say it is pretty safe too,
> since blk_rq_bio_prep would leak the bio if it was called
> twice on same request, before.
> 
> Thanks, I'll send a proper patch after some more testing.
> 
> ---
> git diff --stat -p
>  drivers/scsi/osd/osd_initiator.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 1696130..9cfdce4 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -824,18 +824,12 @@ EXPORT_SYMBOL(osd_req_add_set_attr_list);
>  static int _append_map_kern(struct request *req,
>  	void *buff, unsigned len, gfp_t flags)
>  {
> -	struct bio *bio;
>  	int ret;
>  
> -	bio = bio_map_kern(req->q, buff, len, flags);
> -	if (IS_ERR(bio)) {
> -		OSD_ERR("Failed bio_map_kern(%p, %d) => %ld\n", buff, len,
> -			PTR_ERR(bio));
> -		return PTR_ERR(bio);
> -	}
> -	ret = blk_rq_append_bio(req->q, req, bio);
> +	ret = blk_rq_map_kern(req->q, req, buff, len, flags);
>  	if (ret) {
> -		OSD_ERR("Failed blk_rq_append_bio(%p) => %d\n", bio, ret);
> +		OSD_DEBUG("Failed blk_rq_map_kern(%p, %u) => %d\n",
> +			buff, len, ret);
>  		bio_put(bio);
>  	}
>  	return ret;
> 
> --

I spoke too soon. There is one more place that uses blk_rq_append_bio, that is
the place that adds the read/write bio that is received in osd_req_write/read.
The reason I receive a bio at these is because mainly I need a way to
accept struct page* arrays, as well as kernel & user pointers. A bio is a nice
general carrier for any type of memory. Given a bio at hand there are no ways
left to prepare a request from it save the FS generic_make_request() route.

I was thinking of using struct sg_iovec* at one stage but they look very
scary when used with page*, and mapping a page to a pointer but not doing
cache sync and all that jazz. A bio is a very nice carrier of a scatter-gather
list of memory. It has all the API for any needs. blk_rq_append_bio() was the last
way to associate a bio with a request. (except for privileged block-filesystems)

So the first thing we have to decide is what API we need at read/write
today there is:
void osd_req_read(struct osd_request *or,
	const struct osd_obj_id *, struct bio *data_in, u64 offset);

in exofs I use these two:

int osd_req_read_kern(struct osd_request *or,
	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
int osd_req_read_pages(struct osd_request *or,
	const struct osd_obj_id *, u64 offset, u64 length,
	struct page **pages, int page_count);

(Same for write)
pNFS layout driver is very similar.

Thanks
Boaz
