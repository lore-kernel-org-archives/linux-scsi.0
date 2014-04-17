From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 74341] New: WARNING: CPU: 4 PID: 3686 at fs/sysfs/group.c:216
 sysfs_remove_group
Date: Thu, 17 Apr 2014 19:47:13 +0000
Message-ID: <bug-74341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36184 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaDQTrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2014 15:47:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A256B20306
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2014 19:47:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C70AA202C8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2014 19:47:14 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=74341

            Bug ID: 74341
           Summary: WARNING: CPU: 4 PID: 3686 at fs/sysfs/group.c:216
                    sysfs_remove_group
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.14.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: casteyde.christian@free.fr
        Regression: No

Kernel 3.14.1
Core i7 64 bits / 6GB
GCC 4.8.2

I recently got this warning while accessing an external HDD driver connected
via USB to the laptop:

sd 8:0:0:0: [sdc] Attached SCSI disk
usb 4-2: USB disconnect, device number 3
------------[ cut here ]------------
WARNING: CPU: 4 PID: 3686 at fs/sysfs/group.c:216
sysfs_remove_group+0x8b/0x90()
sysfs group ffffffff81b96ea0 not found for kobject 'target8:0:0'
Modules linked in:
CPU: 4 PID: 3686 Comm: umount Not tainted 3.14.1 #1
Hardware name: Acer Aspire 7750G/JE70_HR, BIOS V1.07 03/02/2011
 0000000000000009 ffff880075821b18 ffffffff817fd0d1 ffff880075821b60
 ffff880075821b50 ffffffff81079003 0000000000000000 ffffffff81b96ea0
 ffff8801a6fe3c38 ffff8801a11c5190 ffff8800aabb5800 ffff880075821bb0
Call Trace:
 [<ffffffff817fd0d1>] dump_stack+0x4d/0x6f
 [<ffffffff81079003>] warn_slowpath_common+0x73/0x90
 [<ffffffff81079067>] warn_slowpath_fmt+0x47/0x50
 [<ffffffff81195953>] ? kernfs_find_and_get_ns+0x43/0x50
 [<ffffffff811945db>] sysfs_remove_group+0x8b/0x90
 [<ffffffff814901be>] dpm_sysfs_remove+0x3e/0x50
 [<ffffffff81487150>] device_del+0x40/0x1b0
 [<ffffffff814aac92>] scsi_target_reap_usercontext+0x22/0x30
 [<ffffffff8108e12f>] execute_in_process_context+0x5f/0x70
 [<ffffffff814abf1c>] scsi_target_reap+0xbc/0xe0
 [<ffffffff814add68>] scsi_device_dev_release_usercontext+0x188/0x1c0
 [<ffffffff8108e12f>] execute_in_process_context+0x5f/0x70
 [<ffffffff814adbd7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff8148678d>] device_release+0x2d/0xa0
 [<ffffffff812e7358>] kobject_cleanup+0x38/0x70
 [<ffffffff812e7240>] kobject_put+0x30/0x60
 [<ffffffff81486b32>] put_device+0x12/0x20
 [<ffffffff814a1f06>] scsi_device_put+0x36/0x50
 [<ffffffff814b124b>] scsi_disk_put+0x2b/0x40
 [<ffffffff814b21bc>] sd_release+0x2c/0x60
 [<ffffffff81162dbc>] __blkdev_put+0x16c/0x1a0
 [<ffffffff81162d59>] __blkdev_put+0x109/0x1a0
 [<ffffffff81163679>] blkdev_put+0x49/0x130
 [<ffffffff8113292f>] kill_block_super+0x3f/0x70
 [<ffffffff81228a92>] fuse_kill_sb_blk+0x42/0x50
 [<ffffffff81132bcd>] deactivate_locked_super+0x2d/0x50
 [<ffffffff81133161>] deactivate_super+0x41/0x60
 [<ffffffff8114d0f0>] mntput_no_expire+0xe0/0x170
 [<ffffffff8114e2cc>] SyS_umount+0x8c/0x3a0
 [<ffffffff810870e2>] ? SyS_rt_sigprocmask+0x62/0xb0
 [<ffffffff818056a2>] system_call_fastpath+0x16/0x1b
---[ end trace adb70c2dc2d071d1 ]---
usb 4-2: new SuperSpeed USB device number 4 using xhci_hcd
usb 4-2: Parent hub missing LPM exit latency info.  Power management will be
impacted.
usb 4-2: New USB device found, idVendor=0480, idProduct=a006
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 4-2: Product: External USB 3.0
usb 4-2: Manufacturer: Toshiba
usb 4-2: SerialNumber: 2012030662297
usb-storage 4-2:1.0: USB Mass Storage device detected
scsi9 : usb-storage 4-2:1.0
scsi 9:0:0:0: Direct-Access     TOSHIBA  External USB 3.0 0001 PQ: 0 ANSI: 6
sd 9:0:0:0: Attached scsi generic sg3 type 0
sd 9:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 9:0:0:0: [sdc] Write Protect is off
sd 9:0:0:0: [sdc] Mode Sense: 33 00 00 08
sd 9:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support
DPO or FUA
 sdc: sdc1
sd 9:0:0:0: [sdc] Attached SCSI disk

The disk seemed to go to sleep and disconnect while I was looking at files on
it. Then I tried to remount it. I looked at dmesg after so I don't know when
exactly the warning occurred.

-- 
You are receiving this mail because:
You are the assignee for the bug.
