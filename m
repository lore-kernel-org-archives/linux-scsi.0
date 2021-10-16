Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341F7C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 00:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14DDE6124F
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 00:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbhJPBAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 21:00:22 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:47010 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234607AbhJPBAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 21:00:15 -0400
X-UUID: 16e89e3752c04842827b0dc513854d68-20211016
X-UUID: 16e89e3752c04842827b0dc513854d68-20211016
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1260108814; Sat, 16 Oct 2021 08:58:05 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Sat, 16 Oct 2021 08:58:04 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 16 Oct 2021 08:58:03 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <peter.wang@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <chaotian.jing@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <gray.jia@mediatek.com>, <stanley.chu@mediatek.com>
Subject: [PATCH v2 3/3] scsi: ufs-mediatek: Fix wrong place of ref-clk delay
Date:   Sat, 16 Oct 2021 08:58:02 +0800
Message-ID: <20211016005802.7729-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211016005802.7729-1-stanley.chu@mediatek.com>
References: <20211016005802.7729-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Fix the location of delay for ref-clk gating and ungating in
ufs_mtk_setup_ref_clk().

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index bc193ba46b31..d0a8e1319ab3 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -247,9 +247,9 @@ static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
 
 	if (on) {
 		ufs_mtk_ref_clk_notify(on, res);
-		ufshcd_delay_us(host->ref_clk_ungating_wait_us, 10);
 		ufshcd_writel(hba, REFCLK_REQUEST, REG_UFS_REFCLK_CTRL);
 	} else {
+		ufshcd_delay_us(host->ref_clk_gating_wait_us, 10);
 		ufshcd_writel(hba, REFCLK_RELEASE, REG_UFS_REFCLK_CTRL);
 	}
 
@@ -274,10 +274,10 @@ static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
 
 out:
 	host->ref_clk_enabled = on;
-	if (!on) {
-		ufshcd_delay_us(host->ref_clk_gating_wait_us, 10);
+	if (on)
+		ufshcd_delay_us(host->ref_clk_ungating_wait_us, 10);
+	else
 		ufs_mtk_ref_clk_notify(on, res);
-	}
 
 	return 0;
 }
-- 
2.18.0

