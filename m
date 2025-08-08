Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096D27CB31;
	Fri,  8 Aug 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754660319; cv=none; b=uLtABjYdX1AII76RPCpqa2KWp6satLmKe+2e98iNxrCX7rTpx/qOBhc+6X8Tbifb86u8L2IdcpmmtSSxSF0/i9mB07Jn+bP2v0g67qjzVoRtE236gPeKacWsyIecqq5XjSQ6QuJ08Q9XikAFsl8wGd0J7XthiAMH/zYECZ9lemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754660319; c=relaxed/simple;
	bh=xNNphpZVuuV6U/Jc9k5AyTfzIpZRp1BJyfmovI8qRz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6LrWFmsIdCHafkwd6vTE5oHpDJzCs0zYSDMLVNYzlPrImUiofone2F+akr/BtvGn4AAPF25K6MkPY26KeIQT2V/Jbrqbtk647ezrSWrRWOzZINqTk9U36y48EZyQ599i+ogUTd/GGr5fFW0DZbxadP0Lwnin77elR92xQZ28PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYfqvPRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYfqvPRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408EEC4CEED;
	Fri,  8 Aug 2025 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754660318;
	bh=xNNphpZVuuV6U/Jc9k5AyTfzIpZRp1BJyfmovI8qRz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fYfqvPRpqL9tPn1XlTBGjZCrl23fSZnBBxWkK3d0SLIQYUv1mTmhtGw+SYAOZFsEc
	 8jGV1OPcY71+2hanQRPlvCztRXRtCZrg+TDzTXOraT0FFPKC9LFc01OerloGi3BDR+
	 rOsK+gTRzCfS7yG6KxwdXCfEG/57frdX+ARcwKa+ehuqlHoqK5po3JAlHypiLQoM9n
	 akslpsAr4M7T6RjNxYjsa542e3DHK5aLxAVffmPIxCDb5PEfb/kLjhGgl6latNHpa5
	 VFLIpcR2UIWUe4vX+MODn1F0r/OAqHW3lJIfHuFC0ESRh3oleZ9Hfg6qj8eA+Int1I
	 XFgAP/0KswDiw==
Message-ID: <4786fbb9-5d25-4d86-b902-61cc78a9b138@kernel.org>
Date: Fri, 8 Aug 2025 22:38:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: Fix build warning in sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <5cfefec0-b64b-4f96-a943-4de3205d3c50@kernel.org>
 <20250808113019.20177-1-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250808113019.20177-1-abinashsinghlalotra@gmail.com>
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
> Hi,
> 
> Thank you very much for your comments.
> I have addressed all your suggestions from v1.
> 
> As you mentioned concerns regarding the readability of
> the __free(kfree) attribute, I have used the classic
> approach in v2. Additionally, I will also send v3
> where the __free() attribute is used instead.
> 
> We can proceed with patch version you
> find more suitable, and do let me know if you have
> any further feedback.
> 
> changelog v1->v2:
> 	moved declarations together
> 	avoided "unreadable" cleanup attribute
> 	splited long line
> 	changed the log message to diiferentiate with buffer allocation
> 
> Thanks,
> 
> ---
>  drivers/scsi/sd.c | 49 +++++++++++++++++++++++++++++------------------
>  1 file changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4a68b2ab2804..f5ab2a422df6 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3696,7 +3696,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	struct scsi_disk *sdkp = scsi_disk(disk);
>  	struct scsi_device *sdp = sdkp->device;
>  	sector_t old_capacity = sdkp->capacity;
> -	struct queue_limits lim;
> +	struct queue_limits *lim;
>  	unsigned char *buffer;
>  	unsigned int dev_max;
>  	int err;

If you change this to "int err = 0", then...

> @@ -3711,23 +3711,30 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
>  			  "allocation failure.\n");
> -		goto out;
> +		goto free_lim;

Yout can do a "goto out" here...

>  	}
>  

[...]

>  	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
> -	sd_config_write_same(sdkp, &lim);
> +	sd_config_write_same(sdkp, lim);
>  	kfree(buffer);

Move this line after the "out" label...

>  
> -	err = queue_limits_commit_update_frozen(sdkp->disk->queue, &lim);
> -	if (err)
> +	err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
> +	if (err) {

just do a goto out here...

> +		kfree(lim);
>  		return err;
> +	}
>  
>  	/*
>  	 * Query concurrent positioning ranges after
> @@ -3819,6 +3828,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	if (sd_zbc_revalidate_zones(sdkp))
>  		set_capacity_and_notify(disk, 0);
>  
> + free_lim:
> +	kfree(lim);
>   out:

And this becomes:

 out:
	kfree(lim);
	kfree(buffer)

	return err;

Much cleaner :)

>  	return 0;
>  }


-- 
Damien Le Moal
Western Digital Research
