From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [11/21] Remove unchecked_isa_dma support for hostdata
Date: Thu,  6 Mar 2008 21:51:32 +0100 (CET)
Message-ID: <20080306205132.201141B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:3829 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYCFUvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:36 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


All ISA drivers who relied on dma able hostdata have been converted
to allocate it separately. So remove the unchecked_isa_dma hostdata
support in the mid layer

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/hosts.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/drivers/scsi/hosts.c
===================================================================
--- linux.orig/drivers/scsi/hosts.c
+++ linux/drivers/scsi/hosts.c
@@ -297,9 +297,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 	gfp_t gfp_mask = GFP_KERNEL;
 	int rval;
 
-	if (sht->unchecked_isa_dma && privsize)
-		gfp_mask |= __GFP_DMA;
-
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
 	if (!shost)
 		return NULL;
