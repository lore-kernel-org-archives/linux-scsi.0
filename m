Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [104.223.66.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C601F37A7;
	Wed,  8 Jan 2025 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.223.66.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736364692; cv=none; b=Q7K2bl+y6Pt9gdeBaWIENe1LuTp9OqQw0T7L1WoWuGWFNjj79URN76NbnkCie6Vj8JAHwOSzUQAXNTmQYLwxvy7tCWv6cnT1cUTeFtbNZZljpHf4JiBBHzJm4b5eG/k8nxIW8XR1HRWSY7o3bRDyHWLW9kUZNP1LLa7w4c1L2AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736364692; c=relaxed/simple;
	bh=mI2xwylXTfUyuKHF28grAoCido8LnuuBuIBxBoTYp3M=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=sVNrk3LPCVdpdmpf/o7x9OkY+TRs38gbLx+dTFY3GVaACmUD64yCpgbjFWQNSvykcel+dFeLyMJ6IDsmD44yeGO9Nm+Y1++zKc7nxKy+koofLpxXwYSaIf+uRhDi3lyAuKln2yNAuvTIeevr0gJQzriiS6sB8rT5VvlsGe4rT1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=OPo9HNBN; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=YoVvzhOx; arc=none smtp.client-ip=104.223.66.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="OPo9HNBN";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YoVvzhOx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1736364688;
	bh=mI2xwylXTfUyuKHF28grAoCido8LnuuBuIBxBoTYp3M=;
	h=Message-ID:Subject:From:To:Date:From;
	b=OPo9HNBNafTCxsS2nmuSAPaAFQ/fpywNBqGugBdec81v2RdgtqCZblZ23zVhEm8TU
	 d0Rk5Ua8ucvxJ6hr1lRTWuxZU4LSusX7tF276bPVNGg3TdKL37TxzwssTimMefGzK4
	 VcCyZofNWb1PuK4iRrCXIJdtiM8emnbvO63r4mVI=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0F64412879AD;
	Wed, 08 Jan 2025 14:31:28 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id M4cM9iMg2P4j; Wed,  8 Jan 2025 14:31:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1736364687;
	bh=mI2xwylXTfUyuKHF28grAoCido8LnuuBuIBxBoTYp3M=;
	h=Message-ID:Subject:From:To:Date:From;
	b=YoVvzhOxsChfS3gKpN7bBQ6/nSQ4LvIi2okE4lrFBdz+KARiYpIKTXAzxUzUQPvdU
	 kUc9/Um6e7awv0bFYA7DkaW7o1y3TJY+2GcSe8Spjx+UxAsDAB3Hwo3bqgSqwUST4P
	 lTTzHslsefLaCgJYTnaQiwMNMZx8SQ/GKfDsX6q0=
Received: from [10.106.168.49] (unknown [167.220.100.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 7D1201287776;
	Wed, 08 Jan 2025 14:31:27 -0500 (EST)
Message-ID: <4954d5ac31f5bb5f68c62ae5d825871eaafc1a5a.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.13-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 08 Jan 2025 11:31:26 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Four driver fixes in UFS, mostly to do with power management.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Manivannan Sadhasivam (4):
      scsi: ufs: qcom: Power down the controller/device during system suspend for SM8550/SM8650 SoCs
      scsi: ufs: qcom: Allow passing platform specific OF data
      scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
      scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()

And the diffstat:

 drivers/ufs/core/ufshcd-priv.h |  6 ------
 drivers/ufs/core/ufshcd.c      | 10 ++++++----
 drivers/ufs/host/ufs-qcom.c    | 31 +++++++++++++++++++------------
 drivers/ufs/host/ufs-qcom.h    |  5 +++++
 include/ufs/ufshcd.h           |  2 --
 5 files changed, 30 insertions(+), 24 deletions(-)

With full diff below.

James

---

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 9ffd94ddf8c7..786f20ef2238 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -237,12 +237,6 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, p, data);
 }
 
-static inline void ufshcd_vops_reinit_notify(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->reinit_notify)
-		hba->vops->reinit_notify(hba);
-}
-
 static inline int ufshcd_vops_mcq_config_resource(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->mcq_config_resource)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8a01e4393159..9c26e8767515 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8858,7 +8858,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 		ufshcd_device_reset(hba);
 		ufs_put_device_desc(hba);
 		ufshcd_hba_stop(hba);
