Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464FBCA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11936214D9
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TjVqlCC9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GZ5osAjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbfJ2MYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:24:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731976AbfJ2MYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 08:24:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0788860F83; Tue, 29 Oct 2019 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572351859;
        bh=OHpqvsbEqQaNTWJz9ZTIW16qLuF+jKcCUcibO+4VId4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjVqlCC9nqtEwkIVY0zioQ61JlBb7R0w1jniFBG/2xmuI49WbyBN+4TsnjDw9p5wj
         a7r0WIrWT4/IVWMSLaIatcy0MRKh32/34mf5dVz0fNu5o0A24ZggkYFuKPTP3pbl9Z
         G464JSbh8Nqt01td5hmKe8gJFDzlZwQGEr8VQxeQ=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 448CB60DB8;
        Tue, 29 Oct 2019 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572351856;
        bh=OHpqvsbEqQaNTWJz9ZTIW16qLuF+jKcCUcibO+4VId4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZ5osAjRxeHszL53rqVnt4H8th3BKDkwXX4Ehz7j6U80jTWUxOVdGDJA8Y45N63Cd
         5KhAt2+7F2F94hSmFqqrQ6njv0nFczh69nqRXiLSiMiUG+1Px7aizru0l1NqH0fVwt
         tqK8L61p5k9hBI0lszc6B+ltPiVbgtQhUfmn48eo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 448CB60DB8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/2] scsi: ufs: Do not rely on prefetched data
Date:   Tue, 29 Oct 2019 05:23:49 -0700
Message-Id: <1572351831-30373-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572351831-30373-1-git-send-email-cang@codeaurora.org>
References: <1572351831-30373-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We were setting bActiveICCLevel attribute for UFS device only once but
type of this attribute has changed from persistent to volatile since UFS
device specification v2.1. This attribute is set to the default value after
power cycle or hardware reset event. It isn't safe to rely on prefetched
data (only used for bActiveICCLevel attribute now). Hence this change
removes the code related to data prefetching and set this parameter on
every attempt to probe the UFS device.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h | 13 -------------
 2 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3a0b99b..0026199 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6424,11 +6424,12 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 	return icc_level;
 }
 
-static void ufshcd_init_icc_levels(struct ufs_hba *hba)
+static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 {
 	int ret;
 	int buff_len = hba->desc_size.pwr_desc;
 	u8 *desc_buf;
+	u32 icc_level;
 
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf)
@@ -6442,20 +6443,17 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 		goto out;
 	}
 
-	hba->init_prefetch_data.icc_level =
-			ufshcd_find_max_sup_active_icc_level(hba,
-			desc_buf, buff_len);
-	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
-			__func__, hba->init_prefetch_data.icc_level);
+	icc_level = ufshcd_find_max_sup_active_icc_level(hba, desc_buf,
+							 buff_len);
+	dev_dbg(hba->dev, "%s: setting icc_level 0x%x", __func__, icc_level);
 
 	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
-		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
-		&hba->init_prefetch_data.icc_level);
+		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
 
 	if (ret)
 		dev_err(hba->dev,
 			"%s: Failed configuring bActiveICCLevel = %d ret = %d",
-			__func__, hba->init_prefetch_data.icc_level , ret);
+			__func__, icc_level, ret);
 
 out:
 	kfree(desc_buf);
@@ -6963,6 +6961,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		}
 	}
 
+	/*
+	 * bActiveICCLevel is volatile for UFS device (as per latest v2.1 spec)
+	 * and for removable UFS card as well, hence always set the parameter.
+	 * Note: Error handler may issue the device reset hence resetting
+	 *       bActiveICCLevel as well so it is always safe to set this here.
+	 */
+	ufshcd_set_active_icc_lvl(hba);
+
 	/* set the state as operational after switching to desired gear */
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 
@@ -6979,9 +6985,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 			hba->dev_info.f_power_on_wp_en = flag;
 
-		if (!hba->is_init_prefetch)
-			ufshcd_init_icc_levels(hba);
-
 		/* Add required well known logical units to scsi mid layer */
 		if (ufshcd_scsi_add_wlus(hba))
 			goto out;
@@ -7006,9 +7009,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		pm_runtime_put_sync(hba->dev);
 	}
 
-	if (!hba->is_init_prefetch)
-		hba->is_init_prefetch = true;
-
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..3089b81 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -405,15 +405,6 @@ struct ufs_clk_scaling {
 	bool is_suspended;
 };
 
-/**
- * struct ufs_init_prefetch - contains data that is pre-fetched once during
- * initialization
- * @icc_level: icc level which was read during initialization
- */
-struct ufs_init_prefetch {
-	u32 icc_level;
-};
-
 #define UFS_ERR_REG_HIST_LENGTH 8
 /**
  * struct ufs_err_reg_hist - keeps history of errors
@@ -505,8 +496,6 @@ struct ufs_stats {
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
- * @is_init_prefetch: flag to check if data was pre-fetched in initialization
- * @init_prefetch_data: data pre-fetched during initialization
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
@@ -657,8 +646,6 @@ struct ufs_hba {
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 	bool is_powered;
-	bool is_init_prefetch;
-	struct ufs_init_prefetch init_prefetch_data;
 
 	/* Work Queues */
 	struct work_struct eh_work;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

