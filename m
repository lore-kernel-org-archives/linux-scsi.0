Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2776CCA47C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 06:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiF2GIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiF2GIZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 02:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069BE101C1;
        Tue, 28 Jun 2022 23:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7270A618B3;
        Wed, 29 Jun 2022 06:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D615FC3411E;
        Wed, 29 Jun 2022 06:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656482886;
        bh=Y0clIUm0kQKL84jG1MkoYmuZWv1Pt6qVIHEJnKsxxLU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WHfscoBjS6qOaKuHnhL0X2oK5v1eZXsWTulP5yJfhX0zW1QGYnybqyBhWlORsJAd9
         qsRPO1cN3UBK5TG6BSTyK+135xR+JIDXPf8nWHz4kE9sZ7hsmcE//8Y9YC95PULpfq
         M2RVO7gpvDB4DuuIqXlLPM9WCBYTGaKF6BCnRhiU0/loy9yctJnq+N7XOtTpdGZyi1
         qzeTitY/I40tNdAu398ZgJOFS+k2cvAq3COXaDxhCESVYwN36H2IVWKkJB/fBoQJyA
         0MWXpyL9oyYefwE7EdSCMa2/Fj/f2vJjkNIoXr2DI9HIz2znvVKYcQRUOReHuk1yNZ
         Var7beve0LjIg==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-31780ad7535so138126807b3.8;
        Tue, 28 Jun 2022 23:08:06 -0700 (PDT)
X-Gm-Message-State: AJIora+NVJWIgxyONEC59ql7DnYXe9gpvyubwdMMwfIyfVRuXFeWFC3o
        wtKIQx7cOtYu+29iLvMUUkQaay87r0S4bfL7BK8=
X-Google-Smtp-Source: AGRyM1tAG5mRPPsnwEJBUZm/Awx1VX65a/yRFNzqHMkP9c4HMk6AWx6uGFfwdrO/fa7qykC7ZMTAjx2wf0qf11KQfnE=
X-Received: by 2002:a81:7742:0:b0:318:35e9:728b with SMTP id
 s63-20020a817742000000b0031835e9728bmr2034646ywc.209.1656482885962; Tue, 28
 Jun 2022 23:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <20220629011638.21783-2-schmitzmic@gmail.com>
In-Reply-To: <20220629011638.21783-2-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 29 Jun 2022 08:07:48 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3__1AqPCjeKkRzNvGfMVvRxPy5rtT7ZFTxiWWhkqv18Q@mail.gmail.com>
Message-ID: <CAK8P3a3__1AqPCjeKkRzNvGfMVvRxPy5rtT7ZFTxiWWhkqv18Q@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] scsi - a3000.c: convert m68k WD33C93 drivers to
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
> Use dma_map_single() for a3000 driver (leave bounce buffer
> logic unchanged).
>
> Use dma_set_mask_and_coherent() to avoid explicit cache
> flushes.
>
> Incorporates review comments by ArndB:
> - drop bounce buffer handling - non-cacheline aligned
>   buffers ought not to happen.
>
> Compile-tested only.
>
> CC: linux-scsi@vger.kernel.org
> Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
