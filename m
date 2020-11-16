Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E7BC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0D52223D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKPGvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:04 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59498 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727131AbgKPGvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:03 -0500
X-UUID: 6d9d181cb4284567996945bd053bff36-20201116
X-UUID: 6d9d181cb4284567996945bd053bff36-20201116
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 459751561; Mon, 16 Nov 2020 14:50:57 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
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
Subject: [PATCH v1 3/9] scsi: ufs-mediatek: Use device parameter initialization function
Date:   Mon, 16 Nov 2020 14:50:48 +0800
Message-ID: <20201116065054.7658-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 8A036E5F5A4507C6D2CA8D84E1B0A0CC0EB40EE0ADAB9ECF05EFF866AB29A3CD2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common device parameter initialization function instead of
initialziing those parameters by vendor driver itself.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 16 +++-------------
 drivers/scsi/ufs/ufs-mediatek.h | 16 ----------------
 2 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index b9b423752ee1..87b4bf125e23 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -680,19 +680,9 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	u32 adapt_val;
 	int ret;
 
-	host_cap.tx_lanes = UFS_MTK_LIMIT_NUM_LANES_TX;
-	host_cap.rx_lanes = UFS_MTK_LIMIT_NUM_LANES_RX;
-	host_cap.hs_rx_gear = UFS_MTK_LIMIT_HSGEAR_RX;
-	host_cap.hs_tx_gear = UFS_MTK_LIMIT_HSGEAR_TX;
-	host_cap.pwm_rx_gear = UFS_MTK_LIMIT_PWMGEAR_RX;
-	host_cap.pwm_tx_gear = UFS_MTK_LIMIT_PWMGEAR_TX;
-	host_cap.rx_pwr_pwm = UFS_MTK_LIMIT_RX_PWR_PWM;
-	host_cap.tx_pwr_pwm = UFS_MTK_LIMIT_TX_PWR_PWM;
-	host_cap.rx_pwr_hs = UFS_MTK_LIMIT_RX_PWR_HS;
-	host_cap.tx_pwr_hs = UFS_MTK_LIMIT_TX_PWR_HS;
-	host_cap.hs_rate = UFS_MTK_LIMIT_HS_RATE;
-	host_cap.desired_working_mode =
-				UFS_MTK_LIMIT_DESIRED_MODE;
+	ufshcd_init_pwr_dev_param(&host_cap);
+	host_cap.hs_rx_gear = UFS_HS_G4;
+	host_cap.hs_tx_gear = UFS_HS_G4;
 
 	ret = ufshcd_get_pwr_dev_param(&host_cap,
 				       dev_max_params,
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
index ac37b11803fb..93d35097dfb0 100644
--- a/drivers/scsi/ufs/ufs-mediatek.h
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -30,22 +30,6 @@
 
 #define REFCLK_REQ_TIMEOUT_US       3000
 
-/*
- * Vendor specific pre-defined parameters
- */
-#define UFS_MTK_LIMIT_NUM_LANES_RX  2
-#define UFS_MTK_LIMIT_NUM_LANES_TX  2
-#define UFS_MTK_LIMIT_HSGEAR_RX     UFS_HS_G4
-#define UFS_MTK_LIMIT_HSGEAR_TX     UFS_HS_G4
-#define UFS_MTK_LIMIT_PWMGEAR_RX    UFS_PWM_G4
-#define UFS_MTK_LIMIT_PWMGEAR_TX    UFS_PWM_G4
-#define UFS_MTK_LIMIT_RX_PWR_PWM    SLOW_MODE
-#define UFS_MTK_LIMIT_TX_PWR_PWM    SLOW_MODE
-#define UFS_MTK_LIMIT_RX_PWR_HS     FAST_MODE
-#define UFS_MTK_LIMIT_TX_PWR_HS     FAST_MODE
-#define UFS_MTK_LIMIT_HS_RATE       PA_HS_MODE_B
-#define UFS_MTK_LIMIT_DESIRED_MODE  UFS_HS_MODE
-
 /*
  * Other attributes
  */
-- 
2.18.0

