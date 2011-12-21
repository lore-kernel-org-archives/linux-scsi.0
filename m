From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Dec 21
Date: Wed, 21 Dec 2011 15:15:03 -0800
Message-ID: <20111221151503.4d78f94f.akpm@linux-foundation.org>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Dec 2011 17:47:33 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).

This kernel is seriously busted.  Sometime between the Dec 15 tree and
the Dec 31 tree someone added something which appears to be causing
writes to the (ata_piix controlled) disk to get lost.  Processes are
getting stuck in D state, usually before it reaches a login prompt.

Suspects would be block, ata, scsi and possibly x86/acpi interrupt
handling.

And no, I'd rather not bisect - it would take ages.  If the maintainers
of the relevant trees can suggest specific patches to revert then I can
take a look at that tomorrow.


[  558.576528] SysRq : Show Blocked State
[  558.576633]   task                        PC stack   pid father
[  558.576738] sh              D 0000000000000001     0  4701   4700 0x00000080
[  558.576882]  ffff8802493f78b8 0000000000000046 000000014a1121c0 ffff8802493f6010
[  558.577109]  ffff88024a1121c0 00000000001d1100 ffff8802493f7fd8 0000000000004000
[  558.577336]  ffff8802493f7fd8 00000000001d1100 ffff880255db66c0 ffff88024a1121c0
[  558.577568] Call Trace:
[  558.577623]  [<ffffffff81051592>] ? sched_clock_cpu+0xc3/0xd1
[  558.577679]  [<ffffffff81051469>] ? sched_clock_local+0x1c/0x82
[  558.577736]  [<ffffffff81051592>] ? sched_clock_cpu+0xc3/0xd1
[  558.577793]  [<ffffffff810631ae>] ? trace_hardirqs_off+0xd/0xf
[  558.577848]  [<ffffffff810515cb>] ? local_clock+0x2b/0x3c
[  558.577905]  [<ffffffff813d2744>] schedule+0x55/0x57
[  558.577960]  [<ffffffff813d27cd>] io_schedule+0x87/0xca
[  558.578017]  [<ffffffff811a1e72>] get_request_wait+0xbd/0x19e
[  558.578073]  [<ffffffff810446a7>] ? wake_up_bit+0x25/0x25
[  558.578127]  [<ffffffff8119e225>] ? elv_merge+0x9a/0xaa
[  558.578182]  [<ffffffff811a20cc>] blk_queue_bio+0x179/0x271
[  558.578238]  [<ffffffff811a02a9>] generic_make_request+0x9c/0xde
[  558.578293]  [<ffffffff811a03a4>] submit_bio+0xb9/0xc4
[  558.578348]  [<ffffffff810ffcc6>] submit_bh+0xe6/0x108
[  558.578404]  [<ffffffff8110273c>] __block_write_full_page+0x1ec/0x2e3
[  558.578462]  [<ffffffff81101fbe>] ? end_buffer_async_read+0x14b/0x14b
[  558.578518]  [<ffffffff811028fb>] block_write_full_page_endio+0xc8/0xcc
[  558.578573]  [<ffffffff8110290f>] block_write_full_page+0x10/0x12
[  558.578631]  [<ffffffff811417cd>] ext3_writeback_writepage+0xaa/0x11d
[  558.578690]  [<ffffffff810a0ed0>] __writepage+0x15/0x34
[  558.578744]  [<ffffffff810a1913>] write_cache_pages+0x240/0x33e
[  558.578799]  [<ffffffff810a0ebb>] ? set_page_dirty+0x65/0x65
[  558.578855]  [<ffffffff81064abf>] ? trace_hardirqs_on+0xd/0xf
[  558.578911]  [<ffffffff810a1a54>] generic_writepages+0x43/0x5a
[  558.578967]  [<ffffffff810a1a91>] do_writepages+0x26/0x28
[  558.579022]  [<ffffffff8109a8cf>] __filemap_fdatawrite_range+0x4e/0x50
[  558.579078]  [<ffffffff8109aee8>] filemap_flush+0x17/0x19
[  558.579134]  [<ffffffff8113f2c2>] ext3_release_file+0x2e/0xa4
[  558.579190]  [<ffffffff810dbdce>] fput+0x10f/0x1cd
[  558.579244]  [<ffffffff810d86e0>] filp_close+0x70/0x7b
[  558.579300]  [<ffffffff8102c09b>] put_files_struct+0x16c/0x2c1
[  558.579356]  [<ffffffff8102bf7b>] ? put_files_struct+0x4c/0x2c1
[  558.579412]  [<ffffffff8102c236>] exit_files+0x46/0x4e
[  558.579465]  [<ffffffff8102dd2a>] do_exit+0x246/0x73c
[  558.579521]  [<ffffffff813d3c4a>] ? retint_swapgs+0xe/0x13
[  558.579576]  [<ffffffff8102e2a4>] do_group_exit+0x84/0xb2
[  558.579743]  [<ffffffff8102e2e4>] sys_exit_group+0x12/0x16
[  558.579910]  [<ffffffff813d9562>] system_call_fastpath+0x16/0x1b
