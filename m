Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2BCC54EBD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Jan 2023 21:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjAFV6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Jan 2023 16:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFV6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2023 16:58:08 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B0B1DDD9
        for <linux-scsi@vger.kernel.org>; Fri,  6 Jan 2023 13:58:07 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id d9so3077189pll.9
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2023 13:58:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KDgpdYfJRQBPUtHQgyUazqqTVR9Uw5bGh9hMDo/k30Q=;
        b=M3P4dIDrD5Spl/nZBR0vpP3CQVzsWZPRWduPTYGUw3itsrNwLd5ZYL2QaY4+gnyUgv
         yZbloFabMig+qEa7FrGEP6Ak1D8KqnIR29NR+66uPFj5AFUCeYF3OUfl8yXb7Zn/9VpW
         5FOdm0K4ODE5kyR8PjgJKatmOROHg+zt8ZwaXLgBjK2ihpLMbiHtylHadXkrMO8adF9a
         p8QAL3lG5tJOrhKcSna3F+oG9OD+da6tUFMFdLPFlgRg1e/+L16f48C18fHJ4eMbHaaw
         FudtrckFJQ1PN7lhguFVRHBuhFMK42tap7Plb5niS5WOzpsaZcEy8+8ytYfExTiUd+B2
         w0jw==
X-Gm-Message-State: AFqh2ko3ydk4izDiLD0dBbO7FTSz9d366nSlZCpSFxaDPEAy2F4b8Z54
        XLafqdleusHL5I/K1Czccgk=
X-Google-Smtp-Source: AMrXdXt1gx/g+hWLUCGO/2k7AL5vnZbAGU0qPBZxLo8egITWq2VQauVoftGvJZX0f1qjDZGV0uCCew==
X-Received: by 2002:a17:902:c612:b0:192:511e:b9ab with SMTP id r18-20020a170902c61200b00192511eb9abmr55265682plr.21.1673042287228;
        Fri, 06 Jan 2023 13:58:07 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:23c3:f25b:a19d:c75a])
        by smtp.gmail.com with ESMTPSA id ij30-20020a170902ab5e00b00193198ffeddsm281154plb.30.2023.01.06.13.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 13:58:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Enable DMA clustering in the UFS driver
Date:   Fri,  6 Jan 2023 13:57:57 -0800
Message-Id: <20230106215800.2249344-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The third patch in this series enables DMA clustering in the UFS driver since
UFS host controllers support DMA clustering. The first two patches fix bugs in
the Exynos host controller driver.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (3):
  scsi: ufs: Exynos: Fix DMA alignment for PAGE_SIZE != 4096
  scsi: ufs: Exynos: Fix the maximum segment size
  scsi: ufs: Enable DMA clustering

 drivers/ufs/core/ufshcd.c     |  5 ++---
 drivers/ufs/host/ufs-exynos.c | 12 +++++++++---
 include/ufs/ufshcd.h          |  4 ++--
 3 files changed, 13 insertions(+), 8 deletions(-)

