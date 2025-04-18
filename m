Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60F91D86D6;
	Fri, 18 Apr 2025 07:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744960633; cv=none; b=Pl894Qd5AdAzzr713AAOX/3gA36WlJIMwJ+Zy7mFFjmdJPJC9vmle3lDwptBcK8ofwH7bjhKdID03eTc1uB96VeO5MmOVleaXQ9CC5+ZBQIFytrjcUXOxOw6NK0swB8PkDAVQ7vfKZix0ly+5qJVcujWqmDwnjFFu9DUn62l+cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744960633; c=relaxed/simple;
	bh=QY69x+XFUNdroILlJzsO6q4icYZsp3BlwERRcUqN78M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nl/951onc/V7fhHxyhuNxoAU8gimydGNiGetAc0JNCyqxjDOLZ/PwlH6hywN8Nma0JK6a6GSVln+vL3Ufqi8rUEXZjE3djwe7wS0xndCqWKHADXurWrPQZJxpVizIA1xzr9jl1B9+v1hIzGIP0cDe0zEVuY8VNARPrH6Dh20L1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pI8PcooA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pI8PcooA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0984C4CEE2;
	Fri, 18 Apr 2025 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744960632;
	bh=QY69x+XFUNdroILlJzsO6q4icYZsp3BlwERRcUqN78M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pI8PcooAfIkxzjL1WGcRU78782kzuftY6pyYaiXgOA1mqwGl/ZwM4vxY7wANlpl5B
	 fPw9I2CJgywQci0zZxfC9X+w8iU/9qWyaXvVekHx4uiEVu0kf5FOoA8AwhzuSUn8XX
	 QQB+IoRveJhXCzBcpa0lc8oI4y3bLwlNjNpPhSzMhLm80rZaC7+3+tEIyI9nnG9ym6
	 vrvaH+GzObcJLdVEyZj37x815wkYE1wtquSmJcZwIeIyE66NtpDJR/gFYAbttKvMLU
	 xMyAETWoqY9EmIY2Yxkuz1ncl9TTnhMNLaUPS49J1kNu39vhRMYSyvy6BfXVNELLYy
	 G6weC1hGexaBg==
Message-ID: <ff7cb666-eeb2-421f-935f-b3fbda66ace3@kernel.org>
Date: Fri, 18 Apr 2025 16:17:10 +0900
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

In fact, MODE SENSE accesses to the f2h subpage of the control page is already
checked in ata_scsiop_mode_sense() and failed if the device does not have CDL.
So the check here is indeed useless. I dropped it.

> 
> ata_mselect_control_ata_feature() only checks the ATA_DFLAG_CDL_ENABLED flag.

I added a patch to check ATA_DFLAG_CDL for this function as we were not failing
the mode select command for devices that do not support CDL.

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
