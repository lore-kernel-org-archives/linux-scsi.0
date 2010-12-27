From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 1/3] bfa: replace bfa_assert with WARN_ON
Date: Sun, 26 Dec 2010 21:46:35 -0800
Message-ID: <1293428795-18711-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:45500 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab0L0Fqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2010 00:46:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch replaces all bfa_assert() with Linux WARN_ON().

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa.h           |    4 +-
 drivers/scsi/bfa/bfa_core.c      |   12 ++--
 drivers/scsi/bfa/bfa_cs.h        |   10 ----
 drivers/scsi/bfa/bfa_fcpim.c     |   42 +++++++-------
 drivers/scsi/bfa/bfa_fcs.c       |    6 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   10 ++--
 drivers/scsi/bfa/bfa_fcs_lport.c |   20 ++++----
 drivers/scsi/bfa/bfa_fcs_rport.c |    4 +-
 drivers/scsi/bfa/bfa_hw_cb.c     |    2 +-
 drivers/scsi/bfa/bfa_hw_ct.c     |    4 +-
 drivers/scsi/bfa/bfa_ioc.c       |   20 ++++----
 drivers/scsi/bfa/bfa_ioc_ct.c    |    4 +-
 drivers/scsi/bfa/bfa_port.c      |    4 +-
 drivers/scsi/bfa/bfa_svc.c       |  110 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfad.c          |    2 +-
 drivers/scsi/bfa/bfad_im.c       |    6 +-
 16 files changed, 125 insertions(+), 135 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index cabc6b9..ed156c5 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -120,8 +120,8 @@ bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
 									\
 		struct list_head *waitq = bfa_reqq(__bfa, __reqq);      \
 									\
-		bfa_assert(((__reqq) < BFI_IOC_MAX_CQS));      \
-		bfa_assert((__wqe)->qresume && (__wqe)->cbarg);      \
+		WARN_ON(((__reqq) >= BFI_IOC_MAX_CQS));     		\
+		WARN_ON(!((__wqe)->qresume && (__wqe)->cbarg));		\
 									\
 		list_add_tail(&(__wqe)->qe, waitq);      \
 	} while (0)
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 3f7f374..6e13ba2 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -285,7 +285,7 @@ bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
 	bfa_trc(bfa, m->mhdr.msg_class);
 	bfa_trc(bfa, m->mhdr.msg_id);
 	bfa_trc(bfa, m->mhdr.mtag.i2htok);
-	bfa_assert(0);
+	WARN_ON(1);
 	bfa_trc_stop(bfa->trcmod);
 }
 
@@ -433,7 +433,7 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 	struct bfa_iocfc_cfg_s	*cfg = &iocfc->cfg;
 	int		i;
 
-	bfa_assert(cfg->fwcfg.num_cqs <= BFI_IOC_MAX_CQS);
+	WARN_ON(cfg->fwcfg.num_cqs > BFI_IOC_MAX_CQS);
 	bfa_trc(bfa, cfg->fwcfg.num_cqs);
 
 	bfa_iocfc_reset_queues(bfa);
@@ -753,7 +753,7 @@ bfa_iocfc_disable_cbfn(void *bfa_arg)
 		bfa_cb_queue(bfa, &bfa->iocfc.stop_hcb_qe, bfa_iocfc_stop_cb,
 			     bfa);
 	else {
-		bfa_assert(bfa->iocfc.action == BFA_IOCFC_ACT_DISABLE);
+		WARN_ON(bfa->iocfc.action != BFA_IOCFC_ACT_DISABLE);
 		bfa_cb_queue(bfa, &bfa->iocfc.dis_hcb_qe, bfa_iocfc_disable_cb,
 			     bfa);
 	}
@@ -894,7 +894,7 @@ bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m)
 		iocfc->updateq_cbfn(iocfc->updateq_cbarg, BFA_STATUS_OK);
 		break;
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -1063,7 +1063,7 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
 	int		i;
 	u32	km_len = 0, dm_len = 0;
 
-	bfa_assert((cfg != NULL) && (meminfo != NULL));
+	WARN_ON((cfg == NULL) || (meminfo == NULL));
 
 	memset((void *)meminfo, 0, sizeof(struct bfa_meminfo_s));
 	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_type =
@@ -1117,7 +1117,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 	bfa->fcs = BFA_FALSE;
 
-	bfa_assert((cfg != NULL) && (meminfo != NULL));
+	WARN_ON((cfg == NULL) || (meminfo == NULL));
 
 	/*
 	 * initialize all memory pointers for iterative allocation
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 493009d..913057d 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -163,16 +163,6 @@ __bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
 #define bfa_trc_fp(_trcp, _data)
 #endif
 
-/*
- * @ BFA LOG interfaces
- */
-#define bfa_assert(__cond)	do {					\
-	if (!(__cond)) {						\
-		printk(KERN_ERR "assert(%s) failed at %s:%d\\n",         \
-		#__cond, __FILE__, __LINE__);				\
-	}								\
-} while (0)
-
 #define bfa_sm_fault(__mod, __event)	do {				\
 	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
 	printk(KERN_ERR	"Assertion failure: %s:%d: %d",			\
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 5e697f2..f57c066 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -32,12 +32,12 @@ static void bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim);
 #define bfa_fcpim_additn(__itnim)					\
 	list_add_tail(&(__itnim)->qe, &(__itnim)->fcpim->itnim_q)
 #define bfa_fcpim_delitn(__itnim)	do {				\
-	bfa_assert(bfa_q_is_on_q(&(__itnim)->fcpim->itnim_q, __itnim));      \
+	WARN_ON(!bfa_q_is_on_q(&(__itnim)->fcpim->itnim_q, __itnim));   \
 	bfa_itnim_update_del_itn_stats(__itnim);      \
 	list_del(&(__itnim)->qe);      \
