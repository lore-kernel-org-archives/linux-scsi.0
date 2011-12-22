From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Dec 21
Date: Thu, 22 Dec 2011 15:24:27 -0800
Message-ID: <20111222152427.c944c747.akpm@linux-foundation.org>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
	<20111221151503.4d78f94f.akpm@linux-foundation.org>
	<20111222150836.af172886.akpm@linux-foundation.org>
	<20111222232036.GP17084@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111222232036.GP17084@google.com>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 22 Dec 2011 15:20:36 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Dec 22, 2011 at 03:08:36PM -0800, Andrew Morton wrote:
> > > [  558.576528] SysRq : Show Blocked State
> > > [  558.576633]   task                        PC stack   pid father
> > > [  558.576738] sh              D 0000000000000001     0  4701   4700 0x00000080
> > > [  558.576882]  ffff8802493f78b8 0000000000000046 000000014a1121c0 ffff8802493f6010
> > > [  558.577109]  ffff88024a1121c0 00000000001d1100 ffff8802493f7fd8 0000000000004000
> > > [  558.577336]  ffff8802493f7fd8 00000000001d1100 ffff880255db66c0 ffff88024a1121c0
> > > [  558.577568] Call Trace:
> > > [  558.577905]  [<ffffffff813d2744>] schedule+0x55/0x57
> > > [  558.577960]  [<ffffffff813d27cd>] io_schedule+0x87/0xca
> > > [  558.578017]  [<ffffffff811a1e72>] get_request_wait+0xbd/0x19e
> > > [  558.578182]  [<ffffffff811a20cc>] blk_queue_bio+0x179/0x271
> > > [  558.578238]  [<ffffffff811a02a9>] generic_make_request+0x9c/0xde
> > > [  558.578293]  [<ffffffff811a03a4>] submit_bio+0xb9/0xc4
> > > [  558.578348]  [<ffffffff810ffcc6>] submit_bh+0xe6/0x108
> > > [  558.578404]  [<ffffffff8110273c>] __block_write_full_page+0x1ec/0x2e3
> > > [  558.578518]  [<ffffffff811028fb>] block_write_full_page_endio+0xc8/0xcc
> > > [  558.578573]  [<ffffffff8110290f>] block_write_full_page+0x10/0x12
> > > [  558.578631]  [<ffffffff811417cd>] ext3_writeback_writepage+0xaa/0x11d
> > > [  558.578690]  [<ffffffff810a0ed0>] __writepage+0x15/0x34
> > > [  558.578744]  [<ffffffff810a1913>] write_cache_pages+0x240/0x33e
> > > [  558.578911]  [<ffffffff810a1a54>] generic_writepages+0x43/0x5a
> > > [  558.578967]  [<ffffffff810a1a91>] do_writepages+0x26/0x28
> > > [  558.579022]  [<ffffffff8109a8cf>] __filemap_fdatawrite_range+0x4e/0x50
> > > [  558.579078]  [<ffffffff8109aee8>] filemap_flush+0x17/0x19
> > > [  558.579134]  [<ffffffff8113f2c2>] ext3_release_file+0x2e/0xa4
> > > [  558.579190]  [<ffffffff810dbdce>] fput+0x10f/0x1cd
> > > [  558.579244]  [<ffffffff810d86e0>] filp_close+0x70/0x7b
> > > [  558.579300]  [<ffffffff8102c09b>] put_files_struct+0x16c/0x2c1
> > > [  558.579412]  [<ffffffff8102c236>] exit_files+0x46/0x4e
> > > [  558.579465]  [<ffffffff8102dd2a>] do_exit+0x246/0x73c
> > > [  558.579576]  [<ffffffff8102e2a4>] do_group_exit+0x84/0xb2
> > > [  558.579743]  [<ffffffff8102e2e4>] sys_exit_group+0x12/0x16
> > > [  558.579910]  [<ffffffff813d9562>] system_call_fastpath+0x16/0x1b
> 
> Hmmm... probably cic allocation failure?

Dunno, it's an 8Gb 8 CPU x86_64 box.

> > A large amount of block core code was merged in the Dec 15 - Dec 21
> > window.  Tejun...
> 
> Yeah, those are blk-ioc cleanup patches.  I was wishing to merge them
> earlier.
> 
> > revert-f2dbd76a0a994bc1d5a3d0e7c844cc373832e86c.patch		BAD
> > revert-1238033c79e92e5c315af12e45396f1a78c73dec.patch
> > revert-b50b636bce6293fa858cc7ff6c3ffe4920d90006.patch
> > revert-b9a1920837bc53430d339380e393a6e4c372939f.patch
> > revert-b2efa05265d62bc29f3a64400fad4b44340eedb8.patch
> > revert-f1a4f4d35ff30a328d5ea28f6cc826b2083111d2.patch
> > revert-216284c352a0061f5b20acff2c4e50fb43fea183.patch
> > revert-dc86900e0a8f665122de6faadd27fb4c6d2b3e4d.patch
> > revert-283287a52e3c3f7f8f9da747f4b8c5202740d776.patch
> > revert-09ac46c429464c919d04bb737b27edd84d944f02.patch		BAD
> > revert-6e736be7f282fff705db7c34a15313281b372a76.patch		GOOD
> > revert-42ec57a8f68311bbbf4ff96a5d33c8a2e90b9d05.patch		GOOD
> > revert-a73f730d013ff2788389fd0c46ad3e5510f124e6.patch
> > revert-8ba61435d73f2274e12d4d823fde06735e8f6a54.patch		GOOD
> > revert-481a7d64790cd7ca61a8bbcbd9d017ce58e6fe39.patch
> > revert-34f6055c80285e4efb3f602a9119db75239744dc.patch
> > revert-1ba64edef6051d2ec79bb2fbd3a0c8f0df00ab55.patch		GOOD
> > 
> > At the f2dbd76a0a994bc1d5a3d0e7c844cc373832e86 pivot point the kernel
> > went odd, got stuck, slowly emitting "cfq: cic link failed!" messages. 
> > So we've added yet another bisection hole in there somewhere.
> 
> You were likely seeing the same problem, just showing up differently.
> Hmm.... we always had the problem of allocation failure in cfq could
> lead to deadlock.

This looks like a lost I/O completion.

>  It's just that those cases happened infrequently
> enough that nobody really noticed (or at least tracked it down).  How
> can you reproduce the problem?

Easily.  One time it got to a login prompt and hung quickly during a
make.  Every other time (ten times, maybe) it hung during initscripts.
