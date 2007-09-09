From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 07/22] advansys: Remove a check for an impossible condition
Date: Sun,  9 Sep 2007 08:56:32 -0600
Message-ID: <11893498072175-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45143 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbXIIO4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:47 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The midlayer guarantees it won't call ->queuecommand for a host which
is handling a reset condition.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 526239a..cd17f28 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3281,25 +3281,6 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done) (struct scsi_cmnd *))
 	/* against own ISR */
 	spin_lock_irqsave(&boardp->lock, flags);
 
-	/*
-	 * Block new commands while handling a reset or abort request.
-	 */
-	if (boardp->flags & ASC_HOST_IN_RESET) {
-		ASC_DBG1(1,
-			 "advansys_queuecommand: scp 0x%lx blocked for reset request\n",
-			 (ulong)scp);
-		scp->result = HOST_BYTE(DID_RESET);
-
-		/*
-		 * Add blocked requests to the board's 'done' queue. The queued
-		 * requests will be completed at the end of the abort or reset
-		 * handling.
-		 */
-		asc_enqueue(&boardp->done, scp, ASC_BACK);
-		spin_unlock_irqrestore(&boardp->lock, flags);
-		return 0;
-	}
-
 	scp->scsi_done = done;
 	asc_res = asc_execute_scsi_cmnd(scp);
 	switch (asc_res) {
-- 
1.5.2.4

