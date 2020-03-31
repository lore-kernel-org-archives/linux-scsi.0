Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BD4C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 04:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAB7B20776
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 04:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ceYFV2uo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgCaEFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 00:05:38 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34023 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgCaEFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 00:05:38 -0400
Received: by mail-vs1-f66.google.com with SMTP id b5so12664901vsb.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2020 21:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zke5yRW+ArGpRV56Byz8cgdPZDWiQ7bt+lqoUYmEskc=;
        b=ceYFV2uoQr0mS2GX/LNa0KtgNEbRuaubbuTOCl8Wvye7sSyixJMXwo4LrJbxQ6j5HA
         nJHMc6TUDu6dDEvnxKlOYZtoYGKF+0k0/H+rm6A4YhCYnsVMn2LvYoJ/xrmy6gqZ3tLm
         vJgfKGExX9svErzZItdo/o5AEMLyrbPy2L/Ls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zke5yRW+ArGpRV56Byz8cgdPZDWiQ7bt+lqoUYmEskc=;
        b=cK3p/PAQY8BZPggVCZSKbTO3tFMQxEAPMKHoh+frtWWelcWJJTfuEOVHR1aVIebP7c
         F7G+vbygP2nnc/p+tMlEaXQJjSrtC4EMlA+VnG2rJa21thorkpz164b5v2tV/tnAhjU+
         IiycdD9m8+FDxCr8++jp9FFQRdpVWSxTvPAoun70iEIdkFZOJ0scSJLzaPjn4CZe28Rr
         5kTqeo3xpGBIKmmnXzXWVW0SYfq2gsfENksIyK/9xHQOlQjPnFg35YgUrzCRT/oWoax+
         4EGi2DvBupvKXeT/14oD0HHUnuIcSdgGx00w9a+A/Qx/XIpDNno2bhInJPgUFMphv9yo
         IWrw==
X-Gm-Message-State: AGi0PuaT6HQQ6BMjFOSIbI8uq3RpttuYNdQfExjzUfPu/dl1EOlvnegJ
        hIXIYnx5ud/fhY9zMBuXVl071AlEetg=
X-Google-Smtp-Source: APiQypK/WWDSwMocT6vb+N87AgVF2SxLLB/nUU5AIh/qhzQCmBfUpuVpTwb56ie3OweuZqj2xE57SQ==
X-Received: by 2002:a67:a409:: with SMTP id n9mr11418539vse.18.1585627533958;
        Mon, 30 Mar 2020 21:05:33 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id l17sm5850469vsq.28.2020.03.30.21.05.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 21:05:32 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id p123so5356161vkg.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2020 21:05:32 -0700 (PDT)
X-Received: by 2002:a1f:a244:: with SMTP id l65mr10199156vke.34.1585627532149;
 Mon, 30 Mar 2020 21:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200330144907.13011-1-dianders@chromium.org> <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200331014109.GA20230@ming.t460p> <CAD=FV=V-6kFD2Nso+8YGpx5atDpkegBH+7JH9YZ70gPAs84FOw@mail.gmail.com>
 <20200331025828.GB20230@ming.t460p>
