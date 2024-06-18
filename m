Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DB750282
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 07:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718695993; cv=none; b=qE6zo46jvn7dth35Ii8TEsY4yzxnIT4ioVHD7TuGmr0hOKOOfwlc3SPaojkVTsRvCjTGh3ygSJvKDqFnlmngamkiHTVM32gl+r8Aereu3km8VvZNXrSciaYMZZ24SoQ15WDPtOUdLkTTO2yM8HcmUx19GxcJVO3ijSR9kfEPxIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718695993; c=relaxed/simple;
	bh=i0HSitmeC2+l7HuX6TTLs3TT0SH4T4i5/u3h5ChVypc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m++73ukcQmuNblLu5vs1QfPDyKZXpOwhoTrXZCoXoW9jh8GnKKLsTZFSe0VB8A12ejlBgVRtu355PzPprVlIgeZoCfX+NtMyGlSucIZ9FQ5yp+ecYTWS1NOi0aCuJ+oYETc3+ChP4f50N5VXeBzlgUrd6g6tHHJoNQjQS7iZe5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V9SvER8D; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V9SvER8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718695992; x=1750231992;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i0HSitmeC2+l7HuX6TTLs3TT0SH4T4i5/u3h5ChVypc=;
  b=V9SvER8DCHF8LcKyjzyAlspWKkx6BADkG4fZKZEqLIxhoLqFH4IO1PwA
   rzrfRhvZO+NbvaQTvlc57o7vXClI7TPS9uM1kBmD0VrUAeSoZqMVbjbIw
   gIAH5DKvIGD2VcmG3HQjJenD+K4MLNk7VKnDXXEQL4z2fLMJVDhtLymaj
   JzYtC0KV2F79/bFO4AkFkOIuhbxqs8fSX16ogPj1P4JJXKGRZc/oQYm+P
   8gcP9Al/0wR7arxV9nTIqZs6GKw/GHNPmZot+e8qStMszehO511zv8Vcy
   ufNEOIFNTcyXdSE3E1OVsF4ZyoWsK8uoCy3xtg5ikNzyMMr2P33nGejKw
   g==;
X-CSE-ConnectionGUID: KHhDPi5OT+iUMgLbhh6gMw==
X-CSE-MsgGUID: 31EdCMw4Ri+0TDf0Y4YOqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="15697396"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15697396"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 00:33:11 -0700
X-CSE-ConnectionGUID: Y8b/FYZ+S/iOlk97hz6VEQ==
X-CSE-MsgGUID: FlUZn1JgTBmKtfaIkzGwSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="41553715"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.246.41.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 00:32:12 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Panther Lake
Date: Tue, 18 Jun 2024 10:31:58 +0300
Message-Id: <20240618073158.38504-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Add PCI ID to support Intel Panther Lake, same as MTL.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 0aca666d2199..ec675a13c73e 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -602,6 +602,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.34.1

