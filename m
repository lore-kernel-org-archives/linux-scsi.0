Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0611C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 06:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiF2GCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiF2GCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 02:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9558B2AC61;
        Tue, 28 Jun 2022 23:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F39361864;
        Wed, 29 Jun 2022 06:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7268EC3411E;
        Wed, 29 Jun 2022 06:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656482561;
        bh=fZfmzQBSj+wDWPm6lqcswxSxSADwVyfsWiZl/h1hLRI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tgzzLj9Q4ZVZm91CWxfFWcZemjKTbJWq/LFNJngqQqMKlAh2tz3Ctg/VlRTR3rl2b
         t0Duw6aHMDdfapdg+3x0966N3YI3gQ7mE8MBCWQTwDZXY+uL37I6qQJd3aJoKoUNZj
         xWJNRRjRo0gR/phZ2wwrq40VZdcznmhHhA1oI4RonZYllLVw6c2iziRhwbpvi844QS
         MTtzFhhLCMVT3yG83Iv4wq11xWjYODSLG99eMt23msehKBT1QWtlmt8+88tIZikbgz
         Du9xDThqzbJin8IkbrAL46ffzer2n9gjMSJ18iO9tCySUDd1/HOpRaEmpqxdCEZp6T
         eJyJA6vOrR4Gg==
Received: by mail-yb1-f171.google.com with SMTP id l11so26037260ybu.13;
        Tue, 28 Jun 2022 23:02:41 -0700 (PDT)
X-Gm-Message-State: AJIora/WAL4nNoZiPtotBjFSWT99pLMTWqCM7ytfWm2MZ0xzhgr7BW0c
        nFND/j0gIqOs+uJWM5XwUE3aV2rXoJOxbKS6FAE=
X-Google-Smtp-Source: AGRyM1vax2z1/7bbqRyMwyprtGXiQsl0QcyiehvPjzSH3hlfMmus9DcEe/FWsZa3xdte0283XPJWodjeKbv3gKO2CxM=
X-Received: by 2002:a25:8b8b:0:b0:669:b37d:f9cd with SMTP id
 j11-20020a258b8b000000b00669b37df9cdmr1591774ybl.394.1656482560488; Tue, 28
 Jun 2022 23:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <20220629011638.21783-4-schmitzmic@gmail.com>
In-Reply-To: <20220629011638.21783-4-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 29 Jun 2022 08:02:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a396Qg3FNrKrPTKwX9mxkZgfE9EzMAq473rLAyK=Lmr_Q@mail.gmail.com>
Message-ID: <CAK8P3a396Qg3FNrKrPTKwX9mxkZgfE9EzMAq473rLAyK=Lmr_Q@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] scsi - gvp11.c: convert m68k WD33C93 drivers to
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
> Use dma_map_single() for gvp11 driver (leave bounce buffer
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
