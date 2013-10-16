From: Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] drivers: scsi: lpfc: Fix typo on NULL assignment
Date: Tue, 15 Oct 2013 21:29:50 -0300
Message-ID: <1381883390-4200-1-git-send-email-felipensp@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59771 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759727Ab3JPA3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2013 20:29:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>

In the lpfc_ct_free_iocb function after freeing associated memory to the
ctiocb->context3, the ctiocb->context1 is set to NULL instead of context3.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 02e8cd9..da61d8d 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -280,7 +280,7 @@ lpfc_ct_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocb)
 		buf_ptr = (struct lpfc_dmabuf *) ctiocb->context3;
 		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
 		kfree(buf_ptr);
-		ctiocb->context1 = NULL;
+		ctiocb->context3 = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, ctiocb);
 	return 0;
--
1.7.10.4

