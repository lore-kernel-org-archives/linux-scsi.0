From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10396] New: BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
Date: Sat,  5 Apr 2008 08:53:12 -0700 (PDT)
Message-ID: <bug-10396-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYDEPxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2008 11:53:15 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m35FrC6v010096
	for <linux-scsi@vger.kernel.org>; Sat, 5 Apr 2008 08:53:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10396

           Summary: BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: v2.6.25-rc8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
        AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
        ReportedBy: linux@tjworld.net


Latest working kernel version: v2.6.20
Earliest failing kernel version: v.2.6.22
Distribution: kernel.org, Ubuntu
Hardware Environment: Dell PowerEdge 6300 with PERC 2 RAID (Adaptec) controller
Software Environment: kernel
Problem Description: Linux fails to boot because aacraid fails and no file
system available.

Steps to reproduce: Boot server with kernel later than v2.6.20

Dell PERC 2 RAID controller, latest firmware (2.8.0 build 6099) with 6 disks -
5x RAID-5, 1x spare.

Logs being captured using a serial console connection.

A *good* start with v2.6.20 reports:

[    6.681614] Adaptec aacraid driver (1.1-5[2423]-mh3)

[    6.686794] ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 18 (level, low) ->
IRQ 17

[    6.695162] FDC 0 is a National Semiconductor PC87306

[    6.724207] AAC0: kernel 2.8-0[6089] 

[    6.727976] AAC0: monitor 2.8-0[6089]

[    6.731702] AAC0: bios 2.8-0[6089]

[    6.735174] AAC0: serial 8a0376

[    6.738794] scsi0 : percraid

[    6.742287] ACPI: PCI Interrupt 0000:02:04.0[A] -> <3>hub 1-0:1.0:
over-current change on port 1

[    6.742810] scsi 0:0:0:0: Direct-Access     DELL     Array1           V1.0
PQ: 0 ANSI: 2

[    6.751893] scsi 0:0:1:0: Direct-Access     DELL     Archive          V1.0
PQ: 0 ANSI: 2

A *bad* start with v2.6.22+ reports:

[  152.474463] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]

[  152.474463] 

