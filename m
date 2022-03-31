Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B0EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbiCaWiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242613AbiCaWiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:38:51 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D0624B5C7
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:03 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id t13so885503pgn.8
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SKZuDfzbVrmLqP+ermTJP0wK4GR71WBzcqaMKF1KssY=;
        b=Qxg50nP0kVX2gnl/SgkpM3+CJjYTLAKtlzUHjgiB4OPJjNvkRtUGkYq31T9PC8JV6N
         K57dDo89vnUo37PsHoADKZ8V/O48+yoIUbC57sgFrDGc9i6RAlAjF8EJLVmEivRrnjKP
         6DdREgqB8ttdDHGwO9j2kAjsPq9TxypsUddmzWRsJ7ketvd0gqyZe8WxQp29Kgw9cgve
         cN0LnGYDh/zRDn73qcYJg7xBd8OIQUsi9v4+73zI3phlwdHzedlaVgRQn6QtCEVsPjSP
         fshVDvJxZuJZ2y25IOXrVI35ZHIe8sLo2zXJgh+m2QpiWvmazIOP05xBsPB5/OZctb0L
         82Iw==
X-Gm-Message-State: AOAM531MpGLl2/olPTgV24TGrI5hcjCqd3211U872FJOLEN6scIGkG2F
        mmDyutpthfQpHZBpa/bX2dA=
X-Google-Smtp-Source: ABdhPJxC7JV8NxMbygUnRRtgmcO0LhJ9GjHh2iEt53QxZDAfDpGMbbAcEWUYwILPeEWs20FrRpJ7pg==
X-Received: by 2002:a63:35c3:0:b0:380:6a04:cecc with SMTP id c186-20020a6335c3000000b003806a04ceccmr12640345pga.455.1648766222593;
        Thu, 31 Mar 2022 15:37:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:37:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH 15/29] scsi: ufs: Remove the driver version
Date:   Thu, 31 Mar 2022 15:34:10 -0700
Message-Id: <20220331223424.1054715-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver version numbers are not useful in upstream kernel code. Hence
remove the driver version number from the UFS driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/cdns-pltfrm.c   | 1 -
 drivers/scsi/ufs/ufshcd-pci.c    | 1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 -
 drivers/scsi/ufs/ufshcd.c        | 1 -
 drivers/scsi/ufs/ufshcd.h        | 1 -
 5 files changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index 7da8be2f35c4..e91cf9fd5a95 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -340,4 +340,3 @@ module_platform_driver(cdns_ufs_pltfrm_driver);
 MODULE_AUTHOR("Jan Kotas <jank@cadence.com>");
 MODULE_DESCRIPTION("Cadence UFS host controller platform driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index f76692053ca1..81aa14661072 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -601,4 +601,3 @@ MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("UFS host controller PCI glue driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 2725ce4de1c9..81e458d31222 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -386,4 +386,3 @@ MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ae08c7964f2d..9d433d2c616d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9915,4 +9915,3 @@ MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bb2624aabda2..49edbdb5ffd6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -49,7 +49,6 @@
 #include "ufshci.h"
 
 #define UFSHCD "ufshcd"
-#define UFSHCD_DRIVER_VERSION "0.2"
 
 struct ufs_hba;
 
