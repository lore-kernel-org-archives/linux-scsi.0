Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A10AC83F34
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 13:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244263AbjHaNIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 09:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243868AbjHaNIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 09:08:42 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0BB1A4
        for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2023 06:08:37 -0700 (PDT)
X-UUID: 7bee11f247ff11ee99480b3a0002f391-20230831
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vpMcaEyrAdaGuO54jgsDq+62Am9F9en4DBy1lZ6dSgs=;
        b=fBp5ulhT2YSuGFVmKl4wdQHtdK0ASEt4GtzWGweQwqdK1EenS9ZzmmRvt96nMHAJrQ0xiUkpswPXqw4NJw3bN1pvj4zJ958cSRpjrgJOOrZ3DWokIA3VeZNiF8yF8TN7mPfXYfU9flkUwj750Ya79kMPLop+4B4ZPVb2AhNBAOU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:af51b50d-be34-46c9-8fa5-b78cc4654f1f,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:0ad78a4,CLOUDID:929c6813-4929-4845-9571-38c601e9c3c9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 7bee11f247ff11ee99480b3a0002f391-20230831
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 553812745; Thu, 31 Aug 2023 21:08:31 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 31 Aug 2023 21:08:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 31 Aug 2023 21:08:30 +0800
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
Subject: [PATCH v2 2/3] ufs: core: fix abnormal scale up after last cmd finish
Date:   Thu, 31 Aug 2023 21:08:25 +0800
Message-ID: <20230831130826.5592-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230831130826.5592-1-peter.wang@mediatek.com>
References: <20230831130826.5592-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When ufshcd_clk_scaling_suspend_work(Thread A) running and new command
coming, ufshcd_clk_scaling_start_busy(Thread B) may get host_lock
after Thread A first time release host_lock. Then Thread A second time
get host_lock will set clk_scaling.window_start_t = 0 which scale up
clock abnormal next polling_ms time.
Also inlines another __ufshcd_suspend_clkscaling calls.

Below is racing step:
1	hba->clk_scaling.suspend_work (Thread A)
	ufshcd_clk_scaling_suspend_work
2		spin_lock_irqsave(hba->host->host_lock, irq_flags);
3		hba->clk_scaling.is_suspended = true;
4		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
		__ufshcd_suspend_clkscaling
7			spin_lock_irqsave(hba->host->host_lock, flags);
8			hba->clk_scaling.window_start_t = 0;
9			spin_unlock_irqrestore(hba->host->host_lock, flags);

	ufshcd_send_command (Thread B)
		ufshcd_clk_scaling_start_busy
5			spin_lock_irqsave(hba->host->host_lock, flags);
			....
6			spin_unlock_irqrestore(hba->host->host_lock, flags);

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e3672e55efae..057549b0e586 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -275,7 +275,6 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba);
-static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba);
 static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
@@ -1385,9 +1384,10 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 		return;
 	}
 	hba->clk_scaling.is_suspended = true;
+	hba->clk_scaling.window_start_t = 0;
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
-	__ufshcd_suspend_clkscaling(hba);
+	devfreq_suspend_device(hba->devfreq);
 }
 
 static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
@@ -1564,16 +1564,6 @@ static void ufshcd_devfreq_remove(struct ufs_hba *hba)
 	dev_pm_opp_remove(hba->dev, clki->max_freq);
 }
 
-static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
-{
-	unsigned long flags;
-
-	devfreq_suspend_device(hba->devfreq);
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->clk_scaling.window_start_t = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-}
-
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
 	unsigned long flags;
@@ -1586,11 +1576,12 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 	if (!hba->clk_scaling.is_suspended) {
 		suspend = true;
 		hba->clk_scaling.is_suspended = true;
+		hba->clk_scaling.window_start_t = 0;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (suspend)
-		__ufshcd_suspend_clkscaling(hba);
+		devfreq_suspend_device(hba->devfreq);
 }
 
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
-- 
2.18.0

