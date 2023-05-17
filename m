Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4B2C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjEQWcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjEQWcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:32:04 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40EA2722
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:03 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1ae4e264e03so14585935ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362723; x=1686954723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kslduZYYKEAPfiMFZMwtBuy6fN4G7EE+wYpgAN4KKEE=;
        b=RIp/xXeLqw/scHcJ5NmqV3+LGm9gD1O158D+oQ29En4dxeGIK10DP9Xd8CMHRcn7Ok
         VcqLa97HF3wQGTFC9ebEyZnfGfbxGfDipSE8B50iGUe7asusMcCPZPFAu0oEsHiYURgb
         2BCuS+lrAFNcB7A7tLQ/oVzQNp/OYa+DojWX3bOjDIfBaqO8DuPrBGexiSe1TrGhwAhQ
         oJfBPBX4nba38vO3osJboutnMDLEzMnG58Zyj8G2Z5GeNh74eth7HIoD3LT3KhvZlgFm
         aLj1uh+apAvWvjNcGsB/mJhFWNw3VuYu8jJX9GMwL7ccN6dcUfxjrS+tuANykXJR3GNx
         ddgA==
X-Gm-Message-State: AC+VfDxq+y82KLVLhbDBZsPBZeTGuU6ObC9TvnUe2ze3zFyinzNYsHZ7
        9zDvA3Mb+rMIW6R8Pkxce5iEodssUds=
X-Google-Smtp-Source: ACHHUZ7+Q298PFeLbZcc+yMj5TtC0MsfdOj6Nf1SHrM8HKTsKVbTCNU50kJX5SzCJAfK8bC0zXzfnA==
X-Received: by 2002:a17:902:c410:b0:1ab:2034:26da with SMTP id k16-20020a170902c41000b001ab203426damr468439plk.51.1684362723039;
        Wed, 17 May 2023 15:32:03 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a9f0100b00250d908a771sm61938pjp.50.2023.05.17.15.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:32:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] UFS host controller driver patches
Date:   Wed, 17 May 2023 15:31:53 -0700
Message-ID: <20230517223157.1068210-1-bvanassche@acm.org>
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

Changes compared to v1:
- Added a comment in patch 4/4 as requested by Adrian Hunter.

Bart Van Assche (4):
  scsi: ufs: Increase the START STOP UNIT timeout from one to ten
    seconds
  scsi: ufs: Fix handling of lrbp->cmd
  scsi: ufs: Move ufshcd_wl_shutdown()
  scsi: ufs: Simplify driver shutdown

 drivers/ufs/core/ufshcd.c             | 65 ++++++++++-----------------
 drivers/ufs/host/cdns-pltfrm.c        |  1 -
 drivers/ufs/host/tc-dwc-g210-pci.c    | 10 -----
 drivers/ufs/host/tc-dwc-g210-pltfrm.c |  1 -
 drivers/ufs/host/ufs-exynos.c         |  1 -
 drivers/ufs/host/ufs-hisi.c           |  1 -
 drivers/ufs/host/ufs-mediatek.c       |  1 -
 drivers/ufs/host/ufs-qcom.c           |  1 -
 drivers/ufs/host/ufs-sprd.c           |  1 -
 drivers/ufs/host/ufshcd-pci.c         | 10 -----
 drivers/ufs/host/ufshcd-pltfrm.c      |  6 ---
 drivers/ufs/host/ufshcd-pltfrm.h      |  1 -
 include/ufs/ufshcd.h                  |  1 -
 13 files changed, 24 insertions(+), 76 deletions(-)

