From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 09/11] vhost/scsi: Drop legacy pre virtio v1.0 !ANY_LAYOUT logic
Date: Mon,  2 Feb 2015 04:06:32 +0000
Message-ID: <1422849994-3419-10-git-send-email-nab@daterainc.com>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With the new ANY_LAYOUT logic in place for vhost_scsi_handle_vqal(),
there is no longer a reason to keep around the legacy code with
!ANY_LAYOUT assumptions.

Go ahead and drop the pre virtio 1.0 logic in vhost_scsi_handle_vq()
and associated helpers.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 339 +--------------------------------------------------
 1 file changed, 1 insertion(+), 338 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 25a07a9..b17b5a0 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -825,93 +825,6 @@ out:
 }
 
 static int
-vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
-			  struct iovec *iov,
-			  int niov,
-			  bool write)
-{
-	struct scatterlist *sg = cmd->tvc_sgl;
-	unsigned int sgl_count = 0;
-	int ret, i;
-
-	for (i = 0; i < niov; i++)
-		sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
-
-	if (sgl_count > TCM_VHOST_PREALLOC_SGLS) {
-		pr_err("vhost_scsi_map_iov_to_sgl() sgl_count: %u greater than"
-			" preallocated TCM_VHOST_PREALLOC_SGLS: %u\n",
-			sgl_count, TCM_VHOST_PREALLOC_SGLS);
-		return -ENOBUFS;
-	}
-
-	pr_debug("%s sg %p sgl_count %u\n", __func__, sg, sgl_count);
-	sg_init_table(sg, sgl_count);
-	cmd->tvc_sgl_count = sgl_count;
-
-	pr_debug("Mapping iovec %p for %u pages\n", &iov[0], sgl_count);
-
-	for (i = 0; i < niov; i++) {
-		ret = vhost_scsi_map_to_sgl(cmd, iov[i].iov_base, iov[i].iov_len,
-					    sg, write);
-		if (ret < 0) {
-			for (i = 0; i < cmd->tvc_sgl_count; i++) {
-				struct page *page = sg_page(&cmd->tvc_sgl[i]);
-				if (page)
-					put_page(page);
-			}
-			cmd->tvc_sgl_count = 0;
-			return ret;
-		}
-		sg += ret;
-		sgl_count -= ret;
-	}
-	return 0;
-}
-
-static int
-vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
-			   struct iovec *iov,
-			   int niov,
-			   bool write)
-{
-	struct scatterlist *prot_sg = cmd->tvc_prot_sgl;
-	unsigned int prot_sgl_count = 0;
-	int ret, i;
-
-	for (i = 0; i < niov; i++)
-		prot_sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
-
-	if (prot_sgl_count > TCM_VHOST_PREALLOC_PROT_SGLS) {
-		pr_err("vhost_scsi_map_iov_to_prot() sgl_count: %u greater than"
-			" preallocated TCM_VHOST_PREALLOC_PROT_SGLS: %u\n",
-			prot_sgl_count, TCM_VHOST_PREALLOC_PROT_SGLS);
-		return -ENOBUFS;
-	}
-
-	pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
-		 prot_sg, prot_sgl_count);
-	sg_init_table(prot_sg, prot_sgl_count);
-	cmd->tvc_prot_sgl_count = prot_sgl_count;
-
-	for (i = 0; i < niov; i++) {
-		ret = vhost_scsi_map_to_sgl(cmd, iov[i].iov_base, iov[i].iov_len,
-					    prot_sg, write);
-		if (ret < 0) {
-			for (i = 0; i < cmd->tvc_prot_sgl_count; i++) {
-				struct page *page = sg_page(&cmd->tvc_prot_sgl[i]);
-				if (page)
-					put_page(page);
-			}
-			cmd->tvc_prot_sgl_count = 0;
-			return ret;
-		}
-		prot_sg += ret;
-		prot_sgl_count -= ret;
-	}
-	return 0;
-}
-
-static int
 vhost_scsi_calc_sgls(struct iovec *iov, size_t off, size_t bytes,
 		     int *niov, int max_niov, int max_sgls)
 {
@@ -1391,253 +1304,6 @@ out:
 	mutex_unlock(&vq->mutex);
 }
 
