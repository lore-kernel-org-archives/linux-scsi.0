Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0AE45DF67;
	Tue, 18 Aug 2026 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052583; cv=none; b=HvJeUChyN/Bl8ppWOy6lKKKP74e5ymwRJzTAszUz4DTpNlRBXBvgByvCr9Sfle8bNw3z0tmyui53KQdDpXPQH9sLjk9zTZP5uTIwRrVVbHtzFnMp1DMT6AR4C7cRVUmDPE62ZJPfLF1V38A1c8dwTECKKIrNzjAvPDuyMIVxMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052583; c=relaxed/simple;
	bh=46+R3vjc5UuwDj7B7/bOMTKNXTQospORxN4V1LnjH6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m9b1GC1vqrvNTMR8X9sJzqUeolKQ0TZtO6Cdq1XT3VfRgVYaKlhe+h1Mht8fq4Plmt3qwM9GpJpoQqtaMS4bW/50JBbXyIpZf2SqHqWaB2Q8L9VPsMlRFaFdJp/X2O+DedLrIsNGUbJcAhF2xcwezsoED4U/juD3kaiFHOCwd3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XjsKkZ51; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XjsKkZ51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787052581; x=1818588581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=46+R3vjc5UuwDj7B7/bOMTKNXTQospORxN4V1LnjH6A=;
  b=XjsKkZ513X0E+d+E9SvPwgwu2FZlpg3Eyc7AhJNKmTk+0gb7cLhY++Mq
   oYrD+jQYjLXzrvFF1yyktaQb0a6vq6H7yJcRkSur6Ziua1mRCAKk6NWkb
   lI36yVYt2qxbXp2Zh2LIi32olzkFOdDC5VF4FF7YGtiqAWW3e/xpqqDc5
   UayOn2odi56wLFB7Ve01eqDB/D6KqbesWnQFY8hRA2RrOH4oUxB4NvVs1
   RNkrLsMEDCKamSxKgqNtfeZX9cvTbMRiN9bzBRHxVAv8FrF6xQVhsyAmv
   60YQmH3QKoltkaAZ350cWKi60FClq8x3wZtkCWIqcNgO7i8vAqVFDdg6o
   g==;
X-CSE-ConnectionGUID: FIWmUaTZR0Wz90pM2jTnog==
X-CSE-MsgGUID: 1P1Av4wER1axqaAhhYDJyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="105075362"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="105075362"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 04:29:40 -0700
X-CSE-ConnectionGUID: GHz/MkEOTLWwmyToI89INg==
X-CSE-MsgGUID: b5pTclTNT7WUavAVEBM01A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="269041552"
Received: from intel-fishhawkfalls.iind.intel.com ([10.99.116.69])
  by orviesa004.jf.intel.com with ESMTP; 18 Aug 2026 04:29:39 -0700
From: sangram kumar yerra <sangram.k.y@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: sangram kumar yerra <sangram.k.y@intel.com>,
	James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 2/2] scsi: ufs: ufs-pci: Add MCQ support for Intel UFS 4.0 controllers
Date: Tue, 18 Aug 2026 16:58:30 +0530
Message-Id: <20260818112830.453402-3-sangram.k.y@intel.com>
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

The Intel UFS 4.0 PCI variant (PCI ID 8086:D335) advertises MCQ
support in its capability register. However, ufshcd_alloc_mcq() also
requires an .op_runtime_config hook to locate the per-queue operation
and runtime (OPR) register blocks, which was not provided by this
variant operations table.

As a result, MCQ initialization fails and ufshcd_add_scsi_host()
prints "MCQ mode is disabled, err=%d\n" before falling back to
legacy single-doorbell (SDB) mode.

Add ufs_intel_mcq_config_resource() to initialize the MCQ
configuration base and add ufs_intel_op_runtime_config() to set up
the OPR register offsets and stride.

Wire both hooks into the variant operations table so MCQ is enabled
when supported by the hardware.

Fixes: 096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
Signed-off-by: sangram kumar yerra <sangram.k.y@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 93bfafc25018..21bb11c724be 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -460,6 +460,43 @@ static int ufs_intel_mtl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static int ufs_intel_mcq_config_resource(struct ufs_hba *hba)
+{
+	hba->mcq_base = hba->mmio_base + ufshcd_mcq_queue_cfg_addr(hba);
+
+	return 0;
+}
+
+/*
+ * This Intel UFS4.0 controller maps MCQ doorbell and interrupt-status
+ * registers into the same PCI BAR as the legacy HCI space, at this
+ * fixed offset/stride.
+ */
+#define UFS_INTEL_SQDAO0	0x2800
+#define UFS_INTEL_SQISAO0	0x2814
+#define UFS_INTEL_CQDAO0	0x281C
+#define UFS_INTEL_CQISAO0	0x2824
+#define UFS_INTEL_MCQ_STRIDE	0x30
+
+static int ufs_intel_op_runtime_config(struct ufs_hba *hba)
+{
+	struct ufshcd_mcq_opr_info_t *opr;
+	int i;
+
+	hba->mcq_opr[OPR_SQD].offset  = UFS_INTEL_SQDAO0;
+	hba->mcq_opr[OPR_SQIS].offset = UFS_INTEL_SQISAO0;
+	hba->mcq_opr[OPR_CQD].offset  = UFS_INTEL_CQDAO0;
+	hba->mcq_opr[OPR_CQIS].offset = UFS_INTEL_CQISAO0;
+
+	for (i = 0; i < OPR_MAX; i++) {
+		opr = &hba->mcq_opr[i];
+		opr->stride = UFS_INTEL_MCQ_STRIDE;
+		opr->base = hba->mmio_base + opr->offset;
+	}
+
+	return 0;
+}
+
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
 {
 	return MAX_SUPP_MAC;
@@ -547,6 +584,8 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 	.pwr_change_notify	= ufs_intel_nvl_pwr_change_notify,
+	.mcq_config_resource	= ufs_intel_mcq_config_resource,
+	.op_runtime_config	= ufs_intel_op_runtime_config,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
-- 
2.34.1

