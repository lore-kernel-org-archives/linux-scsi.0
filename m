Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4512E776E9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 02:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjJCCUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 22:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjJCCUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 22:20:17 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DD5AD
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 19:20:14 -0700 (PDT)
X-UUID: 5db02e20619311ee8051498923ad61e6-20231003
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=jMfgszel4XaxxTVf42vBSHcsSn1JHej+fW2fJ56Bv/o=;
        b=CD9LjqLL0/uVH/mtOmU9yTKrU1SH2xVF2jLGwOenDmVnG95735iNKS+gKoCKWVfPItatStax1yEOidY0zuBCJ9UfoXSaEvGwOSy2zzupQVEkdfALZaW1GMgKbgiMVWD+Fh2s+Sk+rw6hcAGyV6sVGOBoi2PTrrJ4WFMPORRaFQY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:4880741e-cb44-478b-9931-f9109d2d2ae6,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:5b4d83bf-14cc-44ca-b657-2d2783296e72,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 5db02e20619311ee8051498923ad61e6-20231003
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1241552465; Tue, 03 Oct 2023 10:20:05 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 3 Oct 2023 10:20:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 3 Oct 2023 10:20:03 +0800
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
Subject: [PATCH v2] ufs: core: correct clear tm error log
Date:   Tue, 3 Oct 2023 10:20:02 +0800
Message-ID: <20231003022002.25578-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--3.598200-8.000000
X-TMASE-MatchedRID: MACTyP4PrdMMQLXc2MGSbJYsKSXWWrsHgRykyfrH1xmjD9XxfoENjlO4
        BD7nLMxnThbvLLI8RvOlEtDJyVR88h8TzIzimOwPlpYqKNmWxsHZs3HUcS/scCq2rl3dzGQ19+9
        ZqEp9FTicIUr2FfTL+ZJo1iCcy5Li0PGPpPs2kfj6OiWRTETtvcu4wdQxN6w5vkOBSdrypXBibC
        8jY1wJkHh1KtoeV8/TCD/VEQPyg2AXRoPmWO3jekxwdkPqCq7vDEyN+J8hd+jCS9WgDXVPCp6oP
        1a0mRIj
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.598200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 37F58E312851E29D84D1EAED8F6B3B46F15EEEFEC37354F2367A7684C087E15E2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

The clear tm function error log is inverted.

Fixes: 4693fad7d6d4 ("scsi: ufs: core: Log error handler activity")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..8382e8cfa414 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6895,7 +6895,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 			mask, 0, 1000, 1000);
 
 	dev_err(hba->dev, "Clearing task management function with tag %d %s\n",
-		tag, err ? "succeeded" : "failed");
+		tag, err < 0 ? "failed" : "succeeded");
 
 out:
 	return err;
-- 
2.18.0

