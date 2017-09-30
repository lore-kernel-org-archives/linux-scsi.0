From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 05/21] lpfc: Fix warning messages when NVME_TARGET_FC not defined
Date: Fri, 29 Sep 2017 17:34:31 -0700
Message-ID: <20170930003447.10747-6-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:37525 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdI3AfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:01 -0400
Received: by mail-qk0-f195.google.com with SMTP id z143so773954qkb.4
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:35:00 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Warning messages when NVME_TARGET_FC not defined on ppc builds

The lpfc_nvmet_replenish_context() function is only meaningful when
NVME target mode enabled. Surround the function body with ifdefs
for target mode enablement.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 346af470f360..b6cd213567ac 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1438,6 +1438,7 @@ static struct lpfc_nvmet_ctxbuf *
 lpfc_nvmet_replenish_context(struct lpfc_hba *phba,
 			     struct lpfc_nvmet_ctx_info *current_infop)
 {
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_ctxbuf *ctx_buf = NULL;
 	struct lpfc_nvmet_ctx_info *get_infop;
 	int i;
@@ -1485,6 +1486,7 @@ lpfc_nvmet_replenish_context(struct lpfc_hba *phba,
 		get_infop = get_infop->nvmet_ctx_next_cpu;
 	}
 
+#endif
 	/* Nothing found, all contexts for the MRQ are in-flight */
 	return NULL;
 }
-- 
2.13.1
