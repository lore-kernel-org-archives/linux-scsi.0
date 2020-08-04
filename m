Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4ABBC433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 08:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBBB22C9F
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 08:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+5f3Yiz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgHDIgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 04:36:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726058AbgHDIgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 04:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596530207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PvHLEyqPF58gllxf68+mp7qSyk5x+qOWpmVkDZ2ceKE=;
        b=I+5f3YizZPH+smQau5I6pF7nEMyCAXPhFmDfR/q8D9O0uEcm+/JBQYZVHB2mO6gbaf9lC9
        /nhnn3TcOPCXKw2WfNCabzphyW9hYIdI+H+79nNshtCP7k3TGH3kqsLV1daBqXj/NoiCGF
        6vwx5E7EGjsdy/473NKG+ckxo+RmOQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-24c-b3JnOYGWCBJH_-k3Tg-1; Tue, 04 Aug 2020 04:36:43 -0400
X-MC-Unique: 24c-b3JnOYGWCBJH_-k3Tg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB94C8017FB;
        Tue,  4 Aug 2020 08:36:40 +0000 (UTC)
Received: from T590 (ovpn-13-169.pek2.redhat.com [10.72.13.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FB2410013C4;
        Tue,  4 Aug 2020 08:36:29 +0000 (UTC)
Date:   Tue, 4 Aug 2020 16:36:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200804083625.GA1958244@T590>
References: <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
 <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590>
 <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2020 at 12:01:22AM +0530, Kashyap Desai wrote:
> > > >
> > > > Another update is that V4 of 'scsi: core: only re-run queue in
> > > > scsi_end_request() if device queue is busy' is quite hard to
> > > > implement
> > > since
> > > > commit b4fd63f42647110c9 ("Revert "scsi: core: run queue if SCSI
> > > > device queue isn't ready and queue is idle").
> > >
> > > Ming -
> > >
> > > Update from my testing. I found only one case of IO stall. I can
> > > discuss this specific topic if you like to send separate patch. It is
> > > too much interleaved discussion in this thread.
> > >
> > > I noted you mentioned that V4 of 'scsi: core: only re-run queue in
> > > scsi_end_request() if device queue is busy' need underlying support of
> > > "scsi: core: run queue if SCSI device queue isn't ready and queue is
> idle"
> > > patch which is already reverted in mainline.
> >
> > Right.
> >
> > > Overall idea of running h/w queues conditionally in your patch " scsi:
> > > core: only re-run queue in scsi_end_request" is still worth. There can
> > > be
> >
> > I agree.
> >
> > > some race if we use this patch and for that you have concern. Am I
> > > correct. ?
> >
> > If the patch of "scsi: core: run queue if SCSI device queue isn't ready
> and queue
> > is idle" is re-added, the approach should work.
> I could not find issue in " scsi: core: only re-run queue in
> scsi_end_request" even though above mentioned patch is reverted.
> There may be some corner cases/race condition in submission path which can
> be fixed doing self-restart of h/w queue.

It is because two corner cases are handled in other ways:

    Now that we have the patches ("blk-mq: In blk_mq_dispatch_rq_list()
    "no budget" is a reason to kick") and ("blk-mq: Rerun dispatching in
    the case of budget contention") we should no longer need the fix in
    the SCSI code.  Revert it, resolving conflicts with other patches that
    have touched this code.

> 
> > However, it looks a bit
> > complicated, and I was thinking if one simpler approach can be figured
> out.
> 
> I was thinking your original approach is simple, but if you think some
> other simple approach I can test as part of these series.
> BTW, I am still not getting why you think your original approach is not
> good design.

It is still not straightforward enough or simple enough for proving its
correctness, even though the implementation isn't complicated.

> 
> >
> > >
> > > One of the race I found in my testing is fixed by below patch -
> > >
> > > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c index
> > > 54f9015..bcfd33a 100644
> > > --- a/block/blk-mq-sched.c
> > > +++ b/block/blk-mq-sched.c
> > > @@ -173,8 +173,10 @@ static int blk_mq_do_dispatch_ctx(struct
> > > blk_mq_hw_ctx *hctx)
> > >                 if (!sbitmap_any_bit_set(&hctx->ctx_map))
> > >                         break;
> > >
> > > -               if (!blk_mq_get_dispatch_budget(hctx))
> > > +               if (!blk_mq_get_dispatch_budget(hctx)) {
> > > +                       blk_mq_delay_run_hw_queue(hctx,
> > > BLK_MQ_BUDGET_DELAY);
> > >                         break;
> > > +               }
> >
> > Actually all hw queues need to be run, instead of this hctx, cause the
> budget
> > stuff is request queue wide.
> 
> 
> OK. But I thought all the hctx will see issue independently, if they are
> active and they will restart its own hctx queue.
> BTW, do you think above handling in block layer code make sense
> irrespective of current h/w queue restart logic OR it is just relative
> stuffs ?

You are right, it is correct to just run this hctx.

> 
> >
> > >
> > >                 rq = blk_mq_dequeue_from_ctx(hctx, ctx);
> > >                 if (!rq) {
> > >
> > >
> > > In my test setup, I have your V3 'scsi: core: only re-run queue in
> > > scsi_end_request() if device queue is busy' rebased on 5.8 which does
> > > not have
> > > "scsi: core: run queue if SCSI device queue isn't ready and queue is
> idle"
> > > since it is already reverted in mainline.
> >
> > If you added the above patch, I believe you can remove the run queue in
> > scsi_end_request() unconditionally. However, the delay run queue may
> > degrade io performance.
> 
> I understood.  But that performance issue is due to budget contention and
> may impact some old HBA(less queue depth) or emulation HBA.

Your patch for delay running hw queue causes delay once one request
is completed, and the queue should have been run immediately after one
request is finished.

> That is why I thought your patch of conditional h/w run from completion
> would improve performance.

Yeah, we all think that way is correct thing to do, and now the problem
is how to run hw queue just in case of budget contention.


thanks, 
Ming

