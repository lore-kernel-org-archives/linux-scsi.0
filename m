Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A924D11CAF;
	Fri, 18 Jul 2025 07:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752823032; cv=none; b=qDf3uv79gDRle+ABrUl+x1oB6i5gzCjak+7ike3Hta6NKWbFoOH0scgsYxezlpWmlxEfwR18sq4Zf8WnKJ5H7On6/qNIxC5/L2EA2TTymek1T6wxZYHNh61S1cZhfqGY9uij+YcZpg3izsnp9Kfad9QwAcbDVAgpsqQMS8eGt7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752823032; c=relaxed/simple;
	bh=lhxgFIISR09/+ba0vbYgCK7j2KdfyZ9bihwzSEth0HI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mf3VAX1Tqtt62wusbgJIVgxiHFopZzCZnR9v3BAjCWgsd83jw+cv/6ZJ7zT664ON+LICZ5dKTN+T+Pz7UC/IpDGdxcfE4QeCOalPDy48hk2lwmIOYWLhqcazDuxOfZdrfx15Q2b7lOzuYGTTi2FQM5+rilDKicDSUNN/fg8YTuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vAUqyOdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vAUqyOdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A30C4CEED;
	Fri, 18 Jul 2025 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752823032;
	bh=lhxgFIISR09/+ba0vbYgCK7j2KdfyZ9bihwzSEth0HI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vAUqyOdX87o//SaENfyQ5xT7MvqA7j4yXVQ3BIOpSZPzFUbCNM4oVfjknSWuS67bI
	 HBldtKVqHXOAG0iqA8XAksYomjk4ZDAZMzPI2N1bf5sBzoPaM/XFzGsAosE1j03vQD
	 V5+dFerr0JdR2d9QmAMSHcAgQOrW4H/hvSNsnVuxVuVmbh4f5gv5UA2OxHIjyrq4h9
	 7Fxu1vdI7vruxU8bxqo30t+KMetG8qP3pxMJ4nlq5Pmu9sA9awMfS4wmSOA5ByP3Vz
	 X7FKxT5lOUzB80S6bL87NIQ2d0drcSe8dr3T9e/2pMQQznJaIufS4pLe5+y/2zi013
	 B2dvMmikvuBZA==
Message-ID: <d53b460c-5347-41ed-a60d-0b7cf4e71024@kernel.org>
Date: Fri, 18 Jul 2025 16:17:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 06/12] blk-zoned: Introduce a loop in
 blk_zone_wplug_bio_work()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <20250717205808.3292926-7-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717205808.3292926-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 05:58, Bart Van Assche wrote:
> Prepare for submitting multiple bios from inside a single
> blk_zone_wplug_bio_work() call. No functionality has been changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c | 72 +++++++++++++++++++++++------------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 8fe6e545f300..6ef53f78fa3b 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1283,47 +1283,47 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>  	struct blk_zone_wplug *zwplug =
>  		container_of(work, struct blk_zone_wplug, bio_work);
>  	struct block_device *bdev;
> -	unsigned long flags;
>  	struct bio *bio;
>  
> -	/*
> -	 * Submit the next plugged BIO. If we do not have any, clear
> -	 * the plugged flag.
> -	 */
> -	spin_lock_irqsave(&zwplug->lock, flags);
> -
> +	do {
>  again:
> -	bio = bio_list_pop(&zwplug->bio_list);
> -	if (!bio) {
> -		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
> -		spin_unlock_irqrestore(&zwplug->lock, flags);
> -		goto put_zwplug;
> -	}
> -
> -	trace_blk_zone_wplug_bio(zwplug->disk->queue, zwplug->zone_no,
> -				 bio->bi_iter.bi_sector, bio_sectors(bio));
> -
> -	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
> -		blk_zone_wplug_bio_io_error(zwplug, bio);
> -		goto again;
> -	}
> -
> -	spin_unlock_irqrestore(&zwplug->lock, flags);
> +		/*
> +		 * Submit the next plugged BIO. If we do not have any, clear
> +		 * the plugged flag.
> +		 */
> +		scoped_guard(spinlock_irqsave, &zwplug->lock) {

I am really not a fan of this. It adds one level of indentation without making
the code easier to read.

> +			bio = bio_list_pop(&zwplug->bio_list);
> +			if (!bio) {
> +				zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
> +				goto put_zwplug;
> +			}
> +
> +			trace_blk_zone_wplug_bio(zwplug->disk->queue,
> +						 zwplug->zone_no,
> +						 bio->bi_iter.bi_sector,
> +						 bio_sectors(bio));
> +
> +			if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
> +				blk_zone_wplug_bio_io_error(zwplug, bio);
> +				goto again;
> +			}
> +		}
>  
> -	bdev = bio->bi_bdev;
> +		bdev = bio->bi_bdev;
>  
> -	/*
> -	 * blk-mq devices will reuse the extra reference on the request queue
> -	 * usage counter we took when the BIO was plugged, but the submission
> -	 * path for BIO-based devices will not do that. So drop this extra
> -	 * reference here.
> -	 */
> -	if (bdev_test_flag(bdev, BD_HAS_SUBMIT_BIO)) {
> -		bdev->bd_disk->fops->submit_bio(bio);
> -		blk_queue_exit(bdev->bd_disk->queue);
> -	} else {
> -		blk_mq_submit_bio(bio);
> -	}
> +		/*
> +		 * blk-mq devices will reuse the extra reference on the request
> +		 * queue usage counter we took when the BIO was plugged, but the
> +		 * submission path for BIO-based devices will not do that. So
> +		 * drop this extra reference here.
> +		 */
> +		if (bdev_test_flag(bdev, BD_HAS_SUBMIT_BIO)) {
> +			bdev->bd_disk->fops->submit_bio(bio);
> +			blk_queue_exit(bdev->bd_disk->queue);
> +		} else {
> +			blk_mq_submit_bio(bio);
> +		}
> +	} while (0);
>  
>  put_zwplug:
>  	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */


-- 
Damien Le Moal
Western Digital Research
