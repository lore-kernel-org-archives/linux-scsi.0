From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: lpfc: Fix three sleep-in-atomic-context bugs in lpfc_prep_els_iocb()
Date: Sat, 15 Sep 2018 11:41:27 +0800
Message-ID: <20180915034127.6597-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep with holding a spinlock.
The function call paths (from bottom to top) in Linux-4.17 are:

[FUNC] kmalloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_els.c, 205: 
	kmalloc in lpfc_prep_els_iocb
drivers/scsi/lpfc/lpfc_els.c, 2010: 
	lpfc_prep_els_iocb in lpfc_issue_els_plogi
drivers/scsi/lpfc/lpfc_els.c, 4914: 
	lpfc_issue_els_plogi in lpfc_els_disc_plogi
drivers/scsi/lpfc/lpfc_els.c, 1486: 
	lpfc_els_disc_plogi in lpfc_more_plogi
drivers/scsi/lpfc/lpfc_els.c, 3123: 
	lpfc_more_plogi in lpfc_cancel_retry_delay_tmo
drivers/scsi/lpfc/lpfc_nportdisc.c, 279: 
	lpfc_cancel_retry_delay_tmo in lpfc_els_abort
drivers/scsi/lpfc/lpfc_nportdisc.c, 259: 
	spin_lock_irq in lpfc_els_abort

[FUNC] kmalloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_els.c, 226: 
	kmalloc in lpfc_prep_els_iocb
drivers/scsi/lpfc/lpfc_els.c, 2010: 
	lpfc_prep_els_iocb in lpfc_issue_els_plogi
drivers/scsi/lpfc/lpfc_els.c, 4914: 
	lpfc_issue_els_plogi in lpfc_els_disc_plogi
drivers/scsi/lpfc/lpfc_els.c, 1486: 
	lpfc_els_disc_plogi in lpfc_more_plogi
drivers/scsi/lpfc/lpfc_els.c, 3123: 
	lpfc_more_plogi in lpfc_cancel_retry_delay_tmo
drivers/scsi/lpfc/lpfc_nportdisc.c, 279: 
	lpfc_cancel_retry_delay_tmo in lpfc_els_abort
drivers/scsi/lpfc/lpfc_nportdisc.c, 259: 
	spin_lock_irq in lpfc_els_abort

[FUNC] kmalloc(GFP_KERNEL)
drivers/scsi/lpfc/lpfc_els.c, 215: 
	kmalloc in lpfc_prep_els_iocb
drivers/scsi/lpfc/lpfc_els.c, 2010: 
	lpfc_prep_els_iocb in lpfc_issue_els_plogi
drivers/scsi/lpfc/lpfc_els.c, 4914: 
	lpfc_issue_els_plogi in lpfc_els_disc_plogi
drivers/scsi/lpfc/lpfc_els.c, 1486: 
	lpfc_els_disc_plogi in lpfc_more_plogi
drivers/scsi/lpfc/lpfc_els.c, 3123: 
	lpfc_more_plogi in lpfc_cancel_retry_delay_tmo
drivers/scsi/lpfc/lpfc_nportdisc.c, 279: 
	lpfc_cancel_retry_delay_tmo in lpfc_els_abort
drivers/scsi/lpfc/lpfc_nportdisc.c, 259: 
	spin_lock_irq in lpfc_els_abort

To fix these bugs, GFP_KERNEL is replaced with GFP_ATOMIC.

These bugs are found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4dda969e947c..e21b360eb764 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -202,7 +202,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 
 	/* fill in BDEs for command */
 	/* Allocate buffer for command payload */
-	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_ATOMIC);
 	if (pcmd)
 		pcmd->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &pcmd->phys);
 	if (!pcmd || !pcmd->virt)
@@ -212,7 +212,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 
 	/* Allocate buffer for response payload */
 	if (expectRsp) {
-		prsp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+		prsp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_ATOMIC);
 		if (prsp)
 			prsp->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						     &prsp->phys);
@@ -223,7 +223,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		prsp = NULL;
 
 	/* Allocate buffer for Buffer ptr list */
-	pbuflist = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	pbuflist = kmalloc(sizeof(struct lpfc_dmabuf), GFP_ATOMIC);
 	if (pbuflist)
 		pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						 &pbuflist->phys);
-- 
2.17.0
