Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9155BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A3D207E8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGF60ejL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgG2PhQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 11:37:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57323 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgG2PhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 11:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596037033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fPRpG/H7hHYAATuafL5QdtVTE4iZHh44pRmHLhmCbY4=;
        b=NGF60ejL4zUNDVhr6GuVfxLYsXyh/OQszI1R0BkhRAYe5adAi1XJLYg2NjNnKlZTM+G7md
        AzgnPUTHM+JJlXI2RUmfixC2nOeiVNXbrYF48lMOJVgdm2ivEeSGez1QRdxCrGnbsP0o/H
        gQJ4HbuEUKDZLMM3SXiOH0nwDq15tmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-O44GsqeYOTyVpqbKPVNR5g-1; Wed, 29 Jul 2020 11:37:11 -0400
X-MC-Unique: O44GsqeYOTyVpqbKPVNR5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C903518A81A2;
        Wed, 29 Jul 2020 15:37:07 +0000 (UTC)
Received: from T590 (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B1FD7192C;
        Wed, 29 Jul 2020 15:36:52 +0000 (UTC)
Date:   Wed, 29 Jul 2020 23:36:48 +0800
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
Message-ID: <20200729153648.GA1698748@T590>
References: <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
 <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 29, 2020 at 10:55:22AM +0530, Kashyap Desai wrote:
> > On Tue, Jul 28, 2020 at 08:54:27AM +0100, John Garry wrote:
> > > On 24/07/2020 03:47, Ming Lei wrote:
> > > > On Thu, Jul 23, 2020 at 06:29:01PM +0100, John Garry wrote:
> > > > > > > As I see, since megaraid will have 1:1 mapping of CPU to hw
> > > > > > > queue, will there only ever possibly a single bit set in
> > > > > > > ctx_map? If so, it seems a waste to always check every sbitmap
> > > > > > > map. But adding logic for this may negate any possible gains.
> > > > > >
> > > > > > It really depends on min and max cpu id in the map, then sbitmap
> > > > > > depth can be reduced to (max - min + 1). I'd suggest to double
> > > > > > check that cost of sbitmap_any_bit_set() really matters.
> > > > >
> > > > > Hi Ming,
> > > > >
> > > > > I'm not sure that reducing the search range would help much, as we
> > > > > still need to load some indexes of map[], and at best this may be
> > > > > reduced from 2/3
> > > > > -> 1 elements, depending on nr_cpus.
> > > >
> > > > I believe you misunderstood my idea, and you have to think it from
> > > > implementation viewpoint.
> > > >
> > > > The only workable way is to store the min cpu id as 'offset' and set
> > > > the sbitmap depth as (max - min + 1), isn't it? Then the actual cpu
> > > > id can be figured out via 'offset' + nr_bit. And the whole indexes
> > > > are just spread on the actual depth. BTW, max & min is the max / min
> > > > cpu id in hctx->cpu_map. So we can improve not only on 1:1, and I
> > > > guess most of MQ cases can benefit from the change, since it
> shouldn't be
> > usual for one ctx_map to cover both 0 & nr_cpu_id - 1.
> > > >
> > > > Meantime, we need to allocate the sbitmap dynamically.
> > >
> > > OK, so dynamically allocating the sbitmap could be good. I was
> > > thinking previously that we still allocate for nr_cpus size, and
> > > search a limited range - but this would have heavier runtime overhead.
> > >
> > > So if you really think that this may have some value, then let me
> > > know, so we can look to take it forward.
> >
> > Forget to mention, the in-tree code has been this shape for long time,
> please
> > see sbitmap_resize() called from blk_mq_map_swqueue().
> >
> > Another update is that V4 of 'scsi: core: only re-run queue in
> > scsi_end_request() if device queue is busy' is quite hard to implement
> since
> > commit b4fd63f42647110c9 ("Revert "scsi: core: run queue if SCSI device
> > queue isn't ready and queue is idle").
> 
> Ming -
> 
> Update from my testing. I found only one case of IO stall. I can discuss
> this specific topic if you like to send separate patch. It is too much
> interleaved discussion in this thread.
> 
> I noted you mentioned that V4 of 'scsi: core: only re-run queue in
> scsi_end_request() if device queue is busy' need underlying support of
> "scsi: core: run queue if SCSI device queue isn't ready and queue is idle"
> patch which is already reverted in mainline.

Right.

> Overall idea of running h/w queues conditionally in your patch " scsi:
> core: only re-run queue in scsi_end_request" is still worth. There can be

I agree.

> some race if we use this patch and for that you have concern. Am I
> correct. ?

If the patch of "scsi: core: run queue if SCSI device queue isn't ready and
queue is idle" is re-added, the approach should work. However, it looks a bit
complicated, and I was thinking if one simpler approach can be figured out.

> 
> One of the race I found in my testing is fixed by below patch -
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 54f9015..bcfd33a 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -173,8 +173,10 @@ static int blk_mq_do_dispatch_ctx(struct
> blk_mq_hw_ctx *hctx)
>                 if (!sbitmap_any_bit_set(&hctx->ctx_map))
>                         break;
> 
> -               if (!blk_mq_get_dispatch_budget(hctx))
> +               if (!blk_mq_get_dispatch_budget(hctx)) {
> +                       blk_mq_delay_run_hw_queue(hctx,
> BLK_MQ_BUDGET_DELAY);
>                         break;
> +               }

Actually all hw queues need to be run, instead of this hctx, cause
the budget stuff is request queue wide.

> 
>                 rq = blk_mq_dequeue_from_ctx(hctx, ctx);
>                 if (!rq) {
> 
> 
> In my test setup, I have your V3 'scsi: core: only re-run queue in
> scsi_end_request() if device queue is busy' rebased on 5.8 which does not
> have
> "scsi: core: run queue if SCSI device queue isn't ready and queue is idle"
> since it is already reverted in mainline.

If you added the above patch, I believe you can remove the run queue in
scsi_end_request() unconditionally. However, the delay run queue may
degrade io performance.

Actually the re-run queue in scsi_end_request() is only for dequeuing
request from sw/scheduler queue. And no such issue if request stays in
hctx->dispatch list.

> 
> I have 24 SAS SSD and I reduced QD = 16 so that I hit budget contention
> frequently.  I am running ioscheduler=none.
> If hctx0 has 16 IO inflight (All those IO will be posted to h/q queue
> directly). Next IO (17th IO) will see budget contention and it will be
> queued into s/w queue.
> It is expected that queue will be kicked from scsi_end_request. It is
> possible that one of the  IO completed and it reduce sdev->device_busy,
> but it has not yet reach the code which will kicked the h/w queue.
> Releasing budget and restarting h/w queue is not atomic. At the same time,
> another IO (18th IO) from submission path get the budget and it will be
> posted from below path. This IO will reset sdev->restart and it will not
> allow h/w queue to be restarted from completion path. This will lead one

Maybe re-run queue is needed before resetting sdev->restart if sdev->restart is 1.


Thanks, 
Ming

