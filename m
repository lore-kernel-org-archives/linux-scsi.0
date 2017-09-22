From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 04/19] lpfc: Fix warning messages when NVME_TARGET_FC not defined
Date: Thu, 21 Sep 2017 23:17:26 -0700
Message-ID: <20170922061741.12347-5-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34576 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbdIVGR7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:17:59 -0400
Received: by mail-pg0-f68.google.com with SMTP id u18so126547pgo.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:17:59 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
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
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 0b7c1a49e203..313d5c10e0ad 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1457,6 +1457,7 @@ static struct lpfc_nvmet_ctxbuf *
 lpfc_nvmet_replenish_context(struct lpfc_hba *phba,
 			     struct lpfc_nvmet_ctx_info *current_infop)
 {
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_ctxbuf *ctx_buf = NULL;
 	struct lpfc_nvmet_ctx_info *get_infop;
 	int i;
@@ -1504,6 +1505,7 @@ lpfc_nvmet_replenish_context(struct lpfc_hba *phba,
 		get_infop = get_infop->nvmet_ctx_next_cpu;
 	}
 
+#endif
 	/* Nothing found, all contexts for the MRQ are in-flight */
 	return NULL;
 }
-- 
2.13.1
