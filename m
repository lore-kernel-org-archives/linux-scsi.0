From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/2] mpt2sas: Reduce cache misses in command submission
 path
Date: Thu, 7 Apr 2011 01:26:16 -0400
Message-ID: <20110407052616.GB4673@linux.intel.com>
References: <20110405214714.GR4183@linux.intel.com>
 <20110406134654.GB21729@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1DGF0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2011 01:26:16 -0400
Content-Disposition: inline
In-Reply-To: <20110406134654.GB21729@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Wed, Apr 06, 2011 at 09:46:55AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 05, 2011 at 05:47:14PM -0400, Matthew Wilcox wrote:
> > 
> > In a high-IOPS workload, mpt2sas_base_get_smid_scsiio shows up in the top
> > 20 cache misses.  This is because the data structure used for allocating
> > SMIDs is cache unfriendly; freed SMIDs are placed on the tail of the list,
> > guaranteeing a cache miss by the time we allocate it again.
> > 
> > By placing the freed SMID at the head of the list, we increase the
> > likelihood of it being cache-hot when it's used again.
> 
> Looks good for now.  But given that the smids are a statically allocated
> ressource it might be a good idea to get rid of all the rather cache
> unfriendly linked lists and locking and use a bitmap to allocate
> smids and then just index into a linear array of them.

Yep; Eric and I talked about that on Tuesday evening.  I've also redone
this second patch against 2.6.39-rc2.  My good buddy Doug is getting
the numbers now (39-rc2, 39-rc2 plus patch 1, 39-rc2 plus patches 1 & 2).

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 5e001ff..5e9bd384 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1502,14 +1502,13 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
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
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-		    &ioc->free_list);
+		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 		/*
@@ -1526,13 +1525,12 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 		/* hi-priority */
 		i = smid - ioc->hi_priority_smid;
 		ioc->hpr_lookup[i].cb_idx = 0xFF;
-		list_add_tail(&ioc->hpr_lookup[i].tracker_list,
-		    &ioc->hpr_free_list);
+		list_add(&ioc->hpr_lookup[i].tracker_list, &ioc->hpr_free_list);
 	} else if (smid <= ioc->hba_queue_depth) {
 		/* internal queue */
 		i = smid - ioc->internal_smid;
 		ioc->internal_lookup[i].cb_idx = 0xFF;
-		list_add_tail(&ioc->internal_lookup[i].tracker_list,
+		list_add(&ioc->internal_lookup[i].tracker_list,
 		    &ioc->internal_free_list);
 	}
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
