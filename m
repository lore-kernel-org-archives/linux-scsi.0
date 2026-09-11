Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AB842C512;
	Fri, 11 Sep 2026 08:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789114318; cv=none; b=Tav9ZEKnjsksHaPxNCIjX0Pg4KcdnqShRm6QwRVHmGINzEWgH/saHJUlaLF4eNDaYw5BMPclmBPCpDcQHDScAJP3GAURTT3IuQ2OKQmc0hLobVWPP8Dc/BrjOoxJpNpVMdr+DY8lQE8ZmTNi3AjGpxu99vugiUVuASlqa4IuuWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789114318; c=relaxed/simple;
	bh=9stVxPJFwA4nYgL/nVRCOqs6BvJUN2hOdvXN93SFH3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlCfETicZLs5AE9yBtEyJnL4oprCDFPSGlXXRJ9JIIZ9feJyVGgFyWeBovVICWonvYRgHpCNUM6lEwx3cchMKNjFLNKWeIkKTs4B5y7hkRsRNEm0ZDqnR7kkk8YovizblrSTZ6wOFSQfqg4pYy9TxViMefHlwVdtSTns/D15fEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UoPfYuzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoPfYuzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89411F000FF;
	Fri, 11 Sep 2026 08:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789114316;
	bh=Zc4Unt3bjzr3i5aaZwtRw6i8u9jZtKgz5ZUh0uu/Xbw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UoPfYuzHyyNVH+PdcLjFXukbTxLdf38NJfGRtPOPwPnDECvwlse72xehlLn1Vfr4Q
	 YxWYvKhaJWyIvH/11oBBmH0HJT3dfW4YHeG/GrGl+j+kb/pD4jVc8MTEDuaC2b40G6
	 n9uz5fr01vpJPP80/EXWQPwO5ZRBiM89WLhFPtcoaoobCYCV0mDEcqd2mB57imGX0i
	 v2Ps8E3WSIQj+SryW6vZ8cZnHYpEKOKRxf2k+xEufMdg2osDAiKyt54DTaAoh7khy6
	 nRugM7cKC7hmsR3dZPgX5sikQv3pgkIx4rh9raH9LK8nsYveaU1W46tZja+LlrElsG
	 IlKNYryvTc0tw==
Message-ID: <d6afb373-0e01-41e7-bc57-fb9cfc28600e@kernel.org>
Date: Fri, 11 Sep 2026 17:11:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: sd_zbc: reject disks with too many zones
To: ZHOU Jiaxiang <26066541r@connect.polyu.hk>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
References: <20260911041129.128280-1-26066541r@connect.polyu.hk>
 <20260911041129.128280-3-26066541r@connect.polyu.hk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260911041129.128280-3-26066541r@connect.polyu.hk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 13:11, ZHOU Jiaxiang wrote:
> sd_zbc_read_zones() computes the number of zones with 64-bit
> arithmetic and stores the result in the unsigned int nr_zones field
> of struct zoned_disk_info, silently truncating counts that exceed 32
> bits. The truncated count is later used to size per-zone resources,
> while the device may still report more zones than fit.
> 
> Reject such devices at scan time: more than 4 billion zones is not
> realistic for any medium that exists today, and accepting the
> truncated count produces inconsistent zone bookkeeping.
> 
> Signed-off-by: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
> ---
>  drivers/scsi/sd_zbc.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 56e455fb5addd..446628cb3db02 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -589,6 +589,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
>                 u8 buf[SD_BUF_SIZE])
>  {
> +       unsigned long long nr_zones64;
>         unsigned int nr_zones;

Keep the name nr_zones and drop the unsigned int nr_zones variable, it is not
needed.

>         u32 zone_blocks = 0;
>         int ret;
> @@ -620,7 +621,15 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
>         if (ret != 0)
>                 goto err;
> 
> -       nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
> +       nr_zones64 = round_up(sdkp->capacity, zone_blocks) >>
> +                    ilog2(zone_blocks);
> +       if (nr_zones64 > UINT_MAX) {
> +               sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
> +                         nr_zones64);
> +               ret = -EINVAL;
> +               goto err;
> +       }
> +       nr_zones = nr_zones64;
>         sdkp->early_zone_info.nr_zones = nr_zones;
>         sdkp->early_zone_info.zone_blocks = zone_blocks;
> 
> --
> 2.34.1
> 
> [https://www.polyu.edu.hk/emaildisclaimer/PolyU_Email_Signature-v2.jpg]
> 
> Disclaimer:
> 
> This message (including any attachments) contains confidential information intended for a specific individual and purpose. If you are not the intended recipient, you should delete this message and notify the sender and The Hong Kong Polytechnic University (the University) immediately. Any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited and may be unlawful.
> 
> The University specifically denies any responsibility for the accuracy or quality of information obtained through University E-mail Facilities. Any views and opinions expressed are only those of the author(s) and do not necessarily represent those of the University and the University accepts no liability whatsoever for any losses or damages incurred or caused to any party as a result of the use of such information.


-- 
Damien Le Moal
Western Digital Research
