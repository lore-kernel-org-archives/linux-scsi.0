Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8D6C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC2D220A8B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgKPGvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:04 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56429 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727226AbgKPGvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:04 -0500
X-UUID: d7f1ca938c2c4145a203ae78dd275a93-20201116
X-UUID: d7f1ca938c2c4145a203ae78dd275a93-20201116
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 988543428; Mon, 16 Nov 2020 14:50:57 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 16 Nov 2020 14:50:56 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 16 Nov 2020 14:50:56 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <kwmad.kim@samsung.com>,
        <liwei213@huawei.com>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 8/9] scsi: ufs-mediatek: Use common ADAPT configuration function
Date:   Mon, 16 Nov 2020 14:50:53 +0800
Message-ID: <20201116065054.7658-9-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 586618FD9FC2E94551F1713EFAAF3BF557FB27D60D232CE7923BD1AADFE1CDAF2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common ADAPT configuration function to reduce duplicated
code in UFS drivers.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 87b4bf125e23..1d3c5cd4592e 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -677,7 +677,6 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_dev_params host_cap;
-	u32 adapt_val;
 	int ret;
 
 	ufshcd_init_pwr_dev_param(&host_cap);
@@ -693,13 +692,9 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	}
 
 	if (host->hw_ver.major >= 3) {
-		if (dev_req_params->gear_tx == UFS_HS_G4)
-			adapt_val = PA_INITIAL_ADAPT;
-		else
-			adapt_val = PA_NO_ADAPT;
-		ufshcd_dme_set(hba,
-			       UIC_ARG_MIB(PA_TXHSADAPTTYPE),
-			       adapt_val);
+		ret = ufshcd_dme_configure_adapt(hba,
+					   dev_req_params->gear_tx,
+					   PA_INITIAL_ADAPT);
 	}
 
 	return ret;
-- 
2.18.0

