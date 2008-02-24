From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [10/22] Remove unchecked_isa_dma support for hostdata
Date: Mon, 25 Feb 2008 00:35:23 +0100 (CET)
Message-ID: <20080224233523.286B91B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:15963 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYBXXve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:34 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


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
