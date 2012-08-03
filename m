From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/21] lpfc 8.3.33: Check data transfer amount on write
 commands
Date: Fri, 3 Aug 2012 12:34:44 -0400
Message-ID: <1344011684.6110.30.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44804 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2HCQeu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:34:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Check data transfer amount on write commands


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 11:35:20.453631868 -0400
@@ -3552,11 +3552,11 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 
 	/*
 	 * Check SLI validation that all the transfer was actually done
-	 * (fcpi_parm should be zero). Apply check only to reads.
+	 * (fcpi_parm should be zero).
 	 */
-	} else if (fcpi_parm && (cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
+	} else if (fcpi_parm) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
-				 "9029 FCP Read Check Error Data: "
+				 "9029 FCP Data Transfer Check Error: "
 				 "x%x x%x x%x x%x x%x\n",
 				 be32_to_cpu(fcpcmd->fcpDl),
 				 be32_to_cpu(fcprsp->rspResId),



