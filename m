Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A055C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBBWAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjBBWAF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:00:05 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C84611F2
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 13:59:29 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id n2so2233324pfo.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 13:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jaA09wzrIRgtIbC8xDy5PlXj/5BjpF7gR5JeHCrLa4=;
        b=dHMDMlrQb8tcjKVXql+bieZCNgYXPggcTZsegTONxvinjNMMQnM276sQZmoSvE71eJ
         y3weZ5DaZzgpRm84dCsNOR40aaYibVXv+7PAS8ODRJZgetXWqnwAvky8HsVKLjC/DGyD
         PlOm9NTj4ssx6cYY3LfFPJSYWArDz+gbjQJjNA5D4AYYjDuzMdgvq/fRSmPcIHaumg2V
         9uq9PsCGE/CRRediAA9U3jvsWz5k8/I2MXJlTmwbw7uSVJBdivB1OleT1g331s0tbbqN
         H+DqT5x3NhLyUqSNQ9XcxXBJPFjNl12K3Uxl7eIIEL+63Ftv+XAuYIEACC/q1B6Wm2xF
         DzLw==
X-Gm-Message-State: AO0yUKW5aFw3Ul303k8RkZ65RgNQs70b32O4zohVD2EQkhHCt3Ox3CtH
        lsiFHZBuLzgwDijwThduk/c=
X-Google-Smtp-Source: AK7set8JRbBRxJWHcSvrbGcITVZZhnqCqSM9URhPlJFSlQzDabUgaHxEwlqOCayVtPtHVPvFypCB0g==
X-Received: by 2002:a05:6a00:7d4:b0:594:1f1c:3d2e with SMTP id n20-20020a056a0007d400b005941f1c3d2emr2597691pfu.3.1675375124547;
        Thu, 02 Feb 2023 13:58:44 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id y41-20020a056a00182900b00593a612515dsm152814pfa.167.2023.02.02.13.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:58:43 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS devices
Date:   Thu,  2 Feb 2023 13:58:33 -0800
Message-Id: <20230202215835.560530-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Measurements have shown that UFS devices perform better when using SYNCHRONIZE
CACHE instead of FUA. Hence this patch series that makes the SCSI core submit
a SYNCHRONIZE CACHE command instead of setting the FUA bit for UFS
devices. Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- Updated __BLIST_LAST_USED.
- Added #include <scsi/scsi_devinfo.h> to fix a build error reported by the
  kernel robot.

Asutosh Das (1):
  scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA

Bart Van Assche (1):
  scsi: core: Introduce the BLIST_BROKEN_FUA flag

 drivers/scsi/scsi_scan.c    | 3 +++
 drivers/ufs/core/ufshcd.c   | 4 ++++
 include/scsi/scsi_devinfo.h | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

