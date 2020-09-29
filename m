Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F052C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC451207C4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnHZ+04M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgI2KxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgI2KxT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 06:53:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5662DC061755
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:53:19 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t12so4385291ilh.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Bif4uQP4ud0IVC4ZhPgsF1wwhnpcs8sdMQUIko7U2bY=;
        b=DnHZ+04M4GJKBNDz+m7iCiwHgwlfly98g0hq2m1WapJsf4Byad36ex0LW1k/33K7XE
         aDcrWb2MIFsHtlTVJ4OUsWzuQ33/iLHfJDOYkZW+t/K4eN3xT7DQECFXUFlrtcKNO+3c
         gPmkk4aPs8b++n6B6Jc+4+dGkodlIcJOtevdDnMoYlgV47sIQBDWHv3o6QT5HKQKU1A5
         2ICKiXXF+YwsFTwDIOaiiZXT4eKLbOQP+BwUI/xbwaDSQqLh3ZsrexRQV/W6QyjDuvw+
         QhVgVioyezFPOGNyUcOPLOJjxyGfxVeEFvZyKmqaZ/p9kRyd90iIaiy1P3Lu0nP8m0nm
         lCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Bif4uQP4ud0IVC4ZhPgsF1wwhnpcs8sdMQUIko7U2bY=;
        b=jPNgzG1OvhlrKApb0TtPAzMr4NEgYAeCKVg8OYMs0RcELbPDjOv7hYpTmhCZpQHZOU
         7I+BHlZ4vVhnG9eSQy1fA7mfQhpTtBWfPTT2rO52FPMIqz+QCaGW73p+34McJ2Cdzil3
         +I/4XVoEFtH6FwlDPUzo/IB/HcvU52NBwEhvzwZpMmK/7zoAZqMU3YuSHFS1zXwdeziI
         Jq4YzqjWgpsVrXtgQiZtZ4RXwdk1hqQVlFc2bJ857SqS5mEEeicD4sHWwwbOAWUZhlEr
         XEA1zty7lcU/9M7I73+rE0vJ9vzRA2hr4CZMXfSTOQ7OW6lgCYzy28oRIlKed4X1KUL1
         tiVQ==
X-Gm-Message-State: AOAM53281gPaxQglEc2fNCdxqe7M0XCZXB8u1+D4g4ZSiwdLyiWncLEQ
        Geed5vYPlye8nncHRxW66rKLle2ZVCmolZO45Q6QEXDNdj7o7A==
X-Google-Smtp-Source: ABdhPJy93XRtEaoYoTk3FA/4XTN971JiEyr7oTJREPdww0K4FertKL6WXZZYmSF0rznSWrl0AH7PPOHh1IheIOL0O0k=
X-Received: by 2002:a92:1303:: with SMTP id 3mr2340797ilt.117.1601376798284;
 Tue, 29 Sep 2020 03:53:18 -0700 (PDT)
MIME-Version: 1.0
From:   Sundar Nagarajan <sun.nagarajan@gmail.com>
Date:   Tue, 29 Sep 2020 03:53:07 -0700
Message-ID: <CALnajPDasSABjqXBhzs+ACdsxQ02Nk4CoS26X_nYOuCfC-GJdg@mail.gmail.com>
Subject: Bug 209177 - mpt2sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry if I am mailing too many people.
Copying additional people in the hope that someone has the time to
guide me on how to report, debug and fix this bug in the 5.8 kernel.

bugzilla.kernel org bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=209177

Hardware:

Mainboard: Intel S2600CPj
SAS HBA card: LSI SAS9200-16e 16-port PCIe HBA
    VID:PID: 1000:0064

Problem: Does not detect any disks in enclosure
Works in: kernel 5.7.11 (stock, from kernel.org)

Kernel trace:

