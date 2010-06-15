From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 15/23] bfa: add dynamic queue selection
Date: Tue, 15 Jun 2010 11:45:39 -0700
Message-ID: <1276627539-28077-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:42278 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758508Ab0FOSpp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:45:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Add new bfa functionality to support dynamic queue selection (IO redirection).
IO redirection can only be enabled when QoS is disabled.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_cb_ioim_macros.h           |    7 ++++-
 drivers/scsi/bfa/bfa_fcpim.c                    |   24 +++++++++++++++++++
 drivers/scsi/bfa/bfa_fcpim_priv.h               |    5 +++-
 drivers/scsi/bfa/bfa_fcport.c                   |   13 +++++++++-
 drivers/scsi/bfa/bfa_hw_cb.c                    |    7 ++++-
 drivers/scsi/bfa/bfa_hw_ct.c                    |    7 ++++-
 drivers/scsi/bfa/bfa_intr.c                     |    1 +
 drivers/scsi/bfa/bfa_iocfc.c                    |    2 +
 drivers/scsi/bfa/bfa_iocfc.h                    |    9 ++++++-
 drivers/scsi/bfa/bfa_ioim.c                     |   29 ++++++++++++++--------
 drivers/scsi/bfa/bfad_im.c                      |    9 +++++++
 drivers/scsi/bfa/include/bfa_fcpim.h            |   20 +++++++++++++++-
 drivers/scsi/bfa/include/bfa_svc.h              |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h |    2 +-
 14 files changed, 117 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_cb_ioim_macros.h b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
index 53a616f..3906ed9 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim_macros.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
@@ -171,6 +171,11 @@ bfa_cb_ioim_get_cdblen(struct bfad_ioim_s *dio)
 	return cmnd->cmd_len;
 }
 
-
+/**
+ * Assign queue to be used for the I/O request. This value depends on whether
+ * the driver wants to use the queues via any specific algorithm. Currently,
+ * this is not supported.
+ */
+#define bfa_cb_ioim_get_reqq(__dio) BFA_FALSE
 
 #endif /* __BFA_HCB_IOIM_MACROS_H__ */
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 12849e9..8c703d8 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -167,4 +167,28 @@ bfa_fcpim_qdepth_get(struct bfa_s *bfa)
 	return fcpim->q_depth;
 }
 
+void
+bfa_fcpim_update_ioredirect(struct bfa_s *bfa)
+{
+	bfa_boolean_t ioredirect;
+
+	/*
+	 * IO redirection is turned off when QoS is enabled and vice versa
+	 */
+	ioredirect = bfa_fcport_is_qos_enabled(bfa) ? BFA_FALSE : BFA_TRUE;
 
+	/*
+	 * Notify the bfad module of a possible state change in
+	 * IO redirection capability, due to a QoS state change. bfad will
+	 * check on the support for io redirection and update the
+	 * fcpim's ioredirect state accordingly.
+	 */
+	bfa_cb_ioredirect_state_change((void *)(bfa->bfad), ioredirect);
+}
+
+void
+bfa_fcpim_set_ioredirect(struct bfa_s *bfa, bfa_boolean_t state)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	fcpim->ioredirect = state;
+}
diff --git a/drivers/scsi/bfa/bfa_fcpim_priv.h b/drivers/scsi/bfa/bfa_fcpim_priv.h
index 3db39da..762516c 100644
--- a/drivers/scsi/bfa/bfa_fcpim_priv.h
+++ b/drivers/scsi/bfa/bfa_fcpim_priv.h
@@ -49,7 +49,8 @@ struct bfa_fcpim_mod_s {
 	int			num_tskim_reqs;
 	u32		path_tov;
 	u16		q_depth;
-	u16		rsvd;
+	u8              reqq;           /* Request queue to be used */
+	u8		rsvd;
 	struct list_head 	itnim_q;        /*  queue of active itnim    */
 	struct list_head 	ioim_free_q;    /*  free IO resources        */
 	struct list_head 	ioim_resfree_q; /*  IOs waiting for f/w      */
@@ -58,6 +59,7 @@ struct bfa_fcpim_mod_s {
 	u32	ios_active;	/*  current active IOs	      */
 	u32	delay_comp;
 	struct bfa_fcpim_stats_s stats;
+	bfa_boolean_t           ioredirect;
 };
 
 struct bfa_ioim_s;
@@ -82,6 +84,7 @@ struct bfa_ioim_s {
 	struct bfa_cb_qe_s hcb_qe;	/*  bfa callback qelem       */
 	bfa_cb_cbfn_t io_cbfn;		/*  IO completion handler    */
 	struct bfa_ioim_sp_s *iosp;	/*  slow-path IO handling    */
+	u8 reqq;           		/* Request queue for I/O    */
 };
 
 struct bfa_ioim_sp_s {
diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index d3b5efb..e0e7a0d 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -1857,8 +1857,13 @@ bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
 
 	bfa_trc(bfa, ioc_type);
 
-	if (ioc_type == BFA_IOC_TYPE_FC)
+	if (ioc_type == BFA_IOC_TYPE_FC) {
 		fcport->cfg.qos_enabled = on_off;
+		/**
+		 * Notify fcpim of the change in QoS state
+		 */
+		bfa_fcpim_update_ioredirect(bfa);
+	}
 }
 
 void
@@ -1942,4 +1947,10 @@ bfa_fcport_is_linkup(struct bfa_s *bfa)
 	return bfa_sm_cmp_state(BFA_FCPORT_MOD(bfa), bfa_fcport_sm_linkup);
 }
 
