From: "Adam Radford" <aradford@amcc.com>
Subject: RE: 3ware 9000 driver kernel 2.6.7-rc3-mm1 vs 3ware 2.6 source
Date: Mon, 14 Jun 2004 11:30:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HZBA4M03.GZU@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:48022 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S263778AbUFNSbf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 14:31:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jurgen Kramer <gtm.kramer@inter.nl.net>, linux-scsi@vger.kernel.org

Jurgen,

This is a small bug in the 3ware driver released on the install CD. 
It is not correctly skipping channel or lun probing, therefore you
get redundant devices.  You can rectify this situation by turning
off 'Probe all LUNS for each scsi device' in your kernel config or
update your driver.

Please contact 3ware for updated driver version.  

-Adam

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org]On Behalf Of Jurgen Kramer
Sent: Saturday, June 12, 2004 5:13 AM
To: linux-kernel@vger.kernel.org
Subject: 3ware 9000 driver kernel 2.6.7-rc3-mm1 vs 3ware 2.6 source


The 3ware 9000 driver from kernel 2.6.7-rc3-mm1 just creates one scsi
device (is this case sdf) for my 4 disk RAID5 setup while the 3ware 2.6
driver from the install CD (tested with 2.6.5) creates sdf through sdm.
Each drive corresponds to the same logical drive. Is this a driver bug
or just a different approach? The in-kernel driver looks cleaner.

from 2.6.5 with 3ware driver from install CD:

3ware 9000 Storage Controller device driver for Linux v2.26.00.006fw.
3w-9xxx: scsi2: Found a 3ware 9000 Storage Controller at 0xfeafec00,
IRQ: 21.
3w-9xxx: scsi2: Firmware FE9X 2.02.00.008, BIOS BE9X 2.02.01.037, Ports:
4.
scsi2 : 3ware 9000 Storage Controller
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
 sda: sda1
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi removable disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi removable disk sdc at scsi1, channel 0, id 0, lun 1
Attached scsi removable disk sdd at scsi1, channel 0, id 0, lun 2
Attached scsi removable disk sde at scsi1, channel 0, id 0, lun 3
SCSI device sdf: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdf: drive cache: write back, no read (daft)
 sdf: sdf1
Attached scsi disk sdf at scsi2, channel 0, id 0, lun 0
SCSI device sdg: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdg: drive cache: write back, no read (daft)
 sdg: sdg1
Attached scsi disk sdg at scsi2, channel 0, id 0, lun 1
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdh: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdh: drive cache: write back, no read (daft)
 sdh: sdh1
Attached scsi disk sdh at scsi2, channel 0, id 0, lun 2
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdi: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdi: drive cache: write back, no read (daft)
 sdi: sdi1
Attached scsi disk sdi at scsi2, channel 0, id 0, lun 3
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdj: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdj: drive cache: write back, no read (daft)
 sdj: sdj1
Attached scsi disk sdj at scsi2, channel 0, id 0, lun 4
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdk: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdk: drive cache: write back, no read (daft)
 sdk: sdk1
Attached scsi disk sdk at scsi2, channel 0, id 0, lun 5
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdl: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdl: drive cache: write back, no read (daft)
 sdl: sdl1
Attached scsi disk sdl at scsi2, channel 0, id 0, lun 6
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdm: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdm: drive cache: write back, no read (daft)
 sdm: sdm1
Attached scsi disk sdm at scsi2, channel 0, id 0, lun 7

from 2.6.7-mm1:

scsi2 : 3ware 9000 Storage Controller
3w-9xxx: scsi2: Found a 3ware 9000 Storage Controller at 0xfeafec00,
IRQ: 21.
3w-9xxx: scsi2: Firmware FE9X 2.02.00.008, BIOS BE9X 2.02.01.037, Ports:
4.
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdf: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdf: drive cache: write back, no read (daft)
 sdf: sdf1
Attached scsi disk sdf at scsi2, channel 0, id 0, lun 0

Jurgen


-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

