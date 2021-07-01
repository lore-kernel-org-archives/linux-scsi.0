Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47756C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304AA61403
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhGAVPd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:33 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:45642 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhGAVPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:33 -0400
Received: by mail-pg1-f176.google.com with SMTP id y17so7358557pgf.12
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWz7oAcRKyhzkWLGUh+aNyiazazkn/lYksMncObqiKU=;
        b=seD8UXI1GO2FA1qgACG0+sFkNA1jkjJq6hUrIzTcP2qsqYSmBYBXGOhv4BjRluzXP1
         T2htbOv5aM4YpIQGkPdBaFii1umj822FBdTvBe5EDgpD8zjGwwxT2GsYa1qgaIrutIAd
         oWJqVmAdq+RpQFofw7In7XsLoD+JY6m5H7t5uBIlpraAxXvv/XuY/RFf+j1bSOHEqIoZ
         rJ30fMRFLz5gPZUBqwovSt/XrPr0gi42w4Ig+27n2vgspFFrw9gDxXesNgGlitqQE70u
         7df/4bH5viwDG7Lw2Rcj6Uj3w4C8CdjAD2ZK0BBSIEO0wH9SFCqFnBAR6725sinsU+JD
         8oWA==
X-Gm-Message-State: AOAM533sDRX27+3eyyZS2Z+l2cZyzXkECEFiRauLIwVqrv3lLviJHGxx
        a+bBqRTTdmYEvS1ghK/Kvl0=
X-Google-Smtp-Source: ABdhPJzgb6WQPmVoCvFZhEMF1PO+nV0anh7tAgDKhL3zdxSbSZyhOD0oFXwb0pE24pcuTCP+e9gGyQ==
X-Received: by 2002:a05:6a00:1c67:b029:302:4036:407b with SMTP id s39-20020a056a001c67b02903024036407bmr1653712pfw.46.1625173981976;
        Thu, 01 Jul 2021 14:13:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 07/21] ufs: Only include power management code if necessary
Date:   Thu,  1 Jul 2021 14:12:10 -0700
Message-Id: <20210701211224.17070-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch slightly reduces the UFS driver size if built with power
management support disabled.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
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