[  152.474463] Pid: 2096, comm: modprobe Not tainted (2.6.25-rc8-custom #1)

[  152.474463] EIP: 0060:[<c0209db0>] EFLAGS: 00000293 CPU: 0

[  152.474463] EIP is at native_read_tsc+0x0/0x10

[  152.474463] EAX: 00000474 EBX: b8fd8e27 ECX: 02a52000 EDX: 0000004a

[  152.474463] ESI: 00000aac EDI: 0142f9cb EBP: f54dda84 ESP: f7c5dd1c

[  152.474463]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

[  152.474463] CR0: 8005003b CR2: 080f91cf CR3: 37a60000 CR4: 000006d0

[  152.474463] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000

[  152.474463] DR6: ffff0ff0 DR7: 00000400

[  152.474463]  [<c0305067>] ? delay_tsc+0x17/0x20

[  152.474463]  [<c0305016>] ? __delay+0x6/0x10

[  152.474463]  [<f8a5aa40>] ? aac_fib_send+0x220/0x2d0 [aacraid]

[  152.474463]  [<f8a569c4>] ? aac_get_adapter_info+0x74/0x680 [aacraid]

[  152.474463]  [<c021937b>] ? __resched_task+0x5b/0x70

[  152.474463]  [<c021ccda>] ? try_to_wake_up+0x6a/0x100

[  152.474463]  [<f8a5d55a>] ? aac_probe_one+0x23a/0x4a4 [aacraid]

[  152.474463]  [<f8a5af50>] ? aac_command_thread+0x0/0x6d0 [aacraid]

[  152.474463]  [<c0310146>] ? pci_device_probe+0x56/0x80

[  152.474463]  [<c0367948>] ? driver_probe_device+0x88/0x170

[  152.474463]  [<c0367b9e>] ? __driver_attach+0x9e/0xa0

[  152.474463]  [<c0366cea>] ? bus_for_each_dev+0x3a/0x60

[  152.474463]  [<c03100f0>] ? pci_device_probe+0x0/0x80

[  152.474463]  [<c03677c6>] ? driver_attach+0x16/0x20

[  152.474463]  [<c0367b00>] ? __driver_attach+0x0/0xa0

[  152.474463]  [<c0367674>] ? bus_add_driver+0x1a4/0x210

[  152.474463]  [<c0310090>] ? pci_device_remove+0x0/0x40

[  152.474463]  [<c03100f0>] ? pci_device_probe+0x0/0x80

[  152.474463]  [<c0367d3b>] ? driver_register+0x3b/0xf0

[  152.474463]  [<c040b744>] ? _spin_unlock_irqrestore+0x4/0x10

[  152.474463]  [<c031034d>] ? __pci_register_driver+0x3d/0x80

[  152.474463]  [<f890a033>] ? aac_init+0x33/0x74 [aacraid]

[  152.474463]  [<c024696e>] ? sys_init_module+0x13e/0x1c40

[  152.474463]  [<c040d37f>] ? do_page_fault+0x13f/0x670

[  152.474463]  [<c02294ec>] ? irq_exit+0x3c/0x70

[  152.474463]  [<c0204d76>] ? syscall_call+0x7/0xb

[  152.474463]  =======================

v2.6.20 runs stable. v2.6.22+ all fail in the same way. There are also "nobody
cared" IRQ faults:

[   17.155571] irq 10: nobody cared (try booting with the "irqpoll" option)

[   17.155571] Pid: 0, comm: swapper Not tainted 2.6.25-rc8-custom #1

[   17.155571]  [<c025ad74>] __report_bad_irq+0x24/0x80

[   17.155571]  [<c0219e27>] __update_rq_clock+0x27/0x180

[   17.155571]  [<c025b040>] note_interrupt+0x270/0x2b0

[   17.155571]  [<c023c8c1>] getnstimeofday+0x31/0xc0

[   17.155571]  [<c025a2a5>] handle_IRQ_event+0x25/0x50

[   17.155571]  [<c025b9dd>] handle_fasteoi_irq+0xad/0xe0

[   17.155571]  [<c02071dd>] do_IRQ+0x3d/0x80

[   17.155571]  [<c020571f>] common_interrupt+0x23/0x28

[   17.155571]  [<c02300d8>] sys_rt_sigsuspend+0xc8/0xd0

[   17.155571]  [<c02039c2>] default_idle+0x52/0x80

[   17.155571]  [<c0203970>] default_idle+0x0/0x80

[   17.155571]  [<c020380d>] cpu_idle+0x5d/0xe0

[   17.155571]  =======================

[   17.155571] handlers:

[   17.155571] [<f88cc180>] (ahc_linux_isr+0x0/0x250 [aic7xxx])

[   17.155571] Disabling IRQ #10

I'm not sure if these lead to the aacraid failure or the two are unrelated.

In a *bad* boot log I see these but I'm not sure if they are related to the
error reports later:

[    0.910906] ACPI: PCI Root Bridge [PX0B] (0000:02)

[    0.912085] ACPI: Bus 0000:02 not present in PCI namespace

[    0.917111] ACPI: PCI Root Bridge [PX1A] (0000:03)

[    0.920085] ACPI: Bus 0000:03 not present in PCI namespace


I'm trying to determine if those Bus 0000:02/03 references are the same as the
lspci device addresses 02:* and 03:* (see later) because if they are it would
show these two reports might be the root cause of the entire problem.

System configuration:

The PERC/2 controller is:
03:03.0 RAID bus controller [0104]: Digital Equipment Corporation DECchip 21554
[1011:0046] (rev 01)

$ uname -a
Linux PowerEdge6300 2.6.20-15-generic #2 SMP Sun Apr 15 07:36:31 UTC 2007 i686
GNU/Linux

$ modinfo aacraid
filename: /lib/modules/2.6.20-15-generic/kernel/drivers/scsi/aacraid/aacraid.ko
version: 1.1-5[2423]-mh3
license: GPL
description: Dell PERC2, 2/Si, 3/Si, 3/Di, Adaptec Advanced Raid Products, HP
NetRAID-4M, IBM ServeRAID & ICP SCSI driver
author: Red Hat Inc and Adaptec
srcversion: 9F4AEF75C12F7128F830FA2
depends: scsi_mod
vermagic: 2.6.20-15-generic SMP mod_unload 586

$ lspci -nnn
00:02.0 ISA bridge [0601]: Intel Corporation 82371AB/EB/MB PIIX4 ISA
[8086:7110] (rev 02)
00:02.1 IDE interface [0101]: Intel Corporation 82371AB/EB/MB PIIX4 IDE
[8086:7111] (rev 01)
00:02.2 USB Controller [0c03]: Intel Corporation 82371AB/EB/MB PIIX4 USB
[8086:7112] (rev 01)
00:02.3 Bridge [0680]: Intel Corporation 82371AB/EB/MB PIIX4 ACPI [8086:7113]
(rev 02)
00:04.0 VGA compatible controller [0300]: ATI Technologies Inc 3D Rage Pro
[1002:4749] (rev 5c)
00:08.0 SCSI storage controller [0100]: Adaptec AHA-2940U2/U2W [9005:0010]
00:0a.0 PCI bridge [0604]: Intel Corporation 21154 PCI-to-PCI Bridge
[8086:b154]
00:10.0 Host bridge [0600]: Intel Corporation 450NX - 82451NX Memory & I/O
Controller [8086:84ca] (rev 03)
00:12.0 Host bridge [0600]: Intel Corporation 450NX - 82454NX/84460GX PCI
Expander Bridge [8086:84cb] (rev 04)
00:13.0 Host bridge [0600]: Intel Corporation 450NX - 82454NX/84460GX PCI
Expander Bridge [8086:84cb] (rev 04)
00:14.0 Host bridge [0600]: Intel Corporation 450NX - 82454NX/84460GX PCI
Expander Bridge [8086:84cb] (rev 04)
01:04.0 Ethernet controller [0200]: Intel Corporation 82557/8/9 [Ethernet Pro
100] [8086:1229] (rev 0d)
01:05.0 Ethernet controller [0200]: Intel Corporation 82557/8/9 [Ethernet Pro
100] [8086:1229] (rev 0d)
02:04.0 SCSI storage controller [0100]: Adaptec AHA-2940U2/U2W / 7890/7891
[9005:001f]
02:06.0 SCSI storage controller [0100]: Adaptec AHA-2940U2/U2W / 7890/7891
[9005:001f]
02:08.0 SCSI storage controller [0100]: Adaptec AIC-7860 [9004:6078] (rev 03)
03:03.0 RAID bus controller [0104]: Digital Equipment Corporation DECchip 21554
[1011:0046] (rev 01)

$ lsmod | grep aac
aacraid 59652 2
scsi_mod 142348 8 st,sr_mod,sg,sd_mod,aacraid,aic7xxx,scsi_transport_spi,libata

$ grep -i aac /var/log/kern.log
Apr 3 18:07:41 PowerEdge6300 kernel: [ 6.394845] Adaptec aacraid driver
(1.1-5[2423]-mh3)
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.623757] AAC0: kernel 2.8-0[6089]
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.623770] AAC0: monitor 2.8-0[6089]
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.623779] AAC0: bios 2.8-0[6089]
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.623787] AAC0: serial 8a0376