Sep 06 13:41:45 fili kernel: mpt2sas_cm0: scatter gather:
sge_in_main_msg(1), sge_per_chain(9), sge_per_io(128),
chains_per_io(15)
Sep 06 13:41:45 fili kernel: ------------[ cut here ]------------
Sep 06 13:41:45 fili kernel: WARNING: CPU: 0 PID: 13 at
mm/page_alloc.c:4831 __alloc_pages_nodemask+0x1ce/0x310
Sep 06 13:41:45 fili kernel: Modules linked in: crc32_pclmul
hid_generic(+) ghash_clmulni_intel usbhid igb(+) dca hid aesni_intel
mpt3sas(+) ptp crypto_simd ahci mlx4_core(+) raid_class cryptd
glue_helper x
Sep 06 13:41:45 fili kernel: CPU: 0 PID: 13 Comm: kworker/0:1 Not
tainted 5.8.6 #1
Sep 06 13:41:45 fili kernel: Hardware name: ZTSYSTEM CYPRESS11
/S2600CP   , BIOS SE5C600.86B.02.06.0006.032420170950 03/24/2017
Sep 06 13:41:45 fili kernel: Workqueue: events work_for_cpu_fn
Sep 06 13:41:45 fili kernel: RIP: 0010:__alloc_pages_nodemask+0x1ce/0x310
Sep 06 13:41:45 fili kernel: Code: ff ff ff 65 48 8b 04 25 c0 7b 01 00
48 05 78 08 00 00 41 bd 01 00 00 00 48 89 44 24 08 e9 05 ff ff ff 81
e7 00 20 00 00 75 02 <0f> 0b 45 31 ed eb 95 44 8b 64 24 18 65 8b 0
Sep 06 13:41:45 fili kernel: RSP: 0018:ffffacb9400fbc98 EFLAGS: 00010246
Sep 06 13:41:45 fili kernel: RAX: 0000000000000000 RBX:
0000000000000cc0 RCX: 0000000000000000
Sep 06 13:41:45 fili kernel: RDX: 0000000000000000 RSI:
000000000000000b RDI: 0000000000000000
Sep 06 13:41:45 fili kernel: RBP: 000000000075d000 R08:
000000000075d000 R09: ffffffffffffffff
Sep 06 13:41:45 fili kernel: R10: 0000000000000000 R11:
ffff9848de06b1e8 R12: ffffffffffffffff
Sep 06 13:41:45 fili kernel: R13: 0000000000000000 R14:
ffff9848ca1d65d8 R15: ffff9860d65130b0
Sep 06 13:41:45 fili kernel: FS:  0000000000000000(0000)
GS:ffff9848dea00000(0000) knlGS:0000000000000000
Sep 06 13:41:45 fili kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 06 13:41:45 fili kernel: CR2: 00005651c521b0e8 CR3:
0000001ed260a005 CR4: 00000000000606f0
Sep 06 13:41:45 fili kernel: Call Trace:
Sep 06 13:41:45 fili kernel:  dma_direct_alloc_pages+0x171/0x2a0
Sep 06 13:41:45 fili kernel:  dma_pool_alloc+0xd0/0x1c0
Sep 06 13:41:45 fili kernel:  base_alloc_rdpq_dma_pool+0x118/0x1d0 [mpt3sas]
Sep 06 13:41:45 fili kernel:  _base_allocate_memory_pools+0x2d6/0x1240 [mpt3sas]
Sep 06 13:41:45 fili kernel:  mpt3sas_base_attach+0x4a4/0x930 [mpt3sas]
Sep 06 13:41:45 fili kernel:  _scsih_probe+0x4e3/0x920 [mpt3sas]
Sep 06 13:41:45 fili kernel:  local_pci_probe+0x42/0x90
Sep 06 13:41:45 fili kernel:  work_for_cpu_fn+0x16/0x20
Sep 06 13:41:45 fili kernel:  process_one_work+0x208/0x400
Sep 06 13:41:45 fili kernel:  worker_thread+0x221/0x3e0
Sep 06 13:41:45 fili kernel:  ? process_one_work+0x400/0x400
Sep 06 13:41:45 fili kernel:  kthread+0x117/0x130
Sep 06 13:41:45 fili kernel:  ? kthread_park+0x90/0x90
Sep 06 13:41:45 fili kernel:  ret_from_fork+0x22/0x30
Sep 06 13:41:45 fili kernel: ---[ end trace 38d2eb3ff4b32c0c ]---
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: failure at
drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!


On kernel 5.8.6 - mpt[23]sas NOT working:
Only lines with mpt[23]sas:


