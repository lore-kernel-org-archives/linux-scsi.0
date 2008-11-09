From: "Kit Gerrits" <kitgerrits@gmail.com>
Subject: Question about spun-down USB disk
Date: Sun, 9 Nov 2008 22:41:32 +0100
Message-ID: <4917590e.2435440a.1153.2115@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2058 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbYKIVlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 16:41:37 -0500
Received: by nf-out-0910.google.com with SMTP id d3so968152nfc.21
        for <linux-scsi@vger.kernel.org>; Sun, 09 Nov 2008 13:41:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all!

I am using an Asus EEE Box with Fedora 9 as a NAS.
I have found a way to spin-down my USB harddisks with the sg3 utils,
 but the system occasionally times out on write actions to the disk.
I usually access the disk through SMB of NFS, which forces the disk to spin
up first.
Sometimes the system opens the disk by itself, throwing an error.
 lost page write due to I/O error on sdf1

Is there any way to increase the system timeout when accessing/writing-to
the drive?
Or should I go ask the ext3 people?
Or does sg_start not notify the kernel the device has been stopped?


When the system fails, I get the following error:
Nov  4 23:50:42 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:42 EEE-Box kernel: end_request: I/O error, dev sdf, sector
976767873
Nov  4 23:50:42 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 122095984
Nov  4 23:50:42 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:42 EEE-Box kernel: end_request: I/O error, dev sdf, sector
976767873
Nov  4 23:50:42 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 122095984
Nov  4 23:50:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:52 EEE-Box kernel: end_request: I/O error, dev sdf, sector 4361
Nov  4 23:50:52 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 545
Nov  4 23:50:52 EEE-Box kernel: EXT3-fs error (device sdf1): ext3_readdir:
directory #2 contains a hole at offset 0
Nov  4 23:50:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:52 EEE-Box kernel: end_request: I/O error, dev sdf, sector 1
Nov  4 23:50:52 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 0
Nov  4 23:50:52 EEE-Box kernel: lost page write due to I/O error on sdf1
Nov  4 23:50:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:52 EEE-Box kernel: end_request: I/O error, dev sdf, sector 265
Nov  4 23:50:52 EEE-Box kernel: EXT3-fs error (device sdf1):
ext3_get_inode_loc: unable to read inode block - inode=2, block=33
Nov  4 23:50:52 EEE-Box kernel: ------------[ cut here ]------------
Nov  4 23:50:52 EEE-Box kernel: WARNING: at fs/buffer.c:1183
mark_buffer_dirty+0x23/0x6a() (Not tainted)
Nov  4 23:50:52 EEE-Box kernel: Modules linked in: joydev cpufreq_stats
xt_tcpudp iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss
exportfs bridge bnep rfcomm l2cap bluetooth fuse sunrpc ipv6 loop
dm_multipath snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_seq_device video snd_pcm_oss output snd_mixer_oss snd_pcm i915
snd_timer button snd_page_alloc drm snd_hwdep snd i2c_algo_bit i2c_i801
r8169 pcspkr i2c_core soundcore serio_raw iTCO_wdt iTCO_vendor_support
usb_storage sg dm_snapshot dm_zero dm_mirror dm_mod ata_piix pata_acpi
ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd
ehci_hcd [last unloaded: microcode]
Nov  4 23:50:52 EEE-Box kernel: Pid: 1760, comm: ls Not tainted
2.6.25-14.fc9.i686 #1
Nov  4 23:50:52 EEE-Box kernel: [<c0427911>] warn_on_slowpath+0x47/0x73
Nov  4 23:50:52 EEE-Box kernel: [<c062d850>] ?
atomic_notifier_call_chain+0xf/0x11
Nov  4 23:50:52 EEE-Box kernel: [<c054aed9>] ? vt_console_print+0x277/0x286
Nov  4 23:50:52 EEE-Box kernel: [<c054ac62>] ? vt_console_print+0x0/0x286
Nov  4 23:50:52 EEE-Box kernel: [<c042799d>] ?
__call_console_drivers+0x56/0x63
Nov  4 23:50:52 EEE-Box kernel: [<c0427a01>] ?
_call_console_drivers+0x57/0x5b
Nov  4 23:50:52 EEE-Box kernel: [<c0427dd5>] ?
release_console_sem+0x195/0x19d
Nov  4 23:50:52 EEE-Box kernel: [<c049f38d>] mark_buffer_dirty+0x23/0x6a
Nov  4 23:50:52 EEE-Box kernel: [<f88ebc36>] ext3_commit_super+0x40/0x53
[ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88ed076>] ext3_handle_error+0x71/0x95
[ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88ed129>] ext3_error+0x39/0x43 [ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88e5598>]
__ext3_get_inode_loc+0x2b1/0x2d8 [ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88e58ed>] ext3_get_inode_loc+0x14/0x16
[ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88e590f>]
ext3_reserve_inode_write+0x20/0x68 [ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88e5986>] ext3_mark_inode_dirty+0x2f/0x46
[ext3]
Nov  4 23:50:52 EEE-Box kernel: [<f88e5aa8>] ext3_dirty_inode+0x53/0x67
[ext3]
Nov  4 23:50:52 EEE-Box kernel: [<c049b785>] __mark_inode_dirty+0x29/0x13c
Nov  4 23:50:52 EEE-Box kernel: [<c04931af>] touch_atime+0xbb/0xbf
Nov  4 23:50:52 EEE-Box kernel: [<c048d74a>] vfs_readdir+0x76/0x8f
Nov  4 23:50:52 EEE-Box kernel: [<c048d490>] ? filldir64+0x0/0xcd
Nov  4 23:50:52 EEE-Box kernel: [<c048d7c6>] sys_getdents64+0x63/0xa1
Nov  4 23:50:52 EEE-Box kernel: [<c0405bf2>] syscall_call+0x7/0xb
Nov  4 23:50:52 EEE-Box kernel: =======================
Nov  4 23:50:52 EEE-Box kernel: ---[ end trace 1a0b4166f7029756 ]---
Nov  4 23:50:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:52 EEE-Box kernel: end_request: I/O error, dev sdf, sector 1
Nov  4 23:50:52 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 0
Nov  4 23:50:52 EEE-Box kernel: lost page write due to I/O error on sdf1
Nov  4 23:50:52 EEE-Box kernel: EXT3-fs error (device sdf1) in
ext3_reserve_inode_write: IO failure
Nov  4 23:50:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:52 EEE-Box kernel: end_request: I/O error, dev sdf, sector 1
Nov  4 23:50:52 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 0
Nov  4 23:50:52 EEE-Box kernel: lost page write due to I/O error on sdf1
Nov  4 23:50:58 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:58 EEE-Box kernel: end_request: I/O error, dev sdf, sector 4401
Nov  4 23:50:58 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 550
Nov  4 23:50:58 EEE-Box kernel: lost page write due to I/O error on sdf1
Nov  4 23:50:58 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:58 EEE-Box kernel: end_request: I/O error, dev sdf, sector 4409
Nov  4 23:50:58 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 551
Nov  4 23:50:58 EEE-Box kernel: lost page write due to I/O error on sdf1
Nov  4 23:50:58 EEE-Box kernel: Aborting journal on device sdf1.
Nov  4 23:50:58 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Nov  4 23:50:58 EEE-Box kernel: end_request: I/O error, dev sdf, sector 4401
Nov  4 23:50:58 EEE-Box kernel: Buffer I/O error on device sdf1, logical
block 550
Nov  4 23:50:58 EEE-Box kernel: lost page write due to I/O error on sdf1

