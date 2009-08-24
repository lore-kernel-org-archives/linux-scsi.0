From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Sun, 23 Aug 2009 22:34:22 -0400
Message-ID: <20090824023422.GA775@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090822005006.GA22530@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 22, 2009 at 01:50:06AM +0100, Jamie Lokier wrote:
> Oh, I agree with that.  That comes from observing that quasi-portable
> code using O_DIRECT needs to use O_DSYNC too because several OSes and
> filesystems on those OSes revert to buffered writes under some
> circumstances, in which case you want O_DSYNC too.  That has nothing
> to do with hardware caches, but it's a lucky coincidence that
> fdatasync() would form a nice barrier function, and O_DIRECT|O_DSYNC
> would then make sense as an FUA equivalent.

I agree.  I do however fear about everything using O_DIRECT that is
around now.  Less so about the databases and HPC workloads on expensive
hardware because they usually run on vendor approved scsi disks that
have the write back cache disabled, but rather things like
virtualization software or other things that get run on commodity
hardware.

Then again they already don't get what they expect and never did,
so if we clear document and communicate the O_SYNC (that is Linux
O_SYNC) requirement we might be able to go with this.

> Perhaps in the same way that fsync/fdatasync aren't clear on disk
> cache behaviour either.  On Linux and some other OSes.

The disk write cache really is an implementation detail, it has no
business in Posix.

Posix seems to define the semantics for fdatasync and cor relatively
well (that is if you like the specification speak in there):

"The fdatasync() function forces all currently queued I/O operations
 associated with the file indicated by file descriptor fildes to the
 synchronised I/O completion state."

"synchronised I/O data integrity completion

 o For read, when the operation has been completed or diagnosed if
   unsuccessful. The read is complete only when an image of the data has
   been successfully transferred to the requesting process. If there were
   any pending write requests affecting the data to be read at the time
   that the synchronised read operation was requested, these write
   requests shall be successfully transferred prior to reading the
   data."
 o For write, when the operation has been completed or diagnosed if
   unsuccessful. The write is complete only when the data specified in the
   write request is successfully transferred and all file system
   information required to retrieve the data is successfully transferred."

Given that it talks about data retrievable an volatile cache does not
seem to meet the above criteria.  But yeah, it's a horrible language.

> What does IRIX do?  Does O_DIRECT on IRIX write through the drive's
> cache?  What about Solaris?

IRIX only came pre-packaged with SGI MIPS systems.  Which as most of
the more expensive hardware was not configured with write through
caches.  Which btw is still the case for all more expensive hardware
I have.  The whole issue with volatile write back cache is just too
much of a data integrity nightmare as that you would enable it where
your customers actually care about their data.

