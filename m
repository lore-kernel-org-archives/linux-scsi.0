From: Carsten John <cjohn@mpi-bremen.de>
Subject: LSI 22320-R with >3TB RAID problem
Date: Tue, 23 Jan 2007 17:11:29 +0100
Message-ID: <1169568690.632690@magnum.mpi-bremen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42412 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbXAWQUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 11:20:12 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1H9ONP-0005Ge-Jt
	for linux-scsi@vger.kernel.org; Tue, 23 Jan 2007 17:20:03 +0100
Received: from magnum.mpi-bremen.de ([134.102.40.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 17:20:03 +0100
Received: from cjohn by magnum.mpi-bremen.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 17:20:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everybody,

I'm running into Problems with an external Transtec RAID System (it's an
labled EONSTOR). The RAID has about 3.5TB in total. The RAID is
recognized, but can't be accessed.

a similar EONSTOR RAID with 2.5TB is recognized and can be accessed,
despite a few I/O errors during startup.

hardware:
P4 Asus Server
LSI 22320-R SCSI HBA, firmware MPTBIOS-IM-5.07.02
EONSTOR RAID

software:
Ubuntu 6.06 "dapper"
Ubuntu server kernel 2.6.15

relevant dmesg output:
[42949375.460000] Fusion MPT base driver 3.03.04
[42949375.460000] Copyright (c) 1999-2005 LSI Logic Corporation
[42949375.460000] Fusion MPT SPI Host driver 3.03.04
[42949375.460000] ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 24 (level,
low) -> IRQ 169
[42949375.460000] mptbase: Initiating ioc0 bringup
[42949376.640000] ioc0: 53C1030: Capabilities={Initiator}
[42949377.490000] scsi0 : ioc0: LSI53C1030, FwRev=01030700h, Ports=1,
MaxQ=222, IRQ=169
[42949377.490000]   Vendor: IFT       Model: U16U-G4010-6      Rev: 342F
[42949377.490000]   Type:   Direct-Access                      ANSI SCSI
revision: 03
[42949380.990000] ACPI: PCI Interrupt 0000:02:02.1[B] -> GSI 25 (level,
low) -> IRQ 177
[42949380.990000] mptbase: Initiating ioc1 bringup
[42949382.170000] ioc1: 53C1030: Capabilities={Initiator}
[42949383.010000] scsi1 : ioc1: LSI53C1030, FwRev=01030700h, Ports=1,
MaxQ=222, IRQ=177
[42949383.010000]   Vendor: transtec  Model: T6100S08R1-D      Rev: 342J
[42949383.010000]   Type:   Direct-Access                      ANSI SCSI
revision: 05
[42949383.010000] Driver 'sd' needs updating - please use bus_type methods
[42949383.010000] sda : very big device. try to use READ CAPACITY(16).
[42949383.010000] SCSI device sda: 4683300864 512-byte hdwr sectors
(2397850 MB)
[42949383.010000] SCSI device sda: drive cache: write back
[42949383.020000] sda : very big device. try to use READ CAPACITY(16).
[42949383.020000] SCSI device sda: 4683300864 512-byte hdwr sectors
(2397850 MB)
[42949383.020000] SCSI device sda: drive cache: write back
[42949383.020000]  sda:<6>sd 0:0:0:0: SCSI error: return code = 0xb0000
[42949383.030000] end_request: I/O error, dev sda, sector 4683300856
[42949383.030000] Buffer I/O error on device sda, logical block 585412607
[42949383.030000] sd 0:0:0:0: SCSI error: return code = 0xb0000
[42949383.030000] end_request: I/O error, dev sda, sector 4683300856
[42949383.030000] Buffer I/O error on device sda, logical block 585412607
[42949383.030000] Alternate GPT is invalid, using primary GPT.
[42949383.030000]  sda1
[42949383.030000] sd 0:0:0:0: Attached scsi disk sda
[42949384.510000] sdb : very big device. try to use READ CAPACITY(16).
[42949385.010000] SCSI device sdb: 6833670144 512-byte hdwr sectors
(3498839 MB)
[42949386.510000] SCSI device sdb: drive cache: write back
[42949386.510000] sdb : very big device. try to use READ CAPACITY(16).
[42949386.510000] SCSI device sdb: 6833670144 512-byte hdwr sectors
(3498839 MB)
[42949386.510000] SCSI device sdb: drive cache: write back
[42949386.510000]  sdb:<6>sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.520000] end_request: I/O error, dev sdb, sector 6833670136
[42949386.520000] Buffer I/O error on device sdb, logical block 854208767
[42949386.520000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.520000] end_request: I/O error, dev sdb, sector 6833670136
[42949386.520000] Buffer I/O error on device sdb, logical block 854208767
[42949386.520000] Alternate GPT is invalid, using primary GPT.
[42949386.520000]
[42949386.520000] sd 1:0:0:0: Attached scsi disk sdb
[42949386.550000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.550000] end_request: I/O error, dev sdb, sector 6833670016
[42949386.550000] Buffer I/O error on device sdb, logical block 854208752
[42949386.560000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.560000] end_request: I/O error, dev sdb, sector 6833670016
[42949386.560000] Buffer I/O error on device sdb, logical block 854208752
[42949386.560000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.560000] end_request: I/O error, dev sdb, sector 6833670136
[42949386.560000] Buffer I/O error on device sdb, logical block 854208767
[42949386.560000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.560000] end_request: I/O error, dev sdb, sector 6833670136
[42949386.560000] Buffer I/O error on device sdb, logical block 854208767
[42949386.560000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.560000] end_request: I/O error, dev sdb, sector 6833670136
[42949386.560000] Buffer I/O error on device sdb, logical block 854208767
[42949386.560000] sd 1:0:0:0: SCSI error: return code = 0xb0000
[42949386.560000] end_request: I/O error, dev sdb, sector 6833670136


Any ideas?



Thanks

Carsten


			
-- 
Max Planck Institut fuer marine Mikrobiologie
- Network Administration -
Celsiustr. 1
D-28359 Bremen
Tel.: +49 421 2028568
Fax.: +49 421 2028565

