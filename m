Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C364A2046A9
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289970; cv=none; b=rDFQ2B9jZ1RbXX6GfRtM7L6L4RA7x4rzNN2QLQYQYuxV9bDleH3Edm7RLD9ulgEGmT27dVeifQv2NUZauHEGFZIqyARIc7ObflMA7c+L9qcQXbYjpmvj9d74hRKXDnDXqLG4xbONgrgHEhVX7RG6+ok+fz6b8TLOeWDZbhUwBSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289970; c=relaxed/simple;
	bh=XD+jocqvYr7552TFZjMbwvS6G11BikcFaooBxIazKWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEVw9aiUvFw/PgM4Ij/iGyP1mc3mfsUDUVcbnNwxky/6k4QqXfsgrVIDh19EZGtj7XnTp8PEooHMGrptqRtDJDka9JGTZ9qdnSZWIsQosRoPktXJ5Yg0wbZKcUBYrQSm7JiHbScW2d7EiqP4wSzymK5ci/LDA5psdDHwUFZ6oRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d6Urlrdv; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d6Urlrdv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289969; x=1784825969;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XD+jocqvYr7552TFZjMbwvS6G11BikcFaooBxIazKWI=;
  b=d6Urlrdv6baCHMbwpc5o7ZOZXOpW80IfkJkpAb8jPgoeBlqNuCJMpGm+
   ubtq/2jCB4l1V8KU28boMGND8LckXW915WVRAEZWgl3KEg7tkHErsgULJ
   esDxS0T4cQG7Uo6uKUCkTkpxXld31tKiG20BxprpePl2L2wKJyoJE9Hai
   7Dr0hVnkKqkP8RGfCKHA9eHVqxMMMayUlJFZlrvOkLTFsbnpARul8y2wT
   T4POF1e0A1ODxIbbW5aRvCN8Qkb7o7Q/w6WPnbR+RatLbba//goRll+ay
   P3lcj0je+Oapj8Fk5dsjXRWut8WcGoPeuz+EQiu63H4QITdG3FylTGhKB
   w==;
X-CSE-ConnectionGUID: YwLIdSmuRrmJH5vrMbjS8Q==
X-CSE-MsgGUID: DO9mTS7XTxyWJ/qKQYiuYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55735035"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55735035"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:29 -0700
X-CSE-ConnectionGUID: IerDKpx9RKuq+dcqibFQAw==
X-CSE-MsgGUID: WBRYrhdDQJu8WzB7E3KJcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196733053"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:26 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 8/8] scsi: ufs: ufs-pci: Remove control of UIC Completion interrupt for Intel MTL
Date: Wed, 23 Jul 2025 19:58:56 +0300
Message-ID: <20250723165856.145750-9-adrian.hunter@intel.com>
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

Now that UFS core enables the UIC Completion interrupt only when needed,
Intel MTL driver no longer needs to control the interrupt itself.  So
remove the associated code.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index b29ec1904482..b39239f641f2 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -211,32 +211,6 @@ static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufs_intel_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
-{
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-
-	if (enable)
-		set |= UIC_COMMAND_COMPL;
-	else
-		set &= ~UIC_COMMAND_COMPL;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
-}
-
-static void ufs_intel_mtl_h8_notify(struct ufs_hba *hba,
-				    enum uic_cmd_dme cmd,
-				    enum ufs_notify_change_status status)
-{
-	/*
-	 * Disable UIC COMPL INTR to prevent access to UFSHCI after
-	 * checking HCS.UPMCRS
-	 */
-	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
-		ufs_intel_ctrl_uic_compl(hba, false);
-
-	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
-		ufs_intel_ctrl_uic_compl(hba, true);
-}
-
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -549,7 +523,6 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.init			= ufs_intel_mtl_init,
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
-	.hibern8_notify		= ufs_intel_mtl_h8_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
-- 
2.48.1

