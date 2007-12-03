From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and sata drives
Date: Mon, 3 Dec 2007 17:09:54 +0100
Message-ID: <200712031709.54168.kb@sysmikro.com.pl>
References: <200711301022.08001.kb@sysmikro.com.pl> <20071130213313.GA7066@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_SpCVHacFZ00Zyp9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:61229 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915AbXLCQJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2007 11:09:56 -0500
In-Reply-To: <20071130213313.GA7066@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

--Boundary-00=_SpCVHacFZ00Zyp9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


I noticed also another failure when i removed a drive. The event was not 
notified by anything (ie the block device and corresponding sg were 
registered) so i run dd on this truly "virtual" drive.

dd reached D state (as well as scsi_wq) . i think it shouldn't happen no 
matter it was AIC failure or LSI expander failure.

>
> --D

Regards,
Krzysztof

--Boundary-00=_SpCVHacFZ00Zyp9
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="hdd-removal-failure.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="hdd-removal-failure.log"

ata26.00: ATA-6: ST3120026AS, 3.18, max UDMA/133
ata26.00: 234441648 sectors, multi 0: LBA48 
ata26.00: ata_hpa_resize 1: hpa sectors (1) is smaller than sectors (234441648)
ata26.00: configured for UDMA/133
scsi 6:0:20:0: Direct-Access     ATA      ST3120026AS      3.18 PQ: 0 ANSI: 5
sd 6:0:20:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 6:0:20:0: [sdb] Write Protect is off
sd 6:0:20:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:20:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:20:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 6:0:20:0: [sdb] Write Protect is off
sd 6:0:20:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:20:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 6:0:20:0: [sdb] Attached SCSI disk
sd 6:0:20:0: Attached scsi generic sg1 type 0
sd 6:0:20:0: [sdb] Synchronizing SCSI cache
ata26: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata26: status=0x01 { Error }
ata26: error=0x04 { DriveStatusError }
sd 6:0:20:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
sd 6:0:19:0: [sda] Synchronizing SCSI cache
SysRq : Show Blocked State
  task                PC stack   pid father
scsi_wq_6     D 40246817     0  3727      2
       f3d7dc64 00000046 f72d5550 40246817 00000006 40128e47 f618b468 f73deac0 
       42748e00 f72d5698 f72d5550 f3d7dd30 f3d7dd34 f3d7dc80 f3d7dcb8 40402896 
       00000000 f72d5550 4011b8a0 00000000 00000000 4010fa7d f618b3fc f76d8070 
Call Trace:
 [<40246817>] elv_next_request+0xb7/0x210
 [<40128e47>] lock_timer_base+0x27/0x60
 [<40402896>] wait_for_completion+0x86/0xc0
 [<4011b8a0>] default_wake_function+0x0/0x10
 [<4010fa7d>] native_smp_send_reschedule+0x1d/0x30
 [<4011b8a0>] default_wake_function+0x0/0x10
 [<4024a511>] blk_execute_rq+0xa1/0xe0
 [<4024a770>] blk_end_sync_rq+0x0/0x30
 [<4013426b>] autoremove_wake_function+0x1b/0x50
 [<4011b8e7>] __wake_up_common+0x37/0x70
 [<403067a3>] scsi_execute+0xe3/0x110
 [<40306845>] scsi_execute_req+0x75/0xb0
 [<4031a860>] sd_sync_cache+0x70/0xb0
 [<40258ccf>] kobject_get+0xf/0x20
 [<4031ce34>] sd_shutdown+0x64/0x140
 [<4031cbe2>] sd_remove+0x32/0x70
 [<402e15c4>] __device_release_driver+0x94/0xb0
 [<402e15fe>] device_release_driver+0x1e/0x40
 [<402e0869>] bus_remove_device+0x59/0x80
 [<402dee33>] device_del+0x53/0x2c0
 [<4030bed1>] __scsi_remove_device+0x51/0x90
 [<4030bf2f>] scsi_remove_device+0x1f/0x30
 [<4030bfcf>] __scsi_remove_target+0x8f/0xc0
 [<4030c000>] __remove_child+0x0/0x20
 [<4030c018>] __remove_child+0x18/0x20
 [<402df0f2>] device_for_each_child+0x22/0x40
 [<4030c05e>] scsi_remove_target+0x3e/0x50
 [<f8d82f88>] sas_rphy_remove+0x58/0x80 [scsi_transport_sas]
 [<f8d82f28>] sas_rphy_delete+0x8/0x10 [scsi_transport_sas]
 [<f8dbb75e>] sas_unregister_dev+0x8e/0xa0 [libsas]
 [<f8dbe62f>] sas_unregister_devs_sas_addr+0x11f/0x130 [libsas]
 [<f8dbe916>] sas_rediscover_dev+0x116/0x150 [libsas]
 [<f8dbea02>] sas_rediscover+0xb2/0xe0 [libsas]
 [<f8dbb880>] sas_revalidate_domain+0x0/0x50 [libsas]
 [<f8dbea61>] sas_ex_revalidate_domain+0x31/0x70 [libsas]
 [<40130511>] run_workqueue+0x71/0x100
 [<4013061f>] worker_thread+0x7f/0xd0
 [<40134250>] autoremove_wake_function+0x0/0x50
 [<4040254a>] schedule+0x21a/0x4e0
 [<40134250>] autoremove_wake_function+0x0/0x50
 [<401305a0>] worker_thread+0x0/0xd0
 [<40133ca4>] kthread+0x64/0xa0
 [<40133c40>] kthread+0x0/0xa0
 [<40104887>] kernel_thread_helper+0x7/0x10
 =======================
dd            D 40249148     0 18935  16194
       f1fc7d88 00000086 f7d41aa0 40249148 00000000 00000000 4237b300 f3c52900 
       4273fe00 f7d41be8 f7d41aa0 4273fe00 f1fc7de4 42708a64 f1fc7d94 40402eed 
       f1fc7ddc 00000000 401517c5 4040318f 40151780 401342a0 f1fc7ddc f1fc7dd8 
Call Trace:
 [<40249148>] blk_backing_dev_unplug+0x48/0xa0
 [<40402eed>] io_schedule+0x1d/0x30
 [<401517c5>] sync_page+0x45/0x50
 [<4040318f>] __wait_on_bit_lock+0x3f/0x70
 [<40151780>] sync_page+0x0/0x50
 [<401342a0>] wake_bit_function+0x0/0x60
 [<401520ca>] __lock_page+0x9a/0xb0
 [<401342a0>] wake_bit_function+0x0/0x60
 [<401342a0>] wake_bit_function+0x0/0x60
 [<4015279e>] do_generic_mapping_read+0x22e/0x4b0
 [<40152da0>] generic_file_aio_read+0x1c0/0x1f0
 [<40152a20>] file_read_actor+0x0/0x110
 [<40172d6d>] do_sync_read+0xbd/0x110
 [<40134250>] autoremove_wake_function+0x0/0x50
 [<40116455>] do_page_fault+0x1b5/0x630
 [<4012cd5f>] sys_rt_sigaction+0x5f/0xb0
 [<40172e83>] vfs_read+0xc3/0x150
 [<401731c1>] sys_read+0x41/0x70
 [<40103c36>] sysenter_past_esp+0x5f/0x85
 [<40400000>] clip_setup+0x20/0x50
 =======================

--Boundary-00=_SpCVHacFZ00Zyp9--
