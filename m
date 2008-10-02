From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [14/21] SCSI-ISA-DMA: Rely on block layer bouncing for ISA DMA devices scanning
Date: Thu,  2 Oct 2008 09:58:52 +0200 (CEST)
Message-ID: <20081002075852.5C0513E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYJBH6x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:53 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


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
--- linux.orig/drivers/scsi/scsi_scan.c
+++ linux/drivers/scsi/scsi_scan.c
@@ -1015,8 +1015,7 @@ static int scsi_probe_and_add_lun(struct
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
-			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
+	result = kmalloc(result_len, GFP_ATOMIC);
 	if (!result)
 		goto out_free_sdev;
 
@@ -1335,8 +1334,7 @@ static int scsi_report_lun_scan(struct s
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	lun_data = kmalloc(length, GFP_ATOMIC);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
