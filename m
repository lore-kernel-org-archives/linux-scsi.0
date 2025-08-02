Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F57156228
	for <linux-scsi@vger.kernel.org>; Sat,  2 Aug 2025 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754159488; cv=none; b=sA5gTPzzDq35qGEwirxMk2neCS06dwbaO+aeoCDP65SHNL/8hbtj1NmMR0+rsumq6QobREAXtrzB8Agp9nYNOQX2Mc2xnqoZ+GM+s2gFDSU/1tTC5758kIFwt4jwUH9G6mNYFZuKbmfWwwvEiZDB1YPfxD2U7kmQOICHbNoUOIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754159488; c=relaxed/simple;
	bh=eCoUAJtRcVqwcQwHB4q/m4f4+GkXYi3ABqY7728cjuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJaMZ+ryWpl8rIa+MK/04C5lnimujeTfKmEGLnaIxDNe24gzxK6Wr8P9M5iXbVyrVDta+zDRF9nc6Nav9LmsJRflv2sHty01BrvyIJ07QMAkFPQdDyV6zvTKszaCuulXnOItMQ7SgBJRLsbcHLR4Qe+bCGe+LU0ii4SPHdmnIPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=spTecSFc; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="spTecSFc"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-240718d5920so131875ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 Aug 2025 11:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754159486; x=1754764286; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQhFRK1wrqIiede85loSelnbm/P8/qfdIEcSdqEplEA=;
        b=spTecSFclmYxCLdYnFF9Bo1VQ63eylM6cvvC0BH5nzMdI+R95vLxBD+aj0tDZr8P5T
         1nkZpV+Rq/l6gO8rpZKU7uqgNxsB/+UcLKeNvg69OWkoLPds85EhMRlnMGDB+SLez334
         3srzx/MEJMtUDjJhfg49RCaOmQwOdVSdhv9HTQlWF/n63az+WxCY/HrBS5ZB42hTc8eU
         Xm4Cf7r9dh7MwI2QTzyeZ0q1yqd65uApnHRkRSF+NZU/LA/JGP/G23jXvhhCnYLlbcRw
         vkHU9TwrxdNpDvuFFEOIVZTCCefVDkN9KO2+f8XUn020WxvgTFDey4Me5KZadJcT0rgE
         YfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754159486; x=1754764286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQhFRK1wrqIiede85loSelnbm/P8/qfdIEcSdqEplEA=;
        b=rpqSGFVhrKcGpGxnc6SpXGiXe2RE7e4s/5h14pNOqfII6p8pSzdBYXGZG+l5DqlW/T
         uqfYjR16ct7rTidKrLbjDoA2gFQ+RcOHSFNeqH0bvOeCmlxvjR43LfnaUux4knlga1hW
         XZKbL0pZcC028XLEYNuL6OLnOS7RxtXWHr2WxIfT3pN6jn+ytSOyeaa53gpqAkh8nmao
         3cnL9MayP6Y7ODrY+CY4n1CtGYSa/m72R4UKwz6FmwbnIcvePqIMbdtw6/aVmBhtEz/x
         itBG004cJjNeM3uLolwMpgPxXmozNuXRBhwbmBUWLextencL7eZ05SBP3P6CMrPxOHqh
         4IWg==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+olf0DNKyN3ju2rRAFL4ud77wsEn20T/oYbIDYredjQ90ZBJRbb8YuTu8J0fZJ7P5sDv8lfVpQhI@vger.kernel.org
X-Gm-Message-State: AOJu0YwA5W3pDQr0CM1RJsSPeOzV4sykVUb0+9ZsaoucAvaxigAMZ5YU
	D5QVg3Iw36OrxaMWVv6JjONVPGRGT4Wmy+p/+TBB2/uqMBDdvRFEStsEqdOGzDxOGBLdoLSCQA/
	srctdqw==
X-Gm-Gg: ASbGncvbtHXrYOhnoXT0QYOHP2kFJqUwfu2FaswI6WoCl883UOMq+uzkEn0zjG4ZgTE
	a949StBhW5atccA/4vFRZUdoH7tVlrC9vBApfAf10/LkwCgOOrN32ashG04VEScDoXyXeKGWLEx
	aKxViqTBaHJUFPaLb1K9gddfcMJoWnasJEpaz33A0otqo6cOPJ85HN4nPTeTs+cP+4YrOcQDIFj
	2rPMX1VKaSxhM0QPPRwASZR2Xb3gZUYUIlVpH1FkVhMcEaTejoMXvTqqQWBKPMMAUeowjWS5m2p
	4QWSo/2GUbHQmNefEzmjN+oPyBSQeilleNTnKGmkKmIypXVhbKt8/Lp+EipIo42YbirI7J5wXfA
	0CI80X2NOmGquaxU2lei3/rJgt8x5MBivOhZDy0Z5UtMMcYJihl1vz65XhQ==
