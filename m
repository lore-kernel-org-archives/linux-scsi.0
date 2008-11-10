From: Dave Chinner <david@fromorbit.com>
Subject: Re: Thin provisioning & arrays
Date: Mon, 10 Nov 2008 19:31:26 +1100
Message-ID: <20081110083126.GF2373@disturbed>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Black_David@emc.com
Cc: martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, dwmw2@infradead.org, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 09, 2008 at 10:40:24PM -0500, Black_David@emc.com wrote:
> Wow, this discussion can generate a lot of traffic ....  I think
> Dave Chinner's recent message is as good a place as any to start:
>  
> > It also ignores the fact that as the filesystem ages they will have
> > fewer and fewer aligned free chunks as the free space fragments.
> > Over time, arrays using large allocation chunks are simply going to
> > be full of wasted space as filesystem allocation patterns degrade
> > if the array vendors ignore this problem.

[snip a bunch of stuff I can't add anything too ;]

> My take on this is that I agree with Ric's comment:
> 
> > In another email Ted mentions that it makes sense for the FS allocator
> > to notice we've just freed the last block in an aligned region of size
> > X, and I'd agree with that.
> >
> > The trim command we send down when we free the block could just
> contain
> > the entire range that is free (and easy for the FS to determine) every
> > time.
> 
> In other words, the filesystem ought to do a small amount of work to
> send down the largest (reasonable) range that it knows is free - this
> seems likely to be more effective than relying on the elevators to
> make this happen.  
> 
> There will be a chunk size value available in a VPD page that can be
> used to determine minimum size/alignment.  For openers, I see
> essentially
> no point in a 512-byte UNMAP, even though it's allowed by the standard -
> I suspect most arrays (and many SSDs) will ignore it, and ignoring
> it is definitely within the spirit of the proposed T10 standard (hint:
> I'm one of the people directly working on that proposal).

I think this is the crux of the issue. IMO, it's not much of a standard
when the spirit of the standard is to allow everyone to implement
different, non-deterministic behaviour....

> OTOH, it
> may not be possible to frequently assemble large chunks for arrays
> that use them, and I agree with Dave Chinner's remarks on free space
> fragmentation (quoted above) - there's no "free lunch" there.

> Beyond this, I think there may be an underlying assumption that the
> array and filesystem ought to be in sync (or close to it) on based
> on overhead and diminishing marginal returns of trying to get ever-
> closer sync. 

I'm not sure I follow - it's possible to have perfect
synchronisation between the array and the filesystem, including
crash recovery.

> Elsewhere, mention has been made of having the
> filesystem's free list behavior be LIFO-like, rather than constantly
> allocating new blocks from previously-unused space.  IMHO, that's a
> good idea for thin provisioning. 

Which is at odds with preventing fragmentation and minimising the
effect of aging on the filesystem. This, in turn, is bad for thin
provisioning because file fragmentation leads to free space
fragmentation over time.

I think the overall goal for filesystems in thin provisioned
environments should be to minimise free space fragmentation - it's
when you fail to have large contiguous regions of free space in 
the filesystem that thin provisioning becomes difficult. How this
is acheived will be different for every filesystem.

> Now, if the workload running on the filesystem causes the capacity
> used to stay within a range, there will be a set of relatively "hot"
> blocks on the free list that are being frequently freed and reallocated.
> It's a performance win not to UNMAP those blocks (saves work in both
> the kernel and on the array), and hence to have the filesystem and
> array views of what's in use not line up.

In that case, the filesystem tracks what it has not issued unmaps
on, so really there is no discrepancy between the filesystem and the
array in terms of free sapce. The filesystem simply has a "free but
not quite free" list of blocks that haven't been unmapped.

This is like the typical two-stage inode delete that most
journalling filesystems use - one stage to remove it from the
namespace and move it to a "to be freed" list, and then a second
stage to really free it. Inodes on the "to be freed" list can be
reused without being freed, and if a crash occurs they can be
really freed up during recovery. Issuing unmaps is conceptually
little different to this.....

> Despite the derogatory comment about defrag, it's making a comeback.
> I already know of two thin-provisioning-specific defrag utilities from
> other storage vendors (neither is for Linux, AFAIK).  While defrag is
> not a wonderful solution, it does free up space in large contiguous
> ranges, and most of what it frees will be "cold".

The problem is that it is the wrong model to be using for thin
provisioning. It assumes that unmapping blocks as we free them
is fundamentally broken - if unmapping as we go works and is made
reliable, then there is no need for such a defrag tool. Unmapping
can and should be made reliable so that we don't have to waste
effort trying to fix up mismatches that shouldn't have occurred in
the first place...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
