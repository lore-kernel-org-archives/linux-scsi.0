From: <kgudipat@brocade.com>
Subject: [PATCH 10/33] bfa: (Cleanup Patch) Remove the per BFA sub-module header files.
Date: Wed, 15 Sep 2010 12:01:43 -0700
Message-ID: <1284577303-16815-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:57073 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab0IOTCq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:02:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- This patch is part of the BFA cleanup.
	- Removing per BFA sub-module (sgpg/fcport/rport/uf/lps/fcxp) header files
	  will be merging them to bfa_svc.h in the patchset.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcxp_priv.h  |  138 -------------------------------------
 drivers/scsi/bfa/bfa_lps_priv.h   |   38 ----------
 drivers/scsi/bfa/bfa_port_priv.h  |   94 -------------------------
 drivers/scsi/bfa/bfa_rport_priv.h |   45 ------------
 drivers/scsi/bfa/bfa_sgpg_priv.h  |   79 ---------------------
 drivers/scsi/bfa/bfa_uf_priv.h    |   47 -------------
 6 files changed, 0 insertions(+), 441 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfa_fcxp_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_lps_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_port_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_rport_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_sgpg_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_uf_priv.h

diff --git a/drivers/scsi/bfa/bfa_fcxp_priv.h b/drivers/scsi/bfa/bfa_fcxp_priv.h
deleted file mode 100644
index 4cda493..0000000
--- a/drivers/scsi/bfa/bfa_fcxp_priv.h
+++ /dev/null
@@ -1,138 +0,0 @@
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
-#ifndef __BFA_FCXP_PRIV_H__
-#define __BFA_FCXP_PRIV_H__
-
-#include <cs/bfa_sm.h>
-#include <protocol/fc.h>
-#include <bfa_svc.h>
-#include <bfi/bfi_fcxp.h>
-
-#define BFA_FCXP_MIN     	(1)
-#define BFA_FCXP_MAX_IBUF_SZ	(2 * 1024 + 256)
-#define BFA_FCXP_MAX_LBUF_SZ	(4 * 1024 + 256)
-
-struct bfa_fcxp_mod_s {
-	struct bfa_s      *bfa;		/*  backpointer to BFA */
-	struct bfa_fcxp_s *fcxp_list;	/*  array of FCXPs */
-	u16        num_fcxps;	/*  max num FCXP requests */
-	struct list_head fcxp_free_q;	/*  free FCXPs */
-	struct list_head fcxp_active_q;	/*  active FCXPs */
-	void	*req_pld_list_kva;	/*  list of FCXP req pld */
-	u64 req_pld_list_pa;	/*  list of FCXP req pld */
-	void *rsp_pld_list_kva;		/*  list of FCXP resp pld */
-	u64 rsp_pld_list_pa;	/*  list of FCXP resp pld */
-	struct list_head  wait_q;		/*  wait queue for free fcxp */
-	u32	req_pld_sz;
-	u32	rsp_pld_sz;
-};
-
-#define BFA_FCXP_MOD(__bfa)		(&(__bfa)->modules.fcxp_mod)
-#define BFA_FCXP_FROM_TAG(__mod, __tag)	(&(__mod)->fcxp_list[__tag])
-
-typedef void    (*fcxp_send_cb_t) (struct bfa_s *ioc, struct bfa_fcxp_s *fcxp,
-				   void *cb_arg, bfa_status_t req_status,
-				   u32 rsp_len, u32 resid_len,
-				   struct fchs_s *rsp_fchs);
-
-/**
- * Information needed for a FCXP request
- */
-struct bfa_fcxp_req_info_s {
-	struct bfa_rport_s *bfa_rport;	/*  Pointer to the bfa rport that was
-					 *returned from bfa_rport_create().
-					 *This could be left NULL for WKA or for
-					 *FCXP interactions before the rport
-					 *nexus is established
-					 */
-	struct fchs_s   fchs;	/*  request FC header structure */
-	u8 cts;		/*  continous sequence */
-	u8 class;		/*  FC class for the request/response */
-	u16 max_frmsz;	/*  max send frame size */
-	u16 vf_id;		/*  vsan tag if applicable */
-	u8	lp_tag;		/*  lport tag */
-	u32 req_tot_len;	/*  request payload total length */
-};
-
-struct bfa_fcxp_rsp_info_s {
-	struct fchs_s rsp_fchs;		/*  Response frame's FC header will
-					 * be *sent back in this field */
-	u8         rsp_timeout;	/*  timeout in seconds, 0-no response
-					 */
-	u8         rsvd2[3];
-	u32        rsp_maxlen;	/*  max response length expected */
-};
-
-struct bfa_fcxp_s {
-	struct list_head 	qe;		/*  fcxp queue element */
-	bfa_sm_t        sm;             /*  state machine */
-	void           	*caller;	/*  driver or fcs */
-	struct bfa_fcxp_mod_s *fcxp_mod;
-					/*  back pointer to fcxp mod */
-	u16        fcxp_tag;	/*  internal tag */
-	struct bfa_fcxp_req_info_s req_info;
-					/*  request info */
-	struct bfa_fcxp_rsp_info_s rsp_info;
-					/*  response info */
-	u8 	use_ireqbuf;	/*  use internal req buf */
-	u8         use_irspbuf;	/*  use internal rsp buf */
-	u32        nreq_sgles;	/*  num request SGLEs */
-	u32        nrsp_sgles;	/*  num response SGLEs */
-	struct list_head req_sgpg_q;	/*  SG pages for request buf */
-	struct list_head req_sgpg_wqe;	/*  wait queue for req SG page */
-	struct list_head rsp_sgpg_q;	/*  SG pages for response buf */
-	struct list_head rsp_sgpg_wqe;	/*  wait queue for rsp SG page */
-
-	bfa_fcxp_get_sgaddr_t req_sga_cbfn;
-					/*  SG elem addr user function */
-	bfa_fcxp_get_sglen_t req_sglen_cbfn;
-					/*  SG elem len user function */
-	bfa_fcxp_get_sgaddr_t rsp_sga_cbfn;
-					/*  SG elem addr user function */
-	bfa_fcxp_get_sglen_t rsp_sglen_cbfn;
-					/*  SG elem len user function */
-	bfa_cb_fcxp_send_t send_cbfn;   /*  send completion callback */
-	void		*send_cbarg;	/*  callback arg */
-	struct bfa_sge_s   req_sge[BFA_FCXP_MAX_SGES];
-					/*  req SG elems */
-	struct bfa_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];
-					/*  rsp SG elems */
-	u8         rsp_status;	/*  comp: rsp status */
-	u32        rsp_len;	/*  comp: actual response len */
-	u32        residue_len;	/*  comp: residual rsp length */
-	struct fchs_s          rsp_fchs;	/*  comp: response fchs */
-	struct bfa_cb_qe_s    hcb_qe;	/*  comp: callback qelem */
-	struct bfa_reqq_wait_s	reqq_wqe;
-	bfa_boolean_t	reqq_waiting;
-};
-
-#define BFA_FCXP_REQ_PLD(_fcxp) 	(bfa_fcxp_get_reqbuf(_fcxp))
-
-#define BFA_FCXP_RSP_FCHS(_fcxp) 	(&((_fcxp)->rsp_info.fchs))
-#define BFA_FCXP_RSP_PLD(_fcxp) 	(bfa_fcxp_get_rspbuf(_fcxp))
-
-#define BFA_FCXP_REQ_PLD_PA(_fcxp)					\
-	((_fcxp)->fcxp_mod->req_pld_list_pa +				\
-		((_fcxp)->fcxp_mod->req_pld_sz  * (_fcxp)->fcxp_tag))
-
-#define BFA_FCXP_RSP_PLD_PA(_fcxp) 					\
-	((_fcxp)->fcxp_mod->rsp_pld_list_pa +				\
-		((_fcxp)->fcxp_mod->rsp_pld_sz * (_fcxp)->fcxp_tag))
-
-void	bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-#endif /* __BFA_FCXP_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_lps_priv.h b/drivers/scsi/bfa/bfa_lps_priv.h
deleted file mode 100644
index d16c6ce..0000000
--- a/drivers/scsi/bfa/bfa_lps_priv.h
+++ /dev/null
@@ -1,38 +0,0 @@
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
-#ifndef __BFA_LPS_PRIV_H__
-#define __BFA_LPS_PRIV_H__
-
-#include <bfa_svc.h>
-
-struct bfa_lps_mod_s {
-	struct list_head		lps_free_q;
-	struct list_head		lps_active_q;
-	struct bfa_lps_s	*lps_arr;
-	int			num_lps;
-};
-
-#define BFA_LPS_MOD(__bfa)		(&(__bfa)->modules.lps_mod)
-#define BFA_LPS_FROM_TAG(__mod, __tag)	(&(__mod)->lps_arr[__tag])
-
-/*
- * external functions
- */
-void	bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-
-#endif /* __BFA_LPS_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_port_priv.h b/drivers/scsi/bfa/bfa_port_priv.h
deleted file mode 100644
index c9ebe04..0000000
--- a/drivers/scsi/bfa/bfa_port_priv.h
+++ /dev/null
@@ -1,94 +0,0 @@
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
-#ifndef __BFA_PORT_PRIV_H__
-#define __BFA_PORT_PRIV_H__
-
-#include <defs/bfa_defs_pport.h>
-#include <bfi/bfi_pport.h>
-#include "bfa_intr_priv.h"
-
-/**
- * Link notification data structure
- */
-struct bfa_fcport_ln_s {
-	struct bfa_fcport_s     *fcport;
-	bfa_sm_t                sm;
-	struct bfa_cb_qe_s      ln_qe;  /*  BFA callback queue elem for ln */
-	enum bfa_pport_linkstate ln_event; /*  ln event for callback */
-};
-
-/**
- * BFA FC port data structure
- */
-struct bfa_fcport_s {
-	struct bfa_s 		*bfa;	/*  parent BFA instance */
-	bfa_sm_t		sm;	/*  port state machine */
-	wwn_t			nwwn;	/*  node wwn of physical port */
-	wwn_t			pwwn;	/*  port wwn of physical oprt */
-	enum bfa_pport_speed speed_sup;
-					/*  supported speeds */
-	enum bfa_pport_speed speed;	/*  current speed */
-	enum bfa_pport_topology topology;	/*  current topology */
-	u8			myalpa;	/*  my ALPA in LOOP topology */
-	u8			rsvd[3];
-	u32             mypid:24;
-	u32             rsvd_b:8;
-	struct bfa_pport_cfg_s	cfg;	/*  current port configuration */
-	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
-	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
-	struct bfa_reqq_wait_s	reqq_wait;
-					/*  to wait for room in reqq */
-	struct bfa_reqq_wait_s	svcreq_wait;
-					/*  to wait for room in reqq */
-	struct bfa_reqq_wait_s	stats_reqq_wait;
-					/*  to wait for room in reqq (stats) */
-	void			*event_cbarg;
-	void			(*event_cbfn) (void *cbarg,
-						bfa_pport_event_t event);
-	union {
-		union bfi_fcport_i2h_msg_u i2hmsg;
-	} event_arg;
-	void			*bfad;	/*  BFA driver handle */
-	struct bfa_fcport_ln_s   ln; /* Link Notification */
-	struct bfa_cb_qe_s		hcb_qe;	/*  BFA callback queue elem */
-	struct bfa_timer_s      timer;  /*  timer */
-	u32		msgtag;	/*  fimrware msg tag for reply */
-	u8			*stats_kva;
-	u64		stats_pa;
-	union bfa_fcport_stats_u *stats;
-	union bfa_fcport_stats_u *stats_ret; /*  driver stats location */
-	bfa_status_t            stats_status; /*  stats/statsclr status */
-	bfa_boolean_t           stats_busy; /*  outstanding stats/statsclr */
-	bfa_boolean_t           stats_qfull;
-	u32                	stats_reset_time; /* stats reset time stamp */
-	bfa_cb_pport_t          stats_cbfn; /*  driver callback function */
-	void                    *stats_cbarg; /* user callback arg */
-	bfa_boolean_t           diag_busy; /*  diag busy status */
-	bfa_boolean_t           beacon; /*  port beacon status */
-	bfa_boolean_t           link_e2e_beacon; /*  link beacon status */
-};
-
-#define BFA_FCPORT_MOD(__bfa)	(&(__bfa)->modules.fcport)
-
-/*
- * public functions
- */
-void bfa_fcport_init(struct bfa_s *bfa);
-void bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-
-#endif /* __BFA_PORT_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_rport_priv.h b/drivers/scsi/bfa/bfa_rport_priv.h
deleted file mode 100644
index 6490ce2..0000000
--- a/drivers/scsi/bfa/bfa_rport_priv.h
+++ /dev/null
@@ -1,45 +0,0 @@
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
-#ifndef __BFA_RPORT_PRIV_H__
-#define __BFA_RPORT_PRIV_H__
-
-#include <bfa_svc.h>
-
-#define BFA_RPORT_MIN	4
-
-struct bfa_rport_mod_s {
-	struct bfa_rport_s *rps_list;	/*  list of rports	*/
-	struct list_head 	rp_free_q;	/*  free bfa_rports	*/
-	struct list_head 	rp_active_q;	/*  free bfa_rports 	*/
-	u16	num_rports;	/*  number of rports	*/
-};
-
-#define BFA_RPORT_MOD(__bfa)	(&(__bfa)->modules.rport_mod)
-
-/**
- * Convert rport tag to RPORT
- */
-#define BFA_RPORT_FROM_TAG(__bfa, _tag)				\
-	(BFA_RPORT_MOD(__bfa)->rps_list +				\
-	 ((_tag) & (BFA_RPORT_MOD(__bfa)->num_rports - 1)))
-
-/*
- * external functions
- */
-void	bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-#endif /* __BFA_RPORT_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_sgpg_priv.h b/drivers/scsi/bfa/bfa_sgpg_priv.h
deleted file mode 100644
index 9c2a8cb..0000000
--- a/drivers/scsi/bfa/bfa_sgpg_priv.h
+++ /dev/null
@@ -1,79 +0,0 @@
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
- *  hal_sgpg.h BFA SG page module
- */
-
-#ifndef __BFA_SGPG_PRIV_H__
-#define __BFA_SGPG_PRIV_H__
-
-#include <cs/bfa_q.h>
-
-#define BFA_SGPG_MIN	(16)
-
-/**
- * Alignment macro for SG page allocation
- */
-#define BFA_SGPG_ROUNDUP(_l) (((_l) + (sizeof(struct bfi_sgpg_s) - 1)) \
-			& ~(sizeof(struct bfi_sgpg_s) - 1))
-
-struct bfa_sgpg_wqe_s {
-	struct list_head qe;	/*  queue sg page element	*/
-	int	nsgpg;		/*  pages to be allocated	*/
-	int	nsgpg_total;	/*  total pages required	*/
-	void	(*cbfn) (void *cbarg);
-				/*  callback function		*/
-	void	*cbarg;		/*  callback arg		*/
-	struct list_head sgpg_q;	/*  queue of alloced sgpgs	*/
-};
-
-struct bfa_sgpg_s {
-	struct list_head 	qe;	/*  queue sg page element	*/
-	struct bfi_sgpg_s *sgpg; /*  va of SG page		*/
-	union bfi_addr_u sgpg_pa;/*  pa of SG page		*/
-};
-
-/**
- * Given number of SG elements, BFA_SGPG_NPAGE() returns the number of
- * SG pages required.
- */
-#define BFA_SGPG_NPAGE(_nsges)  (((_nsges) / BFI_SGPG_DATA_SGES) + 1)
-
-struct bfa_sgpg_mod_s {
-	struct bfa_s *bfa;
-	int		num_sgpgs;	/*  number of SG pages		*/
-	int		free_sgpgs;	/*  number of free SG pages	*/
-	struct bfa_sgpg_s *hsgpg_arr;	/*  BFA SG page array	*/
-	struct bfi_sgpg_s *sgpg_arr;	/*  actual SG page array	*/
-	u64	sgpg_arr_pa;	/*  SG page array DMA addr	*/
-	struct list_head sgpg_q;	/*  queue of free SG pages	*/
-	struct list_head sgpg_wait_q; /*  wait queue for SG pages	*/
-};
-#define BFA_SGPG_MOD(__bfa)	(&(__bfa)->modules.sgpg_mod)
-
-bfa_status_t	bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q,
-								int nsgpgs);
-void		bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q,
-								int nsgpgs);
-void		bfa_sgpg_winit(struct bfa_sgpg_wqe_s *wqe,
-				   void (*cbfn) (void *cbarg), void *cbarg);
-void		bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe,
-								int nsgpgs);
-void		bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe);
-
-#endif /* __BFA_SGPG_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_uf_priv.h b/drivers/scsi/bfa/bfa_uf_priv.h
deleted file mode 100644
index bcb490f..0000000
--- a/drivers/scsi/bfa/bfa_uf_priv.h
+++ /dev/null
@@ -1,47 +0,0 @@
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
-#ifndef __BFA_UF_PRIV_H__
-#define __BFA_UF_PRIV_H__
-
-#include <cs/bfa_sm.h>
-#include <bfa_svc.h>
-#include <bfi/bfi_uf.h>
-
-#define BFA_UF_MIN	(4)
-
-struct bfa_uf_mod_s {
-	struct bfa_s *bfa;		/*  back pointer to BFA */
-	struct bfa_uf_s *uf_list;	/*  array of UFs */
-	u16	num_ufs;	/*  num unsolicited rx frames */
-	struct list_head 	uf_free_q;	/*  free UFs */
-	struct list_head 	uf_posted_q;	/*  UFs posted to IOC */
-	struct bfa_uf_buf_s *uf_pbs_kva;	/*  list UF bufs request pld */
-	u64	uf_pbs_pa;	/*  phy addr for UF bufs */
-	struct bfi_uf_buf_post_s *uf_buf_posts;
-					/*  pre-built UF post msgs */
-	bfa_cb_uf_recv_t ufrecv;	/*  uf recv handler function */
-	void		*cbarg;		/*  uf receive handler arg */
-};
-
-#define BFA_UF_MOD(__bfa)	(&(__bfa)->modules.uf_mod)
-
-#define ufm_pbs_pa(_ufmod, _uftag)	\
-	((_ufmod)->uf_pbs_pa + sizeof(struct bfa_uf_buf_s) * (_uftag))
-
-void	bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-
-#endif /* __BFA_UF_PRIV_H__ */
-- 
1.7.3.rc1

