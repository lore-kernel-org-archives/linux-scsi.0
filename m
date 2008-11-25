From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: next-20081119: general protection fault: get_next_timer_interrupt()
Date: Tue, 25 Nov 2008 18:43:08 +0100
Message-ID: <20081125174308.GA26308@kernel.dk>
References: <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain> <20081124213517.GA25898@linux.vnet.ibm.com> <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain> <20081125000902.GA24251@us.ibm.com> <20081125115710.6c249f32.sfr@canb.auug.org.au> <20081125020852.GA27280@us.ibm.com> <20081125085109.GR26308@kernel.dk> <20081125165955.GB529@us.ibm.com> <a4423d670811250914x3a42e56egd1bf06e6229666ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4423d670811250914x3a42e56egd1bf06e6229666ba@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Gleixner <tglx@linutronix.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 25 2008, Alexander Beregalov wrote:
> 2008/11/25  <malahal@us.ibm.com>:
> > Jens Axboe [jens.axboe@oracle.com] wrote:
> >> On Mon, Nov 24 2008, malahal@us.ibm.com wrote:
> >> > Stephen Rothwell [sfr@canb.auug.org.au] wrote:
> >> > > > The block timer code calls del_timer(), should it call del_timer_sync()?
> >> > > > It is possible although unlikely that you are hitting del_timer_sync vs
> >> > > > del_timer problem in the block timeout code. Can only be seen on SMP
> >> > > > systems though!
> >> > >
> >> > > Is this still a problem in next-20081121? In that tree, the block commit
> >> > > "block: leave the request timeout timer running even on an empty list"
> >> > > was changed to add this:
> >> > >
> >> > > diff --git a/block/blk-core.c b/block/blk-core.c
> >> > > index 04267d6..44f547c 100644
> >> > > --- a/block/blk-core.c
> >> > > +++ b/block/blk-core.c
> >> > > @@ -391,6 +391,7 @@ EXPORT_SYMBOL(blk_stop_queue);
> >> > >  void blk_sync_queue(struct request_queue *q)
> >> > >  {
> >> > >   del_timer_sync(&q->unplug_timer);
> >> > > + del_timer_sync(&q->timeout);
> >> > >   kblockd_flush_work(&q->unplug_work);
> >> > >  }
> >> > >  EXPORT_SYMBOL(blk_sync_queue);
> >> >
> >> > I was looking at the Linux tree. Clearly same problem doesn't exist with
> >> > the above commit! I wonder why kblockd_flush_work() is called after the
> >> > del_timer_sync(). It makes sense to cancel the work and then shutdown
> >> > the timer(s). I doubt if you are running into this problem though.
> >>
> >> If the kernel tested doesn't include the above fix, it'll surely go
> >> boom. Can someone verify that this is the case?
> >
> > Just looked, next-20081119 doesn't have the above fix. It is included in
> > next-20081120. Also note that the above fix is only partially copied,
> > there is other part that removed deleting the timer when there are no
> > outstanding requests.
> >
> Yes, I can not reproduce it anymore on linux-next 1121 and newer. (I
> did not try 1120) It seems the fix works pretty good.  Is it still
> needed and reasonable  to investigate the problem on next-20081119?
> Unfortunately I do not have much time for it.

No, you don't have to investigate further. This was a known bug that is
fixed in -next and mainline basically right after next-20081119.

> 
> All these problems have gone away on next-1125 except ODEBUG warning
> on HPET.

-- 
Jens Axboe
