Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1189C4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 19:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CD62083B
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 19:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgI2T7S convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 15:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgI2T7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 15:59:18 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date:   Tue, 29 Sep 2020 19:59:17 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sun.nagarajan@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209177-11613-OSE9e4xQRI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209177

--- Comment #1 from sun.nagarajan@gmail.com ---
Kernel version 5.8.12 with the following patches were suggested by Suganath
Prabu Subramani on Sep-29-2020:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/scsi/mpt3sas?h=v5.9-rc4&id=61e6ba03ea26f0205e535862009ff6ffdbf4de0c
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/scsi/mpt3sas?h=v5.9-rc4&id=f56577e8c7d0f3054f97d1f0d1cbe9a4d179cc47

I built kernel version 5.8.12, and these patches were already applied.

The problem still exists.
EDITED dmesg output below:

[   10.110816] mpt2sas_cm0: mpt3sas_base_attach
[   10.110913] dca service started, version 1.12.1
[   10.122668] mpt2sas_cm0: mpt3sas_base_map_resources
[   10.140735] usb 2-1.7: New USB device found, idVendor=1546, idProduct=01a6,
bcdDevice= 7.03
[   10.147693] scsi host2: ahci
[   10.163432] usb 2-1.7: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[   10.173819] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem
(197972228 kB)
[   10.189366] usb 2-1.7: Product: u-blox 6  -  GPS Receiver
[   10.206466] mpt2sas_cm0: _base_get_ioc_facts
[   10.219986] usb 2-1.7: Manufacturer: u-blox AG - www.u-blox.com
[   10.246805] mpt2sas_cm0: _base_wait_for_iocstate
[   10.260177] scsi host3: ahci
[   10.271074] scsi host4: ahci
[   10.281958] scsi host5: ahci
[   10.292565] scsi host6: ahci
[   10.299138] usb 2-1.8: new full-speed USB device number 6 using ehci-pci
[   10.303153] scsi host7: ahci
[   10.328158] ata1: SATA max UDMA/133 abar m2048@0xd1700000 port 0xd1700100
irq 53
[   10.343989] ata2: SATA max UDMA/133 abar m2048@0xd1700000 port 0xd1700180
irq 53
[   10.359546] ata3: SATA max UDMA/133 abar m2048@0xd1700000 port 0xd1700200
irq 53
[   10.374807] ata4: SATA max UDMA/133 abar m2048@0xd1700000 port 0xd1700280
irq 53
[   10.389813] ata5: SATA max UDMA/133 abar m2048@0xd1700000 port 0xd1700300
irq 53
[   10.404635] ata6: SATA max UDMA/133 abar m2048@0xd1700000 port 0xd1700380
irq 53
[   10.412371] scsi 0:0:0:0: Direct-Access     SanDisk  Ultra Fit        1.00
PQ: 0 ANSI: 6
[   10.433718] usb 2-1.8: New USB device found, idVendor=051d, idProduct=0003,
bcdDevice= 1.06
[   10.435546] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.450887] usb 2-1.8: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   10.464152]  offset:data
[   10.478544] usb 2-1.8: Product: Smart-UPS 2200 FW:UPS 06.3 / MCU 11.0
[   10.488004] mpt2sas_cm0:     [0x00]:03100200
[   10.488004] mpt2sas_cm0:     [0x04]:00002300
[   10.488005] mpt2sas_cm0:     [0x08]:00000000
[   10.488005] mpt2sas_cm0:     [0x0c]:00000000
[   10.488006] mpt2sas_cm0:     [0x10]:00000000
[   10.488007] mpt2sas_cm0:     [0x14]:00010080
[   10.488007] mpt2sas_cm0:     [0x18]:22137ec7
[   10.488008] mpt2sas_cm0:     [0x1c]:0001285c
[   10.488017] mpt2sas_cm0:     [0x20]:14000600
[   10.501945] usb 2-1.8: Manufacturer: American Power Conversion
[   10.501961] usb 2-1.8: SerialNumber: JS1051006712  
[   10.513140] mpt2sas_cm0:     [0x24]:00000020
[   10.513140] mpt2sas_cm0:     [0x28]:04000020
[   10.513141] mpt2sas_cm0:     [0x2c]:00810080
[   10.513141] mpt2sas_cm0:     [0x30]:007f0003
[   10.513142] mpt2sas_cm0:     [0x34]:0020ffe0
[   10.513154] mpt2sas_cm0:     [0x38]:008004b0
[   10.513154] mpt2sas_cm0:     [0x3c]:00000011
[   10.513155] mpt2sas_cm0:     [0x40]:00000000
[   10.513156] mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page
size to 4k
[   10.524350] sd 0:0:0:0: [sda] 30031250 512-byte logical blocks: (15.4
GB/14.3 GiB)
[   10.535178] mpt2sas_cm0: CurrentHostPageSize(0)
[   10.548205] sd 0:0:0:0: [sda] Write Protect is off
[   10.556610] mpt2sas_cm0: hba queue depth(32455), max chains per io(128)
[   10.566972] sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
[   10.577132] mpt2sas_cm0: request frame size(128), reply frame size(128)
[   10.589074] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled,
doesn't support DPO or FUA
[   10.597175] mpt2sas_cm0: msix is supported, vector_count(1)
[   10.692084] hid: raw HID events driver (C) Jiri Kosina
[   10.692148] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.6.0-k
[   10.692149] igb: Copyright (c) 2007-2014 Intel Corporation.
[   10.705215] mpt2sas_cm0: MSI-X vectors supported: 1
[   10.705216]   no of cores: 32, max_msix_vectors: -1
[   10.705217] mpt2sas_cm0:  0 1
[   10.705359] mpt2sas_cm0: High IOPs queues : disabled
[   10.757534] ata4: SATA link down (SStatus 0 SControl 300)
[   10.761609] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 56
[   10.761611] mpt2sas_cm0: iomem(0x00000000d1380000),
mapped(0x(____ptrval____)), size(16384)
[   10.761613] mpt2sas_cm0: ioport(0x0000000000002000), size(256)
[   10.781648] ata1: SATA link down (SStatus 0 SControl 300)
[   10.793026] mpt2sas_cm0: _base_get_ioc_facts
[   10.804281] ata6: SATA link down (SStatus 0 SControl 300)
[   10.817492] mpt2sas_cm0: _base_wait_for_iocstate
[   10.821742] usbcore: registered new interface driver usbhid
[   10.821743] usbhid: USB HID core driver
[   10.829361] ata3: SATA link down (SStatus 0 SControl 300)
[   10.906674]  offset:data
[   10.917639] ata5: SATA link down (SStatus 0 SControl 300)
[   10.917791] input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:046B:FF10.0001/input/input2
[   10.917893] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10
Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1d.0-1.4/input0
[   10.918019] input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:046B:FF10.0002/input/input3
[   10.918245] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10
Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1d.0-1.4/input1
[   10.918692] hid-generic 0003:051D:0003.0003: hiddev0,hidraw2: USB HID v1.00
Device [American Power Conversion Smart-UPS 2200 FW:UPS 06.3 / MCU 11.0] on
usb-0000:00:1d.0-1.8/input0
[   10.925117] random: fast init done
[   10.929067] mpt2sas_cm0:     [0x00]:03100200
[   10.939600] ata2: SATA link down (SStatus 0 SControl 300)
[   10.951294] mpt2sas_cm0:     [0x04]:00002300
[   10.984639]  sda: sda1 sda2 sda3
[   10.985180] mpt2sas_cm0:     [0x08]:00000000
[   11.005873] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   11.006343] mpt2sas_cm0:     [0x0c]:00000000
[   11.285853] mpt2sas_cm0:     [0x10]:00000000
[   11.298311] mpt2sas_cm0:     [0x14]:00010080
[   11.310617] mpt2sas_cm0:     [0x18]:22137ec7
[   11.322831] mpt2sas_cm0:     [0x1c]:0001285c
[   11.334964] mpt2sas_cm0:     [0x20]:14000600
[   11.347072] mpt2sas_cm0:     [0x24]:00000020
[   11.359060] mpt2sas_cm0:     [0x28]:04000020
[   11.370880] mpt2sas_cm0:     [0x2c]:00810080
[   11.382482] mpt2sas_cm0:     [0x30]:007f0003
[   11.393927] mpt2sas_cm0:     [0x34]:0020ffe0
[   11.405226] mpt2sas_cm0:     [0x38]:008004b0
[   11.416400] mpt2sas_cm0:     [0x3c]:00000011
[   11.427427] mpt2sas_cm0:     [0x40]:00000000
[   11.438335] mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page
size to 4k
[   11.453888] mpt2sas_cm0: CurrentHostPageSize(0)
[   11.465416] mpt2sas_cm0: hba queue depth(32455), max chains per io(128)
[   11.479358] mpt2sas_cm0: request frame size(128), reply frame size(128)
[   11.493291] mpt2sas_cm0: _base_make_ioc_ready
[   11.507135] mpt2sas_cm0: _base_get_port_facts
[   11.519349] igb 0000:07:00.0: added PHC on eth0
[   11.530468] igb 0000:07:00.0: Intel(R) Gigabit Ethernet Network Connection
[   11.544129] igb 0000:07:00.0: eth0: (PCIe:5.0Gb/s:Width x4)
00:1e:67:97:4d:e9
[   11.558034] igb 0000:07:00.0: eth0: PBA No: 100000-000
[   11.569355] igb 0000:07:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx
queue(s)
[   11.616691]  offset:data
[   11.624765] mpt2sas_cm0:     [0x00]:05070000
[   11.634321] mpt2sas_cm0:     [0x04]:00000000
[   11.643579] mpt2sas_cm0:     [0x08]:00000000
[   11.652537] mpt2sas_cm0:     [0x0c]:00000000
[   11.661248] mpt2sas_cm0:     [0x10]:00000000
[   11.669892] mpt2sas_cm0:     [0x14]:00003000
[   11.678382] mpt2sas_cm0:     [0x18]:00000100
[   11.686741] mpt2sas_cm0: _base_allocate_memory_pools
[   11.696171] mpt2sas_cm0: scatter gather: sge_in_main_msg(1),
sge_per_chain(9), sge_per_io(128), chains_per_io(15)
[   11.715890] ------------[ cut here ]------------
[   11.725227] WARNING: CPU: 0 PID: 5 at mm/page_alloc.c:4831
__alloc_pages_nodemask+0x1ce/0x310
[   11.739330] Modules linked in: fjes(-) hid_generic usbhid hid
crct10dif_pclmul igb(+) crc32_pclmul ghash_clmulni_intel dca aesni_intel ptp
ahci crypto_simd mpt3sas(+) pps_core xhci_pci cryptd mlx4_core(+) raid_class
i2c_algo_bit libahci xhci_pci_renesas glue_helper scsi_transport_sas wmi uas
usb_storage deflate
[   11.791023] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.8.12 #1
[   11.803622] Hardware name: ZTSYSTEM CYPRESS11      /S2600CP   , BIOS
SE5C600.86B.02.06.0006.032420170950 03/24/2017
[   11.827610] Workqueue: events work_for_cpu_fn
[   11.838884] RIP: 0010:__alloc_pages_nodemask+0x1ce/0x310
[   11.851367] Code: ff ff ff 65 48 8b 04 25 c0 7b 01 00 48 05 78 08 00 00 41
bd 01 00 00 00 48 89 44 24 08 e9 05 ff ff ff 81 e7 00 20 00 00 75 02 <0f> 0b 45
31 ed eb 95 44 8b 64 24 18 65 8b 05 1f a6 7a 4b 89 c0 48
[   11.893686] RSP: 0018:ffffc18e000bbc98 EFLAGS: 00010246
[   11.906822] RAX: 0000000000000000 RBX: 0000000000000cc0 RCX:
0000000000000000
[   11.922228] RDX: 0000000000000000 RSI: 000000000000000b RDI:
0000000000000000
[   11.937510] RBP: 000000000075d000 R08: 000000000075d000 R09:
ffffffffffffffff
[   11.952755] R10: 0000000000000000 R11: ffff9e6a16c22350 R12:
ffffffffffffffff
[   11.967942] R13: 0000000000000000 R14: ffff9e5215c34f58 R15:
ffff9e52163590b0
[   11.983165] FS:  0000000000000000(0000) GS:ffff9e521ea00000(0000)
knlGS:0000000000000000
[   11.999566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.013320] CR2: 000055c7853e9ef0 CR3: 00000003d620a003 CR4:
00000000000606f0
[   12.028719] Call Trace:
[   12.038777]  dma_direct_alloc_pages+0x171/0x2a0
[   12.051185]  dma_pool_alloc+0xd0/0x1c0
[   12.062585]  base_alloc_rdpq_dma_pool+0x118/0x1d0 [mpt3sas]
[   12.076131]  _base_allocate_memory_pools+0x2d6/0x1240 [mpt3sas]
[   12.090232]  mpt3sas_base_attach+0x4a4/0x930 [mpt3sas]
[   12.103599]  _scsih_probe+0x4e3/0x920 [mpt3sas]
[   12.116383]  local_pci_probe+0x42/0x90
[   12.128401]  work_for_cpu_fn+0x16/0x20
[   12.140466]  process_one_work+0x208/0x400
[   12.152910]  worker_thread+0x221/0x3e0
[   12.165053]  ? process_one_work+0x400/0x400
[   12.177573]  kthread+0x117/0x130
[   12.188759]  ? kthread_park+0x90/0x90
[   12.200400]  ret_from_fork+0x22/0x30
[   12.211748] ---[ end trace 1d2f9a5394100a7e ]---
[   12.224134] mpt2sas_cm0: mpt3sas_base_free_resources
[   12.237582] mpt2sas_cm0: _base_make_ioc_ready
[   12.249253] mpt2sas_cm0: mpt3sas_base_unmap_resources
[   12.264417] igb 0000:07:00.1: added PHC on eth1
[   12.276024] igb 0000:07:00.1: Intel(R) Gigabit Ethernet Network Connection
[   12.290184] igb 0000:07:00.1: eth1: (PCIe:5.0Gb/s:Width x4)
00:1e:67:97:4d:ea
[   12.304604] igb 0000:07:00.1: eth1: PBA No: 100000-000
[   12.316624] igb 0000:07:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx
queue(s)
[   12.331505] mpt2sas_cm0: _base_release_memory_pools
[   12.343209] mpt2sas_cm0: failure at
drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!

-- 
You are receiving this mail because:
You are on the CC list for the bug.
