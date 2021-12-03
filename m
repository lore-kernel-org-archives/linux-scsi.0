Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7561CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376761AbhLCXXx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:23:53 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:53086 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:23:52 -0500
Received: by mail-pj1-f51.google.com with SMTP id h24so3446525pjq.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rIFpmEaQVzQJF4yxUEcHb+hAveqBxGps251VVNl6QYs=;
        b=PUI4ExO3HLA1v5qnSqEdUxI54Ireq/vQzV9o9s7cipuZ/t+XxW8uDN1MgDEN5irQRv
         zZCiv+21rVslEGLVSqrrRxi2nc7uy4QhYaqgNO9Ndm/CyBdv5ghjobl+z7EbXoUbfMiE
         CGGzKFjvMbp4QTmNuVE2H7p5YSXCzWHEad/aazWaBtbs7A6xHEiqh2EgTkQOH2HGXKo/
         g2Y5WOfbh+TA80YUoo2FlGyhs7rPxXEZTVpYiaWUEBc1KAaUE0GXhDn2OX9JcqHH3cL8
         scwgAyBnSEIQwPy1atqn6KY1pbn+5JUwJrCh3kac16kg7zzzZIdcrRBqDhyHHqc75lIM
         AciA==
X-Gm-Message-State: AOAM533P+5dWB/y4ugaurd+cNabRY7SiaoeiaioZmxLamhPHbqdT10th
        yNtcxTHSpUzHjK6l2GLhVanhcbrSLLw=
X-Google-Smtp-Source: ABdhPJxQJDUTAO6F/8miXTrGs2Jp0x+kmgA3YnP38ZCpsIq91lujo3TT87kN8ty/YPtTiDdQWGXlBw==
X-Received: by 2002:a17:902:c145:b0:142:50c3:c2a with SMTP id 5-20020a170902c14500b0014250c30c2amr26093887plj.32.1638573628194;
        Fri, 03 Dec 2021 15:20:28 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v4 04/17] scsi: ufs: Remove the sdev_rpmb member
Date:   Fri,  3 Dec 2021 15:19:37 -0800
Message-Id: <20211203231950.193369-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the sdev_rpmb member of struct ufs_hba is only used inside
ufshcd_scsi_add_wlus(), convert it into a local variable.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
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
