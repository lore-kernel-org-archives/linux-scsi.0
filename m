From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/14] bfa: Brocade BFA FC SCSI driver (bfa part2)
Date: Thu, 20 Aug 2009 00:01:24 -0700
Message-ID: <200908200701.n7K71Oir006676@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:20240 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbZHTHBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 03:01:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains code to access Brocade Fibre channel HBA
firmware/hardware, part-2

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_fcxp_priv.h  |  138 +++
 bfa_fwimg_priv.h |   31 
 bfa_hw_cb.c      |  142 +++
 bfa_hw_ct.c      |  162 +++
 bfa_intr.c       |  218 +++++
 bfa_intr_priv.h  |  115 ++
 bfa_ioc.c        | 2385 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 bfa_iocfc.c      |  868 ++++++++++++++++++++
 bfa_iocfc.h      |  168 +++
 9 files changed, 4227 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_fcxp_priv.h patch/drivers/scsi/bfa/bfa_fcxp_priv.h
--- orig/drivers/scsi/bfa/bfa_fcxp_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcxp_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,138 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_FCXP_PRIV_H__
+#define __BFA_FCXP_PRIV_H__
+
+#include <cs/bfa_sm.h>
+#include <protocol/fc.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_fcxp.h>
+
+#define BFA_FCXP_MIN     	(1)
+#define BFA_FCXP_MAX_IBUF_SZ	(2 * 1024 + 256)
+#define BFA_FCXP_MAX_LBUF_SZ	(4 * 1024 + 256)
+
+struct bfa_fcxp_mod_s {
+	struct bfa_s      *bfa;		/*  backpointer to BFA */
+	struct bfa_fcxp_s *fcxp_list;	/*  array of FCXPs */
+	u16        num_fcxps;	/*  max num FCXP requests */
+	struct list_head fcxp_free_q;	/*  free FCXPs */
+	struct list_head fcxp_active_q;	/*  active FCXPs */
+	void	*req_pld_list_kva;	/*  list of FCXP req pld */
+	u64 req_pld_list_pa;	/*  list of FCXP req pld */
+	void *rsp_pld_list_kva;		/*  list of FCXP resp pld */
+	u64 rsp_pld_list_pa;	/*  list of FCXP resp pld */
+	struct list_head  wait_q;		/*  wait queue for free fcxp */
+	u32	req_pld_sz;
+	u32	rsp_pld_sz;
+};
+
+#define BFA_FCXP_MOD(__bfa)		(&(__bfa)->modules.fcxp_mod)
+#define BFA_FCXP_FROM_TAG(__mod, __tag)	(&(__mod)->fcxp_list[__tag])
+
+typedef void    (*fcxp_send_cb_t) (struct bfa_s *ioc, struct bfa_fcxp_s *fcxp,
+				   void *cb_arg, bfa_status_t req_status,
+				   u32 rsp_len, u32 resid_len,
+				   struct fchs_s *rsp_fchs);
+
+/**
+ * Information needed for a FCXP request
+ */
+struct bfa_fcxp_req_info_s {
+	struct bfa_rport_s *bfa_rport;	/*  Pointer to the bfa rport that was
+					 *returned from bfa_rport_create().
+					 *This could be left NULL for WKA or for
+					 *FCXP interactions before the rport
+					 *nexus is established
+					 */
+	struct fchs_s   fchs;	/*  request FC header structure */
+	u8 cts;		/*  continous sequence */
+	u8 class;		/*  FC class for the request/response */
+	u16 max_frmsz;	/*  max send frame size */
+	u16 vf_id;		/*  vsan tag if applicable */
+	u8	lp_tag;		/*  lport tag */
+	u32 req_tot_len;	/*  request payload total length */
+};
+
+struct bfa_fcxp_rsp_info_s {
+	struct fchs_s rsp_fchs;		/*  Response frame's FC header will
+					 * be *sent back in this field */
+	u8         rsp_timeout;	/*  timeout in seconds, 0-no response
+					 */
+	u8         rsvd2[3];
+	u32        rsp_maxlen;	/*  max response length expected */
+};
+
+struct bfa_fcxp_s {
+	struct list_head 	qe;		/*  fcxp queue element */
+	bfa_sm_t        sm;             /*  state machine */
+	void           	*caller;	/*  driver or fcs */
+	struct bfa_fcxp_mod_s *fcxp_mod;
+					/*  back pointer to fcxp mod */
+	u16        fcxp_tag;	/*  internal tag */
+	struct bfa_fcxp_req_info_s req_info;
+					/*  request info */
+	struct bfa_fcxp_rsp_info_s rsp_info;
+					/*  response info */
+	u8 	use_ireqbuf;	/*  use internal req buf */
+	u8         use_irspbuf;	/*  use internal rsp buf */
+	u32        nreq_sgles;	/*  num request SGLEs */
+	u32        nrsp_sgles;	/*  num response SGLEs */
+	struct list_head req_sgpg_q;	/*  SG pages for request buf */
+	struct list_head req_sgpg_wqe;	/*  wait queue for req SG page */
+	struct list_head rsp_sgpg_q;	/*  SG pages for response buf */
+	struct list_head rsp_sgpg_wqe;	/*  wait queue for rsp SG page */
+
+	bfa_fcxp_get_sgaddr_t req_sga_cbfn;
+					/*  SG elem addr user function */
+	bfa_fcxp_get_sglen_t req_sglen_cbfn;
+					/*  SG elem len user function */
+	bfa_fcxp_get_sgaddr_t rsp_sga_cbfn;
+					/*  SG elem addr user function */
+	bfa_fcxp_get_sglen_t rsp_sglen_cbfn;
+					/*  SG elem len user function */
+	bfa_cb_fcxp_send_t send_cbfn;   /*  send completion callback */
+	void		*send_cbarg;	/*  callback arg */
+	struct bfa_sge_s   req_sge[BFA_FCXP_MAX_SGES];
+					/*  req SG elems */
+	struct bfa_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];
+					/*  rsp SG elems */
+	u8         rsp_status;	/*  comp: rsp status */
+	u32        rsp_len;	/*  comp: actual response len */
+	u32        residue_len;	/*  comp: residual rsp length */
+	struct fchs_s          rsp_fchs;	/*  comp: response fchs */
+	struct bfa_cb_qe_s    hcb_qe;	/*  comp: callback qelem */
+	struct bfa_reqq_wait_s	reqq_wqe;
+	bfa_boolean_t	reqq_waiting;
+};
+
+#define BFA_FCXP_REQ_PLD(_fcxp) 	(bfa_fcxp_get_reqbuf(_fcxp))
+
+#define BFA_FCXP_RSP_FCHS(_fcxp) 	(&((_fcxp)->rsp_info.fchs))
+#define BFA_FCXP_RSP_PLD(_fcxp) 	(bfa_fcxp_get_rspbuf(_fcxp))
+
+#define BFA_FCXP_REQ_PLD_PA(_fcxp)					\
+	((_fcxp)->fcxp_mod->req_pld_list_pa +				\
+		((_fcxp)->fcxp_mod->req_pld_sz  * (_fcxp)->fcxp_tag))
+
+#define BFA_FCXP_RSP_PLD_PA(_fcxp) 					\
+	((_fcxp)->fcxp_mod->rsp_pld_list_pa +				\
+		((_fcxp)->fcxp_mod->rsp_pld_sz * (_fcxp)->fcxp_tag))
+
+void	bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+#endif /* __BFA_FCXP_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_fwimg_priv.h patch/drivers/scsi/bfa/bfa_fwimg_priv.h
--- orig/drivers/scsi/bfa/bfa_fwimg_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fwimg_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_FWIMG_PRIV_H__
+#define __BFA_FWIMG_PRIV_H__
+
+#define	BFI_FLASH_CHUNK_SZ		256	/*  Flash chunk size */
+#define	BFI_FLASH_CHUNK_SZ_WORDS	(BFI_FLASH_CHUNK_SZ/sizeof(u32))
+
+extern u32 *bfi_image_ct_get_chunk(u32 off);
+extern u32 bfi_image_ct_size;
+extern u32 *bfi_image_cb_get_chunk(u32 off);
+extern u32 bfi_image_cb_size;
+extern u32 *bfi_image_cb;
+extern u32 *bfi_image_ct;
+
+#endif /* __BFA_FWIMG_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_hw_cb.c patch/drivers/scsi/bfa/bfa_hw_cb.c
--- orig/drivers/scsi/bfa/bfa_hw_cb.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_hw_cb.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,142 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#include <bfa_priv.h>
+#include <bfi/bfi_cbreg.h>
+
+void
+bfa_hwcb_reginit(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
+	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
+	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+
+	if (fn == 0) {
+		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN0_INT_MSK);
+	} else {
+		bfa_regs->intr_status = (kva + HOSTFN1_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN1_INT_MSK);
+	}
+
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++) {
+		/*
+		 * CPE registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->cpe_q_pi[i] = (kva + CPE_Q_PI(q));
+		bfa_regs->cpe_q_ci[i] = (kva + CPE_Q_CI(q));
+		bfa_regs->cpe_q_depth[i] = (kva + CPE_Q_DEPTH(q));
+
+		/*
+		 * RME registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->rme_q_pi[i] = (kva + RME_Q_PI(q));
+		bfa_regs->rme_q_ci[i] = (kva + RME_Q_CI(q));
+		bfa_regs->rme_q_depth[i] = (kva + RME_Q_DEPTH(q));
+	}
+}
+
+void
+bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq)
+{
+}
+
+static void
+bfa_hwcb_rspq_ack_msix(struct bfa_s *bfa, int rspq)
+{
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
+		__HFN_INT_RME_Q0 << RME_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), rspq));
+}
+
+void
+bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
+		 u32 *num_vecs, u32 *max_vec_bit)
+{
+#define __HFN_NUMINTS	13
+	if (bfa_ioc_pcifn(&bfa->ioc) == 0) {
+		*msix_vecs_bmap = (__HFN_INT_CPE_Q0 | __HFN_INT_CPE_Q1 |
+				   __HFN_INT_CPE_Q2 | __HFN_INT_CPE_Q3 |
+				   __HFN_INT_RME_Q0 | __HFN_INT_RME_Q1 |
+				   __HFN_INT_RME_Q2 | __HFN_INT_RME_Q3 |
+				   __HFN_INT_MBOX_LPU0);
+		*max_vec_bit = __HFN_INT_MBOX_LPU0;
+	} else {
+		*msix_vecs_bmap = (__HFN_INT_CPE_Q4 | __HFN_INT_CPE_Q5 |
+				   __HFN_INT_CPE_Q6 | __HFN_INT_CPE_Q7 |
+				   __HFN_INT_RME_Q4 | __HFN_INT_RME_Q5 |
+				   __HFN_INT_RME_Q6 | __HFN_INT_RME_Q7 |
+				   __HFN_INT_MBOX_LPU1);
+		*max_vec_bit = __HFN_INT_MBOX_LPU1;
+	}
+
+	*msix_vecs_bmap |= (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+			    __HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS);
+	*num_vecs = __HFN_NUMINTS;
+}
+
+/**
+ * No special setup required for crossbow -- vector assignments are implicit.
+ */
+void
+bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs)
+{
+	int i;
+
+	bfa_assert((nvecs == 1) || (nvecs == __HFN_NUMINTS));
+
+	bfa->msix.nvecs = nvecs;
+	if (nvecs == 1) {
+		for (i = 0; i < BFA_MSIX_CB_MAX; i++)
+			bfa->msix.handler[i] = bfa_msix_all;
+		return;
+	}
+
+	for (i = BFA_MSIX_CPE_Q0; i <= BFA_MSIX_CPE_Q7; i++)
+		bfa->msix.handler[i] = bfa_msix_reqq;
+
+	for (i = BFA_MSIX_RME_Q0; i <= BFA_MSIX_RME_Q7; i++)
+		bfa->msix.handler[i] = bfa_msix_rspq;
+
+	for (; i < BFA_MSIX_CB_MAX; i++)
+		bfa->msix.handler[i] = bfa_msix_lpu_err;
+}
+
+/**
+ * Crossbow -- dummy, interrupts are masked
+ */
+void
+bfa_hwcb_msix_install(struct bfa_s *bfa)
+{
+}
+
+void
+bfa_hwcb_msix_uninstall(struct bfa_s *bfa)
+{
+}
+
+/**
+ * No special enable/disable -- vector assignments are implicit.
+ */
+void
+bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix)
+{
+	bfa->iocfc.hwif.hw_rspq_ack = bfa_hwcb_rspq_ack_msix;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_hw_ct.c patch/drivers/scsi/bfa/bfa_hw_ct.c
--- orig/drivers/scsi/bfa/bfa_hw_ct.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_hw_ct.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,162 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#include <bfa_priv.h>
+#include <bfi/bfi_ctreg.h>
+#include <bfa_ioc.h>
+
+BFA_TRC_FILE(HAL, IOCFC_CT);
+
+static u32 __ct_msix_err_vec_reg[] = {
+	HOST_MSIX_ERR_INDEX_FN0,
+	HOST_MSIX_ERR_INDEX_FN1,
+	HOST_MSIX_ERR_INDEX_FN2,
+	HOST_MSIX_ERR_INDEX_FN3,
+};
+
+static void
+bfa_hwct_msix_lpu_err_set(struct bfa_s *bfa, bfa_boolean_t msix, int vec)
+{
+	int fn = bfa_ioc_pcifn(&bfa->ioc);
+	bfa_os_addr_t kva = bfa_ioc_bar0(&bfa->ioc);
+
+	if (msix)
+		bfa_reg_write(kva + __ct_msix_err_vec_reg[fn], vec);
+	else
+		bfa_reg_write(kva + __ct_msix_err_vec_reg[fn], 0);
+}
+
+/**
+ * Dummy interrupt handler for handling spurious interrupt during chip-reinit.
+ */
+static void
+bfa_hwct_msix_dummy(struct bfa_s *bfa, int vec)
+{
+}
+
+void
+bfa_hwct_reginit(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
+	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
+	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+
+	if (fn == 0) {
+		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN0_INT_MSK);
+	} else {
+		bfa_regs->intr_status = (kva + HOSTFN1_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN1_INT_MSK);
+	}
+
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++) {
+		/*
+		 * CPE registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->cpe_q_pi[i] = (kva + CPE_PI_PTR_Q(q << 5));
+		bfa_regs->cpe_q_ci[i] = (kva + CPE_CI_PTR_Q(q << 5));
+		bfa_regs->cpe_q_depth[i] = (kva + CPE_DEPTH_Q(q << 5));
+		bfa_regs->cpe_q_ctrl[i] = (kva + CPE_QCTRL_Q(q << 5));
+
+		/*
+		 * RME registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->rme_q_pi[i] = (kva + RME_PI_PTR_Q(q << 5));
+		bfa_regs->rme_q_ci[i] = (kva + RME_CI_PTR_Q(q << 5));
+		bfa_regs->rme_q_depth[i] = (kva + RME_DEPTH_Q(q << 5));
+		bfa_regs->rme_q_ctrl[i] = (kva + RME_QCTRL_Q(q << 5));
+	}
+}
+
+void
+bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq)
+{
+	u32	r32;
+
+	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq]);
+	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq], r32);
+}
+
+void
+bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
+		 u32 *num_vecs, u32 *max_vec_bit)
+{
+	*msix_vecs_bmap = (1 << BFA_MSIX_CT_MAX) - 1;
+	*max_vec_bit = (1 << (BFA_MSIX_CT_MAX - 1));
+	*num_vecs = BFA_MSIX_CT_MAX;
+}
+
+/**
+ * Setup MSI-X vector for catapult
+ */
+void
+bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs)
+{
+	bfa_assert((nvecs == 1) || (nvecs == BFA_MSIX_CT_MAX));
+	bfa_trc(bfa, nvecs);
+
+	bfa->msix.nvecs = nvecs;
+	bfa_hwct_msix_uninstall(bfa);
+}
+
+void
+bfa_hwct_msix_install(struct bfa_s *bfa)
+{
+	int i;
+
+	if (bfa->msix.nvecs == 0)
+		return;
+
+	if (bfa->msix.nvecs == 1) {
+		for (i = 0; i < BFA_MSIX_CT_MAX; i++)
+			bfa->msix.handler[i] = bfa_msix_all;
+		return;
+	}
+
+	for (i = BFA_MSIX_CPE_Q0; i <= BFA_MSIX_CPE_Q3; i++)
+		bfa->msix.handler[i] = bfa_msix_reqq;
+
+	for (; i <= BFA_MSIX_RME_Q3; i++)
+		bfa->msix.handler[i] = bfa_msix_rspq;
+
+	bfa_assert(i == BFA_MSIX_LPU_ERR);
+	bfa->msix.handler[BFA_MSIX_LPU_ERR] = bfa_msix_lpu_err;
+}
+
+void
+bfa_hwct_msix_uninstall(struct bfa_s *bfa)
+{
+	int i;
+
+	for (i = 0; i < BFA_MSIX_CT_MAX; i++)
+		bfa->msix.handler[i] = bfa_hwct_msix_dummy;
+}
+
+/**
+ * Enable MSI-X vectors
+ */
+void
+bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix)
+{
+	bfa_trc(bfa, 0);
+	bfa_hwct_msix_lpu_err_set(bfa, msix, BFA_MSIX_LPU_ERR);
+	bfa_ioc_isr_mode_set(&bfa->ioc, msix);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_intr.c patch/drivers/scsi/bfa/bfa_intr.c
--- orig/drivers/scsi/bfa/bfa_intr.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_intr.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,218 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#include <bfa.h>
+#include <bfi/bfi_cbreg.h>
+#include <bfa_port_priv.h>
+#include <bfa_intr_priv.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, INTR);
+
+static void
+bfa_msix_errint(struct bfa_s *bfa, u32 intr)
+{
+	bfa_ioc_error_isr(&bfa->ioc);
+}
+
+static void
+bfa_msix_lpu(struct bfa_s *bfa)
+{
+	bfa_ioc_mbox_isr(&bfa->ioc);
+}
+
+void
+bfa_msix_all(struct bfa_s *bfa, int vec)
+{
+	bfa_intx(bfa);
+}
+
+/**
+ *  hal_intr_api
+ */
+bfa_boolean_t
+bfa_intx(struct bfa_s *bfa)
+{
+	u32        intr, qintr;
+	int             queue;
+
+	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
+	if (!intr)
+		return BFA_FALSE;
+
+	/**
+	 * RME completion queue interrupt
+	 */
+	qintr = intr & __HFN_INT_RME_MASK;
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, qintr);
+
+	for (queue = 0; queue < BFI_IOC_MAX_CQS_ASIC; queue ++) {
+		if (intr & (__HFN_INT_RME_Q0 << queue))
+			bfa_msix_rspq(bfa, queue & (BFI_IOC_MAX_CQS - 1));
+	}
+	intr &= ~qintr;
+	if (!intr)
+		return BFA_TRUE;
+
+	/**
+	 * CPE completion queue interrupt
+	 */
+	qintr = intr & __HFN_INT_CPE_MASK;
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, qintr);
+
+	for (queue = 0; queue < BFI_IOC_MAX_CQS_ASIC; queue++) {
+		if (intr & (__HFN_INT_CPE_Q0 << queue))
+			bfa_msix_reqq(bfa, queue & (BFI_IOC_MAX_CQS - 1));
+	}
+	intr &= ~qintr;
+	if (!intr)
+		return BFA_TRUE;
+
+	bfa_msix_lpu_err(bfa, intr);
+
+	return BFA_TRUE;
+}
+
+void
+bfa_isr_enable(struct bfa_s *bfa)
+{
+	u32        intr_unmask;
+	int             pci_func = bfa_ioc_pcifn(&bfa->ioc);
+
+	bfa_trc(bfa, pci_func);
+
+	bfa_msix_install(bfa);
+	intr_unmask = (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+		       __HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS);
+
+	if (pci_func == 0)
+		intr_unmask |= (__HFN_INT_CPE_Q0 | __HFN_INT_CPE_Q1 |
+				__HFN_INT_CPE_Q2 | __HFN_INT_CPE_Q3 |
+				__HFN_INT_RME_Q0 | __HFN_INT_RME_Q1 |
+				__HFN_INT_RME_Q2 | __HFN_INT_RME_Q3 |
+				__HFN_INT_MBOX_LPU0);
+	else
+		intr_unmask |= (__HFN_INT_CPE_Q4 | __HFN_INT_CPE_Q5 |
+				__HFN_INT_CPE_Q6 | __HFN_INT_CPE_Q7 |
+				__HFN_INT_RME_Q4 | __HFN_INT_RME_Q5 |
+				__HFN_INT_RME_Q6 | __HFN_INT_RME_Q7 |
+				__HFN_INT_MBOX_LPU1);
+
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr_unmask);
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, ~intr_unmask);
+	bfa_isr_mode_set(bfa, bfa->msix.nvecs != 0);
+}
+
+void
+bfa_isr_disable(struct bfa_s *bfa)
+{
+	bfa_isr_mode_set(bfa, BFA_FALSE);
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, -1L);
+	bfa_msix_uninstall(bfa);
+}
+
+void
+bfa_msix_reqq(struct bfa_s *bfa, int qid)
+{
+	struct list_head 		*waitq, *qe, *qen;
+	struct bfa_reqq_wait_s	*wqe;
+
+	qid &= (BFI_IOC_MAX_CQS - 1);
+
+	waitq = bfa_reqq(bfa, qid);
+	list_for_each_safe(qe, qen, waitq) {
+		/**
+		 * Callback only as long as there is room in request queue
+		 */
+		if (bfa_reqq_full(bfa, qid))
+			break;
+
+		list_del(qe);
+		wqe = (struct bfa_reqq_wait_s *) qe;
+		wqe->qresume(wqe->cbarg);
+	}
+}
+
+void
+bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	bfa_trc(bfa, m->mhdr.msg_class);
+	bfa_trc(bfa, m->mhdr.msg_id);
+	bfa_trc(bfa, m->mhdr.mtag.i2htok);
+	bfa_assert(0);
+	bfa_trc_stop(bfa->trcmod);
+}
+
+void
+bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
+{
+	struct bfi_msg_s      *m;
+	u32        pi, ci;
+
+	bfa_trc_fp(bfa, rsp_qid);
+
+	rsp_qid &= (BFI_IOC_MAX_CQS - 1);
+
+	bfa->iocfc.hwif.hw_rspq_ack(bfa, rsp_qid);
+
+	ci = bfa_rspq_ci(bfa, rsp_qid);
+	pi = bfa_rspq_pi(bfa, rsp_qid);
+
+	bfa_trc_fp(bfa, ci);
+	bfa_trc_fp(bfa, pi);
+
+	if (bfa->rme_process) {
+		while (ci != pi) {
+			m = bfa_rspq_elem(bfa, rsp_qid, ci);
+			bfa_assert_fp(m->mhdr.msg_class < BFI_MC_MAX);
+
+			bfa_isrs[m->mhdr.msg_class] (bfa, m);
+
+			CQ_INCR(ci, bfa->iocfc.cfg.drvcfg.num_rspq_elems);
+		}
+	}
+
+	/**
+	 * update CI
+	 */
+	bfa_rspq_ci(bfa, rsp_qid) = pi;
+	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[rsp_qid], pi);
+	bfa_os_mmiowb();
+}
+
+void
+bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
+{
+	u32 intr;
+
+	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
+
+	if (intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1))
+		bfa_msix_lpu(bfa);
+
+	if (intr & (__HFN_INT_ERR_EMC |
+		    __HFN_INT_ERR_LPU0 | __HFN_INT_ERR_LPU1 |
+		    __HFN_INT_ERR_PSS))
+		bfa_msix_errint(bfa, intr);
+}
+
+void
+bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func)
+{
+	bfa_isrs[mc] = isr_func;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_intr_priv.h patch/drivers/scsi/bfa/bfa_intr_priv.h
--- orig/drivers/scsi/bfa/bfa_intr_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_intr_priv.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#ifndef __BFA_INTR_PRIV_H__
+#define __BFA_INTR_PRIV_H__
+
+/**
+ * Message handler
+ */
+typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
+void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
+void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
+
+
+#define bfa_reqq_pi(__bfa, __reqq)	(__bfa)->iocfc.req_cq_pi[__reqq]
+#define bfa_reqq_ci(__bfa, __reqq)					\
+	*(u32 *)((__bfa)->iocfc.req_cq_shadow_ci[__reqq].kva)
+
+#define bfa_reqq_full(__bfa, __reqq)				\
+	(((bfa_reqq_pi(__bfa, __reqq) + 1) &			\
+	  ((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1)) ==	\
+	 bfa_reqq_ci(__bfa, __reqq))
+
+#define bfa_reqq_next(__bfa, __reqq)				\
+	(bfa_reqq_full(__bfa, __reqq) ? NULL :			\
+	 ((void *)((struct bfi_msg_s *)((__bfa)->iocfc.req_cq_ba[__reqq].kva) \
+			  + bfa_reqq_pi((__bfa), (__reqq)))))
+
+#define bfa_reqq_produce(__bfa, __reqq)	do {				\
+	(__bfa)->iocfc.req_cq_pi[__reqq]++;				\
+	(__bfa)->iocfc.req_cq_pi[__reqq] &=				\
+		((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1);      \
+	bfa_reg_write((__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq],		\
+				(__bfa)->iocfc.req_cq_pi[__reqq]);      \
+	bfa_os_mmiowb();      \
+} while (0)
+
+#define bfa_rspq_pi(__bfa, __rspq)					\
+	*(u32 *)((__bfa)->iocfc.rsp_cq_shadow_pi[__rspq].kva)
+
+#define bfa_rspq_ci(__bfa, __rspq)	(__bfa)->iocfc.rsp_cq_ci[__rspq]
+#define bfa_rspq_elem(__bfa, __rspq, __ci)				\
+	&((struct bfi_msg_s *)((__bfa)->iocfc.rsp_cq_ba[__rspq].kva))[__ci]
+
+#define CQ_INCR(__index, __size)					\
+			(__index)++; (__index) &= ((__size) - 1)
+
+/**
+ * Queue element to wait for room in request queue. FIFO order is
+ * maintained when fullfilling requests.
+ */
+struct bfa_reqq_wait_s {
+	struct list_head 	qe;
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
+			void *cbarg)
+{
+	wqe->qresume = qresume;
+	wqe->cbarg = cbarg;
+}
+
+#define bfa_reqq(__bfa, __reqq)	&(__bfa)->reqq_waitq[__reqq]
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
+} while (0)
+
+#define bfa_reqq_wcancel(__wqe)	list_del(&(__wqe)->qe)
+
+#endif /* __BFA_INTR_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_ioc.c patch/drivers/scsi/bfa/bfa_ioc.c
--- orig/drivers/scsi/bfa/bfa_ioc.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_ioc.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,2385 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#include <bfa_ioc.h>
+#include <bfa_fwimg_priv.h>
+#include <bfa_trcmod_priv.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_ctreg.h>
+#include <aen/bfa_aen_ioc.h>
+#include <aen/bfa_aen.h>
+#include <log/bfa_log_hal.h>
+#include <defs/bfa_defs_pci.h>
+
+BFA_TRC_FILE(HAL, IOC);
+
+/**
+ * IOC local definitions
+ */
+#define BFA_IOC_TOV		2000	/* msecs */
+#define BFA_IOC_HB_TOV		1000	/* msecs */
+#define BFA_IOC_HB_FAIL_MAX	4
+#define BFA_IOC_HWINIT_MAX	2
+#define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
+#define BFA_IOC_TOV_RECOVER	(BFA_IOC_HB_FAIL_MAX * BFA_IOC_HB_TOV \
+				+ BFA_IOC_TOV)
+
+#define bfa_ioc_timer_start(__ioc)					\
+	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
+			bfa_ioc_timeout, (__ioc), BFA_IOC_TOV)
+#define bfa_ioc_timer_stop(__ioc)   bfa_timer_stop(&(__ioc)->ioc_timer)
+
+#define BFA_DBG_FWTRC_ENTS	(BFI_IOC_TRC_ENTS)
+#define BFA_DBG_FWTRC_LEN					\
+	(BFA_DBG_FWTRC_ENTS * sizeof(struct bfa_trc_s) +	\
+	 (sizeof(struct bfa_trc_mod_s) -			\
+	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
+#define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
+#define bfa_ioc_stats(_ioc, _stats)	(_ioc)->stats._stats ++
+
+#define BFA_FLASH_CHUNK_NO(off)         (off / BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_FLASH_OFFSET_IN_CHUNK(off)  (off % BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_FLASH_CHUNK_ADDR(chunkno)   (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
+bfa_boolean_t   bfa_auto_recover = BFA_FALSE;
+
+/*
+ * forward declarations
+ */
+static void     bfa_ioc_aen_post(struct bfa_ioc_s *bfa,
+				 enum bfa_ioc_aen_event event);
+static void     bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void     bfa_ioc_timeout(void *ioc);
+static void     bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void     bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_recover(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_firmware_lock(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_firmware_unlock(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
+static void     bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
+
+/**
+ *  bfa_ioc_sm
+ */
+
+/**
+ * IOC state machine events
+ */
+enum ioc_event {
+	IOC_E_ENABLE = 1,	/*  IOC enable request */
+	IOC_E_DISABLE = 2,	/*  IOC disable request */
+	IOC_E_TIMEOUT = 3,	/*  f/w response timeout */
+	IOC_E_FWREADY = 4,	/*  f/w initialization done */
+	IOC_E_FWRSP_GETATTR = 5,	/*  IOC get attribute response */
+	IOC_E_FWRSP_ENABLE = 6,	/*  enable f/w response */
+	IOC_E_FWRSP_DISABLE = 7,	/*  disable f/w response */
+	IOC_E_HBFAIL = 8,	/*  heartbeat failure */
+	IOC_E_HWERROR = 9,	/*  hardware error interrupt */
+	IOC_E_SEMLOCKED = 10,	/*  h/w semaphore is locked */
+	IOC_E_DETACH = 11,	/*  driver detach cleanup */
+};
+
+bfa_fsm_state_decl(bfa_ioc, reset, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, fwcheck, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, mismatch, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, semwait, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, hwinit, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, enabling, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, getattr, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, op, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, initfail, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, hbfail, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, disabling, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, disabled, struct bfa_ioc_s, enum ioc_event);
+
+static struct bfa_sm_table_s ioc_sm_table[] = {
+	{BFA_SM(bfa_ioc_sm_reset), BFA_IOC_RESET},
+	{BFA_SM(bfa_ioc_sm_fwcheck), BFA_IOC_FWMISMATCH},
+	{BFA_SM(bfa_ioc_sm_mismatch), BFA_IOC_FWMISMATCH},
+	{BFA_SM(bfa_ioc_sm_semwait), BFA_IOC_SEMWAIT},
+	{BFA_SM(bfa_ioc_sm_hwinit), BFA_IOC_HWINIT},
+	{BFA_SM(bfa_ioc_sm_enabling), BFA_IOC_HWINIT},
+	{BFA_SM(bfa_ioc_sm_getattr), BFA_IOC_GETATTR},
+	{BFA_SM(bfa_ioc_sm_op), BFA_IOC_OPERATIONAL},
+	{BFA_SM(bfa_ioc_sm_initfail), BFA_IOC_INITFAIL},
+	{BFA_SM(bfa_ioc_sm_hbfail), BFA_IOC_HBFAIL},
+	{BFA_SM(bfa_ioc_sm_disabling), BFA_IOC_DISABLING},
+	{BFA_SM(bfa_ioc_sm_disabled), BFA_IOC_DISABLED},
+};
+
+/**
+ * Reset entry actions -- initialize state machine
+ */
+static void
+bfa_ioc_sm_reset_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->retry_count = 0;
+	ioc->auto_recover = bfa_auto_recover;
+}
+
+/**
+ * Beginning state. IOC is in reset state.
+ */
+static void
+bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fwcheck);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_disable_comp(ioc);
+		break;
+
+	case IOC_E_DETACH:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+/**
+ * Semaphore should be acquired for version check.
+ */
+static void
+bfa_ioc_sm_fwcheck_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_hw_sem_get(ioc);
+}
+
+/**
+ * Awaiting h/w semaphore to continue with version check.
+ */
+static void
+bfa_ioc_sm_fwcheck(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_SEMLOCKED:
+		if (bfa_ioc_firmware_lock(ioc)) {
+			ioc->retry_count = 0;
+			bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
+		} else {
+			bfa_ioc_hw_sem_release(ioc);
+			bfa_fsm_set_state(ioc, bfa_ioc_sm_mismatch);
+		}
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_disable_comp(ioc);
+		/*
+		 * fall through
+		 */
+
+	case IOC_E_DETACH:
+		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		break;
+
+	case IOC_E_FWREADY:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+/**
+ * Notify enable completion callback and generate mismatch AEN.
+ */
+static void
+bfa_ioc_sm_mismatch_entry(struct bfa_ioc_s *ioc)
+{
+	/**
+	 * Provide enable completion callback and AEN notification only once.
+	 */
+	if (ioc->retry_count == 0) {
+		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_FWMISMATCH);
+	}
+	ioc->retry_count++;
+	bfa_ioc_timer_start(ioc);
+}
+
+/**
+ * Awaiting firmware version match.
+ */
+static void
+bfa_ioc_sm_mismatch(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fwcheck);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_disable_comp(ioc);
+		/*
+		 * fall through
+		 */
+
+	case IOC_E_DETACH:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		break;
+
+	case IOC_E_FWREADY:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+/**
+ * Request for semaphore.
+ */
+static void
+bfa_ioc_sm_semwait_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_hw_sem_get(ioc);
+}
+
+/**
+ * Awaiting semaphore for h/w initialzation.
+ */
+static void
+bfa_ioc_sm_semwait(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_SEMLOCKED:
+		ioc->retry_count = 0;
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_hwinit_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_reset(ioc, BFA_FALSE);
+}
+
+/**
+ * Hardware is being initialized. Interrupts are enabled.
+ * Holding hardware semaphore lock.
+ */
+static void
+bfa_ioc_sm_hwinit(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWREADY:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_enabling);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_timer_stop(ioc);
+		/*
+		 * fall through
+		 */
+
+	case IOC_E_TIMEOUT:
+		ioc->retry_count++;
+		if (ioc->retry_count < BFA_IOC_HWINIT_MAX) {
+			bfa_ioc_timer_start(ioc);
+			bfa_ioc_reset(ioc, BFA_TRUE);
+			break;
+		}
+
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_enabling_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_enable(ioc);
+}
+
+/**
+ * Host IOC function is being enabled, awaiting response from firmware.
+ * Semaphore is acquired.
+ */
+static void
+bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWRSP_ENABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_timer_stop(ioc);
+		/*
+		 * fall through
+		 */
+
+	case IOC_E_TIMEOUT:
+		ioc->retry_count++;
+		if (ioc->retry_count < BFA_IOC_HWINIT_MAX) {
+			bfa_reg_write(ioc->ioc_regs.ioc_fwstate,
+				      BFI_IOC_UNINIT);
+			bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
+			break;
+		}
+
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_FWREADY:
+		bfa_ioc_send_enable(ioc);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_getattr_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_getattr(ioc);
+}
+
+/**
+ * IOC configuration in progress. Timer is active.
+ */
+static void
+bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWRSP_GETATTR:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_op);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_timer_stop(ioc);
+		/*
+		 * fall through
+		 */
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_op_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_OK);
+	bfa_ioc_hb_monitor(ioc);
+	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_ENABLE);
+}
+
+static void
+bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_hb_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_HWERROR:
+	case IOC_E_FWREADY:
+		/**
+		 * Hard error or IOC recovery by other function.
+		 * Treat it same as heartbeat failure.
+		 */
+		bfa_ioc_hb_stop(ioc);
+		/*
+		 * !!! fall through !!!
+		 */
+
+	case IOC_E_HBFAIL:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_hbfail);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_DISABLE);
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_disable(ioc);
+}
+
+/**
+ * IOC is being disabled
+ */
+static void
+bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_HWERROR:
+	case IOC_E_FWRSP_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		/*
+		 * !!! fall through !!!
+		 */
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+/**
+ * IOC disable completion entry.
+ */
+static void
+bfa_ioc_sm_disabled_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_disable_comp(ioc);
+}
+
+static void
+bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+		break;
+
+	case IOC_E_DISABLE:
+		ioc->cbfn->disable_cbfn(ioc->bfa);
+		break;
+
+	case IOC_E_FWREADY:
+		break;
+
+	case IOC_E_DETACH:
+		bfa_ioc_firmware_unlock(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_initfail_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+	bfa_ioc_timer_start(ioc);
+}
+
+/**
+ * Hardware initialization failed.
+ */
+static void
+bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_DETACH:
+		bfa_ioc_timer_stop(ioc);
+		bfa_ioc_firmware_unlock(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		break;
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_hbfail_entry(struct bfa_ioc_s *ioc)
+{
+	struct list_head *qe;
+	struct bfa_ioc_hbfail_notify_s *notify;
+
+	/**
+	 * Mark IOC as failed in hardware and stop firmware.
+	 */
+	bfa_ioc_lpu_stop(ioc);
+	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_HBFAIL);
+
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
+		bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
+		/*
+		 * Wait for halt to take effect
+		 */
+		bfa_reg_read(ioc->ioc_regs.ll_halt);
+	}
+
+	/**
+	 * Notify driver and common modules registered for notification.
+	 */
+	ioc->cbfn->hbfail_cbfn(ioc->bfa);
+	list_for_each(qe, &ioc->hb_notify_q) {
+		notify = (struct bfa_ioc_hbfail_notify_s *)qe;
+		notify->cbfn(notify->cbarg);
+	}
+
+	/**
+	 * Flush any queued up mailbox requests.
+	 */
+	bfa_ioc_mbox_hbfail(ioc);
+	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_HBFAIL);
+
+	/**
+	 * Trigger auto-recovery after a delay.
+	 */
+	if (ioc->auto_recover) {
+		bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer,
+				bfa_ioc_timeout, ioc, BFA_IOC_TOV_RECOVER);
+	}
+}
+
+/**
+ * IOC heartbeat failure.
+ */
+static void
+bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+
+	case IOC_E_ENABLE:
+		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		break;
+
+	case IOC_E_DISABLE:
+		if (ioc->auto_recover)
+			bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+		break;
+
+	case IOC_E_FWREADY:
+		/**
+		 * Recovery is already initiated by other function.
+		 */
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+
+/**
+ *  bfa_ioc_pvt BFA IOC private functions
+ */
+
+static void
+bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
+{
+	struct list_head *qe;
+	struct bfa_ioc_hbfail_notify_s *notify;
+
+	ioc->cbfn->disable_cbfn(ioc->bfa);
+
+	/**
+	 * Notify common modules registered for notification.
+	 */
+	list_for_each(qe, &ioc->hb_notify_q) {
+		notify = (struct bfa_ioc_hbfail_notify_s *)qe;
+		notify->cbfn(notify->cbarg);
+	}
+}
+
+static void
+bfa_ioc_sem_timeout(void *ioc_arg)
+{
+	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
+
+	bfa_ioc_hw_sem_get(ioc);
+}
+
+static void
+bfa_ioc_usage_sem_get(struct bfa_ioc_s *ioc)
+{
+	u32        r32;
+	int             cnt = 0;
+#define BFA_SEM_SPINCNT	1000
+
+	do {
+		r32 = bfa_reg_read(ioc->ioc_regs.ioc_usage_sem_reg);
+		cnt++;
+		if (cnt > BFA_SEM_SPINCNT)
+			break;
+	} while (r32 != 0);
+	bfa_assert(cnt < BFA_SEM_SPINCNT);
+}
+
+static void
+bfa_ioc_usage_sem_release(struct bfa_ioc_s *ioc)
+{
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_sem_reg, 1);
+}
+
+static void
+bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
+{
+	u32        r32;
+
+	/**
+	 * First read to the semaphore register will return 0, subsequent reads
+	 * will return 1. Semaphore is released by writing 0 to the register
+	 */
+	r32 = bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	if (r32 == 0) {
+		bfa_fsm_send_event(ioc, IOC_E_SEMLOCKED);
+		return;
+	}
+
+	bfa_timer_begin(ioc->timer_mod, &ioc->sem_timer, bfa_ioc_sem_timeout,
+			ioc, BFA_IOC_TOV);
+}
+
+static void
+bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
+{
+	bfa_reg_write(ioc->ioc_regs.ioc_sem_reg, 1);
+}
+
+static void
+bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
+{
+	bfa_timer_stop(&ioc->sem_timer);
+}
+
+/**
+ * Initialize LPU local memory (aka secondary memory / SRAM)
+ */
+static void
+bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
+{
+	u32        pss_ctl;
+	int             i;
+#define PSS_LMEM_INIT_TIME  10000
+
+	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl &= ~__PSS_LMEM_RESET;
+	pss_ctl |= __PSS_LMEM_INIT_EN;
+	pss_ctl |= __PSS_I2C_CLK_DIV(3UL); /* i2c workaround 12.5khz clock */
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+
+	/**
+	 * wait for memory initialization to be complete
+	 */
+	i = 0;
+	do {
+		pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+		i++;
+	} while (!(pss_ctl & __PSS_LMEM_INIT_DONE) && (i < PSS_LMEM_INIT_TIME));
+
+	/**
+	 * If memory initialization is not successful, IOC timeout will catch
+	 * such failures.
+	 */
+	bfa_assert(pss_ctl & __PSS_LMEM_INIT_DONE);
+	bfa_trc(ioc, pss_ctl);
+
+	pss_ctl &= ~(__PSS_LMEM_INIT_DONE | __PSS_LMEM_INIT_EN);
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+}
+
+static void
+bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
+{
+	u32        pss_ctl;
+
+	/**
+	 * Take processor out of reset.
+	 */
+	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl &= ~__PSS_LPU0_RESET;
+
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+}
+
+static void
+bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
+{
+	u32        pss_ctl;
+
+	/**
+	 * Put processors in reset.
+	 */
+	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl |= (__PSS_LPU0_RESET | __PSS_LPU1_RESET);
+
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+}
+
+/**
+ * Get driver and firmware versions.
+ */
+static void
+bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
+{
+	u32        pgnum, pgoff;
+	u32        loff = 0;
+	int             i;
+	u32       *fwsig = (u32 *) fwhdr;
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
+	     i++) {
+		fwsig[i] = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		loff += sizeof(u32);
+	}
+}
+
+static u32 *
+bfa_ioc_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
+{
+	if (ioc->ctdev)
+		return bfi_image_ct_get_chunk(off);
+	return bfi_image_cb_get_chunk(off);
+}
+
+static          u32
+bfa_ioc_fwimg_get_size(struct bfa_ioc_s *ioc)
+{
+return (ioc->ctdev) ? bfi_image_ct_size : bfi_image_cb_size;
+}
+
+/**
+ * Returns TRUE if same.
+ */
+static          bfa_boolean_t
+bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
+{
+	struct bfi_ioc_image_hdr_s *drv_fwhdr;
+	int             i;
+
+	drv_fwhdr =
+		(struct bfi_ioc_image_hdr_s *)bfa_ioc_fwimg_get_chunk(ioc, 0);
+
+	for (i = 0; i < BFI_IOC_MD5SUM_SZ; i++) {
+		if (fwhdr->md5sum[i] != drv_fwhdr->md5sum[i]) {
+			bfa_trc(ioc, i);
+			bfa_trc(ioc, fwhdr->md5sum[i]);
+			bfa_trc(ioc, drv_fwhdr->md5sum[i]);
+			return BFA_FALSE;
+		}
+	}
+
+	bfa_trc(ioc, fwhdr->md5sum[0]);
+	return BFA_TRUE;
+}
+
+/**
+ * Return true if current running version is valid. Firmware signature and
+ * execution context (driver/bios) must match.
+ */
+static          bfa_boolean_t
+bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_image_hdr_s fwhdr, *drv_fwhdr;
+
+	/**
+	 * If bios/efi boot (flash based) -- return true
+	 */
+	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		return BFA_TRUE;
+
+	bfa_ioc_fwver_get(ioc, &fwhdr);
+	drv_fwhdr =
+		(struct bfi_ioc_image_hdr_s *)bfa_ioc_fwimg_get_chunk(ioc, 0);
+
+	if (fwhdr.signature != drv_fwhdr->signature) {
+		bfa_trc(ioc, fwhdr.signature);
+		bfa_trc(ioc, drv_fwhdr->signature);
+		return BFA_FALSE;
+	}
+
+	if (fwhdr.exec != drv_fwhdr->exec) {
+		bfa_trc(ioc, fwhdr.exec);
+		bfa_trc(ioc, drv_fwhdr->exec);
+		return BFA_FALSE;
+	}
+
+	return bfa_ioc_fwver_cmp(ioc, &fwhdr);
+}
+
+/**
+ * Return true if firmware of current driver matches the running firmware.
+ */
+static          bfa_boolean_t
+bfa_ioc_firmware_lock(struct bfa_ioc_s *ioc)
+{
+	enum bfi_ioc_state ioc_fwstate;
+	u32        usecnt;
+	struct bfi_ioc_image_hdr_s fwhdr;
+
+	/**
+	 * Firmware match check is relevant only for CNA.
+	 */
+	if (!ioc->cna)
+		return BFA_TRUE;
+
+	/**
+	 * If bios boot (flash based) -- do not increment usage count
+	 */
+	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		return BFA_TRUE;
+
+	bfa_ioc_usage_sem_get(ioc);
+	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+
+	/**
+	 * If usage count is 0, always return TRUE.
+	 */
+	if (usecnt == 0) {
+		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 1);
+		bfa_ioc_usage_sem_release(ioc);
+		bfa_trc(ioc, usecnt);
+		return BFA_TRUE;
+	}
+
+	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+	bfa_trc(ioc, ioc_fwstate);
+
+	/**
+	 * Use count cannot be non-zero and chip in uninitialized state.
+	 */
+	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
+
+	/**
+	 * Check if another driver with a different firmware is active
+	 */
+	bfa_ioc_fwver_get(ioc, &fwhdr);
+	if (!bfa_ioc_fwver_cmp(ioc, &fwhdr)) {
+		bfa_ioc_usage_sem_release(ioc);
+		bfa_trc(ioc, usecnt);
+		return BFA_FALSE;
+	}
+
+	/**
+	 * Same firmware version. Increment the reference count.
+	 */
+	usecnt++;
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	bfa_ioc_usage_sem_release(ioc);
+	bfa_trc(ioc, usecnt);
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioc_firmware_unlock(struct bfa_ioc_s *ioc)
+{
+	u32        usecnt;
+
+	/**
+	 * Firmware lock is relevant only for CNA.
+	 * If bios boot (flash based) -- do not decrement usage count
+	 */
+	if (!ioc->cna || (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ))
+		return;
+
+	/**
+	 * decrement usage count
+	 */
+	bfa_ioc_usage_sem_get(ioc);
+	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+	bfa_assert(usecnt > 0);
+
+	usecnt--;
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	bfa_trc(ioc, usecnt);
+
+	bfa_ioc_usage_sem_release(ioc);
+}
+
+/**
+ * Conditionally flush any pending message from firmware at start.
+ */
+static void
+bfa_ioc_msgflush(struct bfa_ioc_s *ioc)
+{
+	u32        r32;
+
+	r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
+	if (r32)
+		bfa_reg_write(ioc->ioc_regs.lpu_mbox_cmd, 1);
+}
+
+
+static void
+bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
+{
+	enum bfi_ioc_state ioc_fwstate;
+	bfa_boolean_t   fwvalid;
+
+	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+
+	if (force)
+		ioc_fwstate = BFI_IOC_UNINIT;
+
+	bfa_trc(ioc, ioc_fwstate);
+
+	/**
+	 * check if firmware is valid
+	 */
+	fwvalid = (ioc_fwstate == BFI_IOC_UNINIT) ?
+			BFA_FALSE : bfa_ioc_fwver_valid(ioc);
+
+	if (!fwvalid) {
+		bfa_ioc_boot(ioc, BFI_BOOT_TYPE_NORMAL, ioc->pcidev.device_id);
+		return;
+	}
+
+	/**
+	 * If hardware initialization is in progress (initialized by other IOC),
+	 * just wait for an initialization completion interrupt.
+	 */
+	if (ioc_fwstate == BFI_IOC_INITING) {
+		bfa_trc(ioc, ioc_fwstate);
+		ioc->cbfn->reset_cbfn(ioc->bfa);
+		return;
+	}
+
+	/**
+	 * If IOC function is disabled and firmware version is same,
+	 * just re-enable IOC.
+	 */
+	if (ioc_fwstate == BFI_IOC_DISABLED || ioc_fwstate == BFI_IOC_OP) {
+		bfa_trc(ioc, ioc_fwstate);
+
+		/**
+		 * When using MSI-X any pending firmware ready event should
+		 * be flushed. Otherwise MSI-X interrupts are not delivered.
+		 */
+		bfa_ioc_msgflush(ioc);
+		ioc->cbfn->reset_cbfn(ioc->bfa);
+		bfa_fsm_send_event(ioc, IOC_E_FWREADY);
+		return;
+	}
+
+	/**
+	 * Initialize the h/w for any other states.
+	 */
+	bfa_ioc_boot(ioc, BFI_BOOT_TYPE_NORMAL, ioc->pcidev.device_id);
+}
+
+static void
+bfa_ioc_timeout(void *ioc_arg)
+{
+	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
+
+	bfa_trc(ioc, 0);
+	bfa_fsm_send_event(ioc, IOC_E_TIMEOUT);
+}
+
+void
+bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
+{
+	u32       *msgp = (u32 *) ioc_msg;
+	u32        i;
+
+	bfa_trc(ioc, msgp[0]);
+	bfa_trc(ioc, len);
+
+	bfa_assert(len <= BFI_IOC_MSGLEN_MAX);
+
+	/*
+	 * first write msg to mailbox registers
+	 */
+	for (i = 0; i < len / sizeof(u32); i++)
+		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32),
+			      bfa_os_wtole(msgp[i]));
+
+	for (; i < BFI_IOC_MSGLEN_MAX / sizeof(u32); i++)
+		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32), 0);
+
+	/*
+	 * write 1 to mailbox CMD to trigger LPU event
+	 */
+	bfa_reg_write(ioc->ioc_regs.hfn_mbox_cmd, 1);
+	(void)bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+}
+
+static void
+bfa_ioc_send_enable(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_ctrl_req_s enable_req;
+
+	bfi_h2i_set(enable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_ENABLE_REQ,
+		    bfa_ioc_portid(ioc));
+	enable_req.ioc_class = ioc->ioc_mc;
+	bfa_ioc_mbox_send(ioc, &enable_req, sizeof(struct bfi_ioc_ctrl_req_s));
+}
+
+static void
+bfa_ioc_send_disable(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_ctrl_req_s disable_req;
+
+	bfi_h2i_set(disable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_DISABLE_REQ,
+		    bfa_ioc_portid(ioc));
+	bfa_ioc_mbox_send(ioc, &disable_req, sizeof(struct bfi_ioc_ctrl_req_s));
+}
+
+static void
+bfa_ioc_send_getattr(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_getattr_req_s attr_req;
+
+	bfi_h2i_set(attr_req.mh, BFI_MC_IOC, BFI_IOC_H2I_GETATTR_REQ,
+		    bfa_ioc_portid(ioc));
+	bfa_dma_be_addr_set(attr_req.attr_addr, ioc->attr_dma.pa);
+	bfa_ioc_mbox_send(ioc, &attr_req, sizeof(attr_req));
+}
+
+static void
+bfa_ioc_hb_check(void *cbarg)
+{
+	struct bfa_ioc_s *ioc = cbarg;
+	u32        hb_count;
+
+	hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
+	if (ioc->hb_count == hb_count) {
+		ioc->hb_fail++;
+	} else {
+		ioc->hb_count = hb_count;
+		ioc->hb_fail = 0;
+	}
+
+	if (ioc->hb_fail >= BFA_IOC_HB_FAIL_MAX) {
+		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE, hb_count);
+		ioc->hb_fail = 0;
+		bfa_ioc_recover(ioc);
+		return;
+	}
+
+	bfa_ioc_mbox_poll(ioc);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
+			BFA_IOC_HB_TOV);
+}
+
+static void
+bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
+{
+	ioc->hb_fail = 0;
+	ioc->hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
+			BFA_IOC_HB_TOV);
+}
+
+static void
+bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
+{
+	bfa_timer_stop(&ioc->ioc_timer);
+}
+
+/**
+ * Host to LPU mailbox message addresses
+ */
+static struct {
+	u32        hfn_mbox, lpu_mbox, hfn_pgn;
+} iocreg_fnreg[] = {
+	{
+	HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0}, {
+	HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1}, {
+	HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2}, {
+	HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3}
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 0
+ */
+static struct {
+	u32        hfn, lpu;
+} iocreg_mbcmd_p0[] = {
+	{
+	HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT}, {
+	HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT}, {
+	HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT}, {
+	HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT}
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 1
+ */
+static struct {
+	u32        hfn, lpu;
+} iocreg_mbcmd_p1[] = {
+	{
+	HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT}, {
+	HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT}, {
+	HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT}, {
+	HOSTFN3_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN3_MBOX0_CMD_STAT}
+};
+
+/**
+ * Shared IRQ handling in INTX mode
+ */
+static struct {
+	u32        isr, msk;
+} iocreg_shirq_next[] = {
+	{
+	HOSTFN1_INT_STATUS, HOSTFN1_INT_MSK}, {
+	HOSTFN2_INT_STATUS, HOSTFN2_INT_MSK}, {
+	HOSTFN3_INT_STATUS, HOSTFN3_INT_MSK}, {
+HOSTFN0_INT_STATUS, HOSTFN0_INT_MSK},};
+
+static void
+bfa_ioc_reg_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t   rb;
+	int             pcifn = bfa_ioc_pcifn(ioc);
+
+	rb = bfa_ioc_bar0(ioc);
+
+	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
+	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
+	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
+
+	if (ioc->port_id == 0) {
+		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
+		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
+		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P0;
+	} else {
+		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
+		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
+		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P1;
+	}
+
+	/**
+	 * Shared IRQ handling in INTX mode
+	 */
+	ioc->ioc_regs.shirq_isr_next = rb + iocreg_shirq_next[pcifn].isr;
+	ioc->ioc_regs.shirq_msk_next = rb + iocreg_shirq_next[pcifn].msk;
+
+	/*
+	 * PSS control registers
+	 */
+	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
+	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
+
+	/*
+	 * IOC semaphore registers and serialization
+	 */
+	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
+	ioc->ioc_regs.ioc_usage_sem_reg = (rb + HOST_SEM1_REG);
+	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
+
+	/**
+	 * sram memory access
+	 */
+	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
+	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CB;
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT)
+		ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
+}
+
+/**
+ *      Initiate a full firmware download.
+ */
+static void
+bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
+		    u32 boot_param)
+{
+	u32       *fwimg;
+	u32        pgnum, pgoff;
+	u32        loff = 0;
+	u32        chunkno = 0;
+	u32        i;
+
+	/**
+	 * Initialize LMEM first before code download
+	 */
+	bfa_ioc_lmem_init(ioc);
+
+	/**
+	 * Flash based firmware boot
+	 */
+	bfa_trc(ioc, bfa_ioc_fwimg_get_size(ioc));
+	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		boot_type = BFI_BOOT_TYPE_FLASH;
+	fwimg = bfa_ioc_fwimg_get_chunk(ioc, chunkno);
+	fwimg[BFI_BOOT_TYPE_OFF / sizeof(u32)] = bfa_os_swap32(boot_type);
+	fwimg[BFI_BOOT_PARAM_OFF / sizeof(u32)] =
+		bfa_os_swap32(boot_param);
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	for (i = 0; i < bfa_ioc_fwimg_get_size(ioc); i++) {
+
+		if (BFA_FLASH_CHUNK_NO(i) != chunkno) {
+			chunkno = BFA_FLASH_CHUNK_NO(i);
+			fwimg = bfa_ioc_fwimg_get_chunk(ioc,
+					BFA_FLASH_CHUNK_ADDR(chunkno));
+		}
+
+		/**
+		 * write smem
+		 */
+		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff,
+			      fwimg[BFA_FLASH_OFFSET_IN_CHUNK(i)]);
+
+		loff += sizeof(u32);
+
+		/**
+		 * handle page offset wrap around
+		 */
+		loff = PSS_SMEM_PGOFF(loff);
+		if (loff == 0) {
+			pgnum++;
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+		}
+	}
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+		      bfa_ioc_smem_pgnum(ioc, 0));
+}
+
+static void
+bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
+{
+	bfa_ioc_hwinit(ioc, force);
+}
+
+/**
+ * Update BFA configuration from firmware configuration.
+ */
+static void
+bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_attr_s *attr = ioc->attr;
+
+	attr->adapter_prop = bfa_os_ntohl(attr->adapter_prop);
+	attr->maxfrsize = bfa_os_ntohs(attr->maxfrsize);
+
+	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
+}
+
+/**
+ * Attach time initialization of mbox logic.
+ */
+static void
+bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	int             mc;
+
+	INIT_LIST_HEAD(&mod->cmd_q);
+	for (mc = 0; mc < BFI_MC_MAX; mc++) {
+		mod->mbhdlr[mc].cbfn = NULL;
+		mod->mbhdlr[mc].cbarg = ioc->bfa;
+	}
+}
+
+/**
+ * Mbox poll timer -- restarts any pending mailbox requests.
+ */
+static void
+bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s *cmd;
+	u32        stat;
+
+	/**
+	 * If no command pending, do nothing
+	 */
+	if (list_empty(&mod->cmd_q))
+		return;
+
+	/**
+	 * If previous command is not yet fetched by firmware, do nothing
+	 */
+	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	if (stat)
+		return;
+
+	/**
+	 * Enqueue command to firmware.
+	 */
+	bfa_q_deq(&mod->cmd_q, &cmd);
+	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
+}
+
+/**
+ * Cleanup any pending requests.
+ */
+static void
+bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s *cmd;
+
+	while (!list_empty(&mod->cmd_q))
+		bfa_q_deq(&mod->cmd_q, &cmd);
+}
+
+/**
+ * Initialize IOC to port mapping.
+ */
+
+#define FNC_PERS_FN_SHIFT(__fn)	((__fn) * 8)
+static void
+bfa_ioc_map_port(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32        r32;
+
+	/**
+	 * For crossbow, port id is same as pci function.
+	 */
+	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT) {
+		ioc->port_id = bfa_ioc_pcifn(ioc);
+		return;
+	}
+
+	/**
+	 * For catapult, base port id on personality register and IOC type
+	 */
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	r32 >>= FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc));
+	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
+
+	bfa_trc(ioc, bfa_ioc_pcifn(ioc));
+	bfa_trc(ioc, ioc->port_id);
+}
+
+
+
+/**
+ *  bfa_ioc_public
+ */
+
+/**
+* Set interrupt mode for a function: INTX or MSIX
+ */
+void
+bfa_ioc_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
+{
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32        r32, mode;
+
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	bfa_trc(ioc, r32);
+
+	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
+		__F0_INTX_STATUS;
+
+	/**
+	 * If already in desired mode, do not change anything
+	 */
+	if (!msix && mode)
+		return;
+
+	if (msix)
+		mode = __F0_INTX_STATUS_MSIX;
+	else
+		mode = __F0_INTX_STATUS_INTA;
+
+	r32 &= ~(__F0_INTX_STATUS << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
+	r32 |= (mode << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
+	bfa_trc(ioc, r32);
+
+	bfa_reg_write(rb + FNC_PERS_REG, r32);
+}
+
+bfa_status_t
+bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32        pll_sclk, pll_fclk, r32;
+
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
+		pll_sclk =
+			__APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
+			__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(0U) |
+			__APP_PLL_312_JITLMT0_1(3U) |
+			__APP_PLL_312_CNTLMT0_1(1U);
+		pll_fclk =
+			__APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
+			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(0U) |
+			__APP_PLL_425_JITLMT0_1(3U) |
+			__APP_PLL_425_CNTLMT0_1(1U);
+
+		/**
+		 * 	For catapult, choose operational mode FC/FCoE
+		 */
+		if (ioc->fcmode) {
+			bfa_reg_write((rb + OP_MODE), 0);
+			bfa_reg_write((rb + ETH_MAC_SER_REG),
+				      __APP_EMS_CMLCKSEL | __APP_EMS_REFCKBUFEN2
+				      | __APP_EMS_CHANNEL_SEL);
+		} else {
+			ioc->pllinit = BFA_TRUE;
+			bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
+			bfa_reg_write((rb + ETH_MAC_SER_REG),
+				      __APP_EMS_REFCKBUFEN1);
+		}
+	} else {
+		pll_sclk =
+			__APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
+			__APP_PLL_312_P0_1(3U) | __APP_PLL_312_JITLMT0_1(3U) |
+			__APP_PLL_312_CNTLMT0_1(3U);
+		pll_fclk =
+			__APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
+			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
+			__APP_PLL_425_JITLMT0_1(3U) |
+			__APP_PLL_425_CNTLMT0_1(3U);
+	}
+
+	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
+	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
+
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_312_BYPASS | __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_425_BYPASS | __APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_os_udelay(2);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_425_LOGIC_SOFT_RESET);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET);
+
+	/**
+	 * Wait for PLLs to lock.
+	 */
+	bfa_os_udelay(2000);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
+
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
+		bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
+		bfa_os_udelay(1000);
+		r32 = bfa_reg_read((rb + MBIST_STAT_REG));
+		bfa_trc(ioc, r32);
+	}
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Interface used by diag module to do firmware boot with memory test
+ * as the entry vector.
+ */
+void
+bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
+{
+	bfa_os_addr_t   rb;
+
+	bfa_ioc_stats(ioc, ioc_boots);
+
+	if (bfa_ioc_pll_init(ioc) != BFA_STATUS_OK)
+		return;
+
+	/**
+	 * Initialize IOC state of all functions on a chip reset.
+	 */
+	rb = ioc->pcidev.pci_bar_kva;
+	if (boot_param == BFI_BOOT_TYPE_MEMTEST) {
+		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_MEMTEST);
+		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_MEMTEST);
+	} else {
+		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_INITING);
+		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_INITING);
+	}
+
+	bfa_ioc_download_fw(ioc, boot_type, boot_param);
+
+	/**
+	 * Enable interrupts just before starting LPU
+	 */
+	ioc->cbfn->reset_cbfn(ioc->bfa);
+	bfa_ioc_lpu_start(ioc);
+}
+
+/**
+ * Enable/disable IOC failure auto recovery.
+ */
+void
+bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
+{
+	bfa_auto_recover = BFA_FALSE;
+}
+
+
+bfa_boolean_t
+bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
+{
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op);
+}
+
+void
+bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
+{
+	u32       *msgp = mbmsg;
+	u32        r32;
+	int             i;
+
+	/**
+	 * read the MBOX msg
+	 */
+	for (i = 0; i < (sizeof(union bfi_ioc_i2h_msg_u) / sizeof(u32));
+	     i++) {
+		r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox +
+				   i * sizeof(u32));
+		msgp[i] = bfa_os_htonl(r32);
+	}
+
+	/**
+	 * turn off mailbox interrupt by clearing mailbox status
+	 */
+	bfa_reg_write(ioc->ioc_regs.lpu_mbox_cmd, 1);
+	bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
+}
+
+void
+bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
+{
+	union bfi_ioc_i2h_msg_u *msg;
+
+	msg = (union bfi_ioc_i2h_msg_u *)m;
+
+	bfa_ioc_stats(ioc, ioc_isrs);
+
+	switch (msg->mh.msg_id) {
+	case BFI_IOC_I2H_HBEAT:
+		break;
+
+	case BFI_IOC_I2H_READY_EVENT:
+		bfa_fsm_send_event(ioc, IOC_E_FWREADY);
+		break;
+
+	case BFI_IOC_I2H_ENABLE_REPLY:
+		bfa_fsm_send_event(ioc, IOC_E_FWRSP_ENABLE);
+		break;
+
+	case BFI_IOC_I2H_DISABLE_REPLY:
+		bfa_fsm_send_event(ioc, IOC_E_FWRSP_DISABLE);
+		break;
+
+	case BFI_IOC_I2H_GETATTR_REPLY:
+		bfa_ioc_getattr_reply(ioc);
+		break;
+
+	default:
+		bfa_trc(ioc, msg->mh.msg_id);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IOC attach time initialization and setup.
+ *
+ * @param[in]	ioc	memory for IOC
+ * @param[in]	bfa	driver instance structure
+ * @param[in]	trcmod	kernel trace module
+ * @param[in]	aen	kernel aen event module
+ * @param[in]	logm	kernel logging module
+ */
+void
+bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa, struct bfa_ioc_cbfn_s *cbfn,
+	       struct bfa_timer_mod_s *timer_mod, struct bfa_trc_mod_s *trcmod,
+	       struct bfa_aen_s *aen, struct bfa_log_mod_s *logm)
+{
+	ioc->bfa = bfa;
+	ioc->cbfn = cbfn;
+	ioc->timer_mod = timer_mod;
+	ioc->trcmod = trcmod;
+	ioc->aen = aen;
+	ioc->logm = logm;
+	ioc->fcmode = BFA_FALSE;
+	ioc->pllinit = BFA_FALSE;
+	ioc->dbg_fwsave_once = BFA_TRUE;
+
+	bfa_ioc_mbox_attach(ioc);
+	INIT_LIST_HEAD(&ioc->hb_notify_q);
+
+	bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+}
+
+/**
+ * Driver detach time IOC cleanup.
+ */
+void
+bfa_ioc_detach(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(ioc, IOC_E_DETACH);
+}
+
+/**
+ * Setup IOC PCI properties.
+ *
+ * @param[in]	pcidev	PCI device information for this IOC
+ */
+void
+bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
+		 enum bfi_mclass mc)
+{
+	ioc->ioc_mc = mc;
+	ioc->pcidev = *pcidev;
+	ioc->ctdev = (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT);
+	ioc->cna = ioc->ctdev && !ioc->fcmode;
+
+	bfa_ioc_map_port(ioc);
+	bfa_ioc_reg_init(ioc);
+}
+
+/**
+ * Initialize IOC dma memory
+ *
+ * @param[in]	dm_kva	kernel virtual address of IOC dma memory
+ * @param[in]	dm_pa	physical address of IOC dma memory
+ */
+void
+bfa_ioc_mem_claim(struct bfa_ioc_s *ioc, u8 *dm_kva, u64 dm_pa)
+{
+	/**
+	 * dma memory for firmware attribute
+	 */
+	ioc->attr_dma.kva = dm_kva;
+	ioc->attr_dma.pa = dm_pa;
+	ioc->attr = (struct bfi_ioc_attr_s *)dm_kva;
+}
+
+/**
+ * Return size of dma memory required.
+ */
+u32
+bfa_ioc_meminfo(void)
+{
+	return BFA_ROUNDUP(sizeof(struct bfi_ioc_attr_s), BFA_DMA_ALIGN_SZ);
+}
+
+void
+bfa_ioc_enable(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_stats(ioc, ioc_enables);
+	ioc->dbg_fwsave_once = BFA_TRUE;
+
+	bfa_fsm_send_event(ioc, IOC_E_ENABLE);
+}
+
+void
+bfa_ioc_disable(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_stats(ioc, ioc_disables);
+	bfa_fsm_send_event(ioc, IOC_E_DISABLE);
+}
+
+/**
+ * Returns memory required for saving firmware trace in case of crash.
+ * Driver must call this interface to allocate memory required for
+ * automatic saving of firmware trace. Driver should call
+ * bfa_ioc_debug_memclaim() right after bfa_ioc_attach() to setup this
+ * trace memory.
+ */
+int
+bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover)
+{
+return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
+}
+
+/**
+ * Initialize memory for saving firmware trace. Driver must initialize
+ * trace memory before call bfa_ioc_enable().
+ */
+void
+bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave)
+{
+	bfa_assert(ioc->auto_recover);
+	ioc->dbg_fwsave = dbg_fwsave;
+	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->auto_recover);
+}
+
+u32
+bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr)
+{
+	return PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, fmaddr);
+}
+
+u32
+bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr)
+{
+	return PSS_SMEM_PGOFF(fmaddr);
+}
+
+/**
+ * Register mailbox message handler functions
+ *
+ * @param[in]	ioc		IOC instance
+ * @param[in]	mcfuncs		message class handler functions
+ */
+void
+bfa_ioc_mbox_register(struct bfa_ioc_s *ioc, bfa_ioc_mbox_mcfunc_t *mcfuncs)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	int             mc;
+
+	for (mc = 0; mc < BFI_MC_MAX; mc++)
+		mod->mbhdlr[mc].cbfn = mcfuncs[mc];
+}
+
+/**
+ * Register mailbox message handler function, to be called by common modules
+ */
+void
+bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
+		    bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+
+	mod->mbhdlr[mc].cbfn = cbfn;
+	mod->mbhdlr[mc].cbarg = cbarg;
+}
+
+/**
+ * Queue a mailbox command request to firmware. Waits if mailbox is busy.
+ * Responsibility of caller to serialize
+ *
+ * @param[in]	ioc	IOC instance
+ * @param[i]	cmd	Mailbox command
+ */
+void
+bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	u32        stat;
+
+	/**
+	 * If a previous command is pending, queue new command
+	 */
+	if (!list_empty(&mod->cmd_q)) {
+		list_add_tail(&cmd->qe, &mod->cmd_q);
+		return;
+	}
+
+	/**
+	 * If mailbox is busy, queue command for poll timer
+	 */
+	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	if (stat) {
+		list_add_tail(&cmd->qe, &mod->cmd_q);
+		return;
+	}
+
+	/**
+	 * mailbox is free -- queue command to firmware
+	 */
+	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
+}
+
+/**
+ * Handle mailbox interrupts
+ */
+void
+bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	struct bfi_mbmsg_s m;
+	int             mc;
+
+	bfa_ioc_msgget(ioc, &m);
+
+	/**
+	 * Treat IOC message class as special.
+	 */
+	mc = m.mh.msg_class;
+	if (mc == BFI_MC_IOC) {
+		bfa_ioc_isr(ioc, &m);
+		return;
+	}
+
+	if ((mc > BFI_MC_MAX) || (mod->mbhdlr[mc].cbfn == NULL)) {
+		bfa_assert(0);
+		bfa_trc_stop(ioc->trcmod);
+		return;
+	}
+
+	mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);
+}
+
+void
+bfa_ioc_error_isr(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(ioc, IOC_E_HWERROR);
+}
+
+#ifndef BFA_BIOS_BUILD
+
+/**
+ * return true if IOC is disabled
+ */
+bfa_boolean_t
+bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
+{
+	return (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling)
+		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled));
+}
+
+/**
+ * return true if IOC firmware is different.
+ */
+bfa_boolean_t
+bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
+{
+	return (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset)
+		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_fwcheck)
+		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_mismatch));
+}
+
+#define bfa_ioc_state_disabled(__sm)		\
+	(((__sm) == BFI_IOC_UNINIT) ||		\
+	 ((__sm) == BFI_IOC_INITING) ||		\
+	 ((__sm) == BFI_IOC_HWINIT) ||		\
+	 ((__sm) == BFI_IOC_DISABLED) ||	\
+	 ((__sm) == BFI_IOC_HBFAIL) ||		\
+	 ((__sm) == BFI_IOC_CFG_DISABLED))
+
+/**
+ * Check if adapter is disabled -- both IOCs should be in a disabled
+ * state.
+ */
+bfa_boolean_t
+bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
+{
+	u32        ioc_state;
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+
+	if (!bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled))
+		return BFA_FALSE;
+
+	ioc_state = bfa_reg_read(rb + BFA_IOC0_STATE_REG);
+	if (!bfa_ioc_state_disabled(ioc_state))
+		return BFA_FALSE;
+
+	ioc_state = bfa_reg_read(rb + BFA_IOC1_STATE_REG);
+	if (!bfa_ioc_state_disabled(ioc_state))
+		return BFA_FALSE;
+
+	return BFA_TRUE;
+}
+
+/**
+ * Add to IOC heartbeat failure notification queue. To be used by common
+ * modules such as
+ */
+void
+bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
+			struct bfa_ioc_hbfail_notify_s *notify)
+{
+	list_add_tail(&notify->qe, &ioc->hb_notify_q);
+}
+
+#define BFA_MFG_NAME "Brocade"
+void
+bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
+			 struct bfa_adapter_attr_s *ad_attr)
+{
+	struct bfi_ioc_attr_s *ioc_attr;
+	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
+
+	ioc_attr = ioc->attr;
+	bfa_os_memcpy((void *)&ad_attr->serial_num,
+		      (void *)ioc_attr->brcd_serialnum,
+		      BFA_ADAPTER_SERIAL_NUM_LEN);
+
+	bfa_os_memcpy(&ad_attr->fw_ver, ioc_attr->fw_version, BFA_VERSION_LEN);
+	bfa_os_memcpy(&ad_attr->optrom_ver, ioc_attr->optrom_version,
+		      BFA_VERSION_LEN);
+	bfa_os_memcpy(&ad_attr->manufacturer, BFA_MFG_NAME,
+		      BFA_ADAPTER_MFG_NAME_LEN);
+	bfa_os_memcpy(&ad_attr->vpd, &ioc_attr->vpd,
+		      sizeof(struct bfa_mfg_vpd_s));
+
+	ad_attr->nports = BFI_ADAPTER_GETP(NPORTS, ioc_attr->adapter_prop);
+	ad_attr->max_speed = BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
+
+	/**
+	 * model name
+	 */
+	if (BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop) == 10) {
+		strcpy(model, "BR-10?0");
+		model[5] = '0' + ad_attr->nports;
+	} else {
+		strcpy(model, "Brocade-??5");
+		model[8] =
+			'0' + BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
+		model[9] = '0' + ad_attr->nports;
+	}
+
+	if (BFI_ADAPTER_IS_SPECIAL(ioc_attr->adapter_prop))
+		ad_attr->prototype = 1;
+	else
+		ad_attr->prototype = 0;
+
+	bfa_os_memcpy(&ad_attr->model, model, BFA_ADAPTER_MODEL_NAME_LEN);
+	bfa_os_memcpy(&ad_attr->model_descr, &ad_attr->model,
+		      BFA_ADAPTER_MODEL_NAME_LEN);
+
+	ad_attr->pwwn = bfa_ioc_get_pwwn(ioc);
+	ad_attr->mac = bfa_ioc_get_mac(ioc);
+
+	ad_attr->pcie_gen = ioc_attr->pcie_gen;
+	ad_attr->pcie_lanes = ioc_attr->pcie_lanes;
+	ad_attr->pcie_lanes_orig = ioc_attr->pcie_lanes_orig;
+	ad_attr->asic_rev = ioc_attr->asic_rev;
+	ad_attr->hw_ver[0] = 'R';
+	ad_attr->hw_ver[1] = 'e';
+	ad_attr->hw_ver[2] = 'v';
+	ad_attr->hw_ver[3] = '-';
+	ad_attr->hw_ver[4] = ioc_attr->asic_rev;
+	ad_attr->hw_ver[5] = '\0';
+
+	ad_attr->cna_capable = ioc->cna;
+}
+
+void
+bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
+{
+	bfa_os_memset((void *)ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
+
+	ioc_attr->state = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+	ioc_attr->port_id = ioc->port_id;
+
+	if (!ioc->ctdev)
+		ioc_attr->ioc_type = BFA_IOC_TYPE_FC;
+	else if (ioc->ioc_mc == BFI_MC_IOCFC)
+		ioc_attr->ioc_type = BFA_IOC_TYPE_FCoE;
+	else if (ioc->ioc_mc == BFI_MC_LL)
+		ioc_attr->ioc_type = BFA_IOC_TYPE_LL;
+
+	bfa_ioc_get_adapter_attr(ioc, &ioc_attr->adapter_attr);
+
+	ioc_attr->pci_attr.device_id = ioc->pcidev.device_id;
+	ioc_attr->pci_attr.pcifn = ioc->pcidev.pci_func;
+	ioc_attr->pci_attr.chip_rev[0] = 'R';
+	ioc_attr->pci_attr.chip_rev[1] = 'e';
+	ioc_attr->pci_attr.chip_rev[2] = 'v';
+	ioc_attr->pci_attr.chip_rev[3] = '-';
+	ioc_attr->pci_attr.chip_rev[4] = ioc_attr->adapter_attr.asic_rev;
+	ioc_attr->pci_attr.chip_rev[5] = '\0';
+}
+
+/**
+ *  hal_wwn_public
+ */
+wwn_t
+bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
+{
+	union {
+		wwn_t           wwn;
+		u8         byte[sizeof(wwn_t)];
+	}
+	w;
+
+	w.wwn = ioc->attr->mfg_wwn;
+
+	if (bfa_ioc_portid(ioc) == 1)
+		w.byte[7]++;
+
+	return w.wwn;
+}
+
+wwn_t
+bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc)
+{
+	union {
+		wwn_t           wwn;
+		u8         byte[sizeof(wwn_t)];
+	}
+	w;
+
+	w.wwn = ioc->attr->mfg_wwn;
+
+	if (bfa_ioc_portid(ioc) == 1)
+		w.byte[7]++;
+
+	w.byte[0] = 0x20;
+
+	return w.wwn;
+}
+
+wwn_t
+bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst)
+{
+	union {
+		wwn_t           wwn;
+		u8         byte[sizeof(wwn_t)];
+	}
+	w              , w5;
+
+	bfa_trc(ioc, inst);
+
+	w.wwn = ioc->attr->mfg_wwn;
+	w5.byte[0] = 0x50 | w.byte[2] >> 4;
+	w5.byte[1] = w.byte[2] << 4 | w.byte[3] >> 4;
+	w5.byte[2] = w.byte[3] << 4 | w.byte[4] >> 4;
+	w5.byte[3] = w.byte[4] << 4 | w.byte[5] >> 4;
+	w5.byte[4] = w.byte[5] << 4 | w.byte[6] >> 4;
+	w5.byte[5] = w.byte[6] << 4 | w.byte[7] >> 4;
+	w5.byte[6] = w.byte[7] << 4 | (inst & 0x0f00) >> 8;
+	w5.byte[7] = (inst & 0xff);
+
+	return w5.wwn;
+}
+
+u64
+bfa_ioc_get_adid(struct bfa_ioc_s *ioc)
+{
+	return ioc->attr->mfg_wwn;
+}
+
+mac_t
+bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
+{
+	mac_t           mac;
+
+	mac = ioc->attr->mfg_mac;
+	mac.mac[MAC_ADDRLEN - 1] += bfa_ioc_pcifn(ioc);
+
+	return mac;
+}
+
+void
+bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
+{
+	ioc->fcmode = BFA_TRUE;
+	ioc->port_id = bfa_ioc_pcifn(ioc);
+}
+
+bfa_boolean_t
+bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
+{
+	return ioc->fcmode || (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT);
+}
+
+/**
+ * Return true if interrupt should be claimed.
+ */
+bfa_boolean_t
+bfa_ioc_intx_claim(struct bfa_ioc_s *ioc)
+{
+	u32        isr, msk;
+
+	/**
+	 * Always claim if not catapult.
+	 */
+	if (!ioc->ctdev)
+		return BFA_TRUE;
+
+	/**
+	 * FALSE if next device is claiming interrupt.
+	 * TRUE if next device is not interrupting or not present.
+	 */
+	msk = bfa_reg_read(ioc->ioc_regs.shirq_msk_next);
+	isr = bfa_reg_read(ioc->ioc_regs.shirq_isr_next);
+	return !(isr & ~msk);
+}
+
+/**
+ * Send AEN notification
+ */
+static void
+bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = ioc->logm;
+	s32         inst_num = 0;
+	struct bfa_ioc_attr_s ioc_attr;
+
+	switch (event) {
+	case BFA_IOC_AEN_HBGOOD:
+		bfa_log(logmod, BFA_AEN_IOC_HBGOOD, inst_num);
+		break;
+	case BFA_IOC_AEN_HBFAIL:
+		bfa_log(logmod, BFA_AEN_IOC_HBFAIL, inst_num);
+		break;
+	case BFA_IOC_AEN_ENABLE:
+		bfa_log(logmod, BFA_AEN_IOC_ENABLE, inst_num);
+		break;
+	case BFA_IOC_AEN_DISABLE:
+		bfa_log(logmod, BFA_AEN_IOC_DISABLE, inst_num);
+		break;
+	case BFA_IOC_AEN_FWMISMATCH:
+		bfa_log(logmod, BFA_AEN_IOC_FWMISMATCH, inst_num);
+		break;
+	default:
+		break;
+	}
+
+	memset(&aen_data.ioc.pwwn, 0, sizeof(aen_data.ioc.pwwn));
+	memset(&aen_data.ioc.mac, 0, sizeof(aen_data.ioc.mac));
+	bfa_ioc_get_attr(ioc, &ioc_attr);
+	switch (ioc_attr.ioc_type) {
+	case BFA_IOC_TYPE_FC:
+		aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
+		break;
+	case BFA_IOC_TYPE_FCoE:
+		aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
+		aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
+		break;
+	case BFA_IOC_TYPE_LL:
+		aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
+		break;
+	default:
+		bfa_assert(ioc_attr.ioc_type == BFA_IOC_TYPE_FC);
+		break;
+	}
+	aen_data.ioc.ioc_type = ioc_attr.ioc_type;
+}
+
+/**
+ * Retrieve saved firmware trace from a prior IOC failure.
+ */
+bfa_status_t
+bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
+{
+	int             tlen;
+
+	if (ioc->dbg_fwsave_len == 0)
+		return BFA_STATUS_ENOFSAVE;
+
+	tlen = *trclen;
+	if (tlen > ioc->dbg_fwsave_len)
+		tlen = ioc->dbg_fwsave_len;
+
+	bfa_os_memcpy(trcdata, ioc->dbg_fwsave, tlen);
+	*trclen = tlen;
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Retrieve saved firmware trace from a prior IOC failure.
+ */
+bfa_status_t
+bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
+{
+	u32        pgnum;
+	u32        loff = BFA_DBG_FWTRC_OFF(bfa_ioc_portid(ioc));
+	int             i, tlen;
+	u32       *tbuf = trcdata, r32;
+
+	bfa_trc(ioc, *trclen);
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	loff = bfa_ioc_smem_pgoff(ioc, loff);
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	tlen = *trclen;
+	if (tlen > BFA_DBG_FWTRC_LEN)
+		tlen = BFA_DBG_FWTRC_LEN;
+	tlen /= sizeof(u32);
+
+	bfa_trc(ioc, tlen);
+
+	for (i = 0; i < tlen; i++) {
+		r32 = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		tbuf[i] = bfa_os_ntohl(r32);
+		loff += sizeof(u32);
+
+		/**
+		 * handle page offset wrap around
+		 */
+		loff = PSS_SMEM_PGOFF(loff);
+		if (loff == 0) {
+			pgnum++;
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+		}
+	}
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+		      bfa_ioc_smem_pgnum(ioc, 0));
+	bfa_trc(ioc, pgnum);
+
+	*trclen = tlen * sizeof(u32);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Save firmware trace if configured.
+ */
+static void
+bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
+{
+	int             tlen;
+
+	if (ioc->dbg_fwsave_len) {
+		tlen = ioc->dbg_fwsave_len;
+		bfa_ioc_debug_fwtrc(ioc, ioc->dbg_fwsave, &tlen);
+	}
+}
+
+/**
+ * Firmware failure detected. Start recovery actions.
+ */
+static void
+bfa_ioc_recover(struct bfa_ioc_s *ioc)
+{
+	if (ioc->dbg_fwsave_once) {
+		ioc->dbg_fwsave_once = BFA_FALSE;
+		bfa_ioc_debug_save(ioc);
+	}
+
+	bfa_ioc_stats(ioc, ioc_hbfails);
+	bfa_fsm_send_event(ioc, IOC_E_HBFAIL);
+}
+
+#else
+
+static void
+bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
+{
+}
+
+static void
+bfa_ioc_recover(struct bfa_ioc_s *ioc)
+{
+	bfa_assert(0);
+}
+
+#endif
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.c patch/drivers/scsi/bfa/bfa_iocfc.c
--- orig/drivers/scsi/bfa/bfa_iocfc.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_iocfc.c	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,868 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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
+#include <bfa_priv.h>
+#include <log/bfa_log_hal.h>
+#include <bfi/bfi_boot.h>
+#include <bfi/bfi_cbreg.h>
+#include <aen/bfa_aen_ioc.h>
+#include <defs/bfa_defs_iocfc.h>
+#include <defs/bfa_defs_pci.h>
+#include "bfa_callback_priv.h"
+
+BFA_TRC_FILE(HAL, IOCFC);
+
+/**
+ * IOC local definitions
+ */
+#define BFA_IOCFC_TOV		5000	/* msecs */
+
+enum {
+	BFA_IOCFC_ACT_NONE	= 0,
+	BFA_IOCFC_ACT_INIT	= 1,
+	BFA_IOCFC_ACT_STOP	= 2,
+	BFA_IOCFC_ACT_DISABLE	= 3,
+};
+
+/*
+ * forward declarations
+ */
+static void bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status);
+static void bfa_iocfc_disable_cbfn(void *bfa_arg);
+static void bfa_iocfc_hbfail_cbfn(void *bfa_arg);
+static void bfa_iocfc_reset_cbfn(void *bfa_arg);
+static void bfa_iocfc_stats_clear(void *bfa_arg);
+static void bfa_iocfc_stats_swap(struct bfa_fw_stats_s *d,
+			struct bfa_fw_stats_s *s);
+static void bfa_iocfc_stats_clr_cb(void *bfa_arg, bfa_boolean_t complete);
+static void bfa_iocfc_stats_clr_timeout(void *bfa_arg);
+static void bfa_iocfc_stats_cb(void *bfa_arg, bfa_boolean_t complete);
+static void bfa_iocfc_stats_timeout(void *bfa_arg);
+
+static struct bfa_ioc_cbfn_s bfa_iocfc_cbfn;
+
+/**
+ *  bfa_ioc_pvt BFA IOC private functions
+ */
+
+static void
+bfa_iocfc_cqs_sz(struct bfa_iocfc_cfg_s *cfg, u32 *dm_len)
+{
+	int             i, per_reqq_sz, per_rspq_sz;
+
+	per_reqq_sz = BFA_ROUNDUP((cfg->drvcfg.num_reqq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+	per_rspq_sz = BFA_ROUNDUP((cfg->drvcfg.num_rspq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+
+	/*
+	 * Calculate CQ size
+	 */
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		*dm_len = *dm_len + per_reqq_sz;
+		*dm_len = *dm_len + per_rspq_sz;
+	}
+
+	/*
+	 * Calculate Shadow CI/PI size
+	 */
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++)
+		*dm_len += (2 * BFA_CACHELINE_SZ);
+}
+
+static void
+bfa_iocfc_fw_cfg_sz(struct bfa_iocfc_cfg_s *cfg, u32 *dm_len)
+{
+	*dm_len +=
+		BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfg_s), BFA_CACHELINE_SZ);
+	*dm_len +=
+		BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfgrsp_s),
+			    BFA_CACHELINE_SZ);
+	*dm_len += BFA_ROUNDUP(sizeof(struct bfa_fw_stats_s), BFA_CACHELINE_SZ);
+}
+
+/**
+ * Use the Mailbox interface to send BFI_IOCFC_H2I_CFG_REQ
+ */
+static void
+bfa_iocfc_send_cfg(void *bfa_arg)
+{
+	struct bfa_s *bfa = bfa_arg;
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfg_req_s cfg_req;
+	struct bfi_iocfc_cfg_s *cfg_info = iocfc->cfginfo;
+	struct bfa_iocfc_cfg_s  *cfg = &iocfc->cfg;
+	int             i;
+
+	bfa_assert(cfg->fwcfg.num_cqs <= BFI_IOC_MAX_CQS);
+	bfa_trc(bfa, cfg->fwcfg.num_cqs);
+
+	iocfc->cfgdone = BFA_FALSE;
+	bfa_iocfc_reset_queues(bfa);
+
+	/**
+	 * initialize IOC configuration info
+	 */
+	cfg_info->endian_sig = BFI_IOC_ENDIAN_SIG;
+	cfg_info->num_cqs = cfg->fwcfg.num_cqs;
+
+	bfa_dma_be_addr_set(cfg_info->cfgrsp_addr, iocfc->cfgrsp_dma.pa);
+	bfa_dma_be_addr_set(cfg_info->stats_addr, iocfc->stats_pa);
+
+	/**
+	 * dma map REQ and RSP circular queues and shadow pointers
+	 */
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		bfa_dma_be_addr_set(cfg_info->req_cq_ba[i],
+				       iocfc->req_cq_ba[i].pa);
+		bfa_dma_be_addr_set(cfg_info->req_shadow_ci[i],
+				       iocfc->req_cq_shadow_ci[i].pa);
+		cfg_info->req_cq_elems[i] =
+			bfa_os_htons(cfg->drvcfg.num_reqq_elems);
+
+		bfa_dma_be_addr_set(cfg_info->rsp_cq_ba[i],
+				       iocfc->rsp_cq_ba[i].pa);
+		bfa_dma_be_addr_set(cfg_info->rsp_shadow_pi[i],
+				       iocfc->rsp_cq_shadow_pi[i].pa);
+		cfg_info->rsp_cq_elems[i] =
+			bfa_os_htons(cfg->drvcfg.num_rspq_elems);
+	}
+
+	/**
+	 * dma map IOC configuration itself
+	 */
+	bfi_h2i_set(cfg_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CFG_REQ,
+			bfa_lpuid(bfa));
+	bfa_dma_be_addr_set(cfg_req.ioc_cfg_dma_addr, iocfc->cfg_info.pa);
+
+	bfa_ioc_mbox_send(&bfa->ioc, &cfg_req,
+			sizeof(struct bfi_iocfc_cfg_req_s));
+}
+
+static void
+bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	bfa->bfad = bfad;
+	iocfc->bfa = bfa;
+	iocfc->action = BFA_IOCFC_ACT_NONE;
+
+	bfa_os_assign(iocfc->cfg, *cfg);
+
+	/**
+	 * Initialize chip specific handlers.
+	 */
+	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT) {
+		iocfc->hwif.hw_reginit = bfa_hwct_reginit;
+		iocfc->hwif.hw_rspq_ack = bfa_hwct_rspq_ack;
+		iocfc->hwif.hw_msix_init = bfa_hwct_msix_init;
+		iocfc->hwif.hw_msix_install = bfa_hwct_msix_install;
+		iocfc->hwif.hw_msix_uninstall = bfa_hwct_msix_uninstall;
+		iocfc->hwif.hw_isr_mode_set = bfa_hwct_isr_mode_set;
+		iocfc->hwif.hw_msix_getvecs = bfa_hwct_msix_getvecs;
+	} else {
+		iocfc->hwif.hw_reginit = bfa_hwcb_reginit;
+		iocfc->hwif.hw_rspq_ack = bfa_hwcb_rspq_ack;
+		iocfc->hwif.hw_msix_init = bfa_hwcb_msix_init;
+		iocfc->hwif.hw_msix_install = bfa_hwcb_msix_install;
+		iocfc->hwif.hw_msix_uninstall = bfa_hwcb_msix_uninstall;
+		iocfc->hwif.hw_isr_mode_set = bfa_hwcb_isr_mode_set;
+		iocfc->hwif.hw_msix_getvecs = bfa_hwcb_msix_getvecs;
+	}
+
+	iocfc->hwif.hw_reginit(bfa);
+	bfa->msix.nvecs = 0;
+}
+
+static void
+bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
+		      struct bfa_meminfo_s *meminfo)
+{
+	u8        *dm_kva;
+	u64        dm_pa;
+	int             i, per_reqq_sz, per_rspq_sz;
+	struct bfa_iocfc_s  *iocfc = &bfa->iocfc;
+	int		dbgsz;
+
+	dm_kva = bfa_meminfo_dma_virt(meminfo);
+	dm_pa = bfa_meminfo_dma_phys(meminfo);
+
+	/*
+	 * First allocate dma memory for IOC.
+	 */
+	bfa_ioc_mem_claim(&bfa->ioc, dm_kva, dm_pa);
+	dm_kva += bfa_ioc_meminfo();
+	dm_pa  += bfa_ioc_meminfo();
+
+	/*
+	 * Claim DMA-able memory for the request/response queues and for shadow
+	 * ci/pi registers
+	 */
+	per_reqq_sz = BFA_ROUNDUP((cfg->drvcfg.num_reqq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+	per_rspq_sz = BFA_ROUNDUP((cfg->drvcfg.num_rspq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		iocfc->req_cq_ba[i].kva = dm_kva;
+		iocfc->req_cq_ba[i].pa = dm_pa;
+		bfa_os_memset(dm_kva, 0, per_reqq_sz);
+		dm_kva += per_reqq_sz;
+		dm_pa += per_reqq_sz;
+
+		iocfc->rsp_cq_ba[i].kva = dm_kva;
+		iocfc->rsp_cq_ba[i].pa = dm_pa;
+		bfa_os_memset(dm_kva, 0, per_rspq_sz);
+		dm_kva += per_rspq_sz;
+		dm_pa += per_rspq_sz;
+	}
+
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		iocfc->req_cq_shadow_ci[i].kva = dm_kva;
+		iocfc->req_cq_shadow_ci[i].pa = dm_pa;
+		dm_kva += BFA_CACHELINE_SZ;
+		dm_pa += BFA_CACHELINE_SZ;
+
+		iocfc->rsp_cq_shadow_pi[i].kva = dm_kva;
+		iocfc->rsp_cq_shadow_pi[i].pa = dm_pa;
+		dm_kva += BFA_CACHELINE_SZ;
+		dm_pa += BFA_CACHELINE_SZ;
+	}
+
+	/*
+	 * Claim DMA-able memory for the config info page
+	 */
+	bfa->iocfc.cfg_info.kva = dm_kva;
+	bfa->iocfc.cfg_info.pa = dm_pa;
+	bfa->iocfc.cfginfo = (struct bfi_iocfc_cfg_s *) dm_kva;
+	dm_kva += BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfg_s), BFA_CACHELINE_SZ);
+	dm_pa += BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfg_s), BFA_CACHELINE_SZ);
+
+	/*
+	 * Claim DMA-able memory for the config response
+	 */
+	bfa->iocfc.cfgrsp_dma.kva = dm_kva;
+	bfa->iocfc.cfgrsp_dma.pa = dm_pa;
+	bfa->iocfc.cfgrsp = (struct bfi_iocfc_cfgrsp_s *) dm_kva;
+
+	dm_kva +=
+		BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfgrsp_s),
+			    BFA_CACHELINE_SZ);
+	dm_pa += BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfgrsp_s),
+			     BFA_CACHELINE_SZ);
+
+	/*
+	 * Claim DMA-able memory for iocfc stats
+	 */
+	bfa->iocfc.stats_kva = dm_kva;
+	bfa->iocfc.stats_pa = dm_pa;
+	bfa->iocfc.fw_stats = (struct bfa_fw_stats_s *) dm_kva;
+	dm_kva += BFA_ROUNDUP(sizeof(struct bfa_fw_stats_s), BFA_CACHELINE_SZ);
+	dm_pa += BFA_ROUNDUP(sizeof(struct bfa_fw_stats_s), BFA_CACHELINE_SZ);
+
+	bfa_meminfo_dma_virt(meminfo) = dm_kva;
+	bfa_meminfo_dma_phys(meminfo) = dm_pa;
+
+	dbgsz = bfa_ioc_debug_trcsz(bfa_auto_recover);
+	if (dbgsz > 0) {
+		bfa_ioc_debug_memclaim(&bfa->ioc, bfa_meminfo_kva(meminfo));
+		bfa_meminfo_kva(meminfo) += dbgsz;
+	}
+}
+
+/**
+ * BFA submodules initialization completion notification.
+ */
+static void
+bfa_iocfc_initdone_submod(struct bfa_s *bfa)
+{
+	int             i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->initdone(bfa);
+}
+
+/**
+ * Start BFA submodules.
+ */
+static void
+bfa_iocfc_start_submod(struct bfa_s *bfa)
+{
+	int             i;
+
+	bfa->rme_process = BFA_TRUE;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->start(bfa);
+}
+
+/**
+ * Disable BFA submodules.
+ */
+static void
+bfa_iocfc_disable_submod(struct bfa_s *bfa)
+{
+	int             i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->iocdisable(bfa);
+}
+
+static void
+bfa_iocfc_init_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	if (complete) {
+		if (bfa->iocfc.cfgdone)
+			bfa_cb_init(bfa->bfad, BFA_STATUS_OK);
+		else
+			bfa_cb_init(bfa->bfad, BFA_STATUS_FAILED);
+	} else
+		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+}
+
+static void
+bfa_iocfc_stop_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s  *bfa = bfa_arg;
+
+	if (complete)
+		bfa_cb_stop(bfa->bfad, BFA_STATUS_OK);
+	else
+		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+}
+
+static void
+bfa_iocfc_disable_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s  *bfa = bfa_arg;
+
+	if (complete)
+		bfa_cb_ioc_disable(bfa->bfad);
+}
+
+/**
+ * Update BFA configuration from firmware configuration.
+ */
+static void
+bfa_iocfc_cfgrsp(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
+	struct bfa_iocfc_fwcfg_s	*fwcfg   = &cfgrsp->fwcfg;
+	struct bfi_iocfc_cfg_s 		*cfginfo = iocfc->cfginfo;
+
+	fwcfg->num_cqs        = fwcfg->num_cqs;
+	fwcfg->num_ioim_reqs  = bfa_os_ntohs(fwcfg->num_ioim_reqs);
+	fwcfg->num_tskim_reqs = bfa_os_ntohs(fwcfg->num_tskim_reqs);
+	fwcfg->num_fcxp_reqs  = bfa_os_ntohs(fwcfg->num_fcxp_reqs);
+	fwcfg->num_uf_bufs    = bfa_os_ntohs(fwcfg->num_uf_bufs);
+	fwcfg->num_rports     = bfa_os_ntohs(fwcfg->num_rports);
+
+	cfginfo->intr_attr.coalesce = cfgrsp->intr_attr.coalesce;
+	cfginfo->intr_attr.delay    = bfa_os_ntohs(cfgrsp->intr_attr.delay);
+	cfginfo->intr_attr.latency  = bfa_os_ntohs(cfgrsp->intr_attr.latency);
+
+	iocfc->cfgdone = BFA_TRUE;
+
+	/**
+	 * Configuration is complete - initialize/start submodules
+	 */
+	if (iocfc->action == BFA_IOCFC_ACT_INIT)
+		bfa_cb_queue(bfa, &iocfc->init_hcb_qe, bfa_iocfc_init_cb, bfa);
+	else
+		bfa_iocfc_start_submod(bfa);
+}
+
+static void
+bfa_iocfc_stats_clear(void *bfa_arg)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	struct bfi_iocfc_stats_req_s stats_req;
+
+	bfa_timer_start(bfa, &iocfc->stats_timer,
+			    bfa_iocfc_stats_clr_timeout, bfa,
+			    BFA_IOCFC_TOV);
+
+	bfi_h2i_set(stats_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CLEAR_STATS_REQ,
+		bfa_lpuid(bfa));
+	bfa_ioc_mbox_send(&bfa->ioc, &stats_req,
+		sizeof(struct bfi_iocfc_stats_req_s));
+}
+
+static void
+bfa_iocfc_stats_swap(struct bfa_fw_stats_s *d, struct bfa_fw_stats_s *s)
+{
+	u32       *dip = (u32 *) d;
+	u32       *sip = (u32 *) s;
+	int             i;
+
+	for (i = 0; i < (sizeof(struct bfa_fw_stats_s) / sizeof(u32)); i++)
+		dip[i] = bfa_os_ntohl(sip[i]);
+}
+
+static void
+bfa_iocfc_stats_clr_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s *bfa = bfa_arg;
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+
+	if (complete) {
+		bfa_ioc_clr_stats(&bfa->ioc);
+		iocfc->stats_cbfn(iocfc->stats_cbarg, iocfc->stats_status);
+	} else {
+		iocfc->stats_busy = BFA_FALSE;
+		iocfc->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_iocfc_stats_clr_timeout(void *bfa_arg)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	bfa_trc(bfa, 0);
+
+	iocfc->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_clr_cb, bfa);
+}
+
+static void
+bfa_iocfc_stats_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	if (complete) {
+		if (iocfc->stats_status == BFA_STATUS_OK) {
+			bfa_os_memset(iocfc->stats_ret, 0,
+				sizeof(*iocfc->stats_ret));
+			bfa_iocfc_stats_swap(&iocfc->stats_ret->fw_stats,
+				iocfc->fw_stats);
+		}
+		iocfc->stats_cbfn(iocfc->stats_cbarg, iocfc->stats_status);
+	} else {
+		iocfc->stats_busy = BFA_FALSE;
+		iocfc->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_iocfc_stats_timeout(void *bfa_arg)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	bfa_trc(bfa, 0);
+
+	iocfc->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_cb, bfa);
+}
+
+static void
+bfa_iocfc_stats_query(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	struct bfi_iocfc_stats_req_s stats_req;
+
+	bfa_timer_start(bfa, &iocfc->stats_timer,
+			    bfa_iocfc_stats_timeout, bfa, BFA_IOCFC_TOV);
+
+	bfi_h2i_set(stats_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_GET_STATS_REQ,
+			bfa_lpuid(bfa));
+	bfa_ioc_mbox_send(&bfa->ioc, &stats_req,
+		sizeof(struct bfi_iocfc_stats_req_s));
+}
+
+void
+bfa_iocfc_reset_queues(struct bfa_s *bfa)
+{
+	int             q;
+
+	for (q = 0; q < BFI_IOC_MAX_CQS; q++) {
+		bfa_reqq_ci(bfa, q) = 0;
+		bfa_reqq_pi(bfa, q) = 0;
+		bfa_rspq_ci(bfa, q) = 0;
+		bfa_rspq_pi(bfa, q) = 0;
+	}
+}
+
+/**
+ * IOC enable request is complete
+ */
+static void
+bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	if (status != BFA_STATUS_OK) {
+		bfa_isr_disable(bfa);
+		if (bfa->iocfc.action == BFA_IOCFC_ACT_INIT)
+			bfa_cb_queue(bfa, &bfa->iocfc.init_hcb_qe,
+				     bfa_iocfc_init_cb, bfa);
+		return;
+	}
+
+	bfa_iocfc_initdone_submod(bfa);
+	bfa_iocfc_send_cfg(bfa);
+}
+
+/**
+ * IOC disable request is complete
+ */
+static void
+bfa_iocfc_disable_cbfn(void *bfa_arg)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	bfa_isr_disable(bfa);
+	bfa_iocfc_disable_submod(bfa);
+
+	if (bfa->iocfc.action == BFA_IOCFC_ACT_STOP)
+		bfa_cb_queue(bfa, &bfa->iocfc.stop_hcb_qe, bfa_iocfc_stop_cb,
+			     bfa);
+	else {
+		bfa_assert(bfa->iocfc.action == BFA_IOCFC_ACT_DISABLE);
+		bfa_cb_queue(bfa, &bfa->iocfc.dis_hcb_qe, bfa_iocfc_disable_cb,
+			     bfa);
+	}
+}
+
+/**
+ * Notify sub-modules of hardware failure.
+ */
+static void
+bfa_iocfc_hbfail_cbfn(void *bfa_arg)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	bfa->rme_process = BFA_FALSE;
+
+	bfa_isr_disable(bfa);
+	bfa_iocfc_disable_submod(bfa);
+
+	if (bfa->iocfc.action == BFA_IOCFC_ACT_INIT)
+		bfa_cb_queue(bfa, &bfa->iocfc.init_hcb_qe, bfa_iocfc_init_cb,
+			     bfa);
+}
+
+/**
+ * Actions on chip-reset completion.
+ */
+static void
+bfa_iocfc_reset_cbfn(void *bfa_arg)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	bfa_iocfc_reset_queues(bfa);
+	bfa_isr_enable(bfa);
+}
+
+
+
+/**
+ *  bfa_ioc_public
+ */
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	/* dma memory for IOC */
+	*dm_len += bfa_ioc_meminfo();
+
+	bfa_iocfc_fw_cfg_sz(cfg, dm_len);
+	bfa_iocfc_cqs_sz(cfg, dm_len);
+	*km_len += bfa_ioc_debug_trcsz(bfa_auto_recover);
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		   struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	int             i;
+
+	bfa_iocfc_cbfn.enable_cbfn = bfa_iocfc_enable_cbfn;
+	bfa_iocfc_cbfn.disable_cbfn = bfa_iocfc_disable_cbfn;
+	bfa_iocfc_cbfn.hbfail_cbfn = bfa_iocfc_hbfail_cbfn;
+	bfa_iocfc_cbfn.reset_cbfn = bfa_iocfc_reset_cbfn;
+
+	bfa_ioc_attach(&bfa->ioc, bfa, &bfa_iocfc_cbfn, &bfa->timer_mod,
+		bfa->trcmod, bfa->aen, bfa->logm);
+	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
+	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
+
+	/**
+	 * Choose FC (ssid: 0x1C) v/s FCoE (ssid: 0x14) mode.
+	 */
+	if (0)
+		bfa_ioc_set_fcmode(&bfa->ioc);
+
+	bfa_iocfc_init_mem(bfa, bfad, cfg, pcidev);
+	bfa_iocfc_mem_claim(bfa, cfg, meminfo);
+	bfa_timer_init(&bfa->timer_mod);
+
+	INIT_LIST_HEAD(&bfa->comp_q);
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++)
+		INIT_LIST_HEAD(&bfa->reqq_waitq[i]);
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_detach(struct bfa_s *bfa)
+{
+	bfa_ioc_detach(&bfa->ioc);
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_init(struct bfa_s *bfa)
+{
+	bfa->iocfc.action = BFA_IOCFC_ACT_INIT;
+	bfa_ioc_enable(&bfa->ioc);
+	bfa_msix_install(bfa);
+}
+
+/**
+ * IOC start called from bfa_start(). Called to start IOC operations
+ * at driver instantiation for this instance.
+ */
+void
+bfa_iocfc_start(struct bfa_s *bfa)
+{
+	if (bfa->iocfc.cfgdone)
+		bfa_iocfc_start_submod(bfa);
+}
+
+/**
+ * IOC stop called from bfa_stop(). Called only when driver is unloaded
+ * for this instance.
+ */
+void
+bfa_iocfc_stop(struct bfa_s *bfa)
+{
+	bfa->iocfc.action = BFA_IOCFC_ACT_STOP;
+
+	bfa->rme_process = BFA_FALSE;
+	bfa_ioc_disable(&bfa->ioc);
+}
+
+void
+bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m)
+{
+	struct bfa_s		*bfa = bfaarg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	union bfi_iocfc_i2h_msg_u	*msg;
+
+	msg = (union bfi_iocfc_i2h_msg_u *) m;
+	bfa_trc(bfa, msg->mh.msg_id);
+
+	switch (msg->mh.msg_id) {
+	case BFI_IOCFC_I2H_CFG_REPLY:
+		iocfc->cfg_reply = &msg->cfg_reply;
+		bfa_iocfc_cfgrsp(bfa);
+		break;
+
+	case BFI_IOCFC_I2H_GET_STATS_RSP:
+		if (iocfc->stats_busy == BFA_FALSE
+		    || iocfc->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&iocfc->stats_timer);
+		iocfc->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_cb,
+			      bfa);
+		break;
+	case BFI_IOCFC_I2H_CLEAR_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (iocfc->stats_busy == BFA_FALSE
+		    || iocfc->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&iocfc->stats_timer);
+		iocfc->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(bfa, &iocfc->stats_hcb_qe,
+			      bfa_iocfc_stats_clr_cb, bfa);
+		break;
+	case BFI_IOCFC_I2H_UPDATEQ_RSP:
+		iocfc->updateq_cbfn(iocfc->updateq_cbarg, BFA_STATUS_OK);
+		break;
+	default:
+		bfa_assert(0);
+	}
+}
+
+#ifndef BFA_BIOS_BUILD
+void
+bfa_adapter_get_attr(struct bfa_s *bfa, struct bfa_adapter_attr_s *ad_attr)
+{
+	bfa_ioc_get_adapter_attr(&bfa->ioc, ad_attr);
+}
+
+u64
+bfa_adapter_get_id(struct bfa_s *bfa)
+{
+	return bfa_ioc_get_adid(&bfa->ioc);
+}
+
+void
+bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	attr->intr_attr = iocfc->cfginfo->intr_attr;
+	attr->config	= iocfc->cfg;
+}
+
+bfa_status_t
+bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
+{
+	struct bfa_iocfc_s		*iocfc = &bfa->iocfc;
+	struct bfi_iocfc_set_intr_req_s *m;
+
+	iocfc->cfginfo->intr_attr = *attr;
+	if (!bfa_iocfc_is_operational(bfa))
+		return BFA_STATUS_OK;
+
+	m = bfa_reqq_next(bfa, BFA_REQQ_IOC);
+	if (!m)
+		return BFA_STATUS_DEVBUSY;
+
+	bfi_h2i_set(m->mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_SET_INTR_REQ,
+			bfa_lpuid(bfa));
+	m->coalesce = attr->coalesce;
+	m->delay    = bfa_os_htons(attr->delay);
+	m->latency  = bfa_os_htons(attr->latency);
+
+	bfa_trc(bfa, attr->delay);
+	bfa_trc(bfa, attr->latency);
+
+	bfa_reqq_produce(bfa, BFA_REQQ_IOC);
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa)
+{
+	struct bfa_iocfc_s      *iocfc = &bfa->iocfc;
+
+	iocfc->cfginfo->sense_buf_len = (BFI_IOIM_SNSLEN - 1);
+	bfa_dma_be_addr_set(iocfc->cfginfo->ioim_snsbase, snsbase_pa);
+}
+
+bfa_status_t
+bfa_iocfc_get_stats(struct bfa_s *bfa, struct bfa_iocfc_stats_s *stats,
+		      bfa_cb_ioc_t cbfn, void *cbarg)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	if (iocfc->stats_busy) {
+		bfa_trc(bfa, iocfc->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	iocfc->stats_busy = BFA_TRUE;
+	iocfc->stats_ret = stats;
+	iocfc->stats_cbfn = cbfn;
+	iocfc->stats_cbarg = cbarg;
+
+	bfa_iocfc_stats_query(bfa);
+
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_iocfc_clear_stats(struct bfa_s *bfa, bfa_cb_ioc_t cbfn, void *cbarg)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	if (iocfc->stats_busy) {
+		bfa_trc(bfa, iocfc->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	iocfc->stats_busy = BFA_TRUE;
+	iocfc->stats_cbfn = cbfn;
+	iocfc->stats_cbarg = cbarg;
+
+	bfa_iocfc_stats_clear(bfa);
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Enable IOC after it is disabled.
+ */
+void
+bfa_iocfc_enable(struct bfa_s *bfa)
+{
+	bfa_plog_str(bfa->plog, BFA_PL_MID_HAL, BFA_PL_EID_MISC, 0,
+		     "IOC Enable");
+	bfa_ioc_enable(&bfa->ioc);
+}
+
+void
+bfa_iocfc_disable(struct bfa_s *bfa)
+{
+	bfa_plog_str(bfa->plog, BFA_PL_MID_HAL, BFA_PL_EID_MISC, 0,
+		     "IOC Disable");
+	bfa->iocfc.action = BFA_IOCFC_ACT_DISABLE;
+
+	bfa->rme_process = BFA_FALSE;
+	bfa_ioc_disable(&bfa->ioc);
+}
+
+
+bfa_boolean_t
+bfa_iocfc_is_operational(struct bfa_s *bfa)
+{
+	return bfa_ioc_is_operational(&bfa->ioc) && bfa->iocfc.cfgdone;
+}
+
+/**
+ * Return boot target port wwns -- read from boot information in flash.
+ */
+void
+bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns)
+{
+	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
+
+	*nwwns = cfgrsp->bootwwns.nwwns;
+	*wwns = cfgrsp->bootwwns.wwn;
+}
+
+#endif
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.h patch/drivers/scsi/bfa/bfa_iocfc.h
--- orig/drivers/scsi/bfa/bfa_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_iocfc.h	2009-08-19 17:47:57.000000000 -0700
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
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

