From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/11] mpt2sas: Early return from function if shost is in recovery.
Date: Wed, 17 Mar 2010 16:23:36 +0530
Message-ID: <20100317105324.GE21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39551 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457Ab0CQLYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:24:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Aded checks for shost_recovery flag for early return from function.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 3735886..4c62ee9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3518,7 +3518,9 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 	    __func__));
 
 	_base_mask_interrupts(ioc);
+	ioc->shost_recovery = 1;
 	_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+	ioc->shost_recovery = 0;
 	if (ioc->pci_irq) {
 		synchronize_irq(pdev->irq);
 		free_irq(ioc->pci_irq, ioc);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index cd0f245..4eb6be9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1978,7 +1978,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 		return;
 	}
 
-	if (ioc->shost_recovery) {
+	if (ioc->shost_recovery || ioc->remove_host) {
 		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
 		return;
@@ -4245,7 +4245,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		_scsih_sas_topology_change_event_debug(ioc, event_data);
 #endif
 
-	if (ioc->shost_recovery)
+	if (ioc->shost_recovery || ioc->remove_host)
 		return;
 
 	if (!ioc->sas_hba.num_phys)
@@ -4284,7 +4284,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 			    "expander event\n", ioc->name));
 			return;
 		}
-		if (ioc->shost_recovery)
+		if (ioc->shost_recovery || ioc->remove_host)
 			return;
 		phy_number = event_data->StartPhyNum + i;
 		reason_code = event_data->PHY[i].PhyStatus &
