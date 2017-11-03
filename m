From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: bnx2i: bnx2i_hwi: use swap macro in
 bnx2i_send_iscsi_nopout
Date: Fri, 3 Nov 2017 14:58:39 -0500
Message-ID: <20171103195839.GA23385@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Make use of the swap macro and remove unnecessary variable tmp.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index e0640e0..9e3bf53 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -547,12 +547,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
 	memcpy(nopout_wqe->lun, &nopout_hdr->lun, 8);
 
-	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
-		u32 tmp = nopout_wqe->lun[0];
-		/* 57710 requires LUN field to be swapped */
-		nopout_wqe->lun[0] = nopout_wqe->lun[1];
-		nopout_wqe->lun[1] = tmp;
-	}
+	/* 57710 requires LUN field to be swapped */
+	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type))
+		swap(nopout_wqe->lun[0], nopout_wqe->lun[1]);
 
 	nopout_wqe->itt = ((u16)task->itt |
 			   (ISCSI_TASK_TYPE_MPATH <<
-- 
2.7.4
