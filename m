Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6E5EE4993
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 10:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjHWKF6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 06:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbjHWJiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 05:38:02 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC735588
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2023 02:29:58 -0700 (PDT)
X-UUID: 9c50dd76419711eeb20a276fd37b9834-20230823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=WHTqxrFEmuBd3YvMSfVGlAXWreyi/5MI1M+PBZMby+U=;
        b=GtfGNWPVvpuwi6Re+NMWYa8PKgXnKPFLMfzD9EbqOnydp33fT6uQvbspA1damx7KHVy0WdmJ57waggedpyMxQeA7W2oW35AXVxi1lyJPOt/1Jfszm+1VbS43omTUs9l3ZZpMF6XdUexLvdrJooTCr875Mjr7pm+/DXbLM8MZYe4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:a46e833a-4358-4b10-9d9f-b5c56a171fcc,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:90
X-CID-INFO: VERSION:1.1.31,REQID:a46e833a-4358-4b10-9d9f-b5c56a171fcc,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:90
X-CID-META: VersionHash:0ad78a4,CLOUDID:c218dbee-9a6e-4c39-b73e-f2bc08ca3dc5,B
        ulkID:2308231729542OGO2GVW,BulkQuantity:0,Recheck:0,SF:38|29|28|17|19|48,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
        L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_SDM,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS,
        TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-UUID: 9c50dd76419711eeb20a276fd37b9834-20230823
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 240061959; Wed, 23 Aug 2023 17:29:51 +0800
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
Subject: [PATCH v1 1/3] ufs: core: only suspend clock scaling if scale down
Date:   Wed, 23 Aug 2023 17:29:46 +0800
Message-ID: <20230823092948.22734-2-peter.wang@mediatek.com>
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

If clock scale up and suspend clock scaling, ufs will keep high
performance/power mode but no read/write requests on going.
It is logic wrong and have power concern.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 129446775796..e3672e55efae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1458,7 +1458,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 out:
-	if (sched_clk_scaling_suspend_work)
+	if (sched_clk_scaling_suspend_work && !scale_up)
 		queue_work(hba->clk_scaling.workq,
 			   &hba->clk_scaling.suspend_work);
 
-- 
2.18.0

