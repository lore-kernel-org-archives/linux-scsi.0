Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813C6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 13:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60C852076E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 13:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m4IkKgPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgHSN6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 09:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgHSN6Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2020 09:58:16 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36AC061383
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2020 06:58:16 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id df16so18192824edb.9
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2020 06:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xkguvOzsgzZf/2nZcmiUdLktaalZbMKG8kwCTKJnbQ=;
        b=m4IkKgPlDJh9Ow/m1Q5dtgZrYLnaRCS7od5vd7CevPl4aSkNJcXDYSbofI9IVrnSM1
         T0Nk8lAEv28vGxYfqJpLVc+ygPg3eNS610ZSiKpYmXTIZXUzbw+fr6qoGPkql89ad0SH
         sz82upHUpsjkfyqDK6oYGAHuFg3NLWv3KpWnw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xkguvOzsgzZf/2nZcmiUdLktaalZbMKG8kwCTKJnbQ=;
        b=L2hPROG0sTGkFU4CL+vRQAo/sS5JdJz8WYenZeywm563H60WLqs6yr11aBvJ5wtPz6
         KActQ+X0q+5UoxXYgOXZRPU6Cux7F25Xo+3yrmb6mxL7lCi3mG+qe2VW4GwWfB62lPk9
         /8bsPr0OfdQ5jOPeEcICTzBqywqCNVO9J08EfF2Z9c6ORLjvWSyloTs6AS13mYgLd6wC
         nFAiii0e2iltcs5GunQCx/7ybnI7DVc3RcDxCJw11lSLt1VsD5xATImnnP6IeT6GsLle
         glixGR2a1y7XWSuGFZGh5Zc7aUkukU1NKRiw4yVzY7xVXWmx5beXCTtaXYvTVX7JHLWc
         79mA==
X-Gm-Message-State: AOAM530iAKlYQW5Ix2BNx0UlI13OWSGWUhtgoQFVZG6f+m6i4xqd8lSB
        xY0rND88sI2f2qvvVq45gp+FwCfUjhTlGA==
X-Google-Smtp-Source: ABdhPJwRZtee2jqyeovG0Zgi0kKuHJSQTVeByDHHWL+/GwTo2o8ATOcYZs4EO6Fjv30zSqlaLDkaRw==
X-Received: by 2002:aa7:c544:: with SMTP id s4mr24644196edr.51.1597845494234;
        Wed, 19 Aug 2020 06:58:14 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id d25sm17936217edr.78.2020.08.19.06.58.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 06:58:11 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id g75so2314195wme.4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2020 06:58:10 -0700 (PDT)
X-Received: by 2002:a1c:5581:: with SMTP id j123mr5137250wmb.11.1597845489930;
 Wed, 19 Aug 2020 06:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-6-hch@lst.de>
 <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com> <20200819135454.GA17098@lst.de>
In-Reply-To: <20200819135454.GA17098@lst.de>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 19 Aug 2020 15:57:53 +0200
X-Gmail-Original-Message-ID: <CAAFQd5BuXP7t3d-Rwft85j=KTyXq7y4s24mQxLr=VoY9krEGZw@mail.gmail.com>
Message-ID: <CAAFQd5BuXP7t3d-Rwft85j=KTyXq7y4s24mQxLr=VoY9krEGZw@mail.gmail.com>
Subject: Re: [PATCH 05/28] media/v4l2: remove V4L2-FLAG-MEMORY-NON-CONSISTENT
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        alsa-devel@alsa-project.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-ia64@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 19, 2020 at 3:55 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Aug 19, 2020 at 01:16:51PM +0200, Tomasz Figa wrote:
> > Hi Christoph,
> >
> > On Wed, Aug 19, 2020 at 8:56 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > The V4L2-FLAG-MEMORY-NON-CONSISTENT flag is entirely unused,
> >
> > Could you explain what makes you think it's unused? It's a feature of
> > the UAPI generally supported by the videobuf2 framework and relied on
> > by Chromium OS to get any kind of reasonable performance when
> > accessing V4L2 buffers in the userspace.
>
> Because it doesn't do anything except on PARISC and non-coherent MIPS,
> so by definition it isn't used by any of these media drivers.

It's still an UAPI feature, so we can't simply remove the flag, it
must stay there as a no-op, until the problem is resolved.

Also, it of course might be disputable as an out-of-tree usage, but
selecting CONFIG_DMA_NONCOHERENT_CACHE_SYNC makes the flag actually do
something on other platforms, including ARM64.

Best regards,
Tomasz
