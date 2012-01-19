From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 06/13] target/fc: Remove cmd->cdb data member
Date: Thu, 19 Jan 2012 13:39:16 -0800
Message-ID: <1327009163-10177-7-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab2ASVjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:31 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

It's used only for debug output. Debug output may want to make use of
fcp->fc_cdb directly.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tcm_fc.h  |    1 -
 drivers/target/tcm_fc/tfc_cmd.c |    8 +-------
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 3c1a756..650a2ba 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -117,7 +117,6 @@ struct ft_cmd {
 	struct fc_seq *seq;		/* sequence in exchange mgr */
 	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
 	struct fc_frame *req_frame;
-	unsigned char *cdb;		/* pointer to CDB inside frame */
 	u32 write_data_len;		/* data received on writes */
 	struct work_struct work;
 	/* Local sense buffer */
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 85fcd09..6884b0f 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -59,8 +59,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	se_cmd = &cmd->se_cmd;
 	pr_debug("%s: cmd %p sess %p seq %p se_cmd %p\n",
 		caller, cmd, cmd->sess, cmd->seq, se_cmd);
-	pr_debug("%s: cmd %p cdb %p\n",
-		caller, cmd, cmd->cdb);
 
 	pr_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
 		caller, cmd, se_cmd->t_data_nents,
@@ -80,8 +78,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 			caller, cmd, ep->sid, ep->did, ep->oxid, ep->rxid,
 			sp->id, ep->esb_stat);
 	}
-	print_hex_dump(KERN_INFO, "ft_dump_cmd ", DUMP_PREFIX_NONE,
-		16, 4, cmd->cdb, MAX_COMMAND_SIZE, 0);
 }
 
 static void ft_free_cmd(struct ft_cmd *cmd)
@@ -585,14 +581,12 @@ static void ft_send_work(struct work_struct *work)
 		task_attr = MSG_SIMPLE_TAG;
 	}
 
-	cmd->cdb = fcp->fc_cdb;
-
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 	/*
  	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
  	 * directly from ft_check_stop_free callback in response path.
  	 */
-	ret = target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, cmd->cdb,
+	ret = target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
 				&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
 				ntohl(fcp->fc_dl), task_attr, data_dir, 0);
 	pr_debug("r_ctl %x alloc target_submit_cmd %d\n", fh->fh_r_ctl, ret);
-- 
1.7.1

