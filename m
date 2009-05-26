From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Tue, 26 May 2009 09:47:02 -0500
Message-ID: <1243349222.2815.22.camel@localhost.localdomain>
References: <20090526062952.GB11363@kernel.dk>
	 <20090526162545U.fujita.tomonori@lab.ntt.co.jp>
	 <20090526073229.GC11363@kernel.dk>
	 <20090526163823U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090526163823U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, rdreier@cisco.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-05-26 at 16:38 +0900, FUJITA Tomonori wrote:
> On Tue, 26 May 2009 09:32:29 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, May 26 2009, FUJITA Tomonori wrote:
> > > On Tue, 26 May 2009 08:29:53 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > On Tue, May 26 2009, FUJITA Tomonori wrote:
> > > > > On Mon, 25 May 2009 18:45:25 -0700
> > > > > Roland Dreier <rdreier@cisco.com> wrote:
> > > > > 
> > > > > >  > Ideally there should be a MACRO that is defined to WORD_SIZE on cache-coherent
> > > > > >  > ARCHs and to SMP_CACHE_BYTES on none-cache-coherent systems and use that size
> > > > > >  > at the __align() attribute. (So only stupid ARCHES get hurt)
> > > > > > 
> > > > > > this seems to come up repeatedly -- I had a proposal a _long_ time ago
> > > > > > that never quite got merged, cf http://lwn.net/Articles/2265/ and
> > > > > > http://lwn.net/Articles/2269/ -- from 2002 (!?).  The idea is to go a
> > > > > 
> > > > > Yeah, I think that Benjamin did last time:
> > > > > 
> > > > > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12632.html
> > > > > 
> > > > > IIRC, James didn't like it so I wrote the current code. I didn't see
> > > > > any big performance difference with scsi_debug:
> > > > > 
> > > > > http://marc.info/?l=linux-scsi&m=120038907123706&w=2
> > > > > 
> > > > > Jens, you see the performance difference due to this unification?
> > > > 
> > > > Yes, it's definitely a worth while optimization. The problem isn't as
> > > > such this specific allocation, it's the total number of allocations we
> > > > do for a piece of IO. This sense buffer one is just one of many, I'm
> > > > continually working to reduce them. If we get rid of this one and add
> > > > the ->alloc_cmd() stuff, we can kill one more. The bio path already lost
> > > > one. So in the IO stack, we went from 6 allocations to 3 for a piece of
> > > > IO. And then it starts to add up. Even at just 30-50k iops, that's more
> > > > than 1% of time in the testing I did.
> > > 
> > > I see, thanks. Hmm, possibly slab becomes slower. ;)
> > > 
> > > Then I think that we need something like the ->alloc_cmd()
> > > method. Let's ask James. 
> > > 
> > > I don't think that it's just about simply adding the hook; there are
> > > some issues that we need to think about. Though Boaz worries too much
> > > a bit, I think.
> > > 
> > > I'm not sure about this patch if we add ->alloc_cmd(). I doubt that
> > > there are any llds don't use ->alloc_cmd() worry about the overhead of
> > > the separated sense buffer allocation. If a lld doesn't define the own
> > > alloc_cmd, then I think it's fine to use the generic command
> > > allocator that does the separate sense buffer allocation.
> > 
> > I think we should do the two things seperately. If we can safely inline
> > the sense buffer in the command by doing the right alignment, then lets
> > do that. The ->alloc_cmd() approach will be easier to do with an inline
> > sense buffer.
> 
> James rejected this in the past. Let's wait for his verdict.

OK, so the reason for the original problems where the sense buffer was
inlined with the scsi_command was that we need to DMA to the sense
buffer but not to the command.  Plus the command is in fairly constant
use so we get cacheline interference unless they're always in separate
caches.  This necessitates opening up a hole in the command to achieve
this (you can separate to the next cache line if you can guarantee that
the command always begins on a cacheline.  If not, it has to be
2*cacheline).  The L1 cacheline can be up to 128 bytes on some
architectures, so we'd need to know the waste of space is worth it in
terms of speed.  The other problem is that the entire command now has to
be allocated in DMAable memory, which restricts the allocation on some
systems.

> Yeah, we can inline the sense buffer but as we discussed in the past
> several times, there are some good reasons that we should not do so, I
> think.

There are several other approaches:

     1. Keep the sense buffer packed in the command but disallow DMA to
        it, which fixes all the alignment problems.  Then we supply a
        set of rotating DMA buffers to drivers which need to do the DMA
        (which isn't the majority).
     2. Sense is a comparative rarity, so us a more compact pooling
        scheme and discard sense for reuse as soon as we know it's not
        used (as in at softirq time when there's no sense collected).

I'd need a little more clarity on the actual size of the problem before
making any choices.

The other thing to bear in mind is that two allocations of M and N might
be more costly than a single allocation of N+M; however, an allocation
of M+N+extra can end up more costly if the extra causes more page
reclaim before we get an actual command.

James



