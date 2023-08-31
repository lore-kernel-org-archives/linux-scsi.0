Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC7AC83F33
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 13:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbjHaNIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 09:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbjHaNIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 09:08:39 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF57BC
        for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2023 06:08:37 -0700 (PDT)
X-UUID: 7beef2e847ff11ee99480b3a0002f391-20230831
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=MtZHyXQ7DGRPhpbCpbsIJoEBq+bGheQvQ3n4RUzQzJQ=;
        b=T1D94anUrA3pbS5+DXxwEZs6I6ep9KcWaLV9BKz8hud1JtV15G6Elp9mnl0GdRpsTXB2hAdiFKP+Ut5zeu+4nU14jH/MQmEDsbYMsKimA7eYsXxVWildY4Hw3hdz4oFZzYUPeZUhGPcwasF3P43oMR8tP+EtBtZMYktDs2HFAGM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:667197a7-a905-4338-9923-296fb7fa9d56,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:0ad78a4,CLOUDID:8d64f81f-33fd-4aaa-bb43-d3fd68d9d5ae,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 7beef2e847ff11ee99480b3a0002f391-20230831
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 769978467; Thu, 31 Aug 2023 21:08:31 +0800
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
Subject: [PATCH v2 3/3] ufs: core: fix abnormal scale up after scale down
Date:   Thu, 31 Aug 2023 21:08:26 +0800
Message-ID: <20230831130826.5592-4-peter.wang@mediatek.com>
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 057549b0e586..d72fa2c1e316 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1430,6 +1430,13 @@ static int ufshcd_devfreq_target(struct device *dev,
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

