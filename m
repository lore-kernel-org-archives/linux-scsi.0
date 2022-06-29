Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4895CCCA47F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 06:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiF2GHR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiF2GG5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 02:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515D2C656;
        Tue, 28 Jun 2022 23:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5ADD61865;
        Wed, 29 Jun 2022 06:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E40C341CC;
        Wed, 29 Jun 2022 06:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656482803;
        bh=xnA/BTZPUlevudpAes3R9CuLzL5s4QtMzhgHxCM8950=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hf3EUau2Ui29RfA5+FL1sEAMXz/TEBviEGj9MtlrOK4JhTy4negjKxUqka2DywmNr
         YsQc6kBI76B/ACQ8Me3Pw6ZlIAw6x0tPMV5vNNRfipknNgv+ZsPl73zuKezviDUL5S
         jTQc8JDaLCaLER4QGLXPo3aaQ0Gkc3bPVhCUsVEfpR1eglcar1Si39tjgfQ2KOmETu
         YF5lgG1VJODt/ANrsGuAokAZIIwuNNsDTbt8HgcgIv3jRm/5pgjwI+oNub/BdMWJkp
         7Oudm/6TYFIysTJ5y00nOi2EBFrXJsvr1nAJwQfVQ0kyxdXOmBG0qmFXgEcoyLMRC7
         9ACoO450/3h0w==
Received: by mail-yb1-f175.google.com with SMTP id i7so26045646ybe.11;
        Tue, 28 Jun 2022 23:06:43 -0700 (PDT)
X-Gm-Message-State: AJIora+ERVdEHWxIT158yR77fth7ec2xIe6A/6zJtpl9NQz4XonP2x/y
        E5sTjCYgcsv62KKC2cW72bNNRO35pwE7ED00avY=
X-Google-Smtp-Source: AGRyM1u9q95dVr1dsnAWrCFLzxDnk8umo+om6oMbHCEK5t4a5fmOMYr25HuN+wvR5aiCnjWUxS9BHjbH6k5fLg/xhMg=
X-Received: by 2002:a25:d60d:0:b0:66c:c951:3eb1 with SMTP id
 n13-20020a25d60d000000b0066cc9513eb1mr1626241ybg.550.1656482802388; Tue, 28
 Jun 2022 23:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <20220629011638.21783-3-schmitzmic@gmail.com>
In-Reply-To: <20220629011638.21783-3-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 29 Jun 2022 08:06:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
Message-ID: <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to
 DMA API
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
> Use dma_map_single() for a2091 driver (leave bounce buffer
> logic unchanged).
>
> Use dma_set_mask_and_coherent() to avoid explicit cache
> flushes.
>
> Compile-tested only.
>
> CC: linux-scsi@vger.kernel.org
> Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> +
> +       addr = dma_map_single(hdata->dev, scsi_pointer->ptr,
> +                             len, DMA_DIR(dir_in));
> +       if (dma_mapping_error(hdata->dev, addr)) {
> +               dev_warn(hdata->dev, "cannot map SCSI data block %p\n",
> +                        scsi_pointer->ptr);
> +               return 1;
> +       }
> +       scsi_pointer->dma_handle = addr;
>
>         /* don't allow DMA if the physical address is bad */
>         if (addr & A2091_XFER_MASK) {
> +               /* drop useless mapping */
> +               dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
> +                                scsi_pointer->this_residual,
> +                                DMA_DIR(dir_in));

I think you could save the extra map/unmap here if you wanted, but that
would risk introducing bugs since it requires a larger rework.

> +               scsi_pointer->dma_handle = (dma_addr_t) NULL;
> +
>                 wh->dma_bounce_len = (scsi_pointer->this_residual + 511) & ~0x1ff;
>                 wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
>                                                 GFP_KERNEL);

Not your bug, but if there is memory above the A2091_XFER_MASK limit,
this would need to use GFP_DMA instead of GFP_KERNEL.

         Arnd
