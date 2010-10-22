From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/7] lpfc 8.3.18: Fix critical errors
Date: Fri, 22 Oct 2010 11:06:56 -0400
Message-ID: <1287760031.11844.23.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56069 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755141Ab0JVPHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:07:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix critical errors

- Update send_scsi_event to validate pnode pointer active before copying
  the wwpn information.
- Add a message, mailbox_idle, and unlock before failing SECURITY_MGMT
  or AUTH_PORT mailbox commands
- Prevent spin_lock_irqsave from being called twice in a row.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    7 ++++++-
 lpfc_bsg.c  |    4 ++--
 lpfc_scsi.c |    9 +++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-10-21 22:39:26.000000000 -0400
@@ -3789,8 +3789,13 @@ sysfs_mbox_read(struct file *filp, struc
 			break;
 		case MBX_SECURITY_MGMT:
 		case MBX_AUTH_PORT:
-			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
+				printk(KERN_WARNING "mbox_read:Command 0x%x "
+				       "is not permitted\n", pmb->mbxCommand);
+				sysfs_mbox_idle(phba);
+				spin_unlock_irq(&phba->hbalock);
 				return -EPERM;
+			}
 			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-10-21 22:39:26.000000000 -0400
@@ -3142,12 +3142,12 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *
 	job = menlo->set_job;
 	job->dd_data = NULL; /* so timeout handler does not reply */
 
-	spin_lock_irqsave(&phba->hbalock, flags);
+	spin_lock(&phba->hbalock);
 	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
 	if (cmdiocbq->context2 && rspiocbq)
 		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
 		       &rspiocbq->iocb, sizeof(IOCB_t));
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock(&phba->hbalock);
 
 	bmp = menlo->bmp;
 	rspiocbq = menlo->rspiocbq;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-10-21 22:39:26.000000000 -0400
@@ -169,6 +169,7 @@ lpfc_update_stats(struct lpfc_hba *phba,
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (!vport->stat_data_enabled ||
 		vport->stat_data_blocked ||
+		!pnode ||
 		!pnode->lat_data ||
 		(phba->bucket_type == LPFC_NO_BUCKET)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2040,6 +2041,9 @@ lpfc_send_scsi_error_event(struct lpfc_h
 	struct lpfc_nodelist *pnode = lpfc_cmd->rdata->pnode;
 	unsigned long flags;
 
+	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+		return;
+
 	/* If there is queuefull or busy condition send a scsi event */
 	if ((cmnd->result == SAM_STAT_TASK_SET_FULL) ||
 		(cmnd->result == SAM_STAT_BUSY)) {
@@ -3226,10 +3230,11 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 	struct lpfc_scsi_buf *lpfc_cmd;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
+	struct lpfc_nodelist *pnode = rdata->pnode;
 	int ret;
 	int status;
 
-	if (!rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
+	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return FAILED;
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
@@ -3256,7 +3261,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 			 "0702 Issue %s to TGT %d LUN %d "
 			 "rpi x%x nlp_flag x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
-			 rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
+			 pnode->nlp_rpi, pnode->nlp_flag);
 
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);


