Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C043537EE;
	Thu,  2 Apr 2026 06:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775112017; cv=none; b=Vz2zz7TQLVslHnfh1ZJHdcAu+h76SPaInY3xoCWoiD7/IK5Arf/MlDNrQCDZ5A9U2a2vR4ApCk1XsRFKu4SxQk+h0dCSkTonyaehAzFOM8eBPH7JI2GfKi0jW4USI7hjIu1WFqiRZkneIzMTIkVStmsk9OWWtlv73H95BEj+7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775112017; c=relaxed/simple;
	bh=nMHiBk8YsGZdSOhs/e+pd2j2up7vFQDXbVZuUD7wYMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kyi4pdpGJIzDiqItHYOSbQVQun8vykF8CI0uNWZWFUw48Q/ZNW/Cu7NpFmIzjI6KQtUzDkuoanwIgxiytSNHSw4LtELN+KVsgAS7D0vtq42w7d1UJPxJ+NFtFu/8T5ZsUyjP/Q/fT9tI2mMNSADGFqU9zzo1pIFmOeThtxv9a+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5JEAjkP; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5JEAjkP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775112015; x=1806648015;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nMHiBk8YsGZdSOhs/e+pd2j2up7vFQDXbVZuUD7wYMI=;
  b=E5JEAjkPYOaWRcP+abvS+isPiVkqbqYfDCBWnSSdgoiX+ZQDbfGFzrLB
   Yhl2faMyXgq9nd+rsj+aY4bu0/uociVtouN46fVGW6VNyCprXdjK5nG2M
   7wpsjHwJ6fRgrPHSlycTa/GFSKoLC6lYfMeValMmJ+ORDK0mDoIgZvgGo
   k/c2hZnQwmBJOPveCVdBK2QEYYs9eJgIB4zeHV7oARWkDdo8JIdG0K+0o
   LRtfyrEOUpAikNR5sVnkeUZ9JuMJTWAKv9nVcLjAhiHnPQNghm5nBy7La
   JnPm5GhHXMBEtEnl4Ixv5GumD++vscCabv9apL+J5m/qUmZVgtGsAJWl1
   A==;
X-CSE-ConnectionGUID: 3jVgXlxcSIWU2DLMV7bRJg==
X-CSE-MsgGUID: GWzXMMntSKCDFhw35C8Yzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="76129969"
X-IronPort-AV: E=Sophos;i="6.23,155,1770624000"; 
   d="scan'208";a="76129969"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 23:40:15 -0700
X-CSE-ConnectionGUID: qEha6gciRE26/o6GortwCQ==
X-CSE-MsgGUID: +GVL4IcrT8GA1V9M3ttOTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,155,1770624000"; 
   d="scan'208";a="231297103"
Received: from haoyao-desk.bj.intel.com ([10.238.153.154])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 23:40:14 -0700
From: Hao Yao <hao.yao@intel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao Yao <hao.yao@intel.com>
Subject: [PATCH] scsi: sd: infer lbpme from VPD B2 when READ CAPACITY 16 lacks LBPME
Date: Thu,  2 Apr 2026 14:39:51 +0800
Message-ID: <20260402063959.4005814-1-hao.yao@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some USB-NVMe bridge devices (e.g. Realtek RTL9210) correctly report
UNMAP support via VPD page B2 (LBPU=1) and block limits via VPD page
B0, but fail to set the LBPME (Logical Block Provisioning Management
Enabled) flag in the READ CAPACITY 16 response. This prevents the SCSI
disk driver from enabling discard/TRIM support.

Fix this by removing the early return in sd_read_block_provisioning()
when lbpme is not set, allowing the function to read VPD B2 regardless.
If VPD B2 indicates LBPU (UNMAP) support, set lbpme so that
sd_read_block_limits() and sd_discard_mode() can properly configure
discard.

Signed-off-by: Hao Yao <hao.yao@intel.com>
---
 drivers/scsi/sd.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 628a1d0a74ba..ba653988dd13 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3466,9 +3466,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 {
 	struct scsi_vpd *vpd;
 
-	if (sdkp->lbpme == 0)
-		return;
-
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb2);
 
@@ -3481,6 +3478,20 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	sdkp->lbpu	= (vpd->data[5] >> 7) & 1; /* UNMAP */
 	sdkp->lbpws	= (vpd->data[5] >> 6) & 1; /* WRITE SAME(16) w/ UNMAP */
 	sdkp->lbpws10	= (vpd->data[5] >> 5) & 1; /* WRITE SAME(10) w/ UNMAP */
+
+	/*
+	 * Some USB-NVMe bridge devices (e.g. Realtek RTL9210) report UNMAP
+	 * support via VPD B2 (LBPU=1) but fail to set the LBPME flag in the
+	 * READ CAPACITY 16 response. If VPD B2 indicates UNMAP support,
+	 * enable lbpme so discard can be configured properly.
+	 */
+	if (!sdkp->lbpme && sdkp->lbpu) {
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "LBPME not set in READ CAPACITY 16 but LBPU set in VPD B2; enabling discard\n");
+		sdkp->lbpme = 1;
+	}
+
 	rcu_read_unlock();
 }
 
-- 
2.43.0

