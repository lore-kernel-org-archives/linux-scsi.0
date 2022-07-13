Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA86C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiGMC4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiGMC4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:56:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281CEAE5E;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso1357252pjj.5;
        Tue, 12 Jul 2022 19:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=YU2pts1EeWVUyc8NOJvYWPdPaG8ZMBOoLSKqRqGVayY=;
        b=n8j6AUaMQ6L3Cq9ZNmEGytU4bVzuQ/NKtWbpjTZ8N0Ti+qURy3Yxm32Mi/m8tXL4UJ
         shIaLswa0AGeLb8mo+uwu/kn64HSDTLwsBTYbGynuoRJpdtfieGdcMwO9wdbF9PwKhm8
         ZRQe+wo8ZggwP/CkoGKnRJIOG8zub0qGWQH38tHmf7LfGI2m5bF7XDSrJ9i+0sdHd0mD
         cdwz8PAf/X540CG7KSyF+iIIzvPv7YoCAp4gCosk9BJ/Fohdr5pASlx1Yd9WZTf43e+N
         /LeN6/Z6Um/+qes8ULWU3TmjqSgAVN6NXxRkvfqjA4SfXDlgjXhUxWVvN7PskFGN9U3F
         7hFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YU2pts1EeWVUyc8NOJvYWPdPaG8ZMBOoLSKqRqGVayY=;
        b=h+8TMFBsGAvRVQcXeNP+tMs0xr0UbbwONASTep5DhTq0G/dq8xkUpcZcn8u0HV8qL6
         W9XNlzhVkTUNZ/Plets27zZZe67XWDUnKs30ty5zwZgptxeibnGvfgl+mHwfVUv1HUO9
         TdZlajzOaXHCD/nesQl1l8btNiBRONB8AH5PjYEr+xFkJOppeR4KgVoiYbxWgsJpAdNW
         TDcsGP4bsfFI40u1EfxHz6t94W14FApxDp82usx5x8SdNfstKf0PKxRsJ5gxYF7JkjJj
         SFMljUKLN5u8a656bpCaNRfnk8ROOf49Iy3oelSOkJt5v9oLGLW1l2PSJ70+nuh1/NKH
         z1Zg==
X-Gm-Message-State: AJIora8J+u5PYeJnKf8Q2ryGr5rhb2dTt5evkO22Kt2aCr/j6BO1c8PA
        IXkbjPJxmOwwjt1bYzYC9ow=
X-Google-Smtp-Source: AGRyM1tZqjEBQYGys7RhzRxSv4XTK+C/SMndE8W7Z2QDSWQKw8R5c+8oAwzBME9cgPGX+6X271kbPg==
X-Received: by 2002:a17:902:edd1:b0:158:8318:b51e with SMTP id q17-20020a170902edd100b001588318b51emr1317603plk.89.1657680966743;
        Tue, 12 Jul 2022 19:56:06 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0f8b00b001efc839ac97sm324627pjz.3.2022.07.12.19.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 19:56:06 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D63A536031B; Wed, 13 Jul 2022 14:56:02 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH v3 0/5] Convert m68k MVME147 WD33C93 SCSI driver to DMA API
Date:   Wed, 13 Jul 2022 14:55:56 +1200
Message-Id: <20220713025601.22584-1-schmitzmic@gmail.com>
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

Changes from v2: 
- fix platform iomem resource size

Only compile tested so far, and hardware testing might be hard to do.
I'd appreciate someone giving this a thorough review.

Cheers,

   Michael