-		ufshcd_vops_reinit_notify(hba);
 		ret = ufshcd_hba_enable(hba);
 		if (ret) {
 			dev_err(hba->dev, "Host controller enable failed\n");
@@ -10591,14 +10590,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/*
-	 * Set the default power management level for runtime and system PM.
+	 * Set the default power management level for runtime and system PM if
+	 * not set by the host controller drivers.
 	 * Default power saving mode is to keep UFS link in Hibern8 state
 	 * and UFS device in sleep state.
 	 */
-	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->rpm_lvl)
+		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
-	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->spm_lvl)
+		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 68040b2ab5f8..91e94fe990b4 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -368,6 +368,11 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	if (ret)
 		return ret;
 
+	if (phy->power_count) {
+		phy_power_off(phy);
+		phy_exit(phy);
+	}
+
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
 	if (ret) {
@@ -866,6 +871,7 @@ static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
  */
 static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 {
+	const struct ufs_qcom_drvdata *drvdata = of_device_get_match_data(hba->dev);
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	if (host->hw_ver.major == 0x2)
@@ -874,9 +880,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 	if (host->hw_ver.major > 0x3)
 		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
 
-	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc") ||
-	    of_device_is_compatible(hba->dev->of_node, "qcom,sm8650-ufshc"))
-		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
+	if (drvdata && drvdata->quirks)
+		hba->quirks |= drvdata->quirks;
 }
 
 static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
@@ -1064,6 +1069,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct ufs_qcom_host *host;
 	struct ufs_clk_info *clki;
+	const struct ufs_qcom_drvdata *drvdata = of_device_get_match_data(hba->dev);
 
 	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
@@ -1143,6 +1149,9 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		dev_warn(dev, "%s: failed to configure the testbus %d\n",
 				__func__, err);
 
+	if (drvdata && drvdata->no_phy_retention)
+		hba->spm_lvl = UFS_PM_LVL_5;
+
 	return 0;
 
 out_variant_clear:
@@ -1579,13 +1588,6 @@ static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
 }
 #endif
 
-static void ufs_qcom_reinit_notify(struct ufs_hba *hba)
-{
-	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-
-	phy_power_off(host->generic_phy);
-}
-
 /* Resources */
 static const struct ufshcd_res_info ufs_res_info[RES_MAX] = {
 	{.name = "ufs_mem",},
@@ -1825,7 +1827,6 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
-	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
 	.op_runtime_config	= ufs_qcom_op_runtime_config,
@@ -1868,9 +1869,15 @@ static void ufs_qcom_remove(struct platform_device *pdev)
 		platform_device_msi_free_irqs_all(hba->dev);
 }
 
+static const struct ufs_qcom_drvdata ufs_qcom_sm8550_drvdata = {
+	.quirks = UFSHCD_QUIRK_BROKEN_LSDBS_CAP,
+	.no_phy_retention = true,
+};
+
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,ufshc" },
-	{ .compatible = "qcom,sm8550-ufshc" },
+	{ .compatible = "qcom,sm8550-ufshc", .data = &ufs_qcom_sm8550_drvdata },
+	{ .compatible = "qcom,sm8650-ufshc", .data = &ufs_qcom_sm8550_drvdata },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index b9de170983c9..919f53682beb 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -217,6 +217,11 @@ struct ufs_qcom_host {
 	bool esi_enabled;
 };
 
+struct ufs_qcom_drvdata {
+	enum ufshcd_quirks quirks;
+	bool no_phy_retention;
+};
+
 static inline u32
 ufs_qcom_get_debug_reg_offset(struct ufs_qcom_host *host, u32 reg)
 {
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d650ae6b58d3..74e5b9960c54 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -329,7 +329,6 @@ struct ufs_pwr_mode_info {
  * @program_key: program or evict an inline encryption key
  * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
- * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  * @mcq_config_resource: called to configure MCQ platform resources
  * @get_hba_mac: reports maximum number of outstanding commands supported by
  *	the controller. Should be implemented for UFSHCI 4.0 or later
@@ -381,7 +380,6 @@ struct ufs_hba_variant_ops {
 				    void *prdt, unsigned int num_segments);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
-	void	(*reinit_notify)(struct ufs_hba *);
 	int	(*mcq_config_resource)(struct ufs_hba *hba);
 	int	(*get_hba_mac)(struct ufs_hba *hba);
 	int	(*op_runtime_config)(struct ufs_hba *hba);

