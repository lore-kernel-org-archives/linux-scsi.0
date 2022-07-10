Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9901FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jul 2022 16:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiGJQGh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jul 2022 12:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJQGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jul 2022 12:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BA85F7D;
        Sun, 10 Jul 2022 09:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1A2612DB;
        Sun, 10 Jul 2022 16:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39648C341C8;
        Sun, 10 Jul 2022 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657469194;
        bh=iMzCML08JjhbLOY9JMOUUEKaAUvSxeDGOjxjoSTNANQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MD5EwUMvmhnpQ1Vy9bM14/FMBvMw/B0p/0yHe9v4To6hBQjivfDi048PYfB7YMTHp
         8UDCcMixdVic36GJcxhYGNCTpk3RWhx1r/O7GyUKYtQgIgAdku1pA7sl/xdjjXTYgX
         /iUrEeeMtkcqKWVt4tupmSfjFR9Qlp6uf5hzW99zKn4+XlMkO1ND4soQX3ps3E01u/
         UGKnlg54P3Zh70YDzm9roHoYB+32DaAOQcvK4VXDDZaEDEveGuJXlN0gxdcghU7qEz
         YFUZGCAlN7lENnYsiXTGOvgYIS+f6aL80I7CNv7ZtmwkmDgfW5lw5N9s2zsgv1+2Iw
         XZ1bDTxwB0InA==
Received: by mail-yb1-f170.google.com with SMTP id f73so5229860yba.10;
        Sun, 10 Jul 2022 09:06:34 -0700 (PDT)
X-Gm-Message-State: AJIora/cm5nzuKxqt2czV+ew0043SFxMa+g+rteAEqe7+d0E2gWaWIUy
        BrlzgKq6RHZcC0WPwy60yBb2hdHFdro4kKoYKfI=
X-Google-Smtp-Source: AGRyM1ungRtXcFvD8MS0lXUNL0bQrEv5LVbxb+EocTFI94AagbZCU4+bxu6oF8yat49PRRtT1r8kuCpoMdx0ygy0ilM=
X-Received: by 2002:a25:7c41:0:b0:66d:766a:4815 with SMTP id
 x62-20020a257c41000000b0066d766a4815mr13505622ybc.480.1657469193329; Sun, 10
 Jul 2022 09:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-2-schmitzmic@gmail.com>
In-Reply-To: <20220709001019.11149-2-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 10 Jul 2022 18:06:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2kwg56-UTv275GJ1r_SDsfoX2fMcmXrvNURN+L3UHoSA@mail.gmail.com>
Message-ID: <CAK8P3a2kwg56-UTv275GJ1r_SDsfoX2fMcmXrvNURN+L3UHoSA@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] m68k - add MVME147 SCSI base address to mvme147hw.h
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
> index e28eb1c0e0bf..fd8c1e4fc7be 100644
> --- a/arch/m68k/include/asm/mvme147hw.h
> +++ b/arch/m68k/include/asm/mvme147hw.h
> @@ -93,6 +93,7 @@ struct pcc_regs {
>  #define M147_SCC_B_ADDR                0xfffe3000
>  #define M147_SCC_PCLK          5000000
>
> +#define MVME147_SCSI_BASE      0xfffe4000

I think this should be an 'void *__iomem' token, not a plain integer.
Apparently the driver internally uses a 'volatile void *', but some of
the other front-ends are already converted to use __iomem.

        Arnd
