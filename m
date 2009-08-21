From: Theodore Tso <tytso@mit.edu>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 18:08:52 -0400
Message-ID: <20090821220852.GM9529@mit.edu>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43268 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbZHUWJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 18:09:03 -0400
Content-Disposition: inline
In-Reply-To: <20090821142635.GB30617@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jamie Lokier <jamie@shareable.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 10:26:35AM -0400, Christoph Hellwig wrote:
> > It turns out that applications needing integrity must use fdatasync or
> > O_DSYNC (or O_SYNC) *already* with O_DIRECT, because the kernel may
> > choose to use buffered writes at any time, with no signal to the
> > application.
> 
> The fallback was a relatively recent addition to the O_DIRECT semantics
> for broken filesystems that can't handle holes very well.  Fortunately
> enough we do force O_SYNC (that is Linux O_SYNC aka Posix O_DSYNC)
> semantics for that already.

Um, actually, we don't.  If we did that, we would have to wait for a
journal commit to complete before allowing the write(2) to complete,
which would be especially painfully slow for ext3.

This question recently came up on the ext4 developer's list, because
of a question of how direct I/O to an preallocated (uninitialized)
extent should be handled.  Are we supposed to guarantee synchronous
updates of the metadata by the time write(2) returns, or not?  One of
the ext4 developers (I can't remember if it was Mingming or Eric)
asked an XFS developer what they did in that case, and I believe the
answer they were given was that XFS started a commit, but did *not*
wait for the commit to complete before returning from the Direct I/O
write.  In fact, they were told (I believe this was from an SGI
engineer, but I don't remember the name; we can track that down if
it's important) that if an application wanted to guarantee metadata
would be updated for an extending write, they had to use fsync() or
O_SYNC/O_DSYNC.  

Perhaps they were given an incorrect answer, but it's clear the
semantics of exactly how Direct I/O works in edge cases isn't well
defined, or at least clearly and widely understood.

I have an early draft (for discussion only) what we think it means and
what is currently implemented in Linux, which I've put up, (again, let
me emphasisize) for *discussion* here:

http://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics

Comments are welcome, either on the wiki's talk page, or directly to
me, or to the linux-fsdevel or linux-ext4.

						- Ted
