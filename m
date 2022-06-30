Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA503C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 03:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiF3DdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 23:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiF3DdN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 23:33:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEFE5FED;
        Wed, 29 Jun 2022 20:33:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so1520300pjs.1;
        Wed, 29 Jun 2022 20:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=85BRrYxng71wcu1JoZwsELKQ/QBDT/gklfigvh09xfQ=;
        b=Q/ogXACDmJvTnQA85r9lYDJjrFTQzX26nU5DSt3QNQgPWHiXuFf64NSGyKcry9ZwPT
         vR+oitNMZvKBby6SaWW8d++Q8ewPumdZ2zliL84cQoH5GqAhWPuMEbVLvXUAOD9JaxxU
         jM1dByC0E9616sLthI2knxvkOGUxXKiQ+l4pvACPPqpDci/y1xSsCBUygyutPeEuYI3I
         nMEntLi82h5VFEnjFqkfIG8Vah962KCLtRl45YmOPqXH+cuC7MeOJYCDlze7mtXY4y3m
         4JMC2GMZWChb2sRHDRTSiPtr1pq1APj4/8vIEES1ty11aadP3xxwJ0HCcVHvf4nhlKLp
         hrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=85BRrYxng71wcu1JoZwsELKQ/QBDT/gklfigvh09xfQ=;
        b=F7R/nHTPV+XwYsdvc0uRd65PQ6L/k8CCWmGiT82FvZF8PSGOfT5CinAm2f12jwM6Hg
         NXW/8g6oTYIoJtklw6sQdC4SgFp4IZXfG5HPOgdwXFzDj3zm5AeGJbtdzhQNyzuDBFDL
         AuRopQn2J8uMbjSxFF0R68lvFoQQXqZvhBx82tPGm1otiUPyjdBsMP5RL+8LtKZCeSBQ
         GNmydxM9qo9O7QIhvRBVtIdGPog+RP3to84aUA86aKnOD0z+erN7GX29+eETDsW+CKKk
         2D2an/zFjKSy/Q+BQAYG3veCrFWQGjZPBOwdXRCOJivejEV/goX1ld8RCglHPzCz6eVY
         MrDQ==
X-Gm-Message-State: AJIora/ubOB0gReLLh8egcsExowsWdS3FQ4stEpGXGFqmuUVJIf++jtk
        9N45vbfLQYxZZGbOJ/TjfiM=
X-Google-Smtp-Source: AGRyM1s8pFPSL1+I82q7CScMvB7qRYBuY8/vVsQTNLSnN5osKUJDzdyRzk0n1MY7fV9kPHNh/MYDUA==
X-Received: by 2002:a17:902:a40f:b0:16a:bf3:b837 with SMTP id p15-20020a170902a40f00b0016a0bf3b837mr13613141plq.55.1656559988354;
        Wed, 29 Jun 2022 20:33:08 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id s5-20020a170902988500b00161947ecc82sm12126073plp.199.2022.06.29.20.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 20:33:07 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 4CE3D360331; Thu, 30 Jun 2022 15:33:04 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH v2 0/3] Converting m68k WD33C93 drivers to DMA API
Date:   Thu, 30 Jun 2022 15:32:59 +1200
Message-Id: <20220630033302.3183-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
m68k WD33C93 still used virt_to_bus to convert virtual addresses to
physical addresses suitable for the DMA engines (note m68k does not
have an IOMMU and uses a direct mapping for DMA addresses). 

Arnd suggested to use dma_map_single() to set up dma mappings instead
of open-coding much the same in every driver dma_setup() function.

DMA setup on a3000 host adapters can be kept as-is (bounce
buffers are used only where the input buffer isn't cache line
aligned). Cache management is now taken care of by dma_map_single().
Note that I've restored bounce buffer allocation (dropped in v1) in
order to make minimal changes to the core logic.

On gvp11 and a2091 host adapters, only the lowest 16 MB of physical
memory can be directy addressed by DMA, and bounce buffers from that
space must be used (possibly allocated from chip RAM using the
custom allocator) if buffers are located in the higher memory regions.
No cache management is required for chip RAM bounce buffers.

The m68k VME mvme147 driver has no DMA addressing or alignment
restrictions and can be converted in the same way as the Amiga a3000
one, but will require conversion to a platform device driver first.

Only compile tested so far, and hardware testing might be hard to do.

Cheers,

   Michael


