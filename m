Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A3834B183
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 21:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776978378; cv=none; b=avGz7BT4a58dpOrVCtED/yYLH3AeFab8YGNbJzDlbIhHTeJtI5TQI2jfVv/WYV7Ehm81l4+hHr5pRshxZQZHiU6qMKk+u9G0QUItCt4Ye7o6dt4/NVJPpEhFtfNmS07nn9xhwleb7kBMJ2vO2pjEIrl06LsDOFhfDGpsan03wLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776978378; c=relaxed/simple;
	bh=0FwnoU7crsng8ZdY1lihmMOcw4yZIHGTIaj/iUR76Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=At4IXIMPzm8jNZIIBMEoO4FzF11zD/GksckKy5sxV1iRWiCBQJbOm5j7PCd/4dYpk3MAO0A+fg+zJmZ0mczoZXfmCxvCh15AT2b4Nwnry9ESrnRwiT8fwKgefgtCo9CAiDOLJvNbmNCk6hgqgn0JyrkB9intrxEjTchTbyCafh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk; spf=pass smtp.mailfrom=philpotter.co.uk; dkim=pass (2048-bit key) header.d=philpotter-co-uk.20251104.gappssmtp.com header.i=@philpotter-co-uk.20251104.gappssmtp.com header.b=LqyluZUJ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20251104.gappssmtp.com header.i=@philpotter-co-uk.20251104.gappssmtp.com header.b="LqyluZUJ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso67092125e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 14:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20251104.gappssmtp.com; s=20251104; t=1776978376; x=1777583176; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9oEVVbYJJp7mcAvHLiflerbUEp4PM9+aREz5+ZVnbHk=;
        b=LqyluZUJs3rOa2H72QmgULEYCpeLS3M9tPk/IwwqOLBpexwm33lPc2mv3fuj1ZSlhL
         /uruXMAVSD37FJ+7rugnSSrxJx71OA3ovtUatCCOUEyKAFCo8yifrvIljpzU+HWJ/DN4
         8oVNnfVUeX7SkD9HhlP32mDjzhvrKIoTVAptCiZ9YbDJ71abMlg09JgF3R0rcyPc1lLk
         A7jKDTSxop/b0neYPCbZa3bRQDY1bqWI0Z0o64nwB9AaC5PXfpGBEqmCdxVXVK/DRNTm
         hjxCUJYHN8gwzYHtugKBsi+b+MXWcbqNkM/fgUy0D0S6eH7fasVl3oav4MC3Zo19mvER
         8qjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776978376; x=1777583176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oEVVbYJJp7mcAvHLiflerbUEp4PM9+aREz5+ZVnbHk=;
        b=fKvgtg4ytyFjJt8fr1F1ncATqHqgxPrehvMcUkyQq68yoHD4vMt1BWb39qsiZ/QKm+
         gsv24Osx3ZrZzueMDUXeqKzlOZOCRqR4JC0G456GdaJcAjScqekD6xrWFoQL4ZYGy7+m
         tEdIqgkU0Wf0GpccCR2mJc5nOr39AXYchA5Zc4b973jRHRFB8TSnekT/5rjkQzORqHAc
         PyDZqcPPGw/9f+W6Lg0HE/Hc1GBCb1YZE2Ahwt7zikadVMdUwmBbgySWgzSM/DrQ8p2I
         GDYja+mnzm/oGMwiwqdttoqhjcQY511BSZeO6+spM1F5u6qyigdH5/cySF1jedFDfLD5
         FnVw==
X-Forwarded-Encrypted: i=1; AFNElJ8/f12tALZa5ZEGMOG+Tw9teYb3P6RUL5jK9jx/CbzLlQ5GyYDLxxOYgz1jVXEt9HDAsuGVX0tiW/EN@vger.kernel.org
X-Gm-Message-State: AOJu0YxUCg96nq8ItMCNUxq73XsKoB2vyeDzPQeR45hH4G8r9tZk6djj
	w6Q3IhbveqteTllIg1FGx7N30VDM5RGkPgTvZnioC+4LtP6xmYhv211owfiqVeY599Y=
