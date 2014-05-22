From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 5/6] vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
Date: Thu, 22 May 2014 02:26:21 +0000
Message-ID: <1400725582-5521-6-git-send-email-nab@daterainc.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58938 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaEVCvI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 22:51:08 -0400
Received: by mail-oa0-f46.google.com with SMTP id i4so3281317oah.5
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 19:51:07 -0700 (PDT)
In-Reply-To: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates vhost_scsi_handle_vq() to check for the existance
of virtio_scsi_cmd_req_pi comparing vq->iov[0].iov_len in order to
calculate seperate data + protection SGLs from data_num.

Also update tcm_vhost_submission_work() to pass the pre-allocated
cmd->tvc_prot_sgl[] memory into target_submit_cmd_map_sgls(), and
update vhost_scsi_get_tag() parameters to accept scsi_tag, lun, and
task_attr.

v4 changes:
  - Add prot_pto=1 in tcm_vhost_submission_work() when no PI buffer
    exists (nab)
  - Get rid of req + cdb pointer casts in vhost_scsi_handle_vq (mst)
  - Ensure that virtio_scsi_cmd_req_pi processing happens regardless
    of data_num in vhost_scsi_handle_vq (nab)
  - Pass TARGET_PROT_ALL into transport_init_session_tags() (nab)
  - Convert vhost_scsi_handle_vq to use memcpy_fromiovecend() (mst)
  - Convert vhost_scsi_handle_vq to use pi_bytesout + pi_bytesin (nab)

v3 changes:
  - Use feature_bit for determining virtio-scsi header type (Paolo)

v2 changes:
  - Use virtio_scsi_cmd_req_pi instead of existing ->prio (Paolo)
  - Make protection buffer come before data buffer (Paolo)
  - Update vhost_scsi_get_tag() parameter usage

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |  183 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 124 insertions(+), 59 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index eabcf18..17ec04b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -169,7 +169,8 @@ enum {
 };
 
 enum {
-	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG)
+	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
+					       (1ULL << VIRTIO_SCSI_F_T10_PI)
 };
 
 #define VHOST_SCSI_MAX_TARGET	256
@@ -720,11 +721,9 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 }
 
 static struct tcm_vhost_cmd *
-vhost_scsi_get_tag(struct vhost_virtqueue *vq,
-			struct tcm_vhost_tpg *tpg,
-			struct virtio_scsi_cmd_req *v_req,
-			u32 exp_data_len,
-			int data_direction)
+vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
+		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
+		   u32 exp_data_len, int data_direction)
 {
 	struct tcm_vhost_cmd *cmd;
 	struct tcm_vhost_nexus *tv_nexus;
@@ -756,13 +755,16 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 	cmd->tvc_prot_sgl = prot_sg;
 	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
-	cmd->tvc_tag = v_req->tag;
-	cmd->tvc_task_attr = v_req->task_attr;
+	cmd->tvc_tag = scsi_tag;
+	cmd->tvc_lun = lun;
+	cmd->tvc_task_attr = task_attr;
 	cmd->tvc_exp_data_len = exp_data_len;
 	cmd->tvc_data_direction = data_direction;
 	cmd->tvc_nexus = tv_nexus;
 	cmd->inflight = tcm_vhost_get_inflight(vq);
 
+	memcpy(cmd->tvc_cdb, cdb, TCM_VHOST_MAX_CDB_SIZE);
+
 	return cmd;
 }
 
@@ -913,18 +915,17 @@ static void tcm_vhost_submission_work(struct work_struct *work)
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
+		else
+			se_cmd->prot_pto = true;
 	} else {
 		sg_ptr = NULL;
 	}
@@ -935,7 +936,7 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
 			cmd->tvc_task_attr, cmd->tvc_data_direction,
 			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			sg_bidi_ptr, sg_no_bidi, NULL, 0);
+			NULL, 0, sg_prot_ptr, cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
@@ -967,12 +968,18 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
 	struct tcm_vhost_tpg **vs_tpg;
 	struct virtio_scsi_cmd_req v_req;
