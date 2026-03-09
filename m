Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCEF36F415;
	Mon,  9 Mar 2026 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773046715; cv=none; b=MOfBttk9qPAlDZngvemdIGXd96tAyBYyI7sr7R7hgdMrGQV6juCCfnHdAyvekRUvfCogVmyusr5A4klCuJtYuNCfi13+2bDU67+Z1cyQh5kWR7+N0LQQoOQgWo1Xb13PcseMCavV5cz+2Lx6LvKjCsrAl2W5qx7kjXKDO7qK7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773046715; c=relaxed/simple;
	bh=2YL5m0nJUkBei4vZwMohzbVtCs+2Y2OUhORJZtMrNP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N+FBJO+euLcnwUobX4WLDeV8Hlg+vAMVIYUUGDm0gQV/wstpTcxMNElo7EF0XFuX95NcFDRcuMIcfzAa//t+g7i+mYGu7eCQIGV0KOn74a23hfUFi4JiGDcJmG1K1aeyTbtG5XkbSTlaMoeqjD1kIRTEvE9hfJa/BdjkLawy+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KRFpIgKI; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KRFpIgKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773046713; x=1804582713;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2YL5m0nJUkBei4vZwMohzbVtCs+2Y2OUhORJZtMrNP8=;
  b=KRFpIgKIvlpYCaxVeolx5Am+c5zFMsuWgbKREhzYuOr0u83FD5hYB5ZE
   HVbrHshwkOT/3/AK5HKzwVubWfTcIwXSCb0+M47gcL5gnz0tN4CpDHBqT
   kDt5w1+oepL1QF8GTqMpATfNJRWjVPpnVzOtRmW3MhzYdFmtXOXACSq7b
   isvlUg8DuZ7HXRuQS/N5HEl7vUjjGUilNGWKXjwCKFxs0wXjo8LW8mNoQ
   62Jzo6qlJdiQkiB70NL4ppZkOxAn+gcaMiPBnA7nuKWEUgRudkPEHvcgw
   zsser2RLzs7X8vhBNg+XR/7DzoM1UPAblW3twCI+H2kE/xAhtXtodUHPB
   A==;
X-CSE-ConnectionGUID: hJUl0JZBQnyfNj+C5kBjfA==
X-CSE-MsgGUID: KOmUVqgKSMuhfDtVgO0wLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="77916010"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="77916010"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 01:58:33 -0700
X-CSE-ConnectionGUID: ByRcv3HbQmmLYkCN/ggQZA==
X-CSE-MsgGUID: v+2QP5JVQuudSVXwU1FBkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="216225887"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO ahunter6-desk) ([10.245.245.128])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 01:58:30 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Nova Lake
Date: Mon,  9 Mar 2026 10:58:15 +0200
Message-ID: <20260309085815.55216-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Add PCI ID to support Intel Nova Lake, same as Intel Meteor Lake (MTL).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 5f65dfad1a71..63f6b36b912f 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -695,6 +695,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4D47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xD335), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.51.0

