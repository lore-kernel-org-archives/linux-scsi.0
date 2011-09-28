From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 4/6] libfc: cache align fc_exch_pool
Date: Tue, 27 Sep 2011 21:38:08 -0700
Message-ID: <20110928043807.13004.48356.stgit@localhost6.localdomain6>
References: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40920 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1I1ErT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 00:47:19 -0400
In-Reply-To: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

fix holes and better cache aligned fields.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d261e98..7c055fd 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -65,16 +65,15 @@ static struct workqueue_struct *fc_exch_workqueue;
  * assigned range of exchanges to per cpu pool.
  */
 struct fc_exch_pool {
+	spinlock_t	 lock;
+	struct list_head ex_list;
 	u16		 next_index;
 	u16		 total_exches;
 
 	/* two cache of free slot in exch array */
 	u16		 left;
 	u16		 right;
-
-	spinlock_t	 lock;
-	struct list_head ex_list;
-};
+} ____cacheline_aligned_in_smp;
 
 /**
  * struct fc_exch_mgr - The Exchange Manager (EM).
@@ -91,13 +90,13 @@ struct fc_exch_pool {
  * It manages the allocation of exchange IDs.
  */
 struct fc_exch_mgr {
+	struct fc_exch_pool *pool;
+	mempool_t	*ep_pool;
 	enum fc_class	class;
 	struct kref	kref;
 	u16		min_xid;
 	u16		max_xid;
-	mempool_t	*ep_pool;
 	u16		pool_max_index;
-	struct fc_exch_pool *pool;
 
 	/*
 	 * currently exchange mgr stats are updated but not used.

