Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1417F18F2CE
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2024 07:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717573151; cv=none; b=IMtzCY6L7e+UzFcLYT59qyto2k+xb1XGzgbn/n8szMxkL/HjXhuZh6CJGw/5bwhjWFNdyo0yGEHoPx8qlZphcMYirCYHFkFZtIHq5D0zqZTGshOlRty5i+EYjP12D4Ld98eCuiWGSZCSJvQEp8gywj8Kti7VihMs8XjLqmgNf8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717573151; c=relaxed/simple;
	bh=X0Jrjq+trUsEKXTAhVa/BzP1d1a+o2cK2CVUNiRaQVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b3ZovR1NEH6s9Pn/lGVMaVmVQRc8PF6NgJzNMHP5G+yBDBl0DIwfbzYZxZLU9Nhier4RZl1JoP18zLS0bMb9EaoU2xCGBd+fpPoHiQ1IMO1rLtH9QqO60Y1ew05WbLdh1G00sVHv9jihRhsuDKTUg9YDVL8cLzJwRlKLcYzpF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id A709E44D6B;
	Wed,  5 Jun 2024 09:39:05 +0200 (CEST)
Message-ID: <0416bd27-49d1-414a-bacd-c80ec8ec9613@proxmox.com>
Date: Wed, 5 Jun 2024 09:39:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Maciej W . Rozycki" <macro@orcam.me.uk>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-3-martin.petersen@oracle.com>
 <449d764e-6e56-43c4-a461-e63a91ab19dc@proxmox.com>
 <yq11q5c9kkm.fsf@ca-mkp.ca.oracle.com>
From: Aaron Lauterer <a.lauterer@proxmox.com>
In-Reply-To: <yq11q5c9kkm.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Martin,

thanks for getting back to me.

On  2024-06-05  04:51, Martin K. Petersen wrote:
> 
> Aaron,
> 
>> The target is an HDD behind a MegaRAID controller configured as JBOD.
> 
> Running in JBOD mode is probably part of the problem.
> 
>> root@pve1:~# sg_vpd -l /dev/sda
>> Supported VPD pages VPD page:
>>     [PQual=0  Peripheral device type: disk]
>>    0x00  Supported VPD pages [sv]
>>    0x80  Unit serial number [sn]
>>    0x83  Device identification [di]
>>    0x87  Mode page policy [mpp]
>>    0x89  ATA information (SAT) [ai]
>>    0x8a  Power condition [pc]
>>    0xb0  Block limits (SBC) [bl]
>>    0xb1  Block device characteristics (SBC) [bdc]
>>    0xb2  Logical block provisioning (SBC) [lbpv]
> 
> I am working on a fix for what's probably a related issue.
> 
> I would appreciate if you could do two things:
> 
> 1. Please send me the output of:
> 
>     # sg_opcodes /dev/sda

Here you go:
---
root@pve1:~# sg_opcodes /dev/sda
   ATA       HGST HUS726T4TAL  W984
   Peripheral device type: disk
Report supported operation codes: Illegal request, Invalid opcode
---

I get the same result for the other 2 block devices configured on this 
RAID controller. One is another JBOD device (an SSD), the other is a RAID-1.

> 
> 2. Try building and booting:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=6.10/scsi-fixes
> 
>     and see if that makes a difference in your case.

I checked out the 6.10/scsi-fixes branch which was on commit

  d53b681 scsi: ufs: mcq: Fix error output and clean up ufshcd_mcq_abort()

to build a new kernel to test.

Unfortunately, I must report that running the `fallocate`[0] command 
still works and does not fail with an unsupported error.


If there is more I can do to help, please let me know.

Best regards,
Aaron

[0]
fallocate --punch-hole --keep-size -l 2M /dev/sda --offset 4M



