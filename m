Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DB0CCA480
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiGLH6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiGLH6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:58:41 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921BEEAF;
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r22so6890397pgr.2;
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=qnDj9YjP4Jn6UNsO+JwNZ89hEl3kIOBm4jZ+bjUXltg=;
        b=Zwh98wpc5RAZ8xyw+BsZHlXJ8tpLxZpEEl0uM94UT8pz/5gpeiBMNUUI2fk8u2du2P
         Tw7emQ6PfJ4Lgno39rVmVeJEfl5F0Y4s6NCUszLHN2tf54FH4H3Qjpq/S892f4o2g27n
         bYfJ7dUCnD0nSsd3q0w6D+rR6w0deXY//KO7JR9pIv0c6gXGk96Il1UBWM98Oa3ssHRe
         +3PJd/aaslVIU6ubasELVx1CAyKWs7CG6tewsiSMSWX+dwPMABiCsA/Qg2IIn59jn3tf
         DIxaMBxlQOynpvhrRB4qL9oyB/O+eYiO5oDaRUoUZKtZ66Z9ewJWLHAYUsx5gZos8wDp
         jyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qnDj9YjP4Jn6UNsO+JwNZ89hEl3kIOBm4jZ+bjUXltg=;
        b=7VVqolSeRUqY8cavg5wshjlp/H9jLHAdXMM43ft0eXb0zKTh4hxkUX75qc4wOcCR1N
         1fouO8gboOy1s4+C2+nII9qCOShdP422spDK5te4pAPlFv+kwrkEokg6ZdzWKgvlnmnY
         S00fwuxX/VkFKjcuTn5exSrxNrbToyRqsQIXvnc+Q2uYeAgerfEWyrhVtDCz1R+Zh9B7
         8CYXKOy7W1OjG/AJA0cwP2WcgKADnKQ7Qxi6F5XxtbX67uEVypAe0rXN6xWktcPLDpO2
         vdRwHt/gFAykBEiL2Htz/1JGhMnOzQuXHjzlsSsLOn4iCR/+bXj7dwXAyDUwb4YZQo6h
         Ub6Q==
X-Gm-Message-State: AJIora8cdb6AayumupeC8/5VA/vBcQ+I1dSczkUjAEPjfjuIs6QGFKbl
        CXbZhJGEWfjvX3ql44tnAyoTuQnzK9c=
X-Google-Smtp-Source: AGRyM1uCLGmzMYY2wxHJA6g3LpBPk+fAWwleO7VZjqpjImsP5B2pDwkinzqKR86ht7xMWFUog41dHw==
X-Received: by 2002:a65:6907:0:b0:415:c9c1:eb4f with SMTP id s7-20020a656907000000b00415c9c1eb4fmr15924063pgq.193.1657612718071;
        Tue, 12 Jul 2022 00:58:38 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id q93-20020a17090a17e600b001e33e264fd6sm6225304pja.40.2022.07.12.00.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:58:37 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 637EF36031B; Tue, 12 Jul 2022 19:58:34 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH v2 0/5] Convert m68k MVME147 WD33C93 SCSI driver to DMA API
Date:   Tue, 12 Jul 2022 19:58:27 +1200
Message-Id: <20220712075832.23793-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
m68k WD33C93 still used virt_to_bus to convert virtual addresses to
physical addresses suitable for the DMA engines (note m68k does not
have an IOMMU and uses a direct mapping for DMA addresses). 

Arnd suggested to use dma_map_single() to set up dma mappings instead
of open-coding much the same in every driver dma_setup() function. An
earlier patch series has converted the three Amiga WD33C93 drivers,
this series now takes care of the sole remaining m68k WD33C93 driver.

The m68k VME mvme147 driver has no DMA addressing or alignment
restrictions and can be converted in the same way as the Amiga a3000
one in my previous series, but requires conversion to a platform
device driver first.

Changes from v1: 
- use of devm_platform_ioremap_resource() to convert phys. resource
to virtual address for chip registers.

Only compile tested so far, and hardware testing might be hard to do.
I'd appreciate someone giving this a thorough review.

Cheers,

   Michael


