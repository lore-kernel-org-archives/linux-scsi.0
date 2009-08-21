From: Jamie Lokier <jamie@shareable.org>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 14:54:03 +0100
Message-ID: <20090821135403.GA6208@shareable.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090821114010.GG12579@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Aug 20 2009, Christoph Hellwig wrote:
> > Btw, something semi-related I've been looking at recently:
> > 
> > Currently O_DIRECT writes bypass all kernel caches, but there they do
> > use the disk caches.  We currenly don't have any barrier support for
> > them at all, which is really bad for data integrity in virtualized
> > environments.  I've started thinking about how to implement this.
> > 
> > The simplest scheme would be to mark the last request of each
> > O_DIRECT write as barrier requests.  This works nicely from the FS
> > perspective and works with all hardware supporting barriers.  It's
> > massive overkill though - we really only need to flush the cache
> > after our request, and not before.  And for SCSI we would be much
> > better just setting the FUA bit on the commands and not require a
> > full cache flush at all.
> > 
> > The next scheme would be to simply always do a cache flush after
> > the direct I/O write has completed, but given that blkdev_issue_flush
> > blocks until the command is done that would a) require everyone to
> > use the end_io callback and b) spend a lot of time in that workque.
> > This only requires one full cache flush, but it's still suboptimal.
> > 
> > I have prototypes this for XFS, but I don't really like it.
> > 
> > The best scheme would be to get some highlevel FUA request in the
> > block layer which gets emulated by a post-command cache flush.
> 
> I've talked to Chris about this in the past too, but I never got around
> to benchmarking FUA for O_DIRECT. It should be pretty easy to wire up
> without making too many changes, and we do have FUA support on most SATA
> drives too. Basically just a check in the driver for whether the
> request is O_DIRECT and a WRITE, ala:
> 
>         if (rq_data_dir(rq) == WRITE && rq_is_sync(rq))
>                 WRITE_FUA;
> 
> I know that FUA is used by that other OS, so I think we should be golden
> on the hw support side.

I've been thinking about this too, and for optimal performance with
VMs and also with databases, I think FUA is too strong.  (It's also
too weak, on drives which don't have FUA).

I would like to be able to get the same performance and integrity as
the kernel filesystems can get, and that means using barrier flushes
when a kernel filesystem would use them, and FUA when a kernel
filesystem would use that.  Preferably the same whether userspace is
using a file or a block device.

The conclusion I came to is that O_DIRECT users need a barrier flush
primitive.  FUA can either be deduced by the elevator, or signalled
explicitly by userspace.

Fortunately there's already a sensible API for both: fdatasync (and
aio_fsync) to mean flush, and O_DSYNC (or inferred from
flush-after-one-write) to mean FUA.

Those apply to files, but they could be made to have the same effect
with block devices, which would be nice for applications which can use
both.  I'll talk about files from here on; assume the idea is to
provide the same functions for block devices.

It turns out that applications needing integrity must use fdatasync or
O_DSYNC (or O_SYNC) *already* with O_DIRECT, because the kernel may
choose to use buffered writes at any time, with no signal to the
application.  O_DSYNC or fdatasync ensures that unknown buffered
writes will be committed.  This is true for other operating systems
too, for the same reason, except some other unixes will convert all
writes to buffered writes, not just corner cases, under various
circumstances that it's hard for applications to detect.

So there's already a good match to using fdatasync and/or O_DSYNC for
O_DIRECT integrity.

If we define fdatasync's behaviour to be that it always causes a
barrier flush if there have been any WRITE commands to a disk since
the last barrier flush, in addition to it's behaviour of flushing
cached pages, that would be enough for VM and database applications
would have good support for integrity.  Of course O_DSYNC would imply
the same after each write.

As an optimisation, I think that FUA might be best done by the
elevator detecting opportunities to do that, rather than explicitly
signalled.

For VMs, the highest performance (with integrity) will likely come from:

    If the guest requests a virtual disk with write cache enabled:

        - Host opens file/blockdev with O_DIRECT  (but *not O_DSYNC*)
        - Host maps guests WRITE commands to host writes
        - Host maps guests CACHE FLUSH commands to fdatasync on host

    If the guest requests a virtual disk with write cache disabled:

        - Host opens file/blockdev with O_DIRECT|O_DSYNC
        - Host maps guests WRITE commands to host writes
        - Host maps guests CACHE FLUSH commands to nothing

    That's with host configured to use O_DIRECT.  If the host is
    configured to not use O_DIRECT, the same logic applies except that
    O_DIRECT is simply omitted.  Nice and simple eh?

Databases and userspace filesystems would be encouraged to do the
equivalent.  In other words, databases would open with O_DIRECT or not
(depending on behaviour preferred), and use fdatasync for barriers, or
use O_DSYNC if they are not using fdatasync.
       
Notice how it conveniently does the right thing when the kernel falls
back to buffered writes without telling anyone.

Code written in that way should do the right thing (or as close as
it's possible to get) on other OSes too.

(Btw, from what I can tell from various Windows documentation, it maps
the equivalent of O_DIRECT|O_DSYNC to setting FUA on every disk write,
and it maps the equivalent of fsync to sending a the disk a cache
flush command as well as writing file metadata.  There's no Windows
equivalent to O_SYNC or fdatasync.)

-- Jamie
