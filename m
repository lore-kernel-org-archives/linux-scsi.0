Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F41CA84;
	Mon,  5 Feb 2024 12:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707136997; cv=none; b=DJThBelrkn6LcnYv3s5vl+y8n4GrOM8foUZkt7CdJB0buVHNze2PjJW47dAqHIHuloN0X1QVdIrvJKr6u8apYWOBEu/yuoKpfriy03BRnxznLzoIT9A9v74qK1g8apkm0lZpUshrru4BVFKa9LgvnqYjOzzE51U4L47hufypovI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707136997; c=relaxed/simple;
	bh=FnVbhOqZgLm2kMDLTxNYG44F87BpohHkM7/k1t9mA30=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eOwjzJfJbdPWkC4Hw7YhxCIeAGdsMIbdGdaCz+bBtE8ejchN1JlGcqJmBgltpMDB4ZFYtKL0ezEUg+FRmYYp8J5tgKUmmdMLxWv5/WevA7Tt94QBZ59f5m6hAJmlC905Mz33A5rx8YjASO24RUvjoNyQfkjRd9J8CfpAdkM+Bzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdeG1Dtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdeG1Dtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529F5C433F1;
	Mon,  5 Feb 2024 12:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707136996;
	bh=FnVbhOqZgLm2kMDLTxNYG44F87BpohHkM7/k1t9mA30=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=JdeG1DtdRGOw0HS1f8QNsNsCE7pYfqnjQSt5B0xTAabbXpIaCZFIz7UeG/rE+5dVg
	 X5RfIkTdi2SrwWWXkv09+f7r19dPWjM0SqjmZVFs9pjD5NQst6hy3HhV2TmDdBFY50
	 eXNcl83FKC1A/Su8OjeRJTCDywxitdnVtIh5NE/LP6DDaDtH4p4xYN7nCz9pxfV2Dm
	 YZtY04/6GlCmLOA9AAjxN2+p8pro4B/Aq3hLDQa1L5InGNNVoHWYBThC1uJiGZ6IZ4
	 Tm5FBTydKliWfGhzugozL07ID5BrUcUo41Yks7k7LLN0VqwsIovpeFzIBoDFCwD6wI
	 nBm1sLpXAx03A==
Message-ID: <93aa5cdd-0ab4-413c-bb18-b1109c7f4f9d@kernel.org>
Date: Mon, 5 Feb 2024 21:43:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org> <Zb8K4uSN3SNeqrPI@fedora>
 <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org> <ZcBFoqweG+okoTN6@fedora>
 <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org> <ZcCzLfocp4VcScOb@fedora>
 <ac52010e-c97b-43cf-baa7-0566185bc410@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ac52010e-c97b-43cf-baa7-0566185bc410@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/24 21:20, Damien Le Moal wrote:
