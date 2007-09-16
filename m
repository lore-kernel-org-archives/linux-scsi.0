From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 13/17] advansys: Remove private lock
Date: Sun, 16 Sep 2007 09:37:44 -0600
Message-ID: <1189957069906-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52716 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXIPPhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:50 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The board lock was essentially identical with the host lock.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 95df291..b652032 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2439,7 +2439,6 @@ struct asc_board {
 		ADVEEP_38C1600_CONFIG adv_38C1600_eep;	/* 38C1600 EEPROM config. */
 	} eep_config;
 	ulong last_reset;	/* Saved last reset time */
-	spinlock_t lock;	/* Board spinlock */
 	/* /proc/scsi/advansys/[0...] */
 	char *prtbuf;		/* /proc print buffer */
 #ifdef ADVANSYS_STATS
@@ -9621,7 +9620,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		}
 
 		ASC_DBG(1, "after AscInitAsc1000Driver()\n");
-		spin_lock_irqsave(&boardp->lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 	} else {
 		/*
 		 * If the suggest reset bus flags are set, then reset the bus.
@@ -9644,13 +9643,13 @@ static int advansys_reset(struct scsi_cmnd *scp)
 			ret = FAILED;
 			break;
 		}
-		spin_lock_irqsave(&boardp->lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 		AdvISR(adv_dvc);
 	}
 
 	/* Save the time of the most recently completed reset. */
 	boardp->last_reset = jiffies;
-	spin_unlock_irqrestore(&boardp->lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	ASC_DBG(1, "ret %d\n", ret);
 
@@ -9707,13 +9706,12 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
  */
 static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
-	unsigned long flags;
 	struct Scsi_Host *shost = dev_id;
 	struct asc_board *boardp = shost_priv(shost);
 	irqreturn_t result = IRQ_NONE;
 
 	ASC_DBG(2, "boardp 0x%p\n", boardp);
-	spin_lock_irqsave(&boardp->lock, flags);
+	spin_lock(shost->host_lock);
 	if (ASC_NARROW_BOARD(boardp)) {
 		if (AscIsIntPending(shost->io_port)) {
 			result = IRQ_HANDLED;
@@ -9728,7 +9726,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 			ASC_STATS(shost, interrupt);
 		}
 	}
-	spin_unlock_irqrestore(&boardp->lock, flags);
+	spin_unlock(shost->host_lock);
 
 	ASC_DBG(1, "end\n");
 	return result;
@@ -11203,20 +11201,12 @@ static int
 advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *shost = scp->device->host;
-	struct asc_board *boardp = shost_priv(shost);
-	unsigned long flags;
 	int asc_res, result = 0;
 
 	ASC_STATS(shost, queuecommand);
 	scp->scsi_done = done;
 
-	/*
-	 * host_lock taken by mid-level prior to call, but need
-	 * to protect against own ISR
-	 */
-	spin_lock_irqsave(&boardp->lock, flags);
 	asc_res = asc_execute_scsi_cmnd(scp);
-	spin_unlock_irqrestore(&boardp->lock, flags);
 
 	switch (asc_res) {
 	case ASC_NOERROR:
@@ -13633,7 +13623,6 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	int share_irq, warn_code, ret;
 
 	boardp->id = asc_board_count++;
-	spin_lock_init(&boardp->lock);
 	pdev = (bus_type == ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NULL;
 
 	if (ASC_NARROW_BOARD(boardp)) {
-- 
1.5.2.4

