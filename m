From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [16/21] Remove automatic block layer bouncing for unchecked_isa_dma
Date: Sun, 16 Nov 2008 00:11:16 +0100 (CET)
Message-ID: <20081115231116.9B7193E6618@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44212 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYKOXLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:14 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


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
--- linux.orig/drivers/scsi/scsi_lib.c	2008-11-15 22:37:08.000000000 +0100
+++ linux/drivers/scsi/scsi_lib.c	2008-11-15 22:37:12.000000000 +0100
@@ -1732,8 +1732,6 @@
 	struct device *host_dev;
 	u64 bounce_limit = 0xffffffff;
 
-	if (shost->unchecked_isa_dma)
-		return BLK_BOUNCE_ISA;
 	/*
 	 * Platforms with virtual-DMA translation
 	 * hardware have no practical limit.
