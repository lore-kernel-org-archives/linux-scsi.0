From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 73621] Kernel exception loading sym53c8xx on dual AMD Athlon
 Tyan S2460 motherboard
Date: Tue, 08 Apr 2014 09:39:17 +0000
Message-ID: <bug-73621-11613-PL9Lh5NEfT@https.bugzilla.kernel.org/>
References: <bug-73621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46515 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbaDHJjU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2014 05:39:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F321B20303
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2014 09:39:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F0FDE203AC
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2014 09:39:17 +0000 (UTC)
In-Reply-To: <bug-73621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=73621

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk

--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk> ---
Incorrect memory frees on error path

[    4.522582] sym0: <825> rev 0x2 at pci 0000:00:09.0 irq 10
[    4.552156] sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
[    4.580096] CACHE TEST FAILED: script execution failed.
[    4.608092] start=35bbf900, pc=0000680c, end=35bbf92c
[    4.636239] sym0: CACHE INCORRECTLY CONFIGURED.
[    4.664419] sym0: giving up ...
[    4.692375] ------------[ cut here ]------------
[    4.693343] WARNING: at
/usr/src/linux-3.10.36/arch/x86/include/asm/dma-mapping.h:166
___free_dma_mem_cluster+0xe9/0xf0 [sym53c8xx]()
[    4.693343] Modules linked in: sym53c8xx(+) w83627hf hwmon_vid hwmon xfs
[    4.693343] CPU: 0 PID: 174 Comm: modprobe Not tainted 3.10.36-smp #1
[    4.693343] Hardware name: Tyan Guinness/Guinness, BIOS PGNA02-8   
12/12/2002
[    4.693343]  00000000 00000000 f51a9a74 c14d3e30 f51a9a9c c10386ce c15dcb79
f8276d54
[    4.693343]  000000a6 f8274ba9 f8274ba9 f511d130 f511d000 c166e640 f51a9aac
c1038792
[    4.693343]  00000009 00000000 f51a9adc f8274ba9 f5108400 f6414100 f5801d80
35096000
[    4.693343] Call Trace:
[    4.693343]  [<c14d3e30>] dump_stack+0x16/0x18
[    4.693343]  [<c10386ce>] warn_slowpath_common+0x5e/0x80
[    4.693343]  [<f8274ba9>] ? ___free_dma_mem_cluster+0xe9/0xf0 [sym53c8xx]
[    4.693343]  [<f8274ba9>] ? ___free_dma_mem_cluster+0xe9/0xf0 [sym53c8xx]
[    4.693343]  [<c1038792>] warn_slowpath_null+0x22/0x30
[    4.693343]  [<f8274ba9>] ___free_dma_mem_cluster+0xe9/0xf0 [sym53c8xx]
[    4.693343]  [<f827479b>] __sym_mfree+0x9b/0xd0 [sym53c8xx]
[    4.693343]  [<c102e4ea>] ? free_memtype+0x9a/0x1c0
[    4.693343]  [<c110b27a>] ? lazy_max_pages+0x1a/0x30
[    4.693343]  [<f8274cdd>] __sym_mfree_dma+0x6d/0x80 [sym53c8xx]
[    4.693343]  [<f8274589>] sym_hcb_free+0x79/0x1a0 [sym53c8xx]
[    4.693343]  [<f826b87e>] sym_free_resources+0x3e/0x80 [sym53c8xx]
[    4.693343]  [<f826d578>] sym2_probe+0x8a8/0xa10 [sym53c8xx]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
