Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798DFC63777
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 09:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3861A207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 09:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgK3JRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 04:17:03 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:54887 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726032AbgK3JRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 04:17:03 -0500
X-UUID: 911facf2d65d4e0ca5166da42b989b84-20201130
X-UUID: 911facf2d65d4e0ca5166da42b989b84-20201130
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 510319689; Mon, 30 Nov 2020 17:16:18 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 30 Nov 2020 17:16:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 Nov 2020 17:16:10 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <nguyenb@codeaurora.org>,
        <bjorn.andersson@linaro.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC voltage values
Date:   Mon, 30 Nov 2020 17:16:10 +0800
Message-ID: <20201130091610.2752-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS specficication allows different VCC configurations for UFS devices,
for example,
	(1). 2.70V - 3.60V (By default)
	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
                          device tree)
	(3). 2.40V - 2.70V (Supported since UFS 3.x)

With the introduction of UFS 3.x products, an issue is happening that
UFS driver will use wrong "min_uV/max_uV" configuration to toggle VCC
regulator on UFU 3.x products with VCC configuration (3) used.

To solve this issue, we simply remove pre-defined initial VCC voltage
values in UFS driver with below reasons,

1. UFS specifications do not define how to detect the VCC configuration
   supported by attached device.

2. Device tree already supports standard regulator properties.

Therefore VCC voltage shall be defined correctly in device tree, and
shall not be changed by UFS driver. What UFS driver needs to do is simply
enabling or disabling the VCC regulator only.

This is a RFC conceptional patch. Please help review this and feel
free to feedback any ideas. Once this concept is accepted, and then
I would post a more completed patch series to fix this issue.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index a6f76399b3ae..3965be03c136 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -133,15 +133,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		vreg->max_uA = 0;
 	}
 
-	if (!strcmp(name, "vcc")) {
-		if (of_property_read_bool(np, "vcc-supply-1p8")) {
-			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
-			vreg->max_uV = UFS_VREG_VCC_1P8_MAX_UV;
-		} else {
-			vreg->min_uV = UFS_VREG_VCC_MIN_UV;
-			vreg->max_uV = UFS_VREG_VCC_MAX_UV;
-		}
-	} else if (!strcmp(name, "vccq")) {
+	if (!strcmp(name, "vccq")) {
 		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
 		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
 	} else if (!strcmp(name, "vccq2")) {
-- 
2.18.0