$ egrep -i 'scsi3|3:0:' /var/log/kern.log
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.624202] scsi3 : percraid
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.624823] scsi 3:0:0:0: Direct-Access
DELL Array1 V1.0 PQ: 0 ANSI: 2
Apr 3 18:07:41 PowerEdge6300 kernel: [ 51.625185] scsi 3:0:1:0: Direct-Access
DELL Archive V1.0 PQ: 0 ANSI: 2
Apr 3 18:07:41 PowerEdge6300 kernel: [ 66.973120] sd 3:0:0:0: Attached scsi
removable disk sda
Apr 3 18:07:41 PowerEdge6300 kernel: [ 66.974231] sd 3:0:1:0: Attached scsi
removable disk sdb
Apr 3 18:07:41 PowerEdge6300 kernel: [ 66.997669] sd 3:0:0:0: Attached scsi
generic sg1 type 0
Apr 3 18:07:41 PowerEdge6300 kernel: [ 66.998217] sd 3:0:1:0: Attached scsi
generic sg2 type 0
Apr 3 18:07:41 PowerEdge6300 kernel: [ 67.016451] sr0: scsi3-mmc drive: 17x/40x
cd/rw xa/form2 cdda tray


$ git-rev-list --pretty=oneline --reverse v2.6.20..v2.6.22 --
drivers/scsi/aacraid

shows 32 commits between good and bad versions that affect aacraid. 

I've begun a bisect/test cycle but it will require 15 tests and the build time
is very long. If the issue is outside aacraid then it'd take weeks to follow
the bisect/test cycle for all commits between v2.6.20 and v2.6.22.

If the issue is ACPI related

$ git-rev-list --pretty=oneline --reverse v2.6.20..v2.6.22 --
drivers/acpi/pci_root.c

shows 7 commits and

$ git-rev-list --pretty=oneline --reverse v2.6.20..v2.6.22 -- drivers/acpi

shows 277 commits.

Related is bug #9133. I've tried all the suggestions in that with no difference
in the observed problem. I've tried boot options noapic noacpi irqpoll and the
various aacraid.* and scsi_mod.scan=sync.

Related Ubuntu report is bug #149071 which might have a different cause
although I began reporting there as it seemed remarkably close. I may open
another Ubuntu bug report to run mirror this one as the cause seems different.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/149071


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
