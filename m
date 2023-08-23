Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70527EE49B2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 10:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjHWKFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 06:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbjHWJiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 05:38:05 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9721C86A7
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 02:30:00 -0700 (PDT)
X-UUID: 9c5e8944419711eeb20a276fd37b9834-20230823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=D9B5gKjOEPiOOStjLAPxB+tM/isvMol7/cjHa3Fam3g=;
        b=PuTy4LEPziZ5Kin4734GFpT+unRRbGd1A3S58E/gzIMeiCMfTtkiifKXFW/mT2dTmkYbbIFt8e75JTNtMmCr1KsPjNhrAFIaQ8yF/7C7Wb2MuXLzK2jyLlAxlcebHJfcYr1NWvs8uN55pX3eSfZ9FzB3MXtoUx3M8SwiZAwuBdw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:4ebba29d-524d-4422-ab40-ee4da6d19e44,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:90
X-CID-INFO: VERSION:1.1.31,REQID:4ebba29d-524d-4422-ab40-ee4da6d19e44,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:90
X-CID-META: VersionHash:0ad78a4,CLOUDID:3fd51813-4929-4845-9571-38c601e9c3c9,B
        ulkID:230823172954CG29KUPX,BulkQuantity:0,Recheck:0,SF:38|29|28|17|19|48,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
        L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_SDM,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS,
        TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-UUID: 9c5e8944419711eeb20a276fd37b9834-20230823
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 63988343; Wed, 23 Aug 2023 17:29:51 +0800
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
Subject: [PATCH v1 3/3] ufs: core: fix abnormal scale up after scale down
Date:   Wed, 23 Aug 2023 17:29:48 +0800
Message-ID: <20230823092948.22734-4-peter.wang@mediatek.com>
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

When no active_reqs, devfreq_monitor(Thread A) will suspend clock scaling.
But it may have racing with clk_scaling.suspend_work(Thread B) and
actually not suspend clock scaling(requue after suspend).
Next time after polling_ms, devfreq_monitor read
clk_scaling.window_start_t = 0 then scale up clock abnormal.

Below is racing step:
	devfreq->work (Thread A)
	devfreq_monitor
		update_devfreq
		.....
			ufshcd_devfreq_target
			queue_work(hba->clk_scaling.workq,
1			   &hba->clk_scaling.suspend_work)
		.....
5	queue_delayed_work(devfreq_wq, &devfreq->work,
			msecs_to_jiffies(devfreq->profile->polling_ms));

2	hba->clk_scaling.suspend_work (Thread B)
	ufshcd_clk_scaling_suspend_work
		__ufshcd_suspend_clkscaling
			devfreq_suspend_device(hba->devfreq);
3				cancel_delayed_work_sync(&devfreq->work);
4			hba->clk_scaling.window_start_t = 0;
	.....

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 017f32b3a789..d3b913d389f4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1431,6 +1431,13 @@ static int ufshcd_devfreq_target(struct device *dev,
 		return 0;
 	}
 
+	/* Skip scaling clock when clock scaling is suspended */
+	if (hba->clk_scaling.is_suspended) {
+		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		dev_warn(hba->dev, "clock scaling is suspended, skip");
+		return 0;
+	}
+
 	if (!hba->clk_scaling.active_reqs)
 		sched_clk_scaling_suspend_work = true;
 
-- 
2.18.0

