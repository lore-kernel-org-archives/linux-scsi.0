From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 13/13] target: Change target_submit_cmd() to return void
Date: Thu, 19 Jan 2012 13:39:23 -0800
Message-ID: <1327009163-10177-14-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab2ASVje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:34 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

Retval not very useful, and may even be harmful. Once submitted, fabrics
should expect a sense error if anything goes wrong. All fabrics checking
of this retval are useless or broken:

fc checks it just to emit more debug output.
ib_srpt trickles retval up, then it is ignored.
qla2xxx trickles it up, which then causes a bug because the abort goto
in qla_target.c thinks cmd hasn't been sent to target.

Just returning nothing is best.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c  |    5 +----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    7 ++-----
 drivers/target/target_core_transport.c |    5 ++---
 drivers/target/tcm_fc/tfc_cmd.c        |    9 ++-------
 include/target/target_core_fabric.h    |    2 +-
 5 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 5ec4f9d..57dbedc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1692,12 +1692,9 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
 	}
 	unpacked_lun = srpt_unpack_lun((uint8_t *)&srp_cmd->lun,
 				       sizeof(srp_cmd->lun));
-	ret = target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
+	target_submit_cmd(cmd, ch->sess, srp_cmd->cdb,
 			&send_ioctx->sense_data[0], unpacked_lun, data_len,
 			MSG_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
-	if (ret != 0)
-		return -1;
-
 	return 0;
 
 send_sense:
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7132c1c..83e5df4 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -597,7 +597,7 @@ int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct se_session *se_sess;
 	struct qla_tgt_sess *sess;
-	int rc, flags = TARGET_SCF_ACK_KREF;
+	int flags = TARGET_SCF_ACK_KREF;
 
 	if (bidi)
 		flags |= TARGET_SCF_BIDI_OP;
@@ -614,12 +614,9 @@ int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		return -EINVAL;
 	}
 
-	rc = target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
+	target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
 				cmd->unpacked_lun, data_length, fcp_task_attr,
 				data_dir, flags);
-	if (rc != 0)
-		return -EINVAL;
-
 	return 0;
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 15faca4..cfc4e02 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1633,7 +1633,7 @@ EXPORT_SYMBOL(transport_handle_cdb_direct);
  * This may only be called from process context, and also currently
  * assumes internal allocation of fabric payload buffer by target-core.
  **/
-int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
 		u32 data_length, int task_attr, int data_dir, int flags)
 {
@@ -1682,12 +1682,11 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * when fabric has filled the incoming buffer.
 	 */
 	transport_handle_cdb_direct(se_cmd);
-	return 0;
+	return;
 
 out_check_cond:
 	transport_send_check_condition_and_sense(se_cmd,
 				se_cmd->scsi_sense_reason, 0);
-	return 0;
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 08a10e1..938240b 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -491,7 +491,6 @@ static void ft_send_work(struct work_struct *work)
 	struct fcp_cmnd *fcp;
 	int data_dir = 0;
 	int task_attr;
-	int ret;
 
 	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
 	if (!fcp)
@@ -544,14 +543,10 @@ static void ft_send_work(struct work_struct *work)
  	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
  	 * directly from ft_check_stop_free callback in response path.
  	 */
-	ret = target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
+	target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
 				&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
 				ntohl(fcp->fc_dl), task_attr, data_dir, 0);
-	pr_debug("r_ctl %x alloc target_submit_cmd %d\n", fh->fh_r_ctl, ret);
-	if (ret < 0) {
-		ft_dump_cmd(cmd, __func__);
-		return;
-	}
+	pr_debug("r_ctl %x alloc target_submit_cmd\n", fh->fh_r_ctl);
 	return;
 
 err:
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 7d0e2e0..cfd908f 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -119,7 +119,7 @@ void	transport_init_se_cmd(struct se_cmd *, struct target_core_fabric_ops *,
 int	transport_lookup_cmd_lun(struct se_cmd *, u32);
 int	transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 int	transport_handle_cdb_direct(struct se_cmd *);
-int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
+void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u32, u32, int, int, int);
 void	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u32 unpacked_lun,
-- 
1.7.1