My current kernel:
Linux EEE-Box 2.6.25-14.fc9.i686 #1 SMP Thu May 1 06:28:41 EDT 2008 i686
i686 i386 GNU/Linux

modinfo  usb_storage
filename:
/lib/modules/2.6.25-14.fc9.i686/kernel/drivers/usb/storage/usb-storage.ko
license:        GPL
description:    USB Mass Storage driver for Linux
author:         Matthew Dharm <mdharm-usb@one-eyed-alien.net>
srcversion:     38F8E61ECA6C16CA785AA38
--cut aliases--
depends:        scsi_mod
vermagic:       2.6.25-14.fc9.i686 SMP mod_unload 686 4KSTACKS
parm:           delay_use:seconds to delay before using a new device (uint)


modinfo  scsi_mod
filename:
/lib/modules/2.6.25-14.fc9.i686/kernel/drivers/scsi/scsi_mod.ko
license:        GPL
description:    SCSI core
srcversion:     DF7CC1670A47C981FCDFA39
depends:
vermagic:       2.6.25-14.fc9.i686 SMP mod_unload 686 4KSTACKS
parm:           dev_flags:Given scsi_dev_flags=vendor:model:flags[,v:m:f]
add black/white list entries for vendor and model with an integer value of
flags to the scsi device info list (string)
parm:           default_dev_flags:scsi default device flag integer value
(int)
parm:           max_luns:last scsi LUN (should be between 1 and 2^32-1)
(uint)
parm:           scan:sync, async or none (string)
parm:           max_report_luns:REPORT LUNS maximum number of LUNS received
(should be between 1 and 16384) (uint)
parm:           inq_timeout:Timeout (in seconds) waiting for devices to
answer INQUIRY. Default is 5. Some non-compliant devices need more. (uint)
parm:           scsi_logging_level:a bit mask of logging levels (int)

modinfo sd_mod
filename:
/lib/modules/2.6.25-14.fc9.i686/kernel/drivers/scsi/sd_mod.ko
--cut aliases--
license:        GPL
description:    SCSI disk (sd) driver
author:         Eric Youngdale
srcversion:     ECC497BE26ACFBB19D2AF29
depends:        scsi_mod
vermagic:       2.6.25-14.fc9.i686 SMP mod_unload 686 4KSTACKS

Dmesg of the device:
Nov  5 00:12:52 EEE-Box kernel: scsi 6:0:0:0: Direct-Access     WD
5000AVV External 1.65 PQ: 0 ANSI: 4
Nov  5 00:12:52 EEE-Box kernel: sd 6:0:0:0: [sdf] 976773168 512-byte
hardware sectors (500108 MB)
Nov  5 00:12:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Write Protect is off
Nov  5 00:12:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Assuming drive cache:
write through
Nov  5 00:12:52 EEE-Box kernel: sd 6:0:0:0: [sdf] 976773168 512-byte
hardware sectors (500108 MB)
Nov  5 00:12:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Write Protect is off
Nov  5 00:12:52 EEE-Box kernel: sd 6:0:0:0: [sdf] Assuming drive cache:
write through

