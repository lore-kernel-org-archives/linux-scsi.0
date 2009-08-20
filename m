From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Wed, 19 Aug 2009 21:05:52 -0400
Message-ID: <20090820010552.GA22107@infradead.org>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZHTBGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2009 21:06:21 -0400
Content-Disposition: inline
In-Reply-To: <20090819203916.GA25296@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com

On Wed, Aug 19, 2009 at 10:39:16PM +0200, Ingo Molnar wrote:
> A general interface design question: you added a new 
> ioctl XFS_IOC_TRIM case. It's a sub-case of an 
> ugly-looking demultiplexing xfs_file_ioctl().

ioctl is per defintion a multiplexer.

> What is your threshold for turning something into a 
> syscall? When are ioctls acceptable in your opinion?
> 
> I'm asking this because we are facing a similar problem 
> with perfcounters: we need to extend the ioctl 
> functionality there but introducing a new syscall looks 
> wasteful.
> 
> So i'm torn about the 'syscall versus ioctl' issue, i'd 
> like to avoid making interface design mistakes and i'd 
> like to solicit some opinions about this. I've attached 
> the perfcounters ioctl patch below.

Only add a syscall if it has _one_ clear defined purpose,
which has kernel-wide meaning.

Do not add an syscall that is just another multiplexer without
structure. Most likely it will just be even worse than sys_ioctl.

Also really don't bother adding a system call that is specific to
one singler driver or filesystem.  Besides horrible logistics -
you'd need some always built-in stub calling out to the possibly
modular drivers/filesystem - it also simply doesn't make any semantical
sense.  I can't say I like the ioctl use in perfcounters much,
but adding a special syscalls instead would be even more horrible.


As for the trim support this really just was an RFC to start bringing
some code into play instead of the endless masturbation about hat code
that doesn't exist happens on hardware most people don't have.  The
interface will most ceetainly change and I hope we will have a common
interface for all filesystems (or at least those that care).
