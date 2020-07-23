Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9784BC433EB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 14:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F0D20709
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 14:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RV5IftjS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgGWOIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 10:08:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58615 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727068AbgGWOIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jul 2020 10:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595513300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I5n8E5gVkq3FpDbwVRFSVKWJp9frt3XcECN0GmaJ+xc=;
        b=RV5IftjS6z66c0tjmyzRZQQZPufocAUMdazkUkS1skQv4Op569WAjVFihgsdyTX5WxA6D3
        TBqEP11s3AifYVBgbnfi916+oWRlyzuFCZ9Hxf3X69rL/tREwtlp4DVfz3TnWYY0bUbwGb
        q+j8yy1e71dbdFVufpwsL2qIPgvoHms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-MmFmJrbxOra8_vMTHKD_jg-1; Thu, 23 Jul 2020 10:08:17 -0400
X-MC-Unique: MmFmJrbxOra8_vMTHKD_jg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03F5080046D;
        Thu, 23 Jul 2020 14:08:15 +0000 (UTC)
Received: from T590 (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A05EE10013C0;
        Thu, 23 Jul 2020 14:08:02 +0000 (UTC)
Date:   Thu, 23 Jul 2020 22:07:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200723140758.GA957464@T590>
References: <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com>
 <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
 <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
 <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 22, 2020 at 10:32:41AM +0100, John Garry wrote:
> > > > > > > 
> > > > > > > diff --git a/block/blk-mq.c b/block/blk-mq.c index
> > > > > > > 1be7ac5a4040..b6a5b41b7fc2 100644
> > > > > > > --- a/block/blk-mq.c
> > > > > > > +++ b/block/blk-mq.c
> > > > > > > @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct
> > > > > > request_queue
> > > > > > > *q, bool async)
> > > > > > >          struct blk_mq_hw_ctx *hctx;
> > > > > > >          int i;
> > > > > > > 
> > > > > > > +       if (!q->elevator)
> > > > > > > +               return;
> > > > > > > +
> > > > > > This way shouldn't be correct, blk_mq_run_hw_queues() is still
> > > > > > needed
> 
> Could the logic of blk_mq_run_hw_queue() -> blk_mq_hctx_has_pending() ->
> sbitmap_any_bit_set(&hctx->ctx_map) be optimised for megaraid scenario?
> 
> As I see, since megaraid will have 1:1 mapping of CPU to hw queue, will
> there only ever possibly a single bit set in ctx_map? If so, it seems a
> waste to always check every sbitmap map. But adding logic for this may
> negate any possible gains.

It really depends on min and max cpu id in the map, then sbitmap
depth can be reduced to (max - min + 1). I'd suggest to double check that
cost of sbitmap_any_bit_set() really matters.

> 
> > > > > for
> > > > > > none because request may not be dispatched successfully by direct
> > > issue.
> > > > > When block layer attempt posting request to h/w queue directly (for
> > > > > ioscheduler=none) and if it fails, it is calling
> > > > > blk_mq_request_bypass_insert().
> > > > > blk_mq_request_bypass_insert function will start the h/w queue from
> > > > > submission context. Do we still have an issue if we skip running hw
> > > > > queue from completion ?
> > > > The thing is that we can't guarantee that direct issue or adding request
> > > into
> > > > hctx->dispatch is always done for MQ/none, for example, request still
> > > > can be added to sw queue from blk_mq_flush_plug_list() when mq plug is
> > > > applied.
> > > I see even blk_mq_sched_insert_requests() from blk_mq_flush_plug_list make
> > > sure it run the h/w queue. If all the submission path which deals with s/w
> > > queue make sure they run h/w queue, can't we remove blk_mq_run_hw_queues()
> > > from scsi_end_request ?
> > No, one purpose of blk_mq_run_hw_queues() is for rerun queue in case that
> > dispatch budget is running out of in submission path, and sdev->device_busy is
> > shared by all hw queues on this scsi device.
> > 
> > I posted one patch for avoiding it in scsi_end_request() before, looks it
> > never lands upstream:
> > 
> 
> I saw that you actually posted the v3:
> https://lore.kernel.org/linux-scsi/BL0PR2101MB11230C5F70151037B23C0C35CE2D0@BL0PR2101MB1123.namprd21.prod.outlook.com/
> And it no longer applies, due to the changes in scsi_mq_get_budget(), I
> think, which look non-trivial. Any chance to repost?

OK, will post V4.


thanks,
Ming