> On 2/5/24 19:06, Ming Lei wrote:
>> On Mon, Feb 05, 2024 at 11:41:04AM +0900, Damien Le Moal wrote:
>>> On 2/5/24 11:19, Ming Lei wrote:
>>>>>>> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>>>>>>> +					  struct bio *bio, unsigned int nr_segs)
>>>>>>> +{
>>>>>>> +	/*
>>>>>>> +	 * Keep a reference on the BIO request queue usage. This reference will
>>>>>>> +	 * be dropped either if the BIO is failed or after it is issued and
>>>>>>> +	 * completes.
>>>>>>> +	 */
>>>>>>> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
>>>>>>
>>>>>> It is fragile to get nested usage_counter, and same with grabbing/releasing it
>>>>>> from different contexts or even functions, and it could be much better to just
>>>>>> let block layer maintain it.
>>>>>>
>>>>>> From patch 23's change:
>>>>>>
>>>>>> +	 * Zoned block device information. Reads of this information must be
>>>>>> +	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this
>>>>>>
>>>>>> Anytime if there is in-flight bio, the block device is opened, so both gendisk and
>>>>>> request_queue are live, so not sure if this .q_usage_counter protection
>>>>>> is needed.
>>>>>
>>>>> Hannes also commented about this. Let me revisit this.
>>>>
>>>> I think only queue re-configuration(blk_revalidate_zone) requires the
>>>> queue usage counter. Otherwise, bdev open()/close() should work just
>>>> fine.
>>>
>>> I want to check FS case though. No clear if mounting FS that supports zone
>>> (btrfs) also uses bdev open ?
>>
>> I feel the following delta change might be cleaner and easily documented:
>>
>> - one IO takes single reference for both bio based and blk-mq,
>> - no drop & re-grab
>> - only grab extra reference for bio based
>> - two code paths share same pattern
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 9520ccab3050..118dd789beb5 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -597,6 +597,10 @@ static void __submit_bio(struct bio *bio)
>>  
>>  	if (!bio->bi_bdev->bd_has_submit_bio) {
>>  		blk_mq_submit_bio(bio);
>> +	} else if (bio_zone_write_plugging(bio)) {
>> +		struct gendisk *disk = bio->bi_bdev->bd_disk;
>> +
>> +		disk->fops->submit_bio(bio);

Actually, no, that is not correct. This would not stop BIO submission if
blk_queue_freeze() was called by another context. So we cannot do that here
without calling blk_queue_enter()...

>>  	} else if (likely(bio_queue_enter(bio) == 0)) {
>>  		struct gendisk *disk = bio->bi_bdev->bd_disk;
>>  
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index f0fc61a3ec81..fc6d792747dc 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3006,8 +3006,12 @@ void blk_mq_submit_bio(struct bio *bio)
>>  	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>>  		goto queue_exit;
>>  
>> +	/*
>> +	 * Grab one reference for plugged zoned write and it will be reused in
>> +	 * next real submission
>> +	 */
>>  	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
>> -		goto queue_exit;
>> +		return;

...and this one is not correct because of the cached request: if there was a
cached request, blk_mq_submit_bio() did not call blk_queue_enter() because the
cached request already had a reference. But we cannot reuse that reference as
the next BIO may be a read or a write to a zone that is not plugged, and these
would use the cached request and so need the usage counter reference. So we
would still need to grab an extra reference in such case.

So in the end, it feels a lot simpler to keep the reference counting as it was
as it makes things a lot less messier in blk_mq_submit_bio(). I will though try
to improve the comments to make it clear how this is working.

>>  
>>  	if (!rq) {
>>  new_request:
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index f6d4f511b664..87abb3f7ef30 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -514,7 +514,8 @@ static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>>  	 * be dropped either if the BIO is failed or after it is issued and
>>  	 * completes.
>>  	 */
>> -	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
>> +	if (bio->bi_bdev->bd_has_submit_bio)
>> +		percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
>>  
>>  	/*
>>  	 * The BIO is being plugged and thus will have to wait for the on-going
>> @@ -760,15 +761,10 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>>  
>>  	blk_zone_wplug_unlock(zwplug, flags);
>>  
>> -	/*
>> -	 * blk-mq devices will reuse the reference on the request queue usage
>> -	 * we took when the BIO was plugged, but the submission path for
>> -	 * BIO-based devices will not do that. So drop this reference here.
>> -	 */
>> +	submit_bio_noacct_nocheck(bio);
>> +
>>  	if (bio->bi_bdev->bd_has_submit_bio)
>>  		blk_queue_exit(bio->bi_bdev->bd_disk->queue);
> 
> Hmm... As-is, this is a potential use-after-free of the bio. But I get the idea.
> This is indeed a little better. I will integrate this.
> 
>> -
>> -	submit_bio_noacct_nocheck(bio);
>>  }
>>  
>>  static struct blk_zone_wplug *blk_zone_alloc_write_plugs(unsigned int nr_zones)
>>
>> Thanks,
>> Ming
>>
>>
> 

-- 
Damien Le Moal
Western Digital Research

