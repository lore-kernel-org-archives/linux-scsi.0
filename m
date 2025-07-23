Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C820C004
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289958; cv=none; b=DdeK043qkbsoTPiPPnfvBG1pH4gFFqSPwEuZRLn0RmlOjFdhjJSu3l/q7fi8cX+zllicKw0u2Fd3yKamqlzxuu7FGDxr3geHr227RB1cYsICOVQlEPPhYBfUa5UMIXcy2Ql4yfw0yZbUuNDkDk4TqaAW7o+wguOpo+6hwv5Dvuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289958; c=relaxed/simple;
	bh=2NmAcWfUNomPCHZleEheU0H7C5vyjGe+WEnOoWa6Qs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBdE5gZObhqHxbL4kLoyThocWX2gWO8NBDi40N+2DzxzFFeIbP7Ojw/39b8fiGH2rH72UQLxRRHWvmi92xrKAXkI+X3JhDp/zq4NG1F8clOgJzxwdiP2p6DqYYj15cW4rvhBZZIQ0ngs1CdMcBaADgAaDFYyUDoeghcXpk0xqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwLuSVPT; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwLuSVPT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289957; x=1784825957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2NmAcWfUNomPCHZleEheU0H7C5vyjGe+WEnOoWa6Qs0=;
  b=SwLuSVPT6pbkoySXg55tpr8ezRCbH8vG253V5ZAzYMdmWLwh9A9Z+izB
   2UOjdh13J3dsB1iv1ZVmKL7ypmVCCWEdojtCrPTyova/uznw14UIQ0DBu
   oD6vxPWTX0HEwFZGSpyhrOxU8pVM9oQ0G3v705ydKIdfwutS8Gt+jHYFr
   RkqOxjTdAZeF1mVtb+M1AhXTfs3xzJpB0iFNhYR5KnoHDlA+bc3RV6Rgo
   R9sTnI8qiKiF8Ep+Zuk73U0WgCFePvRKm+oxoU6FiBg0PPvNkyq49Tpnc
   lSYF49bxGgYZYK7rPBEzqH1DAZHAkeqPvlVSnScqXoe9Au/TlEqsGlmDL
   w==;
X-CSE-ConnectionGUID: jhWw4Fm7RRe9spZ9+Ebjww==
X-CSE-MsgGUID: OR13cRhOSLurhGwtAEPShA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55735000"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55735000"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:17 -0700
X-CSE-ConnectionGUID: J/RdQu9FQK+zDim3bv20DA==
X-CSE-MsgGUID: 3JaPbqK6SqKvNM4/7zOQHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196733002"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:15 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 3/8] scsi: ufs: ufs-pci: Remove UFS PCI driver's ->late_init() call back
Date: Wed, 23 Jul 2025 19:58:51 +0300
Message-ID: <20250723165856.145750-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250723165856.145750-1-adrian.hunter@intel.com>
References: <20250723165856.145750-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

 ->late_init() was introduced to allow the default values for rpm_lvl and
spm_lvl to be set.  Since commit bb9850704c04 ("scsi: ufs: core: Honor
runtime/system PM levels if set by host controller drivers") and
commit fe06b7c07f3f ("scsi: ufs: core: Set default runtime/system PM levels
before ufshcd_hba_init()"), those default values can be set in the ->init()
variant call back.

Move the setting of default values for rpm_lvl and spm_lvl to ->init() and
remove ->late_init().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:
	Adjust for change in patch 2
	Add Bart's Rev'd-by


 drivers/ufs/host/ufshcd-pci.c | 46 +++++++----------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 8aff32d7057d..b29ec1904482 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -22,17 +22,12 @@
 
 #define MAX_SUPP_MAC 64
 
-struct ufs_host {
-	void (*late_init)(struct ufs_hba *hba);
-};
-
 enum intel_ufs_dsm_func_id {
 	INTEL_DSM_FNS		=  0,
 	INTEL_DSM_RESET		=  1,
 };
 
 struct intel_host {
-	struct ufs_host ufs_host;
 	u32		dsm_fns;
 	u32		active_ltr;
 	u32		idle_ltr;
@@ -434,8 +429,14 @@ static int ufs_intel_ehl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
-static void ufs_intel_lkf_late_init(struct ufs_hba *hba)
+static int ufs_intel_lkf_init(struct ufs_hba *hba)
 {
+	int err;
+
+	hba->nop_out_timeout = 200;
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->caps |= UFSHCD_CAP_CRYPTO;
+	err = ufs_intel_common_init(hba);
 	/* LKF always needs a full reset, so set PM accordingly */
 	if (hba->caps & UFSHCD_CAP_DEEPSLEEP) {
 		hba->spm_lvl = UFS_PM_LVL_6;
@@ -444,19 +445,6 @@ static void ufs_intel_lkf_late_init(struct ufs_hba *hba)
 		hba->spm_lvl = UFS_PM_LVL_5;
 		hba->rpm_lvl = UFS_PM_LVL_5;
 	}
-}
-
-static int ufs_intel_lkf_init(struct ufs_hba *hba)
-{
-	struct ufs_host *ufs_host;
-	int err;
-
-	hba->nop_out_timeout = 200;
-	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
-	hba->caps |= UFSHCD_CAP_CRYPTO;
-	err = ufs_intel_common_init(hba);
-	ufs_host = ufshcd_get_variant(hba);
-	ufs_host->late_init = ufs_intel_lkf_late_init;
 	return err;
 }
 
@@ -468,23 +456,12 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
-static void ufs_intel_mtl_late_init(struct ufs_hba *hba)
+static int ufs_intel_mtl_init(struct ufs_hba *hba)
 {
 	hba->rpm_lvl = UFS_PM_LVL_2;
 	hba->spm_lvl = UFS_PM_LVL_2;
-}
-
-static int ufs_intel_mtl_init(struct ufs_hba *hba)
-{
-	struct ufs_host *ufs_host;
-	int err;
-
 	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
-	err = ufs_intel_common_init(hba);
-	/* Get variant after it is set in ufs_intel_common_init() */
-	ufs_host = ufshcd_get_variant(hba);
-	ufs_host->late_init = ufs_intel_mtl_late_init;
-	return err;
+	return ufs_intel_common_init(hba);
 }
 
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
@@ -614,7 +591,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 static int
 ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct ufs_host *ufs_host;
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
 	int err;
@@ -647,10 +623,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	ufs_host = ufshcd_get_variant(hba);
-	if (ufs_host && ufs_host->late_init)
-		ufs_host->late_init(hba);
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
-- 
2.48.1

