From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 01/14] lpfc: Double WQ element count to keep iops up
Date: Thu, 11 Aug 2016 11:35:48 -0700
Message-ID: <57acc584.71VgLPvkdT6sQCgh%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35566 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbcHKSfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:51 -0400
Received: by mail-qt0-f169.google.com with SMTP id x25so2115947qtx.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:51 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id l189sm951682qke.27.2016.08.11.11.35.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Double WQ element count to keep iops up

On embedded io queues, use the default element count, which is twice the
size of the default large WQE element count.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index adf61b43..64b6313 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7349,7 +7349,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		if (phba->fcp_embed_io) {
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      LPFC_WQE128_SIZE,
-						      LPFC_WQE128_DEF_COUNT);
+						      phba->sli4_hba.wq_ecount);
 		} else {
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      phba->sli4_hba.wq_esize,
-- 
2.5.0

