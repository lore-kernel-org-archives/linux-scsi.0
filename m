Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89BF291C33
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525029; cv=none; b=COvsSw8GnnwifYAqfK4HVaBjqiRonR4XrbgKVLm0yLjROwk2J8vUOgZAgE9vOskXrYCHpjMfYHyyrG9sOgLArpu+h3cOphCOM2KNjpwBJ9NnNf6aeVL/PQ5JQxxGX1feRMOemVbnVBUqji/d31d8s82ZYeJsgGhiDKpvj3Szysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525029; c=relaxed/simple;
	bh=4+nELYS/4saL3PDC4ejM4JUZbN900XiuIc4RSjuMeqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbVV1OANFdB3X28RY07UvIm/m+cWFtM4FK47HnvMoACvuSkqNGW7i3xcBuWM1TSe2RNn3YQS6llewbuRsuwdB4v+qpDXHOn7xjbC6ancdH52jj9xn493tTTwgTQBWdkb/yL1s9wLKPMARhpjD0rVyWRfFfrA2XQ8jYjLtYxauM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4kChxB0; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4kChxB0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751525028; x=1783061028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4+nELYS/4saL3PDC4ejM4JUZbN900XiuIc4RSjuMeqY=;
  b=H4kChxB0yF7oFNIfR38F9xLW8L1PmoxyDqc8ZcH1zaVTWcQWye5vPqJW
   qTsKWaGumVbszX1/b/cJTh1GkT/DZ+B608GFrDAiB/snl4f7gOUMmj48/
   jBoEEuO2pbkWNEsDbNnsk/GX96uHbcp3FDEkSjnsVAQ9R96ooi69c15b7
   daxOszbyRcdCK5sZmxete1apwktJ9EJmFGTKmIKPpmiSInk9ofOcQrAbb
   ZOqlkTFDoSZWKc7/i7YET3VOyZo6ylWWZhakZ1YPunfse0MmE9ko7R0ts
   m4XDRkjydzY1CCrHXYjQrfE2IHplCvMftNcwfDAKy7hfmVNsI/yGpC5th
   A==;
X-CSE-ConnectionGUID: 2jvEeEjgSuSduhbFJTNymA==
X-CSE-MsgGUID: AEOjTV7tQ0ChTuW3DmDy4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64533856"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64533856"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:48 -0700
X-CSE-ConnectionGUID: h1lJzv9uTSSlEKp1s8gZow==
X-CSE-MsgGUID: KXsTrHnfR1agrHq2+kSR2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158646101"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:46 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/3] scsi: ufs: ufs-pci: Fix default runtime and system PM levels
Date: Thu,  3 Jul 2025 09:43:21 +0300
Message-ID: <20250703064322.46679-3-adrian.hunter@intel.com>
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

Intel MTL-like host controllers support auto-hibernate.  Using
auto-hibernate with manual (driver initiated) hibernate produces more
complex operation.  For example, the host controller will have to exit
auto-hibernate simply to allow the driver to enter hibernate state
manually.  That is not recommended.

The default rpm_lvl and spm_lvl is 3, which includes manual hibernate.

Change the default values to 2, which does not.

Note, to be simpler to backport to stable kernels, utilize the UFS PCI
driver's ->late_init() call back.  Recent commits have made it possible
to set up a controller-specific default in the regular ->init() call back,
but not all stable kernels have those changes.

Fixes: 4049f7acef3eb ("scsi: ufs: ufs-pci: Add support for Intel MTL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index af1c272eef1c..e42e5f69ff0c 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -468,10 +468,22 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static void ufs_intel_mtl_late_init(struct ufs_hba *hba)
+{
+	hba->rpm_lvl = UFS_PM_LVL_2;
+	hba->spm_lvl = UFS_PM_LVL_2;
+}
+
 static int ufs_intel_mtl_init(struct ufs_hba *hba)
 {
+	struct ufs_host *ufs_host;
+	int err;
+
 	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
-	return ufs_intel_common_init(hba);
+	err = ufs_intel_common_init(hba);
+	ufs_host = ufshcd_get_variant(hba);
+	ufs_host->late_init = ufs_intel_mtl_late_init;
+	return err;
 }
 
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
-- 
2.48.1

