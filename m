From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 01/19] Fix advertised max_sgl_segment count for NVMET
Date: Tue,  4 Apr 2017 10:16:54 -0700
Message-ID: <1491326232-11255-2-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38135 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754986AbdDDRZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:37 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 8E5B530C0A4
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:24 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
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
index 7ca868f..86ab95c 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -667,7 +667,7 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	pinfo.port_id = vport->fc_myDID;
 
 	lpfc_tgttemplate.max_hw_queues = phba->cfg_nvme_io_channel;
-	lpfc_tgttemplate.max_sgl_segments = phba->cfg_sg_seg_cnt;
+	lpfc_tgttemplate.max_sgl_segments = phba->cfg_sg_seg_cnt + 1;
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index ca96f05..0aa202c 100644
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
2.1.0
