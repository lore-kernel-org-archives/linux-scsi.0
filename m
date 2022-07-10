Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729FDC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jul 2022 15:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGJP4l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jul 2022 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJP4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jul 2022 11:56:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7597D7650;
        Sun, 10 Jul 2022 08:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8794CE0BA1;
        Sun, 10 Jul 2022 15:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C926FC3411E;
        Sun, 10 Jul 2022 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657468596;
        bh=tjM2xPoSgOWWofhRatDW9b1gOjkRlx12ysYaWXMf2Tw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MRJtfx/U4MUJvYgqTiEs+iaux6phaCW5lbaNpM4IoBlxNQONqNLh+a5SAbJuFbM+C
         CD/yM/SPvRFF4h0Ka+EUtPxDHHGF4ilsIULQyRiH9gmgLSp3Qp5QHRpZtDOfXzL969
         ixTr0KSxh9a2ptmwsSwvweoQgF1mXTtYTcVLC7dbfnY8oF7UezgkukIoAOCpjyPcyx
         lBCQ6I+/8qnnRnbS8mZTh6f6C2nytSsH3LkcDynFHi7RZ4B+DULheaw5wKffxwnx10
         pcFNPy5haRkxPF1n3mIvkYNuuOfVXzeQphJU9LSbbxi6y2KLgVFSmj9X6NmFRdry5Y
         XjTDDftS+Kk7A==
Received: by mail-yb1-f169.google.com with SMTP id 136so5240631ybl.5;
        Sun, 10 Jul 2022 08:56:36 -0700 (PDT)
X-Gm-Message-State: AJIora9b/L/eCy9n1BwacFcuKiEa/HJUuwTkVQ7MI8vqKnFZQbGrWvsI
        sgxtqiALPWOKXCnaWX1MD85uBLQLpcF2ux9UNss=
X-Google-Smtp-Source: AGRyM1tExm7udUQG57/VpqlX6xxfv4UcD72soelchuSVhZ4ARvOPe2vWriTjXMOLsOWAH+gKeg6ZF2gjKV98hL4PE74=
X-Received: by 2002:a25:8b8b:0:b0:669:b37d:f9cd with SMTP id
 j11-20020a258b8b000000b00669b37df9cdmr13714559ybl.394.1657468595913; Sun, 10
 Jul 2022 08:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-3-schmitzmic@gmail.com>
In-Reply-To: <20220709001019.11149-3-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 10 Jul 2022 17:56:19 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0fisnrP0tO94Fy6ugvrw-KkCmDOpqraK4LC=GfV24rAg@mail.gmail.com>
Message-ID: <CAK8P3a0fisnrP0tO94Fy6ugvrw-KkCmDOpqraK4LC=GfV24rAg@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] m68k - set up platform device for mvme147_scsi
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> +
> +static const struct resource mvme147_scsi_rsrc[] __initconst = {
> +       DEFINE_RES_MEM(MVME147_SCSI_BASE, 0xff),
> +       DEFINE_RES_IRQ(MVME147_IRQ_SCSI_PORT),
> +};

The size should almost certainly be 0x100, not 0xff here.

Otherwise this looks good to me.

       Arnd
