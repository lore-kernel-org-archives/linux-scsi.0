Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BED2FF65A;
	Tue, 14 Oct 2025 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454822; cv=pass; b=OelX96zzH4IVE65L6v9/u8S2hHYP6/xQ1hXm7v7cdm4/a+jeO2MyXXg1ZCphUJgCG7plvF7JMYVOnh0S9wEmzbwPVGOGA3AQVIGuz550svEpUYf32shWDh9Vj6qAsbvIoxb1GrrinssCKkBdgruzf33U/MvCjyTHgy/TC/ibeCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454822; c=relaxed/simple;
	bh=ZoBWVENKC8bPtFQSfKS6zeGQ+CyKx+/t0ZMvJMoFv98=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h3x+tKR3Ab4RG8BEI950tfcJjAdhze/FXeV21pzNAVLkjjlKysi3KAY46q5DjFq14wLTRULLXwhPqtQMJGaVUJp7v84urX6xoYYPF5kEG0uPEFCTuxVdgXOwyI41FNna+TV5idBrPRxFr8yZVcip696wj05JUpZwytFmlXJbUWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=d9GVtVEN; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="d9GVtVEN"
ARC-Seal: i=1; a=rsa-sha256; t=1760454652; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CiuqWR2ZZlUhRzSdVwTeRuN3iwz5IpWLxexEnP8fiGfANThuTjYNGS2X6TpNQsU99z8iBxva7mnh5dSNM8OF8DPk6kwwNkRjnjBtirMEE7EcOTaxkkbdeDKiFl/e8xQJMnq+ecOynYhSeNynF/umnlE7x2FhRBKelahog71qeVQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760454652; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7jkM8YOO8pprHHZutGv60L6EyLB0fCheY+VPh3UUMEs=; 
	b=Z4GCPKO5LrA8hscwHINGC1AvqSn9Ry8P/pbxZ5ChU73Wd69TqA4Fj2dCJn5UHkKKUZXYdoOlpyZ6d5MvsZL+2vxaPvqlF27xo8f+szdbqB1Xgw0KjonPWf4wAgPO4OzM7ePFFYPBXin6WA3kRoZWnJyiH9nC1CyOz5ZPUy4mv94=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760454652;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=7jkM8YOO8pprHHZutGv60L6EyLB0fCheY+VPh3UUMEs=;
	b=d9GVtVENKD3dzplgKPP92f8YaZg0NVzqreE1ArmQK2JoLprb8kKbYTT5s8UUv2ek
	98DErOnDVOPPPOZfSqpOx05MOiCsaR3dEKSkp37AbmKtDOgIjiy/PQfiIg++TQYTOfe
	bNAUD+RS8dIWGfElvqK+PwYmBDljeqkL2noxKbCQ=
Received: by mx.zohomail.com with SMTPS id 1760454650860592.8317711169478;
	Tue, 14 Oct 2025 08:10:50 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Tue, 14 Oct 2025 17:10:09 +0200
Subject: [PATCH 5/5] scsi: ufs: mediatek: Rework resets
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251014-mt8196-ufs-v1-5-195dceb83bc8@collabora.com>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
In-Reply-To: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Stanley Chu <stanley.chu@mediatek.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

Rework the reset control getting in the driver's probe function to use
the "_optional" function instead of defaulting to NULL on IS_ERR, so
that actual real errors (as opposed to missing resets) can be handled as
errors in the probe function.

Also move the MPHY reset into the PHY driver, where it should live, and
remove all remnants of it ever having been in this driver.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h |  8 -----
 drivers/ufs/host/ufs-mediatek.c     | 67 +++++++++++++++++++++----------------
 drivers/ufs/host/ufs-mediatek.h     |  1 -
 3 files changed, 38 insertions(+), 38 deletions(-)

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
index 758a393a9de1..ac40d4a3a800 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -204,49 +204,60 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
 static void ufs_mtk_host_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	struct arm_smccc_res res;
+	int ret;
 
 	reset_control_assert(host->hci_reset);
 	reset_control_assert(host->crypto_reset);
 	reset_control_assert(host->unipro_reset);
-	reset_control_assert(host->mphy_reset);
 
-	usleep_range(100, 110);
+	ret = phy_reset(host->mphy);
+
+	/*
+	 * Only sleep if MPHY doesn't have a reset implemented (which already
+	 * sleeps) or the PHY reset function failed somehow, just to be safe
+	 */
+	if (ret) {
+		usleep_range(100, 110);
+		if (ret != -EOPNOTSUPP)
+			dev_warn(hba->dev, "PHY reset failed: %pe\n", ERR_PTR(ret));
+	}
 
 	reset_control_deassert(host->unipro_reset);
 	reset_control_deassert(host->crypto_reset);
 	reset_control_deassert(host->hci_reset);
-	reset_control_deassert(host->mphy_reset);
-
-	/* restore mphy setting aftre mphy reset */
-	if (host->mphy_reset)
-		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
 }
 
-static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
-				       struct reset_control **rc,
-				       char *str)
+static int ufs_mtk_init_reset_control(struct ufs_hba *hba,
+				      struct reset_control **rc,
+				      const char *str)
 {
-	*rc = devm_reset_control_get(hba->dev, str);
+	*rc = devm_reset_control_get_optional(hba->dev, str);
 	if (IS_ERR(*rc)) {
-		dev_info(hba->dev, "Failed to get reset control %s: %ld\n",
-			 str, PTR_ERR(*rc));
-		*rc = NULL;
+		dev_err(hba->dev, "Failed to get reset control %s: %pe\n", str, *rc);
+		return PTR_ERR(*rc);
 	}
+
+	return 0;
 }
 
-static void ufs_mtk_init_reset(struct ufs_hba *hba)
+static int ufs_mtk_init_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	int ret;
+
+	ret = ufs_mtk_init_reset_control(hba, &host->hci_reset, "hci_rst");
+	if (ret)
+		return ret;
+
+	ret = ufs_mtk_init_reset_control(hba, &host->unipro_reset, "unipro_rst");
+	if (ret)
+		return ret;
+
+	ret = ufs_mtk_init_reset_control(hba, &host->crypto_reset, "crypto_rst");
+	if (ret)
+		return ret;
 
-	ufs_mtk_init_reset_control(hba, &host->hci_reset,
-				   "hci_rst");
-	ufs_mtk_init_reset_control(hba, &host->unipro_reset,
-				   "unipro_rst");
-	ufs_mtk_init_reset_control(hba, &host->crypto_reset,
-				   "crypto_rst");
-	ufs_mtk_init_reset_control(hba, &host->mphy_reset,
-				   "mphy_rst");
+	return 0;
 }
 
 static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
@@ -1238,11 +1249,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
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
index dfbf78bd8664..4a8a8dc2ab1e 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -174,7 +174,6 @@ struct ufs_mtk_host {
 	struct reset_control *hci_reset;
 	struct reset_control *unipro_reset;
 	struct reset_control *crypto_reset;
-	struct reset_control *mphy_reset;
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;
 	struct ufs_mtk_clk mclk;

-- 
2.51.0

