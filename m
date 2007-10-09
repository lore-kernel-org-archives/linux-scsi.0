From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Tue, 9 Oct 2007 14:15:24 +0200
Message-ID: <20071009121524.GO5241@kernel.dk>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009120048.GB13842@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:11028 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXJIMOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2007 08:14:39 -0400
Content-Disposition: inline
In-Reply-To: <20071009120048.GB13842@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 09 2007, Matthew Wilcox wrote:
> On Mon, Oct 08, 2007 at 10:36:10PM -0700, malahal@us.ibm.com wrote:
> > Thank you Randy, Jens for your suggestions. I folded the second patch as
> > it is just a clean up. Here is the fixed one patch version.
> 
> I was thinking about this (in the context of shrinking scsi_cmnd --
> obviously, things are not improved if we simply move the timer to request
> instead of scsi_cmnd).  Why do we need a timer _per request_?  We don't
> need one per network packet.  I appreciate we had one per scsi_cmnd and
> this patch is just moving it upwards in the hierarchy, but perhaps we
> can do better.
> 
> What if we have one timer per request queue instead?  It needs to expire
> as soon as the earliest request timer would expire, then needs to be
> reset to the next earliest one.  We might walk the request queue more
> frequently, but we'd save 48 bytes in the struct request.

I agree, adding a full timer to each request is not nice. You jump over
the actual implementation details of having just one timer in the queue
though, it's pretty cheap to just say it can be done :-). You need to
track each request anyways. If all drivers used the block layer tagging
it would be easy since we are tracking each pending request in that
case, but right now they don't. So pending requests may very well be
outside of block layer knowledge.

You'd also end up using lots of extra cycles to find and move the timer
when it expires (not likely) or is deleted (most likely). I'd greatly
prefer the space overhead in this case, even if it is quite costly.

There's also the issue of fiddling with just one vs many timers,
potentially more cache bouncy.

-- 
Jens Axboe

