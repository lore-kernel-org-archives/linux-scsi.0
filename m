From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [12/21] SCSI-ISA-DMA: Remove unchecked_isa_dma support for hostdata
Date: Thu,  2 Oct 2008 09:58:50 +0200 (CEST)
Message-ID: <20081002075850.53B623E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYJBH6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:51 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


All ISA drivers who relied on dma able hostdata have been converted
to allocate it separately. So remove the unchecked_isa_dma hostdata
support in the mid layer

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/hosts.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/drivers/scsi/hosts.c
===================================================================
--- linux.orig/drivers/scsi/hosts.c
+++ linux/drivers/scsi/hosts.c
@@ -314,9 +314,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 	gfp_t gfp_mask = GFP_KERNEL;
 	int rval;
 
-	if (sht->unchecked_isa_dma && privsize)
-		gfp_mask |= __GFP_DMA;
-
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
 	if (!shost)
 		return NULL;
