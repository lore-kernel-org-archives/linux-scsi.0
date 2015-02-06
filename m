From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 5/8] vhost/scsi: Add ANY_LAYOUT support in vhost_scsi_handle_vq
Date: Fri,  6 Feb 2015 05:06:38 +0000
Message-ID: <1423199201-14659-6-git-send-email-nab@daterainc.com>
References: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42717 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbBFFjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 00:39:52 -0500
Received: by mail-ob0-f179.google.com with SMTP id wp4so11343207obc.10
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2015 21:39:51 -0800 (PST)
In-Reply-To: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>, Al Viro <viro@zeniv.linux.org.uk>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds ANY_LAYOUT compatible support within the existing
vhost_scsi_handle_vq() ->handle_kick() callback.

It calculates data_direction + exp_data_len for the new tcm_vhost_cmd
descriptor by walking both outgoing + incoming iovecs using iov_iter,
assuming the layout of outgoing request header + T10_PI + Data payload
comes first.

It also uses copy_from_iter() to copy leading virtio-scsi request header
that may or may not include SCSI CDB, that returns a re-calculated iovec
to start of T10_PI or Data SGL memory.

Also, go ahead and drop the legacy pre virtio v1.0 !ANY_LAYOUT logic.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 306 ++++++++++++++++++---------------------------------
 1 file changed, 110 insertions(+), 196 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5396b8a..e53959f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -828,93 +828,6 @@ out:
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
 vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 {
 	int sgl_count = 0;
@@ -1064,19 +977,20 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
-	struct tcm_vhost_tpg **vs_tpg;
+	struct tcm_vhost_tpg **vs_tpg, *tpg;
 	struct virtio_scsi_cmd_req v_req;
 	struct virtio_scsi_cmd_req_pi v_req_pi;
-	struct tcm_vhost_tpg *tpg;
 	struct tcm_vhost_cmd *cmd;
+	struct iov_iter out_iter, in_iter, prot_iter, data_iter;
 	u64 tag;
-	u32 exp_data_len, data_first, data_num, data_direction, prot_first;
-	unsigned out, in, i;
-	int head, ret, data_niov, prot_niov, prot_bytes;
-	size_t req_size;
+	u32 exp_data_len, data_direction;
+	unsigned out, in;
+	int head, ret, prot_bytes;
+	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
+	size_t out_size, in_size;
 	u16 lun;
 	u8 *target, *lunp, task_attr;
-	bool hdr_pi;
+	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
 	void *req, *cdb;
 
 	mutex_lock(&vq->mutex);
@@ -1092,10 +1006,10 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	for (;;) {
 		head = vhost_get_vq_desc(vq, vq->iov,
-					ARRAY_SIZE(vq->iov), &out, &in,
-					NULL, NULL);
+					 ARRAY_SIZE(vq->iov), &out, &in,
+					 NULL, NULL);
 		pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-					head, out, in);
+			 head, out, in);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(head < 0))
 			break;
@@ -1107,117 +1021,134 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			}
 			break;
 		}
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
 		/*
-		 * Check for a sane resp buffer so we can report errors to
-		 * the guest.
+		 * Check for a sane response buffer so we can report early
+		 * errors back to the guest.
 		 */
