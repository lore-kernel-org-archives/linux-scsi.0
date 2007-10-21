From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 16/17] SCSI: driver irq handler cleanups
Date: Sun, 21 Oct 2007 03:52:53 -0400 (EDT)
Message-ID: <20071021075253.736AA19041C@havoc.gtf.org>
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:41069 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbXJUHwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

commit c0847f02496b1b8feb64637fc8609500ff69b3f2
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:37:20 2007 -0400

    [SCSI] driver irq handler cleanups
    
    Avoid the need to use 'irq' function arg to look up data (data we
    already had, in every case).
    
    This permits the removal of arrays in some drivers that existed for the
    sole purpose of looking up data we already knew.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/scsi/aha1542.c |   22 ++++++++--------------
 drivers/scsi/eata.c    |   11 ++++-------
 drivers/scsi/psi240i.c |   14 ++++----------
 drivers/scsi/u14-34f.c |    9 ++++-----
 4 files changed, 20 insertions(+), 36 deletions(-)

c0847f02496b1b8feb64637fc8609500ff69b3f2
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 961a188..97c660e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -163,8 +163,6 @@ struct aha1542_hostdata {
 
 #define HOSTDATA(host) ((struct aha1542_hostdata *) &host->hostdata)
 
-static struct Scsi_Host *aha_host[7];	/* One for each IRQ level (9-15) */
-
 static DEFINE_SPINLOCK(aha1542_lock);
 
 
@@ -173,8 +171,7 @@ static DEFINE_SPINLOCK(aha1542_lock);
 
 static void setup_mailboxes(int base_io, struct Scsi_Host *shpnt);
 static int aha1542_restart(struct Scsi_Host *shost);
-static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id);
-static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id);
+static void aha1542_intr_handle(struct Scsi_Host *shost);
 
 #define aha1542_intr_reset(base)  outb(IRST, CONTROL(base))
 
@@ -414,23 +411,19 @@ fail:
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
@@ -1224,7 +1217,8 @@ fail:
 
 			DEB(printk("aha1542_detect: enable interrupt channel %d\n", irq_level));
 			spin_lock_irqsave(&aha1542_lock, flags);
-			if (request_irq(irq_level, do_aha1542_intr_handle, 0, "aha1542", NULL)) {
+			if (request_irq(irq_level, do_aha1542_intr_handle, 0,
+					"aha1542", shpnt)) {
 				printk(KERN_ERR "Unable to allocate IRQ for adaptec controller.\n");
 				spin_unlock_irqrestore(&aha1542_lock, flags);
 				goto unregister;
@@ -1241,7 +1235,7 @@ fail:
 					enable_dma(dma_chan);
 				}
 			}
-			aha_host[irq_level - 9] = shpnt;
+
 			shpnt->this_id = scsi_id;
 			shpnt->unique_id = base_io;
 			shpnt->io_port = base_io;
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 7ead521..302793d 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -2287,17 +2287,14 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec,
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
@@ -2536,7 +2533,7 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 	return IRQ_NONE;
 }
 
-static irqreturn_t do_interrupt_handler(int irq, void *shap)
+static irqreturn_t do_interrupt_handler(int dummy, void *shap)
 {
 	struct Scsi_Host *shost;
 	unsigned int j;
@@ -2549,7 +2546,7 @@ static irqreturn_t do_interrupt_handler(int irq, void *shap)
 	shost = sh[j];
 
 	spin_lock_irqsave(shost->host_lock, spin_flags);
-	ret = ihdlr(irq, shost);
+	ret = ihdlr(shost);
 	spin_unlock_irqrestore(shost->host_lock, spin_flags);
 	return ret;
 }
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 899e89d..300ac9e 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -98,7 +98,6 @@ typedef struct
 
 #define HOSTDATA(host) ((PADAPTER240I)&host->hostdata)
 
-static struct	Scsi_Host *PsiHost[6] = {NULL,};  /* One for each IRQ level (10-15) */
 static			IDENTIFY_DATA	identifyData;
 static			SETUP			ChipSetup;
 
@@ -251,9 +250,9 @@ static ULONG DecodeError (struct Scsi_Host *pshost, UCHAR status)
  *	Returns:		TRUE if drive is not ready in time.
  *
  ****************************************************************/
-static void Irq_Handler (int irq, void *dev_id)
+static void Irq_Handler (struct Scsi_Host *shost_in)
 	{
-	struct Scsi_Host *shost;	// Pointer to host data block
+	struct Scsi_Host *shost = shost_in; // Pointer to host data block
 	PADAPTER240I padapter;		// Pointer to adapter control structure
 	USHORT *pports;			// I/O port array
 	struct scsi_cmnd *SCpnt;
@@ -262,10 +261,6 @@ static void Irq_Handler (int irq, void *dev_id)
 
 	DEB(printk ("\npsi240i received interrupt\n"));
 
-	shost = PsiHost[irq - 10];
-	if ( !shost )
-		panic ("Splunge!");
-
 	padapter = HOSTDATA(shost);
 	pports = padapter->ports;
 	SCpnt = padapter->SCpnt;
@@ -367,13 +362,13 @@ irqerror:;
 	SCpnt->scsi_done (SCpnt);
 	}
 
-static irqreturn_t do_Irq_Handler (int irq, void *dev_id)
+static irqreturn_t do_Irq_Handler (int dummy, void *dev_id)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
-	Irq_Handler(irq, dev_id);
+	Irq_Handler(dev);
 	spin_unlock_irqrestore(dev->host_lock, flags);
 	return IRQ_HANDLED;
 }
@@ -583,7 +578,6 @@ static int Psi240i_Detect (struct scsi_host_template *tpnt)
 		if(pshost == NULL)
 			goto host_init_failure;	
 
-		PsiHost[chipConfig.irq - 10] = pshost;
 		pshost->unique_id = port;
 		pshost->io_port = port;
 		pshost->n_io_port = 16;  /* Number of bytes of I/O space used */
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 7edd6ce..a2d704b 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1716,13 +1716,12 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec, unsigned in
 
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
@@ -1936,7 +1935,7 @@ static irqreturn_t do_interrupt_handler(int irq, void *shap) {
    if ((j = (unsigned int)((char *)shap - sha)) >= num_boards) return IRQ_NONE;
 
    spin_lock_irqsave(sh[j]->host_lock, spin_flags);
-   ret = ihdlr(irq, j);
+   ret = ihdlr(j);
    spin_unlock_irqrestore(sh[j]->host_lock, spin_flags);
    return ret;
 }
