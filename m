Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C9D1DDC35
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296383; cv=none; b=HZAL3WzuA5B9Sxj3OFkZJ/gJbPboEy7Eu8upcS1N7dZ41HQfQs3eGPSRUnzqRGoDzW5k7Z/OXOgmlmTf1Cm8n9Yq2gOpaHT+PcRlw3deWP8jqM8Hknzcvb95mzUzekLwK9QUdowE23FphYXhu7Jp0x+bT4VnPYiGGP0cRmZJWCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296383; c=relaxed/simple;
	bh=Zx6l1s6p/ZL1s1brJpx955kuNx+DbSMKT3CdYKQRRnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCGkckF5zu/7y3dqNq6pUppdDRwPc8xa/fnN0HfqMT8KUuYTY7VMzxDHtqzTUvs40ZtVBGYPY97H8z3HHVvG4I51eGiirIUQwJHxQhj3fgckBzZQ/1x4dYBDNnB3FRbpxVyVGfn8SjdR1hRP7qIhiysJPbGHWTkLdGCrAaO8FgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLfuems3; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLfuems3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761296383; x=1792832383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zx6l1s6p/ZL1s1brJpx955kuNx+DbSMKT3CdYKQRRnI=;
  b=RLfuems3UeGvTNQuSULP64jfoChEWP1rUOEpojSIbmF6spmguHlCQ0j1
   EU3yD0VhRQlOKJLJcESYxuA+6DRUcRcZdJAfNeXgGvF6rKBNpOx4IQYVh
   LP4MqPe+jvcLqWpL+88uSrv7NX9Mk8eH30klC0CsDz1nqjGyebahxFrcc
   9sn/zIRRvcwQ6spVEneOhHzflIdp0qodD/t4fvxQUcZGTjhFCxKabuVE/
   J3s4G7fWpicRGKoR4iqO70a5kqAqK5TABtfSss4PDXkMJDepKTvBWBm9J
   HgQbSF4Si/HQ6oaeitWoMDspQk5+j8gi0SCceqUOHW2eJjBEvwYbLWgA9
   g==;
X-CSE-ConnectionGUID: R/4yOEVSTmuJYjPgT+TCVg==
X-CSE-MsgGUID: 8YGg6QlpQrCLqVrYLJ9MkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80910805"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="80910805"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:43 -0700
X-CSE-ConnectionGUID: HwfZF9kvRVKlVuBPH4RBjA==
X-CSE-MsgGUID: raSxQL0gTYKlVlnHST7XHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="221583398"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.43])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:40 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 4/4] scsi: ufs: core: Fix invalid probe error return value
Date: Fri, 24 Oct 2025 11:59:18 +0300
Message-ID: <20251024085918.31825-5-adrian.hunter@intel.com>
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

After DME Link Startup, the error return value is set to the MIPI UniPro
GenericErrorCode which can be 0 (SUCCESS) or 1 (FAILURE).  Upon failure
during driver probe, the error code 1 is propagated back to the driver
probe function which must return a negative value to indicate an error,
but 1 is not negative, so the probe is considered to be successful even
though it failed.  Subsequently, removing the driver results in an oops
because it is not in a valid state.

This happens because none of the callers of ufshcd_init() expect a
non-negative error code.

Fix the return value and documentation to match actual usage.

Fixes: 69f5eb78d4b0 ("scsi: ufs: core: Move the ufshcd_device_init(hba, true) call")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	None


 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3704f51dfc65..36bed9dbd7e3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10658,7 +10658,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
  * @mmio_base: base register address
  * @irq: Interrupt line of device
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success; < 0 on failure.
  */
 int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 {
@@ -10899,7 +10899,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
 out_error:
-	return err;
+	return err > 0 ? -EIO : err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
 
-- 
2.48.1

