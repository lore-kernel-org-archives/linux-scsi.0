From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 13/14] lpfc: Fix lost target in pt-to-pt connect
Date: Thu, 11 Aug 2016 11:36:00 -0700
Message-ID: <57acc590.rfDBAYZ4VctGazWw%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33552 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbcHKSgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:36:03 -0400
Received: by mail-qk0-f181.google.com with SMTP id t7so4362445qkh.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:36:03 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id r5sm939015qkf.34.2016.08.11.11.36.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:36:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix lost target in pt-to-pt connect

Change reject code to something that allows a retry

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c0af32f..88baa6a 100644
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

