From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 16/19] lpfc: Treat SCSI Write operation Underruns as an error
Date: Fri, 26 Jan 2018 11:22:36 -0800
Message-ID: <20180126192239.10727-17-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38289 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752920AbeAZTXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:23:12 -0500
Received: by mail-qt0-f193.google.com with SMTP id z10so3977387qti.5
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:23:11 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Currently, write underruns (mismatch of amount transferred vs scsi
status and its residual) detected by the adapter are not being
flagged as an error. Its expected the target controls the data
transfer and would appropriately set the RSP values.  Only read
underruns are treated as errors.

Revise the SCSI error handling to treat write underruns as an
error as well.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index dcc86936e6fc..10c2dc0cf1fa 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3772,20 +3772,18 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_UNDER,
-				 "9025 FCP Read Underrun, expected %d, "
+				 "9025 FCP Underrun, expected %d, "
 				 "residual %d Data: x%x x%x x%x\n",
 				 fcpDl,
 				 scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
 				 cmnd->underflow);
 
 		/*
-		 * If there is an under run check if under run reported by
+		 * If there is an under run, check if under run reported by
 		 * storage array is same as the under run reported by HBA.
 		 * If this is not same, there is a dropped frame.
 		 */
-		if ((cmnd->sc_data_direction == DMA_FROM_DEVICE) &&
-			fcpi_parm &&
-			(scsi_get_resid(cmnd) != fcpi_parm)) {
+		if (fcpi_parm && (scsi_get_resid(cmnd) != fcpi_parm)) {
 			lpfc_printf_vlog(vport, KERN_WARNING,
 					 LOG_FCP | LOG_FCP_ERROR,
 					 "9026 FCP Read Check Error "
-- 
2.13.1
