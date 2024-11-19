Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729991D2784;
	Tue, 19 Nov 2024 20:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732049503; cv=none; b=TxM1mmhRVrhn/IeWJZ8pR7nAD0fAJgU2PEvjxWQ7tBPhpAS21SLkgnU+J8YgCw/hGK+0B7q2kavMMDE3nLot3VWg6tN5mwgoTNZOzm71VbolkKvr2Wo7IWgX7v3n3k39qX+3rhcbjr3wkUIlFcCOajrg1tDocsN0miLTCGfB/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732049503; c=relaxed/simple;
	bh=ialYUdFNsj+hOO/mCYfBXJmNlt/CKdhPeNNInyr4rto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z/CMAI2qGE8Vc9UOC+jof1XoGGyrpm0IRGZpBHBRtdrJRxlwAg8iBVJYLRPDw02Jg+q1iNoQDlWoqsHKiFm39wICe5rVH9etBYlH5q53hJlWXyS/daCE2DEtP7bEE/zT5hb0/b0KEImxsbkTxnFMPcSqOxYTlbpv7Ffv1BNzASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0mbwVE41; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0mbwVE41"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtGrC6KyZzlgTWM;
	Tue, 19 Nov 2024 20:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732049494; x=1734641495; bh=GSpkskIa1RUaSnZDKPC1gWBo
	Yy73Ox3kk5jHANpu41Q=; b=0mbwVE413EEHaw8X1wCpXQw2WMNZnrAcGwMDramo
	md7q2Zdf6Pt4Qm4Ep2b3yq4/HwMDt+0Bd5+vwwzwBrHRxwnNCqbzl+wDguEze/5F
	OMxQGLjUdEo5oaOSoww4gLJYz5eR3eho7J/+5HFEF/w7ifyUSRM8vbMKS5dAg91l
	Nk0bIYsTJOScSaWwrk3WXcGf389MLsOa0yyeXFszBu4CtVipaVooA4kCiNBx6+dZ
	ZrALskRufiGVGcMmhfc7oc/rdppn1fPcH33dPpJHPey8OSof6bj82imMboPjij63
	a91KrRypcT15V6iDZ37vNZ/bjwjZV9jB9QF8oEyKwpYapg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3NuxoJgCc-JB; Tue, 19 Nov 2024 20:51:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtGr46bq2zlgTWK;
	Tue, 19 Nov 2024 20:51:32 +0000 (UTC)
Message-ID: <719628f8-5ac2-48b5-8458-68540ae0b2f1@acm.org>
Date: Tue, 19 Nov 2024 12:51:31 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/26] blk-zoned: Only handle errors after pending
 zoned writes have completed
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-5-bvanassche@acm.org>
 <7f4058f9-df04-404c-b4f0-25bf0e8e4886@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7f4058f9-df04-404c-b4f0-25bf0e8e4886@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 6:50 PM, Damien Le Moal wrote:
> On 11/19/24 9:27 AM, Bart Van Assche wrote:
>> Instead of handling write errors immediately, only handle these after all
>> pending zoned write requests have completed or have been requeued. This
>> patch prepares for changing the zone write pointer tracking approach.
> 
> A little more explanations about how this is achieved would be nice. I was
> expecting a shorter change given the short commit message... Took some time to
> understand the changes without details.

Hi Damien,

I will make the patch description more detailed.

