Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95448C32774
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 06:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbiHWGlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Aug 2022 02:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240266AbiHWGls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2022 02:41:48 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAB361139
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 23:41:47 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id f14so9634778qkm.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 23:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KSEL6KbVUUBK+3pPcjKjpFYMy3SDHLT7PrZfydlXkwE=;
        b=FCkjoCuOHX12amTc6euSwdbdjIMpr3EPrGNKJTsE8HchqKFdZWTBneS86acuCjo2rS
         dwLnpgHNFJImE8GAOYojSWY3UH7x8m9TmzqtN8MXwDQi3d2Q7ATzDxM85N6ebFc/cA+t
         lr8MBgRQcE8LrdjmsHV3knt8CMrAcaXKiYa7nxpZ8NilWJOW5MTqIL2tP5U74oqGgHIQ
         6tUgIa5GkHL/g26ubid6FVcL5JG1buLnNMf3BOA7qTos7Oj991+Bud3aoZhEyy4vJCmv
         SKy6ApC4d2k1IP/S8dcJYecG2xtTL00gG0XhxNmRvSI4JV9EjEs9l1zALvs3hsLzYf03
         HQrg==
X-Gm-Message-State: ACgBeo03ZXJUjJmok0HOjjUj/JncMUw2/gNxbglTmQuKcMPCz44VVivS
        TRx8NtpWHxUT5joeczwdPMP/vRuo0BoAlA==
X-Google-Smtp-Source: AA6agR6fwgtUxRK+OqokS87BE5YHBX5qHdKAnGLtSFrBhwmCjkW9paMlQaD3OZ3Ap9VDkY4EF6OxmQ==
X-Received: by 2002:a05:620a:1b83:b0:6bb:43ad:f864 with SMTP id dv3-20020a05620a1b8300b006bb43adf864mr13920047qkb.360.1661236906064;
        Mon, 22 Aug 2022 23:41:46 -0700 (PDT)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id q1-20020a05620a0d8100b006bb2661f3fasm13041532qkl.133.2022.08.22.23.41.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 23:41:44 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-3375488624aso325127737b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 23:41:44 -0700 (PDT)
X-Received: by 2002:a25:cbcf:0:b0:695:2d3b:366 with SMTP id
 b198-20020a25cbcf000000b006952d3b0366mr16620966ybg.365.1661236904316; Mon, 22
 Aug 2022 23:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220816172638.538734-1-bvanassche@acm.org> <decc1ef4-ec85-d947-ec81-ebeaa982f53f@redhat.com>
 <CAMuHMdVDWrLs_KusG8vXA_1z8ORdPnpfxzNqw4jCG_G0D-fn+A@mail.gmail.com> <ecf878dc-905b-f714-4c44-6c90e81f8391@acm.org>
In-Reply-To: <ecf878dc-905b-f714-4c44-6c90e81f8391@acm.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Aug 2022 08:41:31 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW0WzgQjR33hz9om7ahE5StbDCLozVnZzYAS1WEzStR0w@mail.gmail.com>
Message-ID: <CAMuHMdW0WzgQjR33hz9om7ahE5StbDCLozVnZzYAS1WEzStR0w@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, Aug 22, 2022 at 4:52 AM Bart Van Assche <bvanassche@acm.org> wrote:
> On 8/21/22 02:16, Geert Uytterhoeven wrote:
> > It looks like there is a (different) regression in v6.1-rc1 related
> > to s2idle and s2ram, which is not fixed by this patch.  In fact it
> > also happens on boards where SATA is not used, it is just less likely
> > to happen on the non-SATA boards.
> > I still have to bisect it, which may take some time, as the issue is
> > not 100% reproducible.
>
> What kind of regression are you encountering? A crash, a hang or
> something else? Are any call traces available?

A lock-up (magic sysrq does not work) during s2idle.
I tried bisecting it yesterday, but failed.
On v6.0-rc1 (and rc2) it happens ca. 25% of the time, but the closer
I get to v5.19, the less likely it is to happen. Apparently 100
successful s2idle cycles was not enough to declare a kernel good...

    Freezing ...
    Filesystems sync: 0.001 seconds
    Freezing user space processes ... (elapsed 0.001 seconds) done.
    OOM killer disabled.
    Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
    sd 0:0:0:0: [sda] Synchronizing SCSI cache
    sd 0:0:0:0: [sda] Stopping disk

---> hangs here if it happens

    ravb e6800000.ethernet eth0: Link is Down
    sd 0:0:0:0: [sda] Starting disk
    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
PHY driver (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=186)
    ata1: link resume succeeded after 1 retries
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    ata1.00: configured for UDMA/133
    OOM killer enabled.
    Restarting tasks ... done.
    random: crng reseeded on system resumption
    PM: suspend exit
    ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

> I posted another revert earlier today but that revert is for code paths
> not related to suspend/resume functionality. See also
> https://lore.kernel.org/linux-scsi/20220821220502.13685-1-bvanassche@acm.org/

Unlikely to be the case, but I'll give it a try later...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
