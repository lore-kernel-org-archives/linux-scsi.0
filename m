Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A5215798;
	Fri, 18 Jul 2025 07:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752822817; cv=none; b=IiVvUGjsUUbk/En1BLlkkt0D3gWYdxov5ErnU1p3GNMUEGfTHkSUHzaZ4EvIH8bEsQpXrcdhFmNAHBzO+uU+iRGvKgAfVOE8ALwbwF2r/Ewm/TjDR3EKDFlyLZwpl0nZOwtrVEXbr6RQq9LBhAUyDcWxSX/H8Nba8iji8aSEpio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752822817; c=relaxed/simple;
	bh=hHaNkeGumXyqbHU57qmzneFOXre0qEXAOihrFb24pQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EexSbmvtlLvmjD6GWWhFAjo5gupAB/VhHtBFcv6eYIfvkg3Zhl5Q9XRGy4o8UBpuzuT6n7nWcKRQFM4yeazeWiSTUFiIdxmVLe4dPxBs3YOaKLWuQT0aguxswJpEqnZpysd/r9QTU0fF+nJlO92unaaQzxWcDKIkQ3NxKWJ5wTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQ6q8Tuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQ6q8Tuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702ABC4CEED;
	Fri, 18 Jul 2025 07:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752822817;
	bh=hHaNkeGumXyqbHU57qmzneFOXre0qEXAOihrFb24pQI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BQ6q8TuvLsmMWAmPKzqVxX4WHuf6ivkkI6Rd8mVOtUzLMUPh8pb89LOn6Ms0MjFY5
	 LoHxXQ38OrGZ+A6QvS+p6Rc8hS86hWOzkbM9oIL3TCoTNNa6Ve4zT363VuVML4P/V6
	 wbINBgltX2kYZqO/NuWdXKoYJXJO78bfpcvYE0YbvPLZdsf4MerLtYUwcY+LV+tT8Z
	 IJCe1ioQz4OT0KEmAdOa2cOLMUFOENsnZQktBBkhcd08aiLavKshqeFqGbJRCmMZmD
	 OStbNogMaNcFonZ1ikrHz/LmTAN3ecDtH5sItd4FAWQEecDwUqfcEp8Gn1TbpcH25b
	 Y2IBwTSlLrK6g==
Message-ID: <eae89738-44e6-46ea-ada6-665fdfd8db07@kernel.org>
Date: Fri, 18 Jul 2025 16:13:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 03/12] blk-zoned: Add an argument to
 blk_zone_plug_bio()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <20250717205808.3292926-4-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717205808.3292926-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 05:57, Bart Van Assche wrote:
> Software that submits zoned writes, e.g. a filesystem, may submit zoned
> writes from multiple CPUs as long as the zoned writes are serialized per
> zone. Submitting bios from different CPUs may cause bio reordering if
> e.g. different bios reach the storage device through different queues.
> Prepare for preserving the order of pipelined zoned writes per zone by
> adding the 'rq_cpu` argument to blk_zone_plug_bio(). This argument tells
> blk_zone_plug_bio() from which CPU a cached request has been allocated.
> The cached request will only be used if it matches the CPU from which
> zoned writes are being submitted for the zone associated with the bio.

I still do not understand why this patch is needed because you can get the
current CPU submitting the BIO inside blk_zone_plug_bio() with
raw_smp_processor_id(). That CPU ID should be the same as the cached request
that we will use only if the BIO is not going through the BIO work, that is, if
it is the first write BIO in-flight for the zone.

Furthermore, for the DM case, you pass a CPU of "-1", but if the DM target needs
zone append emulation, it will use zone write plugging. So the same control as
for blk-mq is needed.

> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-mq.c         | 7 +++----
>  block/blk-zoned.c      | 5 ++++-
>  drivers/md/dm.c        | 5 ++---
>  include/linux/blkdev.h | 5 +++--
>  4 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 58d3d0e724cb..c1035a2bbda8 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3190,10 +3190,9 @@ void blk_mq_submit_bio(struct bio *bio)
>  	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>  		goto queue_exit;
>  
> -	if (bio_needs_zone_write_plugging(bio)) {
> -		if (blk_zone_plug_bio(bio, nr_segs))
> -			goto queue_exit;
> -	}
> +	if (bio_needs_zone_write_plugging(bio) &&
> +	    blk_zone_plug_bio(bio, nr_segs, rq ? rq->mq_ctx->cpu : -1))
> +		goto queue_exit;
>  
>  new_request:
>  	if (rq) {
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index ef43aaca49f4..7e0f90626459 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1110,6 +1110,9 @@ static void blk_zone_wplug_handle_native_zone_append(struct bio *bio)
>   * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
>   * @bio: The BIO being submitted
>   * @nr_segs: The number of physical segments of @bio
> + * @rq_cpu: software queue onto which a request will be queued. -1 if the caller
> + *	has not yet decided onto which software queue to queue the request or if
> + *	the bio won't be converted into a request.
>   *
>   * Handle write, write zeroes and zone append operations requiring emulation
>   * using zone write plugging.
> @@ -1118,7 +1121,7 @@ static void blk_zone_wplug_handle_native_zone_append(struct bio *bio)
>   * write plug. Otherwise, return false to let the submission path process
>   * @bio normally.
>   */
> -bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
> +bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu)
>  {
>  	struct block_device *bdev = bio->bi_bdev;
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ca889328fdfe..5033af6d687c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1814,9 +1814,8 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
>  
>  static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
>  {
> -	if (!bio_needs_zone_write_plugging(bio))
> -		return false;
> -	return blk_zone_plug_bio(bio, 0);
> +	return bio_needs_zone_write_plugging(bio) &&
> +		blk_zone_plug_bio(bio, 0, -1);
>  }
>  
>  static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3ea6c77746c5..904e2bb1e5fc 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -897,7 +897,7 @@ static inline bool bio_needs_zone_write_plugging(struct bio *bio)
>  	}
>  }
>  
> -bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
> +bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu);
>  
>  /**
>   * disk_zone_capacity - returns the zone capacity of zone containing @sector
> @@ -932,7 +932,8 @@ static inline bool bio_needs_zone_write_plugging(struct bio *bio)
>  	return false;
>  }
>  
> -static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
> +static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs,
> +				     int rq_cpu)
>  {
>  	return false;
>  }


-- 
Damien Le Moal
Western Digital Research
