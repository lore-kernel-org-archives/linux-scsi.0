From: Paul Jackson <pj@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 12:56:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916125631.1f25dfdb.pj@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org>
	<20040916121235.5e4f9c32.pj@sgi.com>
	<1095362263.16326.12.camel@praka>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:44421 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S268165AbUIPT5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 15:57:19 -0400
In-Reply-To: <1095362263.16326.12.camel@praka>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org
Cc: mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

Andrew Vasquez has been looking at this, via private email with just
me (no progress yet).  Figured I update the larger list with this much ...

I am still seeing the SN2 SCSI QLA failure as I reported yesterday, but
now against 2.6.9-rc2-mm1.

For the benefit of those with limited memories, such as myself, I will
repeat the symptoms from the top.

Those with good memories can probably stop reading here - nothing much
new to report other than retesting on 2.6.9-rc2-mm1.

===

This is now testing against 2.6.9-rc2-mm1, plus a one line workaround
for some ACPI problem, from Jesse Barnes.  The symptoms resemble what I
first saw of this failure on 2.6.9-rc1-mm5.  I did not see any such
problem on 2.6.9-rc1-mm4.

I have to make the following change to sn2_defconfig in order to boot:

< CONFIG_SCSI_QLA22XX=y
< CONFIG_SCSI_QLA2300=y
< CONFIG_SCSI_QLA2322=y
---
> # CONFIG_SCSI_QLA22XX is not set
> # CONFIG_SCSI_QLA2300 is not set
> # CONFIG_SCSI_QLA2322 is not set

Once I comment out these QLA lines, I can boot.

Otherwise the boot fails, ending with the following lines of output. 
There are a couple of 5 or 10 second pauses somewhere in the last dozen
lines of this output.

=======================================================

VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 2048 (order 0, 16384 bytes)
SGI XFS with ACLs, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
Initializing Cryptographic API
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
IA-PC Multimedia Timer: v1.0, 25 MHz
EFI Time Services Driver v0.4
sn_console: Console driver init
ttySG0 at I/O 0x0 (irq = 0) is a SGI SN L1
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
tg3.c:v3.9 (August 30, 2004)
eth0: Tigon3 [partno(030-1771-000) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000BaseT Ethernet 08:00:69:13:dc:f6
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0] 
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SGIIOC4: IDE controller at PCI slot 0000:01:01.0, revision 79
ide0: BM-DMA at 0xc00002080c200140-0xc00002080c200163
hda: MATSHITADVD-ROM SR-8588, ATAPI CD/DVD-ROM drive
Using anticipatory io scheduler
ide0 at 0xc00002080c200100-0xc00002080c200107,0xc00002080c200120 on irq 55
ide1: I/O resource 0x376-0x376 not free.
ide1: ports already in use, skipping probe
ide2: I/O resource 0x3EE-0x3EE not free.
ide2: ports already in use, skipping probe
ide3: I/O resource 0x36E-0x36E not free.
ide3: ports already in use, skipping probe
ide4: I/O resource 0x3E6-0x3E6 not free.
ide4: ports already in use, skipping probe
ide5: I/O resource 0x366-0x366 not free.
ide5: ports already in use, skipping probe
hda: ATAPI 48X DVD-ROM drive, 256kB Cache, UDMA(16)
Uniform CD-ROM driver Revision: 3.20
qla1280: QLA12160 found on PCI bus 1, dev 3
scsi(0): Enabling SN2 PCI DMA dual channel lockup workaround
scsi(0): Enabling SN2 PCI DMA workaround
scsi(0:0): Resetting SCSI BUS
scsi(0:1): Resetting SCSI BUS
scsi0 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.32, Driver version 3.24.4
  Vendor: SGI       Model: ST336753LC        Rev: 2741
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:1:0): Sync: period 9, offset 14, Wide, DT, Tagged queuing: depth 255
  Vendor: SGI       Model: ST336753LC        Rev: 2741
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:2:0): Sync: period 9, offset 14, Wide, DT, Tagged queuing: depth 255
QLogic Fibre Channel HBA Driver (a0000001007b29c0)
qla2200 0000:03:01.0: Found an ISP2200, irq 58, iobase 0xc00002080f400000
qla2200 0000:03:01.0: Configuring PCI space...
PCI: slot 0000:03:01.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
POD entered via OS requested halt, using Cac mode
2 008: POD SysCt Cac> 

=======================================================

By way of comparison, the lines just before and after the above
point of death, on a successful boot w/o the QLA2 config, looks like:

=======================================================

scsi0 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.32, Driver version 3.24.4
  Vendor: SGI       Model: ST336753LC        Rev: 2741
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:1:0): Sync: period 9, offset 14, Wide, DT, Tagged queuing: depth 255
  Vendor: SGI       Model: ST336753LC        Rev: 2741
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:2:0): Sync: period 9, offset 14, Wide, DT, Tagged queuing: depth 255
SCSI device sda: 71687372 512-byte hdwr sectors (36704 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
SCSI device sdb: 71687372 512-byte hdwr sectors (36704 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
Attached scsi disk sdb at scsi0, channel 0, id 2, lun 0
Fusion MPT base driver 3.01.16
Copyright (c) 1999-2004 LSI Logic Corporation
Fusion MPT SCSI Host driver 3.01.16
mice: PS/2 mouse device common for all mice

=======================================================

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
