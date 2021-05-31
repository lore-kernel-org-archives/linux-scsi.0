Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92792C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B2261364
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhEaG23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 02:28:29 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:49289 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230091AbhEaG21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 02:28:27 -0400
X-UUID: 6e1e37576ef843e4b5e839fcc83a384a-20210531
X-UUID: 6e1e37576ef843e4b5e839fcc83a384a-20210531
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1346088537; Mon, 31 May 2021 14:26:44 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 31 May 2021 14:26:42 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 14:26:42 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2] scsi: ufs-mediatek: Fix HCI version in some platforms
Date:   Mon, 31 May 2021 14:26:42 +0800
Message-ID: <20210531062642.12642-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some MediaTek SoC platforms with UFSHCI version below 3.0 have
incorrect UFSHCI versions showed in register map.

Fix the version by referring to UniPro version which is
always correct.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 9912e208c2a1..a0abf9cb2398 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -603,11 +603,23 @@ static void ufs_mtk_get_controller_version(struct ufs_hba *hba)
 
 	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_LOCALVERINFO), &ver);
 	if (!ret) {
-		if (ver >= UFS_UNIPRO_VER_1_8)
+		if (ver >= UFS_UNIPRO_VER_1_8) {
 			host->hw_ver.major = 3;
+			/*
+			 * Fix HCI version for some platforms with
+			 * incorrect version
+			 */
+			if (hba->ufs_version < ufshci_version(3, 0))
+				hba->ufs_version = ufshci_version(3, 0);
+		}
 	}
 }
 
+static u32 ufs_mtk_get_ufs_hci_version(struct ufs_hba *hba)
+{
+	return hba->ufs_version;
+}
+
 /**
  * ufs_mtk_init - find other essential mmio bases
  * @hba: host controller instance
@@ -1042,6 +1054,7 @@ static void ufs_mtk_event_notify(struct ufs_hba *hba,
 static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.name                = "mediatek.ufshci",
 	.init                = ufs_mtk_init,
+	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
 	.setup_clocks        = ufs_mtk_setup_clocks,
 	.hce_enable_notify   = ufs_mtk_hce_enable_notify,
 	.link_startup_notify = ufs_mtk_link_startup_notify,
-- 
2.18.0

