Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743F10A24;
	Sun,  4 Feb 2024 23:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707091023; cv=none; b=NqZTFrZcx9tPD3LG3Vykc0laYE6TBnZb0KY1obs45I5GV66KKzRqnkJnJIRwHswhmKROorWbRt1fCczfGXOnhAt6cWD07+cm/+69TZ4Is8yH5iNW5OLaJNd02WCm3BdfdTQq3HgT4geuASJWvUBafube8536X67juJMeWmwhjfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707091023; c=relaxed/simple;
	bh=S7nsiTZ7OTv6LdLKs4GQYVpY3LYxbY4DLEPqqT+OjO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J/ihAOC6VuZdNiHNsNoTcKsY5Xy+KPbRpGnqTRwon3nzjD/gwp0hK/jiPULr1+jZ1o3iVDI1Kaji3ouHvHyHxwUA3aQGeltNz8e26/TXO/F7FZEPK/JGkxOqUGBI2yjRI0cbOJJ8xIxuXjF+f6ywnX8jTxHa/Q3ulF4+ZNNOmx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5L+D697; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5L+D697"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320B1C433C7;
	Sun,  4 Feb 2024 23:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707091022;
	bh=S7nsiTZ7OTv6LdLKs4GQYVpY3LYxbY4DLEPqqT+OjO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p5L+D6974ZXTtslyrvxOaJlVx/CMzUcdCoF2EjHla75uZwO3+bF0YMs1DErY5nNoG
	 cUl0jMpZoMIooWdJLVe9RH7RWXSzsCXTarYz6aqspNQEleo4wRIv/3wr5q0jhuGkA2
	 zkbA5X1wWbyjVNxU2GuQ5itTydWfJ48i2eB39lyVJurpZyw7fx+3ejGU/9ws3rliGa
	 sBiWT+rNLFXrTKoiD5jesVpGakkbFHCjE4G07rW3noCf67U+B/fzbKwzjMhqJ0FQdl
	 t9gQ5QbKkIaKOK8FLxeRjlAtmF5QJ/h6U4Mj1BFdgDLlUfkLwvbuapyXU7oRSzL/zM
	 DttBF1ZnCLOLQ==
Message-ID: <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org>
Date: Mon, 5 Feb 2024 08:57:00 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Zb8K4uSN3SNeqrPI@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/24 12:56, Ming Lei wrote:
> On Fri, Feb 02, 2024 at 04:30:44PM +0900, Damien Le Moal wrote:
>> +/*
>> + * Zone write plug flags bits:
>> + *  - BLK_ZONE_WPLUG_CONV: Indicate that the zone is a conventional one. Writes
>> + *    to these zones are never plugged.
>> + *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,
>> + *    that is, that write BIOs are being throttled due to a write BIO already
>> + *    being executed or the zone write plug bio list is not empty.
>> + */
>> +#define BLK_ZONE_WPLUG_CONV	(1U << 0)
>> +#define BLK_ZONE_WPLUG_PLUGGED	(1U << 1)
> 
> BLK_ZONE_WPLUG_PLUGGED == !bio_list_empty(&zwplug->bio_list), so looks
> this flag isn't necessary.

No, it is. As the description says, the flag not only indicates that there are
plugged BIOs, but it also indicates that there is a write for the zone
in-flight. And that can happen even with the BIO list being empty. E.g. for a
qd=1 workload of small BIOs, no BIO will ever be added to the BIO list, but the
zone still must be marked as "plugged" when a write BIO is issued for it.

>> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>> +					  struct bio *bio, unsigned int nr_segs)
>> +{
>> +	/*
>> +	 * Keep a reference on the BIO request queue usage. This reference will
>> +	 * be dropped either if the BIO is failed or after it is issued and
>> +	 * completes.
>> +	 */
>> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
> 
> It is fragile to get nested usage_counter, and same with grabbing/releasing it
> from different contexts or even functions, and it could be much better to just
> let block layer maintain it.
> 
> From patch 23's change:
> 
> +	 * Zoned block device information. Reads of this information must be
> +	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this
> 
> Anytime if there is in-flight bio, the block device is opened, so both gendisk and
> request_queue are live, so not sure if this .q_usage_counter protection
> is needed.

Hannes also commented about this. Let me revisit this.

>> +	/*
>> +	 * blk-mq devices will reuse the reference on the request queue usage
>> +	 * we took when the BIO was plugged, but the submission path for
>> +	 * BIO-based devices will not do that. So drop this reference here.
>> +	 */
>> +	if (bio->bi_bdev->bd_has_submit_bio)
>> +		blk_queue_exit(bio->bi_bdev->bd_disk->queue);
> 
> But I don't see where this reference is reused for blk-mq in this patch,
> care to point it out?

This patch modifies blk_mq_submit_bio() to add a "goto new_request" at the top
for any BIO flagged with BIO_FLAG_ZONE_WRITE_PLUGGING. So when a plugged BIO is
unplugged and submitted again, the reference that was taken in
blk_zone_wplug_add_bio() is reused for the new request for that BIO.


-- 
Damien Le Moal
Western Digital Research

