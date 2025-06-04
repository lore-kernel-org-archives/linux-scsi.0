Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A3817548;
	Wed,  4 Jun 2025 04:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749011555; cv=none; b=qSQBoBsu8sNgfpRZNU9y1J5/atJjhEHXWEv4+1Sw92T3wnp8xRyUvzQE+T+HVLmE9JZ7vyRIcJt3k9669bzk7YFSZ8sUZ58fvQaoT7zNnI2cWIePCoXc87TvopqF47kIexktvoFkA1ShLGySP3Cey34eANrgd+ksscLF4+EDj70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749011555; c=relaxed/simple;
	bh=1fpC3Hybi/eVGZh4MEeqKTWPmCJz86JZI3OFCfdqyoo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U+oszMAwEtYBTz6qzlgVxD/0soBeqw59v2I1QuPM/aIGFEUps5hC50NGx7kP9q1KDb4rVL1aaMWyPsGaJwdN4AW6YJJjQbFwCo1IOWCqsmCTah4mYCpTQ0atnH6hRxfLDRNk6H6UVc+Oh9Nw/b9vCRH5OBjjaoxwQ7HbBehC4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LbnU+Vth; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LbnU+Vth"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749011554; x=1780547554;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1fpC3Hybi/eVGZh4MEeqKTWPmCJz86JZI3OFCfdqyoo=;
  b=LbnU+VthNRtc4WbynW1jIQiP2Mh8bqI4jxYJ5HrG3veOqTaBWABfjRAh
   ar2WLkDWKTcNAZDKECT2oDAQ8Bk0xAwB27tg7hgxL8cQKbC2MdbNG9NKw
   ZSD3Y6yvN1RoBjPCeWXtLiLE3id5MPTZ9tSyG3UVHffbptHcmL9mqocLg
   nJ6L1e2jUqgziHe4qImGbR6vZj/11EvC5xpgVRiYh3taacekJ+eCkiclF
   QuTwalB8FwdT4eLhr9guzcqlsziLhwQ/q/5iArpOGQ0SbM6JzDsAsZk5E
   JJ3ogA3K4DGyVr8SyahFPGSyUgnk/eRBqC4aWE7vcTKuxajTjemzFJaoW
   Q==;
X-CSE-ConnectionGUID: m8g6KL0ORzezSKwvO+Kvnw==
X-CSE-MsgGUID: uKvHA1HQQD+5PFwSKlgzkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51217522"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="51217522"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:32:33 -0700
X-CSE-ConnectionGUID: ADEZ9NkNT56f57CeRBtwIg==
X-CSE-MsgGUID: 2PWEErnlRCa62D6QTvh1+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="150221411"
Received: from chenyu-dev.sh.intel.com ([10.239.62.107])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jun 2025 21:32:23 -0700
From: Chen Yu <yu.c.chen@intel.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH RESEND] scsi: megaraid_sas: Fix invalid Node index
Date: Wed,  4 Jun 2025 12:25:56 +0800
Message-Id: <20250604042556.3731059-1-yu.c.chen@intel.com>
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
index 5e33d411fa3d..6d4de06082d1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5910,7 +5910,11 @@ megasas_set_high_iops_queue_affinity_and_hint(struct megasas_instance *instance)
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

