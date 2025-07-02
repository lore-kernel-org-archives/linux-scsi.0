Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A29C23956E;
	Wed,  2 Jul 2025 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751453875; cv=none; b=Ge1W+nC0gBOA44TV2oXUKvcK2b8D2DgLAWlWDpZlI613l0Yq0ntpvtP1oH/+8pOm3TKjA4RQkpy14u5V4ReM4nAZGLX+7xuFa4gNB3SmhpoRi05qIWbGroHv1dPItGIQFQAR29ifUjCpsHmrejs6SAHUXl0rJDAeQTl2sQjJbo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751453875; c=relaxed/simple;
	bh=0NhWpmAF5oIbUp7Q5luzWCHiyeWmqI4TcBVmANGR5Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CH71Iw9I1Ky7jeylnU5r8024Gff0DwcHVMEC3yZ/eSxHp4imgHOvISeqEYcQ138nRXMBBuyerRJlz6MfCE4PTS4J9fNz1fA3eAMFgYqjwheGDtHrTVGDr7t9YhgwDpoURtwHqZtBHkeTxW3u/EpcBLrEnRKLiEZXv2syYFYOkww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+QrHvoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+QrHvoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E47C4CEED;
	Wed,  2 Jul 2025 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751453874;
	bh=0NhWpmAF5oIbUp7Q5luzWCHiyeWmqI4TcBVmANGR5Lk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T+QrHvoSyHMnlxCnUhdbb8pmG3SDf8+ItkXXVJXs5/dJ0u2BbNThk8mcuA9NiHgoh
	 YEabfGNiurN6CV7/lqD3WAhAKDxVA1ZifjPjQS3Sv6ByW0eZxkfAcCi6ZmDft6TQ6R
	 eYRLPhCkbH8QCf3PsCywum5JZQnUyR+k1h8J5s0AtXQN7x55FhcK5kYKtmMd+HUIIo
	 dNOCXsaNCPLDSdZoXM28GX4XuYqJxZpD6J7jKEeT46JlPR+zJiOymyQ7oo0BVsEu+X
	 2eX32hE9qKPk66ecMYQEmHVKtFab+TPjTsTKVNdoPGbW960R/ib/ew+h5jpJZLP8/Z
	 QtXVfF6H1GXqw==
Message-ID: <0f9f5900-b7d0-4df2-8c05-fc147c991534@kernel.org>
Date: Wed, 2 Jul 2025 19:57:52 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 01/11] block: Support block drivers that preserve the
 order of write requests
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 Nitesh Shetty <nj.shetty@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20250630223003.2642594-1-bvanassche@acm.org>
 <20250630223003.2642594-2-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250630223003.2642594-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/1/25 07:29, Bart Van Assche wrote:
> Some storage controllers preserve the request order per hardware queue.
> Introduce the request queue limit member variable
> 'driver_preserves_write_order' to allow block drivers to indicate that
> the order of write commands is preserved per hardware queue and hence
> that serialization of writes per zone is not required if all pending
> writes are submitted to the same hardware queue.
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

Why not use a feature instead ? Stacking of the features does exactly this, no ?
That would be less code and one less limit.

>  	t->zone_write_granularity = max(t->zone_write_granularity,
>  					b->zone_write_granularity);
>  	if (!(t->features & BLK_FEAT_ZONED)) {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a51f92b6c340..aa1990d94130 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -408,6 +408,11 @@ struct queue_limits {
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
