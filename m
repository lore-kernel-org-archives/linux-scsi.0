From: Matthias Prager <linux@matthiasprager.de>
Subject: [BUG] mpt2sas: driver init fails on kernel >=4.2 for 9211-8i IT
Date: Sun, 20 Mar 2016 21:14:23 +0100
Message-ID: <56EF049F.6050809@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:40146 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbcCTUWZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Mar 2016 16:22:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Matthias Prager <linux@matthiasprager.de>

Hello,

I don't know what's the correct procedure, whether I should file a bug or first report this issue on the kernel mailing-list. So please feel free to tell me to open a ticket in the bugtracker (bugzilla.kernel.org?).

But first let me present the issue I encounter:

Kernels >= 4.2 (4.2.1 was the first on I tried, but also 4.3, 4.4 and 4.5) fail to load the mpt2sas driver on most (but not all) boots. Kernels <= 4.1.x work fine every single time (4.1.19 was the latest I tried, also 3.18.29).

Here is the dmesg output for a failed driver init with Kernel 4.5.0:
> [    2.068313] mpt3sas version 09.102.00.00 loaded
> [    2.069412] mpt2sas_cm0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (3074748 kB)
> [    2.125260] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: -1
> [    2.125996] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 58
> [    2.126199] mpt2sas_cm0: iomem(0x00000000fd4fc000), mapped(0xffffc900000d0000), size(16384)
> [    2.126430] mpt2sas_cm0: ioport(0x0000000000004000), size(256)
> [    2.216371] mpt2sas_cm0: Allocated physical memory: size(4964 kB)
> [    2.216600] mpt2sas_cm0: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
> [    2.217004] mpt2sas_cm0: Scatter Gather Elements per IO(128)
> [    5.086959] floppy0: no floppy controllers found
> [   32.256720] mpt2sas_cm0: _base_event_notification: timeout
> [   32.256940] mf:
> 
> [   32.257106] 07000000
> [   32.257302] 00000000
> [   32.257337] 00000000
> [   32.257533] 00000000
> [   32.257568] 00000000
> [   32.257764] 0f2f7fff
> [   32.257800] ffffff7c
> [   32.257995] ffffffff
> [   32.258031]
> 
> [   32.258352] ffffffff
> [   32.258387] 00000000
> [   32.258582] 00000000
> 
> [   32.258950] mpt2sas_cm0: sending message unit reset !!
> [   32.260688] mpt2sas_cm0: message unit reset: SUCCESS
> [   32.325956] mpt2sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:8592/_scsih_probe()!

For comparison here is a dmesg output for a successful boot on Kernel 4.1.15:
> [    2.035568] mpt2sas version 20.100.00.00 loaded
> [    2.037243] mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (2046352 kB)
> [    2.755374] mpt2sas0: MSI-X vectors supported: 1, no of cores: 3, max_msix_vectors: 8
> [    2.756377] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 58
> [    2.756708] mpt2sas0: iomem(0x00000000fd5fc000), mapped(0xffffc900000d0000), size(16384)
> [    2.757083] mpt2sas0: ioport(0x0000000000004000), size(256)
> [    3.842944] mpt2sas0: Allocated physical memory: size(4964 kB)
> [    3.843303] mpt2sas0: Current Controller Queue Depth(3307), Max Controller Queue Depth(3432)
> [    3.843717] mpt2sas0: Scatter Gather Elements per IO(128)
> [    4.415980] mpt2sas0: LSISAS2008: FWVersion(20.00.04.00), ChipRevision(0x03), BiosVersion(07.39.00.00)
> [    4.416618] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> [    4.417846] scsi host0: Fusion MPT SAS Host
> [    4.436865] mpt2sas0: sending port enable !!
> [    4.440460] mpt2sas0: host_add: handle(0x0001), sas_addr(0xxxxxxxxxxxxxxxxx), phys(8)
> 
> ...
> [    4.444045] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS5C302 A800 PQ: 0 ANSI: 6
> [    4.444338] scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0xxxxxxxxxxxxxxxxx), phy(1), device_name(0xxxxxxxxxxxxxxxxx)
> [    4.444823] scsi 0:0:0:0: SATA: enclosure_logical_id(0xxxxxxxxxxxxxxxxx), slot(2)
> [    4.445197] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> ... (n times for n drives)
> 
> [    4.515443] mpt2sas0: port enable: SUCCESS


The Controller(s) are all Avego/LSI 9211-8i running the latest version of IT firmware (v20.00.04.00). These are passed through to a gentoo-linux VM on an ESXi 5.1 host (latest patchlevel). I have two of these systems (one production one testing) with nearly identical hardware (Supermicro X8DTi-F boards with 2x Intel Westmere CPUs). I also have an older set of systems running the same software config (Intel S3200SHLC boards with single Core2Quad) which exhibit the same buggy behavior.

The 'uname -a' line on the current testing system looks like this:
> Linux pserver2 4.1.19-gentoo #4 SMP Thu Mar 17 16:02:48 CET 2016 x86_64 Intel(R) Xeon(R) CPU E5506 @ 2.13GHz GenuineIntel GNU/Linux
p

There seem to be other people with similar issues:
<https://bbs.archlinux.org/viewtopic.php?id=209495>

Any thoughts?

---
Matthias
