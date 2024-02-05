Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35A8F51;
	Mon,  5 Feb 2024 02:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707100867; cv=none; b=NP5pgtPbrN3RF/oStgEE0P7jHNfwSQ99hue6VPrNmLnpiA67NROcE+ZVJ/5iVkTeep5kkuBhYP27RWEwM0I9nUG/G/Km9b+7RDSnxZscGL5O5t40v+51JYayhSSBezssPRnvukFO+/i/mPn5+7NKnNRlaRuFzWW50/RAGsq5hQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707100867; c=relaxed/simple;
	bh=0AFY4A1arISoWj5RPvJydiEodo6Kq+sVlKlzhpAEIr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e8Bkhjnhcf1txqZVLpPX3BM1TCjv8XElNgAETtM+41x99AZ2WJMBZIO5G5A9F49S4PQ67Nk4T30uxW+FZTt2manEww19J83W64oel1HlHSDQH1Ic+VWiyUK++tN0WjKFbqkK2Z0zIX/fVwGAcwaa/gN7aJccIEotiwJwDjMAEOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgxDXjL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgxDXjL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91389C433F1;
	Mon,  5 Feb 2024 02:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707100866;
	bh=0AFY4A1arISoWj5RPvJydiEodo6Kq+sVlKlzhpAEIr0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mgxDXjL2QCsdJmbNNdJsjnowXyX4o7x81C+yvJBVrsagna+7H9wfcj1MCebpHX47+
	 x8JVNnMypQHp6RikmzzTN2IEelqs4tND0RmsHEF3Ca4T7y1RTpCytz0glr8fdR0NGm
	 hj0h9PKwKBqShxrqirjL0mpeOCWyt9j3hzIXaJNBHqNvRd8cuOgMjLw4m0d1YOpeds
	 DaCNXO8yLlegy0K+ZPCtus0mL8Xf/InlVPDsHptstDWdw0iBKJr06jwlbddsH097b5
	 Aqb+vayBoJUi7cAR7OOQvpW2auq11O9+YXnwvW59K+Xl3hPSfY5JmcrGuus2aDjq2/
	 zDDCOSfktUYTg==
Message-ID: <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
Date: Mon, 5 Feb 2024 11:41:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org> <Zb8K4uSN3SNeqrPI@fedora>
 <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org> <ZcBFoqweG+okoTN6@fedora>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZcBFoqweG+okoTN6@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/24 11:19, Ming Lei wrote:
>>>> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>>>> +					  struct bio *bio, unsigned int nr_segs)
>>>> +{
>>>> +	/*
>>>> +	 * Keep a reference on the BIO request queue usage. This reference will
>>>> +	 * be dropped either if the BIO is failed or after it is issued and
>>>> +	 * completes.
>>>> +	 */
>>>> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
>>>
>>> It is fragile to get nested usage_counter, and same with grabbing/releasing it
>>> from different contexts or even functions, and it could be much better to just
>>> let block layer maintain it.
>>>
>>> From patch 23's change:
>>>
>>> +	 * Zoned block device information. Reads of this information must be
>>> +	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this
>>>
>>> Anytime if there is in-flight bio, the block device is opened, so both gendisk and
>>> request_queue are live, so not sure if this .q_usage_counter protection
>>> is needed.
>>
>> Hannes also commented about this. Let me revisit this.
> 
> I think only queue re-configuration(blk_revalidate_zone) requires the
> queue usage counter. Otherwise, bdev open()/close() should work just
> fine.

I want to check FS case though. No clear if mounting FS that supports zone
(btrfs) also uses bdev open ?

>>>> +	/*
>>>> +	 * blk-mq devices will reuse the reference on the request queue usage
>>>> +	 * we took when the BIO was plugged, but the submission path for
>>>> +	 * BIO-based devices will not do that. So drop this reference here.
>>>> +	 */
>>>> +	if (bio->bi_bdev->bd_has_submit_bio)
>>>> +		blk_queue_exit(bio->bi_bdev->bd_disk->queue);
>>>
>>> But I don't see where this reference is reused for blk-mq in this patch,
>>> care to point it out?
>>
>> This patch modifies blk_mq_submit_bio() to add a "goto new_request" at the top
>> for any BIO flagged with BIO_FLAG_ZONE_WRITE_PLUGGING. So when a plugged BIO is
>> unplugged and submitted again, the reference that was taken in
>> blk_zone_wplug_add_bio() is reused for the new request for that BIO.
> 
> OK, this reference reuse may be worse, because queue freeze can't prevent new
> write zoned bio from being submitted any more given only percpu_ref_get() is
> called for all write zoned bios.

New BIOs (BIOS that have never been plugged yet) will go through the normal
blk_queue_enter() in blk_mq_submit_bio(), so they will be stopped there if
another context asked for a queue freeze. I do not think there is any issue with
how things are currently done (we tested that *a lot* with many different drives
and drive configs with DM etc). Reference counting as it is is OK, even though
it most likely be simplified. I am looking at that now.

-- 
Damien Le Moal
Western Digital Research

