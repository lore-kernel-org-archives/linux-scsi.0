From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 08/13] target/fc: Move core->fc code conversion earlier in ft_send_tm()
Date: Thu, 19 Jan 2012 13:39:18 -0800
Message-ID: <1327009163-10177-9-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2ASVjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:32 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

No dependencies on rest of code, let's get tm_func set asap.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index f7dad73..bd69ce9 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -357,11 +357,6 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	struct ft_sess *sess;
 	u8 tm_func;
 
-	transport_init_se_cmd(&cmd->se_cmd, &ft_configfs->tf_ops,
-			cmd->sess->se_sess, 0, DMA_NONE, 0,
-			&cmd->ft_sense_buffer[0]);
-	target_get_sess_cmd(cmd->sess->se_sess, &cmd->se_cmd, false);
-
 	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
 
 	switch (fcp->fc_tm_flags) {
@@ -390,6 +385,11 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		return;
 	}
 
+	transport_init_se_cmd(&cmd->se_cmd, &ft_configfs->tf_ops,
+			cmd->sess->se_sess, 0, DMA_NONE, 0,
+			&cmd->ft_sense_buffer[0]);
+	target_get_sess_cmd(cmd->sess->se_sess, &cmd->se_cmd, false);
+
 	pr_debug("alloc tm cmd fn %d\n", tm_func);
 	core_tmr_req_init(&cmd->se_cmd, cmd, tm_func);
 
-- 
1.7.1

