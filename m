Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3615B578;
	Wed, 15 May 2024 21:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715809835; cv=none; b=K+yLzFgr7MHnVctPMwZG8OnnBrOPycpw6VSpOId2/yo7Sh5DW3C9d/JwgdwcpFiWgXanH4257N4iS2goZPE8D7A6hQWZFQaoBTYNNCdY3hAdH2lesNB+3Nnr7ez+Eqw11lNfRQPRU1HAmUe6a3ChlJgn26/AdKg83aFD6Ak6nl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715809835; c=relaxed/simple;
	bh=Tff5kjhuUPpvzAAyUre0AKdN3xDtZWwVcKkQINGkUDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZUM/ouNloqp+/smoAi5SQYo2tN7V8ZuABPi/wDqq7BEgrhImyLL+PPvSg/eRTQdGKAWy+3UbknWad7PN1c2sDALGf8quu1+sOAFM6NqsuhjmBuxAJMwgbN69mbJRGPhSaSk7Ue6wwj6dWRdzKAqZUhlWM8iWRF2ZU0qgirRx4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHh8ismu; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHh8ismu"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ec4dc64c6cso53602995ad.0;
        Wed, 15 May 2024 14:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715809833; x=1716414633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TUuTliHGjG8EepapSs2g5/Z8liXHlvUYXr6xFZTnQ/s=;
        b=aHh8ismud9tYuh2y2103OmS7AAkajLr8vEzIn+QEx+qyBfX9yuztIPMUsmOz0n4TB6
         A/j8FZPYlwf59zyq/hcC01qpClWBC91lGuqaxIzY3K1S0dvVU14aUi3iEnk1MUrRaJ2o
         JpNXUwv4/2FMoeydTPZsJ/pOJl//kPD4EZWVQaD+a7yyG5iZlbjgvF8GtYPqtuSc+Cac
         j/ddIvlzw6L2DjfLG+rrdyp05YY2liz10wKJTQdzrEx8MDx2ZJ++eTeFb5MpaguTZWkZ
         ly3RmcgAyP+tx08RAfUrSFa5nOo6wBMoutTR8swsEri2+YHl3XfUSIep9IVaUcV8aanQ
         TSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715809833; x=1716414633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TUuTliHGjG8EepapSs2g5/Z8liXHlvUYXr6xFZTnQ/s=;
        b=jifq8oQFwy2yFdcZo825mftoXz+bXkJfMsQtUxMRIG1ZGESFccaVvceqWEqO3mxd5L
         zf5i6UUNHL3PtD4KghN31Z9zyjazD17dd0waHpuR96mnLCUe9Fe/rDGBTfPVmO+Iv+49
         6saC8kCHHHUJ3Eocfu7J2+FrMbkb3Ivas4gXrjHC6b2tYG/AGM5jyi7rFFG1QxRYuAWR
         7gWAixUv62Fn4mNDw8/v77GtZVurnor/Fb8aQdmlgurqJaWu1iHCsN4X5OSlis7zVE00
         wH8w+oRfMgqQD6EPzZIieW3Z6TbRrSvNfF8n9ymgztxG+bS38/eSU8DAQOIwrGInAr0a
         8Dqg==
X-Forwarded-Encrypted: i=1; AJvYcCVgNCWu3RxXMBGgKwVO+DRv0m62Kn0fJP8gosI2kFnWkw6D2KWroRjBZ6zho6XPDFDlyAwUaRW4L8EK5ZaiynyGeWVZbcC54DOMoMOr483USHYdUeVGi1JOwR/uUTwFwIiw048xzNSO0syL+Yjp2BnCR/V30b26yCo2LoBVGN3xQvUWCMH69NWWLGpFHEKJ2tuqiaXvOAzP0pfmGG+ap1hkPvCp34lTgUpq3NWqkja1757sp9Mk4+lhu/XLvGR7lJg=
X-Gm-Message-State: AOJu0YzNbXzgEtlE13kZRwdtmm8zjqLYr+kTIyOYI2MhcJvgTCd5c6iX
	2sPVDkPv3vrrEC14h7vEkNWDG2qWgwPDqf39QmVpLOvhs4jHOF9bBki01Q==
