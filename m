From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/07] mpt2sas: Added DID_NO_CONNECT return when driver
 remove and avoid shutdown call
Date: Tue, 14 Jun 2011 10:57:08 +0530
Message-ID: <20110614052705.GG14349@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57222 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab1FNFC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 01:02:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

>From scsih_qcmd, we add checkfor the ioc->remove_host flag, and return DID_NO_CONNECT.
Driver should not call shutdown call from _scsih_remove otherwise,
The scsi midlayer can be deadlocked when devices are removed from the driver 
pci_driver->shutdown handler.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 30f77dd..55b9632 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3766,7 +3766,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		return 0;
 	}
 
-	if (ioc->pci_error_recovery) {
+	if (ioc->pci_error_recovery || ioc->remove_host) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
@@ -7314,7 +7314,6 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
-	_scsih_shutdown(pdev);
 	list_del(&ioc->list);
 	scsi_remove_host(shost);
 	scsi_host_put(shost);
