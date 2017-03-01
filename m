From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: Avoid false out-of-order detection for aborted command
Date: Tue, 28 Feb 2017 16:15:12 -0800
Message-ID: <1488327312-8750-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:28832 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdCAAtC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 19:49:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com

If SCSI-ML has already issued abort on a command i.e
FNIC_IOREQ_ABTS_PENDING is set and we get a IO completion avoid
this being flagged as out-of-order completion by setting the
FNIC_IO_DONE flag in fnic_fcpio_icmnd_cmpl_handler

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..d851d89 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -876,32 +876,28 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	/*
 	 *  if SCSI-ML has already issued abort on this command,
-	 * ignore completion of the IO. The abts path will clean it up
+	 *  set completion of the IO. The abts path will clean it up
 	 */
 	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
-		spin_unlock_irqrestore(io_lock, flags);
+
+		/*
+		 * set the FNIC_IO_DONE so that this doesn't get
+		 * flagged as 'out of order' if it was not aborted
+		 */
+		CMD_FLAGS(sc) |= FNIC_IO_DONE;
 		CMD_FLAGS(sc) |= FNIC_IO_ABTS_PENDING;
-		switch (hdr_status) {
-		case FCPIO_SUCCESS:
-			CMD_FLAGS(sc) |= FNIC_IO_DONE;
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				  "icmnd_cmpl ABTS pending hdr status = %s "
-				  "sc  0x%p scsi_status %x  residual %d\n",
-				  fnic_fcpio_status_to_str(hdr_status), sc,
-				  icmnd_cmpl->scsi_status,
-				  icmnd_cmpl->residual);
-			break;
-		case FCPIO_ABORTED:
+		spin_unlock_irqrestore(io_lock, flags);
+		if(FCPIO_ABORTED == hdr_status)
 			CMD_FLAGS(sc) |= FNIC_IO_ABORTED;
-			break;
-		default:
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-					  "icmnd_cmpl abts pending "
-					  "hdr status = %s tag = 0x%x sc = 0x%p\n",
-					  fnic_fcpio_status_to_str(hdr_status),
-					  id, sc);
-			break;
-		}
+
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			"icmnd_cmpl abts pending "
+			  "hdr status = %s tag = 0x%x sc = 0x%p"
+			  "scsi_status = %x residual = %d\n",
+			  fnic_fcpio_status_to_str(hdr_status),
+			  id, sc,
+			  icmnd_cmpl->scsi_status,
+			  icmnd_cmpl->residual);
 		return;
 	}
 
-- 
2.5.5
