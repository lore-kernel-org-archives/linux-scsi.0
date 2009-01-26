From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12544] New: megaraid kernel oops during smartd poll
Date: Mon, 26 Jan 2009 12:54:29 -0800 (PST)
Message-ID: <bug-12544-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbZAZVDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 16:03:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0QL3LG7014854
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 13:03:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12544

           Summary: megaraid kernel oops during smartd poll
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: dimetrios@gmail.com


Latest working kernel version: 2.6.9
Earliest failing kernel version: 2.6.26
Distribution: Debian Lenny
Hardware Environment: 2xAMD Opteron 265, Supermicro H8DA8, 4GB, LSI Logic
MegaRAID SCSI 320-1 Controller (fw Rev 1L37) RAID5
Software Environment: Debian lenny with custom 2.6.28 kernel, smartd version
5.38
Problem Description: sometimes kernel oops happenes when smartd started which
tried to poll SMART-information from MegaRAID array
steps to reproduce:
# smartd -dn
smartd version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Opened configuration file /etc/smartd.conf
Drive: DEVICESCAN, implied '-a' Directive on line 22 of file /etc/smartd.conf
Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scanning
devices
Device: /dev/sda, opened
[   48.284648] BUG: unable to handle kernel NULL pointer dereference at
00000dd8
[   48.285597] IP: [<f80fcd86>] megaraid_queue_command+0x187/0x822
[megaraid_mbox]
[   48.285597] *pde = 00000000
[   48.285597] Oops: 0002 [#1] SMP
[   48.285597] last sysfs file: /sys/module/nf_conntrack/parameters/hashsize
[   48.285597] Modules linked in: ipt_LOG xt_limit ipt_REJECT ipt_set ipt_ULOG
xt_tcpudp xt_state xt_multiport iptable_filter xt_MARK iptable_mangle xt_mark
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
x_tables ip_set_ipmap ip_set ipv6 loop psmouse serio_raw pcspkr k8temp amd_rng
rng_core i2c_amd756 i2c_amd8111 i2c_core button isp1760 shpchp pci_hotplug
evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg
sd_mod crc_t10dif ide_cd_mod cdrom ata_generic libata floppy megaraid_mbox
megaraid_mm aic79xx scsi_transport_spi tg3 libphy scsi_mod ohci_hcd amd74xx
ide_pci_generic usbcore ide_core thermal processor fan thermal_sys
[   48.285597]
[   48.285597] Pid: 2682, comm: smartd Not tainted (2.6.28-1.1demyan #1)
H8DA8/H8DAR
[   48.285597] EIP: 0060:[<f80fcd86>] EFLAGS: 00010012 CPU: 3
[   48.285597] EIP is at megaraid_queue_command+0x187/0x822 [megaraid_mbox]
[   48.285597] EAX: 00000000 EBX: 00000000 ECX: 00000010 EDX: 00000040
[   48.285597] ESI: f6be7b40 EDI: 00000dd8 EBP: f6aab540 ESP: f612fb58
[   48.285597]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   48.285597] Process smartd (pid: 2682, ti=f612e000 task=f6475300
task.ti=f612e000)
[   48.285597] Stack:
[   48.285597]  ffffffff f8067510 f71d8000 f68cabb8 f68cabb8 f685b340 f71e8000
00000024
[   48.285597]  f612fbc4 f647548c f6b98800 f6912200 c0117ae6 00000000 6373abb8
696e6e61
[   48.285597]  7300676e 7070696b 00676e69 f6908000 f6aab540 f6ba9000 00000296
f8067743
[   48.285597] Call Trace:
[   48.285597]  [<f8067510>] scsi_done+0x0/0x8 [scsi_mod]
[   48.285597]  [<c0117ae6>] default_spin_lock_flags+0x5/0x7
[   48.285597]  [<f8067743>] scsi_dispatch_cmd+0x16a/0x1d6 [scsi_mod]
[   48.285597]  [<f806bf84>] scsi_request_fn+0x349/0x48b [scsi_mod]
[   48.285597]  [<c01e674e>] blk_start_queueing+0x15/0x1e
[   48.285597]  [<c01e4852>] elv_insert+0xdf/0x205
[   48.285597]  [<c01e8b5c>] blk_execute_rq_nowait+0x5d/0x8a
[   48.285597]  [<c01e8c04>] blk_execute_rq+0x7b/0x9b
[   48.285597]  [<c01e8adc>] blk_end_sync_rq+0x0/0x23
[   48.285597]  [<c0117ae6>] default_spin_lock_flags+0x5/0x7
[   48.285597]  [<c0169c7e>] page_address+0x83/0x9e
[   48.285597]  [<c01e4d66>] blk_rq_bio_prep+0x40/0xa5
[   48.285597]  [<c01e88e9>] blk_rq_append_bio+0x11/0x3a
[   48.285597]  [<c01e8a42>] blk_rq_map_user+0x130/0x1ca
[   48.285597]  [<c01eb3d1>] sg_io+0x20e/0x2f8
[   48.285597]  [<c01eb901>] scsi_cmd_ioctl+0x1bc/0x40f
[   48.285597]  [<c016aa28>] __do_fault+0x32e/0x368
[   48.285597]  [<c026e79e>] sock_def_readable+0x2f/0x58
[   48.285597]  [<f81e9f8b>] sd_ioctl+0x90/0xb5 [sd_mod]
[   48.285597]  [<c01e9997>] __blkdev_driver_ioctl+0x53/0x63
[   48.285597]  [<c01ea1f0>] blkdev_ioctl+0x826/0x852
[   48.285597]  [<c018832c>] kern_path+0x1a/0x35
[   48.285597]  [<c0118296>] do_page_fault+0x2fe/0x660
[   48.285597]  [<c018c52a>] dput+0x16/0x103
[   48.285597]  [<c026d01a>] sys_sendto+0xfc/0x127
[   48.285597]  [<c02dbe48>] _spin_lock+0x5/0x7
[   48.285597]  [<c02c73b6>] unix_state_double_lock+0x28/0x3c
[   48.285597]  [<c01c8eb2>] security_unix_may_send+0xc/0xd
[   48.285597]  [<c02c85e6>] unix_dgram_connect+0x18a/0x1dd
[   48.285597]  [<c0117ae6>] default_spin_lock_flags+0x5/0x7
[   48.285597]  [<c019ca32>] block_ioctl+0x2a/0x2f
[   48.285597]  [<c019ca08>] block_ioctl+0x0/0x2f
[   48.285597]  [<c0189ce9>] vfs_ioctl+0x1c/0x5f
[   48.285597]  [<c018a1ad>] do_vfs_ioctl+0x3af/0x3da
[   48.285597]  [<c0190f1e>] mntput_no_expire+0x18/0xf6
[   48.285597]  [<c018a219>] sys_ioctl+0x41/0x58
[   48.285597]  [<c01038e3>] sysenter_do_call+0x12/0x2f
[   48.285597] Code: f2 88 50 03 e9 7f 06 00 00 8b 75 34 8b 06 83 e0 fc 74 29
e8 88 ce 06 c8 89 c7 8b 45 30 03 7e 04 0f b6 50 04 89 d8 89 d1 c1 e9 02 <f3> ab
f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa eb 1a 83 3d e0 17
[   48.285597] EIP: [<f80fcd86>] megaraid_queue_command+0x187/0x822
[megaraid_mbox] SS:ESP 0068:f612fb58
[   48.285597] Kernel panic - not syncing: Fatal exception
[   48.285597] ------------[ cut here ]------------


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
