From: Nicolas Meaux <nicolas.meaux@artabel.net>
Subject: crashing with sym53c8xx
Date: Tue, 16 Dec 2003 10:00:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDEC999.9050702@artabel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from artabel.net1.nerim.net ([62.212.107.173]:16336 "EHLO
	mail.artabel.net") by vger.kernel.org with ESMTP id S261270AbTLPJAL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2003 04:00:11 -0500
Received: from artabel.net (gondor.bel [192.168.1.73])
	by mail.artabel.net (Postfix) with ESMTP id 35C323E482
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2003 10:00:08 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have trouble with a server and its RAID 5 file system, the system 
crash sometimes and especially when i have a very strong activity on the 
RAID system.
I have often change the kernel version ( i have actually compiled the 
2.4.23 ), but it has done nothing.
My raid system is composed of 8 disks SCSI of 36 Go each, in software raid.
When the system crash, a random LED is lit.
I think it is a SCSI problem, i have changed the SCSI cable, but nothing 
better.
My SCSI controller is a "LSI SYMBIOS 53c896", so i use the SYM53C8XX of 
the kernel.
I have used version 1 and 2 of these drivers and had got the same result ...
I have also activated the "use normal IO" of the version 2, but also the 
same problemes.

I have noticed this, ( it is not systematic ), when the file system were 
under load ( but he does not have crashed this time ) :
kernel: sym1: SCSI parity error detected: SCR1=3 DBC=10000800 SBCL=28
kernel: sym1: SCSI BUS reset detected.
kernel: sym1: SCSI BUS has been reset.

Here is my dmesg :

sym0: <896> rev 0x7 on pci bus 1 device 5 function 0 irq 24
sym0: using 64 bit DMA addressing
sym0: Symbios NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
sym1: <896> rev 0x7 on pci bus 1 device 5 function 1 irq 25
sym1: using 64 bit DMA addressing
sym1: Symbios NVRAM, ID 15, Fast-40, LVD, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
scsi0 : sym-2.1.17a
scsi1 : sym-2.1.17a
blk: queue dfde6e18, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: DDYS-T36950M      Rev: S96H
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfdc9e18, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: DDYS-T36950M      Rev: S96H
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfdc9a18, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfdc9618, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfdc9218, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd62e18, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd62a18, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd62618, I/O limit 1048575Mb (mask 0xffffffffff)
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd62218, I/O limit 1048575Mb (mask 0xffffffffff)
sym1:0:0: tagged command queuing enabled, command queue depth 16.
sym1:1:0: tagged command queuing enabled, command queue depth 16.
sym1:2:0: tagged command queuing enabled, command queue depth 16.
sym1:3:0: tagged command queuing enabled, command queue depth 16.
sym1:4:0: tagged command queuing enabled, command queue depth 16.
sym1:5:0: tagged command queuing enabled, command queue depth 16.
sym1:6:0: tagged command queuing enabled, command queue depth 16.
sym1:7:0: tagged command queuing enabled, command queue depth 16.
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi1, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi1, channel 0, id 3, lun 0
Attached scsi disk sde at scsi1, channel 0, id 4, lun 0
Attached scsi disk sdf at scsi1, channel 0, id 5, lun 0
Attached scsi disk sdg at scsi1, channel 0, id 6, lun 0
Attached scsi disk sdh at scsi1, channel 0, id 7, lun 0
sym1:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sda: 71687340 512-byte hdwr sectors (36704 MB)
 sda:
sym1:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdb: 71687340 512-byte hdwr sectors (36704 MB)
 sdb: unknown partition table
sym1:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdc: 71687340 512-byte hdwr sectors (36704 MB)
 sdc: unknown partition table
sym1:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdd: 71687340 512-byte hdwr sectors (36704 MB)
 sdd:
sym1:4: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sde: 71687340 512-byte hdwr sectors (36704 MB)
 sde: unknown partition table
sym1:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdf: 71687340 512-byte hdwr sectors (36704 MB)
 sdf: sdf1 sdf2 sdf3
sym1:6: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdg: 71687340 512-byte hdwr sectors (36704 MB)
 sdg: unknown partition table
sym1:7: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
SCSI device sdh: 71687340 512-byte hdwr sectors (36704 MB)
 sdh: sdh1 sdh2 < >

I have very few informations, and i am desperate ...
Thanks in advance for your help.

    Nicolas

