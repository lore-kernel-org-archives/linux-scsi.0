Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFABC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 00:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634072070E
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 00:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZKg5gTm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgFWA4T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 20:56:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42266 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732403AbgFWA4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 20:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592873746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9reJZXYhkiCIkcK6uyVv3pjja9WpM+51hYLbTX+7Xs=;
        b=AZKg5gTmf8TdSQB6fxblrmCt5dHOgHBT4J5ilx2CEKGhqMHlSou6uDrMb2cnmWIm99cqfq
        Tp5NskZDvFtj3gEMTwEnAsa68VHSGIY7oPtrWFZ+QJnri56ZEJpW6FdUeo59a//ElPZwgF
        MwRqfvtpnup0ik/RM6cMEbz00JV4eV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-XVq_4UbCNxWWdKAn_0ospg-1; Mon, 22 Jun 2020 20:55:41 -0400
X-MC-Unique: XVq_4UbCNxWWdKAn_0ospg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B50CE107ACCA;
        Tue, 23 Jun 2020 00:55:38 +0000 (UTC)
Received: from T590 (ovpn-12-189.pek2.redhat.com [10.72.12.189])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8227A512FE;
        Tue, 23 Jun 2020 00:55:23 +0000 (UTC)
Date:   Tue, 23 Jun 2020 08:55:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
Message-ID: <20200623005518.GA843366@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <20200611030708.GB453671@T590>
 <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
 <bbdec3b3fbeb9907d2ec66a2afa56c29@mail.gmail.com>
 <20200615021355.GA4012@T590>
 <e49f164d867b53fd4495f1e05a85df03@mail.gmail.com>
 <20200616010055.GA27192@T590>
 <f9a05331a46a8c60c10e35df4aa08c45@mail.gmail.com>
 <67d626a6-1b7c-fbc8-24b6-8d6b6df8a7b8@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67d626a6-1b7c-fbc8-24b6-8d6b6df8a7b8@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 22, 2020 at 08:24:39AM +0200, Hannes Reinecke wrote:
> On 6/17/20 1:26 PM, Kashyap Desai wrote:
> > > 
> > > ->queued is increased only and not decreased just for debug purpose so
> > > ->far, so
> > > it can't be relied for this purpose.
> > 
> > Thanks. I overlooked that that it is only incremental counter.
> > 
> > > 
> > > One approach is to add one similar counter, and maintain it by
> > scheduler's
> > > insert/dispatch callback.
> > 
> > I tried below  and I see performance is on expected range.
> > 
> > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> > index fdcc2c1..ea201d0 100644
> > --- a/block/blk-mq-sched.c
> > +++ b/block/blk-mq-sched.c
> > @@ -485,6 +485,7 @@ void blk_mq_sched_insert_request(struct request *rq,
> > bool at_head,
> > 
> >                  list_add(&rq->queuelist, &list);
> >                  e->type->ops.insert_requests(hctx, &list, at_head);
> > +               atomic_inc(&hctx->elevator_queued);
> >          } else {
> >                  spin_lock(&ctx->lock);
> >                  __blk_mq_insert_request(hctx, rq, at_head);
> > @@ -511,8 +512,10 @@ void blk_mq_sched_insert_requests(struct
> > blk_mq_hw_ctx *hctx,
> >          percpu_ref_get(&q->q_usage_counter);
> > 
> >          e = hctx->queue->elevator;
> > -       if (e && e->type->ops.insert_requests)
> > +       if (e && e->type->ops.insert_requests) {
> >                  e->type->ops.insert_requests(hctx, list, false);
> > +               atomic_inc(&hctx->elevator_queued);
> > +       }
> >          else {
> >                  /*
> >                   * try to issue requests directly if the hw queue isn't
> > diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
> > index 126021f..946b47a 100644
> > --- a/block/blk-mq-sched.h
> > +++ b/block/blk-mq-sched.h
> > @@ -74,6 +74,13 @@ static inline bool blk_mq_sched_has_work(struct
> > blk_mq_hw_ctx *hctx)
> >   {
> >          struct elevator_queue *e = hctx->queue->elevator;
> > 
> > +       /* If current hctx has not queued any request, there is no need to
> > run.
> > +        * blk_mq_run_hw_queue() on hctx which has queued IO will handle
> > +        * running specific hctx.
> > +        */
> > +       if (!atomic_read(&hctx->elevator_queued))
> > +               return false;
> > +
> >          if (e && e->type->ops.has_work)
> >                  return e->type->ops.has_work(hctx);
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index f73a2f9..48f1824 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -517,8 +517,10 @@ void blk_mq_free_request(struct request *rq)
> >          struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> > 
> >          if (rq->rq_flags & RQF_ELVPRIV) {
> > -               if (e && e->type->ops.finish_request)
> > +               if (e && e->type->ops.finish_request) {
> >                          e->type->ops.finish_request(rq);
> > +                       atomic_dec(&hctx->elevator_queued);
> > +               }
> >                  if (rq->elv.icq) {
> >                          put_io_context(rq->elv.icq->ioc);
> >                          rq->elv.icq = NULL;
> > @@ -2571,6 +2573,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct
> > blk_mq_tag_set *set,
> >                  goto free_hctx;
> > 
> >          atomic_set(&hctx->nr_active, 0);
> > +       atomic_set(&hctx->elevator_queued, 0);
> >          if (node == NUMA_NO_NODE)
> >                  node = set->numa_node;
> >          hctx->numa_node = node;
> > diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> > index 66711c7..ea1ddb1 100644
> > --- a/include/linux/blk-mq.h
> > +++ b/include/linux/blk-mq.h
> > @@ -139,6 +139,10 @@ struct blk_mq_hw_ctx {
> >           * shared across request queues.
> >           */
> >          atomic_t                nr_active;
> > +       /**
> > +        * @elevator_queued: Number of queued requests on hctx.
> > +        */
> > +       atomic_t                elevator_queued;
> > 
> >          /** @cpuhp_online: List to store request if CPU is going to die */
> >          struct hlist_node       cpuhp_online;
> > 
> > 
> > 
> Would it make sense to move it into the elevator itself?

That is my initial suggestion, and the counter is just done for bfq &
mq-deadline, then we needn't to pay the cost for others.

Thanks,
Ming

