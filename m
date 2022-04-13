Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442AAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 21:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiDMVvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 17:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiDMVvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 17:51:12 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ED047569
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 14:48:49 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a21so3126945pfv.10
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 14:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVNVnL1ER91EUVmvjlcEJqwJQJzYyPETihzAzq7TKFQ=;
        b=CS2Ya2U4sFFIV4zr7KQXQay7/23O8YG9W0IC8eI9vRWljOgBJFliOMSWxauN0iXXpx
         2iIni6L6Ns8eOb77AqkRAsJNeFGSPrOIXLNE2SQyhWyOZBOSsJnCeW8qc/lqcvrpMdcS
         sTovTKO4y451/6WKMFLmv3nUZcBYSZWUaYh1pVrFjLqNvEYJHv291zItApEs2kzSpVpj
         wnmmk5+xTXDQzGeuxMmfvD494OsrLZnkLtmBlxeaRdwDVEBTUptb5RYeZAAwjPM6grUp
         g6MwBt/s/VcSTXagWUAYXxmhzpo4eUWyVgZKSt9jvJZtVkMNIuk5W25fSeobu2UJWgV+
         Sd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVNVnL1ER91EUVmvjlcEJqwJQJzYyPETihzAzq7TKFQ=;
        b=2C6LctTmChTEsZY+c+LI59mDLUyPoGeFtXMqasHAcm5CgPevM4YxnDqX3DNQaTccUZ
         Gqg1YBBYgroEJNEV0w1XKRyMT3a/Tu7MOjJrETw56+almv9NNDFwUVG0MFFinDwJE13u
         SBv9GurDbCFQqRmPnsgj144G54/Axzxh+25qsk5G/+n7Mkr575cYv7iLIuvZYPD6MAO6
         FCW5pPIWOa/dUgOphO4bnGDJ3oL2E8tQPlCKtJo2iWITj11oe563SMi+MtbKL11fo3Co
         WvSiUZPLEJIMl3r3FjjVDNzpogbO6LV0vunqvu69hvwgKmhWHHbtJilOow6URwKHhFjG
         jZ7g==
X-Gm-Message-State: AOAM531iMaDIvq1xjfD7ktBKKu+5lHbFSF8ACqnK28tYO/zz0GzG3Vvs
        PWchp77fIfz3BXuP9zpLPY7/szeG6NZYUb66V5BnjA==
X-Google-Smtp-Source: ABdhPJyTb3+APmRaJOvjIGyw0A57CXWpySjIZCThd/8l52VgsBR+8xKWxVBsAPBuJyAjXa2lYiT5zA==
X-Received: by 2002:a63:7d49:0:b0:378:907d:1fc7 with SMTP id m9-20020a637d49000000b00378907d1fc7mr36702825pgn.252.1649886529005;
        Wed, 13 Apr 2022 14:48:49 -0700 (PDT)
Received: from oak.jof.github.beta.tailscale.net ([2601:645:8780:7d20::5f8c])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7820d000000b004fa72a52040sm37508pfi.172.2022.04.13.14.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 14:48:48 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH 0/1] Rebase: Add printk indexing to scsi drivers.
Date:   Wed, 13 Apr 2022 21:47:35 +0000
Message-Id: <20220413214735.3870-1-jof@thejof.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just rebasing this patch to keep it current.

Jonathan Lassoff (1):
  Add printk indexing to scsi drivers.

 drivers/scsi/scsi_logging.c | 7 ++++---
 include/scsi/scsi_device.h  | 8 +++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)
