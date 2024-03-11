Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7FB29A9
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177733; cv=none; b=iTusJuFQCYcshA0TzPNlSua90wNCm2uwWIc6D4l+30J9w7O39RHfmIz5b+y1ZSMSIJlToDZNx6LM+sdoKCyBGoyJfnKqo00p9pb9cGkN98SmbYlSTakmuWl1nkSKYoJzzQUEF/W3Khx5WQ3dX8IrZlWXe6MTLX7LgJWhviySMBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177733; c=relaxed/simple;
	bh=S4TiDT2b+IX8K1mpyw0L9+1OHltcr7R0o2OZMHLMhAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RO2OY3kqnyX+PkqkBv4VZpO7rF3h2FJharAlwtPdSbge5fMruPzfPw/VgNA7M5pX1EaWxqL5q//BvfDwXwfp+b+Th2egbhILV4DWKsbXV1WGWG0EKRzG6L5g/XvgjocFpA1FNTFGhM6sat+Dxc1h0iS4KJ6MlCab8c4qteLtx+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VIWN/XY9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VIWN/XY9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Ttk9H1SBczlgVnY;
	Mon, 11 Mar 2024 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710177728; x=1712769729; bh=Cezru4N01E7l8y7JjwVw7oci
	0+4h0eq4BC3yuurHt8c=; b=VIWN/XY9w+2vdInyB8zw92JJzao3qYQd0YQ+xrGn
	WNaGtWgOAYQwmA1A6p508br5DMp4yq/oZij5oDJURFXij0fT2Q5WrMF39NvWla/V
	997qpyhxI7DEIEphJraOtpc215KqptU56jUpoHvEuTsRubTXLJyN21Fd1yV0plb+
	57RlQLQZV9gbwGoGLcwuyzbZ29mN6legfYM2bcjomrwScx+qoOrKCbWfwP3EPdA9
	lFAH3hADKMKYNYyiei5idkRewSo042MUeIsnl9VmSgNsoP/b57RrZAjqzr8ombw6
	1zK6j7mua2N1MjOeIoNZh+l8j2wiy+Yujc5mMwXrHSYXhQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id trty6bT7BU6R; Mon, 11 Mar 2024 17:22:08 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Ttk9C50Q9zlgVnW;
	Mon, 11 Mar 2024 17:22:07 +0000 (UTC)
Message-ID: <b62b8f7d-abb9-470c-a042-c0710710da96@acm.org>
Date: Mon, 11 Mar 2024 10:22:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] scsi: scsi_debug: Factor out initialization of
 size parameters
Content-Language: en-US
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>
References: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
 <20240311065427.3006023-2-shinichiro.kawasaki@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240311065427.3006023-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/24 23:54, Shin'ichiro Kawasaki wrote:
> As the preparation for the dev_size_mb parameter changes through sysfs,
> factor out the initialization of parameters affected by the dev_size_mb
> changes.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   drivers/scsi/scsi_debug.c | 52 ++++++++++++++++++++++++---------------
>   1 file changed, 32 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d03d66f11493..c6b32f07a82c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -7234,10 +7234,39 @@ ATTRIBUTE_GROUPS(sdebug_drv);
>   
>   static struct device *pseudo_primary;
>   
> +/*
> + * Calculate size related parameters from sdebug_dev_zize_mb and
> + * sdebug_sector_size.
> + */
> +static void scsi_debug_init_size_parameters(void)
> +{
> +	unsigned long sz;
> +
> +	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
> +	sdebug_store_sectors = sz / sdebug_sector_size;
> +	sdebug_capacity = get_sdebug_capacity();
> +
> +	/* play around with geometry, don't waste too much on track 0 */
> +	sdebug_heads = 8;
> +	sdebug_sectors_per = 32;
> +	if (sdebug_dev_size_mb >= 256)
> +		sdebug_heads = 64;
> +	else if (sdebug_dev_size_mb >= 16)
> +		sdebug_heads = 32;
> +	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
> +		(sdebug_sectors_per * sdebug_heads);
> +	if (sdebug_cylinders_per >= 1024) {
> +		/* other LLDs do this; implies >= 1GB ram disk ... */
> +		sdebug_heads = 255;
> +		sdebug_sectors_per = 63;
> +		sdebug_cylinders_per = (unsigned long)sdebug_capacity /
> +			(sdebug_sectors_per * sdebug_heads);
> +	}
> +}
> +
>   static int __init scsi_debug_init(void)
>   {
>   	bool want_store = (sdebug_fake_rw == 0);
> -	unsigned long sz;
>   	int k, ret, hosts_to_add;
>   	int idx = -1;
>   
> @@ -7369,26 +7398,9 @@ static int __init scsi_debug_init(void)
>   		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
>   	if (sdebug_dev_size_mb < 1)
>   		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
> -	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
> -	sdebug_store_sectors = sz / sdebug_sector_size;
> -	sdebug_capacity = get_sdebug_capacity();
>   
> -	/* play around with geometry, don't waste too much on track 0 */
> -	sdebug_heads = 8;
> -	sdebug_sectors_per = 32;
> -	if (sdebug_dev_size_mb >= 256)
> -		sdebug_heads = 64;
> -	else if (sdebug_dev_size_mb >= 16)
> -		sdebug_heads = 32;
> -	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
> -			       (sdebug_sectors_per * sdebug_heads);
> -	if (sdebug_cylinders_per >= 1024) {
> -		/* other LLDs do this; implies >= 1GB ram disk ... */
> -		sdebug_heads = 255;
> -		sdebug_sectors_per = 63;
> -		sdebug_cylinders_per = (unsigned long)sdebug_capacity /
> -			       (sdebug_sectors_per * sdebug_heads);
> -	}
> +	scsi_debug_init_size_parameters();
> +
>   	if (scsi_debug_lbp()) {
>   		sdebug_unmap_max_blocks =
>   			clamp(sdebug_unmap_max_blocks, 0U, 0xffffffffU);

Please remove sdebug_heads, sdebug_cylinders_per and sdebug_sectors_per
instead of making this change. While these values are reported in a
MODE SENSE response, I don't think that it is valuable to keep support
for heads, cylinders and sectors in the scsi_debug driver.

Thanks,

Bart.
