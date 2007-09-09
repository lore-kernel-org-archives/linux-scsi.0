From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 10/22] advansys: Enable interrupts earlier in queuecommand
Date: Sun,  9 Sep 2007 08:56:35 -0600
Message-ID: <1189349807463-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45154 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbXIIO4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:48 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Move as much as possible outside the critical section in queuecommand, eg:
 - Set the scsi_done field before acquiring the lock
 - Call asc_scsi_done after dropping the lock

Also remove a comment suggesting we should enable interrupts (now we do)
and do some minor reformatting for readability.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 67cdfe6..d7bc0cf 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3176,23 +3176,24 @@ static void asc_scsi_done(struct scsi_cmnd *scp)
  * in the 'scp' result field.
  */
 static int
-advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
+advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
-	struct Scsi_Host *shost;
-	asc_board_t *boardp;
-	ulong flags;
+	struct Scsi_Host *shost = scp->device->host;
+	asc_board_t *boardp = ASC_BOARDP(shost);
+	unsigned long flags;
 	int asc_res, result = 0;
 
-	shost = scp->device->host;
-	boardp = ASC_BOARDP(shost);
 	ASC_STATS(shost, queuecommand);
+	scp->scsi_done = done;
 
-	/* host_lock taken by mid-level prior to call but need to protect */
-	/* against own ISR */
+	/*
+	 * host_lock taken by mid-level prior to call, but need
+	 * to protect against own ISR
+	 */
 	spin_lock_irqsave(&boardp->lock, flags);
-
-	scp->scsi_done = done;
 	asc_res = asc_execute_scsi_cmnd(scp);
+	spin_unlock_irqrestore(&boardp->lock, flags);
+
 	switch (asc_res) {
 	case ASC_NOERROR:
 		break;
@@ -3201,11 +3202,9 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 		break;
 	case ASC_ERROR:
 	default:
-		/* Interrupts could be enabled here. */
 		asc_scsi_done(scp);
 		break;
 	}
-	spin_unlock_irqrestore(&boardp->lock, flags);
 
 	return result;
 }
-- 
1.5.2.4

