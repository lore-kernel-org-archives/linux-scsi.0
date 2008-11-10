From: Black_David@emc.com
Subject: Thin provisioning & arrays
Date: Sun, 9 Nov 2008 22:40:24 -0500
Message-ID: <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp <20081109233639.GT4985@disturbed>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20081109233639.GT4985@disturbed>
Sender: linux-fsdevel-owner@vger.kernel.org
To: david@fromorbit.com, martin.petersen@oracle.com
Cc: chris.mason@oracle.com, jens.axboe@oracle.com, dwmw2@infradead.org, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx, Black_David@emc.com
List-Id: linux-scsi@vger.kernel.org

Wow, this discussion can generate a lot of traffic ....  I think
Dave Chinner's recent message is as good a place as any to start:
 
> It also ignores the fact that as the filesystem ages they will have
> fewer and fewer aligned free chunks as the free space fragments.
> Over time, arrays using large allocation chunks are simply going to
> be full of wasted space as filesystem allocation patterns degrade
> if the array vendors ignore this problem.
> 
> And no matter what us filesystem developers do, there is always
> going to be degradation in allocation patterns as the filesystems
> fill up and age. While we can try to improve aging behaviour, it
> doesn't solve the problem for array vendors - they need to be
> smarter about their allocation and block mapping....

I can't argue with that - this sort of internal fragmentation is
a consequence of using a large thin provisioning chunk size.  As
for why array vendors did this (and EMC is not the only vendor
that uses a large chunk size), the answer is based on the original
motivating customer situation, for example:
- The database admin insists that this new application needs 4TB, 
	so 4TB of storage is provisioned.
- 3 months later, the application is using 200GB, and not growing
	much, if at all.
Even a 1GB chunk size makes a big difference for this example ...

As for arrays and block tracking, EMC arrays work with 4kB blocks
internally.  A write of smaller than 4kB will often result in
reading the rest of the block from the disk into cache.  The
track size that Ric mentioned (64k) is used to manage on-disk
capacity, but the array knows how to do partial track writes.

As for what to optimize for, the chunk size is going to vary widely
across different arrays (even EMC's CLARiiON won't use the same
chunk size as Symmetrix).  Different array implementers will make
different decisions about how much state is reasonable to keep.
My take on this is that I agree with Ric's comment:

> In another email Ted mentions that it makes sense for the FS allocator
> to notice we've just freed the last block in an aligned region of size
> X, and I'd agree with that.
>
> The trim command we send down when we free the block could just
contain
> the entire range that is free (and easy for the FS to determine) every
> time.

In other words, the filesystem ought to do a small amount of work to
send down the largest (reasonable) range that it knows is free - this
seems likely to be more effective than relying on the elevators to
make this happen.  

There will be a chunk size value available in a VPD page that can be
used to determine minimum size/alignment.  For openers, I see
essentially
no point in a 512-byte UNMAP, even though it's allowed by the standard -
I suspect most arrays (and many SSDs) will ignore it, and ignoring
it is definitely within the spirit of the proposed T10 standard (hint:
I'm one of the people directly working on that proposal).  OTOH, it
may not be possible to frequently assemble large chunks for arrays
that use them, and I agree with Dave Chinner's remarks on free space
fragmentation (quoted above) - there's no "free lunch" there.

Beyond this, I think there may be an underlying assumption that the
array and filesystem ought to be in sync (or close to it) on based
on overhead and diminishing marginal returns of trying to get ever-
closer sync.  Elsewhere, mention has been made of having the
filesystem's free list behavior be LIFO-like, rather than constantly
allocating new blocks from previously-unused space.  IMHO, that's a
good idea for thin provisioning. 

Now, if the workload running on the filesystem causes the capacity
used to stay within a range, there will be a set of relatively "hot"
blocks on the free list that are being frequently freed and reallocated.
It's a performance win not to UNMAP those blocks (saves work in both
the kernel and on the array), and hence to have the filesystem and
array views of what's in use not line up.

Despite the derogatory comment about defrag, it's making a comeback.
I already know of two thin-provisioning-specific defrag utilities from
other storage vendors (neither is for Linux, AFAIK).  While defrag is
not a wonderful solution, it does free up space in large contiguous
ranges, and most of what it frees will be "cold".

Thanks,
--David
p.s.  Apologies in advance for slow responses - my Monday "crisis"
	is already scheduled ...
