From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [12/22] Remove GFP_DMAs/unchecked_isa_dma checks in scsi_scan.c
Date: Mon, 25 Feb 2008 00:35:25 +0100 (CET)
Message-ID: <20080224233525.31E991B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19737 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbYBXXf1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:35:27 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


Should not be needed because the block layer bounces that all.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi_scan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/scsi_scan.c
===================================================================
--- linux.orig/drivers/scsi/scsi_scan.c
+++ linux/drivers/scsi/scsi_scan.c
@@ -1010,8 +1010,7 @@ static int scsi_probe_and_add_lun(struct
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
-			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
+	result = kmalloc(result_len, GFP_ATOMIC);
 	if (!result)
 		goto out_free_sdev;
 
@@ -1328,8 +1327,7 @@ static int scsi_report_lun_scan(struct s
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	lun_data = kmalloc(length, GFP_ATOMIC);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 		goto out;
