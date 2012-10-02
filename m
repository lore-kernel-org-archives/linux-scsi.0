From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] target: Add target_submit_cmd_map_mem for SGL fabric memory passthrough
Date: Tue,  2 Oct 2012 07:15:44 +0000
Message-ID: <1349162147-29098-2-git-send-email-nab@linux-iscsi.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57837 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2JBHVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 03:21:03 -0400
In-Reply-To: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new TARGET_SCF_MAP_MEM flag within __target_submit_cmd()
+ a target_submit_cmd_map_mem() wrapper to pass pre-allocated SGL memory
using existing transport_generic_map_mem_to_cmd() logic into the generic
target submit I/O codepath.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |  108 +++++++++++++++++++++++++-------
 include/target/target_core_base.h      |    1 +
 include/target/target_core_fabric.h    |    3 +
 3 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 221f67f..ad2097e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1455,29 +1455,11 @@ int transport_handle_cdb_direct(
 }
 EXPORT_SYMBOL(transport_handle_cdb_direct);
 
-/**
- * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
- *
- * @se_cmd: command descriptor to submit
- * @se_sess: associated se_sess for endpoint
- * @cdb: pointer to SCSI CDB
- * @sense: pointer to SCSI sense buffer
- * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @data_length: fabric expected data transfer length
- * @task_addr: SAM task attribute
- * @data_dir: DMA data direction
- * @flags: flags for command submission from target_sc_flags_tables
- *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
- *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
- **/
-int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+static int __target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags)
+		u32 data_length, int task_attr, int data_dir, int flags,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count)
 {
 	struct se_portal_group *se_tpg;
 	int rc;
@@ -1524,7 +1506,19 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		transport_generic_request_failure(se_cmd);
 		return 0;
 	}
-
+	/*
+	 * When TARGET_SCF_MAP_MEM has been set perform a SGL passthrough
+	 * mapping for pre-allocated fabric memory, instead of having target
+	 * core perform an internal SGL allocation.
+	 */
+	if (flags & TARGET_SCF_MAP_MEM) {
+		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
+				sgl_bidi, sgl_bidi_count);
+		if (rc != 0) {
+			transport_generic_request_failure(se_cmd);
+			return 0;
+		}
+	}
 	/*
 	 * Check if we need to delay processing because of ALUA
 	 * Active/NonOptimized primary access state..
@@ -1534,8 +1528,76 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	transport_handle_cdb_direct(se_cmd);
 	return 0;
 }
+
+/*
+ * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
+ *
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @cdb: pointer to SCSI CDB
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_addr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from process context, and also currently
+ * assumes internal allocation of fabric payload buffer by target-core.
+ */
+int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
+		u32 data_length, int task_attr, int data_dir, int flags)
+{
+	return __target_submit_cmd(se_cmd, se_sess, cdb, sense, unpacked_lun,
+			data_length, task_attr, data_dir, flags,
+			NULL, 0, NULL, 0);
+}
 EXPORT_SYMBOL(target_submit_cmd);
 
+/*
+ * target_submit_cmd_map_mem - lookup unpacked lun and submit uninitialized
+ * 			       se_cmd using pre-allocated memory.
+ *
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @cdb: pointer to SCSI CDB
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_addr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from process context, and also currently
+ * assumes internal allocation of fabric payload buffer by target-core.
+ */
+int target_submit_cmd_map_mem(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
+		u32 data_length, int task_attr, int data_dir, int flags,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count)
+{
+	int lflags = TARGET_SCF_MAP_MEM | flags;
+
+	return __target_submit_cmd(se_cmd, se_sess, cdb, sense, unpacked_lun,
+			data_length, task_attr, data_dir, lflags,
+			sgl, sgl_count, sgl_bidi, sgl_bidi_count);
+}
+EXPORT_SYMBOL(target_submit_cmd_map_mem);
+
 static void target_complete_tmr_failure(struct work_struct *work)
 {
 	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5be8937..6309298 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -220,6 +220,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_BIDI_OP		= 0x01,
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
+	TARGET_SCF_MAP_MEM		= 0x08,
 };
 
 /* fabric independent task management function values */
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 85a5d7a..f315c80 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -102,6 +102,9 @@ int	transport_lookup_cmd_lun(struct se_cmd *, u32);
 int	target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u32, u32, int, int, int);
+int	target_submit_cmd_map_mem(struct se_cmd *, struct se_session *,
+		unsigned char *, unsigned char *, u32, u32, int, int, int,
+		struct scatterlist *, u32, struct scatterlist *, u32);
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u32 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
-- 
1.7.2.5

