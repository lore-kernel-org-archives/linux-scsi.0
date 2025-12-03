Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F8718B0A;
	Wed,  3 Dec 2025 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764721831; cv=none; b=NbA0Mn+2R0xP8lpYcScCZBeqqNvRFOxi9E/ZBY0ORYAlZb+eGy9BAIOoB3CiO3JImlcEnsehmfbxpF8OK39fxUoZioOynHo5U+Y+oB1wrac2SDbu5/IsMRoyPl82bSFE11JQx9P/jpAYqF1eyYZSKrPk+0D/z2kTNVCD3hCGHSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764721831; c=relaxed/simple;
	bh=6qr+KaXuveOuOFRyUZ/sXpXDiL+AemK+ZwynWgCTSrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VFWvQjd6Cd9BOLLXdcjbMHuJFT6c/simqfHN6NOgMqfHGJLx9dyzBs0hXPmArWS3SPUFMnsxEC06nq/D2kKQhOfQoq3SEg9ho/pWTuQxVaDHyBN3GSaXIcmatQcU/Ts9kye4AyeOQlp9ZEpn3MJ8gKzZ1BEFXS7tqmoBpjJsIOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2iP3RW8o; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2iP3RW8o"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dLdpF1cLdzlffvd;
	Wed,  3 Dec 2025 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764721827; x=1767313828; bh=L1ilmufGs/gJtga2/nV2TCmS
	iLKmuYwM/9zSgsaIA8M=; b=2iP3RW8oUH9RpW2CwmWC86nQpsdJSn/FX2uxbQzq
	WUZIW013XaHLkQ7uWpt4JL6dOqk++Gpq8praBIoUi7eCvUtOWSX/4atcYTnMKrp5
	DwqsHUytkmQuNjvpPsTP63qQTtLWnhaZolOwZhsldqMjVVmN+cS89wdAeY+951Xu
	xY6dpCTsUhCwKKfKlDBN7Kd6MPJsu2B1PlSIpUpxo3MfVznpzYHgymEQXreuaFBh
	lXvIbKsaIUkoengNpm+Gz+gcAHSCZPx5DERDks3yD1JS344IrErKaU61lxVJypPk
	N8tuYqqIck/I/pvZX4rfYSjtnEBgY3oDXI/u5Ky6U+0Eiw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o8jAZpbZkfWH; Wed,  3 Dec 2025 00:30:27 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dLdp42KZ0zlfgf6;
	Wed,  3 Dec 2025 00:30:19 +0000 (UTC)
Message-ID: <401d8de5-63a8-461a-bc54-5b2986779a88@acm.org>
Date: Tue, 2 Dec 2025 14:30:19 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: enable sector_size > PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, kernel@pankajraghav.com,
 Swarna Prabhu <s.prabhu@samsung.com>
References: <20251202021522.188419-1-sw.prabhu6@gmail.com>
 <20251202021522.188419-4-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251202021522.188419-4-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 4:15 PM, sw.prabhu6@gmail.com wrote:
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b2ab97be5db3..b5839e62d3bb 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -8459,13 +8459,8 @@ static int __init scsi_debug_init(void)
>   	} else if (sdebug_ndelay > 0)
>   		sdebug_jdelay = JDELAY_OVERRIDDEN;
>   
> -	switch (sdebug_sector_size) {
> -	case  512:
> -	case 1024:
> -	case 2048:
> -	case 4096:
> -		break;
> -	default:
> +	if (sdebug_sector_size < 512 || sdebug_sector_size > BLK_MAX_BLOCK_SIZE ||
> +	    !is_power_of_2(sdebug_sector_size)) {
>   		pr_err("invalid sector_size %d\n", sdebug_sector_size);
>   		return -EINVAL;
>   	}
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c3502fcba1bb..f2eac79d7263 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2889,10 +2889,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
>   			  "assuming 512.\n");
>   	}
>   
> -	if (sector_size != 512 &&
> -	    sector_size != 1024 &&
> -	    sector_size != 2048 &&
> -	    sector_size != 4096) {
> +	if (sector_size < 512 || sector_size > BLK_MAX_BLOCK_SIZE ||
> +	    !is_power_of_2(sector_size)) {
>   		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
>   			  sector_size);
>   		/*

Please reorganize this patch series into one patch for the scsi_debug
driver and another patch for the sd driver.

Thanks,

Bart.
