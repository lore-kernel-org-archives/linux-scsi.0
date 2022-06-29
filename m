Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2EFCCA47C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 08:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiF2IVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 04:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiF2IVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 04:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83F33BBD9;
        Wed, 29 Jun 2022 01:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D82EB8213E;
        Wed, 29 Jun 2022 08:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CF3C34114;
        Wed, 29 Jun 2022 08:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656490872;
        bh=ZB/IbSB2zt5Y82kQpdITm/JuBefjM3JulUOctQox6Jw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o5wppPhWiHiRo6EKh2ptsNyOW33wnrKR1jB7iWUei0cahX0TOFDE8olvg6CvRpcTw
         F5tIV9QHu8pdkIwcHlX+/Xrt8dbEwXXg1gkv+VmpFDfasDR+VR4Yp4yYO1mJLw3K3/
         llGK1kpqaT1LjMPq2VLNmxOE6XtUvqi6jNUY9qsx04G7uotJ27qpXfZYtdJkv0bn+C
         XV+zXdzQ3C8LVi3CwWSvfOU+a3UbSbxH+Hls5YDo2hUzmXNkKW/CzQzmmMfWtYWJkc
         6bO7gQPK2CQxkqZk8zjgUJ2ihxZxhomQUV69vqFpZ4PmIKJ62JDJDwlZnJY9AqtXPI
         XVu+YMaE/eDMQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-3176b6ed923so140378597b3.11;
        Wed, 29 Jun 2022 01:21:12 -0700 (PDT)
X-Gm-Message-State: AJIora8yFGc6g77W1F3ccuBRrtUBcor2EAUhCuDjn6gTS5F2jcU0BNhu
        h2ejSRIVUY367QcCsssPZSWmUlAnvriOeSlUwPg=
X-Google-Smtp-Source: AGRyM1ubL420P6/uCN3T5iWyIX4VbOEq9cTsQ45L00NwQkLmrYJGN+8Qrg05hjBNlitfJoh4tUBT5oOX4MzWuff+hfU=
X-Received: by 2002:a81:72d7:0:b0:317:917b:8a48 with SMTP id
 n206-20020a8172d7000000b00317917b8a48mr2482318ywc.495.1656490871186; Wed, 29
 Jun 2022 01:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
 <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com>
In-Reply-To: <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 29 Jun 2022 10:20:54 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
Message-ID: <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 29, 2022 at 9:36 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Am 29.06.2022 um 18:19 schrieb Arnd Bergmann:
> > On Wed, Jun 29, 2022 at 3:16 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> >>
> >> V1 of a patch series to convert m68k Amiga WD33C93 drivers to the
> >> DMA API.
> >>
> >> This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
> >> m68k WD33C93 still used virt_to_bus to convert virtual addresses to
> >> physical addresses suitable for the DMA engines (note m68k does not
> >> have an IOMMU and uses a direct mapping for DMA addresses).
> >>
> >> Arnd suggested to use dma_map_single() to set up dma mappings instead
> >> of open-coding much the same in every driver dma_setup() function.
> >>
> >> It appears that m68k (MMU, except for coldfire) will set up pages for
> >> DMA transfers as non-cacheable, thus obviating the need for explicit
> >> cache management.
> >
> > To clarify, the dma-mapping API has two ways of dealing with this:
> >
> > - the streaming API (dma_map/unmap_...) uses explicit cache flushes
> >
> > - the coherent API (dma_alloc_coherent etc) uses page protections
> >   to prevent caching.
> >
> > These three drivers use the streaming API because they operate on
> > data passed in from the outside, so the non-cacheable protection bits
> > are not used here.
>
> I had feared you'd say something along these lines ...
>
> Now that throws up a possible problem for the gvp11 driver: due to the
> need to first map an allocated chunk, then possibly discard that and try
> another allocation strategy, copying of data to the bounce buffer is
> deferred until after the final mapping has been successful. This means
> for writes, we have done the cache flushing before we have actually
> written any data to the buffer.
>
> I don't think it is safe to omit the explicit cache flush for writes in
> this case.

I think it's fine as long as you do things in the correct order: the
copy into the bounce buffer has to be done before the
dma_map_single() here, and conversely, the copy out of the
bounce buffer must happen after the dma_unmap_single().

Regarding the amiga_chip_alloc(), I don't know what this means
for caching. If chip memory is cache-coherent (either uncached
or by snooping), then there should not be any
dma_map()/dma_unmap() for that case, but instead the
amiga_chip_alloc() function should return both the pointer
and the dma_addr_t token.

         Arnd
