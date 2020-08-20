Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A1CC433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 10:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7465720738
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 10:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QFNCCjnh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgHTKZ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 06:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731811AbgHTKYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 06:24:49 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8482C061383
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2020 03:24:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id qc22so1871929ejb.4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2020 03:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FU3+CiJFzLHmOFDuQMwlaisWRGuHRN+5AV6txupwZrU=;
        b=QFNCCjnhRiVXX1RwHJMrjJrm3FMIDmNx/PgDGVaGoYPr2orRHBTBO48N0vE/bjgnJ+
         SYuYytDiRhiYZtZgJZ7z4/4vPKus2MwWgTKmnlMmLZQ4o8gAgDqGKHg0dO0uTStdh95b
         tHYxvzFh9iEVHBmlKA/EhqmNwNT52r2I3xUhk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FU3+CiJFzLHmOFDuQMwlaisWRGuHRN+5AV6txupwZrU=;
        b=X55CnYIdZD/9/nxTZLxVOqp5MLjzF8irv5WCBz8tpxwR+Ue1QjicxcZIayw+UgllNo
         twiksd8VXMqZ11xZK/OWQ98IYC1bf30dR7iW5WLy0beSnksc1hYD+WaxAbY9G70z2QRu
         NnLFzX4hjrIe0FIXS0ftGCQ1tS6qp8EHV9T0PznhP8A+IjyTdK+rajzP71Bx/WqpFtYT
         dJMULCYdXchUsytiVS2LpRoP/0+l9Xmc6cWJcroddtg9usSX6xtfjpB1WCcjqC27T4CU
         znGStp0h27QYKc/+lY0GazYoKuEckD27SQjbeWwxLZDn/RDF1RGe3j6gqqd80kDn07kB
         gbWw==
X-Gm-Message-State: AOAM5322w0TVzO0l/CnxPiq4ZGp2eQrb2HQfU5neJPvtjOWkFPCEA4g1
        OKdm1/C8KQXlGGfxIRu60bV/qW/d7Rwyp5Wq
X-Google-Smtp-Source: ABdhPJyb4Y4hm66EHa380TCAgfeE/94XMUU1/ZUDT3d9GzqInxXcEv82wENVorsv/n9FhHXRmlmtZw==
X-Received: by 2002:a17:906:f912:: with SMTP id lc18mr2483586ejb.226.1597919086323;
        Thu, 20 Aug 2020 03:24:46 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id re10sm1184124ejb.68.2020.08.20.03.24.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 03:24:45 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id r15so1469082wrp.13
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2020 03:24:45 -0700 (PDT)
X-Received: by 2002:a5d:6744:: with SMTP id l4mr2717742wrw.105.1597919084826;
 Thu, 20 Aug 2020 03:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-6-hch@lst.de>
 <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com>
 <62e4f4fc-c8a5-3ee8-c576-fe7178cb4356@arm.com> <CAAFQd5AcCTDguB2C9KyDiutXWoEvBL8tL7+a==Uo8vj_8CLOJw@mail.gmail.com>
 <2b32f1d8-16f7-3352-40a5-420993d52fb5@arm.com> <20200820050214.GA4815@lst.de>
In-Reply-To: <20200820050214.GA4815@lst.de>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 20 Aug 2020 12:24:31 +0200
X-Gmail-Original-Message-ID: <CAAFQd5AknYpP5BamC=wJkEJyO-q47V6Gc+HT65h6B+HyT+-xjQ@mail.gmail.com>
Message-ID: <CAAFQd5AknYpP5BamC=wJkEJyO-q47V6Gc+HT65h6B+HyT+-xjQ@mail.gmail.com>
Subject: Re: [PATCH 05/28] media/v4l2: remove V4L2-FLAG-MEMORY-NON-CONSISTENT
To:     Christoph Hellwig <hch@lst.de>
Cc:     Robin Murphy <robin.murphy@arm.com>, alsa-devel@alsa-project.org,
        linux-ia64@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 20, 2020 at 7:02 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Aug 19, 2020 at 03:07:04PM +0100, Robin Murphy wrote:
> >> FWIW, I asked back in time what the plan is for non-coherent
> >> allocations and it seemed like DMA_ATTR_NON_CONSISTENT and
> >> dma_sync_*() was supposed to be the right thing to go with. [2] The
> >> same thread also explains why dma_alloc_pages() isn't suitable for the
> >> users of dma_alloc_attrs() and DMA_ATTR_NON_CONSISTENT.
> >
> > AFAICS even back then Christoph was implying getting rid of NON_CONSISTENT
> > and *replacing* it with something streaming-API-based - i.e. this series -
> > not encouraging mixing the existing APIs. It doesn't seem impossible to
> > implement a remapping version of this new dma_alloc_pages() for
> > IOMMU-backed ops if it's really warranted (although at that point it seems
> > like "non-coherent" vb2-dc starts to have significant conceptual overlap
> > with vb2-sg).
>
> You can alway vmap the returned pages from dma_alloc_pages, but it will
> make cache invalidation hell - you'll need to use
> invalidate_kernel_vmap_range and flush_kernel_vmap_range to properly
> handle virtually indexed caches.
>
> Or with remapping you mean using the iommu do de-scatter/gather?

Ideally, both.

For remapping in the CPU sense, there are drivers which rely on a
contiguous kernel mapping of the vb2 buffers, which was provided by
dma_alloc_attrs(). I think they could be reworked to work on single
pages, but that would significantly complicate the code. At the same
time, such drivers would actually benefit from a cached mapping,
because they often have non-bursty, random access patterns.

Then, in the IOMMU sense, the whole idea of videobuf2-dma-contig is to
rely on the DMA API to always provide device-contiguous memory, as
required by the hardware which only has a single pointer and size.

>
> You can implement that trivially implement it yourself for the iommu
> case:
>
> {
>         merge_boundary = dma_get_merge_boundary(dev);
>         if (!merge_boundary || merge_boundary > chunk_size - 1) {
>                 /* can't coalesce */
>                 return -EINVAL;
>         }
>
>
>         nents = DIV_ROUND_UP(total_size, chunk_size);
>         sg = sgl_alloc();
>         for_each_sgl() {
>                 sg->page = __alloc_pages(get_order(chunk_size))
>                 sg->len = chunk_size;
>         }
>         dma_map_sg(sg, DMA_ATTR_SKIP_CPU_SYNC);
>         // you are guaranteed to get a single dma_addr out
> }
>
> Of course this still uses the scatterlist structure with its annoying
> mix of input and output parametes, so I'd rather not expose it as
> an official API at the DMA layer.

The problem with the above open coded approach is that it requires
explicit handling of the non-IOMMU and IOMMU cases and this is exactly
what we don't want to have in vb2 and what was actually the job of the
DMA API to hide. Is the plan to actually move the IOMMU handling out
of the DMA API?

Do you think we could instead turn it into a dma_alloc_noncoherent()
helper, which has similar semantics as dma_alloc_attrs() and handles
the various corner cases (e.g. invalidate_kernel_vmap_range and
flush_kernel_vmap_range) to achieve the desired functionality without
delegating the "hell", as you called it, to the users?

Best regards,
Tomasz
