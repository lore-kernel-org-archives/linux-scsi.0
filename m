Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D0EC54EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 23:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjALXm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjALXm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 18:42:28 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FBB13F97
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:42:25 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so25275413pjj.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:42:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Iv4usJjVLdnbAbPeu21k4nFO5zrJGv5hWrh95481Wc=;
        b=x2DaYqTwdYpa5cwP5axcyRL03uiy2P+sEVJBYfo+L2F/QWD0pxOAP898m27q6AT2DP
         QAzvk5TPNBXu2iPwOKNfhpsVG1wo1Lrm30RNraZTMUWxegChqo1T4gghknxqeNYimJcl
         z5AaDSPUTSRUa5WrKC1RiDuFKuWQBdqeDPatdIulfYo8e6Fya5h7UUCl2SbDjQH2ATjZ
         s2a9N72gKLQyBF9xkcKG2L7INcsVDNn+vGkdMNhvXXY2q2fza01rcghB6t9NKE8iVgVx
         LCaytDYQWdjpP3hnYCPFwj61fpr9QTYjdI0Ay6FKB6ZUqKWC2SbZ9UHx3VvrRex47Rlu
         d4ZA==
X-Gm-Message-State: AFqh2kogJ4s9YDyF8RAnFAxJNGuxYGFtrvj2xRYPfk2L3NN/dRfZrTHM
        Pyf+q3+qIlc6tXGdHevvidg=
X-Google-Smtp-Source: AMrXdXvfHtcd57QuZPL47bp+GNVfhI7HkJ6uim/8AwoRL1ZrQXonCgII6iFLzVOC+aUjmk1vuuEX1g==
X-Received: by 2002:a17:902:6b89:b0:189:cf92:6f5c with SMTP id p9-20020a1709026b8900b00189cf926f5cmr81823233plk.52.1673566944437;
        Thu, 12 Jan 2023 15:42:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3345:7bfe:9541:882b])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090322c300b0017f8094a52asm12764795plg.29.2023.01.12.15.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 15:42:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] Enable DMA clustering in the UFS driver
Date:   Thu, 12 Jan 2023 15:42:12 -0800
Message-Id: <20230112234215.2630817-1-bvanassche@acm.org>
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

Changes compared to v1:
- Expanded the description of patch 3/3.
- Reworked patch 2/3 such that setting host->max_segment_size no longer races with
  LUN scanning.

Bart Van Assche (3):
  scsi: ufs: Exynos: Fix DMA alignment for PAGE_SIZE != 4096
  scsi: ufs: Exynos: Fix the maximum segment size
  scsi: ufs: Enable DMA clustering

 drivers/ufs/core/ufshcd.c     |  5 ++---
 drivers/ufs/host/ufs-exynos.c | 10 +++++++++-
 include/ufs/ufshcd.h          |  4 ++--
 3 files changed, 13 insertions(+), 6 deletions(-)