In-Reply-To: <20200331025828.GB20230@ming.t460p>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 30 Mar 2020 21:05:20 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Urdjs23t_J=GruoM_42rV94oXMiqTn0w3u4DR50zpb4Q@mail.gmail.com>
Message-ID: <CAD=FV=Urdjs23t_J=GruoM_42rV94oXMiqTn0w3u4DR50zpb4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-scsi@vger.kernel.org, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Mon, Mar 30, 2020 at 7:58 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Mon, Mar 30, 2020 at 07:15:54PM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Mon, Mar 30, 2020 at 6:41 PM Ming Lei <ming.lei@redhat.com> wrote:
> > >
> > > On Mon, Mar 30, 2020 at 07:49:06AM -0700, Douglas Anderson wrote:
> > > > It is possible for two threads to be running
> > > > blk_mq_do_dispatch_sched() at the same time with the same "hctx".
> > > > This is because there can be more than one caller to
> > > > __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
> > > > prevent more than one thread from entering.
> > > >
> > > > If more than one thread is running blk_mq_do_dispatch_sched() at the
> > > > same time with the same "hctx", they may have contention acquiring
> > > > budget.  The blk_mq_get_dispatch_budget() can eventually translate
> > > > into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
> > > > uncommon) then only one of the two threads will be the one to
> > > > increment "device_busy" to 1 and get the budget.
> > > >
> > > > The losing thread will break out of blk_mq_do_dispatch_sched() and
> > > > will stop dispatching requests.  The assumption is that when more
> > > > budget is available later (when existing transactions finish) the
> > > > queue will be kicked again, perhaps in scsi_end_request().
> > > >
> > > > The winning thread now has budget and can go on to call
> > > > dispatch_request().  If dispatch_request() returns NULL here then we
> > > > have a potential problem.  Specifically we'll now call
> > >
> > > I guess this problem should be BFQ specific. Now there is definitely
> > > requests in BFQ queue wrt. this hctx. However, looks this request is
> > > only available from another loser thread, and it won't be retrieved in
> > > the winning thread via e->type->ops.dispatch_request().
> > >
> > > Just wondering why BFQ is implemented in this way?
> >
> > Paolo can maybe comment why.
> >
> > ...but even if BFQ wanted to try to change this, I think it's
> > impossible to fully close the race.  There is no locking between the
> > call to has_work() and dispatch_request() and there can be two (or
> > more) threads running the code at the same time.  Without some type of
> > locking I think it will always be possible for dispatch_request() to
> > return NULL.  Are we OK with code that works most of the time but
> > still has a race?  ...or did I misunderstand how this all works?
>
> Wrt. dispatching requests from hctx->dispatch, there is really one
> race given scsi's run queue from scsi_end_request() may not see
> that request. Looks that is what the patch 1 is addressing.

OK, at least I got something right.  ;-)


> However, for this issue, there isn't race, given when we get budget,
> the request isn't dequeued from BFQ yet. If budget is assigned
> successfully, either the request is dispatched to LLD successfully,
> or STS_RESOURCE is triggered, or running out of driver tag, run queue
> is guaranteed to be started for handling another dispatch path
> which running out of budget.
>
> That is why I raise the question why BFQ dispatches request in this way.

Ah, I _think_ I see what you mean.  So there should be no race because
the "has_work" is just a hint?  It's assumed that whichever task gets
the budget will be able to dispatch all the work that's there.  Is
that right?


