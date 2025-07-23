Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5D207DEE
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289960; cv=none; b=K9a9ocvGCwYNo20hqp0CdbRvltm55lxLEtIDlg6uiQ6YUMUvJD3ud29wvn42wxUVcRmY0CPyp5GONhrqPBdZ8WzQntI5RopPQ9SMweiBqIVHP0lhRN3x1+o6m9vWqVsUvYT3ApEfCoxkUvNO1G26iXTeem6i6sMBLdqpcGG1vVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289960; c=relaxed/simple;
	bh=oYuOM2u7VexSxghcVU4ht9bB/+yKiIoUC4Tz6EPzuA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5VC9FKRyQBQy0HvjFnIq0har5KhDGAfvD5o/1P8cM+1Qtk9YqPZpmtm6i2rv5dubIeqbwyVRl1vKw51CjEqtF4taV90WhaLD2WX1BqpfutHGBHNFIlMY9RzDmM5ktw59RHVLtt/8E01u3SOXY1AXxvLKlFHcN5NVMhV1fBgWxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UC4ki2pQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UC4ki2pQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289959; x=1784825959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oYuOM2u7VexSxghcVU4ht9bB/+yKiIoUC4Tz6EPzuA4=;
  b=UC4ki2pQC1Bq1EwmFZvyTpO1phBOKZ8OWR5Q/g7/jHHufXfoTS8UibJm
   taGlXVf8N/mbWwGDSCDSnZp+cw6bDjxL7l4V1/QDmoU7KWhtco7Pn9NEA
   mSJNc/cNlp1DGKZexS6ZOuh0QAbNStUPi1vT3sNRxvO3TwzWPIGCVzihP
   R8B9/vY0xFIQKR6mrMXCFaDo5B9GQqcC4wwkIGQWngYQQsVe81s2PPXsE
   9Nu4EfYGRUtKK+uEMdsQEXAkZ5D80pJf3qEFGYHOhwP99yrK2oO5EFLQ4
   yPQ5iSSKYF/Tn/F/s0GL4MgYGLs2cARGoFGxwDEtlnRmgAPq3X2S2U1vg
   w==;
X-CSE-ConnectionGUID: CSS6nkVlQ2+cdZqcc/O7Aw==
X-CSE-MsgGUID: wTmhe1GwR/Ws53UYGWEVPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55735007"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55735007"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:19 -0700
X-CSE-ConnectionGUID: gefGgokXSJmMutx8PwVBug==
X-CSE-MsgGUID: e4+TxL3OQviKVeqjmi6FeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196733008"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:17 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 4/8] scsi: ufs: core: Move ufshcd_enable_intr() and ufshcd_disable_intr()
Date: Wed, 23 Jul 2025 19:58:52 +0300
Message-ID: <20250723165856.145750-5-adrian.hunter@intel.com>
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

Move ufshcd_enable_intr() and ufshcd_disable_intr() so they can be called
in subsequent patches without forward declarations.

No functional change.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/core/ufshcd.c | 52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index acfc1b4691fa..2fbd44514308 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -364,6 +364,32 @@ void ufshcd_disable_irq(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
 
+/**
+ * ufshcd_enable_intr - enable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	set |= intrs;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+/**
+ * ufshcd_disable_intr - disable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	set &= ~intrs;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
 static void ufshcd_configure_wb(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_wb_allowed(hba))
@@ -2681,32 +2707,6 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return ufshcd_crypto_fill_prdt(hba, lrbp);
 }
 
-/**
- * ufshcd_enable_intr - enable interrupts
- * @hba: per adapter instance
- * @intrs: interrupt bits
- */
-static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
-{
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-
-	set |= intrs;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
-}
-
-/**
- * ufshcd_disable_intr - disable interrupts
- * @hba: per adapter instance
- * @intrs: interrupt bits
- */
-static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
-{
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-
-	set &= ~intrs;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
-}
-
 /**
  * ufshcd_prepare_req_desc_hdr - Fill UTP Transfer request descriptor header according to request
  * descriptor according to request
-- 
2.48.1

