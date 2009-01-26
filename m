From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][SCST]: Minor cleanup in scst_user module with aim to have
 more robust code
Date: Mon, 26 Jan 2009 21:19:21 +0300
Message-ID: <497DFEA9.20605@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZAZSTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 13:19:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net

This patch does a minor cleanup with aim to have more robust code

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 scst_user.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

Index: scst/src/dev_handlers/scst_user.c
===================================================================
--- scst/src/dev_handlers/scst_user.c	(revision 641)
+++ scst/src/dev_handlers/scst_user.c	(working copy)
@@ -57,8 +57,6 @@
 #define DEV_USER_CMD_HASH_ORDER		6
 #define DEV_USER_ATTACH_TIMEOUT		(5*HZ)
 
-#define DEV_USER_HEADER_LEN	offsetof(struct scst_user_get_cmd, preply)
-
 struct scst_user_dev {
 	struct rw_semaphore dev_rwsem;
 
@@ -412,7 +410,9 @@ static void dev_user_on_cached_mem_free(
 	TRACE_MEM("Preparing ON_CACHED_MEM_FREE (ucmd %p, h %d, ubuff %lx)",
 		ucmd, ucmd->h, ucmd->ubuff);
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.on_cached_mem_free);
+	ucmd->user_cmd_payload_len =
+		offsetof(struct scst_user_get_cmd, on_cached_mem_free) +
+		sizeof(ucmd->user_cmd.on_cached_mem_free);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_ON_CACHED_MEM_FREE;
 	ucmd->user_cmd.on_cached_mem_free.pbuf = ucmd->ubuff;
@@ -630,7 +630,9 @@ static int dev_user_alloc_space(struct s
 		goto out;
 	}
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.alloc_cmd);
+	ucmd->user_cmd_payload_len =
+		offsetof(struct scst_user_get_cmd, alloc_cmd) +
+		sizeof(ucmd->user_cmd.alloc_cmd);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_ALLOC_MEM;
 	ucmd->user_cmd.alloc_cmd.sess_h = (unsigned long)cmd->tgt_dev;
@@ -751,7 +753,9 @@ static int dev_user_parse(struct scst_cm
 	case SCST_USER_PARSE_CALL:
 		TRACE_DBG("Preparing PARSE for user space (ucmd=%p, h=%d, "
 			"bufflen %d)", ucmd, ucmd->h, cmd->bufflen);
-		ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.parse_cmd);
+		ucmd->user_cmd_payload_len =
+			offsetof(struct scst_user_get_cmd, parse_cmd) +
+			sizeof(ucmd->user_cmd.parse_cmd);
 		ucmd->user_cmd.cmd_h = ucmd->h;
 		ucmd->user_cmd.subcode = SCST_USER_PARSE;
 		ucmd->user_cmd.parse_cmd.sess_h = (unsigned long)cmd->tgt_dev;
@@ -863,7 +867,9 @@ static int dev_user_exec(struct scst_cmd
 	if (cmd->data_direction == SCST_DATA_WRITE)
 		dev_user_flush_dcache(ucmd);
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.exec_cmd);
+	ucmd->user_cmd_payload_len =
+		offsetof(struct scst_user_get_cmd, exec_cmd) +
+		sizeof(ucmd->user_cmd.exec_cmd);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_EXEC;
 	ucmd->user_cmd.exec_cmd.sess_h = (unsigned long)cmd->tgt_dev;
@@ -932,7 +938,9 @@ static void dev_user_on_free_cmd(struct 
 		goto out_reply;
 	}
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.on_free_cmd);
+	ucmd->user_cmd_payload_len =
+		offsetof(struct scst_user_get_cmd, on_free_cmd) +
+		sizeof(ucmd->user_cmd.on_free_cmd);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_ON_FREE_CMD;
 	ucmd->user_cmd.on_free_cmd.pbuf = ucmd->ubuff;
@@ -1730,12 +1739,15 @@ static int dev_user_reply_get_cmd(struct
 
 		EXTRACHECKS_BUG_ON(ucmd->user_cmd_payload_len == 0);
 
-		len = DEV_USER_HEADER_LEN + ucmd->user_cmd_payload_len;
+		len = ucmd->user_cmd_payload_len;
 		TRACE_DBG("ucmd %p (user_cmd %p), payload_len %d (len %d)",
 			ucmd, &ucmd->user_cmd, ucmd->user_cmd_payload_len, len);
 		TRACE_BUFFER("UCMD", &ucmd->user_cmd, len);
@@ -2168,7 +2180,9 @@ static int dev_user_task_mgmt_fn(struct 
 	/* We can't afford missing TM command due to memory shortage */
 	ucmd = dev_user_alloc_ucmd(dev, GFP_KERNEL|__GFP_NOFAIL);
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.tm_cmd);
+	ucmd->user_cmd_payload_len =
+		offsetof(struct scst_user_get_cmd, tm_cmd) +
+		sizeof(ucmd->user_cmd.tm_cmd);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_TASK_MGMT;
 	ucmd->user_cmd.tm_cmd.sess_h = (unsigned long)tgt_dev;
@@ -2303,7 +2317,8 @@ static int dev_user_attach_tgt(struct sc
 
 	ucmd->cmpl = &cmpl;
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.sess);
+	ucmd->user_cmd_payload_len = offsetof(struct scst_user_get_cmd, sess) +
+		sizeof(ucmd->user_cmd.sess);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_ATTACH_SESS;
 	ucmd->user_cmd.sess.sess_h = (unsigned long)tgt_dev;
@@ -2380,7 +2395,8 @@ static void dev_user_detach_tgt(struct s
 	TRACE_MGMT_DBG("Preparing DETACH_SESS %p (h %d, sess_h %llx)", ucmd,
 		ucmd->h, ucmd->user_cmd.sess.sess_h);
 
-	ucmd->user_cmd_payload_len = sizeof(ucmd->user_cmd.sess);
+	ucmd->user_cmd_payload_len = offsetof(struct scst_user_get_cmd, sess) +
+		sizeof(ucmd->user_cmd.sess);
 	ucmd->user_cmd.cmd_h = ucmd->h;
 	ucmd->user_cmd.subcode = SCST_USER_DETACH_SESS;
 	ucmd->user_cmd.sess.sess_h = (unsigned long)tgt_dev;

