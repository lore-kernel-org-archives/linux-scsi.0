From: Russell King <rmk@arm.linux.org.uk>
Subject: 2.6.0-test9: BUG: partitions added twice
Date: Sat, 1 Nov 2003 12:56:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031101125609.A30624@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:23824 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S263788AbTKAM4M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Nov 2003 07:56:12 -0500
Received: from flint.arm.linux.org.uk ([2002:d412:e8ba:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.22)
	id 1AFvIY-00088t-8w
	for linux-scsi@vger.kernel.org; Sat, 01 Nov 2003 12:56:10 +0000
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.22)
	id 1AFvIX-00082l-AH
	for linux-scsi@vger.kernel.org; Sat, 01 Nov 2003 12:56:09 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ok, more SCSI problems...

I've just booted 2.6.0-test9 again on this machine, and, having got
the scsi_dev_info parameter wrong again, it decided to go and try
to spin up the non-existent disk in the syquest drive again.

So, rather than wait the 5 or so minutes for the kernel to eventually
get the idea that it can't, I decided to put a cartridge in.  I was
then greeted by the following:

scsi0 : PowerTec SCSI (QLogic FAS216) in slot 0 v1.10 (19/01/2003 2.5.59) terminators on
  Vendor: SONY      Model: SDT-5200          Rev: 3.30
  Type:   Sequential-Access                  ANSI SCSI revision: 02
  Vendor: SyQuest   Model: SQ3270S           Rev: 3-14
  Type:   Direct-Access                      ANSI SCSI revision: 02
sda: Spinning up disk................................................................................................not responding...
sda : READ CAPACITY failed.
sda : status=1, message=00, host=0, driver=08
Current sd?: sense key Not Ready
Additional sense: Logical unit not ready, cause not reportable
sda: Write Protect is off
sda: Mode Sense: 99 00 00 08
SCSI device sda: drive cache: write back
sda: Spinning up disk...........................................ready
SCSI device sda: 524288 512-byte hdwr sectors (268 MB)
sda: Write Protect is off
sda: Mode Sense: 99 00 00 08
SCSI device sda: drive cache: write back
SCSI device sda: 524288 512-byte hdwr sectors (268 MB)
sda: Write Protect is off
sda: Mode Sense: 99 00 00 08
SCSI device sda: drive cache: write back
 sda: sda1 sda2
 sda: sda1 sda2
kobject_register failed for sda1 (-17)
[<c002acbc>] (dump_stack+0x0/0x14) from [<c00df8dc>] (kobject_register+0x40/0x54)
[<c00df89c>] (kobject_register+0x0/0x54) from [<c009edf4>] (add_partition+0xa0/0xc4)
[<c009ed54>] (add_partition+0x0/0xc4) from [<c009ef54>] (register_disk+0xe8/0x114)
[<c009ee6c>] (register_disk+0x0/0x114) from [<c01130d8>] (add_disk+0x50/0x64)
[<c0113088>] (add_disk+0x0/0x64) from [<c0143d7c>] (sd_probe+0x1f0/0x284)
[<c0143b8c>] (sd_probe+0x0/0x284) from [<c010c5e0>] (bus_match+0x48/0x70)
[<c010c598>] (bus_match+0x0/0x70) from [<c010c6dc>] (driver_attach+0x48/0x7c)
[<c010c694>] (driver_attach+0x0/0x7c) from [<c010c90c>] (bus_add_driver+0x70/0x80)
[<c010c89c>] (bus_add_driver+0x0/0x80) from [<c010cc0c>] (driver_register+0x48/0x4c)
[<c010cbc4>] (driver_register+0x0/0x4c) from [<c013b514>] (scsi_register_driver+0x1c/0x24)
[<c013b4f8>] (scsi_register_driver+0x0/0x24) from [<c0018044>] (init_sd+0x68/0x84)
[<c0017fdc>] (init_sd+0x0/0x84) from [<c0008804>] (do_initcalls+0x4c/0xc0)
[<c00087b8>] (do_initcalls+0x0/0xc0) from [<c0008898>] (do_basic_setup+0x20/0x24)
[<c0008878>] (do_basic_setup+0x0/0x24) from [<c00210a4>] (init+0x28/0xd4)
[<c002107c>] (init+0x0/0xd4) from [<c003ee54>] (do_exit+0x0/0x3c0)
kobject_register failed for sda2 (-17)
[<c002acbc>] (dump_stack+0x0/0x14) from [<c00df8dc>] (kobject_register+0x40/0x54)
[<c00df89c>] (kobject_register+0x0/0x54) from [<c009edf4>] (add_partition+0xa0/0xc4)
[<c009ed54>] (add_partition+0x0/0xc4) from [<c009ef54>] (register_disk+0xe8/0x114)
[<c009ee6c>] (register_disk+0x0/0x114) from [<c01130d8>] (add_disk+0x50/0x64)
[<c0113088>] (add_disk+0x0/0x64) from [<c0143d7c>] (sd_probe+0x1f0/0x284)
[<c0143b8c>] (sd_probe+0x0/0x284) from [<c010c5e0>] (bus_match+0x48/0x70)
[<c010c598>] (bus_match+0x0/0x70) from [<c010c6dc>] (driver_attach+0x48/0x7c)
[<c010c694>] (driver_attach+0x0/0x7c) from [<c010c90c>] (bus_add_driver+0x70/0x80)
[<c010c89c>] (bus_add_driver+0x0/0x80) from [<c010cc0c>] (driver_register+0x48/0x4c)
[<c010cbc4>] (driver_register+0x0/0x4c) from [<c013b514>] (scsi_register_driver+0x1c/0x24)
[<c013b4f8>] (scsi_register_driver+0x0/0x24) from [<c0018044>] (init_sd+0x68/0x84)
[<c0017fdc>] (init_sd+0x0/0x84) from [<c0008804>] (do_initcalls+0x4c/0xc0)
[<c00087b8>] (do_initcalls+0x0/0xc0) from [<c0008898>] (do_basic_setup+0x20/0x24)
[<c0008878>] (do_basic_setup+0x0/0x24) from [<c00210a4>] (init+0x28/0xd4)
[<c002107c>] (init+0x0/0xd4) from [<c003ee54>] (do_exit+0x0/0x3c0)
Attached scsi removable disk sda at scsi0, channel 0, id 2, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 1, lun 0,  type 1
Attached scsi generic sg1 at scsi0, channel 0, id 2, lun 0,  type 0

/sys contains:

/sys/block/sda
|-- dev
|-- device -> ../../devices/ecard1/host0/0:0:2:0
|-- queue
|   |-- iosched
|   |   |-- antic_expire
|   |   |-- read_batch_expire
|   |   |-- read_expire
|   |   |-- write_batch_expire
|   |   `-- write_expire
|   `-- nr_requests
|-- range
|-- sda1
|   |-- dev
|   |-- size
|   |-- start
|   `-- stat
|-- sda2
|   |-- dev
|   |-- size
|   |-- start
|   `-- stat
|-- size
`-- stat

5 directories, 18 files

so I guess its trying to add sda1 and sda2 twice.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
