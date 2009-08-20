From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/2] qla2xxx: Generalize srb structure usage.
Date: Thu, 20 Aug 2009 11:06:04 -0700
Message-ID: <1250791565-285-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1250791565-285-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59437 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755130AbZHTSGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 14:06:06 -0400
In-Reply-To: <1250791565-285-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Lay groundwork for adding alternative asynchronous operations by
generalize and extending the SRB structure.  This allows for
follow-on patches to add support for:

- Asynchronous logins.
- ELS/CT passthru requests.
- Loopback requests.
- Non-blocking mailbox commands (ABTS, Task Management, etc).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +++
 drivers/scsi/qla2xxx/qla_iocb.c |    2 ++
 drivers/scsi/qla2xxx/qla_os.c   |   11 +++++++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 68ab28c..9eb7be6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -189,6 +189,7 @@ struct req_que;
  */
 typedef struct srb {
 	struct fc_port *fcport;
+	uint32_t handle;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
 
@@ -196,6 +197,8 @@ typedef struct srb {
 
 	uint32_t request_sense_length;
 	uint8_t *request_sense_ptr;
+
+	void *ctx;
 } srb_t;
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c0ba370..d37554e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -350,6 +350,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Build command packet */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
@@ -778,6 +779,7 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d7b2713..b6c088c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -473,6 +473,7 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
 	cmd->scsi_done = done;
+	sp->ctx = NULL;
 
 	return sp;
 }
@@ -709,6 +710,8 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 			continue;
 		if (sp->fcport != fcport)
 			continue;
+		if (sp->ctx)
+			continue;
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		if (ha->isp_ops->abort_command(sp)) {
@@ -794,7 +797,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		if (sp == NULL)
 			continue;
-
+		if (sp->ctx)
+			continue;
 		if (sp->cmd != cmd)
 			continue;
 
@@ -859,7 +863,8 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 		sp = req->outstanding_cmds[cnt];
 		if (!sp)
 			continue;
-
+		if (sp->ctx)
+			continue;
 		if (vha->vp_idx != sp->fcport->vha->vp_idx)
 			continue;
 		match = 0;
@@ -2986,6 +2991,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 					sp = req->outstanding_cmds[index];
 					if (!sp)
 						continue;
+					if (sp->ctx)
+						continue;
 					sfcp = sp->fcport;
 					if (!(sfcp->flags & FCF_TAPE_PRESENT))
 						continue;
-- 
1.6.2.rc1.30.gd43c

