From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [15/20] Remove automatic block layer bouncing for unchecked_isa_dma
Date: Fri,  7 Mar 2008 18:54:15 +0100 (CET)
Message-ID: <20080307175415.0CDD11B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:56579 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725AbYCGRyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:17 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


All ISA drivers explicitely tell the block layer now that it needs
to bounce for them, so SCSI mid layer doesn't need to do that automatically
for unchecked_isa_dma anymore.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi_lib.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c
+++ linux/drivers/scsi/scsi_lib.c
@@ -1547,8 +1547,6 @@ u64 scsi_calculate_bounce_limit(struct S
 	struct device *host_dev;
 	u64 bounce_limit = 0xffffffff;
 
-	if (shost->unchecked_isa_dma)
-		return BLK_BOUNCE_ISA;
 	/*
 	 * Platforms with virtual-DMA translation
 	 * hardware have no practical limit.
