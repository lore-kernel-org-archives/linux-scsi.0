Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01879E732C7
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 12:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjI1M1A convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Sep 2023 08:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjI1M06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Sep 2023 08:26:58 -0400
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC521A3;
        Thu, 28 Sep 2023 05:26:49 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-504427aae4fso12585868e87.1;
        Thu, 28 Sep 2023 05:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695904007; x=1696508807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3onrZJDriavx3Ipbqf/PYEEZtiSx9wuOqAfV/7ZaIM=;
        b=OqreoBFD3vL5bRNqhPdMNd377tuBvM0OAMfkEl9uEOeLE4NQuMTwbgNVsRgWpOEIuN
         6eiOH6rBYcaUy8NduFOcl2cocuvVHZvCqgPVxcRkcNAwyWLJcWzGM+KvDPFa5IzKWvmj
         TNo3fKvtUVjR7+RPLTZFZmCLOlQ+bGFU4KOtowNxP8UVTaKE86uJBjfSb6zl4+tO/RpP
         k0fw0WBUOMYxX8CxYd55urrxtl0tpeQq52FlOp9l4ocxb7BeHzsIUYHXtIxPckjl5nYv
         j7dL0231I/kDmsDargrFT9QI5gBxMu31FkuiCkl2B22wJ5XXLnV8zwwKiU2GFKTOACLe
         Z+9A==
X-Gm-Message-State: AOJu0Yz7gXAhzNJSfdgrRhYmf6C8TYl38yjaNggdPWou6Vsdp7gbDewm
        ZE2LAoKKRbqhbPXiO2TM/GIXnj1OVuhXIWPS
X-Google-Smtp-Source: AGHT+IHriZ6erWoAdj2yG+xFJPZl8alnOQHnW9T86Bjzjh+6rHuBAFWCY4cC96BGd/Puawoa3888Cg==
X-Received: by 2002:a05:6512:3d21:b0:4ff:62a4:7aaf with SMTP id d33-20020a0565123d2100b004ff62a47aafmr942027lfv.2.1695904006908;
        Thu, 28 Sep 2023 05:26:46 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id w16-20020ac25990000000b005041b7735dbsm3098959lfn.53.2023.09.28.05.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 05:26:46 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50482ba2b20so3223437e87.1;
        Thu, 28 Sep 2023 05:26:46 -0700 (PDT)
X-Received: by 2002:a05:6512:3c91:b0:500:af82:7ddc with SMTP id
 h17-20020a0565123c9100b00500af827ddcmr1038177lfv.28.1695904006082; Thu, 28
 Sep 2023 05:26:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230926081507.69346-1-dlemoal@kernel.org>
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 28 Sep 2023 14:26:31 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX_aNX2FZoydqgZTF+DA1uTt0zxbXcu1FXqeO5tUqry=Q@mail.gmail.com>
Message-ID: <CAMuHMdX_aNX2FZoydqgZTF+DA1uTt0zxbXcu1FXqeO5tUqry=Q@mail.gmail.com>
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

(oops, found a two-day old email still in draft)

On Tue, Sep 26, 2023 at 10:15 AM Damien Le Moal <dlemoal@kernel.org> wrote:
> The first 9 patches of this series fix several issues with suspend/resume
> power management operations in scsi and libata. The most significant
> changes introduced are in patch 4 and 5, where the manage_start_stop
> flag of scsi devices is split into the manage_system_start_stop and
> manage_runtime_start_stop flags to allow keeping scsi runtime power
> operations for spining up/down ATA devices but have libata do its own
> system suspend/resume device power state management using EH.
>
> The remaining patches are code cleanup that do not introduce any
> significant functional change.
>
> This series was tested on qemu and on various PCs and servers. I am
> CC-ing people who recently reported issues with suspend/resume.
> Additional testing would be much appreciated.

JFTR, with current libata/for-next[*], I saw the following with
rcar-sata, once (interesting lines marked with "!"):

    PM: suspend entry (s2idle)
    Filesystems sync: 0.026 seconds
    Freezing user space processes
 !  ata1.00: qc timeout after 10000 msecs (cmd 0x40)
    Freezing user space processes completed (elapsed 0.007 seconds)
 !  ata1.00: VERIFY failed (err_mask=0x4)
    OOM killer disabled.
 !  ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
    Freezing remaining freezable tasks
 !  ata1.00: revalidation failed (errno=-5)
    Freezing remaining freezable tasks completed (elapsed 0.002 seconds)
    sd 0:0:0:0: [sda] Synchronizing SCSI cache
    ata1: link resume succeeded after 1 retries
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    ata1.00: configured for UDMA/133
    ata1.00: Entering active power mode
    ata1.00: Entering standby power mode
    ravb e6800000.ethernet eth0: Link is Down
    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
PHY driver (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=136)
    OOM killer enabled.
    Restarting tasks ... done.
    random: crng reseeded on system resumption
    PM: suspend exit
    ata1: link resume succeeded after 1 retries
    ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    ata1.00: Entering active power mode
    ata1.00: configured for UDMA/133
    ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

Regardless, the disk worked fine after resume.

Note that I saw this only once.

[*] Commit f940258b63da95f4 ("ata: libata: Cleanup inline DMA helper
functions").
    No idea which version of this series that corresponds to, adding
    Link:-tags to your commits would make it easier to track that.
    https://www.kernel.org/doc/html/latest/maintainer/configure-git.html#creating-commit-links-to-lore-kernel-org

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