-	bfa_assert(list_empty(&(__itnim)->io_q));      \
-	bfa_assert(list_empty(&(__itnim)->io_cleanup_q));      \
-	bfa_assert(list_empty(&(__itnim)->pending_q));      \
+	WARN_ON(!list_empty(&(__itnim)->io_q));				\
+	WARN_ON(!list_empty(&(__itnim)->io_cleanup_q));			\
+	WARN_ON(!list_empty(&(__itnim)->pending_q));			\
 } while (0)
 
 #define bfa_itnim_online_cb(__itnim) do {				\
@@ -1184,7 +1184,7 @@ bfa_itnim_iotov_start(struct bfa_itnim_s *itnim)
 	if (itnim->fcpim->path_tov > 0) {
 
 		itnim->iotov_active = BFA_TRUE;
-		bfa_assert(bfa_itnim_hold_io(itnim));
+		WARN_ON(!bfa_itnim_hold_io(itnim));
 		bfa_timer_start(itnim->bfa, &itnim->timer,
 			bfa_itnim_iotov, itnim, itnim->fcpim->path_tov);
 	}
@@ -1262,7 +1262,7 @@ bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	case BFI_ITNIM_I2H_CREATE_RSP:
 		itnim = BFA_ITNIM_FROM_TAG(fcpim,
 						msg.create_rsp->bfa_handle);
-		bfa_assert(msg.create_rsp->status == BFA_STATUS_OK);
+		WARN_ON(msg.create_rsp->status != BFA_STATUS_OK);
 		bfa_stats(itnim, create_comps);
 		bfa_sm_send_event(itnim, BFA_ITNIM_SM_FWRSP);
 		break;
@@ -1270,7 +1270,7 @@ bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	case BFI_ITNIM_I2H_DELETE_RSP:
 		itnim = BFA_ITNIM_FROM_TAG(fcpim,
 						msg.delete_rsp->bfa_handle);
-		bfa_assert(msg.delete_rsp->status == BFA_STATUS_OK);
+		WARN_ON(msg.delete_rsp->status != BFA_STATUS_OK);
 		bfa_stats(itnim, delete_comps);
 		bfa_sm_send_event(itnim, BFA_ITNIM_SM_FWRSP);
 		break;
@@ -1284,7 +1284,7 @@ bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	default:
 		bfa_trc(bfa, m->mhdr.msg_id);
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -1299,7 +1299,7 @@ bfa_itnim_create(struct bfa_s *bfa, struct bfa_rport_s *rport, void *ditn)
 	struct bfa_itnim_s *itnim;
 
 	itnim = BFA_ITNIM_FROM_TAG(fcpim, rport->rport_tag);
-	bfa_assert(itnim->rport == rport);
+	WARN_ON(itnim->rport != rport);
 
 	itnim->ditn = ditn;
 
@@ -1416,7 +1416,7 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		 * requests immediately.
 		 */
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
-		bfa_assert(bfa_q_is_on_q(&ioim->itnim->pending_q, ioim));
+		WARN_ON(!bfa_q_is_on_q(&ioim->itnim->pending_q, ioim));
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
 				__bfa_cb_ioim_abort, ioim);
 		break;
@@ -1649,7 +1649,7 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_CLEANUP:
-		bfa_assert(ioim->iosp->abort_explicit == BFA_TRUE);
+		WARN_ON(ioim->iosp->abort_explicit != BFA_TRUE);
 		ioim->iosp->abort_explicit = BFA_FALSE;
 
 		if (bfa_ioim_send_abort(ioim))
@@ -1795,7 +1795,7 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_CLEANUP:
-		bfa_assert(ioim->iosp->abort_explicit == BFA_TRUE);
+		WARN_ON(ioim->iosp->abort_explicit != BFA_TRUE);
 		ioim->iosp->abort_explicit = BFA_FALSE;
 		bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
 		break;
