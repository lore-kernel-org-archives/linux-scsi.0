From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/9] lpfc 8.1.11 :  Add MSI (Message Signalled Interrupts)
	support
Date: Sat, 02 Dec 2006 13:34:56 -0500
Message-ID: <1165084497.27443.26.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56535 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759461AbWLBQHG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:06 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71al009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add MSI (Message Signalled Interrupts) support
  Actual use must be enabled via the new module parameter "lpfc_use_msi"
  Defaults to no use

Many thanks to Frederic Temporelli who implemented the initial patch.


Signed-off-by: Frederic Temporelli <frederic.temporelli@ext.bull.net>
Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 12:07:50.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 12:11:35.000000000 -0500
@@ -961,6 +961,15 @@ LPFC_ATTR_R(max_luns, 255, 0, 65535,
 LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 	     "Milliseconds driver will wait between polling FCP ring");
 
+/*
+# lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
+#		support this feature
+#       0  = MSI disabled (default)
+#       1  = MSI enabled
+# Value range is [0,1]. Default value is 0.
+*/
+LPFC_ATTR_R(use_msi, 0, 0, 1, "Use Message Signaled Interrupts, if possible");
+
 
 struct class_device_attribute *lpfc_host_attrs[] = {
 	&class_device_attr_info,
@@ -999,6 +1008,7 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_issue_reset,
 	&class_device_attr_lpfc_poll,
 	&class_device_attr_lpfc_poll_tmo,
+	&class_device_attr_lpfc_use_msi,
 	&class_device_attr_lpfc_soft_wwpn,
 	&class_device_attr_lpfc_soft_wwpn_enable,
 	NULL,
@@ -1801,6 +1811,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_discovery_threads_init(phba, lpfc_discovery_threads);
 	lpfc_max_luns_init(phba, lpfc_max_luns);
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
+	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_devloss_tmo_init(phba, lpfc_devloss_tmo);
 	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
 	phba->cfg_poll = lpfc_poll;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2006-12-02 11:57:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2006-12-02 12:11:35.000000000 -0500
@@ -303,6 +303,7 @@ struct lpfc_hba {
 	uint32_t cfg_max_luns;
 	uint32_t cfg_poll;
 	uint32_t cfg_poll_tmo;
+	uint32_t cfg_use_msi;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
 	uint64_t cfg_soft_wwpn;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:02:00.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:11:35.000000000 -0500
@@ -1653,6 +1653,14 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (error)
 		goto out_remove_host;
 
+	if (phba->cfg_use_msi) {
+		error = pci_enable_msi(phba->pcidev);
+		if (error)
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT, "%d:0452 "
+					"Enable MSI failed, continuing with "
+					"IRQ\n", phba->brd_no);
+	}
+
 	error =	request_irq(phba->pcidev->irq, lpfc_intr_handler, IRQF_SHARED,
 							LPFC_DRIVER_NAME, phba);
 	if (error) {
@@ -1732,6 +1740,7 @@ out_free_irq:
 	lpfc_stop_timer(phba);
 	phba->work_hba_events = 0;
 	free_irq(phba->pcidev->irq, phba);
+	pci_disable_msi(phba->pcidev);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(phba);
 out_remove_host:
@@ -1798,6 +1807,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	/* Release the irq reservation */
 	free_irq(phba->pcidev->irq, phba);
+	pci_disable_msi(phba->pcidev);
 
 	lpfc_cleanup(phba, 0);
 	lpfc_stop_timer(phba);


