Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AA5101EC;
	Sat,  3 Aug 2024 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722721616; cv=none; b=IxfBlU4swjegh2QssI1+rdNK8aRYqonlWqKld0zL7cefhV6I/44QTRAMGQCe04AyORX2Fvu6QAXaEK+YVe7kijChooWIGV6oVQRxtkLAQnQnc8dgjfIshfgsh+t1hc3fnmFBsA0VTOUh/D4jy44rivwgWSAV27Q/uqxQkVASuig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722721616; c=relaxed/simple;
	bh=mQwT5aHUifyTWpfaKZkx8teb5olNvyZXf4DUopKgtII=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Wji5UmKDuTbqPSadLJ2E+Uke4LzuWHuDZg4odjvyGI3dRRsgQaV+oUJWAu90uVom0cmymNAr6sLHbn8cZvMn56/KxsFxXh/7qTm/SIKRp6/1wvCELhWHMLFsM4jIKhg+w8Q7ZzKinQbAQ7ZBXskz24qls/4qVmFqk+lPM6WOh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=n5lLHyK4; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=n5lLHyK4; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="n5lLHyK4";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="n5lLHyK4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1722721613;
	bh=mQwT5aHUifyTWpfaKZkx8teb5olNvyZXf4DUopKgtII=;
	h=Message-ID:Subject:From:To:Date:From;
	b=n5lLHyK4PVfs1oRCIsk6Mik+NoTRqGe1Gpnexb64xtWqDoKmafFnMR/zW40e/TIxD
	 O3w1hQ8Bl6B7pFJVio517sN0OjRsCxr9bqRvGt2u01ShDcBVBHeQcSOSlkhT4d6kt3
	 yq7zjnUMaMJKz0OKdulYds+zTpz73yDSXl7lcUyQ=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7AFDC1281A09;
	Sat, 03 Aug 2024 17:46:53 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id vkRLEslJHtwv; Sat,  3 Aug 2024 17:46:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1722721613;
	bh=mQwT5aHUifyTWpfaKZkx8teb5olNvyZXf4DUopKgtII=;
	h=Message-ID:Subject:From:To:Date:From;
	b=n5lLHyK4PVfs1oRCIsk6Mik+NoTRqGe1Gpnexb64xtWqDoKmafFnMR/zW40e/TIxD
	 O3w1hQ8Bl6B7pFJVio517sN0OjRsCxr9bqRvGt2u01ShDcBVBHeQcSOSlkhT4d6kt3
	 yq7zjnUMaMJKz0OKdulYds+zTpz73yDSXl7lcUyQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::db7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DB1BF12816A0;
	Sat, 03 Aug 2024 17:46:52 -0400 (EDT)
Message-ID: <dbfc2aaa8122fe748480f53ab79c0a9efe196ebe.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.11-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 03 Aug 2024 17:46:50 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

One core change that reverts the double message print patch in sd.c (it
was causing regressions on embedded systems).  The rest are driver
fixes in ufs, mpt3sas and mpi3mr.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (2):
      scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES
      scsi: mpi3mr: Avoid IOMMU page faults on REPORT ZONES

Eric Biggers (1):
      scsi: ufs: exynos: Don't resume FMP when crypto support is disabled

Johan Hovold (1):
      scsi: Revert "scsi: sd: Do not repeat the starting disk message"

Kyoungrul Kim (1):
      scsi: ufs: core: Check LSDBS cap when !mcq

Manivannan Sadhasivam (1):
      scsi: ufs: core: Do not set link to OFF state while waking up from hibernation

Peter Wang (2):
      scsi: ufs: core: Fix deadlock during RTC update
      scsi: ufs: core: Bypass quick recovery if force reset is needed

With the diffstat:

 drivers/scsi/mpi3mr/mpi3mr_os.c     | 11 +++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c | 20 ++++++++++++++++++--
 drivers/scsi/sd.c                   |  5 +++--
 drivers/ufs/core/ufshcd-priv.h      |  5 +++++
 drivers/ufs/core/ufshcd.c           | 27 ++++++++++++++++++++++-----
 drivers/ufs/host/ufs-exynos.c       |  3 +++
 include/ufs/ufshcd.h                |  1 +
 include/ufs/ufshci.h                |  1 +
 8 files changed, 64 insertions(+), 9 deletions(-)

With full diff below.

James

