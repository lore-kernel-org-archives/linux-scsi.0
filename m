From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 10/19] lpfc: Set missing abort context
Date: Thu, 21 Sep 2017 23:17:32 -0700
Message-ID: <20170922061741.12347-11-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36338 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbdIVGSF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:05 -0400
Received: by mail-pf0-f195.google.com with SMTP id f84so88302pfj.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:05 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Always set ctxp->state to LPFC_NVMET_STE_ABORT if ABORT op gets called

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 43ad220e17ad..ee88343f3e8c 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -822,6 +822,7 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	atomic_inc(&lpfc_nvmep->xmt_fcp_abort);
 
 	spin_lock_irqsave(&ctxp->ctxlock, flags);
+	ctxp->state = LPFC_NVMET_STE_ABORT;
 
 	/* Since iaab/iaar are NOT set, we need to check
 	 * if the firmware is in process of aborting IO
-- 
2.13.1
