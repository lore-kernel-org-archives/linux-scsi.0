From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ipr: Fix abort path race condition
Date: Wed, 15 Mar 2017 16:58:39 -0500
Message-ID: <20170315215839.717E878041@b03ledav004.gho.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34221 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753867AbdCOV6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 17:58:45 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2FLsSff072198
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:44 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 296nfxux5j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:44 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 15 Mar 2017 17:58:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


This fixes a race condition in the error handlomg paths of ipr. While a command is
outstanding to the adapter, it is placed on a pending queue for the hrrq it is
associated with, while holding the HRRQ lock. When a command is completed,
it is removed from the pending queue, under HRRQ lock, and placed on a local list.
This list is then iterated through without any locks and each command's done function
is invoked, inside of which, the command gets returned to the free list while grabbing
the HRRQ lock. This fixes two race conditions when commands have been removed from the
pending list but have not yet been added to the free list. Both of these changes
fix race conditions that could result in returning success from eh_abort_handler
and then later calling scsi_done for the same request.

The first race condition is in ipr_cancel_op. It looks through each pending queue
to see if the command to be aborted is still outstanding or not. Rather than
looking on the pending queue, reverse the logic to check to look for commands
that are NOT on the free queue.  The second race condition can occur when in
ipr_wait_for_ops where we are waiting for responses for commands we've aborted.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   64 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_wait_for_ops_fixup2 drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_wait_for_ops_fixup2	2017-03-13 15:55:24.902123623 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2017-03-13 15:55:24.908123599 -0500
@@ -5008,6 +5008,25 @@ static int ipr_match_lun(struct ipr_cmnd
 }
 
 /**
+ * ipr_cmnd_is_free - Check if a command is free or not
+ * @ipr_cmd	ipr command struct
+ *
+ * Returns:
+ *	true / false
+ **/
+static bool ipr_cmnd_is_free(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_cmnd *loop_cmd;
+
+	list_for_each_entry(loop_cmd, &ipr_cmd->hrrq->hrrq_free_q, queue) {
+		if (loop_cmd == ipr_cmd)
+			return true;
+	}
+
+	return false;
+}
+
+/**
  * ipr_wait_for_ops - Wait for matching commands to complete
  * @ipr_cmd:	ipr command struct
  * @device:		device to match (sdev)
@@ -5020,7 +5039,7 @@ static int ipr_wait_for_ops(struct ipr_i
 			    int (*match)(struct ipr_cmnd *, void *))
 {
 	struct ipr_cmnd *ipr_cmd;
-	int wait;
+	int wait, i;
 	unsigned long flags;
 	struct ipr_hrr_queue *hrrq;
 	signed long timeout = IPR_ABORT_TASK_TIMEOUT;
@@ -5032,10 +5051,13 @@ static int ipr_wait_for_ops(struct ipr_i
 
 		for_each_hrrq(hrrq, ioa_cfg) {
 			spin_lock_irqsave(hrrq->lock, flags);
-			list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
-				if (match(ipr_cmd, device)) {
-					ipr_cmd->eh_comp = &comp;
-					wait++;
+			for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
+				ipr_cmd = ioa_cfg->ipr_cmnd_list[i];
+				if (!ipr_cmnd_is_free(ipr_cmd)) {
+					if (match(ipr_cmd, device)) {
+						ipr_cmd->eh_comp = &comp;
+						wait++;
+					}
 				}
 			}
 			spin_unlock_irqrestore(hrrq->lock, flags);
@@ -5049,10 +5071,13 @@ static int ipr_wait_for_ops(struct ipr_i
 
 				for_each_hrrq(hrrq, ioa_cfg) {
 					spin_lock_irqsave(hrrq->lock, flags);
-					list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
-						if (match(ipr_cmd, device)) {
-							ipr_cmd->eh_comp = NULL;
-							wait++;
+					for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
+						ipr_cmd = ioa_cfg->ipr_cmnd_list[i];
+						if (!ipr_cmnd_is_free(ipr_cmd)) {
+							if (match(ipr_cmd, device)) {
+								ipr_cmd->eh_comp = NULL;
+								wait++;
+							}
 						}
 					}
 					spin_unlock_irqrestore(hrrq->lock, flags);
@@ -5219,7 +5244,7 @@ static int __ipr_eh_dev_reset(struct scs
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 	struct ata_port *ap;
-	int rc = 0;
+	int rc = 0, i;
 	struct ipr_hrr_queue *hrrq;
 
 	ENTER;
@@ -5241,10 +5266,14 @@ static int __ipr_eh_dev_reset(struct scs
 
 	for_each_hrrq(hrrq, ioa_cfg) {
 		spin_lock(&hrrq->_lock);
-		list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+		for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
+			ipr_cmd = ioa_cfg->ipr_cmnd_list[i];
+
 			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
 				if (!ipr_cmd->qc)
 					continue;
+				if (ipr_cmnd_is_free(ipr_cmd))
+					continue;
 
 				ipr_cmd->done = ipr_sata_eh_done;
 				if (!(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
@@ -5394,7 +5423,7 @@ static int ipr_cancel_op(struct scsi_cmn
 	struct ipr_resource_entry *res;
 	struct ipr_cmd_pkt *cmd_pkt;
 	u32 ioasc, int_reg;
-	int op_found = 0;
+	int i, op_found = 0;
 	struct ipr_hrr_queue *hrrq;
 
 	ENTER;
@@ -5423,11 +5452,12 @@ static int ipr_cancel_op(struct scsi_cmn
 
 	for_each_hrrq(hrrq, ioa_cfg) {
 		spin_lock(&hrrq->_lock);
-		list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
-			if (ipr_cmd->scsi_cmd == scsi_cmd) {
-				ipr_cmd->done = ipr_scsi_eh_done;
-				op_found = 1;
-				break;
+		for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
+			if (ioa_cfg->ipr_cmnd_list[i]->scsi_cmd == scsi_cmd) {
+				if (!ipr_cmnd_is_free(ioa_cfg->ipr_cmnd_list[i])) {
+					op_found = 1;
+					break;
+				}
 			}
 		}
 		spin_unlock(&hrrq->_lock);
_
