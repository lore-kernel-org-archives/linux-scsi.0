From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 6/8] lpfc 8.3.4: Add bsg (SGIOv4) support for ELS/CT support
Date: Sun, 19 Jul 2009 10:01:32 -0400
Message-ID: <1248012092.15009.32.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34696 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZGSOBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:34 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1Ym2021600
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Add bsg (SGIOv4) support for sending and receiving ELS, CT commands

This patch adds a new file, lpfc_bsg.c.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/Makefile    |    2 
 drivers/scsi/lpfc/lpfc.h      |   11 
 drivers/scsi/lpfc/lpfc_attr.c |    3 
 drivers/scsi/lpfc/lpfc_bsg.c  |  904 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_crtn.h |    8 
 drivers/scsi/lpfc/lpfc_ct.c   |    2 
 drivers/scsi/lpfc/lpfc_els.c  |    2 
 drivers/scsi/lpfc/lpfc_init.c |    3 
 drivers/scsi/lpfc/lpfc_nl.h   |   20 +
 drivers/scsi/lpfc/lpfc_scsi.c |    1 
 10 files changed, 954 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_bsg.c

--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -28,4 +28,4 @@ obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	\
 	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o lpfc_scsi.o lpfc_attr.o \
-	lpfc_vport.o lpfc_debugfs.o
+	lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -441,6 +441,12 @@ enum intr_type_t {
 	MSIX,
 };
 
