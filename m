Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B90C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 12:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C186C61287
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 12:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhEaM1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 08:27:07 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:49269 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231473AbhEaM1G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 08:27:06 -0400
X-UUID: c96c30712ec942a09ac76c275402cdcb-20210531
X-UUID: c96c30712ec942a09ac76c275402cdcb-20210531
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2075513405; Mon, 31 May 2021 20:25:24 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 31 May 2021 20:25:23 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 20:25:23 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>
Subject: [PATCH v1] scsi: ufs-mediatek: create device link of reset control
Date:   Mon, 31 May 2021 20:25:19 +0800
Message-ID: <1622463919-18413-1-git-send-email-peter.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Mediatek ufs reset control use reset-ti-syscon module.
So ufs probe should wait reset-ti-syscon module init first.
Else medaitek ufs get reset control fail.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/Kconfig        |    1 +
 drivers/scsi/ufs/ufs-mediatek.c |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 07cf415..2d13795 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -115,6 +115,7 @@ config SCSI_UFS_MEDIATEK
 	tristate "Mediatek specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
 	select PHY_MTK_UFS
+	select RESET_TI_SYSCON
 	help
 	  This selects the Mediatek specific additions to UFSHCD platform driver.
 	  UFS host on Mediatek needs some vendor specific configuration before
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index a981f26..73e8caf 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -1067,9 +1067,40 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 {
 	int err;
 	struct device *dev = &pdev->dev;
+	struct device_node *reset_node;
+	struct platform_device *reset_pdev;
+	struct device_link *link;
+
+	reset_node = of_find_compatible_node(NULL, NULL,
+					     "ti,syscon-reset");
+	if (!reset_node) {
+		dev_notice(dev, "find ti,syscon-reset fail\n");
+		err = -ENODEV;
+		goto out;
+	}
+	reset_pdev = of_find_device_by_node(reset_node);
+	if (!reset_pdev) {
+		dev_notice(dev, "find reset_pdev fail\n");
+		err = -ENODEV;
+		goto out;
+	}
+	link = device_link_add(dev, &reset_pdev->dev,
+		DL_FLAG_AUTOPROBE_CONSUMER);
+	if (!link) {
+		dev_notice(dev, "add reset device_link fail\n");
+		err = -ENODEV;
+		goto out;
+	}
+	/* supplier is not probed */
+	if (link->status == DL_STATE_DORMANT) {
+		err = -EPROBE_DEFER;
+		goto out;
+	}
 
 	/* perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
+
+out:
 	if (err)
 		dev_info(dev, "probe failed %d\n", err);
 
-- 
1.7.9.5

