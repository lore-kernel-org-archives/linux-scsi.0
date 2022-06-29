Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55D2CCA480
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 03:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiF2DK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 23:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiF2DK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 23:10:56 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF36125C5B;
        Tue, 28 Jun 2022 20:10:55 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p14so13794309pfh.6;
        Tue, 28 Jun 2022 20:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=N8ZBJj0XdOhntBRV+Hk37Z2nZbEgcvXedhbKEp+bepI=;
        b=ZGWB+A+qS6O2l1r24YBQraO4k/ATjqyw5iWl5IMNV6rKIiQhjxIyazuLjmyi0+Ms7X
         Mi20dbKHzqdY1TBtlngf3a5fxzyd4nvCPvXAMhLAIg9SHNjMWISHBZaCoCb4mhVTEf93
         oMgATr1vS4WuS06R0SBgVr4S9p0YCKRbIRllZh4TDftG6OZcg8Ttf++r4gYj4tEnyV54
         VlfZJmCjb4VJ4jrHpkf4q2oaipz7tsJVeFKKV3N4pYnpShB5I8EUw6hhETkw/LJLXKXv
         PK0Bd14htMHNPG3NXGbBc6gLnGJYI8nolkH6Ec1synYLPQsUcaBj0R5hCkt7NNzUqaKK
         GzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N8ZBJj0XdOhntBRV+Hk37Z2nZbEgcvXedhbKEp+bepI=;
        b=AVSAm1SEjVvktx+CHs6516rDcp5fOkmWAjpKq6QJ/ejKNm9vcpU0/M+H61eNnGpNN1
         TI0ecGE311jx/Ru/9V8BY9zabj3fRSPeeowKojbLy2Yupcfa9c6M+MVyKHZJqxYpWWUj
         kk9LcCKcSriFW0DSQ15/tfai8Z+x3TKsizSp93E7zBztCEfBYfgMoINrAGcComgZ/DSN
         L6eqcfglLLo/gxnzquylhPisIEdQjTIHRxc+5B/WY0kqvEEl/ey3Jn48isTUO6rHea6W
         hkikRmNFrCM2MrqCCouFVwzIqy77gvq28xmdxyhOniL2yzfCFJuvJCTagAxBi0cdll/i
         q4xQ==
X-Gm-Message-State: AJIora86hTBZFyBS0MCjMFRIThyJoJ75kD5QY9jSnOHcBz9lQsSnwMXB
        va0a7gQvYF3HiDqHX8qKCVo=
X-Google-Smtp-Source: AGRyM1vC6Pt5yfPek+Pv2Lws6u12HLTxo6KLxJ3vD3/MO/rvjVVfEUb5RBPRFHGdZtAlpH3Fe4jvEg==
X-Received: by 2002:a05:6a00:808:b0:525:3c3f:7393 with SMTP id m8-20020a056a00080800b005253c3f7393mr8098675pfk.57.1656472255492;
        Tue, 28 Jun 2022 20:10:55 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id u13-20020a63454d000000b0040d2224ae04sm10054784pgk.76.2022.06.28.20.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:10:54 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 3097F360316; Wed, 29 Jun 2022 13:16:40 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
Date:   Wed, 29 Jun 2022 13:16:35 +1200
Message-Id: <20220629011638.21783-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V1 of a patch series to convert m68k Amiga WD33C93 drivers to the
DMA API.

This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
m68k WD33C93 still used virt_to_bus to convert virtual addresses to
physical addresses suitable for the DMA engines (note m68k does not
have an IOMMU and uses a direct mapping for DMA addresses). 

Arnd suggested to use dma_map_single() to set up dma mappings instead
of open-coding much the same in every driver dma_setup() function.

It appears that m68k (MMU, except for coldfire) will set up pages for
DMA transfers as non-cacheable, thus obviating the need for explicit
cache management. 

DMA setup on a3000 host adapters can be simplified to skip bounce
buffer use (assuming SCSI buffers passed to the driver are cache
line aligned; a safe bet except for maybe sg.c input). 

On gvp11 and a2091 host adapters, only the lowest 16 MB of physical
memory can be directy addressed by DMA, and bounce buffers from that
space must still be used (possibly allocated from chip RAM using the
custom allocator) if buffers are located in the higher memory regions. 

The m68k VME mvme147 driver has no DMA addressing or alignment
restrictions and can be converted in the same way as the Amiga a3000
one, but will require conversion to a platform device driver first.

Only compile tested so far, and hardware testing might be hard to do.
I'd appreciate someone giving this a thorough review.

Thanks, and Cheers,

   Michael


