Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F77DCCA47C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 06:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiF2GT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiF2GTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 02:19:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020101E3DA;
        Tue, 28 Jun 2022 23:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90E3560B1D;
        Wed, 29 Jun 2022 06:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0857EC341CC;
        Wed, 29 Jun 2022 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656483564;
        bh=oSdgUaghy4HmemU1HiGmqBMzm//khTRC6FXfwhpdLe0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KOuco2BKQiFFhnMTfkmVi6wC6evp8Z1fGgs66fyRsvODLmjxaoO8fNnW3OKy6gOUJ
         TCCroKROz/K0347arbDQdklK6SCeL7DlZ+mloGefeeYjs0TbXm3xkR3D2gtAQtJRqs
         z/jJMkEk8KRsMwON3bA6DVwg/43oX6xZygRlN851cXJDiahkqO9labxKhcIJCKhXMe
         YwCoaV2MXw4u97uEHNV4YEcnPF8GAScb3EVWV1yNDvND3RPtCoLXK4EbyZU86kDgpz
         cqdelaEB3SfApgl/3JVI3DlmrNxvI9MwsZRZHtfNYKkZPRrps+eElcMioSRKJMqx/D
         wMM7iFITXYIpQ==
Received: by mail-yb1-f170.google.com with SMTP id q132so26100227ybg.10;
        Tue, 28 Jun 2022 23:19:23 -0700 (PDT)
X-Gm-Message-State: AJIora98AS4t7vYYcee2ZG8Gq49/Eu8/Zb9J0rjFf4NUM5/r2jETfk3P
        V276OJIUYvdJPW6dNG2E/hng0PgB8aNqRdbz+KA=
X-Google-Smtp-Source: AGRyM1vYbv5mCvhz/4H2B2157SYDknMbJ3xbujwZ7EiyY5HFmAKHEbWES0zRl2e02uXrdBdzXa3ZuperaXU1T0ly6Tg=
X-Received: by 2002:a25:9f87:0:b0:669:4345:a8c0 with SMTP id
 u7-20020a259f87000000b006694345a8c0mr1701776ybq.472.1656483562970; Tue, 28
 Jun 2022 23:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com>
In-Reply-To: <20220629011638.21783-1-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 29 Jun 2022 08:19:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
Message-ID: <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 29, 2022 at 3:16 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>
> V1 of a patch series to convert m68k Amiga WD33C93 drivers to the
> DMA API.
>
> This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
> m68k WD33C93 still used virt_to_bus to convert virtual addresses to
> physical addresses suitable for the DMA engines (note m68k does not
> have an IOMMU and uses a direct mapping for DMA addresses).
>
> Arnd suggested to use dma_map_single() to set up dma mappings instead
> of open-coding much the same in every driver dma_setup() function.
>
> It appears that m68k (MMU, except for coldfire) will set up pages for
> DMA transfers as non-cacheable, thus obviating the need for explicit
> cache management.

To clarify, the dma-mapping API has two ways of dealing with this:

- the streaming API (dma_map/unmap_...) uses explicit cache flushes

- the coherent API (dma_alloc_coherent etc) uses page protections
  to prevent caching.

These three drivers use the streaming API because they operate on
data passed in from the outside, so the non-cacheable protection bits
are not used here.

> DMA setup on a3000 host adapters can be simplified to skip bounce
> buffer use (assuming SCSI buffers passed to the driver are cache> Thanks, and Cheers,
>
>    Michael
>

> line aligned; a safe bet except for maybe sg.c input).
>
> On gvp11 and a2091 host adapters, only the lowest 16 MB of physical
> memory can be directy addressed by DMA, and bounce buffers from that
> space must still be used (possibly allocated from chip RAM using the
> custom allocator) if buffers are located in the higher memory regions.
>
> The m68k VME mvme147 driver has no DMA addressing or alignment
> restrictions and can be converted in the same way as the Amiga a3000
> one, but will require conversion to a platform device driver first.

Right, it seems that the old hack of passing a NULL device pointer
no longer works, and that is probably for the better.

If you want an easy way out, the driver can just call
platform_device_register_full() to create its own device with a
dma_mask set up, and use that device for the DMA API, but
not actually match the device to a driver.

> Only compile tested so far, and hardware testing might be hard to do.
> I'd appreciate someone giving this a thorough review.

Looks all good to me.

        Arnd
