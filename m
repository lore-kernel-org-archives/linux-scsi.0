Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA51C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 105F42223D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgKPGvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:06 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56409 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727166AbgKPGvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:05 -0500
X-UUID: 63e5d1246d63429b928920b9aacebae1-20201116
X-UUID: 63e5d1246d63429b928920b9aacebae1-20201116
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1379785335; Mon, 16 Nov 2020 14:50:57 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 16 Nov 2020 14:50:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 16 Nov 2020 14:50:55 +0800
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
Subject: [PATCH v1 1/9] scsi: ufs-mediatek: Refactor performance scaling functions
Date:   Mon, 16 Nov 2020 14:50:46 +0800
Message-ID: <20201116065054.7658-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7BA158C2F014F9EBECDA729273DE98A4D70B8A66006E120B5A876D526A8E02762000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Refactor preformance scaling related functions in MediaTek
UFS driver.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 7fed7630d36c..b9b423752ee1 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -514,6 +514,19 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
+static void ufs_mtk_scale_perf(struct ufs_hba *hba, bool up)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	ufs_mtk_boost_crypt(hba, up);
+	ufs_mtk_setup_ref_clk(hba, up);
+
+	if (up)
+		phy_power_on(host->mphy);
+	else
+		phy_power_off(host->mphy);
+}
+
 /**
  * ufs_mtk_setup_clocks - enables/disable clocks
  * @hba: host controller instance
@@ -555,15 +568,10 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 				clk_pwr_off = true;
 		}
 
-		if (clk_pwr_off) {
-			ufs_mtk_boost_crypt(hba, on);
-			ufs_mtk_setup_ref_clk(hba, on);
-			phy_power_off(host->mphy);
-		}
+		if (clk_pwr_off)
+			ufs_mtk_scale_perf(hba, false);
 	} else if (on && status == POST_CHANGE) {
-		phy_power_on(host->mphy);
-		ufs_mtk_setup_ref_clk(hba, on);
-		ufs_mtk_boost_crypt(hba, on);
+		ufs_mtk_scale_perf(hba, true);
 	}
 
 	return ret;
-- 
2.18.0

