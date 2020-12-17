Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784D8C2BB40
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 04:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F51238A0
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 04:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgLQEZa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 23:25:30 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40688 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbgLQEZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 23:25:30 -0500
X-UUID: 25812e1e89de4a17b0eae6cf91f8821d-20201217
X-UUID: 25812e1e89de4a17b0eae6cf91f8821d-20201217
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 57443078; Thu, 17 Dec 2020 12:24:44 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Dec 2020 12:24:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 12:24:40 +0800
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
Subject: [PATCH v1] scsi: ufs: Fix possible power drain during system suspend
Date:   Thu, 17 Dec 2020 12:24:41 +0800
Message-ID: <20201217042441.31119-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D010D6472C5F9E0B7E4432BE4710CC640C243D934F097B7906218BF37DD362882000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently if device needs to do flush or BKOP operations,
the device VCC power is kept during runtime-suspend period.

However, if system suspend is happening while device is
runtime-suspended, such power may not be disabled successfully.

The reasons may be,

1. If current PM level is the same as SPM level, device will
   keep runtime-suspended by ufshcd_system_suspend().

2. Flush recheck work may not be scheduled successfully
   during system suspend period. If it can wake up the system,
   this is also not the intention of the recheck work.

To fix this issue, simply runtime-resume the device if the flush
is allowed during runtime suspend period. Flush capability will be
disabled while leaving runtime suspend, and also not be allowed in
system suspend period.

Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during runtime suspend")
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add25a7e..9d61dc3eb842 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8903,7 +8903,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-	     hba->uic_link_state))
+	     hba->uic_link_state) &&
+	     !hba->dev_info.b_rpm_dev_flush_capable)
 		goto out;
 
 	if (pm_runtime_suspended(hba->dev)) {
-- 
2.18.0

