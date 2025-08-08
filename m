Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD2427A900;
	Fri,  8 Aug 2025 13:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754660159; cv=none; b=BjZmQlGgBmc9xLDjNB12wVpiUgxbB8qUkh0q9iidruboHDmGHWrQzTWjX9ldUgLTStE7hbkdhAK2DsIWzjmMdRUz10Qp02yiuE2WaYF8tZIt5nQ77rCxwaQNwL4tZhvg7Mga9bhFULYJQAl2V2y2sSBq91i5MHhoo0V0ZwUvFJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754660159; c=relaxed/simple;
	bh=ugMv9daRYsiuonZ3UFEtwMOahAXurNVX+tOnqoZA/fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDuq2HYBI2J/r8oVhpECJ+/sKPWgOQwEE7b1rRz4002Dqd9vyexTqRAPa3jqH+aP+9565TK2IyPdSoaIL+2BTjVbv6sYpI22cSMyHXSYIyLybAzrBkPbVlGAxACM1eTYqihWs8KESkrH2NPe9iZKZnJvXvbPv6ZMSwS4wux6hsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0gCoGTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0gCoGTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFD7C4CEED;
	Fri,  8 Aug 2025 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754660159;
	bh=ugMv9daRYsiuonZ3UFEtwMOahAXurNVX+tOnqoZA/fQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f0gCoGTBpi4y9hbBdFSrM2eokdHdIVGqdel1FzQyFoMkcRlZGadT5FftwPFj9VPwj
	 Ag1IcGif4uyxt0GuGi9OvkwFayY5c9LfjPAkKUytXzko7CGQfHheLBbBSVi+yIOS15
	 ltzSCBCBZ6qmrbc1XdlyOFTg0dADNKEd4zjekdzAUN2TkP4Ck8PsEZQWOqyn2xfNmd
	 SN6rBBSqNaIbfiKE0oajzNZe9LVLLm8/Yr0HPcyrK1s9HmUyKUnuWcbShkwzzxbZGz
	 s2xJR/padrb9xfdhsLqkmmotwdCZi/qkTMZxJmzXfyDIlBmb7h1p7cEqKv7F0nLq7I
	 GlddrMGU4XKPQ==
Message-ID: <a0a339db-d2a0-48ba-9b5e-ef1384801481@kernel.org>
Date: Fri, 8 Aug 2025 22:35:57 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sd: Fix build warning in sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <5cfefec0-b64b-4f96-a943-4de3205d3c50@kernel.org>
 <20250808113019.20177-1-abinashsinghlalotra@gmail.com>
 <20250808113019.20177-2-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250808113019.20177-2-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/8/25 20:30, Abinash Singh wrote:
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
> ---
> 
> Hi ,
> 
> As I mentioned in v2,.. this is the corresponding
> v3 of that. Only difference is in using __free() attribute
> Please infor  me which one is better.

Matter of taste. Personally, I dislike annotations that hide code.
I'll let Martin decide on this.

> 
> changelog v2->v3:
> 	used __free(kfree) attribute.
> 	no extra goto statements (i.e `free_lim`)
> 
> lim was initialized to NULL because there is a return path
> before its allocation. Early exit will pass uninitlized pointer to
> `kfree`.
> We could move the allocation earlier, before this check:
> 
> 			if (!scsi_device_online(sdp))
>     			goto out;
> However, doing so would result in unnecessary allocation
> if the device is not online, leading to wasted resources.
> 
> Thanks,
> ---
>  drivers/scsi/sd.c | 42 +++++++++++++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4a68b2ab2804..50abbab7e27a 100644
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
> @@ -3696,7 +3697,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	struct scsi_disk *sdkp = scsi_disk(disk);
>  	struct scsi_device *sdp = sdkp->device;
>  	sector_t old_capacity = sdkp->capacity;
> -	struct queue_limits lim;
> +	struct queue_limits *lim __free(kfree) = NULL;
>  	unsigned char *buffer;
>  	unsigned int dev_max;
>  	int err;
> @@ -3711,6 +3712,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	if (!scsi_device_online(sdp))
>  		goto out;
>  
> +	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
> +	if (!lim) {
> +		sd_printk(KERN_WARNING, sdkp,
> +			"sd_revalidate_disk: Disk limit allocation failure.\n");
> +		goto out;
> +	}
> +
>  	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
>  	if (!buffer) {
>  		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
> @@ -3720,14 +3728,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
> @@ -3741,17 +3749,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
> @@ -3761,45 +3769,45 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