-static void
-vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
-{
-	struct tcm_vhost_tpg **vs_tpg;
-	struct virtio_scsi_cmd_req v_req;
-	struct virtio_scsi_cmd_req_pi v_req_pi;
-	struct tcm_vhost_tpg *tpg;
-	struct tcm_vhost_cmd *cmd;
-	u64 tag;
-	u32 exp_data_len, data_first, data_num, data_direction, prot_first;
-	unsigned out, in, i;
-	int head, ret, data_niov, prot_niov, prot_bytes;
-	size_t req_size;
-	u16 lun;
-	u8 *target, *lunp, task_attr;
-	bool hdr_pi;
-	void *req, *cdb;
-
-	mutex_lock(&vq->mutex);
-	/*
-	 * We can handle the vq only after the endpoint is setup by calling the
-	 * VHOST_SCSI_SET_ENDPOINT ioctl.
-	 */
-	vs_tpg = vq->private_data;
-	if (!vs_tpg)
-		goto out;
-
-	vhost_disable_notify(&vs->dev, vq);
-
-	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					ARRAY_SIZE(vq->iov), &out, &in,
-					NULL, NULL);
-		pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-					head, out, in);
-		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
-			break;
-		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
-			if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
-				vhost_disable_notify(&vs->dev, vq);
-				continue;
-			}
-			break;
-		}
-
-		/* FIXME: BIDI operation */
-		if (out == 1 && in == 1) {
-			data_direction = DMA_NONE;
-			data_first = 0;
-			data_num = 0;
-		} else if (out == 1 && in > 1) {
-			data_direction = DMA_FROM_DEVICE;
-			data_first = out + 1;
-			data_num = in - 1;
-		} else if (out > 1 && in == 1) {
-			data_direction = DMA_TO_DEVICE;
-			data_first = 1;
-			data_num = out - 1;
-		} else {
-			vq_err(vq, "Invalid buffer layout out: %u in: %u\n",
-					out, in);
-			break;
-		}
-
-		/*
-		 * Check for a sane resp buffer so we can report errors to
-		 * the guest.
-		 */
-		if (unlikely(vq->iov[out].iov_len !=
-					sizeof(struct virtio_scsi_cmd_resp))) {
-			vq_err(vq, "Expecting virtio_scsi_cmd_resp, got %zu"
-				" bytes\n", vq->iov[out].iov_len);
-			break;
-		}
-
-		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI)) {
-			req = &v_req_pi;
-			lunp = &v_req_pi.lun[0];
-			target = &v_req_pi.lun[1];
-			req_size = sizeof(v_req_pi);
-			hdr_pi = true;
-		} else {
-			req = &v_req;
-			lunp = &v_req.lun[0];
-			target = &v_req.lun[1];
-			req_size = sizeof(v_req);
-			hdr_pi = false;
-		}
-
-		if (unlikely(vq->iov[0].iov_len < req_size)) {
-			pr_err("Expecting virtio-scsi header: %zu, got %zu\n",
-			       req_size, vq->iov[0].iov_len);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-		ret = memcpy_fromiovecend(req, &vq->iov[0], 0, req_size);
-		if (unlikely(ret)) {
-			vq_err(vq, "Faulted on virtio_scsi_cmd_req\n");
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-
-		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
-		if (unlikely(*lunp != 1)) {
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-
-		tpg = ACCESS_ONCE(vs_tpg[*target]);
-
-		/* Target does not exist, fail the request */
-		if (unlikely(!tpg)) {
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-
-		data_niov = data_num;
-		prot_niov = prot_first = prot_bytes = 0;
-		/*
-		 * Determine if any protection information iovecs are preceeding
-		 * the actual data payload, and adjust data_first + data_niov
-		 * values accordingly for vhost_scsi_map_iov_to_sgl() below.
-		 *
-		 * Also extract virtio_scsi header bits for vhost_scsi_get_tag()
-		 */
-		if (hdr_pi) {
-			if (v_req_pi.pi_bytesout) {
-				if (data_direction != DMA_TO_DEVICE) {
-					vq_err(vq, "Received non zero do_pi_niov"
-						", but wrong data_direction\n");
-					vhost_scsi_send_bad_target(vs, vq, head, out);
-					continue;
-				}
-				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesout);
-			} else if (v_req_pi.pi_bytesin) {
-				if (data_direction != DMA_FROM_DEVICE) {
-					vq_err(vq, "Received non zero di_pi_niov"
-						", but wrong data_direction\n");
-					vhost_scsi_send_bad_target(vs, vq, head, out);
-					continue;
-				}
-				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesin);
-			}
-			if (prot_bytes) {
-				int tmp = 0;
-
-				for (i = 0; i < data_num; i++) {
-					tmp += vq->iov[data_first + i].iov_len;
-					prot_niov++;
-					if (tmp >= prot_bytes)
-						break;
-				}
-				prot_first = data_first;
-				data_first += prot_niov;
-				data_niov = data_num - prot_niov;
-			}
-			tag = vhost64_to_cpu(vq, v_req_pi.tag);
-			task_attr = v_req_pi.task_attr;
-			cdb = &v_req_pi.cdb[0];
-			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
-		} else {
-			tag = vhost64_to_cpu(vq, v_req.tag);
-			task_attr = v_req.task_attr;
-			cdb = &v_req.cdb[0];
-			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
-		}
-		exp_data_len = 0;
-		for (i = 0; i < data_niov; i++)
-			exp_data_len += vq->iov[data_first + i].iov_len;
-		/*
-		 * Check that the recieved CDB size does not exceeded our
-		 * hardcoded max for vhost-scsi
-		 *
-		 * TODO what if cdb was too small for varlen cdb header?
-		 */
-		if (unlikely(scsi_command_size(cdb) > TCM_VHOST_MAX_CDB_SIZE)) {
-			vq_err(vq, "Received SCSI CDB with command_size: %d that"
-				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
-				scsi_command_size(cdb), TCM_VHOST_MAX_CDB_SIZE);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-
-		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
-					 exp_data_len + prot_bytes,
-					 data_direction);
-		if (IS_ERR(cmd)) {
-			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
-					PTR_ERR(cmd));
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-
-		pr_debug("Allocated tv_cmd: %p exp_data_len: %d, data_direction"
-			": %d\n", cmd, exp_data_len, data_direction);
-
-		cmd->tvc_vhost = vs;
-		cmd->tvc_vq = vq;
-		cmd->tvc_resp_iov = &vq->iov[out];
-
-		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
-			cmd->tvc_cdb[0], cmd->tvc_lun);
-
-		if (prot_niov) {
-			ret = vhost_scsi_map_iov_to_prot(cmd,
-					&vq->iov[prot_first], prot_niov,
-					data_direction == DMA_FROM_DEVICE);
-			if (unlikely(ret)) {
-				vq_err(vq, "Failed to map iov to"
-					" prot_sgl\n");
-				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
-				vhost_scsi_send_bad_target(vs, vq, head, out);
-				continue;
-			}
-		}
-		if (data_direction != DMA_NONE) {
-			ret = vhost_scsi_map_iov_to_sgl(cmd,
-					&vq->iov[data_first], data_niov,
-					data_direction == DMA_FROM_DEVICE);
-			if (unlikely(ret)) {
-				vq_err(vq, "Failed to map iov to sgl\n");
-				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
-				vhost_scsi_send_bad_target(vs, vq, head, out);
-				continue;
-			}
-		}
-		/*
-		 * Save the descriptor from vhost_get_vq_desc() to be used to
-		 * complete the virtio-scsi request in TCM callback context via
-		 * tcm_vhost_queue_data_in() and tcm_vhost_queue_status()
-		 */
-		cmd->tvc_vq_desc = head;
-		/*
-		 * Dispatch tv_cmd descriptor for cmwq execution in process
-		 * context provided by tcm_vhost_workqueue.  This also ensures
-		 * tv_cmd is executed on the same kworker CPU as this vhost
-		 * thread to gain positive L2 cache locality effects..
-		 */
-		INIT_WORK(&cmd->work, tcm_vhost_submission_work);
-		queue_work(tcm_vhost_workqueue, &cmd->work);
-	}
-out:
-	mutex_unlock(&vq->mutex);
-}
-
 static void vhost_scsi_ctl_handle_kick(struct vhost_work *work)
 {
 	pr_debug("%s: The handling func for control queue.\n", __func__);
@@ -1695,10 +1361,7 @@ static void vhost_scsi_handle_kick(struct vhost_work *work)
 						poll.work);
 	struct vhost_scsi *vs = container_of(vq->dev, struct vhost_scsi, dev);
 
-	if (vhost_has_feature(vq, VIRTIO_F_ANY_LAYOUT))
-		vhost_scsi_handle_vqal(vs, vq);
-	else
-		vhost_scsi_handle_vq(vs, vq);
+	vhost_scsi_handle_vqal(vs, vq);
 }
 
 static void vhost_scsi_flush_vq(struct vhost_scsi *vs, int index)
-- 
1.9.1

