From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 10/14] target: Add protection SGLs to target_submit_cmd_map_sgls
Date: Wed,  8 Jan 2014 20:15:53 +0000
Message-ID: <1389212157-14540-11-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support to target_submit_cmd_map_sgls() for
accepting 'sgl_prot' + 'sgl_prot_count' parameters for
DIF protection information.

Note the passed parameters are stored at se_cmd->t_prot_sg
and se_cmd->t_prot_nents respectively.

Also, update tcm_loop and vhost-scsi fabrics usage of
target_submit_cmd_map_sgls() to take into account the
new parameters.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |    2 +-
 drivers/target/target_core_transport.c |   16 ++++++++++++++--
 drivers/vhost/scsi.c                   |    2 +-
 include/target/target_core_fabric.h    |    3 ++-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 1b41e67..c6f1427 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -217,7 +217,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
-			sgl_bidi, sgl_bidi_count);
+			sgl_bidi, sgl_bidi_count, NULL, 0);
 	if (rc < 0) {
 		set_host_byte(sc, DID_NO_CONNECT);
 		goto out_done;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 707ee17..65b42b4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1284,6 +1284,8 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
  * @sgl_count: scatterlist count for unidirectional mapping
  * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
  * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
  *
  * Returns non zero to signal active I/O shutdown failure.  All other
  * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
@@ -1296,7 +1298,8 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
 		u32 data_length, int task_attr, int data_dir, int flags,
 		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count)
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count)
 {
 	struct se_portal_group *se_tpg;
 	sense_reason_t rc;
@@ -1338,6 +1341,14 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		target_put_sess_cmd(se_sess, se_cmd);
 		return 0;
 	}
+	/*
+	 * Save pointers for SGLs containing protection information,
+	 * if present.
+	 */
+	if (sgl_prot_count) {
+		se_cmd->t_prot_sg = sgl_prot;
+		se_cmd->t_prot_nents = sgl_prot_count;
+	}
 
 	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
 	if (rc != 0) {
@@ -1380,6 +1391,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 			return 0;
 		}
 	}
+
 	/*
 	 * Check if we need to delay processing because of ALUA
 	 * Active/NonOptimized primary access state..
@@ -1419,7 +1431,7 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 {
 	return target_submit_cmd_map_sgls(se_cmd, se_sess, cdb, sense,
 			unpacked_lun, data_length, task_attr, data_dir,
-			flags, NULL, 0, NULL, 0);
+			flags, NULL, 0, NULL, 0, NULL, 0);
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f175629..84488a8 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -889,7 +889,7 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
 			cmd->tvc_task_attr, cmd->tvc_data_direction,
 			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			sg_bidi_ptr, sg_no_bidi);
+			sg_bidi_ptr, sg_no_bidi, NULL, 0);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 4cf4fda..0218d68 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -105,7 +105,8 @@ sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u32);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u32, u32, int, int, int,
-		struct scatterlist *, u32, struct scatterlist *, u32);
+		struct scatterlist *, u32, struct scatterlist *, u32,
+		struct scatterlist *, u32);
 int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u32, u32, int, int, int);
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
-- 
1.7.10.4
