From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix sleeping function called with interrupts disabled
Date: Wed, 22 Apr 2009 08:58:02 -0500
Message-ID: <200904221358.n3MDwKNw010452@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56811 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbZDVN6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 09:58:22 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3ME0FCI018651
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 10:00:15 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3MDwLbX189806
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 09:58:21 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3MDwK2t010513
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 09:58:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ata_sas_slave_configure was changed such that it now allocates
some memory for a drain buffer for ATAPI devices. Fixup the ipr
driver such that we no longer make this call with interrupts disabled.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_fix_invalid_context drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_fix_invalid_context	2009-04-22 08:37:32.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2009-04-22 08:37:32.000000000 -0500
@@ -3654,6 +3654,7 @@ static int ipr_slave_configure(struct sc
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
+	struct ata_port *ap = NULL;
 	unsigned long lock_flags = 0;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -3672,12 +3673,16 @@ static int ipr_slave_configure(struct sc
 		}
 		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
 			sdev->allow_restart = 1;
-		if (ipr_is_gata(res) && res->sata_port) {
+		if (ipr_is_gata(res) && res->sata_port)
+			ap = res->sata_port->ap;
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+		if (ap) {
 			scsi_adjust_queue_depth(sdev, 0, IPR_MAX_CMD_PER_ATA_LUN);
-			ata_sas_slave_configure(sdev, res->sata_port->ap);
-		} else {
+			ata_sas_slave_configure(sdev, ap);
+		} else
 			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-		}
+		return 0;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return 0;
_
