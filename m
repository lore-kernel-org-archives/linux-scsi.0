Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6B1C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE87120786
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 05:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ao/vKHAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgG2FZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 01:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgG2FZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 01:25:26 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB3C0619D2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 22:25:25 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id o2so10283451qvk.6
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 22:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=7qdybzT7G9H4eBTr8EVSTA5aHX7B/EHAbYUwJ0eNMW0=;
        b=Ao/vKHAmRm83dhIz643VeTD2ECgoTN8GyiiY+JCIy4SBCn+UVi2aPzU1L7iTod/rp8
         NpEIogqxeumT7kNBCEgUs8+90s25aPnOWy3oYMxmYW+6fTWtQE+RvlzmbtcwyyV+ZRzU
         NP88kGAcYcb9ppUVUjudUTMlmibg5RaYlEP1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=7qdybzT7G9H4eBTr8EVSTA5aHX7B/EHAbYUwJ0eNMW0=;
        b=dXENZI8RJUMUeZNzhNMN4/mrfVlgNt+pDwAfwceMLv96gKg6IfCE1HQG/hAhPwCdTS
         rsdx+j5xh+w9Hae9wyXgRUNqOdlVSo9aLduYLkAdItM+4pteFMabUvdFkPlAygI8kWKR
         O9Oo1ws+TH2BoZw8h1WGDCgrCObdjlDteK7Lb9GSnW+Ls6QSDK/q0GMvjfRIogNCa2BX
         2EslnPKL6QQa8ycRbWMNRmIcDKroOwV7mpKBSLnwgOFoaDsph/kboQKS+30rvR92+afU
         ihui39fLndQdlMmJiAtHdf1ssQL6PqfxjhHquYBBSp/kX55kA0OJFxiZWHBbJbCmJGjm
         MSuQ==
X-Gm-Message-State: AOAM530nOJh7cMQrr2TA3AH+DruDXPCL1Ftlz58ZY2RS9TJU0+y5Ge2u
        H6TOuTMVHmZva3DKF1hz2nHir5LSbg18cbKqpPGSsQ==
X-Google-Smtp-Source: ABdhPJyiwvpSDFexsu/7IHoavsN174eiGxhrJj3+bFTDBIiGbBmN+WpvtqudlB7TabwSyMqHcINlUgpEU/+fhqGz1Pg=
X-Received: by 2002:a0c:f14d:: with SMTP id y13mr8944119qvl.136.1596000324809;
 Tue, 28 Jul 2020 22:25:24 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200721011323.GA833377@T590> <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
 <20200722041201.GA912316@T590> <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590> <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590> <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590> <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
In-Reply-To: <20200728084511.GA1326626@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQNTX/rU6Hw5wsVT3rHynNyPzV5V/AGRP9A4AkK8P+ECUfpMjQJmEWWiAUZ2KnwCMRhAUgBZ/QfjAT/44nIA/TMF8AMjI78NpZYU8OA=
Date:   Wed, 29 Jul 2020 10:55:22 +0530
Message-ID: <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
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

