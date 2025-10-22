Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC002E228D
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156518; cv=none; b=RMHkLNPWjb9DHA/rZKDW9t48gGaJtHlwJ3sokzdZC9DI562f6N0HajcdCy5MUX98g+eDzZqriyuNd8L8pXiolZW4hIaR0bGX2wto5KA6+/FxkoVF50/a7g5eIfwA5Av7XYV4Jb2kkSZukqOtFKDtLaoM3CzMKZmUFJY9xsLXcpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156518; c=relaxed/simple;
	bh=gnWY6CIHQRD+2Iv/y8kB+cCA6JrhgGmXMGeBrtILFdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Db0/G27sOZpipNQf9wvazAU2Db0nmd2jDiIudl5M3Xk7LJ6h49AofkSxJ9+1MlBxSDRl0ZJjLvFTZxJWac5eKZSL6KMoCL5nNsfqxmx8zORFpToyZOMEiJDbyymxNxElshjdovV5eO1BccHHQXELiMRmPkEoo3hzF5rMP5sHPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RbgGkQgl; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RbgGkQgl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761156516; x=1792692516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gnWY6CIHQRD+2Iv/y8kB+cCA6JrhgGmXMGeBrtILFdc=;
  b=RbgGkQgl2Bk9ofvRIIX89WmbA7NQ9KIVM3bZWhjgQR+3JWb7H+smyDEf
   IfDF1mfGUQekdVZmIMYdsMuor0FF6A5DGkYCekLyvamnsQC3DerZsg+K4
   l1JZMlT2PXKnIB20nnQN4pdQhwgmIeRytpoK6g5mjM2X4q3X/Qd/sL+vP
   OuchstgrO5UyhRyU4vHA/uDR0iliwnXxoIf0Y5mUwsv0d2IlrXwAyj1zn
   achuIO8thz5JPGBwIofQ1EvDZCLiJMk966HBQ/x79xkqWWAWEIF8KpnJL
   h/zmt1WD68FycFV54lF+E3nOQE3T54bH7cfjvp6+0xIfjLHFTw1fBxa7p
   Q==;
X-CSE-ConnectionGUID: BRuWH5FrSSGPqP/4SSVZ9w==
X-CSE-MsgGUID: LYw/XaU9QEm6JDmED1HgyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80753234"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="80753234"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:36 -0700
X-CSE-ConnectionGUID: aoS7xCf+TOSPiE5tqZMyjw==
X-CSE-MsgGUID: DPUFlInwSaid4PEF3HwNSw==
X-ExtLoop1: 1
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.4])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:35 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] scsi: ufs: core: Add a quirk to suppress link_startup_again
Date: Wed, 22 Oct 2025 21:08:17 +0300
Message-ID: <20251022180819.86180-3-adrian.hunter@intel.com>
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

ufshcd_link_startup() has a facility (link_startup_again) to issue
DME_LINKSTARTUP a 2nd time even though the 1st time was successful.

Some older hardware benefits from that, however the behaviour is
non-standard, and has been found to cause link startup to be
unreliable for some Intel Alder Lake based host controllers.

Add UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN to suppress link_startup_again, in
preparation for setting the quirk for affected controllers.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 include/ufs/ufshcd.h      | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ca27de4767a..632b508d0edb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5066,7 +5066,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 	 * If UFS device isn't active then we will have to issue link startup
 	 * 2 times to make sure the device state move to active.
 	 */
-	if (!ufshcd_is_ufs_dev_active(hba))
+	if (!(hba->quirks & UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN) &&
+	    !ufshcd_is_ufs_dev_active(hba))
 		link_startup_again = true;
 
 link_startup:
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..4157fbaebff6 100644
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
+	UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN		= 1 << 26,
 };
 
 enum ufshcd_caps {
-- 
2.48.1

