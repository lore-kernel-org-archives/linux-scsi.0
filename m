Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F322848BE;
	Tue, 14 Apr 2026 04:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776139382; cv=none; b=PleOd1sHBjFaa3O/jpjY8+d8Fp1Wbn197VMl5nU7fH/SLh4nLoY4fsK3g4F6tSiA5rkrI5Q6tMqhFOydvFwYb/VxYgJQSGuYf++I2mCEusuvFzF6XbEiYAbS2WgpQ9grsafHbOxHDP62s4756YGLbiFPRtRUTVI/5OVbG9sOAAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776139382; c=relaxed/simple;
	bh=fXLquU1I0wtNzh/pKU9oSrpzoh7lSCfJefNWjtMabHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pW3lrpKEe8dqjJ0ta7OlpQUblLtUceS31Sull7qnDV+tAYdfPnQPxgBKAmX/FGoiQ4KJ0SwEXH97SvuDmh8v6jEO+8lovrEoKrQu2JQ9SDEV4+VgQpKEDS8bHYTj5YGLP38IhF8ox+pojuQ/Z3v3qS9MEtltyp+jLymdEvv9FIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAPbHGoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAPbHGoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC510C19425;
	Tue, 14 Apr 2026 04:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776139382;
	bh=fXLquU1I0wtNzh/pKU9oSrpzoh7lSCfJefNWjtMabHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PAPbHGoFLAkomCKVw7crN7RUoNlOj2ZlndE59qYfsDqJgRMiOxsPCQSLTn4G0tOhD
	 Ull+bAoDRxHYN3LXu9pXrXdq0gJdT1LMs/ZeeANnx+By62W7b1qsdwsOfo8jsQxLS5
	 9hzONh6gWxfUAXEHB5PvtPTyyAYHOyK7gahLZvvxo12vyoVA2UVgrAajwm4y7a6G9f
	 WVXk3+sYicpoVyW/RWtvMzzczbHMLH0JDmqW91XQCzodwxRWDNhcYV2vEZyXDYRDEm
	 75s/MqIs6wWc3rRmSasNyZmtIuGwkUguL9IF83Lt9mJJROzre469vHCZDTMPw28AE/
	 KP/xvNKGm30jQ==
Message-ID: <3d08e14c-2768-4126-882c-126113aea275@kernel.org>
Date: Tue, 14 Apr 2026 06:02:59 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ata: libata-scsi: enable multi-LUN support for ATAPI
 devices
To: Hannes Reinecke <hare@suse.de>, Phil Pemberton <philpem@philpem.me.uk>,
 cassel@kernel.org, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-3-philpem@philpem.me.uk>
 <c62f11f0-6127-41c6-98c6-cb6794125e70@kernel.org>
 <f57b1b0f-4425-40be-8c8b-437fd609ed46@philpem.me.uk>
 <ba5e3570-ec42-4642-9dbe-2344a72adcff@suse.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ba5e3570-ec42-4642-9dbe-2344a72adcff@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/04/13 10:31, Hannes Reinecke wrote:
> On 4/12/26 21:40, Phil Pemberton wrote:
>> On 12/04/2026 08:38, Damien Le Moal wrote:
>>> On 4/9/26 23:05, Phil Pemberton wrote:
>>>>    - Raises max_lun from 1 to 8 (matching the SCSI host default).
>>>>      Sequential LUN scanning stops at the first non-responding LUN, so
>>>>      single-LUN devices are unaffected.
>>>
>>> If the only case that we can encounter with libata are these special 
>>> ATAPI
>>> devices with 2 LUNs, I would limit the maximum to 2.
>>
>> I'm inclined to agree, but there are devices with higher LUN counts: the 
>> Nakamichi CD changers. The MJ-4.4 and MJ-5.16 were available in an ATAPI 
>> variant which exposed a LUN for each disc in the changer stack. There's 
>> a Cathode Ray Dude video demonstrating the latter.
>>
> Don't get too excited. This is ancient technology, with an extremely 
> narrow user-base :-)
> 'Were available' is not identical to 'in current use', and I'm somewhat
> disinclined to add support for technology with no users.
> 
>> I like the idea of the lower LUN cap for compatibility, but I think I'd 
>> hedge bets by also having a module parameter (e.g. libata.atapi_max_lun) 
>> to override it. Default 2 seems like a good compromise.
>>
> Hmm. I really would like to restrict max lun to 1 (as it somewhat mimics 
> the master/slave thingie on IDE). But higher than that really is 
> arbitrary; the next sensible limit would be '7', as this is what SCSI-2
> could handle. I completely fail to see the motivation to have a limit
> somewhere in between.
> 
>> In any case, the BLIST_FORCELUN gate should limit things to one LUN for 
>> any device which isn't on the device list.
>>
>>
>>>>    - ata_scsi_dev_config() previously assigned dev->sdev = sdev for 
>>>> every
>>>>      LUN configured.  With multiple LUNs sharing one ata_device, this
>>>>      caused dev->sdev to be overwritten by each non-LUN-0 sdev.  
>>>> Restrict
>>>>      the assignment to LUN 0 so that dev->sdev always tracks the
>>>>      canonical scsi_device for the underlying ATA device.
>>>
>>> Special casing this does not seem nice at all. Why not simply 
>>> increasing the
>>> sdev reference count when it is assigned to a LUN that is not LUN 0 ? 
>>> And drop
>>> that reference when the LUN is torn down ? That will remove any 
>>> dependency on
>>> the order in which LUNs are torn down too.
>>
>> The if (sdev->lun == 0) guard isn't about teardown ordering; it's about 
>> which device dev->sdev points at.
>>
>> dev->sdev is a single pointer, but with multi-LUN ATAPI there are now 
>> multiple sdevs sharing one ata_device. Without the guard, each call to 
>> ata_scsi_dev_config() overwrites the pointer, so it ends up tracking the 
>> last-configured LUN (likely the highest-numbered one).
>>
> And how would you address the 'sdev' of LUN 1?
> (and how of LUN 2, if we decide to have one?)
> 
> Please, don't. The correct way would be to convert 'dev->sdev' into
> a list.

Or an array sized to the max number of LUNs we allow (7 ?). That would be way
easier to handle than a list I think since we can index that by LUN number.
Unless LUNs can have any number ? I did not check...

And checking suspend/resume will be needed as we likely will need to keep track
of the number of LUNs already suspended before being able to suspend the port.
scsi layer should already be doing something like that for the scsi host though
(host == port here), so luckily, that should not too bad to handle.


-- 
Damien Le Moal
Western Digital Research
