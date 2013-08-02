From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 2/2] mpt3sas: fix cleanup on controller resource mapping failure
Date: Fri,  2 Aug 2013 16:01:24 -0400
Message-ID: <1375473684-12566-3-git-send-email-joe.lawrence@stratus.com>
References: <1375473684-12566-1-git-send-email-joe.lawrence@stratus.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:40088 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3HBUDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Aug 2013 16:03:10 -0400
In-Reply-To: <1375473684-12566-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sreekanth.Reddy@lsi.com, Joe Lawrence <joe.lawrence@stratus.com>

If mpt3sas_base_map_resources takes an early error path then its
counterpart, mpt3sas_base_free_resources needs to be careful about
cleaning up:

  1 - _base_mask_interrupts and _base_make_ioc_ready require memory
      mapped I/O registers, make sure that this is true.

  2 - _base_free_irq iterates over the adapter's reply_queue_list, so
      move this list head initialization out of _base_enable_msix to
      _scsih_probe so this will always be safe.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 16 +++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5dc280c..59e71c4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1709,8 +1709,6 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	int i;
 	u8 try_msix = 0;
 
-	INIT_LIST_HEAD(&ioc->reply_queue_list);
-
 	if (msix_disable == -1 || msix_disable == 0)
 		try_msix = 1;
 
@@ -4393,13 +4391,17 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
-	_base_mask_interrupts(ioc);
-	ioc->shost_recovery = 1;
-	_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
-	ioc->shost_recovery = 0;
+	if (ioc->chip_phys && ioc->chip) {
+		_base_mask_interrupts(ioc);
+		ioc->shost_recovery = 1;
+		_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+		ioc->shost_recovery = 0;
+	}
+
 	_base_free_irq(ioc);
 	_base_disable_msix(ioc);
-	if (ioc->chip_phys)
+
+	if (ioc->chip_phys && ioc->chip)
 		iounmap(ioc->chip);
 	ioc->chip_phys = 0;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8cbe8fd..a961fe1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7779,6 +7779,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->sas_hba.sas_port_list);
 	INIT_LIST_HEAD(&ioc->delayed_tr_list);
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
+	INIT_LIST_HEAD(&ioc->reply_queue_list);
 
 	/* init shost parameters */
 	shost->max_cmd_len = 32;
-- 
1.8.3.1

