From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Wed, 16 Jul 2003 14:45:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030716124549.GX833@suse.de>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net> <1058359278.1856.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:8427 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270812AbTGPMbC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 08:31:02 -0400
Content-Disposition: inline
In-Reply-To: <1058359278.1856.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Haverkamp <markh@osdl.org>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 16 2003, James Bottomley wrote:
> On Tue, 2003-07-15 at 19:02, Mark Haverkamp wrote:
> > Daniel McNeil and I have been debugging a hang with the aacraid driver
> > using the as I/O scheduler.  We found that scsi_request_fn would
> > de-queue a request and later re-queued it.  This left the
> > as_data->nr_dispatched variable in an inconsistent state (it was never
> > being decremented back to zero).  We added a call to
> > elv_completed_request to clean up the state before re-adding the
> > request.  This has fixed our hang problem.  The linux-scsi list is being
> > copied for review of the scsi_lib.c change.
> > 
> > ===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
> > --- 1.99/drivers/scsi/scsi_lib.c	Sun Jun 29 18:14:44 2003
> > +++ edited/drivers/scsi/scsi_lib.c	Tue Jul 15 15:47:45 2003
> > @@ -1215,6 +1215,7 @@
> >  	spin_lock_irq(q->queue_lock);
> >  	if (blk_rq_tagged(req))
> >  		blk_queue_end_tag(q, req);
> > +	elv_completed_request(q, req);
> >  	__elv_add_request(q, req, 0, 0);
> 
> This doen't look right to me.
> 
> SCSI expects to be able to push back uncompleted requests onto the
> request queue.  The fact that you seem to be calling a completion
> function for an uncompleted request is what's causing me heartburn.

Completely agree, see my earlier main on the subject.

> This code used to work with the old scheduler (we extensively tested it
> around the 2.5.6x timeframe because of other changes), so what I'd
> really like to know is what changed in the scheduler assumptions to
> necessitate this?

AS scheduler needs paired started/completed calls, the old scheduler
didn't. In fact elv_completed_request() was introduced for that
purpose.

> If this change is suddenly required, there are several other places in
> our queueing functions that will need similar modifications.

Indeed

> Could I have a definitive statement from the I/O scheduler people about
> the procedure for pushing back uncompleted I/O on the block queue just
> so we all get back on the same page?

SCSI does it right, don't worry. It's a block layer problem that we need
to find out how to correctly make sure that we deal it. Basically
elv_next_request() does an implicit elv_started_request(), at least that
is what AS assumes. So request re-adds should notify the scheduler of
that fact.

The hack posted here works for them, but isn't correct.

-- 
Jens Axboe

