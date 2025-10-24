Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCE5307AD9
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296379; cv=none; b=ONK9DjSepLhtzPzj2ML5vGU26g+sR9AtDbjWxs1lL+vQXanNSSSxpzjtT+EDNATH1jfN9HeTIzPuo7kf6XLEjt8hjm+990WFJKKBAeJgYZv+WPKGfohFfE3kOwj+bhr1t45FKfWLEEQ4Vq361JDnykeBe07h0y9iANrld8Lbaj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296379; c=relaxed/simple;
	bh=WZefDi8YgSbk4OXKRYHwtraMFruL2Kn7YzK3lEIBxJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2/IHtmwFJHJbQ5LBCdpLF1eaB8V9RUVRTZtYsAs0EZ+GjztDITEsLg0S5qX5qre/yIsIgA/EULtydPFKCa25yp0O0FXoWXqlL77nPaGjQwkxITpINcfTMYtNakUaanOKehn7qVBOqRAnHKAulrycucgaYCLHCxss7j4hF0Q2QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LbJKlOpD; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LbJKlOpD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761296378; x=1792832378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WZefDi8YgSbk4OXKRYHwtraMFruL2Kn7YzK3lEIBxJQ=;
  b=LbJKlOpDE6lGLJEU1E8P1XGIU+PpQYCmJG8VEWcBX/elIySVaC1j3Y9K
   EGm5UA0Eck6tzwotEh0Cn043QxHpk1f0NkRKcnrBJN0/LqyIQQbYwQ2Mv
   bLG4yziXDqADqvSX8Xj28p8HU0JsLtd77wX7K3K98AysBKvZPicqDQYKh
   i5N94CssLRO5GjYC41kyxQC9lcFx+VVQtz/Qi3KOdoZe4Dcl6kA4RtkCK
   dgLNz4x0wvNMaJTxxqtkgjufbxlhOYCRw/0W53CBh2nEW33po0pzCYrVt
   9cAJezWE6FVNwFhDtKryJgauN4C2Kd0ww4G2PL0VB94RiFhp6X0ZmDM3x
   Q==;
X-CSE-ConnectionGUID: 9JtSVAYbQsGL+4tqECTaKw==
X-CSE-MsgGUID: wGRqb7QcSRaWLVor51NezQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80910798"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="80910798"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:38 -0700
X-CSE-ConnectionGUID: X0D12gHTS3CSoD+TzIhE7A==
X-CSE-MsgGUID: itVrFaVrRiuSye1BdSDEdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="221583373"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.43])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 01:59:35 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 2/4] scsi: ufs: core: Add a quirk to suppress link_startup_again
Date: Fri, 24 Oct 2025 11:59:16 +0300
Message-ID: <20251024085918.31825-3-adrian.hunter@intel.com>
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

ufshcd_link_startup() has a facility (link_startup_again) to issue
DME_LINKSTARTUP a 2nd time even though the 1st time was successful.

Some older hardware benefits from that, however the behaviour is
non-standard, and has been found to cause link startup to be
unreliable for some Intel Alder Lake based host controllers.

Add UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress link_startup_again,
in preparation for setting the quirk for affected controllers.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

      Rename from UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN
      to UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE


 drivers/ufs/core/ufshcd.c | 3 ++-
 include/ufs/ufshcd.h      | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5d6297aa5c28..3704f51dfc65 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5066,7 +5066,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 	 * If UFS device isn't active then we will have to issue link startup
 	 * 2 times to make sure the device state move to active.
 	 */
-	if (!ufshcd_is_ufs_dev_active(hba))
+	if (!(hba->quirks & UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE) &&
+	    !ufshcd_is_ufs_dev_active(hba))
 		link_startup_again = true;
 
 link_startup:
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..0f95576bf1f6 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -688,6 +688,13 @@ enum ufshcd_quirks {
 	 * single doorbell mode.
 	 */
 	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			= 1 << 25,
+
+	/*
+	 * This quirk indicates that DME_LINKSTARTUP should not be issued a 2nd
+	 * time (refer link_startup_again) after the 1st time was successful,
+	 * because it causes link startup to become unreliable.
+	 */
+	UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE		= 1 << 26,
 };
 
 enum ufshcd_caps {
-- 
2.48.1

