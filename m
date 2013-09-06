From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/18] lpfc 8.3.42: Back out data count,(residual fcfi_parm)
 fix for bad target.
Date: Fri, 6 Sep 2013 12:19:17 -0400
Message-ID: <1378484357.14051.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49776 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IFQTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:19:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Back out data count,(residual fcfi_parm) fix for bad target.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:03.734058299 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:08.267058402 -0400
@@ -3966,11 +3966,11 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 
 	/*
 	 * Check SLI validation that all the transfer was actually done
-	 * (fcpi_parm should be zero).
+	 * (fcpi_parm should be zero). Apply check only to reads.
 	 */
-	} else if (fcpi_parm) {
+	} else if (fcpi_parm && (cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
-				 "9029 FCP Data Transfer Check Error: "
+				 "9029 FCP Read Check Error Data: "
 				 "x%x x%x x%x x%x x%x\n",
 				 be32_to_cpu(fcpcmd->fcpDl),
 				 be32_to_cpu(fcprsp->rspResId),



