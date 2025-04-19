Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E0D259C;
	Sat, 19 Apr 2025 12:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745064645; cv=none; b=DMWoqelOGGw4BCF1+yAcSABPJ+1A7g27vzCFKwUz6gDppbRF5QrfHZBhT8fM4jUNEfbNQyFzkvmGmcslt0e8DeViuKH+bNPf6GaWe7+1aUGEo63Y0hFzMkByDKYtrwAV3tUvS5fdms/fH1VjnCsX5+3HQdaA5LsFWrWVnbldveU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745064645; c=relaxed/simple;
	bh=gG/4R9vVgxIB+SpaZL4mesqyGcRxPvmepmQ5ibM9WKM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kx0gwcq0rfVx8AkiH7iNKXxs7pJ78OqCJlugIBqW/Od7JJzA7xPATNQQpOG8fNcH5ac6bOTQ5pn6LrA1Zcdf92q2suRiy8OgpwkNrlQgbvx1flLrrjExLq1Iz03y6S9EFrQ8iV5nX7smb4+sDwNQUyrvyaw3rKysdrOS1tLeaU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iq6W9Jgc; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iq6W9Jgc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745064643; x=1776600643;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gG/4R9vVgxIB+SpaZL4mesqyGcRxPvmepmQ5ibM9WKM=;
  b=Iq6W9Jgc3FTpEfUg/kMJjCgWiA7B9QjCPTgkrcJHcFPdMTQZalmJQlZp
   Yf2lD4QVovRwbw0ZpmFiHR/FdIPTSdUZNA0Nc01CmGrq4RX6C3WTdxnaW
   m4sYqvUWnAt2Dn9wao1xhU3DXKQa3rGuHcWcaHh4ZmaztEtK4XisxohKz
   1meHLhImHMrWgQrZRFuG8aRaO4tHdMS82VHgIsLb4kaU6NqRVdgzL2tRq
   FWmGrVaqtCC9/pQVXTVeP48CRgG1EwJFwzPHGKdz6mFgJwnzvaA/7UewO
   zkD/H+Qpyys/bHAk2lzt9J45reULoiJOtgLTlypRWj4Njw3JxWL3nN+hf
   A==;
X-CSE-ConnectionGUID: xjXX/yhLQciTWwODF/KhPA==
X-CSE-MsgGUID: n2efEOEHTPSe4q5s86Zr3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46563603"
X-IronPort-AV: E=Sophos;i="6.15,224,1739865600"; 
   d="scan'208";a="46563603"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2025 05:10:43 -0700
X-CSE-ConnectionGUID: X0sworbNSn+KiMNBIcpTtg==
X-CSE-MsgGUID: uSa4u75VS9OiCUPzVzqAYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,224,1739865600"; 
   d="scan'208";a="131298979"
Received: from chenyu-dev.sh.intel.com ([10.239.62.107])
  by orviesa006.jf.intel.com with ESMTP; 19 Apr 2025 05:10:41 -0700
From: Chen Yu <yu.c.chen@intel.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Yu <yu.chen.surf@foxmail.com>,
	Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 1/6] scsi: megaraid_sas: Fix invalid Node index
Date: Sat, 19 Apr 2025 20:04:54 +0800
Message-Id: <20250419120454.1840662-1-yu.c.chen@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a system with DRAM interleave enabled, out-of-bound access
is detected:

megaraid_sas 0000:3f:00.0: requested/available msix 128/128 poll_queue 0
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in ./arch/x86/include/asm/topology.h:72:28
index -1 is out of range for type 'cpumask *[1024]'
dump_stack_lvl+0x5d/0x80
ubsan_epilogue+0x5/0x2b
__ubsan_handle_out_of_bounds.cold+0x46/0x4b
megasas_alloc_irq_vectors+0x149/0x190 [megaraid_sas]
megasas_probe_one.cold+0xa4d/0x189c [megaraid_sas]
local_pci_probe+0x42/0x90
pci_device_probe+0xdc/0x290
really_probe+0xdb/0x340
__driver_probe_device+0x78/0x110
driver_probe_device+0x1f/0xa0
__driver_attach+0xba/0x1c0
bus_for_each_dev+0x8b/0xe0
bus_add_driver+0x142/0x220
driver_register+0x72/0xd0
megasas_init+0xdf/0xff0 [megaraid_sas]
do_one_initcall+0x57/0x310
do_init_module+0x90/0x250
init_module_from_file+0x85/0xc0
idempotent_init_module+0x114/0x310
__x64_sys_finit_module+0x65/0xc0
do_syscall_64+0x82/0x170
entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix it accordingly.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 28c75865967a..7a2e35a35193 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5905,7 +5905,11 @@ megasas_set_high_iops_queue_affinity_and_hint(struct megasas_instance *instance)
 	const struct cpumask *mask;
 
 	if (instance->perf_mode == MR_BALANCED_PERF_MODE) {
-		mask = cpumask_of_node(dev_to_node(&instance->pdev->dev));
+		int nid = dev_to_node(&instance->pdev->dev);
+
+		if (nid == NUMA_NO_NODE)
+			nid = 0;
+		mask = cpumask_of_node(nid);
 
 		for (i = 0; i < instance->low_latency_index_start; i++) {
 			irq = pci_irq_vector(instance->pdev, i);
-- 
2.25.1

