From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 01/21] lpfc: Fix opps when ExpressLane is enabled
Date: Wed,  2 Aug 2017 16:36:28 -0700
Message-ID: <20170802233648.4573-2-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34540 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdHBXhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:37:51 -0400
Received: by mail-qt0-f194.google.com with SMTP id i19so6160788qte.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:37:51 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Null pointer dereference in lpfc_sli4_fof_intr_handler

The driver does not set up cq->assoc_qp for sli4_hba->oas_cq

Initialize cq->assoc_qp before accessing it

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e948ea05fd33..0615bf9def23 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13557,6 +13557,9 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 	/* Save EQ associated with this CQ */
 	cq->assoc_qp = phba->sli4_hba.fof_eq;
 
+	/* Save EQ associated with this CQ */
+	cq->assoc_qp = phba->sli4_hba.fof_eq;
+
 	/* Process all the entries to the OAS CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
-- 
2.13.1
