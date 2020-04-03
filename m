Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33479C2BA15
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 15:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F07AE20857
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 15:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IkCqFgbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404137AbgDCPLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:11:04 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35361 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403795AbgDCPLD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 11:11:03 -0400
Received: by mail-vs1-f68.google.com with SMTP id u11so5146327vsg.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2020 08:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3B7TP3PryQrSMDQHVPJCTFtzd/ywd5l72std87udlQ=;
        b=IkCqFgbE8sOnVH23Bfho3RoIfyYvdmlWc/wIjurrNtsT+gexEJaUgZwBOJ0C/jJdD1
         PgAWRVuRJSjJV0P1Qc0uJR+gA1+MciQJ438syn4YTV4DdihnuugJxVQIWYWTTZXQXDTZ
         vD6xDLcZVIpxcuhFAZ5BbzrIYJfcFfcGZ1KwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3B7TP3PryQrSMDQHVPJCTFtzd/ywd5l72std87udlQ=;
        b=OIhFoaXQBeSUN4htxLTcFYt9YwxOSs1QAS5tSKeZjF6mV7ToPktmtixVvts5mLidk7
         Cj2wB9GGes0wBac+fzdZ7lC6nxJ0koi5eKDaZHnh6t6g7Jjie1A38WqsQynmEycRlIWk
         myCYY1BQCqOemW9GfrzLLX5nmgCaUMVUjM9UFN+zKFJmjhZuvOc9BIrvUTszOyuDETJM
         WOdSiYxl3iVWhgjT0QPWncOvSUxdJPzE/6L2+j1To1GPil72r4qEF5BpFQD+0/nRwHHI
         IU8sJMktMh27tZYeHxN1DpYAtQVfluGXS/0zxZmI7IjyVM157ife7OZP+iLaU6KX/e6D
         v6zQ==
X-Gm-Message-State: AGi0PuaMoYoU2M8Pi8z+p+Zkc4Rjbe9AHcv4IllakYnVBeCxSbG58ZUe
        eRczOhgeks7Qzk0BrE2A7MYZr9g4T2A=
X-Google-Smtp-Source: APiQypJCPRzUzNdG7fPxHjM5jA2Yib2RUsGOXQkQbXjjesRJGPXsCPMwJPz6T5RqqICoNcxBkJPfOQ==
X-Received: by 2002:a05:6102:2401:: with SMTP id j1mr6485335vsi.13.1585926660288;
        Fri, 03 Apr 2020 08:11:00 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id s23sm1052669vsa.5.2020.04.03.08.10.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 08:10:59 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id m18so2829796uap.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2020 08:10:58 -0700 (PDT)
X-Received: by 2002:ab0:7406:: with SMTP id r6mr6622996uap.22.1585926657542;
 Fri, 03 Apr 2020 08:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200402155130.8264-1-dianders@chromium.org> <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p>
In-Reply-To: <20200403013356.GA6987@ming.t460p>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 3 Apr 2020 08:10:45 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
Message-ID: <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget contention
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Salman Qazi <sqazi@google.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Ajay Joshi <ajay.joshi@wdc.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Thu, Apr 2, 2020 at 6:34 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Thu, Apr 02, 2020 at 08:51:30AM -0700, Douglas Anderson wrote:
> > It is possible for two threads to be running
> > blk_mq_do_dispatch_sched() at the same time with the same "hctx".
> > This is because there can be more than one caller to
> > __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
> > prevent more than one thread from entering.
> >
> > If more than one thread is running blk_mq_do_dispatch_sched() at the
> > same time with the same "hctx", they may have contention acquiring
> > budget.  The blk_mq_get_dispatch_budget() can eventually translate
> > into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
> > uncommon) then only one of the two threads will be the one to
> > increment "device_busy" to 1 and get the budget.
> >
> > The losing thread will break out of blk_mq_do_dispatch_sched() and
> > will stop dispatching requests.  The assumption is that when more
> > budget is available later (when existing transactions finish) the
> > queue will be kicked again, perhaps in scsi_end_request().
> >
> > The winning thread now has budget and can go on to call
> > dispatch_request().  If dispatch_request() returns NULL here then we
> > have a potential problem.  Specifically we'll now call
>
> As I mentioned before, it is a BFQ specific issue, it tells blk-mq
> that it has work to do, and now the budget is assigned to the only
> winning thread, however, dispatch_request() still returns NULL.

Correct that it only happens with BFQ, but whether it's a BFQ bug or
not just depends on how you define the has_work() API.  If has_work()
is allowed to be in-exact then it's either a blk-mq bug or a SCSI bug
depending on how you cut it.  If has_work() must be exact then it is
certainly a BFQ bug.  If has_work() doesn't need to be exact then it's
not a BFQ bug.  I believe that a sane API could be defined either way.
Either has_work() can be defined as a lightweight hint to trigger
heavier code or it can be defined as something exact.  It's really up
to blk-mq to say how they define it.

