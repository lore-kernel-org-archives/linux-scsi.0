From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 5/7] mpt2sas: Add free smids to the head, not tail of list
Date: Thu, 27 Mar 2014 16:40:34 -0400
Message-ID: <b74cd5f3a044257f197676fa093a875c637adf2f.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbaC0Uko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:40:44 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com

Reusing a smid quickly means it's still cache-hot.  This yields a small
but noticable performance improvement in a well-known database benchmark.
This improvement is already present in the mpt3sas driver.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..8b88118 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1739,14 +1739,14 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 			list_for_each_entry_safe(chain_req, next,
 			    &ioc->scsi_lookup[i].chain_list, tracker_list) {
 				list_del_init(&chain_req->tracker_list);
-				list_add_tail(&chain_req->tracker_list,
+				list_add(&chain_req->tracker_list,
 				    &ioc->free_chain_list);
 			}
 		}
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+		list_add(&ioc->scsi_lookup[i].tracker_list,
 		    &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
@@ -1764,13 +1764,13 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 		/* hi-priority */
 		i = smid - ioc->hi_priority_smid;
 		ioc->hpr_lookup[i].cb_idx = 0xFF;
-		list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+		list_add(&ioc->hpr_lookup[i].tracker_list,
 		    &ioc->hpr_free_list);
 	} else if (smid <= ioc->hba_queue_depth) {
 		/* internal queue */
 		i = smid - ioc->internal_smid;
 		ioc->internal_lookup[i].cb_idx = 0xFF;
-		list_add_tail(&ioc->internal_lookup[i].tracker_list,
+		list_add(&ioc->internal_lookup[i].tracker_list,
 		    &ioc->internal_free_list);
 	}
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-- 
1.9.0

