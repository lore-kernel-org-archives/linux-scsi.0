From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] sg block layer tcqing fix
Date: Tue, 6 Jan 2004 16:37:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106153723.GE3483@suse.de>
References: <3FF08EAF.9080708@us.ibm.com> <3FFA426B.2030406@torque.net> <1073402071.2047.5.camel@mulgrave> <20040106152215.GD3483@suse.de> <1073403019.2047.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:27266 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264547AbUAFPh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 10:37:29 -0500
Content-Disposition: inline
In-Reply-To: <1073403019.2047.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dougg@torque.net, Brian King <brking@us.ibm.com>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 06 2004, James Bottomley wrote:
> On Tue, 2004-01-06 at 09:22, Jens Axboe wrote:
> > On Tue, Jan 06 2004, James Bottomley wrote:
> > > +	/* unlikely because the tag was usually ended earlier
> > > +	 *
> > > +	 * NOTE: the lock should be held while checking the
> > > +	 * flag.  However, any race here requiring the lock
> > > +	 * would be a gross error. */
> > 
> > I don't agree with this comment - why would you need to have the queue
> > lock to check req->flags?
> 
> Because the usual scsi method of doing this is:
> 
> 	spin_lock_irqsave(q->queue_lock, flags);
> 	if (blk_rq_tagged(req))
> 		blk_queue_end_tag(q, req);
> 	spin_unlock_irqrestore(q->queue_lock, flags);
> 
> which was done because the REQ_QUEUE flag is altered by the
> blk_queue_end_tag(), so I wanted to note that I'd done this one
> differently deliberately.

That doesn't mean it's not safe to check req->flags outside the lock,
it's definitely not safe to call blk_queue_end_tag() without it though.
The above should probably be:

	if (blk_rq_tagged(req)) {
		spin_lock_irqsave(q->queue_lock, flags);
		blk_queue_end_tag(q, req);
		spin_unlock_irqrestore(q->queue_lock, flags);
	}

> On the other hand, I don't see the possibility of a legal race to do
> this in any of our other block tag ending code either...perhaps I should
> just convert them all to this form.

I think so, yes. There should only be one passing down the request.

-- 
Jens Axboe

