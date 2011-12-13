From: Audio Haven <audiohaven@gmail.com>
Subject: mvsas loses all ports under load after a year of driver stability
Date: Tue, 13 Dec 2011 22:46:43 +0100
Message-ID: <CAGtbWyPuFVtDEa8nxsyB_WPZ_9_Wm62UprJUs4buj2hG3N24TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55192 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753Ab1LMVqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2011 16:46:45 -0500
Received: by lagp5 with SMTP id p5so64155lag.19
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2011 13:46:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

I've been running a 12 disk raid6 setup with cheap 1.5 TB green drives
(western digital and seagate lp) across one 8 port mvsas supermicro
controller and 4 ports of the onboard sata_nv of an Asus K8NE4 deluxe
motherboard for about a year. This setup has been very stable until
recently one of the attached western digital disks started giving
uncorrectable offline errors, which was replaced under warranty by a
new seagate disk.

Recently, for some unknown reason the whole supermicro controller
starts to fail at once under load, and drops all 8 attached disks out
of raid:

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2 : active raid6 sdb1[0](F) sdm1[11] sdl1[10] sdj1[16] sdk1[13]
sdi1[14](F) sdh1[12](F) sdg1[5](F) sdf1[15](F) sde1[3](F) sdd1[2](F)
sdc1[1](F)
      14651351040 blocks super 1.2 level 6, 1024k chunk, algorithm 2
[12/4] [________UUUU]

unused devices: <none>

This appears when md2 is under load, e.g. defragmenting the xfs
filesystem on top of the raid, or when raid is rebuilding.

I can recover the raid by rebooting and forcing mdadm:

mdadm -A /dev/md2 -f /dev/sd[b-m]1

but I suspect my raid6 consistency is going to break once if this
problem keeps repeating.

dmesg reports:

ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy3 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b76000]:
ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata12: status=0x01 { Error }
ata12: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy7 : No sig fis
INFO: task md2_raid6:1815 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
md2_raid6     D ffff880098ac9880     0  1815      2 0x00000080
 ffff880083cabcb0 0000000000000046 00000200981d0038 00000000390855d3
 ffff880083caa010 ffff880083cabfd8 00000000000136c0 ffff880083ce5c40
 ffff880083ce5ff8 ffff880083ce5ff0 00000000000136c0 00000000000136c0
Call Trace:
 [<ffffffff81069d34>] ? prepare_to_wait+0x6c/0x79
 [<ffffffff8135f1e9>] md_super_wait+0x73/0x8b
 [<ffffffff81069a8f>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81361e0f>] md_update_sb+0x271/0x2f1
 [<ffffffff813634b0>] md_check_recovery+0x1c6/0x44e
 [<ffffffffa031ceae>] raid5d+0x45/0x50a [raid456]
 [<ffffffff81451dc5>] ? schedule_timeout+0x36/0xe3
 [<ffffffff81069b09>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8136122b>] md_thread+0xfb/0x119
 [<ffffffff81069a8f>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8103e440>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81361130>] ? md_thread+0x0/0x119
 [<ffffffff810695f5>] kthread+0x82/0x8a
 [<ffffffff8100ba64>] kernel_thread_helper+0x4/0x10
 [<ffffffff81069573>] ? kthread+0x0/0x8a
 [<ffffffff8100ba60>] ? kernel_thread_helper+0x0/0x10
INFO: task md2_resync:1818 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
md2_resync    D ffff880083ce03b0     0  1818      2 0x00000080
 ffff88008255fb60 0000000000000046 ffff88008255fad0 ffffffff811faa84
 ffff88008255e010 ffff88008255ffd8 00000000000136c0 ffff880083ce0000
 ffff880083ce03b8 ffff880083ce03b0 00000000000136c0 00000000000136c0
Call Trace:
 [<ffffffff811faa84>] ? blk_unplug+0x29/0x2d
 [<ffffffffa031aad6>] ? md_raid5_unplug_device+0xd1/0xde [raid456]
 [<ffffffffa031ad9b>] get_active_stripe+0x2b8/0x5d8 [raid456]
 [<ffffffff811fec3d>] ? __generic_unplug_device+0x37/0x3b
 [<ffffffff81047d32>] ? default_wake_function+0x0/0x14
 [<ffffffffa031ddfe>] sync_request+0x26d/0x2f9 [raid456]
 [<ffffffff813609a5>] md_do_sync+0x7c2/0xc1c
 [<ffffffff81046399>] ? finish_task_switch+0x8c/0xab
 [<ffffffff8136122b>] md_thread+0xfb/0x119
 [<ffffffff8103e440>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81361130>] ? md_thread+0x0/0x119
 [<ffffffff810695f5>] kthread+0x82/0x8a
 [<ffffffff8100ba64>] kernel_thread_helper+0x4/0x10
 [<ffffffff81069573>] ? kthread+0x0/0x8a
 [<ffffffff8100ba60>] ? kernel_thread_helper+0x0/0x10
