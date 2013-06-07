From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 9/9] vhost/scsi: Convert to se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage
Date: Fri,  7 Jun 2013 21:34:24 +0000
Message-ID: <1370640864-15568-10-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48646 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3FGVsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:48:00 -0400
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch coverts vhost/scsi to se_cmd->cmd_kref TARGET_SCF_ACK_KREF
usage, instead of assuming that vhost_scsi_free_cmd() is always called
before TCM processing is completed in the response fast path.

This includes adding vhost_scsi_check_stop_free() -> target_put_sess_cmd()
to perform the second se_cmd->cmd_kref put, and moving vhost_scsi_free_cmd()
resource release into tcm_vhost_release_cmd() that is invoked once the last
se_cmd->cmd_kref put occurs.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Asias He <asias@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index aacf71e..1e5e820 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -446,7 +446,19 @@ static u32 tcm_vhost_tpg_get_inst_index(struct se_portal_group *se_tpg)
 
 static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 {
-	return;
+	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
+				struct tcm_vhost_cmd, tvc_se_cmd);
+
+	if (tv_cmd->tvc_sgl_count) {
+		u32 i;
+		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
+			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+
+		kfree(tv_cmd->tvc_sgl);
+        }
+
+	tcm_vhost_put_inflight(tv_cmd->inflight);
+	kfree(tv_cmd);
 }
 
 static int tcm_vhost_shutdown_session(struct se_session *se_sess)
@@ -559,17 +571,11 @@ static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *tv_cmd)
 	/* TODO locking against target/backend threads? */
 	transport_generic_free_cmd(se_cmd, 0);
 
-	if (tv_cmd->tvc_sgl_count) {
-		u32 i;
-		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
-
-		kfree(tv_cmd->tvc_sgl);
-	}
-
-	tcm_vhost_put_inflight(tv_cmd->inflight);
+}
 
-	kfree(tv_cmd);
+static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
+{
+	return target_put_sess_cmd(se_cmd->se_sess, se_cmd);
 }
 
 static void tcm_vhost_do_evt_work(struct vhost_scsi *vs,
@@ -847,7 +853,7 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 			tv_cmd->tvc_cdb, &tv_cmd->tvc_sense_buf[0],
 			tv_cmd->tvc_lun, tv_cmd->tvc_exp_data_len,
 			tv_cmd->tvc_task_attr, tv_cmd->tvc_data_direction,
-			0, sg_ptr, tv_cmd->tvc_sgl_count,
+			TARGET_SCF_ACK_KREF, sg_ptr, tv_cmd->tvc_sgl_count,
 			sg_bidi_ptr, sg_no_bidi);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
@@ -2008,6 +2014,7 @@ static struct target_core_fabric_ops tcm_vhost_ops = {
 	.tpg_release_fabric_acl		= tcm_vhost_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_vhost_tpg_get_inst_index,
 	.release_cmd			= tcm_vhost_release_cmd,
+	.check_stop_free		= vhost_scsi_check_stop_free,
 	.shutdown_session		= tcm_vhost_shutdown_session,
 	.close_session			= tcm_vhost_close_session,
 	.sess_get_index			= tcm_vhost_sess_get_index,
-- 
1.7.2.5

