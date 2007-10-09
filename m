From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Tue, 09 Oct 2007 10:56:12 -0500
Message-ID: <1191945372.3294.28.camel@localhost.localdomain>
References: <20071004181259.GA16689@us.ibm.com>
	 <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk>
	 <20071009053610.GA17794@us.ibm.com>
	 <20071009120048.GB13842@parisc-linux.org> <20071009121524.GO5241@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39240 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754647AbXJIP4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 11:56:17 -0400
In-Reply-To: <20071009121524.GO5241@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Tue, 2007-10-09 at 14:15 +0200, Jens Axboe wrote:
> On Tue, Oct 09 2007, Matthew Wilcox wrote:
> > On Mon, Oct 08, 2007 at 10:36:10PM -0700, malahal@us.ibm.com wrote:
> > > Thank you Randy, Jens for your suggestions. I folded the second patch as
> > > it is just a clean up. Here is the fixed one patch version.
> > 
> > I was thinking about this (in the context of shrinking scsi_cmnd --
> > obviously, things are not improved if we simply move the timer to request
> > instead of scsi_cmnd).  Why do we need a timer _per request_?  We don't
> > need one per network packet.  I appreciate we had one per scsi_cmnd and
> > this patch is just moving it upwards in the hierarchy, but perhaps we
> > can do better.
> > 
> > What if we have one timer per request queue instead?  It needs to expire
> > as soon as the earliest request timer would expire, then needs to be
> > reset to the next earliest one.  We might walk the request queue more
> > frequently, but we'd save 48 bytes in the struct request.
> 
> I agree, adding a full timer to each request is not nice. You jump over
> the actual implementation details of having just one timer in the queue
> though, it's pretty cheap to just say it can be done :-). You need to
> track each request anyways. If all drivers used the block layer tagging
> it would be easy since we are tracking each pending request in that
> case, but right now they don't. So pending requests may very well be
> outside of block layer knowledge.

Can't we handle this a bit like the Linux timer infrastructure?  Instead
of a timer per cmnd we have one per queue that's reset by commands
returning?  If we retained a linked list of commands in timer order and
expiry times, that's still going to save us an unsigned long and two
pointers over struct timer_list.

> You'd also end up using lots of extra cycles to find and move the timer
> when it expires (not likely) or is deleted (most likely). I'd greatly
> prefer the space overhead in this case, even if it is quite costly.

If there's another command on the linked list, you mod_timer otherwise
you del_timer_sync.  Returning commands obviously delete from this list.

> There's also the issue of fiddling with just one vs many timers,
> potentially more cache bouncy.

Yes, I agree it's more fiddly.

The beauty is that I think it can all be done at the block layer via
helpers ... so it becomes Somebody Else's Problem from the SCSI point of
view ...

James


James


