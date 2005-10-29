From: James.Smart@Emulex.Com
Subject: [PATCH 11/15]  lpfc 8.1.0 : Adjust lpfc_scsi_buf allocation
Date: Fri, 28 Oct 2005 20:29:51 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A5A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:7121 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750935AbVJ2A3x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:53 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TqDp018545
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:52 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adjust lpfc_scsi_buf allocation to account for lun_queue_depth and
  error handling

Fix: Under high load and high duress, the error handler could steal some
command resources from the normal i/o path. Rework to allocate additional
resources to avoid this scneario.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1152,24 +1152,33 @@ lpfc_slave_alloc(struct scsi_device *sde
 	/*
 	 * Populate the cmds_per_lun count scsi_bufs into this host's globally
 	 * available list of scsi buffers.  Don't allocate more than the
-	 * HBA limit conveyed to the midlayer via the host structure.  Note
-	 * that this list of scsi bufs exists for the lifetime of the driver.
+	 * HBA limit conveyed to the midlayer via the host structure.  The
+	 * formula accounts for the lun_queue_depth + error handlers + 1
+	 * extra.  This list of scsi bufs exists for the lifetime of the driver.
 	 */
 	total = phba->total_scsi_bufs;
-	num_to_alloc = LPFC_CMD_PER_LUN;
+	num_to_alloc = phba->cfg_lun_queue_depth + 2;
 	if (total >= phba->cfg_hba_queue_depth) {
-		printk(KERN_WARNING "%s, At config limitation of "
-		       "%d allocated scsi_bufs\n", __FUNCTION__, total);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
+				"%d:0704 At limitation of %d preallocated "
+				"command buffers\n", phba->brd_no, total);
 		return 0;
 	} else if (total + num_to_alloc > phba->cfg_hba_queue_depth) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
+				"%d:0705 Allocation request of %d command "
+				"buffers will exceed max of %d.  Reducing "
+				"allocation request to %d.\n", phba->brd_no,
+				num_to_alloc, phba->cfg_hba_queue_depth,
+				(phba->cfg_hba_queue_depth - total));
 		num_to_alloc = phba->cfg_hba_queue_depth - total;
 	}
 
 	for (i = 0; i < num_to_alloc; i++) {
 		scsi_buf = lpfc_get_scsi_buf(phba);
 		if (!scsi_buf) {
-			printk(KERN_ERR "%s, failed to allocate "
-			       "scsi_buf\n", __FUNCTION__);
+			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+					"%d:0706 Failed to allocate command "
+					"buffer\n", phba->brd_no);
 			break;
 		}
 
