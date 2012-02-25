From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/7] target: Fix target_submit_tmr se_tmr_req allocation failures
Date: Sat, 25 Feb 2012 21:05:55 +0000
Message-ID: <1330203959-6170-4-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45536 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2BYVOP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:15 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch makes target_submit_tmr() se_tmr_req allocation occur before
target_get_sess_cmd(), and changes target_submit_tmr() to return a failure
w/ non zero status to the fabric caller upon core_tmr_alloc_req() failure.

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   19 ++++++++++---------
 include/target/target_core_fabric.h    |    2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a526907..ce88cd2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1715,7 +1715,7 @@ EXPORT_SYMBOL(target_submit_cmd);
  * Callable from process context
  **/
 
-void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
+int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u32 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type, int flags)
 {
@@ -1728,25 +1728,26 @@ void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 			      0, DMA_NONE, MSG_SIMPLE_TAG, sense);
+	/*
+	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
+	 * allocation failure.
+	 */
+	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, GFP_KERNEL);
+	if (ret < 0)
+		return -ENOMEM;
 
 	/* See target_submit_cmd for commentary */
 	target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
 
-	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, GFP_KERNEL);
-	if (ret < 0) {
-		dump_stack();
-		/* FIXME XXX */
-		return;
-	}
-
 	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
 	if (ret) {
 		se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 		se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 		transport_generic_free_cmd(se_cmd, 0);
-		return;
+		return 0;
 	}
 	transport_generic_handle_tmr(se_cmd);
+	return 0;
 }
 EXPORT_SYMBOL(target_submit_tmr);
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index aefa435..a29092e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -121,7 +121,7 @@ int	transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 int	transport_handle_cdb_direct(struct se_cmd *);
 void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u32, u32, int, int, int);
-void	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
+int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u32 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type, int flags);
 int	transport_generic_handle_cdb_map(struct se_cmd *);
-- 
1.7.2.5

