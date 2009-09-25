From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/4] bfa: fixed checkpatch errors for bfa files
Date: Fri, 25 Sep 2009 12:30:19 -0700
Message-ID: <200909251930.n8PJUJuo012199@swe58.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:58276 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZIYTaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 15:30:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch fixes checkpatch errors/warnings in bfa files.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_cb_ioim_macros.h |   10 ++++----
 bfa_cee.c            |    2 -
 bfa_csdebug.c        |    4 +--
 bfa_fcpim.c          |    4 +--
 bfa_fcpim_priv.h     |    4 +--
 bfa_fcport.c         |   59 ++++++++++++++++++++++++---------------------------
 bfa_fcs_lport.c      |   11 ++++-----
 bfa_fcxp.c           |    8 +++---
 bfa_intr.c           |    2 -
 bfa_intr_priv.h      |   18 ++++++++-------
 bfa_ioc.c            |   10 ++++----
 bfa_ioc.h            |   12 +++++-----
 bfa_iocfc.c          |    8 +++---
 bfa_iocfc.h          |    8 +++---
 bfa_ioim.c           |    4 +--
 bfa_itnim.c          |    6 ++---
 bfa_log.c            |    4 +--
 bfa_port_priv.h      |    4 +--
 bfa_rport.c          |    6 ++---
 bfa_tskim.c          |    9 ++++---
 bfa_uf.c             |    2 -
 21 files changed, 97 insertions(+), 98 deletions(-)

diff -urpN orig/drivers/scsi/bfa/bfa_cb_ioim_macros.h patch/drivers/scsi/bfa/bfa_cb_ioim_macros.h
--- orig/drivers/scsi/bfa/bfa_cb_ioim_macros.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_cb_ioim_macros.h	2009-09-24 23:41:15.000000000 -0700
@@ -51,7 +51,7 @@ bfad_int_to_lun(u32 luno)
 	lun.bfa_lun     = 0;
 	lun.scsi_lun[0] = bfa_os_htons(luno);
 
-	return (lun.bfa_lun);
+	return lun.bfa_lun;
 }
 
 /**
@@ -68,7 +68,7 @@ bfa_cb_ioim_get_cdb(struct bfad_ioim_s *
 {
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
 
-	return ((u8 *) cmnd->cmnd);
+	return (u8 *) cmnd->cmnd;
 }
 
 /**
@@ -97,7 +97,7 @@ bfa_cb_ioim_get_size(struct bfad_ioim_s 
 {
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
 
-	return (scsi_bufflen(cmnd));
+	return scsi_bufflen(cmnd);
 }
 
 /**
@@ -129,7 +129,7 @@ bfa_cb_ioim_get_sgaddr(struct bfad_ioim_
 	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
 	addr = (u64) sg_dma_address(sge);
 
-	return (*(union bfi_addr_u *) &addr);
+	return *((union bfi_addr_u *) &addr);
 }
 
 static inline u32
@@ -197,7 +197,7 @@ bfa_cb_ioim_get_cdblen(struct bfad_ioim_
 {
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
 
-	return (cmnd->cmd_len);
+	return cmnd->cmd_len;
 }
 
 
diff -urpN orig/drivers/scsi/bfa/bfa_cee.c patch/drivers/scsi/bfa/bfa_cee.c
--- orig/drivers/scsi/bfa/bfa_cee.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_cee.c	2009-09-24 23:41:15.000000000 -0700
@@ -228,7 +228,7 @@ bfa_cee_reset_stats_isr(struct bfa_cee_s
 u32
 bfa_cee_meminfo(void)
 {
-	return (bfa_cee_attr_meminfo() + bfa_cee_stats_meminfo());
+	return bfa_cee_attr_meminfo() + bfa_cee_stats_meminfo();
 }
 
 /**
diff -urpN orig/drivers/scsi/bfa/bfa_csdebug.c patch/drivers/scsi/bfa/bfa_csdebug.c
--- orig/drivers/scsi/bfa/bfa_csdebug.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_csdebug.c	2009-09-24 23:41:15.000000000 -0700
@@ -47,12 +47,12 @@ bfa_q_is_on_q_func(struct list_head *q, 
 	tqe = bfa_q_next(q);
 	while (tqe != q) {
 		if (tqe == qe)
-			return (1);
+			return 1;
 		tqe = bfa_q_next(tqe);
 		if (tqe == NULL)
 			break;
 	}
-	return (0);
+	return 0;
 }
 
 
diff -urpN orig/drivers/scsi/bfa/bfa_fcpim.c patch/drivers/scsi/bfa/bfa_fcpim.c
--- orig/drivers/scsi/bfa/bfa_fcpim.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_fcpim.c	2009-09-24 23:41:15.000000000 -0700
@@ -131,7 +131,7 @@ bfa_fcpim_path_tov_get(struct bfa_s *bfa
 {
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
 
-	return (fcpim->path_tov / 1000);
+	return fcpim->path_tov / 1000;
 }
 
 bfa_status_t
@@ -169,7 +169,7 @@ bfa_fcpim_qdepth_get(struct bfa_s *bfa)
 {
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
 
-	return (fcpim->q_depth);
+	return fcpim->q_depth;
 }
 
 
diff -urpN orig/drivers/scsi/bfa/bfa_fcpim_priv.h patch/drivers/scsi/bfa/bfa_fcpim_priv.h
--- orig/drivers/scsi/bfa/bfa_fcpim_priv.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_fcpim_priv.h	2009-09-24 23:41:15.000000000 -0700
@@ -35,7 +35,7 @@
 #define BFA_FCPIM_PATHTOV_MAX	(90 * 1000)	/* in millisecs */
 
 #define bfa_fcpim_stats(__fcpim, __stats)   \