X-Google-Smtp-Source: AGHT+IElqBOAOz5admZx87XGJtYd5m2pfahWSbve4lpZztwOeNSBe/vb8uRMxRnWFMyzO99p2f7atQ==
X-Received: by 2002:a17:902:aa03:b0:1ec:5f64:6e74 with SMTP id d9443c01a7336-1ef43d29b65mr185610635ad.23.1715809832960;
        Wed, 15 May 2024 14:50:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d164dsm122822315ad.52.2024.05.15.14.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 14:50:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 15 May 2024 14:50:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
Message-ID: <ce2bf6af-4382-4fe1-b392-cc6829f5ceb2@roeck-us.net>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409143748.980206-5-hch@lst.de>

Hi,

On Tue, Apr 09, 2024 at 04:37:29PM +0200, Christoph Hellwig wrote:
> Turn __scsi_init_queue into scsi_init_limits which initializes
> queue_limits structure that can be passed to blk_mq_alloc_queue.
> 

With this patch in linux mainline, I see

ata2: found unknown device (class 0)
ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
------------[ cut here ]------------
WARNING: CPU: 0 PID: 27 at block/blk-settings.c:202 blk_validate_limits+0x28c/0x304
Modules linked in:
CPU: 0 PID: 27 Comm: kworker/u4:2 Not tainted 6.9.0-05151-g1b294a1f3561 #1
Hardware name: PowerMac3,1 PPC970FX 0x3c0301 PowerMac
Workqueue: async async_run_entry_fn
NIP:  c0000000007ccec8 LR: c0000000007c805c CTR: 0000000000000000
REGS: c000000006def690 TRAP: 0700   Not tainted  (6.9.0-05151-g1b294a1f3561)
MSR:  8000000000028032 <SF,EE,IR,DR,RI>  CR: 84004228  XER: 20000000
IRQMASK: 0
GPR00: c0000000007c8040 c000000006def930 c00000000159f900 c000000006defac8
GPR04: c00000000146e788 0000000000000000 0000000000000000 0000000000000100
GPR08: 0000000000000200 000000000000ff00 0000000000000000 0000000000004000
GPR12: 000000000fa82000 c000000003330000 c000000000116508 c0000000060c5c40
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000088
GPR20: 0000000000000000 c0000000026f2f40 c0000000025eeff0 0000000000000000
GPR24: c000000006defc80 c0000000031cb3a0 c000000002571c80 c000000006defac8
GPR28: c0000000033052e0 ffffffffffffffff 0000000000000010 c000000008f13df0
NIP [c0000000007ccec8] blk_validate_limits+0x28c/0x304
LR [c0000000007c805c] blk_alloc_queue+0xbc/0x344
Call Trace:
[c000000006def930] [c0000000007c8040] blk_alloc_queue+0xa0/0x344 (unreliable)
[c000000006def990] [c0000000007e2658] blk_mq_alloc_queue+0x60/0xf4
[c000000006defa60] [c000000000a7a260] scsi_alloc_sdev+0x280/0x464
[c000000006defb90] [c000000000a7a6b4] scsi_probe_and_add_lun+0x270/0x388
[c000000006defc60] [c000000000a7b070] __scsi_add_device+0x168/0x1b4
[c000000006defcc0] [c000000000b08fe0] ata_scsi_scan_host+0x294/0x39c
[c000000006defd80] [c000000000af7704] async_port_probe+0x6c/0x98
[c000000006defdb0] [c000000000120028] async_run_entry_fn+0x50/0x13c
[c000000006defe00] [c00000000010821c] process_one_work+0x2c0/0x828
[c000000006deff00] [c000000000109090] worker_thread+0x224/0x474
[c000000006deff90] [c000000000116658] kthread+0x158/0x17c

