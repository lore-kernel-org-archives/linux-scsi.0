From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 11/13] target: Add target_submit_tmr helper function
Date: Thu, 19 Jan 2012 13:39:21 -0800
Message-ID: <1327009163-10177-12-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab2ASVjd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:33 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

Similar to target_submit_cmd, this function lets fabrics call one function
(albeit with a lot of parameters) instead of 3 or more.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |   42 ++++++++++++++++++++++++++++++++
 include/target/target_core_fabric.h    |    3 ++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 314567a..15faca4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1691,6 +1691,48 @@ out_check_cond:
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+/**
+ * target_submit_tmr - lookup unpacked lun and submit uninitialized se_cmd
+ *                     for TMR CDBs
+ *
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @fabric_context: fabric context for TMR req
+ * @tm_type: Type of TM request
+ *
+ * Callable from all contexts.
+ **/
+
+void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *sense, u32 unpacked_lun,
+		void *fabric_tmr_ptr, unsigned char tm_type, int flags)
+{
+	struct se_portal_group *se_tpg;	
+	int ret;
+
+	se_tpg = se_sess->se_tpg;
+	BUG_ON(!se_tpg);
+
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			      0, DMA_NONE, MSG_SIMPLE_TAG, sense);
+
+	/* See target_submit_cmd for commentary */
+	target_get_sess_cmd(se_sess, se_cmd, (flags & TARGET_SCF_ACK_KREF));
+
+	core_tmr_req_init(se_cmd, fabric_tmr_ptr, tm_type);
+
+	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
+	if (ret) {
+		transport_send_check_condition_and_sense(se_cmd,
+			se_cmd->scsi_sense_reason, 0);
+		transport_generic_free_cmd(se_cmd, 0);
+	}
+	transport_generic_handle_tmr(se_cmd);
+}
+EXPORT_SYMBOL(target_submit_tmr);
+
 /*
  * Used by fabric module frontends defining a TFO->new_cmd_map() caller
  * to  queue up a newly setup se_cmd w/ TRANSPORT_NEW_CMD_MAP in order to
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 9684f32..7d0e2e0 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -121,6 +121,9 @@ int	transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 int	transport_handle_cdb_direct(struct se_cmd *);
 int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u32, u32, int, int, int);
+void	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *sense, u32 unpacked_lun,
+		void *fabric_tmr_ptr, unsigned char tm_type, int flags);
 int	transport_generic_handle_cdb_map(struct se_cmd *);
 int	transport_generic_handle_data(struct se_cmd *);
 int	transport_generic_map_mem_to_cmd(struct se_cmd *cmd,
-- 
1.7.1

