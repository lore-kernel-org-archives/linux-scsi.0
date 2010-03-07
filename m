From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: mpt2sas: dma error?
Date: Sun, 7 Mar 2010 00:00:17 -0500
Message-ID: <87d699441003062100y1804b007t406adc4dfec99f46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43990 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0CGFAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2010 00:00:21 -0500
Received: by vws9 with SMTP id 9so2338554vws.19
        for <linux-scsi@vger.kernel.org>; Sat, 06 Mar 2010 21:00:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have an LSI 9211-4i card (aka SAS2004) with 4 drives attached. No
RAID-related setup in the card's BIOS, I'm just using the drives
directly. This is with kernel 2.6.33. The card starts up with

[    1.714458] mpt2sas version 03.100.03.00 loaded
[    1.714757] scsi0 : Fusion MPT SAS Host
[    1.715174]   alloc irq_desc for 16 on node -1
[    1.715175]   alloc kstat_irqs on node -1
[    1.715178] alloc irq_2_iommu on node -1
[    1.715184] mpt2sas 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.715431] mpt2sas 0000:05:00.0: setting latency timer to 64
[    1.715435] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED,
total mem (12387344 kB)
[    1.715939]   alloc irq_desc for 31 on node -1
[    1.715941]   alloc kstat_irqs on node -1
[    1.715943] alloc irq_2_iommu on node -1
[    1.715947] mpt2sas 0000:05:00.0: irq 31 for MSI/MSI-X
[    1.715960] mpt2sas0: PCI-MSI-X enabled: IRQ 31
[    1.716199] mpt2sas0: iomem(0xfaefc000),
mapped(0xffffc90001878000), size(16384)
[    1.716643] mpt2sas0: ioport(0xd000), size(256)
[    1.788476] mpt2sas0: sending diag reset !!
[    2.726738] mpt2sas0: diag reset: SUCCESS
[    2.772789] mpt2sas0: Allocated physical memory: size(839 kB)
[    2.773034] mpt2sas0: Current Controller Queue Depth(339), Max
Controller Queue Depth(2015)
[    2.773481] mpt2sas0: Scatter Gather Elements per IO(128)
[    2.831901] mpt2sas0: LSISAS2008: FWVersion(02.00.50.00),
ChipRevision(0x02), BiosVersion(07.01.00.00)
[    2.832360] mpt2sas0: Protocol=(Initiator,Target),
Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set
Full,NCQ)
[    2.833261] mpt2sas0: sending port enable !!
[    4.478515] mpt2sas0: host_add: handle(0x0001),
sas_addr(0x500605b0001d5848), phys(8)
[   11.712582] mpt2sas0: port enable: SUCCESS

which looks all happy. However it seems that running SMART commands
(like smartctl -a, smartmontools 5.39) on the drives attached results
in the following, semi-reliably:

[ 7069.168433] DRHD: handling fault status reg 2
[ 7069.168440] DMAR:[DMA Read] Request device [05:00.0] fault addr e0000
[ 7069.168442] DMAR:[fault reason 06] PTE Read access is not set
[ 7069.815775] mpt2sas0: fault_state(0x2665)!
[ 7069.815778] mpt2sas0: sending diag reset !!
[ 7070.754176] mpt2sas0: diag reset: SUCCESS
[ 7070.823523] mpt2sas0: LSISAS2008: FWVersion(02.00.50.00),
ChipRevision(0x02), BiosVersion(07.01.00.00)
[ 7070.823526] mpt2sas0: Protocol=(Initiator,Target),
Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set
Full,NCQ)
[ 7070.823818] mpt2sas0: sending port enable !!
[ 7079.740367] mpt2sas0: port enable: SUCCESS
[ 7079.740446] mpt2sas0: _scsih_search_responding_sas_devices
[ 7079.741023] scsi target0:0:0: handle(0x0009),
sas_addr(0x4433221100000000), enclosure logical
id(0x500605b0001d5848), slot(0)
[ 7079.741089] scsi target0:0:1: handle(0x000a),
sas_addr(0x4433221101000000), enclosure logical
id(0x500605b0001d5848), slot(1)
[ 7079.741154] scsi target0:0:2: handle(0x000b),
sas_addr(0x4433221103000000), enclosure logical
id(0x500605b0001d5848), slot(3)
[ 7079.741220] scsi target0:0:3: handle(0x000c),
sas_addr(0x4433221102000000), enclosure logical
id(0x500605b0001d5848), slot(2)
[ 7079.741287] mpt2sas0: _scsih_search_responding_raid_devices
[ 7079.741289] mpt2sas0: _scsih_search_responding_expanders
[ 7079.741291] mpt2sas0: _base_fault_reset_work: hard reset: success

I can just avoid doing any SMART-related stuff on here, but that seems
suboptimal. Anything I can do to debug this? Should I turn DMAR off?
The fault status reg changes with each attempt (2, 102, 202), but the
fault address is always e0000.

Actually, it only happened 3 times, and I can't get it to happen a 4th
time... perhaps it wasn't SMART, or harder to reproduce than I thought
originally. This still seems bad though.

Thanks,

-- 
Ilia Mirkin
imirkin@alum.mit.edu
