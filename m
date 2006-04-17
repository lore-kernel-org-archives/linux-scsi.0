From: James Smart <James.Smart@Emulex.Com>
Subject: [REPOST][PATCH 4/7] lpfc 8.1.5 : Fix cleanup code in the
	lpfc_pci_probe_one() error code path
Date: Sun, 16 Apr 2006 22:26:50 -0400
Message-ID: <1145240810.4264.2.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49369 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750980AbWDQC06
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Apr 2006 22:26:58 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k3H2Qu5S020682
	for <linux-scsi@vger.kernel.org>; Sun, 16 Apr 2006 19:26:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix cleanup code in the lpfc_pci_probe_one() error code path.

This changes the original patch by:
  - hardsetting the return value from lpfc_pci_probe_one() to
    -ENODEV (negative value) if we fail attach
  - removes the checks from lpfc_pci_remove_one() validating the
    host and phba pointers as it's no longer needed.

-- james s

diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-04-16 22:23:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-04-16 22:24:32.000000000 -0400
@@ -1618,7 +1618,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	error = lpfc_alloc_sysfs_attr(phba);
 	if (error)
-		goto out_kthread_stop;
+		goto out_remove_host;
 
 	error =	request_irq(phba->pcidev->irq, lpfc_intr_handler, SA_SHIRQ,
 							LPFC_DRIVER_NAME, phba);
@@ -1635,8 +1635,10 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
 
 	error = lpfc_sli_hba_setup(phba);
-	if (error)
+	if (error) {
+		error = -ENODEV;
 		goto out_free_irq;
+	}
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		spin_lock_irq(phba->host->host_lock);
@@ -1691,6 +1693,9 @@ out_free_irq:
 	free_irq(phba->pcidev->irq, phba);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(phba);
+out_remove_host:
+	fc_remove_host(phba->host);
+	scsi_remove_host(phba->host);
 out_kthread_stop:
 	kthread_stop(phba->worker_thread);
 out_free_iocbq:
@@ -1712,12 +1717,14 @@ out_iounmap_slim:
 out_idr_remove:
 	idr_remove(&lpfc_hba_index, phba->brd_no);
 out_put_host:
+	phba->host = NULL;
 	scsi_host_put(host);
 out_release_regions:
 	pci_release_regions(pdev);
 out_disable_device:
 	pci_disable_device(pdev);
 out:
+	pci_set_drvdata(pdev, NULL);
 	return error;
 }
 


