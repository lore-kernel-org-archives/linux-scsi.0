From: Jamie Lokier <jamie@shareable.org>
Subject: Re: O_DIRECT and barriers
Date: Sat, 22 Aug 2009 01:50:06 +0100
Message-ID: <20090822005006.GA22530@shareable.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:47915 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbZHVAuO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 20:50:14 -0400
Content-Disposition: inline
In-Reply-To: <20090821174525.GA28861@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> > O_DIRECT without O_SYNC, O_DSYNC, fsync or fdatasync is asking for
> > integrity problems when direct writes are converted to buffered writes
> > - which applies to all or nearly all OSes according to their
> > documentation (I've read a lot of them).
> 
> It did not happen on IRIX where O_DIRECT originated that did not happen,

IRIX has an unusually sane O_DIRECT - at least according to it's
documentation.  This is write(2):

     When attempting to write to a file with O_DIRECT or FDIRECT set,
     the portion being written can not be locked in memory by any
     process. In this case, -1 will be returned and errno will be set
     to EBUSY.

AIX however says this:

     In order to avoid consistency issues between programs that use
     Direct I/O and programs that use normal cached I/O, Direct I/O is
     by default used in an exclusive use mode. If there are multiple
     opens of a file and some of them are direct and others are not,
     the file will stay in its normal cached access mode. Only when
     the file is open exclusively by Direct I/O programs will the file
     be placed in Direct I/O mode.

     Similarly, if the file is mapped into virtual memory via the
     shmat() or mmap() system calls, then file will stay in normal
     cached mode.

     The JFS or JFS2 will attempt to move the file into Direct I/O
     mode any time the last conflicting. non-direct access is
     eliminated (either by close(), munmap(), or shmdt()
     subroutines). Changing the file from normal mode to Direct I/O
     mode can be rather expensive since it requires writing all
     modified pages to disk and removing all the file's pages from
     memory.

> neither does it happen on Linux when using XFS.  Then again at least on
> Linux we provide O_SYNC (that is Linux O_SYNC, aka Posix O_DYSC)
> semantics for that case.

As Ted T'so pointer out, we don't.

> > Imho, integrity should not be something which depends on the user
> > knowing the details of their hardware to decide application
> > configuration options - at least, not out of the box.
> 
> That is what I meant.  Only doing cache flushes/FUA for O_DIRECT|O_DSYNC
> is not what users naively expect.

Oh, I agree with that.  That comes from observing that quasi-portable
code using O_DIRECT needs to use O_DSYNC too because several OSes and
filesystems on those OSes revert to buffered writes under some
circumstances, in which case you want O_DSYNC too.  That has nothing
to do with hardware caches, but it's a lucky coincidence that
fdatasync() would form a nice barrier function, and O_DIRECT|O_DSYNC
would then make sense as an FUA equivalent.

> And the wording in hour manpages also suggests this behaviour,
> although it is not entirely clear:
> 
> O_DIRECT (Since Linux 2.4.10)
> 	Try to minimize cache effects of the I/O to and from this file.  In
> 	general this will degrade performance, but it is useful in special
> 	situations, such as when applications do their own caching.  File I/O
> 	is done directly to/from user space buffers.  The I/O is synchronous,
> 	that is,  at the completion of a read(2) or write(2), data is
> 	guaranteed to have been transferred.  See NOTES below forfurther
> 	discussion.

Perhaps in the same way that fsync/fdatasync aren't clear on disk
cache behaviour either.  On Linux and some other OSes.

> (And yeah, the whole wording is horrible, I will send an update once
> we've sorted out the semantics, including caveats about older kernels)

One thing it's unhelpful about is the performance.  O_DIRECT tends to
improve performance for applications that do their own caching, it
also improves performance in whole systems when caching when would
cause memory pressure, and on Linux O_DIRECT is necessary for AIO
which can improve performance.

I have a 166MHz embedded device that I'm using O_DIRECT on to improve
performance - from 1MB/s to 10MB/s.

However if O_DIRECT is changed to force each write(2) through the disk
cache separately, then it will no longer provide this performance
boost at least with some kinds of disk.

That's why it's important not to change it casually.  Maybe it's the
right thing to do, but then it will be important to provide another
form of O_DIRECT which does not write through the disk cache, instead
providing a barrier capability.

(...After all, if we believed in integrity above everything then barriers
would be enabled for ext3 by default, *ahem*.)

Probably the best thing to do is look at what other OSes that are used
by databases etc. do with O_DIRECT, and if it makes sense, copy it.

What does IRIX do?  Does O_DIRECT on IRIX write through the drive's
cache?  What about Solaris?

-- Jamie
