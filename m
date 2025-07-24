Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921DA169AE6
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 13:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753362632; cv=none; b=NWUKilAttwCOzibkmbWC3dUV0+0w/a1q02ypWdBe84QFCzixefXxZ4RwE/JkeoHUl2mal5NaSf/tlomsaoSHpnOchGZenG1g0KeffsyGHIUzVIhT1V7g/Ev9UkjuUnkCwIcDwC4aVPP8F+xKGA97IlEIORr5u72EG2/f05EnV8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753362632; c=relaxed/simple;
	bh=gbIQnkXVR/OJMtuJBoqF8S1xWXqxZ7JCc09UpSpuN0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P1tx9SiZHtMgKqj+lKgq3BD/8VE1N/LfeOtvhmcTky3nZxELZh8D/UoyL8MFHmvu97fsfPGvZomk8pMOGzeiYYgUNeqhfKOcb8uB2jdf4UISsGslzC4ssWR5kM42fyqHGmCSp5CPS7DuqvQ3rBdJdtrAx/FyIMYD5aEggrL7lCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfmvIsjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfmvIsjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0BBC4CEED;
	Thu, 24 Jul 2025 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753362631;
	bh=gbIQnkXVR/OJMtuJBoqF8S1xWXqxZ7JCc09UpSpuN0M=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=FfmvIsjLUNexldROa+7pnNHj+Wv/5gREScWiTbX0CBkUwnzU9uCJFa8DPC52wdCDX
	 kfQKLBUqrKiBsSW7+kCAKWaDRivs/8ldAPB6Z8TPrmDscccfINIUtJ7nIor3xYbeX8
	 aV/Mxi87BToT+gJCkdpXDyWU9ggnFYD56usCflWOb35l//V0o84ZRuvDQOlqFwoslU
	 PK0Pn2weG1pRj2p05gSEY7f7VqLzzAzItBcuvt3nF1c5k2Sur0oeYlzD/DvNWiDd4R
	 pL2xuZey9UZs4Lu7Le53SsIa73O08Nrq4TktVvUoBVQDpNtpwtvMiYvA+LbruZMhA6
	 I3YUPBDyeJrVg==
Message-ID: <ad96bacd-5337-4ac4-8848-0310c7671f61@kernel.org>
Date: Thu, 24 Jul 2025 22:10:29 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Disable CDL probing on ATA with mpt2sas and mpt3sas
To: Friedrich Weber <f.weber@proxmox.com>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 MPT-FusionLinux.pdl@broadcom.com
References: <20250723052334.32298-1-dlemoal@kernel.org>
 <da2e3a15-e185-45e9-b557-a8c3e051058a@proxmox.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <da2e3a15-e185-45e9-b557-a8c3e051058a@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/25 21:01, Friedrich Weber wrote:
> Hi Damien,
> 
> On 23/07/2025 07:26, Damien Le Moal wrote:
>> Martin,
>>
>> Friedrich reported issues with HBAs using the mpt3sas driver and CDL
>> probe, particularly on device hot-plug. These 2 patches address this
>> issue by force-disabling CDL probing with mpt2sas and mpt3sas. This has
>> no effect on feature limitation since the firmware of all HBAs driven by
>> mpt2sas and mpt3sas do not have a SAT implementation capable of handling
>> CDL on ATA devices.
> 
> Thanks for the patches, but they do not seem to fix hotplug in the setup
> we've been testing [0]. We applied the patches to our downstream kernel
> based on 6.14.8 (plus the dependency [1]). Looks like `is_ata` is 0,
> so the CDL check still occurs. We checked with a bpftrace script [2]
> which prints the following on hotplug:
> 
> [kfunc:vmlinux:scsi_cdl_check] comm=kworker/u224:1 sdev=0xffff89b483eef000 sdev.scsi_level=8 sdev.is_ata=0 hostt.no_ata_cdl=1 host=5 id=1 channel=0 lun=0 stack=

sdev.is_ata=0 ?
So the drives that are triggering this issue are SAS drives ?
Then this is even stranger as the HBA does not do much for SAS drives. It
basically normally only forward the scsi command to the drive. Hence why I
changed the initial trial patch to restrict the "no cdl" case to SATA drives,
which I thought we were dealing with here.

Going back to your earlier mails, the drives used are:
 - WUH722020BL5204: that is indeed a 20 TB SAS model... This is the drive
causing the issue.
 - WUH721818AL5204: and again a SAS model (18TB), and this drive seems fine.

So my bad for completely missing this point.

Feel free to contact me off-list so that we can escalate this internally in WD
to see if there is a FW update for the drives that could help.

But I also would like to hear comments from Broadcom folks...

Broadcom folks,

Your silence regarding issues with your HBAs is not nice, to say the least.
Properly understanding issues to fix them appropriately requires your support.
So could you *PLEASE* comment/help ?

-- 
Damien Le Moal
Western Digital Research
