From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/11] qla4xxx: correct use of cmd->host_scribble
Date: Wed, 28 Apr 2010 11:41:59 +0530
Message-ID: <20100428061159.GA11161@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:6062
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750918Ab0D1GPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:15:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

used cmd->host_scribble to store iocb command handle.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 ++
 drivers/scsi/qla4xxx/ql4_iocb.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |   18 ++++++++++--------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 1e56b8e..b6f2d01 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -148,6 +148,8 @@
 
 #define MAX_RESET_HA_RETRIES		2
 
+#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
+
 /*
  * SCSI Request Block structure	 (srb)	that is placed
  * on cmd->SCp location of every I/O	 [We have 22 bytes available]
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index e0c3215..e66f3f2 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -299,7 +299,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	qla4xxx_build_scsi_iocbs(srb, cmd_entry, tot_dsds);
 	wmb();
 
-	srb->cmd->host_scribble = (unsigned char *)srb;
+	srb->cmd->host_scribble = (unsigned char *)(unsigned long)index;
 
 	/* update counters */
 	srb->state = SRB_ACTIVE_STATE;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 34af8ce..0dd9578 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -388,7 +388,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 	srb->ddb = ddb_entry;
 	srb->cmd = cmd;
 	srb->flags = 0;
-	cmd->SCp.ptr = (void *)srb;
+	CMD_SP(cmd) = (void *)srb;
 	cmd->scsi_done = done;
 
 	return srb;
@@ -402,7 +402,7 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_host *ha, struct srb *srb)
 		scsi_dma_unmap(cmd);
 		srb->flags &= ~SRB_DMA_VALID;
 	}
-	cmd->SCp.ptr = NULL;
+	CMD_SP(cmd) = NULL;
 }
 
 void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb)
@@ -890,7 +890,6 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 }
 
 /**
@@ -1478,12 +1477,14 @@ static void qla4xxx_slave_destroy(struct scsi_device *sdev)
 struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t index)
 {
 	struct srb *srb = NULL;
-	struct scsi_cmnd *cmd;
+	struct scsi_cmnd *cmd = NULL;
 
-	if (!(cmd = scsi_host_find_tag(ha->host, index)))
+	cmd = scsi_host_find_tag(ha->host, index);
+	if (!cmd)
 		return srb;
 
-	if (!(srb = (struct srb *)cmd->host_scribble))
+	srb = (struct srb *)CMD_SP(cmd);
+	if (!srb)
 		return srb;
 
 	/* update counters */
@@ -1491,7 +1492,8 @@ struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t in
 		ha->req_q_count += srb->iocb_cnt;
 		ha->iocb_cnt -= srb->iocb_cnt;
 		if (srb->cmd)
-			srb->cmd->host_scribble = NULL;
+			srb->cmd->host_scribble =
+				(unsigned char *)(unsigned long) MAX_SRBS;
 	}
 	return srb;
 }
@@ -1513,7 +1515,7 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
 
 	do {
 		/* Checking to see if its returned to OS */
-		rp = (struct srb *) cmd->SCp.ptr;
+		rp = (struct srb *) CMD_SP(cmd);
 		if (rp == NULL) {
 			done++;
 			break;
-- 
1.7.0.5

