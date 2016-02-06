From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71021] WARNING: CPU: 0 PID: 5517 at
 /build/buildd/linux-3.13.0/fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Sat, 06 Feb 2016 01:20:11 +0000
Message-ID: <bug-71021-11613-D922FNVOYw@https.bugzilla.kernel.org/>
References: <bug-71021-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbcBFBUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Feb 2016 20:20:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DA820203C2
	for <linux-scsi@vger.kernel.org>; Sat,  6 Feb 2016 01:20:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 87E37203DC
	for <linux-scsi@vger.kernel.org>; Sat,  6 Feb 2016 01:20:11 +0000 (UTC)
In-Reply-To: <bug-71021-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71021

Yijing Wang <wangyijing@huawei.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wangyijing@huawei.com

--- Comment #4 from Yijing Wang <wangyijing@huawei.com> ---
I also found the same issue when remove my disk in my platform, I think the
code logic is incorrect, this call trace would appear every disk remove. I
found  Dan Williams posted a fix patch, but it was not merged to kernel.

https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html

Following is my call trace:

WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:224 sysfs_remove_group+0x9c/0xa0()
sysfs group (power)ffff800000a2dbe8 not found for kobject '0:0:1:0'
Modules linked in:
CPU: 2 PID: 6 Comm: kworker/u64:0 Not tainted 4.1.6+ #157
Hardware name: Hisilicon PhosphorV660 Development Board (DT)
Workqueue: scsi_wq_0 sas_destruct_devices
Call trace:
[<ffff800000089918>] dump_backtrace+0x0/0x124
[<ffff800000089a4c>] show_stack+0x10/0x1c
[<ffff8000006ecd10>] dump_stack+0x78/0x98
[<ffff80000009fc38>] warn_slowpath_common+0x98/0xd0
[<ffff80000009fcbc>] warn_slowpath_fmt+0x4c/0x58
[<ffff8000001fc190>] sysfs_remove_group+0x98/0xa0
[<ffff8000003d7afc>] dpm_sysfs_remove+0x54/0x68
[<ffff8000003cca20>] device_del+0x3c/0x208
[<ffff8000003ccbfc>] device_unregister+0x10/0x2c
[<ffff800000307810>] bsg_unregister_queue+0xbc/0xf8
[<ffff8000003fa3b0>] __scsi_remove_device+0x9c/0xbc
[<ffff8000003fa414>] scsi_remove_device+0x44/0x64
[<ffff8000003fa604>] scsi_remove_target+0x198/0x258
[<ffff80000040c090>] sas_rphy_remove+0x8c/0xb4
[<ffff80000040c0ec>] sas_rphy_delete+0x34/0x54
[<ffff8000004102d0>] sas_destruct_devices+0x60/0x98
[<ffff8000000b5490>] process_one_work+0x13c/0x344
[<ffff8000000b57d4>] worker_thread+0x13c/0x494
[<ffff8000000bafb8>] kthread+0xd8/0xf0

-- 
You are receiving this mail because:
You are the assignee for the bug.
