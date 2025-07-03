Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28224292B41
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525031; cv=none; b=ldjkG+y1Z7J8xWjx4H3yXJTMnuv95nU+q3SgEcSG9l8huS3U95/SHVbkO2t4UFcemtN8JjKACdXPo9r3+qcp9T3d34MoXsblJK0YV+OwmvZmO+lTI0tMcpAF4OkwJx9lQTuRngInMuaqqvtHEQyGlR9rqgjwUWUsxuwC99e55vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525031; c=relaxed/simple;
	bh=X+uXdLZ5is07fK6Lr+mlwFDI7JW0dAGHjlReK75akuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw4rQgd+CXS70SqyXiLkhw7Qmo760hlDXNYvTbZ557eGtbJpQHTZ5NQnMCosLE3GfIVXbM0GurG4m9NWGDrZ/pRW2J0GMUqb+XtTJbpPdENvEZvYQtQuvAzIBnFhC/xqxp2AuO40/plTSxAk1Tsb73dwxDuZ1fsW2bhDzDnO6m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dH6bI0dA; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dH6bI0dA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751525030; x=1783061030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X+uXdLZ5is07fK6Lr+mlwFDI7JW0dAGHjlReK75akuI=;
  b=dH6bI0dAaWPH5scD/s3tTQCgBlR5v75wsyOBkxeb6qbUARqhI3lF0m+0
   ATe4E0M4ZbOuVqEQ7iK7byZOgK9ABk6a7XqeNPaoHxdPmpfjcLRp/9T2X
   nmp7UJ5VmehWV2RjPIGPAgrO8EuRQWQyMyqN01WHG7b8HC0AZQy35APVM
   XRZq1n5X4MQqZ80dMf9XpIq0foRpDkVxnqr76sdKW8gimpx+qQ0QDv+Mp
   bS/+JbnpZK3g/lWXPVCCNLJWMyBMZm0RHFfyrhepcRgz9mK2VkgHN+qfy
   5DAHih+dEhcKmN17IF2mKybZAAe/INTjv7D3um1RlchnXyEcL+hJY2iAb
   w==;
X-CSE-ConnectionGUID: XQxmPTudRO6+0fHQltLOUg==
X-CSE-MsgGUID: VT+dziDuSQ+5S/3iYLXrcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64533868"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64533868"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:50 -0700
X-CSE-ConnectionGUID: 8DCexE0zTlOUCRb95yYLWA==
X-CSE-MsgGUID: RwtucmtDTF+djLn3dpvtOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158646107"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:48 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/3] scsi: ufs: ufs-pci: Remove UFS PCI driver's ->late_init() call back
Date: Thu,  3 Jul 2025 09:43:22 +0300
Message-ID: <20250703064322.46679-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250703064322.46679-1-adrian.hunter@intel.com>
References: <20250703064322.46679-1-adrian.hunter@intel.com>
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

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 45 +++++++----------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index e42e5f69ff0c..b29ec1904482 100644
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
 
@@ -468,22 +456,12 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
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
-	ufs_host = ufshcd_get_variant(hba);
-	ufs_host->late_init = ufs_intel_mtl_late_init;
-	return err;
+	return ufs_intel_common_init(hba);
 }
 
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
@@ -613,7 +591,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 static int
 ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct ufs_host *ufs_host;
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
 	int err;
@@ -646,10 +623,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

