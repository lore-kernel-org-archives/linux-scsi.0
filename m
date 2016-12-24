From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] scsi: lpfc: Replace BUG() with BUG_ON()
Date: Sat, 24 Dec 2016 16:21:07 +0530
Message-ID: <1482576667-8042-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34721 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752938AbcLXKv0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Dec 2016 05:51:26 -0500
Received: by mail-pg0-f67.google.com with SMTP id b1so3401270pgc.1
        for <linux-scsi@vger.kernel.org>; Sat, 24 Dec 2016 02:51:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com
Cc: dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 27f0cbb..ede14f1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8855,8 +8855,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct ls_rjt stat;
 
-	if ((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC)
-		BUG();
+	BUG_ON((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
 
 	switch (rspiocb->iocb.ulpStatus) {
 		case IOSTAT_NPORT_RJT:
-- 
2.7.4

