Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91033C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 08:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiFNIAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 04:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiFNIAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 04:00:37 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991049E;
        Tue, 14 Jun 2022 01:00:34 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id n197so5841792qke.1;
        Tue, 14 Jun 2022 01:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UwqQBif62pfk96bb34/7O5EloXnDszc4ir5IVolTz3g=;
        b=hdTHzFQ88zMSuLlQwR/BAMHsRr9N/6OvvFoBzLAmMx3oH1B+/go0WxQP2RogboQjdh
         Q5SicRfa/0gnKidc63j2MMQDHl2NfoI2NT/yUbvQhXdu5f3aZpLJ5l4lfpIQeLpk1fd4
         MWaiInN4Nj1OxVlNZ3nu4d6mkYQns2NPEop6GPDwghXG+I49EdD6EqXB/R1xAio2SzsF
         JlMXCMgIEUjyceX/flgajEwa7r0fKOrWpQ4TU8zPcTiZFPKTLrBwHQvX/SohxJ722iOV
         LAC5AktADDgm9FRLk+Hb2Tk5xfq09NK0TE8ce5LL+WK+jwCFIGVAe5nt06usNB6GfkZw
         thdA==
X-Gm-Message-State: AOAM531o3vZDczHj395n29Rj12RBrkvM+qsrdLtL37hOpsvMvhSBvwJk
        t6KGjxe+5sCIiRCEIjGJdF671Wqt+DPgMQ==
X-Google-Smtp-Source: ABdhPJyO5TT5P4K7NsU5lwZsyEm2L/MSCC4kofYWkftuljEnHuUMT3I0cKVG/H0KnAFLTljEIj8QNA==
X-Received: by 2002:ae9:dd03:0:b0:6a7:1c2a:bbea with SMTP id r3-20020ae9dd03000000b006a71c2abbeamr2933196qkf.769.1655193633514;
        Tue, 14 Jun 2022 01:00:33 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id k15-20020a05620a138f00b006a73654c19bsm8306604qki.23.2022.06.14.01.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 01:00:33 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id x38so13826352ybd.9;
        Tue, 14 Jun 2022 01:00:32 -0700 (PDT)
X-Received: by 2002:a25:818c:0:b0:664:a584:fafd with SMTP id
 p12-20020a25818c000000b00664a584fafdmr3587127ybk.543.1655193632753; Tue, 14
 Jun 2022 01:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220603110524.1997825-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20220603110524.1997825-1-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jun 2022 10:00:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWY7OpB=F3sUoBEpMyJx9U=+YJBFrVd59y=wdsEvN=4JA@mail.gmail.com>
Message-ID: <CAMuHMdWY7OpB=F3sUoBEpMyJx9U=+YJBFrVd59y=wdsEvN=4JA@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] treewide: ufs: Add support for Renesas R-Car UFS controller
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, avri.altman@wdc.com,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        scsi <linux-scsi@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Fri, Jun 3, 2022 at 5:40 PM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> This patch series adds support Renesas R-Car S4-8 UFS controller.
> This controller has some restrictions so adds some quirks for it.
>
> Yoshihiro Shimoda (7):
>   dt-bindings: ufs: Document Renesas R-Car UFS host controller
>   ufs: add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS
>   ufs: add UFSHCD_QUIRK_HIBERN_FASTAUTO
>   scsi: ufs-renesas: Add support for Renesas R-Car UFS controller
>   scsi: MAINTAINERS: Add maintainer for Renesas UFS driver
>   arm64: dts: renesas: r8a779f0: Add UFS node
>   arm64: dts: renesas: r8a779f0: spider-cpu: Enable UFS device

I see you have applied this series, including the DTS parts, to
your for-next tree. Please never apply DTS patches to the SCSI tree,
as they are meant to go in through the soc tree.

Can you please drop the last two patches from your tree?
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