> > > > blk_mq_put_dispatch_budget() which translates into
> > > > scsi_mq_put_budget().  That will mark the device as no longer busy but
> > > > doesn't do anything to kick the queue.  This violates the assumption
> > > > that the queue would be kicked when more budget was available.
> > > >
> > > > Pictorially:
> > > >
> > > > Thread A                          Thread B
> > > > ================================= ==================================
> > > > blk_mq_get_dispatch_budget() => 1
> > > > dispatch_request() => NULL
> > > >                                   blk_mq_get_dispatch_budget() => 0
> > > >                                   // because Thread A marked
> > > >                                   // "device_busy" in scsi_device
> > > > blk_mq_put_dispatch_budget()
> > > >
> > > > The above case was observed in reboot tests and caused a task to hang
> > > > forever waiting for IO to complete.  Traces showed that in fact two
> > > > tasks were running blk_mq_do_dispatch_sched() at the same time with
> > > > the same "hctx".  The task that got the budget did in fact see
> > > > dispatch_request() return NULL.  Both tasks returned and the system
> > > > went on for several minutes (until the hung task delay kicked in)
> > > > without the given "hctx" showing up again in traces.
> > > >
> > > > Let's attempt to fix this problem by detecting budget contention.  If
> > > > we're in the SCSI code's put_budget() function and we saw that someone
> > > > else might have wanted the budget we got then we'll kick the queue.
> > > >
> > > > The mechanism of kicking due to budget contention has the potential to
> > > > overcompensate and kick the queue more than strictly necessary, but it
> > > > shouldn't hurt.
> > > >
> > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > ---
> > > >
> > > >  drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
> > > >  drivers/scsi/scsi_scan.c   |  1 +
> > > >  include/scsi/scsi_device.h |  2 ++
> > > >  3 files changed, 27 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index 610ee41fa54c..0530da909995 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -344,6 +344,21 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> > > >       rcu_read_unlock();
> > > >  }
> > > >
> > > > +static void scsi_device_dec_busy(struct scsi_device *sdev)
> > > > +{
> > > > +     bool was_contention;
> > > > +     unsigned long flags;
> > > > +
> > > > +     spin_lock_irqsave(&sdev->budget_lock, flags);
> > > > +     atomic_dec(&sdev->device_busy);
> > > > +     was_contention = sdev->budget_contention;
> > > > +     sdev->budget_contention = false;
> > > > +     spin_unlock_irqrestore(&sdev->budget_lock, flags);
> > > > +
> > > > +     if (was_contention)
> > > > +             blk_mq_run_hw_queues(sdev->request_queue, true);
> > > > +}
> > > > +
> > > >  void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
> > > >  {
> > > >       struct Scsi_Host *shost = sdev->host;
> > > > @@ -354,7 +369,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
> > > >       if (starget->can_queue > 0)
> > > >               atomic_dec(&starget->target_busy);
> > > >
> > > > -     atomic_dec(&sdev->device_busy);
> > > > +     scsi_device_dec_busy(sdev);
> > > >  }
> > > >
> > > >  static void scsi_kick_queue(struct request_queue *q)
> > > > @@ -1624,16 +1639,22 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
> > > >       struct request_queue *q = hctx->queue;
> > > >       struct scsi_device *sdev = q->queuedata;
> > > >
> > > > -     atomic_dec(&sdev->device_busy);
> > > > +     scsi_device_dec_busy(sdev);
> > > >  }
> > > >
> > > >  static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
> > > >  {
> > > >       struct request_queue *q = hctx->queue;
> > > >       struct scsi_device *sdev = q->queuedata;
> > > > +     unsigned long flags;
> > > >
> > > > -     if (scsi_dev_queue_ready(q, sdev))
> > > > +     spin_lock_irqsave(&sdev->budget_lock, flags);
> > > > +     if (scsi_dev_queue_ready(q, sdev)) {
> > > > +             spin_unlock_irqrestore(&sdev->budget_lock, flags);
> > > >               return true;
> > > > +     }
> > > > +     sdev->budget_contention = true;
> > > > +     spin_unlock_irqrestore(&sdev->budget_lock, flags);
> > >
> > > No, it really hurts performance by adding one per-sdev spinlock in fast path,
> > > and we actually tried to kill the atomic variable of 'sdev->device_busy'
> > > for high performance HBA.
> >
> > It might be slow, but correctness trumps speed, right?  I tried to do
>
> Correctness doesn't have to cause performance regression, does it?

I guess what I'm saying is that if there is a choice between the two
we have to choose correctness.  If there is a bug and we don't know of
any way to fix it other than with a fix that regresses performance
then we have to regress performance.  I wasn't able to find a way to
fix the bug (as I understood it) without regressing performance, but
I'd be happy if someone else could come up with a way.


> > this with a 2nd atomic and without the spinlock but I kept having a
> > hole one way or the other.  I ended up just trying to keep the
> > spinlock section as small as possible.
> >
> > If you know of a way to get rid of the spinlock that still makes the
> > code correct, I'd be super interested!  :-)  I certainly won't claim
> > that it's impossible to do, only that I didn't manage to come up with
> > a way.
>
> As I mentioned, if BFQ doesn't dispatch request in this special way,
> there isn't such race.

OK, so I guess this puts it in Paolo's court then.  I'm about done for
the evening, but maybe he can comment on it or come up with a fix?

-Doug
