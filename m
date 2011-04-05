From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/2] mpt2sas: Reduce cache misses in command submission path
Date: Tue, 5 Apr 2011 17:47:14 -0400
Message-ID: <20110405214714.GR4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1984 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1DEVrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2011 17:47:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com


In a high-IOPS workload, mpt2sas_base_get_smid_scsiio shows up in the top
20 cache misses.  This is because the data structure used for allocating
SMIDs is cache unfriendly; freed SMIDs are placed on the tail of the list,
guaranteeing a cache miss by the time we allocate it again.

By placing the freed SMID at the head of the list, we increase the
likelihood of it being cache-hot when it's used again.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 9ead039..1137cc9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1501,13 +1501,13 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 			/* hi-priority */
 			i = smid - ioc->hi_priority_smid;
 			ioc->hpr_lookup[i].cb_idx = 0xFF;
-			list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+			list_add(&ioc->hpr_lookup[i].tracker_list,
 			    &ioc->hpr_free_list);
 		} else {
 			/* internal queue */
 			i = smid - ioc->internal_smid;
 			ioc->internal_lookup[i].cb_idx = 0xFF;
-			list_add_tail(&ioc->internal_lookup[i].tracker_list,
+			list_add(&ioc->internal_lookup[i].tracker_list,
 			    &ioc->internal_free_list);
 		}
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
@@ -1520,14 +1520,13 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 		list_for_each_entry_safe(chain_req, next,
 		    &ioc->scsi_lookup[i].chain_list, tracker_list) {
 			list_del_init(&chain_req->tracker_list);
-			list_add_tail(&chain_req->tracker_list,
+			list_add(&chain_req->tracker_list,
 			    &ioc->free_chain_list);
 		}
 	}
 	ioc->scsi_lookup[i].cb_idx = 0xFF;
 	ioc->scsi_lookup[i].scmd = NULL;
-	list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-	    &ioc->free_list);
+	list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	/*
