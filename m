Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CC7C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 08:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3307220FC3
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 08:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I/T2Re6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgG1Iph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 04:45:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48291 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728205AbgG1Iph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 04:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595925935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZLFCIDyTMkfzQP0XXawz5q3gUq1NEYSMUB61hST3o0=;
        b=I/T2Re6JtZsPW/EWcD7YJnXqniq0gj7Jc9Uahq1tqiNDVA3s7ZMk53BZ+yEqVpTS/ymQwV
        RkibS0Aw+kF7qpu/b77X3+CEJYqnL6t5L7oMbRg+mzbPwj4NMvHCOdC/VhkgxnzCQKu008
        5wqwW5rRC4VSEe715NYedg0Ii+aoyfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-2bUuV2QsPCWE2ee2SmWIeg-1; Tue, 28 Jul 2020 04:45:31 -0400
X-MC-Unique: 2bUuV2QsPCWE2ee2SmWIeg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BD6FA30D5;
        Tue, 28 Jul 2020 08:45:24 +0000 (UTC)
Received: from T590 (ovpn-12-109.pek2.redhat.com [10.72.12.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 545391036D15;
        Tue, 28 Jul 2020 08:45:15 +0000 (UTC)
Date:   Tue, 28 Jul 2020 16:45:11 +0800
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
Message-ID: <20200728084511.GA1326626@T590>
References: <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
 <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 28, 2020 at 08:54:27AM +0100, John Garry wrote:
> On 24/07/2020 03:47, Ming Lei wrote:
> > On Thu, Jul 23, 2020 at 06:29:01PM +0100, John Garry wrote:
> > > > > As I see, since megaraid will have 1:1 mapping of CPU to hw queue, will
> > > > > there only ever possibly a single bit set in ctx_map? If so, it seems a
> > > > > waste to always check every sbitmap map. But adding logic for this may
> > > > > negate any possible gains.
> > > > 
> > > > It really depends on min and max cpu id in the map, then sbitmap
> > > > depth can be reduced to (max - min + 1). I'd suggest to double check that
> > > > cost of sbitmap_any_bit_set() really matters.
> > > 
> > > Hi Ming,
> > > 
> > > I'm not sure that reducing the search range would help much, as we still
> > > need to load some indexes of map[], and at best this may be reduced from 2/3
> > > -> 1 elements, depending on nr_cpus.
> > 
> > I believe you misunderstood my idea, and you have to think it from implementation
> > viewpoint.
> > 
> > The only workable way is to store the min cpu id as 'offset' and set the sbitmap
> > depth as (max - min + 1), isn't it? Then the actual cpu id can be figured out via
> > 'offset' + nr_bit. And the whole indexes are just spread on the actual depth. BTW,
> > max & min is the max / min cpu id in hctx->cpu_map. So we can improve not only on 1:1,
> > and I guess most of MQ cases can benefit from the change, since it shouldn't be usual
> > for one ctx_map to cover both 0 & nr_cpu_id - 1.
> > 
> > Meantime, we need to allocate the sbitmap dynamically.
> 
> OK, so dynamically allocating the sbitmap could be good. I was thinking
> previously that we still allocate for nr_cpus size, and search a limited
> range - but this would have heavier runtime overhead.
> 
> So if you really think that this may have some value, then let me know, so
> we can look to take it forward.

Forget to mention, the in-tree code has been this shape for long
time, please see sbitmap_resize() called from blk_mq_map_swqueue().

Another update is that V4 of 'scsi: core: only re-run queue in scsi_end_request()
if device queue is busy' is quite hard to implement since commit b4fd63f42647110c9
("Revert "scsi: core: run queue if SCSI device queue isn't ready and queue is idle").


Thanks,
Ming

