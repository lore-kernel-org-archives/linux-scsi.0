Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29ACC433E4
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 02:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CBF20714
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 02:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gnuebQSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGXCrb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 22:47:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30121 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726381AbgGXCrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 22:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595558849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CzMPykDfok16xigTP1nHT3zsso91EXAM32oQ8gcfF5I=;
        b=gnuebQSgG6CCQlcGuiCeML8IvQYFEb61rEl+ByfnLxsPwNjnwOlY3wxqpKBsnaabJGywMh
        7UfVQKXXL0Vqnxd9P3jJHI577DLcWgXZO9RE7HH+NVMyUF3mvNs7I/kiThmHRwjQpy4M9I
        dZNW0q6dwGrawz51aI3BUE+h67VlBXY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-g6IrjqCMO_K7UztKXG9DBg-1; Thu, 23 Jul 2020 22:47:24 -0400
X-MC-Unique: g6IrjqCMO_K7UztKXG9DBg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BCD7100AA24;
        Fri, 24 Jul 2020 02:47:21 +0000 (UTC)
Received: from T590 (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F118279310;
        Fri, 24 Jul 2020 02:47:08 +0000 (UTC)
Date:   Fri, 24 Jul 2020 10:47:04 +0800
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
Message-ID: <20200724024704.GB957464@T590>
References: <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
 <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
 <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 23, 2020 at 06:29:01PM +0100, John Garry wrote:
> > > As I see, since megaraid will have 1:1 mapping of CPU to hw queue, will
> > > there only ever possibly a single bit set in ctx_map? If so, it seems a
> > > waste to always check every sbitmap map. But adding logic for this may
> > > negate any possible gains.
> > 
> > It really depends on min and max cpu id in the map, then sbitmap
> > depth can be reduced to (max - min + 1). I'd suggest to double check that
> > cost of sbitmap_any_bit_set() really matters.
> 
> Hi Ming,
> 
> I'm not sure that reducing the search range would help much, as we still
> need to load some indexes of map[], and at best this may be reduced from 2/3
> -> 1 elements, depending on nr_cpus.

I believe you misunderstood my idea, and you have to think it from implementation
viewpoint.

The only workable way is to store the min cpu id as 'offset' and set the sbitmap
depth as (max - min + 1), isn't it? Then the actual cpu id can be figured out via
'offset' + nr_bit. And the whole indexes are just spread on the actual depth. BTW,
max & min is the max / min cpu id in hctx->cpu_map. So we can improve not only on 1:1,
and I guess most of MQ cases can benefit from the change, since it shouldn't be usual
for one ctx_map to cover both 0 & nr_cpu_id - 1.

Meantime, we need to allocate the sbitmap dynamically.


Thanks,
Ming

