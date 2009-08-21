From: Jamie Lokier <jamie@shareable.org>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 16:24:59 +0100
Message-ID: <20090821152459.GC6929@shareable.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090821142635.GB30617@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 02:54:03PM +0100, Jamie Lokier wrote:
> > I've been thinking about this too, and for optimal performance with
> > VMs and also with databases, I think FUA is too strong.  (It's also
> > too weak, on drives which don't have FUA).
> 
> Why is FUA too strong?

In measurements I've done, disabling a disk's write cache results in
much slower ext3 filesystem writes than using barriers.  Others report
similar results.  This is with disks that don't have NCQ; good NCQ may
be better.

Using FUA for all writes should be equivalent to writing with write
cache disabled.

A journalling filesystem or database tends to write like this:

   (guest) WRITE
   (guest) WRITE
   (guest) WRITE
   (guest) WRITE
   (guest) WRITE
   (guest) CACHE FLUSH
   (guest) WRITE
   (guest) CACHE FLUSH
   (guest) WRITE
   (guest) WRITE
   (guest) WRITE

When a guest does that, for integrity it can be mapped to this on the
host with FUA:

   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA
   (host) WRITE FUA

or

   (host) WRITE
   (host) WRITE
   (host) WRITE
   (host) WRITE
   (host) WRITE
   (host) CACHE FLUSH
   (host) WRITE
   (host) CACHE FLUSH 
   (host) WRITE
   (host) WRITE
   (host) WRITE

We know from measurements that disabling the disk write cache is much
slower than using barriers, at least with some disks.

Assuming that WRITE FUA is equivalent to disabling write cache, we may
expect the WRITE FUA version to run much slower than the CACHE FLUSH
version.

It's also too weak, of course, on drives which don't support FUA.
Then you have to use CACHE FLUSH anyway, so the code should support
that (or disable the write cache entirely, which also performs badly).
If you don't handle drives without FUA, then you're back to "integrity
sometimes, user must check type of hardware", which is something we're
trying to get away from.  Integrity should not be a surprise when the
application requests it.

> > Fortunately there's already a sensible API for both: fdatasync (and
> > aio_fsync) to mean flush, and O_DSYNC (or inferred from
> > flush-after-one-write) to mean FUA.
> 
> I thought about this alot .  It would be sensible to only require
> the FUA semantics if O_SYNC is specified.  But from looking around at
> users of O_DIRECT no one seems to actually specify O_SYNC with it.

O_DIRECT with true POSIX O_SYNC is a bad idea, because it flushes
inode metadata (like mtime) too.  O_DIRECT|O_DSYNC is better.

O_DIRECT without O_SYNC, O_DSYNC, fsync or fdatasync is asking for
integrity problems when direct writes are converted to buffered writes
- which applies to all or nearly all OSes according to their
documentation (I've read a lot of them).

I notice that all applications I looked at which use O_DIRECT don't
attempt to determine when O_DIRECT will definitely result in direct
writes; they simpy assume it can be used as a substituted for O_SYNC
or O_DSYNC, as long as you follow the alignment rules.  Generally they
leave it to the user to configure what they want, and often don't
explain the drive integrity issue, except to say "depends on the OS,
your mileage may vary, we can do nothing about it".

Imho, integrity should not be something which depends on the user
knowing the details of their hardware to decide application
configuration options - at least, not out of the box.

On a related note,
http://publib.boulder.ibm.com/infocenter/systems/index.jsp?topic=/com.ibm.aix.genprogc/doc/genprogc/fileio.htm
says:

    Direct I/O and Data I/O Integrity Completion

    Although direct I/O writes are done synchronously, they do not
    provide synchronized I/O data integrity completion, as defined by
    POSIX. Applications that need this feature should use O_DSYNC in
    addition to O_DIRECT. O_DSYNC guarantees that all of the data and
    enough of the metadata (for example, indirect blocks) have written
    to the stable store to be able to retrieve the data after a system
    crash. O_DIRECT only writes the data; it does not write the
    metadata.

That's another reason to use O_DIRECT|O_DSYNC in moderately portable code.

> And on Linux where O_SYNC really means O_DYSNC that's pretty sensible -
> if O_DIRECT bypasses the filesystem cache there is nothing else
> left to sync for a non-extending write.

Oh, O_SYNC means O_DSYNC?  I thought it was the other way around.
Ugh, how messy.

> That is until those pesky disk
> write back caches come into play that no application writer wants or
> should have to understand.

As far as I can tell, they generally go out of their way to avoid
understanding it, except as a vaguely uncomfortable awareness and pass
the problem on to the application's user.

Unfortunately just disabling the disk cache for O_DIRECT would make
it's performance drop significantly, otherwise I'd say go for it.

> > It turns out that applications needing integrity must use fdatasync or
> > O_DSYNC (or O_SYNfC) *already* with O_DIRECT, because the kernel may
> > choose to use buffered writes at any time, with no signal to the
> > application.
> 
> The fallback was a relatively recent addition to the O_DIRECT semantics
> for broken filesystems that can't handle holes very well.  Fortunately
> enough we do force O_SYNC (that is Linux O_SYNC aka Posix O_DSYNC)
> semantics for that already.

Ok, so you're saying there's no _harm_ in specifying O_DSYNC with
O_DIRECT either? :-)

-- Jamie
