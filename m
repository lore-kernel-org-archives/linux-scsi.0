Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256030BF4F;
	Mon, 13 Apr 2026 05:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776059011; cv=none; b=SSWs/PXjlUYOJLfkLlBhpekHg52dkI2WSHdE4EDVWMM+HLpHmPFXvSjbGuZ+K2mwLZoaomg9P1PQLtYco8VDPaUhn4UumyKMUCt/AMm4ewxfnGJmbrM1H2QzxJynykYGmwU+eFKF4iwps/fK+PsMYKFNzEsrxvEO0xjPwgZr+LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776059011; c=relaxed/simple;
	bh=r+015Cgw6pwSJOcQ7qwYWHmJEnAfUe35dDrClraOUXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CEj3GGWI3UHf5E76t5ac+mH7ffL3j612xOnzzpmLr2jslQ/quxMSLdEs6H6TfzPWGVc2O6HYi+e62rZw/tLf1p8BXVB5pmXgnuoBNc67HpDmz6l6ZhYeUtXNkjA4vKiNJhV+c9vMeDn6OAXt7rFuCJZiRghY3H7GWEtw7ASn0tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bW51+xBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bW51+xBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43CEC116C6;
	Mon, 13 Apr 2026 05:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776059011;
	bh=r+015Cgw6pwSJOcQ7qwYWHmJEnAfUe35dDrClraOUXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bW51+xBJYi5zetWUTby/L8IcG4z3zzIlnBuSu0R8LwDSOYQGgrTJ+jX+/Ls6WoIh3
	 1qC6NU51p8WTbcb+pj/8GebVIYvRQaKUHgyvZnGmxFgt5X5Kww/JalhhhW97wEi9e5
	 mbWMv2fDBRKJiu+qDwe6Y71yiDFWYPPHb5aCeTGsPtLhYJTKYvi+u5g5x0d05oqAUs
	 g5y/ZneKYexUVeiOKIelYK0zsDN+JtKhWjT+uQUNDpzSFEuAsaM/OSW2idzSnOnnSt
	 i54O9OCQTUyF7Dx35/yRI3dCtV4VXn9hDtVK6UEISKyGiqlVwFwtK90Dr7da/kjG+t
	 BH5fl+K54RrKw==
Message-ID: <05b81015-24fe-417a-b52f-854cbef60de4@kernel.org>
Date: Mon, 13 Apr 2026 07:43:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ata: libata-scsi: enable multi-LUN support for ATAPI
 devices
To: Phil Pemberton <philpem@philpem.me.uk>, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-3-philpem@philpem.me.uk>
 <c62f11f0-6127-41c6-98c6-cb6794125e70@kernel.org>
 <f57b1b0f-4425-40be-8c8b-437fd609ed46@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <f57b1b0f-4425-40be-8c8b-437fd609ed46@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/12 21:40, Phil Pemberton wrote:
> On 12/04/2026 08:38, Damien Le Moal wrote:
>> On 4/9/26 23:05, Phil Pemberton wrote:
>>>    - Raises max_lun from 1 to 8 (matching the SCSI host default).
>>>      Sequential LUN scanning stops at the first non-responding LUN, so
>>>      single-LUN devices are unaffected.
>>
>> If the only case that we can encounter with libata are these special ATAPI
>> devices with 2 LUNs, I would limit the maximum to 2.
> 
> I'm inclined to agree, but there are devices with higher LUN counts: the 
> Nakamichi CD changers. The MJ-4.4 and MJ-5.16 were available in an ATAPI 
> variant which exposed a LUN for each disc in the changer stack. There's 
> a Cathode Ray Dude video demonstrating the latter.
> 
> I like the idea of the lower LUN cap for compatibility, but I think I'd 
> hedge bets by also having a module parameter (e.g. libata.atapi_max_lun) 
> to override it. Default 2 seems like a good compromise.
> 
> In any case, the BLIST_FORCELUN gate should limit things to one LUN for 
> any device which isn't on the device list.

Ideally, we want to keep the default 1 LUN value and change it to a higher count
only if we probe that we are dealing with an ATAPI device (device class is
ATAPI). Not sure if that is possible. Need to look again at that code.

>>>    - ata_scsi_dev_config() previously assigned dev->sdev = sdev for every
>>>      LUN configured.  With multiple LUNs sharing one ata_device, this
>>>      caused dev->sdev to be overwritten by each non-LUN-0 sdev.  Restrict
>>>      the assignment to LUN 0 so that dev->sdev always tracks the
>>>      canonical scsi_device for the underlying ATA device.
>>
>> Special casing this does not seem nice at all. Why not simply increasing the
>> sdev reference count when it is assigned to a LUN that is not LUN 0 ? And drop
>> that reference when the LUN is torn down ? That will remove any dependency on
>> the order in which LUNs are torn down too.
> 
> The if (sdev->lun == 0) guard isn't about teardown ordering; it's about 
> which device dev->sdev points at.
> 
> dev->sdev is a single pointer, but with multi-LUN ATAPI there are now 
> multiple sdevs sharing one ata_device. Without the guard, each call to 
> ata_scsi_dev_config() overwrites the pointer, so it ends up tracking the 
> last-configured LUN (likely the highest-numbered one).
> 
> This is really made clear by ata_scsi_sdev_destroy(). It uses
>    dev->sdev == sdev
> to decide when to schedule ATA-level detach. If the pointer has been 
> overwritten, destroying the higher LUN will tear down the whole device, 
> and destroying LUN 0 won't trigger a detach.
> 
> Refcounting keeps whichever sdev is stored there alive, but it doesn't 
> decide which one should be stored in the first place. Picking LUN 0 
> keeps the existing invariant intact for single-LUN devices, and the 
> other users of dev->sdev (scsi_remove_device() in ata_port_detach(), 
> ACPI uevents, zpodd) continue to operate on a stable, well-defined sdev.
> 
> Happy to add scsi_device_get() on the LUN-0 sdev when a higher LUN is 
> configured, and the matching put in sdev_destroy, so LUN 0 can't be 
> freed while higher LUNs still exist. That gives you the ordering 
> guarantee on top of the pointer-stability guarantee.

OK. I misunderstood your change. I really need to look again at that code, which
I have not done in a while.

I think your change may be generally OK, but I am worried that things like
suspend/resume may have issues. Have you tested that ?

Anyway, please give us some time to look into this (sorry, but I am super busy
these days, so it may take a couple of weeks).

-- 
Damien Le Moal
Western Digital Research
