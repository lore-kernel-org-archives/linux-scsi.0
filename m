From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sg block layer tcqing fix
Date: 06 Jan 2004 09:30:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073403019.2047.10.camel@mulgrave>
References: <3FF08EAF.9080708@us.ibm.com> <3FFA426B.2030406@torque.net>
	<1073402071.2047.5.camel@mulgrave>  <20040106152215.GD3483@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:21647 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262128AbUAFPay (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 10:30:54 -0500
In-Reply-To: <20040106152215.GD3483@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: dougg@torque.net, Brian King <brking@us.ibm.com>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-01-06 at 09:22, Jens Axboe wrote:
> On Tue, Jan 06 2004, James Bottomley wrote:
> > +	/* unlikely because the tag was usually ended earlier
> > +	 *
> > +	 * NOTE: the lock should be held while checking the
> > +	 * flag.  However, any race here requiring the lock
> > +	 * would be a gross error. */
> 
> I don't agree with this comment - why would you need to have the queue
> lock to check req->flags?

Because the usual scsi method of doing this is:

	spin_lock_irqsave(q->queue_lock, flags);
	if (blk_rq_tagged(req))
		blk_queue_end_tag(q, req);
	spin_unlock_irqrestore(q->queue_lock, flags);

which was done because the REQ_QUEUE flag is altered by the
blk_queue_end_tag(), so I wanted to note that I'd done this one
differently deliberately.

On the other hand, I don't see the possibility of a legal race to do
this in any of our other block tag ending code either...perhaps I should
just convert them all to this form.

James

