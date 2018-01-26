From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 01/19] lpfc: Fix frequency of Release WQE CQEs
Date: Fri, 26 Jan 2018 11:22:21 -0800
Message-ID: <20180126192239.10727-2-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35051 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbeAZTW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:22:56 -0500
Received: by mail-qt0-f195.google.com with SMTP id g14so4003393qti.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:22:56 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The driver controls when the hardware sends completions that
communicate consumption of elements from the WQ. This is done by
setting a WQEC bit on a WQE.

The current driver sets it on every Nth WQE posting. However, the
driver isn't clearing the bit if the WQE is reused. Thus, if the
queue depth isn't evenly divisible by N, with enough time, it can
be set on every element, creating a lot of overhead and risking
CQ full conditions.

Correct by clearing the bit when not setting it on an Nth element.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5f5528a12308..149f21f53b13 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -129,6 +129,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
 	/* set consumption flag every once in a while */
 	if (!((q->host_index + 1) % q->entry_repost))
 		bf_set(wqe_wqec, &wqe->generic.wqe_com, 1);
+	else
+		bf_set(wqe_wqec, &wqe->generic.wqe_com, 0);
 	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
 		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
 	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
-- 
2.13.1
