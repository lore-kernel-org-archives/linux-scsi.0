Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24259ECAAD3
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 11:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiIOL7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIOL7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 07:59:06 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B821B
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 04:59:04 -0700 (PDT)
X-UUID: 876b442f9f7e46188075afdf1aa80920-20220915
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=iyNKhEf01mkI1QPkYYxrp17y2Y3l4kNNw3ZTDAadyT0=;
        b=fKkA0AKzEWZ5pHV4DG/IOB9TINuBqwiN1aH5ueKewKwYn3iVZfcu6sZw+ALuDfeliCN+nKDzz1b/Mf22UWfjrbZMwbrjCqCOZCcekdcvd0+L+zAO1970M9Ae+gAeTJE7XljkxaFkgVaqetnqj5RmOmMdRoT+vZq7i4FPoJbkeuo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:8031254e-1642-4330-96fd-4bef1c795df3,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:39a5ff1,CLOUDID:a830c65d-5ed4-4e28-8b00-66ed9f042fbd,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 876b442f9f7e46188075afdf1aa80920-20220915
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1734014977; Thu, 15 Sep 2022 19:59:01 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 15 Sep 2022 19:59:00 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 15 Sep 2022 19:59:00 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Subject: [PATCH v1] ufs: core: bypass get rpm when err handling with pm_op_in_progress
Date:   Thu, 15 Sep 2022 19:58:58 +0800
Message-ID: <20220915115858.7642-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

If error happened in rpm flow, get rpm will stuck because rpm is
suspending or resuming. And it cause IO hang.
This patch bypass get rpm when err handling with pm_op_in_progress.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a202d7d5240d..cc58fb585df2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6086,9 +6086,13 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 	}
 }
 
-static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
+static void ufshcd_err_handling_prepare(struct ufs_hba *hba, bool *rpm_put)
 {
-	ufshcd_rpm_get_sync(hba);
+	if (!hba->pm_op_in_progress) {
+		ufshcd_rpm_get_sync(hba);
+		*rpm_put = true;
+	}
+
 	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
 	    hba->is_sys_suspended) {
 		enum ufs_pm_op pm_op;
@@ -6122,13 +6126,14 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	cancel_work_sync(&hba->eeh_work);
 }
 
-static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
+static void ufshcd_err_handling_unprepare(struct ufs_hba *hba, bool rpm_put)
 {
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
-	ufshcd_rpm_put(hba);
+	if (rpm_put)
+		ufshcd_rpm_put(hba);
 }
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
@@ -6210,6 +6215,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	bool err_tm;
 	int pmc_err;
 	int tag;
+	bool rpm_put = false;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
@@ -6231,7 +6237,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_err_handling_prepare(hba);
+	ufshcd_err_handling_prepare(hba, &rpm_put);
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6394,7 +6400,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_err_handling_unprepare(hba);
+	ufshcd_err_handling_unprepare(hba, rpm_put);
 	up(&hba->host_sem);
 
 	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
-- 
2.18.0

