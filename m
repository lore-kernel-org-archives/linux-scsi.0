Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4821E396B9D;
	Fri,  6 Mar 2026 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772803573; cv=pass; b=q1FU/NcaYd/1V5YJ54CG26ZQ8fUqZLqe5BcskQAIrHaDK5IeU86oFY/d25zMvd9TGVV7vmltY9882/9dUFkDZmDfP8zWzf+K8D0Wxh1K99OjYPLarK25BA6cjA+WeI3TaxyEPSeQr54S2oJwn563pO3obACGj10syvdhdbvpyMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772803573; c=relaxed/simple;
	bh=vYMZc9bFtuRFDVWO/t/HPdrFhWduMx7nG1MULjHiIAk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qg/6YgZIrcQOPTMRx8EAbcYWtFtrY0IndmxFBXlGW9756soLy3V2P/taW5TbVY1twyf8xULR9LwwxxWEfinAlyfb17GR+hzvzJFVDYlVyRrdXmgKXNzFmzcZAxoGyGtoanLvCm7/iC3Ulq+hYujhfwpEDNanaCfi284sTnl0xRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=gGNzlaRU; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="gGNzlaRU"
ARC-Seal: i=1; a=rsa-sha256; t=1772803537; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bf2+peiOoXiSTkYpFUp61cUzzKOOmXnND36cZpEeev5I/lrxcnTXklhHY47Iklv7m20vNQ7gBNnXhIhR62bHfge8c+IkPsOfaKRclWvbDYG3UZtVuZ+EaHKu7jaK2K8lyYs9//o0y2i7BDTmZprCEQwTkfD4mDwxpWiWfZEYpL4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772803537; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ExHEKc5L9u5Y4DDkaVnvzF+5E3tzaOhpf9WTifyjtLk=; 
	b=WJUfMocHJs2B8d6VK83r8/NVe58gVVOoJsO29ov0jERlXcp8GV5ty9VRJ99brsU/6Mu3r5ILLTYl/mn9g23ZrNtXnOiu9c28AXIcHA5NttvJ1jlL0yXCd3yonX514uQbn3PZLAhjns3d4pDmS0+pHuPjjXBKQXWhoqburZ+CZtQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772803537;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=ExHEKc5L9u5Y4DDkaVnvzF+5E3tzaOhpf9WTifyjtLk=;
	b=gGNzlaRUsYoVJAjH45Vo/uEHtVpTR7jwouJJ0nGwDwuCKvn52b9+WNHhm9w7qbG3
	8eieGZDmhT9XWIEiQl/Eg79FRA4CXhzfi0mSTjmgOOz/5T6CjPfxeteMkOuVqI8Dh8Y
	O3D0qL8JMAD9Hly2QUctAmvHCnLntHilYcHQoBQ8=
Received: by mx.zohomail.com with SMTPS id 1772803536890548.3092721160912;
	Fri, 6 Mar 2026 05:25:36 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Fri, 06 Mar 2026 14:24:47 +0100
Subject: [PATCH v9 06/23] scsi: ufs: mediatek: Rework resets
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-mt8196-ufs-v9-6-55b073f7a830@collabora.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
In-Reply-To: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

Rework the reset control getting in the driver's probe function to use
the bulk reset APIs. Use the optional variant instead of defaulting to
NULL if the resets fail, so that absent resets can be distinguished from
erroneous resets.

Also remove all remnants of the MPHY reset ever having lived in this
driver.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h |  8 ----
 drivers/ufs/host/ufs-mediatek.c     | 78 ++++++++++++++++++-------------------
 drivers/ufs/host/ufs-mediatek.h     |  7 ++--
 3 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index d627dfb4a766..256598cc3b5b 100644
--- a/drivers/ufs/host/ufs-mediatek-sip.h
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -31,11 +31,6 @@ enum ufs_mtk_vcc_num {
 	UFS_VCC_MAX
 };
 
-enum ufs_mtk_mphy_op {
-	UFS_MPHY_BACKUP = 0,
-	UFS_MPHY_RESTORE
-};
-
 /*
  * SMC call wrapper function
  */
@@ -84,9 +79,6 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
 #define ufs_mtk_device_pwr_ctrl(on, ufs_version, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_PWR_CTRL, &(res), on, ufs_version)
 
-#define ufs_mtk_mphy_ctrl(op, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_MPHY_CTRL, &(res), op)
-
 #define ufs_mtk_mtcmos_ctrl(op, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_MTCMOS_CTRL, &(res), op)
 
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index b3daaa07e925..206794ce46c8 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -93,6 +93,12 @@ static const char *const ufs_uic_dl_err_str[] = {
 	"PA_INIT"
 };
 
