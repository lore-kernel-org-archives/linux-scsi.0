From: "Ronny T. Lampert" <telecaadmin@uni.de>
Subject: aic79xx LUN detection failure
Date: Mon, 27 Jun 2005 14:56:52 +0200
Message-ID: <42BFF794.2010307@uni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.111.48.251] ([217.111.48.251]:65530 "EHLO
	mail.telecasystems.de") by vger.kernel.org with ESMTP
	id S262179AbVF0M4y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 08:56:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

using aic79xx under 2.6.12 still (as it has done since the beginning) fails
for me; 2.4.23+ is running fine.

2.4.23:

scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7901A: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7901A: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

blk: queue f39bfa18, I/O limit 4095Mb (mask 0xffffffff)
scsi2:A:5:0: DV failed to configure device.  Please file a bug report
against this driver.
(scsi2:A:5): 160.000MB/s transfers (80.000MHz DT, 16bit)
  Vendor: easyRAID  Model:  16P              Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f34ef018, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: easyRAID  Model:  16P              Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f34d9e18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: easyRAID  Model:  16P              Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f34d9c18, I/O limit 4095Mb (mask 0xffffffff)
scsi2:A:5:0: Tagged Queuing enabled.  Depth 127
scsi2:A:5:1: Tagged Queuing enabled.  Depth 127
scsi2:A:5:2: Tagged Queuing enabled.  Depth 127
Attached scsi disk sdb at scsi2, channel 0, id 5, lun 0
Attached scsi disk sdc at scsi2, channel 0, id 5, lun 1
Attached scsi disk sdd at scsi2, channel 0, id 5, lun 2
SCSI device sdb: 980451328 512-byte hdwr sectors (501991 MB)
 sdb: sdb1
SCSI device sdc: 1470676992 512-byte hdwr sectors (752987 MB)
 sdc: sdc1
SCSI device sdd: 640319488 512-byte hdwr sectors (327844 MB)
 sdd: sdd1


2.6.12.1 is giving:

scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

input: AT Translated Set 2 keyboard on isa0060/serio0
scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

scsi2:A:5:0: DV failed to configure device.  Please file a bug report
against this driver.
(scsi2:A:5): 160.000MB/s transfers (80.000MHz DT, 16bit)
  Vendor: easyRAID  Model:  16P              Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi2:A:5:0: Tagged Queuing enabled.  Depth 127
SCSI device sdb: 980451328 512-byte hdwr sectors (501991 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 980451328 512-byte hdwr sectors (501991 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1
Attached scsi disk sdb at scsi2, channel 0, id 5, lun 0
scsi: host 2 channel 0 id 5 lun 0x00000200080c0400 has a LUN larger than
currently supported.
scsi: host 2 channel 0 id 5 lun 0xff010000ffffffff has a LUN larger than
currently supported.
scsi: host 2 channel 0 id 5 lun 0x0002202020202020 has a LUN larger than
currently supported.
scsi: host 2 channel 0 id 5 lun808529923 has a LUN larger than allowed by
the host adapter
scsi: host 2 channel 0 id 5 lun3078 has a LUN larger than allowed by the
host adapter


The RAID configuration is showing that it is using LUNs 0-2 as 2.4
indicates. Termination is okay.

Seems like a strange driver problem. What to do?

Cheers,
Ronny

