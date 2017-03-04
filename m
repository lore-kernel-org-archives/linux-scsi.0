From: jsmart2021@gmail.com
Subject: [PATCH 01/20] scsi: lpfc: remove redundant assignment of sgel
Date: Sat,  4 Mar 2017 09:30:21 -0800
Message-ID: <1488648640-5170-2-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35281 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbdCDRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:30:59 -0500
Received: by mail-qk0-f193.google.com with SMTP id n127so34672231qkf.2
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:48 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Colin Ian King <colin.king@canonical.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

From: Colin Ian King <colin.king@canonical.com>

In the NVMET_FCOP_RSP case, sgel is assigned but never used and
hence is redundant and can be removed.

Detected by CoverityScan, CID#1411658 ("Unused value")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c421e17..e59a0a8 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1445,7 +1445,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 
 	case NVMET_FCOP_RSP:
 		/* Words 0 - 2 */
-		sgel = &rsp->sg[0];
 		physaddr = rsp->rspdma;
 		wqe->fcp_trsp.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 		wqe->fcp_trsp.bde.tus.f.bdeSize = rsp->rsplen;
-- 
2.5.0
