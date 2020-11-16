Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1ACC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90DB122240
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgKPGvD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:03 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59517 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbgKPGvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:03 -0500
X-UUID: 678c4dd23da34c25a9763b26d65baf67-20201116
X-UUID: 678c4dd23da34c25a9763b26d65baf67-20201116
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1266693890; Mon, 16 Nov 2020 14:50:57 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
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
Subject: [PATCH v1 7/9] scsi: ufs: Refactor ADAPT configuration function
Date:   Mon, 16 Nov 2020 14:50:52 +0800
Message-ID: <20201116065054.7658-8-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5926274FF60AC1D2252A78452B893F06980F61EAFD7235CF175F1E25C3F32A5E2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several vendors are using same code to configure ADAPT
settings for HS-G4. Simply refactor it as common function.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9186ee01379a..80cbce414678 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3587,6 +3587,22 @@ static int ufshcd_dme_reset(struct ufs_hba *hba)
 	return ret;
 }
 
+int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
+			       int agreed_gear,
+			       int adapt_val)
+{
+	int ret;
+
+	if (agreed_gear != UFS_HS_G4)
+		adapt_val = PA_INITIAL_ADAPT;
+
+	ret = ufshcd_dme_set(hba,
+			     UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+			     adapt_val);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_configure_adapt);
+
 /**
  * ufshcd_dme_enable - UIC command for DME_ENABLE
  * @hba: per adapter instance
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5191d87f6263..d0b68df07eef 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -956,6 +956,9 @@ extern int ufshcd_runtime_idle(struct ufs_hba *hba);
 extern int ufshcd_system_suspend(struct ufs_hba *hba);
 extern int ufshcd_system_resume(struct ufs_hba *hba);
 extern int ufshcd_shutdown(struct ufs_hba *hba);
+extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
+				      int agreed_gear,
+				      int adapt_val);
 extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
-- 
2.18.0

