From: Andrew Morton <akpm@osdl.org>
Subject: scsi_proc_hostdir_rm oops
Date: Sat, 27 Mar 2004 03:10:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040327031021.35512ea3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:55188 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261710AbUC0LKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 06:10:21 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Greg KH <greg@kroah.com>


Got this on 2.6.5-rc2-mm2.  Basically nothing was happening at the time -
I'd been fiddling with usb-storage half an hour earlier.


Mar 27 02:41:03 bix kernel: Unable to handle kernel paging request at virtual address f8a07be8
Mar 27 02:41:03 bix kernel:  printing eip:
Mar 27 02:41:03 bix kernel: c024922e
Mar 27 02:41:03 bix kernel: *pde = 37f3c067
Mar 27 02:41:03 bix kernel: *pte = 00000000
Mar 27 02:41:03 bix kernel: Oops: 0000 [#1]
Mar 27 02:41:03 bix kernel: SMP 
Mar 27 02:41:03 bix kernel: CPU:    2
Mar 27 02:41:03 bix kernel: EIP:    0060:[<c024922e>]    Not tainted VLI
Mar 27 02:41:03 bix kernel: EFLAGS: 00010246   (2.6.5-rc2-mm2) 
Mar 27 02:41:03 bix kernel: EIP is at scsi_proc_hostdir_rm+0x6/0x60
Mar 27 02:41:03 bix kernel: eax: f8a07ba0   ebx: f8a07ba0   ecx: f6dee6d0   edx: f7d73d80
Mar 27 02:41:03 bix kernel: esi: f7d73d78   edi: f57a1694   ebp: f5583a00   esp: f7d73d48
Mar 27 02:41:04 bix kernel: ds: 007b   es: 007b   ss: 0068
Mar 27 02:41:04 bix kernel: Process kswapd0 (pid: 22, threadinfo=f7d73000 task=f7d56230)
Mar 27 02:41:04 bix kernel: Stack: f5583ac4 f7d73d78 c0241ed8 f8a07ba0 c0384ef0 f5583ae8 c0384f20 f57a16b8 
Mar 27 02:41:04 bix kernel:        00000000 00000001 f7d73d80 f7d73d80 00000000 00000001 f7d73d80 f7d73d80 
Mar 27 02:41:04 bix kernel:        c0201678 f5583ac4 c01acf74 f5583ae8 c0385140 f5583b84 c0385160 c038b5d4 
Mar 27 02:41:04 bix kernel: Call Trace:
Mar 27 02:41:04 bix kernel:  [<c0241ed8>] scsi_host_dev_release+0x7c/0xa4
Mar 27 02:41:04 bix kernel:  [<c0201678>] device_release+0x14/0x4c
Mar 27 02:41:04 bix kernel:  [<c01acf74>] kobject_cleanup+0x44/0x6c
Mar 27 02:41:04 bix kernel:  [<c01acfb1>] kobject_put+0x15/0x1c
Mar 27 02:41:04 bix kernel:  [<c0201929>] put_device+0xd/0x14
Mar 27 02:41:04 bix kernel:  [<c0241c3f>] scsi_host_cls_release+0xf/0x14
Mar 27 02:41:04 bix kernel:  [<c0202e6a>] class_dev_release+0x16/0x50
Mar 27 02:41:04 bix kernel:  [<c01acf74>] kobject_cleanup+0x44/0x6c
Mar 27 02:41:04 bix kernel:  [<c01acfb1>] kobject_put+0x15/0x1c
Mar 27 02:41:04 bix kernel:  [<c0184641>] sysfs_d_iput+0x11/0x24
Mar 27 02:41:04 bix kernel:  [<c016b888>] dput+0x17c/0x1c0
Mar 27 02:41:04 bix kernel:  [<c016bc86>] prune_dcache+0x17a/0x1ac
Mar 27 02:41:04 bix kernel:  [<c016c085>] shrink_dcache_memory+0x15/0x20
Mar 27 02:41:04 bix kernel:  [<c01447a2>] shrink_slab+0x13e/0x194
Mar 27 02:41:04 bix kernel:  [<c0145d27>] balance_pgdat+0x15b/0x210
Mar 27 02:41:04 bix kernel:  [<c0145ef5>] kswapd+0x119/0x120
Mar 27 02:41:04 bix kernel:  [<c0145ddc>] kswapd+0x0/0x120
Mar 27 02:41:04 bix kernel:  [<c012074c>] autoremove_wake_function+0x0/0x3c
Mar 27 02:41:04 bix kernel:  [<c012074c>] autoremove_wake_function+0x0/0x3c
Mar 27 02:41:04 bix kernel:  [<c0107255>] kernel_thread_helper+0x5/0xc
Mar 27 02:41:04 bix kernel: 
Mar 27 02:41:04 bix kernel: Code: e8 7c 99 ed ff 83 c4 0c eb 08 8d 76 00 8b 03 89 42 24 89 f1 f0 ff 05 e0 ce 38 c0 0f 8e ce 05 00 00 5b 5e c3 90 56 53 8b 5c 24 0c <83> 7b 48 00 74 50 b9 e0 ce 38 c0 f0 ff 0d e0 ce 38 c0 0f 88 b6 

