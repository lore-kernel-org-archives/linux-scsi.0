From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 05/17] lpfc: Fix NVME LS abort_xri
Date: Mon, 20 Nov 2017 16:00:32 -0800
Message-ID: <20171121000044.27702-6-jsmart2021@gmail.com>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:42446 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdKUAA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:00:59 -0500
Received: by mail-qk0-f195.google.com with SMTP id a194so9753465qkc.9
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:00:59 -0800 (PST)
In-Reply-To: <20171121000044.27702-1-jsmart2021@gmail.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4b76db19ef73..c1c7df607604 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12814,6 +12814,7 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
+	case LPFC_NVME_LS: /* NVME LS uses ELS resources */
 	case LPFC_ELS:
 		cq_event = lpfc_cq_event_setup(
 			phba, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
-- 
2.13.1
