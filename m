Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B6209F2E
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289956; cv=none; b=HN9lYmi9rUIQrl/oepHkQSpBcrLlOoKy4uMgmGhaMsxuvTTLNb6h7H8Y/6+t1lRjrp+3eTjzzwZDW4wbXjR555zR6qx+5w4OiAzlIJzLmCfpfEGAErycmVV5sbWyz7GteMadsnUMtRe7iOjV4yCBDnW4cpuprbUrWI92pG76N1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289956; c=relaxed/simple;
	bh=0rY3vRjksgWaiasmw4KoZsKCUTZxVG3275SZ7kSI3bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLIAOY95FPTv4PyASsCcSzTddgd6X0hIpxV6JGSXRYt0xKHkLtDcxzC02hHYkIXVO8Ia/zjRq48WYl7gYvCQjLA5KlFQTGL665iLobuzbgBTiO+anH44DGiqBZ3C/j1TFe7f6z2uxdvoD8tJkdEizbMnQ9bvev8qo72uu8+f60M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HgbE5R3O; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HgbE5R3O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289955; x=1784825955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0rY3vRjksgWaiasmw4KoZsKCUTZxVG3275SZ7kSI3bA=;
  b=HgbE5R3OOCBW/iRltmxPVTl44EBGWhUoCvdpsBNa6GzJrhsaQBW9qTyL
   rA1SDynPrdvKQlXreGlOHIor89S4LvTik1IJHmMh+h9dF3ofUbfb1zERK
   w7MsBwRgbU3jxuQLXQvZUtgehh1O6Kod8g5SNLV2R/H2IUW0H0Iopdck+
   wwYyjDSbrEv+bQPeSbRS0L7ZeXCyy1ANaK/u3waLXJbEaKc0xArcxG5ef
   4VjSGYwqM703a8K9MotnZ905pICg3p8ggJ7nG6tfAJt5on+15uaMyzRCK
   kSTRQ7Zf498P/4gvp98vpaQyLBPXS3Krn9vIO6ehOyykLbLTTkv2wCSSE
   w==;
X-CSE-ConnectionGUID: 82why5GJTleVekdqcvxq/Q==
X-CSE-MsgGUID: v2uEYLNRRWWgqdsZq967sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55734993"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55734993"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:15 -0700
X-CSE-ConnectionGUID: kyIisrXuRJ+4OSVoyTfqAg==
X-CSE-MsgGUID: k5sAA+5gT3WTH9H4wNewgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196732995"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:12 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 2/8] scsi: ufs: ufs-pci: Fix default runtime and system PM levels
Date: Wed, 23 Jul 2025 19:58:50 +0300
Message-ID: <20250723165856.145750-3-adrian.hunter@intel.com>
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


Changes in V2:
	Add comment about getting variant after it is set


 drivers/ufs/host/ufshcd-pci.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index af1c272eef1c..8aff32d7057d 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -468,10 +468,23 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
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
+	/* Get variant after it is set in ufs_intel_common_init() */
+	ufs_host = ufshcd_get_variant(hba);
+	ufs_host->late_init = ufs_intel_mtl_late_init;
+	return err;
 }
 
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
-- 
2.48.1

