From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] drivers: scsi: lpfc: Remove useless casting in lpfc_init.c
Date: Wed, 16 Oct 2013 13:17:16 -0300
Message-ID: <1381940236-29531-1-git-send-email-geyslan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Casting (void *) value returned by kzalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 647f5bf..bc417d5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4733,9 +4733,8 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
-			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
+					 sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
 
-- 
1.8.4
