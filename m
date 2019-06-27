From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 62/87] scsi: lpfc: replace kmalloc and memset with kzalloc
Date: Fri, 28 Jun 2019 01:44:46 +0800
Message-ID: <20190627174446.5624-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

kmalloc + memset(0) -> kzalloc

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 1ee857d9d165..0dfac41f2fa8 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6017,7 +6017,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				 phba->hba_debugfs_root,
 				 phba, &lpfc_debugfs_op_slow_ring_trc);
 		if (!phba->slow_ring_trc) {
-			phba->slow_ring_trc = kmalloc(
+			phba->slow_ring_trc = kzalloc(
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc),
 				GFP_KERNEL);
@@ -6028,9 +6028,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				goto debug_failed;
 			}
 			atomic_set(&phba->slow_ring_trc_cnt, 0);
-			memset(phba->slow_ring_trc, 0,
-				(sizeof(struct lpfc_debugfs_trc) *
-				lpfc_debugfs_max_slow_ring_trc));
 		}
 
 		snprintf(name, sizeof(name), "nvmeio_trc");
-- 
2.11.0
