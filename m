Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9E3EE4993
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 10:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjHWKFs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 06:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbjHWJiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 05:38:02 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627915591
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 02:29:59 -0700 (PDT)
X-UUID: 9c56cc40419711eeb20a276fd37b9834-20230823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=GSg2e73VclKyIcN/NYbriQbZxkef6F8tmT/HnNPPCUk=;
        b=AZxuVmDyMJax7/izRGWTWzPW09wIdqJshdGOfJRNH6NoutMCINOmG3qHNdy6BZ2IS8mHMk9kWhXT75S5S2L/lcHqa/9zuyq3xJUKogvnDGQl+iqBXpGihZkmrrg8AxFZNd7vZp+4vbsYZqG+N4D3Ga0N5XOA+3ASfmG1l+HPrsE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:f515ea40-439e-48f4-b170-ee0880810457,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:90
X-CID-INFO: VERSION:1.1.31,REQID:f515ea40-439e-48f4-b170-ee0880810457,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:90
X-CID-META: VersionHash:0ad78a4,CLOUDID:4eafa81f-33fd-4aaa-bb43-d3fd68d9d5ae,B
        ulkID:230823172954M9Z3MBHV,BulkQuantity:0,Recheck:0,SF:38|29|28|17|19|48,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
        L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_SDM,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS,
        TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-UUID: 9c56cc40419711eeb20a276fd37b9834-20230823
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 305665578; Wed, 23 Aug 2023 17:29:51 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 23 Aug 2023 17:29:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 23 Aug 2023 17:29:50 +0800
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
Subject: [PATCH v1 2/3] ufs: core: fix abnormal scale up after last cmd finish
Date:   Wed, 23 Aug 2023 17:29:47 +0800
Message-ID: <20230823092948.22734-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230823092948.22734-1-peter.wang@mediatek.com>
References: <20230823092948.22734-1-peter.wang@mediatek.com>
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
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e3672e55efae..017f32b3a789 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1385,9 +1385,10 @@ static void ufshcd_clk_scaling_suspend_work(struct work_struct *work)
 		return;
 	}
 	hba->clk_scaling.is_suspended = true;
+	hba->clk_scaling.window_start_t = 0;
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
-	__ufshcd_suspend_clkscaling(hba);
+	devfreq_suspend_device(hba->devfreq);
 }
 
 static void ufshcd_clk_scaling_resume_work(struct work_struct *work)
-- 
2.18.0

