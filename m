Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B839AC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 13:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354775AbiELN5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 09:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354779AbiELN5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 09:57:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304271C345C
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 06:57:01 -0700 (PDT)
X-UUID: 162a9dc646ba46e285457a6e4d43ea3e-20220512
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:ea0fc23a-65f7-4ab5-ae9a-3f6de342ee11,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-20,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:-15
X-CID-META: VersionHash:faefae9,CLOUDID:959c13a7-eab7-4b74-a74d-5359964535a9,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,File:nil,QS:0,BEC:nil
X-UUID: 162a9dc646ba46e285457a6e4d43ea3e-20220512
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1861353464; Thu, 12 May 2022 21:56:58 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 12 May 2022 21:56:57 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 12 May 2022 21:56:57 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <eddie.huang@mediatek.com>,
        <tun-yu.yu@mediatek.com>
Subject: [PATCH v1] scsi: ufs-mediatek: introduce new UFS4.0 HS-G5 mode
Date:   Thu, 12 May 2022 21:56:54 +0800
Message-ID: <20220512135654.3656-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Per UFS4.0 spec, HS-G5 is a new speed mode.
This patch introduce HS-G5 speed mode to mediatek.
Also add a host cap for power mode change via fastauto.

Co-Developed-by: CC Chou <cc.chou@mediatek.com>
Signed-off-by: CC Chou <cc.chou@mediatek.com>
Co-Developed-by: Eddie Huang <eddie.huang@mediatek.com>
Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
Co-Developed-by: Dennis Yu <tun-yu.yu@mediatek.com>
Signed-off-by: Dennis Yu <tun-yu.yu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 60 +++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufs-mediatek.h |  1 +
 drivers/scsi/ufs/ufshcd.c       |  3 +-
 drivers/scsi/ufs/ufshcd.h       |  1 +
 drivers/scsi/ufs/unipro.h       |  4 ++-
 5 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 86a938075f30..8f2a3b03d244 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -78,6 +78,13 @@ static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
 	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
 }
 
+static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
+}
+
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
 {
 	u32 tmp;
@@ -580,6 +587,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-broken-vcc"))
 		host->caps |= UFS_MTK_CAP_BROKEN_VCC;
 
+	if (of_property_read_bool(np, "mediatek,ufs-pmc-via-fastauto"))
+		host->caps |= UFS_MTK_CAP_PMC_VIA_FASTAUTO;
+
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -755,6 +765,26 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	return err;
 }
 
+static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
+	struct ufs_pa_layer_attr *dev_req_params)
+{
+	if (!ufs_mtk_is_pmc_via_fastauto(hba))
+		return false;
+
+	if (dev_req_params->hs_rate == hba->pwr_info.hs_rate)
+		return false;
+
+	if ((dev_req_params->pwr_tx != FAST_MODE) &&
+		(dev_req_params->gear_tx < UFS_HS_G4))
+		return false;
+
+	if ((dev_req_params->pwr_rx != FAST_MODE) &&
+		(dev_req_params->gear_rx < UFS_HS_G4))
+		return false;
+
+	return true;
+}
+
 static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 				  struct ufs_pa_layer_attr *dev_max_params,
 				  struct ufs_pa_layer_attr *dev_req_params)
@@ -764,8 +794,8 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	int ret;
 
 	ufshcd_init_pwr_dev_param(&host_cap);
-	host_cap.hs_rx_gear = UFS_HS_G4;
-	host_cap.hs_tx_gear = UFS_HS_G4;
+	host_cap.hs_rx_gear = UFS_HS_G5;
+	host_cap.hs_tx_gear = UFS_HS_G5;
 
 	ret = ufshcd_get_pwr_dev_param(&host_cap,
 				       dev_max_params,
@@ -775,6 +805,32 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 			__func__);
 	}
 
+	if (ufs_mtk_pmc_via_fastauto(hba, dev_req_params)) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), UFS_HS_G1);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), UFS_HS_G1);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
+						dev_req_params->lane_tx);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES),
+						dev_req_params->lane_rx);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
+						dev_req_params->hs_rate);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+		     PA_NO_ADAPT);
+
+		ret = ufshcd_uic_change_pwr_mode(hba,
+			FASTAUTO_MODE << 4 | FASTAUTO_MODE);
+
+		if (ret) {
+			dev_err(hba->dev, "%s: HSG1B FASTAUTO failed ret=%d\n",
+				__func__, ret);
+		}
+	}
+
 	if (host->hw_ver.major >= 3) {
 		ret = ufshcd_dme_configure_adapt(hba,
 					   dev_req_params->gear_tx,
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
index 414dca86c09f..3a31f03f3cb1 100644
--- a/drivers/scsi/ufs/ufs-mediatek.h
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -108,6 +108,7 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_VA09_PWR_CTRL              = 1 << 1,
 	UFS_MTK_CAP_DISABLE_AH8                = 1 << 2,
 	UFS_MTK_CAP_BROKEN_VCC                 = 1 << 3,
+	UFS_MTK_CAP_PMC_VIA_FASTAUTO           = 1 << 4,
 };
 
 struct ufs_mtk_crypt_cfg {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..e750011d0de7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4076,7 +4076,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
+int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
@@ -4101,6 +4101,7 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_uic_change_pwr_mode);
 
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 94f545be183a..1cda0f211d72 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1101,6 +1101,7 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 			struct ufs_pa_layer_attr *desired_pwr_mode);
 
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 8e9e486a4f7b..94d97f123e3a 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -231,6 +231,7 @@ enum ufs_hs_gear_tag {
 	UFS_HS_G2,		/* HS Gear 2 */
 	UFS_HS_G3,		/* HS Gear 3 */
 	UFS_HS_G4,		/* HS Gear 4 */
+	UFS_HS_G5,		/* HS Gear 5 */
 };
 
 enum ufs_unipro_ver {
@@ -240,7 +241,8 @@ enum ufs_unipro_ver {
 	UFS_UNIPRO_VER_1_6  = 3, /* UniPro version 1.6 */
 	UFS_UNIPRO_VER_1_61 = 4, /* UniPro version 1.61 */
 	UFS_UNIPRO_VER_1_8  = 5, /* UniPro version 1.8 */
-	UFS_UNIPRO_VER_MAX  = 6, /* UniPro unsupported version */
+	UFS_UNIPRO_VER_2_0  = 6, /* UniPro version 2.0 */
+	UFS_UNIPRO_VER_MAX  = 7, /* UniPro unsupported version */
 	/* UniPro version field mask in PA_LOCALVERINFO */
 	UFS_UNIPRO_VER_MASK = 0xF,
 };
-- 
2.18.0

