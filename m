Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77897C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E50B20768
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:51:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ms63V3XE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbgFWLvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732595AbgFWLvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 07:51:02 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95027C061755
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 04:51:02 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id e2so9476820qvw.7
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 04:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=AOcZHl9tIfhWl5nHlERsjuMsiyHjKy8GNn/AvBj4YBo=;
        b=Ms63V3XEK77MImUFLGAJ1CbDYcP6LSsCrQFMjV20mm/aNsK0FaqnagV3hYJZwFVQKL
         /1jpL6PFqWqGgDQ7AbpfPhXDby6m5rrorLD3IY+B4wyi49Jxw9hPrg2ezKvn3Y425a0r
         +RbE+S3kGjwRkBxKL3IidRitKjhJS/zF5m+Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=AOcZHl9tIfhWl5nHlERsjuMsiyHjKy8GNn/AvBj4YBo=;
        b=Wpf8LBEr4UegA9I30OPYdcUsyh8pBocOW2WSnHGJCzaltUh4Vv47sVbOJaspxTaLto
         oMQ7k5fB/tpWc0AartaTDFOOXYnwS+/sLtcDnQYM+M/9PW815ZBNyPcgqBvd6ViIjZ4S
         jb3rHVRWB+vtqwvaqrQlTf+/frKSVoazkmlQ8QiCn0MDjmMNUNQ5kAdF7CN8qN4QmLiP
         naG5yAKSukYSf7cN+eL479TUhpXmoDOPs1f5njs1a+f72yDjiscLawU/pegHgKbbQkNF
         4Alk6dvvkX4YH8n49ujt3e+BW4ONz/06yyfwVk/B8baMyGEyTlrPGxl/LXpv4novbKdp
         LrQg==
X-Gm-Message-State: AOAM532ec1qjR4Q1SSfXcFbi11aoB8EPabg6E+GiNDqOqRbQaVy8MlH4
        MMawBhDaQlhZqLVqCZZiAm/im8tl8rmKMG9+fdEPyQ==
X-Google-Smtp-Source: ABdhPJwKyXywAJ7FV3/1sVYGE5qlTL1Om5jGUMARAzKJorFbuyLlGtfvOfM6N7Caz8IAXCAz7R2Wut1/reNPbBRh3eA=
X-Received: by 2002:ad4:476a:: with SMTP id d10mr13884374qvx.13.1592913061480;
 Tue, 23 Jun 2020 04:51:01 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <20200611030708.GB453671@T590> <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
 <bbdec3b3fbeb9907d2ec66a2afa56c29@mail.gmail.com> <20200615021355.GA4012@T590>
 <e49f164d867b53fd4495f1e05a85df03@mail.gmail.com> <20200616010055.GA27192@T590>
 <f9a05331a46a8c60c10e35df4aa08c45@mail.gmail.com> <67d626a6-1b7c-fbc8-24b6-8d6b6df8a7b8@suse.de>
 <20200623005518.GA843366@T590>
