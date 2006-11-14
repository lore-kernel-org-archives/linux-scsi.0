From: Etienne.Vogt@obspm.fr
Subject: [mptscsi] endless Domain Validation loop with external RAID enclosure
Date: Tue, 14 Nov 2006 15:41:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611141502290.20450@siolinb.obspm.fr>
Reply-To: Etienne.Vogt@obspm.fr
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siolinb.obspm.fr ([145.238.2.18]:45262 "EHLO siolinb.obspm.fr")
	by vger.kernel.org with ESMTP id S965904AbWKNOlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Nov 2006 09:41:49 -0500
Received: from vogt (helo=localhost)
	by siolinb.obspm.fr with local-esmtp (Exim 3.36 #1 (Debian))
	id 1GjzTw-0006tR-00
	for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2006 15:41:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello linux scsi gurus,

  I am having trouble getting an external Brownie BR8600 SCSItoIDE RAID
enclosure to work on our new HP Proliant ML350 file server. The SCSI
controller used is the integrated HP LSI based MPT SCSI controller :

0000:06:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
0000:09:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)

With linux kernel 2.6.18.1 (official kernel.org, no added patches), the 
mptspi module goes into endless domain validation retries. I can get the 
RAID enclosure to work using the stock 2.6.8-2 kernel from Debian sarge 
(an SCSI protocol error is reported after loading the mptscsih module
but the device works OK afterwards). Hovewer, this now quite old kernel
release lacks the bnx2 driver modules that is needed for the additional
Broadcom Nextreme II based network cards.

I understand that the problem is probably caused by buggy firmware in
the BR8600 RAID system, but we have 5 of those in production each with
1.75 Tb of online storage that used to work fine on servers running
2.4.x kernels. Replacing these RAID systems is not really an affordable 
option at the moment.

So, is there a way to tell the kernel scsi subsystem or the mptspi module 
not to bother about this domain validation failure ? Besides, souldn't
this kind of endless loop be considered as a kernel bug, even if triggered
by buggy peripheral firmware (afterwards, it works on kernel 2.4.x
or 2.6.8-2) ?

Here is an extract from the kernel logs on the 2.6.18.1 kernel :

