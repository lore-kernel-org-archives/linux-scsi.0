Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71080C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245485AbiDLSYY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358694AbiDLSYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:24:01 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAAC5D64B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:43 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id p10so653695plf.9
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u3xoahIYSO9OOaeanh6ld3z8PVf6V1CHNxpRp8Wej3s=;
        b=y/+4SONzA0YHgaJw3x3Fc4NWVT7j2OlsgbB0W0rFDsNtyTNAlyAC+2ZYQyZAXjPFJu
         PK0Fda6uM0QtZnMDg0CTYRJJTsC7OgLXnhJslxk7QNulL+cQgBYgEBZoFhBp5yEfn84x
         VJtuRy0tNKgEC0SJ7GpJEkEMpne2obW1iVQTQIvrrNuFqPTRDp/lprTKm9GyMW0CxsFN
         1v6WwvThSnMJOFKJ09Wj8+CgmxCt1OyPk1ZZbZhf8Gl5JM6sX8jzScS0T44qpPUyjxYr
         BxURU4OdYnamuTjjRhsQcc+n99/rA9ZZCL9rWRfWk2/xkfVoSRbmcHL/GIccNQ/Qoqkh
         1Irg==
X-Gm-Message-State: AOAM531B4Bo/Tx4ak9Bv5iO6UD6BNUWbfTm0F93sHGM2PV4D8gsXRpoV
        4LivLPCFFRWa6HDxhDtRdjc=
X-Google-Smtp-Source: ABdhPJyPAU6pqdXZqCqogqQVjloNzTZs6I5NfHEbd2aCEDK+iUwDJa7yexjFBRmUHK6JuD3Z+tHdeA==
X-Received: by 2002:a17:902:8ec8:b0:156:847b:a8f8 with SMTP id x8-20020a1709028ec800b00156847ba8f8mr39598715plo.121.1649787703052;
        Tue, 12 Apr 2022 11:21:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:21:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 15/29] scsi: ufs: Remove the driver version
Date:   Tue, 12 Apr 2022 11:18:39 -0700
Message-Id: <20220412181853.3715080-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current version number is 0.2. That driver version was assigned more
than nine years ago. A version number that is not updated while the driver
is updated is not useful. Hence remove the driver version number from the
UFS driver. See also commit e0eca63e3421 ("[SCSI] ufs: Separate PCI code
into glue driver").

Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
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
index 9923cbc70653..fc5191101192 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -386,4 +386,3 @@ MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 69198e37c976..912c3ecb8d7a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9923,4 +9923,3 @@ MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
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
 
