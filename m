From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 13:45:25 -0400
Message-ID: <20090821174525.GA28861@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090821152459.GC6929@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 04:24:59PM +0100, Jamie Lokier wrote:
> In measurements I've done, disabling a disk's write cache results in
> much slower ext3 filesystem writes than using barriers.  Others report
> similar results.  This is with disks that don't have NCQ; good NCQ may
> be better.

On a scsi disk and a SATA SSD with NCQ I get different results.  Most
worksloads, in particular metadata-intensive ones and large streaming
writes are noticably better just turning off the write cache.  The only
onces that benefit from it are relatively small writes witout O_SYNC
or much fsyncs.  This is however using XFS which tends to issue much
more barriers than ext3.

> Using FUA for all writes should be equivalent to writing with write
> cache disabled.
> 
> A journalling filesystem or database tends to write like this:
> 
>    (guest) WRITE
>    (guest) WRITE
>    (guest) WRITE
>    (guest) WRITE
>    (guest) WRITE
>    (guest) CACHE FLUSH
>    (guest) WRITE
>    (guest) CACHE FLUSH
>    (guest) WRITE
>    (guest) WRITE
>    (guest) WRITE

In the optimal case, yeah.

> Assuming that WRITE FUA is equivalent to disabling write cache, we may
> expect the WRITE FUA version to run much slower than the CACHE FLUSH
> version.

For a workload that only does FUA writes, yeah.  That is however the use
case for virtual machines.  As I'm looking into those issues I will run
some benchmarks comparing both variants.

> It's also too weak, of course, on drives which don't support FUA.
> Then you have to use CACHE FLUSH anyway, so the code should support
> that (or disable the write cache entirely, which also performs badly).
> If you don't handle drives without FUA, then you're back to "integrity
> sometimes, user must check type of hardware", which is something we're
> trying to get away from.  Integrity should not be a surprise when the
> application requests it.

As mentioned in the previous mails FUA would only be an optimization
(if it ends up helping) we do need to support the cache flush case.

> > I thought about this alot .  It would be sensible to only require
> > the FUA semantics if O_SYNC is specified.  But from looking around at
> > users of O_DIRECT no one seems to actually specify O_SYNC with it.
> 
> O_DIRECT with true POSIX O_SYNC is a bad idea, because it flushes
> inode metadata (like mtime) too.  O_DIRECT|O_DSYNC is better.

O_SYNC above is the Linux O_SYNC aka Posix O_DYNC.

> O_DIRECT without O_SYNC, O_DSYNC, fsync or fdatasync is asking for
> integrity problems when direct writes are converted to buffered writes
> - which applies to all or nearly all OSes according to their
> documentation (I've read a lot of them).

It did not happen on IRIX where O_DIRECT originated that did not happen,
neither does it happen on Linux when using XFS.  Then again at least on
Linux we provide O_SYNC (that is Linux O_SYNC, aka Posix O_DYSC)
semantics for that case.

> Imho, integrity should not be something which depends on the user
> knowing the details of their hardware to decide application
> configuration options - at least, not out of the box.

That is what I meant.  Only doing cache flushes/FUA for O_DIRECT|O_DSYNC
is not what users naively expect.  And the wording in hour manpages also
suggests this behaviour, although it is not entirely clear:


O_DIRECT (Since Linux 2.4.10)

	Try to minimize cache effects of the I/O to and from this file.  In
	general this will degrade performance, but it is useful in special
	situations, such as when applications do their own caching.  File I/O
	is done directly to/from user space buffers.  The I/O is synchronous,
	that is,  at the completion of a read(2) or write(2), data is
	guaranteed to have been transferred.  See NOTES below forfurther
	discussion.

(And yeah, the whole wording is horrible, I will send an update once
we've sorted out the semantics, including caveats about older kernels)

> > And on Linux where O_SYNC really means O_DYSNC that's pretty sensible -
> > if O_DIRECT bypasses the filesystem cache there is nothing else
> > left to sync for a non-extending write.
> 
> Oh, O_SYNC means O_DSYNC?  I thought it was the other way around.
> Ugh, how messy.

Yes.  Except when using XFS and using the "osyncisosync" mount option :)

> > The fallback was a relatively recent addition to the O_DIRECT semantics
> > for broken filesystems that can't handle holes very well.  Fortunately
> > enough we do force O_SYNC (that is Linux O_SYNC aka Posix O_DSYNC)
> > semantics for that already.
> 
> Ok, so you're saying there's no _harm_ in specifying O_DSYNC with
> O_DIRECT either? :-)

No.  In the generic code and filesystems I looked at it simply has no
effect at all.

