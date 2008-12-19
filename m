From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Fri, 19 Dec 2008 01:53:12 -0800 (PST)
Message-ID: <20081219095312.2886011D107@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbYLSJxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 04:53:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBJ9rCag004062
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2008 01:53:13 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #6 from crquan@gmail.com  2008-12-19 01:53 -------
On another type of machine, the driver 4.00.43 with rhel 5.2 x86_64 will cause
to a kernel panic.

Steps to reproduce:
1. Install rhel5.2 x86_64, then mptlinux-4.00.43.00-1-rhel5.x86_64.rpm from lsi
website;
2. normal spare disks support hotplug well;
3. if create a filesystem and mount it, or create lvm, or create soft RAID on
any of the disks, it doesn't support hotplug;
4. if try to plug the disk in a mounted filesystem, or lvm, or soft RAID, the
kernel will panic,

the message as:

gektop@tux ~/sforge/linux-2.6 $ netcat -u -l -p 5140

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff800649dd>] _spin_lock+0x0/0xa
PGD 0 
Oops: 0002 [1] SMP 
last sysfs file: /module/ehci_hcd/sections/.text
CPU 1 
Modules linked in: netconsole(U) autofs4(U) hidp(U) l2cap(U) bluetooth(U)
sunrpc(U) mptctl(U) loop(U) dm_multipath(U) video(U) sbs(U) backlight(U)
i2c_ec(U) button(U) battery(U) asus_acpi(U) acpi_memhotplug(U) ac(U)
parport_pc(U) lp(U) parport(U) floppy(U) sg(U) i2c_i801(U) serio_raw(U)
i5000_edac(U) i2c_core(U) pcspkr(U) edac_mc(U) e1000e(U) shpchp(U)
dm_snapshot(U) dm_zero(U) dm_mirror(U) dm_mod(U) ata_piix(U) libata(U) mptfc(U)
scsi_transport_fc(U) mptspi(U) scsi_transport_spi(U) mptsas(U) mptscsih(U)
mptbase(U) scsi_transport_sas(U) sd_mod(U) scsi_mod(U) ext3(U) jbd(U)
uhci_hcd(U) ohci_hcd(U) ehci_hcd(U)
Pid: 455, comm: mpt/0 Tainted: G      2.6.18-u1219 #1
RIP: 0010:[<ffffffff800649dd>]  [<ffffffff800649dd>] _spin_lock+0x0/0xa
RSP: 0018:ffff81007effbc78  EFLAGS: 00010282
RAX: ffff81007ee95000 RBX: ffff81007a887828 RCX: ffff81007e8ed860
RDX: ffff8100796b0000 RSI: ffff81007a887800 RDI: 0000000000000000
RBP: ffff81007a887800 R08: 00000000ffffffff R09: ffff81007e8ed860
R10: ffff81007e8ed860 R11: ffff81007e8ed860 R12: 0000000000000000
R13: ffff81007ee65c38 R14: ffff81007a887a80 R15: ffffffff880fd792
FS:  0000000000000000(0000) GS:ffff81007ff0b7c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000079867000 CR4: 00000000000006e0
Process mpt/0 (pid: 455, threadinfo ffff81007effa000, task ffff81007fb36080)
Stack:  ffffffff80266193 ffff81007ee95748 ffff81007a887800 ffff81007a8877e0
 ffffffff801ad7d4 ffff810078413700 ffff81007a887800 ffff81007a887a98
 ffff81007a8877e0 ffff81007a8877e0 ffffffff880b4e4e ffff81007eea8000
Call Trace:
 [<ffffffff80266193>] klist_del+0x15/0x2a
 [<ffffffff801ad7d4>] device_del+0x22/0x17f
 [<ffffffff880b4e4e>] :scsi_transport_sas:sas_port_delete+0xdf/0xf7
 [<ffffffff880fd87d>] :mptsas:mptsas_firmware_event_work+0xeb/0xcc3
 [<ffffffff80062efb>] thread_return+0x0/0xdf
 [<ffffffff8008a60e>] __activate_task+0x27/0x39
 [<ffffffff880fd792>] :mptsas:mptsas_firmware_event_work+0x0/0xcc3
 [<ffffffff8004cea9>] run_workqueue+0x94/0xe4
 [<ffffffff800497be>] worker_thread+0x0/0x122
 [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800498ae>] worker_thread+0xf0/0x122
 [<ffffffff8008ac03>] default_wake_function+0x0/0xe
 [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8003253d>] kthread+0xfe/0x132
 [<ffffffff8005dfb1>] child_rip+0xa/0x11
 [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8003243f>] kthread+0x0/0x132
 [<ffffffff8005dfa7>] child_rip+0x0/0x11


Code: read(net): Connection refused


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
