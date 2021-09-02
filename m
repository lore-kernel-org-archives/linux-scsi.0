Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B18C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 07:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B9F60F91
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 07:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243248AbhIBHSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 03:18:12 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:39396 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S243287AbhIBHSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 03:18:11 -0400
X-UUID: 8acbddd53aaf4b27851c9330567d61f9-20210902
X-UUID: 8acbddd53aaf4b27851c9330567d61f9-20210902
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 930483638; Thu, 02 Sep 2021 15:17:09 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Sep 2021 15:17:08 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Sep 2021 15:17:07 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
Subject: [PATCH v4] scsi: ufs: ufs-mediatek: Change dbg select by check IP version
Date:   Thu, 2 Sep 2021 15:17:06 +0800
Message-ID: <1630567026-21661-1-git-send-email-peter.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Mediatek UFS dbg select setting is changed in new IP version.
This patch check the IP version before set dbg select.
Only set once after host reset.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c |   28 ++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufs-mediatek.h |    7 +++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index d2c2516..51c2c52 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -138,6 +138,8 @@ static void ufs_mtk_host_reset(struct ufs_hba *hba)
 	reset_control_deassert(host->unipro_reset);
 	reset_control_deassert(host->crypto_reset);
 	reset_control_deassert(host->hci_reset);
+
+	host->host_reset = true;
 }
 
 static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
@@ -296,6 +298,26 @@ static void ufs_mtk_setup_ref_clk_wait_us(struct ufs_hba *hba,
 	host->ref_clk_ungating_wait_us = ungating_us;
 }
 
+static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	if (!host->host_reset)
+		return;
+
+	if (((host->ip_ver >> 16) & 0xFF) >= 0x36) {
+		ufshcd_writel(hba, 0x820820, REG_UFS_DEBUG_SEL);
+		ufshcd_writel(hba, 0x0, REG_UFS_DEBUG_SEL_B0);
+		ufshcd_writel(hba, 0x55555555, REG_UFS_DEBUG_SEL_B1);
+		ufshcd_writel(hba, 0xaaaaaaaa, REG_UFS_DEBUG_SEL_B2);
+		ufshcd_writel(hba, 0xffffffff, REG_UFS_DEBUG_SEL_B3);
+	} else {
+		ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
+	}
+
+	host->host_reset = false;
+}
+
 static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 				   unsigned long max_wait_ms)
 {
@@ -305,7 +327,7 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 	timeout = ktime_add_ms(ktime_get(), max_wait_ms);
 	do {
 		time_checked = ktime_get();
-		ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
+		ufs_mtk_dbg_sel(hba);
 		val = ufshcd_readl(hba, REG_UFS_PROBE);
 		val = val >> 28;
 
@@ -689,6 +711,8 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	ufs_mtk_mphy_power_on(hba, true);
 	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
 
+	host->ip_ver = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
+
 	goto out;
 
 out_variant_clear:
@@ -1001,7 +1025,7 @@ static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
 			 "MPHY Ctrl ");
 
 	/* Direct debugging information to REG_MTK_PROBE */
-	ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
+	ufs_mtk_dbg_sel(hba);
 	ufshcd_dump_regs(hba, REG_UFS_PROBE, 0x4, "Debug Probe ");
 }
 
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
index 3f0d3bb..f482cbe 100644
--- a/drivers/scsi/ufs/ufs-mediatek.h
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -15,9 +15,14 @@
 #define REG_UFS_REFCLK_CTRL         0x144
 #define REG_UFS_EXTREG              0x2100
 #define REG_UFS_MPHYCTRL            0x2200
+#define REG_UFS_MTK_IP_VER          0x2240
 #define REG_UFS_REJECT_MON          0x22AC
 #define REG_UFS_DEBUG_SEL           0x22C0
 #define REG_UFS_PROBE               0x22C8
+#define REG_UFS_DEBUG_SEL_B0        0x22D0
+#define REG_UFS_DEBUG_SEL_B1        0x22D4
+#define REG_UFS_DEBUG_SEL_B2        0x22D8
+#define REG_UFS_DEBUG_SEL_B3        0x22DC
 
 /*
  * Ref-clk control
@@ -113,6 +118,8 @@ struct ufs_mtk_host {
 	bool ref_clk_enabled;
 	u16 ref_clk_ungating_wait_us;
 	u16 ref_clk_gating_wait_us;
+	u32 ip_ver;
+	bool host_reset;
 };
 
 #endif /* !_UFS_MEDIATEK_H */
-- 
1.7.9.5

