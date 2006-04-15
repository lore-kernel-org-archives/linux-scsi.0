From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/7] lpfc 8.1.5 : Fix cleanup code in the
	lpfc_pci_probe_one() error code path
Date: Sat, 15 Apr 2006 11:53:10 -0400
Message-ID: <1145116391.3795.3.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40371 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030277AbWDOPxN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:53:13 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFrCrf011040
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:53:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix cleanup code in the lpfc_pci_probe_one() error code path.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1618,7 +1618,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	error = lpfc_alloc_sysfs_attr(phba);
 	if (error)
-		goto out_kthread_stop;
+		goto out_remove_host;
 
 	error =	request_irq(phba->pcidev->irq, lpfc_intr_handler, SA_SHIRQ,
 							LPFC_DRIVER_NAME, phba);
@@ -1691,6 +1691,9 @@ out_free_irq:
 	free_irq(phba->pcidev->irq, phba);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(phba);
+out_remove_host:
+	fc_remove_host(phba->host);
+	scsi_remove_host(phba->host);
 out_kthread_stop:
 	kthread_stop(phba->worker_thread);
 out_free_iocbq:
@@ -1712,12 +1715,14 @@ out_iounmap_slim:
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
 
@@ -1725,9 +1730,14 @@ static void __devexit
 lpfc_pci_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host   *host = pci_get_drvdata(pdev);
-	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
+	struct lpfc_hba    *phba;
 	unsigned long iflag;
 
+	if (host == NULL)
+		return;
+
+	phba = (struct lpfc_hba *)host->hostdata;
+
 	lpfc_free_sysfs_attr(phba);
 
 	spin_lock_irqsave(phba->host->host_lock, iflag);


