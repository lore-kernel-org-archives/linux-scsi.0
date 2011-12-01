From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 07/08] [SCSI]  mpt2sas : Fix for memory allocation error
 for large host credits
Date: Thu, 1 Dec 2011 07:53:08 +0530
Message-ID: <201112010929.pB19TbWq021262@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:46755 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab1LAJ3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:29:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for memory allocation error for large host credits 
    
The amount of memory required for tracking chain buffers is rather
large, and when the host credit count is big, memory allocation
failure occurs inside __get_free_pages.  

The fix is to limit the number of chains to 100,000.  In addition,
the number of host credits is limited to 30,000 IOs. However this 
limitation can be overridden this using the command line option 
max_queue_depth.  The algorithm for calculating the 
reply_post_queue_depth is changed so that it is equal to 
(reply_free_queue_depth + 16), previously it was (reply_free_queue_depth * 2).

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: stable@kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index aa04907..64ad383 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -67,6 +67,8 @@ static MPT_CALLBACK	mpt_callbacks[MPT_MAX_CALLBACKS];
 
 #define FAULT_POLLING_INTERVAL 1000 /* in milliseconds */
 
+#define MAX_HBA_QUEUE_DEPTH	30000
+#define MAX_CHAIN_DEPTH		100000
 static int max_queue_depth = -1;
 module_param(max_queue_depth, int, 0);
 MODULE_PARM_DESC(max_queue_depth, " max controller queue depth ");
@@ -2391,8 +2393,6 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 		}
 		if (ioc->chain_dma_pool)
 			pci_pool_destroy(ioc->chain_dma_pool);
-	}
-	if (ioc->chain_lookup) {
 		free_pages((ulong)ioc->chain_lookup, ioc->chain_pages);
 		ioc->chain_lookup = NULL;
 	}
@@ -2410,9 +2410,7 @@ static int
 _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 {
 	struct mpt2sas_facts *facts;
-	u32 queue_size, queue_diff;
 	u16 max_sge_elements;
-	u16 num_of_reply_frames;
 	u16 chains_needed_per_io;
 	u32 sz, total_sz, reply_post_free_sz;
 	u32 retry_sz;
@@ -2439,7 +2437,8 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		max_request_credit = (max_queue_depth < facts->RequestCredit)
 		    ? max_queue_depth : facts->RequestCredit;
 	else
-		max_request_credit = facts->RequestCredit;
+		max_request_credit = min_t(u16, facts->RequestCredit,
+		    MAX_HBA_QUEUE_DEPTH);
 
 	ioc->hba_queue_depth = max_request_credit;
 	ioc->hi_priority_depth = facts->HighPriorityCredit;
@@ -2480,50 +2479,25 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 	ioc->chains_needed_per_io = chains_needed_per_io;
 
-	/* reply free queue sizing - taking into account for events */
-	num_of_reply_frames = ioc->hba_queue_depth + 32;
-
-	/* number of replies frames can't be a multiple of 16 */
-	/* decrease number of reply frames by 1 */
-	if (!(num_of_reply_frames % 16))
-		num_of_reply_frames--;
-
-	/* calculate number of reply free queue entries
-	 *  (must be multiple of 16)
-	 */
-
-	/* (we know reply_free_queue_depth is not a multiple of 16) */
-	queue_size = num_of_reply_frames;
-	queue_size += 16 - (queue_size % 16);
-	ioc->reply_free_queue_depth = queue_size;
-
-	/* reply descriptor post queue sizing */
-	/* this size should be the number of request frames + number of reply
-	 * frames
-	 */
-
-	queue_size = ioc->hba_queue_depth + num_of_reply_frames + 1;
-	/* round up to 16 byte boundary */
-	if (queue_size % 16)
-		queue_size += 16 - (queue_size % 16);
-
-	/* check against IOC maximum reply post queue depth */
-	if (queue_size > facts->MaxReplyDescriptorPostQueueDepth) {
-		queue_diff = queue_size -
-		    facts->MaxReplyDescriptorPostQueueDepth;
+	/* reply free queue sizing - taking into account for 64 FW events */
+	ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 
-		/* round queue_diff up to multiple of 16 */
-		if (queue_diff % 16)
-			queue_diff += 16 - (queue_diff % 16);
-
-		/* adjust hba_queue_depth, reply_free_queue_depth,
-		 * and queue_size
-		 */
-		ioc->hba_queue_depth -= (queue_diff / 2);
-		ioc->reply_free_queue_depth -= (queue_diff / 2);
-		queue_size = facts->MaxReplyDescriptorPostQueueDepth;
+	/* align the reply post queue on the next 16 count boundary */
+	if (!ioc->reply_free_queue_depth % 16)
+		ioc->reply_post_queue_depth = ioc->reply_free_queue_depth + 16;
+	else
+		ioc->reply_post_queue_depth = ioc->reply_free_queue_depth +
+				32 - (ioc->reply_free_queue_depth % 16);
+	if (ioc->reply_post_queue_depth >
+	    facts->MaxReplyDescriptorPostQueueDepth) {
+		ioc->reply_post_queue_depth = min_t(u16,
+		    (facts->MaxReplyDescriptorPostQueueDepth -
+		    (facts->MaxReplyDescriptorPostQueueDepth % 16)),
+		    (ioc->hba_queue_depth - (ioc->hba_queue_depth % 16)));
+		ioc->reply_free_queue_depth = ioc->reply_post_queue_depth - 16;
+		ioc->hba_queue_depth = ioc->reply_free_queue_depth - 64;
 	}
-	ioc->reply_post_queue_depth = queue_size;
+
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scatter gather: "
 	    "sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), "
@@ -2609,15 +2583,12 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    "depth(%d)\n", ioc->name, ioc->request,
 	    ioc->scsiio_depth));
 
-	/* loop till the allocation succeeds */
-	do {
-		sz = ioc->chain_depth * sizeof(struct chain_tracker);
-		ioc->chain_pages = get_order(sz);
-		ioc->chain_lookup = (struct chain_tracker *)__get_free_pages(
-		    GFP_KERNEL, ioc->chain_pages);
-		if (ioc->chain_lookup == NULL)
-			ioc->chain_depth -= 100;
-	} while (ioc->chain_lookup == NULL);
+	ioc->chain_depth = min_t(u32, ioc->chain_depth, MAX_CHAIN_DEPTH);
+	sz = ioc->chain_depth * sizeof(struct chain_tracker);
+	ioc->chain_pages = get_order(sz);
+
+	ioc->chain_lookup = (struct chain_tracker *)__get_free_pages(
+	    GFP_KERNEL, ioc->chain_pages);
 	ioc->chain_dma_pool = pci_pool_create("chain pool", ioc->pdev,
 	    ioc->request_sz, 16, 0);
 	if (!ioc->chain_dma_pool) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c3e69b2..acfa83e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1016,8 +1016,8 @@ _scsih_get_chain_buffer_tracker(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->free_chain_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		printk(MPT2SAS_WARN_FMT "chain buffers not available\n",
-		    ioc->name);
+		dfailprintk(ioc, printk(MPT2SAS_WARN_FMT "chain buffers not "
+			"available\n", ioc->name));
 		return NULL;
 	}
 	chain_req = list_entry(ioc->free_chain_list.next,
