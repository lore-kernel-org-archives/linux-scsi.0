From: jsmart2021@gmail.com
Subject: [PATCH-v1 10/22] Fix PRLI ACC rsp for NVME
Date: Wed, 19 Apr 2017 21:46:29 -0700
Message-ID: <20170420044641.10657-11-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33230 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941139AbdDTErR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:17 -0400
Received: by mail-oi0-f68.google.com with SMTP id a189so5684097oib.0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:16 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

PRLI ACC from target is FCP oriented.

Word 0 was wrong. This was noticed by another nvmet-fc vendor that
was testing the lpfc nvme-fc initiator with their target.

Verified results with analyzer.

PRLI
BC B5 56 56  22 61 04 00  00 61 00 00  01 29 00 00  20 00 00 00
00 10 FF FF  00 00 00 00  20 14 00 18  28 00 00 00  00 00 00 00
00 00 00 00  00 00 00 20  00 00 00 00  9C D8 DA C9  BC 95 75 75

ACC
BC B5 56 56  23 61 00 00  00 61 04 00  01 98 00 00  30 00 00 00
00 10 00 18  00 00 00 00  02 14 00 18  28 00 01 00  00 00 00 00
00 00 00 00  00 00 00 18  00 00 00 00  B0 6B 07 57  BC B5 75 75

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
