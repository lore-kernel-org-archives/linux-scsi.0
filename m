Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B860DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358389AbiDSXBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358383AbiDSXBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:33 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C48C38BE6
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:50 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id 12so80985pll.12
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u3xoahIYSO9OOaeanh6ld3z8PVf6V1CHNxpRp8Wej3s=;
        b=mfTgNA4IFz2reNHI+2TGAwxw4r7c3ZMVDz477+HfbSseiuiTPLm2RtNmjZsRA8Srq1
         E3Z4irW5Cx8yDMuMH+34nWA7grCEDlXLd2DoXFtJScYnWEs95LHKxbxOZtLkodoSfIBu
         8oIaF1MomYQCC6ZY8cRgNRvWFj4/VvkNKmIB6QrmUkATOxrUqY59c3sIv5jbRHtpiD6T
         3KymRWQEv6Zd3aOsgLaM3WWx2fEO7dy2+qKE0NI03dA+ILc0Mx81idiIAZpAPHroaVuz
         plwQbqSjuFHy0JiVISxambxoRYsdAEJVNfZWT5czqGZ/YJOUqb17ISQ+SfPgEGriFxSb
         6FQg==
X-Gm-Message-State: AOAM533C2tydMwUmjQ5dGr4Fgh92d7Ey74kFf9BGxxTzKC39KefNExve
        KoA4nXpRMjBhv3EnH76yxPw=
X-Google-Smtp-Source: ABdhPJxdeiDq7a2Vg5D0nN2br306jtwd3iVS/WkdO5tQqhLjyE2rTSEScJVQVr8PDnbr4M0lQbixyw==
X-Received: by 2002:a17:90a:4203:b0:1cb:6ba1:fcba with SMTP id o3-20020a17090a420300b001cb6ba1fcbamr1006836pjg.20.1650409129572;
        Tue, 19 Apr 2022 15:58:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 15/28] scsi: ufs: Remove the driver version
Date:   Tue, 19 Apr 2022 15:57:58 -0700
Message-Id: <20220419225811.4127248-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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
 