mvsas 0000:01:00.0: Phy6 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [4] tag[4], task
[ffff880090b76e00]:
ata15: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata15: status=0x01 { Error }
ata15: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy1 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [5] tag[5], task
[ffff880090b76a80]:
ata10: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata10: status=0x01 { Error }
ata10: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [6] tag[6], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
sd 4:0:2:0: [sdd]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 4:0:2:0: [sdd]  Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 2e
sd 4:0:2:0: [sdd]  Add. Sense: No additional sense information
sd 4:0:2:0: [sdd] CDB: Write(10): 2a 00 00 00 00 47 00 00 02 00
end_request: I/O error, dev sdd, sector 71
mvsas 0000:01:00.0: Phy3 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b76000]:
ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata12: status=0x01 { Error }
ata12: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
sd 4:0:5:0: [sdg]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 4:0:5:0: [sdg]  Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 b6
sd 4:0:5:0: [sdg]  Add. Sense: No additional sense information
sd 4:0:5:0: [sdg] CDB: Write(10): 2a 00 00 00 00 47 00 00 02 00
end_request: I/O error, dev sdg, sector 71
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [4] tag[4], task
[ffff880090b76e00]:
ata15: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata15: status=0x01 { Error }
ata15: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy1 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [5] tag[5], task
[ffff880090b76a80]:
ata10: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata10: status=0x01 { Error }
ata10: error=0x04 { DriveStatusError }
end_request: I/O error, dev sdc, sector 71
md: super_written gets error=-5, uptodate=0
md/raid:md2: Disk failure on sdc1, disabling device.
<1>md/raid:md2: Operation continuing on 9 devices.
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [6] tag[6], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy3 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b76000]:
ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata12: status=0x01 { Error }
ata12: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [4] tag[4], task
[ffff880090b76e00]:
ata15: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata15: status=0x01 { Error }
ata15: error=0x04 { DriveStatusError }
end_request: I/O error, dev sdh, sector 71
md: super_written gets error=-5, uptodate=0
md/raid:md2: Disk failure on sdh1, disabling device.
<1>md/raid:md2: Operation continuing on 8 devices.
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [5] tag[5], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy3 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b76000]:
ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata12: status=0x01 { Error }
ata12: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [4] tag[4], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy3 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b76000]:
ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata12: status=0x01 { Error }
ata12: error=0x04 { DriveStatusError }
end_request: I/O error, dev sde, sector 71
md: super_written gets error=-5, uptodate=0
md/raid:md2: Disk failure on sde1, disabling device.
<1>md/raid:md2: Operation continuing on 7 devices.
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [4] tag[4], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
sd 4:0:4:0: [sdf]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 4:0:4:0: [sdf]  Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 b6
sd 4:0:4:0: [sdf]  Add. Sense: No additional sense information
sd 4:0:4:0: [sdf] CDB: Write(10): 2a 00 00 00 00 47 00 00 02 00
end_request: I/O error, dev sdf, sector 71
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b76380]:
ata11: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata11: status=0x01 { Error }
ata11: error=0x04 { DriveStatusError }
end_request: I/O error, dev sdd, sector 71
md: super_written gets error=-5, uptodate=0
md/raid:md2: Disk failure on sdd1, disabling device.
<1>md/raid:md2: Operation continuing on 6 devices.
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [2] tag[2], task
[ffff880090b761c0]:
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=0x01 { Error }
ata14: error=0x04 { DriveStatusError }
end_request: I/O error, dev sdg, sector 71
md: super_written gets error=-5, uptodate=0
md/raid:md2: Disk failure on sdg1, disabling device.
<1>md/raid:md2: Operation continuing on 5 devices.
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [3] tag[3], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[0]:rc= 0
ata5: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata5: status=0x01 { Error }
ata5: error=0x04 { DriveStatusError }
ata5: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata5: status=0x01 { Error }
ata5: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
drivers/scsi/mvsas/mv_sas.c 1969:Release slot [1] tag[1], task
[ffff880090b768c0]:
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=0x01 { Error }
ata13: error=0x04 { DriveStatusError }
end_request: I/O error, dev sdf, sector 71
md: super_written gets error=-5, uptodate=0
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
mvsas 0000:01:00.0: Phy2 : No sig fis
mvsas 0000:01:00.0: Phy3 : No sig fis
mvsas 0000:01:00.0: Phy5 : No sig fis
mvsas 0000:01:00.0: Phy7 : No sig fis
mvsas 0000:01:00.0: Phy6 : No sig fis
mvsas 0000:01:00.0: Phy1 : No sig fis
mvsas 0000:01:00.0: Phy4 : No sig fis
mvsas 0000:01:00.0: Phy2 : No sig fis
...

The "no sig fis" keeps on repeating in the dmesg.

Kernel is Linux hd 2.6.37-rc4 #1 SMP Fri Dec 3 11:53:33 CET 2010
x86_64 x86_64 x86_64 GNU/Linux

This setup has been stable for about one year, with lot's of IO and
nightly defragmenting the xfs filesystem.

Is my controller dying (=dropping all 8 connected disks) or is this a
known bug ?
I have a second system with the same controller and a smaller raid6
set of just 8 1TB disks, but this will take some time swapping both
controllers and cabling to eliminate a bad controller.

Best regards,

Frederic Vanden Poel
