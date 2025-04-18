Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966EA1E49F;
	Fri, 18 Apr 2025 09:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744968637; cv=none; b=SjrX13RgYI5F2q7IF7f8yP12oViMZepc90dOhchrlMo9AqhCV0fmisPg52GpfFWLMBoCxGsmF/zZleoqqcISLzr2F1Yd0BxNtuhI+nIACI3i8cT9DS1oR5EhHElF2eLoMtGZIqXcqHLmasywO5AE9wveqI2aKmj/PW61GBRfdC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744968637; c=relaxed/simple;
	bh=SSP8SpkYC8WE/VH5njjVcGegX3g9A9/8UfvJlaTI2l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOolT1MwK2TlZD38eeIpSbezyjg2kiR0bBgkru8FaJ2IJ/UIZ0n5dNvwR5Y1mpH74+Va/GIGdntsBcjezMYZYLj46HjoDhWPWMtMqe0iIkq3pu2BDJvpZMrs0mDJLxsRwA6iuPG5wB6mSV5GIPOQbS2EyJD2VC+L+cdZP1hsDdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p22JJ5Kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p22JJ5Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7324EC4CEE2;
	Fri, 18 Apr 2025 09:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744968637;
	bh=SSP8SpkYC8WE/VH5njjVcGegX3g9A9/8UfvJlaTI2l4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p22JJ5KxltrcGEHIow5KwY6Yg6eGGGnCvrI7uRquYfeYZJA4UFbDJdW37U+pTyi3D
	 dkYu7feMcNS2ev7V6A8ANGmQJGiAEjg+t79Zh6ioNYrPf6vtoMZl1BJRs0DYfeqsdy
	 T+SZf1u9v7RqMtg5fZisOVPuSoTnPRpCMIIT59RqV25A8YxqpfQR3FzmcbOFzeHnTC
	 7HXAdqobBR+heB1A7k+jYO6Bqs5kMCpZ2+iUEmNmGEj+ICRlkS0ETVEbXDtFj180aa
	 rnKW3wgKHEImLlQkCxn5GIAtHQSU1Wil3DDK5M50iyW9G3nfl0sqiiJjdC5TcuqkkJ
	 fn/GK3dxr2wFQ==
Message-ID: <5cf44067-4e3d-49c5-93e0-721337b0302d@kernel.org>
Date: Fri, 18 Apr 2025 18:30:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] ata: libata-scsi: Fail MODE SELECT for unsupported
 mode pages
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250418075517.369098-1-dlemoal@kernel.org>
 <20250418075517.369098-3-dlemoal@kernel.org> <aAIQG2PpFMZeRwUx@ryzen>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aAIQG2PpFMZeRwUx@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/25 17:40, Niklas Cassel wrote:
> On Fri, Apr 18, 2025 at 04:55:14PM +0900, Damien Le Moal wrote:
>> For devices that do not support CDL, the subpage F2h of the control mode
>> page 0Ah should not be supported. However, the function
>> ata_mselect_control_ata_feature() does not fail for a device that does
>> not have the ATA_DFLAG_CDL device flag set, which can lead to an invalid
>> SET FEATURES command (which will be failed by the device) to be issued.
>>
>> Modify ata_mselect_control_ata_feature() to return -EOPNOTSUPP if it is
>> executed for a device without CDL support. This error code is checked by
>> ata_scsi_mode_select_xlat() (through ata_mselect_control()) to fail the
>> MODE SELECT command immediately with an ILLEGAL REQUEST / INVALID FIELD
>> IN CDB asc/ascq as mandated by the SPC specifications for unsupported
>> mode pages.
>>
>> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  drivers/ata/libata-scsi.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 24e662c837e3..15661b05cb48 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -3896,6 +3896,15 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
>>  	struct ata_taskfile *tf = &qc->tf;
>>  	u8 cdl_action;
>>  
>> +	/*
>> +	 * The sub-page f2h should only be supported for devices that support
>> +	 * the T2A and T2B command duration limits mode pages (note here the
>> +	 * "should" which is what SAT-6 defines). So fail this command if the
>> +	 * device does not support CDL.
>> +	 */
>> +	if (!(dev->flags & ATA_DFLAG_CDL))
>> +		return -EOPNOTSUPP;
>> +
>>  	/*
>>  	 * The first four bytes of ATA Feature Control mode page are a header,
>>  	 * so offsets in mpage are off by 4 compared to buf.  Same for len.
>> @@ -4101,6 +4110,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
>>  	case CONTROL_MPAGE:
>>  		ret = ata_mselect_control(qc, spg, p, pg_len, &fp);
>>  		if (ret < 0) {
>> +			if (ret == -EOPNOTSUPP)
>> +				goto invalid_fld;
>>  			fp += hdr_len + bd_len;
>>  			goto invalid_param;
>>  		}
>> -- 
> 
> I would prefer if we did not merge this patch, as it is already handled in
> higher up in the (only) calling function:
> https://github.com/torvalds/linux/blob/v6.15-rc2/drivers/ata/libata-scsi.c#L2582-L2589

This code you point to is for mode sense. This patch deals with mode select,
where we are not checking for the subpage support, which is wrong.

> 
> We only break if "dev->flags & ATA_DFLAG_CDL && pg == CONTROL_MPAGE"
> 
> if this expression is false, we do a fallthrough,
> which means fp = 3; goto invalid_fld;
> 
> 
> Kind regards,
> Niklas


-- 
Damien Le Moal
Western Digital Research