+bfa_boolean_t
+bfa_fcport_is_qos_enabled(struct bfa_s *bfa)
+{
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
+	return fcport->cfg.qos_enabled;
+}
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index 871a4e2..edfd729 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -152,4 +152,9 @@ bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix)
 	bfa->iocfc.hwif.hw_rspq_ack = bfa_hwcb_rspq_ack_msix;
 }
 
-
+void
+bfa_hwcb_msix_get_rme_range(struct bfa_s *bfa, u32 *start, u32 *end)
+{
+	*start = BFA_MSIX_RME_Q0;
+	*end = BFA_MSIX_RME_Q7;
+}
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index 76ceb9a..a357fb3 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -168,4 +168,9 @@ bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix)
 	bfa_ioc_isr_mode_set(&bfa->ioc, msix);
 }
 
-
+void
+bfa_hwct_msix_get_rme_range(struct bfa_s *bfa, u32 *start, u32 *end)
+{
+	*start = BFA_MSIX_RME_Q0;
+	*end = BFA_MSIX_RME_Q3;
+}
diff --git a/drivers/scsi/bfa/bfa_intr.c b/drivers/scsi/bfa/bfa_intr.c
index 0eba3f9..4936788 100644
--- a/drivers/scsi/bfa/bfa_intr.c
+++ b/drivers/scsi/bfa/bfa_intr.c
@@ -134,6 +134,7 @@ bfa_isr_enable(struct bfa_s *bfa)
 
 	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr_unmask);
 	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, ~intr_unmask);
+	bfa->iocfc.intr_mask = ~intr_unmask;
 	bfa_isr_mode_set(bfa, bfa->msix.nvecs != 0);
 }
 
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index 0776d74..90820be 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -187,6 +187,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		iocfc->hwif.hw_msix_uninstall = bfa_hwct_msix_uninstall;
 		iocfc->hwif.hw_isr_mode_set = bfa_hwct_isr_mode_set;
 		iocfc->hwif.hw_msix_getvecs = bfa_hwct_msix_getvecs;
+		iocfc->hwif.hw_msix_get_rme_range = bfa_hwct_msix_get_rme_range;
 	} else {
 		iocfc->hwif.hw_reginit = bfa_hwcb_reginit;
 		iocfc->hwif.hw_reqq_ack = bfa_hwcb_reqq_ack;
@@ -196,6 +197,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		iocfc->hwif.hw_msix_uninstall = bfa_hwcb_msix_uninstall;
 		iocfc->hwif.hw_isr_mode_set = bfa_hwcb_isr_mode_set;
 		iocfc->hwif.hw_msix_getvecs = bfa_hwcb_msix_getvecs;
+		iocfc->hwif.hw_msix_get_rme_range = bfa_hwcb_msix_get_rme_range;
 	}
 
 	iocfc->hwif.hw_reginit(bfa);
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
index 2b28103..74a6a04 100644
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ b/drivers/scsi/bfa/bfa_iocfc.h
@@ -63,6 +63,8 @@ struct bfa_hwif_s {
 	void (*hw_isr_mode_set)(struct bfa_s *bfa, bfa_boolean_t msix);
 	void (*hw_msix_getvecs)(struct bfa_s *bfa, u32 *vecmap,
 			u32 *nvecs, u32 *maxvec);
+	void (*hw_msix_get_rme_range) (struct bfa_s *bfa, u32 *start,
+			u32 *end);
 };
 typedef void (*bfa_cb_iocfc_t) (void *cbarg, enum bfa_status status);
 
