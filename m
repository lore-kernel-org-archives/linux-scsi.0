Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF374AEE2;
	Fri,  8 Aug 2025 08:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754640236; cv=none; b=TsiEIsM9HOp7bReQAtRLP+Jz5lJC9mdWn6S1TEGD0BUgPilx+1cSzuidgJFhRlE79zCmXPD9rKyr8TQ7XvUARZPg3gAzBVedguZDe20WRkcSCGNTqUiUhlQRWc4QpCfXXnT+uLkbv+D+m8+hVhZX3J/yrX9xo5rQC/eiLnxK+lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754640236; c=relaxed/simple;
	bh=upidoVouFlYnnKwWq5YqHJX7odCiw+ilU2lgJvtYf5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TET3mKzAEsSkbnuymTvJW0KUl3sjCRUW6j72BgfbPES28UC+PBHy5cOZPVsPko54kE1DnJov9Hj1Jw0TRQHKtkogFGUb5UYhOctk4MFRFJtWRBKDcLc9AgHsgp7+Pvg2ixf1CGHTskhOzT01jFk5A+3osKOB9TQT2a+8duGi2/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqWBCFoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqWBCFoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85018C4CEED;
	Fri,  8 Aug 2025 08:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754640236;
	bh=upidoVouFlYnnKwWq5YqHJX7odCiw+ilU2lgJvtYf5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iqWBCFoLiQSge0i141OzQRbbujzAu6K7WvzRl9n/gx4mhzRO+NqSFltDoBCfHbGQD
	 3s344iaBd3XzaQR2MLAsmvv4iZeTDF/TUZzkxm3JmsK6j3SvsvPt3EyEdseF4fMKrI
	 Nakw6ZfrHj3B4V7jbgAANp5se0dvWLMkcVN1iaSRZRqmRERLfwpyEKOIQnSgMqxngI
	 q+BCeRaNnLnzZst72rLgwXz+EzBut86c2MfckQ2xebVqxF8qsrEdNMD6g5h6JJAUrw
	 U8eM1jhhPrH2/txfbuUD6/NSgMcBY1s2Zf8alaoBXnax86HnxYtV3DIKnOXQxztHKl
	 +gMUmEbQhxjrw==
Message-ID: <5cfefec0-b64b-4f96-a943-4de3205d3c50@kernel.org>
Date: Fri, 8 Aug 2025 17:01:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: sd: Fix build warning in sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>,
 James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250807183000.31465-1-abinashsinghlalotra@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250807183000.31465-1-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/8/25 3:30 AM, Abinash Singh wrote:
> A build warning was triggered due to excessive stack usage in
> sd_revalidate_disk():
> 
> drivers/scsi/sd.c: In function ‘sd_revalidate_disk.isra’:
> drivers/scsi/sd.c:3824:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> This is caused by a large local struct queue_limits (~400B) allocated
> on the stack. Replacing it with a heap allocation using kmalloc()
> significantly reduces frame usage. Kernel stack is limited (~8 KB),
> and allocating large structs on the stack is discouraged.
> As the function already performs heap allocations (e.g. for buffer),
> this change fits well.
> 
> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4a68b2ab2804..a03844400e51 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -34,6 +34,7 @@
>   */
>  
>  #include <linux/bio-integrity.h>
> +#include <linux/cleanup.h>
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/kernel.h>
> @@ -3696,11 +3696,16 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	struct scsi_disk *sdkp = scsi_disk(disk);
>  	struct scsi_device *sdp = sdkp->device;
>  	sector_t old_capacity = sdkp->capacity;
> -	struct queue_limits lim;
>  	unsigned char *buffer;
>  	unsigned int dev_max;
>  	int err;
>  
> +	struct queue_limits *lim __free(kfree) = kmalloc(sizeof(*lim), GFP_KERNEL);

Please keep the declarations together. Not sure how that will work with that
unreadable __free(kfree) annotation though (the "unreadable" part of this
comment is only my opinion... I really dislike stuff that hides code...).

