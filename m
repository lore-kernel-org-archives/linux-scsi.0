From: <kgudipat@brocade.com>
Subject: [PATCH 11/33] bfa: (Cleanup Patch) BFA header file consolidation / cleanup.
Date: Wed, 15 Sep 2010 12:02:41 -0700
Message-ID: <1284577361-17138-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34186 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab0IOTFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:05:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- This patch is part of the BFA cleanup.
	- bfa_fwimg_priv.h code will be removed.
	- bfa_callback_priv.h & others will be merged to bfa.h in the patchset.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_callback_priv.h |   57 -----------
 drivers/scsi/bfa/bfa_fwimg_priv.h    |   44 --------
 drivers/scsi/bfa/bfa_intr_priv.h     |  117 ---------------------
 drivers/scsi/bfa/bfa_iocfc.h         |  184 ----------------------------------
 drivers/scsi/bfa/bfa_trcmod_priv.h   |   64 ------------
 5 files changed, 0 insertions(+), 466 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfa_callback_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_fwimg_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_intr_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_iocfc.h
 delete mode 100644 drivers/scsi/bfa/bfa_trcmod_priv.h

diff --git a/drivers/scsi/bfa/bfa_callback_priv.h b/drivers/scsi/bfa/bfa_callback_priv.h
deleted file mode 100644
index 1e3265c..0000000
--- a/drivers/scsi/bfa/bfa_callback_priv.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_CALLBACK_PRIV_H__
-#define __BFA_CALLBACK_PRIV_H__
-
-#include <cs/bfa_q.h>
-
-typedef void    (*bfa_cb_cbfn_t) (void *cbarg, bfa_boolean_t complete);
-
-/**
- * Generic BFA callback element.
- */
-struct bfa_cb_qe_s {
-	struct list_head         qe;
-	bfa_cb_cbfn_t  cbfn;
-	bfa_boolean_t   once;
-	u32		rsvd;
-	void           *cbarg;
-};
-
-#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {		\
-	(__hcb_qe)->cbfn  = (__cbfn);      \
-	(__hcb_qe)->cbarg = (__cbarg);      \
-	list_add_tail(&(__hcb_qe)->qe, &(__bfa)->comp_q);      \
-} while (0)
-
-#define bfa_cb_dequeue(__hcb_qe)	list_del(&(__hcb_qe)->qe)
-
-#define bfa_cb_queue_once(__bfa, __hcb_qe, __cbfn, __cbarg) do {	\
-	(__hcb_qe)->cbfn  = (__cbfn);      \
-	(__hcb_qe)->cbarg = (__cbarg);      \
-	if (!(__hcb_qe)->once) {      \
-		list_add_tail((__hcb_qe), &(__bfa)->comp_q);      \
-		(__hcb_qe)->once = BFA_TRUE;				\
-	}								\
-} while (0)
-
-#define bfa_cb_queue_done(__hcb_qe) do {				\
-	(__hcb_qe)->once = BFA_FALSE;					\
-} while (0)
-
-#endif /* __BFA_CALLBACK_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_fwimg_priv.h b/drivers/scsi/bfa/bfa_fwimg_priv.h
deleted file mode 100644
index d33e19e..0000000
--- a/drivers/scsi/bfa/bfa_fwimg_priv.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_FWIMG_PRIV_H__
-#define __BFA_FWIMG_PRIV_H__
-
-#define	BFI_FLASH_CHUNK_SZ		256	/*  Flash chunk size */
-#define	BFI_FLASH_CHUNK_SZ_WORDS	(BFI_FLASH_CHUNK_SZ/sizeof(u32))
-
-/**
- * BFI FW image type
- */
-enum {
-	BFI_IMAGE_CB_FC,
-	BFI_IMAGE_CT_FC,
-	BFI_IMAGE_CT_CNA,
-	BFI_IMAGE_MAX,
-};
-
-extern u32 *bfi_image_get_chunk(int type, uint32_t off);
-extern u32 bfi_image_get_size(int type);
-extern u32 bfi_image_ct_fc_size;
-extern u32 bfi_image_ct_cna_size;
-extern u32 bfi_image_cb_fc_size;
-extern u32 *bfi_image_ct_fc;
-extern u32 *bfi_image_ct_cna;
-extern u32 *bfi_image_cb_fc;
-
-
-#endif /* __BFA_FWIMG_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_intr_priv.h b/drivers/scsi/bfa/bfa_intr_priv.h
deleted file mode 100644
index 5fc301c..0000000
--- a/drivers/scsi/bfa/bfa_intr_priv.h
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_INTR_PRIV_H__
-#define __BFA_INTR_PRIV_H__
-
-/**
- * Message handler
- */
-typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
-void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
-void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
-
-
-#define bfa_reqq_pi(__bfa, __reqq)	((__bfa)->iocfc.req_cq_pi[__reqq])
-#define bfa_reqq_ci(__bfa, __reqq)					\
-	(*(u32 *)((__bfa)->iocfc.req_cq_shadow_ci[__reqq].kva))
-
-#define bfa_reqq_full(__bfa, __reqq)				\
-	(((bfa_reqq_pi(__bfa, __reqq) + 1) &			\
-	  ((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1)) ==	\
-	 bfa_reqq_ci(__bfa, __reqq))
-
-#define bfa_reqq_next(__bfa, __reqq)				\
-	(bfa_reqq_full(__bfa, __reqq) ? NULL :			\
-	 ((void *)((struct bfi_msg_s *)((__bfa)->iocfc.req_cq_ba[__reqq].kva) \
-			  + bfa_reqq_pi((__bfa), (__reqq)))))
-
-#define bfa_reqq_produce(__bfa, __reqq)	do {				\
-	(__bfa)->iocfc.req_cq_pi[__reqq]++;				\
-	(__bfa)->iocfc.req_cq_pi[__reqq] &=				\
-		((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1);      \
-	bfa_reg_write((__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq],		\
-				(__bfa)->iocfc.req_cq_pi[__reqq]);      \
-	bfa_os_mmiowb();      \
-} while (0)
-
-#define bfa_rspq_pi(__bfa, __rspq)					\
-	(*(u32 *)((__bfa)->iocfc.rsp_cq_shadow_pi[__rspq].kva))
-
-#define bfa_rspq_ci(__bfa, __rspq)	((__bfa)->iocfc.rsp_cq_ci[__rspq])
-#define bfa_rspq_elem(__bfa, __rspq, __ci)				\
-	(&((struct bfi_msg_s *)((__bfa)->iocfc.rsp_cq_ba[__rspq].kva))[__ci])
-
-#define CQ_INCR(__index, __size) do {					\
-			(__index)++;					\
-			(__index) &= ((__size) - 1);      \
-} while (0)
-
-/**
- * Queue element to wait for room in request queue. FIFO order is
- * maintained when fullfilling requests.
- */
-struct bfa_reqq_wait_s {
-	struct list_head 	qe;
-	void		(*qresume) (void *cbarg);
-	void		*cbarg;
-};
-
-/**
- * Circular queue usage assignments
- */
-enum {
-	BFA_REQQ_IOC	= 0,	/*  all low-priority IOC msgs	*/
-	BFA_REQQ_FCXP	= 0,	/*  all FCXP messages		*/
-	BFA_REQQ_LPS	= 0,	/*  all lport service msgs	*/
-	BFA_REQQ_PORT	= 0,	/*  all port messages		*/
-	BFA_REQQ_FLASH	= 0,	/*  for flash module		*/
-	BFA_REQQ_DIAG	= 0,	/*  for diag module		*/
-	BFA_REQQ_RPORT	= 0,	/*  all port messages		*/
-	BFA_REQQ_SBOOT	= 0,	/*  all san boot messages	*/
-	BFA_REQQ_QOS_LO	= 1,	/*  all low priority IO	*/
-	BFA_REQQ_QOS_MD	= 2,	/*  all medium priority IO	*/
-	BFA_REQQ_QOS_HI	= 3,	/*  all high priority IO	*/
-};
-
-static inline void
-bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
-			void *cbarg)
-{
-	wqe->qresume = qresume;
-	wqe->cbarg = cbarg;
-}
-
-#define bfa_reqq(__bfa, __reqq)	(&(__bfa)->reqq_waitq[__reqq])
-
-/**
- * static inline void
- * bfa_reqq_wait(struct bfa_s *bfa, int reqq, struct bfa_reqq_wait_s *wqe)
- */
-#define bfa_reqq_wait(__bfa, __reqq, __wqe) do {			\
-									\
-		struct list_head *waitq = bfa_reqq(__bfa, __reqq);      \
-									\
-		bfa_assert(((__reqq) < BFI_IOC_MAX_CQS));      \
-		bfa_assert((__wqe)->qresume && (__wqe)->cbarg);      \
-									\
-		list_add_tail(&(__wqe)->qe, waitq);      \
-} while (0)
-
-#define bfa_reqq_wcancel(__wqe)	list_del(&(__wqe)->qe)
-
-#endif /* __BFA_INTR_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
deleted file mode 100644
index 74a6a04..0000000
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_IOCFC_H__
-#define __BFA_IOCFC_H__
-
-#include <bfa_ioc.h>
-#include <bfa.h>
-#include <bfi/bfi_iocfc.h>
-#include <bfi/bfi_pbc.h>
-#include <bfa_callback_priv.h>
-
-#define BFA_REQQ_NELEMS_MIN	(4)
-#define BFA_RSPQ_NELEMS_MIN	(4)
-
-struct bfa_iocfc_regs_s {
-	bfa_os_addr_t   intr_status;
-	bfa_os_addr_t   intr_mask;
-	bfa_os_addr_t   cpe_q_pi[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   cpe_q_ci[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   cpe_q_depth[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   cpe_q_ctrl[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_ci[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_pi[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_depth[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_ctrl[BFI_IOC_MAX_CQS];
-};
-
-/**
- * MSIX vector handlers
- */
-#define BFA_MSIX_MAX_VECTORS	22
-typedef void (*bfa_msix_handler_t)(struct bfa_s *bfa, int vec);
-struct bfa_msix_s {
-	int	nvecs;
-	bfa_msix_handler_t handler[BFA_MSIX_MAX_VECTORS];
-};
-
-/**
- * Chip specific interfaces
- */
-struct bfa_hwif_s {
-	void (*hw_reginit)(struct bfa_s *bfa);
-	void (*hw_reqq_ack)(struct bfa_s *bfa, int reqq);
-	void (*hw_rspq_ack)(struct bfa_s *bfa, int rspq);
-	void (*hw_msix_init)(struct bfa_s *bfa, int nvecs);
-	void (*hw_msix_install)(struct bfa_s *bfa);
-	void (*hw_msix_uninstall)(struct bfa_s *bfa);
-	void (*hw_isr_mode_set)(struct bfa_s *bfa, bfa_boolean_t msix);
-	void (*hw_msix_getvecs)(struct bfa_s *bfa, u32 *vecmap,
-			u32 *nvecs, u32 *maxvec);
-	void (*hw_msix_get_rme_range) (struct bfa_s *bfa, u32 *start,
-			u32 *end);
-};
-typedef void (*bfa_cb_iocfc_t) (void *cbarg, enum bfa_status status);
-
-struct bfa_iocfc_s {
-	struct bfa_s 		*bfa;
-	struct bfa_iocfc_cfg_s 	cfg;
-	int			action;
-
-	u32        	req_cq_pi[BFI_IOC_MAX_CQS];
-	u32        	rsp_cq_ci[BFI_IOC_MAX_CQS];
-
-	struct bfa_cb_qe_s	init_hcb_qe;
-	struct bfa_cb_qe_s	stop_hcb_qe;
-	struct bfa_cb_qe_s	dis_hcb_qe;
-	struct bfa_cb_qe_s	stats_hcb_qe;
-	bfa_boolean_t		cfgdone;
-
-	struct bfa_dma_s	cfg_info;
-	struct bfi_iocfc_cfg_s *cfginfo;
-	struct bfa_dma_s	cfgrsp_dma;
-	struct bfi_iocfc_cfgrsp_s *cfgrsp;
-	struct bfi_iocfc_cfg_reply_s *cfg_reply;
-
-	u8			*stats_kva;
-	u64		stats_pa;
-	struct bfa_fw_stats_s 	*fw_stats;
-	struct bfa_timer_s 	stats_timer;	/*  timer */
-	struct bfa_iocfc_stats_s *stats_ret;	/*  driver stats location */
-	bfa_status_t		stats_status;	/*  stats/statsclr status */
-	bfa_boolean_t   	stats_busy;	/*  outstanding stats */
-	bfa_cb_ioc_t		stats_cbfn;	/*  driver callback function */
-	void           		*stats_cbarg;	/*  user callback arg */
-
-	struct bfa_dma_s   	req_cq_ba[BFI_IOC_MAX_CQS];
-	struct bfa_dma_s   	req_cq_shadow_ci[BFI_IOC_MAX_CQS];
-	struct bfa_dma_s   	rsp_cq_ba[BFI_IOC_MAX_CQS];
-	struct bfa_dma_s   	rsp_cq_shadow_pi[BFI_IOC_MAX_CQS];
-	struct bfa_iocfc_regs_s	bfa_regs;	/*  BFA device registers */
-	struct bfa_hwif_s	hwif;
-
-	bfa_cb_iocfc_t		updateq_cbfn; /*  bios callback function */
-	void			*updateq_cbarg;	/*  bios callback arg */
-	u32			intr_mask;
-};
-
-#define bfa_lpuid(__bfa)		bfa_ioc_portid(&(__bfa)->ioc)
-#define bfa_msix_init(__bfa, __nvecs)	\
-	((__bfa)->iocfc.hwif.hw_msix_init(__bfa, __nvecs))
-#define bfa_msix_install(__bfa)	\
-	((__bfa)->iocfc.hwif.hw_msix_install(__bfa))
-#define bfa_msix_uninstall(__bfa)	\
-	((__bfa)->iocfc.hwif.hw_msix_uninstall(__bfa))
-#define bfa_isr_mode_set(__bfa, __msix)	\
-	((__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix))
-#define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)	\
-	((__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap,	\
-		 __nvecs, __maxvec))
-#define bfa_msix_get_rme_range(__bfa, __start, __end)   \
-	((__bfa)->iocfc.hwif.hw_msix_get_rme_range(__bfa, __start, __end))
-
-/*
- * FC specific IOC functions.
- */
-void bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
-		u32 *dm_len);
-void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
-		struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
-		struct bfa_pcidev_s *pcidev);
-void bfa_iocfc_detach(struct bfa_s *bfa);
-void bfa_iocfc_init(struct bfa_s *bfa);
-void bfa_iocfc_start(struct bfa_s *bfa);
-void bfa_iocfc_stop(struct bfa_s *bfa);
-void bfa_iocfc_isr(void *bfa, struct bfi_mbmsg_s *msg);
-void bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa);
-bfa_boolean_t bfa_iocfc_is_operational(struct bfa_s *bfa);
-void bfa_iocfc_reset_queues(struct bfa_s *bfa);
-void bfa_iocfc_updateq(struct bfa_s *bfa, u32 reqq_ba, u32 rspq_ba,
-			u32 reqq_sci, u32 rspq_spi,
-			bfa_cb_iocfc_t cbfn, void *cbarg);
-
-void bfa_msix_all(struct bfa_s *bfa, int vec);
-void bfa_msix_reqq(struct bfa_s *bfa, int vec);
-void bfa_msix_rspq(struct bfa_s *bfa, int vec);
-void bfa_msix_lpu_err(struct bfa_s *bfa, int vec);
-
-void bfa_hwcb_reginit(struct bfa_s *bfa);
-void bfa_hwcb_reqq_ack(struct bfa_s *bfa, int rspq);
-void bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq);
-void bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs);
-void bfa_hwcb_msix_install(struct bfa_s *bfa);
-void bfa_hwcb_msix_uninstall(struct bfa_s *bfa);
-void bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
-void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
-			u32 *nvecs, u32 *maxvec);
-void bfa_hwcb_msix_get_rme_range(struct bfa_s *bfa, u32 *start, u32 *end);
-void bfa_hwct_reginit(struct bfa_s *bfa);
-void bfa_hwct_reqq_ack(struct bfa_s *bfa, int rspq);
-void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
-void bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs);
-void bfa_hwct_msix_install(struct bfa_s *bfa);
-void bfa_hwct_msix_uninstall(struct bfa_s *bfa);
-void bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
-void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
-			u32 *nvecs, u32 *maxvec);
-void bfa_hwct_msix_get_rme_range(struct bfa_s *bfa, u32 *start, u32 *end);
-
-void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
-void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
-		bfa_boolean_t mincfg);
-void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns);
-void bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa,
-		struct bfa_boot_pbc_s *pbcfg);
-int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
-		struct bfi_pbc_vport_s *pbc_vport);
-
-#endif /* __BFA_IOCFC_H__ */
-
diff --git a/drivers/scsi/bfa/bfa_trcmod_priv.h b/drivers/scsi/bfa/bfa_trcmod_priv.h
deleted file mode 100644
index a7a8261..0000000
--- a/drivers/scsi/bfa/bfa_trcmod_priv.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-/**
- *  hal_trcmod.h BFA trace modules
- */
-
-#ifndef __BFA_TRCMOD_PRIV_H__
-#define __BFA_TRCMOD_PRIV_H__
-
-#include <cs/bfa_trc.h>
-
-/*
- * !!! Only append to the enums defined here to avoid any versioning
- * !!! needed between trace utility and driver version
- */
-enum {
-	BFA_TRC_HAL_INTR	= 1,
-	BFA_TRC_HAL_FCXP	= 2,
-	BFA_TRC_HAL_UF		= 3,
-	BFA_TRC_HAL_RPORT	= 4,
-	BFA_TRC_HAL_FCPIM	= 5,
-	BFA_TRC_HAL_IOIM	= 6,
-	BFA_TRC_HAL_TSKIM	= 7,
-	BFA_TRC_HAL_ITNIM	= 8,
-	BFA_TRC_HAL_FCPORT	= 9,
-	BFA_TRC_HAL_SGPG	= 10,
-	BFA_TRC_HAL_FLASH	= 11,
-	BFA_TRC_HAL_DEBUG	= 12,
-	BFA_TRC_HAL_WWN		= 13,
-	BFA_TRC_HAL_FLASH_RAW	= 14,
-	BFA_TRC_HAL_SBOOT	= 15,
-	BFA_TRC_HAL_SBOOT_IO	= 16,
-	BFA_TRC_HAL_SBOOT_INTR	= 17,
-	BFA_TRC_HAL_SBTEST	= 18,
-	BFA_TRC_HAL_IPFC	= 19,
-	BFA_TRC_HAL_IOCFC	= 20,
-	BFA_TRC_HAL_FCPTM	= 21,
-	BFA_TRC_HAL_IOTM	= 22,
-	BFA_TRC_HAL_TSKTM	= 23,
-	BFA_TRC_HAL_TIN		= 24,
-	BFA_TRC_HAL_LPS		= 25,
-	BFA_TRC_HAL_FCDIAG	= 26,
-	BFA_TRC_HAL_PBIND	= 27,
-	BFA_TRC_HAL_IOCFC_CT	= 28,
-	BFA_TRC_HAL_IOCFC_CB	= 29,
-	BFA_TRC_HAL_IOCFC_Q	= 30,
-};
-
-#endif /* __BFA_TRCMOD_PRIV_H__ */
-- 
1.7.3.rc1

