Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F78374A06;
	Wed,  8 Jul 2026 03:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783481971; cv=none; b=E4iTqKNDPnXU/GQYlf8ZY0Vi0UpBXSII0VB7JbDtTn+yyws/QzPgt4bTu4+q5lOWJZ35E36HGAVv+e1UGyaJ81w6dnLjDw7IeOVBvMm4lXh7mEHXOAlKFhd94/0r/3JOwin+Biqeewa2KLHmZEg6Q0OKBZeUtcjnF33IGvp0bSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783481971; c=relaxed/simple;
	bh=Kt8tZ/4wO1dXg76E5TlyJ+51bSNyWj52gERhlSa4tuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqWdyFOBlT8ukyNsNDSlxWbULIcxyTF7Zu1wM/sFIklDa/K/2NrkpaWQAldpGPGWC47i+H/Da3RKNTGrdryUuzTc7ps4Nd1ZROECeDlkqLHdZXsjqYBr1c9QbWPWhK5yjXN8l8W4GDyWOel/vrCUt32ZmIhjKGTAUunAGpEVhzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCNT8SF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCNT8SF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E9F1F000E9;
	Wed,  8 Jul 2026 03:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783481970;
	bh=BKcHYxFYEx8dif9aiXtS0RTXpU5/aPBrv6j4taiR2Pw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XCNT8SF9KAS2YcXsJorjnW/RZlERe/VXLqeJG8g/erxtMQqnQ00stY0xrVUyxdsgT
	 mh9oiIM8L9HULwDH0Pyk+s4FaM+VcrU5fp5IacLBOQfGbxF/zJKVlnDDBbVCqGgX6t
	 6LnDSkk4wveMdQfB5TDtipjsDmrA8Pp8ZGR3Qt90VQyZXOfPjoF9/VzBmXaXOiB0GL
	 bEEJehC0SbGsYaI5C0CFRlNfSyD3QYz3jJd/k+joZSnCFJqq8Jd63vT2AFDJbugQnp
	 wLQQnklLO3uqKc676VIqV3nKaI/yk90r2D6TL+3gVsOCPR8WjnhUws/YEMLL2eAXCv
	 5xtrNUTC2H5VA==
Message-ID: <a19a428e-9e66-42ea-b95c-f4954b67ac87@kernel.org>
Date: Wed, 8 Jul 2026 12:39:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: fix error handling for sd_large_pool_create()
 call failure
To: John Garry <john.garry@linux.dev>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: p.raghav@samsung.com, sw.prabhu6@gmail.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
References: <20260707105555.1382237-1-john.garry@linux.dev>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260707105555.1382237-1-john.garry@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/7/26 19:55, John Garry wrote:
> If the sd_probe() -> sd_large_pool_create() call fails, then we incorrectly
> unwind the probe actions.
> 
> Currently for the sd_large_pool_create() failure we do no undo the
> device_add() call.
> 
> Fix this by mimicking the handling of device_add_disk() failure, in calling
> device_unregister() and put_disk(). The device_unregister() call will
> result in scsi_disk_release() being called, which unwinds many actions in
> sd_probe().
> 
> Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Xiuwei posted a series fixing this already:

https://lore.kernel.org/all/20260707030333.22245-1-yangxiuwei@kylinos.cn/

> ---
> I do wonder if it is simpler to always create this pool when we can
> support LBS. We only create a min of two elements in the pool, so
> hardly large.
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f33334..d18693d390b2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
>  	if (sdp->sector_size > PAGE_SIZE) {
>  		if (sd_large_pool_create()) {
>  			error = -ENOMEM;
> -			goto out_free_index;
> +			device_unregister(&sdkp->disk_dev);
> +			put_disk(gd);
> +			goto out;
>  		}
>  	}
>  


-- 
Damien Le Moal
Western Digital Research
