Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F7BC2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 07:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7100C206A1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 07:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TTmgrKJX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgDHHgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 03:36:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50970 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbgDHHgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 03:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586331398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iszkXZ99fvnojmXd6uAmGEoN9rIMI6BXCafTQwT61lw=;
        b=TTmgrKJXfSi1In+p9yrfmyqgxN3kE8DLAI84qiXIu5S/pQn0I7IBQq5kRnNp0iM3WppHDW
        WcujQSP0cZUgUHTMs09T9mWLDwxBj5oFv35R26L74SwJCxyseuYudgQU7ENWVaRD28xoaG
        xuXzLU60SueYr/4z8xZiKeztVTcBGNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-FdZU8CX2NcWt56znMO-S3w-1; Wed, 08 Apr 2020 03:36:34 -0400
X-MC-Unique: FdZU8CX2NcWt56znMO-S3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4175D18FF66A;
        Wed,  8 Apr 2020 07:36:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-32.pek2.redhat.com [10.72.8.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 57F411001DC0;
        Wed,  8 Apr 2020 07:36:22 +0000 (UTC)
Date:   Wed, 8 Apr 2020 15:36:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Salman Qazi <sqazi@google.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-block <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] blk-mq: Rerun dispatching in the case of budget
 contention
Message-ID: <20200408073618.GA352827@localhost.localdomain>
References: <20200407220005.119540-1-dianders@chromium.org>
 <20200407145906.v3.3.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200408020936.GB337494@localhost.localdomain>
 <CAD=FV=WY8sTZQq3NtNe4Ux-C0Q0JOR4V1Z+cjVvj791rFDL+=Q@mail.gmail.com>
 <20200408030625.GC337494@localhost.localdomain>
 <CAD=FV=VUAyuMnvVwz7OGoe03o4ty1S=44sjkGsFaDR5OJbeCPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=VUAyuMnvVwz7OGoe03o4ty1S=44sjkGsFaDR5OJbeCPg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 07, 2020 at 09:11:28PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Tue, Apr 7, 2020 at 8:06 PM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Tue, Apr 07, 2020 at 07:17:49PM -0700, Doug Anderson wrote:
