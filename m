Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB2275846
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755003792; cv=none; b=S+HbrSNKTQqN9pq3sD7GUnUWl9bhProzt5KtWabuazQAF+60i62H5R87t/VKLhHXH321mS4zhRaocvmQ1L/ob9zFDToNi3iWlDDYfnGi/nY2WN7imXaNHYVFHvbgfHxVDpq8VdjWSNkyXA21r1HMhbEZqo5iSQucU9J3FlNy8Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755003792; c=relaxed/simple;
	bh=XA7aptG4SF6cGYrDpDOW/ApMQXIMcJj60Eh2/gyROOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVodNpuHDSwPdqk3nfyjZbGtbp6ih9mGEhis/L2ndyUfAAwFiUY4nMkCvC+LYlWb41vZshhZQ324oc9pVC3+HRvd6XcbmFQw9nkU4AU+zhXZB9YqKDpQfFCM+YLzE7MfNMGwyhDZgH4nEbueZqsyr1W7LpLliD1xNe/BGozMXLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zy7OJPVi; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zy7OJPVi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755003791; x=1786539791;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XA7aptG4SF6cGYrDpDOW/ApMQXIMcJj60Eh2/gyROOo=;
  b=Zy7OJPViOwRlG5WJOTbpaG7qeia+HTDYzP5ZqXMID1szRYhIM9kA0/YE
   CTcJWx4XJxTiP9PRfDKJyuozFDSX4gsnAOJKdLPZrvG5DvIT+XI7x6nVc
   doyXkrYkqadx/5EfDsWZ56FdO6rm5RQJTltwPBCwE7FV+AdGSAZSHPe/R
   nAHdTvjY2e/wQ3IZ2PAFFtumhwpURiyY6yq4rmrlZPCAxqUABWmdBBXyj
   m+A9eFj6c0PhCNXDLIFSkgiZYkrxwdMORJnfn2ghN5ITXCM1uHPN4ZcD3
   oCYf6+YCPFV2/6+dm90eNeXaBLVbcywBAlKZG0CmbrME9lHxLxJ+PoCoQ
   w==;
X-CSE-ConnectionGUID: BATWUB4MQayFW8QqJhQUmg==
X-CSE-MsgGUID: Qs/Bu98sQq2i0Dc5XXvn7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57400095"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57400095"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:03:10 -0700
X-CSE-ConnectionGUID: QmYEMvf+S3iC6dybbdIG0Q==
X-CSE-MsgGUID: ea42IiHqRR6LzWx6yyOCFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171524805"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:03:09 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Wildcat Lake
Date: Tue, 12 Aug 2025 16:02:59 +0300
Message-ID: <20250812130259.109645-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Add PCI ID to support Intel Wildcat Lake, same as MTL.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index b39239f641f2..b87e03777395 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -630,6 +630,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4D47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.48.1

