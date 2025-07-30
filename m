Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6842741BC
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 10:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753872260; cv=none; b=XbLRDgp2Hufof61L8yHijn2+wDrxrYXWc80Kl1yKaeF4ou2wszw67zN4NyiGSmKvV5X7lPK44gVfE2x7UBVdMo1LgtdTSJDhC0wRVZtW5O1kYp22qlU8AhlGXRT3Gb/d8Bfdqkq4+UhmYVl9HTjk/yAE/QlkOapseT4X7oScxWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753872260; c=relaxed/simple;
	bh=BC3ZLfiIfUUV23ytdmprKOx/TjkPKIvphMVV2G+Bls8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=o4hKpSwPpBSjH6YVLKk8kxBciBsFxTAsz/iolApIldDm5A06icXAdNvz1PwnkNEelBcQj1ujfMufrNBR2kt2Yq5ZmRPpmkZlqRG0oEyW9nL6W3o08cr8lGPqzOzyFVjiR96MAYBYEVndK63FP5dWVS3OapbcLtoHImVuwi/ZLy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id AAC56453A6;
	Wed, 30 Jul 2025 12:44:14 +0200 (CEST)
Message-ID: <a345c99d-864b-4dde-b755-b61a085508a8@proxmox.com>
Date: Wed, 30 Jul 2025 12:44:13 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Friedrich Weber <f.weber@proxmox.com>
Subject: Re: [PATCH 0/2] Disable CDL probing on ATA with mpt2sas and mpt3sas
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 MPT-FusionLinux.pdl@broadcom.com
References: <20250723052334.32298-1-dlemoal@kernel.org>
 <da2e3a15-e185-45e9-b557-a8c3e051058a@proxmox.com>
 <ad96bacd-5337-4ac4-8848-0310c7671f61@kernel.org>
Content-Language: en-US
In-Reply-To: <ad96bacd-5337-4ac4-8848-0310c7671f61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1753872243078

On 24/07/2025 15:10, Damien Le Moal wrote:
> On 7/24/25 21:01, Friedrich Weber wrote:
>> Hi Damien,
>>
>> On 23/07/2025 07:26, Damien Le Moal wrote:
>>> Martin,
>>>
>>> Friedrich reported issues with HBAs using the mpt3sas driver and CDL
>>> probe, particularly on device hot-plug. These 2 patches address this
>>> issue by force-disabling CDL probing with mpt2sas and mpt3sas. This has
>>> no effect on feature limitation since the firmware of all HBAs driven by
>>> mpt2sas and mpt3sas do not have a SAT implementation capable of handling
>>> CDL on ATA devices.
>>
>> Thanks for the patches, but they do not seem to fix hotplug in the setup
>> we've been testing [0]. We applied the patches to our downstream kernel
>> based on 6.14.8 (plus the dependency [1]). Looks like `is_ata` is 0,
>> so the CDL check still occurs. We checked with a bpftrace script [2]
>> which prints the following on hotplug:
>>
>> [kfunc:vmlinux:scsi_cdl_check] comm=kworker/u224:1 sdev=0xffff89b483eef000 sdev.scsi_level=8 sdev.is_ata=0 hostt.no_ata_cdl=1 host=5 id=1 channel=0 lun=0 stack=
> 
> sdev.is_ata=0 ?
> So the drives that are triggering this issue are SAS drives ?
> Then this is even stranger as the HBA does not do much for SAS drives. It
> basically normally only forward the scsi command to the drive. Hence why I
> changed the initial trial patch to restrict the "no cdl" case to SATA drives,
> which I thought we were dealing with here.
> 
> Going back to your earlier mails, the drives used are:
>  - WUH722020BL5204: that is indeed a 20 TB SAS model... This is the drive
> causing the issue.
>  - WUH721818AL5204: and again a SAS model (18TB), and this drive seems fine.
> 
> So my bad for completely missing this point.

No problem, I could have realized this sooner too. Yes, all drives
tested so far were SAS drives.

> Feel free to contact me off-list so that we can escalate this internally in WD
> to see if there is a FW update for the drives that could help.

Thanks, I did so!

> But I also would like to hear comments from Broadcom folks...
> 
> Broadcom folks,
> 
> Your silence regarding issues with your HBAs is not nice, to say the least.
> Properly understanding issues to fix them appropriately requires your support.
> So could you *PLEASE* comment/help ?

In case it helps, I posted debug logs with a different SAS3816 HBA that
shows the same issue in the other (older) thread [1].

[1]
https://lore.kernel.org/all/eb3778e5-dfdb-4382-8cc6-da6459f14a46@proxmox.com/

