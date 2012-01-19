From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 05/13] target/fc: Simplify ft_send_work for tmr path
Date: Thu, 19 Jan 2012 13:39:15 -0800
Message-ID: <1327009163-10177-6-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

Check fc_tm_flags early and call ft_send_tm() right away. Don't need to
set local vars for tm case.

data_len local var now unneeded, remove.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |   76 ++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 941fe00..85fcd09 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -536,7 +536,6 @@ static void ft_send_work(struct work_struct *work)
 	struct fc_frame_header *fh = fc_frame_header_get(cmd->req_frame);
 	struct fcp_cmnd *fcp;
 	int data_dir = 0;
-	u32 data_len;
 	int task_attr;
 	int ret;
 
@@ -547,45 +546,6 @@ static void ft_send_work(struct work_struct *work)
 	if (fcp->fc_flags & FCP_CFL_LEN_MASK)
 		goto err;		/* not handling longer CDBs yet */
 
-	if (fcp->fc_tm_flags) {
-		task_attr = FCP_PTA_SIMPLE;
-		data_dir = DMA_NONE;
-		data_len = 0;
-	} else {
-		switch (fcp->fc_flags & (FCP_CFL_RDDATA | FCP_CFL_WRDATA)) {
-		case 0:
-			data_dir = DMA_NONE;
-			break;
-		case FCP_CFL_RDDATA:
-			data_dir = DMA_FROM_DEVICE;
-			break;
-		case FCP_CFL_WRDATA:
-			data_dir = DMA_TO_DEVICE;
-			break;
-		case FCP_CFL_WRDATA | FCP_CFL_RDDATA:
-			goto err;	/* TBD not supported by tcm_fc yet */
-		}
-		/*
-		 * Locate the SAM Task Attr from fc_pri_ta
-		 */
-		switch (fcp->fc_pri_ta & FCP_PTA_MASK) {
-		case FCP_PTA_HEADQ:
-			task_attr = MSG_HEAD_TAG;
-			break;
-		case FCP_PTA_ORDERED:
-			task_attr = MSG_ORDERED_TAG;
-			break;
-		case FCP_PTA_ACA:
-			task_attr = MSG_ACA_TAG;
-			break;
-		case FCP_PTA_SIMPLE: /* Fallthrough */
-		default:
-			task_attr = MSG_SIMPLE_TAG;
-		}
-		
-		data_len = ntohl(fcp->fc_dl);
-		cmd->cdb = fcp->fc_cdb;
-	}
 	/*
 	 * Check for FCP task management flags
 	 */
@@ -593,6 +553,40 @@ static void ft_send_work(struct work_struct *work)
 		ft_send_tm(cmd);
 		return;
 	}
+
+	switch (fcp->fc_flags & (FCP_CFL_RDDATA | FCP_CFL_WRDATA)) {
+	case 0:
+		data_dir = DMA_NONE;
+		break;
+	case FCP_CFL_RDDATA:
+		data_dir = DMA_FROM_DEVICE;
+		break;
+	case FCP_CFL_WRDATA:
+		data_dir = DMA_TO_DEVICE;
+		break;
+	case FCP_CFL_WRDATA | FCP_CFL_RDDATA:
+		goto err;	/* TBD not supported by tcm_fc yet */
+	}
+	/*
+	 * Locate the SAM Task Attr from fc_pri_ta
+	 */
+	switch (fcp->fc_pri_ta & FCP_PTA_MASK) {
+	case FCP_PTA_HEADQ:
+		task_attr = MSG_HEAD_TAG;
+		break;
+	case FCP_PTA_ORDERED:
+		task_attr = MSG_ORDERED_TAG;
+		break;
+	case FCP_PTA_ACA:
+		task_attr = MSG_ACA_TAG;
+		break;
+	case FCP_PTA_SIMPLE: /* Fallthrough */
+	default:
+		task_attr = MSG_SIMPLE_TAG;
+	}
+
+	cmd->cdb = fcp->fc_cdb;
+
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 	/*
  	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
@@ -600,7 +594,7 @@ static void ft_send_work(struct work_struct *work)
  	 */
 	ret = target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, cmd->cdb,
 				&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-				data_len, task_attr, data_dir, 0);
+				ntohl(fcp->fc_dl), task_attr, data_dir, 0);
 	pr_debug("r_ctl %x alloc target_submit_cmd %d\n", fh->fh_r_ctl, ret);
 	if (ret < 0) {
 		ft_dump_cmd(cmd, __func__);
-- 
1.7.1
