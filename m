Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30788C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358407AbiDSXCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbiDSXBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:48 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281E738BDB
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:05 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so2298205pje.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJ468TeVvgDjWAjEHgL/VFPLqS8lMjgqHXroFUEkPJw=;
        b=8PN6LXfZbLbXggWlUeVh9XhJyFP0DzOjSyNvBPTn1Ynemn3zZdqGaZUqKnLB0vlJnf
         6ca/9g71aoVbeLN9QHQQl7Sa0Pbk6NcaStvxVUsSJZ16A6ozuyv4gTxNtC05/QcRgeX2
         evijuNPYy3IvtpC71dB88UjD13oOOkQ3tFPnRYpTttq0X1nOhCy9aDmV2e3DYQmoR5gH
         Tr/yEuJJQRvqXK6JX8TGAY1Fm/P6g8eakH5Puh+AdEW6a7W4Ka6/pQujOMu7T1C3GlUp
         PVwJ+AMT6B1pGmDAiclFGCSPnhTwYJjT1Ia1wSgXbnCtpfCU2eslmgaTMhNsAdxoOzI7
         qFvA==
X-Gm-Message-State: AOAM5311Xr4W2ZXqruX0mUU95rpyT6TfDN0Xyug0Wthxq5VIUNGWirKz
        2FArmeaDfWGDzuEfZJ8bypM=
X-Google-Smtp-Source: ABdhPJy26uKlFyIuChLtuKrXaGMsU2bW61bisnb8p5SbqR4U0hTtjOiE19K0baIuESvubvBaMrQFuA==
X-Received: by 2002:a17:90b:1c05:b0:1d2:ae49:b23d with SMTP id oc5-20020a17090b1c0500b001d2ae49b23dmr977883pjb.236.1650409144650;
        Tue, 19 Apr 2022 15:59:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:59:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v3 23/28] scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives
Date:   Tue, 19 Apr 2022 15:58:06 -0700
Message-Id: <20220419225811.4127248-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd-crypto.h declares functions that must only be called by the UFS
core. Hence remove the #include "ufshcd-crypto.h" directive from UFS
drivers.

Reviewed-by: Eric Biggers <ebiggers@google.com>
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
