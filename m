From: jsmart2021@gmail.com
Subject: [PATCH 04/20] scsi: lpfc: fix missing spin_unlock on sql_list_lock
Date: Sat,  4 Mar 2017 09:30:24 -0800
Message-ID: <1488648640-5170-5-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33856 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdCDRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:30:59 -0500
Received: by mail-qk0-f195.google.com with SMTP id g129so6383381qkd.1
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:52 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Colin Ian King <colin.king@canonical.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

From: Colin Ian King <colin.king@canonical.com>

In the case where sglq is null, the current code just returns without
unlocking the spinlock sql_list_lock. Fix this by breaking out of the
while loop and the exit path will then unlock and return NULL as was
the original intention.

Detected by CoverityScan, CID#1411635 ("Missing unlock")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 562a528..7389c13 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -952,7 +952,7 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	start_sglq = sglq;
 	while (!found) {
 		if (!sglq)
-			return NULL;
+			break;
 		if (ndlp && ndlp->active_rrqs_xri_bitmap &&
 		    test_bit(sglq->sli4_lxritag,
 		    ndlp->active_rrqs_xri_bitmap)) {
-- 
2.5.0
