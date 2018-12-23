From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 04/20] scsi: lpfc: lpfc_scsi: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:56:59 +0100
Message-ID: <1545555435-24576-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

These were introduced in 8a9d2e8003040 ("[SCSI] lpfc 8.3.31:
Correct handling of SLI4-port XRI resource-provisioning profile
change"), but were not even used at that time.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 8a9d2e8003040 ("[SCSI] lpfc 8.3.31: Correct handling of SLI4-port XRI resource-provisioning profile change")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/scsi/lpfc/lpfc_scsi.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b4f1a840b3b4..dd415d783593 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -805,9 +805,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 	dma_addr_t pdma_phys_bpl;
 	uint16_t iotag, lxri = 0;
 	int bcnt, num_posted, sgl_size;
-	LIST_HEAD(prep_sblist);
 	LIST_HEAD(post_sblist);
-	LIST_HEAD(scsi_sblist);
 
 	sgl_size = phba->cfg_sg_dma_buf_size -
 		(sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
