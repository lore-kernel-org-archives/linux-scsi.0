From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 12/13] target/fc: Use target_submit_tmr()
Date: Thu, 19 Jan 2012 13:39:22 -0800
Message-ID: <1327009163-10177-13-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab2ASVjd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:33 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

Make use of the new helper function to submit a TMR.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |   25 +++----------------------
 1 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index da73d0a..08a10e1 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -355,7 +355,6 @@ static void ft_send_tm(struct ft_cmd *cmd)
 {
 	struct fcp_cmnd *fcp;
 	u8 tm_func;
-	int ret;
 
 	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
 	switch (fcp->fc_tm_flags) {
@@ -384,27 +383,9 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		return;
 	}
 
-	transport_init_se_cmd(&cmd->se_cmd, &ft_configfs->tf_ops,
-			cmd->sess->se_sess, 0, DMA_NONE, 0,
-			&cmd->ft_sense_buffer[0]);
-	target_get_sess_cmd(cmd->sess->se_sess, &cmd->se_cmd, false);
-
-	pr_debug("alloc tm cmd fn %d\n", tm_func);
-	core_tmr_req_init(&cmd->se_cmd, cmd, tm_func);
-
-	ret = transport_lookup_tmr_lun(&cmd->se_cmd, scsilun_to_int(&fcp->fc_lun));
-	if (ret < 0) {
-		pr_debug("Failed to get LUN for TMR func %d, "
-			 "se_cmd %p, unpacked_lun %d\n",
-			 tm_func, &cmd->se_cmd, scsilun_to_int(&fcp->fc_lun));
-		ft_dump_cmd(cmd, __func__);
-		transport_send_check_condition_and_sense(&cmd->se_cmd,
-			cmd->se_cmd.scsi_sense_reason, 0);
-		transport_generic_free_cmd(&cmd->se_cmd, 0);
-		return;
-	}
-
-	transport_generic_handle_tmr(&cmd->se_cmd);
+	target_submit_tmr(&cmd->se_cmd, cmd->sess->se_sess,
+		&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
+			  cmd, tm_func, 0);
 }
 
 /*
-- 
1.7.1

