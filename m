From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: mpt fusion driver performance issue in 2.6.14-rc2
Date: Thu, 29 Sep 2005 11:59:19 -0700
Message-ID: <200509291859.j8TIxKg13339@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr22.intel.com ([143.183.121.14]:26270 "EHLO
	scsfmr002.sc.intel.com") by vger.kernel.org with ESMTP
	id S964775AbVI2S7a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 14:59:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "'Moore, Eric Dean'" <Eric.Moore@lsil.com>

Something happened in between kernel 2.6.12 and 2.6.14-rc2, where
disk performance went 20X slower on the latest release kernel. I
suspect it has something to do with the fusion driver. This showed
up in the boot log: "mptscsih: ioc0: DV: Release failed." is it
significant?


2.6.12 

[root]# hdparm -t /dev/sdc
 Timing buffered disk reads:  174 MB in  3.03 seconds =  57.44 MB/sec

2.6.14-rc2

[root]# hdparm -t /dev/sdc
 Timing buffered disk reads:    8 MB in  3.16 seconds =   2.53 MB/sec


Partial boot log with 2.6.14-rc2:

Fusion MPT base driver 3.03.02
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.03.02
GSI 28 (level, low) -> CPU 0 (0xc618) vector 49
ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 28 (level, low) -> IRQ 49
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=255, IRQ=49
  Vendor: MAXTOR    Model: ATLAS10K3_18_SCA  Rev: B000
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
  Vendor: QUANTUM   Model: ATLAS IV 9 SCA    Rev: 0B0B
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 17942584 512-byte hdwr sectors (9187 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 17942584 512-byte hdwr sectors (9187 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
  Vendor: SEAGATE   Model: ST336752LC        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 71687369 512-byte hdwr sectors (36704 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 71687369 512-byte hdwr sectors (36704 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1 sdc2
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
  Vendor: ESG-SHV   Model: SCA HSBP M17      Rev: 1.0D
  Type:   Processor                          ANSI SCSI revision: 02
GSI 29 (level, low) -> CPU 3 (0xc018) vector 50
ACPI: PCI Interrupt 0000:06:02.1[B] -> GSI 29 (level, low) -> IRQ 50
mptbase: Initiating ioc1 bringup
mptscsih: ioc0: DV: Release failed. id 0<6>ioc1: 53C1030: Capabilities={Initiator}
scsi1 : ioc1: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=255, IRQ=50

