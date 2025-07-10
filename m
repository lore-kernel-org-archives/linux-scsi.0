Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F77B86334;
	Thu, 10 Jul 2025 04:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122915; cv=none; b=kyEJ91XHUqMJlPiTGhn+njeutuz6lHa+XP30i+TDAbgFLAFfY282w8PG/wtH6kjTt5XYhOMK/ub2MZTeSUxpg7MmVy/b0eqfNVInIznmjkbXUb17JHssHav1BFrcfXr+sAYZF3e5PZ0nl1yaUbRwnpNhkrWePgsvDbsk8yXiiWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122915; c=relaxed/simple;
	bh=CCSBW3PRG6BWzLIKwTkserW2O15o8W9zC1Q5Uy4adoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjSnCZrpvL9cW5/ztOjayRxlH0Vxe2/ZGcmVbTlhcl/uxWLPWZ4CSesYulN5zfRxO847sZo2TH8oJMt+f0rz+KB1NHgiiNeiT4G8BhdaTrS13cHfZek9ixJMPQRSFPwv9VYYLqzjF/JwaaGXLR1PIdoECAPz1W1eTuKJTobmcxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJNEfrH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJNEfrH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E6FC4CEF5;
	Thu, 10 Jul 2025 04:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752122915;
	bh=CCSBW3PRG6BWzLIKwTkserW2O15o8W9zC1Q5Uy4adoU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uJNEfrH7szeY/5n/EZpveMRjyJBgkC7pyD9E2wTx+Pl59jSoK4Ls5mUEdK/F5E+hj
	 +iJC6MzgNs0on98TFbin9DiMpxfRs+HQw+Iv8Wbnprs3F4FVTV4+3lXHxigKWph/Ra
	 ymheh+8fuMXSRWkEuFw/ZQlYkfrPgTFw/i6LxnPqnLORSebrmG5hWx4PWJbr8gzQNK
	 vS8wXz4u219QLiPU3BzcLU2QKwxQiwIjAwHHXLNXZWhleVfiwBeAiF/EGGqUc+kscg
	 mzS6ISgAeYlR1k9jJn5nD4JaHkOO9+cM0LUH9OvUlWDhy4Ibk5rVq1dhiFi/2njmzP
	 hJjtZAdVCzKAQ==
Message-ID: <f612d306-f8bd-4e05-9fe2-936c00b2beb4@kernel.org>
Date: Thu, 10 Jul 2025 13:46:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 05/13] blk-zoned: Move code from
 disk_zone_wplug_add_bio() into its caller
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-6-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250708220710.3897958-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 7:07 AM, Bart Van Assche wrote:
> Move the following code into the only caller of disk_zone_wplug_add_bio():
>  - bio->bi_opf &= ~REQ_NOWAIT
>  - wplug->flags |= BLK_ZONE_WPLUG_PLUGGED
>  - The disk_zone_wplug_schedule_bio_work() call.

Please make sentences instead of copy-pasting code. We can see that in the
patch itself.

> 
> No functionality has been changed.
> 
> This patch prepares for zoned write pipelining by removing the code from
> disk_zone_wplug_add_bio() that does not apply to all zoned write pipelining
> bio processing cases.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 089f106fd82e..2a85e3b7b081 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -778,8 +778,6 @@ static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
>  				struct blk_zone_wplug *zwplug,
>  				struct bio *bio, unsigned int nr_segs)
>  {
> -	bool schedule_bio_work = false;
> -
>  	/*
>  	 * Grab an extra reference on the BIO request queue usage counter.
>  	 * This reference will be reused to submit a request for the BIO for
> @@ -795,16 +793,6 @@ static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
>  	 */
>  	bio_clear_polled(bio);
>  
> -	/*
> -	 * REQ_NOWAIT BIOs are always handled using the zone write plug BIO
> -	 * work, which can block. So clear the REQ_NOWAIT flag and schedule the
> -	 * work if this is the first BIO we are plugging.
> -	 */
> -	if (bio->bi_opf & REQ_NOWAIT) {
> -		schedule_bio_work = !(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED);
> -		bio->bi_opf &= ~REQ_NOWAIT;
> -	}
> -
>  	/*
>  	 * Reuse the poll cookie field to store the number of segments when
>  	 * split to the hardware limits.
> @@ -818,11 +806,6 @@ static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
>  	 * at the tail of the list to preserve the sequential write order.
>  	 */
>  	bio_list_add(&zwplug->bio_list, bio);
> -
> -	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> -
> -	if (schedule_bio_work)
> -		disk_zone_wplug_schedule_bio_work(disk, zwplug);
>  }
>  
>  /*
> @@ -987,6 +970,7 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  {
>  	struct gendisk *disk = bio->bi_bdev->bd_disk;
>  	sector_t sector = bio->bi_iter.bi_sector;
> +	bool schedule_bio_work = false;
>  	struct blk_zone_wplug *zwplug;
>  	gfp_t gfp_mask = GFP_NOIO;
>  	unsigned long flags;
> @@ -1031,13 +1015,17 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  
>  	/* If the zone is already plugged, add the BIO to the plug BIO list. */
>  	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
> -		goto plug;
> +		goto queue_bio;

"queue_bio" is not a good name. Please make that "add_bio" or "plug_bio" to
match the call to disk_zone_wplug_add_bio() done.

>  	/*
>  	 * Do the same for REQ_NOWAIT BIOs to ensure that we will not see a
>  	 * BLK_STS_AGAIN failure if we let the BIO execute.
>  	 */
> -	if (bio->bi_opf & REQ_NOWAIT)
> -		goto plug;
> +	if (bio->bi_opf & REQ_NOWAIT) {
> +		bio->bi_opf &= ~REQ_NOWAIT;
> +		if (!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED))
> +			goto plug;
> +		goto queue_bio;
> +	}
>  
>  	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
>  		spin_unlock_irqrestore(&zwplug->lock, flags);
> @@ -1053,7 +1041,13 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  	return false;
>  
>  plug:
> +	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	schedule_bio_work = true;
> +
> +queue_bio:
>  	disk_zone_wplug_add_bio(disk, zwplug, bio, nr_segs);
> +	if (schedule_bio_work)
> +		disk_zone_wplug_schedule_bio_work(disk, zwplug);
>  
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  


-- 
Damien Le Moal
Western Digital Research
