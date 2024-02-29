Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AF36D51B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244996; cv=none; b=rswBCfuHqsiybZAW2HPE+/e0jtz4dV8l1EZQCZYmwvmZUq5bz49nD1h3t9VFMKe2tHYEhz14RNfQTfOsJlJcV0UqKJ0OMn51h3LNWw2R7uSMbAzbovHSJOefypIgTkWFw5IPn9vdBhcjtM+Vy2Y5wEFIkGVDf+vKYswar5buBlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244996; c=relaxed/simple;
	bh=eYi8+RSy2mqigUK0OBGfImlIcljRgHgSPK7p6CvaPVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvENPth9Rahdv34Meh59GvWDK7hz1z7yLMUyfdJdp9iq4ImoRHcexVdiEMYG6L5bKb6dh62uMPhBJiGpi4UROQGjG+V3v5MLXCQCvFUxWeE6OIXkqrin9fYzVu9TDkjKWPHCiKGJnVIs7Tr5mX0TLTspPZDzLW1KmTcBsJ0DRYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRfe06/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRfe06/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39D4C433C7;
	Thu, 29 Feb 2024 22:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709244996;
	bh=eYi8+RSy2mqigUK0OBGfImlIcljRgHgSPK7p6CvaPVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RRfe06/85yKQUtvhQAYWWSqfVME7Dy1igLqwf4NM1MwSmz3bzVJyyfd5pFSgkH3vZ
	 PXpwDu+sKPTAi4xpU+tYzPaxpf5328zIDG8H6q/sa3LYihIzrWBcpJfod23qYYdXPH
	 aXAm7nwPVwaBCMdo/Iaf7Ap8QaYMWC2kZEOGbEAIJ/jCGOwNAtXJuvhzlNfJBXBhER
	 pRknKh4ChJh+wRdyJUim2kovLIywYO/3fGWq6pQtoZqXhI7cW6OR1VSKurxHn2kYPj
	 P8rbNsfXRykowriO/lx9NQoi68dGNNpqteppbg4uIBL/p5I8WnKBvOj8cJRYG7u3+G
	 g0btu7qSeXGIA==
Message-ID: <57fc23ee-d450-40b1-89f5-c7a85b6b158a@kernel.org>
Date: Thu, 29 Feb 2024 14:16:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172333.2494378-1-bvanassche@acm.org>
 <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
 <eec0d0d1-9fe3-457f-8150-e5cbe19a9f23@acm.org>
 <ecbc260c-1202-4b0f-bcc9-4886c85bf43c@kernel.org>
 <527dfffe-5ea5-4a0c-9be4-d336e202b34b@acm.org>
 <0c34b7b3-0e24-4256-b593-98675db8e3a8@kernel.org>
 <0004135e-56e9-4722-bc6a-ddb293274d39@acm.org>
 <cd13bc17-f930-471d-9b69-81831205db64@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cd13bc17-f930-471d-9b69-81831205db64@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 14:07, Bart Van Assche wrote:
> On 2/29/24 12:05, Bart Van Assche wrote:
>> [ ... ]
> 
> Thinking further about this, wouldn't this be a better solution
> (untested)?
> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 997de4daa8c4..8d3020486095 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2798,6 +2798,13 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned 
> char *buffer)
>   				      sdkp->physical_block_size);
>   	sdkp->device->sector_size = sector_size;
> 
> +	/*
> +	 * For zoned block devices, if RC BASIS = 1 in the READ CAPACITY
> +	 * response, sdkp->capacity does not represent the device capacity but
> +	 * the highest LBA of the conventional zones at the start of the LBA
> +	 * space. sd_zbc_check_capacity() sets sdkp->capacity correctly for
> +	 * zoned devices.
> +	 */
>   	if (sdkp->capacity > 0xffffffff)
>   		sdp->use_16_for_rw = 1;
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 26af5ab7d7c1..d4d6b3056410 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -734,6 +734,8 @@ static int sd_zbc_check_capacity(struct scsi_disk 
> *sdkp, unsigned char *buf,
>   					(unsigned long long)sdkp->capacity,
>   					(unsigned long long)max_lba + 1);
>   			sdkp->capacity = max_lba + 1;
> +			if (sdkp->capacity > 0xffffffff)
> +				sdkp->device->use_16_for_rw = 1;

ZBC makes 16B RW mandatory, regardless of the device capacity. So I am not very
keen on playing games like this and think that it is safer to always use RW-16,
regardless of the device capacity. I prefer your first patch, with the added
"use_10_for_rw = 0;" added.

>   		}
>   	}
> 
> @@ -924,11 +926,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 
> buf[SD_BUF_SIZE])
>   		return 0;
>   	}
> 
> -	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
> -	sdkp->device->use_16_for_rw = 1;
> -	sdkp->device->use_10_for_rw = 0;
> -	sdkp->device->use_16_for_sync = 1;
> -
>   	/* Check zoned block device characteristics (unconstrained reads) */
>   	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
>   	if (ret)
> 

-- 
Damien Le Moal
Western Digital Research

