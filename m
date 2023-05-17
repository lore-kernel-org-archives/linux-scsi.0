Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFCAC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjEQWYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjEQWYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:24:07 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBE91B5
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:06 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-24e25e2808fso1332820a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362246; x=1686954246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KlBH4CcsbZm5GCg+EQU3IgWsYqUPanCXgcd6L8syW7c=;
        b=iGdr/DyDQ8ADUREj4UEX6k/wvmwL1QNlizS6OcsBJqXOn7XokCJXjVT6J5tWBK/lea
         GfVwGHH4khomI+Rfm5TGXGx92chskI8g5GcFSJZQZq/8thtnqk95/91Wk7J5pI+D3X3+
         JIDPSuRgCTG6oMMyD07KIcFX2Tk3GPzsXafA94ennMRZYN6C2QDtZXNJWFCzYx2XLi7V
         Ub+ikbSUoc0JNjcIsGFgnqsSyHyUQYXudvMvtBmRPbrpCbfQzangm4gxD0cJoAXTZTv9
         NxaDb4KkXpXqHyKCp6+KfzkBIvhKSd0SiCuTtmMQcxO6sprj2EenBz0WJDdXooIHV9D6
         a+AQ==
X-Gm-Message-State: AC+VfDzChPowda295gsOPXdsm7zxyPriK4Ndk4/toDS8nlyTA8pADRui
        I+JDyqDhfbvQZ/PZ+KWuKv0eHXH0RTY=
X-Google-Smtp-Source: ACHHUZ4+Qy9Lhgus6g33q7I0fHJEPwuB6m1vYXCDeJwikBmAXwGU4XsO+iccBqM6IkGyONzLush1zQ==
X-Received: by 2002:a17:90a:4605:b0:250:939f:70a0 with SMTP id w5-20020a17090a460500b00250939f70a0mr384345pjg.14.1684362245740;
        Wed, 17 May 2023 15:24:05 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d32-20020a17090a6f2300b0024df6bbf5d8sm66273pjk.30.2023.05.17.15.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:24:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] ufs: Do not requeue while ungating the clock
Date:   Wed, 17 May 2023 15:23:55 -0700
Message-ID: <20230517222359.1066918-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

In the traces we recorded while testing zoned storage we noticed that UFS
commands are requeued while the clock is being ungated. Command requeueing
makes it harder than necessary to preserve the command order. Hence this
patch series that modifies the SCSI core and also the UFS driver such that
clock ungating does not trigger command requeueing.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- Dropped patch "scsi: ufs: core: Unexport ufshcd_hold() and ufshcd_release()".
- Removed a ufshcd_scsi_block_requests() / ufshcd_scsi_unblock_requests() pair
  from patch "scsi: ufs: Ungate the clock synchronously".

Bart Van Assche (4):
  scsi: core: Rework scsi_host_block()
  scsi: core: Support setting BLK_MQ_F_BLOCKING
  scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
  scsi: ufs: Ungate the clock synchronously

 drivers/scsi/scsi_lib.c          | 26 ++++++-----
 drivers/ufs/core/ufs-sysfs.c     |  2 +-
 drivers/ufs/core/ufshcd-crypto.c |  2 +-
 drivers/ufs/core/ufshcd-priv.h   |  2 +-
 drivers/ufs/core/ufshcd.c        | 76 ++++++++++----------------------
 include/scsi/scsi_host.h         |  3 ++
 6 files changed, 45 insertions(+), 66 deletions(-)

