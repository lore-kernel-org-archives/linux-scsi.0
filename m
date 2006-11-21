From: Brian King <brking@us.ibm.com>
Subject: [PATCH 05/10] ipr: Remove ipr_scsi_timed_out
Date: Tue, 21 Nov 2006 10:28:23 -0600
Message-ID: <200611211628.kALGSNng022039@d01av04.pok.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44483 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1031049AbWKUQ22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:28:28 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGSPud021813
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:25 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSOlh190270
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:25 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSNBY022092
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:24 -0500
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove ipr's usage of the scsi transport eh_timed_out for
handling SATA timeouts. This was only needed in order to set
some flags on the qc prior to calling ata_do_eh. 

---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   40 +++--------------------------------
 1 files changed, 4 insertions(+), 36 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_sata_no_timed_out drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_no_timed_out	2006-11-15 15:43:08.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-15 15:43:08.000000000 -0600
@@ -79,7 +79,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_transport.h>
 #include "ipr.h"
 
 /*
@@ -3643,6 +3642,10 @@ static int __ipr_eh_dev_reset(struct scs
 		if (ipr_cmd->ioarcb.res_handle == res->cfgte.res_handle) {
 			if (ipr_cmd->scsi_cmd)
 				ipr_cmd->done = ipr_scsi_eh_done;
+			if (ipr_cmd->qc && !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
+				ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
+				ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
+			}
 		}
 	}
 
@@ -4655,40 +4658,6 @@ static const char * ipr_ioa_info(struct 
 	return buffer;
 }
 
-/**
- * ipr_scsi_timed_out - Handle scsi command timeout
- * @scsi_cmd:	scsi command struct
- *
- * Return value:
- * 	EH_NOT_HANDLED
- **/
-enum scsi_eh_timer_return ipr_scsi_timed_out(struct scsi_cmnd *scsi_cmd)
-{
-	struct ipr_ioa_cfg *ioa_cfg;
-	struct ipr_cmnd *ipr_cmd;
-	unsigned long flags;
-
-	ENTER;
-	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
-	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
-
-	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
-		if (ipr_cmd->qc && ipr_cmd->qc->scsicmd == scsi_cmd) {
-			ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
-			ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
-			break;
-		}
-	}
-
-	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
-	LEAVE;
-	return EH_NOT_HANDLED;
-}
-
-static struct scsi_transport_template ipr_transport_template = {
-	.eh_timed_out = ipr_scsi_timed_out
-};
-
 static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IPR",
@@ -7030,7 +6999,6 @@ static int __devinit ipr_probe_ioa(struc
 
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
 	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
-	host->transportt = &ipr_transport_template;
 	ata_host_init(&ioa_cfg->ata_host, &pdev->dev,
 		      sata_port_info.flags, &ipr_sata_ops);
 
_
