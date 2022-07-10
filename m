Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA70AC43334
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jul 2022 16:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiGJQMS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jul 2022 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGJQMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jul 2022 12:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0374ED107;
        Sun, 10 Jul 2022 09:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DF74612ED;
        Sun, 10 Jul 2022 16:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CEAC341C8;
        Sun, 10 Jul 2022 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657469535;
        bh=1a8RhVZhJAlIic8t7LTAfzOJRsi+xvs2HaEgv/F0dkk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oYi9pda2FFd0icYDw41L5sFJQe6n5HgqyhFkU1qBqqTHDnEd1rOz/96bq7qDhHkYM
         oyzvy4KLznRi99MbVwYYbxlrN+vByAUOpNaLS/Tv/aHTya4TZYSToiFud6V1nNRgH7
         JYQ9gKQW2IPfZQPoViUJlt1jZZkJyXIvKifUesg0SggLw25sMWFFAE4ZZ4uCSs7fo6
         8qxfLOe1SPK/k/bXN+0e0tZKFtcqrpC2OzjkDag/zxTs5NzNNXOyrUu+4CxXGeA7xd
         QZhDiuRgQrDqYGVimMiQOP6g6Fx1UMYtIHt+s6/BhU267Y+d4e6A/yjWLZJGaFWf/6
         rSFZoEk0TyNJA==
Received: by mail-yb1-f172.google.com with SMTP id h62so2646882ybb.11;
        Sun, 10 Jul 2022 09:12:15 -0700 (PDT)
X-Gm-Message-State: AJIora9ucD/797uZsHW0mEHIPpIX6poIXj+cQn0eJh14inY/n35UBdU+
        ktCSo5bPZBYsu5Uuqu98dtqVUN0jGm50huOoaWE=
X-Google-Smtp-Source: AGRyM1vugHkWVEUPS9DZ1imxiik9ydOWucgh7hpEd285tATMbswYIdcAYZ5l8z+6yShYi02bc1XhQpAWqxujPHA8kvs=
X-Received: by 2002:a25:9f87:0:b0:669:4345:a8c0 with SMTP id
 u7-20020a259f87000000b006694345a8c0mr13864683ybq.472.1657469534931; Sun, 10
 Jul 2022 09:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-4-schmitzmic@gmail.com>
In-Reply-To: <20220709001019.11149-4-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 10 Jul 2022 18:11:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
Message-ID: <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>
> Convert the mvme147_scsi driver to a platform device driver.
> This is required for conversion of the driver to the DMA API.
>
> CC: linux-scsi@vger.kernel.org
> Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

The patch looks correct to me, but the type cast for the address doesn't
seem right:

> -       regs.SASR = (volatile unsigned char *)0xfffe4000;
> -       regs.SCMD = (volatile unsigned char *)0xfffe4001;
>
> -       hdata = shost_priv(mvme147_shost);
> +       mvme147_inst->base = mres->start;
> +       mvme147_inst->irq = ires->start;
> +
> +       regs.SASR = (volatile unsigned char *)mres->start;
> +       regs.SCMD = (volatile unsigned char *)(mres->start)+0x1;

A resource would pass a phys_addr_t token, but the driver expects a
virtual address that should be an __iomem pointer. The MMIO area
already gets mapped into virtual addresses in arch/m68k/kernel/head.S,
so it makes sense to skip the extra ioremap() and just use the address,
but then you can't pass it as an IORESOUCRE_MEM token and should
use platform_data with the pointer instead.

The alternative is to do it the normal way and pass the physical address
as a resource, that you can pass into devm_platform_ioremap_resource()
or a similar helper.

       Arnd
