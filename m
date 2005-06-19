From: Christian Werner <werner@itm.uni-luebeck.de>
Subject: endless loop problem with SYM8xx_2: unexpected disconnect
Date: Sun, 19 Jun 2005 12:45:24 +0200
Message-ID: <42B54CC4.9060005@itm.uni-luebeck.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <200504092344.41310.peter.missel@onlinehome.de> <200505042347.31251.peter.missel@onlinehome.de> <200506182352.47197.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:3788 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S262230AbVFSKp1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 06:45:27 -0400
In-Reply-To: <200506182352.47197.peter.missel@onlinehome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dariush Forouher <forouher@itm.uni-luebeck.de>

Hi,

recently we've tried to use our DawiControl DC-29160 (LSI 53C1010) with 
kernel 2.6.11, but loading the SYM8xx_2 driver ended up in an endless 
loop. With kernel 2.6.4 everything is working fine and with 2.6.8 the 
error is the same. So obviously something's got broken between 2.6.4 and 
2.6.8.

We didn't do any tests with kernel 2.6.12 yet, because this machine is 
in productive use and we have to think twice before booting a new 
kernel. When the error occured we unfortunately had no verbose SCSI 
error reporting enabled. We also didn't do any more tests, because we 
had to get this machine working again fast. Hopefully our error report 
is helpful anyway.

With Kernel 2.6.4. everything is ok:

Jun  4 16:36:29 itm01 kernel: sym0: <1010-66> rev 0x1 at pci 
0000:00:06.0 irq 10
Jun  4 16:36:29 itm01 kernel: sym0: using 64 bit DMA addressing
Jun  4 16:36:29 itm01 kernel: sym0: No NVRAM, ID 7, Fast-80, LVD, parity 
checking
Jun  4 16:36:29 itm01 kernel: sym0: SCSI BUS has been reset.
Jun  4 16:36:29 itm01 kernel: scsi1 : sym-2.1.18f
Jun  4 16:36:29 itm01 kernel:   Vendor: transtec  Model:  
T5008R           Rev: 0001
Jun  4 16:36:29 itm01 kernel:   Type:   
Direct-Access                      ANSI SCSI revision: 03
Jun  4 16:36:29 itm01 kernel: sym0:0:0: tagged command queuing enabled, 
command queue depth 16.
Jun  4 16:36:29 itm01 kernel: sym0:0: FAST-80 WIDE SCSI 160.0 MB/s DT 
(12.5 ns, offset 31)
Jun  4 16:36:29 itm01 kernel: SCSI device sda: 3431579648 512-byte hdwr 
sectors (1756969 MB)
Jun  4 16:36:29 itm01 kernel: SCSI device sda: drive cache: write back
Jun  4 16:36:29 itm01 kernel:  sda: sda1
Jun  4 16:36:29 itm01 kernel: Attached scsi disk sda at scsi1, channel 
0, id 0, lun 0

*******************************************************************

Same hardware configuration but with kernel 2.6.11:

Jun  4 15:59:01 itm01 kernel: sym0: <1010-66> rev 0x1 at pci 
0000:00:06.0 irq 10
Jun  4 15:59:01 itm01 kernel: sym0: using 64 bit DMA addressing
Jun  4 15:59:01 itm01 kernel: sym0: No NVRAM, ID 7, Fast-80, LVD, parity 
checking
Jun  4 15:59:01 itm01 kernel: sym0: SCSI BUS has been reset.
Jun  4 15:59:01 itm01 kernel: scsi3 : sym-2.1.18j
Jun  4 15:59:01 itm01 kernel:   Vendor: transtec  Model:  
T5008R           Rev: 0001
Jun  4 15:59:01 itm01 kernel:   Type:   
Direct-Access                      ANSI SCSI revision: 03
Jun  4 15:59:01 itm01 kernel: sym0:0:0: tagged command queuing enabled, 
command queue depth 16.
Jun  4 15:59:01 itm01 kernel: scsi(3:0:0:0): Beginning Domain Validation
Jun  4 15:59:01 itm01 kernel: sym0: unexpected disconnect
Jun  4 15:59:01 itm01 kernel: scsi(3:0:0:0): Ending Domain Validation
Jun  4 15:59:01 itm01 kernel: sdb: Unit Not Ready, error = 0x100ff
Jun  4 15:59:01 itm01 kernel: sdb : READ CAPACITY failed.
Jun  4 15:59:01 itm01 kernel: sdb : status=1f, message=00, host=1, driver=00
Jun  4 15:59:01 itm01 kernel: sdb : sense not available.
Jun  4 15:59:01 itm01 kernel:  /dev/scsi/host3/bus0/target0/lun0:SCSI 
error : <3 0 0 0> return code = 0x100ff
Jun  4 15:59:01 itm01 kernel: end_request: I/O error, dev sdb, sector 0
Jun  4 15:59:01 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 15:59:01 itm01 kernel: end_request: I/O error, dev sdb, sector 0
Jun  4 15:59:01 itm01 kernel:  unable to read partition table
Jun  4 15:59:01 itm01 kernel: Attached scsi disk sdb at scsi3, channel 
0, id 0, lun 0
Jun  4 15:59:01 itm01 kernel: sym0: unexpected disconnect
Jun  4 15:59:01 itm01 kernel: sym0: unexpected disconnect
Jun  4 16:00:05 itm01 kernel: sym0: unexpected disconnect
Jun  4 16:00:06 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:06 itm01 kernel: end_request: I/O error, dev sdb, sector 0
Jun  4 16:00:06 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:06 itm01 kernel: end_request: I/O error, dev sdb, sector 8
Jun  4 16:00:06 itm01 kernel: sym0: unexpected disconnect
Jun  4 16:00:07 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:07 itm01 kernel: end_request: I/O error, dev sdb, sector 16
Jun  4 16:00:07 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:07 itm01 kernel: end_request: I/O error, dev sdb, sector 24
Jun  4 16:00:07 itm01 kernel: sym0: unexpected disconnect
Jun  4 16:00:07 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:07 itm01 kernel: end_request: I/O error, dev sdb, sector 32
Jun  4 16:00:08 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:08 itm01 kernel: end_request: I/O error, dev sdb, sector 40
Jun  4 16:00:08 itm01 kernel: sym0: unexpected disconnect
Jun  4 16:00:08 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:08 itm01 kernel: end_request: I/O error, dev sdb, sector 48
Jun  4 16:00:09 itm01 kernel: SCSI error : <3 0 0 0> return code = 0x100ff
Jun  4 16:00:09 itm01 kernel: end_request: I/O error, dev sdb, sector 56
[continuing in endless loop ...]

*******************************************************************

Some details about our hardware configuration:
- The max. SCSI speed is set to 160MB/sec in the adapter's NVRAM. Cable 
length is about 3 meters.
- There is only one device attached to the bus. It is an 
ATA-to-SCSI-RAID with 1.6 TBytes capacity.
- The adapter is a 64-Bit PCI card (mounted in a 32-Bit PCI slot).

Is this particular problem already known (We couldn't find any matching 
bug report)?

Thanks for your help!

Dariush and Christian
