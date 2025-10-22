Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C752EBBA9
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156522; cv=none; b=s4YY15r9+48j37XX1pK82pgsH5845nMReSAgDJ5f0uHFEG1vETYhduLmGgiA9xA4OJoR4+XlvYz3Y17CWtTVnYCQTT1mWp+3rxIM5GLJkKgPTTbTupQaT12oLAo+dQM9aCWE1EKaHitYI6OZTqiO2f5Ja9Pv2LZAtkgFnhhNs7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156522; c=relaxed/simple;
	bh=jYrst/nVrvfaGQ7sTYVuQnk/pa6PLfGnWW6Y17Hde08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8pHc1wslMNb+R6szM8ci14/S+Xo+HW3ZO3hBCa6RW0ar0cuKY67fY5v3CgZyAlDXQ8kcXrNS65lxgyZJpcEByXGLM850yH9qHfT+SKM2Bu1V3O0OnNWoJERvM81ljKGlci23tC38tIYHCFJybrHK1VKgNvgcrCUnBusm82NpD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zrp8bt7u; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zrp8bt7u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761156520; x=1792692520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYrst/nVrvfaGQ7sTYVuQnk/pa6PLfGnWW6Y17Hde08=;
  b=Zrp8bt7uJxw/UB4VZaeK2+vgHabBKxqEEKDZye5BF2ugCOyq8ndP0tiD
   7BWCA+RLOwjCQJql131OkxM7wDHpZv/KJLBhcGNoJwKMbIEGB+HJOsXF7
   zYdDhPZ6vnvz+37sIPkPhHMmuKhLriPgLekx8Bxgwrv2oNksQ4dovj3Lr
   2wwpG6upAhX71Qdr7/P8WegoaO/b0d2nembeoMxbg2ZAferB5utddG2P/
   0W6w8QFDWXQu/Ri6AnP6glhKqQXhisEoNWG56lDWeC2eRACNQ3nTkq2hR
   iM0SXl0rrL1Rtz9cz69K55Ng7EjLMrOuYDVhyOzuK7PwQHe2bAQgwSQZy
   A==;
X-CSE-ConnectionGUID: biNTbb5TRuW/DfpYMGcE7A==
X-CSE-MsgGUID: HqyqZMEiTYqA4CJLOa1bWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80753250"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="80753250"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:40 -0700
X-CSE-ConnectionGUID: UwEwqLLlQKioBYlJ+l0DGw==
X-CSE-MsgGUID: u4PoULJySK+mGakavkwwAg==
X-ExtLoop1: 1
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.4])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:39 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] scsi: ufs: core: Fix invalid probe error return value
Date: Wed, 22 Oct 2025 21:08:19 +0300
Message-ID: <20251022180819.86180-5-adrian.hunter@intel.com>
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
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 632b508d0edb..eafff8cfb2b6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10662,7 +10662,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
  * @mmio_base: base register address
  * @irq: Interrupt line of device
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success; < 0 on failure.
  */
 int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 {
@@ -10903,7 +10903,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
 out_error:
-	return err;
+	return err > 0 ? -EIO : err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
 
-- 
2.48.1

