Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA58C19F2C
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 14:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbiHBOdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbiHBOdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 10:33:49 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C75DF61
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 07:33:48 -0700 (PDT)
X-UUID: 97a0f346b90640f5946820bc0cb6e13d-20220802
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:7560e8b9-f707-430b-ad3b-c49339d1aa8b,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:5a4d16d0-a6cf-4fb6-be1b-c60094821ca2,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 97a0f346b90640f5946820bc0cb6e13d-20220802
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2091742629; Tue, 02 Aug 2022 22:33:41 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 2 Aug 2022 22:33:40 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 2 Aug 2022 22:33:40 +0800
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
Subject: [PATCH v3 2/2] ufs: host: support wb toggle with clock scaling
Date:   Tue, 2 Aug 2022 22:32:23 +0800
Message-ID: <20220802143223.1276-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220802143223.1276-1-peter.wang@mediatek.com>
References: <20220802143223.1276-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Set UFSHCD_CAP_WB_WITH_CLK_SCALING for qcom to compatible legacy design.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index f10d4668814c..f8c9a78e7776 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -869,7 +869,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
-	hba->caps |= UFSHCD_CAP_CLK_SCALING;
+	hba->caps |= UFSHCD_CAP_CLK_SCALING | UFSHCD_CAP_WB_WITH_CLK_SCALING;
 	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	hba->caps |= UFSHCD_CAP_CRYPTO;
-- 
2.18.0

