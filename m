Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628FA13BC26;
	Thu,  6 Jun 2024 12:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717676194; cv=none; b=cxmWlii/Ev0HLDDTUI+NionMI1bkJ0u136z3KpvPuFraAkcd88zzgQqPpF7yipF3pCtp4NzX3zEWx/6s03xr//TQure6y1QB6v9K5nX+yPz1zaiJXgfVv16rhZbc+yNZr669YPU1F8QmuIvqT9hpaPjNDouqmLenLea2V3O6ebc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717676194; c=relaxed/simple;
	bh=X7IRKLYQKUcL4/AyrQBAFh74hOuWJ1e48IxTurIYDX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KTYI9sW4hvB4aC5XKlVHkBsPBZjyEV/g41kB7c1X2Zblc7RtLcfNSCnsxE0fFeLNK14w9V/1ePPyVJMFk3iMh1/+QFEU+ABPGaXpMO2E1QT8JQjWvYzUmKIyYKFBjTxMYeOpWcZf6CewoahKB1azFdwr/moEei5I6rFc2QXEI8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHQ+51MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHQ+51MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592ACC3277B;
	Thu,  6 Jun 2024 12:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717676193;
	bh=X7IRKLYQKUcL4/AyrQBAFh74hOuWJ1e48IxTurIYDX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bHQ+51MAXahcjeROL/4TbzyUkWLVBN242M2ewTZR1Vjfxz8YMHlaQ/FMUd3Gp6Znn
	 Wel4nfem/j67CcKf9XWhiFDNf2VyHbN00HiEFbbXcCihhYv7b2JjhTZj6wT8padP/X
	 hZP8HKPy5dj9zogb5QIYg1wB86qyhOKqmrTYkMw6SjJKAOw/hAP6L8HWFyRddHUuEs
	 Kool4/WK7ZdL+BraCwoSaQ3/cRPE9sSRGk7hCsB5OYzKNvBt73mENDh9po4i2qift1
	 giJeNV7HF/cLC0+HMSKfucbkC8tfLq6roMmqUX8HgWrMWxipeQZC0oos2QC6TlxpI2
	 EBLdCsgmhRQNw==
Message-ID: <0d32c921-39d4-4c64-be4a-87c4d67e8e36@kernel.org>
Date: Thu, 6 Jun 2024 21:16:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ata: pata_macio: Fix max_segment_size with PAGE_SIZE ==
 64K
To: Michael Ellerman <mpe@ellerman.id.au>, martin.petersen@oracle.com,
 cassel@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 regressions@lists.linux.dev, doru.iorgulescu1@gmail.com
References: <20240606111445.400001-1-mpe@ellerman.id.au>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240606111445.400001-1-mpe@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 20:14, Michael Ellerman wrote:
> The pata_macio driver advertises a max_segment_size of 0xff00, because
> the hardware doesn't cope with requests >= 64K.
> 
> However the SCSI core requires max_segment_size to be at least
> PAGE_SIZE, which is a problem for pata_macio when the kernel is built
> with 64K pages.
> 
> In older kernels the SCSI core would just increase the segment size to
> be equal to PAGE_SIZE, however since the commit tagged below it causes a
> warning and the device fails to probe:
> 
>   WARNING: CPU: 0 PID: 26 at block/blk-settings.c:202 .blk_validate_limits+0x2f8/0x35c
>   CPU: 0 PID: 26 Comm: kworker/u4:1 Not tainted 6.10.0-rc1 #1
>   Hardware name: PowerMac7,2 PPC970 0x390202 PowerMac
>   ...
>   NIP .blk_validate_limits+0x2f8/0x35c
>   LR  .blk_alloc_queue+0xc0/0x2f8
>   Call Trace:
>     .blk_alloc_queue+0xc0/0x2f8
>     .blk_mq_alloc_queue+0x60/0xf8
>     .scsi_alloc_sdev+0x208/0x3c0
>     .scsi_probe_and_add_lun+0x314/0x52c
>     .__scsi_add_device+0x170/0x1a4
>     .ata_scsi_scan_host+0x2bc/0x3e4
>     .async_port_probe+0x6c/0xa0
>     .async_run_entry_fn+0x60/0x1bc
>     .process_one_work+0x228/0x510
>     .worker_thread+0x360/0x530
>     .kthread+0x134/0x13c
>     .start_kernel_thread+0x10/0x14
>   ...
>   scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> Although the hardware can't cope with a 64K segment, the driver
> already deals with that internally by splitting large requests in
> pata_macio_qc_prep(). That is how the driver has managed to function
> until now on 64K kernels.
> 
> So fix the driver to advertise a max_segment_size of 64K, which avoids
> the warning and keeps the SCSI core happy.
> 
> Fixes: afd53a3d8528 ("scsi: core: Initialize scsi midlayer limits before allocating the queue")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/ce2bf6af-4382-4fe1-b392-cc6829f5ceb2@roeck-us.net/
> Reported-by: Doru Iorgulescu <doru.iorgulescu1@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218858
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  drivers/ata/pata_macio.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
> index 817838e2f70e..3cb455a32d92 100644
> --- a/drivers/ata/pata_macio.c
> +++ b/drivers/ata/pata_macio.c
> @@ -915,10 +915,13 @@ static const struct scsi_host_template pata_macio_sht = {
>  	.sg_tablesize		= MAX_DCMDS,
>  	/* We may not need that strict one */
>  	.dma_boundary		= ATA_DMA_BOUNDARY,
> -	/* Not sure what the real max is but we know it's less than 64K, let's
> -	 * use 64K minus 256
> +	/*
> +	 * The SCSI core requires the segment size to cover at least a page, so
> +	 * for 64K page size kernels this must be at least 64K. However the
> +	 * hardware can't handle 64K, so pata_macio_qc_prep() will split large
> +	 * requests.
>  	 */
> -	.max_segment_size	= MAX_DBDMA_SEG,
> +	.max_segment_size	= SZ_64K,
>  	.device_configure	= pata_macio_device_configure,
>  	.sdev_groups		= ata_common_sdev_groups,
>  	.can_queue		= ATA_DEF_QUEUE,

-- 
Damien Le Moal
Western Digital Research

