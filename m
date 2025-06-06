Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FEF21C189;
	Fri,  6 Jun 2025 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749243856; cv=none; b=NlNI4LixNqFqNTLQcZ7LGha2OsgGxBqJDeXIUgmuxp2c54pVrRU7iVclTRz/gfxTOlkOfGGWq0M/hl9QOW2Cf+xGtA5aQM/P6Q82H+D6AdNxUd03KcBpXd+sKDHg7tu6ip685dbKbW5kwVMdHu20huz0hJplorO4+KJHgQnWYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749243856; c=relaxed/simple;
	bh=G7RLSSbcbnUlUeSNzWK+GZqXacWSF3Fc2SSy/IsAEdc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=pKHdUL/0CIEiTUW/v8JgHL9DGpzWNAuLFKMZ/I8yj+u/iwF/14zY18I4gXlgcOvszPRlNWOWQzw8hrbM2Vjde7tIhT1rI5uV7fvKhJJxPN8cuERFoFsaM7WpSVle+PD9NYciv4yNjRxQGaht14tfRJ7et4S1V+R2xGABvdmYr68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=w52uNFUC; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="w52uNFUC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1749243851;
	bh=G7RLSSbcbnUlUeSNzWK+GZqXacWSF3Fc2SSy/IsAEdc=;
	h=Message-ID:Subject:From:To:Date:From;
	b=w52uNFUCC4h1vVtGW0j4qp6Q7dDeVUwAGbM/dAInAXhuKzb3Z/apG9LWxIJK+LXk0
	 u5PbyI9wSXU3QDgTArjAQfok/FJkm1Bbu0lc+kcoWnwJrIOpO1qgZi0Tqt8KIc5kKI
	 6vX8R3b+eHe01QfmZEy1jcIOEEFXtdNqiEijc62Q=
