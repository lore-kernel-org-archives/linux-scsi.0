Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9413D8B4;
	Tue, 19 Nov 2024 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732001839; cv=none; b=ENmYsGBvGo1fp7/Gct9a1q2GRUSKFGtXU1y4jYN9UcOxrYfMMn+agFVPdEsKgcS3ywCFcnYh2TZZi3yVV5FbHsjo2faQR/BJlvJe/8kugIP39PuOZ4iMYB1DbGxEVEI3lFCTElT3L3FwZC/NctkGcxzbAGdKZ7bck2FMG0holVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732001839; c=relaxed/simple;
	bh=hfGMSViygS8YzL3zpj2rpnB5iyPwjZVWafsVw9LNY9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u34rbPz66m7/MqiwCDf4ELO8RLVa5jIUXYfN0FZniBCWLY4phweNdS+18sQlOkgUlOGOpDnHBfilI8yok0j28QYbZ82pGFqSkrc1BRHM8DTay6S0TERw4XqgW9/LGXFD1UeZKaho9F1iZvSAEQUmqGqpcOJ+TwLq6/br2GFBeWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vQQoaqJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vQQoaqJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC9EC4CECF;
	Tue, 19 Nov 2024 07:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732001838;
	bh=hfGMSViygS8YzL3zpj2rpnB5iyPwjZVWafsVw9LNY9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vQQoaqJ0xQ8YSlzg2uTSyU/eDPykizndVpHrzwbVRvGt1oXkgd1IJG7e5wQCH3o+H
	 847aAKIMl3A/VcfifHWgVjEkScZoPEoBCv8rL04wuBtNEYsRGIvsvE67CEQM2p4izc
	 df8ZHkZInZIw2mMC6CGWiFvDRI1FNoUg1iRwW7RKUqZ071+9bmnIMlJnTeQP4Qu8cs
	 IP07jDJcf4F5+XidfumzLdkbEUPUUdx0DB+1B14He7FeqPSSx4o+AHROsagkFq/B19
	 icecTqDPa4Gl2tMJMp1IkjdENEyUYhQetFv5ZrauWx1PnPrgcmFmpgtMTvwwtCE6ju
	 WsMBUqCjAQYdg==
Message-ID: <a11b4023-5647-419b-9de3-f48024872cc6@kernel.org>
Date: Tue, 19 Nov 2024 16:37:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 07/26] block: Support block drivers that preserve the
 order of write requests
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Hannes Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-8-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:27, Bart Van Assche wrote:
> Many but not all storage controllers require serialization of zoned
> writes. Introduce a new request queue limit member variable related to
> write serialization. 'driver_preserves_write_order' allows block drivers
> to indicate that the order of write commands is preserved per hardware
> queue and hence that serialization of writes per zone is not required if
> all pending writes are submitted to the same hardware queue.
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
> index f1d4dfdc37a7..329d8b65a8d7 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -633,6 +633,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	}
>  	t->max_secure_erase_sectors = min_not_zero(t->max_secure_erase_sectors,
>  						   b->max_secure_erase_sectors);
> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
> +		b->driver_preserves_write_order;
>  	t->zone_write_granularity = max(t->zone_write_granularity,
>  					b->zone_write_granularity);
>  	if (!(t->features & BLK_FEAT_ZONED)) {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a1fd0ddce5cf..72be33d02d1f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -397,6 +397,11 @@ struct queue_limits {
>  
>  	unsigned int		max_open_zones;
>  	unsigned int		max_active_zones;
> +	/*
> +	 * Whether or not the block driver preserves the order of write
> +	 * requests. Set by the block driver.
> +	 */
> +	bool			driver_preserves_write_order;

Why not make this a q->features flag ?

>  
>  	/*
>  	 * Drivers that set dma_alignment to less than 511 must be prepared to


-- 
Damien Le Moal
Western Digital Research
