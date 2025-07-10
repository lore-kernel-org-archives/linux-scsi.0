Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517514C97;
	Thu, 10 Jul 2025 04:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752121876; cv=none; b=ZI3EL4mlyM4dKcgZNZ70HSdJnSaxANUaf2js9zoPF7mha8tFh1dIXMRAfGVxOXsFlNae2AYG4ulhr9TPHXQcHr1LIWT/8DkW7pykp0M6YGyBOV2v8Sm3JHf6VsTXTfBSYKLBJ7ZRi5pxWX22N3iKNjn/YxPxZlRCcxmH32hX5cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752121876; c=relaxed/simple;
	bh=/Bo+TyYCzgF6Ph4QBCoi1SXpCRqNZ2sJdkXxbT+cDHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSMWT9lVdAF0hJh4R6oJwy6MtDwW0W3pYtlAblCoRCCchldWDbs/9G89RC8nWnMHCvy0hwNejpjQzu55guEc184tc4fr+8L4RO6LBYr+tTUka75V2KgyyQI76JcntC8OK+y6yc+jo5j4i9lgB4waPildlls4FLRoN2X2W4DJiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcQT9mKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcQT9mKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0372C4CEE3;
	Thu, 10 Jul 2025 04:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752121875;
	bh=/Bo+TyYCzgF6Ph4QBCoi1SXpCRqNZ2sJdkXxbT+cDHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pcQT9mKySpPIg2xrVL5CdYK57c/vhUtq25RDNMURWRZasTc6iCeU4NxXJmlNCIL52
	 auK8DjbC/j0FtOU2jem4CpBm+fA40nzb1Pyc2/wuNzCRBgK8fc7RbiFL0me5z1FGHK
	 GXCvo3bEOO++NjORTzeNS8/hc0Az3bPdQWQqe7eQCF2o67wn/NnxiduuAqoDaYLtsZ
	 Z+aRUb3fEd55j2hUTbjMeYzCKWeE+1jw217k2fR6nLVok7mdubbzisbtBU/jkIwgOF
	 v+kyH62WTnSneN03jY9iD/mSmmCjeXA0w6eHtA+xDnGe0CU+78pSywGJqGeIt0r6Tr
	 rWzNtXvuZMqwQ==
Message-ID: <12ad2ed3-53b7-489a-9e91-ee6b1099f535@kernel.org>
Date: Thu, 10 Jul 2025 13:28:59 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 01/13] block: Support block drivers that preserve the
 order of write requests
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 Nitesh Shetty <nj.shetty@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250708220710.3897958-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 7:06 AM, Bart Van Assche wrote:
> Some storage controllers preserve the request order per hardware queue.
> Some but not all device mapper drivers preserve the bio order. Introduce
> the request queue limit member variable 'driver_preserves_write_order' to
> allow block drivers and device mapper drivers to indicate that the order
> of write commands is preserved per hardware queue and hence that
> serialization of writes per zone is not required if all pending writes are
> submitted to the same hardware queue.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Nitesh Shetty <nj.shetty@samsung.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-settings.c   | 2 ++
>  include/linux/blkdev.h | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a000daafbfb4..bceb9a9cb5ba 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -814,6 +814,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	}
>  	t->max_secure_erase_sectors = min_not_zero(t->max_secure_erase_sectors,
>  						   b->max_secure_erase_sectors);
> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
> +		b->driver_preserves_write_order;

See blk_stack_limits() and the section:

/*
 * Some feaures need to be supported both by the stacking driver and all
 * underlying devices.  The stacking driver sets these flags before
 * stacking the limits, and this will clear the flags if any of the
 * underlying devices does not support it.
 */
if (!(b->features & BLK_FEAT_NOWAIT))
	t->features &= ~BLK_FEAT_NOWAIT;
if (!(b->features & BLK_FEAT_POLL))
	t->features &= ~BLK_FEAT_POLL;

And make driver_preserves_write_order a feature instead of treating it
specially. Also, the name "driver_preserves_write_order" is not great. The
driver may be preserving write order, but the hardware not (e.g. libata and AHCI).

>  	t->zone_write_granularity = max(t->zone_write_granularity,
>  					b->zone_write_granularity);
>  	if (!(t->features & BLK_FEAT_ZONED)) {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5f14c20c8bc0..4dec1d91b7f2 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -413,6 +413,11 @@ struct queue_limits {
>  
>  	unsigned int		max_open_zones;
>  	unsigned int		max_active_zones;
> +	/*
> +	 * Whether or not the block driver preserves the order of write
> +	 * requests per hardware queue. Set by the block driver.
> +	 */
> +	bool			driver_preserves_write_order;
>  
>  	/*
>  	 * Drivers that set dma_alignment to less than 511 must be prepared to


-- 
Damien Le Moal
Western Digital Research
