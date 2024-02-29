Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBEF70AC9
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709227748; cv=none; b=NPtym4diuJlaJxivGm/4Gv6QcVLVlm2HyHmDF8Uvl/6mRsjh2FIvxKoZZzCSwV41LoaISxp7Zx0HsJsToTwhUTcSjs+wCCgWuKO3stujiA9GLYg1vl5Cdhxbl+zgJg0Uxb7pwKs/34guhD61UfQyuz9Kx7OJ9NuyRtN9DhfC5Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709227748; c=relaxed/simple;
	bh=m5LOIGRNFvqEI8+CIU+11EMGAEbY9KGIFYxc0qfpjNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSQtCWRX0InkmKSV+DkHhiS/TMrsDutQ52jpX9DU6X3TYz8OFj6PpSKoYMp/KFXJoz7x29xbjhy6tCKXktegRPaFuLW0ii5plV5QAEbuO8ehx+z906bC6yKSi9wRdDCnniadeBAh1jurGfgCRqYJwBYdoECCjqZBUl/eACfuFXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzF2m9Va; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzF2m9Va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C0DC433C7;
	Thu, 29 Feb 2024 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709227748;
	bh=m5LOIGRNFvqEI8+CIU+11EMGAEbY9KGIFYxc0qfpjNg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mzF2m9VaQAVsgM4qOTUYDlFj982UxqpyQwABr1keWZUCb+X9iEbzpaKlixb0cs1QV
	 DDj5l9Ej/yLfm1gYUYMfREiJ06WP6IONp7mvfbNa7DRGOtIX2Z53jtgKuWBGA9bUuh
	 oAZHeSmp4xokRzevQuE1DjCboQiQnzdCf58o0HQC4+mB0HtnFlZ4KQdbgNBNEvcjgJ
	 TxsMaTC8GSeB3S9sgPoIL9IUBAyXng4l55kSssKVMQpGsPMo23FnhqgIoSyJVxfDmQ
	 J3mqpxcTWkS3bkL2wc9K/mnM1qf0cXu5GiTQdEGWhBAYFHcecGfnHFkhKwrpiig87q
	 8CXqAZ0HsI+hQ==
Message-ID: <d28c3a75-0a90-4720-a510-7e6847d76f8b@kernel.org>
Date: Thu, 29 Feb 2024 09:29:07 -0800
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
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240229172333.2494378-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 9:23, Bart Van Assche wrote:
> READ(10) and WRITE(10) are sufficient for zoned UFS devices. UFS device
> manufacturers prefer to minimize the size of their firmware and hence
> also the number of SCSI commands that are supported. Hence this patch
> that switches from READ(16)/WRITE(16)/SYNCHRONIZE CACHE(16) to READ(10)/
> WRITE(10)/SYNCHRONIZE CACHE(10) for zoned UFS devices. The 16-byte
> commands are still used for zoned devices with more than 2**32 logical
> blocks because of the following code in sd_read_capacity():
> 
> 	if (sdkp->capacity > 0xffffffff)
> 		sdp->use_16_for_rw = 1;
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ata/libata-scsi.c | 10 ++++++++--
>  drivers/scsi/sd_zbc.c     |  5 -----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0a0f483124c3..a196dce4bbc3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -986,8 +986,14 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
>  
>  void ata_scsi_sdev_config(struct scsi_device *sdev)
>  {
> -	sdev->use_10_for_rw = 1;
> -	sdev->use_10_for_ms = 1;
> +	if (sdev->type == TYPE_ZBC) {
> +		/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
> +		sdev->use_16_for_rw = 1;
> +		sdev->use_16_for_sync = 1;

scsi_add_lun() sets use_10_for_rw to "1" so can we clear it to "0" here again
like was done in the sd_zbc.c hunk below that you removed ?

> +	} else {
> +		sdev->use_10_for_rw = 1;
> +		sdev->use_10_for_ms = 1;
> +	}
>  	sdev->no_write_same = 1;
>  
>  	/* Schedule policy is determined by ->qc_defer() callback and
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 26af5ab7d7c1..bcdb21706d3f 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -924,11 +924,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  		return 0;
>  	}
>  
> -	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
> -	sdkp->device->use_16_for_rw = 1;
> -	sdkp->device->use_10_for_rw = 0;
> -	sdkp->device->use_16_for_sync = 1;
> -
>  	/* Check zoned block device characteristics (unconstrained reads) */
>  	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
>  	if (ret)

-- 
Damien Le Moal
Western Digital Research

