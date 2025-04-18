Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7001C5485;
	Fri, 18 Apr 2025 05:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744954802; cv=none; b=lnETLLOJ/0MwfEDSPZi7w9d8AMhiwuXy1rFrqp4VoeAcfL+aj78CTo3fsKp1vDzWqTEMNljoW7ktz+GWHp2rHT7ZeBHSW9gJvOF6LH7VPuFCiGMlqEJZO/3zums8pNXQn9d66DCNn9IHkcuPQLFW76qTzPvBJBO4JVl3uVcpkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744954802; c=relaxed/simple;
	bh=xXdAX38nqDnPAIBIXh/Qg/ZdEBA5X2yVVJ/FqSg+1xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7zxGCeBtsudoaLdt2ja6fp+DeJI3OGKWHT5u1MMSWWQZAJ/cN5idxDVkwkvJ3rReKLnNu76Q5riPq8a9FTK8YGCOrdDIgDPyq+ML9vERIdJkNlt6pVcFXgwkxalnrrLECkHmjuBtTEEZlaJmJwiixcXm0DlmtXNuI2qFvXS8L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tksuFZrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tksuFZrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AAFC4CEE2;
	Fri, 18 Apr 2025 05:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744954801;
	bh=xXdAX38nqDnPAIBIXh/Qg/ZdEBA5X2yVVJ/FqSg+1xs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tksuFZrD9pR0FB5FX7BvE/zN3ZOoKKd7fbvmgCG8JUxfzKmM7jt0lqH3rnofwbBv2
	 kCzjSV4JPJXWFRmfKB8hEwD7ZxJq4IRNUR/nTvlnHiZlaUzWbQj2AOiderusp+JI/X
	 YEvDxa9J7HmHHW8xTDIbsiHomkQrR56/3Ekwfb9GrxVuiGTERdX2jfi+B0hff+X8MF
	 1tPbhjytBp12HJEV2Mr7lK3ViKX+UpHwz12PLQvB5Oq79tm/Zc5n55ZBHgcc9sKIt0
	 XCOh/mBe7WptFkJ7gPyyEgjuSVQX8Jxt6bVORUd+qEdJ7yq7JjOT+vkrTLIZruvHnH
	 g6JZEBXcqMsaw==
Message-ID: <414f4b93-1ccb-4b3d-a47e-c2cb6ac55b8a@kernel.org>
Date: Fri, 18 Apr 2025 14:39:59 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ata: libata-scsi: Fix
 ata_msense_control_ata_feature()
To: Igor Pylypiv <ipylypiv@google.com>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-2-dlemoal@kernel.org> <aAGTwMfhPPOBYrnf@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aAGTwMfhPPOBYrnf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/25 08:50, Igor Pylypiv wrote:
> On Wed, Apr 16, 2025 at 05:42:36PM +0900, Damien Le Moal wrote:
>> For the ATA features subpage of the control mode page, the T10 SAT-6
>> specifications state that:
>>
>> For a MODE SENSE command, the SATL shall return the CDL_CTRL field value
>> that was last set by an application client.
>>
>> However, the function ata_msense_control_ata_feature() always sets the
>> CDL_CTRL field to the 0x02 value to indicate support for the CDL T2A and
>> T2B pages. This is thus incorrect and the value 0x02 must be reported
>> only after the user enables the CDL feature, which is indicated with the
>> ATA_DFLAG_CDL_ENABLED device flag. When this flag is not set, the
>> CDL_CTRL field of the ATA feature subpage of the control mode page must
>> report a value of 0x00.
>>
>> Fix ata_msense_control_ata_feature() to report the correct values for
>> the CDL_CTRL field, according to the enable/disable state of the device
>> CDL feature.
>>
>> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
> 
>> ---
>>  drivers/ata/libata-scsi.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 2796c0da8257..e6c652b8a541 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -2453,8 +2453,9 @@ static unsigned int ata_msense_control_ata_feature(struct ata_device *dev,
>>  	 */
>>  	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
>>  
>> -	if (dev->flags & ATA_DFLAG_CDL)
>> -		buf[4] = 0x02; /* Support T2A and T2B pages */
>> +	if ((dev->flags & ATA_DFLAG_CDL) &&
> 
> Do we need to check the ATA_DFLAG_CDL flag? If ATA_DFLAG_CDL_ENABLED is set
> then ATA_DFLAG_CDL must be set as well?

Yes, we can remove it. It does not hurt though.

> ata_mselect_control_ata_feature() only checks the ATA_DFLAG_CDL_ENABLED flag.

Indeed, but that actually is wrong I think since we should not attempt to issue
the SET FEATURES command if the drive does not support CDL. This will not happen
for a control initiated through sysfs, but this code also handles user
passtrhough commands. I will add a patch to correct that.

> 
>> +	    (dev->flags & ATA_DFLAG_CDL_ENABLED))
>> +		buf[4] = 0x02; /* T2A and T2B pages enabled */
>>  	else
>>  		buf[4] = 0;
>>  
>> -- 
>> 2.49.0
>>
>>
> 
> Thanks,
> Igor


-- 
Damien Le Moal
Western Digital Research
