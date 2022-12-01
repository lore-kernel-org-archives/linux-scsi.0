Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB91C47088
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 09:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiLAJo3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLAJoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 04:44:14 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67B68EE73
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 01:44:08 -0800 (PST)
X-UUID: 2f1b84a7b1ca49bd8745677374c16705-20221201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=P587dA8Aha5RLNm5yWfcKiJxxnQVVKASOviRpQBreb8=;
        b=h1M35Jvcab5aLqVEbmVUddZFWv/NGjA4jEjsvvE+S2JbQtyFrwUFz5fWlb/3f+LQltlM7lLh86qwuKsJJbjCshm31dwuxyd6v7YtqQruRNneWhYpkNii+bXnCzAWeQzDZtD/g0s6/5xT32PTkV3DTdxjaUsLOpDdA+5ucRoG6mU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:da7c34a1-d18b-4b5e-865d-951e9b2c5e21,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:dcaaed0,CLOUDID:7914dc1e-5e1d-4ab5-ab8e-3e04efc02b30,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 2f1b84a7b1ca49bd8745677374c16705-20221201
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1711310103; Thu, 01 Dec 2022 17:44:02 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 1 Dec 2022 17:44:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 1 Dec 2022 17:44:01 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>
Subject: [PATCH v2] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
Date:   Thu, 1 Dec 2022 17:43:58 +0800
Message-ID: <20221201094358.20700-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When SSU/enter hibern8 fail in wlun suspend flow, trigger error
handler and return busy to break the suspend.
If not, wlun runtime pm status become error and the consumer will
stuck in runtime suspend status.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b1f59a5fe632..8e5f7d9fe7c2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8970,6 +8970,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
+	unsigned long flags;
 
 	hba->pm_op_in_progress = true;
 	if (pm_op != UFS_SHUTDOWN_PM) {
@@ -9049,6 +9050,20 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 		if (!hba->dev_info.b_rpm_dev_flush_capable) {
 			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
+			if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {
+				/*
+				 * If return err in suspend flow, IO will hang.
+				 * Trigger error handler and break suspend for
+				 * error recovery.
+				 */
+				spin_lock_irqsave(hba->host->host_lock, flags);
+				hba->force_reset = true;
+				ufshcd_schedule_eh_work(hba);
+				spin_unlock_irqrestore(hba->host->host_lock,
+					flags);
+
+				ret = -EBUSY;
+			}
 			if (ret)
 				goto enable_scaling;
 		}
@@ -9060,6 +9075,20 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 */
 	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
 	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
+	if ((ret) && (pm_op != UFS_SHUTDOWN_PM)) {
+		/*
+		 * If return err in suspend flow, IO will hang.
+		 * Trigger error handler and break suspend for
+		 * error recovery.
+		 */
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->force_reset = true;
+		ufshcd_schedule_eh_work(hba);
+		spin_unlock_irqrestore(hba->host->host_lock,
+			flags);
+
+		ret = -EBUSY;
+	}
 	if (ret)
 		goto set_dev_active;
 
-- 
2.18.0

