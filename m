From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] Set elsiocb contexts to NULL after freeing it
Date: Tue, 10 Jan 2017 12:05:54 +0100
Message-ID: <20170110110554.13770-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Set the elsiocb contexts to NULL after freeing as others depend on it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 236e4e5..7b6bd8e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3590,12 +3590,14 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 		} else {
 			buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
 			lpfc_els_free_data(phba, buf_ptr1);
+			elsiocb->context2 = NULL;
 		}
 	}
 
 	if (elsiocb->context3) {
 		buf_ptr = (struct lpfc_dmabuf *) elsiocb->context3;
 		lpfc_els_free_bpl(phba, buf_ptr);
+		elsiocb->context3 = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, elsiocb);
 	return 0;
-- 
2.10.2
