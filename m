From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] libata error handling fixes (ATAPI)
Date: Wed, 16 Nov 2005 17:06:45 +0100
Message-ID: <58cb370e0511160806t1defd373w981e213d1cdeb2b3@mail.gmail.com>
References: <20051114195717.GA24373@havoc.gtf.org> <4379AA5B.1060900@pobox.com>
	 <4379B28E.9070708@gmail.com> <4379C062.3010302@pobox.com>
	 <20051115120016.GD7787@suse.de> <437A2814.1060308@cs.wisc.edu>
	 <20051115184131.GJ7787@suse.de> <20051116124035.GX7787@suse.de>
	 <58cb370e0511160704w4803a085h7bd6ab352d8c94e6@mail.gmail.com>
	 <20051116153119.GN7787@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.198]:55443 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030382AbVKPQGr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 11:06:47 -0500
Received: by nproxy.gmail.com with SMTP id k26so351755nfc
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 08:06:45 -0800 (PST)
In-Reply-To: <20051116153119.GN7787@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 11/16/05, Jens Axboe <axboe@suse.de> wrote:
> On Wed, Nov 16 2005, Bartlomiej Zolnierkiewicz wrote:
> > On 11/16/05, Jens Axboe <axboe@suse.de> wrote:
> >
> > > I updated that patch, and converted IDE and SCSI to use it. See the
> > > results here:
> > >
> > > http://brick.kernel.dk/git/?p=linux-2.6-block.git;a=shortlog;h=blk-softirq
> >
> > I like it but:
> >
> > * "we know it's either an FS or PC request" assumption in
> >   ide_softirq_done() is really wrong
>
> It used to be correct :-)

Sorry but it has been always like that,
other requests also pass through ide_end_request()
(which of course needs fixing).

> No, the problem is that I changed the partial stuff to allow the
> deletion/putting of the request to work for every type of request. But
> it definitely needs some more looking into.
>
> > * same with "uptodate = rq->errors"
>
> Yeah. In general, ->errors needs to be streamlined. It's a huge mess
> right now and it's making generic code really hard to do because every
> driver does their own weird thing with it.

Agreed.

> I'd like for IDE to really do stuff the error in ->errors, and push the
> retry or whatever counting into a ->retries instead. Then we can honor
> the simple rule of, rq->errors:
>
> < 0, it contains an -Exxxx value
> == 0, no errors, uptodate
> > 0, not uptodate, no specific error info. Usually 1.

This is a very good idea.

> > * blk_complete_request() is called with ide_lock hold but
> >   ide_softirq_done() also takes ide_lock - is this correct?
>
> blk_complete_request() need not be called with the lock held, in fact it
> would be best if it wasn't (no point in holding the lock). But right now
> it is in ide, because of the below. ide_softirq_done() always needs to
> grab the lock. There are no recursion problems there, ide_softirq_done()
> is called out-of-order from the actual completion call.
>
> > "There's still room for improvement, as __ide_end_request() really
> > could drop the lock after getting HWGROUP->rq (why does it need to
> > hold it in the first place? If ->rq access isn't serialized, we are
> > screwed anyways)."
> >
> > ide_preempt?  and yes we are screwed...
>
> Irk it's nasty, since it basically means we have to hold ide_lock over
> the entire functions looking at hwgroup->rq.
>
> It's ok for __ide_end_request() to be entered with the ide_lock held,
> the costly affair is usually completing the request. Which now happens
> outside of the lock.

We should get rid of ide_preempt later.

This will also allow us to remove ide_do_drive_cmd()
and use blk_execute_rq() exclusively.

> We could split the completion path in two - if we know this call will
> end the request completely, we can drop the lock and call into the
> blk_complete_request() stuff for free. We know we need to clear
> hwgroup->rq anyways, so we can do it up front and complete the request
> 'privately'. If we are not fully completing the request, keep the lock
> and do the partial completion. The bonus here is that the first case
> will be the often taken path by far (always with DMA and no errors), the
> other cases are not interesting from a performance perspective.

Sounds good.

Bartlomiej
