From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH RFC 0/2] avoid crashing when reading /proc/scsi/scsi and simultaneously removing devices
Date: Tue,  8 Dec 2015 09:08:22 -0500
Message-ID: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbbLHOIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 09:08:25 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 8C22C935F7
	for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2015 14:08:25 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id tB8E8OxQ005638
	for <linux-scsi@vger.kernel.org>; Tue, 8 Dec 2015 09:08:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The klist traversal used by the reading of /proc/scsi/scsi is not interlocked
against device removal.  It takes a reference on the containing object, but
this does not prevent the device from being removed from the list.  Thus, we
get errors and eventually panic, as shown in the traces below.  Fix this by
keeping a klist iterator in the seq_file private data.

The problem can be easily reproduced by repeatedly increasing scsi_debug's
max_luns to 30 and then deleting the devices via sysfs, while simulatenously
accessing /proc/scsi/scsi.
    
>From a patch originally developed by David Jeffery <djeffery@redhat.com>

Dec  3 13:22:02 localhost kernel: WARNING: CPU: 2 PID: 28073 at include/linux/kref.h:47 klist_iter_init_node+0x3d/0x50()
Dec  3 13:22:02 localhost kernel: Modules linked in: scsi_debug x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32c_intel joydev iTCO_wdt dcdbas ipmi_devintf acpi_power_meter iTCO_vendor_support ipmi_si imsghandler pcspkr wmi acpi_cpufreq tpm_tis tpm shpchp lpc_ich mfd_core nfsd nfs_acl lockd grace sunrpc tg3 ptp pps_core
Dec  3 13:22:02 localhost kernel: CPU: 2 PID: 28073 Comm: cat Not tainted 4.4.0-rc1+ #2
Dec  3 13:22:02 localhost kernel: Hardware name: Dell Inc. PowerEdge R320/08VT7V, BIOS 2.0.22 11/19/2013
Dec  3 13:22:02 localhost kernel: ffffffff81a20e77 ffff880613acfd18 ffffffff81321eef 0000000000000000
Dec  3 13:22:02 localhost kernel: ffff880613acfd50 ffffffff8107ca52 ffff88061176b198 0000000000000000
Dec  3 13:22:02 localhost kernel: ffffffff814542b0 ffff880610cfb100 ffff88061176b198 ffff880613acfd60
Dec  3 13:22:02 localhost kernel: Call Trace:
Dec  3 13:22:02 localhost kernel: [<ffffffff81321eef>] dump_stack+0x44/0x55
Dec  3 13:22:02 localhost kernel: [<ffffffff8107ca52>] warn_slowpath_common+0x82/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff814542b0>] ? proc_scsi_show+0x20/0x20
Dec  3 13:22:02 localhost kernel: [<ffffffff8107cb4a>] warn_slowpath_null+0x1a/0x20
Dec  3 13:22:02 localhost kernel: [<ffffffff8167225d>] klist_iter_init_node+0x3d/0x50
Dec  3 13:22:02 localhost kernel: [<ffffffff81421d41>] bus_find_device+0x51/0xb0
Dec  3 13:22:02 localhost kernel: [<ffffffff814545ad>] scsi_seq_next+0x2d/0x40
Dec  3 13:22:02 localhost kernel: [<ffffffff811e2e50>] seq_read+0x290/0x370
Dec  3 13:22:02 localhost kernel: [<ffffffff81225be8>] proc_reg_read+0x48/0x70
Dec  3 13:22:02 localhost kernel: [<ffffffff811c07c8>] __vfs_read+0x28/0xd0
Dec  3 13:22:02 localhost kernel: [<ffffffff812b5323>] ? security_file_permission+0xa3/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff811c0cf3>] ? rw_verify_area+0x53/0xf0
Dec  3 13:22:02 localhost kernel: [<ffffffff811c0e16>] vfs_read+0x86/0x130
Dec  3 13:22:02 localhost kernel: [<ffffffff811c1bb6>] SyS_read+0x46/0xa0
Dec  3 13:22:02 localhost kernel: [<ffffffff8167c717>] entry_SYSCALL_64_fastpath+0x12/0x6a
Dec  3 13:22:02 localhost kernel: ---[ end trace 99a60fb1c41fc8c9 ]---
Dec  3 13:22:02 localhost kernel: ------------[ cut here ]------------
Dec  3 13:22:02 localhost kernel: WARNING: CPU: 2 PID: 28073 at lib/klist.c:189 klist_release+0xa8/0xb0()
Dec  3 13:22:02 localhost kernel: Modules linked in: scsi_debug x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32c_intel joydev iTCO_wdt dcdbas ipmi_devintf acpi_power_meter iTCO_vendor_support ipmi_si imsghandler pcspkr wmi acpi_cpufreq tpm_tis tpm shpchp lpc_ich mfd_core nfsd nfs_acl lockd grace sunrpc tg3 ptp pps_core
Dec  3 13:22:02 localhost kernel: CPU: 2 PID: 28073 Comm: cat Tainted: G        W       4.4.0-rc1+ #2
Dec  3 13:22:02 localhost kernel: Hardware name: Dell Inc. PowerEdge R320/08VT7V, BIOS 2.0.22 11/19/2013
Dec  3 13:22:02 localhost kernel: ffffffff81aaa040 ffff880613acfcc0 ffffffff81321eef 0000000000000000
Dec  3 13:22:02 localhost kernel: ffff880613acfcf8 ffffffff8107ca52 dead0000000000f8 ffff880613acfd80
Dec  3 13:22:02 localhost kernel: ffff88060f7aa368 ffff88060f7aa380 ffff88061176b198 ffff880613acfd08
Dec  3 13:22:02 localhost kernel: Call Trace:
Dec  3 13:22:02 localhost kernel: [<ffffffff81321eef>] dump_stack+0x44/0x55
Dec  3 13:22:02 localhost kernel: [<ffffffff8107ca52>] warn_slowpath_common+0x82/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff8107cb4a>] warn_slowpath_null+0x1a/0x20
Dec  3 13:22:02 localhost kernel: [<ffffffff816720a8>] klist_release+0xa8/0xb0
Dec  3 13:22:02 localhost kernel: [<ffffffff814220a0>] ? bus_uevent_store+0x50/0x50
Dec  3 13:22:02 localhost kernel: [<ffffffff816723f5>] klist_next+0x95/0xf0
Dec  3 13:22:02 localhost kernel: [<ffffffff814542b0>] ? proc_scsi_show+0x20/0x20
Dec  3 13:22:02 localhost kernel: [<ffffffff81421d62>] bus_find_device+0x72/0xb0
Dec  3 13:22:02 localhost kernel: [<ffffffff814545ad>] scsi_seq_next+0x2d/0x40
Dec  3 13:22:02 localhost kernel: [<ffffffff811e2e50>] seq_read+0x290/0x370
Dec  3 13:22:02 localhost kernel: [<ffffffff81225be8>] proc_reg_read+0x48/0x70
Dec  3 13:22:02 localhost kernel: [<ffffffff811c07c8>] __vfs_read+0x28/0xd0
Dec  3 13:22:02 localhost kernel: [<ffffffff812b5323>] ? security_file_permission+0xa3/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff811c0cf3>] ? rw_verify_area+0x53/0xf0
Dec  3 13:22:02 localhost kernel: [<ffffffff811c0e16>] vfs_read+0x86/0x130
Dec  3 13:22:02 localhost kernel: [<ffffffff811c1bb6>] SyS_read+0x46/0xa0
Dec  3 13:22:02 localhost kernel: [<ffffffff8167c717>] entry_SYSCALL_64_fastpath+0x12/0x6a
Dec  3 13:22:02 localhost kernel: ---[ end trace 99a60fb1c41fc8ca ]---
Dec  3 13:22:02 localhost kernel: ------------[ cut here ]------------
Dec  3 13:22:02 localhost kernel: WARNING: CPU: 2 PID: 28073 at lib/list_debug.c:53 __list_del_entry+0x61/0xc0()
Dec  3 13:22:02 localhost kernel: list_del corruption, ffff88060f7aa370->next is LIST_POISON1 (dead000000000100)
Dec  3 13:22:02 localhost kernel: Modules linked in: scsi_debug x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32c_intel joydev iTCO_wdt dcdbas ipmi_devintf acpi_power_meter iTCO_vendor_support ipmi_si imsghandler pcspkr wmi acpi_cpufreq tpm_tis tpm shpchp lpc_ich mfd_core nfsd nfs_acl lockd grace sunrpc tg3 ptp pps_core
Dec  3 13:22:02 localhost kernel: CPU: 2 PID: 28073 Comm: cat Tainted: G        W       4.4.0-rc1+ #2
Dec  3 13:22:02 localhost kernel: Hardware name: Dell Inc. PowerEdge R320/08VT7V, BIOS 2.0.22 11/19/2013
Dec  3 13:22:02 localhost kernel: ffffffff81a516b1 ffff880613acfc48 ffffffff81321eef ffff880613acfc90
Dec  3 13:22:02 localhost kernel: ffff880613acfc80 ffffffff8107ca52 ffff88060f7aa370 ffff880613acfd80
Dec  3 13:22:02 localhost kernel: ffff88060f7aa368 ffff88060f7aa380 ffff88061176b198 ffff880613acfce0
Dec  3 13:22:02 localhost kernel: Call Trace:
Dec  3 13:22:02 localhost kernel: [<ffffffff81321eef>] dump_stack+0x44/0x55
Dec  3 13:22:02 localhost kernel: [<ffffffff8107ca52>] warn_slowpath_common+0x82/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff8107cadc>] warn_slowpath_fmt+0x4c/0x50
Dec  3 13:22:02 localhost kernel: [<ffffffff8133e581>] __list_del_entry+0x61/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff8133e5ed>] list_del+0xd/0x30
Dec  3 13:22:02 localhost kernel: [<ffffffff81672021>] klist_release+0x21/0xb0
Dec  3 13:22:02 localhost kernel: [<ffffffff814220a0>] ? bus_uevent_store+0x50/0x50
Dec  3 13:22:02 localhost kernel: [<ffffffff816723f5>] klist_next+0x95/0xf0
Dec  3 13:22:02 localhost kernel: [<ffffffff814542b0>] ? proc_scsi_show+0x20/0x20
Dec  3 13:22:02 localhost kernel: [<ffffffff81421d62>] bus_find_device+0x72/0xb0
Dec  3 13:22:02 localhost kernel: [<ffffffff814545ad>] scsi_seq_next+0x2d/0x40
Dec  3 13:22:02 localhost kernel: [<ffffffff811e2e50>] seq_read+0x290/0x370
Dec  3 13:22:02 localhost kernel: [<ffffffff81225be8>] proc_reg_read+0x48/0x70
Dec  3 13:22:02 localhost kernel: [<ffffffff811c07c8>] __vfs_read+0x28/0xd0
Dec  3 13:22:02 localhost kernel: [<ffffffff812b5323>] ? security_file_permission+0xa3/0xc0
Dec  3 13:22:02 localhost kernel: [<ffffffff811c0cf3>] ? rw_verify_area+0x53/0xf0
Dec  3 13:22:02 localhost kernel: [<ffffffff811c0e16>] vfs_read+0x86/0x130
Dec  3 13:22:02 localhost kernel: [<ffffffff811c1bb6>] SyS_read+0x46/0xa0
Dec  3 13:22:02 localhost kernel: [<ffffffff8167c717>] entry_SYSCALL_64_fastpath+0x12/0x6a
Dec  3 13:22:02 localhost kernel: ---[ end trace 99a60fb1c41fc8cb ]---
Dec  3 13:22:03 localhost kernel: general protection fault: 0000 [#1] SMP
Dec  3 13:22:03 localhost kernel: Modules linked in: scsi_debug x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32c_intel joydev iTCO_wdt dcdbas ipmi_devintf acpi_power_meter iTCO_vendor_support ipmi_si imsghandler pcspkr wmi acpi_cpufreq tpm_tis tpm shpchp lpc_ich mfd_core nfsd nfs_acl lockd grace sunrpc tg3 ptp pps_core
Dec  3 13:22:03 localhost kernel: CPU: 2 PID: 28073 Comm: cat Tainted: G        W       4.4.0-rc1+ #2
Dec  3 13:22:03 localhost kernel: Hardware name: Dell Inc. PowerEdge R320/08VT7V, BIOS 2.0.22 11/19/2013
Dec  3 13:22:03 localhost kernel: task: ffff8806090ef080 ti: ffff880613acc000 task.ti: ffff880613acc000
Dec  3 13:22:03 localhost kernel: RIP: 0010:[<ffffffff816723b2>]  [<ffffffff816723b2>] klist_next+0x52/0xf0
Dec  3 13:22:03 localhost kernel: RSP: 0018:ffff880613acfd48  EFLAGS: 00010287
Dec  3 13:22:03 localhost kernel: RAX: ffff880612ea2ea8 RBX: dead0000000000f8 RCX: 0000000000000000
Dec  3 13:22:03 localhost kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff81cfcab0
Dec  3 13:22:03 localhost kernel: RBP: ffff880613acfd70 R08: 0000000000000001 R09: 000000000000fffe
Dec  3 13:22:03 localhost kernel: R10: 0000000000002a81 R11: 0000000000000002 R12: ffff880613acfd80
Dec  3 13:22:03 localhost kernel: R13: ffffffff814220a0 R14: ffff88060f7aa368 R15: ffff88061176b101
Dec  3 13:22:03 localhost kernel: FS:  00007f47e9ca4700(0000) GS:ffff880617040000(0000) knlGS:0000000000000000
Dec  3 13:22:03 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  3 13:22:03 localhost kernel: CR2: 0000000001d22038 CR3: 000000060724c000 CR4: 00000000000406e0
Dec  3 13:22:03 localhost kernel: Stack:
Dec  3 13:22:03 localhost kernel: ffff88061176b198 0000000000000000 ffffffff814542b0 ffff880610cfb100
Dec  3 13:22:03 localhost kernel: ffff88061176b198 ffff880613acfda8 ffffffff81421d62 ffff880612ea2ea8
Dec  3 13:22:03 localhost kernel: 0000000000000000 ffff88061176b198 ffff880613acff20 ffff880035f39b00
Dec  3 13:22:03 localhost kernel: Call Trace:
Dec  3 13:22:03 localhost kernel: [<ffffffff814542b0>] ? proc_scsi_show+0x20/0x20
Dec  3 13:22:03 localhost kernel: [<ffffffff81421d62>] bus_find_device+0x72/0xb0
Dec  3 13:22:03 localhost kernel: [<ffffffff814545ad>] scsi_seq_next+0x2d/0x40
Dec  3 13:22:03 localhost kernel: [<ffffffff811e2e50>] seq_read+0x290/0x370
Dec  3 13:22:03 localhost kernel: [<ffffffff81225be8>] proc_reg_read+0x48/0x70
Dec  3 13:22:03 localhost kernel: [<ffffffff811c07c8>] __vfs_read+0x28/0xd0
Dec  3 13:22:03 localhost kernel: [<ffffffff812b5323>] ? security_file_permission+0xa3/0xc0
Dec  3 13:22:03 localhost kernel: [<ffffffff811c0cf3>] ? rw_verify_area+0x53/0xf0
Dec  3 13:22:03 localhost kernel: [<ffffffff811c0e16>] vfs_read+0x86/0x130
Dec  3 13:22:03 localhost kernel: [<ffffffff811c1bb6>] SyS_read+0x46/0xa0
Dec  3 13:22:03 localhost kernel: [<ffffffff8167c717>] entry_SYSCALL_64_fastpath+0x12/0x6a
Dec  3 13:22:03 localhost kernel: Code: 8b 46 08 49 8d 7e 18 48 8d 58 f8 f0 41 83 6e 18 01 74 56 49 8b 04 24 45 31 ff 45 31 ed 48 39 c3 49 c7 44 24 08 00 00 00 00 74 20 <f6> 03 01 75 5c b8 01 00 00 00 f0 1 43 18 83 c0 01 83 f8 01
Dec  3 13:22:03 localhost kernel: RIP  [<ffffffff816723b2>] klist_next+0x52/0xf0
Dec  3 13:22:03 localhost kernel: RSP <ffff880613acfd48>
Dec  3 13:22:03 localhost kernel: ---[ end trace 99a60fb1c41fc8cc ]---

Ewan D. Milne (2):
  drivers/base: add bus_device_iter_init, bus_device_iter_next,
    bus_device_iter_exit
  scsi_proc: Change /proc/scsi/scsi to use bus device iterator

 drivers/base/bus.c       | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_proc.c | 49 ++++++++++++++++++++++++++++--------------------
 include/linux/device.h   | 14 ++++++++++++++
 3 files changed, 91 insertions(+), 20 deletions(-)

-- 
2.1.0

