Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75DCC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358681AbiDLSZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349095AbiDLSZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:25:24 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3855D64B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:23:06 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id a21so3291224pfv.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FfWqSXzRy/oQYvE7ypEao+2Y/8rPzLEyN3EEy6t1/o=;
        b=Wvsq7EjtXU0NzN74zSjLNSXFlG+gyoy3UUy8TD7/BA6/r5G4vrnogZOgSPeRItJ0Zl
         5WXaHAyhlOyAVR8GH3zCBQ5WGpqTQQ3dDIlr5ILO0dz8r+7gE7KLXyPLSXxToatNsJWC
         72bJe2zpE5xU/5X5s4nijwmSClfUAIaPD6boianRmCU/p2s9/6B94oGnrs88kWCPT4z6
         5hPOWa4dEyTZmVkYpgi1i4wOnckK8QAMIQLAMVlvW0qr4XNXXcZ0hsb77E1Bk/T3ct4L
         1zEbMePM3oGBnUhfzcMAkpS5StwJDjYs710hRGrNc1w7FUCEGl/vpikKUkGVzHaeAepi
         asUg==
X-Gm-Message-State: AOAM531+fblESKGtrT2dplb9G0MC/0VttAGLjZaLtnk7FtAe6xJsCuPy
        w9cipwJ2osLa8T+GohZGgAI=
X-Google-Smtp-Source: ABdhPJxlQd5xHq1VVEKa0PMCBFRJNRqv2h348tbfVZdZWKSFtY0/h57KET9AfgeGnygEKFxnfzUiqg==
X-Received: by 2002:a63:4761:0:b0:39c:f432:3d3d with SMTP id w33-20020a634761000000b0039cf4323d3dmr19814631pgk.544.1649787785490;
        Tue, 12 Apr 2022 11:23:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:23:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v2 23/29] scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives
Date:   Tue, 12 Apr 2022 11:18:47 -0700
Message-Id: <20220412181853.3715080-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd-crypto.h declares functions that must only be called by the UFS
core. Hence remove the #include "ufshcd-crypto.h" directive from UFS
drivers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 1 -
 drivers/scsi/ufs/ufs-qcom-ice.c | 1 -
 drivers/scsi/ufs/ufs-qcom.h     | 1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index d19b35495302..84ccb5258736 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -19,7 +19,6 @@
 #include <linux/soc/mediatek/mtk_sip_svc.h>
 
 #include "ufshcd.h"
-#include "ufshcd-crypto.h"
 #include "ufshcd-pltfrm.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index bbb0ad7590ec..921d6a93b653 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -9,7 +9,6 @@
 #include <linux/platform_device.h>
 #include <linux/qcom_scm.h>
 
-#include "ufshcd-crypto.h"
 #include "ufs-qcom.h"
 
 #define AES_256_XTS_KEY_SIZE			64
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 51570224a6e2..771bc95d02c7 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -7,6 +7,7 @@
 
 #include <linux/reset-controller.h>
 #include <linux/reset.h>
+#include "ufshcd.h"
 
 #define MAX_UFS_QCOM_HOSTS	1
 #define MAX_U32                 (~(u32)0)
