Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4FAC2BA1E
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 09:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08EDC2054F
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 09:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5N6Zz2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgDEJPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 05:15:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbgDEJPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2020 05:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586078110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wec/vqv73hEsPDDrYN9Jlyzp12r1uEhEmr4QrwDkfL0=;
        b=g5N6Zz2x9GmB08HAJSr0xo9jqF+gCLa/na3Smqex+3yy8DZR7CGHKu0uc3gWp88r6bGeJ4
        UO8g0ttZUVfWg+OF76v7KkkCCodXFOgQfDG8ZJzU9BVxA/DKHFpuY4n22u+i8jOclB97RA
        UEzcQtRJmyAQXxoAfUm2QpIx9fnwx6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-Pz_XGH5uMB2z1gYApQFZPg-1; Sun, 05 Apr 2020 05:15:06 -0400
X-MC-Unique: Pz_XGH5uMB2z1gYApQFZPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C96E98017F3;
        Sun,  5 Apr 2020 09:15:03 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 171345DA2C;
        Sun,  5 Apr 2020 09:14:51 +0000 (UTC)
Date:   Sun, 5 Apr 2020 17:14:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Doug Anderson <dianders@chromium.org>
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
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget
 contention
Message-ID: <20200405091446.GA3421@localhost.localdomain>
References: <20200402155130.8264-1-dianders@chromium.org>
 <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200403013356.GA6987@ming.t460p>
 <CAD=FV=Ub6zhVvTj79SWPUv19RDvD0gt5EjJV-FZSbYxUy_T1OA@mail.gmail.com>
 <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Vsk0SjkA+DbUwJxvO6NFcr0CO9=H1FD7okJ2PxMt5pYA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 03, 2020 at 08:49:54AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Fri, Apr 3, 2020 at 8:10 AM Doug Anderson <dianders@chromium.org> wrote:
> >
> > Correct that it only happens with BFQ, but whether it's a BFQ bug or
> > not just depends on how you define the has_work() API.  If has_work()
> > is allowed to be in-exact then it's either a blk-mq bug or a SCSI bug
> > depending on how you cut it.  If has_work() must be exact then it is
> > certainly a BFQ bug.  If has_work() doesn't need to be exact then it's
> > not a BFQ bug.  I believe that a sane API could be defined either way.
> > Either has_work() can be defined as a lightweight hint to trigger
> > heavier code or it can be defined as something exact.  It's really up
> > to blk-mq to say how they define it.
> >
> > From his response on the SCSI patch [1], it sounded like Jens was OK
> > with has_work() being a lightweight hint as long as BFQ ensures that
> > the queues run later.  ...but, as my investigation found, I believe
> > that BFQ _does_ try to ensure that the queue is run at a later time by
> > calling blk_mq_run_hw_queues().  The irony is that due to the race
> > we're talking about here, blk_mq_run_hw_queues() isn't guaranteed to
> > be reliable if has_work() is inexact.  :(  One way to address this is
> > to make blk_mq_run_hw_queues() reliable even if has_work() is inexact.
> >
> > ...so Jens: care to clarify how you'd like has_work() to be defined?
> 
> Sorry to reply so quickly after my prior reply, but I might have found
> an extreme corner case where we can still run into the same race even
> if has_work() is exact.  This is all theoretical from code analysis.
> Maybe you can poke a hole in my scenario or tell me it's so
> implausible that we don't care, but it seems like it's theoretically
> possible.  For this example I'll assume a budget of 1 (AKA only one
> thread can get budget for a given queue):
> 
> * Threads A and B both run has_work() at the same time with the same
>   "hctx".  has_work() is exact but there's no lock, so it's OK if
>   Thread A and B both get back true.
> 
> * Thread B gets interrupted for a long time right after it decides
>   that there is work.  Maybe its CPU gets an interrupt and the
>   interrupt handler is slow.
> 
> * Thread A runs, get budget, dispatches work.
> 
> * Thread A's work finishes and budget is released.
> 
> * Thread B finally runs again and gets budget.
> 
> * Since Thread A already took care of the work and no new work has
>   come in, Thread B will get NULL from dispatch_request().  I believe
>   this is specifically why dispatch_request() is allowed to return
>   NULL in the first place if has_work() must be exact.
> 
> * Thread B will now be holding the budget and is about to call
>   put_budget(), but hasn't called it yet.
> 
> * Thread B gets interrupted for a long time (again).  Dang interrupts.
> 
> * Now Thread C (with a different "hctx" but the same queue) comes
>   along and runs blk_mq_do_dispatch_sched().
> 
> * Thread C won't do anything because it can't get budget.
> 
> * Finally Thread B will run again and put the budget without kicking
>   any queues.
> 
> Now we have a potential I/O stall because nobody will ever kick the
> queues.
> 
> 
> I think the above example could happen even on non-BFQ systems and I
> think it would also be fixed by an approach like the one in my patch.

OK, looks it isn't specific on BFQ any more.

Follows another candidate approach for this issue, given it is so hard
to trigger, we can make it more reliable by rerun queue when has_work()
returns true after ops->dispath_request() returns NULL.

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 74cedea56034..4408e5d4fcd8 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -80,6 +80,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
        blk_mq_run_hw_queue(hctx, true);
 }

+#define BLK_MQ_BUDGET_DELAY    3               /* ms units */
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
@@ -103,6 +104,9 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
                rq = e->type->ops.dispatch_request(hctx);
                if (!rq) {
                        blk_mq_put_dispatch_budget(hctx);
+
+                       if (e->type->ops.has_work && e->type->ops.has_work(hctx))
+                               blk_mq_delay_run_hw_queue(hctx, BLK_MQ_BUDGET_DELAY);
                        break;
                }


Thanks, 
Ming

