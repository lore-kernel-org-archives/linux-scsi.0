From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 03/11] vhost/scsi: Fix incorrect early vhost_scsi_handle_vq failures
Date: Mon,  2 Feb 2015 04:06:26 +0000
Message-ID: <1422849994-3419-4-git-send-email-nab@daterainc.com>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes vhost_scsi_handle_vq() failure cases that result in BUG_ON()
getting triggered when vhost_scsi_free_cmd() is called, and ->tvc_se_cmd has
not been initialized by target_submit_cmd_map_sgls().

It changes tcm_vhost_release_cmd() to use tcm_vhost_cmd->tvc_nexus for obtaining
se_session pointer reference.  Also, avoid calling put_page() on NULL sg->page
entries in vhost_scsi_map_to_sgl() failure path.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 52 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index a03ac41..9c5ac23 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -460,7 +460,7 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
 				struct tcm_vhost_cmd, tvc_se_cmd);
-	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_session *se_sess = tv_cmd->tvc_nexus->tvn_se_sess;
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
@@ -859,9 +859,11 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 		ret = vhost_scsi_map_to_sgl(cmd, sg, sgl_count, &iov[i],
 					    cmd->tvc_upages, write);
 		if (ret < 0) {
-			for (i = 0; i < cmd->tvc_sgl_count; i++)
-				put_page(sg_page(&cmd->tvc_sgl[i]));
-
+			for (i = 0; i < cmd->tvc_sgl_count; i++) {
+				struct page *page = sg_page(&cmd->tvc_sgl[i]);
+				if (page)
+					put_page(page);
+			}
 			cmd->tvc_sgl_count = 0;
 			return ret;
 		}
@@ -900,9 +902,11 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
 		ret = vhost_scsi_map_to_sgl(cmd, prot_sg, prot_sgl_count, &iov[i],
 					    cmd->tvc_upages, write);
 		if (ret < 0) {
-			for (i = 0; i < cmd->tvc_prot_sgl_count; i++)
-				put_page(sg_page(&cmd->tvc_prot_sgl[i]));
-
+			for (i = 0; i < cmd->tvc_prot_sgl_count; i++) {
+				struct page *page = sg_page(&cmd->tvc_prot_sgl[i]);
+				if (page)
+					put_page(page);
+			}
 			cmd->tvc_prot_sgl_count = 0;
 			return ret;
 		}
@@ -1060,12 +1064,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (unlikely(vq->iov[0].iov_len < req_size)) {
 			pr_err("Expecting virtio-scsi header: %zu, got %zu\n",
 			       req_size, vq->iov[0].iov_len);
-			break;
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
 		}
 		ret = memcpy_fromiovecend(req, &vq->iov[0], 0, req_size);
 		if (unlikely(ret)) {
 			vq_err(vq, "Faulted on virtio_scsi_cmd_req\n");
-			break;
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
 		}
 
 		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
@@ -1096,14 +1102,16 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 				if (data_direction != DMA_TO_DEVICE) {
 					vq_err(vq, "Received non zero do_pi_niov"
 						", but wrong data_direction\n");
-					goto err_cmd;
+					vhost_scsi_send_bad_target(vs, vq, head, out);
+					continue;
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesout);
 			} else if (v_req_pi.pi_bytesin) {
 				if (data_direction != DMA_FROM_DEVICE) {
 					vq_err(vq, "Received non zero di_pi_niov"
 						", but wrong data_direction\n");
-					goto err_cmd;
+					vhost_scsi_send_bad_target(vs, vq, head, out);
+					continue;
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesin);
 			}
@@ -1143,7 +1151,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			vq_err(vq, "Received SCSI CDB with command_size: %d that"
 				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 				scsi_command_size(cdb), TCM_VHOST_MAX_CDB_SIZE);
-			goto err_cmd;
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
 		}
 
 		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
@@ -1152,7 +1161,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (IS_ERR(cmd)) {
 			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
 					PTR_ERR(cmd));
-			goto err_cmd;
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
 		}
 
 		pr_debug("Allocated tv_cmd: %p exp_data_len: %d, data_direction"
@@ -1172,7 +1182,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to"
 					" prot_sgl\n");
-				goto err_free;
+				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
+				vhost_scsi_send_bad_target(vs, vq, head, out);
+				continue;
 			}
 		}
 		if (data_direction != DMA_NONE) {
@@ -1181,7 +1193,9 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 					data_direction == DMA_FROM_DEVICE);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
-				goto err_free;
+				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
+				vhost_scsi_send_bad_target(vs, vq, head, out);
+				continue;
 			}
 		}
 		/*
@@ -1199,14 +1213,6 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		INIT_WORK(&cmd->work, tcm_vhost_submission_work);
 		queue_work(tcm_vhost_workqueue, &cmd->work);
 	}
-
-	mutex_unlock(&vq->mutex);
-	return;
-
-err_free:
-	vhost_scsi_free_cmd(cmd);
-err_cmd:
-	vhost_scsi_send_bad_target(vs, vq, head, out);
 out:
 	mutex_unlock(&vq->mutex);
 }
-- 
1.9.1
