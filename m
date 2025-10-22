Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CD22EA729
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156516; cv=none; b=s5k7ZYQs4IOYsFKXEc9OxSq9H/cU4ZER6EMqucHDBF+cLS4uw3Ik5rCqSzx7f9qzJ4RSHDvLee1cPLQnJcv9+urS7xxKNHnGDn3OD+M3v8bOh+2V7RucrRLqYUR0TNoUnny/Y6MjtnmxU3ikI1lV177vnJWDKujMsSkmmPzGIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156516; c=relaxed/simple;
	bh=3xiQZuQV36hMmV461FCS9d3zH8bf7J3mrnACS69C974=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec4mkU6LzurKsXgldZ18SJ7FfvGD2GDQmFCSgOdGYTucvTBc5iBIKV++c8C01nrzgecXTFzw+MAHzVE8L3xEKoFP+d8t4BOFYjBQ6+DLxDlnKOvSP+csyRqPDm/y0d3YSOmWQJKKxcT2uwBr7sfFb4yokEiOU64jLJ02N2cdr5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jZ1KLt+Q; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jZ1KLt+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761156515; x=1792692515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3xiQZuQV36hMmV461FCS9d3zH8bf7J3mrnACS69C974=;
  b=jZ1KLt+QpvQP8/ILQaiJsT+bwFIy8dmZgOv1UCUcxxQV+30H1fHI/wP0
   5iemsANGqhdj5b1m50O7mtv0p4dgEXFX2a+vhqgixsXFBWM8o01ivWN+n
   MA8SzQ9A18P0FT2A9jf2cBZbNGwHUyZdVIm5gB061JUuWosbp2rNbpW5k
   UYNQ9nGYZQtYf2O3XYBh9Frl1Vx5dNYD+bZvE578Bhr9ekJ62UeRHgpjm
   jrsLYyhCPL0S2hanGRU/nz3e6OVNeg5gz0CAGa72cg28GbzpTlim5ZVYZ
   teA5ccMKKhNPk2bFNeshIK5N+aJLve7YV2IrcdVZgdXK7G8+Xrg8ch+6k
   A==;
X-CSE-ConnectionGUID: XiHY+guhRRmoVk6dNQoCqA==
X-CSE-MsgGUID: 2XFwdAkxR++J2GsspnnDTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80753232"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="80753232"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:34 -0700
X-CSE-ConnectionGUID: euowFZIHTLm1CViM7+LxPA==
X-CSE-MsgGUID: k1h9sLenTC2jvjgwyAuAzA==
X-ExtLoop1: 1
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.4])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:33 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/4] scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
Date: Wed, 22 Oct 2025 21:08:16 +0300
Message-ID: <20251022180819.86180-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022180819.86180-1-adrian.hunter@intel.com>
References: <20251022180819.86180-1-adrian.hunter@intel.com>
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

