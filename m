From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 10:26:35 -0400
Message-ID: <20090821142635.GB30617@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbZHUO0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 10:26:35 -0400
Content-Disposition: inline
In-Reply-To: <20090821135403.GA6208@shareable.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 02:54:03PM +0100, Jamie Lokier wrote:
> I've been thinking about this too, and for optimal performance with
> VMs and also with databases, I think FUA is too strong.  (It's also
> too weak, on drives which don't have FUA).


Why is FUA too strong?

> Fortunately there's already a sensible API for both: fdatasync (and
> aio_fsync) to mean flush, and O_DSYNC (or inferred from
> flush-after-one-write) to mean FUA.

I thought about this alot .  It would be sensible to only require
the FUA semantics if O_SYNC is specified.  But from looking around at
users of O_DIRECT no one seems to actually specify O_SYNC with it.
And on Linux where O_SYNC really means O_DYSNC that's pretty sensible -
if O_DIRECT bypasses the filesystem cache there is nothing else
left to sync for a non-extending write.  That is until those pesky disk
write back caches come into play that no application writer wants or
should have to understand.

> It turns out that applications needing integrity must use fdatasync or
> O_DSYNC (or O_SYNC) *already* with O_DIRECT, because the kernel may
> choose to use buffered writes at any time, with no signal to the
> application.

The fallback was a relatively recent addition to the O_DIRECT semantics
for broken filesystems that can't handle holes very well.  Fortunately
enough we do force O_SYNC (that is Linux O_SYNC aka Posix O_DSYNC)
semantics for that already.

