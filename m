Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535CAC3F2CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 09:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A3721556
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 09:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GAVNfr4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgCEJKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 04:10:18 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46349 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCEJKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 04:10:18 -0500
Received: by mail-oi1-f195.google.com with SMTP id a22so5188045oid.13
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2020 01:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVw9rq/rix9MBoNWQR01CSPHCMCR9vj00qyZgw+bZRw=;
        b=GAVNfr4ekJN/rAAq8AWXuomRPw+LQAG5q3V6xV35njOQwNvr1sbzvpii96PKcV+oew
         iYExUUmUBPi6Rw4rKxZi37AkNT0BjYqRhhJfOEq48F6lZJj8X6oWq8cAnKgwn7rVAEZW
         hRcq119am4x8UEodZTxXYP4rBjBz2Xkr5KxfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVw9rq/rix9MBoNWQR01CSPHCMCR9vj00qyZgw+bZRw=;
        b=mqgfgUFheRGvjBkelfsaFchY2AoJ6xUp0vXyma9kk1VUhhso3UbnTEFhwcc3iAmZ4B
         uZJD0O7Ep9QV5aA1BWBLtBZJZ+/vukw7kb5dSmzgYgHJjQuaXH/SjCCy7IQIDOWOFPCG
         3bTd8rNVjhjg5xA8dbeqnCq9W8agR3y7hFB/jjRkkSaw5uxTHs8hmhWr5aGD9AXDHot3
         4by8vpYGQ4QjjGiAoHLDzTn6dBVhZ7VxzByMdlKYIdoLaXLP6ap9dtPBeW54Uy3M/+Vw
         odxakZRvxeZ8mgkqDIi2rBHNMTLo+EItwNASnllG34OsYOdFJAX7Yf8Gkj/5PqYfB72L
         7Upw==
X-Gm-Message-State: ANhLgQ0NjNmCvq9Oj4z6r2uLt3C+aiKznW+X07zZp/wZWhJU0MZEeD5j
        TNb+N1PDlihTVq9CWRoC25TIJN/xVV01oHj7WiSfz7LX
X-Google-Smtp-Source: ADFU+vvbCXlixGAai/SlKqe/UdGMohjajpDdFJPED4W//juxvv3g4nijsRomM7wOTpZHn93aekZnhkzFXTN5R8V31E4=
X-Received: by 2002:a05:6808:251:: with SMTP id m17mr4895207oie.15.1583399417700;
 Thu, 05 Mar 2020 01:10:17 -0800 (PST)
MIME-Version: 1.0
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1581416293-41610-5-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20200225184202.GC6261@infradead.org> <CAK=zhgoR0k+eoEMNznMGCF21eQMKT2UJ5vufCho4dXfHNFFV3g@mail.gmail.com>
In-Reply-To: <CAK=zhgoR0k+eoEMNznMGCF21eQMKT2UJ5vufCho4dXfHNFFV3g@mail.gmail.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Thu, 5 Mar 2020 14:40:06 +0530
Message-ID: <CAK=zhgpXF=qcwhwpzsx44GDEJxFXLcZFSgO9cAXL8p2GjU0KoQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4g region
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Any update over my previous reply?

Thanks,
Sreekanth

On Thu, Feb 27, 2020 at 6:11 PM Sreekanth Reddy
<sreekanth.reddy@broadcom.com> wrote:
>
> On Wed, Feb 26, 2020 at 12:12 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, Feb 11, 2020 at 05:18:12AM -0500, suganath-prabu.subramani@broadcom.com wrote:
> > > From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> > >
> > > For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..)and
> > > VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..)should
> > > be within 4 GB boundary.Driver uses limitation of VENTURA_SERIES
> > > to manage INVADER_SERIES as well. So here driver is allocating the DMA
> > > able memory for RDPQ's accordingly.
> > >
> > > For RDPQ buffers, driver creates two separate pci pool.
> > > "reply_post_free_dma_pool" and "reply_post_free_dma_pool_align"
> > > First driver tries allocating memory from the pool
> > > "reply_post_free_dma_pool", if the requested allocation are
> > > within same 4gb region then proceeds for next allocations.
> > > If not, allocates from reply_post_free_dma_pool_align which is
> > > size aligned and if success, it will always meet same 4gb region
> > > requirement
> >
> > I don't fully understand the changelog here, and how having two
> > dma pools including one aligned is all that good.
>
> The requirement is that driver needs a set of memory blocks of size
> ~106 KB and this block should not cross the 4gb boundary (i.e.
> starting & end address of this block should have the same higher 32
> bit address). So what we are doing is that first we allocate a block
> from generic pool 'reply_post_free_dma_pool' and we check whether this
> block cross the 4gb boundary or not, if it is yes then we free this
> block and we try to allocate block once gain from pool
> 'reply_post_free_dma_pool_align' where we alignment of this pool is
> set to power of two from block size. Hoping that second time
> allocation block will not cross the 4 gb boundary.
>
> Is there any interface or API which make sures that it always
> allocates the required size memory block and also satisfies 4bg
> boundary condtion?
>
> >
> > Why not do a single dma_alloc_coherent and then subdvide it given
> > that all the allocations from the DMA pool seem to happen at HBA
> > initialization time anyway, invalidating the need for the dynamic
> > nature of the dma pools.
>
> we need 8 blocks of block size ~106 KB, so total will be ~848 KB and
> most of the times we may not get this much size continuous single
> block memory and also this block should satisfy the 4gb boundary
> requirement. And hence driver is allocating each block individually.
>
> Regards,
> Sreekanth
