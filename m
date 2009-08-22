From: Theodore Tso <tytso@mit.edu>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 22:06:07 -0400
Message-ID: <20090822020607.GQ9529@mit.edu>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090822005613.GB22530@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090822005613.GB22530@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 22, 2009 at 01:56:13AM +0100, Jamie Lokier wrote:
> AIX behaves like XFS according to documentation:
> 
>     [ http://publib.boulder.ibm.com/infocenter/systems/index.jsp?topic=/com.ibm.aix.genprogc/doc/genprogc/fileio.htm ]
> 
>     Direct I/O and Data I/O Integrity Completion
> 
>     Although direct I/O writes are done synchronously, they do not
>     provide synchronized I/O data integrity completion, as defined by
>     POSIX. Applications that need this feature should use O_DSYNC in
>     addition to O_DIRECT. O_DSYNC guarantees that all of the data and
>     enough of the metadata (for example, indirect blocks) have written
>     to the stable store to be able to retrieve the data after a system
>     crash. O_DIRECT only writes the data; it does not write the
>     metadata.
> 
> That's another reason to use O_DIRECT|O_DSYNC in moderately portable
> code.

...or use fsync() when they need to guarantee that data has been
atomically written, but not before.  This becomes critically important
if the application is writing into a sparse file, or writing into
uninitalized blocks that were allocated using fallocate(); otherwise,
with O_DIRECT|O_DSYNC, the file system would have to do a commit
operation after each write, which could be a performance disaster.

> > http://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics
> > 
> > Comments are welcome, either on the wiki's talk page, or directly to
> > me, or to the linux-fsdevel or linux-ext4.
> 
> I haven't read it yet.  One thing which comes to mind is it would be
> good to summarise what other OSes as well as Linux do with O_DIRECT
> w.r.t. data-finding metadata, preallocation, file extending, hole
> filling, unaligned access and what alignment is required, block
> devices vs. files and different filesystems and behaviour-modifying
> mount options, file open for buffered I/O on another descriptor, file
> has mapped pages, mlocked pages, and of course drive cache write
> through or not.

It's a wiki; contributions to define all of that is welcome.  :-)

We may want to carefully consider what we want to guarantee for all
time to application writers, and what we might want to leave open to
allow for performance optimizations by the kernel, though.

      	  	      		       	   	   - Ted
