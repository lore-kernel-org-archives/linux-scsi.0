Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489C7C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34142610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhKSUBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:20 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:36516 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbhKSUBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:15 -0500
Received: by mail-pg1-f173.google.com with SMTP id g28so9521565pgg.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p7RkXQurBNiCNgRZJutIR46v6XMOxEF++IT2kqny+ng=;
        b=re9fSEICxN8YueaUCtxt39DrrvqMu/teQ3YNtyPLN+pnIZa64oJvsBIibZQY8bZf3J
         O3XljYbg1BI//2aCUS3JrHKGVoMHemFE+Av9Mmgg7pdv2f8uJjuZImTupgTkQj0FTp8t
         K7A5WqSSsmPLIMA6r4Xfeiy6sMGV7/bP3bwIhuT7BqbDNzf8/i8L8lSIwsXCb6o+Ywum
         sTi+NzTfWGqvSTf68VsHdXKx1t/4sfZt4ohlFkz3WO602nQUfyy0cAGubf5R3mQEBy8U
         vQBFsihm21PDf6oOWr6leXf6cERWIsx8FG3EwCfBF5zCYCvwXeItoiViz9uPRmpCBJIX
         BB+g==
X-Gm-Message-State: AOAM531Y75Ff6KDD3wGZavCTsjKGWJgziXNwfO0fJFswzNMU2DnSv22k
        KUll/PKFYCuq6sh/0Czr/FAazyZ6+Eo=
X-Google-Smtp-Source: ABdhPJyts975Y9757+K6GWZ5fqLmuvhy3L3XvoElzlPodSWw5YxUtmWzgFfSwVlUeqBVIFmduUn8Bg==
X-Received: by 2002:a62:b418:0:b0:4a0:3696:dec0 with SMTP id h24-20020a62b418000000b004a03696dec0mr65701904pfn.73.1637351892645;
        Fri, 19 Nov 2021 11:58:12 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 09/20] scsi: ufs: Remove the sdev_rpmb member
Date:   Fri, 19 Nov 2021 11:57:32 -0800
Message-Id: <20211119195743.2817-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
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
index a3ca9ada0adc..ff9532968ae7 100644
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
index ebe9e197d804..e9bc07c69a80 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -809,7 +809,6 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
-	struct scsi_device *sdev_rpmb;
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
