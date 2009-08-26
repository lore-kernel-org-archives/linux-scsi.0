From: Jamie Lokier <jamie@shareable.org>
Subject: Re: O_DIRECT and barriers
Date: Wed, 26 Aug 2009 16:01:02 +0100
Message-ID: <20090826150102.GB22027@shareable.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090826063455.GA2417@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:41930 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZHZPBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 11:01:15 -0400
Content-Disposition: inline
In-Reply-To: <20090826063455.GA2417@discord.disaster>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

Dave Chinner wrote:
> On Fri, Aug 21, 2009 at 06:08:52PM -0400, Theodore Tso wrote:
> > On Fri, Aug 21, 2009 at 10:26:35AM -0400, Christoph Hellwig wrote:
> > > > It turns out that applications needing integrity must use fdatasync or
> > > > O_DSYNC (or O_SYNC) *already* with O_DIRECT, because the kernel may
> > > > choose to use buffered writes at any time, with no signal to the
> > > > application.
> > > 
> > > The fallback was a relatively recent addition to the O_DIRECT semantics
> > > for broken filesystems that can't handle holes very well.  Fortunately
> > > enough we do force O_SYNC (that is Linux O_SYNC aka Posix O_DSYNC)
> > > semantics for that already.
> > 
> > Um, actually, we don't.  If we did that, we would have to wait for a
> > journal commit to complete before allowing the write(2) to complete,
> > which would be especially painfully slow for ext3.
> > 
> > This question recently came up on the ext4 developer's list, because
> > of a question of how direct I/O to an preallocated (uninitialized)
> > extent should be handled.  Are we supposed to guarantee synchronous
> > updates of the metadata by the time write(2) returns, or not?  One of
> > the ext4 developers (I can't remember if it was Mingming or Eric)
> > asked an XFS developer what they did in that case, and I believe the
> > answer they were given was that XFS started a commit, but did *not*
> > wait for the commit to complete before returning from the Direct I/O
> > write.  In fact, they were told (I believe this was from an SGI
> > engineer, but I don't remember the name; we can track that down if
> > it's important) that if an application wanted to guarantee metadata
> > would be updated for an extending write, they had to use fsync() or
> > O_SYNC/O_DSYNC.  
> 
> That would have been Eric asking me. My answer that O_DIRECT does
> not imply any new data integrity guarantees associated with a
> write(2) call - it just avoids system caches. You get the same
> guarantees of resiliency as a non-O_DIRECT write(2) call at
> completion - it may or may notbe there if you crash. If you want
> some guarantee of integrity, then you need to use O_DSYNC, O_SYNC or
> call f[data]sync(2) just like all other IO.
> 
> Also, note that direct IO is not necessarily synchronous - you can
> do asynchronous direct IO.....

I agree with all of the above, except:

  1. If the automatic O_SYNC fallback mentioned by Christopher is
     currently implemented at all, even in a subset of filesystems,
     then I think it should be removed.

     An app which wants integrity should be calling fsync/fdatasync or
     using O_DSYNC/O_SYNC explicitly - with fsync/fdatasync giving
     more control over batching.

     If it doesn't do any of those things, it may be using O_DIRECT
     for performance, and not wish to be penalised by an expensive
     O_SYNC on every individual write.  Especially when O_SYNC is
     fixed to commit drive caches.

  2. I agree with everything Dave said about needing to use some other
     mechanism for an integrity commit; O_DIRECT is not enough.

     We can't realistically make O_DIRECT (by itself) do integrity
     commits anyway, because on some drives that involves committing
     the drive cache, and it would be a large performance regression.
     Given O_DIRECT is often used for its performance, that's not an
     option.

  3. Currently none of the options provides good integrity commit.

     All of them fail to commit drive caches under some circumstances;
     even fsync on ext3 with barriers enabled (because it doesn't
     commit a journal record if there were writes but no inode change
     with data=ordered).

     This should be changed (or at least made optionally available),
     and that's all the more reason to avoid commit operations except
     when requested.

  4. On drives which need it, fdatasync/fsync must trigger a drive
     cache flush even when there is no dirty page cache to write,
     because dirty pages may have been written in the background
     already, and because O_DIRECT writes dirty the drive cache but
     not the page cache.

     A per-drive flag would make sense to optimise this: It is set by
     any non-FUA writes sent to the drive while the drive's writeback
     cache is enabled, and cleared when any cache flush command is
     sent.  When the flag is clear, further cache flush commands don't
     need to be sent.

-- Jamie
