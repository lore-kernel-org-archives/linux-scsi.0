Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFD4E555;
	Tue, 12 Aug 2025 02:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754964927; cv=none; b=LTOnIa4TnESMFPjMIgiJkHGp/kj+28zNCwJDw+xX+PXHSXZYXT8CwZXguD/5NrKpMlFhZ0x8HXwv/sRZvdtycRgPO+OqWbIcdOm7xPrBp86lvEYdFTbz/SEHf5ZA/gtVUe+uk5T1evo+sRTHy1x/vEZW/zdIKqAaUQqsTdPszVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754964927; c=relaxed/simple;
	bh=PjVELmDzYaMLkBp10XWSYXeAtvViFlQaJPa5dzLJuMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E9rBtQqfSRFiKgrh7LhSTNAuFZpPqJ5eeq4K954xQstrYWi6274LDd8dEtfj9YV9FIYrtc1rDuXKA3iBzp1EGC5TAQ8jDLu+/MBuo8Rvit2b3cyBxJ5Ue7/5y0a1c8C18ijVxYEjUPfZVN326knnwmjMGeWMM05ixCNkKzwL2ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDob5GWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDob5GWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D1DC4CEED;
	Tue, 12 Aug 2025 02:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754964926;
	bh=PjVELmDzYaMLkBp10XWSYXeAtvViFlQaJPa5dzLJuMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uDob5GWnEa5Hkc2pEjI68lfRGCT/9MdLQ4vphtoXQ5Q25AqxmULNGCVZBJcDwi/9c
	 pF2B2M3hqdfQxKcytyQcB4L8cksau6bs/EeQYRLZX/F4B1seO5JO/Q4Hix7zQKksL5
	 m5xEBeYzA23vrE2Jsja1Z+uoc7dciAqTzRjm0XGVanpZapWMmowxaiiHPnWcqDKpjA
	 jL4qazc1SLmrwOCiw4vmURqykrokpxRKD/Kf5vjZZZCZR+ojhs6Uzx42mev7qWTvnH
	 lsCLBkMl/T463uLyzzk26N9/bMKJj5OWhS2skqbFEEtjs8D4atx4AcYrEpu2naqhSJ
	 Iz8h7rLUQwuEQ==
Message-ID: <7570f60f-932b-4b76-a87d-8f3f0760c44f@kernel.org>
Date: Tue, 12 Aug 2025 11:12:44 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 01/16] block: Support block devices that preserve the
 order of write requests
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250811200851.626402-1-bvanassche@acm.org>
 <20250811200851.626402-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250811200851.626402-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/25 5:08 AM, Bart Van Assche wrote:
> Some storage controllers preserve the request order per hardware queue.
> Some but not all device mapper drivers preserve the bio order. Introduce
> the feature flag BLK_FEAT_ORDERED_HWQ to allow block drivers and stacked
> drivers to indicate that the order of write commands is preserved per
> hardware queue and hence that serialization of writes per zone is not
> required if all pending writes are submitted to the same hardware queue.
> Add a sysfs attribute for controlling write pipelining support.

Why ? Why would you want to disable write pipelining since it give better
performance ?

The commit message also does not describe BLK_FEAT_PIPELINE_ZWR, but I think
this enable/disable flag is not needed.

> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  Documentation/ABI/stable/sysfs-block | 15 +++++++++++++++
>  block/blk-settings.c                 | 10 ++++++++++
>  block/blk-sysfs.c                    |  7 +++++++
>  include/linux/blkdev.h               |  9 +++++++++
>  4 files changed, 41 insertions(+)
> 
> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> index 803f578dc023..5a42d99cf39a 100644
> --- a/Documentation/ABI/stable/sysfs-block
> +++ b/Documentation/ABI/stable/sysfs-block
> @@ -637,6 +637,21 @@ Description:
>  		I/O size is reported this file contains 0.
>  
>  
> +What:		/sys/block/<disk>/queue/pipeline_zoned_writes
> +Date:		August 2025
> +Contact:	Bart Van Assche <bvanassche@acm.org>
> +Description:
> +		[RW] If this attribute is present it means that the block driver
> +		and the storage controller both support preserving the order of
> +		zoned writes per hardware queue. This attribute controls whether
> +		or not pipelining zoned writes is enabled. If the value of this
> +		attribute is zero, the block layer restricts the queue depth for
> +		sequential writes per zone to one (zone append operations are
> +		not affected). If the value of this attribute is one, the block
> +		layer does not restrict the queue depth of sequential writes per
> +		zone to one.
> +
> +
>  What:		/sys/block/<disk>/queue/physical_block_size
>  Date:		May 2009
>  Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 07874e9b609f..01c0edf2308a 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -119,6 +119,14 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
>  	lim->max_zone_append_sectors =
>  		min_not_zero(lim->max_hw_zone_append_sectors,
>  			min(lim->chunk_sectors, lim->max_hw_sectors));
> +
> +	/*
> +	 * If both the block driver and the block device preserve the write
> +	 * order per hwq, enable zoned write pipelining.
> +	 */
> +	if (lim->features & BLK_FEAT_ORDERED_HWQ)
> +		lim->features |= BLK_FEAT_PIPELINE_ZWR;
> +
>  	return 0;
>  }
>  
> @@ -780,6 +788,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  		t->features &= ~BLK_FEAT_NOWAIT;
>  	if (!(b->features & BLK_FEAT_POLL))
>  		t->features &= ~BLK_FEAT_POLL;
> +	if (!(b->features & BLK_FEAT_ORDERED_HWQ))
> +		t->features &= ~BLK_FEAT_ORDERED_HWQ;
>  
>  	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
>  
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 78ee8d324c7f..4bf0b663f25d 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -270,6 +270,7 @@ QUEUE_SYSFS_FEATURE(rotational, BLK_FEAT_ROTATIONAL)
>  QUEUE_SYSFS_FEATURE(add_random, BLK_FEAT_ADD_RANDOM)
>  QUEUE_SYSFS_FEATURE(iostats, BLK_FEAT_IO_STAT)
>  QUEUE_SYSFS_FEATURE(stable_writes, BLK_FEAT_STABLE_WRITES);
> +QUEUE_SYSFS_FEATURE(pipeline_zwr, BLK_FEAT_PIPELINE_ZWR);
>  
>  #define QUEUE_SYSFS_FEATURE_SHOW(_name, _feature)			\
>  static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
> @@ -554,6 +555,7 @@ QUEUE_LIM_RO_ENTRY(queue_dax, "dax");
>  QUEUE_RW_ENTRY(queue_io_timeout, "io_timeout");
>  QUEUE_LIM_RO_ENTRY(queue_virt_boundary_mask, "virt_boundary_mask");
>  QUEUE_LIM_RO_ENTRY(queue_dma_alignment, "dma_alignment");
> +QUEUE_LIM_RW_ENTRY(queue_pipeline_zwr, "pipeline_zoned_writes");
>  
>  /* legacy alias for logical_block_size: */
>  static struct queue_sysfs_entry queue_hw_sector_size_entry = {
> @@ -700,6 +702,7 @@ static struct attribute *queue_attrs[] = {
>  	&queue_dax_entry.attr,
>  	&queue_virt_boundary_mask_entry.attr,
>  	&queue_dma_alignment_entry.attr,
> +	&queue_pipeline_zwr_entry.attr,
>  	&queue_ra_entry.attr,
>  
>  	/*
> @@ -746,6 +749,10 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
>  	    !blk_queue_is_zoned(q))
>  		return 0;
>  
> +	if (attr == &queue_pipeline_zwr_entry.attr &&
> +	    !(q->limits.features & BLK_FEAT_ORDERED_HWQ))
> +		return 0;
> +
>  	return attr->mode;
>  }
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 95886b404b16..79d14b3d3309 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -338,6 +338,15 @@ typedef unsigned int __bitwise blk_features_t;
>  /* skip this queue in blk_mq_(un)quiesce_tagset */
>  #define BLK_FEAT_SKIP_TAGSET_QUIESCE	((__force blk_features_t)(1u << 13))
>  
> +/*
> + * The request order is preserved per hardware queue by the block driver and by
> + * the block device. Set by the block driver.
> + */
> +#define BLK_FEAT_ORDERED_HWQ		((__force blk_features_t)(1u << 14))
> +
> +/* Whether to pipeline zoned writes. Controlled by the block layer. */
> +#define BLK_FEAT_PIPELINE_ZWR		((__force blk_features_t)(1u << 15))
> +
>  /* undocumented magic for bcache */
>  #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
>  	((__force blk_features_t)(1u << 15))


-- 
Damien Le Moal
Western Digital Research
