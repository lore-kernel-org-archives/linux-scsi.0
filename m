Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF793C2BB9A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9394E2226A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgLOJkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:40:37 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33782 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728160AbgLOJkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:40:24 -0500
X-UUID: fbc6ddef67e84c37a5a154b284793fae-20201215
X-UUID: fbc6ddef67e84c37a5a154b284793fae-20201215
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 473899769; Tue, 15 Dec 2020 17:39:36 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 17:39:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 17:39:36 +0800
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
Subject: [PATCH v1 2/4] scsi: ufs: Cleanup ufshcd_add_lus function
Date:   Tue, 15 Dec 2020 17:39:32 +0800
Message-ID: <20201215093934.21223-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201215093934.21223-1-stanley.chu@mediatek.com>
References: <20201215093934.21223-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hba->devfreq is zero-initialized thus it is not required
to check its existence in ufshcd_add_lus() function which
is invoked during initialization only.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a91b73a1fc48..9cc16598136d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7636,15 +7636,13 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 			&hba->pwr_info,
 			sizeof(struct ufs_pa_layer_attr));
 		hba->clk_scaling.saved_pwr_info.is_valid = true;
-		if (!hba->devfreq) {
-			hba->clk_scaling.is_allowed = true;
-			ret = ufshcd_devfreq_init(hba);
-			if (ret)
-				goto out;
+		hba->clk_scaling.is_allowed = true;
+		ret = ufshcd_devfreq_init(hba);
+		if (ret)
+			goto out;
 
-			hba->clk_scaling.is_enabled = true;
-			ufshcd_clkscaling_init_sysfs(hba);
-		}
+		hba->clk_scaling.is_enabled = true;
+		ufshcd_clkscaling_init_sysfs(hba);
 	}
 
 	ufs_bsg_probe(hba);
-- 
2.18.0

