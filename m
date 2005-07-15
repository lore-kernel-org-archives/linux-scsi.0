From: Roland Dreier <rolandd@cisco.com>
Subject: [RFC] First pass at InfiniBand SRP initiator
Date: Fri, 15 Jul 2005 13:07:33 -0700
Message-ID: <52ackn7rzu.fsf@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <openib-general-bounces@openib.org>
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: linux-scsi@vger.kernel.org
Cc: openib-general@openib.org
List-Id: linux-scsi@vger.kernel.org

Here's a first pass at an InfiniBand SCSI RDMA Protocol (SRP)
initiator.  This allows systems to talk to storage over an IB network--
IB SRP storage is available from a number of vendors.

This obviously isn't ready for merging yet, since it implements no
error handling, etc.  However, I'd appreciate any and all comments on
the code that exists, so that I can fix things up before going too far
off into the weeds.

One design note: all discovery of storage is assumed to be pushed off
into userspace, which then tells the kernel to connect to a given
target port by doing something like:

    echo id_ext=21000004cfe7a949,ioc_guid=0005ad00000015dd,dgid=fe800000000000000005ad00000015dd,pkey=ffff,service_id=0000000000000066 > /sys/class/infiniband_srp/srp-mthca1-1/add_target

Thanks,
  Roland

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-export/drivers/infiniband/ulp/srp/ib_srp.c	2005-07-15 13:02:00.278274501 -0700
@@ -0,0 +1,1344 @@
+/*
+ * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * $Id: ib_srp.c 2860 2005-07-14 16:39:43Z roland $
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/idr.h>
+#include <linux/string.h>
+#include <linux/parser.h>
+
+#include <asm/atomic.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+
+#include <ib_cache.h>
+
+#include "ib_srp.h"
+
+#define DRV_NAME	"ib_srp"
+#define PFX		DRV_NAME ": "
+#define DRV_VERSION	"0.01"
+#define DRV_RELDATE	"January 11, 2005"
+
+MODULE_AUTHOR("Roland Dreier");
+MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol driver");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static int topspin_workarounds = 1;
+
+module_param(topspin_workarounds, int, 0444);
+MODULE_PARM_DESC(topspin_workarounds,
+		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
+
+static const u8 topspin_oui[3] = { 0x00, 0x05, 0xad };
+
+static atomic_t srp_uid;
+
+static rwlock_t idr_lock;
+static DEFINE_IDR(target_idr);
+
+static void srp_add_one(struct ib_device *device);
+static void srp_remove_one(struct ib_device *device);
+
+static struct ib_client srp_client = {
+	.name   = "srp",
+	.add    = srp_add_one,
+	.remove = srp_remove_one
+};
+
+static inline struct srp_target_port *host_to_target(struct Scsi_Host *host)
+{
+	return (struct srp_target_port *) host->hostdata;
+}
+
+static const char *srp_target_info(struct Scsi_Host *host)
+{
+	return host_to_target(host)->target_name;
+}
+
+static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
+				   unsigned int __nocast gfp_mask,
+				   enum dma_data_direction direction)
+{
+	struct srp_iu *iu;
+
+	iu = kmalloc(sizeof *iu, gfp_mask);
+	if (!iu)
+		return NULL;
+
+	iu->buf = kmalloc(size, gfp_mask);
+	if (!iu->buf) {
+		kfree(iu);
+		return NULL;
+	}
+
+	memset(iu->buf, 0, size);
+
+	iu->dma = dma_map_single(host->dev->dma_device, iu->buf, size, direction);
+	if (dma_mapping_error(iu->dma)) {
+		kfree(iu->buf);
+		kfree(iu);
+		return NULL;
+	}
+
+	iu->size      = size;
+	iu->direction = direction;
+
+	return iu;
+}
+
+static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
+{
+	if (!iu)
+		return;
+
+	dma_unmap_single(host->dev->dma_device, iu->dma, iu->size, iu->direction);
+	kfree(iu->buf);
+	kfree(iu);
+}
+
+static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
+			struct srp_iu *iu)
+{
+	struct srp_cmd *cmd = iu->buf;
+	int len;
+	u8 fmt;
+
+	if (!scmnd->request_buffer || scmnd->sc_data_direction == DMA_NONE)
+		return sizeof (struct srp_cmd);
+
+	if (scmnd->sc_data_direction != DMA_FROM_DEVICE &&
+	    scmnd->sc_data_direction != DMA_TO_DEVICE) {
+		printk(KERN_WARNING PFX "Unhandled data direction %d\n",
+		       scmnd->sc_data_direction);
+		return -EINVAL;
+	}
+
+	if (scmnd->use_sg) {
+		struct scatterlist *scat = scmnd->request_buffer;
+		int n;
+		int i;
+
+		n = dma_map_sg(target->srp_host->dev->dma_device,
+			       scat, scmnd->use_sg, scmnd->sc_data_direction);
+
+		if (n == 1) {
+			struct srp_direct_buf *buf = (void *) cmd->add_data;
+
+			fmt = SRP_DATA_DESC_DIRECT;
+
+			buf->va  = cpu_to_be64(sg_dma_address(scat));
+			buf->key = cpu_to_be32(target->srp_host->mr->rkey);
+			buf->len = cpu_to_be32(sg_dma_len(scat));
+
+			len = sizeof (struct srp_cmd) +
+				sizeof (struct srp_direct_buf);
+		} else {
+			struct srp_indirect_buf *buf = (void *) cmd->add_data;
+			u32 datalen = 0;
+
+			fmt = SRP_DATA_DESC_INDIRECT;
+
+			if (scmnd->sc_data_direction == DMA_TO_DEVICE)
+				cmd->data_out_desc_cnt = n;
+			else
+				cmd->data_in_desc_cnt = n;
+
+			buf->table_desc.va  = cpu_to_be64(iu->dma +
+							  sizeof *cmd +
+							  sizeof *buf);
+			buf->table_desc.key =
+				cpu_to_be32(target->srp_host->mr->rkey);
+			buf->table_desc.len =
+				cpu_to_be32(n * sizeof (struct srp_direct_buf));
+
+			for (i = 0; i < n; ++i) {
+				buf->desc_list[i].va  = cpu_to_be64(sg_dma_address(&scat[i]));
+				buf->desc_list[i].key =
+					cpu_to_be32(target->srp_host->mr->rkey);
+				buf->desc_list[i].len = cpu_to_be32(sg_dma_len(&scat[i]));
+
+				datalen += sg_dma_len(&scat[i]);
+			}
+
+			buf->len = cpu_to_be32(datalen);
+
+			len = sizeof (struct srp_cmd) +
+				sizeof (struct srp_indirect_buf) +
+				n * sizeof (struct srp_direct_buf);
+		}
+	} else {
+		struct srp_direct_buf *buf = (void *) cmd->add_data;
+		dma_addr_t dma;
+
+		dma = dma_map_single(target->srp_host->dev->dma_device,
+				     scmnd->request_buffer, scmnd->request_bufflen,
+				     scmnd->sc_data_direction);
+		if (dma_mapping_error(dma)) {
+			printk(KERN_WARNING PFX "unable to map %p/%d (dir %d)\n",
+			       scmnd->request_buffer, (int) scmnd->request_bufflen,
+			       scmnd->sc_data_direction);
+			return -EINVAL;
+		}
+
+		buf->va  = cpu_to_be64(dma);
+		buf->key = cpu_to_be32(target->srp_host->mr->rkey);
+		buf->len = cpu_to_be32(scmnd->request_bufflen);
+
+		fmt = SRP_DATA_DESC_DIRECT;
+
+		len = sizeof (struct srp_cmd) + sizeof (struct srp_direct_buf);
+	}
+
+	if (scmnd->sc_data_direction == DMA_TO_DEVICE)
+		cmd->buf_fmt = fmt << 4;
+	else
+		cmd->buf_fmt = fmt;
+
+
+	return len;
+}
+
+static void srp_unmap_data(struct scsi_cmnd *scmnd,
+			   struct srp_target_port *target,
+			   struct srp_cmd *cmd)
+{
+	if (!scmnd->request_buffer ||
+	    (scmnd->sc_data_direction != DMA_TO_DEVICE &&
+	     scmnd->sc_data_direction != DMA_FROM_DEVICE))
+	    return;
+
+	if (scmnd->use_sg)
+		dma_unmap_sg(target->srp_host->dev->dma_device,
+			     (struct scatterlist *) scmnd->request_buffer,
+			     scmnd->use_sg, scmnd->sc_data_direction);
+	else
+		dma_unmap_single(target->srp_host->dev->dma_device,
+				 be64_to_cpu(((struct srp_direct_buf *) cmd->add_data)->va),
+				 scmnd->request_bufflen,
+				 scmnd->sc_data_direction);
+}
+
+static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
+{
+	struct scsi_cmnd *scmnd = (void *) (unsigned long) rsp->tag;
+	struct srp_iu *iu = (void *) scmnd->host_scribble;
+	unsigned long flags;
+	s32 delta;
+
+	delta = (s32) be32_to_cpu(rsp->req_lim_delta);
+
+	spin_lock_irqsave(&target->lock, flags);
+	target->req_lim += delta;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	scmnd->result = rsp->status;
+
+	if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
+		memcpy(scmnd->sense_buffer, rsp->data +
+		       be32_to_cpu(rsp->resp_data_len),
+		       min_t(int, be32_to_cpu(rsp->sense_data_len),
+			     SCSI_SENSE_BUFFERSIZE));
+	}
+
+	if (rsp->flags & (SRP_RSP_FLAG_DOOVER | SRP_RSP_FLAG_DOUNDER))
+		scmnd->resid = be32_to_cpu(rsp->data_out_res_cnt);
+	else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
+		scmnd->resid = be32_to_cpu(rsp->data_in_res_cnt);
+
+	if (!scmnd->host_scribble)
+		printk(KERN_ERR PFX "scsi command %p with NULL host_scribble!\n", scmnd);
+
+	srp_unmap_data(scmnd, target, iu->buf);
+	srp_free_iu(target->srp_host, iu);
+
+	scmnd->scsi_done(scmnd);
+}
+
+static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
+{
+	struct srp_iu *iu;
+	u8 opcode;
+
+	iu = target->rx_ring[wc->wr_id & ~SRP_OP_RECV];
+
+	if (!iu->buf) {
+		printk(KERN_ERR PFX "iu with NULL buf; index %d (head %u, tail %u)\n",
+		       (int) wc->wr_id & ~SRP_OP_RECV, target->rx_head, target->rx_tail);
+		return;
+	} else
+		opcode = *(u8 *) iu->buf;
+
+	if (wc->status) {
+		printk(KERN_ERR PFX "failed recv status %d\n", wc->status);
+		goto out;
+	}
+
+	if (0) {
+		int i;
+
+		printk(KERN_ERR PFX "recv completion, opcode 0x%02x\n", opcode);
+
+		for (i = 0; i < wc->byte_len; ++i) {
+			if (i % 8 == 0)
+				printk(KERN_ERR "  [%02x] ", i);
+			printk(" %02x", ((u8 *) iu->buf)[i]);
+			if ((i + 1) % 8 == 0)
+				printk("\n");
+		}
+
+		if (wc->byte_len % 8)
+			printk("\n");
+	}
+
+	switch (opcode) {
+	case SRP_RSP:
+		srp_process_rsp(target, iu->buf);
+		break;
+
+	case SRP_T_LOGOUT:
+		/* XXX Handle target logout */
+		printk(KERN_WARNING PFX "Got target logout request\n");
+		break;
+
+	default:
+		printk(KERN_WARNING PFX "Unhandled SRP opcode 0x%02x\n", opcode);
+		break;
+	}
+
+out:
+	srp_free_iu(target->srp_host, iu);
+	++target->rx_tail;
+}
+
+static void srp_handle_send(struct srp_target_port *target, struct ib_wc *wc)
+{
+	if (wc->status) {
+		struct srp_iu *iu;
+
+		printk(KERN_ERR "failed send status %d\n", wc->status);
+
+		iu = target->tx_ring[wc->wr_id];
+
+		/* XXX fail associated SCSI command */
+
+		srp_free_iu(target->srp_host, iu);
+	}
+
+	++target->tx_tail;
+}
+
+static void srp_completion(struct ib_cq *cq, void *target_ptr)
+{
+	struct srp_target_port *target = target_ptr;
+	struct ib_wc wc;
+
+	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+	while (ib_poll_cq(cq, 1, &wc) > 0) {
+		if (wc.wr_id & SRP_OP_RECV)
+			srp_handle_recv(target, &wc);
+		else
+			srp_handle_send(target, &wc);
+	}
+}
+
+static void srp_qp_event(struct ib_event *event, void *context)
+{
+	printk(KERN_ERR PFX "QP event %d\n", event->event);
+}
+
+static int srp_post_recv(struct srp_target_port *target,
+			 unsigned int __nocast gfp_mask)
+{
+	struct srp_iu *iu;
+	struct ib_sge list;
+	struct ib_recv_wr wr, *bad_wr;
+	unsigned long flags;
+	unsigned int next;
+	int ret;
+
+	iu = srp_alloc_iu(target->srp_host, target->max_ti_iu_len,
+			  gfp_mask, DMA_FROM_DEVICE);
+	if (!iu)
+		return -ENOMEM;
+
+	list.addr   = iu->dma;
+	list.length = iu->size;
+	list.lkey   = target->srp_host->mr->lkey;
+
+	wr.next     = NULL;
+	wr.sg_list  = &list;
+	wr.num_sge  = 1;
+
+	spin_lock_irqsave(&target->lock, flags);
+
+	next = target->rx_head & (SRP_RQ_SIZE - 1);
+	wr.wr_id = next | SRP_OP_RECV;
+	target->rx_ring[next] = iu;
+
+	ret = ib_post_recv(target->qp, &wr, &bad_wr);
+	if (ret)
+		srp_free_iu(target->srp_host, iu);
+	else
+		++target->rx_head;
+
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	return ret;
+}
+
+static int srp_post_send(struct srp_target_port *target,
+			 struct srp_iu *iu, int len)
+{
+	struct ib_sge list;
+	struct ib_send_wr wr, *bad_wr;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&target->lock, flags);
+	if (target->req_lim < 1) {
+		printk(KERN_ERR PFX "Target has req_lim %d\n", target->req_lim);
+		ret = -EAGAIN;
+	}
+
+	--target->req_lim;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	if (ret)
+		return ret;
+
+	list.addr   = iu->dma;
+	list.length = len;
+	list.lkey   = target->srp_host->mr->lkey;
+
+	wr.next       = NULL;
+	wr.wr_id      = target->tx_head & SRP_SQ_SIZE;
+	wr.sg_list    = &list;
+	wr.num_sge    = 1;
+	wr.opcode     = IB_WR_SEND;
+	wr.send_flags = IB_SEND_SIGNALED;
+
+	target->tx_ring[target->tx_head & SRP_SQ_SIZE] = iu;
+
+	ret = ib_post_send(target->qp, &wr, &bad_wr);
+
+	if (!ret)
+		++target->tx_head;
+
+	return ret;
+}
+
+static int srp_queuecommand(struct scsi_cmnd *scmnd,
+			    void (*done)(struct scsi_cmnd *))
+{
+	struct srp_target_port *target;
+	struct srp_iu *iu;
+	struct srp_cmd *cmd;
+	unsigned long flags;
+	int len;
+
+	read_lock_irqsave(&idr_lock, flags);
+	target = idr_find(&target_idr, scmnd->device->id);
+	read_unlock_irqrestore(&idr_lock, flags);
+
+	if (!target) {
+		printk(KERN_ERR PFX "queuecommand for unknown device id %d\n",
+		       scmnd->device->id);
+		scmnd->result = DID_ERROR << 16;
+		done(scmnd);
+		return 0;
+	}
+
+	if (0) {
+		printk(KERN_ERR PFX "command for %u: ", scmnd->device->id);
+		scsi_print_command(scmnd);
+	}
+
+	iu = srp_alloc_iu(target->srp_host, SRP_MAX_IU_LEN,
+			  GFP_ATOMIC, DMA_TO_DEVICE);
+	if (!iu) {
+		scmnd->result = DID_ERROR << 16;
+		printk(KERN_ERR PFX "couldn't allocate send IU\n");
+		done(scmnd);
+		return 0;
+	}
+
+	scmnd->scsi_done     = done;
+	scmnd->result        = 0;
+	scmnd->host_scribble = (void *) iu;
+
+	cmd = iu->buf;
+	memset(cmd, 0, sizeof *cmd);
+
+	cmd->opcode = SRP_CMD;
+	cmd->lun = cpu_to_be64((u64) scmnd->device->lun << 48);
+	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
+	cmd->tag = (unsigned long) scmnd;
+
+	len = srp_map_data(scmnd, target, iu);
+	if (len < 0) {
+		printk(KERN_ERR PFX "Failed to map data\n");
+		goto err;
+	}
+
+	if (srp_post_recv(target, GFP_ATOMIC)) {
+		printk(KERN_ERR PFX "Recv failed\n");
+		goto err_unmap;
+	}
+
+	if (srp_post_send(target, iu, len)) {
+		printk(KERN_ERR PFX "Send failed\n");
+		goto err_unmap;
+	}
+
+	return 0;
+
+err_unmap:
+	srp_unmap_data(scmnd, target, cmd);
+
+err:
+	srp_free_iu(target->srp_host, iu);
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
+
+static int srp_abort(struct scsi_cmnd *scmnd)
+{
+	printk(KERN_ERR PFX "srp_abort called\n");
+
+        scmnd->result = DID_ABORT << 16;
+	scmnd->scsi_done(scmnd);
+
+	return SUCCESS;
+}
+
+static int srp_reset(struct scsi_cmnd *scmnd)
+{
+	printk(KERN_ERR PFX "srp_reset called\n");
+
+        scmnd->result = DID_ABORT << 16;
+	scmnd->scsi_done(scmnd);
+
+	return SUCCESS;
+}
+
+static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
+{
+	struct srp_target_port *target = cm_id->context;
+	struct ib_qp_attr *qp_attr = NULL;
+	int attr_mask = 0;
+	int comp = 0;
+	int ret = 0;
+
+	switch (event->event) {
+	case IB_CM_REP_RECEIVED:
+		printk(KERN_DEBUG PFX "REP received\n");
+		comp = 1;
+
+		{
+			struct srp_login_rsp *rsp = event->private_data;
+
+			/* XXX check that opcode is SRP RSP */
+
+			target->max_ti_iu_len = be32_to_cpu(rsp->max_ti_iu_len);
+			target->req_lim       = be32_to_cpu(rsp->req_lim_delta);
+
+			target->scsi_host->can_queue = min(target->req_lim,
+							   target->scsi_host->can_queue);
+
+			printk(KERN_DEBUG "  req_lim_delta %d\n", be32_to_cpu(rsp->req_lim_delta));
+			printk(KERN_DEBUG "  max_it_iu_len %d\n", be32_to_cpu(rsp->max_it_iu_len));
+			printk(KERN_DEBUG "  max_ti_iu_len %d\n", be32_to_cpu(rsp->max_ti_iu_len));
+		}
+
+		qp_attr = kmalloc(sizeof *qp_attr, GFP_KERNEL);
+		if (!qp_attr) {
+			target->status = -ENOMEM;
+			break;
+		}
+
+		qp_attr->qp_state = IB_QPS_RTR;
+		target->status = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
+		if (target->status)
+			break;
+
+		qp_attr->rq_psn = 0; /* XXX */
+		attr_mask |= IB_QP_RQ_PSN;
+
+		target->status = ib_modify_qp(target->qp, qp_attr, attr_mask);
+		if (target->status)
+			break;
+
+		target->status = srp_post_recv(target, GFP_KERNEL);
+		if (target->status)
+			break;
+
+		qp_attr->qp_state = IB_QPS_RTS;
+		target->status = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
+		if (target->status)
+			break;
+
+		target->status = ib_modify_qp(target->qp, qp_attr, attr_mask);
+		if (target->status)
+			break;
+
+		target->status = ib_send_cm_rtu(cm_id, NULL, 0);
+		if (target->status)
+			break;
+
+		break;
+
+	case IB_CM_REJ_RECEIVED:
+		printk(KERN_DEBUG PFX "REJ received\n");
+		comp = 1;
+
+		if (event->param.rej_rcvd.reason == IB_CM_REJ_PORT_REDIRECT) {
+			/*
+			 * Additional Reject Info contains
+			 * ClassPortInfo, which has the RedirectGID
+			 * field at an offset of 8 bytes.
+			 */
+			memcpy(target->path.dgid.raw,
+			       event->param.rej_rcvd.ari + 8, 16);
+
+			target->status = SRP_PORT_REDIRECT;
+		} else if (topspin_workarounds &&
+			   !memcmp(&target->ioc_guid, topspin_oui, 3) &&
+			   event->param.rej_rcvd.reason == __constant_htons(25)) {
+			/*
+			 * Topspin/Cisco SRP gateways incorrectly send
+			 * reject reason code 25 when they mean 24
+			 * (port redirect).
+			 */
+			memcpy(target->path.dgid.raw,
+			       event->param.rej_rcvd.ari + 0, 16);
+
+			printk(KERN_DEBUG PFX "Topspin/Cisco redirect to target port GID %016llx%016llx\n",
+			       (unsigned long long) be64_to_cpu(target->path.dgid.global.subnet_prefix),
+			       (unsigned long long) be64_to_cpu(target->path.dgid.global.interface_id));
+
+			target->status = SRP_PORT_REDIRECT;
+		} else {
+			printk(KERN_WARNING "  REJ reason 0x%x\n",
+			       event->param.rej_rcvd.reason);
+			target->status = -ECONNRESET;
+			ret = 1;
+		}
+
+		break;
+
+	case IB_CM_MRA_RECEIVED:
+		printk(KERN_ERR PFX "MRA received\n");
+		break;
+
+	case IB_CM_DREP_RECEIVED:
+		printk(KERN_ERR PFX "DREP received\n");
+		break;
+
+	case IB_CM_TIMEWAIT_EXIT:
+		printk(KERN_ERR PFX "connection closed\n");
+
+		comp = 1;
+		ret  = 1;
+		target->status = 0;
+		break;
+
+	default:
+		printk(KERN_WARNING PFX "Unhandled CM event %d\n", event->event);
+		break;
+	}
+
+	if (comp)
+		complete(&target->done);
+
+	kfree(qp_attr);
+
+	return ret;
+}
+
+static struct ib_qp *srp_create_qp(struct srp_target_port *target,
+				   struct ib_qp_init_attr *init_attr)
+{
+	struct ib_qp *qp;
+	struct ib_qp_attr *attr;
+	int ret;
+
+	attr = kmalloc(sizeof *attr, GFP_KERNEL);
+	if (!attr)
+		return ERR_PTR(-ENOMEM);
+
+	ret = ib_find_cached_pkey(target->srp_host->dev,
+				  target->srp_host->port,
+				  be16_to_cpu(target->path.pkey),
+				  &attr->pkey_index);
+	if (ret) {
+		qp = ERR_PTR(ret);
+		goto out;
+	}
+
+	qp = ib_create_qp(target->srp_host->pd, init_attr);
+	if (IS_ERR(qp))
+		goto out;
+
+	attr->qp_state        = IB_QPS_INIT;
+	attr->qp_access_flags = (IB_ACCESS_REMOTE_READ |
+				    IB_ACCESS_REMOTE_WRITE);
+	attr->port_num        = target->srp_host->port;
+
+	ret = ib_modify_qp(qp, attr,
+			   IB_QP_STATE		|
+			   IB_QP_PKEY_INDEX	|
+			   IB_QP_ACCESS_FLAGS	|
+			   IB_QP_PORT);
+	if (ret) {
+		ib_destroy_qp(qp);
+		qp = ERR_PTR(ret);
+	}
+
+out:
+	kfree(attr);
+	return qp;
+}
+
+static void srp_path_rec_completion(int status,
+				    struct ib_sa_path_rec *pathrec,
+				    void *target_ptr)
+{
+	struct srp_target_port *target = target_ptr;
+	struct srp_host        *host   = target->srp_host;
+	struct ib_qp_init_attr *init_attr = NULL;
+
+	if (status) {
+		printk(KERN_ERR PFX "Got failed path rec status %d\n", status);
+		target->status = status;
+		goto out;
+	}
+
+	target->path = *pathrec;
+
+	/*
+	 * We may be getting a path for the second time because we
+	 * were redirected to a different port.  In that case, there's
+	 * no reason to create our CQ and QP again.
+	 */
+	if (target->cq) {
+		target->status = 0;
+		goto out;
+	}
+
+	init_attr = kmalloc(sizeof *init_attr, GFP_KERNEL);
+	if (!init_attr) {
+		target->status = -ENOMEM;
+		goto out;
+	}
+
+	memset(init_attr, 0, sizeof *init_attr);
+	target->cq = ib_create_cq(host->dev, srp_completion,
+				  NULL, target, SRP_CQ_SIZE);
+	if (IS_ERR(target->cq)) {
+		target->status = PTR_ERR(target->cq);
+		goto out_free;
+	}
+
+	ib_req_notify_cq(target->cq, IB_CQ_NEXT_COMP);
+
+	init_attr->event_handler       = srp_qp_event;
+	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
+	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE;
+	init_attr->cap.max_recv_sge    = 1;
+	init_attr->cap.max_send_sge    = 1;
+	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
+	init_attr->qp_type             = IB_QPT_RC;
+	init_attr->send_cq             = target->cq;
+	init_attr->recv_cq             = target->cq;
+
+	target->qp = srp_create_qp(target, init_attr);
+	if (IS_ERR(target->qp)) {
+		target->status = PTR_ERR(target->qp);
+		ib_destroy_cq(target->cq);
+		goto out_free;
+	}
+
+	target->status = 0;
+
+out_free:
+	kfree(init_attr);
+
+out:
+	complete(&target->done);
+}
+
+static int srp_send_req(struct srp_target_port *target)
+{
+	struct {
+		struct ib_cm_req_param param;
+		struct srp_login_req   priv;
+	} *req = NULL;
+	int status;
+
+	req = kmalloc(sizeof *req, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	memset(req, 0, sizeof *req);
+	req->param.primary_path 	      = &target->path;
+	req->param.alternate_path 	      = NULL;
+	req->param.service_id 		      = target->service_id;
+	req->param.qp_num 		      = target->qp->qp_num;
+	req->param.qp_type 		      = target->qp->qp_type;
+	req->param.starting_psn 	      = 0; /* XXX */
+	req->param.private_data 	      = &req->priv;
+	req->param.private_data_len 	      = sizeof req->priv;
+	req->param.responder_resources	      = 4;
+	req->param.remote_cm_response_timeout = 20;
+	req->param.flow_control 	      = 1;
+	req->param.local_cm_response_timeout  = 20;
+	req->param.retry_count 		      = 7;
+	req->param.rnr_retry_count 	      = 7;
+	req->param.max_cm_retries 	      = 15;
+
+	req->priv.opcode     	= SRP_LOGIN_REQ;
+	req->priv.tag        	= 0;
+	req->priv.req_it_iu_len = cpu_to_be32(SRP_MAX_IU_LEN);
+	req->priv.req_buf_fmt 	= cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+					      SRP_BUF_FORMAT_INDIRECT);
+	memcpy(req->priv.initiator_port_id, target->srp_host->initiator_port_id, 16);
+	/*
+	 * Topspin/Cisco SRP targets will reject our login unless we
+	 * zero out the first 8 bytes of our initiator port ID.  The
+	 * second 8 bytes must be our local node GUID, but we always
+	 * use that anyway.
+	 */
+	if (topspin_workarounds && !memcmp(&target->ioc_guid, topspin_oui, 3)) {
+		printk(KERN_DEBUG PFX "Topspin/Cisco initiator port ID workaround "
+		       "activated for target GUID %016llx\n",
+		       (unsigned long long) be64_to_cpu(target->ioc_guid));
+		memset(req->priv.initiator_port_id, 0, 8);
+	}
+	memcpy(req->priv.target_port_id,     &target->id_ext, 8);
+	memcpy(req->priv.target_port_id + 8, &target->ioc_guid, 8);
+
+	status = ib_send_cm_req(target->cm_id, &req->param);
+	if (status) {
+		ib_destroy_qp(target->qp);
+		ib_destroy_cq(target->cq);
+	}
+
+	return status;
+}
+
+static void srp_release_target(struct srp_target_port *target)
+{
+	unsigned long flags;
+
+	/* XXX should send SRP_I_LOGOUT request */
+
+	init_completion(&target->done);
+	ib_send_cm_dreq(target->cm_id, NULL, 0);
+	wait_for_completion(&target->done);
+
+	ib_destroy_qp(target->qp);
+	ib_destroy_cq(target->cq);
+
+	write_lock_irqsave(&idr_lock, flags);
+	idr_remove(&target_idr, target->scsi_id);
+	write_unlock_irqrestore(&idr_lock, flags);
+}
+
+static struct scsi_host_template srp_template = {
+	.module 	       = THIS_MODULE,
+	.name   	       = DRV_NAME,
+	.info   	       = srp_target_info,
+	.queuecommand 	       = srp_queuecommand,
+        .eh_abort_handler      = srp_abort,
+        .eh_bus_reset_handler  = srp_reset,
+        .eh_host_reset_handler = srp_reset,
+	.can_queue 	       = SRP_SQ_SIZE,
+	.this_id 	       = -1,
+	.sg_tablesize 	       = SRP_MAX_INDIRECT,
+	.cmd_per_lun 	       = SRP_SQ_SIZE,
+	.use_clustering        = ENABLE_CLUSTERING
+};
+
+static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
+{
+	unsigned long flags;
+	int ret;
+
+	do {
+		if (!idr_pre_get(&target_idr, GFP_KERNEL))
+			return -ENOMEM;
+
+		write_lock_irqsave(&idr_lock, flags);
+		ret = idr_get_new(&target_idr, target, &target->scsi_id);
+		write_unlock_irqrestore(&idr_lock, flags);
+	} while (ret == -EAGAIN);
+
+	if (ret)
+		goto fail;
+
+	sprintf(target->target_name, "SRP.T10:%016llX",
+		 (unsigned long long) be64_to_cpu(target->id_ext));
+	target->scsi_host->unique_id = atomic_inc_return(&srp_uid);
+
+	if (scsi_add_host(target->scsi_host, host->dev->dma_device))
+		goto fail;
+
+	down(&host->target_mutex);
+	list_add_tail(&target->list, &host->target_list);
+	up(&host->target_mutex);
+
+	/* XXX: are we supposed to have a definition of SCAN_WILD_CARD ?? */
+	scsi_scan_target(&target->scsi_host->shost_gendev,
+			 0, target->scsi_id, ~0, 0);
+
+	return 0;
+
+fail:
+	write_lock_irqsave(&idr_lock, flags);
+	idr_remove(&target_idr, target->scsi_id);
+	write_unlock_irqrestore(&idr_lock, flags);
+
+	return ret;
+}
+
+static void srp_release_class_dev(struct class_device *class_dev)
+{
+	struct srp_host *host =
+		container_of(class_dev, struct srp_host, class_dev);
+
+	kfree(host);
+}
+
+static struct class srp_class = {
+	.name    = "infiniband_srp",
+	.release = srp_release_class_dev
+};
+
+/*
+ * Target ports are added by writing
+ *
+ *     id_ext=<SRP ID ext>,ioc_guid=<SRP IOC GUID>,dgid=<dest GID>,
+ *     pkey=<P_Key>,service_id=<service ID>
+ *
+ * to the add_target sysfs attribute.
+ */
+enum {
+	SRP_OPT_ERR		= 0,
+	SRP_OPT_ID_EXT		= 1 << 0,
+	SRP_OPT_IOC_GUID	= 1 << 1,
+	SRP_OPT_DGID		= 1 << 2,
+	SRP_OPT_PKEY		= 1 << 3,
+	SRP_OPT_SERVICE_ID	= 1 << 4,
+	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
+				   SRP_OPT_IOC_GUID	|
+				   SRP_OPT_DGID		|
+				   SRP_OPT_PKEY		|
+				   SRP_OPT_SERVICE_ID),
+};
+
+static match_table_t srp_opt_tokens = {
+	{ SRP_OPT_ID_EXT,	"id_ext=%s" },
+	{ SRP_OPT_IOC_GUID,	"ioc_guid=%s" },
+	{ SRP_OPT_DGID,		"dgid=%s" },
+	{ SRP_OPT_PKEY,		"pkey=%x" },
+	{ SRP_OPT_SERVICE_ID,	"service_id=%s" },
+	{ SRP_OPT_ERR,		NULL }
+};
+
+static int srp_parse_options(const char *buf, struct srp_target_port *target)
+{
+	char *options;
+	char *p;
+	char dgid[3];
+	substring_t args[MAX_OPT_ARGS];
+	int opt_mask = 0;
+	int token;
+	int ret = -EINVAL;
+	int i;
+
+/* XXX Remove when 2.6.13 is released with kstrdup() */
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,12)
+	{
+		int len = strlen(buf) + 1;
+		options = kmalloc(len, GFP_KERNEL);
+		if (!options)
+			return -ENOMEM;
+		memcpy(options, buf, len);
+	}
+#else
+	options = kstrdup(buf, GFP_KERNEL);
+	if (!options)
+		return -ENOMEM;
+#endif
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		if (!*p)
+			continue;
+
+		token = match_token(p, srp_opt_tokens, args);
+		opt_mask |= token;
+
+		switch (token) {
+		case SRP_OPT_ID_EXT:
+			p = match_strdup(args);
+			target->id_ext = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			kfree(p);
+			break;
+
+		case SRP_OPT_IOC_GUID:
+			p = match_strdup(args);
+			target->ioc_guid = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			kfree(p);
+			break;
+
+		case SRP_OPT_DGID:
+			p = match_strdup(args);
+			if (strlen(p) != 32)
+				goto out;
+
+			for (i = 0; i < 16; ++i) {
+				strlcpy(dgid, p + i * 2, 3);
+				target->path.dgid.raw[i] = simple_strtoul(dgid, NULL, 16);
+			}
+			break;
+
+		case SRP_OPT_PKEY:
+			if (match_hex(args, &token))
+				goto out;
+			target->path.pkey = cpu_to_be16(token);
+			break;
+
+		case SRP_OPT_SERVICE_ID:
+			p = match_strdup(args);
+			target->service_id = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			kfree(p);
+			break;
+
+		default:
+			goto out;
+		}
+	}
+
+	if (opt_mask == SRP_OPT_ALL)
+		ret = 0;
+
+out:
+	kfree(options);
+	return ret;
+}
+
+static ssize_t srp_create_target(struct class_device *class_dev,
+				 const char *buf, size_t count)
+{
+	struct srp_host *host =
+		container_of(class_dev, struct srp_host, class_dev);
+	struct Scsi_Host *target_host;
+	struct srp_target_port *target;
+	int ret;
+
+	target_host = scsi_host_alloc(&srp_template,
+				      sizeof (struct srp_target_port));
+	if (!target_host)
+		return -ENOMEM;
+
+	target = host_to_target(target_host);
+	memset(target, 0, sizeof *target);
+
+	ret = srp_parse_options(buf, target);
+	if (ret) {
+		scsi_host_put(target_host);
+		return ret;
+	}
+
+	spin_lock_init(&target->lock);
+	target->cm_id = ib_create_cm_id(srp_cm_handler, target);
+	if (IS_ERR(target->cm_id)) {
+		scsi_host_put(target_host);
+		return -ENOMEM;
+	}
+
+	ib_get_cached_gid(host->dev, host->port, 0, &target->path.sgid);
+
+	target->scsi_host  = target_host;
+	target->srp_host   = host;
+
+	printk(KERN_DEBUG PFX "new target: id_ext %016llx ioc_guid %016llx pkey %04x "
+	       "service_id %016llx dgid %04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
+	       (unsigned long long) be64_to_cpu(target->id_ext),
+	       (unsigned long long) be64_to_cpu(target->ioc_guid),
+	       be16_to_cpu(target->path.pkey),
+	       (unsigned long long) be64_to_cpu(target->service_id),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[0]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[2]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[4]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[6]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[8]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[10]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[12]),
+	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[14]));
+
+retry_path:
+	target->path.numb_path = 1;
+
+	init_completion(&target->done);
+
+	target->path_query_id = ib_sa_path_rec_get(host->dev, host->port,
+						   &target->path,
+						   IB_SA_PATH_REC_DGID		|
+						   IB_SA_PATH_REC_SGID		|
+						   IB_SA_PATH_REC_NUMB_PATH	|
+						   IB_SA_PATH_REC_PKEY,
+						   1000, GFP_KERNEL,
+						   srp_path_rec_completion,
+						   target, &target->path_query);
+	if (target->path_query_id < 0) {
+		ret = target->path_query_id;
+		ib_destroy_cm_id(target->cm_id);
+		scsi_host_put(target_host);
+		goto out;
+	}
+
+	wait_for_completion(&target->done);
+
+	if (target->status < 0) {
+		printk(KERN_WARNING PFX "Path record query failed\n");
+		ret = target->status;
+		ib_destroy_cm_id(target->cm_id);
+		scsi_host_put(target_host);
+		goto out;
+	}
+
+	init_completion(&target->done);
+	ret = srp_send_req(target);
+	if (ret) {
+		scsi_host_put(target_host);
+		goto out;
+	}
+	wait_for_completion(&target->done);
+
+	/*
+	 * The CM event handling code will set status to
+	 * SRP_PORT_REDIRECT if we get a port redirect REJ back.
+	 */
+	if (target->status == SRP_PORT_REDIRECT)
+		goto retry_path;
+	else if (target->status < 0) {
+		printk(KERN_ERR PFX "Connection failed\n");
+		ret = target->status;
+		scsi_host_put(target_host);
+		goto out;
+	}
+
+	ret = srp_add_target(host, target);
+
+	if (ret)
+		scsi_host_put(target_host);
+
+out:
+	return ret ? ret : count;
+}
+
+static CLASS_DEVICE_ATTR(add_target, S_IWUSR, NULL, srp_create_target);
+
+static struct srp_host *srp_add_port(struct ib_device *device,
+				     u64 node_guid, u8 port)
+{
+	struct srp_host *host;
+
+	host = kmalloc(sizeof *host, GFP_KERNEL);
+	if (!host)
+		return NULL;
+
+	memset(host, 0, sizeof *host);
+
+	INIT_LIST_HEAD(&host->target_list);
+	init_MUTEX(&host->target_mutex);
+	host->dev  = device;
+	host->port = port;
+
+	host->initiator_port_id[7] = port;
+	memcpy(host->initiator_port_id + 8, &node_guid, 8);
+
+	host->pd   = ib_alloc_pd(device);
+	if (IS_ERR(host->pd))
+		goto err_free;
+
+	host->mr   = ib_get_dma_mr(host->pd,
+				   IB_ACCESS_LOCAL_WRITE |
+				   IB_ACCESS_REMOTE_READ |
+				   IB_ACCESS_REMOTE_WRITE);
+	if (IS_ERR(host->mr))
+		goto err_pd;
+
+	host->class_dev.class = &srp_class;
+	host->class_dev.dev   = device->dma_device;
+	snprintf(host->class_dev.class_id, BUS_ID_SIZE, "srp-%s-%d",
+		 device->name, port);
+
+	if (class_device_register(&host->class_dev))
+		goto err_mr;
+	if (class_device_create_file(&host->class_dev, &class_device_attr_add_target))
+		goto err_class;
+	/* XXX ibdev / port files as well */
+
+	/*
+	 * Take another reference so we can unregister and then free
+	 * IB resources afterwards.
+	 */
+	class_device_get(&host->class_dev);
+
+	return host;
+
+err_class:
+	class_device_unregister(&host->class_dev);
+
+err_mr:
+	ib_dereg_mr(host->mr);
+
+err_pd:
+	ib_dealloc_pd(host->pd);
+
+err_free:
+	kfree(host);
+
+	return NULL;
+}
+
+static void srp_add_one(struct ib_device *device)
+{
+	struct list_head *dev_list;
+	struct srp_host *host;
+	struct ib_device_attr *dev_attr;
+	int s, e, p;
+
+	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
+	if (!dev_attr)
+		return;
+
+	if (ib_query_device(device, dev_attr)) {
+		printk(KERN_WARNING PFX "Couldn't query node GUID for %s.\n",
+		       device->name);
+		goto out;
+	}
+
+	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
+	if (!dev_list)
+		goto out;
+
+	INIT_LIST_HEAD(dev_list);
+
+	if (device->node_type == IB_NODE_SWITCH) {
+		s = 0;
+		e = 0;
+	} else {
+		s = 1;
+		e = device->phys_port_cnt;
+	}
+
+	for (p = s; p <= e; ++p) {
+		host = srp_add_port(device, dev_attr->node_guid, p);
+		if (host)
+			list_add_tail(&host->list, dev_list);
+	}
+
+	ib_set_client_data(device, &srp_client, dev_list);
+
+out:
+	kfree(dev_attr);
+}
+
+static void srp_remove_one(struct ib_device *device)
+{
+	struct list_head *dev_list;
+	struct srp_host *host, *tmp_host;
+	struct srp_target_port *target, *tmp_target;
+
+	dev_list = ib_get_client_data(device, &srp_client);
+
+	list_for_each_entry_safe(host, tmp_host, dev_list, list) {
+		down(&host->target_mutex);
+
+		list_for_each_entry_safe(target, tmp_target,
+					 &host->target_list, list) {
+			scsi_remove_host(target->scsi_host);
+			srp_release_target(target);
+			scsi_host_put(target->scsi_host);
+		}
+
+		up(&host->target_mutex);
+
+		class_device_unregister(&host->class_dev);
+		ib_dereg_mr(host->mr);
+		ib_dealloc_pd(host->pd);
+		class_device_put(&host->class_dev);
+	}
+}
+
+static int __init srp_init_module(void)
+{
+	int ret;
+
+	atomic_set(&srp_uid, 0);
+	rwlock_init(&idr_lock);
+
+	ret = class_register(&srp_class);
+	if (ret) {
+		printk(KERN_ERR PFX "couldn't register class infiniband_srp\n");
+		return ret;
+	}
+
+	ret = ib_register_client(&srp_client);
+	if (ret) {
+		printk(KERN_ERR PFX "couldn't register IB client\n");
+		class_unregister(&srp_class);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit srp_cleanup_module(void)
+{
+	ib_unregister_client(&srp_client);
+	class_unregister(&srp_class);
+}
+
+module_init(srp_init_module);
+module_exit(srp_cleanup_module);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-export/drivers/infiniband/ulp/srp/ib_srp.h	2005-07-15 13:02:00.288272334 -0700
@@ -0,0 +1,268 @@
+/*
+ * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * $Id: ib_srp.h 2861 2005-07-14 17:05:01Z roland $
+ */
+
+#ifndef IB_SRP_H
+#define IB_SRP_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include <asm/semaphore.h>
+
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+
+#include <ib_verbs.h>
+#include <ib_sa.h>
+#include <ib_cm.h>
+
+enum {
+	SRP_PORT_REDIRECT	= 1,
+
+	SRP_MAX_IU_LEN		= 256,
+
+	SRP_RQ_SHIFT    	= 6,
+	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
+	SRP_SQ_SIZE		= SRP_RQ_SIZE - 1,
+	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_RQ_SIZE
+};
+
+#define SRP_OP_RECV		(1 << 31)
+#define SRP_MAX_INDIRECT	((SRP_MAX_IU_LEN -			\
+				  sizeof (struct srp_cmd) -		\
+				  sizeof (struct srp_indirect_buf)) / 16)
+
+struct srp_host {
+	u8			initiator_port_id[16];
+	struct ib_device       *dev;
+	u8                      port;
+	struct ib_pd	       *pd;
+	struct ib_mr	       *mr;
+	struct class_device	class_dev;
+	struct list_head	target_list;
+	struct semaphore        target_mutex;
+	struct list_head	list;
+};
+
+struct srp_target_port {
+	spinlock_t		lock;
+
+	__be64			id_ext;
+	__be64			ioc_guid;
+	__be64			service_id;
+	struct srp_host	       *srp_host;
+	struct Scsi_Host       *scsi_host;
+	char			target_name[32];
+	unsigned int		scsi_id;
+
+	struct ib_sa_path_rec	path;
+	struct ib_sa_query     *path_query;
+	int			path_query_id;
+
+	struct ib_cm_id	       *cm_id;
+	struct ib_cq	       *cq;
+	struct ib_qp	       *qp;
+
+	int			max_ti_iu_len;
+	s32			req_lim;
+
+	unsigned		rx_head;
+	unsigned		rx_tail;
+	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
+
+	unsigned		tx_head;
+	unsigned		tx_tail;
+	struct srp_iu	       *tx_ring[SRP_SQ_SIZE + 1];
+
+	struct list_head	list;
+	struct completion	done;
+	int			status;
+};
+
+struct srp_iu {
+	dma_addr_t		dma;
+	void		       *buf;
+	size_t			size;
+	enum dma_data_direction	direction;
+};
+
+/*
+ * SRP protocol definitions
+ */
+
+enum {
+	SRP_LOGIN_REQ	= 0x00,
+	SRP_TSK_MGMT	= 0x01,
+	SRP_CMD		= 0x02,
+	SRP_I_LOGOUT	= 0x03,
+	SRP_LOGIN_RSP	= 0xc0,
+	SRP_RSP		= 0xc1,
+	SRP_LOGIN_REJ	= 0xc2,
+	SRP_T_LOGOUT	= 0x80,
+	SRP_CRED_REQ	= 0x81,
+	SRP_AER_REQ	= 0x82,
+	SRP_CRED_RSP	= 0x41,
+	SRP_AER_RSP	= 0x42
+};
+
+enum {
+	SRP_BUF_FORMAT_DIRECT   = 1 << 1,
+	SRP_BUF_FORMAT_INDIRECT = 1 << 2
+};
+
+enum {
+	SRP_NO_DATA_DESC       = 0,
+	SRP_DATA_DESC_DIRECT   = 1,
+	SRP_DATA_DESC_INDIRECT = 2
+};
+
+struct srp_direct_buf {
+	__be64	va;
+	__be32	key;
+	__be32  len;
+};
+
+/*
+ * We need the packed attribute because the SRP spec puts the list of
+ * descriptors at an offset of 20, which is not aligned to the size
+ * of struct srp_direct_buf.
+ */
+struct srp_indirect_buf {
+	struct srp_direct_buf	table_desc;
+	__be32			len;
+	struct srp_direct_buf	desc_list[0] __attribute__((packed));
+};
+
+enum {
+	SRP_MULTICHAN_SINGLE = 0,
+	SRP_MULTICHAN_MULTI  = 1
+};
+
+struct srp_login_req {
+	u8	opcode;
+	u8	reserved1[7];
+	u64	tag;
+	__be32	req_it_iu_len;
+	u8	reserved2[4];
+	__be16	req_buf_fmt;
+	u8	req_flags;
+	u8	reserved3[5];
+	u8	initiator_port_id[16];
+	u8	target_port_id[16];
+};
+
+struct srp_login_rsp {
+	u8	opcode;
+	u8	reserved1[3];
+	__be32	req_lim_delta;
+	u64	tag;
+	__be32	max_it_iu_len;
+	__be32	max_ti_iu_len;
+	__be16	buf_fmt;
+	u8	rsp_flags;
+	u8	reserved2[25];
+};
+
+struct srp_login_rej {
+	u8	opcode;
+	u8	reserved1[3];
+	__be32	reason;
+	u64	tag;
+	u8	reserved2[8];
+	__be16	buf_fmt;
+	u8	reserved3[6];
+};
+
+struct srp_i_logout {
+	u8	opcode;
+	u8	reserved[7];
+	u64	tag;
+};
+
+struct srp_t_logout {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved[2];
+	__be32	reason;
+	u64	tag;
+};
+
+/*
+ * We need the packed attribute because the SRP spec only aligns the
+ * 8-byte LUN field to 4 bytes.
+ */
+struct srp_cmd {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved1[3];
+	u8	buf_fmt;
+	u8	data_out_desc_cnt;
+	u8	data_in_desc_cnt;
+	u64	tag;
+	u8	reserved2[4];
+	__be64	lun __attribute__((packed));
+	u8	reserved3;
+	u8	task_attr;
+	u8	reserved4;
+	u8	add_cdb_len;
+	u8	cdb[16];
+	u8	add_data[0];
+};
+
+enum {
+	SRP_RSP_FLAG_RSPVALID = 1 << 0,
+	SRP_RSP_FLAG_SNSVALID = 1 << 1,
+	SRP_RSP_FLAG_DOOVER   = 1 << 2,
+	SRP_RSP_FLAG_DOUNDER  = 1 << 3,
+	SRP_RSP_FLAG_DIOVER   = 1 << 4,
+	SRP_RSP_FLAG_DIUNDER  = 1 << 5
+};
+
+struct srp_rsp {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved1[2];
+	__be32	req_lim_delta;
+	u64	tag;
+	u8	reserved2[2];
+	u8	flags;
+	u8	status;
+	__be32	data_out_res_cnt;
+	__be32	data_in_res_cnt;
+	__be32	sense_data_len;
+	__be32	resp_data_len;
+	u8	data[0];
+};
+
+#endif /* IB_SRP_H */
