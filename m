From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71881] New: Disabling wifi by radio killswitch leads to
 remounting external USB HDD and stack trace in kernel log
Date: Tue, 11 Mar 2014 13:48:14 +0000
Message-ID: <bug-71881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaCKNsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2014 09:48:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C368A2021A
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2014 13:48:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E17F120395
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2014 13:48:14 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71881

            Bug ID: 71881
           Summary: Disabling wifi by radio killswitch leads to remounting
                    external USB HDD and stack trace in kernel log
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.13.6-1-ARCH
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: sh.siddhartha@gmail.com
        Regression: No

<info> WiFi now disabled by radio killswitch
hid-generic 0003:413C:8161.0002: can't reset device, 0000:00:1d.0-1.6.1/input0,
status -32
usb 2-1.1: USB disconnect, device number 3
usb 2-1.6: USB disconnect, device number 4
usb 2-1.6.1: USB disconnect, device number 5
Unmounting /home/lfiles/sdh-hdd...
usb 2-1.6.2: USB disconnect, device number 6
usb 2-1.6.3: USB disconnect, device number 7
Unmounting /dev/sdb1 (sdh)
Endpoint unregistered: sender=:1.27 path=/MediaEndpoint/A2DPSource
Endpoint unregistered: sender=:1.27 path=/MediaEndpoint/A2DPSink
[system] Rejected send message, 3 matched rules; type="error", sender=":1.27"
(uid=1000 pid=647 comm="/usr/bin/pulseaudio --start --log-target=syslog ")
interface="(unset)" member="(unset
[system] Rejected send message, 3 matched rules; type="error", sender=":1.27"
(uid=1000 pid=647 comm="/usr/bin/pulseaudio --start --log-target=syslog ")
interface="(unset)" member="(unset
[system] Rejected send message, 3 matched rules; type="error", sender=":1.27"
(uid=1000 pid=647 comm="/usr/bin/pulseaudio --start --log-target=syslog ")
interface="(unset)" member="(unset
[system] Rejected send message, 3 matched rules; type="error", sender=":1.27"
(uid=1000 pid=647 comm="/usr/bin/pulseaudio --start --log-target=syslog ")
interface="(unset)" member="(unset
------------[ cut here ]------------
WARNING: CPU: 2 PID: 23054 at fs/sysfs/group.c:214
sysfs_remove_group+0xc6/0xd0()
sysfs group ffffffff81895c40 not found for kobject 'target6:0:0'
Modules linked in: ipt_MASQUERADE xt_conntrack ipt_REJECT xt_tcpudp
iptable_filter nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_nat_proto_gre
nf_conntrack_pptp nf_conntrack_proto_gre nf_n
 snd_timer sparse_keymap snd dell_laptop mii rfkill dcdbas mei_me evdev psmouse
serio_raw wmi microcode i2c_i801 intel_agp i2c_core video thermal battery ac
mei intel_ips soundcore lpc_ic
CPU: 2 PID: 23054 Comm: umount Tainted: P           O 3.13.6-1-ARCH #1
Hardware name: Dell Inc. Inspiron N5010/, BIOS A15 07/19/2011
 0000000000000009 ffff88005bb25b18 ffffffff81513274 ffff88005bb25b60
 ffff88005bb25b50 ffffffff81061a3d 0000000000000000 ffffffff81895c40
 ffff880037f13c38 ffff880131f69190 ffff880130ee2800 ffff88005bb25bb0
Call Trace:
 [<ffffffff81513274>] dump_stack+0x4d/0x6f
 [<ffffffff81061a3d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81061aac>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff8151843e>] ? mutex_unlock+0xe/0x10
 [<ffffffff8121925e>] ? sysfs_get_dirent_ns+0x4e/0x70
 [<ffffffff8121a3e6>] sysfs_remove_group+0xc6/0xd0
 [<ffffffff813b7033>] dpm_sysfs_remove+0x43/0x50
 [<ffffffff813aceb5>] device_del+0x45/0x1c0
 [<ffffffffa00962b7>] scsi_target_reap_usercontext+0x27/0x40 [scsi_mod]
 [<ffffffff8107b887>] execute_in_process_context+0x67/0x70
 [<ffffffffa00975d4>] scsi_target_reap+0xc4/0xf0 [scsi_mod]
 [<ffffffffa0099558>] scsi_device_dev_release_usercontext+0x188/0x1c0
[scsi_mod]
 [<ffffffff8107b887>] execute_in_process_context+0x67/0x70
 [<ffffffffa00993cc>] scsi_device_dev_release+0x1c/0x20 [scsi_mod]
 [<ffffffff813ac3f2>] device_release+0x32/0xa0
 [<ffffffff812b6b47>] kobject_cleanup+0x77/0x1b0
 [<ffffffff812b69c8>] kobject_put+0x28/0x60
 [<ffffffff813ac7f7>] put_device+0x17/0x20
 [<ffffffffa008d5eb>] scsi_device_put+0x3b/0x50 [scsi_mod]
 [<ffffffffa014b7e0>] scsi_disk_put+0x30/0x50 [sd_mod]
 [<ffffffffa014c6a1>] sd_release+0x31/0x70 [sd_mod]
 [<ffffffff811dc75c>] __blkdev_put+0x17c/0x1b0
 [<ffffffff811dc6f7>] __blkdev_put+0x117/0x1b0
 [<ffffffff811dd0be>] blkdev_put+0x4e/0x140
 [<ffffffff811a5f64>] kill_block_super+0x44/0x70
 [<ffffffffa0f4ddb7>] fuse_kill_sb_blk+0x47/0x50 [fuse]
 [<ffffffff811a622d>] deactivate_locked_super+0x3d/0x60
 [<ffffffff811a67e6>] deactivate_super+0x46/0x60
 [<ffffffff811c24d5>] mntput_no_expire+0xe5/0x170
 [<ffffffff811c3730>] SyS_umount+0x90/0x3c0
 [<ffffffff815216ad>] system_call_fastpath+0x1a/0x1f
---[ end trace e75aa207b605cfaa ]---

-- 
You are receiving this mail because:
You are the assignee for the bug.
