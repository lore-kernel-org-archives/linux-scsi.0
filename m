From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Thu, 26 Dec 2013 09:00:24 +0000
Message-ID: <bug-60758-11613-DjWwtg3Wxc@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46128 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3LZJA3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Dec 2013 04:00:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A523F20144
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2013 09:00:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C26A52015A
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2013 09:00:25 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

Lin Feng <linf@chinanetcenter.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linf@chinanetcenter.com

--- Comment #50 from Lin Feng <linf@chinanetcenter.com> ---
Hi all,

I got exactly the same problem on a CentOS 6.4 64bit kvm guest. That's while
trying to update my kenrel to mainline 3.13-rc5 console repeat writing "FATAL:
Module scsi_wait_scan not found." and finally panic. The whole output graph is
maily same as pasted by Vincent Li.

After tracking this bugzilla I get the thought that the dracut mismatch with
the kernel. Since kerne 3.6 and following have dropped scsi_wait_scan module
but CentOS6.4's dracut is hardcoded to add the instruction "modeprobe
scsi_wait_scan" into /init script in initramfs image.

So I tried following approaches for confirmation:
1. Update kernel to 3.5(it still holds the scsi_wait_scan module): it boots
find.
2. Update the dracut to the latest version in git tree, since it has removed
the redundant "modeprobe scsi_wait_scan" for building 3.6 and later kernels but
it doesn't work, telling me that could not find root device like pasted in
step3.
3. Decompress the initramfs and modify the /init script by removing the line
"modeprobe scsi_wait_scan" but it doesn't work neither:
(snips)
dracut Warning: No root device
"block:/dev/disk/by-uuid/cedcbd9c-32eb-4a3f-9dad-ae5fc560642a" found





dracut Warning: Boot has failed. To debug this issue add "rdshell" to the
kernel command line.


dracut Warning: Signal caught!

dracut Warning: Boot has failed. To debug this issue add "rdshell" to the
kernel command line.
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100

CPU: 1 PID: 1 Comm: init Tainted: GF            3.13.0-rc5 #6
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 0000000000000001 ffff88005dbf9d98 ffffffff8156c92b 000000000000fffe
 ffffffff817dd350 ffff88005dbf9e18 ffffffff8156c6b8 ffffffff00000010
 ffff88005dbf9e28 ffff88005dbf9dc8 ffff88005dbdf7b8 ffff88005dbf9dd8
Call Trace:
 [<ffffffff8156c92b>] dump_stack+0x49/0x5e
 [<ffffffff8156c6b8>] panic+0xbb/0x1d5
 [<ffffffff8104e75b>] find_new_reaper+0x17b/0x180
 [<ffffffff8104f8e5>] forget_original_parent+0x45/0x1c0
 [<ffffffff8111e1f0>] ? perf_cgroup_switch+0x180/0x180
 [<ffffffff8104fa77>] exit_notify+0x17/0x130
 [<ffffffff8104fd7e>] do_exit+0x1ee/0x480
 [<ffffffff81050061>] do_group_exit+0x51/0xc0
 [<ffffffff810500e7>] SyS_exit_group+0x17/0x20
 [<ffffffff81579212>] system_call_fastpath+0x16/0x1b
-------------------------------------------------------------------------------

>From 2 and 3 it seems that scsi_wait_scan is necessary in some cases, like H87
board and my KVM case.

Any idea, Can anyone tell me how to move on? Thanks in advance.

-- 
You are receiving this mail because:
You are the assignee for the bug.