---
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 69b14918de59..ca8f132e03ae 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3575,6 +3575,17 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 		    scmd->sc_data_direction);
 		priv->meta_sg_valid = 1; /* To unmap meta sg DMA */
 	} else {
+		/*
+		 * Some firmware versions byte-swap the REPORT ZONES command
+		 * reply from ATA-ZAC devices by directly accessing in the host
+		 * buffer. This does not respect the default command DMA
+		 * direction and causes IOMMU page faults on some architectures
+		 * with an IOMMU enforcing write mappings (e.g. AMD hosts).
+		 * Avoid such issue by making the REPORT ZONES buffer mapping
+		 * bi-directional.
+		 */
+		if (scmd->cmnd[0] == ZBC_IN && scmd->cmnd[1] == ZI_REPORT_ZONES)
+			scmd->sc_data_direction = DMA_BIDIRECTIONAL;
 		sg_scmd = scsi_sglist(scmd);
 		sges_left = scsi_dma_map(scmd);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b2bcf4a27ddc..b785a7e88b49 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2671,6 +2671,22 @@ _base_build_zero_len_sge_ieee(struct MPT3SAS_ADAPTER *ioc, void *paddr)
 	_base_add_sg_single_ieee(paddr, sgl_flags, 0, 0, -1);
 }
 
+static inline int _base_scsi_dma_map(struct scsi_cmnd *cmd)
+{
+	/*
+	 * Some firmware versions byte-swap the REPORT ZONES command reply from
+	 * ATA-ZAC devices by directly accessing in the host buffer. This does
+	 * not respect the default command DMA direction and causes IOMMU page
+	 * faults on some architectures with an IOMMU enforcing write mappings
+	 * (e.g. AMD hosts). Avoid such issue by making the report zones buffer
+	 * mapping bi-directional.
+	 */
+	if (cmd->cmnd[0] == ZBC_IN && cmd->cmnd[1] == ZI_REPORT_ZONES)
+		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+
+	return scsi_dma_map(cmd);
+}
+
 /**
  * _base_build_sg_scmd - main sg creation routine
  *		pcie_device is unused here!
@@ -2717,7 +2733,7 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
 
 	sg_scmd = scsi_sglist(scmd);
-	sges_left = scsi_dma_map(scmd);
+	sges_left = _base_scsi_dma_map(scmd);
 	if (sges_left < 0)
 		return -ENOMEM;
 
@@ -2861,7 +2877,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	sg_scmd = scsi_sglist(scmd);
-	sges_left = scsi_dma_map(scmd);
+	sges_left = _base_scsi_dma_map(scmd);
 	if (sges_left < 0)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adeaa8ab9951..8bb3a3611851 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4205,6 +4205,8 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -4221,13 +4223,12 @@ static int sd_resume_common(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ce36154ce963..7aea8fbaeee8 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -316,6 +316,11 @@ static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
 	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
 
+static inline int ufshcd_rpm_get_if_active(struct ufs_hba *hba)
+{
+	return pm_runtime_get_if_active(&hba->ufs_device_wlun->sdev_gendev);
+}
+
 static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
 {
 	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc757ba47522..5e3c67e96956 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2416,7 +2416,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 		return err;
 	}
 
+	/*
+	 * The UFSHCI 3.0 specification does not define MCQ_SUPPORT and
+	 * LSDB_SUPPORT, but [31:29] as reserved bits with reset value 0s, which
+	 * means we can simply read values regardless of version.
+	 */
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	/*
+	 * 0h: legacy single doorbell support is available
+	 * 1h: indicate that legacy single doorbell support has been removed
+	 */
+	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -6553,7 +6563,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (ufshcd_err_handling_should_stop(hba))
 		goto skip_err_handling;
 
-	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+	if ((hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) &&
+	    !hba->force_reset) {
 		bool ret;
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -8211,7 +8222,10 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
 	 */
 	val = ts64.tv_sec - hba->dev_info.rtc_time_baseline;
 
-	ufshcd_rpm_get_sync(hba);
+	/* Skip update RTC if RPM state is not RPM_ACTIVE */
+	if (ufshcd_rpm_get_if_active(hba) <= 0)
+		return;
+
 	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
 				0, 0, &val);
 	ufshcd_rpm_put_sync(hba);
@@ -10265,9 +10279,6 @@ int ufshcd_system_restore(struct device *dev)
 	 */
 	ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_BASE_H);
 
-	/* Resuming from hibernate, assume that link was OFF */
-	ufshcd_set_link_off(hba);
-
 	return 0;
 
 }
@@ -10496,6 +10507,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported)\n",
+				__func__);
+			err = -EINVAL;
+			goto out_disable;
+		}
 		err = scsi_add_host(host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 16ad3528d80b..9ec318ef52bf 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1293,6 +1293,9 @@ static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
+	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
+		return;
+
 	arm_smccc_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DESCTYPE_3,
 		      0, 0, 0, 0, &res);
 	if (res.a0)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b14276bc3..cac0cdb9a916 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1109,6 +1109,7 @@ struct ufs_hba {
 	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
+	bool lsdb_sup;
 	bool mcq_enabled;
 	struct ufshcd_res_info res[RES_MAX];
 	void __iomem *mcq_base;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 38fe97971a65..9917c7743d80 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -77,6 +77,7 @@ enum {
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 	MASK_CRYPTO_SUPPORT			= 0x10000000,
+	MASK_LSDB_SUPPORT			= 0x20000000,
 	MASK_MCQ_SUPPORT			= 0x40000000,
 };
 

