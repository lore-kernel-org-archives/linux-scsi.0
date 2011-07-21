From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 085/103] target: Remove ifdeffed code in t_g_process_write
Date: Thu, 21 Jul 2011 00:12:08 -0700
Message-ID: <1311232346-6674-86-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:25955 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752326Ab1GUHJC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:09:02 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   58 --------------------------------
 1 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 056c4cb..e0be171 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4939,64 +4939,6 @@ EXPORT_SYMBOL(transport_generic_new_cmd);
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
1.7.6

