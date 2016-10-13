From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 13/17] lpfc: Fix lost target in pt-to-pt connect
Date: Thu, 13 Oct 2016 15:06:14 -0700
Message-ID: <58000556.iMQkkPWuhx0h/Yw8%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.61]:55039 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbcJMWHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:07:20 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 77BDF100747
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix lost target in pt-to-pt connect

Change reject code to something that allows a retry

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b7d54bf..236e4e5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7610,7 +7610,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/* reject till our FLOGI completes */
 	if ((vport->port_state < LPFC_FABRIC_CFG_LINK) &&
 	    (cmd != ELS_CMD_FLOGI)) {
-		rjt_err = LSRJT_UNABLE_TPC;
+		rjt_err = LSRJT_LOGICAL_BSY;
 		rjt_exp = LSEXP_NOTHING_MORE;
 		goto lsrjt;
 	}
-- 
2.5.0


