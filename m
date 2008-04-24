From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v2] SCSI/aha1542: minor irq handler cleanups
Date: Thu, 24 Apr 2008 19:45:32 -0400
Message-ID: <20080424234532.GA29471@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:36085 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYDXXpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 19:45:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

- where the 'irq' function argument is known never to be used, rename
  it to 'dummy' to make this more obvious
    
- replace per-irq lookup functions and tables with a direct reference
  to data object obtained via 'dev_id' function argument, passed from
  request_irq()

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
NOTE: The previous version failed to update free_irq(), which created a
new bug.

 drivers/scsi/aha1542.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 5a1471c..8059494 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -153,8 +153,6 @@ struct aha1542_hostdata {
 
 #define HOSTDATA(host) ((struct aha1542_hostdata *) &host->hostdata)
 
-static struct Scsi_Host *aha_host[7];	/* One for each IRQ level (9-15) */
-
 static DEFINE_SPINLOCK(aha1542_lock);
 
 
@@ -163,8 +161,7 @@ static DEFINE_SPINLOCK(aha1542_lock);
 
 static void setup_mailboxes(int base_io, struct Scsi_Host *shpnt);
 static int aha1542_restart(struct Scsi_Host *shost);
-static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id);
-static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id);
+static void aha1542_intr_handle(struct Scsi_Host *shost);
 
 #define aha1542_intr_reset(base)  outb(IRST, CONTROL(base))
 
@@ -404,23 +401,19 @@ fail:
 }
 
 /* A quick wrapper for do_aha1542_intr_handle to grab the spin lock */
-static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id)
+static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 {
 	unsigned long flags;
-	struct Scsi_Host *shost;
-
-	shost = aha_host[irq - 9];
-	if (!shost)
-		panic("Splunge!");
+	struct Scsi_Host *shost = dev_id;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	aha1542_intr_handle(shost, dev_id);
+	aha1542_intr_handle(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
 /* A "high" level interrupt handler */
-static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id)
+static void aha1542_intr_handle(struct Scsi_Host *shost)
 {
 	void (*my_done) (Scsi_Cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
@@ -1197,7 +1190,8 @@ fail:
 
 			DEB(printk("aha1542_detect: enable interrupt channel %d\n", irq_level));
 			spin_lock_irqsave(&aha1542_lock, flags);
-			if (request_irq(irq_level, do_aha1542_intr_handle, 0, "aha1542", NULL)) {
+			if (request_irq(irq_level, do_aha1542_intr_handle, 0,
+					"aha1542", shpnt)) {
 				printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
 				spin_unlock_irqrestore(&aha1542_lock, flags);
 				goto unregister;
@@ -1205,7 +1199,7 @@ fail:
 			if (dma_chan != 0xFF) {
 				if (request_dma(dma_chan, "aha1542")) {
 					printk(KERN_ERR "Unable to allocate DMA channel for Adaptec.\n");
-					free_irq(irq_level, NULL);
+					free_irq(irq_level, shpnt);
 					spin_unlock_irqrestore(&aha1542_lock, flags);
 					goto unregister;
 				}
@@ -1214,7 +1208,7 @@ fail:
 					enable_dma(dma_chan);
 				}
 			}
-			aha_host[irq_level - 9] = shpnt;
+
 			shpnt->this_id = scsi_id;
 			shpnt->unique_id = base_io;
 			shpnt->io_port = base_io;
@@ -1276,7 +1270,7 @@ unregister:
 static int aha1542_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
