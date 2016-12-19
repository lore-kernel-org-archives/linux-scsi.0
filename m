From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 04/11] lpfc: Correct issue leading to opps during link
 reset
Date: Mon, 19 Dec 2016 14:35:26 -0800
Message-ID: <585860ae.M6OPvFY8jQPRwQbe%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:49931 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933065AbcLSWfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:35:31 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 86C942803E4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct issue leading to opps during link reset. Missing vport pointer.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 230f924..47b5520 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10027,6 +10027,7 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
 
 	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
+	abtsiocbp->vport = vport;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
 			 "0339 Abort xri x%x, original iotag x%x, "
-- 
2.5.0


