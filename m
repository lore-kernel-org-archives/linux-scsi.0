From: Dave Chinner <david@fromorbit.com>
Subject: Re: thin provisioned LUN support
Date: Mon, 10 Nov 2008 11:33:29 +1100
Message-ID: <20081110003329.GU4985@disturbed>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <1226071230.8030.9.camel@localhost.localdomain> <20081109230823.GS4985@disturbed> <1226273859.19841.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:57807 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570AbYKJAdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 19:33:46 -0500
Content-Disposition: inline
In-Reply-To: <1226273859.19841.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

On Sun, Nov 09, 2008 at 05:37:39PM -0600, James Bottomley wrote:
> On Mon, 2008-11-10 at 10:08 +1100, Dave Chinner wrote:
> > On Fri, Nov 07, 2008 at 09:20:30AM -0600, James Bottomley wrote:
> > > On Fri, 2008-11-07 at 07:14 -0500, Ric Wheeler wrote:
> > > > Jens Axboe wrote:
> > > > I think that discard merging would be helpful (especially for devices 
> > > > with more reasonable sized unmap chunks).
> > > 
> > > One of the ways the unmap command is set up is with a disjoint
> > > scatterlist, so we can send a large number of unmaps together.  Whether
> > > they're merged or not really doesn't matter.
> > > 
> > > The probable way a discard system would work if we wanted to endure the
> > > complexity would be to have the discard system in the underlying device
> > > driver (or possibly just above it in block, but different devices like
> > > SCSI or ATA have different discard characteristics).  It would just
> > > accumulate block discard requests as ranges (and it would have to poke
> > > holes in the ranges as it sees read/write requests) which it flushes
> > > periodically.
> > 
> > It appears to me that discard requests are only being considered
> > here at a block and device level, and nobody is thinking about
> > the system level effects of such aggregation of discard requests.
> > 
> > What happens on a system crash? We lose all the pending discard
> > requests, never to be sent again?
> 
> Yes ... since this is for thin provisioning.  Discard is best guess ...
> it doesn't affect integrity if we lose one and from the point of view of
> the array, 99% transmitted is far better than we do today.  All that
> happens for a lost discard is that the array keeps a block that the
> filesystem isn't currently using.  However, the chances are that it will
> get reused, so it shares a good probability of getting discarded again.

Ok. Given that a single extent free in XFS could span up to 2^37 bytes,
is it considered acceptible to lose the  discard request that this
issued from this transaction? I don't think it is....

> >  If so, how do we tell the device
> > that certain ranges have actually been discarded after the crash?
> > Are you expecting them to get replayed by a filesystem during
> > recovery? What if it was a userspace discard from something like
> > mkfs that was lost? How does this interact with sync or other
> > such user level filesystems synchronisation primitives? Does
> > sync_blockdev() flush out pending discard requests? Should fsync?
> 
> No .. the syncs are all integrity based.  Discard is simple opportunity
> based.

Given that discard requests modify the stable storage associated
with the filesystem, then shouldn't an integrity synchronisation
issue and complete all pending requests to the underlying storage
device?

If not, how do we guarantee them to all be flushed on remount-ro
or unmount-before-hot-unplug type of events?

> > And if the filesystem has to wait for discard requests to complete
> > to guarantee that they are done or can be recovered and replayed
> > after a crash, most filesystems are going to need modification. e.g.
> > XFS would need to prevent the tail of the log moving forward until
> > the discard request associated with a given extent free transaction
> > has been completed. That means we need to be able to specifically
> > flush queued discard requests and we'd need I/O completions to
> > run when they are done to do the filesytem level cleanup work....
> 
> OK, I really don't follow the logic here.  Discards have no effect on
> data integrity ... unless you're confusing them with secure deletion?

Not at all. I'm considering what is needed to allow the filesystem's
discard requests to be replayed during recovery. i.e. what is needed
to allow a filesystem to handle discard requests for thin
provisioning robustly.

If discard requests are not guaranteed to be issued to the storage
on a crash, then it is up to the filesystem to ensure that it
happens during recovery. That requires discard requests to behave
just like all other types of I/O and definitely requires a mechanism
to flush and wait for all discard requests to complete....

> A
> discard merely tells the array that it doesn't need to back this block
> with an actual storage location anymore (until the next write for that
> region comes down).

Right. But really, it's the filesystem that is saying this, not  the
block layer, so if the filesytem wants to be robust, then block
layer can't queue these forever - they have to be issued in a timely
fashion so the filesystem can keep track of which discards have
completed or not....

> The ordering worry can be coped with in the same way we do barriers ...
> it's even safer for discards because if we know the block is going to be
> rewritten, we simply discard the discard.

Ordering is determined by the filesystem - barriers are just a
mechanism the filesystem uses to guarantee I/O ordering. If the
filesystem is tracking discard completion status, then it won't
be issuing I/O over the top of that region as the free transaction
won't be complete until the discard is done....

> > Let's keep the OS level interactions simple - if the array vendors
> > want to keep long queues of requests around before acting on them
> > to aggregate them, then that is an optimisation for them to
> > implement. They already do this with small data writes to NVRAM, so I
> > don't see how this should be treated any differently...
> 
> Well, that's Chris' argument, and it has merit.  I'm coming from the
> point of view that discards are actually a fundamentally different
> entity from anything else we process.

>From a filesystem perspective, they are no different to any other
metadata I/O. They need to be tracked to allow robust crash recovery
semantics to be implemented in the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
