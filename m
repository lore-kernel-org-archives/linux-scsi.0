From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 01/17] lpfc: Fix FCF Infinite loop in
 lpfc_sli4_fcf_rr_next_index_get.
Date: Wed, 16 Dec 2015 18:11:52 -0500
Message-ID: <5671efb8.g2wO8LGtpHquAYxc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34143 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbLPXMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:10 -0500
Received: by mail-pf0-f179.google.com with SMTP id 68so19521147pfc.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:10 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id n64sm7006457pfi.19.2015.12.16.15.12.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix FCF Infinite loop in lpfc_sli4_fcf_rr_next_index_get.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f9585cd..6aae828 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16173,7 +16173,7 @@ fail_fcf_read:
 }
 
 /**
- * lpfc_check_next_fcf_pri
+ * lpfc_check_next_fcf_pri_level
  * phba pointer to the lpfc_hba struct for this port.
  * This routine is called from the lpfc_sli4_fcf_rr_next_index_get
  * routine when the rr_bmask is empty. The FCF indecies are put into the
@@ -16329,8 +16329,12 @@ next_priority:
 
 	if (next_fcf_index < LPFC_SLI4_FCF_TBL_INDX_MAX &&
 		phba->fcf.fcf_pri[next_fcf_index].fcf_rec.flag &
-		LPFC_FCF_FLOGI_FAILED)
+		LPFC_FCF_FLOGI_FAILED) {
+		if (list_is_singular(&phba->fcf.fcf_pri_list))
+			return LPFC_FCOE_FCF_NEXT_NONE;
+
 		goto next_priority;
+	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_FIP,
 			"2845 Get next roundrobin failover FCF (x%x)\n",
-- 
1.7.11.7

