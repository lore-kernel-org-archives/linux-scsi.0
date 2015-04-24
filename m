From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/22] advansys: use spin_lock_irqsave() in interrupt handler
Date: Fri, 24 Apr 2015 10:32:56 +0200
Message-ID: <1429864377-67002-22-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966495AbbDXIdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:16 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

We should be using spin_lock_irqsave() when within the
interrupt handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2c9f9e9..2c4efb4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7242,9 +7242,10 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	struct Scsi_Host *shost = dev_id;
 	struct asc_board *boardp = shost_priv(shost);
 	irqreturn_t result = IRQ_NONE;
+	unsigned long flags;
 
 	ASC_DBG(2, "boardp 0x%p\n", boardp);
-	spin_lock(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, flags);
 	if (ASC_NARROW_BOARD(boardp)) {
 		if (AscIsIntPending(shost->io_port)) {
 			result = IRQ_HANDLED;
@@ -7259,7 +7260,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 			ASC_STATS(shost, interrupt);
 		}
 	}
-	spin_unlock(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	ASC_DBG(1, "end\n");
 	return result;
-- 
1.8.5.2