@@ -2236,7 +2236,7 @@ bfa_ioim_sgpg_alloc(struct bfa_ioim_s *ioim)
 {
 	u16	nsgpgs;
 
-	bfa_assert(ioim->nsges > BFI_SGE_INLINE);
+	WARN_ON(ioim->nsges <= BFI_SGE_INLINE);
 
 	/*
 	 * allocate SG pages needed
@@ -2444,7 +2444,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	iotag = be16_to_cpu(rsp->io_tag);
 
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
-	bfa_assert(ioim->iotag == iotag);
+	WARN_ON(ioim->iotag != iotag);
 
 	bfa_trc(ioim->bfa, ioim->iotag);
 	bfa_trc(ioim->bfa, rsp->io_status);
@@ -2475,13 +2475,13 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	case BFI_IOIM_STS_PROTO_ERR:
 		bfa_stats(ioim->itnim, iocom_proto_err);
-		bfa_assert(rsp->reuse_io_tag);
+		WARN_ON(!rsp->reuse_io_tag);
 		evt = BFA_IOIM_SM_COMP;
 		break;
 
 	case BFI_IOIM_STS_SQER_NEEDED:
 		bfa_stats(ioim->itnim, iocom_sqer_needed);
-		bfa_assert(rsp->reuse_io_tag == 0);
+		WARN_ON(rsp->reuse_io_tag != 0);
 		evt = BFA_IOIM_SM_SQRETRY;
 		break;
 
@@ -2510,7 +2510,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 		break;
 
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 
 	bfa_sm_send_event(ioim, evt);
@@ -2527,7 +2527,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	iotag = be16_to_cpu(rsp->io_tag);
 
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
-	bfa_assert(BFA_IOIM_TAG_2_ID(ioim->iotag) == iotag);
+	WARN_ON(BFA_IOIM_TAG_2_ID(ioim->iotag) != iotag);
 
 	bfa_trc_fp(ioim->bfa, ioim->iotag);
 	bfa_ioim_cb_profile_comp(fcpim, ioim);
@@ -2944,7 +2944,7 @@ bfa_tskim_match_scope(struct bfa_tskim_s *tskim, struct scsi_lun lun)
 		return !memcmp(&tskim->lun, &lun, sizeof(lun));
 
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 
 	return BFA_FALSE;
@@ -3190,7 +3190,7 @@ bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	u16	tsk_tag = be16_to_cpu(rsp->tsk_tag);
 
 	tskim = BFA_TSKIM_FROM_TAG(fcpim, tsk_tag);
-	bfa_assert(tskim->tsk_tag == tsk_tag);
+	WARN_ON(tskim->tsk_tag != tsk_tag);
 
 	tskim->tsk_status = rsp->tsk_status;
 
@@ -3225,7 +3225,7 @@ bfa_tskim_alloc(struct bfa_s *bfa, struct bfad_tskim_s *dtsk)
 void
 bfa_tskim_free(struct bfa_tskim_s *tskim)
 {
-	bfa_assert(bfa_q_is_on_q_func(&tskim->itnim->tsk_q, &tskim->qe));
+	WARN_ON(!bfa_q_is_on_q_func(&tskim->itnim->tsk_q, &tskim->qe));
 	list_del(&tskim->qe);
 	list_add_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
 }
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index e3a41b8..f674f93 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -920,7 +920,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 	INIT_LIST_HEAD(&fabric->vport_q);
 	INIT_LIST_HEAD(&fabric->vf_q);
 	fabric->lps = bfa_lps_alloc(fcs->bfa);
-	bfa_assert(fabric->lps);
+	WARN_ON(!fabric->lps);
 
 	/*
 	 * Initialize fabric delete completion handler. Fabric deletion is
@@ -1317,7 +1317,7 @@ bfa_fcs_port_event_handler(void *cbarg, enum bfa_port_linkstate event)
 		break;
 
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -1364,7 +1364,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 		 * drop frame if vfid is unknown
 		 */
 		if (!fabric) {
-			bfa_assert(0);
+			WARN_ON(1);
 			bfa_stats(fcs, uf.vfid_unknown);
 			bfa_uf_free(uf);
 			return;
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 5736ef8..e7b49f4 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -536,7 +536,7 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 	if (bfa_itnim == NULL) {
 		bfa_trc(port->fcs, rport->pwwn);
 		bfa_fcb_itnim_free(port->fcs->bfad, itnim_drv);
-		bfa_assert(0);
+		WARN_ON(1);
 		return NULL;
 	}
 
@@ -700,7 +700,7 @@ bfa_fcs_itnim_lookup(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	if (!rport)
 		return NULL;
 
-	bfa_assert(rport->itnim != NULL);
+	WARN_ON(rport->itnim == NULL);
 	return rport->itnim;
 }
 
@@ -729,7 +729,7 @@ bfa_fcs_itnim_stats_get(struct bfa_fcs_lport_s *port, wwn_t rpwwn,
 {
 	struct bfa_fcs_itnim_s *itnim = NULL;
 
-	bfa_assert(port != NULL);
+	WARN_ON(port == NULL);
 
 	itnim = bfa_fcs_itnim_lookup(port, rpwwn);
 
@@ -746,7 +746,7 @@ bfa_fcs_itnim_stats_clear(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 {
 	struct bfa_fcs_itnim_s *itnim = NULL;
 
-	bfa_assert(port != NULL);
+	WARN_ON(port == NULL);
 
 	itnim = bfa_fcs_itnim_lookup(port, rpwwn);
 
@@ -778,6 +778,6 @@ bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index eb80498..4e2eb92 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -351,7 +351,7 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 		 * This is a different device with the same pid. Old device
 		 * disappeared. Send implicit LOGO to old device.
 		 */
-		bfa_assert(rport->pwwn != plogi->port_name);
+		WARN_ON(rport->pwwn == plogi->port_name);
 		bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
 
 		/*
@@ -364,7 +364,7 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 	/*
 	 * PLOGI crossing each other.
 	 */
-	bfa_assert(rport->pwwn == WWN_NULL);
+	WARN_ON(rport->pwwn != WWN_NULL);
 	bfa_fcs_rport_plogi(rport, rx_fchs, plogi);
 }
 
@@ -532,19 +532,19 @@ bfa_fcs_lport_offline_actions(struct bfa_fcs_lport_s *port)
 static void
 bfa_fcs_lport_unknown_init(struct bfa_fcs_lport_s *port)
 {
-	bfa_assert(0);
+	WARN_ON(1);
 }
 
 static void
 bfa_fcs_lport_unknown_online(struct bfa_fcs_lport_s *port)
 {
-	bfa_assert(0);
+	WARN_ON(1);
 }
 
 static void
 bfa_fcs_lport_unknown_offline(struct bfa_fcs_lport_s *port)
 {
-	bfa_assert(0);
+	WARN_ON(1);
 }
 
 static void
@@ -777,7 +777,7 @@ bfa_fcs_lport_del_rport(
 	struct bfa_fcs_lport_s *port,
 	struct bfa_fcs_rport_s *rport)
 {
-	bfa_assert(bfa_q_is_on_q(&port->rport_q, rport));
+	WARN_ON(!bfa_q_is_on_q(&port->rport_q, rport));
 	list_del(&rport->qe);
 	port->num_rports--;
 
@@ -1005,7 +1005,7 @@ bfa_fcs_lport_n2n_online(struct bfa_fcs_lport_s *port)
 		 */
 		if (port->num_rports > 0) {
 			rport = bfa_fcs_lport_get_rport_by_pid(port, 0);
-			bfa_assert(rport != NULL);
+			WARN_ON(rport == NULL);
 			if (rport) {
 				bfa_trc(port->fcs, rport->pwwn);
 				bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
@@ -4153,7 +4153,7 @@ bfa_fcs_lport_ns_boot_target_disc(bfa_fcs_lport_t *port)
 
 	for (ii = 0 ; ii < nwwns; ++ii) {
 		rport = bfa_fcs_rport_create_by_wwn(port, wwns[ii]);
-		bfa_assert(rport);
+		WARN_ON(!rport);
 	}
 }
 
@@ -4616,7 +4616,7 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 
 
 		default:
-			bfa_assert(0);
+			WARN_ON(1);
 			nsquery = BFA_TRUE;
 		}
 	}
@@ -4797,7 +4797,7 @@ bfa_fcs_lookup_port(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t lpwwn)
 	struct bfa_fcs_vport_s *vport;
 	bfa_fcs_vf_t   *vf;
 
-	bfa_assert(fcs != NULL);
+	WARN_ON(fcs == NULL);
 
 	vf = bfa_fcs_vf_lookup(fcs, vf_id);
 	if (vf == NULL) {
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 711f2d9..caaee6f 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1968,7 +1968,7 @@ bfa_fcs_rport_alloc(struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 rpid)
 	/*
 	 * allocate FC-4s
 	 */
-	bfa_assert(bfa_fcs_lport_is_initiator(port));
+	WARN_ON(!bfa_fcs_lport_is_initiator(port));
 
 	if (bfa_fcs_lport_is_initiator(port)) {
 		rport->itnim = bfa_fcs_itnim_create(rport);
@@ -2897,7 +2897,7 @@ bfa_fcs_rpf_rpsc2_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 		num_ents = be16_to_cpu(rpsc2_acc->num_pids);
 		bfa_trc(rport->fcs, num_ents);
 		if (num_ents > 0) {
-			bfa_assert(rpsc2_acc->port_info[0].pid != rport->pid);
+			WARN_ON(rpsc2_acc->port_info[0].pid == rport->pid);
 			bfa_trc(rport->fcs,
 				be16_to_cpu(rpsc2_acc->port_info[0].pid));
 			bfa_trc(rport->fcs,
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index 1fa15ed..977e681 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -111,7 +111,7 @@ bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs)
 {
 	int i;
 
-	bfa_assert((nvecs == 1) || (nvecs == __HFN_NUMINTS));
+	WARN_ON((nvecs != 1) && (nvecs != __HFN_NUMINTS));
 
 	bfa->msix.nvecs = nvecs;
 	if (nvecs == 1) {
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index 68077c4..21018d9 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -117,7 +117,7 @@ bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
 void
 bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs)
 {
-	bfa_assert((nvecs == 1) || (nvecs == BFA_MSIX_CT_MAX));
+	WARN_ON((nvecs != 1) && (nvecs != BFA_MSIX_CT_MAX));
 	bfa_trc(bfa, nvecs);
 
 	bfa->msix.nvecs = nvecs;
@@ -144,7 +144,7 @@ bfa_hwct_msix_install(struct bfa_s *bfa)
 	for (; i <= BFA_MSIX_RME_Q3; i++)
 		bfa->msix.handler[i] = bfa_msix_rspq;
 
-	bfa_assert(i == BFA_MSIX_LPU_ERR);
+	WARN_ON(i != BFA_MSIX_LPU_ERR);
 	bfa->msix.handler[BFA_MSIX_LPU_ERR] = bfa_msix_lpu_err;
 }
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 05b0ff9..431cf72 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1219,7 +1219,7 @@ bfa_ioc_sem_get(void __iomem *sem_reg)
 	if (r32 == 0)
 		return BFA_TRUE;
 
-	bfa_assert(cnt < BFA_SEM_SPINCNT);
+	WARN_ON(cnt >= BFA_SEM_SPINCNT);
 	return BFA_FALSE;
 }
 
@@ -1274,7 +1274,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 	 * If memory initialization is not successful, IOC timeout will catch
 	 * such failures.
 	 */
-	bfa_assert(pss_ctl & __PSS_LMEM_INIT_DONE);
+	WARN_ON(!(pss_ctl & __PSS_LMEM_INIT_DONE));
 	bfa_trc(ioc, pss_ctl);
 
 	pss_ctl &= ~(__PSS_LMEM_INIT_DONE | __PSS_LMEM_INIT_EN);
@@ -1503,7 +1503,7 @@ bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 	bfa_trc(ioc, msgp[0]);
 	bfa_trc(ioc, len);
 
-	bfa_assert(len <= BFI_IOC_MSGLEN_MAX);
+	WARN_ON(len > BFI_IOC_MSGLEN_MAX);
 
 	/*
 	 * first write msg to mailbox registers
@@ -2010,7 +2010,7 @@ bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
 
 	default:
 		bfa_trc(ioc, msg->mh.msg_id);
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -2345,7 +2345,7 @@ bfa_ioc_get_type(struct bfa_ioc_s *ioc)
 	else if (ioc->ioc_mc == BFI_MC_LL)
 		return BFA_IOC_TYPE_LL;
 	else {
-		bfa_assert(ioc->ioc_mc == BFI_MC_LL);
+		WARN_ON(ioc->ioc_mc != BFI_MC_LL);
 		return BFA_IOC_TYPE_LL;
 	}
 }
@@ -2369,7 +2369,7 @@ bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver)
 void
 bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev)
 {
-	bfa_assert(chip_rev);
+	WARN_ON(!chip_rev);
 
 	memset((void *)chip_rev, 0, BFA_IOC_CHIP_REV_LEN);
 
@@ -2401,7 +2401,7 @@ bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 {
 	struct bfi_ioc_attr_s	*ioc_attr;
 
-	bfa_assert(model);
+	WARN_ON(!model);
 	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
 
 	ioc_attr = ioc->attr;
@@ -2772,8 +2772,8 @@ bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
 		    void (*timercb) (void *), void *arg, unsigned int timeout)
 {
 
-	bfa_assert(timercb != NULL);
-	bfa_assert(!bfa_q_is_on_q(&mod->timer_q, timer));
+	WARN_ON(timercb == NULL);
+	WARN_ON(bfa_q_is_on_q(&mod->timer_q, timer));
 
 	timer->timeout = timeout;
 	timer->timercb = timercb;
@@ -2788,7 +2788,7 @@ bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
 void
 bfa_timer_stop(struct bfa_timer_s *timer)
 {
-	bfa_assert(!list_empty(&timer->qe));
+	WARN_ON(list_empty(&timer->qe));
 
 	list_del(&timer->qe);
 }
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 9da55a8..ccfecfc 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -113,7 +113,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	/*
 	 * Use count cannot be non-zero and chip in uninitialized state.
 	 */
-	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
+	WARN_ON(ioc_fwstate == BFI_IOC_UNINIT);
 
 	/*
 	 * Check if another driver with a different firmware is active
@@ -158,7 +158,7 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 	 */
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
 	usecnt = readl(ioc->ioc_regs.ioc_usage_reg);
-	bfa_assert(usecnt > 0);
+	WARN_ON(usecnt <= 0);
 
 	usecnt--;
 	writel(usecnt, ioc->ioc_regs.ioc_usage_reg);
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 45b3486..3f8e9d6 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -186,7 +186,7 @@ bfa_port_isr(void *cbarg, struct bfi_mbmsg_s *m)
 		break;
 
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -435,7 +435,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 {
 	struct timeval tv;
 
-	bfa_assert(port);
+	WARN_ON(!port);
 
 	port->dev    = dev;
 	port->ioc    = ioc;
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index b7df553..d33e93a 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -309,7 +309,7 @@ bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 		return;
 
 	if (plkd_validate_logrec(pl_rec)) {
-		bfa_assert(0);
+		WARN_ON(1);
 		return;
 	}
 
@@ -601,15 +601,15 @@ bfa_fcxp_init_reqrsp(struct bfa_fcxp_s *fcxp,
 	       bfa_fcxp_get_sglen_t sglen_cbfn)
 {
 
-	bfa_assert(bfa != NULL);
+	WARN_ON(bfa == NULL);
 
 	bfa_trc(bfa, fcxp->fcxp_tag);
 
 	if (n_sgles == 0) {
 		*use_ibuf = 1;
 	} else {
-		bfa_assert(*sga_cbfn != NULL);
-		bfa_assert(*sglen_cbfn != NULL);
+		WARN_ON(*sga_cbfn == NULL);
+		WARN_ON(*sglen_cbfn == NULL);
 
 		*use_ibuf = 0;
 		*r_sga_cbfn = sga_cbfn;
@@ -621,7 +621,7 @@ bfa_fcxp_init_reqrsp(struct bfa_fcxp_s *fcxp,
 		 * alloc required sgpgs
 		 */
 		if (n_sgles > BFI_SGE_INLINE)
-			bfa_assert(0);
+			WARN_ON(1);
 	}
 
 }
@@ -635,7 +635,7 @@ bfa_fcxp_init(struct bfa_fcxp_s *fcxp,
 	       bfa_fcxp_get_sglen_t rsp_sglen_cbfn)
 {
 
-	bfa_assert(bfa != NULL);
+	WARN_ON(bfa == NULL);
 
 	bfa_trc(bfa, fcxp->fcxp_tag);
 
@@ -672,7 +672,7 @@ bfa_fcxp_put(struct bfa_fcxp_s *fcxp)
 		return;
 	}
 
-	bfa_assert(bfa_q_is_on_q(&mod->fcxp_active_q, fcxp));
+	WARN_ON(!bfa_q_is_on_q(&mod->fcxp_active_q, fcxp));
 	list_del(&fcxp->qe);
 	list_add_tail(&fcxp->qe, &mod->fcxp_free_q);
 }
@@ -721,7 +721,7 @@ hal_fcxp_send_comp(struct bfa_s *bfa, struct bfi_fcxp_send_rsp_s *fcxp_rsp)
 
 	fcxp = BFA_FCXP_FROM_TAG(mod, fcxp_tag);
 
-	bfa_assert(fcxp->send_cbfn != NULL);
+	WARN_ON(fcxp->send_cbfn == NULL);
 
 	hal_fcxp_rx_plog(mod->bfa, fcxp, fcxp_rsp);
 
@@ -877,13 +877,13 @@ bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
 					BFA_FCXP_REQ_PLD_PA(fcxp));
 	} else {
 		if (fcxp->nreq_sgles > 0) {
-			bfa_assert(fcxp->nreq_sgles == 1);
+			WARN_ON(fcxp->nreq_sgles != 1);
 			hal_fcxp_set_local_sges(send_req->req_sge,
 						reqi->req_tot_len,
 						fcxp->req_sga_cbfn(fcxp->caller,
 								   0));
 		} else {
-			bfa_assert(reqi->req_tot_len == 0);
+			WARN_ON(reqi->req_tot_len != 0);
 			hal_fcxp_set_local_sges(send_req->rsp_sge, 0, 0);
 		}
 	}
@@ -892,20 +892,20 @@ bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
 	 * setup rsp sgles
 	 */
 	if (fcxp->use_irspbuf == 1) {
-		bfa_assert(rspi->rsp_maxlen <= BFA_FCXP_MAX_LBUF_SZ);
+		WARN_ON(rspi->rsp_maxlen > BFA_FCXP_MAX_LBUF_SZ);
 
 		hal_fcxp_set_local_sges(send_req->rsp_sge, rspi->rsp_maxlen,
 					BFA_FCXP_RSP_PLD_PA(fcxp));
 
 	} else {
 		if (fcxp->nrsp_sgles > 0) {
-			bfa_assert(fcxp->nrsp_sgles == 1);
+			WARN_ON(fcxp->nrsp_sgles != 1);
 			hal_fcxp_set_local_sges(send_req->rsp_sge,
 						rspi->rsp_maxlen,
 						fcxp->rsp_sga_cbfn(fcxp->caller,
 								   0));
 		} else {
-			bfa_assert(rspi->rsp_maxlen == 0);
+			WARN_ON(rspi->rsp_maxlen != 0);
 			hal_fcxp_set_local_sges(send_req->rsp_sge, 0, 0);
 		}
 	}
@@ -950,7 +950,7 @@ bfa_fcxp_alloc(void *caller, struct bfa_s *bfa, int nreq_sgles,
 {
 	struct bfa_fcxp_s *fcxp = NULL;
 
-	bfa_assert(bfa != NULL);
+	WARN_ON(bfa == NULL);
 
 	fcxp = bfa_fcxp_get(BFA_FCXP_MOD(bfa));
 	if (fcxp == NULL)
@@ -977,7 +977,7 @@ bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp)
 	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
 	void	*reqbuf;
 
-	bfa_assert(fcxp->use_ireqbuf == 1);
+	WARN_ON(fcxp->use_ireqbuf != 1);
 	reqbuf = ((u8 *)mod->req_pld_list_kva) +
 		fcxp->fcxp_tag * mod->req_pld_sz;
 	return reqbuf;
@@ -1004,7 +1004,7 @@ bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp)
 	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
 	void	*rspbuf;
 
-	bfa_assert(fcxp->use_irspbuf == 1);
+	WARN_ON(fcxp->use_irspbuf != 1);
 
 	rspbuf = ((u8 *)mod->rsp_pld_list_kva) +
 		fcxp->fcxp_tag * mod->rsp_pld_sz;
@@ -1023,7 +1023,7 @@ bfa_fcxp_free(struct bfa_fcxp_s *fcxp)
 {
 	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
 
-	bfa_assert(fcxp != NULL);
+	WARN_ON(fcxp == NULL);
 	bfa_trc(mod->bfa, fcxp->fcxp_tag);
 	bfa_fcxp_put(fcxp);
 }
@@ -1102,7 +1102,7 @@ bfa_status_t
 bfa_fcxp_abort(struct bfa_fcxp_s *fcxp)
 {
 	bfa_trc(fcxp->fcxp_mod->bfa, fcxp->fcxp_tag);
-	bfa_assert(0);
+	WARN_ON(1);
 	return BFA_STATUS_OK;
 }
 
@@ -1117,7 +1117,7 @@ bfa_fcxp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
 {
 	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
 
-	bfa_assert(list_empty(&mod->fcxp_free_q));
+	WARN_ON(!list_empty(&mod->fcxp_free_q));
 
 	wqe->alloc_cbfn = alloc_cbfn;
 	wqe->alloc_cbarg = alloc_cbarg;
@@ -1138,7 +1138,7 @@ bfa_fcxp_walloc_cancel(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe)
 {
 	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
 
-	bfa_assert(bfa_q_is_on_q(&mod->wait_q, wqe));
+	WARN_ON(!bfa_q_is_on_q(&mod->wait_q, wqe));
 	list_del(&wqe->qe);
 }
 
@@ -1169,7 +1169,7 @@ bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 
 	default:
 		bfa_trc(bfa, msg->mhdr.msg_id);
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -1555,7 +1555,7 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
 	struct bfa_lps_s	*lps;
 
-	bfa_assert(rsp->lp_tag < mod->num_lps);
+	WARN_ON(rsp->lp_tag >= mod->num_lps);
 	lps = BFA_LPS_FROM_TAG(mod, rsp->lp_tag);
 
 	lps->status = rsp->status;
@@ -1603,7 +1603,7 @@ bfa_lps_logout_rsp(struct bfa_s *bfa, struct bfi_lps_logout_rsp_s *rsp)
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
 	struct bfa_lps_s	*lps;
 
-	bfa_assert(rsp->lp_tag < mod->num_lps);
+	WARN_ON(rsp->lp_tag >= mod->num_lps);
 	lps = BFA_LPS_FROM_TAG(mod, rsp->lp_tag);
 
 	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
@@ -1656,7 +1656,7 @@ bfa_lps_send_login(struct bfa_lps_s *lps)
 	struct bfi_lps_login_req_s	*m;
 
 	m = bfa_reqq_next(lps->bfa, lps->reqq);
-	bfa_assert(m);
+	WARN_ON(!m);
 
 	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGIN_REQ,
 		bfa_lpuid(lps->bfa));
@@ -1681,7 +1681,7 @@ bfa_lps_send_logout(struct bfa_lps_s *lps)
 	struct bfi_lps_logout_req_s *m;
 
 	m = bfa_reqq_next(lps->bfa, lps->reqq);
-	bfa_assert(m);
+	WARN_ON(!m);
 
 	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGOUT_REQ,
 		bfa_lpuid(lps->bfa));
@@ -1700,7 +1700,7 @@ bfa_lps_send_set_n2n_pid(struct bfa_lps_s *lps)
 	struct bfi_lps_n2n_pid_req_s *m;
 
 	m = bfa_reqq_next(lps->bfa, lps->reqq);
-	bfa_assert(m);
+	WARN_ON(!m);
 
 	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_N2N_PID_REQ,
 		bfa_lpuid(lps->bfa));
@@ -1969,7 +1969,7 @@ bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	default:
 		bfa_trc(bfa, m->mhdr.msg_id);
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -2099,7 +2099,7 @@ bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport,
 		bfa_fcport_update_linkinfo(fcport);
 		bfa_sm_set_state(fcport, bfa_fcport_sm_linkup);
 
-		bfa_assert(fcport->event_cbfn);
+		WARN_ON(!fcport->event_cbfn);
 		bfa_fcport_scn(fcport, BFA_PORT_LINKUP, BFA_FALSE);
 		break;
 
@@ -2150,7 +2150,7 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
 	case BFA_FCPORT_SM_LINKUP:
 		bfa_fcport_update_linkinfo(fcport);
 		bfa_sm_set_state(fcport, bfa_fcport_sm_linkup);
-		bfa_assert(fcport->event_cbfn);
+		WARN_ON(!fcport->event_cbfn);
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
 		if (!bfa_ioc_get_fcmode(&fcport->bfa->ioc)) {
@@ -2754,7 +2754,7 @@ bfa_fcport_scn(struct bfa_fcport_s *fcport, enum bfa_port_linkstate event,
 		bfa_sm_send_event(&fcport->ln, BFA_FCPORT_LN_SM_LINKDOWN);
 		break;
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -3219,8 +3219,8 @@ bfa_trunk_scn(struct bfa_fcport_s *fcport, struct bfi_fcport_trunk_scn_s *scn)
 	int link_bm = 0;
 
 	bfa_trc(fcport->bfa, fcport->cfg.trunked);
-	bfa_assert(scn->trunk_state == BFA_TRUNK_ONLINE ||
-		   scn->trunk_state == BFA_TRUNK_OFFLINE);
+	WARN_ON(scn->trunk_state != BFA_TRUNK_ONLINE &&
+		   scn->trunk_state != BFA_TRUNK_OFFLINE);
 
 	bfa_trc(fcport->bfa, trunk->attr.state);
 	bfa_trc(fcport->bfa, scn->trunk_state);
@@ -3329,9 +3329,9 @@ bfa_fcport_init(struct bfa_s *bfa)
 	fcport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
 	fcport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
 
-	bfa_assert(fcport->cfg.maxfrsize);
-	bfa_assert(fcport->cfg.rx_bbcredit);
-	bfa_assert(fcport->speed_sup);
+	WARN_ON(!fcport->cfg.maxfrsize);
+	WARN_ON(!fcport->cfg.rx_bbcredit);
+	WARN_ON(!fcport->speed_sup);
 }
 
 /*
@@ -3428,7 +3428,7 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 		break;
 
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 	break;
 	}
 }
@@ -4310,8 +4310,8 @@ bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	mod->rps_list = rp;
 	mod->num_rports = cfg->fwcfg.num_rports;
 
-	bfa_assert(mod->num_rports &&
-		   !(mod->num_rports & (mod->num_rports - 1)));
+	WARN_ON(!mod->num_rports ||
+		   (mod->num_rports & (mod->num_rports - 1)));
 
 	for (i = 0; i < mod->num_rports; i++, rp++) {
 		memset(rp, 0, sizeof(struct bfa_rport_s));
@@ -4379,7 +4379,7 @@ bfa_rport_free(struct bfa_rport_s *rport)
 {
 	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(rport->bfa);
 
-	bfa_assert(bfa_q_is_on_q(&mod->rp_active_q, rport));
+	WARN_ON(!bfa_q_is_on_q(&mod->rp_active_q, rport));
 	list_del(&rport->qe);
 	list_add_tail(&rport->qe, &mod->rp_free_q);
 }
@@ -4492,13 +4492,13 @@ bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 		rp = BFA_RPORT_FROM_TAG(bfa, msg.create_rsp->bfa_handle);
 		rp->fw_handle = msg.create_rsp->fw_handle;
 		rp->qos_attr = msg.create_rsp->qos_attr;
-		bfa_assert(msg.create_rsp->status == BFA_STATUS_OK);
+		WARN_ON(msg.create_rsp->status != BFA_STATUS_OK);
 		bfa_sm_send_event(rp, BFA_RPORT_SM_FWRSP);
 		break;
 
 	case BFI_RPORT_I2H_DELETE_RSP:
 		rp = BFA_RPORT_FROM_TAG(bfa, msg.delete_rsp->bfa_handle);
-		bfa_assert(msg.delete_rsp->status == BFA_STATUS_OK);
+		WARN_ON(msg.delete_rsp->status != BFA_STATUS_OK);
 		bfa_sm_send_event(rp, BFA_RPORT_SM_FWRSP);
 		break;
 
@@ -4510,7 +4510,7 @@ bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	default:
 		bfa_trc(bfa, m->mhdr.msg_id);
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
@@ -4534,7 +4534,7 @@ bfa_rport_create(struct bfa_s *bfa, void *rport_drv)
 	rp->rport_drv = rport_drv;
 	memset(&rp->stats, 0, sizeof(rp->stats));
 
-	bfa_assert(bfa_sm_cmp_state(rp, bfa_rport_sm_uninit));
+	WARN_ON(!bfa_sm_cmp_state(rp, bfa_rport_sm_uninit));
 	bfa_sm_send_event(rp, BFA_RPORT_SM_CREATE);
 
 	return rp;
@@ -4543,7 +4543,7 @@ bfa_rport_create(struct bfa_s *bfa, void *rport_drv)
 void
 bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
 {
-	bfa_assert(rport_info->max_frmsz != 0);
+	WARN_ON(rport_info->max_frmsz == 0);
 
 	/*
 	 * Some JBODs are seen to be not setting PDU size correctly in PLOGI
@@ -4561,8 +4561,8 @@ bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
 void
 bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed)
 {
-	bfa_assert(speed != 0);
-	bfa_assert(speed != BFA_PORT_SPEED_AUTO);
+	WARN_ON(speed == 0);
+	WARN_ON(speed == BFA_PORT_SPEED_AUTO);
 
 	rport->rport_info.speed = speed;
 	bfa_sm_send_event(rport, BFA_RPORT_SM_SET_SPEED);
@@ -4622,7 +4622,7 @@ bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	sgpg_pa.pa = mod->sgpg_arr_pa;
 	mod->free_sgpgs = mod->num_sgpgs;
 
-	bfa_assert(!(sgpg_pa.pa & (sizeof(struct bfi_sgpg_s) - 1)));
+	WARN_ON(sgpg_pa.pa & (sizeof(struct bfi_sgpg_s) - 1));
 
 	for (i = 0; i < mod->num_sgpgs; i++) {
 		memset(hsgpg, 0, sizeof(*hsgpg));
@@ -4677,7 +4677,7 @@ bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpgs)
 
 	for (i = 0; i < nsgpgs; i++) {
 		bfa_q_deq(&mod->sgpg_q, &hsgpg);
-		bfa_assert(hsgpg);
+		WARN_ON(!hsgpg);
 		list_add_tail(&hsgpg->qe, sgpg_q);
 	}
 
@@ -4694,7 +4694,7 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
 	bfa_trc_fp(bfa, nsgpg);
 
 	mod->free_sgpgs += nsgpg;
-	bfa_assert(mod->free_sgpgs <= mod->num_sgpgs);
+	WARN_ON(mod->free_sgpgs > mod->num_sgpgs);
 
 	list_splice_tail_init(sgpg_q, &mod->sgpg_q);
 
@@ -4724,8 +4724,8 @@ bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe, int nsgpg)
 {
 	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
 
-	bfa_assert(nsgpg > 0);
-	bfa_assert(nsgpg > mod->free_sgpgs);
+	WARN_ON(nsgpg <= 0);
+	WARN_ON(nsgpg <= mod->free_sgpgs);
 
 	wqe->nsgpg_total = wqe->nsgpg = nsgpg;
 
@@ -4736,7 +4736,7 @@ bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe, int nsgpg)
 		/*
 		 * no one else is waiting for SGPG
 		 */
-		bfa_assert(list_empty(&mod->sgpg_wait_q));
+		WARN_ON(!list_empty(&mod->sgpg_wait_q));
 		list_splice_tail_init(&mod->sgpg_q, &wqe->sgpg_q);
 		wqe->nsgpg -= mod->free_sgpgs;
 		mod->free_sgpgs = 0;
@@ -4750,7 +4750,7 @@ bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe)
 {
 	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
 
-	bfa_assert(bfa_q_is_on_q(&mod->sgpg_wait_q, wqe));
+	WARN_ON(!bfa_q_is_on_q(&mod->sgpg_wait_q, wqe));
 	list_del(&wqe->qe);
 
 	if (wqe->nsgpg_total != wqe->nsgpg)
@@ -4982,7 +4982,7 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	uf->data_ptr = buf;
 	uf->data_len = m->xfr_len;
 
-	bfa_assert(uf->data_len >= sizeof(struct fchs_s));
+	WARN_ON(uf->data_len < sizeof(struct fchs_s));
 
 	if (uf->data_len == sizeof(struct fchs_s)) {
 		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_UF, BFA_PL_EID_RX,
@@ -5072,7 +5072,7 @@ bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 
 	default:
 		bfa_trc(bfa, msg->mhdr.msg_id);
-		bfa_assert(0);
+		WARN_ON(1);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index c80540e..4e94d28 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -532,7 +532,7 @@ bfad_hal_mem_release(struct bfad_s *bfad)
 					(dma_addr_t) meminfo_elem->dma);
 				break;
 			default:
-				bfa_assert(0);
+				WARN_ON(1);
 				break;
 			}
 		}
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 53cea3d..f0bcda8 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -449,7 +449,7 @@ bfa_fcb_itnim_free(struct bfad_s *bfad, struct bfad_itnim_s *itnim_drv)
 	struct bfad_im_s	*im = itnim_drv->im;
 
 	/* online to free state transtion should not happen */
-	bfa_assert(itnim_drv->state != ITNIM_STATE_ONLINE);
+	WARN_ON(itnim_drv->state == ITNIM_STATE_ONLINE);
 
 	itnim_drv->queue_work = 1;
 	/* offline request is not yet done, use the same request to free */
@@ -664,7 +664,7 @@ bfad_im_port_clean(struct bfad_im_port_s *im_port)
 	}
 
 	/* the itnim_mapped_list must be empty at this time */
-	bfa_assert(list_empty(&im_port->itnim_mapped_list));
+	WARN_ON(!list_empty(&im_port->itnim_mapped_list));
 
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
@@ -1111,7 +1111,7 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 		kfree(itnim);
 		break;
 	default:
-		bfa_assert(0);
+		WARN_ON(1);
 		break;
 	}
 
-- 
1.6.5.2

