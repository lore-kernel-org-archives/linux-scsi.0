Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92B233704;
	Sun, 12 Apr 2026 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776022824; cv=none; b=oPL43pUZTHqsxEc9O7COteVRUizTQjRCU4FjPMAbFS1r4AIQWWBj9W5V4zXcD7NaJBBOqMi7bpz2EXrZJK3NPMBYcWlxuqs0Cy/VX0iuLlieKtOYzT0VcHG++GR9yq0cKLhKQNs/MkcwXb12mtYVqIVHHKRh4fyPwigdN+8uZlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776022824; c=relaxed/simple;
	bh=IDCjVmbBRFYiqoQOS3yQvnMEln4UpziD65rMTyjw+SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBM657lbaG6f/efrL5GdTHPAXMjD6rqRJpXevsiMYK91qdnJ63Zns9Z7h5bRY92/If4eMl8gO1SUd3DlEviG7sA50bnLiHeb0QLmwvYthZK1dA4LgqYTKzT1EuIhpG7AgFpgHf4Xt6+sjYlWAZhm1MmlwVALCy7sdfyOBML+vsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=dqQCg4kG; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="dqQCg4kG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1776022815;
	bh=IDCjVmbBRFYiqoQOS3yQvnMEln4UpziD65rMTyjw+SU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dqQCg4kGX9yU3yd6xb+uKT3e1wBfwiarPzdjCYQ7SogeoQSzzitvSbIKKg/PgcwHF
	 Y5VKvja7jjOQSRNKBAMqJbjMYyeB7tZORhgzU+VcxVUnvgqdTzhw2EzfMutUAxw9jY
	 +jgg61AZJ2czYzKBkT1lpaWX67GlqCpVyXVCEctU=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 4CBD0BE5E1;
	Sun, 12 Apr 2026 19:40:15 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 0826D5FADC;
	Sun, 12 Apr 2026 20:40:15 +0100 (BST)
Message-ID: <f57b1b0f-4425-40be-8c8b-437fd609ed46@philpem.me.uk>
Date: Sun, 12 Apr 2026 20:40:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ata: libata-scsi: enable multi-LUN support for ATAPI
 devices
To: Damien Le Moal <dlemoal@kernel.org>, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409210559.155864-1-philpem@philpem.me.uk>
 <20260409210559.155864-3-philpem@philpem.me.uk>
 <c62f11f0-6127-41c6-98c6-cb6794125e70@kernel.org>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <c62f11f0-6127-41c6-98c6-cb6794125e70@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2026 08:38, Damien Le Moal wrote:
> On 4/9/26 23:05, Phil Pemberton wrote:
>>    - Raises max_lun from 1 to 8 (matching the SCSI host default).
>>      Sequential LUN scanning stops at the first non-responding LUN, so
>>      single-LUN devices are unaffected.
> 
> If the only case that we can encounter with libata are these special ATAPI
> devices with 2 LUNs, I would limit the maximum to 2.

I'm inclined to agree, but there are devices with higher LUN counts: the 
Nakamichi CD changers. The MJ-4.4 and MJ-5.16 were available in an ATAPI 
variant which exposed a LUN for each disc in the changer stack. There's 
a Cathode Ray Dude video demonstrating the latter.

I like the idea of the lower LUN cap for compatibility, but I think I'd 
hedge bets by also having a module parameter (e.g. libata.atapi_max_lun) 
to override it. Default 2 seems like a good compromise.

In any case, the BLIST_FORCELUN gate should limit things to one LUN for 
any device which isn't on the device list.


>>    - ata_scsi_dev_config() previously assigned dev->sdev = sdev for every
>>      LUN configured.  With multiple LUNs sharing one ata_device, this
>>      caused dev->sdev to be overwritten by each non-LUN-0 sdev.  Restrict
>>      the assignment to LUN 0 so that dev->sdev always tracks the
>>      canonical scsi_device for the underlying ATA device.
> 
> Special casing this does not seem nice at all. Why not simply increasing the
> sdev reference count when it is assigned to a LUN that is not LUN 0 ? And drop
> that reference when the LUN is torn down ? That will remove any dependency on
> the order in which LUNs are torn down too.

The if (sdev->lun == 0) guard isn't about teardown ordering; it's about 
which device dev->sdev points at.

dev->sdev is a single pointer, but with multi-LUN ATAPI there are now 
multiple sdevs sharing one ata_device. Without the guard, each call to 
ata_scsi_dev_config() overwrites the pointer, so it ends up tracking the 
last-configured LUN (likely the highest-numbered one).

This is really made clear by ata_scsi_sdev_destroy(). It uses
   dev->sdev == sdev
to decide when to schedule ATA-level detach. If the pointer has been 
overwritten, destroying the higher LUN will tear down the whole device, 
and destroying LUN 0 won't trigger a detach.

Refcounting keeps whichever sdev is stored there alive, but it doesn't 
decide which one should be stored in the first place. Picking LUN 0 
keeps the existing invariant intact for single-LUN devices, and the 
other users of dev->sdev (scsi_remove_device() in ata_port_detach(), 
ACPI uevents, zpodd) continue to operate on a stable, well-defined sdev.

Happy to add scsi_device_get() on the LUN-0 sdev when a higher LUN is 
configured, and the matching put in sdev_destroy, so LUN 0 can't be 
freed while higher LUNs still exist. That gives you the ordering 
guarantee on top of the pointer-stability guarantee.

>>    - ata_scsi_sdev_destroy() detached the entire ATA device whenever
>>      dev->sdev was non-NULL.  When a spurious multi-LUN scan result was
>>      removed, this incorrectly tore down the underlying device.  Detach
>>      only when the canonical (LUN 0) sdev is being destroyed.
> 
> This should not happen with the reference count change suggested above.
> 
> This is a lot of changes for one patch. So I also suggest splitting this patch.

Will do.

All other comments acked.


-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
