Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CC2469853;
	Tue, 18 Aug 2026 11:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052582; cv=none; b=nBvWzhdMcCUc6JWyi8rg6f2/xVc/inDCgBLArwLL5yhHKro0E7H/OkM2YgQH3nldXTWJIRfiCgYrOAxIJh31TLNpZzdH/Rr8+MzimZ788m1MvQG4ng+5RZxjJcAa3BBctNnLcQaNWknk3XU3s9KyQ/GOGh/ELwnIRJhmh31CG8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052582; c=relaxed/simple;
	bh=ON7FH67kxPAO8Ak13d9x3uiDVMv3VCWGGC3SK2NpDyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DkZbFUnGph+QdSDLkJ+rStvMns+Pqyp4/+Ke83m8Fpw85NXKECpFwJbbJEra1GuE6CEg2CJzkWgQV//9PmJTUMesJE6pjX3HTGsOPp8P7lS0ik9JmZ36HtnxNjshRZSz+s9MNsBJtO5IMujeQi3ZJ5tnC6GRX+Fzd3cvZ3fTiYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ipl1FSCT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ipl1FSCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787052577; x=1818588577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ON7FH67kxPAO8Ak13d9x3uiDVMv3VCWGGC3SK2NpDyY=;
  b=Ipl1FSCTmt4UxlYRi8/w0tx8C70Rn4VD+LYZwqGG7UXqvTkyIEhhL4BO
   4zZymd4PXRWy6QogSuTnNVl2s/0xntTk4Hx+A/NaYDowajrV8Ebvv8OxN
   X+y7ZE9E2lB7PRM7TZSum8he+vKqZVLfK3pbi2kcO3FsH9isTqkkZ8F5E
   MC2LQCrVP+xOutrHOFg97koyct8gL6tC9LN/u6H2WA3+Yjx3iH5/11xHw
   niP4+oUXBUISUCNhlLtHSoyCBbUZScmgE1d4B16ClicUgx9NuuuxTg20n
   6xO+4vP3Uqxd3TrPa7/VPT4Meb2OR4RXgHFOvTT/9nsaWg9sateqNkRiI
   w==;
X-CSE-ConnectionGUID: iiLX/1ITQaKcrrMBq8xV0A==
X-CSE-MsgGUID: cxfyeIaRTHaXtvn2RcDasw==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="105075340"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="105075340"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 04:29:37 -0700
X-CSE-ConnectionGUID: lnm1DJBLTBKec5O0DBNoPQ==
X-CSE-MsgGUID: t1yJXR4YSBCtWtbBlsQvCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="269041526"
Received: from intel-fishhawkfalls.iind.intel.com ([10.99.116.69])
  by orviesa004.jf.intel.com with ESMTP; 18 Aug 2026 04:29:35 -0700
From: sangram kumar yerra <sangram.k.y@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: sangram kumar yerra <sangram.k.y@intel.com>,
	James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 1/2] scsi: ufs: ufs-pci: Add support for Intel UFS 4.0 HS-Gear5
Date: Tue, 18 Aug 2026 16:58:29 +0530
Message-Id: <20260818112830.453402-2-sangram.k.y@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260818112830.453402-1-sangram.k.y@intel.com>
References: <20260818112830.453402-1-sangram.k.y@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reliable HS-Gear5 operation on Intel UFS 4.0 controllers requires
configuring PA_INITIAL_ADAPT before changing the power mode. Without
this setting, the link fails to train reliably at Gear5.

Add a pwr_change_notify() hook to configure the adaptation mode before
the power mode transition. Enable this only for UFS 4.0 and later
controllers by checking hba->ufs_version.

Wire the hook into the existing Meteor Lake family variant operations
table (ufs_intel_mtl_hba_vops) instead of introducing a separate table,
since the Intel UFS 4.0 PCI variant (PCI ID 8086:D335) already uses
this vops table and the hook is internally gated on UFS version >= 4.0.

Use PA_INITIAL_ADAPT when the negotiated TX power mode is FAST_MODE or
FASTAUTO_MODE. Otherwise, reset the adaptation mode to PA_NO_ADAPT,
which is the default setting.

Fixes: 096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
Signed-off-by: sangram kumar yerra <sangram.k.y@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index f2433879b0eb..93bfafc25018 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -181,6 +181,25 @@ static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_nvl_pwr_change_notify(struct ufs_hba *hba,
+					   enum ufs_notify_change_status stage,
+					   struct ufs_pa_layer_attr *dev_req_params)
+{
+	int adapt_val;
+
+	if (stage != PRE_CHANGE || hba->ufs_version < ufshci_version(4, 0))
+		return 0;
+
+	if (dev_req_params->pwr_tx == FAST_MODE || dev_req_params->pwr_tx == FASTAUTO_MODE)
+		adapt_val = PA_INITIAL_ADAPT;
+	else
+		adapt_val = PA_NO_ADAPT;
+
+	ufshcd_dme_configure_adapt(hba, dev_req_params->gear_tx, adapt_val);
+
+	return 0;
+}
+
 static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
 {
 	u32 granularity, peer_granularity;
@@ -527,6 +546,7 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.pwr_change_notify	= ufs_intel_nvl_pwr_change_notify,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
-- 
2.34.1

