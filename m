Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF59CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FE623119
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6dAO0wz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgHFQsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:48:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729184AbgHFQsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 12:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596732490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w+3IJDBpKnoEu5uWHtNsifCRebgdQ/7nqjgRKatFRHs=;
        b=E6dAO0wzpKANDl6c8VY5XlpX9OnCLPnHXvyzSUpLjv2a/AEjuZN3nNKRJuIhBmESnWpyHn
        26Sqvde3YywIA1XJZjRZDkQgOh+pq11Q43csebJlK77vM+5R87y8ifuVvdhURkRkZuuGbP
        C+nW3Q/+/+ALRRXEBl/BfgMvFgMb5Gw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-SPqGxKsbMdaDgta-AJRkXw-1; Thu, 06 Aug 2020 11:29:57 -0400
X-MC-Unique: SPqGxKsbMdaDgta-AJRkXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE468800476;
        Thu,  6 Aug 2020 15:29:54 +0000 (UTC)
Received: from T590 (ovpn-13-169.pek2.redhat.com [10.72.13.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D71C60C47;
        Thu,  6 Aug 2020 15:29:43 +0000 (UTC)
Date:   Thu, 6 Aug 2020 23:29:39 +0800
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
Message-ID: <20200806152939.GA2062348@T590>
References: <20200728084511.GA1326626@T590>
 <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590>
 <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590>
 <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590>
 <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
 <20200806133819.GA2046861@T590>
 <f1ac35dfca34193e6c9bcedbc11911d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1ac35dfca34193e6c9bcedbc11911d2@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2020 at 08:07:38PM +0530, Kashyap Desai wrote:
> > > Hi Ming -
> > >
> > > There is still some race which is not handled.  Take a case of IO is
> > > not able to get budget and it has already marked <restarts> flag.
> > > <restarts> flag will be seen non-zero in completion path and
> > > completion path will attempt h/w queue run. (But this particular IO is
> > > still not in s/w queue.).
> > > Attempt of running h/w queue from completion path will not flush any
> > > IO since there is no IO in s/w queue.
> >
> > Then where is the IO to be submitted in case of running out of budget?
> 
> Typical race in your latest patch is - (Lets consider command A,B and C)
> Command A did not receive budget. Command B completed  (which was already

Command A doesn't get budget, and A is still in sw/scheduler queue
because we try to acquire budget before dequeuing request from sw/scheduler queue,
see __blk_mq_do_dispatch_sched() and blk_mq_do_dispatch_ctx().

Not consider direct issue, because the hw queue will be run explicitly
when not getting budget, see __blk_mq_try_issue_directly.

Not consider command A being added to hctx->dispatch too, because blk-mq will
re-run the queue, see blk_mq_dispatch_rq_list().


> submitted earlier) at the same time and it make sdev->device_busy = 0 from
> " scsi_finish_command".
> Command B has still not called "scsi_end_request". Command C get the
> budget and it will make sdev->device_busy = 1. Now, Command A set  set
> sdev->restarts flags but will not run h/w queue since sdev->device_busy =
> 1.

Right.

> Command B run h/w queue (make sdev->restart = 0) from completion path, but
> command -A is still not in the s/w queue.

Then you didn't answer my question about where A is, did you?

> Command-A is in now in s/w queue. Command-C completed but it will not run h/w queue because
> sdev->restarts = 0.

Why does command-A become in sw/queue now?

> 
> 
> >
> > Any IO request which is going to be added to hctx->dispatch, the queue
> will be
> > re-run via blk-mq core.
> >
> > Any IO request being issued directly when running out of budget will be
> insert
> > to hctx->dispatch or sw/scheduler queue, will be run in the submission
> path.
> 
> I have *not* included below changes we discussed in my testing - If I
> include below patch, it is correct that queue will be run in submission
> path (at least the path which is impacted in my testing). You have already
> mentioned that most of the submission path has fix now in latest kernel
> w.r.t running h/w queue from submission path.  Below path is missing for
> running h/w queue from submission path.
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c index
> 54f9015..bcfd33a 100644
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
> + BLK_MQ_BUDGET_DELAY);
>                         break;
> +               }
> 
>                 rq = blk_mq_dequeue_from_ctx(hctx, ctx);
>                 if (!rq) {
> 
> Are you saying above fix should be included along with your latest patch ?

No.


Thanks,
Ming

