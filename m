From: jsmart2021@gmail.com
Subject: [PATCH 07/20] lpfc: Fix NVME CMD IU byte swapped word 1 problem
Date: Sat,  4 Mar 2017 09:30:27 -0800
Message-ID: <1488648640-5170-8-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36495 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbdCDRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:30:59 -0500
Received: by mail-qk0-f196.google.com with SMTP id n141so10940321qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:56 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Word 1 in NVME CMD IU appears byte swapped from value placed in WQE
Should be Big Endian value in WQE word 16

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 6346d4d..bf3ccc5 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -620,15 +620,15 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 	 * Embed the payload in the last half of the WQE
 	 * WQE words 16-30 get the NVME CMD IU payload
 	 *
-	 * WQE Word 16 is already setup with flags
-	 * WQE words 17-19 get payload Words 2-4
+	 * WQE words 16-19 get payload Words 1-4
 	 * WQE words 20-21 get payload Words 6-7
 	 * WQE words 22-29 get payload Words 16-23
 	 */
-	wptr = &wqe->words[17];  /* WQE ptr */
+	wptr = &wqe->words[16];  /* WQE ptr */
 	dptr = (uint32_t *)nCmd->cmdaddr;  /* payload ptr */
-	dptr += 2;		/* Skip Words 0-1 in payload */
+	dptr++;			/* Skip Word 0 in payload */
 
+	*wptr++ = *dptr++;	/* Word 1 */
 	*wptr++ = *dptr++;	/* Word 2 */
 	*wptr++ = *dptr++;	/* Word 3 */
 	*wptr++ = *dptr++;	/* Word 4 */
@@ -978,9 +978,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			bf_set(wqe_cmd_type, &wqe->generic.wqe_com,
 			       NVME_WRITE_CMD);
 
-			/* Word 16 */
-			wqe->words[16] = LPFC_NVME_EMBED_WRITE;
-
 			phba->fc4NvmeOutputRequests++;
 		} else {
 			/* Word 7 */
@@ -1002,9 +999,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			bf_set(wqe_cmd_type, &wqe->generic.wqe_com,
 			       NVME_READ_CMD);
 
-			/* Word 16 */
-			wqe->words[16] = LPFC_NVME_EMBED_READ;
-
 			phba->fc4NvmeInputRequests++;
 		}
 	} else {
@@ -1026,9 +1020,6 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		/* Word 11 */
 		bf_set(wqe_cmd_type, &wqe->generic.wqe_com, NVME_READ_CMD);
 
-		/* Word 16 */
-		wqe->words[16] = LPFC_NVME_EMBED_CMD;
-
 		phba->fc4NvmeControlRequests++;
 	}
 	/*
-- 
2.5.0
