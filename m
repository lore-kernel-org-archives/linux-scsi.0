From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 06/15] [SCSI] minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:52 -0400 (EDT)
Message-ID: <67d4d42bfa0ff35f765b4522fadaea534cbeb098.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:51364 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbYDRXdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 19:33:39 -0400
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

- remove pointless casts from void*

- remove needless references to 'irq' function argument, when that
  information is already stored somewhere in a driver-private struct.

- where the 'irq' function argument is known never to be used, rename
  it to 'dummy' to make this more obvious

- remove always-false tests for dev_id==NULL

- remove always-true tests for 'irq == host_struct->irq'

- replace per-irq lookup functions and tables with a direct reference
  to data object obtained via 'dev_id' function argument, passed from
  request_irq()

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

---
 drivers/scsi/aha152x.c |    7 +------
 drivers/scsi/eata.c    |   11 ++++-------
 drivers/scsi/u14-34f.c |    9 ++++-----
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 6ccdc96..a09b2d3 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1432,15 +1432,10 @@ static void run(struct work_struct *work)
  */
 static irqreturn_t intr(int irqno, void *dev_id)
 {
-	struct Scsi_Host *shpnt = (struct Scsi_Host *)dev_id;
+	struct Scsi_Host *shpnt = dev_id;
 	unsigned long flags;
 	unsigned char rev, dmacntrl0;
 
-	if (!shpnt) {
-		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
-		return IRQ_NONE;
-	}
-
 	/*
 	 * Read a couple of registers that are known to not be all 1's. If
 	 * we read all 1's (-1), that means that either:
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 8be3d76..a73a6bb 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2286,17 +2286,14 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec,
 	}
 }
 
-static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
+static irqreturn_t ihdlr(struct Scsi_Host *shost)
 {
 	struct scsi_cmnd *SCpnt;
 	unsigned int i, k, c, status, tstatus, reg;
 	struct mssp *spp;
 	struct mscp *cpp;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
-
-	if (shost->irq != irq)
-		panic("%s: ihdlr, irq %d, shost->irq %d.\n", ha->board_name, irq,
-		      shost->irq);
+	int irq = shost->irq;
 
 	/* Check if this board need to be serviced */
 	if (!(inb(shost->io_port + REG_AUX_STATUS) & IRQ_ASSERTED))
@@ -2535,7 +2532,7 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 	return IRQ_NONE;
 }
 
-static irqreturn_t do_interrupt_handler(int irq, void *shap)
+static irqreturn_t do_interrupt_handler(int dummy, void *shap)
 {
 	struct Scsi_Host *shost;
 	unsigned int j;
@@ -2548,7 +2545,7 @@ static irqreturn_t do_interrupt_handler(int irq, void *shap)
 	shost = sh[j];
 
 	spin_lock_irqsave(shost->host_lock, spin_flags);
-	ret = ihdlr(irq, shost);
+	ret = ihdlr(shost);
 	spin_unlock_irqrestore(shost->host_lock, spin_flags);
 	return ret;
 }
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 58d7eee..640333b 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1715,13 +1715,12 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec, unsigned in
 
 }
 
-static irqreturn_t ihdlr(int irq, unsigned int j) {
+static irqreturn_t ihdlr(unsigned int j)
+{
    struct scsi_cmnd *SCpnt;
    unsigned int i, k, c, status, tstatus, reg, ret;
    struct mscp *spp, *cpp;
-
-   if (sh[j]->irq != irq)
-       panic("%s: ihdlr, irq %d, sh[j]->irq %d.\n", BN(j), irq, sh[j]->irq);
+   int irq = sh[j]->irq;
 
    /* Check if this board need to be serviced */
    if (!((reg = inb(sh[j]->io_port + REG_SYS_INTR)) & IRQ_ASSERTED)) goto none;
@@ -1935,7 +1934,7 @@ static irqreturn_t do_interrupt_handler(int irq, void *shap) {
    if ((j = (unsigned int)((char *)shap - sha)) >= num_boards) return IRQ_NONE;
 
    spin_lock_irqsave(sh[j]->host_lock, spin_flags);
-   ret = ihdlr(irq, j);
+   ret = ihdlr(j);
    spin_unlock_irqrestore(sh[j]->host_lock, spin_flags);
    return ret;
 }
-- 
1.5.4.1