Received: from [IPv6:2601:5c4:4302:c21::a774] (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id E0BAF1C025F;
	Fri, 06 Jun 2025 17:04:10 -0400 (EDT)
Message-ID: <b71ba161ecc1e31fde20291f9734eeb56d746279.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for the 6.15+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jun 2025 17:04:10 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Mostly trivial updates and bug fixes (core update is a comment spelling
fix).  The bigger UFS update is the clock scaling and frequency fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Can Guo (2):
      scsi: ufs: qcom: Call ufs_qcom_cfg_timers() in clock scaling path
      scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock freq

Nitin Rawat (1):
      scsi: ufs: qcom: Prevent calling phy_exit() before phy_init()

Tomas Henzl (1):
      scsi: aacraid: Remove useless code

Ziqi Chen (2):
      scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear()
      scsi: ufs: core: Don't perform UFS clkscaling during host async scan

mrigendrachaubey (1):
      scsi: core: devinfo: Fix typo in comment

And the diffstat:

 drivers/scsi/aacraid/aacraid.h |   1 -
 drivers/scsi/aacraid/commsup.c |  10 +--
 drivers/scsi/scsi_devinfo.c    |   2 +-
 drivers/ufs/core/ufshcd.c      |   3 +
 drivers/ufs/host/ufs-qcom.c    | 141 ++++++++++++++++++++++++++++++-------=
----
 5 files changed, 110 insertions(+), 47 deletions(-)

with full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.=
h
index 8c384c25dca1..0a5888b53d6d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -93,7 +93,6 @@ enum {
=20
 #define AAC_NUM_MGT_FIB         8
 #define AAC_NUM_IO_FIB		(1024 - AAC_NUM_MGT_FIB)
-#define AAC_NUM_FIB		(AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
=20
 #define AAC_MAX_LUN		256
=20
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c
index ffef61c4aa01..7d9a4dce236b 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -48,15 +48,7 @@
=20
 static int fib_map_alloc(struct aac_dev *dev)
 {
-	if (dev->max_fib_size > AAC_MAX_NATIVE_SIZE)
-		dev->max_cmd_size =3D AAC_MAX_NATIVE_SIZE;
-	else
-		dev->max_cmd_size =3D dev->max_fib_size;
-	if (dev->max_fib_size < AAC_MAX_NATIVE_SIZE) {
-		dev->max_cmd_size =3D AAC_MAX_NATIVE_SIZE;
-	} else {
-		dev->max_cmd_size =3D dev->max_fib_size;
-	}
+	dev->max_cmd_size =3D AAC_MAX_NATIVE_SIZE;
=20
 	dprintk((KERN_INFO
 	  "allocate hardware fibs dma_alloc_coherent(%p, %d * (%d + %d), %p)\n",
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a348df895dca..8ff679e67bbf 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -836,7 +836,7 @@ int __init scsi_init_devinfo(void)
 		goto out;
=20
 	for (i =3D 0; scsi_static_device_list[i].vendor; i++) {
-		error =3D scsi_dev_info_list_add(1 /* compatibile */,
+		error =3D scsi_dev_info_list_add(1 /* compatible */,
 				scsi_static_device_list[i].vendor,
 				scsi_static_device_list[i].model,
 				NULL,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d7ff24b48de3..a7513f256057 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1397,6 +1397,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hb=
a *hba, u64 timeout_us)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
+	mutex_lock(&hba->host->scan_mutex);
 	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
@@ -1407,6 +1408,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hb=
a *hba, u64 timeout_us)
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
 		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
=20
@@ -1428,6 +1430,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs=
_hba *hba, int err)
 	mutex_unlock(&hba->wb_mutex);
=20
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
 	ufshcd_release(hba);
 }
=20
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 790da25cbaf3..dddc87e08739 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -122,7 +122,9 @@ static const struct {
 };
=20
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
-static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, unsigned long f=
req);
+static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
+						   unsigned long freq, char *name);
+static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_u=
p, unsigned long freq);
=20
 static struct ufs_qcom_host *rcdev_to_ufs_host(struct reset_controller_dev=
 *rcd)
 {
@@ -506,10 +508,9 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *=
hba)
 	if (ret)
 		return ret;
=20
-	if (phy->power_count) {
+	if (phy->power_count)
 		phy_power_off(phy);
-		phy_exit(phy);
-	}
+
=20
 	/* phy initialization - calibrate the phy */
 	ret =3D phy_init(phy);
@@ -597,13 +598,14 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba =
*hba,
  *
  * @hba: host controller instance
  * @is_pre_scale_up: flag to check if pre scale up condition.
+ * @freq: target opp freq
  * Return: zero for success and non-zero in case of a failure.
  */
-static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up)
+static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up, =
unsigned long freq)
 {
 	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
 	struct ufs_clk_info *clki;
-	unsigned long core_clk_rate =3D 0;
+	unsigned long clk_freq =3D 0;
 	u32 core_clk_cycles_per_us;
=20
 	/*
@@ -615,22 +617,34 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, b=
ool is_pre_scale_up)
 	if (host->hw_ver.major < 4 && !ufshcd_is_intr_aggr_allowed(hba))
 		return 0;
=20
+	if (hba->use_pm_opp && freq !=3D ULONG_MAX) {
+		clk_freq =3D ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk");
+		if (clk_freq)
+			goto cfg_timers;
+	}
+
 	list_for_each_entry(clki, &hba->clk_list_head, list) {
 		if (!strcmp(clki->name, "core_clk")) {
+			if (freq =3D=3D ULONG_MAX) {
+				clk_freq =3D clki->max_freq;
+				break;
+			}
+
 			if (is_pre_scale_up)
-				core_clk_rate =3D clki->max_freq;
+				clk_freq =3D clki->max_freq;
 			else
-				core_clk_rate =3D clk_get_rate(clki->clk);
+				clk_freq =3D clk_get_rate(clki->clk);
 			break;
 		}
=20
 	}
=20
+cfg_timers:
 	/* If frequency is smaller than 1MHz, set to 1MHz */
-	if (core_clk_rate < DEFAULT_CLK_RATE_HZ)
-		core_clk_rate =3D DEFAULT_CLK_RATE_HZ;
+	if (clk_freq < DEFAULT_CLK_RATE_HZ)
+		clk_freq =3D DEFAULT_CLK_RATE_HZ;
=20
-	core_clk_cycles_per_us =3D core_clk_rate / USEC_PER_SEC;
+	core_clk_cycles_per_us =3D clk_freq / USEC_PER_SEC;
 	if (ufshcd_readl(hba, REG_UFS_SYS1CLK_1US) !=3D core_clk_cycles_per_us) {
 		ufshcd_writel(hba, core_clk_cycles_per_us, REG_UFS_SYS1CLK_1US);
 		/*
@@ -650,13 +664,13 @@ static int ufs_qcom_link_startup_notify(struct ufs_hb=
a *hba,
=20
 	switch (status) {
 	case PRE_CHANGE:
-		if (ufs_qcom_cfg_timers(hba, false)) {
+		if (ufs_qcom_cfg_timers(hba, false, ULONG_MAX)) {
 			dev_err(hba->dev, "%s: ufs_qcom_cfg_timers() failed\n",
 				__func__);
 			return -EINVAL;
 		}
=20
-		err =3D ufs_qcom_set_core_clk_ctrl(hba, ULONG_MAX);
+		err =3D ufs_qcom_set_core_clk_ctrl(hba, true, ULONG_MAX);
 		if (err)
 			dev_err(hba->dev, "cfg core clk ctrl failed\n");
 		/*
@@ -928,17 +942,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *=
hba,
=20
 		break;
 	case POST_CHANGE:
-		if (ufs_qcom_cfg_timers(hba, false)) {
-			dev_err(hba->dev, "%s: ufs_qcom_cfg_timers() failed\n",
-				__func__);
-			/*
-			 * we return error code at the end of the routine,
-			 * but continue to configure UFS_PHY_TX_LANE_ENABLE
-			 * and bus voting as usual
-			 */
-			ret =3D -EINVAL;
-		}
-
 		/* cache the power mode parameters to use internally */
 		memcpy(&host->dev_req_params,
 				dev_req_params, sizeof(*dev_req_params));
@@ -1414,29 +1417,46 @@ static int ufs_qcom_set_clk_40ns_cycles(struct ufs_=
hba *hba,
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_VS_CORE_CLK_40NS_CYCLES), reg);
 }
