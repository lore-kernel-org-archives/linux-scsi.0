Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39C1883F;
	Tue, 14 Apr 2026 03:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776138123; cv=none; b=E9oxqsVEW6T9XeXsTYTJBPU5sHyXTVIVllCagDyavFg1rXl0GGTQok9csgxmK9snzRoWi64sFoYrA3oZQln/GbLjeXp4yOi+8yGZEyA6Ps3U2eTw6jJXSbtaUy49jBGOtgwfAfLEezS/2XEGfhPsBp0pziHTa3oMm5zRv5Nv2RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776138123; c=relaxed/simple;
	bh=rY7XcsPyF3jFewQ9LxEIm+aB5VWwdH7DKF2onv6Szsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/UceKA3JxzMOTwxh2JEO6jYuOGP0WhDQZsAKuH0xF0m2y5uUiypDx39pPJODR9L1PIvKMXaanQ09sjUo3na8sVrhT6FPtspCFAysg1UJq7Y4RIXdAOoeSL1CVCa2hc1JzdasBBb5EfLfxcambXshJyw2ymVLhjKnKKO8zbgirI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLkwfRiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLkwfRiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D85C2BCAF;
	Tue, 14 Apr 2026 03:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776138123;
	bh=rY7XcsPyF3jFewQ9LxEIm+aB5VWwdH7DKF2onv6Szsc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iLkwfRiuXNItENLo3b/p/gU+HS8IPSKl/2vLJrbm2jn0UIzUoZsOkH7lH7Apf5PT2
	 cWihrljaIo1cbiGepaTNPGYBHfvLttP6Z1bJ5HaTcY82Ax1tzYbqOLNVuojVX7dm1b
	 +evL4qoPQjviEv0tb/+w4eNKRw2LXsgecJ9YLvCqgbIfksA/oI68M4xZPPAsKtBbBx
	 qEf4g0Xr787l3WNTQkG4hWYjTwgu9lumSPU6yxQhcSyBFagMWvBDs6M1zzNm+hTQMm
	 nQhkkIpvq6XgD/kb7NTzY1RlD0RgT6hnfmyPzeZ7yR3YNx9KWYkpM2xcn0gPrt2/i6
	 6FZzAAfApfhsA==
Message-ID: <5ecd8d50-d7dc-43a3-b157-8717c6fc02d4@kernel.org>
Date: Tue, 14 Apr 2026 05:41:59 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mpt3sas: Limit NVMe request size to 2 MiB
To: David Laight <david.laight.linux@gmail.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
 stable@vger.kernel.org, Mira Limbeck <m.limbeck@proxmox.com>,
 Keith Busch <kbusch@kernel.org>
References: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
 <20260413213335.4010d8f2@pumpkin>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260413213335.4010d8f2@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/13 22:33, David Laight wrote:
> On Mon, 13 Apr 2026 23:30:03 +0530
> Ranjan Kumar <ranjan.kumar@broadcom.com> wrote:
> 
>> The HBA firmware reports NVMe MDTS values based on the underlying drive
>> capability. However, due to the 4K PRP page size and a limit of
>> 512 entries, the driver supports a maximum I/O transfer size of 2 MiB.
>>
>> Limit max_hw_sectors to the smaller of the reported MDTS and the
>> 2 MiB driver limit to prevent issuing oversized I/O that may lead
>> to a kernel oops.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
>> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
>> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
>> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index 6ff788557294..44dd439e6f17 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>>  				pcie_device->enclosure_level,
>>  				pcie_device->connector_name);
>>  
>> +		/*
>> +		 * The HBA firmware passes the NVMe drive's MDTS
>> +		 * (Maximum Data Transfer Size) up to the driver. However,
>> +		 * the driver hardcodes a 4K page size for the PRP list,
>                                              ^ buffer ? 
>> +		 * accommodating at most 512 entries. This strictly limits
>> +		 * the maximum supported NVMe I/O transfer to 2 MiB.
> 
> Doesn't that make max_fw_entries 4096/8.

What is max_fw_entries ?
What the above explains is that a single NVMe page (4K) can store 512 (4096/8)
PRP entries, each pointing at a 4K nvme page, so 512*4096=2M maximum size.

> Assuming 4096 byte sectors the longest transfer is then 4096/8*4096.

Yes, that's the SZ_2M Bytes.

> So none of this has anything to to with SECTOR_SHIFT.

Apparently, nvme_mdts is in bytes, even though the documentation in
mpt3sas_base.h does not mention anything about its unit. So yes, we need a
SECTOR_SHIFT to convert that to 512B sectors unit.

> 
>> +		 *
>> +		 * Cap max_hw_sectors to the smaller of the drive's reported
>> +		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
>> +		 */
>> +		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
>>  		if (pcie_device->nvme_mdts)
>> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
>> +			lim->max_hw_sectors = min_t(u32, lim->max_hw_sectors,
>> +					pcie_device->nvme_mdts >> SECTOR_SHIFT);
> 
> Why min_t() ?

max_hw_sectors is unsigned int and nvme_mdts is u32. Not sure if that bothers
min(). Worth trying.

> 
> David
> 
>>  
>>  		pcie_device_put(pcie_device);
>>  		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
> 


-- 
Damien Le Moal
Western Digital Research