X-Google-Smtp-Source: AGHT+IEdqN+p9Xc+EYGJxqw2qS1KMUq6EIW88mU/Zl3lzxHloLCUx8G0wL0x4H1pEUBsb1dDaOVxRw==
X-Received: by 2002:a17:903:2290:b0:240:248f:15f2 with SMTP id d9443c01a7336-2424893ce77mr2471655ad.20.1754159485371;
        Sat, 02 Aug 2025 11:31:25 -0700 (PDT)
Received: from google.com (166.68.83.34.bc.googleusercontent.com. [34.83.68.166])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aca205sm71558715ad.193.2025.08.02.11.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 11:31:24 -0700 (PDT)
Date: Sat, 2 Aug 2025 11:31:20 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
Message-ID: <aI5ZeAweRWKQmLPU@google.com>
References: <20250717165606.3099208-2-cassel@kernel.org>
 <aHlpNRsPbmrTgv0O@google.com>
 <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>
 <aHrLBPunX8Fuv1zz@google.com>
 <70d2f593-3121-4684-8632-6a4ea1dc72ea@kernel.org>
 <5056b88b-0f42-4a02-906f-197492d76827@kernel.org>
 <aIAEdNN88utN4sQJ@google.com>
 <72881ac7-f276-49d6-8918-a81d41502d11@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72881ac7-f276-49d6-8918-a81d41502d11@kernel.org>

