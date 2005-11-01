From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: [PATCH]: Fusion-MPT slowness workaround
Date: Tue, 1 Nov 2005 13:39:01 -0800
Message-ID: <200511012139.jA1Ld1g00601@unix-os.sc.intel.com>
References: <91888D455306F94EBD4D168954A9457C04BE8405@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr23.intel.com ([143.183.121.15]:27839 "EHLO
	scsfmr003.sc.intel.com") by vger.kernel.org with ESMTP
	id S1750920AbVKAVj0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 16:39:26 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C04BE8405@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Moore, Eric Dean'" <Eric.Moore@lsil.com>, Martin Devera <devik@cdi.cz>, bstroesser@fujitsu-siemens.com, rupert@aquabolt.com
Cc: linux-scsi@vger.kernel.org

Moore, Eric Dean wrote on Tuesday, November 01, 2005 11:35 AM
> Here is a patch I would like to have tested to address the
> performance issue many have posted to the forum.
> 
> I've added spin-lock to control domain validation, and 
> alternate controller bringup which are occuring at the same time,
> and causing dv to fail.  Thanks to Kenneth Chen and Bodo Stroesser.

With the patch, Kernel hung at boot (2.6.14 is used).

boot log as following:

[other stuff snipped] ....
Fusion MPT base driver 3.03.03
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.03.03
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

