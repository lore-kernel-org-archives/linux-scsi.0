Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C809C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 09:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37B5F22838
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 09:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387901AbgLDJvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 04:51:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34621 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387867AbgLDJvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 04:51:12 -0500
X-UUID: 4069ad15717f4d08b707dfe057e7c545-20201204
X-UUID: 4069ad15717f4d08b707dfe057e7c545-20201204
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1227462729; Fri, 04 Dec 2020 17:50:30 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Dec 2020 17:50:07 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Dec 2020 17:50:05 +0800
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
        <alice.chao@mediatek.com>, <huadian.liu@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 1/8] scsi: ufs: Remove unused setup_regulators variant function
Date:   Fri, 4 Dec 2020 17:50:00 +0800
Message-ID: <20201204095007.20639-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201204095007.20639-1-stanley.chu@mediatek.com>
References: <20201204095007.20639-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1E162314F9333B50FE3B453AD71A9AA1DE08E1FE37874C1120432C082AE5FB9C2000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since setup_regulators variant function is not used by any
vendors, simply remove it.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 10 +---------
 drivers/scsi/ufs/ufshcd.h | 10 ----------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 11a4aad09f3a..c2f611516ea7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8171,16 +8171,10 @@ static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 		goto out;
 
 	err = ufshcd_vops_init(hba);
-	if (err)
-		goto out;
-
-	err = ufshcd_vops_setup_regulators(hba, true);
-	if (err)
-		ufshcd_vops_exit(hba);
-out:
 	if (err)
 		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
 			__func__, ufshcd_get_var_name(hba), err);
+out:
 	return err;
 }
 
@@ -8189,8 +8183,6 @@ static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
 	if (!hba->vops)
 		return;
 
-	ufshcd_vops_setup_regulators(hba, false);
-
 	ufshcd_vops_exit(hba);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7a7e056a33a9..21de7607611f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -277,7 +277,6 @@ struct ufs_pwr_mode_info {
  * @get_ufs_hci_version: called to get UFS HCI version
  * @clk_scale_notify: notifies that clks are scaled up/down
  * @setup_clocks: called before touching any of the controller registers
- * @setup_regulators: called before accessing the host controller
  * @hce_enable_notify: called before and after HCE enable bit is set to allow
  *                     variant specific Uni-Pro initialization.
  * @link_startup_notify: called before and after Link startup is carried out
@@ -307,7 +306,6 @@ struct ufs_hba_variant_ops {
 				    enum ufs_notify_change_status);
 	int	(*setup_clocks)(struct ufs_hba *, bool,
 				enum ufs_notify_change_status);
-	int     (*setup_regulators)(struct ufs_hba *, bool);
 	int	(*hce_enable_notify)(struct ufs_hba *,
 				     enum ufs_notify_change_status);
 	int	(*link_startup_notify)(struct ufs_hba *,
@@ -1119,14 +1117,6 @@ static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on,
 	return 0;
 }
 
-static inline int ufshcd_vops_setup_regulators(struct ufs_hba *hba, bool status)
-{
-	if (hba->vops && hba->vops->setup_regulators)
-		return hba->vops->setup_regulators(hba, status);
-
-	return 0;
-}
-
 static inline int ufshcd_vops_hce_enable_notify(struct ufs_hba *hba,
 						bool status)
 {
-- 
2.18.0

