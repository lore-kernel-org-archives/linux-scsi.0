Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97F2C25B41
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 08:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjJWIac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 04:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjJWIaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 04:30:23 -0400
X-Greylist: delayed 58275 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Oct 2023 01:30:16 PDT
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BFD170B
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 01:30:16 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 799F640E0177;
        Mon, 23 Oct 2023 08:30:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kKGyltBpSyAv; Mon, 23 Oct 2023 08:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698049812; bh=BMJCMNnA4fp+7OLIRHf4dnEzo06QH1c0/PkmUgpUmUw=;
        h=Date:From:To:Cc:Subject:From;
        b=Fc/sSd8zg/frj9KyG3P5u3TLmtP8OhqDirBwAlHZH5xarMLxqX8OQ7Ex1Gk5+CyPN
         e3dmnpD3nh2KE/AeTO6NHGgduMcRbLTwC2CZgSdjQFCNZsovE0Nrur9GrZf45xGktG
         EJ+nRUrurxuKv18MJZHST/jHmqlUJ2sLjBOPcM4L+WZyWNKsmJnfKraEGBNmRnudy1
         qlMrFZDcacK+qAhmCLRgK8VvGAESzQRaLDeCjNA31up0LM7e/egWSiRUIPwHhk7CO3
         uRy6crHnYrtJ0Fjuo3FwHSxLxYXudNL59hWCO6wIz0D3icMsf/sT4XEgMPVJKSjaEb
         yY4NtlprU/7LyaDkB2vp+XyZl6lrSIubJyUp8s/e4getzBIGWDq4VKrdMcd71Z+FON
         mAw9ZruOOLgn2yW83lwzBFRGuPTVIi+hlWGSITnSb3kK8l7ia3LrOj4tLAxPBEHUZ9
         c32qdC314hHBTm9cOjbi9MxfV32ExZU6P4+LtpbeOCpLhSK5eqmNCRaeOYmHrC9VXO
         LDN7GiZJp5RqJHbpbKs8Fgh5d34GWhrSq1ApoujKA8m6Md2b9T4YJf5zzv++jFPDzl
         vsz7CUGagC5OUTsIO7XESHzXtU1RhAXpa298ouFRiyMo1uYRDrI/oMi61KftPaTTW8
         VHY8Y3xcSYk9V5uxAGAldgzM=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5FC3A40E0187;
        Mon, 23 Oct 2023 08:30:04 +0000 (UTC)
Date:   Mon, 23 Oct 2023 10:29:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: mpt3sas ubsan issues
Message-ID: <20231023082958.GAZTYvBlIB2UPUCUyA@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I don't know how much I would be able to test patches on this box since
it runs tests all the time but lemme report it still - someone might
want to reproduce it on their hw and say, ah, yes, I see it. :)

So this is with 6.6.0-rc7. And it floods dmesg with a lot more of those.

