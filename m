From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 08:03:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058540605.20130.48.camel@markh1.pdx.osdl.net>
References: <20030716132036.GB833@suse.de>
	 <1058364455.1856.28.camel@mulgrave>	<20030716170456.GK833@suse.de>
	 <20030717015756.135a3f5a.akpm@osdl.org>	<20030717085952.GX833@suse.de>
	 <3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@suse.de>
	 <3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>
	 <3F1683F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>
	 <3F168846.90902@cyberone.com.au>
	 <1058474814.4638.11.camel@markh1.pdx.osdl.net>
	 <1058481553.19508.5.camel@markh1.pdx.osdl.net>
	 <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
	 <20030717170055.5dbe20c1.akpm@osdl.org>  <3F17821A.307@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:28300 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267517AbTGROsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 10:48:37 -0400
In-Reply-To: <3F17821A.307@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2003-07-17 at 22:14, Nick Piggin wrote:
> Andrew Morton wrote:
> 
> >Daniel McNeil <daniel@osdl.org> wrote:
> >
> >>Should	
> >>	list_add(&rq->queuelist, ad->dispatch->prev);
> >>be
> >>	list_add_tail(&rq->queuelist, ad->dispatch);
> >>
> >>It is equivalent, but makes the code clearer that we're adding to the
> >>end.
> >>
> >
> >yup.
> >
> >
> >>Also, isn't the: !list_empty(ad->dispatch) unnecessary since a
> >>list_add was just done, so the list cannot be empty?
> >>
> >
> >more yup.
> >
> 
> Oh, so the request should go on the dispatch list?
> OK that makes sense. Maybe also set arq->state = AS_RQ_DISPATCHED
> just in case.
> 
> And I think the arq == NULL case should be checked for with
> rq->flags & REQ_HARDBARRIER || !blk_fs_request(rq) for consistency.
> I think if arq is still NULL then its a bug.
> 
> Thanks
> Nick

Nick,

I tried what you suggested and I'm pretty sure that aic->nr_dispatched
is not getting incremented when it should be.  I get:

Badness in as_remove_dispatched_request at drivers/block/as-iosched.c:1019

Which says that aic->nr_dispatched is wrong. I have attached the
as_requeue_request that I was using.  Is this what you had in mind?


Thanks,
Mark.

---------------

/*
 * requeue the request. The request has not been completed, nor is it a
 * new request, so don't touch accounting.
 */
static void as_requeue_request(request_queue_t *q, struct request *rq)
{
	struct as_data *ad = q->elevator.elevator_data;
	struct as_rq *arq = RQ_DATA(rq);

	if (unlikely(rq->flags & REQ_HARDBARRIER) || 
			unlikely(!blk_fs_request(rq))) {
		BUG_ON(!arq);
		arq->state = AS_RQ_DISPATCHED;
		if (arq->io_context && arq->io_context->aic)
			atomic_inc(&arq->io_context->aic->nr_dispatched);
	}

	list_add_tail(&rq->queuelist, ad->dispatch);

	/* Stop anticipating - let this request get through */
	if (ad->antic_status == ANTIC_WAIT_REQ
			|| ad->antic_status == ANTIC_WAIT_NEXT)
		as_antic_stop(ad);

	return;
}



-- 
Mark Haverkamp <markh@osdl.org>

