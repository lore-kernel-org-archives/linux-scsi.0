From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 01/15] target: Remove ifdeffed code in t_g_process_write
Date: Tue, 28 Jun 2011 12:29:23 -0700
Message-ID: <1309289377-8029-2-git-send-email-agrover@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1F1T3s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 15:29:48 -0400
In-Reply-To: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |   58 --------------------------------
 1 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3288cef..9d02f86 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4945,64 +4945,6 @@ EXPORT_SYMBOL(transport_generic_new_cmd);
  */
 void transport_generic_process_write(struct se_cmd *cmd)
 {
-#if 0
-	/*
-	 * Copy SCSI Presented DTL sector(s) from received buffers allocated to
-	 * original EDTL
-	 */
-	if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
-		if (!cmd->t_tasks_se_num) {
-			unsigned char *dst, *buf =
-				(unsigned char *)cmd->t_task_buf;
-
-			dst = kzalloc(cmd->cmd_spdtl), GFP_KERNEL);
-			if (!(dst)) {
-				printk(KERN_ERR "Unable to allocate memory for"
-						" WRITE underflow\n");
-				transport_generic_request_failure(cmd, NULL,
-					PYX_TRANSPORT_REQ_TOO_MANY_SECTORS, 1);
-				return;
-			}
-			memcpy(dst, buf, cmd->cmd_spdtl);
-
-			kfree(cmd->t_task_buf);
-			cmd->t_task_buf = dst;
-		} else {
-			struct scatterlist *sg =
-				(struct scatterlist *sg)cmd->t_task_buf;
-			struct scatterlist *orig_sg;
-
-			orig_sg = kzalloc(sizeof(struct scatterlist) *
-					cmd->t_tasks_se_num,
-					GFP_KERNEL))) {
-			if (!(orig_sg)) {
-				printk(KERN_ERR "Unable to allocate memory"
-						" for WRITE underflow\n");
-				transport_generic_request_failure(cmd, NULL,
-					PYX_TRANSPORT_REQ_TOO_MANY_SECTORS, 1);
-				return;
-			}
-
-			memcpy(orig_sg, cmd->t_task_buf,
-					sizeof(struct scatterlist) *
-					cmd->t_tasks_se_num);
-
-			cmd->data_length = cmd->cmd_spdtl;
-			/*
-			 * FIXME, clear out original struct se_task and state
-			 * information.
-			 */
-			if (transport_generic_new_cmd(cmd) < 0) {
-				transport_generic_request_failure(cmd, NULL,
-					PYX_TRANSPORT_REQ_TOO_MANY_SECTORS, 1);
-				kfree(orig_sg);
-				return;
-			}
-
-			transport_memcpy_write_sg(cmd, orig_sg);
-		}
-	}
-#endif
 	transport_execute_tasks(cmd);
 }
 EXPORT_SYMBOL(transport_generic_process_write);
-- 
1.7.1

