Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490A2C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1B7207CD
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3V6BD0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgGVEMZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 00:12:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgGVEMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jul 2020 00:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595391143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gX7hhPPMl6PUYDZGTJg81HfIVXLJNVGUO6Jmi9LuBtw=;
        b=a3V6BD0DAy9uqPz3fE+AsRK8euEkLcwqwlW0lpHLzABEJQ8akfkny7PMJQGZR8A5IMxdyS
        cKq84OXEcr9SNw+31CMG8Oq2T198sOleFwio2pp/9yhv9hSnW0LENcTkdz+xBntQPsoLvr
        aS90gg+UO7AZzBEwt5QVr0zbgilvA+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-yDLXea0aMr6C4cwss17B9Q-1; Wed, 22 Jul 2020 00:12:18 -0400
X-MC-Unique: yDLXea0aMr6C4cwss17B9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 171E380183C;
        Wed, 22 Jul 2020 04:12:16 +0000 (UTC)
Received: from T590 (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9705A10027A5;
        Wed, 22 Jul 2020 04:12:05 +0000 (UTC)
Date:   Wed, 22 Jul 2020 12:12:01 +0800
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
Message-ID: <20200722041201.GA912316@T590>
References: <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
 <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com>
 <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com>
 <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
 <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 21, 2020 at 12:23:39PM +0530, Kashyap Desai wrote:
> > > >
> > > > Perf top (shared host tag. IOPS = 230K)
> > > >
> > > > 13.98%  [kernel]        [k] sbitmap_any_bit_set
> > > >      6.43%  [kernel]        [k] blk_mq_run_hw_queue
> > >
> > > blk_mq_run_hw_queue function take more CPU which is called from "
> > > scsi_end_request"
> >
> > The problem could be that nr_hw_queues is increased a lot so that sample
> on
> > blk_mq_run_hw_queue() can be observed now.
> 
> Yes. That is correct.
> 
> >
> > > It looks like " blk_mq_hctx_has_pending" handles only elevator
> > > (scheduler) case. If  queue has ioscheduler=none, we can skip. I case
> > > of scheduler=none, IO will be pushed to hardware queue and it by pass
> > software queue.
> > > Based on above understanding, I added below patch and I can see
> > > performance scale back to expectation.
> > >
> > > Ming mentioned that - we cannot remove blk_mq_run_hw_queues() from IO
> > > completion path otherwise we may see IO hang. So I have just modified
> > > completion path assuming it is only required for IO scheduler case.
> > > https://www.spinics.net/lists/linux-block/msg55049.html
> > >
> > > Please review and let me know if this is good or we have to address
> > > with proper fix.
> > >
> > > diff --git a/block/blk-mq.c b/block/blk-mq.c index
> > > 1be7ac5a4040..b6a5b41b7fc2 100644
> > > --- a/block/blk-mq.c
> > > +++ b/block/blk-mq.c
> > > @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct
> > request_queue
> > > *q, bool async)
> > >         struct blk_mq_hw_ctx *hctx;
> > >         int i;
> > >
> > > +       if (!q->elevator)
> > > +               return;
> > > +
> >
> > This way shouldn't be correct, blk_mq_run_hw_queues() is still needed
> for
> > none because request may not be dispatched successfully by direct issue.
> 
> When block layer attempt posting request to h/w queue directly (for
> ioscheduler=none) and if it fails, it is calling
> blk_mq_request_bypass_insert().
> blk_mq_request_bypass_insert function will start the h/w queue from
> submission context. Do we still have an issue if we skip running hw queue
> from completion ?

The thing is that we can't guarantee that direct issue or adding request into
hctx->dispatch is always done for MQ/none, for example, request still
can be added to sw queue from blk_mq_flush_plug_list() when mq plug is
applied.

Also, I am not sure it is a good idea to add request into hctx->dispatch
via blk_mq_request_bypass_insert() in __blk_mq_try_issue_directly() in
case of running out of budget, because this way may hurt sequential IO
performance.

Thanks,
Ming

