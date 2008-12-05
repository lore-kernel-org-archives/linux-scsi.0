From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: kernel BUG at block/blk-timeout.c:178!
Date: Fri, 5 Dec 2008 14:35:27 +0100
Message-ID: <20081205133527.GK18255@kernel.dk>
References: <4937E888.3060208@hp.com> <20081204155005.GX18255@kernel.dk> <493801AF.8050308@hp.com> <49382201.8030609@hp.com> <4938466C.8050704@hp.com> <20081205094004.GA18255@kernel.dk> <49392D71.10505@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:10579 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYLENfe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 08:35:34 -0500
Content-Disposition: inline
In-Reply-To: <49392D71.10505@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

On Fri, Dec 05 2008, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> >>
> >> I've pushed the BUG ON check into blk_execute_rq, and it's finding it
> >> set there. Could we be getting SCSI_DH_IMM_RETRYs and that's causing the
> >> same request to be used without being re-initialized, and on error the
> >> bit is not being cleaned up properly?
> >>
> >> I'm checking that out next...
> > 
> > That does indeed look problematic, we only init the timer stuff when
> > getting the request initially. So you could either make your retry loop
> > do blk_put_request() and jump to the very beginning again, or this
> > should fix the current usage.
> > 
> > diff --git a/block/elevator.c b/block/elevator.c
> > index a6951f7..0a2f378 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -590,6 +590,12 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
> >  
> >  	rq->q = q;
> >  
> > +	/*
> > +	 * This could happen on a request requeue, init the timer here as well
> > +	 */
> > +	blk_delete_timer(rq);
> > +	blk_clear_rq_complete(rq);
> > +
> >  	switch (where) {
> >  	case ELEVATOR_INSERT_FRONT:
> >  		rq->cmd_flags |= REQ_SOFTBARRIER;
> > 
> 
> Hi Jens -
> 
> I was able to determine we were getting retries on TURs, and then right
> (soon?) thereafter was when we triggered the problem. I put some
> slightly different code than what you suggest above, and that triggered
> a problem elsewhere in SCSI. I backed out what I did, inserted your code
> (after updating my tree to:)
> 
> commit bbeba4c35c252b2e961f09ce6ebe76b2cd5e7e3e
> Merge: 6df944c... 2cbed89...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Dec 4 21:45:44 2008 -0800
> 
>     Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/vi
> 
>     * 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/bdev:
>       [PATCH] fix bogus argument of blkdev_put() in pktcdvd
>       [PATCH 2/2] documnt FMODE_ constants
>       [PATCH 1/2] kill FMODE_NDELAY_NOW
>       [PATCH] clean up blkdev_get a little bit
>       [PATCH] Fix block dev compat ioctl handling
>       [PATCH] kill obsolete temporary comment in swsusp_close()
> 
> and I get the following SCSI-related problem (the same error I got with
> code I tried last night - basically just clearing out the atomic value).
> This has now happened repeatedly 3 times. [I've cc'd linux-scsi as well,
> just to make sure to cover all the bases...]
> 
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/scsi.c:347!
> invalid opcode: 0000 [#1] SMP
> last sysfs file:
> CPU 0
> Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #7
> RIP: 0010:[<ffffffff80d3df3e>]  [<ffffffff80d3df3e>]
> scsi_put_command+0x27/0x65
> RSP: 0018:ffffffff827b3d80  EFLAGS: 00010046
> RAX: 0000000000000282 RBX: ffff88087b68dec0 RCX: ffff88087b68dec8
> RDX: ffff88087b68dec8 RSI: 0000000000000282 RDI: ffff88087b35d834
> RBP: ffffffff827b3d90 R08: ffffffff827b3d30 R09: 00000000827b3d60
> R10: 0000000000000246 R11: ffff88087b16042c R12: ffff88087b35d800
> R13: ffff88087b35d920 R14: 0000000000000000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffffffff82535500(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff82548000, task ffffffff82049380)
> Stack:
>  ffff88087b68dec0 ffff88087b36b230 ffffffff827b3dc0 ffffffff80d43793
>  0000000000000000 ffff88087b68dec0 ffff88087b35b658 0000000000000000
>  ffffffff827b3e00 ffffffff80d43980 ffff88087b36b230 ffff88087b35b658
> Call Trace:
>  <IRQ> <0> [<ffffffff80d43793>] scsi_next_command+0x2e/0x46
>  [<ffffffff80d43980>] scsi_end_request+0x92/0xa4
>  [<ffffffff80d43fe3>] scsi_io_completion+0x1a7/0x3ad
>  [<ffffffff80d3d926>] scsi_finish_command+0xe9/0xf2
>  [<ffffffff80d444d5>] scsi_softirq_done+0x10c/0x115
>  [<ffffffff8062afeb>] blk_done_softirq+0x77/0x87
>  [<ffffffff802628a0>] ? ktime_get_ts+0x49/0x4e
>  [<ffffffff802514b8>] __do_softirq+0x8a/0x151
>  [<ffffffff8256b140>] ? early_idt_handler+0x0/0x72
>  [<ffffffff8020dbec>] call_softirq+0x1c/0x28
>  [<ffffffff8020f32c>] do_softirq+0x44/0x8b
>  [<ffffffff802511bf>] irq_exit+0x3f/0x82
>  [<ffffffff8020f5f0>] do_IRQ+0xc3/0xe3
>  [<ffffffff8020c983>] ret_from_intr+0x0/0x29
>  <EOI> <0> [<ffffffff80228446>] ? native_safe_halt+0x6/0x8
>  [<ffffffff8021406e>] ? default_idle+0x3c/0x59
>  [<ffffffff802141b0>] ? c1e_idle+0x117/0x11e
>  [<ffffffff8026332d>] ? atomic_notifier_call_chain+0x13/0x15
>  [<ffffffff8020b4ea>] ? cpu_idle+0x51/0x92
>  [<ffffffff815be32d>] ? rest_init+0x61/0x63
>  [<ffffffff8256bd6b>] ? start_kernel+0x39c/0x3a7
>  [<ffffffff8256b29f>] ? x86_64_start_reservations+0xa5/0xa9
>  [<ffffffff8256b3f0>] ? x86_64_start_kernel+0x12a/0x139
> Code: 41 5e c9 c3 55 48 89 e5 41 54 53 4c 8b 27 48 89 fb 49 8d 7c 24 34
> e8 69 56 98 00 48 8b 53 08 48 8d 4b 08 48 89 c6 48 39 ca 75 04 <0f> 0b
> eb fe 48 8b 43 10 48 89 42 08 48 89 10 48 8b 3b 48 89 4b
> RIP  [<ffffffff80d3df3e>] scsi_put_command+0x27/0x65
>  RSP <ffffffff827b3d80>
> 

I haven't audited everything for that path yet, but I don't think others
do retries like you suggest here. I'd strongly encourage you to change
the retry logic to really put and get a new request, instead of relying
on all state being clean for a reissue.

-- 
Jens Axboe

