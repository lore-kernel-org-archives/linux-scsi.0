From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Sun, 14 Mar 2010 13:54:09 +0200
Message-ID: <4B9CCE61.2070600@gmail.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN> <1267786018.8894.43.camel@mulgrave.site> <6B62480106F2B34D8404CF2FDAA4D9EF71F65D5D21@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54585 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0CNLyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Mar 2010 07:54:16 -0400
Received: by bwz1 with SMTP id 1so2186808bwz.21
        for <linux-scsi@vger.kernel.org>; Sun, 14 Mar 2010 04:54:14 -0700 (PDT)
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F65D5D21@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I have installed an AOC-SASLP-MV8 on my system (arch linux amd64 2.6.33 
with latest mvsas patch from Srinivas). I do not have any mdraid config, 
every drive has its own filesystem. Everything works fine, unless i try 
to boot with 8 disks. Then booting stalls during the mount disk phase 
and eventually i get an "unable to read superblock" message(curiously 
fscking all the disks seems to work just before that). When that 
happens, the blue activity light for the first drive is constantly on. 
This also happened with the stock 2.6.33 kernel.

With 7 or less disks everything works ok, except for this warning that 
does not seem to interfere with the operation of the card.

------------[ cut here ]------------
WARNING: at drivers/ata/libata-core.c:5186 ata_qc_issue+0x31f/0x330 
[libata]()
Hardware name:
Modules linked in: ipv6 hwmon_vid xfs exportfs jfs cpufreq_powersave 
cpufreq_ondemand fan powernow_k8 freq_table firewire_ohci psmouse 
firewire_core edac_core thermal i2c_nforce2 crc_itu_t serio_raw k8temp 
skge edac_mce_amd button evdev processor pcspkr fuse forcedeth sg 
i2c_core rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 dm_crypt 
dm_mod ohci_hcd sd_mod usb_storage ehci_hcd mvsas libsas sata_sil 
scsi_transport_sas pata_amd sata_nv usbcore sata_via ata_generic 
pata_via pata_acpi libata scsi_mod
Pid: 2920, comm: hddtemp Not tainted 2.6.33-ARCH #1
Call Trace:
  [<ffffffff810528e8>] warn_slowpath_common+0x78/0xb0
  [<ffffffff8105292f>] warn_slowpath_null+0xf/0x20
  [<ffffffffa002c14f>] ata_qc_issue+0x31f/0x330 [libata]
  [<ffffffffa0006fae>] ? scsi_init_sgtable+0x4e/0x90 [scsi_mod]
  [<ffffffffa0033cd0>] ? ata_scsi_pass_thru+0x0/0x2f0 [libata]
  [<ffffffffa00310c6>] ata_scsi_translate+0xa6/0x180 [libata]
  [<ffffffffa0000b10>] ? scsi_done+0x0/0x20 [scsi_mod]
  [<ffffffffa0000b10>] ? scsi_done+0x0/0x20 [scsi_mod]
  [<ffffffffa0034369>] ata_sas_queuecmd+0x139/0x2b0 [libata]
  [<ffffffffa00e4098>] sas_queuecommand+0x98/0x300 [libsas]
  [<ffffffffa0000c25>] scsi_dispatch_cmd+0xf5/0x230 [scsi_mod]
  [<ffffffffa0006ba2>] scsi_request_fn+0x322/0x3e0 [scsi_mod]
  [<ffffffff81061937>] ? lock_timer_base+0x37/0x70
  [<ffffffff811b6d0c>] __blk_run_queue+0x5c/0x150
  [<ffffffff811b0760>] elv_insert+0x140/0x230
  [<ffffffff811b08ba>] __elv_add_request+0x6a/0xc0
  [<ffffffff811bc960>] blk_execute_rq_nowait+0x60/0xb0
  [<ffffffff811bca31>] blk_execute_rq+0x81/0xf0
  [<ffffffff811bc7e8>] ? blk_rq_map_user+0x198/0x270
  [<ffffffff811c0b3b>] sg_io+0x28b/0x3d0
  [<ffffffff811c14c0>] scsi_cmd_ioctl+0x4d0/0x530
  [<ffffffff8115146b>] ? blkdev_get+0xb/0x10
  [<ffffffff811514dc>] ? blkdev_open+0x6c/0xc0
  [<ffffffffa00023cd>] ? scsi_ioctl+0x27d/0x390 [scsi_mod]
  [<ffffffffa0128cff>] sd_ioctl+0x8f/0xe0 [sd_mod]
  [<ffffffff811be0cf>] __blkdev_driver_ioctl+0x8f/0xb0
  [<ffffffff811be59e>] blkdev_ioctl+0x22e/0x820
  [<ffffffff8114fca7>] block_ioctl+0x37/0x40
  [<ffffffff81131978>] vfs_ioctl+0x38/0xd0
  [<ffffffff81131b20>] do_vfs_ioctl+0x80/0x560
  [<ffffffff81132081>] sys_ioctl+0x81/0xa0
  [<ffffffff8100a002>] system_call_fastpath+0x16/0x1b
---[ end trace 881aaf5eceedc267 ]---

SMART works ok, except for a WD drive that needs a -T permissive to work
(the other WD drive on the controller, a WDC WD15EADS-00P8B0, works 
without the -T permissive switch)

root ~  #  smartctl -a -d ata /dev/sdk
smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green family
Device Model:     WDC WD15EADS-00S2B0
Serial Number:    WD-WCAVY1089106
Firmware Version: 01.00A01
User Capacity:    1,500,301,910,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Mar 14 13:39:47 2010 EET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Register values returned from SMART Status command are:
ST =0x40
ERR=0x00
NS =0x14
SC =0xa7
CL =0x1f
CH =0xf8
SEL=0x40
A mandatory SMART command failed: exiting. To continue, add one or more 
'-T permissive' options.

I am now stressing the card, reading and writing data at the same time 
from every single disk on my system and everything seems to work ok 
(fingers crossed). The real test for me will be when I install an HP SAS 
expander that i am waiting for any day now.
