From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 07/15] [SCSI] aha1542: minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:54 -0400 (EDT)
Message-ID: <70159e4a9060dee3fee3d41e22a4d78c5ba95120.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:53255 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbYDRXdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 19:33:39 -0400
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

- where the 'irq' function argument is known never to be used, rename
  it to 'dummy' to make this more obvious

- replace per-irq lookup functions and tables with a direct reference
  to data object obtained via 'dev_id' function argument, passed from
  request_irq()

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/aha1542.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 5a1471c..1375915 100644
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
@@ -1214,7 +1208,7 @@ fail:
 					enable_dma(dma_chan);
 				}
 			}
-			aha_host[irq_level - 9] = shpnt;
+
 			shpnt->this_id = scsi_id;
 			shpnt->unique_id = base_io;
 			shpnt->io_port = base_io;
-- 
1.5.4.1

