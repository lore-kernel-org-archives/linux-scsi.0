Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0A3E71D3E
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 13:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjI2N5L convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 09:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjI2N5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 09:57:10 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EB51A8;
        Fri, 29 Sep 2023 06:57:08 -0700 (PDT)
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-57bb0f5d00aso5925842eaf.1;
        Fri, 29 Sep 2023 06:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695995827; x=1696600627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PAP4l0Hxbk/eOJWv3xiKABg+v2rRJgpEwr5u64onzi0=;
        b=d6z0JWyoQPivk06x4S1ju/CgkXlB9XRYmOCMApMvZbVzkB6N8zZS8QGZUV9HTAGrUj
         7a2nPhIkki5iPBLLq2S+sc8SpO5sAktWyO8cOEWR3b7lVegvWE+YDVO7frG3wjNljg0H
         dMlzRBOPv8fvwqOVtkvpUertoC9AwWc/krcCsZkWoPkMqOBZmSWTe3YCO58CF8JpbBIO
         yTJu3baj2gE8wEPKSnyHs4kEF0LhOBs14OOD2MuqgFVZ2Lon/AfT0AOqnJKhXteZ0N8F
         l9PXuicBWpZQGYFO/wmjLxkU0UixWIqonpzH03sxqFYFavGfRm+BIRN3Fy0tF+LZOuBP
         tkcw==
X-Gm-Message-State: AOJu0YxH6SytKgbP4FZTBCvfUsJAxK7nE69ArF/YkMhit6s9BXlEA8sz
        1LtOgSzHfQXAHEIxhqoLQi8RhyWVvIHzew==
X-Google-Smtp-Source: AGHT+IERP0/hBHMTPYNPHYGXl2xCW3YWzwBD3bjwy0ev0FpQFSJ+oB0192t4ULSlbbnHe3N0yAkrPQ==
X-Received: by 2002:a4a:6c02:0:b0:56e:466c:7393 with SMTP id q2-20020a4a6c02000000b0056e466c7393mr4729915ooc.5.1695995827349;
        Fri, 29 Sep 2023 06:57:07 -0700 (PDT)
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com. [209.85.210.43])
        by smtp.gmail.com with ESMTPSA id r3-20020a4ad4c3000000b0057b74352e3asm2842567oos.25.2023.09.29.06.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 06:57:06 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6c0a42a469dso8425847a34.2;
        Fri, 29 Sep 2023 06:57:06 -0700 (PDT)
X-Received: by 2002:a9d:66cf:0:b0:6bd:152f:9918 with SMTP id
 t15-20020a9d66cf000000b006bd152f9918mr4402953otm.14.1695995825892; Fri, 29
 Sep 2023 06:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230926081507.69346-1-dlemoal@kernel.org> <CAMuHMdX_aNX2FZoydqgZTF+DA1uTt0zxbXcu1FXqeO5tUqry=Q@mail.gmail.com>
 <3a0e6a4d-1a82-0643-e1c0-9a7b1cc55b18@kernel.org>
In-Reply-To: <3a0e6a4d-1a82-0643-e1c0-9a7b1cc55b18@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 29 Sep 2023 15:56:54 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUN0yiMiEjev6gx2tv8eqQoecv6kuHSSztxUhoAvQ9OdA@mail.gmail.com>
Message-ID: <CAMuHMdUN0yiMiEjev6gx2tv8eqQoecv6kuHSSztxUhoAvQ9OdA@mail.gmail.com>
Subject: Re: [PATCH v7 00/23] Fix libata suspend/resume handling and code cleanup
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

On Fri, Sep 29, 2023 at 3:37 PM Damien Le Moal <dlemoal@kernel.org> wrote:
> On 2023/09/28 14:26, Geert Uytterhoeven wrote:
> > On Tue, Sep 26, 2023 at 10:15 AM Damien Le Moal <dlemoal@kernel.org> wrote:
> >> The first 9 patches of this series fix several issues with suspend/resume
> >> power management operations in scsi and libata. The most significant
> >> changes introduced are in patch 4 and 5, where the manage_start_stop
> >> flag of scsi devices is split into the manage_system_start_stop and
> >> manage_runtime_start_stop flags to allow keeping scsi runtime power
> >> operations for spining up/down ATA devices but have libata do its own
> >> system suspend/resume device power state management using EH.
> >>
> >> The remaining patches are code cleanup that do not introduce any
> >> significant functional change.
> >>
> >> This series was tested on qemu and on various PCs and servers. I am
> >> CC-ing people who recently reported issues with suspend/resume.
> >> Additional testing would be much appreciated.
> >
> > JFTR, with current libata/for-next[*], I saw the following with
> > rcar-sata, once (interesting lines marked with "!"):
> >
> >     PM: suspend entry (s2idle)
> >     Filesystems sync: 0.026 seconds
> >     Freezing user space processes
> >  !  ata1.00: qc timeout after 10000 msecs (cmd 0x40)
> >     Freezing user space processes completed (elapsed 0.007 seconds)
> >  !  ata1.00: VERIFY failed (err_mask=0x4)
> >     OOM killer disabled.
> >  !  ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> >     Freezing remaining freezable tasks
> >  !  ata1.00: revalidation failed (errno=-5)
> >     Freezing remaining freezable tasks completed (elapsed 0.002 seconds)
> >     sd 0:0:0:0: [sda] Synchronizing SCSI cache
> >     ata1: link resume succeeded after 1 retries
> >     ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >     ata1.00: configured for UDMA/133
> >     ata1.00: Entering active power mode
> >     ata1.00: Entering standby power mode
> >     ravb e6800000.ethernet eth0: Link is Down
> >     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
> > PHY driver (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=136)
> >     OOM killer enabled.
> >     Restarting tasks ... done.
> >     random: crng reseeded on system resumption
> >     PM: suspend exit
> >     ata1: link resume succeeded after 1 retries
> >     ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >     ata1.00: Entering active power mode
> >     ata1.00: configured for UDMA/133
> >     ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> >
> > Regardless, the disk worked fine after resume.
> >
> > Note that I saw this only once.
>
> I think I found the reason for this, but to confirm, were you doing a suspend
> right after resuming the system ? If yes, that I think I exactly understand the
> issue and why you saw it only once (it is a subtle race with scheduling
> libata-EH suspend/resume operations). I will send a fix next week.

Now you ask that, yes there was a system suspend before.

Relevant log with timing info:

    [  130.177616] PM: suspend exit
    [  130.257981] ata1: link resume succeeded after 1 retries
    [  130.376714] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    [  130.388525] ata1.00: Entering active power mode

so the drive should have been ready here.

    [  140.452669] PM: suspend entry (s2idle)
    [  140.488313] Filesystems sync: 0.026 seconds
    [  140.515957] Freezing user space processes
    [  140.518209] ata1.00: qc timeout after 10000 msecs (cmd 0x40)
    [  140.523384] Freezing user space processes completed (elapsed
0.007 seconds)
    [  140.527718] ata1.00: VERIFY failed (err_mask=0x4)
    [  140.532541] OOM killer disabled.
    [  140.537270] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
    [  140.542069] Freezing remaining freezable tasks
    [  140.546784] ata1.00: revalidation failed (errno=-5)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
