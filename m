From: Matei Oprea <eu@opreamatei.ro>
Subject: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Fri, 11 Apr 2014 12:21:02 +0300
Message-ID: <1397208062-11876-1-git-send-email-eu@opreamatei.ro>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matei Oprea <eu@opreamatei.ro>, ROSEdu Kernel Community <firefly@lists.rosedu.org>
List-Id: linux-scsi@vger.kernel.org

It's easier to use kcalloc for allocating arrays. While at it
also remove useless casting value.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 635eeb3..7e58c22 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4742,12 +4742,13 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
 	}
 
-	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
-			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
-	if (!phba->sli.ring)
-		return -ENOMEM;
+	if (!phba->sli.ring) {
+		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
+					 sizeof(struct lpfc_sli_ring),
+					 GFP_KERNEL);
+		if (!phba->sli.ring)
+			return -ENOMEM;
+	}
 
 	/*
 	 * Since lpfc_sg_seg_cnt is module parameter, the sg_dma_buf_size
-- 
1.9.1
