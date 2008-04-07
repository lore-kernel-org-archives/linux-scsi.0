From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/4] lpfc 8.2.6 : PCI Parity and EEH handling fixes
Date: Mon, 07 Apr 2008 10:16:00 -0400
Message-ID: <1207577760.28169.12.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33289 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYDGOQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 10:16:03 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m37EFx9B010283
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 07:16:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


PCI Parity and EEH handling Fixes:
- Under a PCI Data Parity Error, remove a completion routine callback that
  was on a command that we had already failed and released.
- Under PCI parity error, we were not reinstalling the interrupt handler
  in the slot_reset callback, so we never became functional again.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   31 +++++++++++++++++++++++++++++++
 lpfc_sli.c  |    3 +--
 2 files changed, 32 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-04-07 09:15:06.000000000 -0400
@@ -2371,6 +2371,7 @@ static pci_ers_result_t lpfc_io_slot_res
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	struct lpfc_sli *psli = &phba->sli;
+	int error, retval;
 
 	dev_printk(KERN_INFO, &pdev->dev, "recovering from a slot reset.\n");
 	if (pci_enable_device_mem(pdev)) {
@@ -2385,6 +2386,36 @@ static pci_ers_result_t lpfc_io_slot_res
 	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Enable configured interrupt method */
+	phba->intr_type = NONE;
+	if (phba->cfg_use_msi == 2) {
+		error = lpfc_enable_msix(phba);
+		if (!error)
+			phba->intr_type = MSIX;
+	}
+
+	/* Fallback to MSI if MSI-X initialization failed */
+	if (phba->cfg_use_msi >= 1 && phba->intr_type == NONE) {
+		retval = pci_enable_msi(phba->pcidev);
+		if (!retval)
+			phba->intr_type = MSI;
+		else
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"0470 Enable MSI failed, continuing "
+					"with IRQ\n");
+	}
+
+	/* MSI-X is the only case the doesn't need to call request_irq */
+	if (phba->intr_type != MSIX) {
+		retval = request_irq(phba->pcidev->irq, lpfc_intr_handler,
+				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+		if (retval) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"0471 Enable interrupt handler "
+					"failed\n");
+		} else if (phba->intr_type != MSI)
+			phba->intr_type = INTx;
+	}
 
 	/* Take device offline; this will perform cleanup */
 	lpfc_offline(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-04-07 09:12:39.000000000 -0400
@@ -3634,8 +3634,7 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 		 *  If the iocb is not found in Firmware queue the iocb
 		 *  might have completed already. Do not free it again.
 		 */
-		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-			(irsp->un.ulpWord[4] == IOERR_NO_XRI)) {
+		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
 			spin_unlock_irq(&phba->hbalock);
 			lpfc_sli_release_iocbq(phba, cmdiocb);
 			return;


