Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA597C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B979322BF5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bK8YIY79"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgGUGxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 02:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgGUGxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 02:53:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4476DC0619D6
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 23:53:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d27so15392032qtg.4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 23:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=/LzX205OrVJxpDVgD3okbRlxqqEZJ1kZvD6gwUPc6+w=;
        b=bK8YIY79uozJq8nAajqEK227dyxwk/ewc+lSm4zEJp4hFMrzvVBAK/UStdfJGz8pK/
         xfex1nbbbqNWdolykGggSOqmlvMLGr6bVnUFALah9O0qn0S2CX/mdfV5PrICYAYYhjwv
         T1rgXpyCIhEo6ihcdRPCMVt+6nFBEuLxj/F04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=/LzX205OrVJxpDVgD3okbRlxqqEZJ1kZvD6gwUPc6+w=;
        b=kfuGvcsRw6MKrXxE118C90qnqQ6dfYH+fZdo1uCqnh8/mdlG5rHc2WikaujQtqs/ky
         p9smQn0G3YzvBdJ5cJgjxYDWP9LbyoKeWJJublNol0lOTqV9WzzvlBrsF8rJeHZA+TQe
         RS7zKIj3xryfW7YTusf2ew1z3KGsPgJ6FezxsqO266NMTh5gwtdoScUos35nZM/u7PNn
         z1WIlhxLXqrMulESnECWy3qiy97aROnt55SJLQi06HSMStqkwIoCx83cDnSh99c+NnMV
         LyZ3l05X1Z+3yBM572WdnzX20SLdpwSh0Aw7hhyiTy0PBZUwT8gkeUfRC5zeyzF4ofYX
         n6cg==
X-Gm-Message-State: AOAM5336z39sjUIADvEbhAAK8C9+XdEMJu6+u9Pg/skqNoWmJJ+XHX3Q
        lL9nR3JFnCW7/KACTGoHBLfu4nRpehMbjyTliFdDRA==
X-Google-Smtp-Source: ABdhPJx9UIqbJmT3ciJpPn/RECvKEVWHhtsDZpKUoXVlcMNzMGiz5RapIvzx6yBFENi+j4pIIeS78ePC4YigAXjBNo0=
X-Received: by 2002:ac8:36bb:: with SMTP id a56mr27509911qtc.201.1595314421244;
 Mon, 20 Jul 2020 23:53:41 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com> <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com> <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com> <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com> <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com> <20200721011323.GA833377@T590>
In-Reply-To: <20200721011323.GA833377@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGYVoTUA+B9zIZNqWv71qXbwKlkDwGZowweAlKrFcUB/hGY5AG4aoXNAvsHUMYCeW9VQwH6WrIOAzKzW+wCpzQ5OANTX/rUqMuvaHA=
Date:   Tue, 21 Jul 2020 12:23:39 +0530
Message-ID: <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
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
> > > Perf top (shared host tag. IOPS = 230K)
> > >
> > > 13.98%  [kernel]        [k] sbitmap_any_bit_set
> > >      6.43%  [kernel]        [k] blk_mq_run_hw_queue
> >
> > blk_mq_run_hw_queue function take more CPU which is called from "
> > scsi_end_request"
>
> The problem could be that nr_hw_queues is increased a lot so that sample
on
> blk_mq_run_hw_queue() can be observed now.

Yes. That is correct.

>
> > It looks like " blk_mq_hctx_has_pending" handles only elevator
> > (scheduler) case. If  queue has ioscheduler=none, we can skip. I case
> > of scheduler=none, IO will be pushed to hardware queue and it by pass
> software queue.
> > Based on above understanding, I added below patch and I can see
> > performance scale back to expectation.
> >
> > Ming mentioned that - we cannot remove blk_mq_run_hw_queues() from IO
> > completion path otherwise we may see IO hang. So I have just modified
> > completion path assuming it is only required for IO scheduler case.
> > https://www.spinics.net/lists/linux-block/msg55049.html
> >
> > Please review and let me know if this is good or we have to address
> > with proper fix.
> >
> > diff --git a/block/blk-mq.c b/block/blk-mq.c index
> > 1be7ac5a4040..b6a5b41b7fc2 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct
> request_queue
> > *q, bool async)
> >         struct blk_mq_hw_ctx *hctx;
> >         int i;
> >
> > +       if (!q->elevator)
> > +               return;
> > +
>
> This way shouldn't be correct, blk_mq_run_hw_queues() is still needed
for
> none because request may not be dispatched successfully by direct issue.

When block layer attempt posting request to h/w queue directly (for
ioscheduler=none) and if it fails, it is calling
blk_mq_request_bypass_insert().
blk_mq_request_bypass_insert function will start the h/w queue from
submission context. Do we still have an issue if we skip running hw queue
from completion ?

Kashyap

>
>
> Thanks,
> Ming
