From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Thu, 16 Apr 2015 11:21:22 +0000
Message-ID: <bug-90601-11613-FiZqAlLag2@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49075 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbbDPLV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2015 07:21:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F28A9202D1
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2015 11:21:25 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 530EB201CE
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2015 11:21:23 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #18 from merlin@liao.homelinux.org ---
Created attachment 174171
  --> https://bugzilla.kernel.org/attachment.cgi?id=174171&action=edit
dmesg

I finally managed to get a dmesg output with the crashing kernel.

Especially this part might indicate the root of the problem?
[Thu Apr 16 13:02:10 2015] ------------[ cut here ]------------
[Thu Apr 16 13:02:10 2015] WARNING: CPU: 6 PID: 1736 at lib/dma-debug.c:601
debug_dma_assert_idle+0x17c/0x1e0()
[Thu Apr 16 13:02:10 2015] 3w-sas 0000:03:00.0: DMA-API: cpu touching an active
dma mapped cacheline [cln=0x0000000101ff8e00]
[Thu Apr 16 13:02:10 2015] Modules linked in:
[Thu Apr 16 13:02:10 2015] CPU: 6 PID: 1736 Comm: mount Not tainted
4.0.0-gentoo #1
[Thu Apr 16 13:02:11 2015] Hardware name: Supermicro
X9DR7/E-(J)LN4F/X9DR7/E-(J)LN4F, BIOS 3.0a 09/10/2013
[Thu Apr 16 13:02:11 2015]  ffffffff8170e0f5 ffff88406050fcb8 ffffffff814c8778
000000000000009a
[Thu Apr 16 13:02:11 2015]  ffff88406050fd08 ffff88406050fcf8 ffffffff8107c250
ffff884060422e08
[Thu Apr 16 13:02:11 2015]  ffff8840647fe5e0 0000000000000206 ffffea00e1bf9ce8
ffff884060422e08
[Thu Apr 16 13:02:11 2015] Call Trace:
[Thu Apr 16 13:02:11 2015]  [<ffffffff814c8778>] dump_stack+0x45/0x57
[Thu Apr 16 13:02:11 2015]  [<ffffffff8107c250>] warn_slowpath_common+0x80/0xc0
[Thu Apr 16 13:02:11 2015]  [<ffffffff8107c2d1>] warn_slowpath_fmt+0x41/0x50
[Thu Apr 16 13:02:11 2015]  [<ffffffff812b9dfc>]
debug_dma_assert_idle+0x17c/0x1e0
[Thu Apr 16 13:02:11 2015]  [<ffffffff81114814>] do_wp_page+0xc4/0x810
[Thu Apr 16 13:02:11 2015]  [<ffffffff8111744c>] handle_mm_fault+0xb3c/0x10f0
[Thu Apr 16 13:02:11 2015]  [<ffffffff8111ca6d>] ? do_mmap_pgoff+0x34d/0x400
[Thu Apr 16 13:02:11 2015]  [<ffffffff81070ec6>] __do_page_fault+0x146/0x390
[Thu Apr 16 13:02:11 2015]  [<ffffffff8107114c>] do_page_fault+0xc/0x10
[Thu Apr 16 13:02:11 2015]  [<ffffffff814cf252>] page_fault+0x22/0x30
[Thu Apr 16 13:02:11 2015] ---[ end trace 326b0530baa65706 ]---


I was still able to login with root after that and reproduce the crash with
another backtrace. See the next attachment.

-- 
You are receiving this mail because:
You are the assignee for the bug.
