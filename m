From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 01/13] scsi: Use struct scsi_lun in fc/fcp.h
Date: Thu, 19 Jan 2012 13:39:11 -0800
Message-ID: <1327009163-10177-2-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2ASVj3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:29 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

This allows us to use scsilun_to_int without an ugly cast.

Fix up places that use scsilun_to_int on fcp->fc_lun accordingly.

In fc target, this leaves ft_cmd.lun unused, so remove it.

Signed-off-by: Andy Grover <agrover@redhat.com>

Conflicts:

	drivers/target/tcm_fc/tfc_cmd.c
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    4 +---
 drivers/scsi/libfc/fc_fcp.c     |    5 ++---
 drivers/target/tcm_fc/tcm_fc.h  |    1 -
 drivers/target/tcm_fc/tfc_cmd.c |   11 ++++-------
 include/scsi/fc/fc_fcp.h        |    6 ++++--
 5 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 84a78af..e897ce9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1682,9 +1682,7 @@ void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
 
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 
-	int_to_scsilun(sc_cmd->device->lun,
-			(struct scsi_lun *) fcp_cmnd->fc_lun);
-
+	int_to_scsilun(sc_cmd->device->lun, &fcp_cmnd->fc_lun);
 
 	fcp_cmnd->fc_dl = htonl(io_req->data_xfer_len);
 	memcpy(fcp_cmnd->fc_cdb, sc_cmd->cmnd, sc_cmd->cmd_len);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 221875e..94ada83 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1073,8 +1073,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_flags = fsp->req_flags & ~FCP_CFL_LEN_MASK;
 
-	int_to_scsilun(fsp->cmd->device->lun,
-		       (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
+	int_to_scsilun(fsp->cmd->device->lun, &fsp->cdb_cmd.fc_lun);
 	memcpy(fsp->cdb_cmd.fc_cdb, fsp->cmd->cmnd, fsp->cmd->cmd_len);
 
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
@@ -1256,7 +1255,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
-	int_to_scsilun(lun, (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
+	int_to_scsilun(lun, &fsp->cdb_cmd.fc_lun);
 
 	fsp->wait_for_comp = 1;
 	init_completion(&fsp->tm_done);
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 26061f0..3c1a756 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -113,7 +113,6 @@ struct ft_lport_acl {
  * Commands
  */
 struct ft_cmd {
-	u32 lun;                        /* LUN from request */
 	struct ft_sess *sess;		/* session held for cmd */
 	struct fc_seq *seq;		/* sequence in exchange mgr */
 	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 31f66c6..941fe00 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -61,7 +61,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		caller, cmd, cmd->sess, cmd->seq, se_cmd);
 	pr_debug("%s: cmd %p cdb %p\n",
 		caller, cmd, cmd->cdb);
-	pr_debug("%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
 
 	pr_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
 		caller, cmd, se_cmd->t_data_nents,
@@ -407,8 +406,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 
 	switch (fcp->fc_tm_flags) {
 	case FCP_TMF_LUN_RESET:
-		cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
-		if (transport_lookup_tmr_lun(&cmd->se_cmd, cmd->lun) < 0) {
+		if (transport_lookup_tmr_lun(&cmd->se_cmd, scsilun_to_int(&fcp->fc_lun)) < 0) {
 			/*
 			 * Make sure to clean up newly allocated TMR request
 			 * since "unable to  handle TMR request because failed
@@ -416,7 +414,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 			 */
 			pr_debug("Failed to get LUN for TMR func %d, "
 				  "se_cmd %p, unpacked_lun %d\n",
-				  tm_func, &cmd->se_cmd, cmd->lun);
+				  tm_func, &cmd->se_cmd, scsilun_to_int(&fcp->fc_lun));
 			ft_dump_cmd(cmd, __func__);
 			sess = cmd->sess;
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
@@ -596,14 +594,13 @@ static void ft_send_work(struct work_struct *work)
 		return;
 	}
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
-	cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
 	/*
  	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
  	 * directly from ft_check_stop_free callback in response path.
  	 */
 	ret = target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, cmd->cdb,
-				&cmd->ft_sense_buffer[0], cmd->lun, data_len,
-				task_attr, data_dir, 0);
+				&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
+				data_len, task_attr, data_dir, 0);
 	pr_debug("r_ctl %x alloc target_submit_cmd %d\n", fh->fh_r_ctl, ret);
 	if (ret < 0) {
 		ft_dump_cmd(cmd, __func__);
diff --git a/include/scsi/fc/fc_fcp.h b/include/scsi/fc/fc_fcp.h
index 652dec2..0d7d67e 100644
--- a/include/scsi/fc/fc_fcp.h
+++ b/include/scsi/fc/fc_fcp.h
@@ -20,6 +20,8 @@
 #ifndef _FC_FCP_H_
 #define	_FC_FCP_H_
 
+#include <scsi/scsi.h>
+
 /*
  * Fibre Channel Protocol for SCSI.
  * From T10 FCP-3, T10 project 1560-D Rev 4, Sept. 13, 2005.
@@ -45,7 +47,7 @@
  * FCP_CMND IU Payload.
  */
 struct fcp_cmnd {
-	__u8		fc_lun[8];	/* logical unit number */
+	struct scsi_lun	fc_lun;		/* logical unit number */
 	__u8		fc_cmdref;	/* command reference number */
 	__u8		fc_pri_ta;	/* priority and task attribute */
 	__u8		fc_tm_flags;	/* task management flags */
@@ -57,7 +59,7 @@ struct fcp_cmnd {
 #define	FCP_CMND_LEN	32	/* expected length of structure */
 
 struct fcp_cmnd32 {
-	__u8		fc_lun[8];	/* logical unit number */
+	struct scsi_lun	fc_lun;		/* logical unit number */
 	__u8		fc_cmdref;	/* command reference number */
 	__u8		fc_pri_ta;	/* priority and task attribute */
 	__u8		fc_tm_flags;	/* task management flags */
-- 
1.7.1

