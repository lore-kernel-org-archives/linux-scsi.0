From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 05/17] lpfc: Fix NVME LS abort_xri
Date: Fri,  3 Nov 2017 15:56:16 -0700
Message-ID: <20171103225628.24716-6-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:50728 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756069AbdKCW4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:43 -0400
Received: by mail-qt0-f193.google.com with SMTP id d9so5052942qtd.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:42 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

performing an LS abort results in the following message being seen:
  0603 Invalid CQ subtype 6: 00000300 22000002 ffff0016 d0050000
and the associated exchange is not properly freed.

The code did not recognize the exchange type that was aborted, thus
it was not properly handled.

Correct by adding the NVME LS ELS type to the exchange types that
are recognized.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ba6f0619433c..1229f58bdd09 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12807,6 +12807,7 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
+	case LPFC_NVME_LS: /* NVME LS uses ELS resources */
 	case LPFC_ELS:
 		cq_event = lpfc_cq_event_setup(
 			phba, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
-- 
2.13.1