+struct unsol_rcv_ct_ctx {
+	uint32_t ctxt_id;
+	uint32_t SID;
+	uint32_t oxid;
+};
+
 struct lpfc_hba {
 	/* SCSI interface function jump table entries */
 	int (*lpfc_new_scsi_buf)
@@ -776,6 +782,11 @@ struct lpfc_hba {
 	uint8_t valid_vlan;
 	uint16_t vlan_id;
 	struct list_head fcf_conn_rec_list;
+
+	struct mutex ct_event_mutex; /* synchronize access to ct_ev_waiters */
+	struct list_head ct_ev_waiters;
+	struct unsol_rcv_ct_ctx ct_ctx[64];
+	uint32_t ctx_idx;
 };
 
 static inline struct Scsi_Host *
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4132,6 +4132,9 @@ struct fc_function_template lpfc_transport_functions = {
 	.vport_disable = lpfc_vport_disable,
 
 	.set_vport_symbolic_name = lpfc_set_vport_symbolic_name,
+
+	.bsg_request = lpfc_bsg_request,
+	.bsg_timeout = lpfc_bsg_timeout,
 };
 
 struct fc_function_template lpfc_vport_transport_functions = {
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -0,0 +1,904 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2009 Emulex.  All rights reserved.                *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+
+#include <linux/interrupt.h>
+#include <linux/mempool.h>
+#include <linux/pci.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_bsg_fc.h>
+
+#include "lpfc_hw4.h"
+#include "lpfc_hw.h"
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
+#include "lpfc_scsi.h"
+#include "lpfc.h"
+#include "lpfc_logmsg.h"
+#include "lpfc_crtn.h"
+#include "lpfc_vport.h"
+#include "lpfc_version.h"
+
+/**
+ * lpfc_bsg_rport_ct - send a CT command from a bsg request
+ * @job: fc_bsg_job to handle
+ */
+static int
+lpfc_bsg_rport_ct(struct fc_bsg_job *job)
+{
+	struct Scsi_Host *shost = job->shost;
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct ulp_bde64 *bpl = NULL;
+	uint32_t timeout;
+	struct lpfc_iocbq *cmdiocbq = NULL;
+	struct lpfc_iocbq *rspiocbq = NULL;
+	IOCB_t *cmd;
+	IOCB_t *rsp;
+	struct lpfc_dmabuf *bmp = NULL;
+	int request_nseg;
+	int reply_nseg;
+	struct scatterlist *sgel = NULL;
+	int numbde;
+	dma_addr_t busaddr;
+	int rc = 0;
+
+	/* in case no data is transferred */
+	job->reply->reply_payload_rcv_len = 0;
+
+	if (!lpfc_nlp_get(ndlp)) {
+		job->reply->result = -ENODEV;
+		return 0;
+	}
+
+	if (ndlp->nlp_flag & NLP_ELS_SND_MASK) {
+		rc = -ENODEV;
+		goto free_ndlp_exit;
+	}
+
+	spin_lock_irq(shost->host_lock);
+	cmdiocbq = lpfc_sli_get_iocbq(phba);
+	if (!cmdiocbq) {
+		rc = -ENOMEM;
+		spin_unlock_irq(shost->host_lock);
+		goto free_ndlp_exit;
+	}
+	cmd = &cmdiocbq->iocb;
+
+	rspiocbq = lpfc_sli_get_iocbq(phba);
+	if (!rspiocbq) {
+		rc = -ENOMEM;
+		goto free_cmdiocbq;
+	}
+	spin_unlock_irq(shost->host_lock);
+
+	rsp = &rspiocbq->iocb;
+
+	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!bmp) {
+		rc = -ENOMEM;
+		spin_lock_irq(shost->host_lock);
+		goto free_rspiocbq;
+	}
+
+	spin_lock_irq(shost->host_lock);
+	bmp->virt = lpfc_mbuf_alloc(phba, 0, &bmp->phys);
+	if (!bmp->virt) {
+		rc = -ENOMEM;
+		goto free_bmp;
+	}
+	spin_unlock_irq(shost->host_lock);
+
+	INIT_LIST_HEAD(&bmp->list);
+	bpl = (struct ulp_bde64 *) bmp->virt;
+
+	request_nseg = pci_map_sg(phba->pcidev, job->request_payload.sg_list,
+				  job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	for_each_sg(job->request_payload.sg_list, sgel, request_nseg, numbde) {
+		busaddr = sg_dma_address(sgel);
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		bpl->tus.f.bdeSize = sg_dma_len(sgel);
+		bpl->tus.w = cpu_to_le32(bpl->tus.w);
+		bpl->addrLow = cpu_to_le32(putPaddrLow(busaddr));
+		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
+		bpl++;
+	}
+
+	reply_nseg = pci_map_sg(phba->pcidev, job->reply_payload.sg_list,
+				job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	for_each_sg(job->reply_payload.sg_list, sgel, reply_nseg, numbde) {
+		busaddr = sg_dma_address(sgel);
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+		bpl->tus.f.bdeSize = sg_dma_len(sgel);
+		bpl->tus.w = cpu_to_le32(bpl->tus.w);
+		bpl->addrLow = cpu_to_le32(putPaddrLow(busaddr));
+		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
+		bpl++;
+	}
+
+	cmd->un.genreq64.bdl.ulpIoTag32 = 0;
+	cmd->un.genreq64.bdl.addrHigh = putPaddrHigh(bmp->phys);
+	cmd->un.genreq64.bdl.addrLow = putPaddrLow(bmp->phys);
+	cmd->un.genreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
+	cmd->un.genreq64.bdl.bdeSize =
+		(request_nseg + reply_nseg) * sizeof(struct ulp_bde64);
+	cmd->ulpCommand = CMD_GEN_REQUEST64_CR;
+	cmd->un.genreq64.w5.hcsw.Fctl = (SI | LA);
+	cmd->un.genreq64.w5.hcsw.Dfctl = 0;
+	cmd->un.genreq64.w5.hcsw.Rctl = FC_UNSOL_CTL;
+	cmd->un.genreq64.w5.hcsw.Type = FC_COMMON_TRANSPORT_ULP;
+	cmd->ulpBdeCount = 1;
+	cmd->ulpLe = 1;
+	cmd->ulpClass = CLASS3;
+	cmd->ulpContext = ndlp->nlp_rpi;
+	cmd->ulpOwner = OWN_CHIP;
+	cmdiocbq->vport = phba->pport;
+	cmdiocbq->context1 = NULL;
+	cmdiocbq->context2 = NULL;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
+
+	timeout = phba->fc_ratov * 2;
+	job->dd_data = cmdiocbq;
+
+	rc = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq, rspiocbq,
+					timeout + LPFC_DRVR_TIMEOUT);
+
+	if (rc != IOCB_TIMEDOUT) {
+		pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+			     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+		pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+			     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	}
+
+	if (rc == IOCB_TIMEDOUT) {
+		lpfc_sli_release_iocbq(phba, rspiocbq);
+		rc = -EACCES;
+		goto free_ndlp_exit;
+	}
+
+	if (rc != IOCB_SUCCESS) {
+		rc = -EACCES;
+		goto free_outdmp;
+	}
+
+	if (rsp->ulpStatus) {
+		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
+			switch (rsp->un.ulpWord[4] & 0xff) {
+			case IOERR_SEQUENCE_TIMEOUT:
+				rc = -ETIMEDOUT;
+				break;
+			case IOERR_INVALID_RPI:
+				rc = -EFAULT;
+				break;
+			default:
+				rc = -EACCES;
+				break;
+			}
+			goto free_outdmp;
+		}
+	} else
+		job->reply->reply_payload_rcv_len =
+			rsp->un.genreq64.bdl.bdeSize;
+
+free_outdmp:
+	spin_lock_irq(shost->host_lock);
+	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
+free_bmp:
+	kfree(bmp);
+free_rspiocbq:
+	lpfc_sli_release_iocbq(phba, rspiocbq);
+free_cmdiocbq:
+	lpfc_sli_release_iocbq(phba, cmdiocbq);
+	spin_unlock_irq(shost->host_lock);
+free_ndlp_exit:
+	lpfc_nlp_put(ndlp);
+
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	/* complete the job back to userspace */
+	job->job_done(job);
+
+	return 0;
+}
+
+/**
+ * lpfc_bsg_rport_els - send an ELS command from a bsg request
+ * @job: fc_bsg_job to handle
+ */
+static int
+lpfc_bsg_rport_els(struct fc_bsg_job *job)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct lpfc_nodelist *ndlp = rdata->pnode;
+
+	uint32_t elscmd;
+	uint32_t cmdsize;
+	uint32_t rspsize;
+	struct lpfc_iocbq *rspiocbq;
+	struct lpfc_iocbq *cmdiocbq;
+	IOCB_t *rsp;
+	uint16_t rpi = 0;
+	struct lpfc_dmabuf *pcmd;
+	struct lpfc_dmabuf *prsp;
+	struct lpfc_dmabuf *pbuflist = NULL;
+	struct ulp_bde64 *bpl;
+	int iocb_status;
+	int request_nseg;
+	int reply_nseg;
+	struct scatterlist *sgel = NULL;
+	int numbde;
+	dma_addr_t busaddr;
+	int rc = 0;
+
+	/* in case no data is transferred */
+	job->reply->reply_payload_rcv_len = 0;
+
+	if (!lpfc_nlp_get(ndlp)) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	elscmd = job->request->rqst_data.r_els.els_code;
+	cmdsize = job->request_payload.payload_len;
+	rspsize = job->reply_payload.payload_len;
+	rspiocbq = lpfc_sli_get_iocbq(phba);
+	if (!rspiocbq) {
+		lpfc_nlp_put(ndlp);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rsp = &rspiocbq->iocb;
+	rpi = ndlp->nlp_rpi;
+
+	cmdiocbq = lpfc_prep_els_iocb(phba->pport, 1, cmdsize, 0, ndlp,
+				      ndlp->nlp_DID, elscmd);
+
+	if (!cmdiocbq) {
+		lpfc_sli_release_iocbq(phba, rspiocbq);
+		return -EIO;
+	}
+
+	job->dd_data = cmdiocbq;
+	pcmd = (struct lpfc_dmabuf *) cmdiocbq->context2;
+	prsp = (struct lpfc_dmabuf *) pcmd->list.next;
+
+	lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
+	kfree(pcmd);
+	lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
+	kfree(prsp);
+	cmdiocbq->context2 = NULL;
+
+	pbuflist = (struct lpfc_dmabuf *) cmdiocbq->context3;
+	bpl = (struct ulp_bde64 *) pbuflist->virt;
+
+	request_nseg = pci_map_sg(phba->pcidev, job->request_payload.sg_list,
+				  job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	for_each_sg(job->request_payload.sg_list, sgel, request_nseg, numbde) {
+		busaddr = sg_dma_address(sgel);
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		bpl->tus.f.bdeSize = sg_dma_len(sgel);
+		bpl->tus.w = cpu_to_le32(bpl->tus.w);
+		bpl->addrLow = cpu_to_le32(putPaddrLow(busaddr));
+		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
+		bpl++;
+	}
+
+	reply_nseg = pci_map_sg(phba->pcidev, job->reply_payload.sg_list,
+				job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	for_each_sg(job->reply_payload.sg_list, sgel, reply_nseg, numbde) {
+		busaddr = sg_dma_address(sgel);
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+		bpl->tus.f.bdeSize = sg_dma_len(sgel);
+		bpl->tus.w = cpu_to_le32(bpl->tus.w);
+		bpl->addrLow = cpu_to_le32(putPaddrLow(busaddr));
+		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
+		bpl++;
+	}
+
+	cmdiocbq->iocb.un.elsreq64.bdl.bdeSize =
+		(request_nseg + reply_nseg) * sizeof(struct ulp_bde64);
+	cmdiocbq->iocb.ulpContext = rpi;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->context1 = NULL;
+	cmdiocbq->context2 = NULL;
+
+	iocb_status = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
+					rspiocbq, (phba->fc_ratov * 2)
+					       + LPFC_DRVR_TIMEOUT);
+
+	/* release the new ndlp once the iocb completes */
+	lpfc_nlp_put(ndlp);
+	if (iocb_status != IOCB_TIMEDOUT) {
+		pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+			     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+		pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+			     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	}
+
+	if (iocb_status == IOCB_SUCCESS) {
+		if (rsp->ulpStatus == IOSTAT_SUCCESS) {
+			job->reply->reply_payload_rcv_len =
+				rsp->un.elsreq64.bdl.bdeSize;
+			rc = 0;
+		} else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
+			struct fc_bsg_ctels_reply *els_reply;
+			/* LS_RJT data returned in word 4 */
+			uint8_t *rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
+
+			els_reply = &job->reply->reply_data.ctels_reply;
+			job->reply->result = 0;
+			els_reply->status = FC_CTELS_STATUS_REJECT;
+			els_reply->rjt_data.action = rjt_data[0];
+			els_reply->rjt_data.reason_code = rjt_data[1];
+			els_reply->rjt_data.reason_explanation = rjt_data[2];
+			els_reply->rjt_data.vendor_unique = rjt_data[3];
+		} else
+			rc = -EIO;
+	} else
+		rc = -EIO;
+
+	if (iocb_status != IOCB_TIMEDOUT)
+		lpfc_els_free_iocb(phba, cmdiocbq);
+
+	lpfc_sli_release_iocbq(phba, rspiocbq);
+
+out:
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	/* complete the job back to userspace */
+	job->job_done(job);
+
+	return 0;
+}
+
+struct lpfc_ct_event {
+	struct list_head node;
+	int ref;
+	wait_queue_head_t wq;
+
+	/* Event type and waiter identifiers */
+	uint32_t type_mask;
+	uint32_t req_id;
+	uint32_t reg_id;
+
+	/* next two flags are here for the auto-delete logic */
+	unsigned long wait_time_stamp;
+	int waiting;
+
+	/* seen and not seen events */
+	struct list_head events_to_get;
+	struct list_head events_to_see;
+};
+
+struct event_data {
+	struct list_head node;
+	uint32_t type;
+	uint32_t immed_dat;
+	void *data;
+	uint32_t len;
+};
+
+static struct lpfc_ct_event *
+lpfc_ct_event_new(int ev_reg_id, uint32_t ev_req_id)
+{
+	struct lpfc_ct_event *evt = kzalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt)
+		return NULL;
+
+	INIT_LIST_HEAD(&evt->events_to_get);
+	INIT_LIST_HEAD(&evt->events_to_see);
+	evt->req_id = ev_req_id;
+	evt->reg_id = ev_reg_id;
+	evt->wait_time_stamp = jiffies;
+	init_waitqueue_head(&evt->wq);
+
+	return evt;
+}
+
+static void
+lpfc_ct_event_free(struct lpfc_ct_event *evt)
+{
+	struct event_data *ed;
+
+	list_del(&evt->node);
+
+	while (!list_empty(&evt->events_to_get)) {
+		ed = list_entry(evt->events_to_get.next, typeof(*ed), node);
+		list_del(&ed->node);
+		kfree(ed->data);
+		kfree(ed);
+	}
+
+	while (!list_empty(&evt->events_to_see)) {
+		ed = list_entry(evt->events_to_see.next, typeof(*ed), node);
+		list_del(&ed->node);
+		kfree(ed->data);
+		kfree(ed);
+	}
+
+	kfree(evt);
+}
+
+static inline void
+lpfc_ct_event_ref(struct lpfc_ct_event *evt)
+{
+	evt->ref++;
+}
+
+static inline void
+lpfc_ct_event_unref(struct lpfc_ct_event *evt)
+{
+	if (--evt->ref < 0)
+		lpfc_ct_event_free(evt);
+}
+
+#define SLI_CT_ELX_LOOPBACK 0x10
+
+enum ELX_LOOPBACK_CMD {
+	ELX_LOOPBACK_XRI_SETUP,
+	ELX_LOOPBACK_DATA,
+};
+
+/**
+ * lpfc_bsg_ct_unsol_event - process an unsolicited CT command
+ * @phba:
+ * @pring:
+ * @piocbq:
+ *
+ * This function is called when an unsolicited CT command is received.  It
+ * forwards the event to any processes registerd to receive CT events.
+ */
+void
+lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			struct lpfc_iocbq *piocbq)
+{
+	uint32_t evt_req_id = 0;
+	uint32_t cmd;
+	uint32_t len;
+	struct lpfc_dmabuf *dmabuf = NULL;
+	struct lpfc_ct_event *evt;
+	struct event_data *evt_dat = NULL;
+	struct lpfc_iocbq *iocbq;
+	size_t offset = 0;
+	struct list_head head;
+	struct ulp_bde64 *bde;
+	dma_addr_t dma_addr;
+	int i;
+	struct lpfc_dmabuf *bdeBuf1 = piocbq->context2;
+	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
+	struct lpfc_hbq_entry *hbqe;
+	struct lpfc_sli_ct_request *ct_req;
+
+	INIT_LIST_HEAD(&head);
+	list_add_tail(&head, &piocbq->list);
+
+	if (piocbq->iocb.ulpBdeCount == 0 ||
+	    piocbq->iocb.un.cont64[0].tus.f.bdeSize == 0)
+		goto error_ct_unsol_exit;
+
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
+		dmabuf = bdeBuf1;
+	else {
+		dma_addr = getPaddr(piocbq->iocb.un.cont64[0].addrHigh,
+				    piocbq->iocb.un.cont64[0].addrLow);
+		dmabuf = lpfc_sli_ringpostbuf_get(phba, pring, dma_addr);
+	}
+
+	ct_req = (struct lpfc_sli_ct_request *)dmabuf->virt;
+	evt_req_id = ct_req->FsType;
+	cmd = ct_req->CommandResponse.bits.CmdRsp;
+	len = ct_req->CommandResponse.bits.Size;
+	if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
+		lpfc_sli_ringpostbuf_put(phba, pring, dmabuf);
+
+	mutex_lock(&phba->ct_event_mutex);
+	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
+		if (evt->req_id != evt_req_id)
+			continue;
+
+		lpfc_ct_event_ref(evt);
+
+		evt_dat = kzalloc(sizeof(*evt_dat), GFP_KERNEL);
+		if (!evt_dat) {
+			lpfc_ct_event_unref(evt);
+			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+					"2614 Memory allocation failed for "
+					"CT event\n");
+			break;
+		}
+
+		mutex_unlock(&phba->ct_event_mutex);
+
+		if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+			/* take accumulated byte count from the last iocbq */
+			iocbq = list_entry(head.prev, typeof(*iocbq), list);
+			evt_dat->len = iocbq->iocb.unsli3.rcvsli3.acc_len;
+		} else {
+			list_for_each_entry(iocbq, &head, list) {
+				for (i = 0; i < iocbq->iocb.ulpBdeCount; i++)
+					evt_dat->len +=
+					iocbq->iocb.un.cont64[i].tus.f.bdeSize;
+			}
+		}
+
+		evt_dat->data = kzalloc(evt_dat->len, GFP_KERNEL);
+		if (!evt_dat->data) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+					"2615 Memory allocation failed for "
+					"CT event data, size %d\n",
+					evt_dat->len);
+			kfree(evt_dat);
+			mutex_lock(&phba->ct_event_mutex);
+			lpfc_ct_event_unref(evt);
+			mutex_unlock(&phba->ct_event_mutex);
+			goto error_ct_unsol_exit;
+		}
+
+		list_for_each_entry(iocbq, &head, list) {
+			if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+				bdeBuf1 = iocbq->context2;
+				bdeBuf2 = iocbq->context3;
+			}
+			for (i = 0; i < iocbq->iocb.ulpBdeCount; i++) {
+				int size = 0;
+				if (phba->sli3_options &
+				    LPFC_SLI3_HBQ_ENABLED) {
+					if (i == 0) {
+						hbqe = (struct lpfc_hbq_entry *)
+						  &iocbq->iocb.un.ulpWord[0];
+						size = hbqe->bde.tus.f.bdeSize;
+						dmabuf = bdeBuf1;
+					} else if (i == 1) {
+						hbqe = (struct lpfc_hbq_entry *)
+							&iocbq->iocb.unsli3.
+							sli3Words[4];
+						size = hbqe->bde.tus.f.bdeSize;
+						dmabuf = bdeBuf2;
+					}
+					if ((offset + size) > evt_dat->len)
+						size = evt_dat->len - offset;
+				} else {
+					size = iocbq->iocb.un.cont64[i].
+						tus.f.bdeSize;
+					bde = &iocbq->iocb.un.cont64[i];
+					dma_addr = getPaddr(bde->addrHigh,
+							    bde->addrLow);
+					dmabuf = lpfc_sli_ringpostbuf_get(phba,
+							pring, dma_addr);
+				}
+				if (!dmabuf) {
+					lpfc_printf_log(phba, KERN_ERR,
+						LOG_LIBDFC, "2616 No dmabuf "
+						"found for iocbq 0x%p\n",
+						iocbq);
+					kfree(evt_dat->data);
+					kfree(evt_dat);
+					mutex_lock(&phba->ct_event_mutex);
+					lpfc_ct_event_unref(evt);
+					mutex_unlock(&phba->ct_event_mutex);
+					goto error_ct_unsol_exit;
+				}
+				memcpy((char *)(evt_dat->data) + offset,
+				       dmabuf->virt, size);
+				offset += size;
+				if (evt_req_id != SLI_CT_ELX_LOOPBACK &&
+				    !(phba->sli3_options &
+				      LPFC_SLI3_HBQ_ENABLED)) {
+					lpfc_sli_ringpostbuf_put(phba, pring,
+								 dmabuf);
+				} else {
+					switch (cmd) {
+					case ELX_LOOPBACK_XRI_SETUP:
+						if (!(phba->sli3_options &
+						      LPFC_SLI3_HBQ_ENABLED))
+							lpfc_post_buffer(phba,
+									 pring,
+									 1);
+						else
+							lpfc_in_buf_free(phba,
+									dmabuf);
+						break;
+					default:
+						if (!(phba->sli3_options &
+						      LPFC_SLI3_HBQ_ENABLED))
+							lpfc_post_buffer(phba,
+									 pring,
+									 1);
+						break;
+					}
+				}
+			}
+		}
+
+		mutex_lock(&phba->ct_event_mutex);
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			evt_dat->immed_dat = phba->ctx_idx;
+			phba->ctx_idx = (phba->ctx_idx + 1) % 64;
+			phba->ct_ctx[evt_dat->immed_dat].oxid =
+						piocbq->iocb.ulpContext;
+			phba->ct_ctx[evt_dat->immed_dat].SID =
+				piocbq->iocb.un.rcvels.remoteID;
+		} else
+			evt_dat->immed_dat = piocbq->iocb.ulpContext;
+
+		evt_dat->type = FC_REG_CT_EVENT;
+		list_add(&evt_dat->node, &evt->events_to_see);
+		wake_up_interruptible(&evt->wq);
+		lpfc_ct_event_unref(evt);
+		if (evt_req_id == SLI_CT_ELX_LOOPBACK)
+			break;
+	}
+	mutex_unlock(&phba->ct_event_mutex);
+
+error_ct_unsol_exit:
+	if (!list_empty(&head))
+		list_del(&head);
+
+	return;
+}
+
+/**
+ * lpfc_bsg_set_event - process a SET_EVENT bsg vendor command
+ * @job: SET_EVENT fc_bsg_job
+ */
+static int
+lpfc_bsg_set_event(struct fc_bsg_job *job)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct set_ct_event *event_req;
+	struct lpfc_ct_event *evt;
+	int rc = 0;
+
+	if (job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct set_ct_event)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2612 Received SET_CT_EVENT below minimum "
+				"size\n");
+		return -EINVAL;
+	}
+
+	event_req = (struct set_ct_event *)
+		job->request->rqst_data.h_vendor.vendor_cmd;
+
+	mutex_lock(&phba->ct_event_mutex);
+	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
+		if (evt->reg_id == event_req->ev_reg_id) {
+			lpfc_ct_event_ref(evt);
+			evt->wait_time_stamp = jiffies;
+			break;
+		}
+	}
+	mutex_unlock(&phba->ct_event_mutex);
+
+	if (&evt->node == &phba->ct_ev_waiters) {
+		/* no event waiting struct yet - first call */
+		evt = lpfc_ct_event_new(event_req->ev_reg_id,
+					event_req->ev_req_id);
+		if (!evt) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+					"2617 Failed allocation of event "
+					"waiter\n");
+			return -ENOMEM;
+		}
+
+		mutex_lock(&phba->ct_event_mutex);
+		list_add(&evt->node, &phba->ct_ev_waiters);
+		lpfc_ct_event_ref(evt);
+		mutex_unlock(&phba->ct_event_mutex);
+	}
+
+	evt->waiting = 1;
+	if (wait_event_interruptible(evt->wq,
+				     !list_empty(&evt->events_to_see))) {
+		mutex_lock(&phba->ct_event_mutex);
+		lpfc_ct_event_unref(evt); /* release ref */
+		lpfc_ct_event_unref(evt); /* delete */
+		mutex_unlock(&phba->ct_event_mutex);
+		rc = -EINTR;
+		goto set_event_out;
+	}
+
+	evt->wait_time_stamp = jiffies;
+	evt->waiting = 0;
+
+	mutex_lock(&phba->ct_event_mutex);
+	list_move(evt->events_to_see.prev, &evt->events_to_get);
+	lpfc_ct_event_unref(evt); /* release ref */
+	mutex_unlock(&phba->ct_event_mutex);
+
+set_event_out:
+	/* set_event carries no reply payload */
+	job->reply->reply_payload_rcv_len = 0;
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	/* complete the job back to userspace */
+	job->job_done(job);
+
+	return 0;
+}
+
+/**
+ * lpfc_bsg_get_event - process a GET_EVENT bsg vendor command
+ * @job: GET_EVENT fc_bsg_job
+ */
+static int
+lpfc_bsg_get_event(struct fc_bsg_job *job)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct get_ct_event *event_req;
+	struct get_ct_event_reply *event_reply;
+	struct lpfc_ct_event *evt;
+	struct event_data *evt_dat = NULL;
+	int rc = 0;
+
+	if (job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct get_ct_event)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2613 Received GET_CT_EVENT request below "
+				"minimum size\n");
+		return -EINVAL;
+	}
+
+	event_req = (struct get_ct_event *)
+		job->request->rqst_data.h_vendor.vendor_cmd;
+
+	event_reply = (struct get_ct_event_reply *)
+		job->reply->reply_data.vendor_reply.vendor_rsp;
+
+	mutex_lock(&phba->ct_event_mutex);
+	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
+		if (evt->reg_id == event_req->ev_reg_id) {
+			if (list_empty(&evt->events_to_get))
+				break;
+			lpfc_ct_event_ref(evt);
+			evt->wait_time_stamp = jiffies;
+			evt_dat = list_entry(evt->events_to_get.prev,
+					     struct event_data, node);
+			list_del(&evt_dat->node);
+			break;
+		}
+	}
+	mutex_unlock(&phba->ct_event_mutex);
+
+	if (!evt_dat) {
+		job->reply->reply_payload_rcv_len = 0;
+		rc = -ENOENT;
+		goto error_get_event_exit;
+	}
+
+	if (evt_dat->len > job->reply_payload.payload_len) {
+		evt_dat->len = job->reply_payload.payload_len;
+			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+					"2618 Truncated event data at %d "
+					"bytes\n",
+					job->reply_payload.payload_len);
+	}
+
+	event_reply->immed_data = evt_dat->immed_dat;
+
+	if (evt_dat->len > 0)
+		job->reply->reply_payload_rcv_len =
+			sg_copy_from_buffer(job->reply_payload.sg_list,
+					    job->reply_payload.sg_cnt,
+					    evt_dat->data, evt_dat->len);
+	else
+		job->reply->reply_payload_rcv_len = 0;
+	rc = 0;
+
+	if (evt_dat)
+		kfree(evt_dat->data);
+	kfree(evt_dat);
+	mutex_lock(&phba->ct_event_mutex);
+	lpfc_ct_event_unref(evt);
+	mutex_unlock(&phba->ct_event_mutex);
+
+error_get_event_exit:
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	/* complete the job back to userspace */
+	job->job_done(job);
+
+	return rc;
+}
+
+/**
+ * lpfc_bsg_hst_vendor - process a vendor-specific fc_bsg_job
+ * @job: fc_bsg_job to handle
+ */
+static int
+lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
+{
+	int command = job->request->rqst_data.h_vendor.vendor_cmd[0];
+
+	switch (command) {
+	case LPFC_BSG_VENDOR_SET_CT_EVENT:
+		return lpfc_bsg_set_event(job);
+		break;
+
+	case LPFC_BSG_VENDOR_GET_CT_EVENT:
+		return lpfc_bsg_get_event(job);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+/**
+ * lpfc_bsg_request - handle a bsg request from the FC transport
+ * @job: fc_bsg_job to handle
+ */
+int
+lpfc_bsg_request(struct fc_bsg_job *job)
+{
+	uint32_t msgcode;
+	int rc = -EINVAL;
+
+	msgcode = job->request->msgcode;
+
+	switch (msgcode) {
+	case FC_BSG_HST_VENDOR:
+		rc = lpfc_bsg_hst_vendor(job);
+		break;
+	case FC_BSG_RPT_ELS:
+		rc = lpfc_bsg_rport_els(job);
+		break;
+	case FC_BSG_RPT_CT:
+		rc = lpfc_bsg_rport_ct(job);
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * lpfc_bsg_timeout - handle timeout of a bsg request from the FC transport
+ * @job: fc_bsg_job that has timed out
+ *
+ * This function just aborts the job's IOCB.  The aborted IOCB will return to
+ * the waiting function which will handle passing the error back to userspace
+ */
+int
+lpfc_bsg_timeout(struct fc_bsg_job *job)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *)job->dd_data;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+
+	if (cmdiocb)
+		lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb);
+
+	return 0;
+}
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -137,6 +137,9 @@ int lpfc_els_disc_adisc(struct lpfc_vport *);
 int lpfc_els_disc_plogi(struct lpfc_vport *);
 void lpfc_els_timeout(unsigned long);
 void lpfc_els_timeout_handler(struct lpfc_vport *);
+struct lpfc_iocbq *lpfc_prep_els_iocb(struct lpfc_vport *, uint8_t, uint16_t,
+				      uint8_t, struct lpfc_nodelist *,
+				      uint32_t, uint32_t);
 void lpfc_hb_timeout_handler(struct lpfc_hba *);
 
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
@@ -364,3 +367,8 @@ void lpfc_start_fdiscs(struct lpfc_hba *phba);
 #define HBA_EVENT_LINK_UP                2
 #define HBA_EVENT_LINK_DOWN              3
 
+/* functions to support SGIOv4/bsg interface */
+int lpfc_bsg_request(struct fc_bsg_job *);
+int lpfc_bsg_timeout(struct fc_bsg_job *);
+void lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
+			     struct lpfc_iocbq *);
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -97,6 +97,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct list_head head;
 	struct lpfc_dmabuf *bdeBuf;
 
