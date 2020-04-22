Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5380BC55189
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 09:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226E3206B9
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 09:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YJTn9zmG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDVJSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 05:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726041AbgDVJSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 05:18:17 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9A7C03C1A6
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 02:18:17 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id p13so475300qvt.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 02:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSPQUP7A+DeH39dmFyGyJuy5CrZts0FOGHN3ttYlt5k=;
        b=YJTn9zmGJuiS1lMIv2q2CsEAIqiJd7f5e/nQkmPao2+vG7tQCl6v7x9JLjj/iorFhs
         KCIOVLmtp3UIYrq9Ac7dxqwEXjP4Vs9VABtfLL7SDeABwImsaObc3M/4qWHkj5tu1K8C
         D6YBcOnXTk3goXWN4/3DWARGSwobXQ/FOh42s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSPQUP7A+DeH39dmFyGyJuy5CrZts0FOGHN3ttYlt5k=;
        b=pw14nXz26w6R7Yg3ZLQEE3ziQngQLrBYBU9HAy8XjRkKSUIrmyB1+PYq9EyJFcyeDz
         PL2hQ1Zb13qCebDuzol/xTQvxXy1PXTKNxnKp/qv2KRP3047eA4N7gkQ3lEWlNhu7icD
         84u6XpqQxzmSJTXICdmUNK8ykB7327fod4CfmoQbOlMoBozyQ2Dtrut8+KM009VJX1ze
         saDjD+4XooqvrW/fFCTp7khbYtlqrVSGZcTX1v+oinXwPjG0Puv0uAfOjrk1fhcHNVUl
         nyBYW20uTfou9Z5wW1kqRvM9rsu6ei3VcV+DRcxFlr1EqHKBld4/Kz+RD71TWAdlhjh5
         pJIg==
X-Gm-Message-State: AGi0Puah+7fb6G+bwTB226gJKaKVnILRq+r0TIohYSdtO8czrnTimhKF
        bc5xgf+0JOY73LWfNAKJPARZdqFslv+69bVp6zLOQWf3Z1G8ICfK
X-Google-Smtp-Source: APiQypLxnQL2w/X6sn/EUamSfdgdCspVrNnn3wThC7YWIDF2aaLyABffuFjKW/5dMRu2gltQaVu3Hy+QHbuiiltOsCM=
X-Received: by 2002:ad4:4f01:: with SMTP id fb1mr24923234qvb.162.1587547095757;
 Wed, 22 Apr 2020 02:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1586957125-19460-2-git-send-email-suganath-prabu.subramani@broadcom.com> <20200422063427.GB20318@infradead.org>
In-Reply-To: <20200422063427.GB20318@infradead.org>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Wed, 22 Apr 2020 14:49:42 +0530
Message-ID: <CA+RiK67m6Uk=QLppNcO23C4CnbSO483uwowTg0ZPZ9oRLxOsew@mail.gmail.com>
Subject: Re: [v1 1/5] mpt3sas: Don't change the dma coherent mask after allocations
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <Sathya.Prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

Your original patch always set the dma coherent mask to 32bit.
But in this patch set, we first set the dma coherent to 64bit, if RDPQ
pools crosses
the 4gb boundary then we change it to 32 bit.
Like your original patch we will simplify.

Thanks,
Suganath


On Wed, Apr 22, 2020 at 12:04 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Apr 15, 2020 at 09:25:21AM -0400, Suganath Prabu wrote:
> > From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> >
> > Currently driver is initially setting the dma coherent mask to 32 bit
> > and then after allocating the Reply Descriptor Post Queues(RDPQ) pools
> > it changes the dma coherent mask to 64/63 according to HBA generation.
> >
> > But the DMA layer does not allow changing the DMA coherent mask after
> > there are outstanding allocations.
> >
> > So, updating the driver to stop changing the dma coherent mask after
> > allocations.
> >
> > Rename ioc variable "dma_mask" to "is_dma_32bit" and use it to set 32
> > bit DMA.
> > ---
> > v1 Change log:
> > 1) Incorporated the review comments from Christoph Hellwig
> >
> > Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
>
> I still don't see why you don't simply take my original patch instead.