followed by

scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
usb 1-1: new full-speed USB device number 2 using ohci-pci
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
input: QEMU QEMU USB Keyboard as /devices/pci0000:f0/0000:f0:0d.0/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata2: WARNING: synchronous SCSI scan failed without making any progress, switching to async

and ultimately a boot hang. This is with the mac99 emulation in qemu.
The warning is always seen, the boot hang is seen when trying to boot
from ide/ata drive. Bisect log is attached.

Guenter

---
# bad: [1b294a1f35616977caddaddf3e9d28e576a1adbc] Merge tag 'net-next-6.10' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
# good: [a5131c3fdf2608f1c15f3809e201cf540eb28489] Merge tag 'x86-shstk-2024-05-13' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect start 'HEAD' 'a5131c3fdf26'
# good: [f8beae078c82abde57fed4a5be0bbc3579b59ad0] Merge tag 'gtp-24-05-07' of git://git.kernel.org/pub/scm/linux/kernel/git/pablo/gtp Pablo neira Ayuso says:
git bisect good f8beae078c82abde57fed4a5be0bbc3579b59ad0
# good: [ce952d8f0e9b58dc6a2bde7e47ca7fa7925583cc] Merge tag 'gpio-updates-for-v6.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux
git bisect good ce952d8f0e9b58dc6a2bde7e47ca7fa7925583cc
# bad: [113d1dd9c8ea2186d56a641a787e2588673c9c32] Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect bad 113d1dd9c8ea2186d56a641a787e2588673c9c32
# good: [a3d1f54d7aa4c3be2c6a10768d4ffa1dcb620da9] Merge tag 'for-6.10-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect good a3d1f54d7aa4c3be2c6a10768d4ffa1dcb620da9
# bad: [f92141e18c8b466027e226f3388de15b059b6f65] Merge patch series "convert SCSI to atomic queue limits, part 1 (v3)"
git bisect bad f92141e18c8b466027e226f3388de15b059b6f65
# good: [0e0a4da35284c85225e3b128912582ebc73256c8] Merge patch series "scsi: ufs: Remove overzealous memory barriers"
git bisect good 0e0a4da35284c85225e3b128912582ebc73256c8
# bad: [a25a9c85d17fd2f19bd5a2bb25b8361d72336bc7] scsi: libata: Switch to using ->device_configure
git bisect bad a25a9c85d17fd2f19bd5a2bb25b8361d72336bc7
# bad: [6248d7f7714f018f2c02f356582784e74596f8e8] scsi: core: Add a no_highmem flag to struct Scsi_Host
git bisect bad 6248d7f7714f018f2c02f356582784e74596f8e8
# good: [33507b3964f136ea1592718cb81885c8f9354f65] scsi: ufs: qcom: Add sanity checks for gear/lane values during ICC scaling
git bisect good 33507b3964f136ea1592718cb81885c8f9354f65
# good: [4373d2ecca7fa7ad04aa9c371c80049bafec2610] scsi: bsg: Pass queue_limits to bsg_setup_queue()
git bisect good 4373d2ecca7fa7ad04aa9c371c80049bafec2610
# bad: [afd53a3d852808bfeb5bc3ae3cd1caa9389bcc94] scsi: core: Initialize scsi midlayer limits before allocating the queue
git bisect bad afd53a3d852808bfeb5bc3ae3cd1caa9389bcc94
# good: [9042fb6d2c085eccdf11069b04754dac807c36ea] scsi: mpi3mr: Pass queue_limits to bsg_setup_queue()
git bisect good 9042fb6d2c085eccdf11069b04754dac807c36ea
# first bad commit: [afd53a3d852808bfeb5bc3ae3cd1caa9389bcc94] scsi: core: Initialize scsi midlayer limits before allocating the queue
