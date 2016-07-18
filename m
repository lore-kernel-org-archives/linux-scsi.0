From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/2] lpfc: call lpfc_sli_validate_fcp_iocb() with the hbalock held
Date: Mon, 18 Jul 2016 16:06:03 +0200
Message-ID: <1468850763-72179-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbcGROGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jul 2016 10:06:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Call lpfc_sli_validate_fcp_iocb() with the hbalock held, as the pointer to
iocbq is not guaranteed to still be valid after looking it up.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1a248a2..d58ec4c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9978,6 +9978,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 	struct lpfc_iocbq *iocbq;
 	int sum, i;
 
+	spin_lock_irq(&phba->hbalock);
 	for (i = 1, sum = 0; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
@@ -9985,6 +9986,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 						ctx_cmd) == 0)
 			sum++;
 	}
+	spin_unlock_irq(&phba->hbalock);
 
 	return sum;
 }
-- 
1.8.5.6

