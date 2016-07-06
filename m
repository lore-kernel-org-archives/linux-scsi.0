From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 13/21] lpfc: Correct Port reset resulting in FC port going offline
Date: Wed, 06 Jul 2016 12:36:06 -0700
Message-ID: <577d5da6.Csc9NMYwiS/8EdfU%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38604 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbcGFTgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:12 -0400
Received: by mail-wm0-f44.google.com with SMTP id r201so5686493wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:11 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id f73sm5773199wmg.1.2016.07.06.12.36.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct Port reset resulting in FC port going offline

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6e11574..f4b3548 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1595,9 +1595,10 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 		 * ready before performing reset.
 		 */
 		rc = lpfc_sli4_pdev_status_reg_wait(phba);
-		if (!rc)
+		if (rc)
 			return rc;
 	}
+
 	/* need reset: attempt for port recovery */
 	if (en_rn_msg)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-- 
2.5.0

