Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66109C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 08:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiGLINL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 04:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiGLINF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 04:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60FF9F069;
        Tue, 12 Jul 2022 01:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B57615F8;
        Tue, 12 Jul 2022 08:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF99C385A2;
        Tue, 12 Jul 2022 08:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657613582;
        bh=5gFlyz4GTdrW2qOIcMlideR6XOBHM7ZqjMqzi905iZE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P9735ohxW+cjkZzMPF2z08nphvep4A9RBNStM2CIdjar4BTOIixETdq10MwpMu1i7
         d7333xsXxGJoTA70syr9aAhxrJxlJzarBoABtIloZpqxfc5QXxrxX6qM7aViwHN+2Q
         1+abSmhDvEk0+mg+k2lzMzoKVpEpTeXM4wgVAhh4hb77yAljjkjiInOi26QhYkAMx/
         FyqMxP/Gaj7iG5ekEMp3EM7ZXPUmCT9MspAXY+Afu80Jwrwhqg6d+mzKl7bp6Hy3tm
         MT6cUtxdFQRDvP9dSs5t4DXtCjgZi5vXtqNT6Jv6+OTXEQNAeibNgOKiUXKDygQvcC
         ppl0zREr56Tdg==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-31c8bb90d09so73085027b3.8;
        Tue, 12 Jul 2022 01:13:02 -0700 (PDT)
X-Gm-Message-State: AJIora+wtuBpUlIKIszLIIR3B2dgS2KYmAFkg5xJt+9BvzFxQ9rWoiXh
        +Y8urIFxSwh8Ly6vZfw7jcELx/43kJt1Qoj6utY=
X-Google-Smtp-Source: AGRyM1v/qLuIWrQCKqd0NOX72fp/jkb29ce6mfVosuWC4V9hDmFWcsI3rRQdcPifXx5yGEvoNdbq8CY3Mv9FA2md0O4=
X-Received: by 2002:a81:9b02:0:b0:31c:9ae4:99ec with SMTP id
 s2-20020a819b02000000b0031c9ae499ecmr23743830ywg.495.1657613581808; Tue, 12
 Jul 2022 01:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220712075832.23793-1-schmitzmic@gmail.com> <20220712075832.23793-3-schmitzmic@gmail.com>
In-Reply-To: <20220712075832.23793-3-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 12 Jul 2022 10:12:45 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2ptjH3VyCjuwQROw8GuOs8CxuhX8dMBxMa5m-Q93yZ_g@mail.gmail.com>
Message-ID: <CAK8P3a2ptjH3VyCjuwQROw8GuOs8CxuhX8dMBxMa5m-Q93yZ_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] m68k - set up platform device for mvme147_scsi
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2022 at 9:58 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> +
> +static const struct resource mvme147_scsi_rsrc[] __initconst = {
> +       DEFINE_RES_MEM(MVME147_SCSI_BASE, 0xff),

Still the wrong size?

> +       DEFINE_RES_IRQ(MVME147_IRQ_SCSI_PORT),
> +};
> +
> +int __init mvme147_platform_init(void)
> +{
> +       struct platform_device *pdev;
> +       int rv = 0;
> +
> +       pdev = platform_device_register_simple("mvme147-scsi", -1,
> +               mvme147_scsi_rsrc, ARRAY_SIZE(mvme147_scsi_rsrc));

I think you actually have to use platform_device_register_full() to pass
a DMA mask here: As I understand it, the dma_set_mask_and_coherent()
call in the driver fails if the device is not already marked as dma
capable by having an initial mask set.

The way this normally works is that the device gets created with a mask
that reflects the capabilities of the bus, while the driver sets a mask
based on what it wants to program into the device, and the dma-mapping
interfaces ensure that we only use the intersection of those.

        Arnd
