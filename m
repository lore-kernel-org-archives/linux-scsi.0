From: "Luck, Tony" <tony.luck@intel.com>
Subject: scsi: killing requests for dead queue
Date: Thu, 03 Nov 2011 14:23:24 -0700
Message-ID: <4eb3064c133909be1c@agluck-desktop.sc.intel.com>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: linux-next@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

First saw these messages on next-20111102 (but my previous build from linux-next
was next-20111017 ... so a big gap).  Still there today in next-20111103. Not seeing
these messages from Linus 3.2 merge window builds.

lspci says:
----------
20:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
20:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)

extract from dmesg:
------------------
Fusion MPT base driver 3.04.20
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.20
GSI 27 (level, low) -> CPU 0 (0x0000) vector 54
mptspi 0000:20:01.0: PCI INT A -> GSI 27 (level, low) -> IRQ 54
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
scsi0 : ioc0: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=54
scsi 0:0:0:0: Direct-Access     HP 36.4G MAU3036NC        HPC2 PQ: 0 ANSI: 3
scsi target0:0:0: Beginning Domain Validation
scsi target0:0:0: Ending Domain Validation
scsi target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
scsi 0:0:1:0: Direct-Access     HP 36.4G MAU3036NC        HPC2 PQ: 0 ANSI: 3
scsi target0:0:1: Beginning Domain Validation
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: cf 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
scsi target0:0:1: Ending Domain Validation
scsi target0:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:1:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
 sda: sda1
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: cf 00 10 08
scsi: killing requests for dead queue
scsi: killing requests for dead queue
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
sd 0:0:0:0: [sda] Attached SCSI disk
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue

bunch more "scsi: killing requests for dead queue" messages. But system
does eventually come up (and the messages stop).