Sep 06 13:41:45 fili kernel: Command line:
BOOT_IMAGE=/boot/vmlinuz-5.8.6 root=/dev/mapper/fili0-rootfs ro
console=ttyS0,115200n1 console=tty0 mpt2sas.msix_disable=1
mpt3sas.msix_disable=1
Sep 06 13:41:45 fili kernel: Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-5.8.6 root=/dev/mapper/fili0-rootfs ro
console=ttyS0,115200n1 console=tty0 mpt2sas.msix_disable=1
mpt3sas.msix_disable=1
Sep 06 13:41:45 fili kernel: mpt3sas version 34.100.00.00 loaded
Sep 06 13:41:45 fili kernel: mpt3sas 0000:02:00.0: can't disable ASPM;
OS doesn't have ASPM control
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: 64 BIT PCI BUS DMA
ADDRESSING SUPPORTED, total mem (197972228 kB)
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: CurrentHostPageSize is 0:
Setting default host page size to 4k
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: High IOPs queues : disabled
Sep 06 13:41:45 fili kernel: mpt2sas0: IO-APIC enabled: IRQ 54
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: iomem(0x00000000d1380000),
mapped(0x(____ptrval____)), size(16384)
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: ioport(0x0000000000002000), size(256)
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: CurrentHostPageSize is 0:
Setting default host page size to 4k
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: scatter gather:
sge_in_main_msg(1), sge_per_chain(9), sge_per_io(128),
chains_per_io(15)
Sep 06 13:41:45 fili kernel: Modules linked in: crc32_pclmul
hid_generic(+) ghash_clmulni_intel usbhid igb(+) dca hid aesni_intel
mpt3sas(+) ptp crypto_simd ahci mlx4_core(+) raid_class cryptd
glue_helper xhci_pci pps_core uas libahci i2c_algo_bit
xhci_pci_renesas scsi_transport_sas wmi usb_storage deflate
Sep 06 13:41:45 fili kernel:  base_alloc_rdpq_dma_pool+0x118/0x1d0 [mpt3sas]
Sep 06 13:41:45 fili kernel:  _base_allocate_memory_pools+0x2d6/0x1240 [mpt3sas]
Sep 06 13:41:45 fili kernel:  mpt3sas_base_attach+0x4a4/0x930 [mpt3sas]
Sep 06 13:41:45 fili kernel:  _scsih_probe+0x4e3/0x920 [mpt3sas]
Sep 06 13:41:45 fili kernel: mpt2sas_cm0: failure at
drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!


On kernel 5.7.11 - mpt[23]sas IS working
Only lines with mpt[23]sas:


Sep 06 13:49:36 fili kernel: Command line:
BOOT_IMAGE=/boot/vmlinuz-5.7.11 root=/dev/mapper/fili0-rootfs ro
console=ttyS0,115200n1 console=tty0 mpt2sas.msix_disable=1
mpt3sas.msix_disable=1
Sep 06 13:49:36 fili kernel: Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-5.7.11 root=/dev/mapper/fili0-rootfs ro
console=ttyS0,115200n1 console=tty0 mpt2sas.msix_disable=1
mpt3sas.msix_disable=1
Sep 06 13:49:36 fili kernel: mpt3sas version 33.100.00.00 loaded
Sep 06 13:49:36 fili kernel: mpt3sas 0000:02:00.0: can't disable ASPM;
OS doesn't have ASPM control
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: 64 BIT PCI BUS DMA
ADDRESSING SUPPORTED, total mem (197972264 kB)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: CurrentHostPageSize is 0:
Setting default host page size to 4k
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: High IOPs queues : disabled
Sep 06 13:49:36 fili kernel: mpt2sas0: IO-APIC enabled: IRQ 55
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: iomem(0x00000000d1380000),
mapped(0x(____ptrval____)), size(16384)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: ioport(0x0000000000002000), size(256)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: CurrentHostPageSize is 0:
Setting default host page size to 4k
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: scatter gather:
sge_in_main_msg(1), sge_per_chain(9), sge_per_io(128),
chains_per_io(15)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: request
pool(0x(____ptrval____)) - dma(0x17c9400000): depth(30127),
frame_size(128), pool_size(3765 kB)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: sense
pool(0x(____ptrval____))- dma(0x17c4c00000):
depth(29868),element_size(96), pool_size(2800 kB)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: config
page(0x(____ptrval____)) - dma(0x17c509c000): size(512)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: Allocated physical memory:
size(14663 kB)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: Current Controller Queue
Depth(29865),Max Controller Queue Depth(32455)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: Scatter Gather Elements per IO(128)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: overriding NVDATA EEDPTagMode setting
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: LSISAS2116:
FWVersion(20.00.06.00), ChipRevision(0x02), BiosVersion(00.00.00.00)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: Protocol=(Initiator,Target),
Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set
Full,NCQ)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: sending port enable !!
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: host_add: handle(0x0001),
sas_addr(0x500062b20038b300), phys(16)
Sep 06 13:49:36 fili kernel: mpt2sas_cm0: expander_add:
handle(0x0011), parent(0x0001), sas_addr(0x5001940000d2c23f), phys(25)
Sep 06 13:49:37 fili kernel: mpt2sas_cm0: port enable: SUCCESS
