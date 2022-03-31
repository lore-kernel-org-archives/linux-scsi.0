Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69B4C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbiCaWkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242600AbiCaWj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:56 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADE72013F8
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:38:09 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id y6so899545plg.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FfWqSXzRy/oQYvE7ypEao+2Y/8rPzLEyN3EEy6t1/o=;
        b=h8BUDtW2Tn0hl7hWyVypWTTH0sY07nUhPw+4YNMUJgcLA7YHvJrFYWH+s0txovZr47
         6OLubsHB689lIYya36Ih1BjaB3JMZLnEpMQLal6nWGiJU9Lr4zuqeca9HSWTBK1hIeLb
         lU3FOpFK034eUZ4Q57q6vXAk8C04QMk7yLGnMD8TXg1msSn3+X5FHq5Pq5xF4BbmAbEe
         mfk47PJMCXdRhLa7gNN5pXZiRyJYTQFcK5X4f16YpZ1wYfRXIXoS3s3RSKiz2oMIfN2j
         GW5AkiJGtoKKdRJufz8zruiQ/AMn0EjcWYsvsV2tXuSM3ctO5p0hDn6V3XxT23j0POC7
         KeGA==
X-Gm-Message-State: AOAM531a+BHGZzxoGDqrkR4v9rQPbOgycBHMVQ9l4P5JLt5JHJ/hrzg8
        Tdh/44pvlCPyp8cmcwSPhg4eY4Ks2sY=
X-Google-Smtp-Source: ABdhPJzYrmlpn8xqbZ34aN22nC2S6EbmxWzYpyYqimF7YLDWx/iwy5NQ4lVrwgk0CrcT52VmPl5nig==
X-Received: by 2002:a17:902:8306:b0:14f:a386:6a44 with SMTP id bd6-20020a170902830600b0014fa3866a44mr7358395plb.140.1648766288469;
        Thu, 31 Mar 2022 15:38:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:38:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 23/29] scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives
Date:   Thu, 31 Mar 2022 15:34:18 -0700
Message-Id: <20220331223424.1054715-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
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
