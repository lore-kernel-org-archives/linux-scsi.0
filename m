Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E7A2DFA4B;
	Fri, 18 Apr 2025 23:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017377; cv=none; b=OXiYD0Ru68TSc8zOP2kqqVyMgqhDNGkKEkfyFUHRnoIfdKM+fihfIJam9eF+lAbT8TFG6lQgc1B3DDnLiuPknsq46+kG9f7nzPEzr4NA3WsFQvr4hLge/jJggTSWvDmP+evGi3q3Bvrdak60vtEczgV0T1ySumIWb/3rYX6FG9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017377; c=relaxed/simple;
	bh=LbXBD/Wq33oDG958wUuxjS3Q9JN3n2Vn9cgrZJrIM2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLDLurbOZVwn/ERh4FZR6K6VW0ZGvSQiOYv5orn/+HC99ZATpJnc/zfy2q0uIzKPaQZmO0STxBLQTF1mLBlluRaijt86w/iuNWlLJAzk8bOI+QIUfL8v/fCC+zhT+Q+tw9I52HDpo2K594M9pwImvIP5xdTCprUa8W39AcMoJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/YOp09F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/YOp09F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6895CC4CEE2;
	Fri, 18 Apr 2025 23:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745017377;
	bh=LbXBD/Wq33oDG958wUuxjS3Q9JN3n2Vn9cgrZJrIM2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h/YOp09Fb6oMl+/NyxbyQg3wghGDi8QDLnrdGkUuT5U7J7ivc2NrngTo9t/1mTVvC
	 jurt1kKayr5W2cxXWR9q9pMIrfP1lLegVRA0NSRT8CQfEX0Z/q6m28TkUcXSblanTL
	 MzUy7o23biA2LnJmp/JNLnSIWNbYEjtF4ET05mNFVMEhgctmLC1A9UHp/niOJE9IfF
	 7eYvO//AaR4Kyj8QypnMY08FyKiWctk6zvgrNZWLzwVVhAVt0YWbmTxv4onwiwv7mU
	 9A65nAhrho4V/wFIONfWxCbWQZfDRF0A1rejUz4/E9uk7n6c2y+wIbH3tHoyRe+x/8
	 wb2cjS7afj/eQ==
Message-ID: <3f2aa3be-2b4e-4998-a1bc-7120fee8748c@kernel.org>
Date: Sat, 19 Apr 2025 08:02:55 +0900
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
 <5cf44067-4e3d-49c5-93e0-721337b0302d@kernel.org>
 <DC50C6CE-E3FF-494C-8167-4B662B03A48F@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <DC50C6CE-E3FF-494C-8167-4B662B03A48F@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/25 20:45, Niklas Cassel wrote:
> 
> 
> On 18 April 2025 11:30:35 CEST, Damien Le Moal <dlemoal@kernel.org> wrote:
>> On 4/18/25 17:40, Niklas Cassel wrote:
>>> On Fri, Apr 18, 2025 at 04:55:14PM +0900, Damien Le Moal wrote:
>>>> For devices that do not support CDL, the subpage F2h of the control mode
>>>> page 0Ah should not be supported. However, the function
>>>> ata_mselect_control_ata_feature() does not fail for a device that does
>>>> not have the ATA_DFLAG_CDL device flag set, which can lead to an invalid
>>>> SET FEATURES command (which will be failed by the device) to be issued.
>>>>
>>>> Modify ata_mselect_control_ata_feature() to return -EOPNOTSUPP if it is
>>>> executed for a device without CDL support. This error code is checked by
>>>> ata_scsi_mode_select_xlat() (through ata_mselect_control()) to fail the
>>>> MODE SELECT command immediately with an ILLEGAL REQUEST / INVALID FIELD
>>>> IN CDB asc/ascq as mandated by the SPC specifications for unsupported
>>>> mode pages.
>>>>
>>>> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>>> ---
>>>>  drivers/ata/libata-scsi.c | 11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
>>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>>> index 24e662c837e3..15661b05cb48 100644
>>>> --- a/drivers/ata/libata-scsi.c
>>>> +++ b/drivers/ata/libata-scsi.c
>>>> @@ -3896,6 +3896,15 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
>>>>  	struct ata_taskfile *tf = &qc->tf;
>>>>  	u8 cdl_action;
>>>>  
>>>> +	/*
>>>> +	 * The sub-page f2h should only be supported for devices that support
>>>> +	 * the T2A and T2B command duration limits mode pages (note here the
>>>> +	 * "should" which is what SAT-6 defines). So fail this command if the
>>>> +	 * device does not support CDL.
>>>> +	 */
>>>> +	if (!(dev->flags & ATA_DFLAG_CDL))
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>>  	/*
>>>>  	 * The first four bytes of ATA Feature Control mode page are a header,
>>>>  	 * so offsets in mpage are off by 4 compared to buf.  Same for len.
>>>> @@ -4101,6 +4110,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
>>>>  	case CONTROL_MPAGE:
>>>>  		ret = ata_mselect_control(qc, spg, p, pg_len, &fp);
>>>>  		if (ret < 0) {
>>>> +			if (ret == -EOPNOTSUPP)
>>>> +				goto invalid_fld;
>>>>  			fp += hdr_len + bd_len;
>>>>  			goto invalid_param;
>>>>  		}
>>>> -- 
>>>
>>> I would prefer if we did not merge this patch, as it is already handled in
>>> higher up in the (only) calling function:
>>> https://github.com/torvalds/linux/blob/v6.15-rc2/drivers/ata/libata-scsi.c#L2582-L2589
>>
>> This code you point to is for mode sense. This patch deals with mode select,
>> where we are not checking for the subpage support, which is wrong.
>>
> 
> I linked to the wrong line.
> 
> https://github.com/torvalds/linux/blob/v6.15-rc2/drivers/ata/libata-scsi.c#L4081
> 
> The rest of the comment is still valid.
> 
> This case that this patch tries to fix can already not happen.

You are absolutely correct ! How did I miss that :)
Sending V3 with this patch dropped.

-- 
Damien Le Moal
Western Digital Research
