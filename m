From: David Teigland <teigland@redhat.com>
Subject: mptspi_dv_renegotiate_work oops
Date: Mon, 12 May 2008 13:42:08 -0500
Message-ID: <20080512184208.GD31873@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbYELSmm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 14:42:42 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4CIgfOG003400
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 14:42:41 -0400
Received: from file.rdu.redhat.com (file.rdu.redhat.com [10.11.255.147])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CIgfiR030617
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 14:42:41 -0400
Received: from null.msp.redhat.com (null.msp.redhat.com [10.15.80.136])
	by file.rdu.redhat.com (8.13.1/8.13.1) with ESMTP id m4CIgeVv028640
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 14:42:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, I'm getting the following on 2.6.26-rc1 and -rc2 kernels:

Loading scsi_mod.ko module
SCSI subsystem initialized
Loading sd_mod.ko module
Driver 'sd' needs updating - please use bus_type methods
Loading mptbase.ko module
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Loading scsi_transport_spi.ko module
Loading mptscsih.ko module
Loading mptspi.ko module
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt 0000:86:01.0[A] -> GSI 32 (level, low) -> IRQ 32
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
mptbase: ioc0: PCI-MSI enabled
mptbase: ioc0: Initiating recovery
BUG: unable to handle kernel NULL pointer dereference at 0000000000000948
IP: [<ffffffffa00e5e28>] :mptspi:mptspi_dv_renegotiate_work+0x13/0xc3
PGD 13f4a4067 PUD 13e918067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: mptspi(+) mptscsih scsi_transport_spi mptbase sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 15, comm: events/0 Not tainted 2.6.26-rc2 #1
RIP: 0010:[<ffffffffa00e5e28>]  [<ffffffffa00e5e28>] :mptspi:mptspi_dv_renegotiate_work+0x13/0xc3
RSP: 0018:ffff81007f475e50  EFLAGS: 00010286
RAX: ffffffff802431cb RBX: ffff81007f475e90 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81007e970f20
RBP: ffff81007f475e80 R08: 0000000000000002 R09: 0000000000000000
R10: ffffffff802431cb R11: 0000000000000000 R12: ffff81007ffbcea8
R13: 0000000000000948 R14: ffffffffa00e5e15 R15: 0000000000000000
FS:  0000000000680850(0000) GS:ffffffff80638000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000948 CR3: 000000013e915000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/0 (pid: 15, threadinfo ffff81007f474000, task ffff81007f472440)
Stack:  ffffffffa00e5e15 0000000000000000 ffff81007f475e90 ffff81007ffbcea8
 ffff81007e970f20 ffffffffa00e5e15 ffff81007f475ed0 ffffffff8024321a
 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a
Call Trace:
 [<ffffffffa00e5e15>] ? :mptspi:mptspi_dv_renegotiate_work+0x0/0xc3
 [<ffffffffa00e5e15>] ? :mptspi:mptspi_dv_renegotiate_work+0x0/0xc3
 [<ffffffff8024321a>] run_workqueue+0xee/0x1f6
 [<ffffffff80243da7>] worker_thread+0xdb/0xe8
 [<ffffffff80246a2c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80243ccc>] ? worker_thread+0x0/0xe8
 [<ffffffff80246909>] kthread+0x49/0x78
 [<ffffffff8020cd88>] child_rip+0xa/0x12
 [<ffffffff80246784>] ? kthreadd+0x1a6/0x1cb
 [<ffffffff802468c0>] ? kthread+0x0/0x78
 [<ffffffff8020cd7e>] ? child_rip+0x0/0x12


Code: 8b bc 24 f8 00 00 00 e8 83 f7 ff ff 5a 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 56 41 55 41 54 53 48 83 ec 10 4c 8b 6f 40 <4d> 8b 75 00 e8 27 a4 1a e0 66 41 83 bd fa 02 00 00 00 49 8b be
RIP  [<ffffffffa00e5e28>] :mptspi:mptspi_dv_renegotiate_work+0x13/0xc3
 RSP <ffff81007f475e50>
CR2: 0000000000000948
---[ end trace 78bae8bebb941c9f ]---
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Initiating recovery
scsi0 : ioc0: LSI53C1030 B2, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=8412
 target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed
mptscsih: ioc0: attempting task abort! (sc=ffff81007eff5d80)
scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

mptbase: ioc0: Initiating recovery
scsi 0:0:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0, sc=ffff81007eff5d80, mf = ffff81007ea02ce0, idx=d
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: task abort: FAILED (sc=ffff81007eff5d80)
mptscsih: ioc0: attempting target reset! (sc=ffff81007eff5d80)
scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: target reset: FAILED (sc=ffff81007eff5d80)
mptscsih: ioc0: attempting bus reset! (sc=ffff81007eff5d80)
scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: bus reset: FAILED (sc=ffff81007eff5d80)
mptscsih: ioc0: attempting host reset! (sc=ffff81007eff5d80)
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: host reset: SUCCESS (sc=ffff81007eff5d80)
scsi 0:0:0:0: Device offlined - not ready after error recovery
 target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed
mptscsih: ioc0: attempting task abort! (sc=ffff81007eff5d80)
scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

...

mptbase: ioc0: Initiating recovery
scsi 0:0:15:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 15, sc=ffff81007eff5d80, mf = ffff81007ea056e0, idx=7d
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: task abort: FAILED (sc=ffff81007eff5d80)
mptscsih: ioc0: attempting target reset! (sc=ffff81007eff5d80)
scsi 0:0:15:0: CDB: Inquiry: 12 00 00 00 24 00
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: target reset: FAILED (sc=ffff81007eff5d80)
mptscsih: ioc0: attempting bus reset! (sc=ffff81007eff5d80)
scsi 0:0:15:0: CDB: Inquiry: 12 00 00 00 24 00
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: bus reset: FAILED (sc=ffff81007eff5d80)
mptscsih: ioc0: attempting host reset! (sc=ffff81007eff5d80)
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: host reset: SUCCESS (sc=ffff81007eff5d80)
scsi 0:0:15:0: Device offlined - not ready after error recovery
Loading scsi_transport_fc.ko module
Loading qla2xxx.ko module


Booting 2.6.25 works and looks like this:

Loading scsi_mod.ko module
SCSI subsystem initialized
Loading sd_mod.ko module
Driver 'sd' needs updating - please use bus_type methods
Loading mptbase.ko module
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Loading scsi_transport_spi.ko module
Loading mptscsih.ko module
Loading mptspi.ko module
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt 0000:86:01.0[A] -> GSI 32 (level, low) -> IRQ 32
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
scsi0 : ioc0: LSI53C1030 B2, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=32
scsi 0:0:0:0: Direct-Access     COMPAQ   BF03698578       HPB2 PQ: 0 ANSI: 3
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 127)
sd 0:0:0:0: [sda] 71132000 512-byte hardware sectors (36420 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: cf 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 71132000 512-byte hardware sectors (36420 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: cf 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
Loading scsi_transport_fc.ko module
Loading qla2xxx.ko module