Nov 13 17:06:32 filer1 kernel: Fusion MPT base driver 3.04.01
Nov 13 17:06:32 filer1 kernel: Copyright (c) 1999-2005 LSI Logic 
Corporation
Nov 13 17:06:32 filer1 kernel: Fusion MPT SPI Host driver 3.04.01
Nov 13 17:06:32 filer1 kernel: ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 
48 (level, low) -> IRQ 209
Nov 13 17:06:32 filer1 kernel: mptbase: Initiating ioc0 bringup
Nov 13 17:06:32 filer1 kernel: ioc0: 53C1030: 
Capabilities={Initiator,Target}
Nov 13 17:06:32 filer1 kernel: scsi2 : ioc0: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=209
Nov 13 17:06:37 filer1 kernel: ACPI: PCI Interrupt 0000:09:01.0[A] -> GSI 
76 (level, low) -> IRQ 217
Nov 13 17:06:37 filer1 kernel: mptbase: Initiating ioc1 bringup
Nov 13 17:06:37 filer1 kernel: ioc1: 53C1030: 
Capabilities={Initiator,Target}
Nov 13 17:06:38 filer1 kernel: scsi3 : ioc1: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=217
Nov 13 17:06:42 filer1 kernel: ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 
24 (level, low) -> IRQ 225
Nov 13 17:06:42 filer1 kernel: mptbase: Initiating ioc2 bringup
Nov 13 17:06:43 filer1 kernel: ioc2: 53C1030: 
Capabilities={Initiator,Target}
Nov 13 17:06:43 filer1 kernel: scsi4 : ioc2: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=225
Nov 13 17:06:48 filer1 kernel: ACPI: PCI Interrupt 0000:02:03.1[B] -> GSI 
25 (level, low) -> IRQ 233
Nov 13 17:06:48 filer1 kernel: mptbase: Initiating ioc3 bringup
Nov 13 17:06:49 filer1 kernel: ioc3: 53C1030: 
Capabilities={Initiator,Target}
Nov 13 17:06:49 filer1 kernel: scsi5 : ioc3: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=233
Nov 13 17:06:52 filer1 kernel:   Vendor: BROWNIE   Model: 8600U3 
Rev: 0001
Nov 13 17:06:52 filer1 kernel:   Type:   Direct-Access 
ANSI SCSI revision: 03
Nov 13 17:06:52 filer1 kernel:  target5:0:8: Beginning Domain Validation
Nov 13 17:07:02 filer1 kernel: mptscsih: ioc3: attempting task abort! 
(sc=f7a21980)
Nov 13 17:07:02 filer1 kernel: scsi 5:0:8:0:
Nov 13 17:07:02 filer1 kernel:         command: Inquiry: 12 00 00 00 90 00
Nov 13 17:07:04 filer1 kernel: mptbase: Initiating ioc3 recovery
Nov 13 17:07:10 filer1 kernel: mptscsih: ioc3: task abort: SUCCESS 
(sc=f7a21980)Nov 13 17:07:10 filer1 kernel:  target5:0:8: Domain 
Validation detected failure, dropping back
Nov 13 17:07:10 filer1 kernel:  target5:0:8: Domain Validation skipping 
write tests
Nov 13 17:07:10 filer1 kernel:  target5:0:8: Ending Domain Validation
Nov 13 17:07:10 filer1 kernel:  target5:0:8: asynchronous
Nov 13 17:07:10 filer1 kernel: SCSI device sda: 3417931776 512-byte hdwr 
sectors (1749981 MB)
Nov 13 17:07:10 filer1 kernel: sda: Write Protect is off
Nov 13 17:07:10 filer1 kernel: sda: Mode Sense: ad 00 00 08
Nov 13 17:07:10 filer1 kernel: SCSI device sda: drive cache: write back
Nov 13 17:07:10 filer1 kernel: SCSI device sda: 3417931776 512-byte hdwr 
sectors (1749981 MB)
Nov 13 17:07:10 filer1 kernel: sda: Write Protect is off
Nov 13 17:07:10 filer1 kernel: sda: Mode Sense: ad 00 00 08
Nov 13 17:07:10 filer1 kernel: SCSI device sda: drive cache: write back
Nov 13 17:07:10 filer1 kernel:  sda: sda1
Nov 13 17:07:10 filer1 kernel: sd 5:0:8:0: Attached scsi disk sda
Nov 13 17:07:10 filer1 kernel:  target5:0:8: Beginning Domain Validation
Nov 13 17:07:22 filer1 kernel: mptscsih: ioc3: attempting task abort! 
(sc=f77a5e00)
Nov 13 17:07:22 filer1 kernel: sd 5:0:8:0:
Nov 13 17:07:22 filer1 kernel:         command: Inquiry: 12 00 00 00 90 00
Nov 13 17:07:24 filer1 kernel: mptbase: Initiating ioc3 recovery
Nov 13 17:07:30 filer1 kernel: mptscsih: ioc3: task abort: SUCCESS 
(sc=f77a5e00)Nov 13 17:07:30 filer1 kernel:  target5:0:8: Domain 
Validation detected failure, dropping back
Nov 13 17:07:30 filer1 kernel:  target5:0:8: Domain Validation skipping 
write tests
Nov 13 17:07:30 filer1 kernel:  target5:0:8: Ending Domain Validation
Nov 13 17:07:30 filer1 kernel:  target5:0:8: asynchronous
Nov 13 17:07:30 filer1 kernel:  target5:0:8: Beginning Domain Validation
Nov 13 17:07:40 filer1 kernel: mptscsih: ioc3: attempting task abort! 
(sc=f7a3e980)
Nov 13 17:07:40 filer1 kernel: sd 5:0:8:0:
Nov 13 17:07:40 filer1 kernel:         command: Inquiry: 12 00 00 00 90 00
Nov 13 17:07:42 filer1 kernel: mptbase: Initiating ioc3 recovery
Nov 13 17:07:48 filer1 kernel: mptscsih: ioc3: task abort: SUCCESS 
(sc=f7a3e980)Nov 13 17:07:48 filer1 kernel:  target5:0:8: Domain 
Validation detected failure, dropping back
Nov 13 17:07:48 filer1 kernel:  target5:0:8: Domain Validation skipping 
write tests
Nov 13 17:07:48 filer1 kernel:  target5:0:8: Ending Domain Validation
Nov 13 17:07:48 filer1 kernel:  target5:0:8: asynchronous
Nov 13 17:07:48 filer1 kernel:  target5:0:8: Beginning Domain Validation
Nov 13 17:07:58 filer1 kernel: mptscsih: ioc3: attempting task abort! 
(sc=f7a21c80)
Nov 13 17:07:58 filer1 kernel: sd 5:0:8:0:
Nov 13 17:07:58 filer1 kernel:         command: Inquiry: 12 00 00 00 90 00
Nov 13 17:08:00 filer1 kernel: mptbase: Initiating ioc3 recovery
Nov 13 17:08:06 filer1 kernel: mptscsih: ioc3: task abort: SUCCESS 
(sc=f7a21c80)Nov 13 17:08:06 filer1 kernel:  target5:0:8: Domain 
Validation detected failure, dropping back
Nov 13 17:08:06 filer1 kernel:  target5:0:8: Domain Validation skipping 
write tests
Nov 13 17:08:06 filer1 kernel:  target5:0:8: Ending Domain Validation
Nov 13 17:08:06 filer1 kernel:  target5:0:8: asynchronous
Nov 13 17:08:06 filer1 kernel:  target5:0:8: Beginning Domain Validation
Nov 13 17:08:16 filer1 kernel: mptscsih: ioc3: attempting task abort! 
(sc=f7a3e200)
Nov 13 17:08:16 filer1 kernel: sd 5:0:8:0:
Nov 13 17:08:16 filer1 kernel:         command: Inquiry: 12 00 00 00 90 00
Nov 13 17:08:19 filer1 kernel: mptbase: Initiating ioc3 recovery
[then it goes on an on....]

