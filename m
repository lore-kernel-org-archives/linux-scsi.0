From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 01/11] Fix system panic when express lane enabled.
Date: Thu, 15 Jun 2017 22:56:41 -0700
Message-ID: <20170616055651.9674-2-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34272 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdFPF5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:03 -0400
Received: by mail-qt0-f195.google.com with SMTP id o21so7935983qtb.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:03 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

There is a null pointer dereference that can happen in the FOF interrupt
handler.

The driver was not setting up cq->assoc_qp_for sli4_hba->oas_cq.

Initialize cq->assoc_qp before accessing it.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 040575adf9c6..4f2cc395597e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13560,6 +13560,9 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 		return;
 	}
 
+	/* Save EQ associated with this CQ */
+	cq->assoc_qp = phba->sli4_hba.fof_eq;
+
 	/* Process all the entries to the OAS CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
-- 
2.11.0
