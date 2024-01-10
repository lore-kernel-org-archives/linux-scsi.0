Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7563364C8
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 07:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFqyTiKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3941BC433C7;
	Wed, 10 Jan 2024 07:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704870272;
	bh=pr2B+SWj16ZWWqw/3m6Md8HzI5RZaYua1Hc8A/FDz70=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=DFqyTiKPHhWwzJzxxXqET6fxXbxLV1YZeboZGfCtAaOLj5ZIK1gsSA03HLlyjh3Id
	 pLjs0rDOCo09TClJHqrRDFqnj5/uLLw/pd9aWA9l5pZCXcdKTd0lh3Wh4j7AA9XESY
	 GrFL165kWt8iJ5+XFmdsqubiTRYuVoOB3VhfGZiGDbQhq455f1Dig0CVkFDTeaJ5dD
	 5xVoqeEDC50AYOqM0uqX3tAVpd1BbgV8H0LwQmIWdmG72pk9U+lJ0YDMyPUP/AFN3m
	 dpzsQbedm0mozV8+sKpF+nMXb2kLerYc9tPUgC+I2uGPcz5f45RmpCdSYvIEvEnbla
	 N0R24pVwcnA5A==
Message-ID: <b6da4b95-f6e4-4cf7-9cdc-239d91655b6d@kernel.org>
Date: Wed, 10 Jan 2024 16:04:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Content-Language: en-US
To: Kevin Locke <kevin@kevinlocke.name>, Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <a6d89569-8369-4550-83da-d63afdab579d@kernel.org>
 <ZZ48yBm1yOEDv3ST@kevinlocke.name>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZZ48yBm1yOEDv3ST@kevinlocke.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/24 15:44, Kevin Locke wrote:
> On Wed, 2024-01-10 at 11:18 +0900, Damien Le Moal wrote:
>> On 1/9/24 02:56, Kevin Locke wrote:
>>> On a ThinkPad T430 running Linux 6.7, when I attempt to delete the ATA
>>> device for a hard drive in the Ultrabay slot (to hotswap/undock it[1])
>>> the process freezes in an unterruptible sleep.  Specifically, if I run
>>>
>>>     echo 1 >/sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/delete
>>>
>>> The shell process hangs in the write(2) syscall.  The last dmesg
>>> entries post hang are:
>>>
>>>     sd 1:0:0:0: [sda] Synchronizing SCSI cache
>>>     ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>>>     ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>>>     ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>>>     ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>>>     ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>>>     ata2.00: configured for UDMA/133
>>
>> It looks like the device was sleeping or was in standby state.
>> If that is the case, then we may be deadlocking with the scsi revalidate done
>> when waking up a drive. Can you confirm what the power state of the drive was
>> when you ran this ? Do you see an issue if you first make sure that the drive is
>> spun-up ?
> 
> Bingo!  I can confirm that I do not experience the issue when the
> drive is in the active/idle state, nor in standby (hdparm -y).  I only
> experience the issue if the drive is in the sleep (hdparm -Y) state.

hdparm -Y does not use the kernel power management core. There is a hack in
libata to track that a SLEEP command was issued to the device and then mark it
with ATA_DFLAG_SLEEPING. And if this flag is set, then the port is reset to
spinup the drive whenever a new command is received. That is what is causing the
problem here as a reset (EH running) is not supposed to happen when the scsi
drive is going away.

This all boils down to the scsi disk not being in sync with its underlying ata
device: the scsi disk is not marked as spun-down/standby and so a flush cache is
issued. Problem is that it is not realistic to track and maintain the system
device state by catching/parsing passthrough commands such as issued by hdparm.

That said, a hang is still not acceptable. we will see how to avoid it (it is
not trivial).

> 
> Thanks for the incisive suggestion,
> Kevin
> 
> P.S. The Ultrabay eject script[1] runs `hdparm -Y` before delete.
> Should that be removed (or changed to standby) to avoid unnecessary
> revalidation?  For both HDD and SSD?

Removing a scsi disk will remove and put the backing ata device in standby
state. So you do not need to do that manually. Remove that "hdparm -Y" from your
script.

> 
> [1]: https://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices#Script_for_Ultrabay_eject
> 

-- 
Damien Le Moal
Western Digital Research

