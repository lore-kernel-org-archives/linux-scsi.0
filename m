Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D659396D1C
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 09:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776071500; cv=none; b=DQn3oEfyFz05/sDXPxJrcsyQX8YO0qpU4gQbavqIpiR2mhuk485UZ+6104mT1nH4jss+dzkV4O08JxPpuCXaODO1HhxyXzKNgeCGe+KL02kmvmK9o/pUpbbcs/HjcZEleQJSfksLMRjNzghMwoZPiqF+vX1laOdmit5d6IUkf6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776071500; c=relaxed/simple;
	bh=eERfkjN4DpYAGn/76VBsZsVdCMDCoQ0zH4bK5T32w6g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QlkA1nJAJqIpIeuReNe7PSnT0ox4XF7k7JuRPOodsvZoTQmMGD+lETQiADAAi2hc9eEmdlAK+34UXU2gY+Aqbqlgt6YZvqj3oXphmQtlLqCdGlYEP0MlN22Vb3XbHMiWeHk8Ry6Y7gaJO1gI1uxQfXwBteCJGUV3+Fbo/6JfrT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: L4iHgOHxQyulpbaQs/PbJg==
X-CSE-MsgGUID: 4pOVZg0aS0KPMhnvdX5McQ==
X-IronPort-AV: E=Sophos;i="6.23,176,1770566400"; 
   d="scan'208";a="172642272"
From: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Bean Huo
	<beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>
CC: <linux-scsi@vger.kernel.org>, <wanghui33@xiaomi.com>, Wang Shuaiwei
	<wangshuaiwei1@xiaomi.com>
Subject: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS mode
Date: Mon, 13 Apr 2026 17:11:26 +0800
Message-ID: <20260413091126.1219552-1-wangshuaiwei1@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX02.mioffice.cn (10.237.8.122) To bj-mbx11.mioffice.cn
 (10.237.8.131)

According to the UFS spec, the bRefClkFreq attribute can only be written
when both sub-links are in LS-MODE. However, in HS LSS mode with
resetmode = HS_MODE, if the UFS device's default bRefClkFreq value
differs from the host controller's dev_ref_clk_freq setting, the
write operation will fail.

To fix this issue, introduce ufshcd_get_op_mode() function to detect
the current link operational mode. Call ufshcd_set_dev_ref_clk() only
when both sub-links are in LS-MODE to ensure the attribute can be
written successfully.

Signed-off-by: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
---
 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++++--
 include/ufs/unipro.h      |  5 +++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ceb6d6d479d..51a8656e412e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9103,6 +9103,30 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 		 hba->nutrs);
 }
 
+/**
+ * ufshcd_get_op_mode - get UFS operating mode.
+ * @hba: per-adapter instance
+ *
+ * Use the PA_PWRMODE value to represent the operating mode of UFS.
+ *
+ */
+static enum ufs_op_mode ufshcd_get_op_mode(struct ufs_hba *hba)
+{
+	u32 mode;
+	u8 rx_mode;
+	u8 tx_mode;
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
+	rx_mode = (mode >> PWRMODE_RX_OFFSET) & PWRMODE_MASK;
+	tx_mode = mode & PWRMODE_MASK;
+
+	if ((SLOW_MODE == rx_mode || SLOWAUTO_MODE == rx_mode) &&
+	    (SLOW_MODE == tx_mode || SLOWAUTO_MODE == tx_mode))
+		return LS_MODE;
+
+	return HS_MODE;
+}
+
 static int ufshcd_post_device_init(struct ufs_hba *hba)
 {
 	int ret;
@@ -9119,11 +9143,12 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
 		return 0;
 
 	/*
-	 * Set the right value to bRefClkFreq before attempting to
+	 * Set the right value to bRefClkFreq in LS_MODE before attempting to
 	 * switch to HS gears.
 	 */
-	if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
+	if (ufshcd_get_op_mode(hba) == LS_MODE && hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
 		ufshcd_set_dev_ref_clk(hba);
+
 	/* Gear up to HS gear. */
 	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
 	if (ret) {
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 59de737490ca..3858ed13b2f3 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -198,6 +198,11 @@
 #define DME_LocalTC0ReplayTimeOutVal		0xD042
 #define DME_LocalAFC0ReqTimeOutVal		0xD043
 
+enum ufs_op_mode {
+	LS_MODE = 1,
+	HS_MODE = 2,
+};
+
 /* PA power modes */
 enum ufs_pa_pwr_mode {
 	FAST_MODE	= 1,
-- 
2.43.0

