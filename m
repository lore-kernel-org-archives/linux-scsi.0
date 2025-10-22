Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20782E1EE0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156515; cv=none; b=fFkADp9BSm5pBbLfVxdtnVuT3SjX+3pJ0/l6LZFTNTrjInn+4rrTnvdXLTZePryR1OIVSJbZX/RbeWgXDe+yGtfNd2BqaOcXg7t8nGndv0MLQ8HxZkYmNIMpNWT4MuFfmRwPcoAwwWTNhHBMzaCpWYaJVLTCBzv3WR5s5ZkgwZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156515; c=relaxed/simple;
	bh=6gcsdI9q+bUIFUTDrIY6mY/Nxa71x3R8kxNhcHp2KhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B+2tECi/KFFPGv8jFDWr4aU/d+4dVvna1JKTBpjteOjyTp51nKT0uQwO8ThcX1Kv4L5/vQjwmpHPJaQywr+HG4A2UwLMS9mdqHqp9pFLWUfqgZyb2+wLCMFrp6fBo9Ab7usFwNQ/4Qs0X//wAWJdV1JcfGC9tnMWzb+E/UawLi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CvHuEbYR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CvHuEbYR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761156513; x=1792692513;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6gcsdI9q+bUIFUTDrIY6mY/Nxa71x3R8kxNhcHp2KhI=;
  b=CvHuEbYRG/4vIsIGa4Se+SgjXU5WiZ5Sg2cIOH3dyRgljRNsqbmJ/Fwj
   xnI209Ip3TdzP6w6iYWCc1WP4H0Zq/RoDq3aDPrrYCf1oTAO2eY3gACWR
   zKhL2/FPdHvEO+BvsuudTVCeEXPpRzwcOYTz9PKRrXJTzWKTTiLDrSK7b
   LKqxFU4uU3rOA99CPXr7ppEoCir7H6SqgOPXiJ1R0IRFTyjSTD1Q3oTPX
   B+pPginZ0xdMbTm0v/lRrxVBgRFN8oZdRaEDQbtpr5NCH5Z9ex0hbrI5/
   XBaqfEcRxVDRCEPs4pVYveWaIm2BHwqnDEhyh/o9ZQQCmXBpy08bON9lk
   g==;
X-CSE-ConnectionGUID: ntJ6WxNqShy9ZJHbYO6S1Q==
X-CSE-MsgGUID: xAGnTDNTSvKnU/AXIVr4iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80753229"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="80753229"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:33 -0700
X-CSE-ConnectionGUID: ZNhebiSaTmO4FBB51Ko/Fg==
X-CSE-MsgGUID: 7ibnoJ6oQZiicf4asEHSRA==
X-ExtLoop1: 1
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.4])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:08:31 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/4] scsi: ufs: PM fixes Intel host controllers
Date: Wed, 22 Oct 2025 21:08:15 +0300
Message-ID: <20251022180819.86180-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Hi

Here are fixes related to power management on Intel host controllers,
primarily ones based on Intel Alder Lake.

Patches are based on 6.18/scsi-fixes


Adrian Hunter (4):
      scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
      scsi: ufs: core: Add a quirk to suppress link_startup_again
      scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN for Intel ADL
      scsi: ufs: core: Fix invalid probe error return value

 drivers/ufs/core/ufshcd.c     |  7 +++--
 drivers/ufs/host/ufshcd-pci.c | 70 +++++++++++++++++++++++++++++++++++++++++--
 include/ufs/ufshcd.h          |  7 +++++
 3 files changed, 78 insertions(+), 6 deletions(-)

base-commit: d54c676d4fe0543d1642ab7a68ffdd31e8639a5d


Regards
Adrian
