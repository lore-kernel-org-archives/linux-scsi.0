Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6678AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhK3XhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:15 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:41508 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236283AbhK3XhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:14 -0500
Received: by mail-pg1-f178.google.com with SMTP id k4so11402759pgb.8
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:33:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qp6OgTSeGaLaP7FXJm6cQqjf4ONa+6UL3Ui5n6wvjR0=;
        b=wdy/BUWxZh1gt9T5j4izEasAu6FzTK0nd9iNrN33YeIaXbsIgmxThYvktydOTdKWjp
         sTLUU1wFEM3zvI17r/b+nA3QOREZK0Ph48EDwLcPNDYWrAJXPMkcI6e6rDCeyUdE4/4R
         TAnEGqo1XTuxi0BJsRXkIzDhGu0OVAUjc1vaNE4u+D0gmWC5XyVvyTHyWUB8ChlrAWp6
         IUJKruSY/UnL0AQPsU3X9MCqtQbHw+9+/saeiPE0PHZVIAd9tpZRQoX855/GF08vMm3R
         aALMgBuZB4fSFpyf72uiVUnMKte6EuR7WAr/rMjqXOtPCdLYIlB6S/F53eYMDdOx3+CE
         HuAw==
X-Gm-Message-State: AOAM532Bf6oWITR1cage6UrUkOCfYWP5H2cdN9Hz559az+EVTXw3MXal
        zALsuzZb5jEc7yR76SUAJCg=
X-Google-Smtp-Source: ABdhPJyrQNVMoM01Id7uxc2vcThGq7jfSb2X+fPK01QvN7FQbYKIpM7bn0kmcoxXOcTny23zCQsc2Q==
X-Received: by 2002:a63:8849:: with SMTP id l70mr1859869pgd.257.1638315234788;
        Tue, 30 Nov 2021 15:33:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 05/17] scsi: ufs: Remove the sdev_rpmb member
Date:   Tue, 30 Nov 2021 15:33:12 -0800
Message-Id: <20211130233324.1402448-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the sdev_rpmb member of struct ufs_hba is only used inside
ufshcd_scsi_add_wlus(), convert it into a local variable.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 drivers/scsi/ufs/ufshcd.h |  1 -
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4821ad9912bb..973b7b083dbe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7412,7 +7412,7 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
 	int ret = 0;
-	struct scsi_device *sdev_boot;
+	struct scsi_device *sdev_boot, *sdev_rpmb;
 
 	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
@@ -7423,14 +7423,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	}
 	scsi_device_put(hba->sdev_ufs_device);
 
-	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
+	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
-	if (IS_ERR(hba->sdev_rpmb)) {
-		ret = PTR_ERR(hba->sdev_rpmb);
+	if (IS_ERR(sdev_rpmb)) {
+		ret = PTR_ERR(sdev_rpmb);
 		goto remove_sdev_ufs_device;
 	}
-	ufshcd_blk_pm_runtime_init(hba->sdev_rpmb);
-	scsi_device_put(hba->sdev_rpmb);
+	ufshcd_blk_pm_runtime_init(sdev_rpmb);
+	scsi_device_put(sdev_rpmb);
 
 	sdev_boot = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 28c1bbe9fa7d..ecc6c545a19d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -809,7 +809,6 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
-	struct scsi_device *sdev_rpmb;
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
