From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 07/17] lpfc: Fix Port going offline after multiple resets.
Date: Thu,  1 Jun 2017 21:07:01 -0700
Message-ID: <20170602040711.21046-8-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36359 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdFBEHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:07:46 -0400
Received: by mail-qt0-f193.google.com with SMTP id j13so8200186qta.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:07:45 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Observing lpfc port down after issuing hbacmd reset command

Failure in posting SGL buffers. If there is only one SGL buffer
and rrq is valid for its XRI, we are rightly returning NULL but
not adding the buffer back to the SGL list. So, number of buffers
become less than total count and repost fails during reset.

Add SGL buffer back to list before returning NULL.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d6b184839bc2..e81fa7d4deb5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -968,6 +968,7 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 			list_remove_head(lpfc_els_sgl_list, sglq,
 						struct lpfc_sglq, list);
 			if (sglq == start_sglq) {
+				list_add_tail(&sglq->list, lpfc_els_sgl_list);
 				sglq = NULL;
 				break;
 			} else
-- 
2.11.0