X-Gm-Gg: AeBDiet1r0blgSScoY4yKdM9zHp/vm7wAwB4nE2cRgDLBYEDbkyTdgMf5GTTZLwo+EY
	ZwdQ37FaFZqtM18U/8jvzAzfnKIld5pLxfrrAIE6T5QTRRcJIf1PtwTkvNjqTHhPKNg7A+5VjDJ
	xEz6quSsEupzFSAVnSZebOqTH6Q7+yOeaUr7ibuzDraUnhiZUIaRGtDtzreTOZtPlFL0xOzFtQH
	HrDCJUdrjpwR3ZRSKuGi77ztVwO75hz2lnX0pw9KR9Fb70zr5J8yEku0OtovWx8dlQ8WlLlbWFy
	Dkb+pbLedDHxH8GyLFMYE2I13RNXi7bQdz/2bJsKFlYs5bP0jIGOwJAgWsRoZSJGr7Xde5Rj7om
	kmp4LSpu9eAEF64gr7E5s844XXPxDrAObhPMWoLY3uI87Gd0Z5Fe7kmIbsvTJpKFqbWHXV17olk
	vTIPKxBqmGz8vVt6alFBBVTNNt9//EULVZkThUDfwMaYwdh135mgro6fkQ1zKegAM9WF5BZ+i69
	p4zmDcNGA4zBqBvAA8ydqTDbroPD7w=
X-Received: by 2002:a05:600c:a105:b0:485:3a03:ceca with SMTP id 5b1f17b1804b1-488fb7826femr289011485e9.23.1776978375112;
        Thu, 23 Apr 2026 14:06:15 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ffad20f2sm268386685e9.0.2026.04.23.14.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 14:06:14 -0700 (PDT)
Date: Thu, 23 Apr 2026 22:06:12 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com,
	axboe@kernel.dk, linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daan De Meyer <daan@amutable.com>
Subject: Re: [PATCH v2] cdrom, scsi: sr: propagate read-only status to block
 layer via set_disk_ro()
Message-ID: <aeqJxCKP6nm4iZDQ@equinox>
References: <20260330133403.796330-1-daan@amutable.com>
 <20260422113206.246267-1-daan@amutable.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422113206.246267-1-daan@amutable.com>

On Wed, Apr 22, 2026 at 11:32:06AM +0000, Daan De Meyer wrote:
> The cdrom core never calls set_disk_ro() for a registered device, so
> BLKROGET on a CD-ROM device always returns 0 (writable), even when the
> drive has no write capabilities and writes will inevitably fail. This
> causes problems for userspace that relies on BLKROGET to determine
> whether a block device is read-only. For example, systemd's loop device
> setup uses BLKROGET to decide whether to create a loop device with
> LO_FLAGS_READ_ONLY. Without the read-only flag, writes pass through the
> loop device to the CD-ROM and fail with I/O errors. systemd-fsck
> similarly checks BLKROGET to decide whether to run fsck in no-repair
> mode (-n).
> 
> The write-capability bits in cdi->mask come from two different sources:
> CDC_DVD_RAM and CDC_CD_RW are populated by the driver from the MODE
> SENSE capabilities page (page 0x2A) before register_cdrom() is called,
> while CDC_MRW_W and CDC_RAM require the MMC GET CONFIGURATION command
> and were only probed by cdrom_open_write() at device open time. This
> meant that any attempt to compute the writable state from the full
> mask at probe time was incorrect, because the GET CONFIGURATION bits
> were still unset (and cdi->mask is initialized such that capabilities
> are assumed present).
> 
> Fix this by factoring the GET CONFIGURATION probing out of
> cdrom_open_write() into a new exported helper,
> cdrom_probe_write_features(), and having sr call it from sr_probe()
> right after get_capabilities() has populated the MODE SENSE bits.
> register_cdrom() then calls set_disk_ro() based on the full
> write-capability mask (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)
> so the block layer reflects the drive's actual write support. The
> feature queries used (CDF_MRW and CDF_RWRT via GET CONFIGURATION with
> RT=00) report drive-level capabilities that are persistent across
> media, so a single probe before register_cdrom() is sufficient and the
> redundant probe at open time is dropped.
> 
> With set_disk_ro() now accurate, the long-vestigial cd->writeable flag
> in sr can go: get_capabilities() used to set cd->writeable based on
> the same four mask bits, but because CDC_MRW_W and CDC_RAM default to
> "capability present" in cdi->mask and aren't touched by MODE SENSE,
> the condition that gated cd->writeable was always true, making it
> unconditionally 1. Replace the corresponding gate in sr_init_command()
> with get_disk_ro(cd->disk), which turns a previously no-op check into
> a real one and also catches kernel-internal bio writers that bypass
> blkdev_write_iter()'s bdev_read_only() check.
> 
> The sd driver (SCSI disks) does not have this problem because it
> checks the MODE SENSE Write Protect bit and calls set_disk_ro()
> accordingly. The sr driver cannot use the same approach because the
> MMC specification does not define the WP bit in the MODE SENSE
> device-specific parameter byte for CD-ROM devices.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Daan De Meyer <daan@amutable.com>

Hi Daan,

Thank you for the patch. I will properly review it and build test etc.
this weekend and come back to you, hope that's ok.

Regards,
Phil
