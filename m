From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 2/6] mpt3sas: Configure reply post queue depth, DMA and sgl  tablesize.
Date: Fri, 19 Jan 2018 04:37:38 -0800
Message-ID: <1516365462-14708-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1516365462-14708-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36258 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754805AbeASMiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jan 2018 07:38:04 -0500
Received: by mail-qt0-f196.google.com with SMTP id z11so3398167qtm.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2018 04:38:04 -0800 (PST)
In-Reply-To: <1516365462-14708-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

This configures shost max sector to 128, single reply descriptor
post queue, sgl table size to 16 and 32 bit DMA for MPI Endpoint
and it supports 64K as max IO.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 47 +++++++++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 40 ++++++++++++++++++------------
 2 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a44b9be..c0a1c0f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2214,6 +2214,9 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 	struct sysinfo s;
 	u64 consistent_dma_mask;
 
+	if (ioc->is_mcpu_endpoint)
+		goto try_32bit;
+
 	if (ioc->dma_mask)
 		consistent_dma_mask = DMA_BIT_MASK(64);
 	else
@@ -2232,6 +2235,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 		}
 	}
 
+ try_32bit:
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
 	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		ioc->base_add_sg_single = &_base_add_sg_single_32;
@@ -3887,17 +3891,21 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		sg_tablesize = min_t(unsigned short, sg_tablesize,
 		   MPT_KDUMP_MIN_PHYS_SEGMENTS);
 
-	if (sg_tablesize < MPT_MIN_PHYS_SEGMENTS)
-		sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
-	else if (sg_tablesize > MPT_MAX_PHYS_SEGMENTS) {
-		sg_tablesize = min_t(unsigned short, sg_tablesize,
-				      SG_MAX_SEGMENTS);
-		pr_warn(MPT3SAS_FMT
-		 "sg_tablesize(%u) is bigger than kernel"
-		 " defined SG_CHUNK_SIZE(%u)\n", ioc->name,
-		 sg_tablesize, MPT_MAX_PHYS_SEGMENTS);
+	if (ioc->is_mcpu_endpoint)
+		ioc->shost->sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
+	else {
+		if (sg_tablesize < MPT_MIN_PHYS_SEGMENTS)
+			sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
+		else if (sg_tablesize > MPT_MAX_PHYS_SEGMENTS) {
+			sg_tablesize = min_t(unsigned short, sg_tablesize,
+					SG_MAX_SEGMENTS);
+			pr_warn(MPT3SAS_FMT
+				"sg_tablesize(%u) is bigger than kernel "
+				"defined SG_CHUNK_SIZE(%u)\n", ioc->name,
+				sg_tablesize, MPT_MAX_PHYS_SEGMENTS);
+		}
+		ioc->shost->sg_tablesize = sg_tablesize;
 	}
-	ioc->shost->sg_tablesize = sg_tablesize;
 
 	ioc->internal_depth = min_t(int, (facts->HighPriorityCredit + (5)),
 		(facts->RequestCredit / 4));
@@ -3982,13 +3990,18 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	/* reply free queue sizing - taking into account for 64 FW events */
 	ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 
-	/* calculate reply descriptor post queue depth */
-	ioc->reply_post_queue_depth = ioc->hba_queue_depth +
-				ioc->reply_free_queue_depth +  1 ;
-	/* align the reply post queue on the next 16 count boundary */
-	if (ioc->reply_post_queue_depth % 16)
-		ioc->reply_post_queue_depth += 16 -
-		(ioc->reply_post_queue_depth % 16);
+	/* mCPU manage single counters for simplicity */
+	if (ioc->is_mcpu_endpoint)
+		ioc->reply_post_queue_depth = ioc->reply_free_queue_depth;
+	else {
+		/* calculate reply descriptor post queue depth */
+		ioc->reply_post_queue_depth = ioc->hba_queue_depth +
+			ioc->reply_free_queue_depth +  1;
+		/* align the reply post queue on the next 16 count boundary */
+		if (ioc->reply_post_queue_depth % 16)
+			ioc->reply_post_queue_depth += 16 -
+				(ioc->reply_post_queue_depth % 16);
+	}
 
 	if (ioc->reply_post_queue_depth >
 	    facts->MaxReplyDescriptorPostQueueDepth) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index bde3c6f..5e52679 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10521,26 +10521,34 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->transportt = mpt3sas_transport_template;
 	shost->unique_id = ioc->id;
 
-	if (max_sectors != 0xFFFF) {
-		if (max_sectors < 64) {
-			shost->max_sectors = 64;
-			pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
-			    "for max_sectors, range is 64 to 32767. Assigning "
-			    "value of 64.\n", ioc->name, max_sectors);
-		} else if (max_sectors > 32767) {
-			shost->max_sectors = 32767;
-			pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
-			    "for max_sectors, range is 64 to 32767. Assigning "
-			    "default value of 32767.\n", ioc->name,
-			    max_sectors);
-		} else {
-			shost->max_sectors = max_sectors & 0xFFFE;
-			pr_info(MPT3SAS_FMT
+	if (ioc->is_mcpu_endpoint) {
+		/* mCPU MPI support 64K max IO */
+		shost->max_sectors = 128;
+		pr_info(MPT3SAS_FMT
 				"The max_sectors value is set to %d\n",
 				ioc->name, shost->max_sectors);
+	} else {
+		if (max_sectors != 0xFFFF) {
+			if (max_sectors < 64) {
+				shost->max_sectors = 64;
+				pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
+				    "for max_sectors, range is 64 to 32767. " \
+				    "Assigning value of 64.\n", \
+				    ioc->name, max_sectors);
+			} else if (max_sectors > 32767) {
+				shost->max_sectors = 32767;
+				pr_warn(MPT3SAS_FMT "Invalid value %d passed " \
+				    "for max_sectors, range is 64 to 32767." \
+				    "Assigning default value of 32767.\n", \
+				    ioc->name, max_sectors);
+			} else {
+				shost->max_sectors = max_sectors & 0xFFFE;
+				pr_info(MPT3SAS_FMT
+					"The max_sectors value is set to %d\n",
+					ioc->name, shost->max_sectors);
+			}
 		}
 	}
-
 	/* register EEDP capabilities with SCSI layer */
 	if (prot_mask > 0)
 		scsi_host_set_prot(shost, prot_mask);
-- 
2.5.5