>> @@ -608,6 +608,8 @@ static inline void disk_zone_wplug_set_error(struct gendisk *disk,
>>   	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
>>   		return;
>>   
>> +	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
>> +	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
> 
> Why move these before the comment ? Also, why set BLK_ZONE_WPLUG_PLUGGED ? It
> should be set already since this is handling a failed write that was either
> being prepared for submission or submitted (and completed) already. In both
> cases, the wplug is plugged since we have a write in flight.
> 
>>   	/*
>>   	 * At this point, we already have a reference on the zone write plug.
>>   	 * However, since we are going to add the plug to the disk zone write
>> @@ -616,7 +618,6 @@ static inline void disk_zone_wplug_set_error(struct gendisk *disk,
>>   	 * handled, or in disk_zone_wplug_clear_error() if the zone is reset or
>>   	 * finished.
>>   	 */
>> -	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
>>   	refcount_inc(&zwplug->ref);

Does the comment block refer to the refcount_inc() call only or to both
the flags changes and the refcount_inc() call? I'm assuming the former.
That's why I moved the "zwplug->flags |= BLK_ZONE_WPLUG_ERROR;"
statement. Did I perhaps misunderstand something?

>> +/*
>> + * Changes @data->res to %false if and only if @rq is a zoned write for the
>> + * given zone and if it is owned by the block driver.
> 
> It would be nice to have a request flag or a state indicating that instead of
> needing all this code... Can't that be done ?

rq->state and rq->bio are modified independently and are independent of
whether or not blk_rq_is_seq_zoned_write() evaluates to true. I'm
concerned that introducing the proposed flag would result in numerous
changes in the block layer and hence would make the block layer harder
to maintain.

>> +/*
>> + * Change the zone state to "error" if a request is requeued to postpone
>> + * processing of requeued requests until all pending requests have either
>> + * completed or have been requeued.
>> + */
>> +void blk_zone_write_plug_requeue_request(struct request *rq)
>> +{
>> +	struct gendisk *disk = rq->q->disk;
>> +	struct blk_zone_wplug *zwplug;
>> +
>> +	if (!disk->zone_wplugs_hash_bits || !blk_rq_is_seq_zoned_write(rq))
>> +		return;
> 
> I think the disk->zone_wplugs_hash_bits check needs to go inside
> disk_get_zone_wplug() as that will avoid a similar check in
> blk_zone_write_plug_free_request() too. That said, I am not even convinced it
> is needed at all since these functions should be called only for a zoned drive
> which should have its zone wplug hash setup.

Moving the disk->zone_wplugs_hash_bits check sounds good to me.

I added this check after hitting an UBSAN report that indicates that
disk->zone_wplugs_hash_bits was used before it was changed into a non-
zero value. sd_revalidate_disk() submits a very substantial number of
SCSI commands before it calls blk_revalidate_disk_zones(), the function
that sets disk->zone_wplugs_hash_bits.

>> @@ -1343,14 +1459,15 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>>   
>>   static void disk_zone_process_err_list(struct gendisk *disk)
>>   {
>> -	struct blk_zone_wplug *zwplug;
>> +	struct blk_zone_wplug *zwplug, *next;
>>   	unsigned long flags;
>>   
>>   	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>>   
>> -	while (!list_empty(&disk->zone_wplugs_err_list)) {
>> -		zwplug = list_first_entry(&disk->zone_wplugs_err_list,
>> -					  struct blk_zone_wplug, link);
>> +	list_for_each_entry_safe(zwplug, next, &disk->zone_wplugs_err_list,
>> +				 link) {
> 
> You are holding the disk zwplug spinlock, so why use the _safe() loop ? Not
> needed, right ?
> 
>> +		if (!blk_zone_all_zwr_inserted(zwplug))
>> +			continue;
>>   		list_del_init(&zwplug->link);
>>   		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);

The _safe suffix in list_for_each_entry_safe() is not related to locking
  - it means that it is allowed to delete the loop entry 'zwplug' from
the list.

I think the _safe variant is needed because of the list_del_init() call.

>> +/* May be called from interrupt context and hence must not sleep. */
>> +void blk_zone_requeue_work(struct request_queue *q)
>> +{
>> +	struct gendisk *disk = q->disk;
>> +
>> +	if (!disk)
>> +		return;
> 
> Can this happen ?

The code in scsi_scan.c executes SCSI commands like INQUIRY before
sd_probe() attaches a disk (device_add_disk()) so I think that any code
inserted into blk_mq_requeue_work() must support q->disk == NULL.

>> @@ -1854,8 +1991,11 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>>   	zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
>>   	spin_unlock_irqrestore(&zwplug->lock, flags);
>>   
>> -	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
>> -		   zwp_wp_offset, zwp_bio_list_size);
>> +	bool all_zwr_inserted = blk_zone_all_zwr_inserted(zwplug);
> 
> Is this bool really needed ? If it is, shouldn't it be assigned while holding
> the zwplug lock to have a "snapshot" of the plug with all printed values
> consistent ?

Since blk_zone_all_zwr_inserted() checks information that is not
related to the zwplug state (e.g. the requeue list), I don't think that
the zwplug lock should be held around this blk_zone_all_zwr_inserted()
call.

I can keep this change as a local debugging patch if you would prefer
this.

>> +void blk_zone_write_plug_requeue_request(struct request *rq);
>> +static inline void blk_zone_requeue_request(struct request *rq)
>> +{
>> +	if (!blk_rq_is_seq_zoned_write(rq))
>> +		return;
>> +
>> +	blk_zone_write_plug_requeue_request(rq);
> 
> May be:
> 
> 	if (blk_rq_is_seq_zoned_write(rq))
> 		blk_zone_write_plug_requeue_request(rq);
> 
> ?

I can make this change - I don't have a strong opinion about which style
to prefer.
  Thanks,

Bart.