On Wed, Jul 23, 2025 at 10:38:56AM +0900, Damien Le Moal wrote:
> On 7/23/25 6:36 AM, Igor Pylypiv wrote:
> >>> And it works, I can see the drives in the enclosure behind the expander.
> >>> Care to send a proper path ?
> >>>
> >>> I think this needs more testing though, especially special cases like yanking
> >>> the SAS cable and doing device hotplug/unplug. Will do that later today.
> >>
> >> So I did that. And things are not pretty... Even a simple "rmmod pm80xx"
> >> crashes the kernel on a bad pointer dereference (invalid port address). Same if
> >> I hot-unplug drives from the enclosure. But that happens even with only Niklas
> >> revert patch applied. So I think that is unrelated to this change.
> >>
> >> That said, I will dig further to understand how the port pointers become
> >> invalid, and make sure this change is OK. Note that there are no issues that I
> >> can see when there is no expander (drives directly attached to the HBA).
> > 
> > Thank you for testing, Damien!
> > 
> > Just guessing, would defining the lldd_port_deformed() callback help?
> > The callback can set lldd_port to NULL if the problem is due to a dangling
> > lldd_port pointer.
> 
> Not sure if that is needed yet. The crash I am seeing is:
> 
> [56961.621080] BUG: unable to handle page fault for address: ff303500e1ee00ac
> [56961.629527] #PF: supervisor read access in kernel mode
> [56961.635315] #PF: error_code(0x0000) - not-present page
> [56961.641102] PGD 95e001067 P4D 95e002067 PUD 0
> [56961.646113] Oops: Oops: 0000 [#1] SMP
> [56961.650244] CPU: 10 UID: 0 PID: 3373 Comm: rmmod Not tainted 6.16.0-rc7+
> #380 PREEMPT(voluntary)
> [56961.660238] Hardware name: Supermicro SYS-520P-WTR/X12SPW-TF, BIOS 1.2
> 02/14/2022
> [56961.668664] RIP: 0010:do_raw_spin_lock+0xa/0xb0
> [56961.673776] Code: ff 48 c7 03 00 00 00 00 48 c7 43 10 ff ff ff ff 48 c7 43
> 08 ed 1e af de 48 83 c4 10 5b 5d c3 90 66 0f 1f 00 0f 1f 44 00 00 53 <8b> 47 04
> 48 89 fb 3d ad 4e ad de 75 41 48 8b 43 10 65 48 3b 05 4d
> [56961.694912] RSP: 0018:ff31e51a4f09fa60 EFLAGS: 00010082
> [56961.700799] RAX: 0000000000000000 RBX: 0000000000000046 RCX: 0000000000000000
> [56961.708841] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ff303500e1ee00a8
> [56961.716880] RBP: ff303500e1ee00a8 R08: 0000000000000001 R09: 0000000000000000
> [56961.724920] R10: 0000000000000000 R11: 0000000000000000 R12: ff303500e1ee0000
> [56961.732958] R13: ff303504f4f64000 R14: ff303504e1ee0000 R15: ff303504d9f60000
> [56961.740999] FS:  00007f126637a740(0000) GS:ff3035145d8ed000(0000)
> knlGS:0000000000000000
> [56961.750114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [56961.756590] CR2: ff303500e1ee00ac CR3: 00000001f2f38001 CR4: 0000000000773ef0
> [56961.765229] PKRU: 55555554
> [56961.768887] Call Trace:
> [56961.772249]  <TASK>
> [56961.775212]  _raw_spin_lock_irqsave+0x41/0x50
> [56961.780723]  ? sas_ata_end_eh+0x2f/0x60 [libsas]
> [56961.786532]  sas_ata_end_eh+0x2f/0x60 [libsas]
> [56961.792133]  sas_unregister_common_dev+0xc3/0x1a0 [libsas]
> [56961.798897]  sas_destruct_devices+0x9f/0xc0 [libsas]
> [56961.805073]  sas_deform_port.cold+0x83/0x288 [libsas]
> [56961.811330]  sas_unregister_ports+0x36/0x50 [libsas]
> [56961.817484]  sas_unregister_ha+0x56/0x90 [libsas]
> [56961.823343]  pm8001_pci_remove+0x28/0x160 [pm80xx]
> [56961.829315]  pci_device_remove+0x44/0xb0
> [56961.834287]  device_release_driver_internal+0x1a4/0x210
> [56961.840718]  driver_detach+0x4b/0x90
> [56961.845297]  bus_remove_driver+0x70/0xf0
> [56961.850265]  pci_unregister_driver+0x2f/0xb0
> [56961.855625]  pm8001_exit+0x10/0x28 [pm80xx]
> [56961.860909]  __x64_sys_delete_module+0x19e/0x2d0
> [56961.866650]  do_syscall_64+0x92/0x380
> [56961.871310]  ? __x64_sys_close+0x3d/0x80
> [56961.876246]  ? trace_hardirqs_on_prepare+0x77/0xa0
> [56961.882156]  ? do_syscall_64+0x154/0x380
> [56961.887081]  ? do_fault+0x3ef/0x720
> [56961.891510]  ? ___pte_offset_map+0x43/0x1c0
> [56961.896711]  ? ___pte_offset_map+0x24/0x1c0
> [56961.901901]  ? __handle_mm_fault+0x5f2/0x1140
> [56961.907278]  ? ksys_read+0x79/0xf0
> [56961.911570]  ? lock_acquire+0x280/0x2e0
> [56961.916339]  ? lock_acquire+0x280/0x2e0
> [56961.921103]  ? lock_release+0x222/0x2d0
> [56961.925865]  ? rcu_read_unlock+0x1c/0x60
> [56961.930720]  ? lock_release+0x222/0x2d0
> [56961.935476]  ? do_user_addr_fault+0x368/0x6a0
> [56961.940811]  ? trace_hardirqs_off+0x40/0xb0
> [56961.945936]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [56961.952031] RIP: 0033:0x7f1265d02a2b
> [56961.956444] Code: 73 01 c3 48 8b 0d dd 33 0f 00 f7 d8 64 89 01 48 83 c8 ff
> c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01
> f0 ff ff 73 01 c3 48 8b 0d ad 33 0f 00 f7 d8 64 89 01 48
> [56961.978361] RSP: 002b:00007ffe899f06c8 EFLAGS: 00000202 ORIG_RAX:
> 00000000000000b0
> [56961.987286] RAX: ffffffffffffffda RBX: 0000559d15a32750 RCX: 00007f1265d02a2b
> [56961.995727] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000559d15a327b8
> [56962.004170] RBP: 00007ffe899f06f0 R08: 0000000000000000 R09: 0000000000000000
> [56962.012612] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> [56962.021058] R13: 00007ffe899f1701 R14: 00007ffe899f0940 R15: 0000000000000000
> 
> So it is here:
> 
> void sas_ata_end_eh(struct ata_port *ap)
> {
>         struct domain_device *dev = ap->private_data;
>         struct sas_ha_struct *ha = dev->port->ha;
>         unsigned long flags;
> 
>         spin_lock_irqsave(&ha->lock, flags);
> 	...
> 
> Meaning that the ha pointer is broken...
> Not sure why yet, but I get the exact same place for the crash if I hot-unplug
> a drive from the enclosure. So something is wrong with removing devices when
> there is an expander. Still digging into it.
>

Hi Damien,

Do you happen to have any updates regarding this crash?

Thanks,
Igor
 
> -- 
> Damien Le Moal
> Western Digital Research
