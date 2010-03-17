From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/11] mpt2sas: Use of get_free_pages for huge memorary allocation.
Date: Wed, 17 Mar 2010 16:22:52 +0530
Message-ID: <20100317105241.GD21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54738 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab0CQLXu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:23:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

use the get_free_pages API for larger contigious physical memory chunk.
Also, the ioc->chain_depth need to be changed from
a 16bit to 32bit variable because the number of chains will exceed 64k
when the queue depth is large.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 79ab9fa..3735886 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1898,7 +1898,7 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
-	kfree(ioc->scsi_lookup);
+	free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 }
@@ -2110,11 +2110,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
 
-	ioc->scsi_lookup = kcalloc(ioc->scsiio_depth,
-	    sizeof(struct request_tracker), GFP_KERNEL);
+	sz = ioc->scsiio_depth * sizeof(struct request_tracker);
+	ioc->scsi_lookup_pages = get_order(sz);
+	ioc->scsi_lookup = (struct request_tracker *)__get_free_pages(
+	    GFP_KERNEL, ioc->scsi_lookup_pages);
 	if (!ioc->scsi_lookup) {
-		printk(MPT2SAS_ERR_FMT "scsi_lookup: kcalloc failed\n",
-		    ioc->name);
+		printk(MPT2SAS_ERR_FMT "scsi_lookup: get_free_pages failed, "
+		    "sz(%d)\n", ioc->name, (int)sz);
 		goto out;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1df5ec0..cccd4df 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -676,7 +676,8 @@ struct MPT2SAS_ADAPTER {
 	dma_addr_t	request_dma;
 	u32		request_dma_sz;
 	struct request_tracker *scsi_lookup;
-	spinlock_t scsi_lookup_lock;
+	ulong		scsi_lookup_pages;
+	spinlock_t 	scsi_lookup_lock;
 	struct list_head free_list;
 	int		pending_io_count;
 	wait_queue_head_t reset_wq;
@@ -688,7 +689,7 @@ struct MPT2SAS_ADAPTER {
 	u16		max_sges_in_chain_message;
 	u16		chains_needed_per_io;
 	u16		chain_offset_value_for_main_message;
-	u16		chain_depth;
+	u32		chain_depth;
 
 	/* hi-priority queue */
 	u16		hi_priority_smid;
