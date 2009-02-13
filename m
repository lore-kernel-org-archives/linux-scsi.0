From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc3: BUG: NMI Watchdog detected LOCKUP
Date: Fri, 13 Feb 2009 09:31:06 +0100
Message-ID: <20090213083106.GD4606@elte.hu>
References: <19f34abd0902080221w662635f0h51875a125b156535@mail.gmail.com> <20090212161908.2cc2045c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:50665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZBMIbY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2009 03:31:24 -0500
Content-Disposition: inline
In-Reply-To: <20090212161908.2cc2045c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > [ 3344.972984] Call Trace:
> > [ 3344.972984]  [<ffffffff8118d26a>] __make_request+0x3e/0x412
> > [ 3344.972984]  [<ffffffff8118bf77>] generic_make_request+0x279/0x2c3
> > [ 3344.972984]  [<ffffffff8119f189>] ? radix_tree_tag_set+0x6b/0xce
> > [ 3344.972984]  [<ffffffff8118c087>] submit_bio+0xc6/0xcf
> > [ 3344.972984]  [<ffffffff8107feb8>] ? unlock_page+0x22/0x26
> > [ 3344.972984]  [<ffffffff8109ebd4>] swap_writepage+0xa2/0xac
> > [ 3344.972984]  [<ffffffff8108a076>] shrink_page_list+0x3a7/0x67b
> > [ 3344.972984]  [<ffffffff810376f1>] ? finish_task_switch+0x68/0x88
> > [ 3344.972984]  [<ffffffff8101b822>] ? __cpus_empty+0x9/0xb
> > [ 3344.972984]  [<ffffffff8101ba27>] ? flush_tlb_page+0x66/0x83
> > [ 3344.972984]  [<ffffffff814908b3>] ? thread_return+0x3d/0xc6
> > [ 3344.972984]  [<ffffffff8108a98d>] shrink_list+0x29d/0x59f
> > [ 3344.972984]  [<ffffffff81086c4f>] ? get_dirty_limits+0x22/0x24a
> > [ 3344.972984]  [<ffffffff8108af10>] shrink_zone+0x281/0x32b
> > [ 3344.972984]  [<ffffffff8119ff8e>] ? __up_read+0x92/0x9c
> > [ 3344.972984]  [<ffffffff8108b100>] ? shrink_slab+0x146/0x158
> > [ 3344.972984]  [<ffffffff8108c022>] try_to_free_pages+0x23d/0x38f
> > [ 3344.972984]  [<ffffffff81089185>] ? isolate_pages_global+0x0/0x219
> > [ 3344.972984]  [<ffffffff81085cc9>] __alloc_pages_internal+0x292/0x43d
> > [ 3344.972984]  [<ffffffff810a6963>] alloc_pages_current+0xb9/0xc2
> > [ 3344.972984]  [<ffffffff810aa658>] alloc_slab_page+0x19/0x69
> > [ 3344.972984]  [<ffffffff810aa6f1>] new_slab+0x49/0x1cc
> > [ 3344.972984]  [<ffffffff8119f8b1>] ? rb_insert_color+0xbd/0xe6
> > [ 3344.972984]  [<ffffffff810aaad3>] __slab_alloc+0x1f3/0x36c
> > [ 3344.972984]  [<ffffffff81389fe8>] ? __alloc_skb+0x42/0x130
> > [ 3344.972984]  [<ffffffff81389fe8>] ? __alloc_skb+0x42/0x130
> > [ 3344.972984]  [<ffffffff810aaf7c>] kmem_cache_alloc_node+0x69/0xa2
> > [ 3344.972984]  [<ffffffff81389fe8>] __alloc_skb+0x42/0x130
> > [ 3344.972984]  [<ffffffff81385bd3>] sock_alloc_send_skb+0xa1/0x200
> > [ 3344.972984]  [<ffffffff8116700a>] ? security_socket_getpeersec_dgram+0x11/0x3
> > [ 3344.972984]  [<ffffffff81409250>] unix_stream_sendmsg+0x138/0x2b5
> > [ 3344.972984]  [<ffffffff8138276b>] __sock_sendmsg+0x59/0x62
> > [ 3344.972984]  [<ffffffff8138285c>] sock_aio_write+0xe8/0xf8
> > [ 3344.972984]  [<ffffffff810af9a2>] do_sync_write+0xe7/0x12d
> > [ 3344.972984]  [<ffffffff8104d980>] ? autoremove_wake_function+0x0/0x38
> > [ 3344.972984]  [<ffffffff8116d9da>] ? selinux_file_permission+0xbd/0xc6
> > [ 3344.972984]  [<ffffffff811669d0>] ? security_file_permission+0x11/0x13
> > [ 3344.972984]  [<ffffffff810b029a>] vfs_write+0xbe/0x105
> > [ 3344.972984]  [<ffffffff810b03a5>] sys_write+0x47/0x6f
> > [ 3344.972984]  [<ffffffff8102bba8>] sysenter_dispatch+0x7/0x27
> > [ 3344.972984] Code: 01 00 00 f0 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c9 c
> > [ 3344.972984] BUG: NMI Watchdog detected LOCKUP<4>---[ end trace 820f38a7b2441-
> > [ 3344.972984]  on CPU0, ip ffffffff81491f6c, registers:
> 
> And then the block layer died.  Looks like it was trying to take the
> queue lock.  Probably against the recently-offlined device.
> 
> I'd say that either someone forgot to release the lock on an error
> path.  Or the structure was freed, but the kernel still tries to use it.

Should run with CONFIG_PROVE_LOCKING=y for more precise forensics about
precisely who did that and when.

Or if this was with lockdep enabled already, some other modes of failure
should be considered too. (such as memory corruption)

	Ingo
