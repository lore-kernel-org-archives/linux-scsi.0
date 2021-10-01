Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F79C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 07:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7656261A55
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 07:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352617AbhJAH5p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 03:57:45 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:37654 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231237AbhJAH5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 03:57:44 -0400
X-UUID: 88f4852ee7244f6e894cada71038b24f-20211001
X-UUID: 88f4852ee7244f6e894cada71038b24f-20211001
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 440655713; Fri, 01 Oct 2021 15:55:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 1 Oct 2021 15:55:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 Oct 2021 15:55:55 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
Subject: [PATCH v1] scsi: ufs: add wmb after clear interrupt status
Date:   Fri, 1 Oct 2021 15:55:49 +0800
Message-ID: <20211001075549.7313-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Write IS(0x20) to clear interrupts should be done before
read UTRLDBR(0x58) or UTRLCNR(0x64).
If optimize lead to read TRLDBR(0x58) or UTRLCNR(0x64) before
Write IS(0x20), the final complete task may miss.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..3318b3b6c916 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6492,6 +6492,10 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
+
+		/* Make sure interrupt status are clear before service */
+		wmb();
+
 		if (enabled_intr_status)
 			retval |= ufshcd_sl_intr(hba, enabled_intr_status);
 
-- 
2.18.0

