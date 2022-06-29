Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34057C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 15:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiF2Ps1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 11:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiF2Ps0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 11:48:26 -0400
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5532819C24;
        Wed, 29 Jun 2022 08:48:26 -0700 (PDT)
Received: by mail-qv1-f54.google.com with SMTP id u7so2973000qvm.4;
        Wed, 29 Jun 2022 08:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wz7eXw2S/QC34F3xFIRIyGegcwsmPmEWtkGOYyZ4CJs=;
        b=XqiqVDuzZMRuF+vY+69VxcoqYxwLYQdJCu1xMyB6GuWR88AEkyN3YMiQRu59aJgBoo
         upo+fotWvT393xrp9RPZogQxXSwqU1oKBSl5rPLwAg0CazPfMXWYyTRHlzn1Ti6l0Q0z
         rw5WUnbHPeUqVSi3wL88AH0Toxud9yH6DAac0d8oULPUWlXFnzPgD2HLNHhpWJC29gVZ
         1ih6c5mQN+yGl5saRDS+MX10u74mFKosnnw56J8tTMYnF9ioCP0Ru0iGipRlEDUR8wi8
         NI+uEvmzlEjtw8PAksegzqzaiOdMuJxTTEaYDphH0tKBzRGvGPfhUAIC1l2laXrHQC5/
         fGEQ==
X-Gm-Message-State: AJIora86mcb240W3MkR+28d1bk4ZSWLDWh/u9aJ8R3UQFeiaKiub+M2I
        vEo0BGlWKhhX8AmGMyOwZqxD4+fsOmCo/w==
X-Google-Smtp-Source: AGRyM1ssar9h9aO7Lfeqm/vCNjXyx4TCSGzBV73PAWTbQGOunltWikuGzWQHeJ4KhJC+9End3fcNkw==
X-Received: by 2002:ad4:5d62:0:b0:470:7781:b692 with SMTP id fn2-20020ad45d62000000b004707781b692mr7028192qvb.1.1656517705336;
        Wed, 29 Jun 2022 08:48:25 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id s12-20020a05620a29cc00b006a36b0d7f27sm14311701qkp.76.2022.06.29.08.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 08:48:25 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-31bf327d4b5so62846637b3.13;
        Wed, 29 Jun 2022 08:48:24 -0700 (PDT)
X-Received: by 2002:a81:a092:0:b0:318:5c89:a935 with SMTP id
 x140-20020a81a092000000b003185c89a935mr4773748ywg.383.1656517704763; Wed, 29
 Jun 2022 08:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
 <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com> <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
In-Reply-To: <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Jun 2022 17:48:12 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWcZdN6kZ4pHZfybd9qtPbYVtcys+VOUG+HXvX3rPFwjA@mail.gmail.com>
Message-ID: <CAMuHMdWcZdN6kZ4pHZfybd9qtPbYVtcys+VOUG+HXvX3rPFwjA@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

On Wed, Jun 29, 2022 at 10:21 AM Arnd Bergmann <arnd@kernel.org> wrote:
> Regarding the amiga_chip_alloc(), I don't know what this means
> for caching. If chip memory is cache-coherent (either uncached
> or by snooping), then there should not be any
> dma_map()/dma_unmap() for that case, but instead the
> amiga_chip_alloc() function should return both the pointer
> and the dma_addr_t token.

Chip RAM is mapped uncached.
Amifb remaps it using ioremap_wt() to get a write-through frame buffer.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
