From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 02/11] lpfc: Correct error in setting OS Driver Version
 with FW
Date: Mon, 19 Dec 2016 14:35:24 -0800
Message-ID: <585860ac./lhnLnmTkBR6l6Rv%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:49929 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933063AbcLSWf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:35:29 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 7ED282803EE
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct error in setting OS Driver Version with FW.  Prior length was
too short.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 27cbd68..230f924 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6304,7 +6304,8 @@ lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 			 LPFC_SLI4_MBX_EMBED);
 
 	mbox->u.mqe.un.set_host_data.param_id = LPFC_SET_HOST_OS_DRIVER_VERSION;
-	mbox->u.mqe.un.set_host_data.param_len = 8;
+	mbox->u.mqe.un.set_host_data.param_len =
+					LPFC_HOST_OS_DRIVER_VERSION_SIZE;
 	snprintf(mbox->u.mqe.un.set_host_data.data,
 		 LPFC_HOST_OS_DRIVER_VERSION_SIZE,
 		 "Linux %s v"LPFC_DRIVER_VERSION,
-- 
2.5.0


