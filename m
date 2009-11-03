From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] New: mvsas : repeatably disconnects all disks during
 RAID6 resync
Date: Tue, 3 Nov 2009 02:08:25 GMT
Message-ID: <bug-14534-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50353 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZKCCIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 21:08:22 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA328P0l014722
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2009 02:08:25 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14534

           Summary: mvsas : repeatably disconnects all disks during RAID6
                    resync
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.31.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: wagner@tik.ee.ethz.ch
        Regression: No


Created an attachment (id=23624)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23624)
Error log from /var/log/kern.log

I am in the process of evaluating 8 port SATA/SAS PCI-E controllers for 
a storage server. I started with a Supermicro AOC-SASLP-MV8 which runs 
on a Marvell 6480 host controller. 
- Direct storage access was fine.
- RAID1 with 2 disks was fine. 
- A RAID6 with 4 disks disconnected all drives within a very 
  short time directly after creation, error log attached. The 
  disks only become accessible again after cold reboot and I 
  had to manually disconnect 2 of them in order to be able to 
  access them at all, since  the disks were immediately 
  disconnected again by the resync process.

The disks had no errors in their logs. 3 have seen extended use without 
problems and one is new, but also has a long SMART selftest and some 
hours of use without problems. They are all different, which should 
rule out a controller/disk interaction issue, unless such a problem 
on one port can kill all four ports.

Disk list:
=========
sda: 160GB Samsung SP1614C
sdb: 500GB Seagate Barracuda 7200.12  (new)
sdc: 80 GB Seagate ST380021A, attached via RockerHead 100 SATA->IDE converter
sdd: 40 GB Hitachi Travelstar 5K100 HTS541040G9SA00
sde (system drive, not in RAID): Same as sdc

Output from lspci:
=================
exp:root ~>lspci
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int
gfx)
00:03.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext
gfx port 1)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE
port 2)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE
mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address
Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3300 Graphics
01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
02:00.0 SCSI storage controller: Marvell Technology Group Ltd.
MV64460/64461/64462 System Controller, Revision B (rev 01)
03:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet
Adapter (rev b0)
exp:root ~>

Attached files:

relevant part of /var/log/kern.log
.config in followup

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
