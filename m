Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843053FF1;
	Thu, 10 Jul 2025 08:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752136916; cv=none; b=AJG4ZHbnNtN5AkzaZdGx+7YM2p9WRfxe7q+mbkyLBxCKwtqEhsalE+cy8Gqb4F4Z5Jpckwjnh1K6cnPFUik9ST/Tl50dDvL4g6+6T+IUo4xpLuIgI/M8AX91DhaUNmP0AvxKA7k+SrdUPJnqNd7WyVJvuwI5WfXlF+riLnnTerU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752136916; c=relaxed/simple;
	bh=mwgND88E4lwUvCMupP7ykiyWQ6Nyoxp+jZIi6bu/39M=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=aHfQt2Rm/dw9aPh6BiHvrN/4B5EhgxxGZIaNh03w/JVaeIAVdN1oTM+laX2kFgnMfBvb42HDZ/852kEMlJhmG/llaohREdeAtuJSzh+AqLLtBR/W4sbSOCE8toiTtlBuNHHlxLZNizHmkfhZiVkJA8xaw8pUJrEU4R5MK8zQY9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 28E7945723;
	Thu, 10 Jul 2025 10:41:45 +0200 (CEST)
Message-ID: <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
Date: Thu, 10 Jul 2025 10:41:43 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Friedrich Weber <f.weber@proxmox.com>
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Damien Le Moal <dlemoal@kernel.org>, Mira Limbeck
 <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
 <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
 <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
Content-Language: en-US
In-Reply-To: <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Damien,

On 09/06/2025 14:24, Damien Le Moal wrote:
> On 6/3/25 20:28, Friedrich Weber wrote:
>>>> They provided controller information via `sas3ircu` and `storcli`:
>>>>
>>>> sas3ircu:
>>>>
>>>>   Controller type                         : SAS3008
>>>>   BIOS version                            : 8.37.00.00
>>>>   Firmware version                        : 16.00.16.00
>>>
>>> Is this the latest available FW for this HBA ? (see below)
>>
>> It seems 16.00.16.00 is even newer than the latest version available on
>> the Broadcom website, which is a bit strange -- I only found [1] there
>> which has an older 16.00.14.00 (3008_FW_PH16.00.14.00.rar).
> 
> So this is an old/now EOL 9300 series HBA, right ? Or is this a 3008 controller
> chip as part of the server motherboard (e.g. a supermicro HBA ?)
> Looking at the Broadcom support page for legacy products, the latest FW version
> seems to be 16.00.10.00.

According to the user it is not part of a server motherboard but a
"proper" PCIe Broadcom SAS 9300-8i HBA.

> 
>>>> storcli:
>>>>
>>>> Firmware Package Build = 24.18.0-0021
>>>> Firmware Version = 4.670.00-6500
>>>> CPLD Version = 26515-00A
>>>> Bios Version = 6.34.01.0_4.19.08.00_0x06160200
>>>> HII Version = 03.23.06.00
>>>> Ctrl-R Version = 5.18-0400
>>>> Preboot CLI Version = 01.07-05:#%0000
>>>> NVDATA Version = 3.1611.00-0005
>>>> Boot Block Version = 3.07.00.00-0003
>>>> Driver Name = megaraid_sas
>>>> Driver Version = 07.727.03.00-rc1
>>>
>>> Unfortunately, I do not have any megaraid model so I cannot test/recreate. I
>>> only have mpt3sas (9300, 9400 and 9500 series HBAs) and mpi3mr models (9600 HBA
>>> series).
>>
>> We just realized this is actually the firmware information for a
>> different unrelated controller on the same host (a LSI MegaRAID SAS-3
>> 3108 using the megaraid_sas driver). But the megaraid_sas one is not
>> used in our tests, so please ignore the storcli output we provided.
>> Sorry for the confusion.
>>
>> The controller we're testing with is the SAS3008 I mentioned initially,
>> with firmware version 16.00.16.00 as reported by sas3ircu above.
> 
> I do not have this FW... Not sure what the HBA itself is too. I only have some
> Broadcom 9300-XX HBAs that have the 3008 controller.
> 
>> FWIW, the user reports they have also seen the same issue with a
>> SAS3-9500-8e Tri-mode HBA.
> 
> This one had a FW update last month or so. So checking the latest is required.

Yeah, I agree checking the latest firmware makes sense for these,
unfortunately they are currently in use so the user cannot test with them.

But we might be able to run some tests with a Supermicro
AOC-S3816L-L16iT (so Broadcom SAS3816?) soon where the hotplug issue
apparently also happens. We'll make sure to update to the latest
firmware and I'll do my best to collect relevant logs. If you can think
of anything specific we should collect, feel free to let me know.

> 
>>>> And the disk information from `smartctl --xall`
>>>>
>>>> 20T:
>>>>
>>>> === START OF INFORMATION SECTION ===
>>>> Vendor:               WDC
>>>> Product:              WUH722020BL5204
> 
> ...
> 
>>>> Product:              WUH721818AL5204
> 
> I have these. I will try to check. But again, I seriously doubt this has
> anything to do with the drives since these do not support CDL, nor do the HBAs
> you listed. None of then support CDL so calling scsi_report_opcode() for
> checking CDL, we should always see the HBA SAT return "CDL not supported".
> 
> 
>>> I do not think that the drives are relevant for this issue. How the HBA react
>>> to a command error from the drive resulting from the HBA command translation
>>> likely is the issue.
>>
>> I see, but it is certainly strange that 18T vs 20T drives do seem to
>> make a difference (hotplug works with 18T and doesn't work with 20T).
> 
> Probably a timing difference since these drives are not the same generation.
> They have different timing on scan.

Right, this would make sense, especially since cold boot appears to
work, so it sounds plausible that this may be timing-related.

> 
>>>> If you need any additional information, please let us know!
>>>
>>> Adding the Broadcom folks to this thread, since as suspected, this seems to be
>>> an HBA issue. I strongly suspect that it relates to a recent very similar issue
>>> I have seen with the mpi3mr driver and a 9600 Broadcom HBA: any hotplug of a
>>> drive would completely crash the HBA and a full power cycle was needed to
>>> recover. A simple reboot would not be sufficient. I think the latest HBA FW
>>> version fixes that problem.
>>>
>>> Broadcom team,
>>>
>>> Any comment ?
> 
> Broadcom ? Would you care to comment ?
> 
> At this point, I have no idea what is going on. My hunch is that it is the HBA
> SAT misbehaving. But that is only a hunch. To prove it, we would likely need a
> bus trace and have Broadcom look at HBA logs (which can be extracted using
> storecli). All of this likely means involving the technical support of the vendors.
> 

Thanks for looking into this, it is definitely a strange problem.

Considering these drives don't support CDL anyway: Do you think it would
be possible to provide an "escape hatch" to disable only the CDL checks
(a module parameter?) so hotplug can work for the user again for their
device? If I see correctly, disabling just the CDL checks is not
possible (without recompiling the kernel) -- scsi_mod.dev_flags can be
used to disable RSOC, but I guess that has other unintended consequences
too, so a more "targeted" escape hatch would be nice.

Best,

Friedrich

