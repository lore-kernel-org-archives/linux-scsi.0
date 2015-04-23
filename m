From: Firo Yang <firogm@gmail.com>
Subject: [PATCH] lpfc: Remove unnessary cast
Date: Thu, 23 Apr 2015 17:54:11 +0800
Message-ID: <1429782851-6716-1-git-send-email-firogm@gmail.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: james.smart@emulex.com, JBottomley@odin.com
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Firo Yang <firogm@gmail.com>
List-Id: linux-scsi@vger.kernel.org

kzalloc() returns a void pointer - no need to cast it in
drivers/scsi/lpfc/lpfc_init.c::lpfc_sli_driver_resource_setup()

Signed-off-by: Firo Yang <firogm@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e8c8c1e..30b72da 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4975,8 +4975,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
-- 
2.1.0