From his response on the SCSI patch [1], it sounded like Jens was OK
with has_work() being a lightweight hint as long as BFQ ensures that
the queues run later.  ...but, as my investigation found, I believe
that BFQ _does_ try to ensure that the queue is run at a later time by
calling blk_mq_run_hw_queues().  The irony is that due to the race
we're talking about here, blk_mq_run_hw_queues() isn't guaranteed to
be reliable if has_work() is inexact.  :(  One way to address this is
to make blk_mq_run_hw_queues() reliable even if has_work() is inexact.

...so Jens: care to clarify how you'd like has_work() to be defined?


> > - Because this problem only trips with inexact has_work() it's
> >   believed that blk_mq_do_dispatch_ctx() does not need a similar
> >   change.
>
> Right, I prefer to fix it in BFQ, given it isn't a generic issue,
> not worth of generic solution.

Just to confirm: it sounds like you are saying that BFQ is not a first
class citizen here because not everyone uses BFQ.  Is that really the
best policy?  Couldn't I say that SCSI shouldn't be a first class
citizen because not everyone uses SCSI?  In such a case I could argue
that we should speed up the blk-mq layer by removing all the budget
code since SCSI is the only user.  I'm not actually suggesting it,
only pointing out that sometimes we need to make allowances in the
code.


> > @@ -97,12 +97,34 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
> >               if (e->type->ops.has_work && !e->type->ops.has_work(hctx))
> >                       break;
> >
> > -             if (!blk_mq_get_dispatch_budget(hctx))
> > -                     break;
> > +
> > +             if (!blk_mq_get_dispatch_budget(hctx)) {
> > +                     /*
> > +                      * We didn't get budget so set contention.  If
> > +                      * someone else had the budget but didn't dispatch
> > +                      * they'll kick everything.  NOTE: we check one
> > +                      * extra time _after_ setting contention to fully
> > +                      * close the race.  If we don't actually dispatch
> > +                      * we'll detext faux contention (with ourselves)
> > +                      * but that should be rare.
> > +                      */
> > +                     atomic_set(&q->budget_contention, 1);
> > +
> > +                     if (!blk_mq_get_dispatch_budget(hctx))
>
> scsi_mq_get_budget() implies a smp_mb(), so the barrier can order
> between blk_mq_get_dispatch_budget() and atomic_set(&q->budget_contention, 0|1).

I always struggle when working with memory barriers.  I think you are
saying that this section of code is OK, though, presumably because the
SCSI code does "atomic_inc_return" which implies this barrier.

Do you happen to know if it's documented that anyone who implements
get_budget() for "struct blk_mq_ops" will have a memory barrier here?
I know SCSI is the only existing user, but we'd want to keep it
generic.


> > +                             break;
> > +             }
> >
> >               rq = e->type->ops.dispatch_request(hctx);
> >               if (!rq) {
> >                       blk_mq_put_dispatch_budget(hctx);
> > +
> > +                     /*
> > +                      * We've released the budget but us holding it might
> > +                      * have prevented someone else from dispatching.
> > +                      * Detect that case and run all queues again.
> > +                      */
> > +                     if (atomic_read(&q->budget_contention))
>
> scsi_mq_put_budget() doesn't imply smp_mb(), so one smp_mb__after_atomic()
> is needed between the above two op.

OK, thanks.  I will add that we decide to move forward with this
patch.  Again I'd wonder if this type of thing should be documented.


> > +                             blk_mq_run_hw_queues(q, true);
> >                       break;
> >               }
> >
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 2cd8d2b49ff4..6163c43ceca5 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -1528,6 +1528,9 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
> >       struct blk_mq_hw_ctx *hctx;
> >       int i;
> >
> > +     /* We're running the queues, so clear the contention detector */
> > +     atomic_set(&q->budget_contention, 0);
> > +
>
> You add extra cost in fast path.

Yes, but it is a fairly minor cost added.  It's called once in a place
where we're unlikely to be looping and where we're about to do a lot
heavier operations (perhaps in a loop).  This doesn't feel like a
dealbreaker.


> >       queue_for_each_hw_ctx(q, hctx, i) {
> >               if (blk_mq_hctx_stopped(hctx))
> >                       continue;
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index f629d40c645c..07f21e45d993 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -583,6 +583,8 @@ struct request_queue {
> >
> >  #define BLK_MAX_WRITE_HINTS  5
> >       u64                     write_hints[BLK_MAX_WRITE_HINTS];
> > +
> > +     atomic_t                budget_contention;
>
> It needn't to be a atomic variable, and simple 'unsigned'
> int should be fine, what matters is that the order between
> R/W this flag and get/put budget.

Apparently I'm the only one who feels atomic_t is more documenting
here.  I will cede to the will of the majority here and change to
'unsigned int' if we decide to move forward with this patch.

-Doug

[1] https://lore.kernel.org/r/d6af2344-11f7-5862-daed-e21cbd496d92@kernel.dk
