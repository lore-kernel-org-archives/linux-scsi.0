From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH v3 4/9] snic:Add snic target discovery
Date: Thu,  2 Apr 2015 02:04:43 -0700
Message-ID: <1427965488-12073-5-git-send-email-nmusini@cisco.com>
References: <1427965488-12073-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-6.cisco.com ([173.37.142.93]:19178 "EHLO
	alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbDBJH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2015 05:07:59 -0400
In-Reply-To: <1427965488-12073-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

snic_disc.h contains snic target structure definition.

snic_disc.c contains target discovery, setup, lookup, and cleanup

snic_ctl.c contains retrieval of snic capabilities includes
max ios, size, SGs per request, and max concurrent requests.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
* v3
- Cleaned up redundant comment.

 drivers/scsi/snic/snic_ctl.c  | 277 +++++++++++++++++++
 drivers/scsi/snic/snic_disc.c | 603 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/snic/snic_disc.h | 124 +++++++++
 3 files changed, 1004 insertions(+)
 create mode 100644 drivers/scsi/snic/snic_ctl.c
 create mode 100644 drivers/scsi/snic/snic_disc.c
 create mode 100644 drivers/scsi/snic/snic_disc.h

diff --git a/drivers/scsi/snic/snic_ctl.c b/drivers/scsi/snic/snic_ctl.c
new file mode 100644
index 0000000..4ff4cbe
--- /dev/null
+++ b/drivers/scsi/snic/snic_ctl.c
@@ -0,0 +1,277 @@
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
+#include <linux/ctype.h>
+
+#include "snic_io.h"
+#include "snic.h"
+#include "cq_enet_desc.h"
+#include "snic_fwint.h"
+#include "snic_os.h"
+
+/*
+ * snic_handle_link : Handles link flaps.
+ */
+void
+snic_handle_link(struct work_struct *work)
+{
+	struct snic *snic = container_of(work, struct snic, link_work);
+
+	if (snic->config.xpt_type != SNIC_DAS) {
+		SNIC_HOST_INFO(snic->shost, "Link Event Received.\n");
+		SNIC_ASSERT_NOT_IMPL(1);
+
+		return;
+	}
+
+	snic->link_status = vnic_dev_link_status(snic->vdev);
+	snic->link_down_cnt = vnic_dev_link_down_cnt(snic->vdev);
+	SNIC_HOST_INFO(snic->shost, "Link Event: Link %s.\n",
+		       ((snic->link_status) ? "Up" : "Down"));
+}
+
+
+/*
+ * snic_ver_enc : Encodes version str to int
+ * version string is similar to netmask string
+ */
+static int
+snic_ver_enc(const char *s)
+{
+	int v[4] = {0};
+	int  i = 0, x = 0;
+	char c;
+	const char *p = s;
+
+	/* validate version string */
+	if ((strlen(s) > 15) || (strlen(s) < 7))
+		goto end;
+
+	while ((c = *p++)) {
+		if (c == '.') {
+			i++;
+			continue;
+		}
+
+		if (i > 4 || !isdigit(c))
+			goto end;
+
+		v[i] = v[i] * 10 + (c - '0');
+	}
+
+	/* validate sub version numbers */
+	for (i = 3; i >= 0; i--)
+		if (v[i] > 0xff)
+			goto end;
+
+	x |= (v[0] << 24) | v[1] << 16 | v[2] << 8 | v[3];
+
+end:
+	if (x == 0) {
+		SNIC_ERR("Invalid version string [%s].\n", s);
+
+		return -1;
+	}
+
+	return x;
+} /* end of snic_ver_enc */
+
+/*
+ * snic_qeueue_exch_ver_req :
+ *
+ * Queues Exchange Version Request, to communicate host information
+ * in return, it gets firmware version details
+ */
+int
+snic_queue_exch_ver_req(struct snic *snic)
+{
+	struct snic_req_info *rqi = NULL;
+	struct snic_host_req *req = NULL;
+	int ret = 0;
+
+	SNIC_HOST_INFO(snic->shost, "Exch Ver Req Preparing...\n");
+
+	rqi = snic_req_init(snic, 0);
+	if (!rqi) {
+		SNIC_HOST_ERR(snic->shost,
+			      "Queuing Exch Ver Req failed, err = %d\n",
+			      ret);
+
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	req = rqi_to_req(rqi);
+
+	/* Initialize snic_host_req */
+	snic_io_hdr_enc(&req->hdr, SNIC_REQ_EXCH_VER, 0, SCSI_NO_TAG,
+			snic->config.hid, 0, (u64)rqi);
+	req->u.exch_ver.drvr_ver = snic_ver_enc(SNIC_DRV_VERSION);
+	req->u.exch_ver.os_type = SNIC_OS_TYPE;
+
+	snic_handle_untagged_req(snic, rqi);
+
+	ret = snic_queue_wq_desc(snic, req, sizeof(*req));
+	if (ret) {
+		snic_release_untagged_req(snic, rqi);
+		SNIC_HOST_ERR(snic->shost,
+			      "Queuing Exch Ver Req failed, err = %d\n",
+			      ret);
+		goto error;
+	}
+
+	SNIC_HOST_INFO(snic->shost, "Exch Ver Req is issued. ret = %d\n", ret);
+
+error:
+	return ret;
+} /* end of snic_queue_exch_ver_req */
+
+/*
+ * snic_io_exch_ver_cmpl_handler
+ */
+int
+snic_io_exch_ver_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
+{
+	struct snic_req_info *rqi = NULL;
+	u8 typ, hdr_stat;
+	u32 cmnd_id, hid, max_sgs;
+	u64 ctx = 0;
+	unsigned long flags;
+	int ret = 0;
+
+	SNIC_HOST_INFO(snic->shost, "Exch Ver Compl Received.\n");
+	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx);
+	SNIC_BUG_ON(snic->config.hid != hid);
+	rqi = (struct snic_req_info *) ctx;
+
+	if (hdr_stat) {
+		SNIC_HOST_ERR(snic->shost,
+			      "Exch Ver Completed w/ err status %d\n",
+			      hdr_stat);
+
+		goto exch_cmpl_end;
+	}
+
+	spin_lock_irqsave(&snic->snic_lock, flags);
+	snic->fwinfo.fw_ver = fwreq->u.exch_ver_cmpl.version;
+	snic->fwinfo.hid = fwreq->u.exch_ver_cmpl.hid;
+	snic->fwinfo.max_concur_ios = fwreq->u.exch_ver_cmpl.max_concur_ios;
+	snic->fwinfo.max_sgs_per_cmd = fwreq->u.exch_ver_cmpl.max_sgs_per_cmd;
+	snic->fwinfo.max_io_sz = fwreq->u.exch_ver_cmpl.max_io_sz;
+	snic->fwinfo.max_tgts = fwreq->u.exch_ver_cmpl.max_tgts;
+	snic->fwinfo.io_tmo = fwreq->u.exch_ver_cmpl.io_timeout;
+
+	SNIC_HOST_INFO(snic->shost,
+		       "vers %u hid %u max_concur_ios %u max_sgs_per_cmd %u max_io_sz %u max_tgts %u fw tmo %u\n",
+		       fwreq->u.exch_ver_cmpl.version,
+		       fwreq->u.exch_ver_cmpl.hid,
+		       fwreq->u.exch_ver_cmpl.max_concur_ios,
+		       fwreq->u.exch_ver_cmpl.max_sgs_per_cmd,
+		       fwreq->u.exch_ver_cmpl.max_io_sz,
+		       fwreq->u.exch_ver_cmpl.max_tgts,
+		       fwreq->u.exch_ver_cmpl.io_timeout);
+
+	SNIC_HOST_INFO(snic->shost,
+		       "HBA Capabilities = 0x%x\n",
+		       fwreq->u.exch_ver_cmpl.hba_cap);
+
+	/* Updating SGList size */
+	max_sgs = snic->fwinfo.max_sgs_per_cmd;
+	if (max_sgs && max_sgs < SNIC_MAX_SG_DESC_CNT) {
+		snic->shost->sg_tablesize = max_sgs;
+		SNIC_HOST_INFO(snic->shost, "Max SGs set to %d\n",
+			       snic->shost->sg_tablesize);
+	} else if (max_sgs > snic->shost->sg_tablesize) {
+		SNIC_HOST_INFO(snic->shost,
+			       "Target type %d Supports Larger Max SGList %d than driver's Max SG List %d.\n",
+			       snic->config.xpt_type, max_sgs,
+			       snic->shost->sg_tablesize);
+	}
+
+	if (snic->shost->can_queue > snic->fwinfo.max_concur_ios)
+		snic->shost->can_queue = snic->fwinfo.max_concur_ios;
+
+	snic->shost->max_sectors = snic->fwinfo.max_io_sz >> 9;
+	if (snic->fwinfo.wait)
+		complete(snic->fwinfo.wait);
+
+	spin_unlock_irqrestore(&snic->snic_lock, flags);
+
+exch_cmpl_end:
+	snic_release_untagged_req(snic, rqi);
+
+	SNIC_HOST_INFO(snic->shost, "Exch_cmpl Done, hdr_stat %d.\n", hdr_stat);
+
+	return ret;
+} /* end of snic_io_exch_ver_cmpl_handler */
+
+/*
+ * snic_get_conf
+ *
+ * Synchronous call, and Retrieves snic params.
+ */
+int
+snic_get_conf(struct snic *snic)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	unsigned long flags;
+	int ret;
+	int nr_retries = 3;
+
+	SNIC_HOST_INFO(snic->shost, "Retrieving snic params.\n");
+	spin_lock_irqsave(&snic->snic_lock, flags);
+	memset(&snic->fwinfo, 0, sizeof(snic->fwinfo));
+	snic->fwinfo.wait = &wait;
+	spin_unlock_irqrestore(&snic->snic_lock, flags);
+
+	/* Additional delay to handle HW Resource initialization. */
+	msleep(50);
+
+	/*
+	 * Exch ver req can be ignored by FW, if HW Resource initialization
+	 * is in progress, Hence retry.
+	 */
+	do {
+		ret = snic_queue_exch_ver_req(snic);
+		if (ret)
+			return ret;
+
+		wait_for_completion_timeout(&wait, msecs_to_jiffies(2000));
+		spin_lock_irqsave(&snic->snic_lock, flags);
+		ret = (snic->fwinfo.fw_ver != 0) ? 0 : -ETIMEDOUT;
+		if (ret)
+			SNIC_HOST_ERR(snic->shost,
+				      "Failed to retrieve snic params,\n");
+
+		/* Unset fwinfo.wait, on success or on last retry */
+		if (ret == 0 || nr_retries == 1)
+			snic->fwinfo.wait = NULL;
+
+		spin_unlock_irqrestore(&snic->snic_lock, flags);
+	} while (ret && --nr_retries);
+
+	return ret;
+} /* end of snic_get_info */
diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
new file mode 100644
index 0000000..bc6703e
--- /dev/null
+++ b/drivers/scsi/snic/snic_disc.c
@@ -0,0 +1,603 @@
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
+#include <linux/mempool.h>
+
+#include <scsi/scsi_tcq.h>
+
+#include "snic_disc.h"
+#include "snic.h"
+#include "snic_io.h"
+#include "snic_os.h"
+
+
+/* snic target types */
+static const char * const snic_tgt_type_str[] = {
+	[SNIC_TGT_DAS] = "DAS",
+	[SNIC_TGT_SAN] = "SAN",
+};
+
+static inline const char *
+snic_tgt_type_to_str(int typ)
+{
+	return ((typ > SNIC_TGT_NONE && typ <= SNIC_TGT_SAN) ?
+		 snic_tgt_type_str[typ] : "Unknown");
+}
+
+static const char * const snic_tgt_state_str[] = {
+	[SNIC_TGT_STAT_INIT]	= "INIT",
+	[SNIC_TGT_STAT_ONLINE]	= "ONLINE",
+	[SNIC_TGT_STAT_OFFLINE]	= "OFFLINE",
+	[SNIC_TGT_STAT_DEL]	= "DELETION IN PROGRESS",
+};
+
+const char *
+snic_tgt_state_to_str(int state)
+{
+	return ((state >= SNIC_TGT_STAT_INIT && state <= SNIC_TGT_STAT_DEL) ?
+		snic_tgt_state_str[state] : "UNKNOWN");
+}
+
+/*
+ * Initiate report_tgt req desc
+ */
+static void
+snic_report_tgt_init(struct snic_host_req *req, u32 hid, u8 *buf, u32 len,
+		     u64 rsp_buf_pa, u64 ctx)
+{
+	struct snic_sg_desc *sgd = NULL;
+
+
+	snic_io_hdr_enc(&req->hdr, SNIC_REQ_REPORT_TGTS, 0, SCSI_NO_TAG, hid,
+			1, ctx);
+
+	req->u.rpt_tgts.sg_cnt = 1;
+	sgd = req_to_sgl(req);
+	sgd[0].addr = cpu_to_le64(rsp_buf_pa);
+	sgd[0].len = cpu_to_le32(len);
+	sgd[0]._resvd = 0;
+	req->u.rpt_tgts.sg_addr = (u64) sgd;
+}
+
+/*
+ * snic_queue_report_tgt_req: Queues report target request.
+ */
+static int
+snic_queue_report_tgt_req(struct snic *snic)
+{
+	struct snic_req_info *rqi = NULL;
+	u32 ntgts, buf_len = 0;
+	u8 *buf = NULL;
+	dma_addr_t pa = 0;
+	int ret = 0;
+
+	rqi = snic_req_init(snic, 1);
+	if (!rqi) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	if (snic->fwinfo.max_tgts)
+		ntgts = min_t(u32, snic->fwinfo.max_tgts, snic->shost->max_id);
+	else
+		ntgts = snic->shost->max_id;
+
+	/* Allocate Response Buffer */
+	SNIC_BUG_ON(ntgts == 0);
+	buf_len = ntgts * sizeof(struct snic_tgt_id) + SNIC_SG_DESC_ALIGN;
+
+	buf = kzalloc(buf_len, GFP_KERNEL|GFP_DMA);
+	if (!buf) {
+		snic_req_free(snic, rqi);
+		SNIC_HOST_ERR(snic->shost, "Resp Buf Alloc Failed.\n");
+
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	SNIC_BUG_ON((((unsigned long)buf) % SNIC_SG_DESC_ALIGN) != 0);
+
+	pa = pci_map_single(snic->pdev, buf, buf_len, PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(snic->pdev, pa)) {
+		kfree(buf);
+		snic_req_free(snic, rqi);
+		SNIC_HOST_ERR(snic->shost,
+			      "Rpt-tgt rspbuf %p: PCI DMA Mapping Failed\n",
+			      buf);
+		ret = -EINVAL;
+
+		goto error;
+	}
+
+
+	SNIC_BUG_ON(pa == 0);
+	rqi->sge_va = (u64) buf;
+
+	snic_report_tgt_init(rqi->req,
+			     snic->config.hid,
+			     buf,
+			     buf_len,
+			     (u64)pa,
+			     (u64)rqi);
+
+	snic_handle_untagged_req(snic, rqi);
+
+	ret = snic_queue_wq_desc(snic, rqi->req, rqi->req_len);
+	if (ret) {
+		pci_unmap_single(snic->pdev, pa, buf_len, PCI_DMA_FROMDEVICE);
+		kfree(buf);
+		rqi->sge_va = 0;
+		snic_release_untagged_req(snic, rqi);
+		SNIC_HOST_ERR(snic->shost, "Queuing Report Tgts Failed.\n");
+
+		goto error;
+	}
+
+	SNIC_DISC_DBG(snic->shost, "Report Targets Issued.\n");
+
+	return ret;
+
+error:
+	SNIC_HOST_ERR(snic->shost,
+		      "Queuing Report Targets Failed, err = %d\n",
+		      ret);
+	return ret;
+} /* end of snic_queue_report_tgt_req */
+
+/* call into SML */
+static void
+snic_scsi_scan_tgt(struct work_struct *work)
+{
+	struct snic_tgt *tgt = container_of(work, struct snic_tgt, scan_work);
+	struct Scsi_Host *shost = dev_to_shost(&tgt->dev);
+	unsigned long flags;
+
+	SNIC_HOST_INFO(shost, "Scanning Target id 0x%x\n", tgt->id);
+	scsi_scan_target(&tgt->dev,
+			 tgt->channel,
+			 tgt->scsi_tgt_id,
+			 SCAN_WILD_CARD,
+			 1);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	tgt->flags &= ~SNIC_TGT_SCAN_PENDING;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+} /* end of snic_scsi_scan_tgt */
+
+/*
+ * snic_tgt_lookup :
+ */
+static struct snic_tgt *
+snic_tgt_lookup(struct snic *snic, struct snic_tgt_id *tgtid)
+{
+	struct list_head *cur, *nxt;
+	struct snic_tgt *tgt = NULL;
+
+	list_for_each_safe(cur, nxt, &snic->disc.tgt_list) {
+		tgt = list_entry(cur, struct snic_tgt, list);
+		if (tgt->id == tgtid->tgt_id)
+			return tgt;
+		tgt = NULL;
+	}
+
+	return tgt;
+} /* end of snic_tgt_lookup */
+
+/*
+ * snic_tgt_dev_release : Called on dropping last ref for snic_tgt object
+ */
+void
+snic_tgt_dev_release(struct device *dev)
+{
+	struct snic_tgt *tgt = dev_to_tgt(dev);
+
+	SNIC_HOST_INFO(snic_tgt_to_shost(tgt),
+		       "Target Device ID %d (%s) Permanently Deleted.\n",
+		       tgt->id,
+		       dev_name(dev));
+
+	SNIC_BUG_ON(!list_empty(&tgt->list));
+	kfree(tgt);
+}
+
+/*
+ * snic_tgt_del : work function to delete snic_tgt
+ */
+static void
+snic_tgt_del(struct work_struct *work)
+{
+	struct snic_tgt *tgt = container_of(work, struct snic_tgt, del_work);
+	struct Scsi_Host *shost = snic_tgt_to_shost(tgt);
+
+	if (tgt->flags & SNIC_TGT_SCAN_PENDING)
+		scsi_flush_work(shost);
+
+	/* Block IOs on child devices, stops new IOs */
+	scsi_target_block(&tgt->dev);
+
+	/* Cleanup IOs */
+	snic_tgt_scsi_abort_io(tgt);
+
+	/* Unblock IOs now, to flush if there are any. */
+	scsi_target_unblock(&tgt->dev, SDEV_TRANSPORT_OFFLINE);
+
+	/* Delete SCSI Target and sdevs */
+	scsi_remove_target(&tgt->dev);  /* ?? */
+	device_del(&tgt->dev);
+	put_device(&tgt->dev);
+} /* end of snic_tgt_del */
+
+/* snic_tgt_create: checks for existence of snic_tgt, if it doesn't
+ * it creates one.
+ */
+static struct snic_tgt *
+snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
+{
+	struct snic_tgt *tgt = NULL;
+	unsigned long flags;
+	int ret;
+
+	tgt = snic_tgt_lookup(snic, tgtid);
+	if (tgt) {
+		/* update the information if required */
+		return tgt;
+	}
+
+	tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
+	if (!tgt) {
+		SNIC_HOST_ERR(snic->shost, "Failure to allocate snic_tgt.\n");
+		ret = -ENOMEM;
+
+		return tgt;
+	}
+
+	INIT_LIST_HEAD(&tgt->list);
+	tgt->id = tgtid->tgt_id;
+	tgt->channel = 0;
+
+	SNIC_BUG_ON(tgtid->tgt_type > SNIC_TGT_SAN);
+	tgt->tdata.typ = tgtid->tgt_type;
+
+	/*
+	 * Plugging into SML Device Tree
+	 */
+	tgt->tdata.disc_id = 0;
+	tgt->state = SNIC_TGT_STAT_INIT;
+	device_initialize(&tgt->dev);
+	tgt->dev.parent = get_device(&snic->shost->shost_gendev);
+	tgt->dev.release = snic_tgt_dev_release;
+	INIT_WORK(&tgt->scan_work, snic_scsi_scan_tgt);
+	INIT_WORK(&tgt->del_work, snic_tgt_del);
+	switch (tgtid->tgt_type) {
+	case SNIC_TGT_DAS:
+		dev_set_name(&tgt->dev, "snic_das_tgt:%d:%d-%d",
+			     snic->shost->host_no, tgt->channel, tgt->id);
+		break;
+
+	case SNIC_TGT_SAN:
+		dev_set_name(&tgt->dev, "snic_san_tgt:%d:%d-%d",
+			     snic->shost->host_no, tgt->channel, tgt->id);
+		break;
+
+	default:
+		SNIC_HOST_INFO(snic->shost, "Target type Unknown Detected.\n");
+		dev_set_name(&tgt->dev, "snic_das_tgt:%d:%d-%d",
+			     snic->shost->host_no, tgt->channel, tgt->id);
+		break;
+	}
+
+	spin_lock_irqsave(snic->shost->host_lock, flags);
+	list_add_tail(&tgt->list, &snic->disc.tgt_list);
+	tgt->scsi_tgt_id = snic->disc.nxt_tgt_id++;
+	tgt->state = SNIC_TGT_STAT_ONLINE;
+	spin_unlock_irqrestore(snic->shost->host_lock, flags);
+
+	SNIC_HOST_INFO(snic->shost,
+		       "Tgt %d, type = %s detected. Adding..\n",
+		       tgt->id, snic_tgt_type_to_str(tgt->tdata.typ));
+
+	ret = device_add(&tgt->dev);
+	if (ret) {
+		SNIC_HOST_ERR(snic->shost,
+			      "Snic Tgt: device_add, with err = %d\n",
+			      ret);
+
+		put_device(&snic->shost->shost_gendev);
+		kfree(tgt);
+		tgt = NULL;
+
+		return tgt;
+	}
+
+	SNIC_HOST_INFO(snic->shost, "Scanning %s.\n", dev_name(&tgt->dev));
+
+	scsi_queue_work(snic->shost, &tgt->scan_work);
+
+	return tgt;
+} /* end of snic_tgt_create */
+
+/* Handler for discovery */
+void
+snic_handle_tgt_disc(struct work_struct *work)
+{
+	struct snic *snic = container_of(work, struct snic, tgt_work);
+	struct snic_tgt_id *tgtid = NULL;
+	struct snic_tgt *tgt = NULL;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&snic->snic_lock, flags);
+	if (snic->in_remove) {
+		spin_unlock_irqrestore(&snic->snic_lock, flags);
+		kfree(snic->disc.rtgt_info);
+
+		return;
+	}
+	spin_unlock_irqrestore(&snic->snic_lock, flags);
+
+	mutex_lock(&snic->disc.mutex);
+	/* Discover triggered during disc in progress */
+	if (snic->disc.req_cnt) {
+		snic->disc.state = SNIC_DISC_DONE;
+		snic->disc.req_cnt = 0;
+		mutex_unlock(&snic->disc.mutex);
+		kfree(snic->disc.rtgt_info);
+		snic->disc.rtgt_info = NULL;
+
+		SNIC_HOST_INFO(snic->shost, "tgt_disc: Discovery restart.\n");
+		/* Start Discovery Again */
+		snic_disc_start(snic);
+
+		return;
+	}
+
+	tgtid = (struct snic_tgt_id *)snic->disc.rtgt_info;
+
+	SNIC_BUG_ON(snic->disc.rtgt_cnt == 0 || tgtid == NULL);
+
+	for (i = 0; i < snic->disc.rtgt_cnt; i++) {
+		tgt = snic_tgt_create(snic, &tgtid[i]);
+		if (!tgt) {
+			int buf_sz = snic->disc.rtgt_cnt * sizeof(*tgtid);
+
+			SNIC_HOST_ERR(snic->shost, "Failed to create tgt.\n");
+			snic_hex_dump("rpt_tgt_rsp", (char *)tgtid, buf_sz);
+			break;
+		}
+	}
+
+	snic->disc.rtgt_info = NULL;
+	snic->disc.state = SNIC_DISC_DONE;
+	mutex_unlock(&snic->disc.mutex);
+
+	SNIC_HOST_INFO(snic->shost, "Discovery Completed.\n");
+
+	kfree(tgtid);
+} /* end of snic_handle_tgt_disc */
+
+
+int
+snic_report_tgt_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
+{
+
+	u8 typ, cmpl_stat;
+	u32 cmnd_id, hid;
+	u64 ctx;
+	struct snic_req_info *rqi = NULL;
+	struct snic_tgt_id *tgtid;
+	int i, ret = 0;
+
+	snic_io_hdr_dec(&fwreq->hdr, &typ, &cmpl_stat, &cmnd_id, &hid, &ctx);
+	rqi = (struct snic_req_info *)ctx;
+	tgtid = (struct snic_tgt_id *) (rqi->sge_va);
+
+	if (fwreq->u.rpt_tgts_cmpl.tgt_cnt == 0) {
+		SNIC_HOST_ERR(snic->shost, "No Targets Found on this host.\n");
+		ret = 1;
+
+		goto end;
+	}
+
+	/* printing list of targets here */
+	SNIC_HOST_INFO(snic->shost,
+		       "Target Count = %d\n",
+		       fwreq->u.rpt_tgts_cmpl.tgt_cnt);
+
+	SNIC_BUG_ON(fwreq->u.rpt_tgts_cmpl.tgt_cnt > snic->fwinfo.max_tgts);
+
+	for (i = 0; i < fwreq->u.rpt_tgts_cmpl.tgt_cnt; i++)
+		SNIC_HOST_INFO(snic->shost, "Tgt id = 0x%x\n", tgtid[i].tgt_id);
+
+	/*
+	 * Queue work for further processing,
+	 * Response Buffer Memory is freed after creating targets
+	 */
+	snic->disc.rtgt_cnt = fwreq->u.rpt_tgts_cmpl.tgt_cnt;
+	snic->disc.rtgt_info = (u8 *)tgtid;
+	queue_work(snic_glob->event_q, &snic->tgt_work);
+	ret = 0;
+
+end:
+	/* Unmap Response Buffer */
+	snic_pci_unmap_rsp_buf(snic, rqi);
+	if (ret)
+		kfree(tgtid);
+
+	rqi->sge_va = 0;
+	snic_release_untagged_req(snic, rqi);
+
+	return ret;
+} /* end of snic_report_tgt_cmpl_handler */
+
+/* Discovery init fn */
+void
+snic_disc_init(struct snic_disc *disc)
+{
+	INIT_LIST_HEAD(&disc->tgt_list);
+	mutex_init(&disc->mutex);
+	disc->disc_id = 0;
+	disc->nxt_tgt_id = 0;
+	disc->state = SNIC_DISC_INIT;
+	disc->req_cnt = 0;
+	disc->rtgt_cnt = 0;
+	disc->rtgt_info = NULL;
+	disc->cb = NULL;
+} /* end of snic_disc_init */
+
+/* Discovery, uninit fn */
+void
+snic_disc_term(struct snic *snic)
+{
+	struct snic_disc *disc = &snic->disc;
+
+	mutex_lock(&disc->mutex);
+	if (disc->req_cnt) {
+		disc->req_cnt = 0;
+		SNIC_SCSI_DBG(snic->shost, "Terminating Discovery.\n");
+	}
+	mutex_unlock(&disc->mutex);
+}
+
+/*
+ * snic_disc_start: Discovery Start ...
+ */
+int
+snic_disc_start(struct snic *snic)
+{
+	struct snic_disc *disc = &snic->disc;
+	int ret = 0;
+
+	SNIC_SCSI_DBG(snic->shost, "Discovery Start.\n");
+
+	mutex_lock(&disc->mutex);
+	if (disc->state == SNIC_DISC_PENDING) {
+		disc->req_cnt++;
+		mutex_unlock(&disc->mutex);
+
+		return ret;
+	}
+	disc->state = SNIC_DISC_PENDING;
+	mutex_unlock(&disc->mutex);
+
+	ret = snic_queue_report_tgt_req(snic);
+	if (ret)
+		SNIC_HOST_INFO(snic->shost, "Discovery Failed, err=%d.\n", ret);
+
+	return ret;
+} /* end of snic_disc_start */
+
+/*
+ * snic_disc_work :
+ */
+void
+snic_handle_disc(struct work_struct *work)
+{
+	struct snic *snic = container_of(work, struct snic, disc_work);
+	int ret = 0;
+
+	SNIC_HOST_INFO(snic->shost, "disc_work: Discovery\n");
+
+	ret = snic_disc_start(snic);
+	if (ret)
+		goto disc_err;
+
+disc_err:
+	SNIC_HOST_ERR(snic->shost,
+		      "disc_work: Discovery Failed w/ err = %d\n",
+		      ret);
+} /* end of snic_disc_work */
+
+/*
+ * snic_tgt_del_all : cleanup all snic targets
+ * Called on unbinding the interface
+ */
+void
+snic_tgt_del_all(struct snic *snic)
+{
+	struct snic_tgt *tgt = NULL;
+	struct list_head *cur, *nxt;
+	unsigned long flags;
+
+	mutex_lock(&snic->disc.mutex);
+	spin_lock_irqsave(snic->shost->host_lock, flags);
+
+	list_for_each_safe(cur, nxt, &snic->disc.tgt_list) {
+		tgt = list_entry(cur, struct snic_tgt, list);
+		tgt->state = SNIC_TGT_STAT_DEL;
+		list_del_init(&tgt->list);
+		SNIC_HOST_INFO(snic->shost, "Tgt %d q'ing for del\n", tgt->id);
+		queue_work(snic_glob->event_q, &tgt->del_work);
+		tgt = NULL;
+	}
+	spin_unlock_irqrestore(snic->shost->host_lock, flags);
+
+	scsi_flush_work(snic->shost);
+	mutex_unlock(&snic->disc.mutex);
+} /* end of snic_tgt_del_all */
+#ifdef SNIC_TGTINFO_ENABLE
+
+/*
+ * snic_queue_get_tgtinfo_req: Queues get target info request.
+ */
+int
+snic_queue_get_tgtinfo_req(struct snic *snic, u32 tgt_id)
+{
+	struct snic_req_info *rqi = NULL;
+	struct snic_host_req *req = NULL;
+	int ret = 0;
+
+	rqi = snic_req_init(snic, 0);
+	if (!rqi) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	req = rqi->req;
+
+	snic_handle_untagged_req(snic, rqi);
+
+	snic_io_hdr_enc(&req->hdr,
+			SNIC_REQ_TGT_INFO,
+			0 /* Status */,
+			SCSI_NO_TAG,
+			snic->config.hid,
+			0 /* SG Count */,
+			(u64)rqi /* Initiator Context */);
+
+	req->u.tgt_info.tgt_id = tgt_id;
+	ret = snic_queue_wq_desc(snic, rqi->req, rqi->req_len);
+	if (ret) {
+		snic_release_untagged_req(snic, rqi);
+		SNIC_HOST_ERR(snic->shost, "Queuing Get Tgt Info Failed.\n");
+
+		goto error;
+	}
+
+	SNIC_DISC_DBG(snic->shost, "Get Tgt Info Issued for Tgt Id %d.\n",
+		      tgt_id);
+
+	return ret;
+
+error:
+	SNIC_HOST_ERR(snic->shost,
+		      "Queuing Get Target Info Failed for Tgt %d, err = %d\n",
+		      tgt_id,
+		      ret);
+	return ret;
+} /* end of snic_queue_tgtinfo_req */
+#endif
diff --git a/drivers/scsi/snic/snic_disc.h b/drivers/scsi/snic/snic_disc.h
new file mode 100644
index 0000000..97fa3f5
--- /dev/null
+++ b/drivers/scsi/snic/snic_disc.h
@@ -0,0 +1,124 @@
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
+#ifndef __SNIC_DISC_H
+#define __SNIC_DISC_H
+
+#include "snic_fwint.h"
+
+enum snic_disc_state {
+	SNIC_DISC_NONE,
+	SNIC_DISC_INIT,
+	SNIC_DISC_PENDING,
+	SNIC_DISC_DONE
+};
+
+struct snic;
+struct snic_disc {
+	struct list_head tgt_list;
+	enum snic_disc_state state;
+	struct mutex mutex;
+	u16	disc_id;
+	u8	req_cnt;
+	u32	nxt_tgt_id;
+	u32	rtgt_cnt;
+	u8	*rtgt_info;
+	struct delayed_work disc_timeout;
+	void (*cb)(struct snic *);
+};
+
+#define SNIC_TGT_NAM_LEN	16
+
+enum snic_tgt_state {
+	SNIC_TGT_STAT_NONE,
+	SNIC_TGT_STAT_INIT,
+	SNIC_TGT_STAT_ONLINE,	/* Target is Online */
+	SNIC_TGT_STAT_OFFLINE,	/* Target is Offline */
+	SNIC_TGT_STAT_DEL,
+};
+
+struct snic_tgt_priv {
+	struct list_head list;
+	enum snic_tgt_type typ;
+	u16 disc_id;
+	char *name[SNIC_TGT_NAM_LEN];
+
+	union {
+		/*DAS Target specific info */
+		/*SAN Target specific info */
+		u8 dummmy;
+	} u;
+};
+
+/* snic tgt flags */
+#define SNIC_TGT_SCAN_PENDING	0x01
+
+struct snic_tgt {
+	struct list_head list;
+	u16	id;
+	u16	channel;
+	u32	flags;
+	u32	scsi_tgt_id;
+	enum snic_tgt_state state;
+	struct device dev;
+	struct work_struct scan_work;
+	struct work_struct del_work;
+	struct snic_tgt_priv tdata;
+};
+
+
+struct snic_fw_req;
+
+void snic_disc_init(struct snic_disc *);
+int snic_disc_start(struct snic *);
+void snic_disc_term(struct snic *);
+int snic_report_tgt_cmpl_handler(struct snic *, struct snic_fw_req *);
+int snic_tgtinfo_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq);
+void snic_process_report_tgts_rsp(struct work_struct *);
+void snic_handle_tgt_disc(struct work_struct *);
+void snic_handle_disc(struct work_struct *);
+void snic_tgt_dev_release(struct device *);
+void snic_tgt_del_all(struct snic *);
+
+#define dev_to_tgt(d) \
+	container_of(d, struct snic_tgt, dev)
+
+static inline int
+is_snic_target(struct device *dev)
+{
+	return dev->release == snic_tgt_dev_release;
+}
+
+#define starget_to_tgt(st)	\
+	(is_snic_target(((struct scsi_target *) st)->dev.parent) ? \
+		dev_to_tgt(st->dev.parent) : NULL)
+
+#define snic_tgt_to_shost(t)	\
+	dev_to_shost(t->dev.parent)
+
+static inline int
+snic_tgt_chkready(struct snic_tgt *tgt)
+{
+	if (tgt->state == SNIC_TGT_STAT_ONLINE)
+		return 0;
+	else
+		return DID_NO_CONNECT << 16;
+}
+
+const char *snic_tgt_state_to_str(int);
+int snic_tgt_scsi_abort_io(struct snic_tgt *);
+#endif /* end of  __SNIC_DISC_H */
-- 
1.8.5.4