=20
-static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, unsigned long f=
req)
+static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_u=
p, unsigned long freq)
 {
 	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
 	struct list_head *head =3D &hba->clk_list_head;
 	struct ufs_clk_info *clki;
 	u32 cycles_in_1us =3D 0;
 	u32 core_clk_ctrl_reg;
+	unsigned long clk_freq;
 	int err;
=20
+	if (hba->use_pm_opp && freq !=3D ULONG_MAX) {
+		clk_freq =3D ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk_unipro")=
;
+		if (clk_freq) {
+			cycles_in_1us =3D ceil(clk_freq, HZ_PER_MHZ);
+			goto set_core_clk_ctrl;
+		}
+	}
+
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk) &&
 		    !strcmp(clki->name, "core_clk_unipro")) {
-			if (!clki->max_freq)
+			if (!clki->max_freq) {
 				cycles_in_1us =3D 150; /* default for backwards compatibility */
-			else if (freq =3D=3D ULONG_MAX)
+				break;
+			}
+
+			if (freq =3D=3D ULONG_MAX) {
 				cycles_in_1us =3D ceil(clki->max_freq, HZ_PER_MHZ);
-			else
-				cycles_in_1us =3D ceil(freq, HZ_PER_MHZ);
+				break;
+			}
=20
+			if (is_scale_up)
+				cycles_in_1us =3D ceil(clki->max_freq, HZ_PER_MHZ);
+			else
+				cycles_in_1us =3D ceil(clk_get_rate(clki->clk), HZ_PER_MHZ);
 			break;
 		}
 	}
