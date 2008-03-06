From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [15/21] Remove automatic block layer bouncing for unchecked_isa_dma
Date: Thu,  6 Mar 2008 21:51:36 +0100 (CET)
Message-ID: <20080306205136.E62DB1B419D@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:12094 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762548AbYCFUvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:39 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
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
