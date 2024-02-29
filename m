Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8EA2576F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 22:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709246742; cv=none; b=C+tS0FUYXTJnI4GZ1aq8Vcpu7vr+ftJ3Z5qtVxZWkPlqG9TMBSg2TVAH/wJrz/BTucsngYFXwoZp9RICJywcrWuOiDzgRlTFs02A2iMj6tZHlFSXS1/Xi40J7SDMEDMeCnPevRPzbI6g/ls+SFMU9+t0jWWKbzu0kcVReGhEmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709246742; c=relaxed/simple;
	bh=SBsWzBv2vZswKTi+PGoMiTXakZNh0DciyHe+FYSda30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S0YlOK0OJc8xj/N58Z3/pxtMD5bNXRQWPay597qRiv7zvtpUZenueVyZ2JjOl6aoUqsCYpzKH3SacFufNWozvpLfYXNCOgLA36H9/JExf6FzANarH6UwS0pRD1lwiEMPwsqWbLVAptPrxSR2FwHpzvvUwpyMkJzy2jy74NPvp4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JutA5eXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JutA5eXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD31C433C7;
	Thu, 29 Feb 2024 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709246741;
	bh=SBsWzBv2vZswKTi+PGoMiTXakZNh0DciyHe+FYSda30=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JutA5eXe/OBATuTNlnPifdLm1W9zq7ZIhCqbs8tsyb/BMnafk3VfA2dPoopaVnGtX
	 xoYwyWSMbiq8mIAblax5z5sL/IMFtE+RcKpTsj7IXshZbIZJeDro0fQNrik8mfSEvZ
	 KKJIFg/pH3XekZmhdTaONWXSIMQtLgoVlu/fHTDWvLjuBpQ7NqYzQKdxemDxUxuGK8
	 oOMCdRP46Gwwdlpz5mQmKhSSOOfV1d1Ly1PdkGrcc+uCpMEtUmX2ptSllZgQq/YMtC
	 ku/ooFXhFqxabsi9/gkguWu1uKbWBW+k/bArHZwgm9W1xVfYc3Kufjw1qvxVItH848
	 eANaw8eIZFzgQ==
Message-ID: <e3d40ae6-ed41-40a0-8521-48a2797fa255@kernel.org>
Date: Thu, 29 Feb 2024 14:45:40 -0800
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
 <57fc23ee-d450-40b1-89f5-c7a85b6b158a@kernel.org>
 <fbe8bf39-4222-4b5a-8c7f-d284bc9f29fe@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <fbe8bf39-4222-4b5a-8c7f-d284bc9f29fe@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 14:39, Bart Van Assche wrote:
> On 2/29/24 14:16, Damien Le Moal wrote:
>> On 2024/02/29 14:07, Bart Van Assche wrote:
>>> --- a/drivers/scsi/sd_zbc.c
>>> +++ b/drivers/scsi/sd_zbc.c
>>> @@ -734,6 +734,8 @@ static int sd_zbc_check_capacity(struct scsi_disk
>>> *sdkp, unsigned char *buf,
>>>    					(unsigned long long)sdkp->capacity,
>>>    					(unsigned long long)max_lba + 1);
>>>    			sdkp->capacity = max_lba + 1;
>>> +			if (sdkp->capacity > 0xffffffff)
>>> +				sdkp->device->use_16_for_rw = 1;
>>
>> ZBC makes 16B RW mandatory, regardless of the device capacity. So I am not very
>> keen on playing games like this and think that it is safer to always use RW-16,
>> regardless of the device capacity. I prefer your first patch, with the added
>> "use_10_for_rw = 0;" added.
> 
> Hi Damien,
> 
> I think that we need to combine the two patches otherwise we risk
> breaking support for zoned devices that are neither ATA devices nor
> UFS devices. How about the patch below?
> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0a0f483124c3..6d55a01f0263 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -986,8 +986,15 @@ static void ata_gen_ata_sense(struct ata_queued_cmd 
> *qc)
> 
>   void ata_scsi_sdev_config(struct scsi_device *sdev)
>   {
> -	sdev->use_10_for_rw = 1;
> -	sdev->use_10_for_ms = 1;
> +	if (sdev->type == TYPE_ZBC) {
> +		/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
> +		sdev->use_16_for_rw = 1;
> +		sdev->use_10_for_rw = 0;
> +		sdev->use_16_for_sync = 1;
> +	} else {
> +		sdev->use_10_for_rw = 1;
> +		sdev->use_10_for_ms = 1;
> +	}
>   	sdev->no_write_same = 1;
> 
>   	/* Schedule policy is determined by ->qc_defer() callback and
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

While correct, I do not think that this change is needed. With the first hunk in
place, a TYPE_ZBC device will be forced to use RW-16, regardless of the device
capacity.

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

