From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [11/20] Remove unchecked_isa_dma support for hostdata
Date: Fri,  7 Mar 2008 18:54:10 +0100 (CET)
Message-ID: <20080307175410.F043E1B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53534 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbYCGRyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:13 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
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
