Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9679C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jul 2022 06:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiGUGvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jul 2022 02:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiGUGvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2022 02:51:12 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6DE43E76
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 23:51:10 -0700 (PDT)
X-UUID: 8420d73761804b119e61d997d7afc6bd-20220721
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:5fc1017e-b616-4747-bf0f-f62c1780c6b2,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:100
X-CID-INFO: VERSION:1.1.8,REQID:5fc1017e-b616-4747-bf0f-f62c1780c6b2,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,ACT
        ION:quarantine,TS:100
X-CID-META: VersionHash:0f94e32,CLOUDID:4d38e064-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:29906bd59336,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 8420d73761804b119e61d997d7afc6bd-20220721
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1821424200; Thu, 21 Jul 2022 14:51:04 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 21 Jul 2022 14:51:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 21 Jul 2022 14:51:02 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Subject: [PATCH v2] scsi: ufs: correct ufshcd_shutdown flow
Date:   Thu, 21 Jul 2022 14:51:01 +0800
Message-ID: <20220721065101.26789-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Both ufshcd_shtdown and ufshcd_wl_shutdown could run concurrently.
And it have race condition when ufshcd_wl_shutdown on-going and
clock/power turn off by ufshcd_shutdown.

The normal case:
ufshcd_wl_shutdown -> ufshcd_shtdown
ufshcd_shtdown should turn off clock/power.

The abnormal case:
ufshcd_shtdown -> ufshcd_wl_shutdown
Wait ufshcd_wl_shutdown set device to power off and turn off clock/power.
If timeout happen, means device still in active mode, cannot turn off
clock/power directly. Skip and keep clock/power on in this case.

Also remove pm_runtime_get_sync because shutdown is focus on
turn off clock/power. We don't need turn on(resume) and turn off.
The second reason is ufshcd_wl_shutdown call ufshcd_rpm_get_sync
already, if ufshcd_shtdown wait ufshcd_wl_shutdown finish,
hba->dev is already resume and no need pm_runtime_get_sync.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..533563a2a6b7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -58,6 +58,9 @@
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
 
+/* Shutdown wait devcie into power off timeout */
+#define UFS_SHUTDWON_TIMEOUT	500 /* msecs */
+
 /* maximum number of retries for a general UIC command  */
 #define UFS_UIC_COMMAND_RETRIES 3
 
@@ -9461,10 +9464,15 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
  */
 int ufshcd_shutdown(struct ufs_hba *hba)
 {
-	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
-		goto out;
+	unsigned long timeout;
 
-	pm_runtime_get_sync(hba->dev);
+	/* Wait ufshcd_wl_shutdown clear ufs state */
+	timeout = jiffies + msecs_to_jiffies(UFS_SHUTDWON_TIMEOUT);
+	while (!ufshcd_is_ufs_dev_poweroff(hba) || !ufshcd_is_link_off(hba)) {
+		if (time_after(jiffies, timeout))
+			goto out;
+		msleep(1);
+	}
 
 	ufshcd_suspend(hba);
 out:
-- 
2.18.0