> +	if (!lim) {
> +		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory allocation failure.\n");

Long line. Please split after sdkp. Also, the same message is used for the
buffer allocation. So maybe differentiate with it ? E.g. something like "Disk
limit allocation failure" ?

> +		goto out;
> +	}
> +
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>  				      "sd_revalidate_disk\n"));
>  
> @@ -3720,14 +3726,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  
>  	sd_spinup_disk(sdkp);
>  
> -	lim = queue_limits_start_update(sdkp->disk->queue);
> +	*lim = queue_limits_start_update(sdkp->disk->queue);
>  
>  	/*
>  	 * Without media there is no reason to ask; moreover, some devices
>  	 * react badly if we do.
>  	 */
>  	if (sdkp->media_present) {
> -		sd_read_capacity(sdkp, &lim, buffer);
> +		sd_read_capacity(sdkp, lim, buffer);
>  		/*
>  		 * Some USB/UAS devices return generic values for mode pages
>  		 * until the media has been accessed. Trigger a READ operation
> @@ -3741,17 +3747,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		 * cause this to be updated correctly and any device which
>  		 * doesn't support it should be treated as rotational.
>  		 */
> -		lim.features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
> +		lim->features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
>  
>  		if (scsi_device_supports_vpd(sdp)) {
>  			sd_read_block_provisioning(sdkp);
> -			sd_read_block_limits(sdkp, &lim);
> +			sd_read_block_limits(sdkp, lim);
>  			sd_read_block_limits_ext(sdkp);
> -			sd_read_block_characteristics(sdkp, &lim);
> -			sd_zbc_read_zones(sdkp, &lim, buffer);
> +			sd_read_block_characteristics(sdkp, lim);
> +			sd_zbc_read_zones(sdkp, lim, buffer);
>  		}
>  
> -		sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));
> +		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
>  
>  		sd_print_capacity(sdkp, old_capacity);
>  
> @@ -3761,45 +3767,45 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_app_tag_own(sdkp, buffer);
>  		sd_read_write_same(sdkp, buffer);
>  		sd_read_security(sdkp, buffer);
> -		sd_config_protection(sdkp, &lim);
> +		sd_config_protection(sdkp, lim);
>  	}
>  
>  	/*
>  	 * We now have all cache related info, determine how we deal
>  	 * with flush requests.
>  	 */
> -	sd_set_flush_flag(sdkp, &lim);
> +	sd_set_flush_flag(sdkp, lim);
>  
>  	/* Initial block count limit based on CDB TRANSFER LENGTH field size. */
>  	dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
>  
>  	/* Some devices report a maximum block count for READ/WRITE requests. */
>  	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
> -	lim.max_dev_sectors = logical_to_sectors(sdp, dev_max);
> +	lim->max_dev_sectors = logical_to_sectors(sdp, dev_max);
>  
>  	if (sd_validate_min_xfer_size(sdkp))
> -		lim.io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
> +		lim->io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
>  	else
> -		lim.io_min = 0;
> +		lim->io_min = 0;
>  
>  	/*
>  	 * Limit default to SCSI host optimal sector limit if set. There may be
>  	 * an impact on performance for when the size of a request exceeds this
>  	 * host limit.
>  	 */
> -	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
> +	lim->io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
>  	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
> -		lim.io_opt = min_not_zero(lim.io_opt,
> +		lim->io_opt = min_not_zero(lim->io_opt,
>  				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
>  	}
>  
>  	sdkp->first_scan = 0;
>  
>  	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
> -	sd_config_write_same(sdkp, &lim);
> +	sd_config_write_same(sdkp, lim);
>  	kfree(buffer);
>  
> -	err = queue_limits_commit_update_frozen(sdkp->disk->queue, &lim);
> +	err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
>  	if (err)
>  		return err;
>  


-- 
Damien Le Moal
Western Digital Research
