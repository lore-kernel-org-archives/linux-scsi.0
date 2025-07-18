Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3822E336F;
	Fri, 18 Jul 2025 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752856202; cv=none; b=cFX+7icsNdRIJrITNaKhA7l6cXwKY5Dfhm+gu0jug2xsjxC3I5kgirX8gAXLP6yoWeHVRYe10iHH71pro/2PCJ2D0mCGcSzx3eOS69PisUxZyGsrJHbDiKaIhBrvycgogmhJdNo/VSH0dypvay/FXFGR1ug1vAD84obrdlrq2VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752856202; c=relaxed/simple;
	bh=77BaOVua4mwNSOChTFzpb12lpS81KOvl66N8JsEf8s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hhY1E7ltmKu7QOtNKvHGaFVC60Ui41rn0hlxG1B5/PlpJm5UWFYvMbvd1e9TjyzrDyJWpHNE8oYjEsV4mRfABQbm6RBglKHZeiargFGSnjkgStRD4B6zr0vGhCbmpFWc+aSk/JhykZKfG+q+Ar1QFAWsSlQPdEgRZJFO+eQsVvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mFm6c9si; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mFm6c9si"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkFd40sp8zm0ySb;
	Fri, 18 Jul 2025 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752856198; x=1755448199; bh=qiSLpOh9TBJ54FgAH95p5dXM
	+Z1M3poauybTgmZBR3g=; b=mFm6c9sih6mbCEOJ4XS6glAadWN3ASCYuYahTMvC
	Jg8P7lqI39pyqw0uSuJdGkcKeIVebALGNe0rhxniwFQ/QjwQ9gctONu3xZIeX2Lm
	OJ5+akjDlWAkRMyxMkRIyvjofWL2iSoFp5rcfIAh02qyMWGFo8mqFRVjNXi6Bx7Q
	Q8vPzaJ24ZKN2tULKHLAJ2IdAilyNGyhqN2dBOXW4ry66qo7PKWcYDbpFYt0rTyh
	gkn8rCrjI5FTMpGRluFaOHk/ty1i9Qjfo4wBxZR4n01WM2aNvN/JB6KJB8gj6ZLZ
	g+aGNad0KJY20rYdF0Q+p/SogOShsIBSZuqW9mI0aiXKsA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Es9HjYdIKYTS; Fri, 18 Jul 2025 16:29:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkFcz59Pzzm0yTN;
	Fri, 18 Jul 2025 16:29:54 +0000 (UTC)
Message-ID: <e51d282f-b07a-4c4d-b83d-b4fb5061ba12@acm.org>
Date: Fri, 18 Jul 2025 09:29:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 07/12] blk-zoned: Support pipelining of zoned writes
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <20250717205808.3292926-8-bvanassche@acm.org>
 <bde0f755-eb69-4799-a9dd-35bf330f78ab@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bde0f755-eb69-4799-a9dd-35bf330f78ab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 12:38 AM, Damien Le Moal wrote:
> On 7/18/25 05:58, Bart Van Assche wrote:
>> @@ -768,14 +771,19 @@ static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
>>   static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
>>   					      struct blk_zone_wplug *zwplug)
>>   {
>> +	lockdep_assert_held(&zwplug->lock);
> 
> Unrelated change. Please move this to a prep patch.

I will drop this change since I don't really need this change.

>> +
>>   	/*
>>   	 * Take a reference on the zone write plug and schedule the submission
>>   	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
>>   	 * reference we take here.
>>   	 */
>> -	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
> 
> Why do you remove this warning ?

This warning probably can be retained. I will look into restoring it.

>> @@ -972,9 +980,12 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>>   	return true;
>>   }
>>   
>> -static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>> +static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs,
>> +					int from_cpu)
>>   {
>>   	struct gendisk *disk = bio->bi_bdev->bd_disk;
>> +	const bool ordered_hwq = bio_op(bio) != REQ_OP_ZONE_APPEND &&
>> +		disk->queue->limits.features & BLK_FEAT_ORDERED_HWQ;
> 
> This is not correct. If the BIO is a zone append and
> blk_zone_wplug_handle_write() is called, it means that we need to handle the BIO
> using zone append emulation, that is, the BIO will be a regular write. So you
> must treat it as if it originally was a regular write.

Hmm ... my understanding is that zone append emulation and also the
conversion of REQ_OP_ZONE_APPEND into REQ_OP_WRITE happens after the
above code has been executed, namely by blk_zone_wplug_prepare_bio().
 From that function:

	[ ... ]
	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
		bio->bi_opf &= ~REQ_OP_MASK;
		bio->bi_opf |= REQ_OP_WRITE | REQ_NOMERGE;
	[ ... ]

Did I perhaps misunderstand your comment?

>> +	if (refcount_read(&zwplug->ref) == 2)
>> +		zwplug->from_cpu = -1;
> 
> This needs a comment explaining why you use the plug ref count instead of
> unconditionally clearing from_cpu.

I'm considering to add the following comment:

  	/*
	 * zwplug->from_cpu must not change while one or more writes are pending
	 * for the zone associated with zwplug. zwplug->ref is 2 when the plug
	 * is unused (one reference taken when the plug was allocated and
	 * another reference taken by the caller context). Reset
	 * zwplug->from_cpu if no more writes are pending.
	 */

Thanks,

Bart.
