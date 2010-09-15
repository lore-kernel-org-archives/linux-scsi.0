From: <kgudipat@brocade.com>
Subject: [PATCH 18/33] bfa: Add back cleaned up BFA specific header files.
Date: Wed, 15 Sep 2010 12:10:50 -0700
Message-ID: <1284577850-19980-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:57427 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab0IOTL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:11:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Adding back cleaned up BFA specific header files:

	  bfa.h    : Contains all BFA hw/fw access specific function prototypes / structures,
				 IOC FC specific definitions and interrupt related function prototypes.
	  bfa_cs.h : Contains bfa_trc specific structures & definitions and has statemachine
				 related definitions.
	  bfa_modules.h : Contains the BFA sub-modules definitions and the template
					  to interact with the BFA sub-module.
	  bfa_plog.h : Contains the per port log structure.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa.h         |  438 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_cs.h      |  364 +++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_modules.h |  130 ++++++++++++
 drivers/scsi/bfa/bfa_plog.h    |  159 +++++++++++++++
 4 files changed, 1091 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfa.h
 create mode 100644 drivers/scsi/bfa/bfa_cs.h
 create mode 100644 drivers/scsi/bfa/bfa_modules.h
 create mode 100644 drivers/scsi/bfa/bfa_plog.h

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
new file mode 100644
index 0000000..ceaac65
--- /dev/null
+++ b/drivers/scsi/bfa/bfa.h
@@ -0,0 +1,438 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_H__
+#define __BFA_H__
+
+#include "bfa_os_inc.h"
+#include "bfa_cs.h"
+#include "bfa_plog.h"
+#include "bfa_defs_svc.h"
+#include "bfi.h"
+#include "bfa_ioc.h"
+
+struct bfa_s;
+
+typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
+typedef void    (*bfa_cb_cbfn_t) (void *cbarg, bfa_boolean_t complete);
+
+/**
+ * Interrupt message handlers
+ */
+void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
+void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
+
+/**
+ * Request and response queue related defines
+ */
+#define BFA_REQQ_NELEMS_MIN	(4)
+#define BFA_RSPQ_NELEMS_MIN	(4)
+
+#define bfa_reqq_pi(__bfa, __reqq)	((__bfa)->iocfc.req_cq_pi[__reqq])
+#define bfa_reqq_ci(__bfa, __reqq)					\
+	(*(u32 *)((__bfa)->iocfc.req_cq_shadow_ci[__reqq].kva))
+
+#define bfa_reqq_full(__bfa, __reqq)				\
+	(((bfa_reqq_pi(__bfa, __reqq) + 1) &			\
+	  ((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1)) ==	\
+	 bfa_reqq_ci(__bfa, __reqq))
+
+#define bfa_reqq_next(__bfa, __reqq)					\
+	(bfa_reqq_full(__bfa, __reqq) ? NULL :				\
+	 ((void *)((struct bfi_msg_s *)((__bfa)->iocfc.req_cq_ba[__reqq].kva) \
+		   + bfa_reqq_pi((__bfa), (__reqq)))))
+
+#define bfa_reqq_produce(__bfa, __reqq)	do {				\
+		(__bfa)->iocfc.req_cq_pi[__reqq]++;			\
+		(__bfa)->iocfc.req_cq_pi[__reqq] &=			\
+			((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1);      \
+		bfa_reg_write((__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq],	\
+			      (__bfa)->iocfc.req_cq_pi[__reqq]);      \
+		mmiowb();      \
+	} while (0)
+
+#define bfa_rspq_pi(__bfa, __rspq)					\
+	(*(u32 *)((__bfa)->iocfc.rsp_cq_shadow_pi[__rspq].kva))
+
+#define bfa_rspq_ci(__bfa, __rspq)	((__bfa)->iocfc.rsp_cq_ci[__rspq])
+#define bfa_rspq_elem(__bfa, __rspq, __ci)				\
+	(&((struct bfi_msg_s *)((__bfa)->iocfc.rsp_cq_ba[__rspq].kva))[__ci])
+
+#define CQ_INCR(__index, __size) do {			\
+	(__index)++;					\
+	(__index) &= ((__size) - 1);			\
+} while (0)
+
+/**
+ * Queue element to wait for room in request queue. FIFO order is
+ * maintained when fullfilling requests.
+ */
+struct bfa_reqq_wait_s {
+	struct list_head	qe;
+	void		(*qresume) (void *cbarg);
+	void		*cbarg;
+};
+
+/**
+ * Circular queue usage assignments
+ */
+enum {
+	BFA_REQQ_IOC	= 0,	/*  all low-priority IOC msgs	*/
+	BFA_REQQ_FCXP	= 0,	/*  all FCXP messages		*/
+	BFA_REQQ_LPS	= 0,	/*  all lport service msgs	*/
+	BFA_REQQ_PORT	= 0,	/*  all port messages		*/
+	BFA_REQQ_FLASH	= 0,	/*  for flash module		*/
+	BFA_REQQ_DIAG	= 0,	/*  for diag module		*/
+	BFA_REQQ_RPORT	= 0,	/*  all port messages		*/
+	BFA_REQQ_SBOOT	= 0,	/*  all san boot messages	*/
+	BFA_REQQ_QOS_LO	= 1,	/*  all low priority IO	*/
+	BFA_REQQ_QOS_MD	= 2,	/*  all medium priority IO	*/
+	BFA_REQQ_QOS_HI	= 3,	/*  all high priority IO	*/
+};
+
+static inline void
+bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
+	       void *cbarg)
+{
+	wqe->qresume = qresume;
+	wqe->cbarg = cbarg;
+}
+
+#define bfa_reqq(__bfa, __reqq)	(&(__bfa)->reqq_waitq[__reqq])
+
+/**
+ * static inline void
+ * bfa_reqq_wait(struct bfa_s *bfa, int reqq, struct bfa_reqq_wait_s *wqe)
+ */
+#define bfa_reqq_wait(__bfa, __reqq, __wqe) do {			\
+									\
+		struct list_head *waitq = bfa_reqq(__bfa, __reqq);      \
+									\
+		bfa_assert(((__reqq) < BFI_IOC_MAX_CQS));      \
+		bfa_assert((__wqe)->qresume && (__wqe)->cbarg);      \
+									\
+		list_add_tail(&(__wqe)->qe, waitq);      \
+	} while (0)
+
+#define bfa_reqq_wcancel(__wqe)	list_del(&(__wqe)->qe)
+
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
+#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {	\
+		(__hcb_qe)->cbfn  = (__cbfn);      \
+		(__hcb_qe)->cbarg = (__cbarg);      \
+		list_add_tail(&(__hcb_qe)->qe, &(__bfa)->comp_q);      \
+	} while (0)
+
+#define bfa_cb_dequeue(__hcb_qe)	list_del(&(__hcb_qe)->qe)
+
+#define bfa_cb_queue_once(__bfa, __hcb_qe, __cbfn, __cbarg) do {	\
+		(__hcb_qe)->cbfn  = (__cbfn);      \
+		(__hcb_qe)->cbarg = (__cbarg);      \
+		if (!(__hcb_qe)->once) {      \
+			list_add_tail(&(__hcb_qe)->qe, &(__bfa)->comp_q);      \
+			(__hcb_qe)->once = BFA_TRUE;			\
+		}							\
+	} while (0)
+
+#define bfa_cb_queue_done(__hcb_qe) do {	\
+		(__hcb_qe)->once = BFA_FALSE;	\
+	} while (0)
+
+
+/**
+ * PCI devices supported by the current BFA
+ */
+struct bfa_pciid_s {
+	u16	device_id;
+	u16	vendor_id;
+};
+
+extern char     bfa_version[];
+
+/**
+ * BFA memory resources
+ */
+enum bfa_mem_type {
+	BFA_MEM_TYPE_KVA = 1,	/*  Kernel Virtual Memory *(non-dma-able) */
+	BFA_MEM_TYPE_DMA = 2,	/*  DMA-able memory */
+	BFA_MEM_TYPE_MAX = BFA_MEM_TYPE_DMA,
+};
+
+struct bfa_mem_elem_s {
+	enum bfa_mem_type mem_type;	/* see enum bfa_mem_type */
+	u32	mem_len;	/*  Total Length in Bytes	*/
+	u8		*kva;		/*  kernel virtual address	*/
+	u64	dma;		/*  dma address if DMA memory	*/
+	u8		*kva_curp;	/*  kva allocation cursor	*/
+	u64	dma_curp;	/*  dma allocation cursor	*/
+};
+
+struct bfa_meminfo_s {
+	struct bfa_mem_elem_s meminfo[BFA_MEM_TYPE_MAX];
+};
+#define bfa_meminfo_kva(_m)				\
+	((_m)->meminfo[BFA_MEM_TYPE_KVA - 1].kva_curp)
+#define bfa_meminfo_dma_virt(_m)			\
+	((_m)->meminfo[BFA_MEM_TYPE_DMA - 1].kva_curp)
+#define bfa_meminfo_dma_phys(_m)			\
+	((_m)->meminfo[BFA_MEM_TYPE_DMA - 1].dma_curp)
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
+	void (*hw_reqq_ack)(struct bfa_s *bfa, int reqq);
+	void (*hw_rspq_ack)(struct bfa_s *bfa, int rspq);
+	void (*hw_msix_init)(struct bfa_s *bfa, int nvecs);
+	void (*hw_msix_install)(struct bfa_s *bfa);
+	void (*hw_msix_uninstall)(struct bfa_s *bfa);
+	void (*hw_isr_mode_set)(struct bfa_s *bfa, bfa_boolean_t msix);
+	void (*hw_msix_getvecs)(struct bfa_s *bfa, u32 *vecmap,
+				u32 *nvecs, u32 *maxvec);
+	void (*hw_msix_get_rme_range) (struct bfa_s *bfa, u32 *start,
+				       u32 *end);
+};
+typedef void (*bfa_cb_iocfc_t) (void *cbarg, enum bfa_status status);
+
+struct bfa_iocfc_s {
+	struct bfa_s		*bfa;
+	struct bfa_iocfc_cfg_s	cfg;
+	int			action;
+	u32		req_cq_pi[BFI_IOC_MAX_CQS];
+	u32		rsp_cq_ci[BFI_IOC_MAX_CQS];
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
+	struct bfa_dma_s	req_cq_ba[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s	req_cq_shadow_ci[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s	rsp_cq_ba[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s	rsp_cq_shadow_pi[BFI_IOC_MAX_CQS];
+	struct bfa_iocfc_regs_s	bfa_regs;	/*  BFA device registers */
+	struct bfa_hwif_s	hwif;
+	bfa_cb_iocfc_t		updateq_cbfn; /*  bios callback function */
+	void			*updateq_cbarg;	/*  bios callback arg */
+	u32	intr_mask;
+};
+
+#define bfa_lpuid(__bfa)						\
+	bfa_ioc_portid(&(__bfa)->ioc)
+#define bfa_msix_init(__bfa, __nvecs)					\
+	((__bfa)->iocfc.hwif.hw_msix_init(__bfa, __nvecs))
+#define bfa_msix_install(__bfa)						\
+	((__bfa)->iocfc.hwif.hw_msix_install(__bfa))
+#define bfa_msix_uninstall(__bfa)					\
+	((__bfa)->iocfc.hwif.hw_msix_uninstall(__bfa))
+#define bfa_isr_mode_set(__bfa, __msix)					\
+	((__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix))
+#define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)		\
+	((__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap,		\
+					__nvecs, __maxvec))
+#define bfa_msix_get_rme_range(__bfa, __start, __end)			\
+	((__bfa)->iocfc.hwif.hw_msix_get_rme_range(__bfa, __start, __end))
+#define bfa_msix(__bfa, __vec)						\
+	((__bfa)->msix.handler[__vec](__bfa, __vec))
+
+/*
+ * FC specific IOC functions.
+ */
+void bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		       u32 *dm_len);
+void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
+		      struct bfa_iocfc_cfg_s *cfg,
+		      struct bfa_meminfo_s *meminfo,
+		      struct bfa_pcidev_s *pcidev);
+void bfa_iocfc_detach(struct bfa_s *bfa);
+void bfa_iocfc_init(struct bfa_s *bfa);
+void bfa_iocfc_start(struct bfa_s *bfa);
+void bfa_iocfc_stop(struct bfa_s *bfa);
+void bfa_iocfc_isr(void *bfa, struct bfi_mbmsg_s *msg);
+void bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa);
+bfa_boolean_t bfa_iocfc_is_operational(struct bfa_s *bfa);
+void bfa_iocfc_reset_queues(struct bfa_s *bfa);
+
+void bfa_msix_all(struct bfa_s *bfa, int vec);
+void bfa_msix_reqq(struct bfa_s *bfa, int vec);
+void bfa_msix_rspq(struct bfa_s *bfa, int vec);
+void bfa_msix_lpu_err(struct bfa_s *bfa, int vec);
+
+void bfa_hwcb_reginit(struct bfa_s *bfa);
+void bfa_hwcb_reqq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs);
+void bfa_hwcb_msix_install(struct bfa_s *bfa);
+void bfa_hwcb_msix_uninstall(struct bfa_s *bfa);
+void bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
+void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap, u32 *nvecs,
+			   u32 *maxvec);
+void bfa_hwcb_msix_get_rme_range(struct bfa_s *bfa, u32 *start,
+				 u32 *end);
+void bfa_hwct_reginit(struct bfa_s *bfa);
+void bfa_hwct_reqq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs);
+void bfa_hwct_msix_install(struct bfa_s *bfa);
+void bfa_hwct_msix_uninstall(struct bfa_s *bfa);
+void bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
+void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap, u32 *nvecs,
+			   u32 *maxvec);
+void bfa_hwct_msix_get_rme_range(struct bfa_s *bfa, u32 *start,
+				 u32 *end);
+void bfa_com_port_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi);
+void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns);
+wwn_t bfa_iocfc_get_pwwn(struct bfa_s *bfa);
+wwn_t bfa_iocfc_get_nwwn(struct bfa_s *bfa);
+void bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa,
+				struct bfa_boot_pbc_s *pbcfg);
+int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
+				struct bfi_pbc_vport_s *pbc_vport);
+
+
+/**
+ *----------------------------------------------------------------------
+ *		BFA public interfaces
+ *----------------------------------------------------------------------
+ */
+#define bfa_stats(_mod, _stats)	((_mod)->stats._stats++)
+#define bfa_ioc_get_stats(__bfa, __ioc_stats)		\
+	bfa_ioc_fetch_stats(&(__bfa)->ioc, __ioc_stats)
+#define bfa_ioc_clear_stats(__bfa)		\
+	bfa_ioc_clr_stats(&(__bfa)->ioc)
+#define bfa_get_nports(__bfa)			\
+	bfa_ioc_get_nports(&(__bfa)->ioc)
+#define bfa_get_adapter_manufacturer(__bfa, __manufacturer)		\
+	bfa_ioc_get_adapter_manufacturer(&(__bfa)->ioc, __manufacturer)
+#define bfa_get_adapter_model(__bfa, __model)			\
+	bfa_ioc_get_adapter_model(&(__bfa)->ioc, __model)
+#define bfa_get_adapter_serial_num(__bfa, __serial_num)			\
+	bfa_ioc_get_adapter_serial_num(&(__bfa)->ioc, __serial_num)
+#define bfa_get_adapter_fw_ver(__bfa, __fw_ver)			\
+	bfa_ioc_get_adapter_fw_ver(&(__bfa)->ioc, __fw_ver)
+#define bfa_get_adapter_optrom_ver(__bfa, __optrom_ver)			\
+	bfa_ioc_get_adapter_optrom_ver(&(__bfa)->ioc, __optrom_ver)
+#define bfa_get_pci_chip_rev(__bfa, __chip_rev)			\
+	bfa_ioc_get_pci_chip_rev(&(__bfa)->ioc, __chip_rev)
+#define bfa_get_ioc_state(__bfa)		\
+	bfa_ioc_get_state(&(__bfa)->ioc)
+#define bfa_get_type(__bfa)			\
+	bfa_ioc_get_type(&(__bfa)->ioc)
+#define bfa_get_mac(__bfa)			\
+	bfa_ioc_get_mac(&(__bfa)->ioc)
+#define bfa_get_mfg_mac(__bfa)			\
+	bfa_ioc_get_mfg_mac(&(__bfa)->ioc)
+#define bfa_get_fw_clock_res(__bfa)		\
+	((__bfa)->iocfc.cfgrsp->fwcfg.fw_tick_res)
+
+void bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids);
+void bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg);
+void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
+void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
+			 struct bfa_meminfo_s *meminfo);
+void bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		struct bfa_meminfo_s *meminfo,
+		struct bfa_pcidev_s *pcidev);
+void bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod);
+void bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog);
+void bfa_detach(struct bfa_s *bfa);
+void bfa_init(struct bfa_s *bfa);
+void bfa_start(struct bfa_s *bfa);
+void bfa_stop(struct bfa_s *bfa);
+void bfa_attach_fcs(struct bfa_s *bfa);
+void bfa_cb_init(void *bfad, bfa_status_t status);
+void bfa_cb_updateq(void *bfad, bfa_status_t status);
+
+bfa_boolean_t bfa_intx(struct bfa_s *bfa);
+void bfa_intx_disable(struct bfa_s *bfa);
+void bfa_intx_enable(struct bfa_s *bfa);
+void bfa_isr_enable(struct bfa_s *bfa);
+void bfa_isr_disable(struct bfa_s *bfa);
+
+void bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q);
+void bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q);
+void bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q);
+
+typedef void (*bfa_cb_ioc_t) (void *cbarg, enum bfa_status status);
+void bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr);
+void bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr);
+
+void bfa_adapter_get_attr(struct bfa_s *bfa,
+			  struct bfa_adapter_attr_s *ad_attr);
+u64 bfa_adapter_get_id(struct bfa_s *bfa);
+
+bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
+				   struct bfa_iocfc_intr_attr_s *attr);
+
+void bfa_iocfc_enable(struct bfa_s *bfa);
+void bfa_iocfc_disable(struct bfa_s *bfa);
+void bfa_chip_reset(struct bfa_s *bfa);
+void bfa_timer_tick(struct bfa_s *bfa);
+#define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)		\
+	bfa_timer_begin(&(_bfa)->timer_mod, _timer, _timercb, _arg, _timeout)
+
+/*
+ * BFA debug API functions
+ */
+bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
+bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
+bfa_status_t bfa_debug_fwcore(struct bfa_s *bfa, void *buf,
+			      u32 *offset, int *buflen);
+void bfa_debug_fwsave_clear(struct bfa_s *bfa);
+bfa_status_t bfa_fw_stats_get(struct bfa_s *bfa, void *data);
+bfa_status_t bfa_fw_stats_clear(struct bfa_s *bfa);
+
+#endif /* __BFA_H__ */
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
new file mode 100644
index 0000000..7260c74
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -0,0 +1,364 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
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
+ *  bfa_cs.h BFA common services
+ */
+
+#ifndef __BFA_CS_H__
+#define __BFA_CS_H__
+
+#include "bfa_os_inc.h"
+
+/**
+ * BFA TRC
+ */
+
+#ifndef BFA_TRC_MAX
+#define BFA_TRC_MAX	(4 * 1024)
+#endif
+
+#ifndef BFA_TRC_TS
+#define BFA_TRC_TS(_trcm)	((_trcm)->ticks++)
+#endif
+
+struct bfa_trc_s {
+#ifdef __BIGENDIAN
+	u16	fileno;
+	u16	line;
+#else
+	u16	line;
+	u16	fileno;
+#endif
+	u32	timestamp;
+	union {
+		struct {
+			u32	rsvd;
+			u32	u32;
+		} u32;
+		u64	u64;
+	} data;
+};
+
+struct bfa_trc_mod_s {
+	u32	head;
+	u32	tail;
+	u32	ntrc;
+	u32	stopped;
+	u32	ticks;
+	u32	rsvd[3];
+	struct bfa_trc_s trc[BFA_TRC_MAX];
+};
+
+enum {
+	BFA_TRC_HAL  = 1,	/*  BFA modules */
+	BFA_TRC_FCS  = 2,	/*  BFA FCS modules */
+	BFA_TRC_LDRV = 3,	/*  Linux driver modules */
+	BFA_TRC_CNA  = 4,	/*  Common modules */
+};
+#define BFA_TRC_MOD_SH	10
+#define BFA_TRC_MOD(__mod)	((BFA_TRC_ ## __mod) << BFA_TRC_MOD_SH)
+
+/**
+ * Define a new tracing file (module). Module should match one defined above.
+ */
+#define BFA_TRC_FILE(__mod, __submod)					\
+	static int __trc_fileno = ((BFA_TRC_ ## __mod ## _ ## __submod) | \
+						 BFA_TRC_MOD(__mod))
+
+
+#define bfa_trc32(_trcp, _data)	\
+	__bfa_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u32)_data)
+#define bfa_trc(_trcp, _data)	\
+	__bfa_trc((_trcp)->trcmod, __trc_fileno, __LINE__, (u64)_data)
+
+static inline void
+bfa_trc_init(struct bfa_trc_mod_s *trcm)
+{
+	trcm->head = trcm->tail = trcm->stopped = 0;
+	trcm->ntrc = BFA_TRC_MAX;
+}
+
+static inline void
+bfa_trc_stop(struct bfa_trc_mod_s *trcm)
+{
+	trcm->stopped = 1;
+}
+
+#ifdef FWTRC
+extern void dc_flush(void *data);
+#else
+#define dc_flush(data)
+#endif
+
+
+static inline void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s	*trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u64 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+	dc_flush(trc);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+	dc_flush(trcm);
+}
+
+
+static inline void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
+{
+	int		tail = trcm->tail;
+	struct bfa_trc_s *trc = &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno = (u16) fileno;
+	trc->line = (u16) line;
+	trc->data.u32.u32 = data;
+	trc->timestamp = BFA_TRC_TS(trcm);
+	dc_flush(trc);
+
+	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail == trcm->head)
+		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
+	dc_flush(trcm);
+}
+
+#ifndef BFA_PERF_BUILD
+#define bfa_trc_fp(_trcp, _data)	bfa_trc(_trcp, _data)
+#else
+#define bfa_trc_fp(_trcp, _data)
+#endif
+
+/**
+ * @ BFA LOG interfaces
+ */
+#define bfa_assert(__cond)	do {					\
+	if (!(__cond)) {						\
+		printk(KERN_ERR "assert(%s) failed at %s:%d\\n",         \
+		#__cond, __FILE__, __LINE__);				\
+	}								\
+} while (0)
+
+#define bfa_sm_fault(__mod, __event)	do {				\
+	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
+	printk(KERN_ERR	"Assertion failure: %s:%d: %d",			\
+		__FILE__, __LINE__, (__event));				\
+} while (0)
+
+#ifndef BFA_PERF_BUILD
+#define bfa_assert_fp(__cond)	bfa_assert(__cond)
+#else
+#define bfa_assert_fp(__cond)
+#endif
+
+/* BFA queue definitions */
+#define bfa_q_first(_q) ((void *)(((struct list_head *) (_q))->next))
+#define bfa_q_next(_qe) (((struct list_head *) (_qe))->next)
+#define bfa_q_prev(_qe) (((struct list_head *) (_qe))->prev)
+
+/*
+ * bfa_q_qe_init - to initialize a queue element
+ */
+#define bfa_q_qe_init(_qe) {				\
+	bfa_q_next(_qe) = (struct list_head *) NULL;	\
+	bfa_q_prev(_qe) = (struct list_head *) NULL;	\
+}
+
+/*
+ * bfa_q_deq - dequeue an element from head of the queue
+ */
+#define bfa_q_deq(_q, _qe) {						\
+	if (!list_empty(_q)) {						\
+		(*((struct list_head **) (_qe))) = bfa_q_next(_q);	\
+		bfa_q_prev(bfa_q_next(*((struct list_head **) _qe))) =	\
+				(struct list_head *) (_q);		\
+		bfa_q_next(_q) = bfa_q_next(*((struct list_head **) _qe));\
+		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		\
+	} else {							\
+		*((struct list_head **) (_qe)) = (struct list_head *) NULL;\
+	}								\
+}
+
+/*
+ * bfa_q_deq_tail - dequeue an element from tail of the queue
+ */
+#define bfa_q_deq_tail(_q, _qe) {					\
+	if (!list_empty(_q)) {						\
+		*((struct list_head **) (_qe)) = bfa_q_prev(_q);	\
+		bfa_q_next(bfa_q_prev(*((struct list_head **) _qe))) =	\
+			(struct list_head *) (_q);			\
+		bfa_q_prev(_q) = bfa_q_prev(*(struct list_head **) _qe);\
+		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		\
+	} else {							\
+		*((struct list_head **) (_qe)) = (struct list_head *) NULL;\
+	}								\
+}
+
+static inline int
+bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe)
+{
+	struct list_head        *tqe;
+
+	tqe = bfa_q_next(q);
+	while (tqe != q) {
+		if (tqe == qe)
+			return 1;
+		tqe = bfa_q_next(tqe);
+		if (tqe == NULL)
+			break;
+	}
+	return 0;
+}
+
+/*
+ * #ifdef BFA_DEBUG (Using bfa_assert to check for debug_build is not
+ * consistent across modules)
+ */
+#ifndef BFA_PERF_BUILD
+#define BFA_Q_DBG_INIT(_qe) bfa_q_qe_init(_qe)
+#else
+#define BFA_Q_DBG_INIT(_qe)
+#endif
+
+#define bfa_q_is_on_q(_q, _qe)      \
+	bfa_q_is_on_q_func(_q, (struct list_head *)(_qe))
+
+/**
+ * @ BFA state machine interfaces
+ */
+
+typedef void (*bfa_sm_t)(void *sm, int event);
+
+/**
+ * oc - object class eg. bfa_ioc
+ * st - state, eg. reset
+ * otype - object type, eg. struct bfa_ioc_s
+ * etype - object type, eg. enum ioc_event
+ */
+#define bfa_sm_state_decl(oc, st, otype, etype)		\
+	static void oc ## _sm_ ## st(otype * fsm, etype event)
+
+#define bfa_sm_set_state(_sm, _state)	((_sm)->sm = (bfa_sm_t)(_state))
+#define bfa_sm_send_event(_sm, _event)	((_sm)->sm((_sm), (_event)))
+#define bfa_sm_get_state(_sm)		((_sm)->sm)
+#define bfa_sm_cmp_state(_sm, _state)	((_sm)->sm == (bfa_sm_t)(_state))
+
+/**
+ * For converting from state machine function to state encoding.
+ */
+struct bfa_sm_table_s {
+	bfa_sm_t	sm;	/*  state machine function	*/
+	int		state;	/*  state machine encoding	*/
+	char		*name;	/*  state name for display	*/
+};
+#define BFA_SM(_sm)	((bfa_sm_t)(_sm))
+
+/**
+ * State machine with entry actions.
+ */
+typedef void (*bfa_fsm_t)(void *fsm, int event);
+
+/**
+ * oc - object class eg. bfa_ioc
+ * st - state, eg. reset
+ * otype - object type, eg. struct bfa_ioc_s
+ * etype - object type, eg. enum ioc_event
+ */
+#define bfa_fsm_state_decl(oc, st, otype, etype)		\
+	static void oc ## _sm_ ## st(otype * fsm, etype event);      \
+	static void oc ## _sm_ ## st ## _entry(otype * fsm)
+
+#define bfa_fsm_set_state(_fsm, _state) do {	\
+	(_fsm)->fsm = (bfa_fsm_t)(_state);      \
+	_state ## _entry(_fsm);      \
+} while (0)
+
+#define bfa_fsm_send_event(_fsm, _event)	((_fsm)->fsm((_fsm), (_event)))
+#define bfa_fsm_get_state(_fsm)			((_fsm)->fsm)
+#define bfa_fsm_cmp_state(_fsm, _state)		\
+	((_fsm)->fsm == (bfa_fsm_t)(_state))
+
+static inline int
+bfa_sm_to_state(struct bfa_sm_table_s *smt, bfa_sm_t sm)
+{
+	int	i = 0;
+
+	while (smt[i].sm && smt[i].sm != sm)
+		i++;
+	return smt[i].state;
+}
+
+/**
+ * @ Generic wait counter.
+ */
+
+typedef void (*bfa_wc_resume_t) (void *cbarg);
+
+struct bfa_wc_s {
+	bfa_wc_resume_t wc_resume;
+	void		*wc_cbarg;
+	int		wc_count;
+};
+
+static inline void
+bfa_wc_up(struct bfa_wc_s *wc)
+{
+	wc->wc_count++;
+}
+
+static inline void
+bfa_wc_down(struct bfa_wc_s *wc)
+{
+	wc->wc_count--;
+	if (wc->wc_count == 0)
+		wc->wc_resume(wc->wc_cbarg);
+}
+
+/**
+ * Initialize a waiting counter.
+ */
+static inline void
+bfa_wc_init(struct bfa_wc_s *wc, bfa_wc_resume_t wc_resume, void *wc_cbarg)
+{
+	wc->wc_resume = wc_resume;
+	wc->wc_cbarg = wc_cbarg;
+	wc->wc_count = 0;
+	bfa_wc_up(wc);
+}
+
+/**
+ * Wait for counter to reach zero
+ */
+static inline void
+bfa_wc_wait(struct bfa_wc_s *wc)
+{
+	bfa_wc_down(wc);
+}
+
+#endif /* __BFA_CS_H__ */
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
new file mode 100644
index 0000000..2cd5273
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -0,0 +1,130 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
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
+ *  bfa_modules.h BFA modules
+ */
+
+#ifndef __BFA_MODULES_H__
+#define __BFA_MODULES_H__
+
+#include "bfa_cs.h"
+#include "bfa.h"
+#include "bfa_svc.h"
+#include "bfa_fcpim.h"
+#include "bfa_port.h"
+
+struct bfa_modules_s {
+	struct bfa_fcport_s	fcport;		/*  fc port module	      */
+	struct bfa_fcxp_mod_s	fcxp_mod;	/*  fcxp module	      */
+	struct bfa_lps_mod_s	lps_mod;	/*  fcxp module	      */
+	struct bfa_uf_mod_s	uf_mod;		/*  unsolicited frame module */
+	struct bfa_rport_mod_s	rport_mod;	/*  remote port module	      */
+	struct bfa_fcpim_mod_s	fcpim_mod;	/*  FCP initiator module     */
+	struct bfa_sgpg_mod_s	sgpg_mod;	/*  SG page module	      */
+	struct bfa_port_s	port;		/*  Physical port module     */
+};
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_HAL_CORE	= 1,
+	BFA_TRC_HAL_FCXP	= 2,
+	BFA_TRC_HAL_FCPIM	= 3,
+	BFA_TRC_HAL_IOCFC_CT	= 4,
+	BFA_TRC_HAL_IOCFC_CB	= 5,
+};
+
+
+/**
+ * Macro to define a new BFA module
+ */
+#define BFA_MODULE(__mod)						\
+	static void bfa_ ## __mod ## _meminfo(				\
+			struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,	\
+			u32 *dm_len);      \
+	static void bfa_ ## __mod ## _attach(struct bfa_s *bfa,		\
+			void *bfad, struct bfa_iocfc_cfg_s *cfg,	\
+			struct bfa_meminfo_s *meminfo,			\
+			struct bfa_pcidev_s *pcidev);      \
+	static void bfa_ ## __mod ## _detach(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _start(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _stop(struct bfa_s *bfa);      \
+	static void bfa_ ## __mod ## _iocdisable(struct bfa_s *bfa);      \
+									\
+	extern struct bfa_module_s hal_mod_ ## __mod;			\
+	struct bfa_module_s hal_mod_ ## __mod = {			\
+		bfa_ ## __mod ## _meminfo,				\
+		bfa_ ## __mod ## _attach,				\
+		bfa_ ## __mod ## _detach,				\
+		bfa_ ## __mod ## _start,				\
+		bfa_ ## __mod ## _stop,					\
+		bfa_ ## __mod ## _iocdisable,				\
+	}
+
+#define BFA_CACHELINE_SZ	(256)
+
+/**
+ * Structure used to interact between different BFA sub modules
+ *
+ * Each sub module needs to implement only the entry points relevant to it (and
+ * can leave entry points as NULL)
+ */
+struct bfa_module_s {
+	void (*meminfo) (struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+			u32 *dm_len);
+	void (*attach) (struct bfa_s *bfa, void *bfad,
+			struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo,
+			struct bfa_pcidev_s *pcidev);
+	void (*detach) (struct bfa_s *bfa);
+	void (*start) (struct bfa_s *bfa);
+	void (*stop) (struct bfa_s *bfa);
+	void (*iocdisable) (struct bfa_s *bfa);
+};
+
+extern struct bfa_module_s *hal_mods[];
+
+struct bfa_s {
+	void			*bfad;		/*  BFA driver instance    */
+	struct bfa_plog_s	*plog;		/*  portlog buffer	    */
+	struct bfa_trc_mod_s	*trcmod;	/*  driver tracing	    */
+	struct bfa_ioc_s	ioc;		/*  IOC module		    */
+	struct bfa_iocfc_s	iocfc;		/*  IOCFC module	    */
+	struct bfa_timer_mod_s	timer_mod;	/*  timer module	    */
+	struct bfa_modules_s	modules;	/*  BFA modules	    */
+	struct list_head	comp_q;		/*  pending completions     */
+	bfa_boolean_t		rme_process;	/*  RME processing enabled  */
+	struct list_head	reqq_waitq[BFI_IOC_MAX_CQS];
+	bfa_boolean_t		fcs;		/*  FCS is attached to BFA */
+	struct bfa_msix_s	msix;
+};
+
+extern bfa_isr_func_t bfa_isrs[BFI_MC_MAX];
+extern bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[];
+extern bfa_boolean_t bfa_auto_recover;
+extern struct bfa_module_s hal_mod_sgpg;
+extern struct bfa_module_s hal_mod_fcport;
+extern struct bfa_module_s hal_mod_fcxp;
+extern struct bfa_module_s hal_mod_lps;
+extern struct bfa_module_s hal_mod_uf;
+extern struct bfa_module_s hal_mod_rport;
+extern struct bfa_module_s hal_mod_fcpim;
+
+#endif /* __BFA_MODULES_H__ */
diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.h
new file mode 100644
index 0000000..501f0ed
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_plog.h
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_PORTLOG_H__
+#define __BFA_PORTLOG_H__
+
+#include "bfa_fc.h"
+#include "bfa_defs.h"
+
+#define BFA_PL_NLOG_ENTS 256
+#define BFA_PL_LOG_REC_INCR(_x) ((_x)++, (_x) %= BFA_PL_NLOG_ENTS)
+
+#define BFA_PL_STRING_LOG_SZ   32   /* number of chars in string log */
+#define BFA_PL_INT_LOG_SZ      8    /* number of integers in the integer log */
+
+enum bfa_plog_log_type {
+	BFA_PL_LOG_TYPE_INVALID	= 0,
+	BFA_PL_LOG_TYPE_INT	= 1,
+	BFA_PL_LOG_TYPE_STRING	= 2,
+};
+
+/*
+ * the (fixed size) record format for each entry in the portlog
+ */
+struct bfa_plog_rec_s {
+	u64	tv;	/* timestamp */
+	u8	 port;	/* Source port that logged this entry */
+	u8	 mid;	/* module id */
+	u8	 eid;	/* indicates Rx, Tx, IOCTL, etc.  bfa_plog_eid */
+	u8	 log_type; /* string/integer log, bfa_plog_log_type_t */
+	u8	 log_num_ints;
+	/*
+	 * interpreted only if log_type is INT_LOG. indicates number of
+	 * integers in the int_log[] (0-PL_INT_LOG_SZ).
+	 */
+	u8	 rsvd;
+	u16	misc;	/* can be used to indicate fc frame length */
+	union {
+		char	    string_log[BFA_PL_STRING_LOG_SZ];
+		u32	int_log[BFA_PL_INT_LOG_SZ];
+	} log_entry;
+
+};
+
+/*
+ * the following #defines will be used by the logging entities to indicate
+ * their module id. BFAL will convert the integer value to string format
+ *
+* process to be used while changing the following #defines:
+ *  - Always add new entries at the end
+ *  - define corresponding string in BFAL
+ *  - Do not remove any entry or rearrange the order.
+ */
+enum bfa_plog_mid {
+	BFA_PL_MID_INVALID	= 0,
+	BFA_PL_MID_DEBUG	= 1,
+	BFA_PL_MID_DRVR		= 2,
+	BFA_PL_MID_HAL		= 3,
+	BFA_PL_MID_HAL_FCXP	= 4,
+	BFA_PL_MID_HAL_UF	= 5,
+	BFA_PL_MID_FCS		= 6,
+	BFA_PL_MID_LPS		= 7,
+	BFA_PL_MID_MAX		= 8
+};
+
+#define BFA_PL_MID_STRLEN    8
+struct bfa_plog_mid_strings_s {
+	char	    m_str[BFA_PL_MID_STRLEN];
+};
+
+/*
+ * the following #defines will be used by the logging entities to indicate
+ * their event type. BFAL will convert the integer value to string format
+ *
+* process to be used while changing the following #defines:
+ *  - Always add new entries at the end
+ *  - define corresponding string in BFAL
+ *  - Do not remove any entry or rearrange the order.
+ */
+enum bfa_plog_eid {
+	BFA_PL_EID_INVALID		= 0,
+	BFA_PL_EID_IOC_DISABLE		= 1,
+	BFA_PL_EID_IOC_ENABLE		= 2,
+	BFA_PL_EID_PORT_DISABLE		= 3,
+	BFA_PL_EID_PORT_ENABLE		= 4,
+	BFA_PL_EID_PORT_ST_CHANGE	= 5,
+	BFA_PL_EID_TX			= 6,
+	BFA_PL_EID_TX_ACK1		= 7,
+	BFA_PL_EID_TX_RJT		= 8,
+	BFA_PL_EID_TX_BSY		= 9,
+	BFA_PL_EID_RX			= 10,
+	BFA_PL_EID_RX_ACK1		= 11,
+	BFA_PL_EID_RX_RJT		= 12,
+	BFA_PL_EID_RX_BSY		= 13,
+	BFA_PL_EID_CT_IN		= 14,
+	BFA_PL_EID_CT_OUT		= 15,
+	BFA_PL_EID_DRIVER_START		= 16,
+	BFA_PL_EID_RSCN			= 17,
+	BFA_PL_EID_DEBUG		= 18,
+	BFA_PL_EID_MISC			= 19,
+	BFA_PL_EID_FIP_FCF_DISC		= 20,
+	BFA_PL_EID_FIP_FCF_CVL		= 21,
+	BFA_PL_EID_LOGIN		= 22,
+	BFA_PL_EID_LOGO			= 23,
+	BFA_PL_EID_TRUNK_SCN		= 24,
+	BFA_PL_EID_MAX
+};
+
+#define BFA_PL_ENAME_STRLEN	8
+struct bfa_plog_eid_strings_s {
+	char	    e_str[BFA_PL_ENAME_STRLEN];
+};
+
+#define BFA_PL_SIG_LEN	8
+#define BFA_PL_SIG_STR  "12pl123"
+
+/*
+ * per port circular log buffer
+ */
+struct bfa_plog_s {
+	char	    plog_sig[BFA_PL_SIG_LEN];	/* Start signature */
+	u8	 plog_enabled;
+	u8	 rsvd[7];
+	u32	ticks;
+	u16	head;
+	u16	tail;
+	struct bfa_plog_rec_s  plog_recs[BFA_PL_NLOG_ENTS];
+};
+
+void bfa_plog_init(struct bfa_plog_s *plog);
+void bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc, char *log_str);
+void bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			u32 *intarr, u32 num_ints);
+void bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		enum bfa_plog_eid event, u16 misc, struct fchs_s *fchdr);
+void bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event, u16 misc,
+			struct fchs_s *fchdr, u32 pld_w0);
+void bfa_plog_clear(struct bfa_plog_s *plog);
+void bfa_plog_enable(struct bfa_plog_s *plog);
+void bfa_plog_disable(struct bfa_plog_s *plog);
+bfa_boolean_t	bfa_plog_get_setting(struct bfa_plog_s *plog);
+
+#endif /* __BFA_PORTLOG_H__ */
-- 
1.7.3.rc1

