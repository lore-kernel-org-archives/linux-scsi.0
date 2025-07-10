Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7ADA920;
	Thu, 10 Jul 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752143709; cv=none; b=lwIlg3NXmH3dmRaxH3zLliPvUHeFQRC5kBhGlzfI+tOwXnqi8Mhpc0EZDarPKM5yLmid1JWoQwqZf5zF0Oj08UqibBHX5ryCu23wFXlNDOSgin0Q07nrf1BQyM5DfxwAdBfgD0f0b/nxRdF0qhSJaHr8xN7PilZ/7w3/4y41m7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752143709; c=relaxed/simple;
	bh=opRqITO1nE780uyZ5wsnKM1ZtcFtMsOipmHlDsOxMOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STB+2DnYfoIKGPxPexUWHQsEH8RdYg58Q0ETKCf/rc193lZX5W0INgx/Wh74MEDyTqYwN6zbnq1bnrL/+EA7cJzdf6ak+2vAc1EnI2CDRcnShmoE0e1y4ktK2GQ/P0iXvPkgWY0Ol8ifdLSDGxAopEkSnTg+C31Z5dX9XZujG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMOLwsmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMOLwsmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36E8C4CEE3;
	Thu, 10 Jul 2025 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752143709;
	bh=opRqITO1nE780uyZ5wsnKM1ZtcFtMsOipmHlDsOxMOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HMOLwsmt7/ocnuYpLPulO1YEuV7KUtnOSv4K/3GxxHvwUKixHDhydQXA+22gw55Hl
	 B5nj/yv06xYsWVyX6t1SjDWxXxQ0WYRrogKAb/34AkydIMV9ER8/U1hs0vBZPfghd4
	 aesn3XXG1Y+tuwI5BpwDgSWAt6lVKXAHNUM20zBF9kmDhwkDj54mr+gvHn6eJoPS4E
	 N2UPKId1FjDdtgScBoN5kL3EhpYTPYoIgsvN4p6ChuywRp/xuz1KHtl5NqLI5VXk/9
	 nIj8vq3t3U4jY6iAgKsvE8HuqNJSrlFX7FlH9Q7eG1bnFzkDTSYd4u5sCbgbCnG59m
	 7veUaqt+SxE7g==
Message-ID: <9e85be51-a44e-42a4-bc48-74d6375c70fd@kernel.org>
Date: Thu, 10 Jul 2025 19:32:51 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Friedrich Weber <f.weber@proxmox.com>,
 Mira Limbeck <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
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
 <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/10/25 5:41 PM, Friedrich Weber wrote:
> Hi Damien,
> 
> On 09/06/2025 14:24, Damien Le Moal wrote:
>> On 6/3/25 20:28, Friedrich Weber wrote:
>>>>> They provided controller information via `sas3ircu` and `storcli`:
>>>>>
>>>>> sas3ircu:
>>>>>
>>>>>   Controller type                         : SAS3008
>>>>>   BIOS version                            : 8.37.00.00
>>>>>   Firmware version                        : 16.00.16.00
>>>>
>>>> Is this the latest available FW for this HBA ? (see below)
>>>
>>> It seems 16.00.16.00 is even newer than the latest version available on
>>> the Broadcom website, which is a bit strange -- I only found [1] there
>>> which has an older 16.00.14.00 (3008_FW_PH16.00.14.00.rar).
>>
>> So this is an old/now EOL 9300 series HBA, right ? Or is this a 3008 controller
>> chip as part of the server motherboard (e.g. a supermicro HBA ?)
>> Looking at the Broadcom support page for legacy products, the latest FW version
>> seems to be 16.00.10.00.
> 
> According to the user it is not part of a server motherboard but a
> "proper" PCIe Broadcom SAS 9300-8i HBA.

This is an old HBA EOL HBA that has no FW update. So we will need to quirk it
to avoid the CDL probing with MAINTENANCE IN command as that seems to be the issue.

> Yeah, I agree checking the latest firmware makes sense for these,
> unfortunately they are currently in use so the user cannot test with them.
> 
> But we might be able to run some tests with a Supermicro
> AOC-S3816L-L16iT (so Broadcom SAS3816?) soon where the hotplug issue
> apparently also happens. We'll make sure to update to the latest
> firmware and I'll do my best to collect relevant logs. If you can think
> of anything specific we should collect, feel free to let me know.

See above. With such old HBA, there is no FW update.

I think we can safely ignore CDL support for the mpt3sas driver since the HBAs
controlled with this driver (9300, 9400 and 9500) do not support CDL at all.

Will try to cook something.

> Thanks for looking into this, it is definitely a strange problem.
> 
> Considering these drives don't support CDL anyway: Do you think it would
> be possible to provide an "escape hatch" to disable only the CDL checks
> (a module parameter?) so hotplug can work for the user again for their
> device? If I see correctly, disabling just the CDL checks is not
> possible (without recompiling the kernel) -- scsi_mod.dev_flags can be
> used to disable RSOC, but I guess that has other unintended consequences
> too, so a more "targeted" escape hatch would be nice.

No need to quirk the drives since the HBAs themselves do not support CDL at
all. Let me see how to do it. Basically, we need to prevent the call to
scsi_cdl_check() if the scsi host is from mpt3sas...


-- 
Damien Le Moal
Western Digital Research
