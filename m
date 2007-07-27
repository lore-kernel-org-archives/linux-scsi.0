From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/2] arcmsr: irq handler fixes, cleanups, micro-opts
Date: Fri, 27 Jul 2007 13:01:15 -0400
Message-ID: <20070727170114.GA27441@havoc.gtf.org>
References: <20070727170048.GA27353@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S937293AbXG0RBa@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070727170048.GA27353@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, erich@areca.com.tw
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


commit 97618f90f021d457c5078ab85f0f443553f93d51
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 27 12:58:00 2007 -0400

    [SCSI] arcmsr: interrupt handling fixes, cleanups, micro-opts
    
    * Remove IRQF_DISABLED, it is clearly wrong for this driver.
    
    * Remove wasteful spin_lock_irqsave() in interrupt handler.
      The lighter-weight spin_lock() is all that's needed.
    
    * Annotate with FIXME where arcmsr_interrupt() is called
      without any spinlock being acquired.
    
    * Eliminate pointless cast from void pointer in arcmsr_do_interrupt()
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/arcmsr/arcmsr_hba.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

97618f90f021d457c5078ab85f0f443553f93d51
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ae26ed4..d9fadb4 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -159,14 +159,12 @@ static struct pci_driver arcmsr_pci_driver = {
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)
 {
 	irqreturn_t handle_state;
-	struct AdapterControlBlock *acb;
-	unsigned long flags;
-
-	acb = (struct AdapterControlBlock *)dev_id;
+	struct AdapterControlBlock *acb = dev_id;
 
-	spin_lock_irqsave(acb->host->host_lock, flags);
+	spin_lock(acb->host->host_lock);
 	handle_state = arcmsr_interrupt(acb);
-	spin_unlock_irqrestore(acb->host->host_lock, flags);
+	spin_unlock(acb->host->host_lock);
+
 	return handle_state;
 }
 
@@ -331,7 +329,7 @@ static int arcmsr_probe(struct pci_dev *pdev,
 		goto out_iounmap;
 
 	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "arcmsr", acb);
+			    IRQF_SHARED, "arcmsr", acb);
 	if (error)
 		goto out_free_ccb_pool;
 
@@ -421,7 +419,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	for (poll_count = 0; poll_count < 256; poll_count++) {
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);
+		arcmsr_interrupt(acb);	/* FIXME: need spinlock */
 		msleep(25);
 	}
 
@@ -1452,7 +1450,7 @@ static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 	for (i = 0; i < 400; i++) {
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);
+		arcmsr_interrupt(acb);	/* FIXME: need spinlock */
 		msleep(25);
 	}
 	arcmsr_iop_reset(acb);
