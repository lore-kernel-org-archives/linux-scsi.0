Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27CAC07E9C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D67B613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGIU3u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:50 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:37431 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGIU3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:49 -0400
Received: by mail-pl1-f172.google.com with SMTP id a14so5626620pls.4
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nQ6YxKDsrns++bb4kAUMSQF41LGjIKyfM0ujb+zeL+4=;
        b=f086V2H889HiHwxwFHEZ12nyUkzZxdwZw/cYEJmZ953k0ThWt/cLoufxYFIKzqyyVo
         siVx8EWuChVsXUBQG+vCY8EUOa0ZKWikWSsM1MoJ3GEa/oqEGKRWFewbRpTnsZmAO2nZ
         dX8kuX2M7qs71svYEjM45gs1AE6ugFxN/itooLlQko5aNii3w/J7Fbl63LIhMFsv6+ed
         a7jQIbdX/0XGRFmmzX9S+EPT3DbbAau8cSe9IojD21QkzY+Y373Vq5zT0fwavtXxzZyN
         MMLMMzfoCzbhsYvPl5wGZYz8GPkKle21QqgmnHZoletKucCbC0mvmRySfVm+gy7Odxnm
         0sVg==
X-Gm-Message-State: AOAM531W+RPNELf9H8Jxe7swSMJ1PUMktalkQ4MSWc7PktLGixUQLhjI
        +LsMpUlS5SjRayAfGj5yGRI=
X-Google-Smtp-Source: ABdhPJxD8l8wq8zDR5JgianEwjGqb3e4e6P26M6JYbToAnS0ZtuPkhGj4/7b3AmM9/p6UNIy+PcKJA==
X-Received: by 2002:a17:902:db08:b029:129:73d9:b868 with SMTP id m8-20020a170902db08b029012973d9b868mr28161910plx.5.1625862425674;
        Fri, 09 Jul 2021 13:27:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 03/19] scsi: ufs: Only include power management code if necessary
Date:   Fri,  9 Jul 2021 13:26:22 -0700
Message-Id: <20210709202638.9480-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch slightly reduces the UFS driver size if built with power
management support disabled.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++++
 drivers/scsi/ufs/ufshcd.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a34aa6d486c7..37302a8b3937 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8736,6 +8736,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 		usleep_range(5000, 5100);
 }
 
+#ifdef CONFIG_PM
 static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -8763,6 +8764,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 out:
 	return ret;
 }
+#endif /* CONFIG_PM */
 
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
 {
@@ -9165,6 +9167,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	return ret;
 }
 
+#ifdef CONFIG_PM
 /**
  * ufshcd_resume - helper function for resume operations
  * @hba: per adapter instance
@@ -9202,7 +9205,9 @@ static int ufshcd_resume(struct ufs_hba *hba)
 		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
 	return ret;
 }
+#endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_system_suspend - system suspend callback
  * @dev: Device associated with the UFS controller.
@@ -9258,7 +9263,9 @@ int ufshcd_system_resume(struct device *dev)
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
+#endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM
 /**
  * ufshcd_runtime_suspend - runtime suspend callback
  * @dev: Device associated with the UFS controller.
@@ -9306,6 +9313,7 @@ int ufshcd_runtime_resume(struct device *dev)
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
+#endif /* CONFIG_PM */
 
 /**
  * ufshcd_shutdown - shutdown routine
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index dc75426c609f..79f6c261dfff 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1009,10 +1009,14 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 extern int ufshcd_runtime_suspend(struct device *dev);
 extern int ufshcd_runtime_resume(struct device *dev);
+#endif
+#ifdef CONFIG_PM_SLEEP
 extern int ufshcd_system_suspend(struct device *dev);
 extern int ufshcd_system_resume(struct device *dev);
+#endif
 extern int ufshcd_shutdown(struct ufs_hba *hba);
 extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
 				      int agreed_gear,
