From: Dave Chinner <david@fromorbit.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 09:36:05 +1100
Message-ID: <20081106223605.GC2373@disturbed>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:57191 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbYKFWgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 17:36:17 -0500
Content-Disposition: inline
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

On Thu, Nov 06, 2008 at 09:43:23AM -0500, Ric Wheeler wrote:
>
> After talking to some vendors, one issue that came up is that the arrays  
> all have a different size that is used internally to track the SCSI  
> equivalent of TRIM commands (POKE/unmap).
>
> What they would like is for us to coalesce these commands into aligned  
> multiples of these chunks. If not, the target device will most likely  
> ignore the bits at the beginning and end (and all small requests).

There's lots of questions that need to be answered here. e.g:

Where are these free spaces going to be aggregated before dispatch?

What happens if they are re-allocated and re-written by the
filesystem before they've been dispatched?

How is the chunk size going to be passed to the aggregation layer?

What about passing itto the filesystem so it can align all it's
allocations in a manner that simplifies the dispatch problem?

What happens if a crash occurs before the aggregated free space is
dispatched?

Are there coherency problems with filesystem recovery after a crash?

> I have been thinking about whether or not we can (and should) do  
> anything more than our current best effort to send down large chunks  
> (note that the "chunk" size can range from reasonable sizes like 8KB or  
> so up to close to 1MB!).

Any aggregation is only as good as the original allocation the
filesystem did. Look as the mess ext3 extracting untarring a kernel
tarball creates - blocks are written to all over the place. You'd
need to fix that to have any hope of behaviour nicely for a RAID
that has a sub-optimal thin provisioning algorithm.

The problem is not with the filesystem, the block layer or the OS.
If they array vendors have optimised themselves into a corner,
then they shoul dbe fixing their problem, not asking the rest of
the world to expend large amounts of effort to work around the
shortcomings of their products.....

> One suggestion is that a modified defrag sweep could be used
> periodically to update the device (a proposal I am not keen on).

No thanks. That needs an implementation per filesystem, and it will
need to be done with the filesystem on line which means it will
still need substantial help from the kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
