From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 07/15] lpfc: Fix Port going offline after multiple resets.
Date: Tue, 30 May 2017 23:04:31 -0700
Message-ID: <20170531060439.2073-8-jsmart2021@gmail.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36452 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdEaGFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:05:02 -0400
Received: by mail-qk0-f196.google.com with SMTP id y128so733133qka.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:05:01 -0700 (PDT)
In-Reply-To: <20170531060439.2073-1-jsmart2021@gmail.com>
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
