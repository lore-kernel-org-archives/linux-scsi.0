From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Wed, 28 Dec 2011 09:50:25 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
References: <20111222150836.af172886.akpm@linux-foundation.org> <20111222232036.GP17084@google.com> <20111222152427.c944c747.akpm@linux-foundation.org> <20111222233843.GR17084@google.com> <20111222154427.89b245c7.akpm@linux-foundation.org>
 <20111222234639.GS17084@google.com> <20111223004244.GU17084@google.com> <alpine.LSU.2.00.1112232058550.3225@eggly.anvils> <20111225010238.GA6013@htj.dyndns.org> <alpine.LSU.2.00.1112280010550.1398@eggly.anvils> <20111228164836.GP17712@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111228164836.GP17712@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Dec 2011, Tejun Heo wrote:
> On Wed, Dec 28, 2011 at 12:33:01AM -0800, Hugh Dickins wrote:
> 
> > However, there are a couple of other unhealthy symptoms I've noticed
> > under load in -next's block/cfq layer, both with and without your patch.
> > 
> > One is kernel BUG at block/cfq-iosched.c:2585!
> > 	BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
> > 
> > cfq_dispatch_request+0x1a
> > cfq_dispatch_requests+0x5c
> > blk_peek_request+0x195
> > scsi_request_fn+0x6a
> > __blk_run_queue+0x16
> > scsi_run_queue+0x18a
> > scsi_next_command+0x36
> > scsi_io_completion+0x426
> > scsi_finish_command+0xaf
> > scsi_softirq_done+0xdd
> > blk_done_softirq+0x6c
> > __do_softirq+0x80
> > call_softirq+0x1c
> > do_softirq+0x33
> > irq_exit+0x3f
> > do_IRQ+0x97
> > ret_from_intr
> > 
> > I've had that one four times now on different machines; but quicker
> > to reproduce are these warnings from CONFIG_DEBUG_LIST=y:
> > 
> > ------------[ cut here ]------------
> > WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> > Hardware name: 4174AY9
> > list_del corruption. prev->next should be ffff880005aa1380, but was 6b6b6b6b6b6b6b6b
> > Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
> > Pid: 29241, comm: cc1 Tainted: G        W    3.2.0-rc6-next-20111222 #18
> > Call Trace:
> >  <IRQ>  [<ffffffff810544b4>] warn_slowpath_common+0x80/0x98
> >  [<ffffffff81054560>] warn_slowpath_fmt+0x41/0x43
> >  [<ffffffff811fc1a1>] __list_del_entry+0x8d/0x98
> >  [<ffffffff811df8ab>] cfq_remove_request+0x3b/0xdf
> >  [<ffffffff811df989>] cfq_dispatch_insert+0x3a/0x87
> >  [<ffffffff811dfb3b>] cfq_dispatch_request+0x65/0x92
> >  [<ffffffff811dfbc4>] cfq_dispatch_requests+0x5c/0x133
> >  [<ffffffff812e103e>] ? scsi_request_fn+0x3b6/0x3d3
> >  [<ffffffff811d3069>] blk_peek_request+0x195/0x1a6
> >  [<ffffffff812e103e>] ? scsi_request_fn+0x3b6/0x3d3
> >  [<ffffffff812e0cf5>] scsi_request_fn+0x6d/0x3d3
> >  [<ffffffff811d0730>] __blk_run_queue+0x19/0x1b
> >  [<ffffffff811d0bfd>] blk_run_queue+0x21/0x35
> >  [<ffffffff812e08c4>] scsi_run_queue+0x11f/0x1b9
> >  [<ffffffff812e205c>] scsi_next_command+0x36/0x46
> >  [<ffffffff812e24dc>] scsi_io_completion+0x426/0x4a9
> >  [<ffffffff812dc0b2>] scsi_finish_command+0xaf/0xb8
> >  [<ffffffff812e200c>] scsi_softirq_done+0xdd/0xe5
> >  [<ffffffff811d79c6>] blk_done_softirq+0x76/0x8a
> >  [<ffffffff8105a28d>] __do_softirq+0x98/0x136
> >  [<ffffffff814e649c>] call_softirq+0x1c/0x30
> >  [<ffffffff8102f187>] do_softirq+0x38/0x81
> >  [<ffffffff8105a596>] irq_exit+0x4e/0xb6
> >  [<ffffffff8102ee9e>] do_IRQ+0x97/0xae
> >  [<ffffffff814e49f0>] common_interrupt+0x70/0x70
> >  <EOI>  [<ffffffff814e4a8e>] ? retint_swapgs+0xe/0x13
> > ---[ end trace 61fdaa1b260613d1 ]---
> 
> Hmm... that looks like cfqq being freed before unlinked.  I'll try to
> reproduce it.  Is there any particular workload you were running?

"It's the tmpfs swapping test that I've been running, with variations,
for years.  System booted with mem=700M and 1.5G swap, two repetitious
make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that because
the balance of built to unbuilt source grows smaller with later kernels),
one directly in a tmpfs, the other in a 1k-block ext2 (that I drive with
ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file."

I doubt much of that (quoted from an older mail to someone else about
one of the many other bugs it's found) is relevant: maybe just plenty
of file I/O and swapping.

Hugh
