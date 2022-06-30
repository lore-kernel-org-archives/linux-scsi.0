Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB06C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 09:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiF3J1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 05:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiF3J1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 05:27:32 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FE43E5E3;
        Thu, 30 Jun 2022 02:27:32 -0700 (PDT)
Received: by mail-qk1-f170.google.com with SMTP id p11so758751qkg.12;
        Thu, 30 Jun 2022 02:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R87iXVpBAiRhNyzS24oAY5vkn2O2gq43QG09RAl+RuY=;
        b=VAsY2MJL0IztFDQqC0fjuMAhWcJ27QPMQgGNak9nW6M10cD9W7ql9Aa22DkysBfNEp
         FcSzbbEaaPXuSCELY0RSBARkIdwao1UWIh5RWM7CwcCmKDKx1KkiWIQUCjHXS6MfsS+G
         Mmnw4MbJUSmAN+KhFZDkEWdyqeHXNicA46KeANwg43nzRP4/zCe3USG8ZB+ZDoB3N/W2
         3BAtBAyxDXHQChVMcgFMsE+4XBuLhYmair7x3tFq3MCJmHZZfAYIky/O71qFwj9T5quE
         p3rz2LC6L5zY8KaoqOAYGNndaY8+4dQxMlOjjcmtdKXlej3URQYCynt9pRHKSvzcQX+T
         +ilw==
X-Gm-Message-State: AJIora+KxrP8oUgrwrmEX6cj598B3YNdnWFs+HJOI3xBe+rEHqTeKIKC
        imv8BJdREopxj6og3Xm7GSXh4DfUsGBOkA==
X-Google-Smtp-Source: AGRyM1uzYkGbpBqTxwEkTHO0t4Vyu/dpm6i+1I9PdIxuFONJomCbAJlZ8ATdwTUE3uVQfuCjyEr/Mg==
X-Received: by 2002:a37:c02:0:b0:6ae:fe17:cae5 with SMTP id 2-20020a370c02000000b006aefe17cae5mr5572608qkm.393.1656581251143;
        Thu, 30 Jun 2022 02:27:31 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id a20-20020a05620a16d400b0069fe1dfbeffsm14943304qkn.92.2022.06.30.02.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 02:27:30 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id l11so32645814ybu.13;
        Thu, 30 Jun 2022 02:27:30 -0700 (PDT)
X-Received: by 2002:a05:6902:905:b0:64a:2089:f487 with SMTP id
 bu5-20020a056902090500b0064a2089f487mr8553999ybb.202.1656581250283; Thu, 30
 Jun 2022 02:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <20220629011638.21783-3-schmitzmic@gmail.com>
 <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
 <554d6fa7-01b7-d3c8-a72a-6474e9c5038e@gmail.com> <CAMuHMdX0x3nL5fhmv2T01o8=H6Gp1jog_MZt9gjFe2A7YyMAuQ@mail.gmail.com>
 <39114583-9c4a-7b19-54d5-516feb556fac@gmail.com>
In-Reply-To: <39114583-9c4a-7b19-54d5-516feb556fac@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 30 Jun 2022 11:27:19 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVFYNc5TPxqjo-NxOPEpVgJ8SkuB-Mb4curd731Z4NE5Q@mail.gmail.com>
Message-ID: <CAMuHMdVFYNc5TPxqjo-NxOPEpVgJ8SkuB-Mb4curd731Z4NE5Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to
 DMA API
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

On Wed, Jun 29, 2022 at 10:48 PM Michael Schmitz <schmitzmic@gmail.com> wrote:
> On 30/06/22 03:55, Geert Uytterhoeven wrote:
> > On Wed, Jun 29, 2022 at 9:27 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> >> Most users will opt for loading the kernel to a RAM chunk at a higher
> >> physical address, making the lower chunk unusable (except as chip RAM),
> >> meaning allocating a bounce buffer within the first 16 MB will most
> >> likely fail anyway AIUI (but Geert would know that for sure).
> > Exactly.  On Zorro III-capable machines, Zorro II RAM is not mapped
> > for general use, but can be used by the z2ram block device.
> Is there any DMA capable memory other than chip and ZorroII RAM on these
> machines?
> > Note that you can use it as a bounce buffer, by looking for and marking
> > free chunks in the zorro_unused_z2ram bitmap.
>
> That would be similar to what amiga_chip_alloc() does, right? Any
> advantages over using chip RAM (faster, perhaps)?

Yes, Z2RAM is faster, as Amiga custom chip DMA does not steal cycles
from Z2RAM.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
