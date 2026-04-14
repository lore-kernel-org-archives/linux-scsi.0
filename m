Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D6437D110;
	Tue, 14 Apr 2026 07:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776151279; cv=none; b=RG/eXAc9qkKUEyclGNYtaX4LE37YlG3AiaQLuSg7WfsAnK1rMqmORQF/B2Y+TlBXKONboTS+SK6xokQN8znO1ZE73ojM+YVyzoOKZDo0vvQR4ejlRnqRbxiMBcc6YxyuNQ4xEvwE9ZmOZ6OIeBds8pN+Hgvawav7MLWdXJW5h/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776151279; c=relaxed/simple;
	bh=zQdC8VDI7SwlbhdZAtFV+shNPnBxTuWnCfpu1A+w7I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XiTOmy4cXNtPn5w8qW/jOraL9lTh7SvlT2bsVmNrkreEUInKy6X3xdTQgkWuz+LsNeUJ5zwa/0mt2FATDztjE6PJ6hadFPAWp0LQEY6FbaFD5+OsYfb5QTGzxFexEt13/Fqk6PywRz/bBxdllxLsX6gvUkVsMS7eVCcW3NKIDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9ZTeI6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9ZTeI6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AABCC19425;
	Tue, 14 Apr 2026 07:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776151279;
	bh=zQdC8VDI7SwlbhdZAtFV+shNPnBxTuWnCfpu1A+w7I4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z9ZTeI6T2B4lkLCanqccYV4697jJ9qO3oYvSaW8i2QE4gDOqwJrkdaEswQH6dQRll
	 jnqwMmeZtJyIf1UU+Y30HvdzSR7CYILID/HlR4uFZbnJkUHABXCTvEWmGtLs1QWR4B
	 FV+25HlfoWQp9ojCVOkPg8WYTlKW3kzceKKfhKIjbS1ScDYvzXPKyEAxj0xc+ILinW
	 VwfyfInwf2270UFIRRvhNA2KUK2kMnX3oVegttzKs0uq3ynfGJ4LBa13fwU/Xi3Itu
	 l1WfQWG6Hy+UiFT7gveqb8OlF8t7Sz5bsMsOA0fdGdsxyn4foLYuotYG+ehxFbjq/V
	 xDIEl4ZYY6Puw==
Message-ID: <a7101526-3b23-4474-afc8-bd39e7e3646f@kernel.org>
Date: Tue, 14 Apr 2026 09:21:15 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mpt3sas: Limit NVMe request size to 2 MiB
To: David Laight <david.laight.linux@gmail.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, sathya.prakash@broadcom.com,
 chandrakanth.patil@broadcom.com, stable@vger.kernel.org,
 Mira Limbeck <m.limbeck@proxmox.com>, Keith Busch <kbusch@kernel.org>
References: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
 <20260413213335.4010d8f2@pumpkin>
 <5ecd8d50-d7dc-43a3-b157-8717c6fc02d4@kernel.org>
 <20260414081210.2b63e350@pumpkin>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260414081210.2b63e350@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/14/26 09:12, David Laight wrote:
> On Tue, 14 Apr 2026 05:41:59 +0200
> Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> On 2026/04/13 22:33, David Laight wrote:
>>> On Mon, 13 Apr 2026 23:30:03 +0530
>>> Ranjan Kumar <ranjan.kumar@broadcom.com> wrote:
>>>   
>>>> The HBA firmware reports NVMe MDTS values based on the underlying drive
>>>> capability. However, due to the 4K PRP page size and a limit of
>>>> 512 entries, the driver supports a maximum I/O transfer size of 2 MiB.
>>>>
>>>> Limit max_hw_sectors to the smaller of the reported MDTS and the
>>>> 2 MiB driver limit to prevent issuing oversized I/O that may lead
>>>> to a kernel oops.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
>>>> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
>>>> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
>>>> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
>>>> Suggested-by: Keith Busch <kbusch@kernel.org>
>>>> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
>>>> ---
>>>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
>>>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>>> index 6ff788557294..44dd439e6f17 100644
>>>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>>>> @@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>>>>  				pcie_device->enclosure_level,
>>>>  				pcie_device->connector_name);
>>>>  
>>>> +		/*
>>>> +		 * The HBA firmware passes the NVMe drive's MDTS
>>>> +		 * (Maximum Data Transfer Size) up to the driver. However,
>>>> +		 * the driver hardcodes a 4K page size for the PRP list,  
>>>                                              ^ buffer ?   
>>>> +		 * accommodating at most 512 entries. This strictly limits
>>>> +		 * the maximum supported NVMe I/O transfer to 2 MiB.  
>>>
>>> Doesn't that make max_fw_entries 4096/8.  
>>
>> What is max_fw_entries ?
> 
> A mistype for max_hw_sectors :-(
> 
>> What the above explains is that a single NVMe page (4K) can store 512 (4096/8)
>> PRP entries, each pointing at a 4K nvme page, so 512*4096=2M maximum size.
>>
>>> Assuming 4096 byte sectors the longest transfer is then 4096/8*4096.  
>>
>> Yes, that's the SZ_2M Bytes.
> 
> So write it as (4096/8)*4096

See below.

>>> So none of this has anything to to with SECTOR_SHIFT.  
>>
>> Apparently, nvme_mdts is in bytes, even though the documentation in
>> mpt3sas_base.h does not mention anything about its unit. So yes, we need a
>> SECTOR_SHIFT to convert that to 512B sectors unit.
> 
> It is all very confusing because of the 4k and 512 byte sectors and there
> being another 512 constant.
> Perhaps the best expression is:
> 	(4096 /* NVMe page */ / 8) * (4096 /* hw sector size */ >> SECTOR_SIZE)

Yes, we could, but I think the comment is clear enough, so I have no issue with
the code as it is. But I will not fight this though. I will let Martin & James
decide.

>>>> +		 *
>>>> +		 * Cap max_hw_sectors to the smaller of the drive's reported
>>>> +		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
>>>> +		 */
>>>> +		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
>>>>  		if (pcie_device->nvme_mdts)
>>>> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
>>>> +			lim->max_hw_sectors = min_t(u32, lim->max_hw_sectors,
>>>> +					pcie_device->nvme_mdts >> SECTOR_SHIFT);  
>>>
>>> Why min_t() ?  
>>
>> max_hw_sectors is unsigned int and nvme_mdts is u32. Not sure if that bothers
>> min(). Worth trying.
> 
> It doesn't bother it (any more).

OK. Let's drop the min_t() then and use min().

-- 
Damien Le Moal
Western Digital Research
