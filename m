From: Alex Shi <alex.shi@intel.com>
Subject: [PATCH] scsi/mpt2sas: remove unnecesscary preempt requirement for MSIX
Date: Sat, 28 Apr 2012 14:27:33 +0800
Message-ID: <1335594453-30679-1-git-send-email-alex.shi@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab2D1G2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Apr 2012 02:28:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.shi@intel.com

smp_processor_id() need used in preempt safe ENV. Otherwise, the
cpu may be preempted and run on other cpus. But here, we don't care much
the specific CPU which handler the MSI, so just replace it by
raw_smp_processor_id() to avoid preempt debug warning.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 8a59a77..3f518ba 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1785,7 +1785,7 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
 
 /**
-- 
1.7.5.4