=20
+set_core_clk_ctrl:
 	err =3D ufshcd_dme_get(hba,
 			    UIC_ARG_MIB(DME_VS_CORE_CLK_CTRL),
 			    &core_clk_ctrl_reg);
@@ -1473,13 +1493,13 @@ static int ufs_qcom_clk_scale_up_pre_change(struct =
ufs_hba *hba, unsigned long f
 {
 	int ret;
=20
-	ret =3D ufs_qcom_cfg_timers(hba, true);
+	ret =3D ufs_qcom_cfg_timers(hba, true, freq);
 	if (ret) {
 		dev_err(hba->dev, "%s ufs cfg timer failed\n", __func__);
 		return ret;
 	}
 	/* set unipro core clock attributes and clear clock divider */
-	return ufs_qcom_set_core_clk_ctrl(hba, freq);
+	return ufs_qcom_set_core_clk_ctrl(hba, true, freq);
 }
=20
 static int ufs_qcom_clk_scale_up_post_change(struct ufs_hba *hba)
@@ -1510,8 +1530,15 @@ static int ufs_qcom_clk_scale_down_pre_change(struct=
 ufs_hba *hba)
=20
 static int ufs_qcom_clk_scale_down_post_change(struct ufs_hba *hba, unsign=
ed long freq)
 {
+	int ret;
+
+	ret =3D ufs_qcom_cfg_timers(hba, false, freq);
+	if (ret) {
+		dev_err(hba->dev, "%s: ufs_qcom_cfg_timers() failed\n",	__func__);
+		return ret;
+	}
 	/* set unipro core clock attributes and clear clock divider */
-	return ufs_qcom_set_core_clk_ctrl(hba, freq);
+	return ufs_qcom_set_core_clk_ctrl(hba, false, freq);
 }
=20
 static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
@@ -2081,11 +2108,53 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	return ret;
 }
=20
+static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
+						   unsigned long freq, char *name)
+{
+	struct ufs_clk_info *clki;
+	struct dev_pm_opp *opp;
+	unsigned long clk_freq;
+	int idx =3D 0;
+	bool found =3D false;
+
+	opp =3D dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
+	if (IS_ERR(opp)) {
+		dev_err(hba->dev, "Failed to find OPP for exact frequency %lu\n", freq);
+		return 0;
+	}
+
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!strcmp(clki->name, name)) {
+			found =3D true;
+			break;
+		}
+
+		idx++;
+	}
+
+	if (!found) {
+		dev_err(hba->dev, "Failed to find clock '%s' in clk list\n", name);
+		dev_pm_opp_put(opp);
+		return 0;
+	}
+
+	clk_freq =3D dev_pm_opp_get_freq_indexed(opp, idx);
+
+	dev_pm_opp_put(opp);
+
+	return clk_freq;
+}
+
 static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long =
freq)
 {
-	u32 gear =3D 0;
+	u32 gear =3D UFS_HS_DONT_CHANGE;
+	unsigned long unipro_freq;
+
+	if (!hba->use_pm_opp)
+		return gear;
=20
-	switch (freq) {
+	unipro_freq =3D ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk_unipro=
");
+	switch (unipro_freq) {
 	case 403000000:
 		gear =3D UFS_HS_G5;
 		break;
@@ -2105,10 +2174,10 @@ static u32 ufs_qcom_freq_to_gear_speed(struct ufs_h=
ba *hba, unsigned long freq)
 		break;
 	default:
 		dev_err(hba->dev, "%s: Unsupported clock freq : %lu\n", __func__, freq);
-		break;
+		return UFS_HS_DONT_CHANGE;
 	}
=20
-	return gear;
+	return min_t(u32, gear, hba->max_pwr_info.info.gear_rx);
 }
=20
 /*


