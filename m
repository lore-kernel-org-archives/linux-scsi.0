From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/14] bfa: Brocade BFA FC SCSI driver (bfa3)
Date: Wed, 23 Sep 2009 17:53:56 -0700
Message-ID: <200909240053.n8O0ru9e015353@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:38846 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZIXAxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 20:53:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains code to access Brocade Fibre channel HBA
firmware/hardware, part-3

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_iocfc.h      |  168 +++++++
 bfa_iocfc_q.c    |   44 +
 bfa_ioim.c       | 1311 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 bfa_itnim.c      | 1088 +++++++++++++++++++++++++++++++++++++++++++++
 bfa_log.c        |  346 ++++++++++++++
 bfa_log_module.c |  451 ++++++++++++++++++
 bfa_lps.c        |  782 ++++++++++++++++++++++++++++++++
 7 files changed, 4190 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.h patch/drivers/scsi/bfa/bfa_iocfc.h
--- orig/drivers/scsi/bfa/bfa_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_iocfc.h	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,168 @@
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
+#ifndef __BFA_IOCFC_H__
+#define __BFA_IOCFC_H__
+
+#include <bfa_ioc.h>
+#include <bfa.h>
+#include <bfi/bfi_iocfc.h>
+#include <bfa_callback_priv.h>
+
+#define BFA_REQQ_NELEMS_MIN	(4)
+#define BFA_RSPQ_NELEMS_MIN	(4)
+
+struct bfa_iocfc_regs_s {
+	bfa_os_addr_t   intr_status;
+	bfa_os_addr_t   intr_mask;
+	bfa_os_addr_t   cpe_q_pi[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   cpe_q_ci[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   cpe_q_depth[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   cpe_q_ctrl[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_ci[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_pi[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_depth[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_ctrl[BFI_IOC_MAX_CQS];
+};
+
+/**
+ * MSIX vector handlers
+ */
+#define BFA_MSIX_MAX_VECTORS	22
+typedef void (*bfa_msix_handler_t)(struct bfa_s *bfa, int vec);
+struct bfa_msix_s {
+	int	nvecs;
+	bfa_msix_handler_t handler[BFA_MSIX_MAX_VECTORS];
+};
+
+/**
+ * Chip specific interfaces
+ */
+struct bfa_hwif_s {
+	void (*hw_reginit)(struct bfa_s *bfa);
+	void (*hw_rspq_ack)(struct bfa_s *bfa, int rspq);
+	void (*hw_msix_init)(struct bfa_s *bfa, int nvecs);
+	void (*hw_msix_install)(struct bfa_s *bfa);
+	void (*hw_msix_uninstall)(struct bfa_s *bfa);
+	void (*hw_isr_mode_set)(struct bfa_s *bfa, bfa_boolean_t msix);
+	void (*hw_msix_getvecs)(struct bfa_s *bfa, u32 *vecmap,
+			u32 *nvecs, u32 *maxvec);
+};
+typedef void (*bfa_cb_iocfc_t) (void *cbarg, enum bfa_status status);
+
+struct bfa_iocfc_s {
+	struct bfa_s 		*bfa;
+	struct bfa_iocfc_cfg_s 	cfg;
+	int			action;
+
+	u32        	req_cq_pi[BFI_IOC_MAX_CQS];
+	u32        	rsp_cq_ci[BFI_IOC_MAX_CQS];
+
+	struct bfa_cb_qe_s	init_hcb_qe;
+	struct bfa_cb_qe_s	stop_hcb_qe;
+	struct bfa_cb_qe_s	dis_hcb_qe;
+	struct bfa_cb_qe_s	stats_hcb_qe;
+	bfa_boolean_t		cfgdone;
+
+	struct bfa_dma_s	cfg_info;
+	struct bfi_iocfc_cfg_s *cfginfo;
+	struct bfa_dma_s	cfgrsp_dma;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp;
+	struct bfi_iocfc_cfg_reply_s *cfg_reply;
+
+	u8			*stats_kva;
+	u64		stats_pa;
+	struct bfa_fw_stats_s 	*fw_stats;
+	struct bfa_timer_s 	stats_timer;	/*  timer */
+	struct bfa_iocfc_stats_s *stats_ret;	/*  driver stats location */
+	bfa_status_t		stats_status;	/*  stats/statsclr status */
+	bfa_boolean_t   	stats_busy;	/*  outstanding stats */
+	bfa_cb_ioc_t		stats_cbfn;	/*  driver callback function */
+	void           		*stats_cbarg;	/*  user callback arg */
+
+	struct bfa_dma_s   	req_cq_ba[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s   	req_cq_shadow_ci[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s   	rsp_cq_ba[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s   	rsp_cq_shadow_pi[BFI_IOC_MAX_CQS];
+	struct bfa_iocfc_regs_s	bfa_regs;	/*  BFA device registers */
+	struct bfa_hwif_s	hwif;
+
+	bfa_cb_iocfc_t		updateq_cbfn; /*  bios callback function */
+	void				*updateq_cbarg;	/*  bios callback arg */
+};
+
+#define bfa_lpuid(__bfa)		bfa_ioc_portid(&(__bfa)->ioc)
+#define bfa_msix_init(__bfa, __nvecs)	\
+	(__bfa)->iocfc.hwif.hw_msix_init(__bfa, __nvecs)
+#define bfa_msix_install(__bfa)	\
+	(__bfa)->iocfc.hwif.hw_msix_install(__bfa)
+#define bfa_msix_uninstall(__bfa)	\
+	(__bfa)->iocfc.hwif.hw_msix_uninstall(__bfa)
+#define bfa_isr_mode_set(__bfa, __msix)	\
+	(__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix)
+#define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)	\
+	(__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)
+
+/*
+ * FC specific IOC functions.
+ */
+void bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len);
+void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
+		struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
+		struct bfa_pcidev_s *pcidev);
+void bfa_iocfc_detach(struct bfa_s *bfa);
+void bfa_iocfc_init(struct bfa_s *bfa);
+void bfa_iocfc_start(struct bfa_s *bfa);
+void bfa_iocfc_stop(struct bfa_s *bfa);
+void bfa_iocfc_isr(void *bfa, struct bfi_mbmsg_s *msg);
+void bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa);
+bfa_boolean_t bfa_iocfc_is_operational(struct bfa_s *bfa);
+void bfa_iocfc_reset_queues(struct bfa_s *bfa);
+void bfa_iocfc_updateq(struct bfa_s *bfa, u32 reqq_ba, u32 rspq_ba,
+			u32 reqq_sci, u32 rspq_spi,
+			bfa_cb_iocfc_t cbfn, void *cbarg);
+
+void bfa_msix_all(struct bfa_s *bfa, int vec);
+void bfa_msix_reqq(struct bfa_s *bfa, int vec);
+void bfa_msix_rspq(struct bfa_s *bfa, int vec);
+void bfa_msix_lpu_err(struct bfa_s *bfa, int vec);
+
+void bfa_hwcb_reginit(struct bfa_s *bfa);
+void bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs);
+void bfa_hwcb_msix_install(struct bfa_s *bfa);
+void bfa_hwcb_msix_uninstall(struct bfa_s *bfa);
+void bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
+void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
+			u32 *nvecs, u32 *maxvec);
+void bfa_hwct_reginit(struct bfa_s *bfa);
+void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs);
+void bfa_hwct_msix_install(struct bfa_s *bfa);
+void bfa_hwct_msix_uninstall(struct bfa_s *bfa);
+void bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
+void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
+			u32 *nvecs, u32 *maxvec);
+
+void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
+void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
+		bfa_boolean_t mincfg);
+void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns);
+
+#endif /* __BFA_IOCFC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc_q.c patch/drivers/scsi/bfa/bfa_iocfc_q.c
--- orig/drivers/scsi/bfa/bfa_iocfc_q.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_iocfc_q.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,44 @@
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
+#include "bfa_intr_priv.h"
+
+BFA_TRC_FILE(HAL, IOCFC_Q);
+
+void
+bfa_iocfc_updateq(struct bfa_s *bfa, u32 reqq_ba, u32 rspq_ba,
+				u32 reqq_sci, u32 rspq_spi, bfa_cb_iocfc_t cbfn,
+				void *cbarg)
+{
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_updateq_req_s updateq_req;
+
+	iocfc->updateq_cbfn = cbfn;
+	iocfc->updateq_cbarg = cbarg;
+
+	bfi_h2i_set(updateq_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_UPDATEQ_REQ,
+			bfa_lpuid(bfa));
+
+	updateq_req.reqq_ba = bfa_os_htonl(reqq_ba);
+	updateq_req.rspq_ba = bfa_os_htonl(rspq_ba);
+	updateq_req.reqq_sci = bfa_os_htonl(reqq_sci);
+	updateq_req.rspq_spi = bfa_os_htonl(rspq_spi);
+
+	bfa_ioc_mbox_send(&bfa->ioc, &updateq_req,
+			sizeof(struct bfi_iocfc_updateq_req_s));
+}
diff -urpN orig/drivers/scsi/bfa/bfa_ioim.c patch/drivers/scsi/bfa/bfa_ioim.c
--- orig/drivers/scsi/bfa/bfa_ioim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_ioim.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,1311 @@
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
+#include <cs/bfa_debug.h>
+#include <bfa_cb_ioim_macros.h>
+
+BFA_TRC_FILE(HAL, IOIM);
+
+/*
+ * forward declarations.
+ */
+static bfa_boolean_t	bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim);
+static bfa_boolean_t	bfa_ioim_sge_setup(struct bfa_ioim_s *ioim);
+static void		bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim);
+static bfa_boolean_t	bfa_ioim_send_abort(struct bfa_ioim_s *ioim);
+static void		bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim);
+static void __bfa_cb_ioim_good_comp(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_abort(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_failed(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete);
+
+/**
+ *  bfa_ioim_sm
+ */
+
+/**
+ * IO state machine events
+ */
+enum bfa_ioim_event {
+	BFA_IOIM_SM_START = 1,		/*  io start request from host */
+	BFA_IOIM_SM_COMP_GOOD = 2,	/*  io good comp, resource free */
+	BFA_IOIM_SM_COMP = 3,		/*  io comp, resource is free */
+	BFA_IOIM_SM_COMP_UTAG = 4,	/*  io comp, resource is free */
+	BFA_IOIM_SM_DONE = 5,		/*  io comp, resource not free */
+	BFA_IOIM_SM_FREE = 6,		/*  io resource is freed */
+	BFA_IOIM_SM_ABORT = 7,		/*  abort request from scsi stack */
+	BFA_IOIM_SM_ABORT_COMP = 8,	/*  abort from f/w */
+	BFA_IOIM_SM_ABORT_DONE = 9,	/*  abort completion from f/w */
+	BFA_IOIM_SM_QRESUME = 10,	/*  CQ space available to queue IO */
+	BFA_IOIM_SM_SGALLOCED = 11,	/*  SG page allocation successful */
+	BFA_IOIM_SM_SQRETRY = 12,	/*  sequence recovery retry */
+	BFA_IOIM_SM_HCB	= 13,		/*  bfa callback complete */
+	BFA_IOIM_SM_CLEANUP = 14,	/*  IO cleanup from itnim */
+	BFA_IOIM_SM_TMSTART = 15,	/*  IO cleanup from tskim */
+	BFA_IOIM_SM_TMDONE = 16,	/*  IO cleanup from tskim */
+	BFA_IOIM_SM_HWFAIL = 17,	/*  IOC h/w failure event */
+	BFA_IOIM_SM_IOTOV = 18,		/*  ITN offline TOV       */
+};
+
+/*
+ * forward declaration of IO state machine
+ */
+static void     bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim,
+				       enum bfa_ioim_event event);
+static void     bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim,
+					enum bfa_ioim_event event);
+static void     bfa_ioim_sm_active(struct bfa_ioim_s *ioim,
+				       enum bfa_ioim_event event);
+static void     bfa_ioim_sm_abort(struct bfa_ioim_s *ioim,
+				      enum bfa_ioim_event event);
+static void     bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim,
+					enum bfa_ioim_event event);
+static void     bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim,
+				      enum bfa_ioim_event event);
+static void     bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim,
+					    enum bfa_ioim_event event);
+static void     bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim,
+					      enum bfa_ioim_event event);
+static void     bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim,
+				    enum bfa_ioim_event event);
+static void     bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim,
+					 enum bfa_ioim_event event);
+static void     bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim,
+					enum bfa_ioim_event event);
+
+/**
+ * 		IO is not started (unallocated).
+ */
+static void
+bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_trc_fp(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_START:
+		if (!bfa_itnim_is_online(ioim->itnim)) {
+			if (!bfa_itnim_hold_io(ioim->itnim)) {
+				bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+				list_del(&ioim->qe);
+				list_add_tail(&ioim->qe,
+					&ioim->fcpim->ioim_comp_q);
+				bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+						__bfa_cb_ioim_pathtov, ioim);
+			} else {
+				list_del(&ioim->qe);
+				list_add_tail(&ioim->qe,
+					&ioim->itnim->pending_q);
+			}
+			break;
+		}
+
+		if (ioim->nsges > BFI_SGE_INLINE) {
+			if (!bfa_ioim_sge_setup(ioim)) {
+				bfa_sm_set_state(ioim, bfa_ioim_sm_sgalloc);
+				return;
+			}
+		}
+
+		if (!bfa_ioim_send_ioreq(ioim)) {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_qfull);
+			break;
+		}
+
+		bfa_sm_set_state(ioim, bfa_ioim_sm_active);
+		break;
+
+	case BFA_IOIM_SM_IOTOV:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+				__bfa_cb_ioim_pathtov, ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		/**
+		 * IO in pending queue can get abort requests. Complete abort
+		 * requests immediately.
+		 */
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_assert(bfa_q_is_on_q(&ioim->itnim->pending_q, ioim));
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+				ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is waiting for SG pages.
+ */
+static void
+bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_SGALLOCED:
+		if (!bfa_ioim_send_ioreq(ioim)) {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_qfull);
+			break;
+		}
+		bfa_sm_set_state(ioim, bfa_ioim_sm_active);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is active.
+ */
+static void
+bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_trc_fp(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_COMP_GOOD:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+			      __bfa_cb_ioim_good_comp, ioim);
+		break;
+
+	case BFA_IOIM_SM_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_comp,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_comp,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		ioim->iosp->abort_explicit = BFA_TRUE;
+		ioim->io_cbfn = __bfa_cb_ioim_abort;
+
+		if (bfa_ioim_send_abort(ioim))
+			bfa_sm_set_state(ioim, bfa_ioim_sm_abort);
+		else {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_abort_qfull);
+			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+					  &ioim->iosp->reqq_wait);
+		}
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		ioim->iosp->abort_explicit = BFA_FALSE;
+		ioim->io_cbfn = __bfa_cb_ioim_failed;
+
+		if (bfa_ioim_send_abort(ioim))
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
+		else {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
+			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+					  &ioim->iosp->reqq_wait);
+		}
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is being aborted, waiting for completion from firmware.
+ */
+static void
+bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+	case BFA_IOIM_SM_DONE:
+	case BFA_IOIM_SM_FREE:
+		break;
+
+	case BFA_IOIM_SM_ABORT_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_COMP_UTAG:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_assert(ioim->iosp->abort_explicit == BFA_TRUE);
+		ioim->iosp->abort_explicit = BFA_FALSE;
+
+		if (bfa_ioim_send_abort(ioim))
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
+		else {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
+			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+					  &ioim->iosp->reqq_wait);
+		}
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO is being cleaned up (implicit abort), waiting for completion from
+ * firmware.
+ */
+static void
+bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+	case BFA_IOIM_SM_DONE:
+	case BFA_IOIM_SM_FREE:
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		/**
+		 * IO is already being aborted implicitly
+		 */
+		ioim->io_cbfn = __bfa_cb_ioim_abort;
+		break;
+
+	case BFA_IOIM_SM_ABORT_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_COMP_UTAG:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		/**
+		 * IO can be in cleanup state already due to TM command. 2nd cleanup
+		 * request comes from ITN offline event.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is waiting for room in request CQ
+ */
+static void
+bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_QRESUME:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_active);
+		bfa_ioim_send_ioreq(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Active IO is being aborted, waiting for room in request CQ.
+ */
+static void
+bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_QRESUME:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_abort);
+		bfa_ioim_send_abort(ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_assert(ioim->iosp->abort_explicit == BFA_TRUE);
+		ioim->iosp->abort_explicit = BFA_FALSE;
+		bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
+		break;
+
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Active IO is being cleaned up, waiting for room in request CQ.
+ */
+static void
+bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_QRESUME:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
+		bfa_ioim_send_abort(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		/**
+		 * IO is alraedy being cleaned up implicitly
+		 */
+		ioim->io_cbfn = __bfa_cb_ioim_abort;
+		break;
+
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO bfa callback is pending.
+ */
+static void
+bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_trc_fp(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_HCB:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
+		bfa_ioim_free(ioim);
+		bfa_cb_ioim_resfree(ioim->bfa->bfad);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO bfa callback is pending. IO resource cannot be freed.
+ */
+static void
+bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_HCB:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_resfree);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_resfree_q);
+		break;
+
+	case BFA_IOIM_SM_FREE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO is completed, waiting resource free from firmware.
+ */
+static void
+bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_FREE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
+		bfa_ioim_free(ioim);
+		bfa_cb_ioim_resfree(ioim->bfa->bfad);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
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
+ *  bfa_ioim_private
+ */
+
+static void
+__bfa_cb_ioim_good_comp(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_good_comp(ioim->bfa->bfad, ioim->dio);
+}
+
+static void
+__bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s	*ioim = cbarg;
+	struct bfi_ioim_rsp_s *m;
+	u8		*snsinfo = NULL;
+	u8         sns_len = 0;
+	s32         residue = 0;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	m = (struct bfi_ioim_rsp_s *) &ioim->iosp->comp_rspmsg;
+	if (m->io_status == BFI_IOIM_STS_OK) {
+		/**
+		 * setup sense information, if present
+		 */
+		if (m->scsi_status == SCSI_STATUS_CHECK_CONDITION
+					&& m->sns_len) {
+			sns_len = m->sns_len;
+			snsinfo = ioim->iosp->snsinfo;
+		}
+
+		/**
+		 * setup residue value correctly for normal completions
+		 */
+		if (m->resid_flags == FCP_RESID_UNDER)
+			residue = bfa_os_ntohl(m->residue);
+		if (m->resid_flags == FCP_RESID_OVER) {
+			residue = bfa_os_ntohl(m->residue);
+			residue = -residue;
+		}
+	}
+
+	bfa_cb_ioim_done(ioim->bfa->bfad, ioim->dio, m->io_status,
+			  m->scsi_status, sns_len, snsinfo, residue);
+}
+
+static void
+__bfa_cb_ioim_failed(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_done(ioim->bfa->bfad, ioim->dio, BFI_IOIM_STS_ABORTED,
+			  0, 0, NULL, 0);
+}
+
+static void
+__bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_done(ioim->bfa->bfad, ioim->dio, BFI_IOIM_STS_PATHTOV,
+			  0, 0, NULL, 0);
+}
+
+static void
+__bfa_cb_ioim_abort(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_abort(ioim->bfa->bfad, ioim->dio);
+}
+
+static void
+bfa_ioim_sgpg_alloced(void *cbarg)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	ioim->nsgpgs = BFA_SGPG_NPAGE(ioim->nsges);
+	list_splice_tail_init(&ioim->iosp->sgpg_wqe.sgpg_q, &ioim->sgpg_q);
+	bfa_ioim_sgpg_setup(ioim);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_SGALLOCED);
+}
+
+/**
+ * Send I/O request to firmware.
+ */
+static          bfa_boolean_t
+bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
+{
+	struct bfa_itnim_s *itnim = ioim->itnim;
+	struct bfi_ioim_req_s *m;
+	static struct fcp_cmnd_s cmnd_z0 = { 0 };
+	struct bfi_sge_s      *sge;
+	u32        pgdlen = 0;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(ioim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+				  &ioim->iosp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	/**
+	 * build i/o request message next
+	 */
+	m->io_tag = bfa_os_htons(ioim->iotag);
+	m->rport_hdl = ioim->itnim->rport->fw_handle;
+	m->io_timeout = bfa_cb_ioim_get_timeout(ioim->dio);
+
+	/**
+	 * build inline IO SG element here
+	 */
+	sge = &m->sges[0];
+	if (ioim->nsges) {
+		sge->sga = bfa_cb_ioim_get_sgaddr(ioim->dio, 0);
+		pgdlen = bfa_cb_ioim_get_sglen(ioim->dio, 0);
+		sge->sg_len = pgdlen;
+		sge->flags = (ioim->nsges > BFI_SGE_INLINE) ?
+					BFI_SGE_DATA_CPL : BFI_SGE_DATA_LAST;
+		bfa_sge_to_be(sge);
+		sge++;
+	}
+
+	if (ioim->nsges > BFI_SGE_INLINE) {
+		sge->sga = ioim->sgpg->sgpg_pa;
+	} else {
+		sge->sga.a32.addr_lo = 0;
+		sge->sga.a32.addr_hi = 0;
+	}
+	sge->sg_len = pgdlen;
+	sge->flags = BFI_SGE_PGDLEN;
+	bfa_sge_to_be(sge);
+
+	/**
+	 * set up I/O command parameters
+	 */
+	bfa_os_assign(m->cmnd, cmnd_z0);
+	m->cmnd.lun = bfa_cb_ioim_get_lun(ioim->dio);
+	m->cmnd.iodir = bfa_cb_ioim_get_iodir(ioim->dio);
+	bfa_os_assign(m->cmnd.cdb,
+			*(struct scsi_cdb_s *)bfa_cb_ioim_get_cdb(ioim->dio));
+	m->cmnd.fcp_dl = bfa_os_htonl(bfa_cb_ioim_get_size(ioim->dio));
+
+	/**
+	 * set up I/O message header
+	 */
+	switch (m->cmnd.iodir) {
+	case FCP_IODIR_READ:
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_READ, 0, bfa_lpuid(ioim->bfa));
+		bfa_stats(itnim, input_reqs);
+		break;
+	case FCP_IODIR_WRITE:
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_WRITE, 0, bfa_lpuid(ioim->bfa));
+		bfa_stats(itnim, output_reqs);
+		break;
+	case FCP_IODIR_RW:
+		bfa_stats(itnim, input_reqs);
+		bfa_stats(itnim, output_reqs);
+	default:
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
+	}
+	if (itnim->seq_rec ||
+	    (bfa_cb_ioim_get_size(ioim->dio) & (sizeof(u32) - 1)))
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
+
+#ifdef IOIM_ADVANCED
+	m->cmnd.crn = bfa_cb_ioim_get_crn(ioim->dio);
+	m->cmnd.priority = bfa_cb_ioim_get_priority(ioim->dio);
+	m->cmnd.taskattr = bfa_cb_ioim_get_taskattr(ioim->dio);
+
+	/**
+	 * Handle large CDB (>16 bytes).
+	 */
+	m->cmnd.addl_cdb_len = (bfa_cb_ioim_get_cdblen(ioim->dio) -
+					FCP_CMND_CDB_LEN) / sizeof(u32);
+	if (m->cmnd.addl_cdb_len) {
+		bfa_os_memcpy(&m->cmnd.cdb + 1, (struct scsi_cdb_s *)
+				bfa_cb_ioim_get_cdb(ioim->dio) + 1,
+				m->cmnd.addl_cdb_len * sizeof(u32));
+		fcp_cmnd_fcpdl(&m->cmnd) =
+				bfa_os_htonl(bfa_cb_ioim_get_size(ioim->dio));
+	}
+#endif
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(ioim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Setup any additional SG pages needed.Inline SG element is setup
+ * at queuing time.
+ */
+static bfa_boolean_t
+bfa_ioim_sge_setup(struct bfa_ioim_s *ioim)
+{
+	u16        nsgpgs;
+
+	bfa_assert(ioim->nsges > BFI_SGE_INLINE);
+
+	/**
+	 * allocate SG pages needed
+	 */
+	nsgpgs = BFA_SGPG_NPAGE(ioim->nsges);
+	if (!nsgpgs)
+		return BFA_TRUE;
+
+	if (bfa_sgpg_malloc(ioim->bfa, &ioim->sgpg_q, nsgpgs)
+	    != BFA_STATUS_OK) {
+		bfa_sgpg_wait(ioim->bfa, &ioim->iosp->sgpg_wqe, nsgpgs);
+		return BFA_FALSE;
+	}
+
+	ioim->nsgpgs = nsgpgs;
+	bfa_ioim_sgpg_setup(ioim);
+
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
+{
+	int             sgeid, nsges, i;
+	struct bfi_sge_s      *sge;
+	struct bfa_sgpg_s *sgpg;
+	u32        pgcumsz;
+
+	sgeid = BFI_SGE_INLINE;
+	ioim->sgpg = sgpg = bfa_q_first(&ioim->sgpg_q);
+
+	do {
+		sge = sgpg->sgpg->sges;
+		nsges = ioim->nsges - sgeid;
+		if (nsges > BFI_SGPG_DATA_SGES)
+			nsges = BFI_SGPG_DATA_SGES;
+
+		pgcumsz = 0;
+		for (i = 0; i < nsges; i++, sge++, sgeid++) {
+			sge->sga = bfa_cb_ioim_get_sgaddr(ioim->dio, sgeid);
+			sge->sg_len = bfa_cb_ioim_get_sglen(ioim->dio, sgeid);
+			pgcumsz += sge->sg_len;
+
+			/**
+			 * set flags
+			 */
+			if (i < (nsges - 1))
+				sge->flags = BFI_SGE_DATA;
+			else if (sgeid < (ioim->nsges - 1))
+				sge->flags = BFI_SGE_DATA_CPL;
+			else
+				sge->flags = BFI_SGE_DATA_LAST;
+		}
+
+		sgpg = (struct bfa_sgpg_s *) bfa_q_next(sgpg);
+
+		/**
+		 * set the link element of each page
+		 */
+		if (sgeid == ioim->nsges) {
+			sge->flags = BFI_SGE_PGDLEN;
+			sge->sga.a32.addr_lo = 0;
+			sge->sga.a32.addr_hi = 0;
+		} else {
+			sge->flags = BFI_SGE_LINK;
+			sge->sga = sgpg->sgpg_pa;
+		}
+		sge->sg_len = pgcumsz;
+	} while (sgeid < ioim->nsges);
+}
+
+/**
+ * Send I/O abort request to firmware.
+ */
+static          bfa_boolean_t
+bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
+{
+	struct bfa_itnim_s          *itnim = ioim->itnim;
+	struct bfi_ioim_abort_req_s *m;
+	enum bfi_ioim_h2i       msgop;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(ioim->bfa, itnim->reqq);
+	if (!m)
+		return BFA_FALSE;
+
+	/**
+	 * build i/o request message next
+	 */
+	if (ioim->iosp->abort_explicit)
+		msgop = BFI_IOIM_H2I_IOABORT_REQ;
+	else
+		msgop = BFI_IOIM_H2I_IOCLEANUP_REQ;
+
+	bfi_h2i_set(m->mh, BFI_MC_IOIM, msgop, bfa_lpuid(ioim->bfa));
+	m->io_tag    = bfa_os_htons(ioim->iotag);
+	m->abort_tag = ++ioim->abort_tag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(ioim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Call to resume any I/O requests waiting for room in request queue.
+ */
+static void
+bfa_ioim_qresume(void *cbarg)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	bfa_fcpim_stats(ioim->fcpim, qresumes);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_QRESUME);
+}
+
+
+static void
+bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim)
+{
+	/**
+	 * Move IO from itnim queue to fcpim global queue since itnim will be
+	 * freed.
+	 */
+	list_del(&ioim->qe);
+	list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+
+	if (!ioim->iosp->tskim) {
+		if (ioim->fcpim->delay_comp && ioim->itnim->iotov_active) {
+			bfa_cb_dequeue(&ioim->hcb_qe);
+			list_del(&ioim->qe);
+			list_add_tail(&ioim->qe, &ioim->itnim->delay_comp_q);
+		}
+		bfa_itnim_iodone(ioim->itnim);
+	} else
+		bfa_tskim_iodone(ioim->iosp->tskim);
+}
+
+/**
+ * 		  or after the link comes back.
+ */
+void
+bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
+{
+	/**
+	 * If path tov timer expired, failback with PATHTOV status - these
+	 * IO requests are not normally retried by IO stack.
+	 *
+	 * Otherwise device cameback online and fail it with normal failed
+	 * status so that IO stack retries these failed IO requests.
+	 */
+	if (iotov)
+		ioim->io_cbfn = __bfa_cb_ioim_pathtov;
+	else
+		ioim->io_cbfn = __bfa_cb_ioim_failed;
+
+	bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+
+    /**
+     * Move IO to fcpim global queue since itnim will be
+     * freed.
+     */
+    list_del(&ioim->qe);
+    list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+}
+
+
+
+/**
+ *  bfa_ioim_friend
+ */
+
+/**
+ * Memory allocation and initialization.
+ */
+void
+bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
+{
+	struct bfa_ioim_s		*ioim;
+	struct bfa_ioim_sp_s	*iosp;
+	u16		i;
+	u8			*snsinfo;
+	u32		snsbufsz;
+
+	/**
+	 * claim memory first
+	 */
+	ioim = (struct bfa_ioim_s *) bfa_meminfo_kva(minfo);
+	fcpim->ioim_arr = ioim;
+	bfa_meminfo_kva(minfo) = (u8 *) (ioim + fcpim->num_ioim_reqs);
+
+	iosp = (struct bfa_ioim_sp_s *) bfa_meminfo_kva(minfo);
+	fcpim->ioim_sp_arr = iosp;
+	bfa_meminfo_kva(minfo) = (u8 *) (iosp + fcpim->num_ioim_reqs);
+
+	/**
+	 * Claim DMA memory for per IO sense data.
+	 */
+	snsbufsz = fcpim->num_ioim_reqs * BFI_IOIM_SNSLEN;
+	fcpim->snsbase.pa  = bfa_meminfo_dma_phys(minfo);
+	bfa_meminfo_dma_phys(minfo) += snsbufsz;
+
+	fcpim->snsbase.kva = bfa_meminfo_dma_virt(minfo);
+	bfa_meminfo_dma_virt(minfo) += snsbufsz;
+	snsinfo = fcpim->snsbase.kva;
+	bfa_iocfc_set_snsbase(fcpim->bfa, fcpim->snsbase.pa);
+
+	/**
+	 * Initialize ioim free queues
+	 */
+	INIT_LIST_HEAD(&fcpim->ioim_free_q);
+	INIT_LIST_HEAD(&fcpim->ioim_resfree_q);
+	INIT_LIST_HEAD(&fcpim->ioim_comp_q);
+
+	for (i = 0; i < fcpim->num_ioim_reqs;
+	     i++, ioim++, iosp++, snsinfo += BFI_IOIM_SNSLEN) {
+		/*
+		 * initialize IOIM
+		 */
+		bfa_os_memset(ioim, 0, sizeof(struct bfa_ioim_s));
+		ioim->iotag   = i;
+		ioim->bfa     = fcpim->bfa;
+		ioim->fcpim   = fcpim;
+		ioim->iosp    = iosp;
+		iosp->snsinfo = snsinfo;
+		INIT_LIST_HEAD(&ioim->sgpg_q);
+		bfa_reqq_winit(&ioim->iosp->reqq_wait,
+				   bfa_ioim_qresume, ioim);
+		bfa_sgpg_winit(&ioim->iosp->sgpg_wqe,
+				   bfa_ioim_sgpg_alloced, ioim);
+		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
+
+		list_add_tail(&ioim->qe, &fcpim->ioim_free_q);
+	}
+}
+
+/**
+ * Driver detach time call.
+ */
+void
+bfa_ioim_detach(struct bfa_fcpim_mod_s *fcpim)
+{
+}
+
+void
+bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfi_ioim_rsp_s *rsp = (struct bfi_ioim_rsp_s *) m;
+	struct bfa_ioim_s *ioim;
+	u16        iotag;
+	enum bfa_ioim_event evt = BFA_IOIM_SM_COMP;
+
+	iotag = bfa_os_ntohs(rsp->io_tag);
+
+	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
+	bfa_assert(ioim->iotag == iotag);
+
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, rsp->io_status);
+	bfa_trc(ioim->bfa, rsp->reuse_io_tag);
+
+	if (bfa_sm_cmp_state(ioim, bfa_ioim_sm_active))
+		bfa_os_assign(ioim->iosp->comp_rspmsg, *m);
+
+	switch (rsp->io_status) {
+	case BFI_IOIM_STS_OK:
+		bfa_fcpim_stats(fcpim, iocomp_ok);
+		if (rsp->reuse_io_tag == 0)
+			evt = BFA_IOIM_SM_DONE;
+		else
+			evt = BFA_IOIM_SM_COMP;
+		break;
+
+	case BFI_IOIM_STS_TIMEDOUT:
+	case BFI_IOIM_STS_ABORTED:
+		rsp->io_status = BFI_IOIM_STS_ABORTED;
+		bfa_fcpim_stats(fcpim, iocomp_aborted);
+		if (rsp->reuse_io_tag == 0)
+			evt = BFA_IOIM_SM_DONE;
+		else
+			evt = BFA_IOIM_SM_COMP;
+		break;
+
+	case BFI_IOIM_STS_PROTO_ERR:
+		bfa_fcpim_stats(fcpim, iocom_proto_err);
+		bfa_assert(rsp->reuse_io_tag);
+		evt = BFA_IOIM_SM_COMP;
+		break;
+
+	case BFI_IOIM_STS_SQER_NEEDED:
+		bfa_fcpim_stats(fcpim, iocom_sqer_needed);
+		bfa_assert(rsp->reuse_io_tag == 0);
+		evt = BFA_IOIM_SM_SQRETRY;
+		break;
+
+	case BFI_IOIM_STS_RES_FREE:
+		bfa_fcpim_stats(fcpim, iocom_res_free);
+		evt = BFA_IOIM_SM_FREE;
+		break;
+
+	case BFI_IOIM_STS_HOST_ABORTED:
+		bfa_fcpim_stats(fcpim, iocom_hostabrts);
+		if (rsp->abort_tag != ioim->abort_tag) {
+			bfa_trc(ioim->bfa, rsp->abort_tag);
+			bfa_trc(ioim->bfa, ioim->abort_tag);
+			return;
+		}
+
+		if (rsp->reuse_io_tag)
+			evt = BFA_IOIM_SM_ABORT_COMP;
+		else
+			evt = BFA_IOIM_SM_ABORT_DONE;
+		break;
+
+	case BFI_IOIM_STS_UTAG:
+		bfa_fcpim_stats(fcpim, iocom_utags);
+		evt = BFA_IOIM_SM_COMP_UTAG;
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+
+	bfa_sm_send_event(ioim, evt);
+}
+
+void
+bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfi_ioim_rsp_s *rsp = (struct bfi_ioim_rsp_s *) m;
+	struct bfa_ioim_s *ioim;
+	u16        iotag;
+
+	iotag = bfa_os_ntohs(rsp->io_tag);
+
+	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
+	bfa_assert(ioim->iotag == iotag);
+
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_COMP_GOOD);
+}
+
+/**
+ * Called by itnim to clean up IO while going offline.
+ */
+void
+bfa_ioim_cleanup(struct bfa_ioim_s *ioim)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_fcpim_stats(ioim->fcpim, io_cleanups);
+
+	ioim->iosp->tskim = NULL;
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_CLEANUP);
+}
+
+void
+bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim, struct bfa_tskim_s *tskim)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_fcpim_stats(ioim->fcpim, io_tmaborts);
+
+	ioim->iosp->tskim = tskim;
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_CLEANUP);
+}
+
+/**
+ * IOC failure handling.
+ */
+void
+bfa_ioim_iocdisable(struct bfa_ioim_s *ioim)
+{
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_HWFAIL);
+}
+
+/**
+ * IO offline TOV popped. Fail the pending IO.
+ */
+void
+bfa_ioim_tov(struct bfa_ioim_s *ioim)
+{
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_IOTOV);
+}
+
+
+
+/**
+ *  bfa_ioim_api
+ */
+
+/**
+ * Allocate IOIM resource for initiator mode I/O request.
+ */
+struct bfa_ioim_s *
+bfa_ioim_alloc(struct bfa_s *bfa, struct bfad_ioim_s *dio,
+		struct bfa_itnim_s *itnim, u16 nsges)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_ioim_s *ioim;
+
+	/**
+	 * alocate IOIM resource
+	 */
+	bfa_q_deq(&fcpim->ioim_free_q, &ioim);
+	if (!ioim) {
+		bfa_fcpim_stats(fcpim, no_iotags);
+		return NULL;
+	}
+
+	ioim->dio = dio;
+	ioim->itnim = itnim;
+	ioim->nsges = nsges;
+	ioim->nsgpgs = 0;
+
+	bfa_stats(fcpim, total_ios);
+	bfa_stats(itnim, ios);
+	fcpim->ios_active++;
+
+	list_add_tail(&ioim->qe, &itnim->io_q);
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+
+	return ioim;
+}
+
+void
+bfa_ioim_free(struct bfa_ioim_s *ioim)
+{
+	struct bfa_fcpim_mod_s *fcpim = ioim->fcpim;
+
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_assert_fp(bfa_sm_cmp_state(ioim, bfa_ioim_sm_uninit));
+
+	bfa_assert_fp(list_empty(&ioim->sgpg_q)
+		   || (ioim->nsges > BFI_SGE_INLINE));
+
+	if (ioim->nsgpgs > 0)
+		bfa_sgpg_mfree(ioim->bfa, &ioim->sgpg_q, ioim->nsgpgs);
+
+	bfa_stats(ioim->itnim, io_comps);
+	fcpim->ios_active--;
+
+	list_del(&ioim->qe);
+	list_add_tail(&ioim->qe, &fcpim->ioim_free_q);
+}
+
+void
+bfa_ioim_start(struct bfa_ioim_s *ioim)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_START);
+}
+
+/**
+ * Driver I/O abort request.
+ */
+void
+bfa_ioim_abort(struct bfa_ioim_s *ioim)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_fcpim_stats(ioim->fcpim, io_aborts);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_ABORT);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_itnim.c patch/drivers/scsi/bfa/bfa_itnim.c
--- orig/drivers/scsi/bfa/bfa_itnim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_itnim.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,1088 @@
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
+#include <bfa_fcpim.h>
+#include "bfa_fcpim_priv.h"
+
+BFA_TRC_FILE(HAL, ITNIM);
+
+#define BFA_ITNIM_FROM_TAG(_fcpim, _tag)				\
+	((_fcpim)->itnim_arr + ((_tag) & ((_fcpim)->num_itnims - 1)))
+
+#define bfa_fcpim_additn(__itnim)					\
+	list_add_tail(&(__itnim)->qe, &(__itnim)->fcpim->itnim_q)
+#define bfa_fcpim_delitn(__itnim)	do {				\
+	bfa_assert(bfa_q_is_on_q(&(__itnim)->fcpim->itnim_q, __itnim));      \
+	list_del(&(__itnim)->qe);      \
+	bfa_assert(list_empty(&(__itnim)->io_q));      \
+	bfa_assert(list_empty(&(__itnim)->io_cleanup_q));      \
+	bfa_assert(list_empty(&(__itnim)->pending_q));      \
+} while (0)
+
+#define bfa_itnim_online_cb(__itnim) do {				\
+	if ((__itnim)->bfa->fcs)					\
+		bfa_cb_itnim_online((__itnim)->ditn);      \
+	else {								\
+		bfa_cb_queue((__itnim)->bfa, &(__itnim)->hcb_qe,	\
+		__bfa_cb_itnim_online, (__itnim));      \
+	}								\
+} while (0)
+
+#define bfa_itnim_offline_cb(__itnim) do {				\
+	if ((__itnim)->bfa->fcs)					\
+		bfa_cb_itnim_offline((__itnim)->ditn);      \
+	else {								\
+		bfa_cb_queue((__itnim)->bfa, &(__itnim)->hcb_qe,	\
+		__bfa_cb_itnim_offline, (__itnim));      \
+	}								\
+} while (0)
+
+#define bfa_itnim_sler_cb(__itnim) do {					\
+	if ((__itnim)->bfa->fcs)					\
+		bfa_cb_itnim_sler((__itnim)->ditn);      \
+	else {								\
+		bfa_cb_queue((__itnim)->bfa, &(__itnim)->hcb_qe,	\
+		__bfa_cb_itnim_sler, (__itnim));      \
+	}								\
+} while (0)
+
+/*
+ * forward declarations
+ */
+static void     bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim);
+static bfa_boolean_t bfa_itnim_send_fwcreate(struct bfa_itnim_s *itnim);
+static bfa_boolean_t bfa_itnim_send_fwdelete(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_cleanp_comp(void *itnim_cbarg);
+static void     bfa_itnim_cleanup(struct bfa_itnim_s *itnim);
+static void     __bfa_cb_itnim_online(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_itnim_offline(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_itnim_sler(void *cbarg, bfa_boolean_t complete);
+static void     bfa_itnim_iotov_online(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov_cleanup(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov(void *itnim_arg);
+static void     bfa_itnim_iotov_start(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov_delete(struct bfa_itnim_s *itnim);
+
+/**
+ *  bfa_itnim_sm BFA itnim state machine
+ */
+
+
+enum bfa_itnim_event {
+	BFA_ITNIM_SM_CREATE = 1,	/*  itnim is created */
+	BFA_ITNIM_SM_ONLINE = 2,	/*  itnim is online */
+	BFA_ITNIM_SM_OFFLINE = 3,	/*  itnim is offline */
+	BFA_ITNIM_SM_FWRSP = 4,		/*  firmware response */
+	BFA_ITNIM_SM_DELETE = 5,	/*  deleting an existing itnim */
+	BFA_ITNIM_SM_CLEANUP = 6,	/*  IO cleanup completion */
+	BFA_ITNIM_SM_SLER = 7,		/*  second level error recovery */
+	BFA_ITNIM_SM_HWFAIL = 8,	/*  IOC h/w failure event */
+	BFA_ITNIM_SM_QRESUME = 9,	/*  queue space available */
+};
+
+static void     bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim,
+					enum bfa_itnim_event event);
+static void     bfa_itnim_sm_created(struct bfa_itnim_s *itnim,
+					 enum bfa_itnim_event event);
+static void     bfa_itnim_sm_fwcreate(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void	bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
+				enum bfa_itnim_event event);
+static void     bfa_itnim_sm_online(struct bfa_itnim_s *itnim,
+					enum bfa_itnim_event event);
+static void     bfa_itnim_sm_sler(struct bfa_itnim_s *itnim,
+				      enum bfa_itnim_event event);
+static void     bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
+						 enum bfa_itnim_event event);
+static void     bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
+						enum bfa_itnim_event event);
+static void     bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void     bfa_itnim_sm_offline(struct bfa_itnim_s *itnim,
+					 enum bfa_itnim_event event);
+static void     bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
+					    enum bfa_itnim_event event);
+static void     bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void     bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void     bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void     bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+
+/**
+ * 		Beginning/unallocated state - no events expected.
+ */
+static void
+bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_CREATE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_created);
+		itnim->is_online = BFA_FALSE;
+		bfa_fcpim_additn(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Beginning state, only online event expected.
+ */
+static void
+bfa_itnim_sm_created(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_ONLINE:
+		if (bfa_itnim_send_fwcreate(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate_qfull);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Waiting for itnim create response from firmware.
+ */
+static void
+bfa_itnim_sm_fwcreate(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_online);
+		itnim->is_online = BFA_TRUE;
+		bfa_itnim_iotov_online(itnim);
+		bfa_itnim_online_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_delete_pending);
+		break;
+
+	case BFA_ITNIM_SM_OFFLINE:
+		if (bfa_itnim_send_fwdelete(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete_qfull);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
+			enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_QRESUME:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		bfa_itnim_send_fwcreate(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_reqq_wcancel(&itnim->reqq_wait);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_offline);
+		bfa_reqq_wcancel(&itnim->reqq_wait);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_reqq_wcancel(&itnim->reqq_wait);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 	Waiting for itnim create response from firmware, a delete is pending.
+ */
+static void
+bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
+				enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+		if (bfa_itnim_send_fwdelete(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_deleting_qfull);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Online state - normal parking state.
+ */
+static void
+bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_offline);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_itnim_cleanup(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_delete);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_cleanup(itnim);
+		break;
+
+	case BFA_ITNIM_SM_SLER:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_sler);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_itnim_sler_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Second level error recovery need.
+ */
+static void
+bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_offline);
+		bfa_itnim_cleanup(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_delete);
+		bfa_itnim_cleanup(itnim);
+		bfa_itnim_iotov_delete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Going offline. Waiting for active IO cleanup.
+ */
+static void
+bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
+				 enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_CLEANUP:
+		if (bfa_itnim_send_fwdelete(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete_qfull);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_delete);
+		bfa_itnim_iotov_delete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_SLER:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Deleting itnim. Waiting for active IO cleanup.
+ */
+static void
+bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
+				enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_CLEANUP:
+		if (bfa_itnim_send_fwdelete(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_deleting_qfull);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Rport offline. Fimrware itnim is being deleted - awaiting f/w response.
+ */
+static void
+bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_offline);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
+			enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_QRESUME:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete);
+		bfa_itnim_send_fwdelete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_deleting_qfull);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_reqq_wcancel(&itnim->reqq_wait);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Offline state.
+ */
+static void
+bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_itnim_iotov_delete(itnim);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_ONLINE:
+		if (bfa_itnim_send_fwcreate(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate_qfull);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IOC h/w failed state.
+ */
+static void
+bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
+			    enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_itnim_iotov_delete(itnim);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_ONLINE:
+		if (bfa_itnim_send_fwcreate(itnim))
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate_qfull);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Itnim is deleted, waiting for firmware response to delete.
+ */
+static void
+bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
+			enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_QRESUME:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		bfa_itnim_send_fwdelete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_reqq_wcancel(&itnim->reqq_wait);
+		bfa_fcpim_delitn(itnim);
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
+ *  bfa_itnim_private
+ */
+
+/**
+ * 		Initiate cleanup of all IOs on an IOC failure.
+ */
+static void
+bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim)
+{
+	struct bfa_tskim_s *tskim;
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &itnim->tsk_q) {
+		tskim = (struct bfa_tskim_s *) qe;
+		bfa_tskim_iocdisable(tskim);
+	}
+
+	list_for_each_safe(qe, qen, &itnim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_iocdisable(ioim);
+	}
+
+	/**
+	 * For IO request in pending queue, we pretend an early timeout.
+	 */
+	list_for_each_safe(qe, qen, &itnim->pending_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_tov(ioim);
+	}
+
+	list_for_each_safe(qe, qen, &itnim->io_cleanup_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_iocdisable(ioim);
+	}
+}
+
+/**
+ * 		IO cleanup completion
+ */
+static void
+bfa_itnim_cleanp_comp(void *itnim_cbarg)
+{
+	struct bfa_itnim_s *itnim = itnim_cbarg;
+
+	bfa_stats(itnim, cleanup_comps);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_CLEANUP);
+}
+
+/**
+ * 		Initiate cleanup of all IOs.
+ */
+static void
+bfa_itnim_cleanup(struct bfa_itnim_s *itnim)
+{
+	struct bfa_ioim_s  *ioim;
+	struct bfa_tskim_s *tskim;
+	struct list_head         *qe, *qen;
+
+	bfa_wc_init(&itnim->wc, bfa_itnim_cleanp_comp, itnim);
+
+	list_for_each_safe(qe, qen, &itnim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+
+		/**
+		 * Move IO to a cleanup queue from active queue so that a later
+		 * TM will not pickup this IO.
+		 */
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &itnim->io_cleanup_q);
+
+		bfa_wc_up(&itnim->wc);
+		bfa_ioim_cleanup(ioim);
+	}
+
+	list_for_each_safe(qe, qen, &itnim->tsk_q) {
+		tskim = (struct bfa_tskim_s *) qe;
+		bfa_wc_up(&itnim->wc);
+		bfa_tskim_cleanup(tskim);
+	}
+
+	bfa_wc_wait(&itnim->wc);
+}
+
+static void
+__bfa_cb_itnim_online(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	if (complete)
+		bfa_cb_itnim_online(itnim->ditn);
+}
+
+static void
+__bfa_cb_itnim_offline(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	if (complete)
+		bfa_cb_itnim_offline(itnim->ditn);
+}
+
+static void
+__bfa_cb_itnim_sler(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	if (complete)
+		bfa_cb_itnim_sler(itnim->ditn);
+}
+
+/**
+ * Call to resume any I/O requests waiting for room in request queue.
+ */
+static void
+bfa_itnim_qresume(void *cbarg)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_QRESUME);
+}
+
+
+
+
+/**
+ *  bfa_itnim_public
+ */
+
+void
+bfa_itnim_iodone(struct bfa_itnim_s *itnim)
+{
+	bfa_wc_down(&itnim->wc);
+}
+
+void
+bfa_itnim_tskdone(struct bfa_itnim_s *itnim)
+{
+	bfa_wc_down(&itnim->wc);
+}
+
+void
+bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	/**
+	 * ITN memory
+	 */
+	*km_len += cfg->fwcfg.num_rports * sizeof(struct bfa_itnim_s);
+}
+
+void
+bfa_itnim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
+{
+	struct bfa_s      *bfa = fcpim->bfa;
+	struct bfa_itnim_s *itnim;
+	int             i;
+
+	INIT_LIST_HEAD(&fcpim->itnim_q);
+
+	itnim = (struct bfa_itnim_s *) bfa_meminfo_kva(minfo);
+	fcpim->itnim_arr = itnim;
+
+	for (i = 0; i < fcpim->num_itnims; i++, itnim++) {
+		bfa_os_memset(itnim, 0, sizeof(struct bfa_itnim_s));
+		itnim->bfa = bfa;
+		itnim->fcpim = fcpim;
+		itnim->reqq = BFA_REQQ_QOS_LO;
+		itnim->rport = BFA_RPORT_FROM_TAG(bfa, i);
+		itnim->iotov_active = BFA_FALSE;
+		bfa_reqq_winit(&itnim->reqq_wait, bfa_itnim_qresume, itnim);
+
+		INIT_LIST_HEAD(&itnim->io_q);
+		INIT_LIST_HEAD(&itnim->io_cleanup_q);
+		INIT_LIST_HEAD(&itnim->pending_q);
+		INIT_LIST_HEAD(&itnim->tsk_q);
+		INIT_LIST_HEAD(&itnim->delay_comp_q);
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+	}
+
+	bfa_meminfo_kva(minfo) = (u8 *) itnim;
+}
+
+void
+bfa_itnim_iocdisable(struct bfa_itnim_s *itnim)
+{
+	bfa_stats(itnim, ioc_disabled);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_HWFAIL);
+}
+
+static bfa_boolean_t
+bfa_itnim_send_fwcreate(struct bfa_itnim_s *itnim)
+{
+	struct bfi_itnim_create_req_s *m;
+
+	itnim->msg_no++;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(itnim->bfa, itnim->reqq, &itnim->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_ITNIM, BFI_ITNIM_H2I_CREATE_REQ,
+			bfa_lpuid(itnim->bfa));
+	m->fw_handle = itnim->rport->fw_handle;
+	m->class = FC_CLASS_3;
+	m->seq_rec = itnim->seq_rec;
+	m->msg_no = itnim->msg_no;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(itnim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_itnim_send_fwdelete(struct bfa_itnim_s *itnim)
+{
+	struct bfi_itnim_delete_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(itnim->bfa, itnim->reqq, &itnim->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_ITNIM, BFI_ITNIM_H2I_DELETE_REQ,
+			bfa_lpuid(itnim->bfa));
+	m->fw_handle = itnim->rport->fw_handle;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(itnim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Cleanup all pending failed inflight requests.
+ */
+static void
+bfa_itnim_delayed_comp(struct bfa_itnim_s *itnim, bfa_boolean_t iotov)
+{
+	struct bfa_ioim_s *ioim;
+	struct list_head *qe, *qen;
+
+	list_for_each_safe(qe, qen, &itnim->delay_comp_q) {
+		ioim = (struct bfa_ioim_s *)qe;
+		bfa_ioim_delayed_comp(ioim, iotov);
+	}
+}
+
+/**
+ * Start all pending IO requests.
+ */
+static void
+bfa_itnim_iotov_online(struct bfa_itnim_s *itnim)
+{
+	struct bfa_ioim_s *ioim;
+
+	bfa_itnim_iotov_stop(itnim);
+
+	/**
+	 * Abort all inflight IO requests in the queue
+	 */
+	bfa_itnim_delayed_comp(itnim, BFA_FALSE);
+
+	/**
+	 * Start all pending IO requests.
+	 */
+	while (!list_empty(&itnim->pending_q)) {
+		bfa_q_deq(&itnim->pending_q, &ioim);
+		list_add_tail(&ioim->qe, &itnim->io_q);
+		bfa_ioim_start(ioim);
+	}
+}
+
+/**
+ * Fail all pending IO requests
+ */
+static void
+bfa_itnim_iotov_cleanup(struct bfa_itnim_s *itnim)
+{
+	struct bfa_ioim_s *ioim;
+
+	/**
+	 * Fail all inflight IO requests in the queue
+	 */
+	bfa_itnim_delayed_comp(itnim, BFA_TRUE);
+
+	/**
+	 * Fail any pending IO requests.
+	 */
+	while (!list_empty(&itnim->pending_q)) {
+		bfa_q_deq(&itnim->pending_q, &ioim);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+		bfa_ioim_tov(ioim);
+	}
+}
+
+/**
+ * IO TOV timer callback. Fail any pending IO requests.
+ */
+static void
+bfa_itnim_iotov(void *itnim_arg)
+{
+	struct bfa_itnim_s *itnim = itnim_arg;
+
+	itnim->iotov_active = BFA_FALSE;
+
+	bfa_cb_itnim_tov_begin(itnim->ditn);
+	bfa_itnim_iotov_cleanup(itnim);
+	bfa_cb_itnim_tov(itnim->ditn);
+}
+
+/**
+ * Start IO TOV timer for failing back pending IO requests in offline state.
+ */
+static void
+bfa_itnim_iotov_start(struct bfa_itnim_s *itnim)
+{
+	if (itnim->fcpim->path_tov > 0) {
+
+		itnim->iotov_active = BFA_TRUE;
+		bfa_assert(bfa_itnim_hold_io(itnim));
+		bfa_timer_start(itnim->bfa, &itnim->timer,
+			bfa_itnim_iotov, itnim, itnim->fcpim->path_tov);
+	}
+}
+
+/**
+ * Stop IO TOV timer.
+ */
+static void
+bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim)
+{
+	if (itnim->iotov_active) {
+		itnim->iotov_active = BFA_FALSE;
+		bfa_timer_stop(&itnim->timer);
+	}
+}
+
+/**
+ * Stop IO TOV timer.
+ */
+static void
+bfa_itnim_iotov_delete(struct bfa_itnim_s *itnim)
+{
+    bfa_boolean_t pathtov_active = BFA_FALSE;
+
+    if (itnim->iotov_active)
+		pathtov_active = BFA_TRUE;
+
+	bfa_itnim_iotov_stop(itnim);
+	if (pathtov_active)
+		bfa_cb_itnim_tov_begin(itnim->ditn);
+	bfa_itnim_iotov_cleanup(itnim);
+	if (pathtov_active)
+		bfa_cb_itnim_tov(itnim->ditn);
+}
+
+
+
+/**
+ *  bfa_itnim_public
+ */
+
+/**
+ * 		Itnim interrupt processing.
+ */
+void
+bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	union bfi_itnim_i2h_msg_u msg;
+	struct bfa_itnim_s *itnim;
+
+	bfa_trc(bfa, m->mhdr.msg_id);
+
+	msg.msg = m;
+
+	switch (m->mhdr.msg_id) {
+	case BFI_ITNIM_I2H_CREATE_RSP:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.create_rsp->bfa_handle);
+		bfa_assert(msg.create_rsp->status == BFA_STATUS_OK);
+		bfa_stats(itnim, create_comps);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_FWRSP);
+		break;
+
+	case BFI_ITNIM_I2H_DELETE_RSP:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.delete_rsp->bfa_handle);
+		bfa_assert(msg.delete_rsp->status == BFA_STATUS_OK);
+		bfa_stats(itnim, delete_comps);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_FWRSP);
+		break;
+
+	case BFI_ITNIM_I2H_SLER_EVENT:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.sler_event->bfa_handle);
+		bfa_stats(itnim, sler_events);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_SLER);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_itnim_api
+ */
+
+struct bfa_itnim_s *
+bfa_itnim_create(struct bfa_s *bfa, struct bfa_rport_s *rport, void *ditn)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_itnim_s *itnim;
+
+	itnim = BFA_ITNIM_FROM_TAG(fcpim, rport->rport_tag);
+	bfa_assert(itnim->rport == rport);
+
+	itnim->ditn = ditn;
+
+	bfa_stats(itnim, creates);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_CREATE);
+
+	return (itnim);
+}
+
+void
+bfa_itnim_delete(struct bfa_itnim_s *itnim)
+{
+	bfa_stats(itnim, deletes);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_DELETE);
+}
+
+void
+bfa_itnim_online(struct bfa_itnim_s *itnim, bfa_boolean_t seq_rec)
+{
+	itnim->seq_rec = seq_rec;
+	bfa_stats(itnim, onlines);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_ONLINE);
+}
+
+void
+bfa_itnim_offline(struct bfa_itnim_s *itnim)
+{
+	bfa_stats(itnim, offlines);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_OFFLINE);
+}
+
+/**
+ * Return true if itnim is considered offline for holding off IO request.
+ * IO is not held if itnim is being deleted.
+ */
+bfa_boolean_t
+bfa_itnim_hold_io(struct bfa_itnim_s *itnim)
+{
+	return (
+		itnim->fcpim->path_tov && itnim->iotov_active &&
+		(bfa_sm_cmp_state(itnim, bfa_itnim_sm_fwcreate) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_sler) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_cleanup_offline) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_fwdelete) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_offline) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_iocdisable))
+);
+}
+
+void
+bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
+	struct bfa_itnim_hal_stats_s *stats)
+{
+	*stats = itnim->stats;
+}
+
+void
+bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
+{
+	bfa_os_memset(&itnim->stats, 0, sizeof(itnim->stats));
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_log.c patch/drivers/scsi/bfa/bfa_log.c
--- orig/drivers/scsi/bfa/bfa_log.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_log.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,346 @@
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
+ *  bfa_log.c BFA log library
+ */
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_log.h>
+
+/*
+ * global log info structure
+ */
+struct bfa_log_info_s {
+	u32        start_idx;	/*  start index for a module */
+	u32        total_count;	/*  total count for a module */
+	enum bfa_log_severity level;	/*  global log level */
+	bfa_log_cb_t	cbfn;		/*  callback function */
+};
+
+static struct bfa_log_info_s bfa_log_info[BFA_LOG_MODULE_ID_MAX + 1];
+static u32 bfa_log_msg_total_count;
+static int      bfa_log_initialized;
+
+static char    *bfa_log_severity[] =
+	{ "[none]", "[critical]", "[error]", "[warn]", "[info]", "" };
+
+/**
+ * BFA log library initialization
+ *
+ * The log library initialization includes the following,
+ *    - set log instance name and callback function
+ *    - read the message array generated from xml files
+ *    - calculate start index for each module
+ *    - calculate message count for each module
+ *    - perform error checking
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] instance_name - instance name
+ * @param[in] cbfn - callback function
+ *
+ * It return 0 on success, or -1 on failure
+ */
+int
+bfa_log_init(struct bfa_log_mod_s *log_mod, char *instance_name,
+			bfa_log_cb_t cbfn)
+{
+	struct bfa_log_msgdef_s *msg;
+	u32        pre_mod_id = 0;
+	u32        cur_mod_id = 0;
+	u32        i, pre_idx, idx, msg_id;
+
+	/*
+	 * set instance name
+	 */
+	if (log_mod) {
+		strncpy(log_mod->instance_info, instance_name,
+			sizeof(log_mod->instance_info));
+		log_mod->cbfn = cbfn;
+		for (i = 0; i <= BFA_LOG_MODULE_ID_MAX; i++)
+			log_mod->log_level[i] = BFA_LOG_WARNING;
+	}
+
+	if (bfa_log_initialized)
+		return 0;
+
+	for (i = 0; i <= BFA_LOG_MODULE_ID_MAX; i++) {
+		bfa_log_info[i].start_idx = 0;
+		bfa_log_info[i].total_count = 0;
+		bfa_log_info[i].level = BFA_LOG_WARNING;
+		bfa_log_info[i].cbfn = cbfn;
+	}
+
+	pre_idx = 0;
+	idx = 0;
+	msg = bfa_log_msg_array;
+	msg_id = BFA_LOG_GET_MSG_ID(msg);
+	pre_mod_id = BFA_LOG_GET_MOD_ID(msg_id);
+	while (msg_id != 0) {
+		cur_mod_id = BFA_LOG_GET_MOD_ID(msg_id);
+
+		if (cur_mod_id > BFA_LOG_MODULE_ID_MAX) {
+			cbfn(log_mod, msg_id,
+				"%s%s log: module id %u out of range\n",
+				BFA_LOG_CAT_NAME,
+				bfa_log_severity[BFA_LOG_ERROR],
+				cur_mod_id);
+			return -1;
+		}
+
+		if (pre_mod_id > BFA_LOG_MODULE_ID_MAX) {
+			cbfn(log_mod, msg_id,
+				"%s%s log: module id %u out of range\n",
+				BFA_LOG_CAT_NAME,
+				bfa_log_severity[BFA_LOG_ERROR],
+				pre_mod_id);
+			return -1;
+		}
+
+		if (cur_mod_id != pre_mod_id) {
+			bfa_log_info[pre_mod_id].start_idx = pre_idx;
+			bfa_log_info[pre_mod_id].total_count = idx - pre_idx;
+			pre_mod_id = cur_mod_id;
+			pre_idx = idx;
+		}
+
+		idx++;
+		msg++;
+		msg_id = BFA_LOG_GET_MSG_ID(msg);
+	}
+
+	bfa_log_info[cur_mod_id].start_idx = pre_idx;
+	bfa_log_info[cur_mod_id].total_count = idx - pre_idx;
+	bfa_log_msg_total_count = idx;
+
+	cbfn(log_mod, msg_id, "%s%s log: init OK, msg total count %u\n",
+		BFA_LOG_CAT_NAME,
+		bfa_log_severity[BFA_LOG_INFO], bfa_log_msg_total_count);
+
+	bfa_log_initialized = 1;
+
+	return 0;
+}
+
+/**
+ * BFA log set log level for a module
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] mod_id - module id
+ * @param[in] log_level - log severity level
+ *
+ * It return BFA_STATUS_OK on success, or > 0 on failure
+ */
+bfa_status_t
+bfa_log_set_level(struct bfa_log_mod_s *log_mod, int mod_id,
+		  enum bfa_log_severity log_level)
+{
+	if (mod_id <= BFA_LOG_UNUSED_ID || mod_id > BFA_LOG_MODULE_ID_MAX)
+		return BFA_STATUS_EINVAL;
+
+	if (log_level <= BFA_LOG_INVALID || log_level > BFA_LOG_LEVEL_MAX)
+		return BFA_STATUS_EINVAL;
+
+	if (log_mod)
+		log_mod->log_level[mod_id] = log_level;
+	else
+		bfa_log_info[mod_id].level = log_level;
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * BFA log set log level for all modules
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] log_level - log severity level
+ *
+ * It return BFA_STATUS_OK on success, or > 0 on failure
+ */
+bfa_status_t
+bfa_log_set_level_all(struct bfa_log_mod_s *log_mod,
+		  enum bfa_log_severity log_level)
+{
+	int mod_id = BFA_LOG_UNUSED_ID + 1;
+
+	if (log_level <= BFA_LOG_INVALID || log_level > BFA_LOG_LEVEL_MAX)
+		return BFA_STATUS_EINVAL;
+
+	if (log_mod) {
+		for (; mod_id <= BFA_LOG_MODULE_ID_MAX; mod_id++)
+			log_mod->log_level[mod_id] = log_level;
+	} else {
+		for (; mod_id <= BFA_LOG_MODULE_ID_MAX; mod_id++)
+			bfa_log_info[mod_id].level = log_level;
+	}
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * BFA log set log level for all aen sub-modules
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] log_level - log severity level
+ *
+ * It return BFA_STATUS_OK on success, or > 0 on failure
+ */
+bfa_status_t
+bfa_log_set_level_aen(struct bfa_log_mod_s *log_mod,
+		  enum bfa_log_severity log_level)
+{
+	int mod_id = BFA_LOG_AEN_MIN + 1;
+
+	if (log_mod) {
+		for (; mod_id <= BFA_LOG_AEN_MAX; mod_id++)
+			log_mod->log_level[mod_id] = log_level;
+	} else {
+		for (; mod_id <= BFA_LOG_AEN_MAX; mod_id++)
+			bfa_log_info[mod_id].level = log_level;
+	}
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * BFA log get log level for a module
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] mod_id - module id
+ *
+ * It returns log level or -1 on error
+ */
+enum bfa_log_severity
+bfa_log_get_level(struct bfa_log_mod_s *log_mod, int mod_id)
+{
+	if (mod_id <= BFA_LOG_UNUSED_ID || mod_id > BFA_LOG_MODULE_ID_MAX)
+		return BFA_LOG_INVALID;
+
+	if (log_mod)
+		return (log_mod->log_level[mod_id]);
+	else
+		return (bfa_log_info[mod_id].level);
+}
+
+enum bfa_log_severity
+bfa_log_get_msg_level(struct bfa_log_mod_s *log_mod, u32 msg_id)
+{
+	struct bfa_log_msgdef_s *msg;
+	u32        mod = BFA_LOG_GET_MOD_ID(msg_id);
+	u32        idx = BFA_LOG_GET_MSG_IDX(msg_id) - 1;
+
+	if (!bfa_log_initialized)
+		return BFA_LOG_INVALID;
+
+	if (mod > BFA_LOG_MODULE_ID_MAX)
+		return BFA_LOG_INVALID;
+
+	if (idx >= bfa_log_info[mod].total_count) {
+		bfa_log_info[mod].cbfn(log_mod, msg_id,
+			"%s%s log: inconsistent idx %u vs. total count %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR], idx,
+			bfa_log_info[mod].total_count);
+		return BFA_LOG_INVALID;
+	}
+
+	msg = bfa_log_msg_array + bfa_log_info[mod].start_idx + idx;
+	if (msg_id != BFA_LOG_GET_MSG_ID(msg)) {
+		bfa_log_info[mod].cbfn(log_mod, msg_id,
+			"%s%s log: inconsistent msg id %u array msg id %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR],
+			msg_id, BFA_LOG_GET_MSG_ID(msg));
+		return BFA_LOG_INVALID;
+	}
+
+	return BFA_LOG_GET_SEVERITY(msg);
+}
+
+/**
+ * BFA log message handling
+ *
+ * BFA log message handling finds the message based on message id and prints
+ * out the message based on its format and arguments. It also does prefix
+ * the severity etc.
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] msg_id - message id
+ * @param[in] ... - message arguments
+ *
+ * It return 0 on success, or -1 on errors
+ */
+int
+bfa_log(struct bfa_log_mod_s *log_mod, u32 msg_id, ...)
+{
+	va_list         ap;
+	char            buf[256];
+	struct bfa_log_msgdef_s *msg;
+	int             log_level;
+	u32        mod = BFA_LOG_GET_MOD_ID(msg_id);
+	u32        idx = BFA_LOG_GET_MSG_IDX(msg_id) - 1;
+
+	if (!bfa_log_initialized)
+		return -1;
+
+	if (mod > BFA_LOG_MODULE_ID_MAX)
+		return -1;
+
+	if (idx >= bfa_log_info[mod].total_count) {
+		bfa_log_info[mod].
+			cbfn
+			(log_mod, msg_id,
+			"%s%s log: inconsistent idx %u vs. total count %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR], idx,
+			bfa_log_info[mod].total_count);
+		return -1;
+	}
+
+	msg = bfa_log_msg_array + bfa_log_info[mod].start_idx + idx;
+	if (msg_id != BFA_LOG_GET_MSG_ID(msg)) {
+		bfa_log_info[mod].
+			cbfn
+			(log_mod, msg_id,
+			"%s%s log: inconsistent msg id %u array msg id %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR],
+			msg_id, BFA_LOG_GET_MSG_ID(msg));
+		return -1;
+	}
+
+	log_level = log_mod ? log_mod->log_level[mod] : bfa_log_info[mod].level;
+	if ((BFA_LOG_GET_SEVERITY(msg) > log_level) &&
+			(msg->attributes != BFA_LOG_ATTR_NONE))
+		return 0;
+
+	va_start(ap, msg_id);
+	bfa_os_vsprintf(buf, BFA_LOG_GET_MSG_FMT_STRING(msg), ap);
+	va_end(ap);
+
+	if (log_mod)
+		log_mod->cbfn(log_mod, msg_id, "%s[%s]%s%s %s: %s\n",
+				BFA_LOG_CAT_NAME, log_mod->instance_info,
+				bfa_log_severity[BFA_LOG_GET_SEVERITY(msg)],
+				(msg->attributes & BFA_LOG_ATTR_AUDIT)
+				? " (audit) " : "", msg->msg_value, buf);
+	else
+		bfa_log_info[mod].cbfn(log_mod, msg_id, "%s%s%s %s: %s\n",
+				BFA_LOG_CAT_NAME,
+				bfa_log_severity[BFA_LOG_GET_SEVERITY(msg)],
+				(msg->attributes & BFA_LOG_ATTR_AUDIT) ?
+				" (audit) " : "", msg->msg_value, buf);
+
+	return 0;
+}
+
diff -urpN orig/drivers/scsi/bfa/bfa_log_module.c patch/drivers/scsi/bfa/bfa_log_module.c
--- orig/drivers/scsi/bfa/bfa_log_module.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_log_module.c	2009-09-23 15:59:19.000000000 -0700
@@ -0,0 +1,451 @@
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
+#include <cs/bfa_log.h>
+#include <aen/bfa_aen_adapter.h>
+#include <aen/bfa_aen_audit.h>
+#include <aen/bfa_aen_ethport.h>
+#include <aen/bfa_aen_ioc.h>
+#include <aen/bfa_aen_itnim.h>
+#include <aen/bfa_aen_lport.h>
+#include <aen/bfa_aen_port.h>
+#include <aen/bfa_aen_rport.h>
+#include <log/bfa_log_fcs.h>
+#include <log/bfa_log_hal.h>
+#include <log/bfa_log_linux.h>
+#include <log/bfa_log_wdrv.h>
+
+struct bfa_log_msgdef_s bfa_log_msg_array[] = {
+
+
+/* messages define for BFA_AEN_CAT_ADAPTER Module */
+{BFA_AEN_ADAPTER_ADD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ADAPTER_ADD",
+ "New adapter found: SN = %s, base port WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_ADAPTER_REMOVE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_ADAPTER_REMOVE",
+ "Adapter removed: SN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_AUDIT Module */
+{BFA_AEN_AUDIT_AUTH_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_AUDIT_AUTH_ENABLE",
+ "Authentication enabled for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_AUDIT_AUTH_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_AUDIT_AUTH_DISABLE",
+ "Authentication disabled for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_ETHPORT Module */
+{BFA_AEN_ETHPORT_LINKUP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_LINKUP",
+ "Base port ethernet linkup: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_ETHPORT_LINKDOWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_LINKDOWN",
+ "Base port ethernet linkdown: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_ETHPORT_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_ENABLE",
+ "Base port ethernet interface enabled: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_ETHPORT_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_DISABLE",
+ "Base port ethernet interface disabled: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_IOC Module */
+{BFA_AEN_IOC_HBGOOD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_IOC_HBGOOD",
+ "Heart Beat of IOC %d is good.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_HBFAIL, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_CRITICAL,
+ "BFA_AEN_IOC_HBFAIL",
+ "Heart Beat of IOC %d has failed.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_IOC_ENABLE",
+ "IOC %d is enabled.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_IOC_DISABLE",
+ "IOC %d is disabled.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_FWMISMATCH, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_CRITICAL, "BFA_AEN_IOC_FWMISMATCH",
+ "Running firmware version is incompatible with the driver version.",
+ (0), 0},
+
+
+
+
+/* messages define for BFA_AEN_CAT_ITNIM Module */
+{BFA_AEN_ITNIM_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ITNIM_ONLINE",
+ "Target (WWN = %s) is online for initiator (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_ITNIM_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ITNIM_OFFLINE",
+ "Target (WWN = %s) offlined by initiator (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_ITNIM_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_ITNIM_DISCONNECT",
+ "Target (WWN = %s) connectivity lost for initiator (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+
+
+
+/* messages define for BFA_AEN_CAT_LPORT Module */
+{BFA_AEN_LPORT_NEW, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_NEW",
+ "New logical port created: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DELETE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_DELETE",
+ "Logical port deleted: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_ONLINE",
+ "Logical port online: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_OFFLINE",
+ "Logical port taken offline: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_LPORT_DISCONNECT",
+ "Logical port lost fabric connectivity: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_NEW_PROP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_NEW_PROP",
+ "New virtual port created using proprietary interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DELETE_PROP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_LPORT_DELETE_PROP",
+ "Virtual port deleted using proprietary interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_NEW_STANDARD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_LPORT_NEW_STANDARD",
+ "New virtual port created using standard interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DELETE_STANDARD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_LPORT_DELETE_STANDARD",
+ "Virtual port deleted using standard interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_NPIV_DUP_WWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_LPORT_NPIV_DUP_WWN",
+ "Virtual port login failed. Duplicate WWN = %s reported by fabric.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_LPORT_NPIV_FABRIC_MAX, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_LPORT_NPIV_FABRIC_MAX",
+ "Virtual port (WWN = %s) login failed. Max NPIV ports already exist in"
+ " fabric/fport.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_LPORT_NPIV_UNKNOWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_LPORT_NPIV_UNKNOWN",
+ "Virtual port (WWN = %s) login failed.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_PORT Module */
+{BFA_AEN_PORT_ONLINE, BFA_LOG_ATTR_NONE, BFA_LOG_INFO, "BFA_AEN_PORT_ONLINE",
+ "Base port online: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_OFFLINE",
+ "Base port offline: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_RLIR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_RLIR",
+ "RLIR event not supported.",
+ (0), 0},
+
+{BFA_AEN_PORT_SFP_INSERT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_SFP_INSERT",
+ "New SFP found: WWN/MAC = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_SFP_REMOVE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_PORT_SFP_REMOVE",
+ "SFP removed: WWN/MAC = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_SFP_POM, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_SFP_POM",
+ "SFP POM level to %s: WWN/MAC = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_PORT_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_ENABLE",
+ "Base port enabled: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_DISABLE",
+ "Base port disabled: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_AUTH_ON, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_AUTH_ON",
+ "Authentication successful for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_AUTH_OFF, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "BFA_AEN_PORT_AUTH_OFF",
+ "Authentication unsuccessful for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "BFA_AEN_PORT_DISCONNECT",
+ "Base port (WWN = %s) lost fabric connectivity.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_QOS_NEG, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_QOS_NEG",
+ "QOS negotiation failed for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_FABRIC_NAME_CHANGE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_PORT_FABRIC_NAME_CHANGE",
+ "Base port WWN = %s, Fabric WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_PORT_SFP_ACCESS_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_PORT_SFP_ACCESS_ERROR",
+ "SFP access error: WWN/MAC = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_SFP_UNSUPPORT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_PORT_SFP_UNSUPPORT",
+ "Unsupported SFP found: WWN/MAC = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_RPORT Module */
+{BFA_AEN_RPORT_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_ONLINE",
+ "Remote port (WWN = %s) online for logical port (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_RPORT_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_OFFLINE",
+ "Remote port (WWN = %s) offlined by logical port (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_RPORT_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_RPORT_DISCONNECT",
+ "Remote port (WWN = %s) connectivity lost for logical port (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_RPORT_QOS_PRIO, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_QOS_PRIO",
+ "QOS priority changed to %s: RPWWN = %s and LPWWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_AEN_RPORT_QOS_FLOWID, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_QOS_FLOWID",
+ "QOS flow ID changed to %d: RPWWN = %s and LPWWN = %s.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for FCS Module */
+{BFA_LOG_FCS_FABRIC_NOSWITCH, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "FCS_FABRIC_NOSWITCH",
+ "No switched fabric presence is detected.",
+ (0), 0},
+
+{BFA_LOG_FCS_FABRIC_ISOLATED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "FCS_FABRIC_ISOLATED",
+ "Port is isolated due to VF_ID mismatch. PWWN: %s, Port VF_ID: %04x and"
+ " switch port VF_ID: %04x.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_X << BFA_LOG_ARG1) |
+  (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for HAL Module */
+{BFA_LOG_HAL_ASSERT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "HAL_ASSERT",
+ "Assertion failure: %s:%d: %s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_LOG_HAL_HEARTBEAT_FAILURE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_CRITICAL, "HAL_HEARTBEAT_FAILURE",
+ "Firmware heartbeat failure at %d",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_HAL_FCPIM_PARM_INVALID, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "HAL_FCPIM_PARM_INVALID",
+ "Driver configuration %s value %d is invalid. Value should be within"
+ " %d and %d.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_D << BFA_LOG_ARG2) | (BFA_LOG_D << BFA_LOG_ARG3) | 0), 4},
+
+{BFA_LOG_HAL_SM_ASSERT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "HAL_SM_ASSERT",
+ "SM Assertion failure: %s:%d: event = %d",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_D << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for LINUX Module */
+{BFA_LOG_LINUX_DEVICE_CLAIMED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DEVICE_CLAIMED",
+ "bfa device at %s claimed.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_HASH_INIT_FAILED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_HASH_INIT_FAILED",
+ "Hash table initialization failure for the port %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_SYSFS_FAILED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_SYSFS_FAILED",
+ "sysfs file creation failure for the port %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_MEM_ALLOC_FAILED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_MEM_ALLOC_FAILED",
+ "Memory allocation failed: %s.  ",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_REGISTRATION_FAILED,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_DRIVER_REGISTRATION_FAILED",
+ "%s.  ",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_ITNIM_FREE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_ITNIM_FREE",
+ "scsi%d: FCID: %s WWPN: %s",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_LOG_LINUX_ITNIM_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_ITNIM_ONLINE",
+ "Target: %d:0:%d FCID: %s WWPN: %s",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | (BFA_LOG_S << BFA_LOG_ARG3) | 0), 4},
+
+{BFA_LOG_LINUX_ITNIM_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_ITNIM_OFFLINE",
+ "Target: %d:0:%d FCID: %s WWPN: %s",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | (BFA_LOG_S << BFA_LOG_ARG3) | 0), 4},
+
+{BFA_LOG_LINUX_SCSI_HOST_FREE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_SCSI_HOST_FREE",
+ "Free scsi%d",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_SCSI_ABORT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_SCSI_ABORT",
+ "scsi%d: abort cmnd %p, iotag %x",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_P << BFA_LOG_ARG1) |
+  (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_LOG_LINUX_SCSI_ABORT_COMP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_SCSI_ABORT_COMP",
+ "scsi%d: complete abort 0x%p, iotag 0x%x",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_P << BFA_LOG_ARG1) |
+  (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for WDRV Module */
+{BFA_LOG_WDRV_IOC_INIT_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_INIT_ERROR",
+ "IOC initialization has failed.",
+ (0), 0},
+
+{BFA_LOG_WDRV_IOC_INTERNAL_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_INTERNAL_ERROR",
+ "IOC internal error.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_IOC_START_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_START_ERROR",
+ "IOC could not be started.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_IOC_STOP_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_STOP_ERROR",
+ "IOC could not be stopped.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_INSUFFICIENT_RESOURCES, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_INSUFFICIENT_RESOURCES",
+ "Insufficient memory.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_BASE_ADDRESS_MAP_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_BASE_ADDRESS_MAP_ERROR",
+ "Unable to map the IOC onto the system address space.  ",
+ (0), 0},
+
+
+{0, 0, 0, "", "", 0, 0},
+};
diff -urpN orig/drivers/scsi/bfa/bfa_lps.c patch/drivers/scsi/bfa/bfa_lps.c
--- orig/drivers/scsi/bfa/bfa_lps.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_lps.c	2009-09-23 15:59:19.000000000 -0700
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
+#include <bfi/bfi_lps.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, LPS);
+BFA_MODULE(lps);
+
+#define BFA_LPS_MIN_LPORTS	(1)
+#define BFA_LPS_MAX_LPORTS	(256)
+
+/**
+ * forward declarations
+ */
+static void bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+			    u32 *dm_len);
+static void bfa_lps_attach(struct bfa_s *bfa, void *bfad,
+			   struct bfa_iocfc_cfg_s *cfg,
+			   struct bfa_meminfo_s *meminfo,
+			   struct bfa_pcidev_s *pcidev);
+static void bfa_lps_initdone(struct bfa_s *bfa);
+static void bfa_lps_detach(struct bfa_s *bfa);
+static void bfa_lps_start(struct bfa_s *bfa);
+static void bfa_lps_stop(struct bfa_s *bfa);
+static void bfa_lps_iocdisable(struct bfa_s *bfa);
+static void bfa_lps_login_rsp(struct bfa_s *bfa,
+			      struct bfi_lps_login_rsp_s *rsp);
+static void bfa_lps_logout_rsp(struct bfa_s *bfa,
+			       struct bfi_lps_logout_rsp_s *rsp);
+static void bfa_lps_reqq_resume(void *lps_arg);
+static void bfa_lps_free(struct bfa_lps_s *lps);
+static void bfa_lps_send_login(struct bfa_lps_s *lps);
+static void bfa_lps_send_logout(struct bfa_lps_s *lps);
+static void bfa_lps_login_comp(struct bfa_lps_s *lps);
+static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
+
+
+/**
+ *  lps_pvt BFA LPS private functions
+ */
+
+enum bfa_lps_event {
+	BFA_LPS_SM_LOGIN	= 1,	/* login request from user	*/
+	BFA_LPS_SM_LOGOUT	= 2,	/* logout request from user	*/
+	BFA_LPS_SM_FWRSP	= 3,	/* f/w response to login/logout	*/
+	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue	*/
+	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user		*/
+	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline		*/
+};
+
+static void bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_loginwait(struct bfa_lps_s *lps,
+			enum bfa_lps_event event);
+static void bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_logowait(struct bfa_lps_s *lps,
+			enum bfa_lps_event event);
+
+/**
+ * Init state -- no login
+ */
+static void
+bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_LOGIN:
+		if (bfa_reqq_full(lps->bfa, lps->reqq)) {
+			bfa_sm_set_state(lps, bfa_lps_sm_loginwait);
+			bfa_reqq_wait(lps->bfa, lps->reqq, &lps->wqe);
+		} else {
+			bfa_sm_set_state(lps, bfa_lps_sm_login);
+			bfa_lps_send_login(lps);
+		}
+		break;
+
+	case BFA_LPS_SM_LOGOUT:
+		bfa_lps_logout_comp(lps);
+		break;
+
+	case BFA_LPS_SM_DELETE:
+		bfa_lps_free(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		break;
+
+	case BFA_LPS_SM_FWRSP:
+		/* Could happen when fabric detects loopback and discards
+		 * the lps request. Fw will eventually sent out the timeout
+		 * Just ignore
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * login is in progress -- awaiting response from firmware
+ */
+static void
+bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_FWRSP:
+		if (lps->status == BFA_STATUS_OK)
+			bfa_sm_set_state(lps, bfa_lps_sm_online);
+		else
+			bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_lps_login_comp(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * login pending - awaiting space in request queue
+ */
+static void
+bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_RESUME:
+		bfa_sm_set_state(lps, bfa_lps_sm_login);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_reqq_wcancel(&lps->wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * login complete
+ */
+static void
+bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_LOGOUT:
+		if (bfa_reqq_full(lps->bfa, lps->reqq)) {
+			bfa_sm_set_state(lps, bfa_lps_sm_logowait);
+			bfa_reqq_wait(lps->bfa, lps->reqq, &lps->wqe);
+		} else {
+			bfa_sm_set_state(lps, bfa_lps_sm_logout);
+			bfa_lps_send_logout(lps);
+		}
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+	case BFA_LPS_SM_DELETE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * logout in progress - awaiting firmware response
+ */
+static void
+bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_FWRSP:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_lps_logout_comp(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * logout pending -- awaiting space in request queue
+ */
+static void
+bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_RESUME:
+		bfa_sm_set_state(lps, bfa_lps_sm_logout);
+		bfa_lps_send_logout(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_reqq_wcancel(&lps->wqe);
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
+ *  lps_pvt BFA LPS private functions
+ */
+
+/**
+ * return memory requirement
+ */
+static void
+bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len, u32 *dm_len)
+{
+	if (cfg->drvcfg.min_cfg)
+		*ndm_len += sizeof(struct bfa_lps_s) * BFA_LPS_MIN_LPORTS;
+	else
+		*ndm_len += sizeof(struct bfa_lps_s) * BFA_LPS_MAX_LPORTS;
+}
+
+/**
+ * bfa module attach at initialization time
+ */
+static void
+bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+	int			i;
+
+	bfa_os_memset(mod, 0, sizeof(struct bfa_lps_mod_s));
+	mod->num_lps = BFA_LPS_MAX_LPORTS;
+	if (cfg->drvcfg.min_cfg)
+		mod->num_lps = BFA_LPS_MIN_LPORTS;
+	else
+		mod->num_lps = BFA_LPS_MAX_LPORTS;
+	mod->lps_arr = lps = (struct bfa_lps_s *) bfa_meminfo_kva(meminfo);
+
+	bfa_meminfo_kva(meminfo) += mod->num_lps * sizeof(struct bfa_lps_s);
+
+	INIT_LIST_HEAD(&mod->lps_free_q);
+	INIT_LIST_HEAD(&mod->lps_active_q);
+
+	for (i = 0; i < mod->num_lps; i++, lps++) {
+		lps->bfa	= bfa;
+		lps->lp_tag	= (u8) i;
+		lps->reqq	= BFA_REQQ_LPS;
+		bfa_reqq_winit(&lps->wqe, bfa_lps_reqq_resume, lps);
+		list_add_tail(&lps->qe, &mod->lps_free_q);
+	}
+}
+
+static void
+bfa_lps_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lps_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lps_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lps_stop(struct bfa_s *bfa)
+{
+}
+
+/**
+ * IOC in disabled state -- consider all lps offline
+ */
+static void
+bfa_lps_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+	struct list_head		*qe, *qen;
+
+	list_for_each_safe(qe, qen, &mod->lps_active_q) {
+		lps = (struct bfa_lps_s *) qe;
+		bfa_sm_send_event(lps, BFA_LPS_SM_OFFLINE);
+	}
+}
+
+/**
+ * Firmware login response
+ */
+static void
+bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+
+	bfa_assert(rsp->lp_tag < mod->num_lps);
+	lps = BFA_LPS_FROM_TAG(mod, rsp->lp_tag);
+
+	lps->status = rsp->status;
+	switch (rsp->status) {
+	case BFA_STATUS_OK:
+		lps->fport	= rsp->f_port;
+		lps->npiv_en	= rsp->npiv_en;
+		lps->lp_pid	= rsp->lp_pid;
+		lps->pr_bbcred	= bfa_os_ntohs(rsp->bb_credit);
+		lps->pr_pwwn	= rsp->port_name;
+		lps->pr_nwwn	= rsp->node_name;
+		lps->auth_req	= rsp->auth_req;
+		lps->lp_mac	= rsp->lp_mac;
+		lps->brcd_switch = rsp->brcd_switch;
+		lps->fcf_mac	= rsp->fcf_mac;
+
+		break;
+
+	case BFA_STATUS_FABRIC_RJT:
+		lps->lsrjt_rsn = rsp->lsrjt_rsn;
+		lps->lsrjt_expl = rsp->lsrjt_expl;
+
+		break;
+
+	case BFA_STATUS_EPROTOCOL:
+		lps->ext_status = rsp->ext_status;
+
+		break;
+
+	default:
+		/* Nothing to do with other status */
+		break;
+	}
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
+}
+
+/**
+ * Firmware logout response
+ */
+static void
+bfa_lps_logout_rsp(struct bfa_s *bfa, struct bfi_lps_logout_rsp_s *rsp)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+
+	bfa_assert(rsp->lp_tag < mod->num_lps);
+	lps = BFA_LPS_FROM_TAG(mod, rsp->lp_tag);
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
+}
+
+/**
+ * Space is available in request queue, resume queueing request to firmware.
+ */
+static void
+bfa_lps_reqq_resume(void *lps_arg)
+{
+	struct bfa_lps_s	*lps = lps_arg;
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_RESUME);
+}
+
+/**
+ * lps is freed -- triggered by vport delete
+ */
+static void
+bfa_lps_free(struct bfa_lps_s *lps)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(lps->bfa);
+
+	list_del(&lps->qe);
+	list_add_tail(&lps->qe, &mod->lps_free_q);
+}
+
+/**
+ * send login request to firmware
+ */
+static void
+bfa_lps_send_login(struct bfa_lps_s *lps)
+{
+	struct bfi_lps_login_req_s	*m;
+
+	m = bfa_reqq_next(lps->bfa, lps->reqq);
+	bfa_assert(m);
+
+	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGIN_REQ,
+			bfa_lpuid(lps->bfa));
+
+	m->lp_tag	= lps->lp_tag;
+	m->alpa		= lps->alpa;
+	m->pdu_size	= bfa_os_htons(lps->pdusz);
+	m->pwwn		= lps->pwwn;
+	m->nwwn		= lps->nwwn;
+	m->fdisc	= lps->fdisc;
+	m->auth_en	= lps->auth_en;
+
+	bfa_reqq_produce(lps->bfa, lps->reqq);
+}
+
+/**
+ * send logout request to firmware
+ */
+static void
+bfa_lps_send_logout(struct bfa_lps_s *lps)
+{
+	struct bfi_lps_logout_req_s *m;
+
+	m = bfa_reqq_next(lps->bfa, lps->reqq);
+	bfa_assert(m);
+
+	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGOUT_REQ,
+			bfa_lpuid(lps->bfa));
+
+	m->lp_tag    = lps->lp_tag;
+	m->port_name = lps->pwwn;
+	bfa_reqq_produce(lps->bfa, lps->reqq);
+}
+
+/**
+ * Indirect login completion handler for non-fcs
+ */
+static void
+bfa_lps_login_comp_cb(void *arg, bfa_boolean_t complete)
+{
+	struct bfa_lps_s *lps	= arg;
+
+	if (!complete)
+		return;
+
+	if (lps->fdisc)
+		bfa_cb_lps_fdisc_comp(lps->bfa->bfad, lps->uarg, lps->status);
+	else
+		bfa_cb_lps_flogi_comp(lps->bfa->bfad, lps->uarg, lps->status);
+}
+
+/**
+ * Login completion handler -- direct call for fcs, queue for others
+ */
+static void
+bfa_lps_login_comp(struct bfa_lps_s *lps)
+{
+	if (!lps->bfa->fcs) {
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe,
+				bfa_lps_login_comp_cb, lps);
+		return;
+	}
+
+	if (lps->fdisc)
+		bfa_cb_lps_fdisc_comp(lps->bfa->bfad, lps->uarg, lps->status);
+	else
+		bfa_cb_lps_flogi_comp(lps->bfa->bfad, lps->uarg, lps->status);
+}
+
+/**
+ * Indirect logout completion handler for non-fcs
+ */
+static void
+bfa_lps_logout_comp_cb(void *arg, bfa_boolean_t complete)
+{
+	struct bfa_lps_s *lps	= arg;
+
+	if (!complete)
+		return;
+
+	if (lps->fdisc)
+		bfa_cb_lps_fdisclogo_comp(lps->bfa->bfad, lps->uarg);
+	else
+		bfa_cb_lps_flogo_comp(lps->bfa->bfad, lps->uarg);
+}
+
+/**
+ * Logout completion handler -- direct call for fcs, queue for others
+ */
+static void
+bfa_lps_logout_comp(struct bfa_lps_s *lps)
+{
+	if (!lps->bfa->fcs) {
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe,
+				bfa_lps_logout_comp_cb, lps);
+		return;
+	}
+	if (lps->fdisc)
+		bfa_cb_lps_fdisclogo_comp(lps->bfa->bfad, lps->uarg);
+	else
+		bfa_cb_lps_flogo_comp(lps->bfa->bfad, lps->uarg);
+}
+
+
+
+/**
+ *  lps_public BFA LPS public functions
+ */
+
+/**
+ * Allocate a lport srvice tag.
+ */
+struct bfa_lps_s  *
+bfa_lps_alloc(struct bfa_s *bfa)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps = NULL;
+
+	bfa_q_deq(&mod->lps_free_q, &lps);
+
+	if (lps == NULL)
+		return NULL;
+
+	list_add_tail(&lps->qe, &mod->lps_active_q);
+
+	bfa_sm_set_state(lps, bfa_lps_sm_init);
+	return lps;
+}
+
+/**
+ * Free lport service tag. This can be called anytime after an alloc.
+ * No need to wait for any pending login/logout completions.
+ */
+void
+bfa_lps_delete(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_DELETE);
+}
+
+/**
+ * Initiate a lport login.
+ */
+void
+bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa, u16 pdusz,
+	wwn_t pwwn, wwn_t nwwn, bfa_boolean_t auth_en)
+{
+	lps->uarg	= uarg;
+	lps->alpa	= alpa;
+	lps->pdusz	= pdusz;
+	lps->pwwn	= pwwn;
+	lps->nwwn	= nwwn;
+	lps->fdisc	= BFA_FALSE;
+	lps->auth_en	= auth_en;
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
+}
+
+/**
+ * Initiate a lport fdisc login.
+ */
+void
+bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
+	wwn_t nwwn)
+{
+	lps->uarg	= uarg;
+	lps->alpa	= 0;
+	lps->pdusz	= pdusz;
+	lps->pwwn	= pwwn;
+	lps->nwwn	= nwwn;
+	lps->fdisc	= BFA_TRUE;
+	lps->auth_en	= BFA_FALSE;
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
+}
+
+/**
+ * Initiate a lport logout (flogi).
+ */
+void
+bfa_lps_flogo(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
+}
+
+/**
+ * Initiate a lport FDSIC logout.
+ */
+void
+bfa_lps_fdisclogo(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
+}
+
+/**
+ * Discard a pending login request -- should be called only for
+ * link down handling.
+ */
+void
+bfa_lps_discard(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_OFFLINE);
+}
+
+/**
+ * Return lport services tag
+ */
+u8
+bfa_lps_get_tag(struct bfa_lps_s *lps)
+{
+	return lps->lp_tag;
+}
+
+/**
+ * Return lport services tag given the pid
+ */
+u8
+bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+	int			i;
+
+	for (i = 0, lps = mod->lps_arr; i < mod->num_lps; i++, lps++) {
+		if (lps->lp_pid == pid)
+			return lps->lp_tag;
+	}
+
+	/* Return base port tag anyway */
+	return 0;
+}
+
+/**
+ * return if fabric login indicates support for NPIV
+ */
+bfa_boolean_t
+bfa_lps_is_npiv_en(struct bfa_lps_s *lps)
+{
+	return lps->npiv_en;
+}
+
+/**
+ * Return TRUE if attached to F-Port, else return FALSE
+ */
+bfa_boolean_t
+bfa_lps_is_fport(struct bfa_lps_s *lps)
+{
+	return lps->fport;
+}
+
+/**
+ * Return TRUE if attached to a Brocade Fabric
+ */
+bfa_boolean_t
+bfa_lps_is_brcd_fabric(struct bfa_lps_s *lps)
+{
+	return lps->brcd_switch;
+}
+/**
+ * return TRUE if authentication is required
+ */
+bfa_boolean_t
+bfa_lps_is_authreq(struct bfa_lps_s *lps)
+{
+	return lps->auth_req;
+}
+
+bfa_eproto_status_t
+bfa_lps_get_extstatus(struct bfa_lps_s *lps)
+{
+	return lps->ext_status;
+}
+
+/**
+ * return port id assigned to the lport
+ */
+u32
+bfa_lps_get_pid(struct bfa_lps_s *lps)
+{
+	return lps->lp_pid;
+}
+
+/**
+ * Return bb_credit assigned in FLOGI response
+ */
+u16
+bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps)
+{
+	return lps->pr_bbcred;
+}
+
+/**
+ * Return peer port name
+ */
+wwn_t
+bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps)
+{
+	return lps->pr_pwwn;
+}
+
+/**
+ * Return peer node name
+ */
+wwn_t
+bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps)
+{
+	return lps->pr_nwwn;
+}
+
+/**
+ * return reason code if login request is rejected
+ */
+u8
+bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps)
+{
+	return lps->lsrjt_rsn;
+}
+
+/**
+ * return explanation code if login request is rejected
+ */
+u8
+bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps)
+{
+	return lps->lsrjt_expl;
+}
+
+
+/**
+ * LPS firmware message class handler.
+ */
+void
+bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	union bfi_lps_i2h_msg_u	msg;
+
+	bfa_trc(bfa, m->mhdr.msg_id);
+	msg.msg = m;
+
+	switch (m->mhdr.msg_id) {
+	case BFI_LPS_H2I_LOGIN_RSP:
+		bfa_lps_login_rsp(bfa, msg.login_rsp);
+		break;
+
+	case BFI_LPS_H2I_LOGOUT_RSP:
+		bfa_lps_logout_rsp(bfa, msg.logout_rsp);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
