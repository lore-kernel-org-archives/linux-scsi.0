Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F92D883F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 03:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.143.206.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776137852; cv=none; b=R77OJAVQzRgQBHFu9/goCzHN4+0yynmHqdfWsBc/dsEF6zBDQFr74GCf4wQa3IwssJZkdQ3vKkPB1OKn2FKFSWjWksniBd+acak72hbVih87Ydzx5cyE/KUHba2y+w6HLdSCFZMkeNpBsIxkTGbrWQgy4g8h0EJkeWKYUfWIoeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776137852; c=relaxed/simple;
	bh=9XuOP0cOc605cfCd9cpV1sznXz1ITn2hbyUPql1TOXQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uNwlZ61VXf8vKodRZ9QMUhrTdYQOGUJb0gYce7hYRKndS2kiEgFmqbASKf++RnleWeORZifRNvyTIRxPN9X3sXoiNe3dysT21+hTQUuZ9b9blO6Kg24cA47Ezj7JRUStj4h6Z/8Y+8mXqgILOLG279yl3/SwE/0nGXJy62Y7NMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=118.143.206.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: 0sEfiXkIRfuZdhTs63NwcA==
X-CSE-MsgGUID: l9x3FBTvSzG0Fg5i4LN2JQ==
X-IronPort-AV: E=Sophos;i="6.23,178,1770566400"; 
   d="scan'208";a="146539484"
From: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Bean Huo
	<beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>
CC: <linux-scsi@vger.kernel.org>, <wanghui33@xiaomi.com>, Wang Shuaiwei
	<wangshuaiwei1@xiaomi.com>
Subject: [PATCH v2] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS mode
Date: Tue, 14 Apr 2026 11:37:18 +0800
Message-ID: <20260414033718.1459540-1-wangshuaiwei1@xiaomi.com>
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

v1->v2:
- modify the coding style

v1: https://lore.kernel.org/linux-scsi/20260413091126.1219552-1-wangshuaiwei1@xiaomi.com/
---
 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++++--
 include/ufs/unipro.h      |  5 +++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ceb6d6d479d..da38e97a199e 100644
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
+	if ((rx_mode == SLOW_MODE || rx_mode == SLOWAUTO_MODE) &&
+	    (tx_mode == SLOW_MODE || tx_mode == SLOWAUTO_MODE))
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

