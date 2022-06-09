Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B3DC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 08:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbiFII7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 04:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243095AbiFII62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 04:58:28 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A1323BDC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 01:57:58 -0700 (PDT)
X-UUID: 5ac282a784e6422191a848d8b73fd13d-20220609
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:971f939e-86c1-44d3-8a6c-ae5123f217e2,OB:0,LO
        B:10,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:95
X-CID-INFO: VERSION:1.1.5,REQID:971f939e-86c1-44d3-8a6c-ae5123f217e2,OB:0,LOB:
        10,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:95
X-CID-META: VersionHash:2a19b09,CLOUDID:15063de5-2ba2-4dc1-b6c5-11feb6c769e0,C
        OID:bbf645eb6186,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:0,BEC:nil
X-UUID: 5ac282a784e6422191a848d8b73fd13d-20220609
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 40121880; Thu, 09 Jun 2022 16:57:53 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 9 Jun 2022 16:57:52 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Thu, 9 Jun 2022 16:57:52 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <powen.kao@mediatek.com>,
        <mason.zhang@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <eddie.huang@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/3] scsi: ufs: Export ufshcd_uic_change_pwr_mode()
Date:   Thu, 9 Jun 2022 16:57:49 +0800
Message-ID: <20220609085751.25305-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220609085751.25305-1-stanley.chu@mediatek.com>
References: <20220609085751.25305-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export ufshcd_uic_change_pwr_mode() to allow vendors to
use it for SoC-specific power mode change design limitation.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 include/ufs/ufshcd.h      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 936a6d5467c9..19e17c898319 100755
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4091,7 +4091,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
+int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
@@ -4116,6 +4116,7 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_uic_change_pwr_mode);
 
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718..aa778418703f 100755
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1087,6 +1087,7 @@ extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 			struct ufs_pa_layer_attr *desired_pwr_mode);
+extern int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
2.18.0

