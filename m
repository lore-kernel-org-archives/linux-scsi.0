Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C7EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 08:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDF3E2177B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 08:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KjwxtEMA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgG1IB2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 04:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgG1IB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 04:01:27 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD0BC061794
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 01:01:27 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id x69so17871159qkb.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 01:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=o7IdoU3GthtJkfIpVkjeEL5SahC9gpK+nOKCUdtMyLA=;
        b=KjwxtEMA9I7JUPYRUD4voCkD5N/T88FB5uYhvp80eZM5TeofA1tbo+WN+19ZrRdeUk
         ilGFOGzz9WxqdsLXw3AyXzUD0rY+GNi2PJh0C7dyDWuxH0DFBZ5wDD9zg5zKGqwfP//b
         omkODedxdxISuIQEyh54T5Gh0RH80qTqlF+8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=o7IdoU3GthtJkfIpVkjeEL5SahC9gpK+nOKCUdtMyLA=;
        b=slY28eqg+CVPCZsH4t3eFLrm0/DH0Z6j4CEffCmHrH4KmSJMhrSRPRmIKa8GZtiTnm
         odMAaDweDezHvzVQZ5HX7k5AUNqZNMie92CJm+2JU50aLyaehBjJGxdzUxVpnaC9bcDu
         3ppYw7Td2h+YsSiCmZrDmdUvzxeZy33Zi+jHxeztlHJUU1ZrPoo9DGeX/bJYkwuQkzYY
         1iKDZTawEQf6zUzPx1D0ko0C0a13DojkKTenc7SYlJK82M4W3hzfVC3r76eVWGRFIVEO
         h2v2t0gjWjlTRMLGtCYBAsKWhP52Y4pQ4jx+83QHBts/EVZeuOW9zMFLQ3ewaVSaNb21
         GIzw==
X-Gm-Message-State: AOAM532sjLbuJ8gCsQLDmKiowo+OI3O1GcKk4CLpQjNYtRRteOBybNmZ
        Y2Si3XpN7wFYk/9u2nV0rofPeHxitQ0pmArxoS2ZPA==
X-Google-Smtp-Source: ABdhPJw2OmXGrJ6ZFDe0WzmPpXDjucVRdGY9T7sWAlVhud6PWKwelDeoOmTHqUPRT1QWJyFuLkKQ0wLY7Vq20AbXHwo=
X-Received: by 2002:a37:70c1:: with SMTP id l184mr23039981qkc.70.1595923286478;
 Tue, 28 Jul 2020 01:01:26 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com> <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com> <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com> <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com> <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com> <20200722080409.GB912316@T590>
In-Reply-To: <20200722080409.GB912316@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQG4aoXNvN1oD1R4AnS848tUiuVMpAL7B1DGAnlvVUMB+lqyDgMys1vsAqc0OTgDU1/61AGRP9A4AkK8P+ECUfpMjQJmEWWiqIX8AyA=
Date:   Tue, 28 Jul 2020 13:31:23 +0530
Message-ID: <ce3f1daa9f7399071b801f2ffd3f7ab3@mail.gmail.com>
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

> On Wed, Jul 22, 2020 at 11:00:45AM +0530, Kashyap Desai wrote:
> > > On Tue, Jul 21, 2020 at 12:23:39PM +0530, Kashyap Desai wrote:
> > > > > > >
> > > > > > > Perf top (shared host tag. IOPS = 230K)
> > > > > > >
> > > > > > > 13.98%  [kernel]        [k] sbitmap_any_bit_set
> > > > > > >      6.43%  [kernel]        [k] blk_mq_run_hw_queue
> > > > > >
> > > > > > blk_mq_run_hw_queue function take more CPU which is called
from
> "
> > > > > > scsi_end_request"
> > > > >
> > > > > The problem could be that nr_hw_queues is increased a lot so
> > > > > that sample
> > > > on
> > > > > blk_mq_run_hw_queue() can be observed now.
> > > >
> > > > Yes. That is correct.
> > > >
> > > > >
> > > > > > It looks like " blk_mq_hctx_has_pending" handles only elevator
> > > > > > (scheduler) case. If  queue has ioscheduler=none, we can skip.
> > > > > > I case of scheduler=none, IO will be pushed to hardware queue
> > > > > > and it by pass
> > > > > software queue.
> > > > > > Based on above understanding, I added below patch and I can
> > > > > > see performance scale back to expectation.
> > > > > >
> > > > > > Ming mentioned that - we cannot remove blk_mq_run_hw_queues()
> > > from
> > > > > > IO completion path otherwise we may see IO hang. So I have
> > > > > > just modified completion path assuming it is only required for
> > > > > > IO
> > scheduler
> > > case.
> > > > > > https://www.spinics.net/lists/linux-block/msg55049.html
> > > > > >
> > > > > > Please review and let me know if this is good or we have to
> > > > > > address with proper fix.
> > > > > >
> > > > > > diff --git a/block/blk-mq.c b/block/blk-mq.c index
> > > > > > 1be7ac5a4040..b6a5b41b7fc2 100644
> > > > > > --- a/block/blk-mq.c
> > > > > > +++ b/block/blk-mq.c
> > > > > > @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct
> > > > > request_queue
> > > > > > *q, bool async)
> > > > > >         struct blk_mq_hw_ctx *hctx;
> > > > > >         int i;
> > > > > >
> > > > > > +       if (!q->elevator)
> > > > > > +               return;
> > > > > > +
> > > > >
> > > > > This way shouldn't be correct, blk_mq_run_hw_queues() is still
> > > > > needed
> > > > for
> > > > > none because request may not be dispatched successfully by
> > > > > direct
> > issue.
> > > >
> > > > When block layer attempt posting request to h/w queue directly
> > > > (for
> > > > ioscheduler=none) and if it fails, it is calling
> > > > blk_mq_request_bypass_insert().
> > > > blk_mq_request_bypass_insert function will start the h/w queue
> > > > from submission context. Do we still have an issue if we skip
> > > > running hw queue from completion ?
> > >
> > > The thing is that we can't guarantee that direct issue or adding
> > > request
> > into
> > > hctx->dispatch is always done for MQ/none, for example, request
> > > hctx->still
> > > can be added to sw queue from blk_mq_flush_plug_list() when mq plug
> > > is applied.
> >
> > I see even blk_mq_sched_insert_requests() from blk_mq_flush_plug_list
> > make sure it run the h/w queue. If all the submission path which deals
> > with s/w queue make sure they run h/w queue, can't we remove
> > blk_mq_run_hw_queues() from scsi_end_request ?
>
> No, one purpose of blk_mq_run_hw_queues() is for rerun queue in case
that
> dispatch budget is running out of in submission path, and
sdev->device_busy
> is shared by all hw queues on this scsi device.
>
> I posted one patch for avoiding it in scsi_end_request() before, looks
it never
> lands upstream:
>
> https://lore.kernel.org/linux-block/20191118100640.3673-1-
> ming.lei@redhat.com/

Ming - I think above patch will fix the issue of performance on VD.
I fix some hunk failure and ported to 5.8 kernel -
I am testing this patch on my setup. If you post V4, I will use that.

So far looks good.  I have reduced device queue depth so that I hit budget
busy code path frequently.

Kashyap


>
> Thanks,
> Ming
