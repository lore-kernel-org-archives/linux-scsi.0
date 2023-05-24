Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA9CC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 20:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjEXUhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjEXUhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 16:37:07 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCD210B
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:06 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2536e522e47so648723a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960626; x=1687552626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EiuukRqh0lHS/JrPJ93luo6Klh9/B+NSSB1tX1UPhQA=;
        b=JvElMqzsJW7bLXXb5EO2I2CSpJX+R237+gnbrDHfjGvDNIYMIqmtMGtNw9bu8khJmt
         SQsSkfSvCh8iJz9zNygd3N5jZCniUVVlGlyB2+4vK+FRjYRlwrKeuFi7f6TYRITAsKsw
         v9yDIxAREvbCGY9aXYSAdQBUHGLFT6RyhlRsBsnvgDrxI2ZJiChbG+0uhr3vXu/KZsxF
         xzgn+AoffvS3ohs3A5EhXpc/FamPwp6QndIdRYWUp4jtYWGWsuvPhjcMva3Wn8oDIjcJ
         1y7k5TqQbpqmXozOcCDo1XubUC559t7R/BdqLOHRMQ9+xT36SMig4swPJ2e+j3cCx9hh
         tylw==
X-Gm-Message-State: AC+VfDw5Hyv2YJXoRl7f9w4Ix0aoiWNL8nw0xOKieAOaEWf2OwkahC5D
        mbVPQOpN+X+cXhaFEWOPEpmsgtRsV4A=
X-Google-Smtp-Source: ACHHUZ6s5k+eDanFnoRGbZZJidrRmKQQc7kir6LYti7zoyQrWQY2iKbHiI7I5Ud5U2nj/+AOvU68Eg==
X-Received: by 2002:a17:90b:4d8c:b0:24b:a5b6:e866 with SMTP id oj12-20020a17090b4d8c00b0024ba5b6e866mr16991527pjb.24.1684960625592;
        Wed, 24 May 2023 13:37:05 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090a70c700b002535dc42bb5sm1690122pjm.47.2023.05.24.13.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 13:37:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] UFS host controller driver patches
Date:   Wed, 24 May 2023 13:36:18 -0700
Message-ID: <20230524203659.1394307-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these four UFS host controller driver patches for the next
merge window.

Thanks,

Bart.

Changes compared to v2:
- Changed a WARN_ON(lrbp->cmd) statement into lrbp->cmd = NULL in patch 2/4.

Changes compared to v1:
- Added a comment in patch 4/4 as requested by Adrian Hunter.

Bart Van Assche (4):
  scsi: ufs: Increase the START STOP UNIT timeout from one to ten
    seconds
  scsi: ufs: Fix handling of lrbp->cmd
  scsi: ufs: Move ufshcd_wl_shutdown()
  scsi: ufs: Simplify driver shutdown

 drivers/ufs/core/ufshcd.c             | 67 ++++++++++-----------------
 drivers/ufs/host/cdns-pltfrm.c        |  1 -
 drivers/ufs/host/tc-dwc-g210-pci.c    | 10 ----
 drivers/ufs/host/tc-dwc-g210-pltfrm.c |  1 -
 drivers/ufs/host/ufs-exynos.c         |  1 -
 drivers/ufs/host/ufs-hisi.c           |  1 -
 drivers/ufs/host/ufs-mediatek.c       |  1 -
 drivers/ufs/host/ufs-qcom.c           |  1 -
 drivers/ufs/host/ufs-sprd.c           |  1 -
 drivers/ufs/host/ufshcd-pci.c         | 10 ----
 drivers/ufs/host/ufshcd-pltfrm.c      |  6 ---
 drivers/ufs/host/ufshcd-pltfrm.h      |  1 -
 include/ufs/ufshcd.h                  |  1 -
 13 files changed, 25 insertions(+), 77 deletions(-)

