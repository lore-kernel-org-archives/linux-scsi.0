Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B1207DEE
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289963; cv=none; b=PBNyagMtPh+WJdjJgYiomLsS4NQTEmZ1oCt5NpJTkSQrCy9mqszshauwbNg0ECwg6mrDarETH0cuDI2GZlD4qoJlZes4+it62KNNVLyBcX6tTv5jvYHo3+TsmTWdnIPqMDXyWQvj6dovFtK9dcxBWJLn5kZvJYjpwy9xaks6jnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289963; c=relaxed/simple;
	bh=SXYnZvNPIzsXsO2tVyFkExL4bC4deQA9hrUDoh0d2H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt7yIXar0dgHSCH5BdpX6ojtfQgTCN9c3VK13s9K4A9tqaDSmrguwGnYceu5pbEsL0eRrgNz8n6L+0I8IINa2ExdYudV1ttu4irZwnl97Iz815Ocah+Btiu5WPDja40CdHcueSTsTDKbujnFVj5k/fJ0M2oli48Cg5dtZFVrGNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NV9w9pTZ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NV9w9pTZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289962; x=1784825962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXYnZvNPIzsXsO2tVyFkExL4bC4deQA9hrUDoh0d2H0=;
  b=NV9w9pTZSE2APDAl/QeGnElX3riasexvsBne8l0F6aB+hATlxb4WvruJ
   EczP8843lxpYXCZIefP4fNVU0fgvt+HatsTC5hXTNuvlJNXwe1FxSPf9R
   wRtczBG4J3kz20vHN/fWBV+JCR1v9vnfcWI/E516iPawDfHZ0UK+18JpB
   BpLQgc0CIS9rNoduKP/pyJRe+qMTP9sWtXDhHqiQEu6c7mHWwM6faSQNu
   69mzcH9jbLOu1oFB1IAnuJ4CYSCbpol6cJ51cTyPbsrrcIBI9UXM1IgcB
   FBJjROJeKnQZhoQ0CQUrSeNfyPAaFImsKUPkrmQz26YjGqOi0/yqpOk01
   Q==;
X-CSE-ConnectionGUID: 0wq8//G4SKCHXqdpXzWBSg==
X-CSE-MsgGUID: Pp+QVF6tQSyIuHw7veqX5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55735014"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55735014"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:22 -0700
X-CSE-ConnectionGUID: L4mcwJlSRz2AHliL79MMSg==
X-CSE-MsgGUID: oW5DKFLpQBe8msOZUO5FHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196733018"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:19 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 5/8] scsi: ufs: core: Remove duplicated code in ufshcd_send_bsg_uic_cmd()
Date: Wed, 23 Jul 2025 19:58:53 +0300
Message-ID: <20250723165856.145750-6-adrian.hunter@intel.com>
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

Make ufshcd_send_bsg_uic_cmd() call ufshcd_send_uic_cmd() instead of
duplicating its code.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/core/ufshcd.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2fbd44514308..7fb0ca3576d4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4405,28 +4405,17 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
 	int ret;
 
+	if (uic_cmd->argument1 != UIC_ARG_MIB(PA_PWRMODE) ||
+	    uic_cmd->command != UIC_CMD_DME_SET)
+		return ufshcd_send_uic_cmd(hba, uic_cmd);
+
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
 		return 0;
 
 	ufshcd_hold(hba);
-
-	if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
-	    uic_cmd->command == UIC_CMD_DME_SET) {
-		ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
-		goto out;
-	}
-
-	mutex_lock(&hba->uic_cmd_mutex);
-	ufshcd_add_delay_before_dme_cmd(hba);
-
-	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
-	if (!ret)
-		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
-
-	mutex_unlock(&hba->uic_cmd_mutex);
-
-out:
+	ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
 	ufshcd_release(hba);
+
 	return ret;
 }
 
-- 
2.48.1

