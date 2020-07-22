Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60052C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 05:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A37F208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 05:30:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XXSV4lWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgGVFau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 01:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgGVFau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 01:30:50 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F26C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 22:30:50 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o22so751827qtt.13
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 22:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=xS7Kim2B+CsYrc0K8U/ptK8kz6IkaQc1pJN6IBahgXw=;
        b=XXSV4lWPuk1sw6CMEr0dF6ewLex6pQo3j438xMU/jhuiIBc+4nJt01o2gVFLLZShZN
         NGlU/u00P2slIbxRlQkDtILKaJa2r2qwHQJ8okJTZngb9AY8F0a22gBgnP/FG/Ri0lO+
         th7tM1/3CzQadUNAIbcZPi957F5rdC+UCoUPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=xS7Kim2B+CsYrc0K8U/ptK8kz6IkaQc1pJN6IBahgXw=;
        b=q4yahw9kSMaey2/DNJSFGV3CYpjCDq7Q3rot8wQ3uuyN5MBlZOZwQi2dGjLCt2da50
         qN/FJCV25a8va7gO/DXLNz5g1E03Vp5Cv7b+bSwrRxJne/JX91VKGTn25Mbqk+9VbvRW
         K/hg7saUxDQMX0uh+JXAnlFlOMZF+TUuIaqokDFqwlIID9AU3k/B6rUHFP0idKTicojd
         ua85/Xj4if90JI6T600U6XydUHqi3A+Qlh/b5TTrzV5vEITaYTgHMN69lG9/uXW7gD1R
         Lp6z/L9FR6Q/j2eQXDIUT/lU7mB4rbiLlRZ8eq6d4Fr46aww9Gb6Q81qIBFBFVpgjOI3
         eOVg==
X-Gm-Message-State: AOAM530Dmz4jaFtoHPDbGUO+WNVsvtpCXyNzzph4oWe3PIKIWW9w4Yzc
        pMJ7Q57sIYmoTZZaOookQCpn711T6Lb53ynhE6Bjgg==
X-Google-Smtp-Source: ABdhPJxdo25+2XkRwhdgHq/9+5Ivpi6lc6jH4cYcwcW5ri/AAteix9e9opTnAE3gxSc32WaM6Jr5BIh5I5ypUpvcfdY=
X-Received: by 2002:ac8:44ad:: with SMTP id a13mr32794905qto.387.1595395849116;
 Tue, 21 Jul 2020 22:30:49 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com> <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com> <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com> <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com> <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com> <20200722041201.GA912316@T590>
In-Reply-To: <20200722041201.GA912316@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJSqxXFx3TUO8QxiMK90640nKnEzQH+EZjkAbhqhc0C+wdQxgJ5b1VDAfpasg4DMrNb7AKnNDk4A1Nf+tQBkT/QOAJCvD/hp1lGymA=
Date:   Wed, 22 Jul 2020 11:00:45 +0530
Message-ID: <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
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

> On Tue, Jul 21, 2020 at 12:23:39PM +0530, Kashyap Desai wrote:
> > > > >
> > > > > Perf top (shared host tag. IOPS = 230K)
> > > > >
> > > > > 13.98%  [kernel]        [k] sbitmap_any_bit_set
> > > > >      6.43%  [kernel]        [k] blk_mq_run_hw_queue
> > > >
> > > > blk_mq_run_hw_queue function take more CPU which is called from "
> > > > scsi_end_request"
> > >
> > > The problem could be that nr_hw_queues is increased a lot so that
> > > sample
> > on
> > > blk_mq_run_hw_queue() can be observed now.
> >
> > Yes. That is correct.
> >
> > >
> > > > It looks like " blk_mq_hctx_has_pending" handles only elevator
> > > > (scheduler) case. If  queue has ioscheduler=none, we can skip. I
> > > > case of scheduler=none, IO will be pushed to hardware queue and it
> > > > by pass
> > > software queue.
> > > > Based on above understanding, I added below patch and I can see
> > > > performance scale back to expectation.
> > > >
> > > > Ming mentioned that - we cannot remove blk_mq_run_hw_queues()
> from
> > > > IO completion path otherwise we may see IO hang. So I have just
> > > > modified completion path assuming it is only required for IO
scheduler
> case.
> > > > https://www.spinics.net/lists/linux-block/msg55049.html
> > > >
> > > > Please review and let me know if this is good or we have to
> > > > address with proper fix.
> > > >
> > > > diff --git a/block/blk-mq.c b/block/blk-mq.c index
> > > > 1be7ac5a4040..b6a5b41b7fc2 100644
> > > > --- a/block/blk-mq.c
> > > > +++ b/block/blk-mq.c
> > > > @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct
> > > request_queue
> > > > *q, bool async)
> > > >         struct blk_mq_hw_ctx *hctx;
> > > >         int i;
> > > >
> > > > +       if (!q->elevator)
> > > > +               return;
> > > > +
> > >
> > > This way shouldn't be correct, blk_mq_run_hw_queues() is still
> > > needed
> > for
> > > none because request may not be dispatched successfully by direct
issue.
> >
> > When block layer attempt posting request to h/w queue directly (for
> > ioscheduler=none) and if it fails, it is calling
> > blk_mq_request_bypass_insert().
> > blk_mq_request_bypass_insert function will start the h/w queue from
> > submission context. Do we still have an issue if we skip running hw
> > queue from completion ?
>
> The thing is that we can't guarantee that direct issue or adding request
into
> hctx->dispatch is always done for MQ/none, for example, request still
> can be added to sw queue from blk_mq_flush_plug_list() when mq plug is
> applied.

I see even blk_mq_sched_insert_requests() from blk_mq_flush_plug_list make
sure it run the h/w queue. If all the submission path which deals with s/w
queue make sure they run h/w queue, can't we remove blk_mq_run_hw_queues()
from scsi_end_request ?

>
> Also, I am not sure it is a good idea to add request into hctx->dispatch
via
> blk_mq_request_bypass_insert() in __blk_mq_try_issue_directly() in case
of
> running out of budget, because this way may hurt sequential IO
performance.
>
> Thanks,
> Ming
