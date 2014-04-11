From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Fri, 11 Apr 2014 13:49:51 +0000
Message-ID: <bug-71231-11613-fz1b2vUs9G@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55729 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbaDKNty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 09:49:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E601F2081B
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 13:49:52 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0829B2080B
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 13:49:52 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #15 from Alex <alexandernaumann@gmx.de> ---
After disabling ACPI Processor and cpuidle, I get these four different stack
traces (system is working, but not rebooting anymore for example) several
times:


Call Trace:
 [<ffffffff8175bafd>] __mutex_lock_slowpath+0x5d/0x1d0
 [<ffffffff8175bc48>] ? __mutex_lock_slowpath+0x1a8/0x1d0
 [<ffffffff8175b57d>] mutex_lock+0x1d/0x40
 [<ffffffff81152645>] sysfs_dentry_revalidate+0x35/0x100
 [<ffffffff810fa729>] lookup_fast+0x299/0x2e0
 [<ffffffff810fab06>] ? __inode_permission+0x46/0x70
 [<ffffffff810fad1a>] link_path_walk+0x19a/0x800
 [<ffffffff81027fd9>] ? physflat_send_IPI_mask+0x9/0x10
 [<ffffffff810fe604>] path_openat.isra.68+0x94/0x450
 [<ffffffff8175bc48>] ? __mutex_lock_slowpath+0x1a8/0x1d0
 [<ffffffff810febec>] do_filp_open+0x3c/0x90
 [<ffffffff8110a332>] ? __alloc_fd+0x42/0x100
 [<ffffffff810eefef>] do_sys_open+0xef/0x1d0
 [<ffffffff81002441>] ? do_notify_resume+0x51/0x80
 [<ffffffff81135ae6>] compat_SyS_open+0x16/0x20
 [<ffffffff81760318>] sysenter_dispatch+0x7/0x25

Call Trace:
 [<ffffffff8100a7c9>] default_idle+0x9/0x10
 [<ffffffff8100af4a>] arch_cpu_idle+0xa/0x10
 [<ffffffff81071eb1>] cpu_startup_entry+0x91/0x180
 [<ffffffff81cd9ef7>] start_secondary+0x1a0/0x1a4

Call Trace:
 [<ffffffff81112242>] ? simple_read_from_buffer+0x42/0xa0
 [<ffffffff81151b73>] sysfs_read_file+0xe3/0x190
 [<ffffffff810f02e4>] vfs_read+0xa4/0x180
 [<ffffffff810f055d>] SyS_read+0x4d/0x90
 [<ffffffff81760318>] sysenter_dispatch+0x7/0x25

Call Trace:
 [<ffffffff8175bafd>] __mutex_lock_slowpath+0x5d/0x1d0
 [<ffffffff8175b57d>] mutex_lock+0x1d/0x40
 [<ffffffff811511db>] sysfs_getattr+0x2b/0x60
 [<ffffffff810f45e4>] vfs_getattr+0x24/0x40
 [<ffffffff810f4b88>] vfs_fstat+0x38/0x70
 [<ffffffff8110a332>] ? __alloc_fd+0x42/0x100
 [<ffffffff81036385>] sys32_fstat64+0x15/0x30
 [<ffffffff810ef064>] ? do_sys_open+0x164/0x1d0
 [<ffffffff81760318>] sysenter_dispatch+0x7/0x25


I have booted this Multiprocessor server with 40 FC-LUNs connected
(multipathing --> 80).

-- 
You are receiving this mail because:
You are the assignee for the bug.
