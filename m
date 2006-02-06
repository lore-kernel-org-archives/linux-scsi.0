From: brking@us.ibm.com
Subject: [patch 09/15] libata: Improved ata_exec_internal timeout handling
Date: Mon, 06 Feb 2006 09:42:28 -0600
Message-ID: <200602061542.k16FgYf0002182@d01av01.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Currently ata_exec_internal does very minimal cleanup if
the executing command times out. This works for most usage
scenarios, but can cause problems for hosts that set
ATA_FLAG_PIO_DMA. For these users, the DMA buffer gets unmapped
while the timed out out command is still active, which has
the potential to cause PCI DMA errors if the command is
still in progress. The following patch modifies ata_exec_internal
to invoke eng_timeout on a timeout to allow for the timed out
command to be cleaned up better before proceeding further.
This patch is also in preparation for SAS attached SATA devices.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ahci.c         |    5 +----
 drivers/scsi/libata-core.c  |   21 ++++-----------------
 drivers/scsi/sata_mv.c      |   10 +++-------
 drivers/scsi/sata_promise.c |    5 +----
 drivers/scsi/sata_sil24.c   |    5 +----
 5 files changed, 10 insertions(+), 36 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_exec_internal_timeout drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_exec_internal_timeout	2006-02-03 12:38:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-03 12:41:07.000000000 -0600
@@ -1108,9 +1108,9 @@ void ata_qc_complete_internal(struct ata
  *
  *	Executes libata internal command with timeout.  @tf contains
  *	command on entry and result on return.  Timeout and error
- *	conditions are reported via return value.  No recovery action
- *	is taken after a command times out.  It's caller's duty to
- *	clean up after timeout.
+ *	conditions are reported via return value.  If command
+ *	times out, the timeout will be reported via eng_timeout to
+ *	allow for proper cleanup so the qc can be freed.
  *
  *	LOCKING:
  *	None.  Should be called with kernel context, might sleep.
@@ -1150,18 +1150,11 @@ ata_exec_internal(struct ata_port *ap, s
 
 	if (!wait_for_completion_timeout(&wait, ATA_TMOUT_INTERNAL)) {
 		spin_lock_irqsave(ap->lock, flags);
-
-		/* We're racing with irq here.  If we lose, the
-		 * following test prevents us from completing the qc
-		 * again.  If completion irq occurs after here but
-		 * before the caller cleans up, it will result in a
-		 * spurious interrupt.  We can live with that.
-		 */
 		if (qc->flags & ATA_QCFLAG_ACTIVE) {
 			qc->err_mask = AC_ERR_TIMEOUT;
-			ata_qc_complete(qc);
 			printk(KERN_WARNING "ata%u: qc timeout (cmd 0x%x)\n",
 			       ap->id, command);
+			ap->ops->eng_timeout(ap);
 		}
 
 		spin_unlock_irqrestore(ap->lock, flags);
@@ -3846,13 +3839,7 @@ void ata_eng_timeout(struct ata_port *ap
 	qc = ata_qc_from_tag(ap, ap->active_tag);
 	if (qc)
 		ata_qc_timeout(qc);
-	else {
-		printk(KERN_ERR "ata%u: BUG: timeout without command\n",
-		       ap->id);
-		goto out;
-	}
 
-out:
 	DPRINTK("EXIT\n");
 }
 
diff -puN drivers/scsi/ahci.c~libata_exec_internal_timeout drivers/scsi/ahci.c
--- libata-dev/drivers/scsi/ahci.c~libata_exec_internal_timeout	2006-02-03 12:38:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ahci.c	2006-02-03 12:38:14.000000000 -0600
@@ -677,10 +677,7 @@ static void ahci_eng_timeout(struct ata_
 	spin_lock_irqsave(&host_set->lock, flags);
 
 	qc = ata_qc_from_tag(ap, ap->active_tag);
-	if (!qc) {
-		printk(KERN_ERR "ata%u: BUG: timeout without command\n",
-		       ap->id);
-	} else {
+	if (qc) {
 		ahci_restart_port(ap, readl(port_mmio + PORT_IRQ_STAT));
 		qc->err_mask |= AC_ERR_TIMEOUT;
 	}
diff -puN drivers/scsi/sata_mv.c~libata_exec_internal_timeout drivers/scsi/sata_mv.c
--- libata-dev/drivers/scsi/sata_mv.c~libata_exec_internal_timeout	2006-02-03 12:38:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/sata_mv.c	2006-02-03 12:38:15.000000000 -0600
@@ -2019,17 +2019,13 @@ static void mv_eng_timeout(struct ata_po
 			 to_pci_dev(ap->host_set->dev));
 
 	qc = ata_qc_from_tag(ap, ap->active_tag);
-        printk(KERN_ERR "mmio_base %p ap %p qc %p scsi_cmnd %p &cmnd %p\n",
-	       ap->host_set->mmio_base, ap, qc, qc->scsicmd,
-	       &qc->scsicmd->cmnd);
+        printk(KERN_ERR "mmio_base %p ap %p qc %p scsi_cmnd %p\n",
+	       ap->host_set->mmio_base, ap, qc, qc->scsicmd);
 
 	mv_err_intr(ap);
 	mv_stop_and_reset(ap);
 
-	if (!qc) {
-		printk(KERN_ERR "ata%u: BUG: timeout without command\n",
-		       ap->id);
-	} else {
+	if (qc) {
 		qc->err_mask |= AC_ERR_TIMEOUT;
 		ata_eh_qc_complete(qc);
 	}
diff -puN drivers/scsi/sata_promise.c~libata_exec_internal_timeout drivers/scsi/sata_promise.c
--- libata-dev/drivers/scsi/sata_promise.c~libata_exec_internal_timeout	2006-02-03 12:38:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/sata_promise.c	2006-02-03 12:38:14.000000000 -0600
@@ -431,11 +431,8 @@ static void pdc_eng_timeout(struct ata_p
 	spin_lock_irqsave(&host_set->lock, flags);
 
 	qc = ata_qc_from_tag(ap, ap->active_tag);
-	if (!qc) {
-		printk(KERN_ERR "ata%u: BUG: timeout without command\n",
-		       ap->id);
+	if (!qc)
 		goto out;
-	}
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
diff -puN drivers/scsi/sata_sil24.c~libata_exec_internal_timeout drivers/scsi/sata_sil24.c
--- libata-dev/drivers/scsi/sata_sil24.c~libata_exec_internal_timeout	2006-02-03 12:38:14.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/sata_sil24.c	2006-02-03 12:38:14.000000000 -0600
@@ -638,11 +638,8 @@ static void sil24_eng_timeout(struct ata
 	struct ata_queued_cmd *qc;
 
 	qc = ata_qc_from_tag(ap, ap->active_tag);
-	if (!qc) {
-		printk(KERN_ERR "ata%u: BUG: timeout without command\n",
-		       ap->id);
+	if (!qc)
 		return;
-	}
 
 	printk(KERN_ERR "ata%u: command timeout\n", ap->id);
 	qc->err_mask |= AC_ERR_TIMEOUT;
_
