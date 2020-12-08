Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2175C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 13:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824A323B08
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 13:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgLHN5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 08:57:24 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:37939 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729680AbgLHN5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 08:57:23 -0500
X-UUID: 04896d5bc9764a2e8ec41ba1c2bb8256-20201208
X-UUID: 04896d5bc9764a2e8ec41ba1c2bb8256-20201208
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 510762096; Tue, 08 Dec 2020 21:56:38 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 8 Dec 2020 21:56:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Dec 2020 21:56:34 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <nguyenb@codeaurora.org>,
        <bjorn.andersson@linaro.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/2] scsi: ufs: Uninline ufshcd_vops_device_reset function
Date:   Tue, 8 Dec 2020 21:56:35 +0800
Message-ID: <20201208135635.15326-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201208135635.15326-1-stanley.chu@mediatek.com>
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 101DC9A9E8D7F51DCEBAB7D3E09A549AADA7E869E7FE7D2790AA99B6101A000D2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since more and more statements showing up in ufshcd_vops_device_reset(),
uninline it to allow compiler making possibly better optimization.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 27 ++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h | 19 +++++--------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c1c401b2b69d..b2ca1a6ad426 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -580,6 +580,23 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hba)
 		 hba->pwr_info.hs_rate);
 }
 
+static void ufshcd_device_reset(struct ufs_hba *hba)
+{
+	int err;
+
+	err = ufshcd_vops_device_reset(hba);
+
+	if (!err) {
+		ufshcd_set_ufs_dev_active(hba);
+		if (ufshcd_is_wb_allowed(hba)) {
+			hba->wb_enabled = false;
+			hba->wb_buf_flush_enabled = false;
+		}
+	}
+	if (err != -EOPNOTSUPP)
+		ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
+}
+
 void ufshcd_delay_us(unsigned long us, unsigned long tolerance)
 {
 	if (!us)
@@ -3932,7 +3949,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* Reset the attached device */
-	ufshcd_vops_device_reset(hba);
+	ufshcd_device_reset(hba);
 
 	ret = ufshcd_host_reset_and_restore(hba);
 
@@ -6933,7 +6950,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 
 	do {
 		/* Reset the attached device */
-		ufshcd_vops_device_reset(hba);
+		ufshcd_device_reset(hba);
 
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
@@ -8712,7 +8729,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * further below.
 	 */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
-		ufshcd_vops_device_reset(hba);
+		ufshcd_device_reset(hba);
 		WARN_ON(!ufshcd_is_link_off(hba));
 	}
 	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
@@ -8722,7 +8739,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 set_dev_active:
 	/* Can also get here needing to exit DeepSleep */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
-		ufshcd_vops_device_reset(hba);
+		ufshcd_device_reset(hba);
 		ufshcd_host_reset_and_restore(hba);
 	}
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
@@ -9321,7 +9338,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/* Reset the attached device */
-	ufshcd_vops_device_reset(hba);
+	ufshcd_device_reset(hba);
 
 	ufshcd_init_crypto(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 36d367eb8139..9bb5f0ed4124 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1216,21 +1216,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 		hba->vops->dbg_register_dump(hba);
 }
 
-static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
+static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
 {
-	if (hba->vops && hba->vops->device_reset) {
-		int err = hba->vops->device_reset(hba);
-
-		if (!err) {
-			ufshcd_set_ufs_dev_active(hba);
-			if (ufshcd_is_wb_allowed(hba)) {
-				hba->wb_enabled = false;
-				hba->wb_buf_flush_enabled = false;
-			}
-		}
-		if (err != -EOPNOTSUPP)
-			ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
-	}
+	if (hba->vops && hba->vops->device_reset)
+		return hba->vops->device_reset(hba);
+
+	return -EOPNOTSUPP;
 }
 
 static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
-- 
2.18.0

