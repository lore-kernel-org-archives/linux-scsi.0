Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E143C6FA8F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 18:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbjH3SiW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242235AbjH3HcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 03:32:25 -0400
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CEBCC9;
        Wed, 30 Aug 2023 00:32:22 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-ccc462deca6so4940684276.0;
        Wed, 30 Aug 2023 00:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693380741; x=1693985541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YiMzLoE5Q+zRkThtoGKTqX07/QOz8BBNWArS9Mxfso=;
        b=MbQqBm3emLZILLL1ySORtOLgjT4ACijvvI2Iiy877jatwsrrkimgou9UhKSYMuru8X
         Q1GR18rAJ1A/BO+qmmrcTbEmSlaLgepa2H6VyrxqEhVfi/F8GI/0JXL8Vp7xazhRNtML
         CDBjdsRVgRCkWH98N1cmOHB7cDOtLXwxMbLVRxmriwSvZen88aI0xCTs1Rt7DRnGqLeF
         ZJc6tbvGkkWqlIO7cWaC70+2wScdTwCcVzGEfgi1n9csoq6lsQ2ESBtN3iPQwkDztj0X
         5N9jtpyQQBkKnGdmPZhlrMd0kednn8eyUo4gUkKXIGhfi577SHnn5oqizgIBAl/e7n+X
         72sg==
X-Gm-Message-State: AOJu0Yw3U82WHyW5+EL+v7fKlWwkdpmRE+DyAs0FLXvNN2kvHcTqQYHK
        g/ru8svkXxVthV920Om15YgNlbQPNoe28g==
X-Google-Smtp-Source: AGHT+IH6AmQBL5iWQ+fuCTxyeAZAdGuPRN1lJglwtUleIWj6uDIY9UEUBHtWLygPmv5kVe3RRcemMg==
X-Received: by 2002:a25:768e:0:b0:d47:8db3:8bc8 with SMTP id r136-20020a25768e000000b00d478db38bc8mr1458958ybc.21.1693380741059;
        Wed, 30 Aug 2023 00:32:21 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id i17-20020a25f211000000b00d712798a09bsm2473700ybe.64.2023.08.30.00.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 00:32:20 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5925e580f12so60165327b3.3;
        Wed, 30 Aug 2023 00:32:20 -0700 (PDT)
X-Received: by 2002:a25:5f4d:0:b0:d16:4c3c:b5fb with SMTP id
 h13-20020a255f4d000000b00d164c3cb5fbmr1219242ybm.51.1693380740357; Wed, 30
 Aug 2023 00:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230829214517.14448-1-schmitzmic@gmail.com> <4a7d0dda-c24f-4875-892f-c8c5ef700882@app.fastmail.com>
 <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
In-Reply-To: <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 30 Aug 2023 09:32:08 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU-VmQcH+envdwFpRmMF2RpdZb3FE60u1RPROXwWzsbMw@mail.gmail.com>
Message-ID: <CAMuHMdU-VmQcH+envdwFpRmMF2RpdZb3FE60u1RPROXwWzsbMw@mail.gmail.com>
Subject: Re: [PATCH] scsi: gvp11: add module parameter for DMA transfer bit mask
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

On Wed, Aug 30, 2023 at 12:26 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> On 30/08/23 10:05, Arnd Bergmann wrote:
> > On Tue, Aug 29, 2023, at 17:45, Michael Schmitz wrote:
> >> SCSI boards on Amiga. There now is no way to set a non-default
> >> DMA mask on these boards.
> > It might help to mention here in which cases the default mask
> > is actually wrong.
>
> All I have is:
>
> Probably it's needed on A2000 with an accelerator card and GVP II SCSI,
> to prevent DMA to RAM banks that do not support fast DMA cycles.
>
> from Geert's reply. I can add that. It just did sound a shade
> speculative...

Apparently gvp11_setup() became unused in 2.3.13pre2 (in 1999), when all
*_setup() functions were removed from init/main.c, and some of them were
reimplemented using __setup() in the driver sources where they belonged.

> >> +module_param(gvp11_xfer_mask,  int, 0444);
> >> +MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
> >> +
> > I think the comment is the wrong way round, it should be
> > 0x00ffffff in this case, which also matches the default
> > mask for ZORRO_PROD_GVP_SERIES_II, in the match table:
> >
> > static struct zorro_device_id gvp11_zorro_tbl[] = {
> >          { ZORRO_PROD_GVP_COMBO_030_R3_SCSI,     ~0x00ffffff },
> >          { ZORRO_PROD_GVP_SERIES_II,             ~0x00ffffff },
> >          { ZORRO_PROD_GVP_GFORCE_030_SCSI,       ~0x01ffffff },
> >          { ZORRO_PROD_GVP_A530_SCSI,             ~0x01ffffff },
> >          { ZORRO_PROD_GVP_COMBO_030_R4_SCSI,     ~0x01ffffff },
> >          { ZORRO_PROD_GVP_A1291,                 ~0x07ffffff },
> >          { ZORRO_PROD_GVP_GFORCE_040_SCSI_1,     ~0x07ffffff },
> >          { 0 }
> > };

The default masks above were added (in some other form) in 2.1.91pre1
(in 1998).  Before, people had to use gvp11_setup() to do that.

So I think it is safe to assume there is no longer a need to configure
this manually.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
