From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 04/19] lpfc: correct debug counters for abort
Date: Fri, 26 Jan 2018 11:22:24 -0800
Message-ID: <20180126192239.10727-5-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35073 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752588AbeAZTW7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:22:59 -0500
Received: by mail-qt0-f195.google.com with SMTP id g14so4003831qti.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:22:59 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Existing code was using the wrong field for the completion status
when comparing whether to increment abort statistics

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 8dbf5c9d51aa..7927ac46d345 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -130,7 +130,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	if (tgtp) {
 		if (status) {
 			atomic_inc(&tgtp->xmt_ls_rsp_error);
-			if (status == IOERR_ABORT_REQUESTED)
+			if (result == IOERR_ABORT_REQUESTED)
 				atomic_inc(&tgtp->xmt_ls_rsp_aborted);
 			if (bf_get(lpfc_wcqe_c_xb, wcqe))
 				atomic_inc(&tgtp->xmt_ls_rsp_xb_set);
@@ -541,7 +541,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		rsp->transferred_length = 0;
 		if (tgtp) {
 			atomic_inc(&tgtp->xmt_fcp_rsp_error);
-			if (status == IOERR_ABORT_REQUESTED)
+			if (result == IOERR_ABORT_REQUESTED)
 				atomic_inc(&tgtp->xmt_fcp_rsp_aborted);
 		}
 
-- 
2.13.1