> On Tue, Jul 28, 2020 at 08:54:27AM +0100, John Garry wrote:
> > On 24/07/2020 03:47, Ming Lei wrote:
> > > On Thu, Jul 23, 2020 at 06:29:01PM +0100, John Garry wrote:
> > > > > > As I see, since megaraid will have 1:1 mapping of CPU to hw
> > > > > > queue, will there only ever possibly a single bit set in
> > > > > > ctx_map? If so, it seems a waste to always check every sbitmap
> > > > > > map. But adding logic for this may negate any possible gains.
> > > > >
> > > > > It really depends on min and max cpu id in the map, then sbitmap
> > > > > depth can be reduced to (max - min + 1). I'd suggest to double
> > > > > check that cost of sbitmap_any_bit_set() really matters.
> > > >
> > > > Hi Ming,
> > > >
> > > > I'm not sure that reducing the search range would help much, as we
> > > > still need to load some indexes of map[], and at best this may be
> > > > reduced from 2/3
> > > > -> 1 elements, depending on nr_cpus.
> > >
> > > I believe you misunderstood my idea, and you have to think it from
> > > implementation viewpoint.
> > >
> > > The only workable way is to store the min cpu id as 'offset' and set
> > > the sbitmap depth as (max - min + 1), isn't it? Then the actual cpu
> > > id can be figured out via 'offset' + nr_bit. And the whole indexes
> > > are just spread on the actual depth. BTW, max & min is the max / min
> > > cpu id in hctx->cpu_map. So we can improve not only on 1:1, and I
> > > guess most of MQ cases can benefit from the change, since it
shouldn't be
> usual for one ctx_map to cover both 0 & nr_cpu_id - 1.
> > >
> > > Meantime, we need to allocate the sbitmap dynamically.
> >
> > OK, so dynamically allocating the sbitmap could be good. I was
> > thinking previously that we still allocate for nr_cpus size, and
> > search a limited range - but this would have heavier runtime overhead.
> >
> > So if you really think that this may have some value, then let me
> > know, so we can look to take it forward.
>
> Forget to mention, the in-tree code has been this shape for long time,
please
> see sbitmap_resize() called from blk_mq_map_swqueue().
>
> Another update is that V4 of 'scsi: core: only re-run queue in
> scsi_end_request() if device queue is busy' is quite hard to implement
since
> commit b4fd63f42647110c9 ("Revert "scsi: core: run queue if SCSI device
> queue isn't ready and queue is idle").

Ming -

Update from my testing. I found only one case of IO stall. I can discuss
this specific topic if you like to send separate patch. It is too much
interleaved discussion in this thread.

I noted you mentioned that V4 of 'scsi: core: only re-run queue in
scsi_end_request() if device queue is busy' need underlying support of
"scsi: core: run queue if SCSI device queue isn't ready and queue is idle"
patch which is already reverted in mainline.
Overall idea of running h/w queues conditionally in your patch " scsi:
core: only re-run queue in scsi_end_request" is still worth. There can be
some race if we use this patch and for that you have concern. Am I
correct. ?

One of the race I found in my testing is fixed by below patch -

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 54f9015..bcfd33a 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -173,8 +173,10 @@ static int blk_mq_do_dispatch_ctx(struct
blk_mq_hw_ctx *hctx)
                if (!sbitmap_any_bit_set(&hctx->ctx_map))
                        break;

-               if (!blk_mq_get_dispatch_budget(hctx))
+               if (!blk_mq_get_dispatch_budget(hctx)) {
+                       blk_mq_delay_run_hw_queue(hctx,
BLK_MQ_BUDGET_DELAY);
                        break;
+               }

                rq = blk_mq_dequeue_from_ctx(hctx, ctx);
                if (!rq) {


In my test setup, I have your V3 'scsi: core: only re-run queue in
scsi_end_request() if device queue is busy' rebased on 5.8 which does not
have
"scsi: core: run queue if SCSI device queue isn't ready and queue is idle"
since it is already reverted in mainline.

I have 24 SAS SSD and I reduced QD = 16 so that I hit budget contention
frequently.  I am running ioscheduler=none.
If hctx0 has 16 IO inflight (All those IO will be posted to h/q queue
directly). Next IO (17th IO) will see budget contention and it will be
queued into s/w queue.
It is expected that queue will be kicked from scsi_end_request. It is
possible that one of the  IO completed and it reduce sdev->device_busy,
but it has not yet reach the code which will kicked the h/w queue.
Releasing budget and restarting h/w queue is not atomic. At the same time,
another IO (18th IO) from submission path get the budget and it will be
posted from below path. This IO will reset sdev->restart and it will not
allow h/w queue to be restarted from completion path. This will lead one
IO in s/w queue pending forever if there are no more new IOs.
blk_mq_sched_insert_requests
	->blk_mq_try_issue_list_directly().

I found that overall idea and attempt in recent block layer code is to
restart h/w queue from submission path in delayed context.
Making it less dependent on queue restart from completion path and/or even
though completion path restart the queue, there are certain race in
submission path which must be fixed by self-restarting h/w queue.

If we catch all such instances in submission path (as posted above in my
patch), we can still consider your patch
'scsi: core: only re-run queue in scsi_end_request() if device queue is
busy'.

Thanks, Kashyap

>
>
> Thanks,
> Ming
