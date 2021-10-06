Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE0AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 03:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D586120D
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 03:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhJFDL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 23:11:57 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:41708 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237168AbhJFDL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 23:11:57 -0400
X-UUID: 89c5f900381e4fb0b061b0f52fead3c3-20211006
X-UUID: 89c5f900381e4fb0b061b0f52fead3c3-20211006
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1052495989; Wed, 06 Oct 2021 11:10:02 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 6 Oct 2021 11:10:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Oct 2021 11:10:01 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <mikebi@micron.com>
Subject: [PATCH v3 2/2] scsi: ufs: ufs-mediatek: disable auto-hibern8 before suspend
Date:   Wed, 6 Oct 2021 11:09:59 +0800
Message-ID: <20211006030959.20533-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211006030959.20533-1-peter.wang@mediatek.com>
References: <20211006030959.20533-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Mediatek UFS design need disable auto-hibern8 before suspend.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufs-exynos.c   |  6 ++-
 drivers/scsi/ufs/ufs-hisi.c     |  6 ++-
 drivers/scsi/ufs/ufs-mediatek.c | 68 ++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufs-mediatek.h | 20 ++++++++++
 drivers/scsi/ufs/ufs-qcom.c     |  6 ++-
 5 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a14dd8ce56d4..b2ec9e20b14d 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1176,10 +1176,14 @@ static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
 	}
 }
 
-static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
+	enum ufs_notify_change_status status)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
+	if (status == PRE_CHANGE)
+		return 0;
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
 
diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 6b706de8354b..8c7e8d321746 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -396,10 +396,14 @@ static int ufs_hisi_pwr_change_notify(struct ufs_hba *hba,
 	return ret;
 }
 
-static int ufs_hisi_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+static int ufs_hisi_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
+	enum ufs_notify_change_status status)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
 
+	if (status == PRE_CHANGE)
+		return 0;
+
 	if (pm_op == UFS_RUNTIME_PM)
 		return 0;
 
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index d2d7e76c5ec8..d1696db70ce8 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -311,6 +311,46 @@ static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
 	}
 }
 
+static void ufs_mtk_wait_idle_state(struct ufs_hba *hba,
+			    unsigned long retry_ms)
+{
+	u64 timeout, time_checked;
+	u32 val, sm;
+	bool wait_idle;
+
+	timeout = sched_clock() + retry_ms * 1000000UL;
+
+
+	/* wait a specific time after check base */
+	udelay(10);
+	wait_idle = false;
+
+	do {
+		time_checked = sched_clock();
+		ufs_mtk_dbg_sel(hba);
+		val = ufshcd_readl(hba, REG_UFS_PROBE);
+
+		sm = val & 0x1f;
+
+		/*
+		 * if state is in H8 enter and H8 enter confirm
+		 * wait until return to idle state.
+		 */
+		if ((sm >= VS_HIB_ENTER) && (sm <= VS_HIB_EXIT)) {
+			wait_idle = true;
+			udelay(50);
+			continue;
+		} else if (!wait_idle)
+			break;
+
+		if (wait_idle && (sm == VS_HCE_BASE))
+			break;
+	} while (time_checked < timeout);
+
+	if (wait_idle && sm != VS_HCE_BASE)
+		dev_info(hba->dev, "wait idle tmo: 0x%x\n", val);
+}
+
 static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 				   unsigned long max_wait_ms)
 {
@@ -949,11 +989,37 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 				   REGULATOR_MODE_NORMAL);
 }
 
-static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+{
+	unsigned long flags;
+	int ret;
+
+	/* disable auto-hibern8 */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* wait host return to idle state when auto-hibern8 off */
+	ufs_mtk_wait_idle_state(hba, 5);
+
+	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
+	if (ret)
+		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+}
+
+static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
+	enum ufs_notify_change_status status)
 {
 	int err;
 	struct arm_smccc_res res;
 
+	if (status == PRE_CHANGE) {
+		if (!ufshcd_is_auto_hibern8_supported(hba))
+			return 0;
+		ufs_mtk_auto_hibern8_disable(hba);
+		return 0;
+	}
+
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_lpm(hba);
 		if (err)
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
index 524c8e2c1e6f..c96b9b529ee2 100644
--- a/drivers/scsi/ufs/ufs-mediatek.h
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -54,6 +54,26 @@ enum {
 	VS_LINK_CFG                 = 5,
 };
 
+/*
+ * Vendor specific host controller state
+ */
+enum {
+	VS_HCE_RESET                = 0,
+	VS_HCE_BASE                 = 1,
+	VS_HCE_OOCPR_WAIT           = 2,
+	VS_HCE_DME_RESET            = 3,
+	VS_HCE_MIDDLE               = 4,
+	VS_HCE_DME_ENABLE           = 5,
+	VS_HCE_DEFAULTS             = 6,
+	VS_HIB_IDLEEN               = 7,
+	VS_HIB_ENTER                = 8,
+	VS_HIB_ENTER_CONF           = 9,
+	VS_HIB_MIDDLE               = 10,
+	VS_HIB_WAITTIMER            = 11,
+	VS_HIB_EXIT_CONF            = 12,
+	VS_HIB_EXIT                 = 13,
+};
+
 /*
  * SiP commands
  */
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9d9770f1db4f..82cc55744afc 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -589,11 +589,15 @@ static void ufs_qcom_device_reset_ctrl(struct ufs_hba *hba, bool asserted)
 	gpiod_set_value_cansleep(host->device_reset, asserted);
 }
 
-static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
+	enum ufs_notify_change_status status)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 
+	if (status == PRE_CHANGE)
+		return 0;
+
 	if (ufs_qcom_is_link_off(hba)) {
 		/*
 		 * Disable the tx/rx lane symbol clocks before PHY is
-- 
2.18.0

