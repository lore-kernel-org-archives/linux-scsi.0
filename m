Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6868E2046A9
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289968; cv=none; b=WWEIT4xUk6dD4QqKbFh0xMNlrqmrhqwTqUjChJfYNImKBswBHziUZbPmqYdv/TyEqsfHHBVRrtNVrUqe3duodIbutNUHYkioAvqVddeB17r3MvQOY/Q0uovQ+75NzUx8kXYakgRp1/BLtAQYjEGhszZQ/7DIs2GTjFxVyywWtvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289968; c=relaxed/simple;
	bh=Zly+dgS1IsrKt5il31S2R5nYXnoFS/NH/0Fi28ACKoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9+Ya5WV35lO7BPbt1CGoHpIf6jnMY6E5Xtp7BPMSk6uKJuZQzsf8MrVFEiXAzD2M8Ahh4dC+IWJa9fC+8m/oXD2E99r/erRJHjcgWzI+C0819RNkCsE/+FX7HgF/iDqVmS9ezq0O014NbIDJXTN8RCT17+mCvoEj0HLsYufNqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mx8T/5TX; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mx8T/5TX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289966; x=1784825966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zly+dgS1IsrKt5il31S2R5nYXnoFS/NH/0Fi28ACKoo=;
  b=mx8T/5TXKMktnNu8YDYRkQf8zIMPelzA5SeJZLTXfB/v4LHdr1e/ESBj
   lmBS62gyNeRAJW25ddFfa2++m6iujT8o48bqC2Uj2aR3moaOfHGoiyCJd
   942qmHSDWEI6D04w+yCeDCNCYS3nKU2FMnyI+7P4Yg9ag1PJ0mQiVF8IZ
   nRPvLMeoHA28POwccBZJAOG/C31phZTq0u5t0T8c61M/7eA37K8GG+mmD
   RZ9Eh3V7PseeDm8NRxPL6TLeFN/Ku1yHcGBtGqPV4lXgIXL6Pvs+TzXcz
   aK1Mx1lxpPGPIIF0yO+Nm2eHp1+WEzNsIDRrqv1os4JA7AajSA7649MOg
   w==;
X-CSE-ConnectionGUID: aFFzchaXRB6bzeL8QWcw9w==
X-CSE-MsgGUID: rtbpCw9tSqmqEoPm8aZjdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55735028"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55735028"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:26 -0700
X-CSE-ConnectionGUID: KxKBG4X6ReqOPM3f/+gFJw==
X-CSE-MsgGUID: xsJCmPyjRPmjQ687iFHglw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196733046"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:24 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 7/8] scsi: ufs: core: Do not write interrupt enable register unnecessarily
Date: Wed, 23 Jul 2025 19:58:55 +0300
Message-ID: <20250723165856.145750-8-adrian.hunter@intel.com>
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

Write a new value to the interrupt enable register only if it is different
from the old value, thereby saving a register write operation.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/core/ufshcd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1567aba866b5..df475b3fb7c5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -371,10 +371,11 @@ EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
  */
 static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
 {
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+	u32 old_val = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+	u32 new_val = old_val | intrs;
 
-	set |= intrs;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+	if (new_val != old_val)
+		ufshcd_writel(hba, new_val, REG_INTERRUPT_ENABLE);
 }
 
 /**
@@ -384,10 +385,11 @@ static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
  */
 static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
 {
-	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+	u32 old_val = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+	u32 new_val = old_val & ~intrs;
 
-	set &= ~intrs;
-	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+	if (new_val != old_val)
+		ufshcd_writel(hba, new_val, REG_INTERRUPT_ENABLE);
 }
 
 static void ufshcd_configure_wb(struct ufs_hba *hba)
-- 
2.48.1

