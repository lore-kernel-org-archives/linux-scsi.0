Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0948C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DBF622240
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgKPGvT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:19 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59517 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727228AbgKPGvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:04 -0500
X-UUID: a4cd92fc30f746358018a7f03dd0d624-20201116
X-UUID: a4cd92fc30f746358018a7f03dd0d624-20201116
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2073750733; Mon, 16 Nov 2020 14:50:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
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
Subject: [PATCH v1 2/9] scsi: ufs: Introduce device parameter initialization function
Date:   Mon, 16 Nov 2020 14:50:47 +0800
Message-ID: <20201116065054.7658-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nowadays many vendors initialize their device parameters in
their own vendor drivers. The initialization code is almost
the same as well as the pre-defined definitions. Introduce
a common device parameter initialization function which assign
the most common initial values. With this function, we
could remove those duplicated codes in vendor drivers.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 17 +++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 3db0af66c71c..a6f76399b3ae 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -354,6 +354,23 @@ int ufshcd_get_pwr_dev_param(struct ufs_dev_params *pltfrm_param,
 }
 EXPORT_SYMBOL_GPL(ufshcd_get_pwr_dev_param);
 
+void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param)
+{
+	dev_param->tx_lanes = 2;
+	dev_param->rx_lanes = 2;
+	dev_param->hs_rx_gear = UFS_HS_G3;
+	dev_param->hs_tx_gear = UFS_HS_G3;
+	dev_param->pwm_rx_gear = UFS_PWM_G4;
+	dev_param->pwm_tx_gear = UFS_PWM_G4;
+	dev_param->rx_pwr_pwm = SLOW_MODE;
+	dev_param->tx_pwr_pwm = SLOW_MODE;
+	dev_param->rx_pwr_hs = FAST_MODE;
+	dev_param->tx_pwr_hs = FAST_MODE;
+	dev_param->hs_rate = PA_HS_MODE_B;
+	dev_param->desired_working_mode = UFS_HS_MODE;
+}
+EXPORT_SYMBOL_GPL(ufshcd_init_pwr_dev_param);
+
 /**
  * ufshcd_pltfrm_init - probe routine of the driver
  * @pdev: pointer to Platform device handle
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/scsi/ufs/ufshcd-pltfrm.h
index b79cdf9129a0..772a8e848098 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.h
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.h
@@ -28,6 +28,7 @@ struct ufs_dev_params {
 int ufshcd_get_pwr_dev_param(struct ufs_dev_params *dev_param,
 			     struct ufs_pa_layer_attr *dev_max,
 			     struct ufs_pa_layer_attr *agreed_pwr);
+void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
 		       const struct ufs_hba_variant_ops *vops);
 void ufshcd_pltfrm_shutdown(struct platform_device *pdev);
-- 
2.18.0

