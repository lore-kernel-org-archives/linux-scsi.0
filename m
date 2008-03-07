From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [13/20] Use blk_kmalloc in scsi_scan
Date: Fri,  7 Mar 2008 18:54:13 +0100 (CET)
Message-ID: <20080307175413.040B01B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53549 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739AbYCGRyP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:15 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Ask the block layer to get dmaable memory for IO that does 
not require bouncing.

Removes unchecked_isa_dma references -- this goes through the
bounce_gfp now

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi_scan.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux/drivers/scsi/scsi_scan.c
===================================================================
--- linux.orig/drivers/scsi/scsi_scan.c
+++ linux/drivers/scsi/scsi_scan.c
@@ -1010,8 +1010,7 @@ static int scsi_probe_and_add_lun(struct
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
-			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
+	result = blk_kmalloc(sdev->request_queue, result_len, GFP_ATOMIC);
 	if (!result)
 		goto out_free_sdev;
 
@@ -1091,7 +1090,7 @@ static int scsi_probe_and_add_lun(struct
 	}
 
  out_free_result:
-	kfree(result);
+	blk_kfree(result, result_len);
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp) {
@@ -1278,7 +1277,7 @@ static int scsi_report_lun_scan(struct s
 {
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
-	unsigned int length;
+	unsigned int length, olength;
 	unsigned int lun;
 	unsigned int num_luns;
 	unsigned int retries;
@@ -1328,8 +1327,8 @@ static int scsi_report_lun_scan(struct s
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	olength = length;
+	lun_data = blk_kmalloc(sdev->request_queue, length, GFP_ATOMIC);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 		goto out;
@@ -1457,7 +1456,7 @@ static int scsi_report_lun_scan(struct s
 	}
 
  out_err:
-	kfree(lun_data);
+	blk_kfree(lun_data, olength);
  out:
 	scsi_device_put(sdev);
 	if (sdev->sdev_state == SDEV_CREATED)
