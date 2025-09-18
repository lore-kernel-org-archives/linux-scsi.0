Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED6F21B199;
	Thu, 18 Sep 2025 12:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758199615; cv=none; b=CUO0V3Lr4P/upB+S6O7jNPCmyjlpYOth4Y/I6gdXU6owKa4wEJP7FiSV2x+lLLHxyqdzG707o7YMExDXey9xK/0aejGuQGo66bp1xaehIvG4zgJOwjFTbSyrAVVJIlrSfv8/yLNgnDmMDSfzR8UReLAlrl/RLYlbdAN1h21zrEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758199615; c=relaxed/simple;
	bh=j3LgcXkZGb+gIC+Ry9Yqzb9XF3Ssc3Kw4mvGIT22bIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V7w3W6bV3uCLeCnWy4M/MPDRVM1+JTpAXSmetiAVMUB3B4OloeRi9Lx9aDo9g3gcGo8+6EpEgBLy/EkzpbHBrP7chQPcPUWTKgF1fv+Bykg08GBFV3vVQy9ZwZitAOWGJ9qECqTTNDCdeiyIh4F4cP95EatuC+nr4Rgvkfal/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 472784ED6C;
	Thu, 18 Sep 2025 14:46:42 +0200 (CEST)
Message-ID: <8103ec9d-642a-4b40-b544-af1aae1205cc@proxmox.com>
Date: Thu, 18 Sep 2025 14:46:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Damien Le Moal <dlemoal@kernel.org>,
 Diangang Li <lidiangang@bytedance.com>
Cc: Mira Limbeck <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
 <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
 <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
 <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
 <3b2a6cfe-5bf3-4818-8633-c200d8e6f122@kernel.org>
 <4cb58e56-d9e2-4868-84ad-8b7253148228@proxmox.com>
 <75412b1b-3f39-4f6a-93ce-823c15a19bf3@kernel.org>
 <20250731114832.GA97414@bytedance.com>
 <856aa232-701f-40bf-bae9-1aff8886f473@kernel.org>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <856aa232-701f-40bf-bae9-1aff8886f473@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1758199592700

On 01/08/2025 01:21, Damien Le Moal wrote:
> On 7/31/25 20:48, Diangang Li wrote:
>> On Tue, Jul 22, 2025 at 06:37:50PM +0900, Damien Le Moal wrote:
>>> On 7/22/25 6:32 PM, Friedrich Weber wrote:
>>>> On 14/07/2025 04:48, Damien Le Moal wrote:
>>>>> On 7/10/25 5:41 PM, Friedrich Weber wrote:
>>>>>> Thanks for looking into this, it is definitely a strange problem.
>>>>>>
>>>>>> Considering these drives don't support CDL anyway: Do you think it would
>>>>>> be possible to provide an "escape hatch" to disable only the CDL checks
>>>>>> (a module parameter?) so hotplug can work for the user again for their
>>>>>> device? If I see correctly, disabling just the CDL checks is not
>>>>>> possible (without recompiling the kernel) -- scsi_mod.dev_flags can be
>>>>>> used to disable RSOC, but I guess that has other unintended consequences
>>>>>> too, so a more "targeted" escape hatch would be nice.
>>>>>
>>>>> Could you test the attached patch ? That should solve the issue.
>>>>>
>>>>
>>>> Thanks for the patch! The user tested it on top of a 6.15.6 kernel and
>>>> with the SAS3008 HBA, and indeed:
>>>>
>>>> - under 6.15.6, hotplug fails with the log messages mentioned in my
>>>> first message,
>>>> - with your patch on top, hotplug works again.
>>>
>>> OK. Will post a proper patch then (tomorrow).
>>> Thanks for testing.
>>>
>>
>> Hi Damien,
>>
>> Are you planning to post a formal patch to upstream?
> 
> I initially thought that the issue was due to some problem with the HBA SAT
> (SCSI to ATA translation). However, the drives that trigger the issue are SAS
> drives, so there is no command translation and it is much less likely that the
> issue is related to the HBA. So I am relunctant to take a big hammer and disable
> CDL for mpt3sas for SAS drive. HBAs driven by that driver do *not* support CDL
> for ATA, so disabling CDL would not be an issue for SATA disks. But there is no
> good reasons to disable CDL for SAS drives.
> 
> This is being handled as a drive issue now, off-list.

Posting the resolution here for posterity: After updating the firmware
of affected drives to GC8, hotplug works again.

Thanks again for the troubleshooting!

Best,

Friedrich