the same kernel logs with 2.6.8-2 on the same machine :

Nov 14 09:51:14 filer1 kernel: Fusion MPT base driver 3.01.09
Nov 14 09:51:14 filer1 kernel: Copyright (c) 1999-2004 LSI Logic 
Corporation
Nov 14 09:51:14 filer1 kernel: ACPI: PCI interrupt 0000:06:01.0[A] -> GSI 
48 (level, low) -> IRQ 201
Nov 14 09:51:14 filer1 kernel: mptbase: Initiating ioc0 bringup
Nov 14 09:51:14 filer1 kernel: ioc0: 53C1030: 
Capabilities={Initiator,Target}
Nov 14 09:51:14 filer1 kernel: ACPI: PCI interrupt 0000:09:01.0[A] -> GSI 
76 (level, low) -> IRQ 209
Nov 14 09:51:14 filer1 kernel: mptbase: Initiating ioc1 bringup
Nov 14 09:51:14 filer1 kernel: ioc1: 53C1030: 
Capabilities={Initiator,Target}
Nov 14 09:51:14 filer1 kernel: ACPI: PCI interrupt 0000:02:03.0[A] -> GSI 
24 (level, low) -> IRQ 50
Nov 14 09:51:14 filer1 kernel: mptbase: Initiating ioc2 bringup
Nov 14 09:51:14 filer1 kernel: ioc2: 53C1030: 
Capabilities={Initiator,Target}
Nov 14 09:51:14 filer1 kernel: ACPI: PCI interrupt 0000:02:03.1[B] -> GSI 
25 (level, low) -> IRQ 58
Nov 14 09:51:14 filer1 kernel: mptbase: Initiating ioc3 bringup
Nov 14 09:51:14 filer1 kernel: ioc3: 53C1030: 
Capabilities={Initiator,Target}
Nov 14 09:51:14 filer1 kernel: Fusion MPT SCSI Host driver 3.01.09
Nov 14 09:51:14 filer1 kernel: scsi2 : ioc0: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=201
Nov 14 09:51:18 filer1 kernel: scsi3 : ioc1: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=209
Nov 14 09:51:22 filer1 kernel: scsi4 : ioc2: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=50
Nov 14 09:51:26 filer1 kernel: scsi5 : ioc3: LSI53C1030, FwRev=01032700h, 
Ports=1, MaxQ=255, IRQ=58
Nov 14 09:51:27 filer1 kernel:   Vendor: BROWNIE   Model: 8600U3 
Rev: 0001
Nov 14 09:51:27 filer1 kernel:   Type:   Direct-Access 
ANSI SCSI revision: 03
Nov 14 09:52:59 filer1 kernel: SCSI device sda: 3417931776 512-byte hdwr 
sectors (1749981 MB)
Nov 14 09:53:04 filer1 kernel: mptbase: ioc3: IOCStatus(0x0047): SCSI 
Protocol Error
Nov 14 09:53:27 filer1 last message repeated 4 times
Nov 14 09:53:27 filer1 kernel: SCSI device sda: drive cache: write back
Nov 14 09:53:27 filer1 kernel:  /dev/scsi/host5/bus0/target8/lun0: p1
Nov 14 09:53:27 filer1 kernel: Attached scsi disk sda at scsi5, channel 0, 
id 8, lun 0


