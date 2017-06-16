From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 10/11] Driver responds LS_RJT to Beacon Off ELS - Linux
Date: Thu, 15 Jun 2017 22:56:50 -0700
Message-ID: <20170616055651.9674-11-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34414 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdFPF5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:22 -0400
Received: by mail-qt0-f195.google.com with SMTP id o21so7937233qtb.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:21 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Beacon OFF from switch is rejected by driver.

Driver fails Beacon OFF if frequency is set to 0. As per fc-ls
spec, status, capability, frequency and duration fields are only
applicable for Beacon ON.

Remove frequency and type checks. Reject Beacon ON if duration
is non zero.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 54de984d695f..6d1d6f691df4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5703,27 +5703,13 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		rjt_err = LSRJT_CMD_UNSUPPORTED;
 		goto rjt;
 	}
-	if (beacon->lcb_frequency == 0) {
+	if (beacon->lcb_sub_command != LPFC_LCB_ON &&
+	    beacon->lcb_sub_command != LPFC_LCB_OFF) {
 		rjt_err = LSRJT_CMD_UNSUPPORTED;
 		goto rjt;
 	}
-	if ((beacon->lcb_type != LPFC_LCB_GREEN) &&
-	    (beacon->lcb_type != LPFC_LCB_AMBER)) {
-		rjt_err = LSRJT_CMD_UNSUPPORTED;
-		goto rjt;
-	}
-	if ((beacon->lcb_sub_command != LPFC_LCB_ON) &&
-	    (beacon->lcb_sub_command != LPFC_LCB_OFF)) {
-		rjt_err = LSRJT_CMD_UNSUPPORTED;
-		goto rjt;
-	}
-	if ((beacon->lcb_sub_command == LPFC_LCB_ON) &&
-	    (beacon->lcb_type != LPFC_LCB_GREEN) &&
-	    (beacon->lcb_type != LPFC_LCB_AMBER)) {
-		rjt_err = LSRJT_CMD_UNSUPPORTED;
-		goto rjt;
-	}
-	if (be16_to_cpu(beacon->lcb_duration) != 0) {
+	if (beacon->lcb_sub_command == LPFC_LCB_ON &&
+	    be16_to_cpu(beacon->lcb_duration) != 0) {
 		rjt_err = LSRJT_CMD_UNSUPPORTED;
 		goto rjt;
 	}
-- 
2.11.0
