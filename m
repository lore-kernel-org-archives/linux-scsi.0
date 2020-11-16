Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7106C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BB32223D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgKPGvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:07 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56409 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727226AbgKPGvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:07 -0500
X-UUID: a1e7b60b3db84da38432c8b5148f062a-20201116
X-UUID: a1e7b60b3db84da38432c8b5148f062a-20201116
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 270768927; Mon, 16 Nov 2020 14:50:57 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
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
Subject: [PATCH v1 6/9] scsi: ufs-hisi: Use device parameter initialization function
Date:   Mon, 16 Nov 2020 14:50:51 +0800
Message-ID: <20201116065054.7658-7-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use common device parameter initialization function instead of
initialziing those parameters by vendor driver itself.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-hisi.c | 13 +------------
 drivers/scsi/ufs/ufs-hisi.h | 13 -------------
 2 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 074a6a055a4c..0aa58131e791 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -293,18 +293,7 @@ static int ufs_hisi_link_startup_notify(struct ufs_hba *hba,
 
 static void ufs_hisi_set_dev_cap(struct ufs_dev_params *hisi_param)
 {
-	hisi_param->rx_lanes = UFS_HISI_LIMIT_NUM_LANES_RX;
-	hisi_param->tx_lanes = UFS_HISI_LIMIT_NUM_LANES_TX;
-	hisi_param->hs_rx_gear = UFS_HISI_LIMIT_HSGEAR_RX;
-	hisi_param->hs_tx_gear = UFS_HISI_LIMIT_HSGEAR_TX;
-	hisi_param->pwm_rx_gear = UFS_HISI_LIMIT_PWMGEAR_RX;
-	hisi_param->pwm_tx_gear = UFS_HISI_LIMIT_PWMGEAR_TX;
-	hisi_param->rx_pwr_pwm = UFS_HISI_LIMIT_RX_PWR_PWM;
-	hisi_param->tx_pwr_pwm = UFS_HISI_LIMIT_TX_PWR_PWM;
-	hisi_param->rx_pwr_hs = UFS_HISI_LIMIT_RX_PWR_HS;
-	hisi_param->tx_pwr_hs = UFS_HISI_LIMIT_TX_PWR_HS;
-	hisi_param->hs_rate = UFS_HISI_LIMIT_HS_RATE;
-	hisi_param->desired_working_mode = UFS_HISI_LIMIT_DESIRED_MODE;
+	ufshcd_init_pwr_dev_param(hisi_param);
 }
 
 static void ufs_hisi_pwr_change_pre_change(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufs-hisi.h b/drivers/scsi/ufs/ufs-hisi.h
index 3231d3d81c98..5a90c0f4e90c 100644
--- a/drivers/scsi/ufs/ufs-hisi.h
+++ b/drivers/scsi/ufs/ufs-hisi.h
@@ -76,19 +76,6 @@ enum {
 #define SLOW	1
 #define FAST	2
 
-#define UFS_HISI_LIMIT_NUM_LANES_RX	2
-#define UFS_HISI_LIMIT_NUM_LANES_TX	2
-#define UFS_HISI_LIMIT_HSGEAR_RX	UFS_HS_G3
-#define UFS_HISI_LIMIT_HSGEAR_TX	UFS_HS_G3
-#define UFS_HISI_LIMIT_PWMGEAR_RX	UFS_PWM_G4
-#define UFS_HISI_LIMIT_PWMGEAR_TX	UFS_PWM_G4
-#define UFS_HISI_LIMIT_RX_PWR_PWM	SLOW_MODE
-#define UFS_HISI_LIMIT_TX_PWR_PWM	SLOW_MODE
-#define UFS_HISI_LIMIT_RX_PWR_HS	FAST_MODE
-#define UFS_HISI_LIMIT_TX_PWR_HS	FAST_MODE
-#define UFS_HISI_LIMIT_HS_RATE	PA_HS_MODE_B
-#define UFS_HISI_LIMIT_DESIRED_MODE	FAST
-
 #define UFS_HISI_CAP_RESERVED		BIT(0)
 #define UFS_HISI_CAP_PHY10nm		BIT(1)
 
-- 
2.18.0

