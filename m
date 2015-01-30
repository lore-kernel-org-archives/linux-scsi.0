From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 7/8] vhost/scsi: Add ANY_LAYOUT support
Date: Fri, 30 Jan 2015 08:12:31 +0000
Message-ID: <1422605552-24797-8-git-send-email-nab@daterainc.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds initial ANY_LAYOUT support with a new vhost_virtqueue
callback in vhost_scsi_handle_vqal().

It calculates data_direction + exp_data_len for the new tcm_vhost_cmd
descriptor by walking both outgoing + incoming iovecs, assuming the
layout of outgoing request header + T10_PI + Data payload comes first.

It also uses memcpy_fromiovec_out() to copy leading virtio-scsi
request header that may or may not include SCSI CDB, that returns a
re-calculated iovec to start of T10_PI or Data SGL memory.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 267 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 267 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d2208a41..206f4ef 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1087,6 +1087,273 @@ static void vhost_scsi_queue_desc(struct tcm_vhost_cmd *cmd, int desc)
 }
 
 static void
+vhost_scsi_handle_vqal(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
+{
+	struct tcm_vhost_tpg **vs_tpg;
+	struct virtio_scsi_cmd_req v_req;
+	struct virtio_scsi_cmd_req_pi v_req_pi;
+	struct tcm_vhost_tpg *tpg;
+	struct tcm_vhost_cmd *cmd;
+	struct iovec *iov, *iov_out, *prot_iov, *data_iov;
+	u64 tag;
+	u32 exp_data_len, data_direction;
+	unsigned out, in, i;
+	int head, ret, prot_bytes, iov_off, data_off, prot_off;
+	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
+	size_t out_size, in_size;
+	u16 lun;
+	u8 *target, *lunp, task_attr;
+	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
+	void *req, *cdb;
+
+	mutex_lock(&vq->mutex);
+	/*
+	 * We can handle the vq only after the endpoint is setup by calling the
+	 * VHOST_SCSI_SET_ENDPOINT ioctl.
+	 */
+	vs_tpg = vq->private_data;
+	if (!vs_tpg)
+		goto out;
+
+	vhost_disable_notify(&vs->dev, vq);
+
+	for (;;) {
+		head = vhost_get_vq_desc(vq, vq->iov,
+					 ARRAY_SIZE(vq->iov), &out, &in,
+					 NULL, NULL);
+		pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
+			 head, out, in);
+		/* On error, stop handling until the next kick. */
+		if (unlikely(head < 0))
+			break;
+		/* Nothing new?  Wait for eventfd to tell us they refilled. */
+		if (head == vq->num) {
+			if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
+				vhost_disable_notify(&vs->dev, vq);
+				continue;
+			}
+			break;
+		}
+		/*
+		 * Setup pointers and values based upon different virtio-scsi
+		 * request header if T10_PI is enabled in KVM guest.
+		 */
+		if (t10_pi) {
+			req = &v_req_pi;
+			req_size = sizeof(v_req_pi);
+			lunp = &v_req_pi.lun[0];
+			target = &v_req_pi.lun[1];
+		} else {
+			req = &v_req;
+			req_size = sizeof(v_req);
+			lunp = &v_req.lun[0];
+			target = &v_req.lun[1];
+		}
+		/*
+		 * Determine data_direction for ANY_LAYOUT by calculating the
+		 * total outgoing iovec sizes / incoming iovec sizes vs.
+		 * virtio-scsi request / response headers respectively.
+		 *
+		 * FIXME: Not correct for BIDI operation
+		 */
+		out_size = in_size = 0;
+		for (i = 0; i < out; i++)
+			out_size += vq->iov[i].iov_len;
+		for (i = out; i < out + in; i++)
+			in_size += vq->iov[i].iov_len;
+		/*
+		 * Any associated T10_PI bytes for the outgoing / incoming
+		 * payloads are included in calculation of exp_data_len here.
+		 */
+		if (out_size > req_size) {
+			data_direction = DMA_TO_DEVICE;
+			exp_data_len = out_size - req_size;
+		} else if (in_size > rsp_size) {
+			data_direction = DMA_FROM_DEVICE;
+			exp_data_len = in_size - rsp_size;
+		} else {
+			data_direction = DMA_NONE;
+			exp_data_len = 0;
+		}
+		/*
+		 * Copy over the virtio-scsi request header, which when
+		 * ANY_LAYOUT is enabled may span multiple iovecs, or a
+		 * single iovec may contain both the header + incoming
+		 * WRITE payloads.
+		 *
+		 * memcpy_fromiovec_out() is modifying the iovecs as it
+		 * copies over req_size bytes into req, so the returned
+		 * iov_out will contain the correct start + offset of the
+		 * incoming WRITE payload, if DMA_TO_DEVICE is set.
+		 */
+		ret = memcpy_fromiovec_out(req, &vq->iov[0], &iov_out, req_size);
+		if (unlikely(ret)) {
+			vq_err(vq, "Faulted on virtio_scsi_cmd_req\n");
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+
+		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
+		if (unlikely(*lunp != 1)) {
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+
+		tpg = ACCESS_ONCE(vs_tpg[*target]);
+		if (unlikely(!tpg)) {
+			/* Target does not exist, fail the request */
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+		/*
+		 * Determine start of T10_PI or data payload iovec in ANY_LAYOUT
+		 * mode based upon data_direction.
+		 *
+		 * For DMA_TO_DEVICE, this is iov_out from memcpy_fromiovec_out()
+		 * with the already recalculated iov_base + iov_len.
+		 *
+		 * For DMA_FROM_DEVICE, the iovec will be just past the end
+		 * of the virtio-scsi response header in either the same
+		 * or immediately following iovec.
+		 */
+		iov = data_iov = prot_iov = NULL;
+		iov_off = data_off = prot_off = 0;
+
+		if (data_direction == DMA_TO_DEVICE) {
+			iov = iov_out;
+		} else if (data_direction == DMA_FROM_DEVICE) {
+			int tmp_rsp_size = rsp_size;
+
+			for (i = out; i < out + in; i++) {
+				if (vq->iov[i].iov_len > tmp_rsp_size) {
+					iov = &vq->iov[i];
+					iov_off = tmp_rsp_size;
+					break;
+				} else if (vq->iov[i].iov_len == tmp_rsp_size) {
+					iov = &vq->iov[i+1];
+					break;
+				} else {
+					tmp_rsp_size -= vq->iov[i].iov_len;
+				}
+			}
+		}
+		/*
+		 * If T10_PI header is present, setup prot_iov + prot_off values
+		 * then recalculate data_iov + data_off for vhost_scsi_mapal()
+		 * mapping from host scatterlists via get_user_pages_fast().
+		 */
+		prot_bytes = 0;
+
+		if (t10_pi) {
+			int i = 0, tmp_prot_bytes;
+
+			if (v_req_pi.pi_bytesout) {
+				if (data_direction != DMA_TO_DEVICE) {
+					vq_err(vq, "Received non zero do_pi_niov"
+						", but wrong data_direction\n");
+					vhost_scsi_send_bad_target(vs, vq, head, out);
+					continue;
+				}
+				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesout);
+			} else if (v_req_pi.pi_bytesin) {
+				if (data_direction != DMA_FROM_DEVICE) {
+					vq_err(vq, "Received non zero di_pi_niov"
+						", but wrong data_direction\n");
+					vhost_scsi_send_bad_target(vs, vq, head, out);
+					continue;
+				}
+				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesin);
+			}
+			/*
+			 * Set prot_iov + prot_off values used by the iovec ->
+			 * SGL mapping logic, then calculate the start of data
+			 * payload after T10_PI and save to data_iov + data_off.
+			 */
+			data_iov = prot_iov = iov;
+			data_off = prot_off = iov_off;
+			tmp_prot_bytes = prot_bytes;
+
+			while (tmp_prot_bytes) {
+				int iov_len = prot_iov[i].iov_len - iov_off;
+				int len = min(iov_len, tmp_prot_bytes);
+
+				if (tmp_prot_bytes -= len) {
+					i++;
+					iov_off = 0;
+					continue;
+				}
+				if (iov_len > len) {
+					data_iov = &prot_iov[i];
+					data_off = len;
+				} else if (iov_len == len) {
+					data_iov = &prot_iov[i+1];
+					data_off = 0;
+				}
+			}
+
+			exp_data_len -= prot_bytes;
+			tag = vhost64_to_cpu(vq, v_req_pi.tag);
+			task_attr = v_req_pi.task_attr;
+			cdb = &v_req_pi.cdb[0];
+			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
+		} else {
+			data_iov = iov;
+			data_off = iov_off;
+
+			tag = vhost64_to_cpu(vq, v_req.tag);
+			task_attr = v_req.task_attr;
+			cdb = &v_req.cdb[0];
+			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
+		}
+		/*
+		 * Check that the recieved CDB size does not exceeded our
+		 * hardcoded max for vhost-scsi, then get a pre-allocated
+		 * cmd descriptor for the incoming virtio-scsi tag.
+		 *
+		 * TODO what if cdb was too small for varlen cdb header?
+		 */
+		if (unlikely(scsi_command_size(cdb) > TCM_VHOST_MAX_CDB_SIZE)) {
+			vq_err(vq, "Received SCSI CDB with command_size: %d that"
+				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
+				scsi_command_size(cdb), TCM_VHOST_MAX_CDB_SIZE);
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
+					 exp_data_len + prot_bytes,
+					 data_direction);
+		if (IS_ERR(cmd)) {
+			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
+			       PTR_ERR(cmd));
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+		cmd->tvc_vhost = vs;
+		cmd->tvc_vq = vq;
+		cmd->tvc_resp_iov = &vq->iov[out];
+
+		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
+			 cmd->tvc_cdb[0], cmd->tvc_lun);
+		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
+			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
+
+		if (data_direction != DMA_NONE) {
+			ret = vhost_scsi_mapal(cmd, prot_bytes, prot_iov, prot_off,
+					       exp_data_len, data_iov, data_off);
+			if (unlikely(ret)) {
+				vq_err(vq, "Failed to map iov to sgl\n");
+				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
+				vhost_scsi_send_bad_target(vs, vq, head, out);
+				continue;
+			}
+		}
+		vhost_scsi_queue_desc(cmd, head);
+	}
+out:
+	mutex_unlock(&vq->mutex);
+}
+
+static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
 	struct tcm_vhost_tpg **vs_tpg;
-- 
1.9.1

