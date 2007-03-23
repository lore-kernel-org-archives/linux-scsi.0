From: Richard Lary <rlary@austin.ibm.com>
Subject: [PATCH] lpfc: add cfg_use_msi test before pci_msi_disable() calls
Date: Fri, 23 Mar 2007 08:32:14 -0500 (CDT)
Message-ID: <200703231332.l2NDWFXq021381@anacortes.austin.ibm.com>
Reply-To: rlary@austin.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49127 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934296AbXCWNgG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Mar 2007 09:36:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2NDa4jp027076
	for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2007 09:36:04 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2NDYm6R196240
	for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2007 09:34:48 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2NDYmbf018584
	for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2007 09:34:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

From: Richard Lary <rlary@us.ibm.com>

This patch adds test for phba->cfg_use_msi
before calls to pci_msi_disable() to prevent
calls to this function when pci_msi_enable()
has not been called.

Signed-off-by: Richard Lary <rlary@us.ibm.com>
---

Calling pci_msi_disable() when pci_msi_enable()
has not been previously called results in
console error message when removing lpfc.

$ modprobe -r lpfc
error[-3]: getting the number of MSI interrupts for fibre-channel

Applies to: 2.6.21-rc4-git5

Index: b/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1704,7 +1704,8 @@ out_free_irq:
 	lpfc_stop_timer(phba);
 	phba->work_hba_events = 0;
 	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
+	if (phba->cfg_use_msi)
+		pci_disable_msi(phba->pcidev);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(phba);
 out_remove_host:
@@ -1771,7 +1772,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	/* Release the irq reservation */
 	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
+	if (phba->cfg_use_msi)
+		pci_disable_msi(phba->pcidev);
 
 	lpfc_cleanup(phba, 0);
 	lpfc_stop_timer(phba);
