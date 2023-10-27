Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEC9C25B47
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 08:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345710AbjJ0IyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Oct 2023 04:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbjJ0IyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Oct 2023 04:54:07 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F420D56
        for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2023 01:43:41 -0700 (PDT)
X-UUID: e9a6cf9674a411eea33bb35ae8d461a2-20231027
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=VcyzQ2NeYWUVU838NXIO17JVGw61EnQMWdi7e/381zA=;
        b=PlSNIqIyH+uOTmuhN3OfBEjheZtn5ANtrQOjCymKJj4pE3dtzBeAn3PhCmg9YgiTdYjIJYNmJsyy7fikQLilVziVAnKGSBJ7E+uIqUI/M37wfolOu5JjUtgbFudxH9mJ7hE2i+gY8CNTNcsg97GOZBiRvtXFJLSngtxBijSNUdM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:7a3c05e8-a345-4c8d-9f08-03ffd2d1aa5f,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:5f78ec9,CLOUDID:0135f771-1bd3-4f48-b671-ada88705968c,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e9a6cf9674a411eea33bb35ae8d461a2-20231027
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 360201609; Fri, 27 Oct 2023 16:43:33 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 27 Oct 2023 16:43:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 27 Oct 2023 16:43:32 +0800
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
Subject: [PATCH v1] ufs: core: fix racing issue between ufshcd_mcq_abort and ISR
Date:   Fri, 27 Oct 2023 16:43:29 +0800
Message-ID: <20231027084329.4067-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--7.853700-8.000000
X-TMASE-MatchedRID: sBypFcuOxUYMQLXc2MGSbBuZoNKc6pl+WPJn4UmMuVJ0cpXNtrVD/RFG
        4EGBR4d4nFnqwstPnWZOTRDyBol0uXAvdl/gU+kWydRN/Yyg4pid2Wz0X3OaLd9RlPzeVuQQ8rM
        P48ANS13i8zVgXoAltsIJ+4gwXrEtwrbXMGDYqV94uFxKD13nMe+qZbkhrKAvDcHRGkNOD0huqx
        mYCr02+2o6x355ikkS
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.853700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 6956C7A927BB23CF71FBC2478C5F13C21FD7890C25E3F5B2D56A548C830530692000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

If command timeout happen and cq complete irq raise at the same time,
ufshcd_mcq_abort null the lprb->cmd and NULL poiner KE in ISR.
Below is error log.

ufshcd_abort: Device abort task at tag 18
Unable to handle kernel NULL pointer dereference at virtual address
0000000000000108
pc : [0xffffffe27ef867ac] scsi_dma_unmap+0xc/0x44
lr : [0xffffffe27f1b898c] ufshcd_release_scsi_cmd+0x24/0x114

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 2ba8ec254dce..6ea96406f2bf 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -630,6 +630,7 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
+	unsigned long flags;
 	int err = FAILED;
 
 	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
@@ -670,8 +671,10 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	}
 
 	err = SUCCESS;
+	spin_lock_irqsave(&hwq->cq_lock, flags);
 	if (ufshcd_cmd_inflight(lrbp->cmd))
 		ufshcd_release_scsi_cmd(hba, lrbp);
+	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 
 out:
 	return err;
-- 
2.18.0

