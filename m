Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E0D1A28C;
	Tue, 19 Nov 2024 03:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731985207; cv=none; b=dWe76UzlU9EikCRSaQ+bEqEm5SfItOkP/25RuEjNTaumuiw+HvEuprW0Nc262qw9cuSxn0moVsTZDC7Sbous1ymx9y4k/dSJzAJAYUSs5WIc1aUjHW+mDda/l/rztTjYGq8afM5Lo1AKSIGwzvhMKgjlnfYW6A3xxHgkX1lOtm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731985207; c=relaxed/simple;
	bh=SEmBZqabrrtdfxMtp7uyBAHvBVFPVIs7bHoN7TNTTXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blVRqdlJG0qAStDNawT8LTM3VXHB+hdqMdrXZu4zAN6lCNm+O37iFr0+W5DgbS3kJIZH7H0ZQrMqAPHL/sH6NdrcodIKXt3mhsn351f3TugIjunTFuDoxnFj9Q7pETeGYpelcEFTGJj2OLZpKjSQnVnm8SnLf+fBDGJ2B34QMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjCbm3Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjCbm3Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE88C4CECC;
	Tue, 19 Nov 2024 03:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731985207;
	bh=SEmBZqabrrtdfxMtp7uyBAHvBVFPVIs7bHoN7TNTTXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WjCbm3Y8KJy5KV4OKiUfKDMsMPzn0VscL0abXZk4pjg4La0p2mUUy544C7ibJTgWF
	 5c+11o32r5etk/2e5M0R54INfA0VLfG6BrfplBzY5Koqkdoj81yOgoKXIFlG12djKS
	 r432SrmLZC0XBd0y899mx6YpPKWYgWGowArJ4aMQpln5r6JLtETV77PZAsHyp1wX40
	 ASBvWuRBzh1oiai/2+DYixTfe7uAXspX1U3h7mhwaODQfGDOHOspnYetUF2DqDZCRi
	 6+kzamvgYX56vIIYVWfHqH9jFWqopcMH3wGM7qXf6bwn+fJtkfzNYZz949L6Lhc36J
	 o8iKVu9qGp8Pg==
Message-ID: <286101f8-c01f-4b10-bb94-adb8928e50e6@kernel.org>
Date: Tue, 19 Nov 2024 12:00:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 06/26] blk-zoned: Fix requeuing of zoned writes
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-7-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 9:27 AM, Bart Van Assche wrote:
> Make sure that unaligned writes are sent to the block driver. This
> allows the block driver to limit the number of retries of unaligned
> writes. Remove disk_zone_wplug_abort_unaligned() because it only examines
> the bio plug list. Pending writes can occur either on the bio plug list
> or on the request queue requeue list.

There can be only one write in flight, so at most one write in the requeue
list... And if that write was requeued, it means that it was not even started
so is not failed yet. So not sure what this is all about.

Am I missing something ?

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c | 36 ------------------------------------
>  1 file changed, 36 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 284820b29285..ded38fa9ae3d 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -577,33 +577,6 @@ static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
>  		blk_zone_wplug_bio_io_error(zwplug, bio);
>  }
>  
> -/*
> - * Abort (fail) all plugged BIOs of a zone write plug that are not aligned
> - * with the assumed write pointer location of the zone when the BIO will
> - * be unplugged.
> - */
> -static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
> -					    struct blk_zone_wplug *zwplug)
> -{
> -	unsigned int wp_offset = zwplug->wp_offset;
> -	struct bio_list bl = BIO_EMPTY_LIST;
> -	struct bio *bio;
> -
> -	while ((bio = bio_list_pop(&zwplug->bio_list))) {
> -		if (disk_zone_is_full(disk, zwplug->zone_no, wp_offset) ||
> -		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
> -		     bio_offset_from_zone_start(bio) != wp_offset)) {
> -			blk_zone_wplug_bio_io_error(zwplug, bio);
> -			continue;
> -		}
> -
> -		wp_offset += bio_sectors(bio);
> -		bio_list_add(&bl, bio);
> -	}
> -
> -	bio_list_merge(&zwplug->bio_list, &bl);
> -}
> -
>  static inline void disk_zone_wplug_set_error(struct gendisk *disk,
>  					     struct blk_zone_wplug *zwplug)
>  {
> @@ -982,14 +955,6 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>  		 * so that we can restore its operation code on completion.
>  		 */
>  		bio_set_flag(bio, BIO_EMULATES_ZONE_APPEND);
> -	} else {
> -		/*
> -		 * Check for non-sequential writes early because we avoid a
> -		 * whole lot of error handling trouble if we don't send it off
> -		 * to the driver.
> -		 */
> -		if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
> -			goto err;
>  	}
>  
>  	/* Advance the zone write pointer offset. */
> @@ -1425,7 +1390,6 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>  
>  	/* Update the zone write pointer offset. */
>  	zwplug->wp_offset = zwplug->wp_offset_compl;
> -	disk_zone_wplug_abort_unaligned(disk, zwplug);
>  
>  	/* Restart BIO submission if we still have any BIO left. */
>  	if (!bio_list_empty(&zwplug->bio_list)) {


-- 
Damien Le Moal
Western Digital Research