-		if (unlikely(vq->iov[out].iov_len !=
-					sizeof(struct virtio_scsi_cmd_resp))) {
-			vq_err(vq, "Expecting virtio_scsi_cmd_resp, got %zu"
-				" bytes\n", vq->iov[out].iov_len);
+		if (unlikely(vq->iov[out].iov_len < rsp_size)) {
+			vq_err(vq, "Expecting at least virtio_scsi_cmd_resp"
+				" size, got %zu bytes\n", vq->iov[out].iov_len);
 			break;
 		}
-
-		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI)) {
+		/*
+		 * Setup pointers and values based upon different virtio-scsi
+		 * request header if T10_PI is enabled in KVM guest.
+		 */
+		if (t10_pi) {
 			req = &v_req_pi;
+			req_size = sizeof(v_req_pi);
 			lunp = &v_req_pi.lun[0];
 			target = &v_req_pi.lun[1];
-			req_size = sizeof(v_req_pi);
-			hdr_pi = true;
 		} else {
 			req = &v_req;
+			req_size = sizeof(v_req);
 			lunp = &v_req.lun[0];
 			target = &v_req.lun[1];
-			req_size = sizeof(v_req);
-			hdr_pi = false;
 		}
+		/*
+		 * FIXME: Not correct for BIDI operation
+		 */
+		out_size = iov_length(vq->iov, out);
+		in_size = iov_length(&vq->iov[out], in);
 
-		if (unlikely(vq->iov[0].iov_len < req_size)) {
-			pr_err("Expecting virtio-scsi header: %zu, got %zu\n",
-			       req_size, vq->iov[0].iov_len);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-		ret = memcpy_fromiovecend(req, &vq->iov[0], 0, req_size);
-		if (unlikely(ret)) {
-			vq_err(vq, "Faulted on virtio_scsi_cmd_req\n");
+		/*
+		 * Copy over the virtio-scsi request header, which for a
+		 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
+		 * single iovec may contain both the header + outgoing
+		 * WRITE payloads.
+		 *
+		 * copy_from_iter() will advance out_iter, so that it will
+		 * point at the start of the outgoing WRITE payload, if
+		 * DMA_TO_DEVICE is set.
+		 */
+		iov_iter_init(&out_iter, WRITE, vq->iov, out, out_size);
+
+		ret = copy_from_iter(req, req_size, &out_iter);
+		if (unlikely(ret != req_size)) {
+			vq_err(vq, "Faulted on copy_from_iter\n");
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
-
 		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
 		if (unlikely(*lunp != 1)) {
+			vq_err(vq, "Illegal virtio-scsi lun: %u\n", *lunp);
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
 
 		tpg = ACCESS_ONCE(vs_tpg[*target]);
-
-		/* Target does not exist, fail the request */
 		if (unlikely(!tpg)) {
+			/* Target does not exist, fail the request */
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
-
-		data_niov = data_num;
-		prot_niov = prot_first = prot_bytes = 0;
 		/*
-		 * Determine if any protection information iovecs are preceeding
-		 * the actual data payload, and adjust data_first + data_niov
-		 * values accordingly for vhost_scsi_map_iov_to_sgl() below.
+		 * Determine data_direction by calculating the total outgoing
+		 * iovec sizes + incoming iovec sizes vs. virtio-scsi request +
+		 * response headers respectively.
 		 *
-		 * Also extract virtio_scsi header bits for vhost_scsi_get_tag()
+		 * For DMA_TO_DEVICE this is out_iter, which is already pointing
+		 * to the right place.
+		 *
+		 * For DMA_FROM_DEVICE, the iovec will be just past the end
+		 * of the virtio-scsi response header in either the same
+		 * or immediately following iovec.
+		 *
+		 * Any associated T10_PI bytes for the outgoing / incoming
+		 * payloads are included in calculation of exp_data_len here.
+		 */
+		prot_bytes = 0;
+
+		if (out_size > req_size) {
+			data_direction = DMA_TO_DEVICE;
+			exp_data_len = out_size - req_size;
+			data_iter = out_iter;
+		} else if (in_size > rsp_size) {
+			data_direction = DMA_FROM_DEVICE;
+			exp_data_len = in_size - rsp_size;
+
+			iov_iter_init(&in_iter, READ, &vq->iov[out], in,
+				      rsp_size + exp_data_len);
+			iov_iter_advance(&in_iter, rsp_size);
+			data_iter = in_iter;
+		} else {
+			data_direction = DMA_NONE;
+			exp_data_len = 0;
+		}
+		/*
+		 * If T10_PI header + payload is present, setup prot_iter values
+		 * and recalculate data_iter for vhost_scsi_mapal() mapping to
+		 * host scatterlists via get_user_pages_fast().
 		 */
-		if (hdr_pi) {
+		if (t10_pi) {
 			if (v_req_pi.pi_bytesout) {
 				if (data_direction != DMA_TO_DEVICE) {
-					vq_err(vq, "Received non zero do_pi_niov"
-						", but wrong data_direction\n");
+					vq_err(vq, "Received non zero pi_bytesout,"
+						" but wrong data_direction\n");
 					vhost_scsi_send_bad_target(vs, vq, head, out);
 					continue;
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesout);
 			} else if (v_req_pi.pi_bytesin) {
 				if (data_direction != DMA_FROM_DEVICE) {
-					vq_err(vq, "Received non zero di_pi_niov"
-						", but wrong data_direction\n");
+					vq_err(vq, "Received non zero pi_bytesin,"
+						" but wrong data_direction\n");
 					vhost_scsi_send_bad_target(vs, vq, head, out);
 					continue;
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesin);
 			}
+			/*
+			 * Set prot_iter to data_iter, and advance past any
+			 * preceeding prot_bytes that may be present.
+			 *
+			 * Also fix up the exp_data_len to reflect only the
+			 * actual data payload length.
+			 */
 			if (prot_bytes) {
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
+				exp_data_len -= prot_bytes;
+				prot_iter = data_iter;
+				iov_iter_advance(&data_iter, prot_bytes);
 			}
 			tag = vhost64_to_cpu(vq, v_req_pi.tag);
 			task_attr = v_req_pi.task_attr;
@@ -1229,12 +1160,10 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			cdb = &v_req.cdb[0];
 			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
 		}
-		exp_data_len = 0;
-		for (i = 0; i < data_niov; i++)
-			exp_data_len += vq->iov[data_first + i].iov_len;
 		/*
-		 * Check that the recieved CDB size does not exceeded our
-		 * hardcoded max for vhost-scsi
+		 * Check that the received CDB size does not exceeded our
+		 * hardcoded max for vhost-scsi, then get a pre-allocated
+		 * cmd descriptor for the new virtio-scsi tag.
 		 *
 		 * TODO what if cdb was too small for varlen cdb header?
 		 */
@@ -1245,44 +1174,29 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
-
 		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
 					 exp_data_len + prot_bytes,
 					 data_direction);
 		if (IS_ERR(cmd)) {
 			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
-					PTR_ERR(cmd));
+			       PTR_ERR(cmd));
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
-
-		pr_debug("Allocated tv_cmd: %p exp_data_len: %d, data_direction"
-			": %d\n", cmd, exp_data_len, data_direction);
-
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
 		cmd->tvc_resp_iov = &vq->iov[out];
 		cmd->tvc_in_iovs = in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
-			cmd->tvc_cdb[0], cmd->tvc_lun);
+			 cmd->tvc_cdb[0], cmd->tvc_lun);
+		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
+			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
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
 		if (data_direction != DMA_NONE) {
-			ret = vhost_scsi_map_iov_to_sgl(cmd,
-					&vq->iov[data_first], data_niov,
-					data_direction == DMA_FROM_DEVICE);
+			ret = vhost_scsi_mapal(cmd,
+					       prot_bytes, &prot_iter,
+					       exp_data_len, &data_iter);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
@@ -1293,14 +1207,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		/*
 		 * Save the descriptor from vhost_get_vq_desc() to be used to
 		 * complete the virtio-scsi request in TCM callback context via
-		 * tcm_vhost_queue_data_in() and tcm_vhost_queue_status()
+		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
 		cmd->tvc_vq_desc = head;
 		/*
-		 * Dispatch tv_cmd descriptor for cmwq execution in process
-		 * context provided by tcm_vhost_workqueue.  This also ensures
-		 * tv_cmd is executed on the same kworker CPU as this vhost
-		 * thread to gain positive L2 cache locality effects..
+		 * Dispatch cmd descriptor for cmwq execution in process
+		 * context provided by vhost_scsi_workqueue.  This also ensures
+		 * cmd is executed on the same kworker CPU as this vhost
+		 * thread to gain positive L2 cache locality effects.
 		 */
 		INIT_WORK(&cmd->work, tcm_vhost_submission_work);
 		queue_work(tcm_vhost_workqueue, &cmd->work);
-- 
1.9.1

