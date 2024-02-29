Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2532A7A125
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709236736; cv=none; b=Pnw7cWhoRjH/HzsrpF06gPZA0vEd3pneckvjUxneYXkIN4LtWOwXzM7RFDcbsXD2O8F2Qdp1RUzcf4EGsFtmowhnL1FHQAUKLkQr8oN/DWeigwQtTY5wLQ5oInPVYIXwbnFwDh77cM/n9JhzEkg/1O36gkjdreE56wJkgqQ7ylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709236736; c=relaxed/simple;
	bh=Pc9VY/oF13+7ZoZI9f/5Jxv/D5DlCq/NWeNUDl+3B4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZD4BySFAlqy7yrUy42QJ6P4unTobOI/CsmT+hdVwFPqQ5T2qkMCuVB7Y2fsQ2xKRMU/74XDS4+tpyYkkNd7rL5d56n/RiZ8gDpAVtKkDeow1fb4Mkmf49PbkkG2lGI3B8FyiB4kY/DzH13+IEUt8kin0bX9X8/QD4JzFtYh934M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0RCQG41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0RCQG41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDD5C433F1;
	Thu, 29 Feb 2024 19:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709236735;
	bh=Pc9VY/oF13+7ZoZI9f/5Jxv/D5DlCq/NWeNUDl+3B4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H0RCQG41X9D4xsIOnc1HizX5+vaibUHXCOzSh50t4Ex1hhQhkuvn1CLJtcu6bSshS
	 jitdisDliAPwFgDYVM/PH//oJLvZapJJYP1auZS5+5nTOFnSU22k5DzMUYUTUaa3yF
	 KuARLpEiCmHzHNmHReBMtYBEFpTMP17SemV44VCx66flH9p4EDc1u92EdGqK/AGV9D
	 iakHFBU3vIWGjieoNb4svaBTdvUBTdBX58QH8LEOvMrkFx/ibHONElVENBFI9T09xL
	 LDAq3/ipSM1abqf+Vglt10FEAD+5ci8XZOwEDWmDCaFSaN0fAxlxG70xTn5kLzA5Qh
	 aPlfuQcZO3iSA==
Message-ID: <0c34b7b3-0e24-4256-b593-98675db8e3a8@kernel.org>
Date: Thu, 29 Feb 2024 11:58:54 -0800
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
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <527dfffe-5ea5-4a0c-9be4-d336e202b34b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 10:54, Bart Van Assche wrote:
> On 2/29/24 10:31, Damien Le Moal wrote:
>> Yes, but I find that a little fragile and given that rw-10 causes problems with
>> ZBC, I prefer to make it very explicit that the 10B command variants should not
>> be used.
> 
> Hi Damien,
> 
>  From commit c6463c651d7a ("sd_zbc: Force use of READ16/WRITE16"; v4.10):
> 
> -------------------------------------------------------------------------
> sd_zbc: Force use of READ16/WRITE16
> 
> Normally, sd_read_capacity sets sdp->use_16_for_rw to 1 based on the
> disk capacity so that READ16/WRITE16 are used for large drives. However,
> for a zoned disk with RC_BASIS set to 0, the capacity reported through
> READ_CAPACITY may be very small, leading to use_16_for_rw not being
> set and READ10/WRITE10 commands being used, even after the actual zoned
> disk capacity is corrected in sd_zbc_read_zones. This causes LBA offset
> overflow for accesses beyond 2TB.
> 
> As the ZBC standard makes it mandatory for ZBC drives to support
> the READ16/WRITE16 commands anyway, make sure that use_16_for_rw is set.
> -------------------------------------------------------------------------
> 
> Would this change be sufficient to fix the problems mentioned above?
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 997de4daa8c4..71f477e502e9 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1279,7 +1279,7 @@ static blk_status_t 
> sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>   	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
>   		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
>   					 protect | fua, dld);
> -	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
> +	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff) || (lba >> 32)) {

Sure, that works too, but seems useless given that we do have use_16_for_rw set.
Would clearing use_10_for_rw to 0 cause a problem for zoned UFS drives ?

>   		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
>   					 protect | fua, dld);
>   	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