and last, kernel logs for another BR8600 attached to a server running
kernel 2.4.31 (with an Adaptec SCSI Host adapter) :

Oct 16 17:14:01 mpopu kernel: scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
Oct 16 17:14:01 mpopu kernel:         <Adaptec AIC7902 Ultra320 SCSI adapter>
Oct 16 17:14:01 mpopu kernel:         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
Oct 16 17:14:01 mpopu kernel:
Oct 16 17:14:01 mpopu kernel: scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
Oct 16 17:14:01 mpopu kernel:         <Adaptec AIC7902 Ultra320 SCSI adapter>
Oct 16 17:14:01 mpopu kernel:         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
Oct 16 17:14:01 mpopu kernel:
Oct 16 17:14:01 mpopu kernel: blk: queue f63fca18, I/O limit 4095Mb (mask 0xffffffff)
Oct 16 17:14:01 mpopu kernel: scsi1:A:8:0: DV failed to configure device. 
Please file a bug report against this driver.
Oct 16 17:14:01 mpopu kernel: (scsi1:A:8): 160.000MB/s transfers (80.000MHz DT,
16bit)
Oct 16 17:14:01 mpopu kernel:   Vendor: BROWNIE   Model: 8600U3            Rev:
0001
Oct 16 17:14:01 mpopu kernel:   Type:   Direct-Access                      ANSI
SCSI revision: 03
Oct 16 17:14:01 mpopu kernel: blk: queue f63fc818, I/O limit 4095Mb (mask 0xffffffff)
Oct 16 17:14:01 mpopu kernel: Attached scsi disk sdb at scsi1, channel 0, id 8,
lun 0
Oct 16 17:14:01 mpopu kernel: SCSI device sdb: 3417931776 512-byte hdwr sectors
(1749981 MB)
Oct 16 17:14:01 mpopu kernel:  sdb: sdb1


-- 
 		Etienne Vogt (Etienne.Vogt@obspm.fr)
 		Observatoire de Paris-Meudon, France
