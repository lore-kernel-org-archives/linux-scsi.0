Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBBCC64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 09:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4260E20C56
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 09:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388134AbgLBJTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 04:19:14 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:42330 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388132AbgLBJTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 04:19:12 -0500
X-UUID: 4be2a8abb52d42e0ac6dff359f83e27b-20201202
X-UUID: 4be2a8abb52d42e0ac6dff359f83e27b-20201202
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2054784308; Wed, 02 Dec 2020 17:18:28 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Dec 2020 17:18:19 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 17:18:19 +0800
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
Subject: [PATCH v3] scsi: ufs: Remove pre-defined initial voltage values of device powers
Date:   Wed, 2 Dec 2020 17:18:19 +0800
Message-ID: <20201202091819.22363-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS specficication allows different VCC configurations for UFS devices,
for example,
	(1). 2.70V - 3.60V (Activated by default in UFS core driver)
	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
                          device tree)
	(3). 2.40V - 2.70V (Supported since UFS 3.x)

With the introduction of UFS 3.x products, an issue is happening that
UFS driver will use wrong "min_uV-max_uV" values to configure the
voltage of VCC regulator on UFU 3.x products with the configuration (3)
used.

To solve this issue, we simply remove pre-defined initial VCC voltage
values in UFS core driver with below reasons,

1. UFS specifications do not define how to detect the VCC configuration
   supported by attached device.

2. Device tree already supports standard regulator properties.

Therefore VCC voltage shall be defined correctly in device tree, and
shall not changed by UFS driver. What UFS driver needs to do is simply
enable or disable the VCC regulator only.

Similar change is applied to VCCQ and VCCQ2 as well.

Note that we keep struct ufs_vreg unchanged. This allows vendors to
configure proper min_uV and max_uV of any regulators to make
regulator_set_voltage() works during regulator toggling flow in the
future. Without specific vendor configurations, min_uV and max_uV will
be NULL by default and UFS core driver will enable or disable the
regulator only without adjusting its voltage.

Acked-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 0619cfbfbdbb..1a69949a4ea1 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -134,25 +134,6 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		dev_info(dev, "%s: unable to find %s\n", __func__, prop_name);
 		vreg->max_uA = 0;
 	}
-
-	if (!strcmp(name, "vcc")) {
-		if (of_property_read_bool(np, "vcc-supply-1p8")) {
-			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
-			vreg->max_uV = UFS_VREG_VCC_1P8_MAX_UV;
-		} else {
-			vreg->min_uV = UFS_VREG_VCC_MIN_UV;
-			vreg->max_uV = UFS_VREG_VCC_MAX_UV;
-		}
-	} else if (!strcmp(name, "vccq")) {
-		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
-		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
-	} else if (!strcmp(name, "vccq2")) {
-		vreg->min_uV = UFS_VREG_VCCQ2_MIN_UV;
-		vreg->max_uV = UFS_VREG_VCCQ2_MAX_UV;
-	}
-
-	goto out;
-
 out:
 	if (!ret)
 		*out_vreg = vreg;
-- 
2.18.0

