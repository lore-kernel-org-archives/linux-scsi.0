From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [14/22] Remove automatic block layer bouncing for unchecked_isa_dma
Date: Mon, 25 Feb 2008 00:35:27 +0100 (CET)
Message-ID: <20080224233527.3B9031B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:55517 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYBXXvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:36 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


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
