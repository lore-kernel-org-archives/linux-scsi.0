From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [16/21] SCSI-ISA-DMA: Remove automatic block layer bouncing for unchecked_isa_dma
Date: Thu,  2 Oct 2008 09:58:54 +0200 (CEST)
Message-ID: <20081002075854.69AEA3E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57114 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYJBH6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:55 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


All ISA drivers explicitely tell the block layer now that it needs
to bounce for them, so SCSI mid layer doesn't need to do that automatically
for unchecked_isa_dma anymore.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi_lib.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c
+++ linux/drivers/scsi/scsi_lib.c
@@ -1610,8 +1610,6 @@ u64 scsi_calculate_bounce_limit(struct S
 	struct device *host_dev;
 	u64 bounce_limit = 0xffffffff;
 
-	if (shost->unchecked_isa_dma)
-		return BLK_BOUNCE_ISA;
 	/*
 	 * Platforms with virtual-DMA translation
 	 * hardware have no practical limit.
