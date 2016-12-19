From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 10/11] lpfc: Add missing memory barrier
Date: Mon, 19 Dec 2016 14:35:32 -0800
Message-ID: <585860b4.c6ZLcPoTRNPY8wWj%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp02.broadcom.com ([192.19.219.146]:40392 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933297AbcLSWkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:40:39 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id DFB64260007
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


On loosely ordered memory systems (PPC for example), the WQE elements
were being updated in memory, but not necessarily flushed before the
separate doorbell was written to hw which would cause hw to dma the
WQE element. Thus, the hardware occasionally received partially
updated WQE data.

Add the memory barrier after updating the WQE memory.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d0ffcf3..c8f5a56 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -120,6 +120,7 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
 	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
 		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
 	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
+	wmb();
 
 	/* Update the host index before invoking device */
 	host_index = q->host_index;
-- 
2.5.0


