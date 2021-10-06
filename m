Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A894C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 03:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF48B61139
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 03:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhJFDL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 23:11:59 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:41708 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237183AbhJFDL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 23:11:57 -0400
X-UUID: 96d6a5a282634e96bca0f64d8e4badea-20211006
X-UUID: 96d6a5a282634e96bca0f64d8e4badea-20211006
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1004137058; Wed, 06 Oct 2021 11:10:02 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 6 Oct 2021 11:10:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Oct 2021 11:10:01 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <mikebi@micron.com>
Subject: [PATCH v3 1/2] scsi: ufs: support vops pre suspend
Date:   Wed, 6 Oct 2021 11:09:58 +0800
Message-ID: <20211006030959.20533-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211006030959.20533-1-peter.wang@mediatek.com>
References: <20211006030959.20533-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

This patch introduce an solution to do pre suspned before SSU
(sleep) command.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++--
 drivers/scsi/ufs/ufshcd.h | 8 +++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 188de6f91050..73eb626fa88f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8897,6 +8897,10 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	flush_work(&hba->eeh_work);
 
+	ret = ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE);
+	if (ret)
+		goto enable_scaling;
+
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
 		if (pm_op != UFS_RUNTIME_PM)
 			/* ensure that bkops is disabled */
@@ -8924,7 +8928,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * vendor specific host controller register space call them before the
 	 * host clocks are ON.
 	 */
-	ret = ufshcd_vops_suspend(hba, pm_op);
+	ret = ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
 	if (ret)
 		goto set_link_active;
 	goto out;
@@ -9052,7 +9056,8 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 set_old_link_state:
 	ufshcd_link_state_transition(hba, old_link_state, 0);
 vendor_suspend:
-	ufshcd_vops_suspend(hba, pm_op);
+	ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE);
+	ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f0da5d3db1fa..e90320253d96 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -344,7 +344,8 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status);
 	int	(*apply_dev_quirks)(struct ufs_hba *hba);
 	void	(*fixup_dev_quirks)(struct ufs_hba *hba);
-	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
+	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op,
+					enum ufs_notify_change_status);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
@@ -1300,10 +1301,11 @@ static inline void ufshcd_vops_fixup_dev_quirks(struct ufs_hba *hba)
 		hba->vops->fixup_dev_quirks(hba);
 }
 
-static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
+static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op,
+				enum ufs_notify_change_status status)
 {
 	if (hba->vops && hba->vops->suspend)
-		return hba->vops->suspend(hba, op);
+		return hba->vops->suspend(hba, op, status);
 
 	return 0;
 }
-- 
2.18.0

