From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 04/19] Fix PRLI ACC rsp for NVME
Date: Tue,  4 Apr 2017 10:16:57 -0700
Message-ID: <1491326232-11255-5-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38167 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755063AbdDDRZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:40 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id DC63F30C0A0
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:26 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

PRLI ACC from target is FCP oriented


Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d9c61d0..d6e0f58 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4403,7 +4403,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 	memset(pcmd, 0, cmdsize);
 
-	*((uint32_t *) (pcmd)) = (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK));
+	*((uint32_t *)(pcmd)) = elsrspcmd;
 	pcmd += sizeof(uint32_t);
 
 	/* For PRLI, remainder of payload is PRLI parameter page */
-- 
2.1.0
