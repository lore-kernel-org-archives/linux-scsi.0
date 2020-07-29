Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C09C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA07620838
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f7/r/5RL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgG2Sb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2Sb0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:31:26 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2EC0619D2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 11:31:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id g26so23235859qka.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 11:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=pyYdnxXoYtviXWOBeIb8J7LIjti14p/YvqpeLM4RqxU=;
        b=f7/r/5RLryVxjmFbu+Je4ewLJK0nGeZRZ1I4bzK/oXBBac9ppTRkjjyzoztaP+TZYe
         WZ4TRvVN6QgqWS9KcGCCimHZh95Gg7YSBRajOK3C690HRUEMeGTdqXnNoVwVYedAPpEw
         OsplV3b9dNwM/s8fjBM4dmBYC3BR0JGLK71Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=pyYdnxXoYtviXWOBeIb8J7LIjti14p/YvqpeLM4RqxU=;
        b=kt3ih8ZkHvkuIQOBeMHS2y5Ik8Lksa+mSb4HSgBoHz+ij+1/55KhwMvKjl7nGr7iko
         SIoLhAkGeqNKbJEJoMuXkGvEEfQkR2mA9dqMUHfrIRuCtGrt0WSkihnzlfvPMULKTRbG
         MsXv6/3xUAiKxiEvKME/nDE/E0WhN5X8s2z/rYN+7/3Wq7sdgnzexkXYRM/7qv3206xu
         dAIln9KSlNsforg7319ZC7HjBWwvMGu0wl/c4LBgoTPJ4MTp78MEUjLCY7oXXJWC3V1N
         W0w0v+hMMskMkz5yARaEpPPxJ1Gex6nNUWPw6SGDVeTIXJLJ2i4W6lvZ2vFWUY69ieDz
         ykIA==
X-Gm-Message-State: AOAM531RWf8IQTH0YYerxyD2vvTjZBFokivlJH/3CEi29T2H9lD85ZPo
        Dehs93kURgr104kvNlrmXjtNJDrvNWVRne9abOA/JA==
X-Google-Smtp-Source: ABdhPJx2aNoKqfw5fVGntXgc/RYi1viLbdi6yqObU1P3EtGrONiLeLUzLT1H3RwFSu5YUJG9VJ3G9JQ50YlrAUl5hSo=
X-Received: by 2002:ae9:e507:: with SMTP id w7mr33994809qkf.264.1596047485412;
 Wed, 29 Jul 2020 11:31:25 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200722041201.GA912316@T590> <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590> <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590> <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590> <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590> <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590>
In-Reply-To: <20200729153648.GA1698748@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJCvD/hZEpycfSbmqCxmdJyJD/+0AJR+kyNAmYRZaIBRnYqfAIxGEBSAFn9B+MBP/jicgD9MwXwAyMjvw0CEOgTfwH/A0ecp7ZdvrA=
Date:   Thu, 30 Jul 2020 00:01:22 +0530
Message-ID: <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Ming Lei <ming.lei@redhat.com>
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

> > >
> > > Another update is that V4 of 'scsi: core: only re-run queue in
> > > scsi_end_request() if device queue is busy' is quite hard to
> > > implement
> > since
> > > commit b4fd63f42647110c9 ("Revert "scsi: core: run queue if SCSI
> > > device queue isn't ready and queue is idle").
> >
> > Ming -
> >
> > Update from my testing. I found only one case of IO stall. I can
> > discuss this specific topic if you like to send separate patch. It is
> > too much interleaved discussion in this thread.
> >
> > I noted you mentioned that V4 of 'scsi: core: only re-run queue in
> > scsi_end_request() if device queue is busy' need underlying support of
> > "scsi: core: run queue if SCSI device queue isn't ready and queue is
idle"
> > patch which is already reverted in mainline.
>
> Right.
>
> > Overall idea of running h/w queues conditionally in your patch " scsi:
> > core: only re-run queue in scsi_end_request" is still worth. There can
> > be
>
> I agree.
>
> > some race if we use this patch and for that you have concern. Am I
> > correct. ?
>
> If the patch of "scsi: core: run queue if SCSI device queue isn't ready
and queue
> is idle" is re-added, the approach should work.
I could not find issue in " scsi: core: only re-run queue in
scsi_end_request" even though above mentioned patch is reverted.
There may be some corner cases/race condition in submission path which can
be fixed doing self-restart of h/w queue.

> However, it looks a bit
> complicated, and I was thinking if one simpler approach can be figured
out.

I was thinking your original approach is simple, but if you think some
other simple approach I can test as part of these series.
BTW, I am still not getting why you think your original approach is not
good design.

>
> >
> > One of the race I found in my testing is fixed by below patch -
> >
> > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c index
> > 54f9015..bcfd33a 100644
> > --- a/block/blk-mq-sched.c
> > +++ b/block/blk-mq-sched.c
> > @@ -173,8 +173,10 @@ static int blk_mq_do_dispatch_ctx(struct
> > blk_mq_hw_ctx *hctx)
> >                 if (!sbitmap_any_bit_set(&hctx->ctx_map))
> >                         break;
> >
> > -               if (!blk_mq_get_dispatch_budget(hctx))
> > +               if (!blk_mq_get_dispatch_budget(hctx)) {
> > +                       blk_mq_delay_run_hw_queue(hctx,
> > BLK_MQ_BUDGET_DELAY);
> >                         break;
> > +               }
>
> Actually all hw queues need to be run, instead of this hctx, cause the
budget
> stuff is request queue wide.


OK. But I thought all the hctx will see issue independently, if they are
active and they will restart its own hctx queue.
BTW, do you think above handling in block layer code make sense
irrespective of current h/w queue restart logic OR it is just relative
stuffs ?

>
> >
> >                 rq = blk_mq_dequeue_from_ctx(hctx, ctx);
> >                 if (!rq) {
> >
> >
> > In my test setup, I have your V3 'scsi: core: only re-run queue in
> > scsi_end_request() if device queue is busy' rebased on 5.8 which does
> > not have
> > "scsi: core: run queue if SCSI device queue isn't ready and queue is
idle"
> > since it is already reverted in mainline.
>
> If you added the above patch, I believe you can remove the run queue in
> scsi_end_request() unconditionally. However, the delay run queue may
> degrade io performance.

I understood.  But that performance issue is due to budget contention and
may impact some old HBA(less queue depth) or emulation HBA.
That is why I thought your patch of conditional h/w run from completion
would improve performance.

>
> Actually the re-run queue in scsi_end_request() is only for dequeuing
request
> from sw/scheduler queue. And no such issue if request stays in
> hctx->dispatch list.

I was not aware of this. Thanks for info.  I will review the code for my
own understanding.
>
> >
> > I have 24 SAS SSD and I reduced QD = 16 so that I hit budget
> > contention frequently.  I am running ioscheduler=none.
> > If hctx0 has 16 IO inflight (All those IO will be posted to h/q queue
> > directly). Next IO (17th IO) will see budget contention and it will be
> > queued into s/w queue.
> > It is expected that queue will be kicked from scsi_end_request. It is
> > possible that one of the  IO completed and it reduce
> > sdev->device_busy, but it has not yet reach the code which will kicked
the
> h/w queue.
> > Releasing budget and restarting h/w queue is not atomic. At the same
> > time, another IO (18th IO) from submission path get the budget and it
> > will be posted from below path. This IO will reset sdev->restart and
> > it will not allow h/w queue to be restarted from completion path. This
> > will lead one
>
> Maybe re-run queue is needed before resetting sdev->restart if
sdev->restart
> is 1.

Agree.

>
>
> Thanks,
> Ming