+	lpfc_bsg_ct_unsol_event(phba, pring, piocbq);
+
 	if (unlikely(icmd->ulpStatus == IOSTAT_NEED_BUFFER)) {
 		lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
 	} else if ((icmd->ulpStatus == IOSTAT_LOCAL_REJECT) &&
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -146,7 +146,7 @@ lpfc_els_chk_latt(struct lpfc_vport *vport)
  *   Pointer to the newly allocated/prepared els iocb data structure
  *   NULL - when els iocb data structure allocation/preparation failed
  **/
-static struct lpfc_iocbq *
+struct lpfc_iocbq *
 lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		   uint16_t cmdSize, uint8_t retry,
 		   struct lpfc_nodelist *ndlp, uint32_t did,
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4172,6 +4172,9 @@ lpfc_hba_alloc(struct pci_dev *pdev)
 		return NULL;
 	}
 
+	mutex_init(&phba->ct_event_mutex);
+	INIT_LIST_HEAD(&phba->ct_ev_waiters);
+
 	return phba;
 }
 
--- a/drivers/scsi/lpfc/lpfc_nl.h
+++ b/drivers/scsi/lpfc/lpfc_nl.h
@@ -177,3 +177,23 @@ struct temp_event {
 	uint32_t data;
 };
 
+/* bsg definitions */
+#define LPFC_BSG_VENDOR_SET_CT_EVENT	1
+#define LPFC_BSG_VENDOR_GET_CT_EVENT	2
+
+struct set_ct_event {
+	uint32_t command;
+	uint32_t ev_req_id;
+	uint32_t ev_reg_id;
+};
+
+struct get_ct_event {
+	uint32_t command;
+	uint32_t ev_reg_id;
+	uint32_t ev_req_id;
+};
+
+struct get_ct_event_reply {
+	uint32_t immed_data;
+	uint32_t type;
+};
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3584,6 +3584,7 @@ struct scsi_host_template lpfc_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_hba_attrs,
 	.max_sectors		= 0xFFFF,
+	.vendor_id		= LPFC_NL_VENDOR_ID,
 };
 
 struct scsi_host_template lpfc_vport_template = {


