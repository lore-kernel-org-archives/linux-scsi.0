Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B391306B17
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 08:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296376; cv=none; b=SvuQRrp8yF5PcpTItXL10o6Sn06XmSxVeDfxGsD67qZ/2lcBAposHkz/NqQ7dZbReCpO/a5wu7TQaNfDjgwobCWH7UiWR1cSjkSbBmoXnHIYA0PEYs1z2zUoPojGGVxHA1kUH+V874Tri8KEXLa4KhyvYVPhac5SGV4NCDt9iYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296376; c=relaxed/simple;
	bh=teZLq23HaTo08w7cPVPa5KSA1EhFhUsEm0zbN2BuMLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJsv6TGCQgMzTUyunWtf//75AGqmembsnTiho8NZostxLeZfEeWofkiw2rC92yWUDLE30xVRNnJT7lBf1Ri0WfNgcfesKxO8Xzto1LWZlVSf7dUhNHqmwh1ZU65jy6dU++QLB+rfQHswRS6+n19bePVEyGGpBC71v2TrWeo24GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FqZvKBbp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FqZvKBbp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761296376; x=1792832376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=teZLq23HaTo08w7cPVPa5KSA1EhFhUsEm0zbN2BuMLg=;
  b=FqZvKBbpBKybmPaBZIu2ATgBgWt9v1ifqLEbYzhJoegbutNOVEpUG9V+
   Izk/+WBwYOwcPRcY4Aor+bPRDRuuL+EncxNOI/6Tvbl1aYdkdbDK1dIb6
   mbg8nhanSbDPapvIv3Lepm3TjReAfo7NuAihmGihe0xC6qQzOTJlaA458
   +7gr2QHbqi2XP9i4t0BixKLsq/C3Ko8ySCzPJEA0II5b7RCFWSk/WgrNj
   JeAuIdXzNETuxyyFvssHlTSgWlge5jZOUpW06JiB3azVtrPHaDVb1Uc6r
   dwEN09+YXV9A3Yh7o4wgiMB1KphKK1cY5HSTkUL277NebZKqrKK+JRQSR
   A==;
X-CSE-ConnectionGUID: tdtsEGSaSlyQnzZAZYaZoA==
X-CSE-MsgGUID: OJMc7EXkTA2bB/1GFZjKCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80910796"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="80910796"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:36 -0700
X-CSE-ConnectionGUID: stoTMco0QwmSe2cXKFDs0Q==
X-CSE-MsgGUID: QfGAfjcMT+qp26YFBWBXTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="221583363"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.43])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:33 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 1/4] scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
Date: Fri, 24 Oct 2025 11:59:15 +0300
Message-ID: <20251024085918.31825-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251024085918.31825-1-adrian.hunter@intel.com>
References: <20251024085918.31825-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Intel platforms with UFS, can support Suspend-to-Idle (S0ix) and
Suspend-to-RAM (S3).  For S0ix the link state should be HIBERNATE.  For S3,
state is lost, so the link state must be OFF.  Driver policy, expressed by
spm_lvl, can be 3 (link HIBERNATE, device SLEEP) for S0ix but must be
changed to 5 (link OFF, device POWEROFF) for S3.

Fix support for S0ix/S3 by switching spm_lvl as needed.  During
suspend ->prepare(), if the suspend target state is not Suspend-to-Idle,
ensure the spm_lvl is at least 5 to ensure that resume will be possible
from deep sleep states.  During suspend ->complete(), restore the spm_lvl
to its original value that is suitable for S0ix.

This fix is first needed in Intel Alder Lake based controllers.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	None


 drivers/ufs/host/ufshcd-pci.c | 67 +++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index b87e03777395..89f88b693850 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
+#include <linux/suspend.h>
 #include <linux/debugfs.h>
 #include <linux/uuid.h>
 #include <linux/acpi.h>
@@ -31,6 +32,7 @@ struct intel_host {
 	u32		dsm_fns;
 	u32		active_ltr;
 	u32		idle_ltr;
+	int		saved_spm_lvl;
 	struct dentry	*debugfs_root;
 	struct gpio_desc *reset_gpio;
 };
@@ -347,6 +349,7 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
+	host->saved_spm_lvl = -1;
 	ufshcd_set_variant(hba, host);
 	intel_dsm_init(host, hba->dev);
 	if (INTEL_DSM_SUPPORTED(host, RESET)) {
@@ -538,6 +541,66 @@ static int ufshcd_pci_restore(struct device *dev)
 
 	return ufshcd_system_resume(dev);
 }
+
+static int ufs_intel_suspend_prepare(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct intel_host *host = ufshcd_get_variant(hba);
+	int err;
+
+	/*
+	 * Only s2idle (S0ix) retains link state.  Force power-off
+	 * (UFS_PM_LVL_5) for any other case.
+	 */
+	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE && hba->spm_lvl < UFS_PM_LVL_5) {
+		host->saved_spm_lvl = hba->spm_lvl;
+		hba->spm_lvl = UFS_PM_LVL_5;
+	}
+
+	err = ufshcd_suspend_prepare(dev);
+
+	if (err < 0 && host->saved_spm_lvl != -1) {
+		hba->spm_lvl = host->saved_spm_lvl;
+		host->saved_spm_lvl = -1;
+	}
+
+	return err;
+}
+
+static void ufs_intel_resume_complete(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	ufshcd_resume_complete(dev);
+
+	if (host->saved_spm_lvl != -1) {
+		hba->spm_lvl = host->saved_spm_lvl;
+		host->saved_spm_lvl = -1;
+	}
+}
+
+static int ufshcd_pci_suspend_prepare(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!strcmp(hba->vops->name, "intel-pci"))
+		return ufs_intel_suspend_prepare(dev);
+
+	return ufshcd_suspend_prepare(dev);
+}
+
+static void ufshcd_pci_resume_complete(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!strcmp(hba->vops->name, "intel-pci")) {
+		ufs_intel_resume_complete(dev);
+		return;
+	}
+
+	ufshcd_resume_complete(dev);
+}
 #endif
 
 /**
@@ -611,8 +674,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 	.thaw		= ufshcd_system_resume,
 	.poweroff	= ufshcd_system_suspend,
 	.restore	= ufshcd_pci_restore,
-	.prepare	= ufshcd_suspend_prepare,
-	.complete	= ufshcd_resume_complete,
+	.prepare	= ufshcd_pci_suspend_prepare,
+	.complete	= ufshcd_pci_resume_complete,
 #endif
 };
 
-- 
2.48.1

