From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Thu, 5 Mar 2009 20:32:02 +0100
Message-ID: <20090305193202.GA647@elte.hu>
References: <20090305182958Q.fujita.tomonori@lab.ntt.co.jp> <20090305100901.GU11787@kernel.dk> <20090305101436.GV11787@kernel.dk> <20090305192737I.fujita.tomonori@lab.ntt.co.jp> <20090305103023.GW11787@kernel.dk> <20090305104159.GE32407@elte.hu> <20090305110534.GX11787@kernel.dk> <20090305110736.GJ32407@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090305110736.GJ32407@elte.hu>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tglx@linutronix.de, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Mar 05 2009, Ingo Molnar wrote:
> > > 
> > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > > Totally untested, comments welcome...
> > > > > 
> > > > > Yeah, I think that updating bi_seg_front_size and 
> > > > > bi_seg_back_size at one place, __blk_recalc_rq_segments, is 
> > > > > better. I thought about the same way. But we are already in 
> > > > > -rc7 and this must go into mainline now. So I chose a 
> > > > > less-intrusive way (similar to what we have done in the 
> > > > > past).
> > > > > 
> > > > > As you know, the merging code is really complicated and we 
> > > > > could overlook stuff easily. ;) It might be better to 
> > > > > simplify the merging code a bit.
> > > > 
> > > > If someone (Ingo?) is willing to test the last variant, I'd 
> > > > much rather add that. It does simplify it (imho), and it kills 
> > > > 23 lines while only adding 9. But a quick response would be 
> > > > nice, then I can ask Linus to pull it later today.
> > > 
> > > sure, can give it a whirl.
> > > 
> > > Note that your patch in this thread does no apply cleanly. Could 
> > > you please send a pull request of your latest fixes that i could 
> > > pull into tip:out-of-tree for testing purposes?
> > 
> > Hmm that's odd, I have no changes in blk-merge.c in my tree 
> > against Linus'. But you can pull:
> > 
> >   git://git.kernel.dk/linux-2.6-block.git for-linus
> > 
> > Jens Axboe (2):
> >       cciss: remove 30 second initial timeout on controller reset
> >       block: fix missing bio back/front segment size setting in blk_recount_segments()
> > 
> > Kris Shannon (1):
> >       Fix kernel NULL pointer dereference in xen-blkfront
> > 
> > Roel Kluin (1):
> >       loop: don't increment p->offset with (size_t) -EINVAL
> > 
> >  block/blk-merge.c            |   25 +++++++++----------------
> >  drivers/block/cciss.c        |    8 +++-----
> >  drivers/block/loop.c         |    3 +--
> >  drivers/block/xen-blkfront.c |    2 ++
> >  4 files changed, 15 insertions(+), 23 deletions(-)
> 
> It pulled without conflicts so we are good. Started testing 
> it. Once Thomas is around i suspect he'll be able to test it 
> too with his reproducer.

FYI, here the patches didnt cause any problems.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
