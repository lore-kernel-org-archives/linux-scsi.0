From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Wed, 23 Sep 2009 17:49:58 -0700
Message-ID: <200909240049.n8O0nw3l013437@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753080AbZIXAuF@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains code to access Brocade Fibre channel HBA
firmware/hardware, part-1

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_callback_priv.h  |   57 +
 bfa_cb_ioim_macros.h |  205 ++++++
 bfa_cee.c            |  492 +++++++++++++++
 bfa_core.c           |  402 ++++++++++++
 bfa_csdebug.c        |   58 +
 bfa_fcpim.c          |  175 +++++
 bfa_fcpim_priv.h     |  188 +++++
 bfa_fcport.c         | 1671 +++++++++++++++++++++++++++++++++++++++++++++++++++
 bfa_fcxp.c           |  782 +++++++++++++++++++++++
 9 files changed, 4030 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_callback_priv.h patch/drivers/scsi/bfa/bfa_callback_priv.h
--- orig/drivers/scsi/bfa/bfa_callback_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_callback_priv.h	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_CALLBACK_PRIV_H__
+#define __BFA_CALLBACK_PRIV_H__
+
+#include <cs/bfa_q.h>
+
+typedef void    (*bfa_cb_cbfn_t) (void *cbarg, bfa_boolean_t complete);
+
+/**
+ * Generic BFA callback element.
+ */
+struct bfa_cb_qe_s {
+	struct list_head         qe;
+	bfa_cb_cbfn_t  cbfn;
+	bfa_boolean_t   once;
+	u32		rsvd;
+	void           *cbarg;
+};
+
+#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {		\
+	(__hcb_qe)->cbfn  = (__cbfn);      \
+	(__hcb_qe)->cbarg = (__cbarg);      \
+	list_add_tail(&(__hcb_qe)->qe, &(__bfa)->comp_q);      \
+} while (0)
+
+#define bfa_cb_dequeue(__hcb_qe)	list_del(&(__hcb_qe)->qe)
+
+#define bfa_cb_queue_once(__bfa, __hcb_qe, __cbfn, __cbarg) do {	\
+	(__hcb_qe)->cbfn  = (__cbfn);      \
+	(__hcb_qe)->cbarg = (__cbarg);      \
+	if (!(__hcb_qe)->once) {      \
+		list_add_tail((__hcb_qe), &(__bfa)->comp_q);      \
+		(__hcb_qe)->once = BFA_TRUE;				\
+	}								\
+} while (0)
+
+#define bfa_cb_queue_done(__hcb_qe) do {				\
+	(__hcb_qe)->once = BFA_FALSE;					\
+} while (0)
+
+#endif /* __BFA_CALLBACK_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_cb_ioim_macros.h patch/drivers/scsi/bfa/bfa_cb_ioim_macros.h
--- orig/drivers/scsi/bfa/bfa_cb_ioim_macros.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_cb_ioim_macros.h	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,205 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_cb_ioim_macros.h BFA IOIM driver interface macros.
+ */
+
+#ifndef __BFA_HCB_IOIM_MACROS_H__
+#define __BFA_HCB_IOIM_MACROS_H__
+
+#include <bfa_os_inc.h>
+/*
+ * #include <linux/dma-mapping.h>
+ *
+ * #include <scsi/scsi.h> #include <scsi/scsi_cmnd.h> #include
+ * <scsi/scsi_device.h> #include <scsi/scsi_host.h>
+ */
+#include "bfad_im_compat.h"
+
+/*
+ * task attribute values in FCP-2 FCP_CMND IU
+ */
+#define SIMPLE_Q    0
+#define HEAD_OF_Q   1
+#define ORDERED_Q   2
+#define ACA_Q       4
+#define UNTAGGED    5
+
+static inline lun_t
+bfad_int_to_lun(u32 luno)
+{
+	union {
+		u16        scsi_lun[4];
+		lun_t           bfa_lun;
+	} lun;
+
+	lun.bfa_lun     = 0;
+	lun.scsi_lun[0] = bfa_os_htons(luno);
+
+	return (lun.bfa_lun);
+}
+
+/**
+ * Get LUN for the I/O request
+ */
+#define bfa_cb_ioim_get_lun(__dio)	\
+	bfad_int_to_lun(((struct scsi_cmnd *)__dio)->device->lun)
+
+/**
+ * Get CDB for the I/O request
+ */
+static inline u8 *
+bfa_cb_ioim_get_cdb(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+
+	return ((u8 *) cmnd->cmnd);
+}
+
+/**
+ * Get I/O direction (read/write) for the I/O request
+ */
+static inline enum fcp_iodir
+bfa_cb_ioim_get_iodir(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	enum dma_data_direction dmadir;
+
+	dmadir = cmnd->sc_data_direction;
+	if (dmadir == DMA_TO_DEVICE)
+		return FCP_IODIR_WRITE;
+	else if (dmadir == DMA_FROM_DEVICE)
+		return FCP_IODIR_READ;
+	else
+		return FCP_IODIR_NONE;
+}
+
+/**
+ * Get IO size in bytes for the I/O request
+ */
+static inline u32
+bfa_cb_ioim_get_size(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+
+	return (scsi_bufflen(cmnd));
+}
+
+/**
+ * Get timeout for the I/O request
+ */
+static inline u8
+bfa_cb_ioim_get_timeout(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	/*
+	 * TBD: need a timeout for scsi passthru
+	 */
+	if (cmnd->device->host == NULL)
+		return 4;
+
+	return 0;
+}
+
+/**
+ * Get SG element for the I/O request given the SG element index
+ */
+static inline union bfi_addr_u
+bfa_cb_ioim_get_sgaddr(struct bfad_ioim_s *dio, int sgeid)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct scatterlist *sge;
+	u64        addr;
+
+	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
+	addr = (u64) sg_dma_address(sge);
+
+	return (*(union bfi_addr_u *) &addr);
+}
+
+static inline u32
+bfa_cb_ioim_get_sglen(struct bfad_ioim_s *dio, int sgeid)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct scatterlist *sge;
+	u32        len;
+
+	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
+	len = sg_dma_len(sge);
+
+	return len;
+}
+
+/**
+ * Get Command Reference Number for the I/O request. 0 if none.
+ */
+static inline u8
+bfa_cb_ioim_get_crn(struct bfad_ioim_s *dio)
+{
+	return 0;
+}
+
+/**
+ * Get SAM-3 priority for the I/O request. 0 is default.
+ */
+static inline u8
+bfa_cb_ioim_get_priority(struct bfad_ioim_s *dio)
+{
+	return 0;
+}
+
+/**
+ * Get task attributes for the I/O request. Default is FCP_TASK_ATTR_SIMPLE(0).
+ */
+static inline u8
+bfa_cb_ioim_get_taskattr(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	u8         task_attr = UNTAGGED;
+
+	if (cmnd->device->tagged_supported) {
+		switch (cmnd->tag) {
+		case HEAD_OF_QUEUE_TAG:
+			task_attr = HEAD_OF_Q;
+			break;
+		case ORDERED_QUEUE_TAG:
+			task_attr = ORDERED_Q;
+			break;
+		default:
+			task_attr = SIMPLE_Q;
+			break;
+		}
+	}
+
+	return task_attr;
+}
+
+/**
+ * Get CDB length in bytes for the I/O request. Default is FCP_CMND_CDB_LEN(16).
+ */
+static inline u8
+bfa_cb_ioim_get_cdblen(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+
+	return (cmnd->cmd_len);
+}
+
+
+
+#endif /* __BFA_HCB_IOIM_MACROS_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_cee.c patch/drivers/scsi/bfa/bfa_cee.c
--- orig/drivers/scsi/bfa/bfa_cee.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_cee.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,492 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <defs/bfa_defs_cee.h>
+#include <cs/bfa_trc.h>
+#include <cs/bfa_log.h>
+#include <cs/bfa_debug.h>
+#include <cee/bfa_cee.h>
+#include <bfi/bfi_cee.h>
+#include <bfi/bfi.h>
+#include <bfa_ioc.h>
+#include <cna/bfa_cna_trcmod.h>
+
+BFA_TRC_FILE(CNA, CEE);
+
+#define bfa_ioc_portid(__ioc) ((__ioc)->port_id)
+#define bfa_lpuid(__arg) bfa_ioc_portid(&(__arg)->ioc)
+
+static void     bfa_cee_format_lldp_cfg(struct bfa_cee_lldp_cfg_s *lldp_cfg);
+static void     bfa_cee_format_dcbcx_stats(struct bfa_cee_dcbx_stats_s
+					   *dcbcx_stats);
+static void     bfa_cee_format_lldp_stats(struct bfa_cee_lldp_stats_s
+					  *lldp_stats);
+static void     bfa_cee_format_cfg_stats(struct bfa_cee_cfg_stats_s *cfg_stats);
+static void     bfa_cee_format_cee_cfg(void *buffer);
+static void     bfa_cee_format_cee_stats(void *buffer);
+
+static void
+bfa_cee_format_cee_stats(void *buffer)
+{
+	struct bfa_cee_stats_s *cee_stats = buffer;
+	bfa_cee_format_dcbcx_stats(&cee_stats->dcbx_stats);
+	bfa_cee_format_lldp_stats(&cee_stats->lldp_stats);
+	bfa_cee_format_cfg_stats(&cee_stats->cfg_stats);
+}
+
+static void
+bfa_cee_format_cee_cfg(void *buffer)
+{
+	struct bfa_cee_attr_s *cee_cfg = buffer;
+	bfa_cee_format_lldp_cfg(&cee_cfg->lldp_remote);
+}
+
+static void
+bfa_cee_format_dcbcx_stats(struct bfa_cee_dcbx_stats_s *dcbcx_stats)
+{
+	dcbcx_stats->subtlvs_unrecognized =
+		bfa_os_ntohl(dcbcx_stats->subtlvs_unrecognized);
+	dcbcx_stats->negotiation_failed =
+		bfa_os_ntohl(dcbcx_stats->negotiation_failed);
+	dcbcx_stats->remote_cfg_changed =
+		bfa_os_ntohl(dcbcx_stats->remote_cfg_changed);
+	dcbcx_stats->tlvs_received = bfa_os_ntohl(dcbcx_stats->tlvs_received);
+	dcbcx_stats->tlvs_invalid = bfa_os_ntohl(dcbcx_stats->tlvs_invalid);
+	dcbcx_stats->seqno = bfa_os_ntohl(dcbcx_stats->seqno);
+	dcbcx_stats->ackno = bfa_os_ntohl(dcbcx_stats->ackno);
+	dcbcx_stats->recvd_seqno = bfa_os_ntohl(dcbcx_stats->recvd_seqno);
+	dcbcx_stats->recvd_ackno = bfa_os_ntohl(dcbcx_stats->recvd_ackno);
+}
+
+static void
+bfa_cee_format_lldp_stats(struct bfa_cee_lldp_stats_s *lldp_stats)
+{
+	lldp_stats->frames_transmitted =
+		bfa_os_ntohl(lldp_stats->frames_transmitted);
+	lldp_stats->frames_aged_out = bfa_os_ntohl(lldp_stats->frames_aged_out);
+	lldp_stats->frames_discarded =
+		bfa_os_ntohl(lldp_stats->frames_discarded);
+	lldp_stats->frames_in_error = bfa_os_ntohl(lldp_stats->frames_in_error);
+	lldp_stats->frames_rcvd = bfa_os_ntohl(lldp_stats->frames_rcvd);
+	lldp_stats->tlvs_discarded = bfa_os_ntohl(lldp_stats->tlvs_discarded);
+	lldp_stats->tlvs_unrecognized =
+		bfa_os_ntohl(lldp_stats->tlvs_unrecognized);
+}
+
+static void
+bfa_cee_format_cfg_stats(struct bfa_cee_cfg_stats_s *cfg_stats)
+{
+	cfg_stats->cee_status_down = bfa_os_ntohl(cfg_stats->cee_status_down);
+	cfg_stats->cee_status_up = bfa_os_ntohl(cfg_stats->cee_status_up);
+	cfg_stats->cee_hw_cfg_changed =
+		bfa_os_ntohl(cfg_stats->cee_hw_cfg_changed);
+	cfg_stats->recvd_invalid_cfg =
+		bfa_os_ntohl(cfg_stats->recvd_invalid_cfg);
+}
+
+static void
+bfa_cee_format_lldp_cfg(struct bfa_cee_lldp_cfg_s *lldp_cfg)
+{
+	lldp_cfg->time_to_interval = bfa_os_ntohs(lldp_cfg->time_to_interval);
+	lldp_cfg->enabled_system_cap =
+		bfa_os_ntohs(lldp_cfg->enabled_system_cap);
+}
+
+/**
+ * bfa_cee_attr_meminfo()
+ *
+ *
+ * @param[in] void
+ *
+ * @return Size of DMA region
+ */
+static          u32
+bfa_cee_attr_meminfo(void)
+{
+	return BFA_ROUNDUP(sizeof(struct bfa_cee_attr_s), BFA_DMA_ALIGN_SZ);
+}
+
+/**
+ * bfa_cee_stats_meminfo()
+ *
+ *
+ * @param[in] void
+ *
+ * @return Size of DMA region
+ */
+static          u32
+bfa_cee_stats_meminfo(void)
+{
+	return BFA_ROUNDUP(sizeof(struct bfa_cee_stats_s), BFA_DMA_ALIGN_SZ);
+}
+
+/**
+ * bfa_cee_get_attr_isr()
+ *
+ *
+ * @param[in] cee - Pointer to the CEE module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_cee_get_attr_isr(struct bfa_cee_s *cee, bfa_status_t status)
+{
+	cee->get_attr_status = status;
+	bfa_trc(cee, 0);
+	if (status == BFA_STATUS_OK) {
+		bfa_trc(cee, 0);
+		/*
+		 * The requested data has been copied to the DMA area, *process
+		 * it.
+		 */
+		memcpy(cee->attr, cee->attr_dma.kva,
+		       sizeof(struct bfa_cee_attr_s));
+		bfa_cee_format_cee_cfg(cee->attr);
+	}
+	cee->get_attr_pending = BFA_FALSE;
+	if (cee->cbfn.get_attr_cbfn) {
+		bfa_trc(cee, 0);
+		cee->cbfn.get_attr_cbfn(cee->cbfn.get_attr_cbarg, status);
+	}
+	bfa_trc(cee, 0);
+}
+
+/**
+ * bfa_cee_get_attr_isr()
+ *
+ *
+ * @param[in] cee - Pointer to the CEE module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_cee_get_stats_isr(struct bfa_cee_s *cee, bfa_status_t status)
+{
+	cee->get_stats_status = status;
+	bfa_trc(cee, 0);
+	if (status == BFA_STATUS_OK) {
+		bfa_trc(cee, 0);
+		/*
+		 * The requested data has been copied to the DMA area, process
+		 * it.
+		 */
+		memcpy(cee->stats, cee->stats_dma.kva,
+		       sizeof(struct bfa_cee_stats_s));
+		bfa_cee_format_cee_stats(cee->stats);
+	}
+	cee->get_stats_pending = BFA_FALSE;
+	bfa_trc(cee, 0);
+	if (cee->cbfn.get_stats_cbfn) {
+		bfa_trc(cee, 0);
+		cee->cbfn.get_stats_cbfn(cee->cbfn.get_stats_cbarg, status);
+	}
+	bfa_trc(cee, 0);
+}
+
+/**
+ * bfa_cee_get_attr_isr()
+ *
+ *
+ * @param[in] cee - Pointer to the CEE module
+ *            status - Return status from the f/w
+ *
+ * @return void
+ */
+static void
+bfa_cee_reset_stats_isr(struct bfa_cee_s *cee, bfa_status_t status)
+{
+	cee->reset_stats_status = status;
+	cee->reset_stats_pending = BFA_FALSE;
+	if (cee->cbfn.reset_stats_cbfn)
+		cee->cbfn.reset_stats_cbfn(cee->cbfn.reset_stats_cbarg, status);
+}
+
+/**
+ * bfa_cee_meminfo()
+ *
+ *
+ * @param[in] void
+ *
+ * @return Size of DMA region
+ */
+u32
+bfa_cee_meminfo(void)
+{
+	return (bfa_cee_attr_meminfo() + bfa_cee_stats_meminfo());
+}
+
+/**
+ * bfa_cee_mem_claim()
+ *
+ *
+ * @param[in] cee CEE module pointer
+ * 	      dma_kva Kernel Virtual Address of CEE DMA Memory
+ * 	      dma_pa  Physical Address of CEE DMA Memory
+ *
+ * @return void
+ */
+void
+bfa_cee_mem_claim(struct bfa_cee_s *cee, u8 *dma_kva, u64 dma_pa)
+{
+	cee->attr_dma.kva = dma_kva;
+	cee->attr_dma.pa = dma_pa;
+	cee->stats_dma.kva = dma_kva + bfa_cee_attr_meminfo();
+	cee->stats_dma.pa = dma_pa + bfa_cee_attr_meminfo();
+	cee->attr = (struct bfa_cee_attr_s *)dma_kva;
+	cee->stats =
+		(struct bfa_cee_stats_s *)(dma_kva + bfa_cee_attr_meminfo());
+}
+
+/**
+ * bfa_cee_get_attr()
+ *
+ *   Send the request to the f/w to fetch CEE attributes.
+ *
+ * @param[in] Pointer to the CEE module data structure.
+ *
+ * @return Status
+ */
+
+bfa_status_t
+bfa_cee_get_attr(struct bfa_cee_s *cee, struct bfa_cee_attr_s *attr,
+		 bfa_cee_get_attr_cbfn_t cbfn, void *cbarg)
+{
+	struct bfi_cee_get_req_s *cmd;
+
+	bfa_assert((cee != NULL) && (cee->ioc != NULL));
+	bfa_trc(cee, 0);
+	if (!bfa_ioc_is_operational(cee->ioc)) {
+		bfa_trc(cee, 0);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+	if (cee->get_attr_pending == BFA_TRUE) {
+		bfa_trc(cee, 0);
+		return BFA_STATUS_DEVBUSY;
+	}
+	cee->get_attr_pending = BFA_TRUE;
+	cmd = (struct bfi_cee_get_req_s *)cee->get_cfg_mb.msg;
+	cee->attr = attr;
+	cee->cbfn.get_attr_cbfn = cbfn;
+	cee->cbfn.get_attr_cbarg = cbarg;
+	bfi_h2i_set(cmd->mh, BFI_MC_CEE, BFI_CEE_H2I_GET_CFG_REQ,
+		    bfa_ioc_portid(cee->ioc));
+	bfa_dma_be_addr_set(cmd->dma_addr, cee->attr_dma.pa);
+	bfa_ioc_mbox_queue(cee->ioc, &cee->get_cfg_mb);
+	bfa_trc(cee, 0);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_cee_get_stats()
+ *
+ *   Send the request to the f/w to fetch CEE statistics.
+ *
+ * @param[in] Pointer to the CEE module data structure.
+ *
+ * @return Status
+ */
+
+bfa_status_t
+bfa_cee_get_stats(struct bfa_cee_s *cee, struct bfa_cee_stats_s *stats,
+		  bfa_cee_get_stats_cbfn_t cbfn, void *cbarg)
+{
+	struct bfi_cee_get_req_s *cmd;
+
+	bfa_assert((cee != NULL) && (cee->ioc != NULL));
+
+	if (!bfa_ioc_is_operational(cee->ioc)) {
+		bfa_trc(cee, 0);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+	if (cee->get_stats_pending == BFA_TRUE) {
+		bfa_trc(cee, 0);
+		return BFA_STATUS_DEVBUSY;
+	}
+	cee->get_stats_pending = BFA_TRUE;
+	cmd = (struct bfi_cee_get_req_s *)cee->get_stats_mb.msg;
+	cee->stats = stats;
+	cee->cbfn.get_stats_cbfn = cbfn;
+	cee->cbfn.get_stats_cbarg = cbarg;
+	bfi_h2i_set(cmd->mh, BFI_MC_CEE, BFI_CEE_H2I_GET_STATS_REQ,
+		    bfa_ioc_portid(cee->ioc));
+	bfa_dma_be_addr_set(cmd->dma_addr, cee->stats_dma.pa);
+	bfa_ioc_mbox_queue(cee->ioc, &cee->get_stats_mb);
+	bfa_trc(cee, 0);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_cee_reset_stats()
+ *
+ *
+ * @param[in] Pointer to the CEE module data structure.
+ *
+ * @return Status
+ */
+
+bfa_status_t
+bfa_cee_reset_stats(struct bfa_cee_s *cee, bfa_cee_reset_stats_cbfn_t cbfn,
+		    void *cbarg)
+{
+	struct bfi_cee_reset_stats_s *cmd;
+
+	bfa_assert((cee != NULL) && (cee->ioc != NULL));
+	if (!bfa_ioc_is_operational(cee->ioc)) {
+		bfa_trc(cee, 0);
+		return BFA_STATUS_IOC_FAILURE;
+	}
+	if (cee->reset_stats_pending == BFA_TRUE) {
+		bfa_trc(cee, 0);
+		return BFA_STATUS_DEVBUSY;
+	}
+	cee->reset_stats_pending = BFA_TRUE;
+	cmd = (struct bfi_cee_reset_stats_s *)cee->reset_stats_mb.msg;
+	cee->cbfn.reset_stats_cbfn = cbfn;
+	cee->cbfn.reset_stats_cbarg = cbarg;
+	bfi_h2i_set(cmd->mh, BFI_MC_CEE, BFI_CEE_H2I_RESET_STATS,
+		    bfa_ioc_portid(cee->ioc));
+	bfa_ioc_mbox_queue(cee->ioc, &cee->reset_stats_mb);
+	bfa_trc(cee, 0);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * bfa_cee_isrs()
+ *
+ *
+ * @param[in] Pointer to the CEE module data structure.
+ *
+ * @return void
+ */
+
+void
+bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
+{
+	union bfi_cee_i2h_msg_u *msg;
+	struct bfi_cee_get_rsp_s *get_rsp;
+	struct bfa_cee_s *cee = (struct bfa_cee_s *)cbarg;
+	msg = (union bfi_cee_i2h_msg_u *)m;
+	get_rsp = (struct bfi_cee_get_rsp_s *)m;
+	bfa_trc(cee, msg->mh.msg_id);
+	switch (msg->mh.msg_id) {
+	case BFI_CEE_I2H_GET_CFG_RSP:
+		bfa_trc(cee, get_rsp->cmd_status);
+		bfa_cee_get_attr_isr(cee, get_rsp->cmd_status);
+		break;
+	case BFI_CEE_I2H_GET_STATS_RSP:
+		bfa_cee_get_stats_isr(cee, get_rsp->cmd_status);
+		break;
+	case BFI_CEE_I2H_RESET_STATS_RSP:
+		bfa_cee_reset_stats_isr(cee, get_rsp->cmd_status);
+		break;
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * bfa_cee_hbfail()
+ *
+ *
+ * @param[in] Pointer to the CEE module data structure.
+ *
+ * @return void
+ */
+
+void
+bfa_cee_hbfail(void *arg)
+{
+	struct bfa_cee_s *cee;
+	cee = (struct bfa_cee_s *)arg;
+
+	if (cee->get_attr_pending == BFA_TRUE) {
+		cee->get_attr_status = BFA_STATUS_FAILED;
+		cee->get_attr_pending = BFA_FALSE;
+		if (cee->cbfn.get_attr_cbfn) {
+			cee->cbfn.get_attr_cbfn(cee->cbfn.get_attr_cbarg,
+						BFA_STATUS_FAILED);
+		}
+	}
+	if (cee->get_stats_pending == BFA_TRUE) {
+		cee->get_stats_status = BFA_STATUS_FAILED;
+		cee->get_stats_pending = BFA_FALSE;
+		if (cee->cbfn.get_stats_cbfn) {
+			cee->cbfn.get_stats_cbfn(cee->cbfn.get_stats_cbarg,
+						 BFA_STATUS_FAILED);
+		}
+	}
+	if (cee->reset_stats_pending == BFA_TRUE) {
+		cee->reset_stats_status = BFA_STATUS_FAILED;
+		cee->reset_stats_pending = BFA_FALSE;
+		if (cee->cbfn.reset_stats_cbfn) {
+			cee->cbfn.reset_stats_cbfn(cee->cbfn.reset_stats_cbarg,
+						   BFA_STATUS_FAILED);
+		}
+	}
+}
+
+/**
+ * bfa_cee_attach()
+ *
+ *
+ * @param[in] cee - Pointer to the CEE module data structure
+ *            ioc - Pointer to the ioc module data structure
+ *            dev - Pointer to the device driver module data structure
+ *                  The device driver specific mbox ISR functions have
+ *                  this pointer as one of the parameters.
+ *            trcmod -
+ *            logmod -
+ *
+ * @return void
+ */
+void
+bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc, void *dev,
+	       struct bfa_trc_mod_s *trcmod, struct bfa_log_mod_s *logmod)
+{
+	bfa_assert(cee != NULL);
+	cee->dev = dev;
+	cee->trcmod = trcmod;
+	cee->logmod = logmod;
+	cee->ioc = ioc;
+
+	bfa_ioc_mbox_regisr(cee->ioc, BFI_MC_CEE, bfa_cee_isr, cee);
+	bfa_ioc_hbfail_init(&cee->hbfail, bfa_cee_hbfail, cee);
+	bfa_ioc_hbfail_register(cee->ioc, &cee->hbfail);
+	bfa_trc(cee, 0);
+}
+
+/**
+ * bfa_cee_detach()
+ *
+ *
+ * @param[in] cee - Pointer to the CEE module data structure
+ *
+ * @return void
+ */
+void
+bfa_cee_detach(struct bfa_cee_s *cee)
+{
+	/*
+	 * For now, just check if there is some ioctl pending and mark that as
+	 * failed?
+	 */
+	/* bfa_cee_hbfail(cee); */
+}
diff -urpN orig/drivers/scsi/bfa/bfa_core.c patch/drivers/scsi/bfa/bfa_core.c
--- orig/drivers/scsi/bfa/bfa_core.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_core.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,402 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <defs/bfa_defs_pci.h>
+#include <cs/bfa_debug.h>
+#include <bfa_iocfc.h>
+
+#define DEF_CFG_NUM_FABRICS         1
+#define DEF_CFG_NUM_LPORTS          256
+#define DEF_CFG_NUM_CQS             4
+#define DEF_CFG_NUM_IOIM_REQS       (BFA_IOIM_MAX)
+#define DEF_CFG_NUM_TSKIM_REQS      128
+#define DEF_CFG_NUM_FCXP_REQS       64
+#define DEF_CFG_NUM_UF_BUFS         64
+#define DEF_CFG_NUM_RPORTS          1024
+#define DEF_CFG_NUM_ITNIMS          (DEF_CFG_NUM_RPORTS)
+#define DEF_CFG_NUM_TINS            256
+
+#define DEF_CFG_NUM_SGPGS           2048
+#define DEF_CFG_NUM_REQQ_ELEMS      256
+#define DEF_CFG_NUM_RSPQ_ELEMS      64
+#define DEF_CFG_NUM_SBOOT_TGTS      16
+#define DEF_CFG_NUM_SBOOT_LUNS      16
+
+/**
+ * Use this function query the memory requirement of the BFA library.
+ * This function needs to be called before bfa_attach() to get the
+ * memory required of the BFA layer for a given driver configuration.
+ *
+ * This call will fail, if the cap is out of range compared to pre-defined
+ * values within the BFA library
+ *
+ * @param[in] cfg - 	pointer to bfa_ioc_cfg_t. Driver layer should indicate
+ * 			its configuration in this structure.
+ *			The default values for struct bfa_iocfc_cfg_s can be
+ *			fetched using bfa_cfg_get_default() API.
+ *
+ * 			If cap's boundary check fails, the library will use
+ *			the default bfa_cap_t values (and log a warning msg).
+ *
+ * @param[out] meminfo - pointer to bfa_meminfo_t. This content
+ * 			indicates the memory type (see bfa_mem_type_t) and
+ *			amount of memory required.
+ *
+ *			Driver should allocate the memory, populate the
+ *			starting address for each block and provide the same
+ *			structure as input parameter to bfa_attach() call.
+ *
+ * @return void
+ *
+ * Special Considerations: @note
+ */
+void
+bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
+{
+	int             i;
+	u32        km_len = 0, dm_len = 0;
+
+	bfa_assert((cfg != NULL) && (meminfo != NULL));
+
+	bfa_os_memset((void *)meminfo, 0, sizeof(struct bfa_meminfo_s));
+	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_type =
+		BFA_MEM_TYPE_KVA;
+	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_type =
+		BFA_MEM_TYPE_DMA;
+
+	bfa_iocfc_meminfo(cfg, &km_len, &dm_len);
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->meminfo(cfg, &km_len, &dm_len);
+
+
+	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_len = km_len;
+	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_len = dm_len;
+}
+
+/**
+ * Use this function to do attach the driver instance with the BFA
+ * library. This function will not trigger any HW initialization
+ * process (which will be done in bfa_init() call)
+ *
+ * This call will fail, if the cap is out of range compared to
+ * pre-defined values within the BFA library
+ *
+ * @param[out]	bfa	Pointer to bfa_t.
+ * @param[in]	bfad 	Opaque handle back to the driver's IOC structure
+ * @param[in]	cfg	Pointer to bfa_ioc_cfg_t. Should be same structure
+ * 			that was used in bfa_cfg_get_meminfo().
+ * @param[in] 	meminfo Pointer to bfa_meminfo_t. The driver should
+ * 			use the bfa_cfg_get_meminfo() call to
+ * 			find the memory blocks required, allocate the
+ * 			required memory and provide the starting addresses.
+ * @param[in] 	pcidev	pointer to struct bfa_pcidev_s
+ *
+ * @return
+ * void
+ *
+ * Special Considerations:
+ *
+ * @note
+ *
+ */
+void
+bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+	       struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	int             i;
+	struct bfa_mem_elem_s *melem;
+
+	bfa->fcs = BFA_FALSE;
+
+	bfa_assert((cfg != NULL) && (meminfo != NULL));
+
+	/**
+	 * initialize all memory pointers for iterative allocation
+	 */
+	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
+		melem = meminfo->meminfo + i;
+		melem->kva_curp = melem->kva;
+		melem->dma_curp = melem->dma;
+	}
+
+	bfa_iocfc_attach(bfa, bfad, cfg, meminfo, pcidev);
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->attach(bfa, bfad, cfg, meminfo, pcidev);
+
+}
+
+/**
+ * Use this function to delete a BFA IOC. IOC should be stopped (by
+ * calling bfa_stop()) before this function call.
+ *
+ * @param[in] bfa - pointer to bfa_t.
+ *
+ * @return
+ * void
+ *
+ * Special Considerations:
+ *
+ * @note
+ */
+void
+bfa_detach(struct bfa_s *bfa)
+{
+	int	i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->detach(bfa);
+
+	bfa_iocfc_detach(bfa);
+}
+
+
+void
+bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod)
+{
+	bfa->trcmod = trcmod;
+}
+
+
+void
+bfa_init_log(struct bfa_s *bfa, struct bfa_log_mod_s *logmod)
+{
+	bfa->logm = logmod;
+}
+
+
+void
+bfa_init_aen(struct bfa_s *bfa, struct bfa_aen_s *aen)
+{
+	bfa->aen = aen;
+}
+
+void
+bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog)
+{
+	bfa->plog = plog;
+}
+
+/**
+ * Initialize IOC.
+ *
+ * This function will return immediately, when the IOC initialization is
+ * completed, the bfa_cb_init() will be called.
+ *
+ * @param[in]	bfa	instance
+ *
+ * @return void
+ *
+ * Special Considerations:
+ *
+ * @note
+ * When this function returns, the driver should register the interrupt service
+ * routine(s) and enable the device interrupts. If this is not done,
+ * bfa_cb_init() will never get called
+ */
+void
+bfa_init(struct bfa_s *bfa)
+{
+	bfa_iocfc_init(bfa);
+}
+
+/**
+ * Use this function initiate the IOC configuration setup. This function
+ * will return immediately.
+ *
+ * @param[in]	bfa	instance
+ *
+ * @return None
+ */
+void
+bfa_start(struct bfa_s *bfa)
+{
+	bfa_iocfc_start(bfa);
+}
+
+/**
+ * Use this function quiese the IOC. This function will return immediately,
+ * when the IOC is actually stopped, the bfa_cb_stop() will be called.
+ *
+ * @param[in] 	bfa - pointer to bfa_t.
+ *
+ * @return None
+ *
+ * Special Considerations:
+ * bfa_cb_stop() could be called before or after bfa_stop() returns.
+ *
+ * @note
+ * In case of any failure, we could handle it automatically by doing a
+ * reset and then succeed the bfa_stop() call.
+ */
+void
+bfa_stop(struct bfa_s *bfa)
+{
+	bfa_iocfc_stop(bfa);
+}
+
+void
+bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q)
+{
+	INIT_LIST_HEAD(comp_q);
+	list_splice_tail_init(&bfa->comp_q, comp_q);
+}
+
+void
+bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q)
+{
+	struct list_head        *qe;
+	struct list_head        *qen;
+	struct bfa_cb_qe_s   *hcb_qe;
+
+	list_for_each_safe(qe, qen, comp_q) {
+		hcb_qe = (struct bfa_cb_qe_s *) qe;
+		hcb_qe->cbfn(hcb_qe->cbarg, BFA_TRUE);
+	}
+}
+
+void
+bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q)
+{
+	struct list_head        *qe;
+	struct bfa_cb_qe_s   *hcb_qe;
+
+	while (!list_empty(comp_q)) {
+		bfa_q_deq(comp_q, &qe);
+		hcb_qe = (struct bfa_cb_qe_s *) qe;
+		hcb_qe->cbfn(hcb_qe->cbarg, BFA_FALSE);
+	}
+}
+
+void
+bfa_attach_fcs(struct bfa_s *bfa)
+{
+	bfa->fcs = BFA_TRUE;
+}
+
+/**
+ * Periodic timer heart beat from driver
+ */
+void
+bfa_timer_tick(struct bfa_s *bfa)
+{
+	bfa_timer_beat(&bfa->timer_mod);
+}
+
+#ifndef BFA_BIOS_BUILD
+/**
+ * Return the list of PCI vendor/device id lists supported by this
+ * BFA instance.
+ */
+void
+bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
+{
+	static struct bfa_pciid_s __pciids[] = {
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G2P},
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G1P},
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
+	};
+
+	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
+	*pciids = __pciids;
+}
+
+/**
+ * Use this function query the default struct bfa_iocfc_cfg_s value (compiled
+ * into BFA layer). The OS driver can then turn back and overwrite entries that
+ * have been configured by the user.
+ *
+ * @param[in] cfg - pointer to bfa_ioc_cfg_t
+ *
+ * @return
+ *	void
+ *
+ * Special Considerations:
+ * 	note
+ */
+void
+bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg)
+{
+	cfg->fwcfg.num_fabrics = DEF_CFG_NUM_FABRICS;
+	cfg->fwcfg.num_lports = DEF_CFG_NUM_LPORTS;
+	cfg->fwcfg.num_rports = DEF_CFG_NUM_RPORTS;
+	cfg->fwcfg.num_ioim_reqs = DEF_CFG_NUM_IOIM_REQS;
+	cfg->fwcfg.num_tskim_reqs = DEF_CFG_NUM_TSKIM_REQS;
+	cfg->fwcfg.num_fcxp_reqs = DEF_CFG_NUM_FCXP_REQS;
+	cfg->fwcfg.num_uf_bufs = DEF_CFG_NUM_UF_BUFS;
+	cfg->fwcfg.num_cqs = DEF_CFG_NUM_CQS;
+
+	cfg->drvcfg.num_reqq_elems = DEF_CFG_NUM_REQQ_ELEMS;
+	cfg->drvcfg.num_rspq_elems = DEF_CFG_NUM_RSPQ_ELEMS;
+	cfg->drvcfg.num_sgpgs = DEF_CFG_NUM_SGPGS;
+	cfg->drvcfg.num_sboot_tgts = DEF_CFG_NUM_SBOOT_TGTS;
+	cfg->drvcfg.num_sboot_luns = DEF_CFG_NUM_SBOOT_LUNS;
+	cfg->drvcfg.path_tov = BFA_FCPIM_PATHTOV_DEF;
+	cfg->drvcfg.ioc_recover = BFA_FALSE;
+	cfg->drvcfg.delay_comp = BFA_FALSE;
+
+}
+
+void
+bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg)
+{
+	bfa_cfg_get_default(cfg);
+	cfg->fwcfg.num_ioim_reqs   = BFA_IOIM_MIN;
+	cfg->fwcfg.num_tskim_reqs  = BFA_TSKIM_MIN;
+	cfg->fwcfg.num_fcxp_reqs   = BFA_FCXP_MIN;
+	cfg->fwcfg.num_uf_bufs     = BFA_UF_MIN;
+	cfg->fwcfg.num_rports      = BFA_RPORT_MIN;
+
+	cfg->drvcfg.num_sgpgs      = BFA_SGPG_MIN;
+	cfg->drvcfg.num_reqq_elems = BFA_REQQ_NELEMS_MIN;
+	cfg->drvcfg.num_rspq_elems = BFA_RSPQ_NELEMS_MIN;
+	cfg->drvcfg.min_cfg        = BFA_TRUE;
+}
+
+void
+bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr)
+{
+	bfa_ioc_get_attr(&bfa->ioc, ioc_attr);
+}
+
+/**
+ * Retrieve firmware trace information on IOC failure.
+ */
+bfa_status_t
+bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
+{
+	return bfa_ioc_debug_fwsave(&bfa->ioc, trcdata, trclen);
+}
+
+/**
+ * 		Fetch firmware trace data.
+ *
+ * @param[in]		bfa			BFA instance
+ * @param[out]		trcdata		Firmware trace buffer
+ * @param[in,out]	trclen		Firmware trace buffer len
+ *
+ * @retval BFA_STATUS_OK			Firmware trace is fetched.
+ * @retval BFA_STATUS_INPROGRESS	Firmware trace fetch is in progress.
+ */
+bfa_status_t
+bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen)
+{
+	return bfa_ioc_debug_fwtrc(&bfa->ioc, trcdata, trclen);
+}
+#endif
diff -urpN orig/drivers/scsi/bfa/bfa_csdebug.c patch/drivers/scsi/bfa/bfa_csdebug.c
--- orig/drivers/scsi/bfa/bfa_csdebug.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_csdebug.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <cs/bfa_debug.h>
+#include <bfa_os_inc.h>
+#include <cs/bfa_q.h>
+#include <log/bfa_log_hal.h>
+
+/**
+ *  cs_debug_api
+ */
+
+
+void
+bfa_panic(int line, char *file, char *panicstr)
+{
+	bfa_log(NULL, BFA_LOG_HAL_ASSERT, file, line, panicstr);
+	bfa_os_panic();
+}
+
+void
+bfa_sm_panic(struct bfa_log_mod_s *logm, int line, char *file, int event)
+{
+	bfa_log(logm, BFA_LOG_HAL_SM_ASSERT, file, line, event);
+	bfa_os_panic();
+}
+
+int
+bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe)
+{
+	struct list_head        *tqe;
+
+	tqe = bfa_q_next(q);
+	while (tqe != q) {
+		if (tqe == qe)
+			return (1);
+		tqe = bfa_q_next(tqe);
+		if (tqe == NULL)
+			break;
+	}
+	return (0);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcpim.c patch/drivers/scsi/bfa/bfa_fcpim.c
--- orig/drivers/scsi/bfa/bfa_fcpim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcpim.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,175 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <log/bfa_log_hal.h>
+
+BFA_TRC_FILE(HAL, FCPIM);
+BFA_MODULE(fcpim);
+
+/**
+ *  hal_fcpim_mod BFA FCP Initiator Mode module
+ */
+
+/**
+ * 		Compute and return memory needed by FCP(im) module.
+ */
+static void
+bfa_fcpim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	bfa_itnim_meminfo(cfg, km_len, dm_len);
+
+	/**
+	 * IO memory
+	 */
+	if (cfg->fwcfg.num_ioim_reqs < BFA_IOIM_MIN)
+		cfg->fwcfg.num_ioim_reqs = BFA_IOIM_MIN;
+	else if (cfg->fwcfg.num_ioim_reqs > BFA_IOIM_MAX)
+		cfg->fwcfg.num_ioim_reqs = BFA_IOIM_MAX;
+
+	*km_len += cfg->fwcfg.num_ioim_reqs *
+	  (sizeof(struct bfa_ioim_s) + sizeof(struct bfa_ioim_sp_s));
+
+	*dm_len += cfg->fwcfg.num_ioim_reqs * BFI_IOIM_SNSLEN;
+
+	/**
+	 * task management command memory
+	 */
+	if (cfg->fwcfg.num_tskim_reqs < BFA_TSKIM_MIN)
+		cfg->fwcfg.num_tskim_reqs = BFA_TSKIM_MIN;
+	*km_len += cfg->fwcfg.num_tskim_reqs * sizeof(struct bfa_tskim_s);
+}
+
+
+static void
+bfa_fcpim_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		     struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	bfa_trc(bfa, cfg->drvcfg.path_tov);
+	bfa_trc(bfa, cfg->fwcfg.num_rports);
+	bfa_trc(bfa, cfg->fwcfg.num_ioim_reqs);
+	bfa_trc(bfa, cfg->fwcfg.num_tskim_reqs);
+
+	fcpim->bfa            = bfa;
+	fcpim->num_itnims     = cfg->fwcfg.num_rports;
+	fcpim->num_ioim_reqs  = cfg->fwcfg.num_ioim_reqs;
+	fcpim->num_tskim_reqs = cfg->fwcfg.num_tskim_reqs;
+	fcpim->path_tov       = cfg->drvcfg.path_tov;
+	fcpim->delay_comp	  = cfg->drvcfg.delay_comp;
+
+	bfa_itnim_attach(fcpim, meminfo);
+	bfa_tskim_attach(fcpim, meminfo);
+	bfa_ioim_attach(fcpim, meminfo);
+}
+
+static void
+bfa_fcpim_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcpim_detach(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	bfa_ioim_detach(fcpim);
+	bfa_tskim_detach(fcpim);
+}
+
+static void
+bfa_fcpim_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcpim_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcpim_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_itnim_s *itnim;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
+		itnim = (struct bfa_itnim_s *) qe;
+		bfa_itnim_iocdisable(itnim);
+	}
+}
+
+void
+bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	fcpim->path_tov = path_tov * 1000;
+	if (fcpim->path_tov > BFA_FCPIM_PATHTOV_MAX)
+		fcpim->path_tov = BFA_FCPIM_PATHTOV_MAX;
+}
+
+u16
+bfa_fcpim_path_tov_get(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	return (fcpim->path_tov / 1000);
+}
+
+bfa_status_t
+bfa_fcpim_get_modstats(struct bfa_s *bfa, struct bfa_fcpim_stats_s *modstats)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	*modstats = fcpim->stats;
+
+	return BFA_STATUS_OK;
+}
+
+bfa_status_t
+bfa_fcpim_clr_modstats(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	memset(&fcpim->stats, 0, sizeof(struct bfa_fcpim_stats_s));
+
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	bfa_assert(q_depth <= BFA_IOCFC_QDEPTH_MAX);
+
+	fcpim->q_depth = q_depth;
+}
+
+u16
+bfa_fcpim_qdepth_get(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	return (fcpim->q_depth);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcpim_priv.h patch/drivers/scsi/bfa/bfa_fcpim_priv.h
--- orig/drivers/scsi/bfa/bfa_fcpim_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcpim_priv.h	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,188 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCPIM_PRIV_H__
+#define __BFA_FCPIM_PRIV_H__
+
+#include <bfa_fcpim.h>
+#include <defs/bfa_defs_fcpim.h>
+#include <cs/bfa_wc.h>
+#include "bfa_sgpg_priv.h"
+
+#define BFA_ITNIM_MIN   32
+#define BFA_ITNIM_MAX   1024
+
+#define BFA_IOIM_MIN    8
+#define BFA_IOIM_MAX    2000
+
+#define BFA_TSKIM_MIN   4
+#define BFA_TSKIM_MAX   512
+#define BFA_FCPIM_PATHTOV_DEF	(30 * 1000)	/* in millisecs */
+#define BFA_FCPIM_PATHTOV_MAX	(90 * 1000)	/* in millisecs */
+
+#define bfa_fcpim_stats(__fcpim, __stats)   \
+    (__fcpim)->stats.__stats ++
+
+struct bfa_fcpim_mod_s {
+	struct bfa_s 	*bfa;
+	struct bfa_itnim_s 	*itnim_arr;
+	struct bfa_ioim_s 	*ioim_arr;
+	struct bfa_ioim_sp_s *ioim_sp_arr;
+	struct bfa_tskim_s 	*tskim_arr;
+	struct bfa_dma_s	snsbase;
+	int			num_itnims;
+	int			num_ioim_reqs;
+	int			num_tskim_reqs;
+	u32		path_tov;
+	u16		q_depth;
+	u16		rsvd;
+	struct list_head 	itnim_q;        /*  queue of active itnim    */
+	struct list_head 	ioim_free_q;    /*  free IO resources        */
+	struct list_head 	ioim_resfree_q; /*  IOs waiting for f/w      */
+	struct list_head 	ioim_comp_q;    /*  IO global comp Q         */
+	struct list_head 	tskim_free_q;
+	u32	ios_active;	/*  current active IOs	      */
+	u32	delay_comp;
+	struct bfa_fcpim_stats_s stats;
+};
+
+struct bfa_ioim_s;
+struct bfa_tskim_s;
+
+/**
+ * BFA IO (initiator mode)
+ */
+struct bfa_ioim_s {
+	struct list_head qe;		/*  queue elememt            */
+	bfa_sm_t		sm; 	/*  BFA ioim state machine   */
+	struct bfa_s 	        *bfa;	/*  BFA module               */
+	struct bfa_fcpim_mod_s	*fcpim;	/*  parent fcpim module      */
+	struct bfa_itnim_s 	*itnim;	/*  i-t-n nexus for this IO  */
+	struct bfad_ioim_s 	*dio;	/*  driver IO handle         */
+	u16	iotag;		/*  FWI IO tag               */
+	u16	abort_tag;	/*  unqiue abort request tag */
+	u16	nsges;		/*  number of SG elements    */
+	u16	nsgpgs;		/*  number of SG pages       */
+	struct bfa_sgpg_s *sgpg;	/*  first SG page            */
+	struct list_head sgpg_q;		/*  allocated SG pages       */
+	struct bfa_cb_qe_s hcb_qe;	/*  bfa callback qelem       */
+	bfa_cb_cbfn_t io_cbfn;		/*  IO completion handler    */
+	struct bfa_ioim_sp_s *iosp;	/*  slow-path IO handling    */
+};
+
+struct bfa_ioim_sp_s {
+	struct bfi_msg_s 	comp_rspmsg;	/*  IO comp f/w response     */
+	u8			*snsinfo;	/*  sense info for this IO   */
+	struct bfa_sgpg_wqe_s sgpg_wqe;	/*  waitq elem for sgpg      */
+	struct bfa_reqq_wait_s reqq_wait;	/*  to wait for room in reqq */
+	bfa_boolean_t		abort_explicit;	/*  aborted by OS            */
+	struct bfa_tskim_s	*tskim;		/*  Relevant TM cmd          */
+};
+
+/**
+ * BFA Task management command (initiator mode)
+ */
+struct bfa_tskim_s {
+	struct list_head          qe;
+	bfa_sm_t		sm;
+	struct bfa_s            *bfa;        /*  BFA module  */
+	struct bfa_fcpim_mod_s  *fcpim;      /*  parent fcpim module      */
+	struct bfa_itnim_s      *itnim;      /*  i-t-n nexus for this IO  */
+	struct bfad_tskim_s         *dtsk;   /*  driver task mgmt cmnd    */
+	bfa_boolean_t        notify;         /*  notify itnim on TM comp  */
+	lun_t                lun;            /*  lun if applicable        */
+	enum fcp_tm_cmnd        tm_cmnd;     /*  task management command  */
+	u16             tsk_tag;        /*  FWI IO tag               */
+	u8              tsecs;          /*  timeout in seconds       */
+	struct bfa_reqq_wait_s  reqq_wait;   /*  to wait for room in reqq */
+	struct list_head              io_q;    /*  queue of affected IOs    */
+	struct bfa_wc_s             wc;      /*  waiting counter          */
+	struct bfa_cb_qe_s	hcb_qe;      /*  bfa callback qelem       */
+	enum bfi_tskim_status   tsk_status;  /*  TM status                */
+};
+
+/**
+ * BFA i-t-n (initiator mode)
+ */
+struct bfa_itnim_s {
+	struct list_head    qe;		/*  queue element               */
+	bfa_sm_t	  sm;		/*  i-t-n im BFA state machine  */
+	struct bfa_s      *bfa;		/*  bfa instance                */
+	struct bfa_rport_s *rport;	/*  bfa rport                   */
+	void           *ditn;		/*  driver i-t-n structure      */
+	struct bfi_mhdr_s      mhdr;	/*  pre-built mhdr              */
+	u8         msg_no;		/*  itnim/rport firmware handle */
+	u8         reqq;		/*  CQ for requests             */
+	struct bfa_cb_qe_s    hcb_qe;	/*  bfa callback qelem          */
+	struct list_head pending_q;	/*  queue of pending IO requests*/
+	struct list_head io_q;		/*  queue of active IO requests */
+	struct list_head io_cleanup_q;	/*  IO being cleaned up         */
+	struct list_head tsk_q;		/*  queue of active TM commands */
+	struct list_head  delay_comp_q;/*  queue of failed inflight cmds */
+	bfa_boolean_t   seq_rec;	/*  SQER supported              */
+	bfa_boolean_t   is_online;	/*  itnim is ONLINE for IO      */
+	bfa_boolean_t   iotov_active;	/*  IO TOV timer is active	 */
+	struct bfa_wc_s        wc;	/*  waiting counter             */
+	struct bfa_timer_s timer;	/*  pending IO TOV		 */
+	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
+	struct bfa_fcpim_mod_s *fcpim;	/*  fcpim module                */
+	struct bfa_itnim_hal_stats_s	stats;
+};
+
+#define bfa_itnim_is_online(_itnim) (_itnim)->is_online
+#define BFA_FCPIM_MOD(_hal) (&(_hal)->modules.fcpim_mod)
+#define BFA_IOIM_FROM_TAG(_fcpim, _iotag)	\
+	(&fcpim->ioim_arr[_iotag])
+#define BFA_TSKIM_FROM_TAG(_fcpim, _tmtag)                  \
+    (&fcpim->tskim_arr[_tmtag & (fcpim->num_tskim_reqs - 1)])
+
+/*
+ * function prototypes
+ */
+void            bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim,
+				    struct bfa_meminfo_s *minfo);
+void            bfa_ioim_detach(struct bfa_fcpim_mod_s *fcpim);
+void            bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void            bfa_ioim_good_comp_isr(struct bfa_s *bfa,
+					struct bfi_msg_s *msg);
+void            bfa_ioim_cleanup(struct bfa_ioim_s *ioim);
+void            bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim,
+					struct bfa_tskim_s *tskim);
+void            bfa_ioim_iocdisable(struct bfa_ioim_s *ioim);
+void            bfa_ioim_tov(struct bfa_ioim_s *ioim);
+
+void            bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim,
+				     struct bfa_meminfo_s *minfo);
+void            bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim);
+void            bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void            bfa_tskim_iodone(struct bfa_tskim_s *tskim);
+void            bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
+void            bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
+
+void            bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+				      u32 *dm_len);
+void            bfa_itnim_attach(struct bfa_fcpim_mod_s *fcpim,
+				     struct bfa_meminfo_s *minfo);
+void            bfa_itnim_detach(struct bfa_fcpim_mod_s *fcpim);
+void            bfa_itnim_iocdisable(struct bfa_itnim_s *itnim);
+void            bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void            bfa_itnim_iodone(struct bfa_itnim_s *itnim);
+void            bfa_itnim_tskdone(struct bfa_itnim_s *itnim);
+bfa_boolean_t   bfa_itnim_hold_io(struct bfa_itnim_s *itnim);
+
+#endif /* __BFA_FCPIM_PRIV_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcport.c patch/drivers/scsi/bfa/bfa_fcport.c
--- orig/drivers/scsi/bfa/bfa_fcport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcport.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,1671 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_pport.h>
+#include <cs/bfa_debug.h>
+#include <aen/bfa_aen.h>
+#include <cs/bfa_plog.h>
+#include <aen/bfa_aen_port.h>
+
+BFA_TRC_FILE(HAL, PPORT);
+BFA_MODULE(pport);
+
+#define bfa_pport_callback(__pport, __event) do {			\
+	if ((__pport)->bfa->fcs) {      \
+		(__pport)->event_cbfn((__pport)->event_cbarg, (__event));      \
+	} else {							\
+		(__pport)->hcb_event = (__event);      \
+		bfa_cb_queue((__pport)->bfa, &(__pport)->hcb_qe,	\
+		__bfa_cb_port_event, (__pport));      \
+	}								\
+} while (0)
+
+/*
+ * The port is considered disabled if corresponding physical port or IOC are
+ * disabled explicitly
+ */
+#define BFA_PORT_IS_DISABLED(bfa) \
+	((bfa_pport_is_disabled(bfa) == BFA_TRUE) || \
+	(bfa_ioc_is_disabled(&bfa->ioc) == BFA_TRUE))
+
+/*
+ * forward declarations
+ */
+static bfa_boolean_t bfa_pport_send_enable(struct bfa_pport_s *port);
+static bfa_boolean_t bfa_pport_send_disable(struct bfa_pport_s *port);
+static void     bfa_pport_update_linkinfo(struct bfa_pport_s *pport);
+static void     bfa_pport_reset_linkinfo(struct bfa_pport_s *pport);
+static void     bfa_pport_set_wwns(struct bfa_pport_s *port);
+static void     __bfa_cb_port_event(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete);
+static void     bfa_port_stats_timeout(void *cbarg);
+static void     bfa_port_stats_clr_timeout(void *cbarg);
+
+/**
+ *  bfa_pport_private
+ */
+
+/**
+ * BFA port state machine events
+ */
+enum bfa_pport_sm_event {
+	BFA_PPORT_SM_START = 1,	/*  start port state machine */
+	BFA_PPORT_SM_STOP = 2,	/*  stop port state machine */
+	BFA_PPORT_SM_ENABLE = 3,	/*  enable port */
+	BFA_PPORT_SM_DISABLE = 4,	/*  disable port state machine */
+	BFA_PPORT_SM_FWRSP = 5,	/*  firmware enable/disable rsp */
+	BFA_PPORT_SM_LINKUP = 6,	/*  firmware linkup event */
+	BFA_PPORT_SM_LINKDOWN = 7,	/*  firmware linkup down */
+	BFA_PPORT_SM_QRESUME = 8,	/*  CQ space available */
+	BFA_PPORT_SM_HWFAIL = 9,	/*  IOC h/w failure */
+};
+
+static void     bfa_pport_sm_uninit(struct bfa_pport_s *pport,
+				    enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_enabling_qwait(struct bfa_pport_s *pport,
+					    enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_enabling(struct bfa_pport_s *pport,
+				      enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_linkdown(struct bfa_pport_s *pport,
+				      enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_linkup(struct bfa_pport_s *pport,
+				    enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_disabling(struct bfa_pport_s *pport,
+				       enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_disabling_qwait(struct bfa_pport_s *pport,
+					     enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_disabled(struct bfa_pport_s *pport,
+				      enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_stopped(struct bfa_pport_s *pport,
+				     enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_iocdown(struct bfa_pport_s *pport,
+				     enum bfa_pport_sm_event event);
+static void     bfa_pport_sm_iocfail(struct bfa_pport_s *pport,
+				     enum bfa_pport_sm_event event);
+
+static struct bfa_sm_table_s hal_pport_sm_table[] = {
+	{BFA_SM(bfa_pport_sm_uninit), BFA_PPORT_ST_UNINIT},
+	{BFA_SM(bfa_pport_sm_enabling_qwait), BFA_PPORT_ST_ENABLING_QWAIT},
+	{BFA_SM(bfa_pport_sm_enabling), BFA_PPORT_ST_ENABLING},
+	{BFA_SM(bfa_pport_sm_linkdown), BFA_PPORT_ST_LINKDOWN},
+	{BFA_SM(bfa_pport_sm_linkup), BFA_PPORT_ST_LINKUP},
+	{BFA_SM(bfa_pport_sm_disabling_qwait),
+	 BFA_PPORT_ST_DISABLING_QWAIT},
+	{BFA_SM(bfa_pport_sm_disabling), BFA_PPORT_ST_DISABLING},
+	{BFA_SM(bfa_pport_sm_disabled), BFA_PPORT_ST_DISABLED},
+	{BFA_SM(bfa_pport_sm_stopped), BFA_PPORT_ST_STOPPED},
+	{BFA_SM(bfa_pport_sm_iocdown), BFA_PPORT_ST_IOCDOWN},
+	{BFA_SM(bfa_pport_sm_iocfail), BFA_PPORT_ST_IOCDOWN},
+};
+
+static void
+bfa_pport_aen_post(struct bfa_pport_s *pport, enum bfa_port_aen_event event)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = pport->bfa->logm;
+	wwn_t           pwwn = pport->pwwn;
+	char            pwwn_ptr[BFA_STRING_32];
+	struct bfa_ioc_attr_s ioc_attr;
+
+	wwn2str(pwwn_ptr, pwwn);
+	switch (event) {
+	case BFA_PORT_AEN_ONLINE:
+		bfa_log(logmod, BFA_AEN_PORT_ONLINE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_OFFLINE:
+		bfa_log(logmod, BFA_AEN_PORT_OFFLINE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_ENABLE:
+		bfa_log(logmod, BFA_AEN_PORT_ENABLE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_DISABLE:
+		bfa_log(logmod, BFA_AEN_PORT_DISABLE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_DISCONNECT:
+		bfa_log(logmod, BFA_AEN_PORT_DISCONNECT, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_QOS_NEG:
+		bfa_log(logmod, BFA_AEN_PORT_QOS_NEG, pwwn_ptr);
+		break;
+	default:
+		break;
+	}
+
+	bfa_ioc_get_attr(&pport->bfa->ioc, &ioc_attr);
+	aen_data.port.ioc_type = ioc_attr.ioc_type;
+	aen_data.port.pwwn = pwwn;
+}
+
+static void
+bfa_pport_sm_uninit(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		/**
+		 * Start event after IOC is configured and BFA is started.
+		 */
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Port is persistently configured to be in enabled state. Do
+		 * not change state. Port enabling is done when START event is
+		 * received.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * If a port is persistently configured to be disabled, the
+		 * first event will a port disable request.
+		 */
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_enabling_qwait(struct bfa_pport_s *pport,
+			    enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_QRESUME:
+		bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		bfa_pport_send_enable(pport);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already enable is in progress.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Just send disable request to firmware when room becomes
+		 * available in request queue.
+		 */
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link events when doing back-to-back
+		 * enable/disables.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_enabling(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_FWRSP:
+	case BFA_PPORT_SM_LINKDOWN:
+		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+		bfa_pport_update_linkinfo(pport);
+		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
+
+		bfa_assert(pport->event_cbfn);
+		bfa_pport_callback(pport, BFA_PPORT_LINKUP);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already being enabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		if (bfa_pport_send_disable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_linkdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_LINKUP:
+		bfa_pport_update_linkinfo(pport);
+		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
+		bfa_assert(pport->event_cbfn);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
+		bfa_pport_callback(pport, BFA_PPORT_LINKUP);
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ONLINE);
+		/**
+		 * If QoS is enabled and it is not online,
+		 * Send a separate event.
+		 */
+		if ((pport->cfg.qos_enabled)
+		    && (bfa_os_ntohl(pport->qos_attr.state) != BFA_QOS_ONLINE))
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_QOS_NEG);
+
+		break;
+
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link down event.
+		 */
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already enabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		if (bfa_pport_send_disable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_linkup(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already enabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		if (bfa_pport_send_disable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+
+		bfa_pport_reset_linkinfo(pport);
+		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_LINKDOWN:
+		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
+		bfa_pport_reset_linkinfo(pport);
+		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
+		if (BFA_PORT_IS_DISABLED(pport->bfa)) {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		} else {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+		}
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		bfa_pport_reset_linkinfo(pport);
+		if (BFA_PORT_IS_DISABLED(pport->bfa)) {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		} else {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+		}
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		bfa_pport_reset_linkinfo(pport);
+		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
+		if (BFA_PORT_IS_DISABLED(pport->bfa)) {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		} else {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+		}
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_disabling_qwait(struct bfa_pport_s *pport,
+			     enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_QRESUME:
+		bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		bfa_pport_send_disable(pport);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Already being disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link events when doing back-to-back
+		 * enable/disables.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_disabling(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_FWRSP:
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Already being disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link events when doing back-to-back
+		 * enable/disables.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_disabled(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		/**
+		 * Ignore start event for a port that is disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+			     BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Already disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+		break;
+
+	default:
+		bfa_sm_fault(pport->bfa, event);
+	}
+}
+
+static void
+bfa_pport_sm_stopped(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+		break;
+
+	default:
+		/**
+		 * Ignore all other events.
+		 */
+		;
+	}
+}
+
+/**
+ * Port is enabled. IOC is down/failed.
+ */
+static void
+bfa_pport_sm_iocdown(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+		break;
+
+	default:
+		/**
+		 * Ignore all events.
+		 */
+		;
+	}
+}
+
+/**
+ * Port is disabled. IOC is down/failed.
+ */
+static void
+bfa_pport_sm_iocfail(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		/**
+		 * Ignore all events.
+		 */
+		;
+	}
+}
+
+
+
+/**
+ *  bfa_pport_private
+ */
+
+static void
+__bfa_cb_port_event(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_pport_s *pport = cbarg;
+
+	if (complete)
+		pport->event_cbfn(pport->event_cbarg, pport->hcb_event);
+}
+
+#define PPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_pport_stats_u), \
+							BFA_CACHELINE_SZ))
+
+static void
+bfa_pport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+		  u32 *dm_len)
+{
+	*dm_len += PPORT_STATS_DMA_SZ;
+}
+
+static void
+bfa_pport_qresume(void *cbarg)
+{
+	struct bfa_pport_s *port = cbarg;
+
+	bfa_sm_send_event(port, BFA_PPORT_SM_QRESUME);
+}
+
+static void
+bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
+{
+	u8        *dm_kva;
+	u64        dm_pa;
+
+	dm_kva = bfa_meminfo_dma_virt(meminfo);
+	dm_pa = bfa_meminfo_dma_phys(meminfo);
+
+	pport->stats_kva = dm_kva;
+	pport->stats_pa = dm_pa;
+	pport->stats = (union bfa_pport_stats_u *)dm_kva;
+
+	dm_kva += PPORT_STATS_DMA_SZ;
+	dm_pa += PPORT_STATS_DMA_SZ;
+
+	bfa_meminfo_dma_virt(meminfo) = dm_kva;
+	bfa_meminfo_dma_phys(meminfo) = dm_pa;
+}
+
+/**
+ * Memory initialization.
+ */
+static void
+bfa_pport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		 struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_pport_cfg_s *port_cfg = &pport->cfg;
+
+	bfa_os_memset(pport, 0, sizeof(struct bfa_pport_s));
+	pport->bfa = bfa;
+
+	bfa_pport_mem_claim(pport, meminfo);
+
+	bfa_sm_set_state(pport, bfa_pport_sm_uninit);
+
+	/**
+	 * initialize and set default configuration
+	 */
+	port_cfg->topology = BFA_PPORT_TOPOLOGY_P2P;
+	port_cfg->speed = BFA_PPORT_SPEED_AUTO;
+	port_cfg->trunked = BFA_FALSE;
+	port_cfg->maxfrsize = 0;
+
+	port_cfg->trl_def_speed = BFA_PPORT_SPEED_1GBPS;
+
+	bfa_reqq_winit(&pport->reqq_wait, bfa_pport_qresume, pport);
+}
+
+static void
+bfa_pport_initdone(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	/**
+	 * Initialize port attributes from IOC hardware data.
+	 */
+	bfa_pport_set_wwns(pport);
+	if (pport->cfg.maxfrsize == 0)
+		pport->cfg.maxfrsize = bfa_ioc_maxfrsize(&bfa->ioc);
+	pport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
+	pport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
+
+	bfa_assert(pport->cfg.maxfrsize);
+	bfa_assert(pport->cfg.rx_bbcredit);
+	bfa_assert(pport->speed_sup);
+}
+
+static void
+bfa_pport_detach(struct bfa_s *bfa)
+{
+}
+
+/**
+ * Called when IOC is ready.
+ */
+static void
+bfa_pport_start(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_START);
+}
+
+/**
+ * Called before IOC is stopped.
+ */
+static void
+bfa_pport_stop(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_STOP);
+}
+
+/**
+ * Called when IOC failure is detected.
+ */
+static void
+bfa_pport_iocdisable(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_HWFAIL);
+}
+
+static void
+bfa_pport_update_linkinfo(struct bfa_pport_s *pport)
+{
+	struct bfi_pport_event_s *pevent = pport->event_arg.i2hmsg.event;
+
+	pport->speed = pevent->link_state.speed;
+	pport->topology = pevent->link_state.topology;
+
+	if (pport->topology == BFA_PPORT_TOPOLOGY_LOOP)
+		pport->myalpa = pevent->link_state.tl.loop_info.myalpa;
+
+	/*
+	 * QoS Details
+	 */
+	bfa_os_assign(pport->qos_attr, pevent->link_state.qos_attr);
+	bfa_os_assign(pport->qos_vc_attr, pevent->link_state.qos_vc_attr);
+
+	bfa_trc(pport->bfa, pport->speed);
+	bfa_trc(pport->bfa, pport->topology);
+}
+
+static void
+bfa_pport_reset_linkinfo(struct bfa_pport_s *pport)
+{
+	pport->speed = BFA_PPORT_SPEED_UNKNOWN;
+	pport->topology = BFA_PPORT_TOPOLOGY_NONE;
+}
+
+/**
+ * Send port enable message to firmware.
+ */
+static          bfa_boolean_t
+bfa_pport_send_enable(struct bfa_pport_s *port)
+{
+	struct bfi_pport_enable_req_s *m;
+
+	/**
+	 * Increment message tag before queue check, so that responses to old
+	 * requests are discarded.
+	 */
+	port->msgtag++;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	if (!m) {
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_ENABLE_REQ,
+		    bfa_lpuid(port->bfa));
+	m->nwwn = port->nwwn;
+	m->pwwn = port->pwwn;
+	m->port_cfg = port->cfg;
+	m->msgtag = port->msgtag;
+	m->port_cfg.maxfrsize = bfa_os_htons(port->cfg.maxfrsize);
+	bfa_dma_be_addr_set(m->stats_dma_addr, port->stats_pa);
+	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_lo);
+	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_hi);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	return BFA_TRUE;
+}
+
+/**
+ * Send port disable message to firmware.
+ */
+static          bfa_boolean_t
+bfa_pport_send_disable(struct bfa_pport_s *port)
+{
+	bfi_pport_disable_req_t *m;
+
+	/**
+	 * Increment message tag before queue check, so that responses to old
+	 * requests are discarded.
+	 */
+	port->msgtag++;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	if (!m) {
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_DISABLE_REQ,
+		    bfa_lpuid(port->bfa));
+	m->msgtag = port->msgtag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+
+	return BFA_TRUE;
+}
+
+static void
+bfa_pport_set_wwns(struct bfa_pport_s *port)
+{
+	port->pwwn = bfa_ioc_get_pwwn(&port->bfa->ioc);
+	port->nwwn = bfa_ioc_get_nwwn(&port->bfa->ioc);
+
+	bfa_trc(port->bfa, port->pwwn);
+	bfa_trc(port->bfa, port->nwwn);
+}
+
+static void
+bfa_port_send_txcredit(void *port_cbarg)
+{
+
+	struct bfa_pport_s *port = port_cbarg;
+	struct bfi_pport_set_svc_params_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	if (!m) {
+		bfa_trc(port->bfa, port->cfg.tx_bbcredit);
+		return;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_SET_SVC_PARAMS_REQ,
+		    bfa_lpuid(port->bfa));
+	m->tx_bbcredit = bfa_os_htons((u16) port->cfg.tx_bbcredit);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+}
+
+
+
+/**
+ *  bfa_pport_public
+ */
+
+/**
+ * Firmware message handler.
+ */
+void
+bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	union bfi_pport_i2h_msg_u i2hmsg;
+
+	i2hmsg.msg = msg;
+	pport->event_arg.i2hmsg = i2hmsg;
+
+	switch (msg->mhdr.msg_id) {
+	case BFI_PPORT_I2H_ENABLE_RSP:
+		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+		break;
+
+	case BFI_PPORT_I2H_DISABLE_RSP:
+		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+		break;
+
+	case BFI_PPORT_I2H_EVENT:
+		switch (i2hmsg.event->link_state.linkstate) {
+		case BFA_PPORT_LINKUP:
+			bfa_sm_send_event(pport, BFA_PPORT_SM_LINKUP);
+			break;
+		case BFA_PPORT_LINKDOWN:
+			bfa_sm_send_event(pport, BFA_PPORT_SM_LINKDOWN);
+			break;
+		case BFA_PPORT_TRUNK_LINKDOWN:
+			/** todo: event notification */
+			break;
+		}
+		break;
+
+	case BFI_PPORT_I2H_GET_STATS_RSP:
+	case BFI_PPORT_I2H_GET_QOS_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (pport->stats_busy == BFA_FALSE
+		    || pport->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&pport->timer);
+		pport->stats_status = i2hmsg.getstats_rsp->status;
+		bfa_cb_queue(pport->bfa, &pport->hcb_qe, __bfa_cb_port_stats,
+			     pport);
+		break;
+	case BFI_PPORT_I2H_CLEAR_STATS_RSP:
+	case BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (pport->stats_busy == BFA_FALSE
+		    || pport->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&pport->timer);
+		pport->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(pport->bfa, &pport->hcb_qe,
+			     __bfa_cb_port_stats_clr, pport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_pport_api
+ */
+
+/**
+ * Registered callback for port events.
+ */
+void
+bfa_pport_event_register(struct bfa_s *bfa,
+			 void (*cbfn) (void *cbarg, bfa_pport_event_t event),
+			 void *cbarg)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	pport->event_cbfn = cbfn;
+	pport->event_cbarg = cbarg;
+}
+
+bfa_status_t
+bfa_pport_enable(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	if (pport->diag_busy)
+		return (BFA_STATUS_DIAG_BUSY);
+	else if (bfa_sm_cmp_state
+		 (BFA_PORT_MOD(bfa), bfa_pport_sm_disabling_qwait))
+		return (BFA_STATUS_DEVBUSY);
+
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_ENABLE);
+	return BFA_STATUS_OK;
+}
+
+bfa_status_t
+bfa_pport_disable(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_DISABLE);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Configure port speed.
+ */
+bfa_status_t
+bfa_pport_cfg_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, speed);
+
+	if ((speed != BFA_PPORT_SPEED_AUTO) && (speed > pport->speed_sup)) {
+		bfa_trc(bfa, pport->speed_sup);
+		return BFA_STATUS_UNSUPP_SPEED;
+	}
+
+	pport->cfg.speed = speed;
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Get current speed.
+ */
+enum bfa_pport_speed
+bfa_pport_get_speed(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->speed;
+}
+
+/**
+ * Configure port topology.
+ */
+bfa_status_t
+bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, topology);
+	bfa_trc(bfa, pport->cfg.topology);
+
+	switch (topology) {
+	case BFA_PPORT_TOPOLOGY_P2P:
+	case BFA_PPORT_TOPOLOGY_LOOP:
+	case BFA_PPORT_TOPOLOGY_AUTO:
+		break;
+
+	default:
+		return BFA_STATUS_EINVAL;
+	}
+
+	pport->cfg.topology = topology;
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Get current topology.
+ */
+enum bfa_pport_topology
+bfa_pport_get_topology(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->topology;
+}
+
+bfa_status_t
+bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, alpa);
+	bfa_trc(bfa, pport->cfg.cfg_hardalpa);
+	bfa_trc(bfa, pport->cfg.hardalpa);
+
+	pport->cfg.cfg_hardalpa = BFA_TRUE;
+	pport->cfg.hardalpa = alpa;
+
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_pport_clr_hardalpa(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, pport->cfg.cfg_hardalpa);
+	bfa_trc(bfa, pport->cfg.hardalpa);
+
+	pport->cfg.cfg_hardalpa = BFA_FALSE;
+	return (BFA_STATUS_OK);
+}
+
+bfa_boolean_t
+bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	*alpa = port->cfg.hardalpa;
+	return port->cfg.cfg_hardalpa;
+}
+
+u8
+bfa_pport_get_myalpa(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->myalpa;
+}
+
+bfa_status_t
+bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxfrsize)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, maxfrsize);
+	bfa_trc(bfa, pport->cfg.maxfrsize);
+
+	/*
+	 * with in range
+	 */
+	if ((maxfrsize > FC_MAX_PDUSZ) || (maxfrsize < FC_MIN_PDUSZ))
+		return (BFA_STATUS_INVLD_DFSZ);
+
+	/*
+	 * power of 2, if not the max frame size of 2112
+	 */
+	if ((maxfrsize != FC_MAX_PDUSZ) && (maxfrsize & (maxfrsize - 1)))
+		return (BFA_STATUS_INVLD_DFSZ);
+
+	pport->cfg.maxfrsize = maxfrsize;
+	return (BFA_STATUS_OK);
+}
+
+u16
+bfa_pport_get_maxfrsize(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->cfg.maxfrsize;
+}
+
+u32
+bfa_pport_mypid(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->mypid;
+}
+
+u8
+bfa_pport_get_rx_bbcredit(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->cfg.rx_bbcredit;
+}
+
+void
+bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	port->cfg.tx_bbcredit = (u8) tx_bbcredit;
+	bfa_port_send_txcredit(port);
+}
+
+/**
+ * Get port attributes.
+ */
+
+wwn_t
+bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	if (node)
+		return pport->nwwn;
+	else
+		return pport->pwwn;
+}
+
+void
+bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_os_memset(attr, 0, sizeof(struct bfa_pport_attr_s));
+
+	attr->nwwn = pport->nwwn;
+	attr->pwwn = pport->pwwn;
+
+	bfa_os_memcpy(&attr->pport_cfg, &pport->cfg,
+		      sizeof(struct bfa_pport_cfg_s));
+	/*
+	 * speed attributes
+	 */
+	attr->pport_cfg.speed = pport->cfg.speed;
+	attr->speed_supported = pport->speed_sup;
+	attr->speed = pport->speed;
+	attr->cos_supported = FC_CLASS_3;
+
+	/*
+	 * topology attributes
+	 */
+	attr->pport_cfg.topology = pport->cfg.topology;
+	attr->topology = pport->topology;
+
+	/*
+	 * beacon attributes
+	 */
+	attr->beacon = pport->beacon;
+	attr->link_e2e_beacon = pport->link_e2e_beacon;
+	attr->plog_enabled = bfa_plog_get_setting(pport->bfa->plog);
+
+	attr->pport_cfg.path_tov = bfa_fcpim_path_tov_get(bfa);
+	attr->pport_cfg.q_depth = bfa_fcpim_qdepth_get(bfa);
+	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, pport->sm);
+	if (bfa_ioc_is_disabled(&pport->bfa->ioc))
+		attr->port_state = BFA_PPORT_ST_IOCDIS;
+	else if (bfa_ioc_fw_mismatch(&pport->bfa->ioc))
+		attr->port_state = BFA_PPORT_ST_FWMISMATCH;
+}
+
+static void
+bfa_port_stats_query(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	bfi_pport_get_stats_req_t *msg;
+
+	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		port->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_stats_query,
+			       port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
+		return;
+	}
+	port->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_GET_STATS_REQ,
+		    bfa_lpuid(port->bfa));
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+
+	return;
+}
+
+static void
+bfa_port_stats_clear(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	bfi_pport_clear_stats_req_t *msg;
+
+	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		port->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_stats_clear,
+			       port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
+		return;
+	}
+	port->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_STATS_REQ,
+		    bfa_lpuid(port->bfa));
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	return;
+}
+
+static void
+bfa_port_qos_stats_clear(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+	bfi_pport_clear_qos_stats_req_t *msg;
+
+	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		port->stats_qfull = BFA_TRUE;
+		bfa_reqq_winit(&port->stats_reqq_wait, bfa_port_qos_stats_clear,
+			       port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT, &port->stats_reqq_wait);
+		return;
+	}
+	port->stats_qfull = BFA_FALSE;
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_qos_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ,
+		    bfa_lpuid(port->bfa));
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	return;
+}
+
+static void
+bfa_pport_stats_swap(union bfa_pport_stats_u *d, union bfa_pport_stats_u *s)
+{
+	u32       *dip = (u32 *) d;
+	u32       *sip = (u32 *) s;
+	int             i;
+
+	/*
+	 * Do 64 bit fields swap first
+	 */
+	for (i = 0;
+	     i <
+	     ((sizeof(union bfa_pport_stats_u) -
+	       sizeof(struct bfa_qos_stats_s)) / sizeof(u32)); i = i + 2) {
+#ifdef __BIGENDIAN
+		dip[i] = bfa_os_ntohl(sip[i]);
+		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
+#else
+		dip[i] = bfa_os_ntohl(sip[i + 1]);
+		dip[i + 1] = bfa_os_ntohl(sip[i]);
+#endif
+	}
+
+	/*
+	 * Now swap the 32 bit fields
+	 */
+	for (; i < (sizeof(union bfa_pport_stats_u) / sizeof(u32)); ++i)
+		dip[i] = bfa_os_ntohl(sip[i]);
+}
+
+static void
+__bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_pport_s *port = cbarg;
+
+	if (complete) {
+		port->stats_cbfn(port->stats_cbarg, port->stats_status);
+	} else {
+		port->stats_busy = BFA_FALSE;
+		port->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_port_stats_clr_timeout(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+
+	bfa_trc(port->bfa, port->stats_qfull);
+
+	if (port->stats_qfull) {
+		bfa_reqq_wcancel(&port->stats_reqq_wait);
+		port->stats_qfull = BFA_FALSE;
+	}
+
+	port->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats_clr, port);
+}
+
+static void
+__bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_pport_s *port = cbarg;
+
+	if (complete) {
+		if (port->stats_status == BFA_STATUS_OK)
+			bfa_pport_stats_swap(port->stats_ret, port->stats);
+		port->stats_cbfn(port->stats_cbarg, port->stats_status);
+	} else {
+		port->stats_busy = BFA_FALSE;
+		port->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_port_stats_timeout(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *)cbarg;
+
+	bfa_trc(port->bfa, port->stats_qfull);
+
+	if (port->stats_qfull) {
+		bfa_reqq_wcancel(&port->stats_reqq_wait);
+		port->stats_qfull = BFA_FALSE;
+	}
+
+	port->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats, port);
+}
+
+#define BFA_PORT_STATS_TOV	1000
+
+/**
+ * Fetch port attributes.
+ */
+bfa_status_t
+bfa_pport_get_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
+		    bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	if (port->stats_busy) {
+		bfa_trc(bfa, port->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	port->stats_busy = BFA_TRUE;
+	port->stats_ret = stats;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+
+	bfa_port_stats_query(port);
+
+	bfa_timer_start(bfa, &port->timer, bfa_port_stats_timeout, port,
+			BFA_PORT_STATS_TOV);
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	if (port->stats_busy) {
+		bfa_trc(bfa, port->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	port->stats_busy = BFA_TRUE;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+
+	bfa_port_stats_clear(port);
+
+	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
+			BFA_PORT_STATS_TOV);
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, bitmap);
+	bfa_trc(bfa, pport->cfg.trunked);
+	bfa_trc(bfa, pport->cfg.trunk_ports);
+
+	if (!bitmap || (bitmap & (bitmap - 1)))
+		return BFA_STATUS_EINVAL;
+
+	pport->cfg.trunked = BFA_TRUE;
+	pport->cfg.trunk_ports = bitmap;
+
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	qos_attr->state = bfa_os_ntohl(pport->qos_attr.state);
+	qos_attr->total_bb_cr = bfa_os_ntohl(pport->qos_attr.total_bb_cr);
+}
+
+void
+bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+			  struct bfa_qos_vc_attr_s *qos_vc_attr)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_qos_vc_attr_s *bfa_vc_attr = &pport->qos_vc_attr;
+	u32        i = 0;
+
+	qos_vc_attr->total_vc_count = bfa_os_ntohs(bfa_vc_attr->total_vc_count);
+	qos_vc_attr->shared_credit = bfa_os_ntohs(bfa_vc_attr->shared_credit);
+	qos_vc_attr->elp_opmode_flags =
+		bfa_os_ntohl(bfa_vc_attr->elp_opmode_flags);
+
+	/*
+	 * Individual VC info
+	 */
+	while (i < qos_vc_attr->total_vc_count) {
+		qos_vc_attr->vc_info[i].vc_credit =
+			bfa_vc_attr->vc_info[i].vc_credit;
+		qos_vc_attr->vc_info[i].borrow_credit =
+			bfa_vc_attr->vc_info[i].borrow_credit;
+		qos_vc_attr->vc_info[i].priority =
+			bfa_vc_attr->vc_info[i].priority;
+		++i;
+	}
+}
+
+/**
+ * Fetch QoS Stats.
+ */
+bfa_status_t
+bfa_pport_get_qos_stats(struct bfa_s *bfa, union bfa_pport_stats_u *stats,
+			bfa_cb_pport_t cbfn, void *cbarg)
+{
+	/*
+	 * QoS stats is embedded in port stats
+	 */
+	return (bfa_pport_get_stats(bfa, stats, cbfn, cbarg));
+}
+
+bfa_status_t
+bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	if (port->stats_busy) {
+		bfa_trc(bfa, port->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	port->stats_busy = BFA_TRUE;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+
+	bfa_port_qos_stats_clear(port);
+
+	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
+			BFA_PORT_STATS_TOV);
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Fetch port attributes.
+ */
+bfa_status_t
+bfa_pport_trunk_disable(struct bfa_s *bfa)
+{
+	return (BFA_STATUS_OK);
+}
+
+bfa_boolean_t
+bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	*bitmap = port->cfg.trunk_ports;
+	return port->cfg.trunked;
+}
+
+bfa_boolean_t
+bfa_pport_is_disabled(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return (bfa_sm_to_state(hal_pport_sm_table, port->sm) ==
+		BFA_PPORT_ST_DISABLED);
+
+}
+
+bfa_boolean_t
+bfa_pport_is_ratelim(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+return (pport->cfg.ratelimit ? BFA_TRUE : BFA_FALSE);
+
+}
+
+void
+bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, on_off);
+	bfa_trc(bfa, pport->cfg.qos_enabled);
+
+	pport->cfg.qos_enabled = on_off;
+}
+
+void
+bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, on_off);
+	bfa_trc(bfa, pport->cfg.ratelimit);
+
+	pport->cfg.ratelimit = on_off;
+	if (pport->cfg.trl_def_speed == BFA_PPORT_SPEED_UNKNOWN)
+		pport->cfg.trl_def_speed = BFA_PPORT_SPEED_1GBPS;
+}
+
+/**
+ * Configure default minimum ratelim speed
+ */
+bfa_status_t
+bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, speed);
+
+	/*
+	 * Auto and speeds greater than the supported speed, are invalid
+	 */
+	if ((speed == BFA_PPORT_SPEED_AUTO) || (speed > pport->speed_sup)) {
+		bfa_trc(bfa, pport->speed_sup);
+		return BFA_STATUS_UNSUPP_SPEED;
+	}
+
+	pport->cfg.trl_def_speed = speed;
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Get default minimum ratelim speed
+ */
+enum bfa_pport_speed
+bfa_pport_get_ratelim_speed(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, pport->cfg.trl_def_speed);
+	return (pport->cfg.trl_def_speed);
+
+}
+
+void
+bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, status);
+	bfa_trc(bfa, pport->diag_busy);
+
+	pport->diag_busy = status;
+}
+
+void
+bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+		 bfa_boolean_t link_e2e_beacon)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, beacon);
+	bfa_trc(bfa, link_e2e_beacon);
+	bfa_trc(bfa, pport->beacon);
+	bfa_trc(bfa, pport->link_e2e_beacon);
+
+	pport->beacon = beacon;
+	pport->link_e2e_beacon = link_e2e_beacon;
+}
+
+bfa_boolean_t
+bfa_pport_is_linkup(struct bfa_s *bfa)
+{
+	return bfa_sm_cmp_state(BFA_PORT_MOD(bfa), bfa_pport_sm_linkup);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcxp.c patch/drivers/scsi/bfa/bfa_fcxp.c
--- orig/drivers/scsi/bfa/bfa_fcxp.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcxp.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,782 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfi/bfi_uf.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, FCXP);
+BFA_MODULE(fcxp);
+
+/**
+ * forward declarations
+ */
+static void     __bfa_fcxp_send_cbfn(void *cbarg, bfa_boolean_t complete);
+static void     hal_fcxp_rx_plog(struct bfa_s *bfa, struct bfa_fcxp_s *fcxp,
+				 struct bfi_fcxp_send_rsp_s *fcxp_rsp);
+static void     hal_fcxp_tx_plog(struct bfa_s *bfa, u32 reqlen,
+				 struct bfa_fcxp_s *fcxp, struct fchs_s *fchs);
+static void	bfa_fcxp_qresume(void *cbarg);
+static void	bfa_fcxp_queue(struct bfa_fcxp_s *fcxp,
+			       struct bfi_fcxp_send_req_s *send_req);
+
+/**
+ *  fcxp_pvt BFA FCXP private functions
+ */
+
+static void
+claim_fcxp_req_rsp_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
+{
+	u8        *dm_kva = NULL;
+	u64        dm_pa;
+	u32        buf_pool_sz;
+
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa = bfa_meminfo_dma_phys(mi);
+
+	buf_pool_sz = mod->req_pld_sz * mod->num_fcxps;
+
+	/*
+	 * Initialize the fcxp req payload list
+	 */
+	mod->req_pld_list_kva = dm_kva;
+	mod->req_pld_list_pa = dm_pa;
+	dm_kva += buf_pool_sz;
+	dm_pa += buf_pool_sz;
+	bfa_os_memset(mod->req_pld_list_kva, 0, buf_pool_sz);
+
+	/*
+	 * Initialize the fcxp rsp payload list
+	 */
+	buf_pool_sz = mod->rsp_pld_sz * mod->num_fcxps;
+	mod->rsp_pld_list_kva = dm_kva;
+	mod->rsp_pld_list_pa = dm_pa;
+	dm_kva += buf_pool_sz;
+	dm_pa += buf_pool_sz;
+	bfa_os_memset(mod->rsp_pld_list_kva, 0, buf_pool_sz);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva;
+	bfa_meminfo_dma_phys(mi) = dm_pa;
+}
+
+static void
+claim_fcxps_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
+{
+	u16        i;
+	struct bfa_fcxp_s *fcxp;
+
+	fcxp = (struct bfa_fcxp_s *) bfa_meminfo_kva(mi);
+	bfa_os_memset(fcxp, 0, sizeof(struct bfa_fcxp_s) * mod->num_fcxps);
+
+	INIT_LIST_HEAD(&mod->fcxp_free_q);
+	INIT_LIST_HEAD(&mod->fcxp_active_q);
+
+	mod->fcxp_list = fcxp;
+
+	for (i = 0; i < mod->num_fcxps; i++) {
+		fcxp->fcxp_mod = mod;
+		fcxp->fcxp_tag = i;
+
+		list_add_tail(&fcxp->qe, &mod->fcxp_free_q);
+		bfa_reqq_winit(&fcxp->reqq_wqe, bfa_fcxp_qresume, fcxp);
+		fcxp->reqq_waiting = BFA_FALSE;
+
+		fcxp = fcxp + 1;
+	}
+
+	bfa_meminfo_kva(mi) = (void *)fcxp;
+}
+
+static void
+bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+		u32 *dm_len)
+{
+	u16        num_fcxp_reqs = cfg->fwcfg.num_fcxp_reqs;
+
+	if (num_fcxp_reqs == 0)
+		return;
+
+	/*
+	 * Account for req/rsp payload
+	 */
+	*dm_len += BFA_FCXP_MAX_IBUF_SZ * num_fcxp_reqs;
+	if (cfg->drvcfg.min_cfg)
+		*dm_len += BFA_FCXP_MAX_IBUF_SZ * num_fcxp_reqs;
+	else
+		*dm_len += BFA_FCXP_MAX_LBUF_SZ * num_fcxp_reqs;
+
+	/*
+	 * Account for fcxp structs
+	 */
+	*ndm_len += sizeof(struct bfa_fcxp_s) * num_fcxp_reqs;
+}
+
+static void
+bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	bfa_os_memset(mod, 0, sizeof(struct bfa_fcxp_mod_s));
+	mod->bfa = bfa;
+	mod->num_fcxps = cfg->fwcfg.num_fcxp_reqs;
+
+	/**
+	 * Initialize FCXP request and response payload sizes.
+	 */
+	mod->req_pld_sz = mod->rsp_pld_sz = BFA_FCXP_MAX_IBUF_SZ;
+	if (!cfg->drvcfg.min_cfg)
+		mod->rsp_pld_sz = BFA_FCXP_MAX_LBUF_SZ;
+
+	INIT_LIST_HEAD(&mod->wait_q);
+
+	claim_fcxp_req_rsp_mem(mod, meminfo);
+	claim_fcxps_mem(mod, meminfo);
+}
+
+static void
+bfa_fcxp_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+	struct bfa_fcxp_s *fcxp;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &mod->fcxp_active_q) {
+		fcxp = (struct bfa_fcxp_s *) qe;
+		if (fcxp->caller == NULL) {
+			fcxp->send_cbfn(fcxp->caller, fcxp, fcxp->send_cbarg,
+					BFA_STATUS_IOC_FAILURE, 0, 0, NULL);
+			bfa_fcxp_free(fcxp);
+		} else {
+			fcxp->rsp_status = BFA_STATUS_IOC_FAILURE;
+			bfa_cb_queue(bfa, &fcxp->hcb_qe,
+				      __bfa_fcxp_send_cbfn, fcxp);
+		}
+	}
+}
+
+static struct bfa_fcxp_s *
+bfa_fcxp_get(struct bfa_fcxp_mod_s *fm)
+{
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_q_deq(&fm->fcxp_free_q, &fcxp);
+
+	if (fcxp)
+		list_add_tail(&fcxp->qe, &fm->fcxp_active_q);
+
+	return (fcxp);
+}
+
+static void
+bfa_fcxp_put(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+	struct bfa_fcxp_wqe_s *wqe;
+
+	bfa_q_deq(&mod->wait_q, &wqe);
+	if (wqe) {
+		bfa_trc(mod->bfa, fcxp->fcxp_tag);
+		wqe->alloc_cbfn(wqe->alloc_cbarg, fcxp);
+		return;
+	}
+
+	bfa_assert(bfa_q_is_on_q(&mod->fcxp_active_q, fcxp));
+	list_del(&fcxp->qe);
+	list_add_tail(&fcxp->qe, &mod->fcxp_free_q);
+}
+
+static void
+bfa_fcxp_null_comp(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
+		       bfa_status_t req_status, u32 rsp_len,
+		       u32 resid_len, struct fchs_s *rsp_fchs)
+{
+	/**discarded fcxp completion */
+}
+
+static void
+__bfa_fcxp_send_cbfn(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_fcxp_s *fcxp = cbarg;
+
+	if (complete) {
+		fcxp->send_cbfn(fcxp->caller, fcxp, fcxp->send_cbarg,
+				fcxp->rsp_status, fcxp->rsp_len,
+				fcxp->residue_len, &fcxp->rsp_fchs);
+	} else {
+		bfa_fcxp_free(fcxp);
+	}
+}
+
+static void
+hal_fcxp_send_comp(struct bfa_s *bfa, struct bfi_fcxp_send_rsp_s *fcxp_rsp)
+{
+	struct bfa_fcxp_mod_s	*mod = BFA_FCXP_MOD(bfa);
+	struct bfa_fcxp_s 	*fcxp;
+	u16		fcxp_tag = bfa_os_ntohs(fcxp_rsp->fcxp_tag);
+
+	bfa_trc(bfa, fcxp_tag);
+
+	fcxp_rsp->rsp_len = bfa_os_ntohl(fcxp_rsp->rsp_len);
+
+	/**
+	 * @todo f/w should not set residue to non-0 when everything
+	 *       is received.
+	 */
+	if (fcxp_rsp->req_status == BFA_STATUS_OK)
+		fcxp_rsp->residue_len = 0;
+	else
+		fcxp_rsp->residue_len = bfa_os_ntohl(fcxp_rsp->residue_len);
+
+	fcxp = BFA_FCXP_FROM_TAG(mod, fcxp_tag);
+
+	bfa_assert(fcxp->send_cbfn != NULL);
+
+	hal_fcxp_rx_plog(mod->bfa, fcxp, fcxp_rsp);
+
+	if (fcxp->send_cbfn != NULL) {
+		if (fcxp->caller == NULL) {
+			bfa_trc(mod->bfa, fcxp->fcxp_tag);
+
+			fcxp->send_cbfn(fcxp->caller, fcxp, fcxp->send_cbarg,
+					fcxp_rsp->req_status, fcxp_rsp->rsp_len,
+					fcxp_rsp->residue_len, &fcxp_rsp->fchs);
+			/*
+			 * fcxp automatically freed on return from the callback
+			 */
+			bfa_fcxp_free(fcxp);
+		} else {
+			bfa_trc(mod->bfa, fcxp->fcxp_tag);
+			fcxp->rsp_status = fcxp_rsp->req_status;
+			fcxp->rsp_len = fcxp_rsp->rsp_len;
+			fcxp->residue_len = fcxp_rsp->residue_len;
+			fcxp->rsp_fchs = fcxp_rsp->fchs;
+
+			bfa_cb_queue(bfa, &fcxp->hcb_qe,
+				      __bfa_fcxp_send_cbfn, fcxp);
+		}
+	} else {
+		bfa_trc(bfa, fcxp_tag);
+	}
+}
+
+static void
+hal_fcxp_set_local_sges(struct bfi_sge_s *sge, u32 reqlen, u64 req_pa)
+{
+	union bfi_addr_u      sga_zero = { {0} };
+
+	sge->sg_len = reqlen;
+	sge->flags = BFI_SGE_DATA_LAST;
+	bfa_dma_addr_set(sge[0].sga, req_pa);
+	bfa_sge_to_be(sge);
+	sge++;
+
+	sge->sga = sga_zero;
+	sge->sg_len = reqlen;
+	sge->flags = BFI_SGE_PGDLEN;
+	bfa_sge_to_be(sge);
+}
+
+static void
+hal_fcxp_tx_plog(struct bfa_s *bfa, u32 reqlen, struct bfa_fcxp_s *fcxp,
+		 struct fchs_s *fchs)
+{
+	/*
+	 * TODO: TX ox_id
+	 */
+	if (reqlen > 0) {
+		if (fcxp->use_ireqbuf) {
+			u32        pld_w0 =
+				*((u32 *) BFA_FCXP_REQ_PLD(fcxp));
+
+			bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_FCXP,
+				BFA_PL_EID_TX,
+				reqlen + sizeof(struct fchs_s), fchs, pld_w0);
+		} else {
+			bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP,
+				BFA_PL_EID_TX, reqlen + sizeof(struct fchs_s),
+				fchs);
+		}
+	} else {
+		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP, BFA_PL_EID_TX,
+			       reqlen + sizeof(struct fchs_s), fchs);
+	}
+}
+
+static void
+hal_fcxp_rx_plog(struct bfa_s *bfa, struct bfa_fcxp_s *fcxp,
+		 struct bfi_fcxp_send_rsp_s *fcxp_rsp)
+{
+	if (fcxp_rsp->rsp_len > 0) {
+		if (fcxp->use_irspbuf) {
+			u32        pld_w0 =
+				*((u32 *) BFA_FCXP_RSP_PLD(fcxp));
+
+			bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_FCXP,
+					      BFA_PL_EID_RX,
+					      (u16) fcxp_rsp->rsp_len,
+					      &fcxp_rsp->fchs, pld_w0);
+		} else {
+			bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP,
+				       BFA_PL_EID_RX,
+				       (u16) fcxp_rsp->rsp_len,
+				       &fcxp_rsp->fchs);
+		}
+	} else {
+		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP, BFA_PL_EID_RX,
+			       (u16) fcxp_rsp->rsp_len, &fcxp_rsp->fchs);
+	}
+}
+
+/**
+ * Handler to resume sending fcxp when space in available in cpe queue.
+ */
+static void
+bfa_fcxp_qresume(void *cbarg)
+{
+	struct bfa_fcxp_s		*fcxp = cbarg;
+	struct bfa_s			*bfa = fcxp->fcxp_mod->bfa;
+	struct bfi_fcxp_send_req_s	*send_req;
+
+	fcxp->reqq_waiting = BFA_FALSE;
+	send_req = bfa_reqq_next(bfa, BFA_REQQ_FCXP);
+	bfa_fcxp_queue(fcxp, send_req);
+}
+
+/**
+ * Queue fcxp send request to foimrware.
+ */
+static void
+bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
+{
+	struct bfa_s      		*bfa = fcxp->fcxp_mod->bfa;
+	struct bfa_fcxp_req_info_s	*reqi = &fcxp->req_info;
+	struct bfa_fcxp_rsp_info_s	*rspi = &fcxp->rsp_info;
+	struct bfa_rport_s		*rport = reqi->bfa_rport;
+
+	bfi_h2i_set(send_req->mh, BFI_MC_FCXP, BFI_FCXP_H2I_SEND_REQ,
+			bfa_lpuid(bfa));
+
+	send_req->fcxp_tag = bfa_os_htons(fcxp->fcxp_tag);
+	if (rport) {
+		send_req->rport_fw_hndl = rport->fw_handle;
+		send_req->max_frmsz = bfa_os_htons(rport->rport_info.max_frmsz);
+		if (send_req->max_frmsz == 0)
+			send_req->max_frmsz = bfa_os_htons(FC_MAX_PDUSZ);
+	} else {
+		send_req->rport_fw_hndl = 0;
+		send_req->max_frmsz = bfa_os_htons(FC_MAX_PDUSZ);
+	}
+
+	send_req->vf_id = bfa_os_htons(reqi->vf_id);
+	send_req->lp_tag = reqi->lp_tag;
+	send_req->class = reqi->class;
+	send_req->rsp_timeout = rspi->rsp_timeout;
+	send_req->cts = reqi->cts;
+	send_req->fchs = reqi->fchs;
+
+	send_req->req_len = bfa_os_htonl(reqi->req_tot_len);
+	send_req->rsp_maxlen = bfa_os_htonl(rspi->rsp_maxlen);
+
+	/*
+	 * setup req sgles
+	 */
+	if (fcxp->use_ireqbuf == 1) {
+		hal_fcxp_set_local_sges(send_req->req_sge, reqi->req_tot_len,
+					BFA_FCXP_REQ_PLD_PA(fcxp));
+	} else {
+		if (fcxp->nreq_sgles > 0) {
+			bfa_assert(fcxp->nreq_sgles == 1);
+			hal_fcxp_set_local_sges(send_req->req_sge,
+						reqi->req_tot_len,
+						fcxp->req_sga_cbfn(fcxp->caller,
+								   0));
+		} else {
+			bfa_assert(reqi->req_tot_len == 0);
+			hal_fcxp_set_local_sges(send_req->rsp_sge, 0, 0);
+		}
+	}
+
+	/*
+	 * setup rsp sgles
+	 */
+	if (fcxp->use_irspbuf == 1) {
+		bfa_assert(rspi->rsp_maxlen <= BFA_FCXP_MAX_LBUF_SZ);
+
+		hal_fcxp_set_local_sges(send_req->rsp_sge, rspi->rsp_maxlen,
+					BFA_FCXP_RSP_PLD_PA(fcxp));
+
+	} else {
+		if (fcxp->nrsp_sgles > 0) {
+			bfa_assert(fcxp->nrsp_sgles == 1);
+			hal_fcxp_set_local_sges(send_req->rsp_sge,
+						rspi->rsp_maxlen,
+						fcxp->rsp_sga_cbfn(fcxp->caller,
+								   0));
+		} else {
+			bfa_assert(rspi->rsp_maxlen == 0);
+			hal_fcxp_set_local_sges(send_req->rsp_sge, 0, 0);
+		}
+	}
+
+	hal_fcxp_tx_plog(bfa, reqi->req_tot_len, fcxp, &reqi->fchs);
+
+	bfa_reqq_produce(bfa, BFA_REQQ_FCXP);
+
+	bfa_trc(bfa, bfa_reqq_pi(bfa, BFA_REQQ_FCXP));
+	bfa_trc(bfa, bfa_reqq_ci(bfa, BFA_REQQ_FCXP));
+}
+
+
+/**
+ *  hal_fcxp_api BFA FCXP API
+ */
+
+/**
+ * Allocate an FCXP instance to send a response or to send a request
+ * that has a response. Request/response buffers are allocated by caller.
+ *
+ * @param[in]	bfa		BFA bfa instance
+ * @param[in]	nreq_sgles	Number of SG elements required for request
+ * 				buffer. 0, if fcxp internal buffers are	used.
+ * 				Use bfa_fcxp_get_reqbuf() to get the
+ * 				internal req buffer.
+ * @param[in]	req_sgles	SG elements describing request buffer. Will be
+ * 				copied in by BFA and hence can be freed on
+ * 				return from this function.
+ * @param[in]	get_req_sga	function ptr to be called to get a request SG
+ * 				Address (given the sge index).
+ * @param[in]	get_req_sglen	function ptr to be called to get a request SG
+ * 				len (given the sge index).
+ * @param[in]	get_rsp_sga	function ptr to be called to get a response SG
+ * 				Address (given the sge index).
+ * @param[in]	get_rsp_sglen	function ptr to be called to get a response SG
+ * 				len (given the sge index).
+ *
+ * @return FCXP instance. NULL on failure.
+ */
+struct bfa_fcxp_s *
+bfa_fcxp_alloc(void *caller, struct bfa_s *bfa, int nreq_sgles,
+			int nrsp_sgles, bfa_fcxp_get_sgaddr_t req_sga_cbfn,
+			bfa_fcxp_get_sglen_t req_sglen_cbfn,
+			bfa_fcxp_get_sgaddr_t rsp_sga_cbfn,
+			bfa_fcxp_get_sglen_t rsp_sglen_cbfn)
+{
+	struct bfa_fcxp_s *fcxp = NULL;
+	u32        nreq_sgpg, nrsp_sgpg;
+
+	bfa_assert(bfa != NULL);
+
+	fcxp = bfa_fcxp_get(BFA_FCXP_MOD(bfa));
+	if (fcxp == NULL)
+		return (NULL);
+
+	bfa_trc(bfa, fcxp->fcxp_tag);
+
+	fcxp->caller = caller;
+
+	if (nreq_sgles == 0) {
+		fcxp->use_ireqbuf = 1;
+	} else {
+		bfa_assert(req_sga_cbfn != NULL);
+		bfa_assert(req_sglen_cbfn != NULL);
+
+		fcxp->use_ireqbuf = 0;
+		fcxp->req_sga_cbfn = req_sga_cbfn;
+		fcxp->req_sglen_cbfn = req_sglen_cbfn;
+
+		fcxp->nreq_sgles = nreq_sgles;
+
+		/*
+		 * alloc required sgpgs
+		 */
+		if (nreq_sgles > BFI_SGE_INLINE) {
+			nreq_sgpg = BFA_SGPG_NPAGE(nreq_sgles);
+
+			if (bfa_sgpg_malloc
+			    (bfa, &fcxp->req_sgpg_q, nreq_sgpg)
+			    != BFA_STATUS_OK) {
+				/* bfa_sgpg_wait(bfa, &fcxp->req_sgpg_wqe,
+				nreq_sgpg); */
+				/*
+				 * TODO
+				 */
+			}
+		}
+	}
+
+	if (nrsp_sgles == 0) {
+		fcxp->use_irspbuf = 1;
+	} else {
+		bfa_assert(rsp_sga_cbfn != NULL);
+		bfa_assert(rsp_sglen_cbfn != NULL);
+
+		fcxp->use_irspbuf = 0;
+		fcxp->rsp_sga_cbfn = rsp_sga_cbfn;
+		fcxp->rsp_sglen_cbfn = rsp_sglen_cbfn;
+
+		fcxp->nrsp_sgles = nrsp_sgles;
+		/*
+		 * alloc required sgpgs
+		 */
+		if (nrsp_sgles > BFI_SGE_INLINE) {
+			nrsp_sgpg = BFA_SGPG_NPAGE(nreq_sgles);
+
+			if (bfa_sgpg_malloc
+			    (bfa, &fcxp->rsp_sgpg_q, nrsp_sgpg)
+			    != BFA_STATUS_OK) {
+				/* bfa_sgpg_wait(bfa, &fcxp->rsp_sgpg_wqe,
+				nrsp_sgpg); */
+				/*
+				 * TODO
+				 */
+			}
+		}
+	}
+
+	return (fcxp);
+}
+
+/**
+ * Get the internal request buffer pointer
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ *
+ * @return 		pointer to the internal request buffer
+ */
+void *
+bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+	void	*reqbuf;
+
+	bfa_assert(fcxp->use_ireqbuf == 1);
+	reqbuf = ((u8 *)mod->req_pld_list_kva) +
+			fcxp->fcxp_tag * mod->req_pld_sz;
+	return reqbuf;
+}
+
+u32
+bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+
+	return mod->req_pld_sz;
+}
+
+/**
+ * Get the internal response buffer pointer
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ *
+ * @return		pointer to the internal request buffer
+ */
+void *
+bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+	void	*rspbuf;
+
+	bfa_assert(fcxp->use_irspbuf == 1);
+
+	rspbuf = ((u8 *)mod->rsp_pld_list_kva) +
+			fcxp->fcxp_tag * mod->rsp_pld_sz;
+	return rspbuf;
+}
+
+/**
+ * 		Free the BFA FCXP
+ *
+ * @param[in]	fcxp			BFA fcxp pointer
+ *
+ * @return 		void
+ */
+void
+bfa_fcxp_free(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+
+	bfa_assert(fcxp != NULL);
+	bfa_trc(mod->bfa, fcxp->fcxp_tag);
+	bfa_fcxp_put(fcxp);
+}
+
+/**
+ * Send a FCXP request
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ * @param[in]	rport	BFA rport pointer. Could be left NULL for WKA rports
+ * @param[in]	vf_id	virtual Fabric ID
+ * @param[in]	lp_tag  lport tag
+ * @param[in]	cts	use Continous sequence
+ * @param[in]	cos	fc Class of Service
+ * @param[in]	reqlen	request length, does not include FCHS length
+ * @param[in]	fchs	fc Header Pointer. The header content will be copied
+ *			in by BFA.
+ *
+ * @param[in]	cbfn	call back function to be called on receiving
+ * 								the response
+ * @param[in]	cbarg	arg for cbfn
+ * @param[in]	rsp_timeout
+ *			response timeout
+ *
+ * @return		bfa_status_t
+ */
+void
+bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
+		u16 vf_id, u8 lp_tag, bfa_boolean_t cts, enum fc_cos cos,
+		u32 reqlen, struct fchs_s *fchs, bfa_cb_fcxp_send_t cbfn,
+		void *cbarg, u32 rsp_maxlen, u8 rsp_timeout)
+{
+	struct bfa_s			*bfa  = fcxp->fcxp_mod->bfa;
+	struct bfa_fcxp_req_info_s	*reqi = &fcxp->req_info;
+	struct bfa_fcxp_rsp_info_s	*rspi = &fcxp->rsp_info;
+	struct bfi_fcxp_send_req_s	*send_req;
+
+	bfa_trc(bfa, fcxp->fcxp_tag);
+
+	/**
+	 * setup request/response info
+	 */
+	reqi->bfa_rport = rport;
+	reqi->vf_id = vf_id;
+	reqi->lp_tag = lp_tag;
+	reqi->class = cos;
+	rspi->rsp_timeout = rsp_timeout;
+	reqi->cts = cts;
+	reqi->fchs = *fchs;
+	reqi->req_tot_len = reqlen;
+	rspi->rsp_maxlen = rsp_maxlen;
+	fcxp->send_cbfn = cbfn ? cbfn : bfa_fcxp_null_comp;
+	fcxp->send_cbarg = cbarg;
+
+	/**
+	 * If no room in CPE queue, wait for
+	 */
+	send_req = bfa_reqq_next(bfa, BFA_REQQ_FCXP);
+	if (!send_req) {
+		bfa_trc(bfa, fcxp->fcxp_tag);
+		fcxp->reqq_waiting = BFA_TRUE;
+		bfa_reqq_wait(bfa, BFA_REQQ_FCXP, &fcxp->reqq_wqe);
+		return;
+	}
+
+	bfa_fcxp_queue(fcxp, send_req);
+}
+
+/**
+ * Abort a BFA FCXP
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ *
+ * @return 		void
+ */
+bfa_status_t
+bfa_fcxp_abort(struct bfa_fcxp_s *fcxp)
+{
+	bfa_assert(0);
+	return (BFA_STATUS_OK);
+}
+
+void
+bfa_fcxp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
+			bfa_fcxp_alloc_cbfn_t alloc_cbfn, void *alloc_cbarg)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	bfa_assert(list_empty(&mod->fcxp_free_q));
+
+	wqe->alloc_cbfn = alloc_cbfn;
+	wqe->alloc_cbarg = alloc_cbarg;
+	list_add_tail(&wqe->qe, &mod->wait_q);
+}
+
+void
+bfa_fcxp_walloc_cancel(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	bfa_assert(bfa_q_is_on_q(&mod->wait_q, wqe));
+	list_del(&wqe->qe);
+}
+
+void
+bfa_fcxp_discard(struct bfa_fcxp_s *fcxp)
+{
+	/**
+	 * If waiting for room in request queue, cancel reqq wait
+	 * and free fcxp.
+	 */
+	if (fcxp->reqq_waiting) {
+		fcxp->reqq_waiting = BFA_FALSE;
+		bfa_reqq_wcancel(&fcxp->reqq_wqe);
+		bfa_fcxp_free(fcxp);
+		return;
+	}
+
+	fcxp->send_cbfn = bfa_fcxp_null_comp;
+}
+
+
+
+/**
+ *  hal_fcxp_public BFA FCXP public functions
+ */
+
+void
+bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	switch (msg->mhdr.msg_id) {
+	case BFI_FCXP_I2H_SEND_RSP:
+		hal_fcxp_send_comp(bfa, (struct bfi_fcxp_send_rsp_s *) msg);
+		break;
+
+	default:
+		bfa_trc(bfa, msg->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+u32
+bfa_fcxp_get_maxrsp(struct bfa_s *bfa)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	return mod->rsp_pld_sz;
+}
+
+
