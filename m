From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 4/4] tcm_vhost: Convert I/O path to use target_submit_cmd_map_sgls
Date: Tue,  2 Oct 2012 21:16:58 +0000
Message-ID: <1349212618-348-5-git-send-email-nab@linux-iscsi.org>
References: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38200 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2JBVWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 17:22:23 -0400
In-Reply-To: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts tcm_vhost to use target_submit_cmd_map_sgls() for
I/O submission and mapping of pre-allocated SGL memory from incoming
virtio-scsi SGL memory -> se_cmd descriptors.

This includes removing the original open-coded fabric uses of target
core callers to support transport_generic_map_mem_to_cmd() between
target_setup_cmd_from_cdb() and transport_handle_cdb_direct() logic.

It also includes adding a handful of new tcm_vhost_cmnd member +
assignments in vhost_scsi_allocate_cmd() used from cmwq process
context I/O submission within tcm_vhost_submission_work()

(v2: Use renamed target_submit_cmd_map_sgls)

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/tcm_vhost.c |   68 +++++++++-----------------------------------
 drivers/vhost/tcm_vhost.h |    8 +++++
 2 files changed, 22 insertions(+), 54 deletions(-)

diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index 89dc99b..aa31692 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -415,10 +415,7 @@ static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
 {
 	struct tcm_vhost_cmd *tv_cmd;
 	struct tcm_vhost_nexus *tv_nexus;
-	struct se_portal_group *se_tpg = &tv_tpg->se_tpg;
 	struct se_session *se_sess;
-	struct se_cmd *se_cmd;
-	int sam_task_attr;
 
 	tv_nexus = tv_tpg->tpg_nexus;
 	if (!tv_nexus) {
@@ -434,23 +431,11 @@ static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
 	}
 	INIT_LIST_HEAD(&tv_cmd->tvc_completion_list);
 	tv_cmd->tvc_tag = v_req->tag;
+	tv_cmd->tvc_task_attr = v_req->task_attr;
+	tv_cmd->tvc_exp_data_len = exp_data_len;
+	tv_cmd->tvc_data_direction = data_direction;
+	tv_cmd->tvc_nexus = tv_nexus;
 
-	se_cmd = &tv_cmd->tvc_se_cmd;
-	/*
-	 * Locate the SAM Task Attr from virtio_scsi_cmd_req
-	 */
-	sam_task_attr = v_req->task_attr;
-	/*
-	 * Initialize struct se_cmd descriptor from TCM infrastructure
-	 */
-	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, exp_data_len,
-				data_direction, sam_task_attr,
-				&tv_cmd->tvc_sense_buf[0]);
-
-#if 0	/* FIXME: vhost_scsi_allocate_cmd() BIDI operation */
-	if (bidi)
-		se_cmd->se_cmd_flags |= SCF_BIDI;
-#endif
 	return tv_cmd;
 }
 
@@ -549,37 +534,10 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 {
 	struct tcm_vhost_cmd *tv_cmd =
 		container_of(work, struct tcm_vhost_cmd, work);
+	struct tcm_vhost_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &tv_cmd->tvc_se_cmd;
 	struct scatterlist *sg_ptr, *sg_bidi_ptr = NULL;
 	int rc, sg_no_bidi = 0;
-	/*
-	 * Locate the struct se_lun pointer based on v_req->lun, and
-	 * attach it to struct se_cmd
-	 */
-	rc = transport_lookup_cmd_lun(&tv_cmd->tvc_se_cmd, tv_cmd->tvc_lun);
-	if (rc < 0) {
-		pr_err("Failed to look up lun: %d\n", tv_cmd->tvc_lun);
-		transport_send_check_condition_and_sense(&tv_cmd->tvc_se_cmd,
-			tv_cmd->tvc_se_cmd.scsi_sense_reason, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-		return;
-	}
-
-	rc = target_setup_cmd_from_cdb(se_cmd, tv_cmd->tvc_cdb);
-	if (rc == -ENOMEM) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-		return;
-	} else if (rc < 0) {
-		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
-			tcm_vhost_queue_status(se_cmd);
-		else
-			transport_send_check_condition_and_sense(se_cmd,
-					se_cmd->scsi_sense_reason, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-		return;
-	}
 
 	if (tv_cmd->tvc_sgl_count) {
 		sg_ptr = tv_cmd->tvc_sgl;
@@ -597,17 +555,19 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 	} else {
 		sg_ptr = NULL;
 	}
-
-	rc = transport_generic_map_mem_to_cmd(se_cmd, sg_ptr,
-				tv_cmd->tvc_sgl_count, sg_bidi_ptr,
-				sg_no_bidi);
+	tv_nexus = tv_cmd->tvc_nexus;
+
+	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
+			tv_cmd->tvc_cdb, &tv_cmd->tvc_sense_buf[0],
+			tv_cmd->tvc_lun, tv_cmd->tvc_exp_data_len,
+			tv_cmd->tvc_task_attr, tv_cmd->tvc_data_direction,
+			0, sg_ptr, tv_cmd->tvc_sgl_count,
+			sg_bidi_ptr, sg_no_bidi);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
-				se_cmd->scsi_sense_reason, 0);
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 		transport_generic_free_cmd(se_cmd, 0);
-		return;
 	}
-	transport_handle_cdb_direct(se_cmd);
 }
 
 static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
index d9e9355..7e87c63 100644
--- a/drivers/vhost/tcm_vhost.h
+++ b/drivers/vhost/tcm_vhost.h
@@ -5,6 +5,12 @@
 struct tcm_vhost_cmd {
 	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
 	int tvc_vq_desc;
+	/* virtio-scsi initiator task attribute */
+	int tvc_task_attr;
+	/* virtio-scsi initiator data direction */
+	enum dma_data_direction tvc_data_direction;
+	/* Expected data transfer length from virtio-scsi header */
+	u32 tvc_exp_data_len;
 	/* The Tag from include/linux/virtio_scsi.h:struct virtio_scsi_cmd_req */
 	u64 tvc_tag;
 	/* The number of scatterlists associated with this cmd */
@@ -17,6 +23,8 @@ struct tcm_vhost_cmd {
 	struct virtio_scsi_cmd_resp __user *tvc_resp;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
+	/* Pointer to vhost nexus memory */
+	struct tcm_vhost_nexus *tvc_nexus;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
 	/* work item used for cmwq dispatch to tcm_vhost_submission_work() */
-- 
1.7.2.5

