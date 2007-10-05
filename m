From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/17] sym53c8xx: Don't disable interrupts in the interrupt handler
Date: Fri,  5 Oct 2007 15:55:02 -0400
Message-ID: <11916141143743-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:40284 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761028AbXJETzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:20 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Interrupts can't be re-entered, so it's sufficient to call spin_lock, not
spin_lock_irqsave().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d614a9c..4d49a9b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -550,14 +550,13 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
  */
 static irqreturn_t sym53c8xx_intr(int irq, void *dev_id)
 {
-	unsigned long flags;
-	struct sym_hcb *np = (struct sym_hcb *)dev_id;
+	struct sym_hcb *np = dev_id;
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
-	spin_lock_irqsave(np->s.host->host_lock, flags);
+	spin_lock(np->s.host->host_lock);
 	sym_interrupt(np);
-	spin_unlock_irqrestore(np->s.host->host_lock, flags);
+	spin_unlock(np->s.host->host_lock);
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
 
-- 
1.4.4.2

