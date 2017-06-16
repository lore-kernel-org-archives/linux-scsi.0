From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 08/11] Fix crash doing IO with resets
Date: Thu, 15 Jun 2017 22:56:48 -0700
Message-ID: <20170616055651.9674-9-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36092 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFPF5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:17 -0400
Received: by mail-qt0-f195.google.com with SMTP id s33so7933258qtg.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:17 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

During every reset, IOCBs are allocated. So, at one point, number of
allocated IOCBs reaches maximum limit and lpfc_sli_next_iotag fails.

Allocate IOCBs only during initialization. Reuse them after every reset
instead of allocating new set of IOCBs.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8de70b9d79dd..e948ea05fd33 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6927,18 +6927,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		cnt = phba->cfg_iocb_cnt * 1024;
 		/* We need 1 iocbq for every SGL, for IO processing */
 		cnt += phba->sli4_hba.nvmet_xri_cnt;
-		/* Initialize and populate the iocb list per host */
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2821 initialize iocb list %d total %d\n",
-				phba->cfg_iocb_cnt, cnt);
-		rc = lpfc_init_iocb_list(phba, cnt);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"1413 Failed to init iocb list.\n");
-			goto out_destroy_queue;
-		}
-
-		lpfc_nvmet_create_targetport(phba);
 	} else {
 		/* update host scsi xri-sgl sizes and mappings */
 		rc = lpfc_sli4_scsi_sgl_update(phba);
@@ -6959,18 +6947,24 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		}
 
 		cnt = phba->cfg_iocb_cnt * 1024;
+	}
+
+	if (!phba->sli.iocbq_lookup) {
 		/* Initialize and populate the iocb list per host */
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2820 initialize iocb list %d total %d\n",
+				"2821 initialize iocb list %d total %d\n",
 				phba->cfg_iocb_cnt, cnt);
 		rc = lpfc_init_iocb_list(phba, cnt);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"6301 Failed to init iocb list.\n");
+					"1413 Failed to init iocb list.\n");
 			goto out_destroy_queue;
 		}
 	}
 
+	if (phba->nvmet_support)
+		lpfc_nvmet_create_targetport(phba);
+
 	if (phba->nvmet_support && phba->cfg_nvmet_mrq) {
 		/* Post initial buffers to all RQs created */
 		for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
-- 
2.11.0
