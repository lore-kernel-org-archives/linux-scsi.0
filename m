From: James Smart <james.smart@emulex.com>
Subject: [PATCH 20/21] lpfc 8.3.30: Revert fix for Link Pull Causes I/O
 Failures
Date: Thu, 1 Mar 2012 22:38:42 -0500
Message-ID: <1330659524.18500.47.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38913 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757859Ab2CBDi4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:38:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Revert fix for Link Pull Causes I/O Failures


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    9 ---------
 lpfc_scsi.h |    1 -
 2 files changed, 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-03-01 17:33:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-03-01 17:33:56.000000000 -0500
@@ -4187,15 +4187,6 @@ lpfc_queuecommand_lck(struct scsi_cmnd *
 		cmnd->result = err;
 		goto out_fail_command;
 	}
-	/*
-	 * Do not let the mid-layer retry I/O too fast. If an I/O is retried
-	 * without waiting a bit then indicate that the device is busy.
-	 */
-	if (cmnd->retries &&
-	    time_before(jiffies, (cmnd->jiffies_at_alloc +
-				  msecs_to_jiffies(LPFC_RETRY_PAUSE *
-						   cmnd->retries))))
-		return SCSI_MLQUEUE_DEVICE_BUSY;
 	ndlp = rdata->pnode;
 
 	if ((scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) &&
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
--- a/drivers/scsi/lpfc/lpfc_scsi.h	2012-03-01 17:33:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.h	2012-03-01 17:33:56.000000000 -0500
@@ -164,5 +164,4 @@ struct lpfc_scsi_buf {
 
 #define LPFC_SCSI_DMA_EXT_SIZE 264
 #define LPFC_BPL_SIZE          1024
-#define LPFC_RETRY_PAUSE       300
 #define MDAC_DIRECT_CMD                  0x22



