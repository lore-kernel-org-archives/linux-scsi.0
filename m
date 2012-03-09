From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/10] libfc: fcoe_transport_create fails in single-CPU
 environment
Date: Fri, 09 Mar 2012 14:50:30 -0800
Message-ID: <20120309225030.6515.1152.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab2CIWua (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:30 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Steven Clark <sclark@crossbeam.com>

From: Steven Clark <sclark@crossbeam.com>

Starting fcoe fails at fcoe_transport_create when attempting to allocate a pool of 4K exchanges on a
64-bit single-CPU environment because the call  to __alloc_percpu() is greater than the max of 32K.
This patch reduces the number of exchanges to fit within the maximum allowed space.

[ Whitespace problems fixed by Robert Love to satisfy chechpatch.pl ]

Signed-off-by: Steven Clark <sclark@crossbeam.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 588060f..31cf794 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2284,7 +2284,18 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lport,
 	mp->class = class;
 	/* adjust em exch xid range for offload */
 	mp->min_xid = min_xid;
-	mp->max_xid = max_xid;
+
+       /* reduce range so per cpu pool fits into PCPU_MIN_UNIT_SIZE pool */
+	pool_exch_range = (PCPU_MIN_UNIT_SIZE - sizeof(*pool)) /
+		sizeof(struct fc_exch *);
+	if ((max_xid - min_xid + 1) / (fc_cpu_mask + 1) > pool_exch_range) {
+		mp->max_xid = pool_exch_range * (fc_cpu_mask + 1) +
+			min_xid - 1;
+	} else {
+		mp->max_xid = max_xid;
+		pool_exch_range = (mp->max_xid - mp->min_xid + 1) /
+			(fc_cpu_mask + 1);
+	}
 
 	mp->ep_pool = mempool_create_slab_pool(2, fc_em_cachep);
 	if (!mp->ep_pool)
@@ -2295,7 +2306,6 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lport,
 	 * divided across all cpus. The exch pointers array memory is
 	 * allocated for exch range per pool.
 	 */
-	pool_exch_range = (mp->max_xid - mp->min_xid + 1) / (fc_cpu_mask + 1);
 	mp->pool_max_index = pool_exch_range - 1;
 
 	/*

