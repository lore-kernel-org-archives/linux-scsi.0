From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: blk request timeout handler against 2.6.26
Date: Fri, 20 Jun 2008 10:37:38 +0200
Message-ID: <20080620083738.GX20851@kernel.dk>
References: <20080503020000.GU14976@parisc-linux.org> <20080507074357.GP329@kernel.dk> <20080513032012.GC9511@us.ibm.com> <20080619171741.GB819@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17865 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYFTIhl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2008 04:37:41 -0400
Content-Disposition: inline
In-Reply-To: <20080619171741.GB819@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, Jun 19 2008, Mike Anderson wrote:
> Jens,
> 
> What is the status of the blk request timeout handler patches? I noticed
> the branch is showing no update for 7 months and the updates sent to the
> list received no response.
> 
> I was working on a abort function patch on top of the timeout patches to
> see if I could speed up some multipath failure over cases and wanted to
> understand if the blk timeout patch set was still a valid patch set.

It's still alive, I'll update the branch with the latest stuff. Perhaps
we can even make 2.6.27, it should be about ready-cooked now.

> 
> 
> malahal@us.ibm.com <malahal@us.ibm.com> wrote:
> > Add missing queue lock in blk_complete_request(). Ran disktest for few
> > hours and it works fine with this patch.
> > 
> > Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> > 
> > diff -r c06b3eb1f516 block/blk-core.c
> > --- a/block/blk-core.c	Wed May 07 20:07:12 2008 -0700
> > +++ b/block/blk-core.c	Wed May 07 20:17:03 2008 -0700
> > @@ -1856,6 +1856,10 @@
> >   */
> >  void blk_complete_request(struct request *req)
> >  {
> > +	unsigned long flags;
> > +	struct request_queue *q = req->q;
> > +	int rc;
> > +
> >  	/*
> >  	 * We don't have to worry about this one timing out any more.
> >  	 * If we are unable to remove the timer, then the command
> > @@ -1864,7 +1868,10 @@
> >  	 * that function could really be.  It might be on another processor,
> >  	 * etc, etc.
> >  	 */
> > -	if (!blk_delete_timer(req))
> > +	spin_lock_irqsave(q->queue_lock, flags);
> > +	rc = blk_delete_timer(req);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > +	if (!rc)
> >  		return;
> > 
> >  	__blk_complete_request(req);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com

-- 
Jens Axboe