> > > Hi,
> > >
> > > On Tue, Apr 7, 2020 at 7:09 PM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > On Tue, Apr 07, 2020 at 03:00:04PM -0700, Douglas Anderson wrote:
> > > > > If ever a thread running blk-mq code tries to get budget and fails it
> > > > > immediately stops doing work and assumes that whenever budget is freed
> > > > > up that queues will be kicked and whatever work the thread was trying
> > > > > to do will be tried again.
> > > > >
> > > > > One path where budget is freed and queues are kicked in the normal
> > > > > case can be seen in scsi_finish_command().  Specifically:
> > > > > - scsi_finish_command()
> > > > >   - scsi_device_unbusy()
> > > > >     - # Decrement "device_busy", AKA release budget
> > > > >   - scsi_io_completion()
> > > > >     - scsi_end_request()
> > > > >       - blk_mq_run_hw_queues()
> > > > >
> > > > > The above is all well and good.  The problem comes up when a thread
> > > > > claims the budget but then releases it without actually dispatching
> > > > > any work.  Since we didn't schedule any work we'll never run the path
> > > > > of finishing work / kicking the queues.
> > > > >
> > > > > This isn't often actually a problem which is why this issue has
> > > > > existed for a while and nobody noticed.  Specifically we only get into
> > > > > this situation when we unexpectedly found that we weren't going to do
> > > > > any work.  Code that later receives new work kicks the queues.  All
> > > > > good, right?
> > > > >
> > > > > The problem shows up, however, if timing is just wrong and we hit a
> > > > > race.  To see this race let's think about the case where we only have
> > > > > a budget of 1 (only one thread can hold budget).  Now imagine that a
> > > > > thread got budget and then decided not to dispatch work.  It's about
> > > > > to call put_budget() but then the thread gets context switched out for
> > > > > a long, long time.  While in this state, any and all kicks of the
> > > > > queue (like the when we received new work) will be no-ops because
> > > > > nobody can get budget.  Finally the thread holding budget gets to run
> > > > > again and returns.  All the normal kicks will have been no-ops and we
> > > > > have an I/O stall.
> > > > >
> > > > > As you can see from the above, you need just the right timing to see
> > > > > the race.  To start with, the only case it happens if we thought we
> > > > > had work, actually managed to get the budget, but then actually didn't
> > > > > have work.  That's pretty rare to start with.  Even then, there's
> > > > > usually a very small amount of time between realizing that there's no
> > > > > work and putting the budget.  During this small amount of time new
> > > > > work has to come in and the queue kick has to make it all the way to
> > > > > trying to get the budget and fail.  It's pretty unlikely.
> > > > >
> > > > > One case where this could have failed is illustrated by an example of
> > > > > threads running blk_mq_do_dispatch_sched():
> > > > >
> > > > > * Threads A and B both run has_work() at the same time with the same
> > > > >   "hctx".  Imagine has_work() is exact.  There's no lock, so it's OK
> > > > >   if Thread A and B both get back true.
> > > > > * Thread B gets interrupted for a long time right after it decides
> > > > >   that there is work.  Maybe its CPU gets an interrupt and the
> > > > >   interrupt handler is slow.
> > > > > * Thread A runs, get budget, dispatches work.
> > > > > * Thread A's work finishes and budget is released.
> > > > > * Thread B finally runs again and gets budget.
> > > > > * Since Thread A already took care of the work and no new work has
> > > > >   come in, Thread B will get NULL from dispatch_request().  I believe
> > > > >   this is specifically why dispatch_request() is allowed to return
> > > > >   NULL in the first place if has_work() must be exact.
> > > > > * Thread B will now be holding the budget and is about to call
> > > > >   put_budget(), but hasn't called it yet.
> > > > > * Thread B gets interrupted for a long time (again).  Dang interrupts.
> > > > > * Now Thread C (maybe with a different "hctx" but the same queue)
> > > > >   comes along and runs blk_mq_do_dispatch_sched().
> > > > > * Thread C won't do anything because it can't get budget.
> > > >
> > > > Thread C will re-run queue in this case:
> > > >
> > > > Just thought scsi_mq_get_budget() does handle the case via re-run queue:
> > > >
> > > >         if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
> > > >                 blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
> > > >
> > > > So looks no such race.
> > >
> > > Thread B is holding budget and hasn't released it yet, right?  In the
> > > context of scsi, that means "device_busy >= 1", right?  So how can the
> > > code you point at help us?  When Thread C reads "device_busy" it will
> > > be 1 and that code won't run.  What did I miss?
> >
> > Oh, this is my fault, sorry for the noise.
> >
> > >
> > >
> > > > > * Finally Thread B will run again and put the budget without kicking
> > > > >   any queues.
> > > > >
> > > > > Even though the example above is with blk_mq_do_dispatch_sched() I
> > > > > believe the race is possible any time someone is holding budget but
> > > > > doesn't do work.
> > > > >
> > > > > Unfortunately, the unlikely has become more likely if you happen to be
> > > > > using the BFQ I/O scheduler.  BFQ, by design, sometimes returns "true"
> > > > > for has_work() but then NULL for dispatch_request() and stays in this
> > > > > state for a while (currently up to 9 ms).  Suddenly you only need one
> > > > > race to hit, not two races in a row.  With my current setup this is
> > > > > easy to reproduce in reboot tests and traces have actually shown that
> > > > > we hit a race similar to the one describe above.
> > > > >
> > > > > In theory we could choose to just fix blk_mq_do_dispatch_sched() to
> > > > > kick the queues when it puts budget.  That would fix the BFQ case and
> > > > > one could argue that all the other cases are just theoretical.  While
> > > > > that is true, for all the other cases it should be very uncommon to
> > > > > run into the case where we need put_budget().  Having an extra queue
> > > > > kick for safety there shouldn't affect much and keeps the race at bay.
> > > > >
> > > > > One last note is that (at least in the SCSI case) budget is shared by
> > > > > all "hctx"s that have the same queue.  Thus we need to make sure to
> > > > > kick the whole queue, not just re-run dispatching on a single "hctx".
> > > > >
> > > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > > ---
> > > > >
> > > > > Changes in v3:
> > > > > - Always kick when putting the budget.
> > > > > - Delay blk_mq_do_dispatch_sched() kick by 3 ms for inexact has_work().
> > > > > - Totally rewrote commit message.
> > > > >
> > > > > Changes in v2:
> > > > > - Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")
> > > > >
> > > > >  block/blk-mq.h | 14 +++++++++++++-
> > > > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/block/blk-mq.h b/block/blk-mq.h
> > > > > index 10bfdfb494fa..1270505367ab 100644
> > > > > --- a/block/blk-mq.h
> > > > > +++ b/block/blk-mq.h
> > > > > @@ -180,12 +180,24 @@ unsigned int blk_mq_in_flight(struct request_queue *q, struct hd_struct *part);
> > > > >  void blk_mq_in_flight_rw(struct request_queue *q, struct hd_struct *part,
> > > > >                        unsigned int inflight[2]);
> > > > >
> > > > > +#define BLK_MQ_BUDGET_DELAY  3               /* ms units */
> > > > > +
> > > > >  static inline void blk_mq_put_dispatch_budget(struct blk_mq_hw_ctx *hctx)
> > > > >  {
> > > > >       struct request_queue *q = hctx->queue;
> > > > >
> > > > > -     if (q->mq_ops->put_budget)
> > > > > +     if (q->mq_ops->put_budget) {
> > > > >               q->mq_ops->put_budget(hctx);
> > > > > +
> > > > > +             /*
> > > > > +              * The only time we call blk_mq_put_dispatch_budget() is if
> > > > > +              * we released the budget without dispatching.  Holding the
> > > > > +              * budget could have blocked any "hctx"s with the same queue
> > > > > +              * and if we didn't dispatch then there's no guarantee anyone
> > > > > +              * will kick the queue.  Kick it ourselves.
> > > > > +              */
> > > > > +             blk_mq_delay_run_hw_queues(q, BLK_MQ_BUDGET_DELAY);
> > > >
> > > > No, please don't do that un-conditionally we just need to re-run queue
> > > > when there has work to do.
> > >
> > > ...what function would you like me to call to check?  The code you
> >
> > At least we only need to call it in blk_mq_do_dispatch_sched() and
> > blk_mq_do_dispatch_ctx(), in which no request is dequeued yet. Other
> > callers can handle the run queue cause request has been there.
> 
> Sure, I can move it so it's only in blk_mq_do_dispatch_sched() and
> blk_mq_do_dispatch_ctx().  That would definitely make it so that I
> can't reproduce problems anymore, at least.
> 
> The one thing that worries me is that I couldn't come up with a
> convincing argument about why the race wasn't possible when we put the
> budget in blk_mq_dispatch_rq_list() and __blk_mq_try_issue_directly().
> Perhaps you can explain.  In blk_mq_dispatch_rq_list() I can see that
> we will call blk_mq_run_hw_queue() or blk_mq_delay_run_hw_queue(), but
> I guess I'm at least slightly worried that we'd also need to kick the
> other "hctx"s on the same queue.  In theory holding budget could have

No, if there is one request from any one hctx, when this request is
dispatched and completed, all hctxs will be run again from
scsi_end_request().



Thanks,
Ming

