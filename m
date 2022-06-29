Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE4DCCA47C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 16:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiF2QoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 12:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiF2QoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 12:44:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57B02F3B4;
        Wed, 29 Jun 2022 09:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3847561D14;
        Wed, 29 Jun 2022 16:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF54C341CC;
        Wed, 29 Jun 2022 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656521062;
        bh=V2f0cATrgiGMV68Myff+6mhO9+a2GJaZcIePa5rdn90=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fqrBX8CkY92AHeFGdKwtfcdr2meueCqlckjwbieB9FucCu6GBJVvh5fZWu0f/nBKA
         zEwXmQZQveINFFYyBQNinHbK2lKtTlEgGUssAOwU16nbDc6G2pqBl81lFdKJLqGYdX
         Ptix7Gv7gUgUm1rLPp9JKeL2ajgfBeQ6fMT8jmMwMrJTgh+kDapm4GqTKhBITVoeZE
         jV34p7vDICFnB2JS1knZlZWJ/dYgMByUyCS+jyUQ37TM1VaBmKkRSZiZLaAWKRRWml
         RyR1opx5kb8g+jWO2fcJcyt1tKcualFMB8WeXnyDn+iF5toUmS4YhAfnUf+eI5eVm3
         h+Mn3la1m17fQ==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-3178acf2a92so153791887b3.6;
        Wed, 29 Jun 2022 09:44:22 -0700 (PDT)
X-Gm-Message-State: AJIora+2zO4OtwwMhrbzurrbbSDG4X2sVz8BstHxOnvChehHqOjZGFbN
        UsnMF3g+TZnMJoyRPoE5FdAn8lkmz6U89H/+t/k=
X-Google-Smtp-Source: AGRyM1vxZE51YW1O1J3m8vitAIYO137e9Nx4Um0mT0MpLO7Muh9ky4sEd6hDPLxT7WRY3R59/nAJ5JGU748GNwokEfA=
X-Received: by 2002:a81:7742:0:b0:318:35e9:728b with SMTP id
 s63-20020a817742000000b0031835e9728bmr4845437ywc.209.1656521061564; Wed, 29
 Jun 2022 09:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
 <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com> <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
 <CAMuHMdWcZdN6kZ4pHZfybd9qtPbYVtcys+VOUG+HXvX3rPFwjA@mail.gmail.com>
In-Reply-To: <CAMuHMdWcZdN6kZ4pHZfybd9qtPbYVtcys+VOUG+HXvX3rPFwjA@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 29 Jun 2022 18:44:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a32A9eqQoOm9qyWV_XpQQnKyaEg5ULKyi1ZkDpn1onL5Q@mail.gmail.com>
Message-ID: <CAK8P3a32A9eqQoOm9qyWV_XpQQnKyaEg5ULKyi1ZkDpn1onL5Q@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 29, 2022 at 5:48 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> On Wed, Jun 29, 2022 at 10:21 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > Regarding the amiga_chip_alloc(), I don't know what this means
> > for caching. If chip memory is cache-coherent (either uncached
> > or by snooping), then there should not be any
> > dma_map()/dma_unmap() for that case, but instead the
> > amiga_chip_alloc() function should return both the pointer
> > and the dma_addr_t token.
>
> Chip RAM is mapped uncached.
> Amifb remaps it using ioremap_wt() to get a write-through frame buffer.

Ok, so in this case the driver should skip the dma_map_single() cache
management and instead keep converting the chipram address to
a bus address directly. While the driver does an extra cache
flush on the uncached address today, it's clearly not needed and there
is probably a performance benefit to not doing it.

For simplicity, the normal bounce buffer could similarly use
dma_alloc_coherent(), which will also result in an uncached
buffer. If I read this correctly, this will also ensure that the buffer
is within the DMA mask, so if ZONE_DMA is larger than the mask,
it just returns NULL and you have to fall back to the chipram
page, rather than checking the address and freeing the buffer.

       Arnd
