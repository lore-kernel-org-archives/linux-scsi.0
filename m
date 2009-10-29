From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: Thin provisioning support
Date: Thu, 29 Oct 2009 03:23:22 -0400
Message-ID: <20091029072322.GA25926@infradead.org>
References: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbZJ2HXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 03:23:17 -0400
Content-Disposition: inline
In-Reply-To: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

And a crash when using unmap_granularity=1 when using the discard-enable
mkfs.xfs binary from xfsprogs-dev.git:

qemu1:~/xfsprogs-dev# ./mkfs/mkfs.xfs -f /dev/sdb
[   53.562041] BUG: unable to handle kernel paging request at fcc80000
[   53.563812] IP: [<c070fbb7>] unmap_region+0xc7/0x120
[   53.564091] *pde = 36fd0067 *pte = 00000000 
[   53.564091] Oops: 0002 [#1] SMP 
[   53.564091] last sysfs file: /sys/block/sr0/dev
[   53.564091] Modules linked in:
[   53.564091] 
[   53.564091] Pid: 184, comm: kblockd/0 Not tainted (2.6.32-rc5-xfs
#414) 
[   53.564091] EIP: 0060:[<c070fbb7>] EFLAGS: 00010046 CPU: 0
[   53.564091] EIP is at unmap_region+0xc7/0x120
[   53.564091] EAX: 00020000 EBX: 0001ffff ECX: 00020000 EDX: fcc7c000
[   53.564091] ESI: 00000000 EDI: 00000001 EBP: f7959ca4 ESP: f7959c54
[   53.564091]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   53.564091] Process kblockd/0 (pid: 184, ti=f7958000 task=f7956f40
task.ti=f7958000)
[   53.564091] Stack:
[   53.564091]  00020000 00000000 00000000 00000000 00000000 00000000
00020000 00000000
[   53.564091] <0> 00020000 00000000 fcc7c000 00000001 00000000 00020000
00000000 00000001
[   53.564091] <0> 00000000 00000001 00000000 00000000 f7959eb0 c0715156
00020000 f792c200
[   53.564091] Call Trace:
[   53.564091]  [<c0715156>] ? scsi_debug_queuecommand+0x1786/0x19b0
[   53.564091]  [<c0131f58>] ? sched_clock+0x8/0x10
[   53.564091]  [<c0182412>] ? sched_clock_local+0xd2/0x170
[   53.564091]  [<c06e8c80>] ? scsi_done+0x0/0x10
[   53.564091]  [<c0182412>] ? sched_clock_local+0xd2/0x170
[   53.564091]  [<c01825d8>] ? sched_clock_cpu+0x128/0x170
[   53.564091]  [<c0191023>] ? __lock_acquire+0x2e3/0x1270
[   53.564091]  [<c0191023>] ? __lock_acquire+0x2e3/0x1270
[   53.564091]  [<c06e8e44>] ? scsi_dispatch_cmd+0xa4/0x250
[   53.564091]  [<c0893af6>] ? _spin_lock_irqsave+0x76/0x90
[   53.564091]  [<c06e8e89>] ? scsi_dispatch_cmd+0xe9/0x250
[   53.564091]  [<c06eed5e>] ? scsi_request_fn+0x38e/0x4d0
[   53.564091]  [<c0651739>] ? __generic_unplug_device+0x29/0x30
[   53.564091]  [<c0651761>] ? generic_unplug_device+0x21/0x30
[   53.564091]  [<c06499a5>] ? blk_unplug_work+0x35/0x40
[   53.564091]  [<c0178785>] ? worker_thread+0x195/0x290
[   53.564091]  [<c0178720>] ? worker_thread+0x130/0x290
[   53.564091]  [<c0649970>] ? blk_unplug_work+0x0/0x40
[   53.564091]  [<c017c810>] ? autoremove_wake_function+0x0/0x50
[   53.564091]  [<c01785f0>] ? worker_thread+0x0/0x290
[   53.564091]  [<c017c504>] ? kthread+0x74/0x80
[   53.564091]  [<c017c490>] ? kthread+0x0/0x80
[   53.564091]  [<c012d4c7>] ? kernel_thread_helper+0x7/0x10