@@ -104,7 +106,8 @@ struct bfa_iocfc_s {
 	struct bfa_hwif_s	hwif;
 
 	bfa_cb_iocfc_t		updateq_cbfn; /*  bios callback function */
-	void				*updateq_cbarg;	/*  bios callback arg */
+	void			*updateq_cbarg;	/*  bios callback arg */
+	u32			intr_mask;
 };
 
 #define bfa_lpuid(__bfa)		bfa_ioc_portid(&(__bfa)->ioc)
@@ -119,6 +122,8 @@ struct bfa_iocfc_s {
 #define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)	\
 	((__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap,	\
 		 __nvecs, __maxvec))
+#define bfa_msix_get_rme_range(__bfa, __start, __end)   \
+	((__bfa)->iocfc.hwif.hw_msix_get_rme_range(__bfa, __start, __end))
 
 /*
  * FC specific IOC functions.
@@ -154,6 +159,7 @@ void bfa_hwcb_msix_uninstall(struct bfa_s *bfa);
 void bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
 void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
 			u32 *nvecs, u32 *maxvec);
+void bfa_hwcb_msix_get_rme_range(struct bfa_s *bfa, u32 *start, u32 *end);
 void bfa_hwct_reginit(struct bfa_s *bfa);
 void bfa_hwct_reqq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
@@ -163,6 +169,7 @@ void bfa_hwct_msix_uninstall(struct bfa_s *bfa);
 void bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
 void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
 			u32 *nvecs, u32 *maxvec);
+void bfa_hwct_msix_get_rme_range(struct bfa_s *bfa, u32 *start, u32 *end);
 
 void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
 void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index 687f3d6..680b87d 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -234,8 +234,8 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 			bfa_sm_set_state(ioim, bfa_ioim_sm_abort);
 		else {
 			bfa_sm_set_state(ioim, bfa_ioim_sm_abort_qfull);
-			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
-					  &ioim->iosp->reqq_wait);
+			bfa_reqq_wait(ioim->bfa, ioim->reqq,
+					&ioim->iosp->reqq_wait);
 		}
 		break;
 
@@ -247,8 +247,8 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
 		else {
 			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
-			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
-					  &ioim->iosp->reqq_wait);
+			bfa_reqq_wait(ioim->bfa, ioim->reqq,
+					&ioim->iosp->reqq_wait);
 		}
 		break;
 
@@ -305,7 +305,7 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
 		else {
 			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
-			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+			bfa_reqq_wait(ioim->bfa, ioim->reqq,
 					  &ioim->iosp->reqq_wait);
 		}
 		break;
@@ -738,9 +738,9 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	/**
 	 * check for room in queue to send request now
 	 */
-	m = bfa_reqq_next(ioim->bfa, itnim->reqq);
+	m = bfa_reqq_next(ioim->bfa, ioim->reqq);
 	if (!m) {
-		bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+		bfa_reqq_wait(ioim->bfa, ioim->reqq,
 				  &ioim->iosp->reqq_wait);
 		return BFA_FALSE;
 	}
@@ -832,7 +832,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(ioim->bfa, itnim->reqq);
+	bfa_reqq_produce(ioim->bfa, ioim->reqq);
 	return BFA_TRUE;
 }
 
@@ -930,14 +930,13 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 static          bfa_boolean_t
 bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
 {
-	struct bfa_itnim_s          *itnim = ioim->itnim;
 	struct bfi_ioim_abort_req_s *m;
 	enum bfi_ioim_h2i       msgop;
 
 	/**
 	 * check for room in queue to send request now
 	 */
-	m = bfa_reqq_next(ioim->bfa, itnim->reqq);
+	m = bfa_reqq_next(ioim->bfa, ioim->reqq);
 	if (!m)
 		return BFA_FALSE;
 
@@ -956,7 +955,7 @@ bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
 	/**
 	 * queue I/O message to firmware
 	 */
-	bfa_reqq_produce(ioim->bfa, itnim->reqq);
+	bfa_reqq_produce(ioim->bfa, ioim->reqq);
 	return BFA_TRUE;
 }
 
