From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: [PATCH] bnx2fc: Fix locking requirements in bnx2fc_init_tgt
Date: Tue,  5 Apr 2016 10:36:46 -0400
Message-ID: <1459867006-19605-1-git-send-email-bastienphilbert@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This fixes the locking around the call to bnx2fc_alloc_id to comply
with the comments about this particular function's definition about
requiring the need to hold the hba mutex before and after calling 
it.
Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 08ec318..f2988cd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -368,9 +368,13 @@ static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
 		return -1;
 	}
 
+	mutex_lock(&hba->hba_mutex);
 	tgt->fcoe_conn_id = bnx2fc_alloc_conn_id(hba, tgt);
-	if (tgt->fcoe_conn_id == -1)
+	if (tgt->fcoe_conn_id == -1) {
+		mutex_unlock(&hba->hba_mutex);
 		return -1;
+	}
+	mutex_unlock(&hba->hba_mutex);
 
 	BNX2FC_TGT_DBG(tgt, "init_tgt - conn_id = 0x%x\n", tgt->fcoe_conn_id);
 
-- 
2.5.0
