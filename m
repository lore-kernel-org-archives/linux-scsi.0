From: Andrew Ryan <genanr@emsphone.com>
Subject: MD causes BUG in scsi-lib.c kernel 2.6.0-test4
Date: Fri, 29 Aug 2003 10:36:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030829153614.GA30216@thumper2.emsphone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thumper2.emsphone.com ([199.67.51.102]:21960 "EHLO
	thumper2.emsphone.com") by vger.kernel.org with ESMTP
	id S261403AbTH2PgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 11:36:19 -0400
Received: from thumper2.emsphone.com (genanr@localhost [127.0.0.1])
	by thumper2.emsphone.com (8.12.9/8.12.9/Debian-3) with ESMTP id h7TFaEm8030300
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2003 10:36:14 -0500
Received: (from genanr@localhost)
	by thumper2.emsphone.com (8.12.9/8.12.9/Debian-3) id h7TFaEqI030298
	for linux-scsi@vger.kernel.org; Fri, 29 Aug 2003 10:36:14 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When trying to set up a simple multipath MD device, I get the following oops
when trying to create (or mount) it.  Kernel version 2.6.0-test4 using
qlogic 8.00.00b5 drivers.

Aug 25 17:56:55 linuxha1 kernel: kernel BUG at drivers/scsi/scsi_lib.c:544!
Aug 25 17:56:55 linuxha1 kernel: invalid operand: 0000 [#1]
Aug 25 17:56:55 linuxha1 kernel: CPU:    1
Aug 25 17:56:55 linuxha1 kernel: EIP:    0060:[<c022b195>]    Not tainted
Aug 25 17:56:55 linuxha1 kernel: EFLAGS: 00010046
Aug 25 17:56:55 linuxha1 kernel: EIP is at scsi_alloc_sgtable+0x15/0xf0
Aug 25 17:56:55 linuxha1 kernel: eax: 00000000   ebx: f6811248   ecx: f6b7c400   edx: f7d3e7e0
Aug 25 17:56:55 linuxha1 kernel: esi: 00000020   edi: f7d3e7e0   ebp: f6811248   esp: f660bd2c
Aug 25 17:56:55 linuxha1 kernel: ds: 007b   es: 007b   ss: 0068
Aug 25 17:56:55 linuxha1 kernel: Process mount (pid: 5551, threadinfo=f660a000 task=f769b3a0)
Aug 25 17:56:55 linuxha1 kernel: Stack: 00000020 f6811248 00000020 f7d3e7e0 f6811248 c022b77b f7d3e7e0 00000020 
Aug 25 17:56:55 linuxha1 kernel:        f7d3e7e0 00000020 f6b7c400 c022b91d f7d3e7e0 f6811248 f6d8c800 f660bdac 
Aug 25 17:56:55 linuxha1 kernel:        f678bad4 c01ed244 f6d8c800 f6811248 f6d8c800 f6d8c944 c01ee995 f6d8c800 
Aug 25 17:56:55 linuxha1 kernel: Call Trace:
Aug 25 17:56:55 linuxha1 kernel:  [<c022b77b>] scsi_init_io+0x5b/0x110
Aug 25 17:56:55 linuxha1 kernel:  [<c022b91d>] scsi_prep_fn+0xed/0x150
Aug 25 17:56:55 linuxha1 kernel:  [<c01ed244>] elv_next_request+0x14/0xe0
Aug 25 17:56:55 linuxha1 kernel:  [<c01ee995>] generic_unplug_device+0x45/0x70
Aug 25 17:56:55 linuxha1 kernel:  [<c013734f>] do_page_cache_readahead+0x14f/0x170
Aug 25 17:56:55 linuxha1 kernel:  [<c01eead2>] blk_run_queues+0x72/0xa0
Aug 25 17:56:55 linuxha1 kernel:  [<c0150175>] block_sync_page+0x5/0x10
Aug 25 17:56:55 linuxha1 kernel:  [<c0131a0f>] __lock_page+0xaf/0xe0
Aug 25 17:56:55 linuxha1 kernel:  [<c01185d0>] autoremove_wake_function+0x0/0x40
Aug 25 17:56:55 linuxha1 kernel:  [<c0137445>] page_cache_readahead+0xd5/0x150
Aug 25 17:56:55 linuxha1 kernel:  [<c01185d0>] autoremove_wake_function+0x0/0x40
Aug 25 17:56:55 linuxha1 kernel:  [<c0131eff>] do_generic_mapping_read+0x1cf/0x3a0
Aug 25 17:56:55 linuxha1 kernel:  [<c01320d0>] file_read_actor+0x0/0xd0
Aug 25 17:56:55 linuxha1 kernel:  [<c0132395>] __generic_file_aio_read+0x1f5/0x220
Aug 25 17:56:55 linuxha1 kernel:  [<c01320d0>] file_read_actor+0x0/0xd0
Aug 25 17:56:55 linuxha1 kernel:  [<c0132488>] generic_file_read+0x78/0xa0
Aug 25 17:56:55 linuxha1 kernel:  [<c0152e48>] do_open+0xf8/0x390
Aug 25 17:56:55 linuxha1 kernel:  [<c0153186>] blkdev_open+0x26/0x60
Aug 25 17:56:55 linuxha1 kernel:  [<c014adeb>] dentry_open+0xeb/0x1c0
Aug 25 17:56:55 linuxha1 kernel:  [<c014b97a>] vfs_read+0xaa/0xe0
Aug 25 17:56:55 linuxha1 kernel:  [<c0152600>] block_llseek+0x0/0xe0
Aug 25 17:56:55 linuxha1 kernel:  [<c014b7f5>] sys_llseek+0xb5/0xe0
Aug 25 17:56:55 linuxha1 kernel:  [<c014bb6f>] sys_read+0x2f/0x50
Aug 25 17:56:55 linuxha1 kernel:  [<c0108f93>] syscall_call+0x7/0xb
Aug 25 17:56:55 linuxha1 kernel: 
Aug 25 17:56:55 linuxha1 kernel: Code: 0f 0b 20 02 af cc 2c c0 0f b7 82 9e 00 00 00 83 f8 20 7f 1d 

Andy
