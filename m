From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/6] lpfc 8.2.5 : Add MSI-X single message support
Date: Fri, 08 Feb 2008 18:49:51 -0500
Message-ID: <1202514591.20924.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44684 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbYBHXti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 18:49:38 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m18NnaUj018575
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 15:49:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add MSI-X single message support


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |   10 +++++-
 lpfc_attr.c |    6 ++-
 lpfc_init.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 91 insertions(+), 22 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-02-08 18:10:59.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-02-08 18:12:03.000000000 -0500
@@ -1592,9 +1592,11 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 #		support this feature
 #       0  = MSI disabled (default)
 #       1  = MSI enabled
-# Value range is [0,1]. Default value is 0.
+#	2  = MSI-X enabled
+# Value range is [0,2]. Default value is 0.
 */
-LPFC_ATTR_R(use_msi, 0, 0, 1, "Use Message Signaled Interrupts, if possible");
+LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
+	    "MSI-X (2), if possible");
 
 /*
 # lpfc_enable_hba_reset: Allow or prevent HBA resets to the hardware.
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:10:53.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:12:03.000000000 -0500
@@ -392,6 +392,13 @@ enum hba_temp_state {
 	HBA_OVER_TEMP
 };
 
+enum intr_type_t {
+	NONE = 0,
+	INTx,
+	MSI,
+	MSIX,
+};
+
 struct lpfc_hba {
 	struct lpfc_sli sli;
 	uint32_t sli_rev;		/* SLI2 or SLI3 */
@@ -555,7 +562,8 @@ struct lpfc_hba {
 	mempool_t *nlp_mem_pool;
 
 	struct fc_host_statistics link_stats;
-	uint8_t using_msi;
+	enum intr_type_t intr_type;
+	struct msix_entry msix_entries[1];
 
 	struct list_head port_list;
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:11:20.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:12:03.000000000 -0500
@@ -1924,6 +1924,42 @@ void lpfc_host_attrib_init(struct Scsi_H
 	spin_unlock_irq(shost->host_lock);
 }
 
+static int
+lpfc_enable_msix(struct lpfc_hba *phba)
+{
+	int error;
+
+	phba->msix_entries[0].entry = 0;
+	phba->msix_entries[0].vector = 0;
+
+	error = pci_enable_msix(phba->pcidev, phba->msix_entries,
+				ARRAY_SIZE(phba->msix_entries));
+	if (error) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0420 Enable MSI-X failed (%d), continuing "
+				"with MSI\n", error);
+		pci_disable_msix(phba->pcidev);
+		return error;
+	}
+
+	error =	request_irq(phba->msix_entries[0].vector, lpfc_intr_handler, 0,
+			    LPFC_DRIVER_NAME, phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0421 MSI-X request_irq failed (%d), "
+				"continuing with MSI\n", error);
+		pci_disable_msix(phba->pcidev);
+	}
+	return error;
+}
+
+static void
+lpfc_disable_msix(struct lpfc_hba *phba)
+{
+	free_irq(phba->msix_entries[0].vector, phba);
+	pci_disable_msix(phba->pcidev);
+}
+
 static int __devinit
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
@@ -2125,24 +2161,36 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	lpfc_debugfs_initialize(vport);
 
 	pci_set_drvdata(pdev, shost);
+	phba->intr_type = NONE;
+
+	if (phba->cfg_use_msi == 2) {
+		error = lpfc_enable_msix(phba);
+		if (!error)
+			phba->intr_type = MSIX;
+	}
 
-	if (phba->cfg_use_msi) {
+	/* Fallback to MSI if MSI-X initialization failed */
+	if (phba->cfg_use_msi >= 1 && phba->intr_type == NONE) {
 		retval = pci_enable_msi(phba->pcidev);
 		if (!retval)
-			phba->using_msi = 1;
+			phba->intr_type = MSI;
 		else
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"0452 Enable MSI failed, continuing "
 					"with IRQ\n");
 	}
 
-	retval = request_irq(phba->pcidev->irq, lpfc_intr_handler, IRQF_SHARED,
-			    LPFC_DRIVER_NAME, phba);
-	if (retval) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0451 Enable interrupt handler failed\n");
-		error = retval;
-		goto out_disable_msi;
+	/* MSI-X is the only case the doesn't need to call request_irq */
+	if (phba->intr_type != MSIX) {
+		retval = request_irq(phba->pcidev->irq, lpfc_intr_handler,
+				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+		if (retval) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT, "0451 Enable "
+					"interrupt handler failed\n");
+			error = retval;
+			goto out_disable_msi;
+		} else if (phba->intr_type != MSI)
+			phba->intr_type = INTx;
 	}
 
 	phba->MBslimaddr = phba->slim_memmap_p;
@@ -2187,9 +2235,14 @@ out_remove_device:
 out_free_irq:
 	lpfc_stop_phba_timers(phba);
 	phba->pport->work_port_events = 0;
-	free_irq(phba->pcidev->irq, phba);
+
+	if (phba->intr_type == MSIX)
+		lpfc_disable_msix(phba);
+	else
+		free_irq(phba->pcidev->irq, phba);
+
 out_disable_msi:
-	if (phba->using_msi)
+	if (phba->intr_type == MSI)
 		pci_disable_msi(phba->pcidev);
 	destroy_port(vport);
 out_kthread_stop:
@@ -2262,10 +2315,13 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	lpfc_debugfs_terminate(vport);
 
-	/* Release the irq reservation */
-	free_irq(phba->pcidev->irq, phba);
-	if (phba->using_msi)
-		pci_disable_msi(phba->pcidev);
+	if (phba->intr_type == MSIX)
+		lpfc_disable_msix(phba);
+	else {
+		free_irq(phba->pcidev->irq, phba);
+		if (phba->intr_type == MSI)
+			pci_disable_msi(phba->pcidev);
+	}
 
 	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(shost);
@@ -2324,10 +2380,13 @@ static pci_ers_result_t lpfc_io_error_de
 	pring = &psli->ring[psli->fcp_ring];
 	lpfc_sli_abort_iocb_ring(phba, pring);
 
-	/* Release the irq reservation */
-	free_irq(phba->pcidev->irq, phba);
-	if (phba->using_msi)
-		pci_disable_msi(phba->pcidev);
+	if (phba->intr_type == MSIX)
+		lpfc_disable_msix(phba);
+	else {
+		free_irq(phba->pcidev->irq, phba);
+		if (phba->intr_type == MSI)
+			pci_disable_msi(phba->pcidev);
+	}
 
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;


