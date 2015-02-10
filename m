From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 3/9] snic:Add meta request,  handling of meta requests.
Date: Tue, 10 Feb 2015 08:43:30 -0800
Message-ID: <1423586616-18177-4-git-send-email-nmusini@cisco.com>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-3.cisco.com ([173.37.142.90]:21652 "EHLO
	alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbBJQyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2015 11:54:35 -0500
In-Reply-To: <1423586616-18177-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

snic_io.h contains meta request structure definition
meta request contains high level information about firmware requests.
such as request information, size, SGLs.

snic_io.c contains interfaces to handle meta request, firmware acknowledgment,
and high level generic queueing interface.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_io.c | 546 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/snic/snic_io.h | 111 +++++++++
 2 files changed, 657 insertions(+)
 create mode 100644 drivers/scsi/snic/snic_io.c
 create mode 100644 drivers/scsi/snic/snic_io.h

diff --git a/drivers/scsi/snic/snic_io.c b/drivers/scsi/snic/snic_io.c
new file mode 100644
index 0000000..6f98a71
--- /dev/null
+++ b/drivers/scsi/snic/snic_io.c
@@ -0,0 +1,546 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/mempool.h>
+#include <scsi/scsi_tcq.h>
+
+#include "snic_io.h"
+#include "snic.h"
+#include "cq_enet_desc.h"
+#include "snic_fwint.h"
+#include "snic_os.h"
+
+static void
+snic_wq_cmpl_frame_send(struct vnic_wq *wq,
+			    struct cq_desc *cq_desc,
+			    struct vnic_wq_buf *buf,
+			    void *opaque)
+{
+	struct snic *snic = vnic_dev_priv(wq->vdev);
+
+	SNIC_BUG_ON(buf->os_buf == NULL);
+
+	if (snic_log_level & SNIC_DESC_LOGGING)
+		SNIC_HOST_INFO(snic->shost,
+			       "Ack received for snic_host_req %p.\n",
+			       buf->os_buf);
+
+	SNIC_TRC(snic->shost->host_no, 0, 0,
+		 ((u64)(buf->os_buf) - sizeof(struct snic_req_info)), 0, 0, 0);
+	pci_unmap_single(snic->pdev, buf->dma_addr, buf->len, PCI_DMA_TODEVICE);
+	buf->os_buf = NULL;
+}
+
+static int
+snic_wq_cmpl_handler_cont(struct vnic_dev *vdev,
+			  struct cq_desc *cq_desc,
+			  u8 type,
+			  u16 q_num,
+			  u16 cmpl_idx,
+			  void *opaque)
+{
+	struct snic *snic = vnic_dev_priv(vdev);
+	unsigned long flags;
+
+	SNIC_BUG_ON(q_num != 0);
+
+	spin_lock_irqsave(&snic->wq_lock[q_num], flags);
+	vnic_wq_service(&snic->wq[q_num],
+			cq_desc,
+			cmpl_idx,
+			snic_wq_cmpl_frame_send,
+			NULL);
+	spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
+
+	return 0;
+} /* end of snic_cmpl_handler_cont */
+
+int
+snic_wq_cmpl_handler(struct snic *snic, int work_to_do)
+{
+	unsigned int work_done = 0;
+	unsigned int i;
+
+	snic->s_stats.misc.last_ack_time = jiffies;
+	for (i = 0; i < snic->wq_count; i++) {
+		work_done += vnic_cq_service(&snic->cq[i],
+						work_to_do,
+						snic_wq_cmpl_handler_cont,
+						NULL);
+	}
+
+	return work_done;
+} /* end of snic_wq_cmpl_handler */
+
+void
+snic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
+{
+
+	struct snic_host_req *req = buf->os_buf;
+	struct snic *snic = vnic_dev_priv(wq->vdev);
+	struct snic_req_info *rqi = NULL;
+	unsigned long flags;
+
+	pci_unmap_single(snic->pdev, buf->dma_addr, buf->len, PCI_DMA_TODEVICE);
+
+	rqi = req_to_rqi(req);
+	spin_lock_irqsave(&snic->spl_cmd_lock, flags);
+	if (list_empty(&rqi->list)) {
+		spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
+		goto end;
+	}
+
+	SNIC_BUG_ON(rqi->list.next == NULL); /* if not added to spl_cmd_list */
+	list_del_init(&rqi->list);
+	spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
+
+	if (rqi->sge_va) {
+		snic_pci_unmap_rsp_buf(snic, rqi);
+		kfree((void *)rqi->sge_va);
+		rqi->sge_va = 0;
+	}
+	snic_req_free(snic, rqi);
+	SNIC_HOST_INFO(snic->shost, "snic_free_wq_buf .. freed.\n");
+
+end:
+	return;
+}
+
+/* Criteria to select work queue in multi queue mode */
+static int
+snic_select_wq(struct snic *snic)
+{
+	/* No multi queue support for now */
+	BUILD_BUG_ON(SNIC_WQ_MAX > 1);
+
+	return 0;
+}
+
+int
+snic_queue_wq_desc(struct snic *snic, void *os_buf, u16 len)
+{
+	dma_addr_t pa = 0;
+	unsigned long flags;
+	struct snic_fw_stats *fwstats = &snic->s_stats.fw;
+	long act_reqs;
+	int q_num = 0;
+
+	snic_print_desc(__func__, os_buf, len);
+
+	/* Map request buffer */
+	pa = pci_map_single(snic->pdev, os_buf, len, PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(snic->pdev, pa)) {
+		SNIC_HOST_ERR(snic->shost, "qdesc: PCI DMA Mapping Fail.\n");
+
+		return -EINVAL;
+	}
+
+	q_num = snic_select_wq(snic);
+
+	spin_lock_irqsave(&snic->wq_lock[q_num], flags);
+	if (!vnic_wq_desc_avail(snic->wq)) {
+		pci_unmap_single(snic->pdev, pa, len, PCI_DMA_TODEVICE);
+		spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
+		atomic64_inc(&snic->s_stats.misc.wq_alloc_fail);
+		SNIC_DBG("host = %d, WQ is Full\n", snic->shost->host_no);
+
+		return -ENOMEM;
+	}
+
+	snic_queue_wq_eth_desc(&snic->wq[q_num], os_buf, pa, len, 0, 0, 1);
+	spin_unlock_irqrestore(&snic->wq_lock[q_num], flags);
+
+	/* Update stats */
+	act_reqs = atomic64_inc_return(&fwstats->actv_reqs);
+	if (act_reqs > atomic64_read(&fwstats->max_actv_reqs))
+		atomic64_set(&fwstats->max_actv_reqs, act_reqs);
+
+	return 0;
+} /* end of snic_queue_wq_desc() */
+
+/*
+ * snic_handle_untagged_req: Adds snic specific requests to spl_cmd_list.
+ * Purpose : Used during driver unload to clean up the requests.
+ */
+void
+snic_handle_untagged_req(struct snic *snic, struct snic_req_info *rqi)
+{
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&rqi->list);
+
+	spin_lock_irqsave(&snic->spl_cmd_lock, flags);
+	list_add_tail(&rqi->list, &snic->spl_cmd_list);
+	spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
+}
+
+static struct snic_host_req *
+snic_req_align(struct snic_host_req *req)
+{
+	unsigned long sgl_ptr;
+
+	sgl_ptr = (unsigned long) req;
+	/* Cache sgl list allocated address before alignment */
+	if (sgl_ptr % SNIC_SG_DESC_ALIGN) {
+		req = (struct snic_host_req *)
+			   ((sgl_ptr + SNIC_SG_DESC_ALIGN - 1) &
+			    ~(SNIC_SG_DESC_ALIGN - 1));
+
+	}
+
+	return req;
+}
+
+/*
+ * snic_req_init:
+ * Allocates snic_req_info + snic_host_req + sgl data, and initializes.
+ */
+struct snic_req_info *
+snic_req_init(struct snic *snic, int sg_cnt)
+{
+	u8 typ;
+	struct snic_req_info *rqi = NULL;
+
+	typ = (sg_cnt <= SNIC_REQ_CACHE_DFLT_SGL) ?
+		SNIC_REQ_CACHE_DFLT_SGL : SNIC_REQ_CACHE_MAX_SGL;
+
+	rqi = mempool_alloc(snic->req_pool[typ], GFP_ATOMIC);
+	if (!rqi) {
+		atomic64_inc(&snic->s_stats.io.alloc_fail);
+		SNIC_HOST_ERR(snic->shost,
+			      "Failed to allocate memory from snic req pool id = %d\n",
+			      typ);
+		return rqi;
+	}
+
+	memset(rqi, 0, sizeof(*rqi));
+	rqi->rq_pool_type = typ;
+	rqi->start_time = jiffies;
+	rqi->req = (struct snic_host_req *) (rqi + 1);
+	rqi->req_len = sizeof(struct snic_host_req);
+	rqi->snic = snic;
+
+	BUILD_BUG_ON((sizeof(struct snic_req_info) % SNIC_SG_DESC_ALIGN) != 0);
+	BUILD_BUG_ON((sizeof(struct snic_host_req) % SNIC_SG_DESC_ALIGN) != 0);
+
+	rqi->req = snic_req_align(rqi->req);
+
+	if (sg_cnt == 0)
+		goto end;
+
+	rqi->req_len += (sg_cnt * sizeof(struct snic_sg_desc));
+
+	if (sg_cnt > atomic64_read(&snic->s_stats.io.max_sgl))
+		atomic64_set(&snic->s_stats.io.max_sgl, sg_cnt);
+
+	SNIC_BUG_ON(sg_cnt > SNIC_MAX_SG_DESC_CNT);
+	atomic64_inc(&snic->s_stats.io.sgl_cnt[sg_cnt - 1]);
+
+end:
+	memset(rqi->req, 0, rqi->req_len);
+
+	/* pre initialization of init_ctx to support req_to_rqi */
+	rqi->req->hdr.init_ctx = (u64) rqi;
+
+	SNIC_SCSI_DBG(snic->shost, "Req_alloc:rqi = %p allocatd.\n", rqi);
+
+	return rqi;
+} /* end of snic_req_init */
+
+/*
+ * snic_abort_req_init : Inits abort request.
+ */
+struct snic_host_req *
+snic_abort_req_init(struct snic *snic, struct snic_req_info *rqi)
+{
+	struct snic_host_req *req = NULL;
+
+	SNIC_BUG_ON(!rqi);
+
+	/* If abort to be issued second time, then reuse */
+	if (rqi->abort_req)
+		return rqi->abort_req;
+
+
+	req = mempool_alloc(snic->req_pool[SNIC_REQ_TM_CACHE], GFP_ATOMIC);
+	if (!req) {
+		SNIC_HOST_ERR(snic->shost, "abts:Failed to alloc tm req.\n");
+		WARN_ON_ONCE(1);
+
+		return NULL;
+	}
+
+	rqi->abort_req_unaligned = req;
+	rqi->abort_req = snic_req_align(req);
+	req = rqi->abort_req;
+	memset(req, 0, sizeof(struct snic_host_req));
+	/* pre initialization of init_ctx to support req_to_rqi */
+	req->hdr.init_ctx = (u64) rqi;
+
+	return req;
+} /* end of snic_abort_req_init */
+
+/*
+ * snic_dr_req_init : Inits device reset req
+ */
+struct snic_host_req *
+snic_dr_req_init(struct snic *snic, struct snic_req_info *rqi)
+{
+	struct snic_host_req *req = NULL;
+
+	SNIC_BUG_ON(!rqi);
+
+	req = mempool_alloc(snic->req_pool[SNIC_REQ_TM_CACHE], GFP_ATOMIC);
+	if (!req) {
+		SNIC_HOST_ERR(snic->shost, "dr:Failed to alloc tm req.\n");
+		WARN_ON_ONCE(1);
+
+		return NULL;
+	}
+
+	SNIC_BUG_ON(rqi->dr_req_unaligned != NULL);
+	rqi->dr_req_unaligned = req;
+	rqi->dr_req = snic_req_align(req);
+	req = rqi->dr_req;
+	memset(req, 0, sizeof(struct snic_host_req));
+	/* pre initialization of init_ctx to support req_to_rqi */
+	req->hdr.init_ctx = (u64) rqi;
+
+	return req;
+} /* end of snic_dr_req_init */
+
+/* frees snic_req_info and snic_host_req */
+void
+snic_req_free(struct snic *snic, struct snic_req_info *rqi)
+{
+	SNIC_BUG_ON(rqi->req == rqi->abort_req);
+	SNIC_BUG_ON(rqi->req == rqi->dr_req);
+	SNIC_BUG_ON(rqi->sge_va != 0);
+
+	SNIC_SCSI_DBG(snic->shost,
+		      "Req_free:rqi %p:ioreq %p:abt %p:dr %p\n",
+		      rqi, rqi->req, rqi->abort_req, rqi->dr_req);
+
+	if (rqi->abort_req_unaligned) {
+		mempool_free(rqi->abort_req_unaligned,
+			     snic->req_pool[SNIC_REQ_TM_CACHE]);
+	}
+
+	if (rqi->dr_req_unaligned) {
+		mempool_free(rqi->dr_req_unaligned,
+			     snic->req_pool[SNIC_REQ_TM_CACHE]);
+	}
+
+	mempool_free(rqi, snic->req_pool[rqi->rq_pool_type]);
+}
+
+void
+snic_pci_unmap_rsp_buf(struct snic *snic, struct snic_req_info *rqi)
+{
+	struct snic_sg_desc *sgd;
+
+	sgd = req_to_sgl(rqi_to_req(rqi));
+	SNIC_BUG_ON(sgd[0].addr == 0);
+	pci_unmap_single(snic->pdev,
+			 sgd[0].addr,
+			 sgd[0].len,
+			 PCI_DMA_FROMDEVICE);
+}
+
+/*
+ * snic_free_all_untagged_reqs: Walks through untagged reqs and frees them.
+ */
+void
+snic_free_all_untagged_reqs(struct snic *snic)
+{
+	struct snic_req_info *rqi;
+	struct list_head *cur, *nxt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&snic->spl_cmd_lock, flags);
+	list_for_each_safe(cur, nxt, &snic->spl_cmd_list) {
+		rqi = list_entry(cur, struct snic_req_info, list);
+		list_del_init(&rqi->list);
+		if (rqi->sge_va) {
+			snic_pci_unmap_rsp_buf(snic, rqi);
+			kfree((void *)rqi->sge_va);
+			rqi->sge_va = 0;
+		}
+
+		snic_req_free(snic, rqi);
+	}
+	spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
+}
+
+/*
+ * snic_release_untagged_req : Unlinks the untagged req and frees it.
+ */
+void
+snic_release_untagged_req(struct snic *snic, struct snic_req_info *rqi)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&snic->snic_lock, flags);
+	if (snic->in_remove) {
+		spin_unlock_irqrestore(&snic->snic_lock, flags);
+		goto end;
+	}
+	spin_unlock_irqrestore(&snic->snic_lock, flags);
+
+	spin_lock_irqsave(&snic->spl_cmd_lock, flags);
+	if (list_empty(&rqi->list)) {
+		spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
+		goto end;
+	}
+	list_del_init(&rqi->list);
+	spin_unlock_irqrestore(&snic->spl_cmd_lock, flags);
+	snic_req_free(snic, rqi);
+
+end:
+	return;
+}
+
+/* dump buf in hex fmt */
+void
+snic_hex_dump(char *pfx, char *data, int len)
+{
+	SNIC_INFO("%s Dumping Data of Len = %d\n", pfx, len);
+	snic_data_dump(pfx, data, len);
+}
+
+#define	LINE_BUFSZ	128	/* for snic_print_desc fn */
+static void
+snic_dump_desc(const char *fn, char *os_buf, int len)
+{
+	struct snic_host_req *req = (struct snic_host_req *) os_buf;
+	struct snic_fw_req *fwreq = (struct snic_fw_req *) os_buf;
+	struct snic_req_info *rqi = NULL;
+	char line[LINE_BUFSZ] = { '\0' };
+	char *cmd_str = NULL;
+
+	if (req->hdr.type >= SNIC_RSP_REPORT_TGTS_CMPL)
+		rqi = (struct snic_req_info *) fwreq->hdr.init_ctx;
+	else
+		rqi = (struct snic_req_info *) req->hdr.init_ctx;
+
+	SNIC_BUG_ON(rqi == NULL || rqi->req == NULL);
+	switch (req->hdr.type) {
+	case SNIC_REQ_REPORT_TGTS:
+		cmd_str = "report-tgt : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_REQ_REPORT_TGTS :");
+		break;
+
+	case SNIC_REQ_ICMND:
+		cmd_str = "icmnd : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_REQ_ICMND : 0x%x :",
+			 req->u.icmnd.cdb[0]);
+		break;
+
+	case SNIC_REQ_ITMF:
+		cmd_str = "itmf : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_REQ_ITMF :");
+		break;
+
+	case SNIC_REQ_HBA_RESET:
+		cmd_str = "hba reset :";
+		snprintf(line, LINE_BUFSZ, "SNIC_REQ_HBA_RESET :");
+		break;
+
+	case SNIC_REQ_EXCH_VER:
+		cmd_str = "exch ver : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_REQ_EXCH_VER :");
+		break;
+
+	case SNIC_REQ_TGT_INFO:
+		cmd_str = "tgt info : ";
+		break;
+
+	case SNIC_RSP_REPORT_TGTS_CMPL:
+		cmd_str = "report tgt cmpl : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_RSP_REPORT_TGTS_CMPL :");
+		break;
+
+	case SNIC_RSP_ICMND_CMPL:
+		cmd_str = "icmnd_cmpl : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_RSP_ICMND_CMPL : 0x%x :",
+			 rqi->req->u.icmnd.cdb[0]);
+		break;
+
+	case SNIC_RSP_ITMF_CMPL:
+		cmd_str = "itmf_cmpl : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_RSP_ITMF_CMPL :");
+		break;
+
+	case SNIC_RSP_HBA_RESET_CMPL:
+		cmd_str = "hba_reset_cmpl : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_RSP_HBA_RESET_CMPL :");
+		break;
+
+	case SNIC_RSP_EXCH_VER_CMPL:
+		cmd_str = "exch_ver_cmpl : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_RSP_EXCH_VER_CMPL :");
+		break;
+
+	case SNIC_MSG_ACK:
+		cmd_str = "msg ack : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_MSG_ACK :");
+		break;
+
+	case SNIC_MSG_ASYNC_EVNOTIFY:
+		cmd_str = "async notify : ";
+		snprintf(line, LINE_BUFSZ, "SNIC_MSG_ASYNC_EVNOTIFY :");
+		break;
+
+	default:
+		cmd_str = "unknown : ";
+		SNIC_BUG_ON(1);
+		break;
+	}
+
+	SNIC_INFO("%s:%s >>cmndid=%x:sg_cnt = %x:status = %x:ctx = %llx.\n",
+		  fn, line, req->hdr.cmnd_id, req->hdr.sg_cnt, req->hdr.status,
+		  req->hdr.init_ctx);
+
+	/* Enable it, to dump byte stream */
+	if (snic_log_level & 0x20)
+		snic_hex_dump(cmd_str, os_buf, len);
+} /* end of __snic_print_desc */
+
+void
+snic_print_desc(const char *fn, char *os_buf, int len)
+{
+	if (snic_log_level & SNIC_DESC_LOGGING)
+		snic_dump_desc(fn, os_buf, len);
+}
+
+void
+snic_calc_io_process_time(struct snic *snic, struct snic_req_info *rqi)
+{
+	u64 duration;
+
+	duration = jiffies - rqi->start_time;
+
+	if (duration > atomic64_read(&snic->s_stats.io.max_time))
+		atomic64_set(&snic->s_stats.io.max_time, duration);
+}
diff --git a/drivers/scsi/snic/snic_io.h b/drivers/scsi/snic/snic_io.h
new file mode 100644
index 0000000..47719d4
--- /dev/null
+++ b/drivers/scsi/snic/snic_io.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _SNIC_IO_H
+#define _SNIC_IO_H
+
+#define SNIC_DFLT_SG_DESC_CNT	32	/* Default descriptors for sgl */
+#define SNIC_MAX_SG_DESC_CNT	60	/* Max descriptor for sgl */
+#define SNIC_SG_DESC_ALIGN	16	/* Descriptor address alignment */
+
+/* SG descriptor for snic */
+struct snic_sg_desc {
+	__le64 addr;
+	__le32 len;
+	u32 _resvd;
+};
+
+struct snic_dflt_sgl {
+	struct snic_sg_desc sg_desc[SNIC_DFLT_SG_DESC_CNT];
+};
+
+struct snic_max_sgl {
+	struct snic_sg_desc sg_desc[SNIC_MAX_SG_DESC_CNT];
+};
+
+enum snic_req_cache_type {
+	SNIC_REQ_CACHE_DFLT_SGL = 0,	/* cache with default size sgl */
+	SNIC_REQ_CACHE_MAX_SGL,		/* cache with max size sgl */
+	SNIC_REQ_TM_CACHE,		/* cache for task mgmt reqs contains
+					   snic_host_req objects only*/
+	SNIC_REQ_MAX_CACHES		/* number of sgl caches */
+};
+
+/* IO state machine */
+enum snic_ioreq_state {
+	SNIC_IOREQ_NOT_INITED = 0,
+	SNIC_IOREQ_PENDING,
+	SNIC_IOREQ_ABTS_PENDING,
+	SNIC_IOREQ_ABTS_COMPLETE,
+	SNIC_IOREQ_LR_PENDING,
+	SNIC_IOREQ_LR_COMPLETE,
+	SNIC_IOREQ_COMPLETE,
+};
+
+struct snic;
+struct snic_host_req;
+
+/*
+ * snic_req_info : Contains info about IO, one per scsi command.
+ * Notes: Make sure that the structure is aligned to 16 B
+ * this helps in easy access to snic_req_info from snic_host_req
+ */
+struct snic_req_info {
+	struct list_head list;
+	struct snic_host_req *req;
+	u64	start_time;		/* start time in jiffies */
+	u16	rq_pool_type;		/* noticion of request pool type */
+	u16	req_len;		/* buf len passing to fw (req + sgl)*/
+	u32	tgt_id;
+
+	u32	tm_tag;
+	u8	io_cmpl:1;		/* sets to 1 when fw completes IO */
+	u8	_resvd1[3];
+	struct scsi_cmnd *sc;		/* Associated scsi cmd */
+	struct snic	*snic;		/* Associated snic */
+	u64	sge_va;			/* Pointer to Resp Buffer */
+	u64	snsbuf_va;
+
+	void *abort_req_unaligned;
+	struct snic_host_req *abort_req;
+	struct completion *abts_done;
+
+	void *dr_req_unaligned;
+	struct snic_host_req *dr_req;
+	struct completion *dr_done;
+};
+
+
+#define rqi_to_req(rqi)	\
+	((struct snic_host_req *) (((struct snic_req_info *)rqi)->req))
+
+#define req_to_rqi(req)	\
+	((struct snic_req_info *) (((struct snic_host_req *)req)->hdr.init_ctx))
+
+#define req_to_sgl(req)	\
+	((struct snic_sg_desc *) (((struct snic_host_req *)req)+1))
+
+struct snic_req_info *
+snic_req_init(struct snic *, int sg_cnt);
+void snic_req_free(struct snic *, struct snic_req_info *);
+void snic_calc_io_process_time(struct snic *, struct snic_req_info *);
+void snic_pci_unmap_rsp_buf(struct snic *, struct snic_req_info *);
+struct snic_host_req *
+snic_abort_req_init(struct snic *, struct snic_req_info *);
+struct snic_host_req *
+snic_dr_req_init(struct snic *, struct snic_req_info *);
+#endif /* _SNIC_IO_H */
-- 
1.8.5.4