+	struct virtio_scsi_cmd_req_pi v_req_pi;
 	struct tcm_vhost_tpg *tpg;
 	struct tcm_vhost_cmd *cmd;
-	u32 exp_data_len, data_first, data_num, data_direction;
+	u64 tag;
+	u32 exp_data_len, data_first, data_num, data_direction, prot_first;
 	unsigned out, in, i;
-	int head, ret;
-	u8 target;
+	int head, ret, data_niov, prot_niov, prot_bytes;
+	size_t req_size;
+	u16 lun;
+	u8 *target, *lunp, task_attr;
+	bool hdr_pi;
+	void *req, *cdb;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1003,7 +1010,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			break;
 		}
 
-/* FIXME: BIDI operation */
+		/* FIXME: BIDI operation */
 		if (out == 1 && in == 1) {
 			data_direction = DMA_NONE;
 			data_first = 0;
@@ -1033,29 +1040,38 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			break;
 		}
 
-		if (unlikely(vq->iov[0].iov_len != sizeof(v_req))) {
-			vq_err(vq, "Expecting virtio_scsi_cmd_req, got %zu"
-				" bytes\n", vq->iov[0].iov_len);
+		if (vs->dev.acked_features & VIRTIO_SCSI_F_T10_PI) {
+			req = &v_req_pi;
+			lunp = &v_req_pi.lun[0];
+			target = &v_req_pi.lun[1];
+			req_size = sizeof(v_req_pi);
+			hdr_pi = true;
+		} else {
+			req = &v_req;
+			lunp = &v_req.lun[0];
+			target = &v_req.lun[1];
+			req_size = sizeof(v_req);
+			hdr_pi = false;
+		}
+
+		if (unlikely(vq->iov[0].iov_len < req_size)) {
+			pr_err("Expecting virtio-scsi header: %zu, got %zu\n",
+			       req_size, vq->iov[0].iov_len);
 			break;
 		}
-		pr_debug("Calling __copy_from_user: vq->iov[0].iov_base: %p,"
-			" len: %zu\n", vq->iov[0].iov_base, sizeof(v_req));
-		ret = __copy_from_user(&v_req, vq->iov[0].iov_base,
-				sizeof(v_req));
+		ret = memcpy_fromiovecend(req, &vq->iov[0], 0, req_size);
 		if (unlikely(ret)) {
 			vq_err(vq, "Faulted on virtio_scsi_cmd_req\n");
 			break;
 		}
 
 		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
-		if (unlikely(v_req.lun[0] != 1)) {
+		if (unlikely(*lunp != 1)) {
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
 
-		/* Extract the tpgt */
-		target = v_req.lun[1];
-		tpg = ACCESS_ONCE(vs_tpg[target]);
+		tpg = ACCESS_ONCE(vs_tpg[*target]);
 
 		/* Target does not exist, fail the request */
 		if (unlikely(!tpg)) {
@@ -1063,17 +1079,78 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			continue;
 		}
 
+		data_niov = data_num;
+		prot_niov = prot_first = prot_bytes = 0;
+		/*
+		 * Determine if any protection information iovecs are preceeding
+		 * the actual data payload, and adjust data_first + data_niov
+		 * values accordingly for vhost_scsi_map_iov_to_sgl() below.
+		 *
+		 * Also extract virtio_scsi header bits for vhost_scsi_get_tag()
+		 */
+		if (hdr_pi) {
+			if (v_req_pi.pi_bytesout) {
+				if (data_direction != DMA_TO_DEVICE) {
+					vq_err(vq, "Received non zero do_pi_niov"
+						", but wrong data_direction\n");
+					goto err_cmd;
+				}
+				prot_bytes = v_req_pi.pi_bytesout;
+			} else if (v_req_pi.pi_bytesin) {
+				if (data_direction != DMA_FROM_DEVICE) {
+					vq_err(vq, "Received non zero di_pi_niov"
+						", but wrong data_direction\n");
+					goto err_cmd;
+				}
+				prot_bytes = v_req_pi.pi_bytesin;
+			}
+			if (prot_bytes) {
+				int tmp = 0;
+
+				for (i = 0; i < data_num; i++) {
+					tmp += vq->iov[data_first + i].iov_len;
+					prot_niov++;
+					if (tmp >= prot_bytes)
+						break;
+				}
+				prot_first = data_first;
+				data_first += prot_niov;
+				data_niov = data_num - prot_niov;
+			}
+			tag = v_req_pi.tag;
+			task_attr = v_req_pi.task_attr;
+			cdb = &v_req_pi.cdb[0];
+			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
+		} else {
+			tag = v_req.tag;
+			task_attr = v_req.task_attr;
+			cdb = &v_req.cdb[0];
+			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
+		}
 		exp_data_len = 0;
-		for (i = 0; i < data_num; i++)
+		for (i = 0; i < data_niov; i++)
 			exp_data_len += vq->iov[data_first + i].iov_len;
+		/*
+		 * Check that the recieved CDB size does not exceeded our
+		 * hardcoded max for vhost-scsi
+		 *
+		 * TODO what if cdb was too small for varlen cdb header?
+		 */
+		if (unlikely(scsi_command_size(cdb) > TCM_VHOST_MAX_CDB_SIZE)) {
+			vq_err(vq, "Received SCSI CDB with command_size: %d that"
+				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
+				scsi_command_size(cdb), TCM_VHOST_MAX_CDB_SIZE);
+			goto err_cmd;
+		}
 
-		cmd = vhost_scsi_get_tag(vq, tpg, &v_req,
+		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
 					 exp_data_len, data_direction);
 		if (IS_ERR(cmd)) {
 			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
 					PTR_ERR(cmd));
 			goto err_cmd;
 		}
+
 		pr_debug("Allocated tv_cmd: %p exp_data_len: %d, data_direction"
 			": %d\n", cmd, exp_data_len, data_direction);
 
@@ -1081,40 +1158,28 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		cmd->tvc_vq = vq;
 		cmd->tvc_resp = vq->iov[out].iov_base;
 
-		/*
-		 * Copy in the recieved CDB descriptor into cmd->tvc_cdb
-		 * that will be used by tcm_vhost_new_cmd_map() and down into
-		 * target_setup_cmd_from_cdb()
-		 */
-		memcpy(cmd->tvc_cdb, v_req.cdb, TCM_VHOST_MAX_CDB_SIZE);
-		/*
-		 * Check that the recieved CDB size does not exceeded our
-		 * hardcoded max for tcm_vhost
-		 */
-		/* TODO what if cdb was too small for varlen cdb header? */
-		if (unlikely(scsi_command_size(cmd->tvc_cdb) >
-					TCM_VHOST_MAX_CDB_SIZE)) {
-			vq_err(vq, "Received SCSI CDB with command_size: %d that"
-				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
-				scsi_command_size(cmd->tvc_cdb),
-				TCM_VHOST_MAX_CDB_SIZE);
-			goto err_free;
-		}
-		cmd->tvc_lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
-
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			cmd->tvc_cdb[0], cmd->tvc_lun);
 
+		if (prot_niov) {
+			ret = vhost_scsi_map_iov_to_prot(cmd,
+					&vq->iov[prot_first], prot_niov,
+					data_direction == DMA_FROM_DEVICE);
+			if (unlikely(ret)) {
+				vq_err(vq, "Failed to map iov to"
+					" prot_sgl\n");
+				goto err_free;
+			}
+		}
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
 		/*
 		 * Save the descriptor from vhost_get_vq_desc() to be used to
 		 * complete the virtio-scsi request in TCM callback context via
@@ -1788,7 +1853,7 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 	tv_nexus->tvn_se_sess = transport_init_session_tags(
 					TCM_VHOST_DEFAULT_TAGS,
 					sizeof(struct tcm_vhost_cmd),
-					TARGET_PROT_NORMAL);
+					TARGET_PROT_ALL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
-- 
1.7.10.4

