From: jsmart2021@gmail.com
Subject: ["PATCH-v2" 01/22] Standardize nvme SGL segment count
Date: Thu, 20 Apr 2017 15:04:27 -0700
Message-ID: <20170420220448.27095-2-jsmart2021@gmail.com>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36265 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947449AbdDTWE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:04:59 -0400
Received: by mail-oi0-f66.google.com with SMTP id a3so8780816oii.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 15:04:58 -0700 (PDT)
In-Reply-To: <20170420220448.27095-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Standardize default SGL segment count for nvme target and initiator

The driver needs to make them the same for clarity.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvme.h  | 4 +---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.h | 4 +---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 1347deb..6277796 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -21,9 +21,7 @@
  * included with this package.                                     *
  ********************************************************************/
 
-#define LPFC_NVME_MIN_SEGS		16
-#define LPFC_NVME_DEFAULT_SEGS		66	/* 256K IOs - 64 + 2 */
-#define LPFC_NVME_MAX_SEGS		510
+#define LPFC_NVME_DEFAULT_SEGS		(64 + 1)	/* 256K IOs */
 #define LPFC_NVMET_MIN_POSTBUF		16
 #define LPFC_NVMET_DEFAULT_POSTBUF	1024
 #define LPFC_NVMET_MAX_POSTBUF		4096
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index d488c33..c8a4941 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -709,7 +709,7 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	pinfo.port_id = vport->fc_myDID;
 
 	lpfc_tgttemplate.max_hw_queues = phba->cfg_nvme_io_channel;
-	lpfc_tgttemplate.max_sgl_segments = phba->cfg_sg_seg_cnt;
+	lpfc_tgttemplate.max_sgl_segments = phba->cfg_sg_seg_cnt + 1;
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED |
 					   NVMET_FCTGTFEAT_CMD_IN_ISR |
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 02735fc..d8bac4c 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -21,9 +21,7 @@
  * included with this package.                                     *
  ********************************************************************/
 
-#define LPFC_NVMET_MIN_SEGS		16
-#define LPFC_NVMET_DEFAULT_SEGS		64	/* 256K IOs */
-#define LPFC_NVMET_MAX_SEGS		510
+#define LPFC_NVMET_DEFAULT_SEGS		(64 + 1)	/* 256K IOs */
 #define LPFC_NVMET_SUCCESS_LEN	12
 
 /* Used for NVME Target */
-- 
2.9.3
