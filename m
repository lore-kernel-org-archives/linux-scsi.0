From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [14/21] Rely on block layer bouncing for ISA DMA devices scanning
Date: Sun, 16 Nov 2008 00:11:14 +0100 (CET)
Message-ID: <20081115231114.929F73E6619@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44206 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKOXLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:12 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


Remove unchecked_isa_dma references in scsi_scan.c Instead we rely on
the block layer bouncing here. This is safe because all ISA DMA drivers have
been converted to set a suitable bounce pfn. Also scanning is not performance
critical, so a copy more or less doesn't matter.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi_scan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/scsi_scan.c
===================================================================
--- linux.orig/drivers/scsi/scsi_scan.c	2008-11-15 22:37:08.000000000 +0100
+++ linux/drivers/scsi/scsi_scan.c	2008-11-15 22:37:12.000000000 +0100
@@ -1028,8 +1028,7 @@
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
-			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
+	result = kmalloc(result_len, GFP_ATOMIC);
 	if (!result)
 		goto out_free_sdev;
 
@@ -1348,8 +1347,7 @@
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	lun_data = kmalloc(length, GFP_ATOMIC);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