-    (__fcpim)->stats.__stats ++
+    ((__fcpim)->stats.__stats++)
 
 struct bfa_fcpim_mod_s {
 	struct bfa_s 	*bfa;
@@ -143,7 +143,7 @@ struct bfa_itnim_s {
 	struct bfa_itnim_hal_stats_s	stats;
 };
 
-#define bfa_itnim_is_online(_itnim) (_itnim)->is_online
+#define bfa_itnim_is_online(_itnim) ((_itnim)->is_online)
 #define BFA_FCPIM_MOD(_hal) (&(_hal)->modules.fcpim_mod)
 #define BFA_IOIM_FROM_TAG(_fcpim, _iotag)	\
 	(&fcpim->ioim_arr[_iotag])
diff -urpN orig/drivers/scsi/bfa/bfa_fcport.c patch/drivers/scsi/bfa/bfa_fcport.c
--- orig/drivers/scsi/bfa/bfa_fcport.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_fcport.c	2009-09-24 23:41:15.000000000 -0700
@@ -388,32 +388,29 @@ bfa_pport_sm_linkup(struct bfa_pport_s *
 		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
 		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
 			     BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
-		if (BFA_PORT_IS_DISABLED(pport->bfa)) {
+		if (BFA_PORT_IS_DISABLED(pport->bfa))
 			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
-		} else {
+		else
 			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
-		}
 		break;
 
 	case BFA_PPORT_SM_STOP:
 		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
 		bfa_pport_reset_linkinfo(pport);
-		if (BFA_PORT_IS_DISABLED(pport->bfa)) {
+		if (BFA_PORT_IS_DISABLED(pport->bfa))
 			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
-		} else {
+		else
 			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
-		}
 		break;
 
 	case BFA_PPORT_SM_HWFAIL:
 		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
 		bfa_pport_reset_linkinfo(pport);
 		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
-		if (BFA_PORT_IS_DISABLED(pport->bfa)) {
+		if (BFA_PORT_IS_DISABLED(pport->bfa))
 			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
-		} else {
+		else
 			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
-		}
 		break;
 
 	default:
@@ -999,10 +996,10 @@ bfa_pport_enable(struct bfa_s *bfa)
 	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
 
 	if (pport->diag_busy)
-		return (BFA_STATUS_DIAG_BUSY);
+		return BFA_STATUS_DIAG_BUSY;
 	else if (bfa_sm_cmp_state
 		 (BFA_PORT_MOD(bfa), bfa_pport_sm_disabling_qwait))
-		return (BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
 
 	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_ENABLE);
 	return BFA_STATUS_OK;
@@ -1032,7 +1029,7 @@ bfa_pport_cfg_speed(struct bfa_s *bfa, e
 
 	pport->cfg.speed = speed;
 
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 /**
@@ -1068,7 +1065,7 @@ bfa_pport_cfg_topology(struct bfa_s *bfa
 	}
 
 	pport->cfg.topology = topology;
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 /**
@@ -1094,7 +1091,7 @@ bfa_pport_cfg_hardalpa(struct bfa_s *bfa
 	pport->cfg.cfg_hardalpa = BFA_TRUE;
 	pport->cfg.hardalpa = alpa;
 
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 bfa_status_t
@@ -1106,7 +1103,7 @@ bfa_pport_clr_hardalpa(struct bfa_s *bfa
 	bfa_trc(bfa, pport->cfg.hardalpa);
 
 	pport->cfg.cfg_hardalpa = BFA_FALSE;
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 bfa_boolean_t
@@ -1138,16 +1135,16 @@ bfa_pport_cfg_maxfrsize(struct bfa_s *bf
 	 * with in range
 	 */
 	if ((maxfrsize > FC_MAX_PDUSZ) || (maxfrsize < FC_MIN_PDUSZ))
-		return (BFA_STATUS_INVLD_DFSZ);
+		return BFA_STATUS_INVLD_DFSZ;
 
 	/*
 	 * power of 2, if not the max frame size of 2112
 	 */
 	if ((maxfrsize != FC_MAX_PDUSZ) && (maxfrsize & (maxfrsize - 1)))
-		return (BFA_STATUS_INVLD_DFSZ);
+		return BFA_STATUS_INVLD_DFSZ;
 
 	pport->cfg.maxfrsize = maxfrsize;
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 u16
@@ -1415,7 +1412,7 @@ bfa_pport_get_stats(struct bfa_s *bfa, u
 
 	if (port->stats_busy) {
 		bfa_trc(bfa, port->stats_busy);
-		return (BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
 	}
 
 	port->stats_busy = BFA_TRUE;
@@ -1427,7 +1424,7 @@ bfa_pport_get_stats(struct bfa_s *bfa, u
 
 	bfa_timer_start(bfa, &port->timer, bfa_port_stats_timeout, port,
 			BFA_PORT_STATS_TOV);
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 bfa_status_t
@@ -1437,7 +1434,7 @@ bfa_pport_clear_stats(struct bfa_s *bfa,
 
 	if (port->stats_busy) {
 		bfa_trc(bfa, port->stats_busy);
-		return (BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
 	}
 
 	port->stats_busy = BFA_TRUE;
@@ -1448,7 +1445,7 @@ bfa_pport_clear_stats(struct bfa_s *bfa,
 
 	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
 			BFA_PORT_STATS_TOV);
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 bfa_status_t
@@ -1515,7 +1512,7 @@ bfa_pport_get_qos_stats(struct bfa_s *bf
 	/*
 	 * QoS stats is embedded in port stats
 	 */
-	return (bfa_pport_get_stats(bfa, stats, cbfn, cbarg));
+	return bfa_pport_get_stats(bfa, stats, cbfn, cbarg);
 }
 
 bfa_status_t
@@ -1525,7 +1522,7 @@ bfa_pport_clear_qos_stats(struct bfa_s *
 
 	if (port->stats_busy) {
 		bfa_trc(bfa, port->stats_busy);
-		return (BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
 	}
 
 	port->stats_busy = BFA_TRUE;
@@ -1536,7 +1533,7 @@ bfa_pport_clear_qos_stats(struct bfa_s *
 
 	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout, port,
 			BFA_PORT_STATS_TOV);
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 /**
@@ -1545,7 +1542,7 @@ bfa_pport_clear_qos_stats(struct bfa_s *
 bfa_status_t
 bfa_pport_trunk_disable(struct bfa_s *bfa)
 {
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 bfa_boolean_t
@@ -1562,8 +1559,8 @@ bfa_pport_is_disabled(struct bfa_s *bfa)
 {
 	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
 
-	return (bfa_sm_to_state(hal_pport_sm_table, port->sm) ==
-		BFA_PPORT_ST_DISABLED);
+	return bfa_sm_to_state(hal_pport_sm_table, port->sm) ==
+		BFA_PPORT_ST_DISABLED;
 
 }
 
@@ -1572,7 +1569,7 @@ bfa_pport_is_ratelim(struct bfa_s *bfa)
 {
 	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
 
-return (pport->cfg.ratelimit ? BFA_TRUE : BFA_FALSE);
+	return pport->cfg.ratelimit ? BFA_TRUE : BFA_FALSE;
 
 }
 
@@ -1620,7 +1617,7 @@ bfa_pport_cfg_ratelim_speed(struct bfa_s
 
 	pport->cfg.trl_def_speed = speed;
 
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 /**
@@ -1632,7 +1629,7 @@ bfa_pport_get_ratelim_speed(struct bfa_s
 	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
 
 	bfa_trc(bfa, pport->cfg.trl_def_speed);
-	return (pport->cfg.trl_def_speed);
+	return pport->cfg.trl_def_speed;
 
 }
 
diff -urpN orig/drivers/scsi/bfa/bfa_fcs_lport.c patch/drivers/scsi/bfa/bfa_fcs_lport.c
--- orig/drivers/scsi/bfa/bfa_fcs_lport.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_fcs_lport.c	2009-09-24 23:41:15.000000000 -0700
@@ -568,11 +568,10 @@ bfa_fcs_port_offline_actions(struct bfa_
 
 	__port_action[port->fabric->fab_type].offline(port);
 
-	if (bfa_fcs_fabric_is_online(port->fabric) == BFA_TRUE) {
+	if (bfa_fcs_fabric_is_online(port->fabric) == BFA_TRUE)
 		bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_DISCONNECT);
-	} else {
+	else
 		bfa_fcs_port_aen_post(port, BFA_LPORT_AEN_OFFLINE);
-	}
 	bfa_fcb_port_offline(port->fcs->bfad, port->port_cfg.roles,
 			port->fabric->vf_drv,
 			(port->vport == NULL) ? NULL : port->vport->vport_drv);
@@ -777,7 +776,7 @@ bfa_fcs_port_get_rport_by_pwwn(struct bf
 	}
 
 	bfa_trc(port->fcs, pwwn);
-	return (NULL);
+	return NULL;
 }
 
 /**
@@ -796,7 +795,7 @@ bfa_fcs_port_get_rport_by_nwwn(struct bf
 	}
 
 	bfa_trc(port->fcs, nwwn);
-	return (NULL);
+	return NULL;
 }
 
 /**
@@ -870,7 +869,7 @@ bfa_fcs_port_lip(struct bfa_fcs_port_s *
 bfa_boolean_t
 bfa_fcs_port_is_online(struct bfa_fcs_port_s *port)
 {
-	return (bfa_sm_cmp_state(port, bfa_fcs_port_sm_online));
+	return bfa_sm_cmp_state(port, bfa_fcs_port_sm_online);
 }
 
 /**
diff -urpN orig/drivers/scsi/bfa/bfa_fcxp.c patch/drivers/scsi/bfa/bfa_fcxp.c
--- orig/drivers/scsi/bfa/bfa_fcxp.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_fcxp.c	2009-09-24 23:41:15.000000000 -0700
@@ -199,7 +199,7 @@ bfa_fcxp_get(struct bfa_fcxp_mod_s *fm)
 	if (fcxp)
 		list_add_tail(&fcxp->qe, &fm->fcxp_active_q);
 
-	return (fcxp);
+	return fcxp;
 }
 
 static void
@@ -503,7 +503,7 @@ bfa_fcxp_alloc(void *caller, struct bfa_
 
 	fcxp = bfa_fcxp_get(BFA_FCXP_MOD(bfa));
 	if (fcxp == NULL)
-		return (NULL);
+		return NULL;
 
 	bfa_trc(bfa, fcxp->fcxp_tag);
 
@@ -568,7 +568,7 @@ bfa_fcxp_alloc(void *caller, struct bfa_
 		}
 	}
 
-	return (fcxp);
+	return fcxp;
 }
 
 /**
@@ -709,7 +709,7 @@ bfa_status_t
 bfa_fcxp_abort(struct bfa_fcxp_s *fcxp)
 {
 	bfa_assert(0);
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 void
diff -urpN orig/drivers/scsi/bfa/bfa_intr.c patch/drivers/scsi/bfa/bfa_intr.c
--- orig/drivers/scsi/bfa/bfa_intr.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_intr.c	2009-09-24 23:41:15.000000000 -0700
@@ -59,7 +59,7 @@ bfa_intx(struct bfa_s *bfa)
 	qintr = intr & __HFN_INT_RME_MASK;
 	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, qintr);
 
-	for (queue = 0; queue < BFI_IOC_MAX_CQS_ASIC; queue ++) {
+	for (queue = 0; queue < BFI_IOC_MAX_CQS_ASIC; queue++) {
 		if (intr & (__HFN_INT_RME_Q0 << queue))
 			bfa_msix_rspq(bfa, queue & (BFI_IOC_MAX_CQS - 1));
 	}
diff -urpN orig/drivers/scsi/bfa/bfa_intr_priv.h patch/drivers/scsi/bfa/bfa_intr_priv.h
--- orig/drivers/scsi/bfa/bfa_intr_priv.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_intr_priv.h	2009-09-24 23:41:15.000000000 -0700
@@ -26,9 +26,9 @@ void bfa_isr_unhandled(struct bfa_s *bfa
 void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
 
 
-#define bfa_reqq_pi(__bfa, __reqq)	(__bfa)->iocfc.req_cq_pi[__reqq]
+#define bfa_reqq_pi(__bfa, __reqq)	((__bfa)->iocfc.req_cq_pi[__reqq])
 #define bfa_reqq_ci(__bfa, __reqq)					\
-	*(u32 *)((__bfa)->iocfc.req_cq_shadow_ci[__reqq].kva)
+	(*(u32 *)((__bfa)->iocfc.req_cq_shadow_ci[__reqq].kva))
 
 #define bfa_reqq_full(__bfa, __reqq)				\
 	(((bfa_reqq_pi(__bfa, __reqq) + 1) &			\
@@ -50,14 +50,16 @@ void bfa_isr_bind(enum bfi_mclass mc, bf
 } while (0)
 
 #define bfa_rspq_pi(__bfa, __rspq)					\
-	*(u32 *)((__bfa)->iocfc.rsp_cq_shadow_pi[__rspq].kva)
+	(*(u32 *)((__bfa)->iocfc.rsp_cq_shadow_pi[__rspq].kva))
 
-#define bfa_rspq_ci(__bfa, __rspq)	(__bfa)->iocfc.rsp_cq_ci[__rspq]
+#define bfa_rspq_ci(__bfa, __rspq)	((__bfa)->iocfc.rsp_cq_ci[__rspq])
 #define bfa_rspq_elem(__bfa, __rspq, __ci)				\
-	&((struct bfi_msg_s *)((__bfa)->iocfc.rsp_cq_ba[__rspq].kva))[__ci]
+	(&((struct bfi_msg_s *)((__bfa)->iocfc.rsp_cq_ba[__rspq].kva))[__ci])
 
-#define CQ_INCR(__index, __size)					\
-			(__index)++; (__index) &= ((__size) - 1)
+#define CQ_INCR(__index, __size) do {					\
+			(__index)++;					\
+			(__index) &= ((__size) - 1);      \
+} while (0)
 
 /**
  * Queue element to wait for room in request queue. FIFO order is
@@ -94,7 +96,7 @@ bfa_reqq_winit(struct bfa_reqq_wait_s *w
 	wqe->cbarg = cbarg;
 }
 
-#define bfa_reqq(__bfa, __reqq)	&(__bfa)->reqq_waitq[__reqq]
+#define bfa_reqq(__bfa, __reqq)	(&(__bfa)->reqq_waitq[__reqq])
 
 /**
  * static inline void
diff -urpN orig/drivers/scsi/bfa/bfa_ioc.c patch/drivers/scsi/bfa/bfa_ioc.c
--- orig/drivers/scsi/bfa/bfa_ioc.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_ioc.c	2009-09-24 23:41:15.000000000 -0700
@@ -51,7 +51,7 @@ BFA_TRC_FILE(HAL, IOC);
 	 (sizeof(struct bfa_trc_mod_s) -			\
 	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
 #define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
-#define bfa_ioc_stats(_ioc, _stats)	(_ioc)->stats._stats ++
+#define bfa_ioc_stats(_ioc, _stats)	((_ioc)->stats._stats++)
 
 #define BFA_FLASH_CHUNK_NO(off)         (off / BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_FLASH_OFFSET_IN_CHUNK(off)  (off % BFI_FLASH_CHUNK_SZ_WORDS)
@@ -1953,8 +1953,8 @@ bfa_ioc_error_isr(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
 {
-	return (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled));
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling)
+		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled);
 }
 
 /**
@@ -1963,9 +1963,9 @@ bfa_ioc_is_disabled(struct bfa_ioc_s *io
 bfa_boolean_t
 bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 {
-	return (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset)
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset)
 		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_fwcheck)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_mismatch));
+		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_mismatch);
 }
 
 #define bfa_ioc_state_disabled(__sm)		\
diff -urpN orig/drivers/scsi/bfa/bfa_ioc.h patch/drivers/scsi/bfa/bfa_ioc.h
--- orig/drivers/scsi/bfa/bfa_ioc.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_ioc.h	2009-09-24 23:41:15.000000000 -0700
@@ -179,16 +179,16 @@ struct bfa_ioc_s {
 	struct bfa_ioc_mbox_mod_s mbox_mod;
 };
 
-#define bfa_ioc_pcifn(__ioc)		(__ioc)->pcidev.pci_func
-#define bfa_ioc_devid(__ioc)		(__ioc)->pcidev.device_id
-#define bfa_ioc_bar0(__ioc)		(__ioc)->pcidev.pci_bar_kva
+#define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
+#define bfa_ioc_devid(__ioc)		((__ioc)->pcidev.device_id)
+#define bfa_ioc_bar0(__ioc)		((__ioc)->pcidev.pci_bar_kva)
 #define bfa_ioc_portid(__ioc)		((__ioc)->port_id)
 #define bfa_ioc_fetch_stats(__ioc, __stats) \
-		((__stats)->drv_stats) = (__ioc)->stats
+		(((__stats)->drv_stats) = (__ioc)->stats)
 #define bfa_ioc_clr_stats(__ioc)	\
 		bfa_os_memset(&(__ioc)->stats, 0, sizeof((__ioc)->stats))
-#define bfa_ioc_maxfrsize(__ioc)	(__ioc)->attr->maxfrsize
-#define bfa_ioc_rx_bbcredit(__ioc)	(__ioc)->attr->rx_bbcredit
+#define bfa_ioc_maxfrsize(__ioc)	((__ioc)->attr->maxfrsize)
+#define bfa_ioc_rx_bbcredit(__ioc)	((__ioc)->attr->rx_bbcredit)
 #define bfa_ioc_speed_sup(__ioc)	\
 	BFI_ADAPTER_GETP(SPEED, (__ioc)->attr->adapter_prop)
 
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.c patch/drivers/scsi/bfa/bfa_iocfc.c
--- orig/drivers/scsi/bfa/bfa_iocfc.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_iocfc.c	2009-09-24 23:41:15.000000000 -0700
@@ -794,7 +794,7 @@ bfa_iocfc_get_stats(struct bfa_s *bfa, s
 
 	if (iocfc->stats_busy) {
 		bfa_trc(bfa, iocfc->stats_busy);
-		return (BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
 	}
 
 	iocfc->stats_busy = BFA_TRUE;
@@ -804,7 +804,7 @@ bfa_iocfc_get_stats(struct bfa_s *bfa, s
 
 	bfa_iocfc_stats_query(bfa);
 
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 bfa_status_t
@@ -814,7 +814,7 @@ bfa_iocfc_clear_stats(struct bfa_s *bfa,
 
 	if (iocfc->stats_busy) {
 		bfa_trc(bfa, iocfc->stats_busy);
-		return (BFA_STATUS_DEVBUSY);
+		return BFA_STATUS_DEVBUSY;
 	}
 
 	iocfc->stats_busy = BFA_TRUE;
@@ -822,7 +822,7 @@ bfa_iocfc_clear_stats(struct bfa_s *bfa,
 	iocfc->stats_cbarg = cbarg;
 
 	bfa_iocfc_stats_clear(bfa);
-	return (BFA_STATUS_OK);
+	return BFA_STATUS_OK;
 }
 
 /**
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.h patch/drivers/scsi/bfa/bfa_iocfc.h
--- orig/drivers/scsi/bfa/bfa_iocfc.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_iocfc.h	2009-09-24 23:41:15.000000000 -0700
@@ -107,13 +107,13 @@ struct bfa_iocfc_s {
 
 #define bfa_lpuid(__bfa)		bfa_ioc_portid(&(__bfa)->ioc)
 #define bfa_msix_init(__bfa, __nvecs)	\
-	(__bfa)->iocfc.hwif.hw_msix_init(__bfa, __nvecs)
+	((__bfa)->iocfc.hwif.hw_msix_init(__bfa, __nvecs))
 #define bfa_msix_install(__bfa)	\
-	(__bfa)->iocfc.hwif.hw_msix_install(__bfa)
+	((__bfa)->iocfc.hwif.hw_msix_install(__bfa))
 #define bfa_msix_uninstall(__bfa)	\
-	(__bfa)->iocfc.hwif.hw_msix_uninstall(__bfa)
+	((__bfa)->iocfc.hwif.hw_msix_uninstall(__bfa))
 #define bfa_isr_mode_set(__bfa, __msix)	\
-	(__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix)
+	((__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix))
 #define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)	\
 	(__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)
 
diff -urpN orig/drivers/scsi/bfa/bfa_ioim.c patch/drivers/scsi/bfa/bfa_ioim.c
--- orig/drivers/scsi/bfa/bfa_ioim.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_ioim.c	2009-09-24 23:41:15.000000000 -0700
@@ -105,13 +105,13 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *io
 				bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 				list_del(&ioim->qe);
 				list_add_tail(&ioim->qe,
-					&ioim->fcpim->ioim_comp_q);
+						&ioim->fcpim->ioim_comp_q);
 				bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
 						__bfa_cb_ioim_pathtov, ioim);
 			} else {
 				list_del(&ioim->qe);
 				list_add_tail(&ioim->qe,
-					&ioim->itnim->pending_q);
+						&ioim->itnim->pending_q);
 			}
 			break;
 		}
diff -urpN orig/drivers/scsi/bfa/bfa_itnim.c patch/drivers/scsi/bfa/bfa_itnim.c
--- orig/drivers/scsi/bfa/bfa_itnim.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_itnim.c	2009-09-24 23:41:15.000000000 -0700
@@ -1029,7 +1029,7 @@ bfa_itnim_create(struct bfa_s *bfa, stru
 	bfa_stats(itnim, creates);
 	bfa_sm_send_event(itnim, BFA_ITNIM_SM_CREATE);
 
-	return (itnim);
+	return itnim;
 }
 
 void
@@ -1061,7 +1061,7 @@ bfa_itnim_offline(struct bfa_itnim_s *it
 bfa_boolean_t
 bfa_itnim_hold_io(struct bfa_itnim_s *itnim)
 {
-	return (
+	return
 		itnim->fcpim->path_tov && itnim->iotov_active &&
 		(bfa_sm_cmp_state(itnim, bfa_itnim_sm_fwcreate) ||
 		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_sler) ||
@@ -1069,7 +1069,7 @@ bfa_itnim_hold_io(struct bfa_itnim_s *it
 		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_fwdelete) ||
 		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_offline) ||
 		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_iocdisable))
-);
+	;
 }
 
 void
diff -urpN orig/drivers/scsi/bfa/bfa_log.c patch/drivers/scsi/bfa/bfa_log.c
--- orig/drivers/scsi/bfa/bfa_log.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_log.c	2009-09-24 23:41:15.000000000 -0700
@@ -231,9 +231,9 @@ bfa_log_get_level(struct bfa_log_mod_s *
 		return BFA_LOG_INVALID;
 
 	if (log_mod)
-		return (log_mod->log_level[mod_id]);
+		return log_mod->log_level[mod_id];
 	else
-		return (bfa_log_info[mod_id].level);
+		return bfa_log_info[mod_id].level;
 }
 
 enum bfa_log_severity
diff -urpN orig/drivers/scsi/bfa/bfa_port_priv.h patch/drivers/scsi/bfa/bfa_port_priv.h
--- orig/drivers/scsi/bfa/bfa_port_priv.h	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_port_priv.h	2009-09-24 23:41:15.000000000 -0700
@@ -59,8 +59,8 @@ struct bfa_pport_s {
 	u8			*stats_kva;
 	u64		stats_pa;
 	union bfa_pport_stats_u *stats;	/*  pport stats */
-	u32		mypid : 24;
-	u32		rsvd_b : 8;
+	u32		mypid:24;
+	u32		rsvd_b:8;
 	struct bfa_timer_s 	timer;	/*  timer */
 	union bfa_pport_stats_u 	*stats_ret;
 					/*  driver stats location */
diff -urpN orig/drivers/scsi/bfa/bfa_rport.c patch/drivers/scsi/bfa/bfa_rport.c
--- orig/drivers/scsi/bfa/bfa_rport.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_rport.c	2009-09-24 23:41:15.000000000 -0700
@@ -677,7 +677,7 @@ bfa_rport_alloc(struct bfa_rport_mod_s *
 	if (rport)
 		list_add_tail(&rport->qe, &mod->rp_active_q);
 
-	return (rport);
+	return rport;
 }
 
 static void
@@ -834,7 +834,7 @@ bfa_rport_create(struct bfa_s *bfa, void
 	rp = bfa_rport_alloc(BFA_RPORT_MOD(bfa));
 
 	if (rp == NULL)
-		return (NULL);
+		return NULL;
 
 	rp->bfa = bfa;
 	rp->rport_drv = rport_drv;
@@ -843,7 +843,7 @@ bfa_rport_create(struct bfa_s *bfa, void
 	bfa_assert(bfa_sm_cmp_state(rp, bfa_rport_sm_uninit));
 	bfa_sm_send_event(rp, BFA_RPORT_SM_CREATE);
 
-	return (rp);
+	return rp;
 }
 
 void
diff -urpN orig/drivers/scsi/bfa/bfa_tskim.c patch/drivers/scsi/bfa/bfa_tskim.c
--- orig/drivers/scsi/bfa/bfa_tskim.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_tskim.c	2009-09-24 23:41:15.000000000 -0700
@@ -23,13 +23,14 @@ BFA_TRC_FILE(HAL, TSKIM);
 /**
  * task management completion handling
  */
-#define bfa_tskim_qcomp(__tskim, __cbfn) do {			     \
-	bfa_cb_queue((__tskim)->bfa, &(__tskim)->hcb_qe, __cbfn, (__tskim)); \
+#define bfa_tskim_qcomp(__tskim, __cbfn) do {			\
+	bfa_cb_queue((__tskim)->bfa, &(__tskim)->hcb_qe,	\
+			 __cbfn, (__tskim));      \
 	bfa_tskim_notify_comp(__tskim);      \
 } while (0)
 
-#define bfa_tskim_notify_comp(__tskim) do {				     \
-	if ((__tskim)->notify)					     	     \
+#define bfa_tskim_notify_comp(__tskim) do {			 \
+	if ((__tskim)->notify)					 \
 		bfa_itnim_tskdone((__tskim)->itnim);      \
 } while (0)
 
diff -urpN orig/drivers/scsi/bfa/bfa_uf.c patch/drivers/scsi/bfa/bfa_uf.c
--- orig/drivers/scsi/bfa/bfa_uf.c	2009-09-24 23:41:15.000000000 -0700
+++ patch/drivers/scsi/bfa/bfa_uf.c	2009-09-24 23:41:15.000000000 -0700
@@ -185,7 +185,7 @@ bfa_uf_get(struct bfa_uf_mod_s *uf_mod)
 	struct bfa_uf_s   *uf;
 
 	bfa_q_deq(&uf_mod->uf_free_q, &uf);
-	return (uf);
+	return uf;
 }
 
 static void
