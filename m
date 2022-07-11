Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E5CCCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 07:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiGKHQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 03:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiGKHQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 03:16:24 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC7AC41;
        Mon, 11 Jul 2022 00:16:23 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id g6so6351289qtu.2;
        Mon, 11 Jul 2022 00:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wedE63FcPbf/4vBfAtxK449esBGNm+XPK5Lks7qID9Y=;
        b=Big8YPpgRbH+YjyEB9sB1UvJgp0vVhKO9xdtR9RCEz9BrCrfJboVQ85SM2CG/8wwBo
         gGkbTz4xxDtx7uSHooV8R5AMGU9EDRzIWxVyIvjo6k+GhGQnKvZa60yKsEromTaVgPey
         138619LGmP1h1E9Zm0ILCyRpEuljDdZGJLdZ81G5d/AJve7E5tfPdCeSNGwugvY2ODMe
         +pGcpxtAallil6ZXRMFJA7vbtouQeC88GvkIMKf7utEC7Jf1YwyfG19GDqQFVTzEx1oD
         Nr07lv/3mi7Cnh2nDWDIZLgsoDDoK0ghMMpvczgsd/ubalZD2BzKuKD0g2+pOwaXOAcb
         ZHjg==
X-Gm-Message-State: AJIora/GRxgnTnfaa6oJyBekCf85HFaGddIhqgrEsxfCRIEbWTJoU9hv
        mw5sas4JSe56XObQQNjC7dDek8AWGXH4sg==
X-Google-Smtp-Source: AGRyM1tm8FR/1yG8PurYZoFzpy63o4yAXCDBBdA4cf+Fms2YR5YEjOrnJokzTL/10hAGpoWxFe0CAw==
X-Received: by 2002:a05:622a:44:b0:31e:b6a9:69b0 with SMTP id y4-20020a05622a004400b0031eb6a969b0mr1357452qtw.540.1657523781182;
        Mon, 11 Jul 2022 00:16:21 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id r14-20020a05620a03ce00b006b46ad28ba7sm5586214qkm.84.2022.07.11.00.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 00:16:20 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id 75so6039545ybf.4;
        Mon, 11 Jul 2022 00:16:20 -0700 (PDT)
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr16228553ybh.36.1657523780563; Mon, 11
 Jul 2022 00:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
In-Reply-To: <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 11 Jul 2022 09:16:08 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
Message-ID: <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 10, 2022 at 6:12 PM Arnd Bergmann <arnd@kernel.org> wrote:
> On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> > Convert the mvme147_scsi driver to a platform device driver.
> > This is required for conversion of the driver to the DMA API.
> >
> > CC: linux-scsi@vger.kernel.org
> > Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
> > Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>
> The patch looks correct to me, but the type cast for the address doesn't
> seem right:
>
> > -       regs.SASR = (volatile unsigned char *)0xfffe4000;
> > -       regs.SCMD = (volatile unsigned char *)0xfffe4001;
> >
> > -       hdata = shost_priv(mvme147_shost);
> > +       mvme147_inst->base = mres->start;
> > +       mvme147_inst->irq = ires->start;
> > +
> > +       regs.SASR = (volatile unsigned char *)mres->start;
> > +       regs.SCMD = (volatile unsigned char *)(mres->start)+0x1;
>
> A resource would pass a phys_addr_t token, but the driver expects a
> virtual address that should be an __iomem pointer. The MMIO area
> already gets mapped into virtual addresses in arch/m68k/kernel/head.S,
> so it makes sense to skip the extra ioremap() and just use the address,
> but then you can't pass it as an IORESOUCRE_MEM token and should
> use platform_data with the pointer instead.
>
> The alternative is to do it the normal way and pass the physical address
> as a resource, that you can pass into devm_platform_ioremap_resource()
> or a similar helper.

I would prefer the latter.  While head.S sets up the mapping,
__ioremap() does not have support for this on the mvme platform,
so this has to be added first. Look at the amiga and virt platforms
for examples.

If you do want to pass the virtual address as platform data (for now
;-), please provide the physical memory resource too, so we don't
have to go through another synchronization step with the m68k and
scsi trees later.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
