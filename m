From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [12/21] Remove unchecked_isa_dma support for hostdata
Date: Sun, 16 Nov 2008 00:11:12 +0100 (CET)
Message-ID: <20081115231112.88A1B3E661A@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44199 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbYKOXLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:10 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


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
--- linux.orig/drivers/scsi/hosts.c	2008-11-15 22:37:12.000000000 +0100
+++ linux/drivers/scsi/hosts.c	2008-11-15 23:50:55.000000000 +0100
@@ -314,9 +314,6 @@
 	gfp_t gfp_mask = GFP_KERNEL;
 	int rval;
 
-	if (sht->unchecked_isa_dma && privsize)
-		gfp_mask |= __GFP_DMA;
-
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
 	if (!shost)
 		return NULL;
