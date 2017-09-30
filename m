From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 11/21] lpfc: Set missing abort context
Date: Fri, 29 Sep 2017 17:34:37 -0700
Message-ID: <20170930003447.10747-12-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35186 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752622AbdI3AfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:06 -0400
Received: by mail-qk0-f194.google.com with SMTP id o77so782777qke.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:35:06 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Always set ctxp->state to LPFC_NVMET_STE_ABORT if ABORT op gets called

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 354e60043ea1..e410a6f1e2c2 100644
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