...
[   13.262385] mpt3sas_cm0: sense popage(0x000000006aab6fad) - dma(0xdebee000): size(512)
[   13.262517] mpt3sas_cm0: Allocated physical memory: size(40437 kB)
[   13.262519] mpt3sas_cm0: Current Controller Queue Depth(9460),Max Controller Queue Depth(9584)
[   13.262520] mpt3sas_cm0: Scatter Gather Elements per IO(128)
[   13.263057] usb usb3: Manufacturer: Linux 6.6.0-rc7-1698028227438 xhci-hcd
[   13.294499] mpt3sas_cm0: _base_display_fwpkg_version: complete
[   13.298770] usb usb3: SerialNumber: 0000:46:00.3
[   13.303908] mpt3sas_cm0: FW Package Ver(16.17.01.00)
[   13.309243] hub 3-0:1.0: USB hub found
[   13.314578] mpt3sas_cm0: LSISAS3008: FWVersion(16.00.11.00), ChipRevision(0x02)
[   13.319513] hub 3-0:1.0: 2 ports detected
[   13.324725] mpt3sas_cm0: Protocol=(
[   13.330802] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[   13.335195] Initiator
[   13.340449] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.06
[   13.345645] ,Target
[   13.350873] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.356100] ), Capabilities=(
[   13.361323] usb usb4: Product: xHCI Host Controller
[   13.365024] ata6: SATA link down (SStatus 0 SControl 300)
[   13.365056] ata5: SATA link down (SStatus 0 SControl 300)
[   13.365088] ata8: SATA link down (SStatus 0 SControl 300)
[   13.365121] ata2: SATA link down (SStatus 0 SControl 300)
[   13.365156] ata1: SATA link down (SStatus 0 SControl 300)
[   13.365190] ata4: SATA link down (SStatus 0 SControl 300)
[   13.365223] ata3: SATA link down (SStatus 0 SControl 300)
[   13.366549] TLR
[   13.369707] ata7: SATA link down (SStatus 0 SControl 300)
[   13.371778] usb usb4: Manufacturer: Linux 6.6.0-rc7-1698028227438 xhci-hcd
[   13.377001] ,EEDP,Snapshot Buffer
[   13.382227] usb usb4: SerialNumber: 0000:46:00.3
[   13.387452] ,Diag Trace Buffer
[   13.392812] AVX2 version of gcm_enc/dec engaged.
[   13.392828] hub 4-0:1.0: USB hub found
[   13.392837] hub 4-0:1.0: 2 ports detected
[   13.397903] ,Task Set Full,NCQ)
[   13.397938] ACPI: bus type drm_connector registered
[   13.399992] tg3 0000:c1:00.1 eno8403: renamed from eth1
[   13.415815] usb 1-1: New USB device found, idVendor=0424, idProduct=2744, bcdDevice= 1.21
[   13.418864] scsi host0: Fusion MPT SAS Host
[   13.424033] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   13.424035] usb 1-1: Product: USB2734
[   13.430904] mpt3sas_cm0: sending port enable !!
[   13.434486] usb 1-1: Manufacturer: Microchip Tech
[   13.465838] AES CTR mode by8 optimization enabled
[   13.507930] hub 1-1:1.0: USB hub found
[   13.513067] ================================================================================
[   13.513276] mpt3sas_cm0: hba_port entry: 000000008c1f0b7e, port: 255 is added to hba_port list
[   13.513480] ===============================================================================1698028227438 #1
[   13.513489] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 2.3.6 07/06/2021
[   13.513490] Workqueue: fw_event_mpt3sas0 _firmware_event_work [mpt3sas]
[   13.513512] Call Trace:
[   13.513514]  <TASK>
[   13.513516]  dump_stack_lvl+0x4c/0x70
[   13.513521]  dump_stack+0x14/0x20
[   13.513523]  __ubsan_handle_out_of_bounds+0xa6/0xf0
[   13.513529]  _scsih_sas_host_add+0x5fc/0x660 [mpt3sas]
[   13.513544]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513549]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513550]  ? dequeue_entity+0x13f/0x530
[   13.513555]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513557]  ? psi_group_change+0x237/0x4e0
[   13.513561]  _firmware_event_work+0xd35/0x3380 [mpt3sas]
[   13.513572]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513575]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513577]  ? raw_spin_rq_unlock+0x14/0x40
[   13.513580]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513583]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513585]  ? __schedule+0x3cb/0x15d0
[   13.513590]  ? srso_alias_return_thunk+0x5/0x7f
[   13.513592]  ? complete+0x71/0x80
[   13.513595]  process_one_work+0x17b/0x350
[   13.513600]  worker_thread+0x2f7/0x420
[   13.513603]  ? __pfx_worker_thread+0x10/0x10
[   13.513605]  kthread+0xfb/0x130
[   13.513608]  ? __pfx_kthread+0x10/0x10
[   13.513611]  ret_from_fork+0x40/0x60
[   13.513615]  ? __pfx_kthread+0x10/0x10
[   13.513617]  ret_from_fork_asm+0x1b/0x30
[   13.513625]  </TASK>
[   13.513626] ================================================================================
[   13.514519] mpt3sas_cm0: host_add: handle(0x0001), sas_addr(0x52cea7f0be87d800), phys(8)
[   13.518324] hub 1-1:1.0: 4 ports detected
[   13.523322] UBSAN: array-index-out-of-bounds in drivers/scsi/mpt3sas/mpt3sas_scsih.c:4667:12
[   13.523328] index 1 is out of range for type 'MPI2_EVENT_SAS_TOPO_PHY_ENTRY [1]'
[   13.528940] mpt3sas_cm0: port enable: SUCCESS
[   13.533773] CPU: 72 PID: 0 Comm: swapper/72 Not tainted 6.6.0-rc7-1698028227438 #1
[   13.533780] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 2.3.6 07/06/2021
[   13.533782] Call Trace:
[   13.533785]  <IRQ>
[   13.533789]  dump_stack_lvl+0x4c/0x70
[   13.569068] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[   13.570363]  dump_stack+0x14/0x20
[   13.584973] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[   13.586031]  __ubsan_handle_out_of_bounds+0xa6/0xf0
[   13.593325] usb 2-1: New USB device found, idVendor=0424, idProduct=5744, bcdDevice= 1.21
[   13.596484]  ? vmemmap_populate_print_last+0x41/0x80
[   13.601713] usb 2-1: New USB device strings: Mfr=2, Product=3, SerialNumber=0
[   13.606937]  ? _scsih_fw_event_add.part.0+0xd3/0x140 [mpt3sas]
[   13.612161] usb 2-1: Product: USB5734
[   13.617391]  mpt3sas_scsih_event_callback+0xec6/0x1000 [mpt3sas]
[   13.622613] usb 2-1: Manufacturer: Microchip Tech
[   13.627843]  _base_process_reply_queue+0x59c/0x12a0 [mpt3sas]
[   13.658851] hub 2-1:1.0: USB hub found
[   13.659178]  _basndle_edge_irq+0x90/0x240
[   13.738365] usb 3-1: New USB device found, idVendor=1604, idProduct=10c0, bcdDevice= 0.00
[   13.742754]  __common_interrupt+0x55/0x100
[   13.742760]  common_interrupt+0x85/0xa0
[   13.747995] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.753217]  </IRQ>
[   13.753219]  <TASK>
[   13.753223]  asm_common_interrupt+0x2b/0x40
[   13.791656] hub 3-1:1.0: USB hub found
[   13.792360] RIP: 0010:cpuidle_enter_state+0xde/0x710
[   13.799978] hub 3-1:1.0: 4 ports detected
[   13.807745] Code: 54 0b ff e8 d4 f5 ff ff 8b 53 04 49 89 c7 0f 1f 44 00 00 31 ff e8 32 2f 0a ff 80 7d d0 00 0f 85 50 02 00 00 fb 0f 1f 44 00 00 <45> 85 f6 0f 88 e6 01 00 00 4d 63 ee 49 83 fd 09 0f 87 03 05 00 00
[   13.807749] RSP: 0018:ffffba41005cfe28 EFLAGS: 00000246
[   14.527602] RAX: ffff9bd85fc34100 RBX: ffff9bf8843f3800 RCX: 0000000000000000
[   14.534733] RDX: 0000000000000048 RSI: 0000000000000002 RDI: 0000000000000000
[   14.537460] usb 3-1.1: new high-speed USB device number 3 using xhci_hcd
[   14.541867] RBP: ffffba41005cfe78 R08: 000000032570bc57 R09: 00000049ef18ea00
[   14.541870] R10: 000000029a243a00 R11: 000001d1a94a2000 R12: ffffffffa1d12e40
[   14.541873] R13: 0000000000000002 R14: 0000000000000002 R15: 000000032570bc57
[   14.541883]  ? cpuidle_enter_state+0xce/0x710
[   14.574334]  cpuidle_enter+0x32/0x50
[   14.577921]  call_cpuidle+0x23/0x50
[   14.581421]  do_idle+0x1e7/0x240
[   14.584659]  ? srso_alias_return_thunk+0x5/0x7f
[   14.589196]  cpu_startup_entry+0x31/0x40
[   14.593130]  start_secondary+0x12d/0x160
[   14.597065]  secondary_startup_64_no_verify+0x17d/0x18b
[   14.602304]  </TASK>
[   14.604500] ================================================================================

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
