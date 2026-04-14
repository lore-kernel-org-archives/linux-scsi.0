Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AED635F609
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 07:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776150736; cv=none; b=MzesHv4ndviBlcrg3tVw8asTDUdreubFeewRJfLTYlSfkCmyNdJF2hBP5m4idxZAb42XVOPiyWpVnvjCcflX/619x0scrXY08ynI4DbH3jfc+0IjI5gjKQn07vw1CxEcL8Pp+QwBqtZxcS/mG2h90evqs42R03IgXq7m/YbWzgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776150736; c=relaxed/simple;
	bh=pc/khuUTh7M50Gs774pXFPkfuOHJz9HSjhJ8TEeqTrM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+HiMh8Ghlu/bIXwR1W0PIDe9UjtlynM+mpuZRcukKun5KIGtg/YKwjJOHtmxk5XrNg+cY1zhBuqHEAGJypWQ0OpOBpRFT9exCnazu22/hxwfechYdyCz/fCSd1HV1GJgCmCE7/w1iFfWPl7GRct0sSVWT6N0WN2FUCX0SOqnAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hqhpidqE; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hqhpidqE"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a29e6110so56595615e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 00:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776150733; x=1776755533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhanaccIGc9hiLH1UN6IYI4Y2aihOg0AcpAQfiO+8sc=;
        b=hqhpidqEStwT0NwwL1oD+WcInDKRiVbovXaKZd8SMkJDGlFEm9ku1lf2KZ+r4sFHac
         8nc+YTRKPweh/Mf2gfPY6b6XhwLHfdLnqEcLtJtn4EA2+z5Gzf1i/7Upcvo3obKOg2MN
         qX5fUzhyRyKfJjTjJWD7x7hYDIXF3GE5Y73EoYXN/8zek5VJtTL4QWRtlD3HPwwlGSTr
         /zv6UZ8ba8b1iM83IVYpgOCEuUHyis2mLR2jbf4Tt7kZbkYwl9uT8Sdr+h9FF0z8wFE9
         MFD+tNWnq7SPz5Q4VHjNzaC/WWQoDWXKH1TDrnxes4wG9eAeb10Hd86iGOAef01cSRde
         NSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776150733; x=1776755533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LhanaccIGc9hiLH1UN6IYI4Y2aihOg0AcpAQfiO+8sc=;
        b=Dm/OX68z6PwndfMhBYabs4z0yjK2KjQDFaeUeTOwQP+rCtXpiafzCNOmN/r/tbrSR3
         nxIORYJddxrPOgENQLO9oHhteEHTQ3Ps/KotC+bbnSON5IaLya7VenmTPc6mRi1jouR8
         /DUIywSuidDI6C7ACaqi3b9qAlkeHvOxbDywxWyhdGBTB9efD86vWTyGilc58YLSdgzr
         ooE71O+MZF4A4qawl2FNVxk22Naady4/z2eEKiucavt/N7dCpcXiRXkp7xd5xkhFhr1p
         HZIcNl7cf8hEH6OAnkqBh6Ur+K+SjlhOCJCkHmaDA5M4AzhhpdVhpLK5M8yBvdZNPUvh
         K68w==
X-Forwarded-Encrypted: i=1; AFNElJ+xnuKrycDXBB4UAKtbKUjuFq+QYiNV5qCDdgNt/IMsiDcfT8a3Tc3UxbeRUvogNAKmNEPH9578Sgys@vger.kernel.org
X-Gm-Message-State: AOJu0YxkxGRmm2HW+pVJ77g7W4pH7q0vmT3y5ZJrFgHinIgU9KTDuhaY
	uxmbivpBMqDXGpjXaEDEaIJitrjGAxKI9uI3bpaS6NypcvQ/K+iD6NzQ
X-Gm-Gg: AeBDies2Vttf7XK5lWrmH9nNvCg1rxFOqIOtZDY3ZUiW7nbihW1ntNPjnPINkgmAAwo
	mA4BjpSBFo2TDd4zju0ikU/htwywR9yfcpIRTLrmV4m9tLjlOUTVjUsNuP5R62brWphNHwot7Nh
	fgu0GfB0TEfEKTGW76yt8N2wDfE8ccbXRErZRq40niGVQSRH3rrAV7yeKxxyr7FlqJGpOOiG4yd
	aX1vcXH0O53bmzlAPVTaWRrXWkDJWC4wgBId2SNJFKEYXHoH70J2z14JBM3BBWYAj7XY3ptoOjg
	UeQsRuufrm/qFtKGAbfCw7ItM/9LEzHgFo8wGgveAdAu5WQrLnQnvX9SO/lDVgGRpsIKlYmw0JS
	y1sAPjhl97rxIiKsq0P5xP4gYwTzSg8sVbHZZA9PfuY9tJObPmbnIOd1DXLIfS+z60gmvlWtw25
	YBAy9u/JDDaDObq67lZIwFwhtx/7SQfGEjWTj3tl+CMhiFQsUg+QVS6AEpegWBs1Jv
