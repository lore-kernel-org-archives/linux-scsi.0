From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Thu, 11 Oct 2007 20:24:32 +0200
Message-ID: <20071011182430.GC22606@kernel.dk>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com> <20071009120048.GB13842@parisc-linux.org> <20071009121524.GO5241@kernel.dk> <1191945372.3294.28.camel@localhost.localdomain> <20071010122508.GL4984@kernel.dk> <20071011180108.GA15357@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:5171 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXJKSYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 14:24:37 -0400
Content-Disposition: inline
In-Reply-To: <20071011180108.GA15357@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, Oct 11 2007, malahal@us.ibm.com wrote:
> > @@ -3600,24 +3618,132 @@ static struct notifier_block __devinitdata blk_cpu_notifier = {
> >  };
> > 
> >  /**
> > - * blk_complete_request - end I/O on a request
> > - * @req:      the request being processed
> > + * blk_delete_timer - Delete/cancel timer for a given function.
> > + * @req:	request that we are canceling timer for
> >   *
> > - * Description:
> > - *     Ends all I/O on a request. It does not handle partial completions,
> > - *     unless the driver actually implements this in its completion callback
> > - *     through requeueing. Theh actual completion happens out-of-order,
> > - *     through a softirq handler. The user must have registered a completion
> > - *     callback through blk_queue_softirq_done().
> > - **/
> > + * Return value:
> > + *     1 if we were able to detach the timer.  0 if we blew it, and the
> > + *     timer function has already started to run.
> > + */
> > +int blk_delete_timer(struct request *req)
> > +{
> > +	if (!req->q->rq_timed_out_fn)
> > +		return 1;
> > 
> > -void blk_complete_request(struct request *req)
> > +	if (!list_empty(&req->timeout_list)) {
> 
> This could race with timeout handler. In other words, this routine may
> return 1 while blk_rq_timed_out() is running on the request.

My current code is fine, it deletes the request from the list before
calling blk_rq_timed_out().

> > +	ret = q->rq_timed_out_fn(req);
> > +	switch (ret) {
> > +	case BLK_EH_HANDLED:
> > +		__blk_complete_request(req);
> > +		break;
> > +	case BLK_EH_RESET_TIMER:
> > +		blk_add_timer(req);
> 
> You will need to delete the req from the timeout_list before calling
> blk_add_timer again. You may need to remove the req from the list in
> other cases too.

Yep, that is exactly what I did.

-- 
Jens Axboe

