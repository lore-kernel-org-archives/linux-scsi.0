Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F255C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C5261152
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 09:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhKKJwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 04:52:39 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:51866 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229668AbhKKJwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 04:52:37 -0500
X-UUID: a4adca22386c407faf21a3961981e030-20211111
X-UUID: a4adca22386c407faf21a3961981e030-20211111
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1037976598; Thu, 11 Nov 2021 17:49:45 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 11 Nov 2021 17:49:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs10n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 11 Nov 2021 17:49:43 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <mikebi@micron.com>
Subject: [PATCH v1] scsi: ufs: fix tm cmd timeout/ISR racing issue
Date:   Thu, 11 Nov 2021 17:49:39 +0800
Message-ID: <20211111094939.14991-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When tmc 100 ms timeout and recevied tmc complete ISR concurrently,
Bug happen because complete NULL poiner and KE.
Fix this racing issue by check NULL and use host_lock protect.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5c6a58a666d2..6821ceb6783e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6442,7 +6442,8 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 		struct request *req = hba->tmf_rqs[tag];
 		struct completion *c = req->end_io_data;
 
-		complete(c);
+		if (c)
+			complete(c);
 		ret = IRQ_HANDLED;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -6597,7 +6598,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		 * Make sure that ufshcd_compl_tm() does not trigger a
 		 * use-after-free.
 		 */
+		spin_lock_irqsave(hba->host->host_lock, flags);
 		req->end_io_data = NULL;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-- 
2.18.0