@@ -1306,6 +1305,14 @@ void
 bfa_ioim_start(struct bfa_ioim_s *ioim)
 {
 	bfa_trc_fp(ioim->bfa, ioim->iotag);
+
+	/**
+	 * Obtain the queue over which this request has to be issued
+	 */
+	ioim->reqq = bfa_fcpim_ioredirect_enabled(ioim->bfa) ?
+			bfa_cb_ioim_get_reqq(ioim->dio) :
+			bfa_itnim_get_reqq(ioim);
+
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_START);
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 943bc4b..ffbec9b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -702,6 +702,15 @@ bfad_im_probe_undo(struct bfad_s *bfad)
 	}
 }
 
+/**
+ * Call back function to handle IO redirection state change
+ */
+void
+bfa_cb_ioredirect_state_change(void *hcb_bfad, bfa_boolean_t ioredirect)
+{
+	/* Do nothing */
+}
+
 struct Scsi_Host *
 bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 {
diff --git a/drivers/scsi/bfa/include/bfa_fcpim.h b/drivers/scsi/bfa/include/bfa_fcpim.h
index 0478979..4bc9453 100644
--- a/drivers/scsi/bfa/include/bfa_fcpim.h
+++ b/drivers/scsi/bfa/include/bfa_fcpim.h
@@ -42,6 +42,24 @@ u16	bfa_fcpim_qdepth_get(struct bfa_s *bfa);
 bfa_status_t bfa_fcpim_get_modstats(struct bfa_s *bfa,
 			struct bfa_fcpim_stats_s *modstats);
 bfa_status_t bfa_fcpim_clr_modstats(struct bfa_s *bfa);
+void bfa_fcpim_set_ioredirect(struct bfa_s *bfa, bfa_boolean_t state);
+void bfa_fcpim_update_ioredirect(struct bfa_s *bfa);
+void bfa_cb_ioredirect_state_change(void *hcb_bfad, bfa_boolean_t ioredirect);
+
+#define bfa_fcpim_ioredirect_enabled(__bfa)                             \
+	(((struct bfa_fcpim_mod_s *)(BFA_FCPIM_MOD(__bfa)))->ioredirect)
+
+#define bfa_fcpim_get_next_reqq(__bfa, __qid)                           \
+{                                                                       \
+	struct bfa_fcpim_mod_s *__fcpim = BFA_FCPIM_MOD(__bfa);         \
+	__fcpim->reqq++;                                                \
+	__fcpim->reqq &= (BFI_IOC_MAX_CQS - 1);                          \
+	*(__qid) = __fcpim->reqq;                                       \
+}
+
+#define bfa_iocfc_map_msg_to_qid(__msg, __qid)                          \
+	*(__qid) = (u8)((__msg) & (BFI_IOC_MAX_CQS - 1));
+
 
 /*
  * bfa itnim API functions
@@ -56,6 +74,7 @@ void		bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
 			struct bfa_itnim_hal_stats_s *stats);
 void		bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
 
+#define bfa_itnim_get_reqq(__ioim) (((struct bfa_ioim_s *)__ioim)->itnim->reqq)
 
 /**
  * 		BFA completion callback for bfa_itnim_online().
@@ -156,4 +175,3 @@ void		bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 				  enum bfi_tskim_status tsk_status);
 
 #endif /* __BFA_FCPIM_H__ */
-
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 1349b99..7840943 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -215,6 +215,7 @@ bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
 		bfa_cb_pport_t cbfn, void *cbarg);
 bfa_status_t bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
 		void *cbarg);
+bfa_boolean_t bfa_fcport_is_qos_enabled(struct bfa_s *bfa);
 
 /*
  * bfa rport API functions
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_driver.h b/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
index 50382dd..7d00d00 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
@@ -29,7 +29,7 @@ struct bfa_driver_stats_s {
     u16    tm_target_reset;
     u16    tm_bus_reset;
     u16    ioc_restart;        /*  IOC restart count */
-    u16    io_pending;         /*  outstanding io count per-IOC */
+    u16    rsvd;
     u64    control_req;
     u64    input_req;
     u64    output_req;
-- 
1.6.5.2

