From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Subject: (unknown)
Date: Fri, 20 Mar 2009 00:22:57 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0903200003010.19032@tassadar.physics.auth.gr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tassadar.physics.auth.gr ([155.207.123.25]:44861 "EHLO
	tassadar.physics.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844AbZCSWrf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 18:47:35 -0400
Received: from tassadar.physics.auth.gr (IDENT:1000@localhost [127.0.0.1])
	by tassadar.physics.auth.gr (8.13.7/8.13.6) with ESMTP id n2JMMw8e019303
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 00:22:58 +0200
Received: from localhost (dzila@localhost)
	by tassadar.physics.auth.gr (8.13.7/8.13.3/Submit) with ESMTP id n2JMMvwF019300
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 00:22:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I was having problems with two nodes rhel4 x86_64 compatible nodes with 
this:

08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064E 
PCI-Express Fusion-MPT SAS (rev 04)

the nodes would panic after doing some task (download a few gigabytes and 
run a few computations)

screenshots of two panics

http://img10.imageshack.us/img10/3184/camxgemspanic.jpg
http://img10.imageshack.us/img10/174/wn024.jpg


Prior to the panic the systems would be up for couple of hours to 
a couple of days and log this when say a gzip was running:

Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task 
abort! (sc=000001019199d4c0)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11, 
lun 0
Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00 
01 cd ab d3 00 01 40 00
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptbase: ioc0: IOCStatus=8000 
LogInfo=31120403 Originator={PL}, Code={Abort}, SubCode(0x0403)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptbase: ioc0: IOCStatus=8048 
LogInfo=31140000 Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: task abort: 
SUCCESS (sc=000001019199d4c0)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptbase: ioc0: IOCStatus=804b 
LogInfo=31120403 Originator={PL}, Code={Abort}, SubCode(0x0403)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task 
abort! (sc=0000010024283d00)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11, 
lun 0
Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00 
01 cd ad 13 00 01 40 00
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task 
abort! (sc=0000010102db4ac0)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11, 
lun 0
Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00 
01 cd ae 53 00 01 40 00
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task 
abort! (sc=0000010102db4cc0)
Mar  5 16:19:30 wn023.grid.auth.gr kernel: scsi7 : destination target 11, 
lun 0
Mar  5 16:19:30 wn023.grid.auth.gr kernel:         command = Write (10) 00 
01 cd af 93 00 01 40 00
Mar  5 16:19:30 wn023.grid.auth.gr kernel: mptscsi: ioc0: attempting task 
abort! (sc=0000010102db40c0)


Memtest for days was running ok.

I found this: https://bugzilla.redhat.com/show_bug.cgi?id=208033

and I upgraded my firmware from 
http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2487&OSFullName=OS+Independent&lang=eng&strOSs=38&submit=Go

After the upgrade the systems don't seem to panic. But they log this


mptbase: ioc0: IOCStatus=8000 LogInfo=31123000 Originator={PL}, 
Code={Abort}, SubCode(0x3000)
mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL}, 
Code={Abort}, SubCode(0x3000)
mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL}, 
Code={Abort}, SubCode(0x3000)
mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL}, 
Code={Abort}, SubCode(0x3000)
mptbase: ioc0: IOCStatus=804b LogInfo=31123000 Originator={PL}, 
Code={Abort}, SubCode(0x3000)

lspci
00:00.0 Host bridge: Intel Corporation 5000V Chipset Memory Controller Hub 
(rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 2-3 (rev b1)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 3 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA 
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller 
(rev 09)
00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI 
Controller (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus 
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream 
Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X 
Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01)
02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E2 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E3 (rev 01)
05:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
05:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064E 
PCI-Express Fusion-MPT SAS (rev 04)
09:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

[root@wn024 log]# cat /proc/mpt/summary
ioc0: LSISAS1064E, FwRev=011b0000h, Ports=1, MaxQ=268, IRQ=169
[root@wn024 log]# cat /proc/mpt/version
mptlinux-3.12.19.00rh
   Fusion MPT base driver
   Fusion MPT SPI host driver
   Fusion MPT SAS host driver

uname -an
Linux wn024.grid.auth.gr 2.6.9-78.0.13.ELlargesmp #1 SMP Wed Jan 14 
14:20:39 CST 2009 x86_64 x86_64 x86_64 GNU/Linux


Is something broken here? I am close to ask for the systems to be 
replaced.


Cheers,


-- 
=============================================================================
Dimitris Zilaskos
GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
Tel: +302310998988 Fax: +302310994309
http://www.grid.auth.gr
=============================================================================
