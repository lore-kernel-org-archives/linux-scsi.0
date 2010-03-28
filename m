From: Jan Sanislo <oystr@cs.washington.edu>
Subject: Peculiar Fusion MPT SPI driver behavior
Date: 28 Mar 2010 15:02 PDT
Message-ID: <1269813745/oystr@maui.cs.washington.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from maui.cs.washington.edu ([128.208.5.86]:47403 "EHLO
	maui.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0C1Wa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Mar 2010 18:30:29 -0400
Received: from maui.cs.washington.edu (localhost [127.0.0.1])
	by maui.cs.washington.edu (8.14.1/8.14.1/1.10) with ESMTP id o2SM3PME027292
	for <linux-scsi@vger.kernel.org>; Sun, 28 Mar 2010 15:03:25 -0700
	(envelope-from oystr@maui.cs.washington.edu)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've noticed some problems with the Fusion MPT SPI driver in kernel versions
2.6.31 and 2.6.33 using an LSI53C1030 card attached to a Storcase disk
array.  When probing LUNs kernel log messages look like those below (note
the complaints about "unknown device type", "capacity change", etc), with
failure to detect all of the drives in the proper manner:

============================================

kernel: Fusion MPT base driver 3.04.13
kernel: Copyright (c) 1999-2008 LSI Corporation
kernel: Fusion MPT SPI Host driver 3.04.13
kernel: mptspi 0000:03:07.0: PCI INT A -> GSI 66 (level, low) -> IRQ 66
kernel: mptbase: ioc0: Initiating bringup
kernel: ioc0: LSI53C1030 C0: Capabilities={Initiator}
kernel: scsi4 : ioc0: LSI53C1030 C0, FwRev=01032920h, Ports=1, MaxQ=222, IRQ=66
kernel: scsi 4:0:0:0: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: scsi target4:0:0: Beginning Domain Validation
kernel: scsi target4:0:0: Ending Domain Validation
kernel: scsi target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI WRFLOW PCOMP (6.25 ns, offset 127)
kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
kernel: scsi: On host 4 channel 0 id 0 only 511 (max_scsi_report_luns) of 460799999 luns reported, try increasing max_scsi_report_luns.
kernel: sd 4:0:0:0: [sdb] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:0: [sdb] Write Protect is off
kernel: scsi: unknown device type 25
kernel: scsi 4:0:0:1: Unknown                                     R0.0 PQ: 0 ANSI: 0
kernel: scsi 4:0:0:1: Information Units disabled by blacklist
kernel: scsi 4:0:0:1: Attached scsi generic sg3 type 25
kernel: sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: scsi scan: INQUIRY result too short (5), using 36
kernel: scsi: unknown device type 27
kernel: scsi 4:0:0:2: Unknown           SC U320/ SATA16R          R0.0 PQ: 6 ANSI: 7
kernel: scsi 4:0:0:2: Attached scsi generic sg4 type 27
kernel: scsi: unknown device type 25
kernel: scsi 4:0:0:3: Unknown                                     R0.0 PQ: 0 ANSI: 0
kernel: scsi 4:0:0:3: Information Units disabled by blacklist
kernel: sdb:
kernel: scsi 4:0:0:3: Attached scsi generic sg5 type 25
kernel: scsi 4:0:0:4: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:4: Attached scsi generic sg6 type 0
kernel: scsi 4:0:0:5: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:4: [sdc] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:5: Attached scsi generic sg7 type 0
kernel: sd 4:0:0:4: [sdc] Write Protect is off
kernel: scsi: unknown device type 25
kernel: scsi 4:0:0:6: Unknown                                     R0.0 PQ: 0 ANSI: 0
kernel: scsi 4:0:0:6: Information Units disabled by blacklist
kernel: sd 4:0:0:4: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sd 4:0:0:5: [sdd] Write Protect is off
kernel: scsi 4:0:0:6: Attached scsi generic sg8 type 25
kernel: sdb1
kernel: sd 4:0:0:5: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: scsi 4:0:0:7: Direct-Access              0                     PQ: 0 ANSI: 0
kernel: sd 4:0:0:7: Attached scsi generic sg9 type 0
kernel: sd 4:0:0:0: [sdb] Write Protect is on
kernel: sd 4:0:0:5: [sdd] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sdc:
kernel: sd 4:0:0:7: [sde] 1531461632 512-byte logical blocks: (784 GB/730 GiB)
kernel: sd 4:0:0:0: [sdb] Got wrong page
kernel: sd 4:0:0:0: [sdb] Assuming drive cache: write through
kernel: sd 4:0:0:0: [sdb] Attached SCSI disk
kernel: sd 4:0:0:7: [sde] Write Protect is off
kernel: sdd: detected capacity change from 4608 to 1887436800000
kernel: sdd:
kernel: sd 4:0:0:7: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sde: sdc1
kernel: mptspi 0000:03:07.1: PCI INT B -> GSI 67 (level, low) -> IRQ 67
kernel: mptbase: ioc1: Initiating bringup
kernel: ioc1: LSI53C1030 C0: Capabilities={Initiator}
kernel: sdd1
kernel: sd 4:0:0:4: [sdc] Attached SCSI disk
kernel: scsi5 : ioc1: LSI53C1030 C0, FwRev=01032920h, Ports=1, MaxQ=222, IRQ=67
kernel: sd 4:0:0:5: [sdd] Attached SCSI disk
kernel: sde1
kernel: sd 4:0:0:7: [sde] Attached SCSI disk

============================================

I noticed that probing in 6.31 and 6.33 kernels is done basically
asynchronously.  If I change the line of code in the sd_probe function
in drivers/scsi/sd.c from:

async_schedule(sd_probe_async, sdkp);

to a direct call to sd_probe_async:

sd_probe_async(sdkp, (async_cookie_t) 0);

then all disks are detected properly, as shown in the following log
messages:

============================================

kernel: Fusion MPT SPI Host driver 3.04.13
kernel: mptspi 0000:03:07.0: PCI INT A -> GSI 66 (level, low) -> IRQ 66
kernel: mptbase: ioc0: Initiating bringup
kernel: e1000: 0000:04:03.0: e1000_probe: (PCI:33MHz:32-bit) 00:14:22:b0:6d:4e
kernel: e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
kernel: ioc0: LSI53C1030 C0: Capabilities={Initiator}
kernel: scsi4 : ioc0: LSI53C1030 C0, FwRev=01032920h, Ports=1, MaxQ=222, IRQ=66
kernel: scsi 4:0:0:0: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: scsi target4:0:0: Beginning Domain Validation
kernel: scsi target4:0:0: Ending Domain Validation
kernel: scsi target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI WRFLOW PCOMP (6.25 ns, offset 127)
kernel: sd 4:0:0:0: [sdb] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:0: [sdb] Write Protect is off
kernel: sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdb: sdb1
kernel: sd 4:0:0:0: [sdb] Attached SCSI disk
kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
kernel: scsi 4:0:0:1: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:1: [sdc] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:1: [sdc] Write Protect is off
kernel: sd 4:0:0:1: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdc: sdc1
kernel: sd 4:0:0:1: [sdc] Attached SCSI disk
kernel: sd 4:0:0:1: Attached scsi generic sg3 type 0
kernel: scsi 4:0:0:2: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:2: [sdd] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:2: [sdd] Write Protect is off
kernel: sd 4:0:0:2: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdd: sdd1
kernel: sd 4:0:0:2: [sdd] Attached SCSI disk
kernel: sd 4:0:0:2: Attached scsi generic sg4 type 0
kernel: scsi 4:0:0:3: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:3: [sde] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:3: [sde] Write Protect is off
kernel: sd 4:0:0:3: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sde: sde1
kernel: sd 4:0:0:3: [sde] Attached SCSI disk
kernel: sd 4:0:0:3: Attached scsi generic sg5 type 0
kernel: scsi 4:0:0:4: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:4: [sdf] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:4: [sdf] Write Protect is off
kernel: sd 4:0:0:4: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdf: sdf1
kernel: sd 4:0:0:4: [sdf] Attached SCSI disk
kernel: sd 4:0:0:4: Attached scsi generic sg6 type 0
kernel: scsi 4:0:0:5: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:5: [sdg] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:5: [sdg] Write Protect is off
kernel: sd 4:0:0:5: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdg: sdg1
kernel: sd 4:0:0:5: [sdg] Attached SCSI disk
kernel: sd 4:0:0:5: Attached scsi generic sg7 type 0
kernel: scsi 4:0:0:6: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:6: [sdh] 3686400000 512-byte logical blocks: (1.88 TB/1.71 TiB)
kernel: sd 4:0:0:6: [sdh] Write Protect is off
kernel: sd 4:0:0:6: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdh: sdh1
kernel: sd 4:0:0:6: [sdh] Attached SCSI disk
kernel: sd 4:0:0:6: Attached scsi generic sg8 type 0
kernel: scsi 4:0:0:7: Direct-Access     SC U320/ SATA16R          R0.0 PQ: 0 ANSI: 3
kernel: sd 4:0:0:7: [sdi] 1531461632 512-byte logical blocks: (784 GB/730 GiB)
kernel: sd 4:0:0:7: [sdi] Write Protect is off
kernel: sd 4:0:0:7: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdi: sdi1
kernel: sd 4:0:0:7: [sdi] Attached SCSI disk
kernel: sd 4:0:0:7: Attached scsi generic sg9 type 0
kernel: mptspi 0000:03:07.1: PCI INT B -> GSI 67 (level, low) -> IRQ 67
kernel: mptbase: ioc1: Initiating bringup
kernel: ioc1: LSI53C1030 C0: Capabilities={Initiator}
kernel: scsi5 : ioc1: LSI53C1030 C0, FwRev=01032920h, Ports=1, MaxQ=222, IRQ=67

============================================

Has anybody else seen this behavior or am I doing something wrong?
