Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3360C636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74886124B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhGVCye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:34 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:41849 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhGVCyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:33 -0400
Received: by mail-pl1-f174.google.com with SMTP id e14so2948544plh.8
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yWeAFvnC1E0LSqJDI6nM6Yu6WBgJ6bok/dF5XIWN3AU=;
        b=AjR2tmvMhEVyWeAM3dGKdi9+I9I0KG/mk0fInjY7I7/uFzeh+rc2HcA6M9AIUkvddt
         UgzOAb7p2ogUYPWqrYQjr9qatWtfqTgY7NKNOvf180czHgemSJdJwbR4V9WzZ9wpk4+O
         sAHBGXR5BRD5SGuQCb93EwRXBerfNMF42FhAXQVrD9YOpYwZfzpdht8oZiHBkhCaKdBB
         DuZ8zaxrfVI8tLv08/5aUe/+osheDYA8Ukc8Dv6s3zEbSfcYPmPSV8Br6hGt9R/H12El
         4HviWlMKT4AlkNHd6Wo9f1leOcmM5HmhIYmgJ9ecMbAzHyvIw7IqG2pYh1BwUBV2Qgy8
         ZdfQ==
X-Gm-Message-State: AOAM532cGI4mdsn827/uYHWvYYstUStpuCRi8+Faq+My1xibTIpxowvX
        WYs4VSljupNqn1nI0HgbfhM=
X-Google-Smtp-Source: ABdhPJzhWnPOx0yfyQ7Wg+0SCBCgAfm2zjYbYuJvE1KdWK4tMoAApBxVIpIWsybe4eimLyT+ar94Ug==
X-Received: by 2002:aa7:8a07:0:b029:332:958b:7f07 with SMTP id m7-20020aa78a070000b0290332958b7f07mr40150864pfa.70.1626924908438;
        Wed, 21 Jul 2021 20:35:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 03/18] scsi: ufs: Only include power management code if necessary
Date:   Wed, 21 Jul 2021 20:34:24 -0700
Message-Id: <20210722033439.26550-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch slightly reduces the UFS driver size if built with power
management support disabled.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
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
index 58b1742ec9b9..0503ebe197f6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8740,6 +8740,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 		usleep_range(5000, 5100);
 }
 
+#ifdef CONFIG_PM
 static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -8767,6 +8768,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 out:
 	return ret;
 }
+#endif /* CONFIG_PM */
 
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
 {
@@ -9169,6 +9171,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	return ret;
 }
 
+#ifdef CONFIG_PM
 /**
  * ufshcd_resume - helper function for resume operations
  * @hba: per adapter instance
@@ -9206,7 +9209,9 @@ static int ufshcd_resume(struct ufs_hba *hba)
 		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
 	return ret;
 }
+#endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_system_suspend - system suspend callback
  * @dev: Device associated with the UFS controller.
@@ -9262,7 +9267,9 @@ int ufshcd_system_resume(struct device *dev)
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
+#endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM
 /**
  * ufshcd_runtime_suspend - runtime suspend callback
  * @dev: Device associated with the UFS controller.
@@ -9310,6 +9317,7 @@ int ufshcd_runtime_resume(struct device *dev)
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
+#endif /* CONFIG_PM */
 
 /**
  * ufshcd_shutdown - shutdown routine
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index cc971aebb9da..0a3afd9499c9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1001,10 +1001,14 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
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
