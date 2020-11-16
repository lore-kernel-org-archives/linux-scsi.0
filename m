Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A70C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B80DC2223D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgKPGvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:07 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56429 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727248AbgKPGvG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:06 -0500
X-UUID: 17fb1c7661d740e59a8e28bfec8058c8-20201116
X-UUID: 17fb1c7661d740e59a8e28bfec8058c8-20201116
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1338968127; Mon, 16 Nov 2020 14:50:57 +0800
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
Subject: [PATCH v1 5/9] scsi: ufs-exynos: Use device parameter initialization function
Date:   Mon, 16 Nov 2020 14:50:50 +0800
Message-ID: <20201116065054.7658-6-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F7C328403594EF3E73E48010B0EA8562DABC4C1AE26A152F8097040FB84C7D3E2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common device parameter initialization function instead of
initialziing those parameters by vendor driver itself.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 15 +--------------
 drivers/scsi/ufs/ufs-exynos.h | 13 -------------
 2 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 5e6b95dbb578..a8770ff14588 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -617,20 +617,7 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 		goto out;
 	}
 
-
-	ufs_exynos_cap.tx_lanes = UFS_EXYNOS_LIMIT_NUM_LANES_TX;
-	ufs_exynos_cap.rx_lanes = UFS_EXYNOS_LIMIT_NUM_LANES_RX;
-	ufs_exynos_cap.hs_rx_gear = UFS_EXYNOS_LIMIT_HSGEAR_RX;
-	ufs_exynos_cap.hs_tx_gear = UFS_EXYNOS_LIMIT_HSGEAR_TX;
-	ufs_exynos_cap.pwm_rx_gear = UFS_EXYNOS_LIMIT_PWMGEAR_RX;
-	ufs_exynos_cap.pwm_tx_gear = UFS_EXYNOS_LIMIT_PWMGEAR_TX;
-	ufs_exynos_cap.rx_pwr_pwm = UFS_EXYNOS_LIMIT_RX_PWR_PWM;
-	ufs_exynos_cap.tx_pwr_pwm = UFS_EXYNOS_LIMIT_TX_PWR_PWM;
-	ufs_exynos_cap.rx_pwr_hs = UFS_EXYNOS_LIMIT_RX_PWR_HS;
-	ufs_exynos_cap.tx_pwr_hs = UFS_EXYNOS_LIMIT_TX_PWR_HS;
-	ufs_exynos_cap.hs_rate = UFS_EXYNOS_LIMIT_HS_RATE;
-	ufs_exynos_cap.desired_working_mode =
-				UFS_EXYNOS_LIMIT_DESIRED_MODE;
+	ufshcd_init_pwr_dev_param(&ufs_exynos_cap);
 
 	ret = ufshcd_get_pwr_dev_param(&ufs_exynos_cap,
 				       dev_max_params, dev_req_params);
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 76d6e39efb2f..06ee565f7eb0 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -90,19 +90,6 @@ struct exynos_ufs;
 #define SLOW 1
 #define FAST 2
 
-#define UFS_EXYNOS_LIMIT_NUM_LANES_RX	2
-#define UFS_EXYNOS_LIMIT_NUM_LANES_TX	2
-#define UFS_EXYNOS_LIMIT_HSGEAR_RX	UFS_HS_G3
-#define UFS_EXYNOS_LIMIT_HSGEAR_TX	UFS_HS_G3
-#define UFS_EXYNOS_LIMIT_PWMGEAR_RX	UFS_PWM_G4
-#define UFS_EXYNOS_LIMIT_PWMGEAR_TX	UFS_PWM_G4
-#define UFS_EXYNOS_LIMIT_RX_PWR_PWM	SLOW_MODE
-#define UFS_EXYNOS_LIMIT_TX_PWR_PWM	SLOW_MODE
-#define UFS_EXYNOS_LIMIT_RX_PWR_HS	FAST_MODE
-#define UFS_EXYNOS_LIMIT_TX_PWR_HS	FAST_MODE
-#define UFS_EXYNOS_LIMIT_HS_RATE		PA_HS_MODE_B
-#define UFS_EXYNOS_LIMIT_DESIRED_MODE	FAST
-
 #define RX_ADV_FINE_GRAN_SUP_EN	0x1
 #define RX_ADV_FINE_GRAN_STEP_VAL	0x3
 #define RX_ADV_MIN_ACTV_TIME_CAP	0x9
-- 
2.18.0

