From: madhu.iyengar@qlogic.com
Subject: [PATCH 10/12] qla2xxx: Drop srb reference before waiting for completion.
Date: Fri, 15 Oct 2010 11:27:47 -0700
Message-ID: <1287167269-8034-11-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36965 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756401Ab0JOSg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:29 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch fixes a regression introduced by commit
083a469db4ecf3b286a96b5b722c37fc1affe0be

qla2xxx_eh_wait_on_command() is waiting for an srb to
complete, which will never happen as the routine took
a reference to the srb previously and will only drop it
after this function. So every command abort will fail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   61 +++++++++++++---------------------------
 1 files changed, 20 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c9f9ed3..b0c7139 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -830,62 +830,44 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret, i;
+	int ret;
 	unsigned int id, lun;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = vha->req;
-	srb_t *spt;
-	int got_ref = 0;
 
 	fc_block_scsi_eh(cmd);
 
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
-	ret = SUCCESS;
-
 	id = cmd->device->id;
 	lun = cmd->device->lun;
-	spt = (srb_t *) CMD_SP(cmd);
-	if (!spt)
-		return SUCCESS;
 
-	/* Check active list for command command. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		sp = req->outstanding_cmds[i];
-
-		if (sp == NULL)
-			continue;
-		if ((sp->ctx) && !(sp->flags & SRB_FCP_CMND_DMA_VALID) &&
-		    !IS_PROT_IO(sp))
-			continue;
-		if (sp->cmd != cmd)
-			continue;
+	sp = (srb_t *) CMD_SP(cmd);
+	if (!sp) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		return SUCCESS;
+	}
 
-		DEBUG2(printk("%s(%ld): aborting sp %p from RISC.",
-		    __func__, vha->host_no, sp));
+	DEBUG2(printk("%s(%ld): aborting sp %p from RISC.",
+	    __func__, vha->host_no, sp));
 
-		/* Get a reference to the sp and drop the lock.*/
-		sp_get(sp);
-		got_ref++;
+	/* Get a reference to the sp and drop the lock.*/
+	sp_get(sp);
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(sp)) {
-			DEBUG2(printk("%s(%ld): abort_command "
-			"mbx failed.\n", __func__, vha->host_no));
-			ret = FAILED;
-		} else {
-			DEBUG3(printk("%s(%ld): abort_command "
-			"mbx success.\n", __func__, vha->host_no));
-			wait = 1;
-		}
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		break;
-	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (ha->isp_ops->abort_command(sp)) {
+		DEBUG2(printk("%s(%ld): abort_command "
+		"mbx failed.\n", __func__, vha->host_no));
+		ret = FAILED;
+	} else {
+		DEBUG3(printk("%s(%ld): abort_command "
+		"mbx success.\n", __func__, vha->host_no));
+		wait = 1;
+	}
+	qla2x00_sp_compl(ha, sp);
 
 	/* Wait for the command to be returned. */
 	if (wait) {
@@ -897,9 +879,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (got_ref)
-		qla2x00_sp_compl(ha, sp);
-
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %x.\n",
 	    vha->host_no, id, lun, wait, ret);
-- 
1.6.0.2

