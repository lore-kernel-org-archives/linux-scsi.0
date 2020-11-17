Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333D4C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E611324686
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWLdUvZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgKQQ6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgKQQ6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:58:48 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4895B2466D;
        Tue, 17 Nov 2020 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605632327;
        bh=kicS4tzR+Z+1NqfDkwWxTmUjLJz1UsouESdl9kc6obo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWLdUvZQIG7KYttKbbMAKWmlBkdq2DMRtr+lp7Jad4wJId2/lIBAW7qPUAltQgpW8
         PMOxJltFiaxBNk0X+M4kKpNen09MV/OJC0dGlYeKAwJX2Xx/dUkgKYxd6xxsUJZSXK
         3T2e9lTR6mvvPN5eSrSEIqp2yjyRUdYUofE3GIdM=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>
Subject: [PATCH v5 3/7] scsi: ufs: clear UAC for FFU and RPMB LUNs
Date:   Tue, 17 Nov 2020 08:58:35 -0800
Message-Id: <20201117165839.1643377-4-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201117165839.1643377-1-jaegeuk@kernel.org>
References: <20201117165839.1643377-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

In order to conduct FFU or RPMB operations, UFS needs to clear UAC. This patch
clears it explicitly, so that we could get no failure given early execution.

Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 70 +++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6c9269bffcbd..8e696ca79b40 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7058,7 +7058,6 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
 	int ret = 0;
-	struct scsi_device *sdev_rpmb;
 	struct scsi_device *sdev_boot;
 
 	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
@@ -7071,14 +7070,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	ufshcd_blk_pm_runtime_init(hba->sdev_ufs_device);
 	scsi_device_put(hba->sdev_ufs_device);
 
-	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
+	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
-	if (IS_ERR(sdev_rpmb)) {
-		ret = PTR_ERR(sdev_rpmb);
+	if (IS_ERR(hba->sdev_rpmb)) {
+		ret = PTR_ERR(hba->sdev_rpmb);
 		goto remove_sdev_ufs_device;
 	}
-	ufshcd_blk_pm_runtime_init(sdev_rpmb);
-	scsi_device_put(sdev_rpmb);
+	ufshcd_blk_pm_runtime_init(hba->sdev_rpmb);
+	scsi_device_put(hba->sdev_rpmb);
 
 	sdev_boot = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
@@ -7602,6 +7601,63 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
 
+static int
+ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp);
+
+static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
+{
+	struct scsi_device *sdp;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (wlun  == UFS_UPIU_UFS_DEVICE_WLUN)
+		sdp = hba->sdev_ufs_device;
+	else if (wlun  == UFS_UPIU_RPMB_WLUN)
+		sdp = hba->sdev_rpmb;
+	else
+		BUG_ON(1);
+	if (sdp) {
+		ret = scsi_device_get(sdp);
+		if (!ret && !scsi_device_online(sdp)) {
+			ret = -ENODEV;
+			scsi_device_put(sdp);
+		}
+	} else {
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (ret)
+		goto out_err;
+
+	ret = ufshcd_send_request_sense(hba, sdp);
+	scsi_device_put(sdp);
+out_err:
+	if (ret)
+		dev_err(hba->dev, "%s: UAC clear LU=%x ret = %d\n",
+				__func__, wlun, ret);
+	return ret;
+}
+
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (!hba->wlun_dev_clr_ua)
+		goto out;
+
+	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
+	if (!ret)
+		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
+	if (!ret)
+		hba->wlun_dev_clr_ua = false;
+out:
+	if (ret)
+		dev_err(hba->dev, "%s: Failed to clear UAC WLUNS ret = %d\n",
+				__func__, ret);
+	return ret;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -7721,6 +7777,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
+	} else {
+		ufshcd_clear_ua_wluns(hba);
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 47eb1430274c..718881d038f5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -681,6 +681,7 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
+	struct scsi_device *sdev_rpmb;
 
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
-- 
2.29.2.299.gdc1121823c-goog

