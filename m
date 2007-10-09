From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Tue, 9 Oct 2007 10:23:26 -0700
Message-ID: <20071009172326.GA20324@us.ibm.com>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009120048.GB13842@parisc-linux.org> <20071009121524.GO5241@kernel.dk> <1191945372.3294.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:58603 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXJIRX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 13:23:28 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l99HNSZI019362
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 13:23:28 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l99HNSG7332170
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 11:23:28 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l99HNRWt017010
	for <linux-scsi@vger.kernel.org>; Tue, 9 Oct 2007 11:23:27 -0600
Content-Disposition: inline
In-Reply-To: <1191945372.3294.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

If we don't need precise timeout, we can have one single timer running
at regular intervals, say every second. We also record the exact number
of requests that are supposed to be done in a particular interval. This
is done by computing the 'interval index' of a request, incrementing it
when we send the request and decrementing the same when the request is
completed. Timer can detect if all requests are done for that interval
by looking at the 'interval number'

In this method, timer can detect a timeout but doesn't know which
command has timed out though. Aborting all pending requests is one
option. As we don't start timer for each request, there is no need to
stop any timer when the request is done.

Thanks, Malahal.

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Tue, 2007-10-09 at 14:15 +0200, Jens Axboe wrote:
> > On Tue, Oct 09 2007, Matthew Wilcox wrote:
> > > On Mon, Oct 08, 2007 at 10:36:10PM -0700, malahal@us.ibm.com wrote:
> > > > Thank you Randy, Jens for your suggestions. I folded the second patch as
> > > > it is just a clean up. Here is the fixed one patch version.
> > > 
> > > I was thinking about this (in the context of shrinking scsi_cmnd --
> > > obviously, things are not improved if we simply move the timer to request
> > > instead of scsi_cmnd).  Why do we need a timer _per request_?  We don't
> > > need one per network packet.  I appreciate we had one per scsi_cmnd and
> > > this patch is just moving it upwards in the hierarchy, but perhaps we
> > > can do better.
> > > 
> > > What if we have one timer per request queue instead?  It needs to expire
> > > as soon as the earliest request timer would expire, then needs to be
> > > reset to the next earliest one.  We might walk the request queue more
> > > frequently, but we'd save 48 bytes in the struct request.
> > 
> > I agree, adding a full timer to each request is not nice. You jump over
> > the actual implementation details of having just one timer in the queue
> > though, it's pretty cheap to just say it can be done :-). You need to
> > track each request anyways. If all drivers used the block layer tagging
> > it would be easy since we are tracking each pending request in that
> > case, but right now they don't. So pending requests may very well be
> > outside of block layer knowledge.
> 
> Can't we handle this a bit like the Linux timer infrastructure?  Instead
> of a timer per cmnd we have one per queue that's reset by commands
> returning?  If we retained a linked list of commands in timer order and
> expiry times, that's still going to save us an unsigned long and two
> pointers over struct timer_list.
> 
> > You'd also end up using lots of extra cycles to find and move the timer
> > when it expires (not likely) or is deleted (most likely). I'd greatly
> > prefer the space overhead in this case, even if it is quite costly.
> 
> If there's another command on the linked list, you mod_timer otherwise
> you del_timer_sync.  Returning commands obviously delete from this list.
> 
> > There's also the issue of fiddling with just one vs many timers,
> > potentially more cache bouncy.
> 
> Yes, I agree it's more fiddly.
> 
> The beauty is that I think it can all be done at the block layer via
> helpers ... so it becomes Somebody Else's Problem from the SCSI point of
> view ...
> 
> James
