From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 11:23:19 -0400
Message-ID: <20090821152318.GA26599@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821142008.GA30617@infradead.org> <1250867170.7363.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZHUPXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 11:23:18 -0400
Content-Disposition: inline
In-Reply-To: <1250867170.7363.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 09:06:10AM -0600, James Bottomley wrote:
> I've never really understood why FUA is considered equivalent to a
> barrier.  Our barrier semantics are that all I/Os before the barrier
> should be safely on disk after the barrier executes.  The FUA semantics
> are that *this write* should be safely on disk after it executes ... it
> can still leave preceding writes in the cache.  I can see that if you're
> only interested in metadata that making every metadata write a FUA and
> leaving the cache to sort out data writes does give FS image
> consistency.
> 
> How does FUA give us linux barrier semantics?

FUA by itself doesn't.

Think what use cases we have for barriers and/or FUA right now:

 - a cache flush.  Can only implement as cache flush obviously.
 - a barrier flush bio - can be implement as
     o cache flush, write, cache flush
     o or more efficiently as cache flush, write with FUA bit set

now there is a third use case for O_SYNC, O_DIRECT write which actually
do have FUA-like semantis, that is we only guarantee the I/O is on disk,
but we do not make guarantees about ordering vs earlier writes.
Currently we (as in those few filesystem bothering despite the
VFS/generic helpers making it really hard) implement O_SYNC by:

 - doing one or multiple normal writes, and wait on them
 - then issue a cache flush - either explicitly blkdev_issue_flush
   or implicitly as part of a barrier write for metadata

this could be done more efficiently simply setting the FUA bit on these
requests if we had an API for it.  For O_DIRECT should also apply
except that currently we don't even try.