X-Received: by 2002:a05:600c:8b27:b0:488:af7f:775f with SMTP id 5b1f17b1804b1-488d68766c7mr208172865e9.18.1776150733023;
        Tue, 14 Apr 2026 00:12:13 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de2a53sm38049692f8f.5.2026.04.14.00.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 00:12:12 -0700 (PDT)
Date: Tue, 14 Apr 2026 08:12:10 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, sathya.prakash@broadcom.com,
 chandrakanth.patil@broadcom.com, stable@vger.kernel.org, Mira Limbeck
 <m.limbeck@proxmox.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3] mpt3sas: Limit NVMe request size to 2 MiB
Message-ID: <20260414081210.2b63e350@pumpkin>
In-Reply-To: <5ecd8d50-d7dc-43a3-b157-8717c6fc02d4@kernel.org>
References: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
	<20260413213335.4010d8f2@pumpkin>
	<5ecd8d50-d7dc-43a3-b157-8717c6fc02d4@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Apr 2026 05:41:59 +0200
Damien Le Moal <dlemoal@kernel.org> wrote:

> On 2026/04/13 22:33, David Laight wrote:
> > On Mon, 13 Apr 2026 23:30:03 +0530
> > Ranjan Kumar <ranjan.kumar@broadcom.com> wrote:
> >   
> >> The HBA firmware reports NVMe MDTS values based on the underlying drive
> >> capability. However, due to the 4K PRP page size and a limit of
> >> 512 entries, the driver supports a maximum I/O transfer size of 2 MiB.
> >>
> >> Limit max_hw_sectors to the smaller of the reported MDTS and the
> >> 2 MiB driver limit to prevent issuing oversized I/O that may lead
> >> to a kernel oops.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> >> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
> >> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
> >> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
> >> Suggested-by: Keith Busch <kbusch@kernel.org>
> >> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> >> ---
> >>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
> >>  1 file changed, 13 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >> index 6ff788557294..44dd439e6f17 100644
> >> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >> @@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
> >>  				pcie_device->enclosure_level,
> >>  				pcie_device->connector_name);
> >>  
> >> +		/*
> >> +		 * The HBA firmware passes the NVMe drive's MDTS
> >> +		 * (Maximum Data Transfer Size) up to the driver. However,
> >> +		 * the driver hardcodes a 4K page size for the PRP list,  
> >                                              ^ buffer ?   
> >> +		 * accommodating at most 512 entries. This strictly limits
> >> +		 * the maximum supported NVMe I/O transfer to 2 MiB.  
> > 
> > Doesn't that make max_fw_entries 4096/8.  
> 
> What is max_fw_entries ?

A mistype for max_hw_sectors :-(

> What the above explains is that a single NVMe page (4K) can store 512 (4096/8)
> PRP entries, each pointing at a 4K nvme page, so 512*4096=2M maximum size.
> 
> > Assuming 4096 byte sectors the longest transfer is then 4096/8*4096.  
> 
> Yes, that's the SZ_2M Bytes.

So write it as (4096/8)*4096

> 
> > So none of this has anything to to with SECTOR_SHIFT.  
> 
> Apparently, nvme_mdts is in bytes, even though the documentation in
> mpt3sas_base.h does not mention anything about its unit. So yes, we need a
> SECTOR_SHIFT to convert that to 512B sectors unit.

It is all very confusing because of the 4k and 512 byte sectors and there
being another 512 constant.
Perhaps the best expression is:
	(4096 /* NVMe page */ / 8) * (4096 /* hw sector size */ >> SECTOR_SIZE)


> 
> >   
> >> +		 *
> >> +		 * Cap max_hw_sectors to the smaller of the drive's reported
> >> +		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
> >> +		 */
> >> +		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
> >>  		if (pcie_device->nvme_mdts)
> >> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> >> +			lim->max_hw_sectors = min_t(u32, lim->max_hw_sectors,
> >> +					pcie_device->nvme_mdts >> SECTOR_SHIFT);  
> > 
> > Why min_t() ?  
> 
> max_hw_sectors is unsigned int and nvme_mdts is u32. Not sure if that bothers
> min(). Worth trying.

It doesn't bother it (any more).

	David

> 
> > 
> > David
> >   
> >>  
> >>  		pcie_device_put(pcie_device);
> >>  		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);  
> >   
> 
> 