In-Reply-To: <20200623005518.GA843366@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgGaerxUAVTJvjECMFFU0QGrq6UsAuDJt2sC5poHDQH30JQYAZ8VPSMDEFRlXqtNvHgw
Date:   Tue, 23 Jun 2020 17:20:59 +0530
Message-ID: <3b3c83d2ea14c73561f215ba15322702@mail.gmail.com>
Subject: RE: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
To:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>
> On Mon, Jun 22, 2020 at 08:24:39AM +0200, Hannes Reinecke wrote:
> > On 6/17/20 1:26 PM, Kashyap Desai wrote:
> > > >
> > > > ->queued is increased only and not decreased just for debug
> > > > ->purpose so far, so
> > > > it can't be relied for this purpose.
> > >
> > > Thanks. I overlooked that that it is only incremental counter.
> > >
> > > >
> > > > One approach is to add one similar counter, and maintain it by
> > > scheduler's
> > > > insert/dispatch callback.
> > >
> > > I tried below  and I see performance is on expected range.
> > >
> > > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c index
> > > fdcc2c1..ea201d0 100644
> > > --- a/block/blk-mq-sched.c
> > > +++ b/block/blk-mq-sched.c
> > > @@ -485,6 +485,7 @@ void blk_mq_sched_insert_request(struct request
> > > *rq, bool at_head,
> > >
> > >                  list_add(&rq->queuelist, &list);
> > >                  e->type->ops.insert_requests(hctx, &list, at_head);
> > > +               atomic_inc(&hctx->elevator_queued);
> > >          } else {
> > >                  spin_lock(&ctx->lock);
> > >                  __blk_mq_insert_request(hctx, rq, at_head); @@
> > > -511,8 +512,10 @@ void blk_mq_sched_insert_requests(struct
> > > blk_mq_hw_ctx *hctx,
> > >          percpu_ref_get(&q->q_usage_counter);
> > >
> > >          e = hctx->queue->elevator;
> > > -       if (e && e->type->ops.insert_requests)
> > > +       if (e && e->type->ops.insert_requests) {
> > >                  e->type->ops.insert_requests(hctx, list, false);
> > > +               atomic_inc(&hctx->elevator_queued);
> > > +       }
> > >          else {
> > >                  /*
> > >                   * try to issue requests directly if the hw queue
> > > isn't diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h index
> > > 126021f..946b47a 100644
> > > --- a/block/blk-mq-sched.h
> > > +++ b/block/blk-mq-sched.h
> > > @@ -74,6 +74,13 @@ static inline bool blk_mq_sched_has_work(struct
> > > blk_mq_hw_ctx *hctx)
> > >   {
> > >          struct elevator_queue *e = hctx->queue->elevator;
> > >
> > > +       /* If current hctx has not queued any request, there is no
> > > + need to
> > > run.
> > > +        * blk_mq_run_hw_queue() on hctx which has queued IO will
handle
> > > +        * running specific hctx.
> > > +        */
> > > +       if (!atomic_read(&hctx->elevator_queued))
> > > +               return false;
> > > +
> > >          if (e && e->type->ops.has_work)
> > >                  return e->type->ops.has_work(hctx);
> > >
> > > diff --git a/block/blk-mq.c b/block/blk-mq.c index f73a2f9..48f1824
> > > 100644
> > > --- a/block/blk-mq.c
> > > +++ b/block/blk-mq.c
> > > @@ -517,8 +517,10 @@ void blk_mq_free_request(struct request *rq)
> > >          struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> > >
> > >          if (rq->rq_flags & RQF_ELVPRIV) {
> > > -               if (e && e->type->ops.finish_request)
> > > +               if (e && e->type->ops.finish_request) {
> > >                          e->type->ops.finish_request(rq);
> > > +                       atomic_dec(&hctx->elevator_queued);
> > > +               }
> > >                  if (rq->elv.icq) {
> > >                          put_io_context(rq->elv.icq->ioc);
> > >                          rq->elv.icq = NULL; @@ -2571,6 +2573,7 @@
> > > blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set
> > > *set,
> > >                  goto free_hctx;
> > >
> > >          atomic_set(&hctx->nr_active, 0);
> > > +       atomic_set(&hctx->elevator_queued, 0);
> > >          if (node == NUMA_NO_NODE)
> > >                  node = set->numa_node;
> > >          hctx->numa_node = node;
> > > diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h index
> > > 66711c7..ea1ddb1 100644
> > > --- a/include/linux/blk-mq.h
> > > +++ b/include/linux/blk-mq.h
> > > @@ -139,6 +139,10 @@ struct blk_mq_hw_ctx {
> > >           * shared across request queues.
> > >           */
> > >          atomic_t                nr_active;
> > > +       /**
> > > +        * @elevator_queued: Number of queued requests on hctx.
> > > +        */
> > > +       atomic_t                elevator_queued;
> > >
> > >          /** @cpuhp_online: List to store request if CPU is going to
die */
> > >          struct hlist_node       cpuhp_online;
> > >
> > >
> > >
> > Would it make sense to move it into the elevator itself?

I am not sure where exactly I should add this counter since I need counter
per hctx. Elevator data is per request object.
Please suggest.

>
> That is my initial suggestion, and the counter is just done for bfq &
mq-
> deadline, then we needn't to pay the cost for others.

I have updated patch -

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a1123d4..3e0005c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4640,6 +4640,12 @@ static bool bfq_has_work(struct blk_mq_hw_ctx
*hctx)
 {
        struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;

+       /* If current hctx has not queued any request, there is no need to
run.
+        * blk_mq_run_hw_queue() on hctx which has queued IO will handle
+        * running specific hctx.
+        */
+       if (!atomic_read(&hctx->elevator_queued))
+               return false;
        /*
         * Avoiding lock: a race on bfqd->busy_queues should cause at
         * most a call to dispatch for nothing
@@ -5554,6 +5561,7 @@ static void bfq_insert_requests(struct blk_mq_hw_ctx
*hctx,
                rq = list_first_entry(list, struct request, queuelist);
                list_del_init(&rq->queuelist);
                bfq_insert_request(hctx, rq, at_head);
+              atomic_inc(&hctx->elevator_queued);
        }
 }

@@ -5925,6 +5933,7 @@ static void bfq_finish_requeue_request(struct
request *rq)

        if (likely(rq->rq_flags & RQF_STARTED)) {
                unsigned long flags;
+              struct blk_mq_hw_ctx *mq_hctx = rq->mq_hctx;

                spin_lock_irqsave(&bfqd->lock, flags);

@@ -5934,6 +5943,7 @@ static void bfq_finish_requeue_request(struct
request *rq)
                bfq_completed_request(bfqq, bfqd);
                bfq_finish_requeue_request_body(bfqq);

+              atomic_dec(&hctx->elevator_queued);
                spin_unlock_irqrestore(&bfqd->lock, flags);
        } else {
                /*
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 126021f..946b47a 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -74,6 +74,13 @@ static inline bool blk_mq_sched_has_work(struct
blk_mq_hw_ctx *hctx)
 {
        struct elevator_queue *e = hctx->queue->elevator;

+       /* If current hctx has not queued any request, there is no need to
run.
+        * blk_mq_run_hw_queue() on hctx which has queued IO will handle
+        * running specific hctx.
+        */
+       if (!atomic_read(&hctx->elevator_queued))
+               return false;
+
        if (e && e->type->ops.has_work)
                return e->type->ops.has_work(hctx);

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f73a2f9..82dd152 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2571,6 +2571,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct
blk_mq_tag_set *set,
                goto free_hctx;

        atomic_set(&hctx->nr_active, 0);
+      atomic_set(&hctx->elevator_queued, 0);
        if (node == NUMA_NO_NODE)
                node = set->numa_node;
        hctx->numa_node = node;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index b57470e..703ac55 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -533,6 +533,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx
*hctx,
                rq = list_first_entry(list, struct request, queuelist);
                list_del_init(&rq->queuelist);
                dd_insert_request(hctx, rq, at_head);
+              atomic_inc(&hctx->elevator_queued);
        }
        spin_unlock(&dd->lock);
 }
@@ -562,6 +563,7 @@ static void dd_prepare_request(struct request *rq)
 static void dd_finish_request(struct request *rq)
 {
        struct request_queue *q = rq->q;
+      struct blk_mq_hw_ctx *hctx = rq->mq_hctx;

        if (blk_queue_is_zoned(q)) {
                struct deadline_data *dd = q->elevator->elevator_data;
@@ -570,15 +572,23 @@ static void dd_finish_request(struct request *rq)
                spin_lock_irqsave(&dd->zone_lock, flags);
                blk_req_zone_write_unlock(rq);
                if (!list_empty(&dd->fifo_list[WRITE]))
-                       blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
+                       blk_mq_sched_mark_restart_hctx(hctx);
                spin_unlock_irqrestore(&dd->zone_lock, flags);
        }
+       atomic_dec(&hctx->elevator_queued);
 }

 static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 {
        struct deadline_data *dd = hctx->queue->elevator->elevator_data;

+       /* If current hctx has not queued any request, there is no need to
run.
+        * blk_mq_run_hw_queue() on hctx which has queued IO will handle
+        * running specific hctx.
+        */
+       if (!atomic_read(&hctx->elevator_queued))
+               return false;
+
        return !list_empty_careful(&dd->dispatch) ||
                !list_empty_careful(&dd->fifo_list[0]) ||
                !list_empty_careful(&dd->fifo_list[1]);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 66711c7..ea1ddb1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -139,6 +139,10 @@ struct blk_mq_hw_ctx {
         * shared across request queues.
         */
        atomic_t                nr_active;
+       /**
+        * @elevator_queued: Number of queued requests on hctx.
+        */
+       atomic_t                elevator_queued;

        /** @cpuhp_online: List to store request if CPU is going to die */
        struct hlist_node       cpuhp_online;


>
> Thanks,
> Ming
