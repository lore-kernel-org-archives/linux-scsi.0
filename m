Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD71C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586E561184
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhKJAsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:04 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:45657 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhKJAsC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:02 -0500
Received: by mail-pg1-f173.google.com with SMTP id f5so610666pgc.12
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wws/JzFdGi/vBUm8yYarEhegVfr1+J0nCcGQ/Nh3upE=;
        b=PRQSHXdMvo2zLrmW2hPN5E4Zp1jV8YtdWlknrNfJYmdhDwbAuhH9+CwM6JK8NexuaT
         QYY85QGrjvzNc/VwJEq1dAEjqHGwzkvnJ1Se1ZjT2HuzxuCnaXsLivcm7ND34hWUR7Gk
         kn8VX70U8pzaNF0xkaE2TYY9ZzteN1DuiDsUc1Uq+p3efQ2N8ekrak+y1kNDYldY/qjF
         IOCzbzSqP4YfuJpDDP2A9+uFoOp0WeJKj2j9qd/ClXthEBz24yPLxEBVZHLo9xUO3oRi
         THBOjVLPcC6JMDVNoyISskgSNMxNOXh4DF0qFsivgUq+VQBU9KoFPPOr/auZ77C2gllY
         zuog==
X-Gm-Message-State: AOAM530EsIf32E5pw6uwW+SpVKx+aCZhZnvRWV0i7y06liiYDPuAkqsg
        QaE1IqKRo6O47GFPqtr7Qmc3HXw8njq2BA==
X-Google-Smtp-Source: ABdhPJzRkBgpVglPZdl19Mb86f6U6yKyGCb3nIpy2mD9o/4vDPd0uAkWqx1zffUVAGE45ZSfsHgy+g==
X-Received: by 2002:a63:5646:: with SMTP id g6mr9065278pgm.216.1636505115202;
        Tue, 09 Nov 2021 16:45:15 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH 03/11] scsi: ufs: Remove the sdev_rpmb member
Date:   Tue,  9 Nov 2021 16:44:32 -0800
Message-Id: <20211110004440.3389311-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the sdev_rpmb member of struct ufs_hba is only used inside
ufshcd_scsi_add_wlus(), convert it into a local variable.

Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 drivers/scsi/ufs/ufshcd.h |  1 -
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d18685d080d7..dff76b1a0d5d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7407,7 +7407,7 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
 	int ret = 0;
-	struct scsi_device *sdev_boot;
+	struct scsi_device *sdev_boot, *sdev_rpmb;
 
 	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
@@ -7418,14 +7418,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
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
index a911ad72de7a..65178487adf3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -809,7 +809,6 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
-	struct scsi_device *sdev_rpmb;
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
