From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Fri, 06 Dec 2013 21:18:11 +0000
Message-ID: <bug-60758-11613-qUmQyluOSS@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48687 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab3LFVSP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Dec 2013 16:18:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 48EB320462
	for <linux-scsi@vger.kernel.org>; Fri,  6 Dec 2013 21:18:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1F0BA20443
	for <linux-scsi@vger.kernel.org>; Fri,  6 Dec 2013 21:18:13 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

Vincent Li <vincent.mc.li@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vincent.mc.li@gmail.com

--- Comment #48 from Vincent Li <vincent.mc.li@gmail.com> ---
oddly, I can boot into 3.12.0-rc4 but not 3.13.0-rc3, neither of them has
scsi_wait_scan.ko compiled. I see error message "FATAL: Module scsi_wait_scan
not found" for both 3.12.0-rc4 and 3.13.0-rc3. but it only appears once for
3.12.0-rc4. it repeated many times for 3.13.0-rc3 and finally kernel Panic:

FATAL: Module scsi_wait_scan not found.
FATAL: Module scsi_wait_scan not found.
FATAL: Module scsi_wait_scan not found.
FATAL: Module scsi_wait_scan not found.

Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100

CPU: 3 PID: 1 Comm: init Tainted: GF            3.13.0-rc3 #27
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
 0000000000000001 ffff8802108f3d98 ffffffff8156c50b 000000000000fffe
 ffffffff817e0d00 ffff8802108f3e18 ffffffff8156c298 ffffffff00000010
 ffff8802108f3e28 ffff8802108f3dc8 ffff8802108f17b8 ffff8802108f3dd8
Call Trace:
 [<ffffffff8156c50b>] dump_stack+0x49/0x5e
 [<ffffffff8156c298>] panic+0xbb/0x1d5
 [<ffffffff8104e74b>] find_new_reaper+0x17b/0x180
 [<ffffffff8104f8d5>] forget_original_parent+0x45/0x1c0
 [<ffffffff8111e110>] ? perf_cgroup_switch+0x180/0x180
 [<ffffffff8104fa67>] exit_notify+0x17/0x130
 [<ffffffff8104fd6e>] do_exit+0x1ee/0x480
 [<ffffffff81050051>] do_group_exit+0x51/0xc0
 [<ffffffff810500d7>] SyS_exit_group+0x17/0x20
 [<ffffffff81578dd2>] system_call_fastpath+0x16/0x1b

I tried comment out the scsi_wait_scan in rc.sysinit and kernel boot parameter
with 'scsi_mod.scan=async', no help

-- 
You are receiving this mail because:
You are the assignee for the bug.