+static const char *const ufs_reset_names[] = {
+	"unipro",
+	"crypto",
+	"hci",
+};
+
 static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -203,49 +209,45 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
 static void ufs_mtk_host_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	struct arm_smccc_res res;
-
-	reset_control_assert(host->hci_reset);
-	reset_control_assert(host->crypto_reset);
-	reset_control_assert(host->unipro_reset);
-	reset_control_assert(host->mphy_reset);
-
-	usleep_range(100, 110);
+	int ret;
 
-	reset_control_deassert(host->unipro_reset);
-	reset_control_deassert(host->crypto_reset);
-	reset_control_deassert(host->hci_reset);
-	reset_control_deassert(host->mphy_reset);
+	ret = reset_control_bulk_assert(MTK_UFS_NUM_RESETS, host->resets);
+	if (ret)
+		dev_warn(hba->dev, "Host reset assert failed: %pe\n", ERR_PTR(ret));
 
-	/* restore mphy setting aftre mphy reset */
-	if (host->mphy_reset)
-		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
-}
+	ret = phy_reset(host->mphy);
 
-static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
-				       struct reset_control **rc,
-				       char *str)
-{
-	*rc = devm_reset_control_get(hba->dev, str);
-	if (IS_ERR(*rc)) {
-		dev_info(hba->dev, "Failed to get reset control %s: %ld\n",
-			 str, PTR_ERR(*rc));
-		*rc = NULL;
+	/*
+	 * Only sleep if MPHY doesn't have a reset implemented (which already
+	 * sleeps) or the PHY reset function failed somehow, just to be safe
+	 */
+	if (ret) {
+		usleep_range(100, 110);
+		if (ret != -EOPNOTSUPP)
+			dev_warn(hba->dev, "PHY reset failed: %pe\n", ERR_PTR(ret));
 	}
+
+	ret = reset_control_bulk_deassert(MTK_UFS_NUM_RESETS, host->resets);
+	if (ret)
+		dev_warn(hba->dev, "Host reset deassert failed: %pe\n", ERR_PTR(ret));
 }
 
-static void ufs_mtk_init_reset(struct ufs_hba *hba)
+static int ufs_mtk_init_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	int ret, i;
+
+	for (i = 0; i < MTK_UFS_NUM_RESETS; i++)
+		host->resets[i].id = ufs_reset_names[i];
 
-	ufs_mtk_init_reset_control(hba, &host->hci_reset,
-				   "hci_rst");
-	ufs_mtk_init_reset_control(hba, &host->unipro_reset,
-				   "unipro_rst");
-	ufs_mtk_init_reset_control(hba, &host->crypto_reset,
-				   "crypto_rst");
-	ufs_mtk_init_reset_control(hba, &host->mphy_reset,
-				   "mphy_rst");
+	ret = devm_reset_control_bulk_get_optional_exclusive(hba->dev, MTK_UFS_NUM_RESETS,
+							     host->resets);
+	if (ret) {
+		dev_err(hba->dev, "Failed to get resets: %pe\n", ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
 }
 
 static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
@@ -1247,11 +1249,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	if (err)
 		goto out_variant_clear;
 
-	ufs_mtk_init_reset(hba);
-
-	/* backup mphy setting if mphy can reset */
-	if (host->mphy_reset)
-		ufs_mtk_mphy_ctrl(UFS_MPHY_BACKUP, res);
+	err = ufs_mtk_init_reset(hba);
+	if (err)
+		goto out_variant_clear;
 
 	/* Enable runtime autosuspend */
 	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 9747277f11e8..4fce29d131d1 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -7,12 +7,14 @@
 #define _UFS_MEDIATEK_H
 
 #include <linux/bitops.h>
+#include <linux/reset.h>
 
 /*
  * MCQ define and struct
  */
 #define UFSHCD_MAX_Q_NR 8
 #define MTK_MCQ_INVALID_IRQ	0xFFFF
+#define MTK_UFS_NUM_RESETS 3
 
 /* REG_UFS_MMIO_OPT_CTRL_0 160h */
 #define EHS_EN                  BIT(0)
@@ -175,10 +177,7 @@ struct ufs_mtk_mcq_intr_info {
 struct ufs_mtk_host {
 	struct phy *mphy;
 	struct regulator *reg_va09;
-	struct reset_control *hci_reset;
-	struct reset_control *unipro_reset;
-	struct reset_control *crypto_reset;
-	struct reset_control *mphy_reset;
+	struct reset_control_bulk_data resets[MTK_UFS_NUM_RESETS];
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;
 	struct ufs_mtk_clk mclk;

-- 
2.53.0

