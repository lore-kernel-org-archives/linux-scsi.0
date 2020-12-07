Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1CBC1B0E3
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 05:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D136B22A85
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 05:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgLGFuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 00:50:51 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60583 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725799AbgLGFuv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 00:50:51 -0500
X-UUID: 9559639d0b5a4169aed1f4ad40a2a174-20201207
X-UUID: 9559639d0b5a4169aed1f4ad40a2a174-20201207
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 585174363; Mon, 07 Dec 2020 13:50:08 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 7 Dec 2020 13:50:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Dec 2020 13:50:05 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH] scsi: ufs: Enable WB flush during suspend only if WB is enabled
Date:   Mon, 7 Dec 2020 13:50:06 +0800
Message-ID: <20201207055006.24471-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7ECFD28C327FC532B2FC8FDB68299D886D91BB65601C989360DB1525EEFAE1122000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

WriteBootser flush during suspend is not necessary to be enabled if
WriteBooster feature is disabled. Simply adding a check to prevent
unexpected power drain.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4879e87577e1..89fa8b9ac11d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5458,7 +5458,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	u32 avail_buf;
 	u8 index;
 
-	if (!ufshcd_is_wb_allowed(hba))
+	if (!ufshcd_is_wb_allowed(hba) || !hba->wb_enabled)
 		return false;
 	/*
 	 * The ufs device needs the vcc to be ON to flush.
-- 
2.18.0

