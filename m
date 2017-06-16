From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 04/11] Reduce time spent in IRQ for received NVME commands
Date: Thu, 15 Jun 2017 22:56:44 -0700
Message-ID: <20170616055651.9674-5-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36029 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdFPF5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:09 -0400
Received: by mail-qt0-f193.google.com with SMTP id s33so7932726qtg.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:09 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Removed unnecessary bzero of context area. Due to size of sg list,
added a substantial delay and played havoc on cpu caches.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index dba1bd216be3..431faa0a4f3e 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -205,7 +205,6 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 		sid = sli4_sid_from_fc_hdr(fc_hdr);
 
 		ctxp = (struct lpfc_nvmet_rcv_ctx *)ctx_buf->context;
-		memset(ctxp, 0, sizeof(ctxp->ctx));
 		ctxp->wqeq = NULL;
 		ctxp->txrdy = NULL;
 		ctxp->offset = 0;
@@ -1422,7 +1421,6 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 				"6414 NVMET Context corrupt %d %d oxid x%x\n",
 				ctxp->state, ctxp->entry_cnt, ctxp->oxid);
 	}
-	memset(ctxp, 0, sizeof(ctxp->ctx));
 	ctxp->wqeq = NULL;
 	ctxp->txrdy = NULL;
 	ctxp->offset = 0;
-- 
2.11.0
