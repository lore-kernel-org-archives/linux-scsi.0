From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 4/6] vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
Date: Mon, 24 Feb 2014 05:32:28 +0000
Message-ID: <1393219950-18613-5-git-send-email-nab@daterainc.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates vhost_scsi_handle_vq() to calculate a data_niov +
prot_niov currently based upon virtio_scsi_cmd_req->prio for figuring
out many of seperate data + protection SGLs to expect from data_num.

Also update tcm_vhost_submission_work() to pass the pre-allocated
cmd->tvc_prot_sgl[] memory into target_submit_cmd_map_sgls().

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0cf5948..3bdb625 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -908,18 +908,15 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 		container_of(work, struct tcm_vhost_cmd, work);
 	struct tcm_vhost_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
-	struct scatterlist *sg_ptr, *sg_bidi_ptr = NULL;
-	int rc, sg_no_bidi = 0;
+	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
+	int rc;
 
+	/* FIXME: BIDI operation */
 	if (cmd->tvc_sgl_count) {
 		sg_ptr = cmd->tvc_sgl;
-/* FIXME: Fix BIDI operation in tcm_vhost_submission_work() */
-#if 0
-		if (se_cmd->se_cmd_flags & SCF_BIDI) {
-			sg_bidi_ptr = NULL;
-			sg_no_bidi = 0;
-		}
-#endif
+
+		if (cmd->tvc_prot_sgl_count)
+			sg_prot_ptr = cmd->tvc_prot_sgl;
 	} else {
 		sg_ptr = NULL;
 	}
@@ -930,7 +927,7 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
 			cmd->tvc_task_attr, cmd->tvc_data_direction,
 			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			sg_bidi_ptr, sg_no_bidi, NULL, 0);
+			NULL, 0, sg_prot_ptr, cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
@@ -966,7 +963,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct tcm_vhost_cmd *cmd;
 	u32 exp_data_len, data_first, data_num, data_direction;
 	unsigned out, in, i;
-	int head, ret;
+	int head, ret, data_niov, prot_niov;
 	u8 target;
 
 	mutex_lock(&vq->mutex);
@@ -998,7 +995,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			break;
 		}
 
-/* FIXME: BIDI operation */
+		/* FIXME: BIDI operation */
 		if (out == 1 && in == 1) {
 			data_direction = DMA_NONE;
 			data_first = 0;
@@ -1052,8 +1049,17 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			continue;
 		}
 
+		data_niov = data_num;
+		prot_niov = 0;
+
+		if (data_num && v_req.prio != 0) {
+			/* FIXME: Figure out a better way.. */
+			data_niov = data_num - v_req.prio;
+			prot_niov = v_req.prio;
+		}
+
 		exp_data_len = 0;
-		for (i = 0; i < data_num; i++)
+		for (i = 0; i < data_niov; i++)
 			exp_data_len += vq->iov[data_first + i].iov_len;
 
 		cmd = vhost_scsi_get_tag(vq, tpg, &v_req,
@@ -1096,14 +1102,23 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 		if (data_direction != DMA_NONE) {
 			ret = vhost_scsi_map_iov_to_sgl(cmd,
-					&vq->iov[data_first], data_num,
+					&vq->iov[data_first], data_niov,
 					data_direction == DMA_FROM_DEVICE);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				goto err_free;
 			}
 		}
-
+		if (prot_niov) {
+			ret = vhost_scsi_map_iov_to_prot(cmd,
+					&vq->iov[data_first + data_niov], prot_niov,
+					data_direction == DMA_FROM_DEVICE);
+			if (unlikely(ret)) {
+				vq_err(vq, "Failed to map iov to"
+					   " prot_sgl\n");
+				goto err_free;
+			}
+		}
 		/*
 		 * Save the descriptor from vhost_get_vq_desc() to be used to
 		 * complete the virtio-scsi request in TCM callback context via
-- 
1.7.10.4
