From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 1/7] bfa: remove unused and empty functions
Date: Thu, 9 Dec 2010 19:07:46 -0800
Message-ID: <1291950466-10699-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44579 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab0LJDHy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:07:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>

Removed unused and empty functions.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <xmzhang@brocade.com>
---
 drivers/scsi/bfa/bfa.h           |   10 --
 drivers/scsi/bfa/bfa_core.c      |   79 +------------
 drivers/scsi/bfa/bfa_fcpim.c     |   82 +------------
 drivers/scsi/bfa/bfa_fcpim.h     |    4 -
 drivers/scsi/bfa/bfa_fcs.c       |   20 ---
 drivers/scsi/bfa/bfa_fcs.h       |   20 ---
 drivers/scsi/bfa/bfa_fcs_lport.c |   49 -------
 drivers/scsi/bfa/bfa_fcs_rport.c |  116 -----------------
 drivers/scsi/bfa/bfa_ioc.c       |   23 +---
 drivers/scsi/bfa/bfa_ioc.h       |    1 -
 drivers/scsi/bfa/bfa_plog.h      |    3 -
 drivers/scsi/bfa/bfa_port.c      |   14 --
 drivers/scsi/bfa/bfa_port.h      |    1 -
 drivers/scsi/bfa/bfa_svc.c       |  260 --------------------------------------
 drivers/scsi/bfa/bfa_svc.h       |   32 -----
 15 files changed, 4 insertions(+), 710 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index ff2bd07..7ed13ce 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -33,7 +33,6 @@ typedef void    (*bfa_cb_cbfn_t) (void *cbarg, bfa_boolean_t complete);
  * Interrupt message handlers
  */
 void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
-void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
 
 /*
  * Request and response queue related defines
@@ -397,8 +396,6 @@ void bfa_cb_init(void *bfad, bfa_status_t status);
 void bfa_cb_updateq(void *bfad, bfa_status_t status);
 
 bfa_boolean_t bfa_intx(struct bfa_s *bfa);
-void bfa_intx_disable(struct bfa_s *bfa);
-void bfa_intx_enable(struct bfa_s *bfa);
 void bfa_isr_enable(struct bfa_s *bfa);
 void bfa_isr_disable(struct bfa_s *bfa);
 
@@ -410,16 +407,12 @@ typedef void (*bfa_cb_ioc_t) (void *cbarg, enum bfa_status status);
 void bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr);
 void bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr);
 
-void bfa_adapter_get_attr(struct bfa_s *bfa,
-			  struct bfa_adapter_attr_s *ad_attr);
-u64 bfa_adapter_get_id(struct bfa_s *bfa);
 
 bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
 				   struct bfa_iocfc_intr_attr_s *attr);
 
 void bfa_iocfc_enable(struct bfa_s *bfa);
 void bfa_iocfc_disable(struct bfa_s *bfa);
-void bfa_chip_reset(struct bfa_s *bfa);
 void bfa_timer_tick(struct bfa_s *bfa);
 #define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)		\
 	bfa_timer_begin(&(_bfa)->timer_mod, _timer, _timercb, _arg, _timeout)
@@ -431,8 +424,5 @@ bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
 bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
 bfa_status_t bfa_debug_fwcore(struct bfa_s *bfa, void *buf,
 			      u32 *offset, int *buflen);
-void bfa_debug_fwsave_clear(struct bfa_s *bfa);
-bfa_status_t bfa_fw_stats_get(struct bfa_s *bfa, void *data);
-bfa_status_t bfa_fw_stats_clear(struct bfa_s *bfa);
 
 #endif /* __BFA_H__ */
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 2345f48..90e0f81 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -104,9 +104,6 @@ bfa_msix_all(struct bfa_s *bfa, int vec)
 	bfa_intx(bfa);
 }
 
-/*
- *  hal_intr_api
- */
 bfa_boolean_t
 bfa_intx(struct bfa_s *bfa)
 {
@@ -151,18 +148,6 @@ bfa_intx(struct bfa_s *bfa)
 }
 
 void
-bfa_intx_enable(struct bfa_s *bfa)
-{
-	writel(bfa->iocfc.intr_mask, bfa->iocfc.bfa_regs.intr_mask);
-}
-
-void
-bfa_intx_disable(struct bfa_s *bfa)
-{
-	writel(-1L, bfa->iocfc.bfa_regs.intr_mask);
-}
-
-void
 bfa_isr_enable(struct bfa_s *bfa)
 {
 	u32 intr_unmask;
@@ -317,18 +302,12 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 	}
 }
 
-void
-bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func)
-{
-	bfa_isrs[mc] = isr_func;
-}
-
 /*
  * BFA IOC FC related functions
  */
 
 /*
- *  hal_ioc_pvt BFA IOC private functions
+ *  BFA IOC private functions
  */
 
 static void
@@ -735,9 +714,6 @@ bfa_iocfc_reset_cbfn(void *bfa_arg)
 	bfa_isr_enable(bfa);
 }
 
-/*
- *  hal_ioc_public
- */
 
 /*
  * Query IOC memory requirement information.
@@ -857,18 +833,6 @@ bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m)
 }
 
 void
-bfa_adapter_get_attr(struct bfa_s *bfa, struct bfa_adapter_attr_s *ad_attr)
-{
-	bfa_ioc_get_adapter_attr(&bfa->ioc, ad_attr);
-}
-
-u64
-bfa_adapter_get_id(struct bfa_s *bfa)
-{
-	return bfa_ioc_get_adid(&bfa->ioc);
-}
-
-void
 bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr)
 {
 	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
@@ -998,9 +962,6 @@ bfa_iocfc_get_pbc_vports(struct bfa_s *bfa, struct bfi_pbc_vport_s *pbc_vport)
 	return cfgrsp->pbc_cfg.nvports;
 }
 
-/*
- *  hal_api
- */
 
 /*
  * Use this function query the memory requirement of the BFA library.
@@ -1338,15 +1299,6 @@ bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
 }
 
 /*
- * Clear the saved firmware trace information of an IOC.
- */
-void
-bfa_debug_fwsave_clear(struct bfa_s *bfa)
-{
-	bfa_ioc_debug_fwsave_clear(&bfa->ioc);
-}
-
-/*
  * Fetch firmware trace data.
  *
  * @param[in]		bfa			BFA instance
@@ -1378,32 +1330,3 @@ bfa_debug_fwcore(struct bfa_s *bfa, void *buf, u32 *offset, int *buflen)
 {
 	return bfa_ioc_debug_fwcore(&bfa->ioc, buf, offset, buflen);
 }
-/*
- * Reset hw semaphore & usage cnt regs and initialize.
- */
-void
-bfa_chip_reset(struct bfa_s *bfa)
-{
-	bfa_ioc_ownership_reset(&bfa->ioc);
-	bfa_ioc_pll_init(&bfa->ioc);
-}
-
-/*
- * Fetch firmware statistics data.
- *
- * @param[in]		bfa		BFA instance
- * @param[out]		data		Firmware stats buffer
- *
- * @retval BFA_STATUS_OK		Firmware trace is fetched.
- */
-bfa_status_t
-bfa_fw_stats_get(struct bfa_s *bfa, void *data)
-{
-	return bfa_ioc_fw_stats_get(&bfa->ioc, data);
-}
-
-bfa_status_t
-bfa_fw_stats_clear(struct bfa_s *bfa)
-{
-	return bfa_ioc_fw_stats_clear(&bfa->ioc);
-}
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 135c442..0e7f380 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -107,9 +107,6 @@ enum bfa_itnim_event {
 	if ((__fcpim)->profile_start)					\
 		(__fcpim)->profile_start(__ioim);			\
 } while (0)
-/*
- *  hal_ioim_sm
- */
 
 /*
  * IO state machine events
@@ -295,7 +292,7 @@ static void     bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim,
 					enum bfa_tskim_event event);
 
 /*
- *  hal_fcpim_mod BFA FCP Initiator Mode module
+ *  BFA FCP Initiator Mode module
  */
 
 /*
@@ -357,10 +354,6 @@ bfa_fcpim_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 static void
 bfa_fcpim_detach(struct bfa_s *bfa)
 {
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-
-	bfa_ioim_detach(fcpim);
-	bfa_tskim_detach(fcpim);
 }
 
 static void
@@ -1587,13 +1580,6 @@ bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
 }
 
 void
-bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
-	struct bfa_itnim_iostats_s *stats)
-{
-	*stats = itnim->stats;
-}
-
-void
 bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
 {
 	int j;
@@ -2213,11 +2199,6 @@ bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 
-
-/*
- *  hal_ioim_private
- */
-
 static void
 __bfa_cb_ioim_good_comp(void *cbarg, bfa_boolean_t complete)
 {
@@ -2421,25 +2402,6 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	    (bfa_cb_ioim_get_size(ioim->dio) & (sizeof(u32) - 1)))
 		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
 
-#ifdef IOIM_ADVANCED
-	m->cmnd.crn = bfa_cb_ioim_get_crn(ioim->dio);
-	m->cmnd.priority = bfa_cb_ioim_get_priority(ioim->dio);
-	m->cmnd.taskattr = bfa_cb_ioim_get_taskattr(ioim->dio);
-
-	/*
-	 * Handle large CDB (>16 bytes).
-	 */
-	m->cmnd.addl_cdb_len = (bfa_cb_ioim_get_cdblen(ioim->dio) -
-					FCP_CMND_CDB_LEN) / sizeof(u32);
-	if (m->cmnd.addl_cdb_len) {
-		memcpy(&m->cmnd.cdb + 1, (scsi_cdb_t *)
-				bfa_cb_ioim_get_cdb(ioim->dio) + 1,
-				m->cmnd.addl_cdb_len * sizeof(u32));
-		fcp_cmnd_fcpdl(&m->cmnd) =
-				cpu_to_be32(bfa_cb_ioim_get_size(ioim->dio));
-	}
-#endif
-
 	/*
 	 * queue I/O message to firmware
 	 */
@@ -2653,11 +2615,6 @@ bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 }
 
 
-
-/*
- *  hal_ioim_friend
- */
-
 /*
  * Memory allocation and initialization.
  */
@@ -2722,14 +2679,6 @@ bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 	}
 }
 
-/*
- * Driver detach time call.
- */
-void
-bfa_ioim_detach(struct bfa_fcpim_mod_s *fcpim)
-{
-}
-
 void
 bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 {
@@ -2903,11 +2852,6 @@ bfa_ioim_tov(struct bfa_ioim_s *ioim)
 }
 
 
-
-/*
- *  hal_ioim_api
- */
-
 /*
  * Allocate IOIM resource for initiator mode I/O request.
  */
@@ -3234,11 +3178,6 @@ bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 }
 
 
-
-/*
- *  hal_tskim_private
- */
-
 static void
 __bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete)
 {
@@ -3452,11 +3391,6 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 }
 
 
-
-/*
- *  hal_tskim_friend
- */
-
 /*
  * Notification on completions from related ioim.
  */
@@ -3522,14 +3456,6 @@ bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 }
 
 void
-bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim)
-{
-	/*
-	* @todo
-	*/
-}
-
-void
 bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 {
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
@@ -3556,12 +3482,6 @@ bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 }
 
 
-
-/*
- *  hal_tskim_api
- */
-
-
 struct bfa_tskim_s *
 bfa_tskim_alloc(struct bfa_s *bfa, struct bfad_tskim_s *dtsk)
 {
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index db53717..18bdc44 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -220,7 +220,6 @@ bfa_ioim_get_iotag(struct bfa_ioim_s *ioim)
  */
 void	bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim,
 					struct bfa_meminfo_s *minfo);
-void	bfa_ioim_detach(struct bfa_fcpim_mod_s *fcpim);
 void	bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 void	bfa_ioim_good_comp_isr(struct bfa_s *bfa,
 					struct bfi_msg_s *msg);
@@ -232,7 +231,6 @@ void	bfa_ioim_tov(struct bfa_ioim_s *ioim);
 
 void	bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim,
 					struct bfa_meminfo_s *minfo);
-void	bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim);
 void	bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 void	bfa_tskim_iodone(struct bfa_tskim_s *tskim);
 void	bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
@@ -296,8 +294,6 @@ void		bfa_itnim_delete(struct bfa_itnim_s *itnim);
 void		bfa_itnim_online(struct bfa_itnim_s *itnim,
 				 bfa_boolean_t seq_rec);
 void		bfa_itnim_offline(struct bfa_itnim_s *itnim);
-void		bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
-			struct bfa_itnim_iostats_s *stats);
 void		bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
 bfa_status_t	bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
 		struct bfa_itnim_ioprofile_s *ioprofile);
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index c94502d..5e192f3 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -1038,14 +1038,6 @@ bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_START);
 }
 
-/*
- *   Suspend fabric activity as part of driver suspend.
- */
-void
-bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs)
-{
-}
-
 bfa_boolean_t
 bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric)
 {
@@ -1147,18 +1139,6 @@ bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric)
 }
 
 /*
- *	brief
- *
- */
-bfa_status_t
-bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf, struct bfa_fcs_s *fcs,
-		     struct bfa_lport_cfg_s *port_cfg, struct bfad_vf_s *vf_drv)
-{
-	bfa_sm_set_state(vf, bfa_fcs_fabric_sm_uninit);
-	return BFA_STATUS_OK;
-}
-
-/*
  * Lookup for a vport withing a fabric given its pwwn
  */
 struct bfa_fcs_vport_s *
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 5a8b928..fcb54e5 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -316,8 +316,6 @@ void            bfa_fcs_lport_add_rport(struct bfa_fcs_lport_s *port,
 				       struct bfa_fcs_rport_s *rport);
 void            bfa_fcs_lport_del_rport(struct bfa_fcs_lport_s *port,
 				       struct bfa_fcs_rport_s *rport);
-void bfa_fcs_lport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_lport_modexit(struct bfa_fcs_s *fcs);
 void            bfa_fcs_lport_ns_init(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_ns_offline(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_ns_online(struct bfa_fcs_lport_s *vport);
@@ -359,9 +357,6 @@ bfa_status_t bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
 			    struct bfa_vport_attr_s *vport_attr);
-void bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
-			     struct bfa_vport_stats_s *vport_stats);
-void bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport);
 struct bfa_fcs_vport_s *bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs,
 					     u16 vf_id, wwn_t vpwwn);
 void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
@@ -437,23 +432,12 @@ bfa_fcs_rport_get_halrport(struct bfa_fcs_rport_s *rport)
 /*
  * bfa fcs rport API functions
  */
-bfa_status_t bfa_fcs_rport_add(struct bfa_fcs_lport_s *port, wwn_t *pwwn,
-			       struct bfa_fcs_rport_s *rport,
-			       struct bfad_rport_s *rport_drv);
-bfa_status_t bfa_fcs_rport_remove(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
-			    struct bfa_rport_attr_s *attr);
-void bfa_fcs_rport_get_stats(struct bfa_fcs_rport_s *rport,
-			     struct bfa_rport_stats_s *stats);
-void bfa_fcs_rport_clear_stats(struct bfa_fcs_rport_s *rport);
 struct bfa_fcs_rport_s *bfa_fcs_rport_lookup(struct bfa_fcs_lport_s *port,
 					     wwn_t rpwwn);
 struct bfa_fcs_rport_s *bfa_fcs_rport_lookup_by_nwwn(
 	struct bfa_fcs_lport_s *port, wwn_t rnwwn);
 void bfa_fcs_rport_set_del_timeout(u8 rport_tmo);
 
-void bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport,
-			     enum bfa_port_speed speed);
 void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport,
 	 struct fchs_s *fchs, u16 len);
 void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
@@ -689,7 +673,6 @@ u16 bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
@@ -707,9 +690,6 @@ bfa_boolean_t	bfa_fcs_fabric_is_auth_failed(struct bfa_fcs_fabric_s *fabric);
 enum bfa_port_type bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric);
 void	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
 void	bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric);
-bfa_status_t	bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf,
-			struct bfa_fcs_s *fcs, struct bfa_lport_cfg_s *port_cfg,
-			struct bfad_vf_s *vf_drv);
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 	       wwn_t fabric_name);
 u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index bf85ca7..d3e2ad4 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -589,28 +589,6 @@ bfa_fcs_lport_deleted(struct bfa_fcs_lport_s *port)
 }
 
 
-
-/*
- *  fcs_lport_api BFA FCS port API
- */
-/*
- *   Module initialization
- */
-void
-bfa_fcs_lport_modinit(struct bfa_fcs_s *fcs)
-{
-
-}
-
-/*
- *   Module cleanup
- */
-void
-bfa_fcs_lport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
-
 /*
  * Unsolicited frame receive handling.
  */
@@ -5620,33 +5598,6 @@ bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
 	attr->vport_state = bfa_sm_to_state(vport_sm_table, vport->sm);
 }
 
-/*
- *	Use this function to get vport's statistics.
- *
- *	param[in]	vport	pointer to bfa_fcs_vport_t.
- *	param[out]	stats	pointer to return vport statistics in
- *
- *	return None
- */
-void
-bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
-			struct bfa_vport_stats_s *stats)
-{
-	*stats = vport->vport_stats;
-}
-
-/*
- *	Use this function to clear vport's statistics.
- *
- *	param[in]	vport	pointer to bfa_fcs_vport_t.
- *
- *	return None
- */
-void
-bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport)
-{
-	memset(&vport->vport_stats, 0, sizeof(struct bfa_vport_stats_s));
-}
 
 /*
  *	Lookup a virtual port. Excludes base port from lookup.
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 1717d1d..ecf8dd7 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2613,106 +2613,6 @@ bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, __be16 ox_id)
  *  fcs_rport_api FCS rport API.
  */
 
-/*
- *	Direct API to add a target by port wwn. This interface is used, for
- *	example, by bios when target pwwn is known from boot lun configuration.
- */
-bfa_status_t
-bfa_fcs_rport_add(struct bfa_fcs_lport_s *port, wwn_t *pwwn,
-		struct bfa_fcs_rport_s *rport, struct bfad_rport_s *rport_drv)
-{
-	bfa_trc(port->fcs, *pwwn);
-
-	return BFA_STATUS_OK;
-}
-
-/*
- *	Direct API to remove a target and its associated resources. This
- *	interface is used, for example, by driver to remove target
- *	ports from the target list for a VM.
- */
-bfa_status_t
-bfa_fcs_rport_remove(struct bfa_fcs_rport_s *rport_in)
-{
-
-	struct bfa_fcs_rport_s *rport;
-
-	bfa_trc(rport_in->fcs, rport_in->pwwn);
-
-	rport = bfa_fcs_lport_get_rport_by_pwwn(rport_in->port, rport_in->pwwn);
-	if (rport == NULL) {
-		/*
-		 * TBD Error handling
-		 */
-		bfa_trc(rport_in->fcs, rport_in->pid);
-		return BFA_STATUS_UNKNOWN_RWWN;
-	}
-
-	/*
-	 * TBD if this remote port is online, send a logo
-	 */
-	return BFA_STATUS_OK;
-
-}
-
-/*
- *	Remote device status for display/debug.
- */
-void
-bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
-			struct bfa_rport_attr_s *rport_attr)
-{
-	struct bfa_rport_qos_attr_s qos_attr;
-	bfa_fcs_lport_t *port = rport->port;
-	bfa_port_speed_t rport_speed = rport->rpf.rpsc_speed;
-
-	memset(rport_attr, 0, sizeof(struct bfa_rport_attr_s));
-
-	rport_attr->pid = rport->pid;
-	rport_attr->pwwn = rport->pwwn;
-	rport_attr->nwwn = rport->nwwn;
-	rport_attr->cos_supported = rport->fc_cos;
-	rport_attr->df_sz = rport->maxfrsize;
-	rport_attr->state = bfa_fcs_rport_get_state(rport);
-	rport_attr->fc_cos = rport->fc_cos;
-	rport_attr->cisc = rport->cisc;
-	rport_attr->scsi_function = rport->scsi_function;
-	rport_attr->curr_speed  = rport->rpf.rpsc_speed;
-	rport_attr->assigned_speed  = rport->rpf.assigned_speed;
-
-	bfa_rport_get_qos_attr(rport->bfa_rport, &qos_attr);
-	rport_attr->qos_attr = qos_attr;
-
-	rport_attr->trl_enforced = BFA_FALSE;
-	if (bfa_fcport_is_ratelim(port->fcs->bfa)) {
-		if (rport_speed == BFA_PORT_SPEED_UNKNOWN) {
-			/* Use default ratelim speed setting */
-			rport_speed =
-				bfa_fcport_get_ratelim_speed(rport->fcs->bfa);
-		}
-
-		if (rport_speed < bfa_fcs_lport_get_rport_max_speed(port))
-			rport_attr->trl_enforced = BFA_TRUE;
-	}
-}
-
-/*
- *	Per remote device statistics.
- */
-void
-bfa_fcs_rport_get_stats(struct bfa_fcs_rport_s *rport,
-			struct bfa_rport_stats_s *stats)
-{
-	*stats = rport->stats;
-}
-
-void
-bfa_fcs_rport_clear_stats(struct bfa_fcs_rport_s *rport)
-{
-	memset((char *)&rport->stats, 0,
-			sizeof(struct bfa_rport_stats_s));
-}
-
 struct bfa_fcs_rport_s *
 bfa_fcs_rport_lookup(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 {
@@ -2744,22 +2644,6 @@ bfa_fcs_rport_lookup_by_nwwn(struct bfa_fcs_lport_s *port, wwn_t rnwwn)
 }
 
 /*
- * This API is to set the Rport's speed. Should be used when RPSC is not
- * supported by the rport.
- */
-void
-bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport, bfa_port_speed_t speed)
-{
-	rport->rpf.assigned_speed  = speed;
-
-	/* Set this speed in f/w only if the RPSC speed is not available */
-	if (rport->rpf.rpsc_speed == BFA_PORT_SPEED_UNKNOWN)
-		bfa_rport_speed(rport->bfa_rport, speed);
-}
-
-
-
-/*
  * Remote port features (RPF) implementation.
  */
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 23c2ef6..efd4c76 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -101,9 +101,6 @@ static void bfa_ioc_pf_disabled(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_failed(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc);
 
-/*
- *  hal_ioc_sm
- */
 
 /*
  * IOC state machine definitions/declarations
@@ -1101,7 +1098,7 @@ bfa_iocpf_sm_fail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 
 /*
- *  hal_ioc_pvt BFA IOC private functions
+ *  BFA IOC private functions
  */
 
 static void
@@ -1819,11 +1816,6 @@ bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 }
 
 
-
-/*
- *  hal_ioc_public
- */
-
 bfa_status_t
 bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 {
@@ -2456,9 +2448,6 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 	bfa_ioc_get_pci_chip_rev(ioc, ioc_attr->pci_attr.chip_rev);
 }
 
-/*
- *  hal_wwn_public
- */
 wwn_t
 bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
 {
@@ -2542,14 +2531,6 @@ bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 	return BFA_STATUS_OK;
 }
 
-/*
- * Clear saved firmware trace
- */
-void
-bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc)
-{
-	ioc->dbg_fwsave_once = BFA_TRUE;
-}
 
 /*
  * Retrieve saved firmware trace from a prior IOC failure.
@@ -2735,7 +2716,7 @@ bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc)
 }
 
 /*
- *  hal_iocpf_pvt BFA IOC PF private functions
+ *  BFA IOC PF private functions
  */
 
 static void
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index f8ac050..ff012f7 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -357,7 +357,6 @@ int bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover);
 void bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave);
 bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
 		int *trclen);
-void bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc);
 bfa_status_t bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata,
 				 int *trclen);
 bfa_status_t bfa_ioc_debug_fwcore(struct bfa_ioc_s *ioc, void *buf,
diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.h
index 501f0ed..bdcd8ec 100644
--- a/drivers/scsi/bfa/bfa_plog.h
+++ b/drivers/scsi/bfa/bfa_plog.h
@@ -151,9 +151,6 @@ void bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 void bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 			enum bfa_plog_eid event, u16 misc,
 			struct fchs_s *fchdr, u32 pld_w0);
-void bfa_plog_clear(struct bfa_plog_s *plog);
-void bfa_plog_enable(struct bfa_plog_s *plog);
-void bfa_plog_disable(struct bfa_plog_s *plog);
 bfa_boolean_t	bfa_plog_get_setting(struct bfa_plog_s *plog);
 
 #endif /* __BFA_PORTLOG_H__ */
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 35277cb..fa57b12 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -457,17 +457,3 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 
 	bfa_trc(port, 0);
 }
-
-/*
- * bfa_port_detach()
- *
- *
- * @param[in] port - Pointer to the Port module data structure
- *
- * @return void
- */
-void
-bfa_port_detach(struct bfa_port_s *port)
-{
-	bfa_trc(port, 0);
-}
diff --git a/drivers/scsi/bfa/bfa_port.h b/drivers/scsi/bfa/bfa_port.h
index dbce9df..c4ee9db 100644
--- a/drivers/scsi/bfa/bfa_port.h
+++ b/drivers/scsi/bfa/bfa_port.h
@@ -48,7 +48,6 @@ struct bfa_port_s {
 
 void	     bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 				void *dev, struct bfa_trc_mod_s *trcmod);
-void	     bfa_port_detach(struct bfa_port_s *port);
 void	     bfa_port_hbfail(void *arg);
 
 bfa_status_t bfa_port_get_stats(struct bfa_port_s *port,
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 71b9281..ef223ad 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -437,23 +437,6 @@ bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	}
 }
 
-void
-bfa_plog_clear(struct bfa_plog_s *plog)
-{
-	plog->head = plog->tail = 0;
-}
-
-void
-bfa_plog_enable(struct bfa_plog_s *plog)
-{
-	plog->plog_enabled = 1;
-}
-
-void
-bfa_plog_disable(struct bfa_plog_s *plog)
-{
-	plog->plog_enabled = 0;
-}
 
 bfa_boolean_t
 bfa_plog_get_setting(struct bfa_plog_s *plog)
@@ -1853,14 +1836,6 @@ bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
 }
 
-/*
- * Initiate a lport logout (flogi).
- */
-void
-bfa_lps_flogo(struct bfa_lps_s *lps)
-{
-	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
-}
 
 /*
  * Initiate a lport FDSIC logout.
@@ -3818,89 +3793,6 @@ bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn, void *cbarg)
 	return BFA_STATUS_OK;
 }
 
-/*
- * Fetch FCQoS port statistics
- */
-bfa_status_t
-bfa_fcport_get_qos_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
-	bfa_cb_port_t cbfn, void *cbarg)
-{
-	/* Meaningful only for FC mode */
-	bfa_assert(bfa_ioc_get_fcmode(&bfa->ioc));
-
-	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
-}
-
-/*
- * Reset FCoE port statistics
- */
-bfa_status_t
-bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn, void *cbarg)
-{
-	/* Meaningful only for FC mode */
-	bfa_assert(bfa_ioc_get_fcmode(&bfa->ioc));
-
-	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
-}
-
-/*
- * Fetch FCQoS port statistics
- */
-bfa_status_t
-bfa_fcport_get_fcoe_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
-	bfa_cb_port_t cbfn, void *cbarg)
-{
-	/* Meaningful only for FCoE mode */
-	bfa_assert(!bfa_ioc_get_fcmode(&bfa->ioc));
-
-	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
-}
-
-/*
- * Reset FCoE port statistics
- */
-bfa_status_t
-bfa_fcport_clear_fcoe_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn, void *cbarg)
-{
-	/* Meaningful only for FCoE mode */
-	bfa_assert(!bfa_ioc_get_fcmode(&bfa->ioc));
-
-	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
-}
-
-void
-bfa_fcport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	qos_attr->state = fcport->qos_attr.state;
-	qos_attr->total_bb_cr = be32_to_cpu(fcport->qos_attr.total_bb_cr);
-}
-
-void
-bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
-	struct bfa_qos_vc_attr_s *qos_vc_attr)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	struct bfa_qos_vc_attr_s *bfa_vc_attr = &fcport->qos_vc_attr;
-	u32 i = 0;
-
-	qos_vc_attr->total_vc_count = be16_to_cpu(bfa_vc_attr->total_vc_count);
-	qos_vc_attr->shared_credit  = be16_to_cpu(bfa_vc_attr->shared_credit);
-	qos_vc_attr->elp_opmode_flags  =
-			be32_to_cpu(bfa_vc_attr->elp_opmode_flags);
-
-	/* Individual VC info */
-	while (i < qos_vc_attr->total_vc_count) {
-		qos_vc_attr->vc_info[i].vc_credit	=
-				bfa_vc_attr->vc_info[i].vc_credit;
-		qos_vc_attr->vc_info[i].borrow_credit	=
-				bfa_vc_attr->vc_info[i].borrow_credit;
-		qos_vc_attr->vc_info[i].priority	=
-				bfa_vc_attr->vc_info[i].priority;
-		++i;
-	}
-}
 
 /*
  * Fetch port attributes.
@@ -3924,59 +3816,6 @@ bfa_fcport_is_ratelim(struct bfa_s *bfa)
 
 }
 
-void
-bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	enum bfa_ioc_type_e ioc_type = bfa_get_type(bfa);
-
-	bfa_trc(bfa, on_off);
-	bfa_trc(bfa, fcport->cfg.qos_enabled);
-
-	bfa_trc(bfa, ioc_type);
-
-	if (ioc_type == BFA_IOC_TYPE_FC) {
-		fcport->cfg.qos_enabled = on_off;
-		/*
-		 * Notify fcpim of the change in QoS state
-		 */
-		bfa_fcpim_update_ioredirect(bfa);
-	}
-}
-
-void
-bfa_fcport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	bfa_trc(bfa, on_off);
-	bfa_trc(bfa, fcport->cfg.ratelimit);
-
-	fcport->cfg.ratelimit = on_off;
-	if (fcport->cfg.trl_def_speed == BFA_PORT_SPEED_UNKNOWN)
-		fcport->cfg.trl_def_speed = BFA_PORT_SPEED_1GBPS;
-}
-
-/*
- * Configure default minimum ratelim speed
- */
-bfa_status_t
-bfa_fcport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_port_speed speed)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	bfa_trc(bfa, speed);
-
-	/* Auto and speeds greater than the supported speed, are invalid */
-	if ((speed == BFA_PORT_SPEED_AUTO) || (speed > fcport->speed_sup)) {
-		bfa_trc(bfa, fcport->speed_sup);
-		return BFA_STATUS_UNSUPP_SPEED;
-	}
-
-	fcport->cfg.trl_def_speed = speed;
-
-	return BFA_STATUS_OK;
-}
 
 /*
  * Get default minimum ratelim speed
@@ -3990,32 +3829,6 @@ bfa_fcport_get_ratelim_speed(struct bfa_s *bfa)
 	return fcport->cfg.trl_def_speed;
 
 }
-void
-bfa_fcport_busy(struct bfa_s *bfa, bfa_boolean_t status)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	bfa_trc(bfa, status);
-	bfa_trc(bfa, fcport->diag_busy);
-
-	fcport->diag_busy = status;
-}
-
-void
-bfa_fcport_beacon(void *dev, bfa_boolean_t beacon,
-	bfa_boolean_t link_e2e_beacon)
-{
-	struct bfa_s *bfa = dev;
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	bfa_trc(bfa, beacon);
-	bfa_trc(bfa, link_e2e_beacon);
-	bfa_trc(bfa, fcport->beacon);
-	bfa_trc(bfa, fcport->link_e2e_beacon);
-
-	fcport->beacon = beacon;
-	fcport->link_e2e_beacon = link_e2e_beacon;
-}
 
 bfa_boolean_t
 bfa_fcport_is_linkup(struct bfa_s *bfa)
@@ -4036,63 +3849,6 @@ bfa_fcport_is_qos_enabled(struct bfa_s *bfa)
 	return fcport->cfg.qos_enabled;
 }
 
-bfa_status_t
-bfa_trunk_get_attr(struct bfa_s *bfa, struct bfa_trunk_attr_s *attr)
-
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	struct bfa_fcport_trunk_s *trunk = &fcport->trunk;
-
-	bfa_trc(bfa, fcport->cfg.trunked);
-	bfa_trc(bfa, trunk->attr.state);
-	*attr = trunk->attr;
-	attr->port_id = bfa_lps_get_base_pid(bfa);
-
-	return BFA_STATUS_OK;
-}
-
-void
-bfa_trunk_enable_cfg(struct bfa_s *bfa)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	struct bfa_fcport_trunk_s *trunk = &fcport->trunk;
-
-	bfa_trc(bfa, 1);
-	trunk->attr.state = BFA_TRUNK_OFFLINE;
-	fcport->cfg.trunked = BFA_TRUE;
-}
-
-bfa_status_t
-bfa_trunk_enable(struct bfa_s *bfa)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	struct bfa_fcport_trunk_s *trunk = &fcport->trunk;
-
-	bfa_trc(bfa, 1);
-
-	trunk->attr.state   = BFA_TRUNK_OFFLINE;
-	bfa_fcport_disable(bfa);
-	fcport->cfg.trunked = BFA_TRUE;
-	bfa_fcport_enable(bfa);
-
-	return BFA_STATUS_OK;
-}
-
-bfa_status_t
-bfa_trunk_disable(struct bfa_s *bfa)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	struct bfa_fcport_trunk_s *trunk = &fcport->trunk;
-
-	bfa_trc(bfa, 0);
-	trunk->attr.state   = BFA_TRUNK_DISABLED;
-	bfa_fcport_disable(bfa);
-	fcport->cfg.trunked = BFA_FALSE;
-	bfa_fcport_enable(bfa);
-	return BFA_STATUS_OK;
-}
-
-
 /*
  * Rport State machine functions
  */
@@ -4877,22 +4633,6 @@ bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed)
 }
 
 void
-bfa_rport_get_stats(struct bfa_rport_s *rport,
-	struct bfa_rport_hal_stats_s *stats)
-{
-	*stats = rport->stats;
-}
-
-void
-bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
-					struct bfa_rport_qos_attr_s *qos_attr)
-{
-	qos_attr->qos_priority  = rport->qos_attr.qos_priority;
-	qos_attr->qos_flow_id  = be32_to_cpu(rport->qos_attr.qos_flow_id);
-
-}
-
-void
 bfa_rport_clear_stats(struct bfa_rport_s *rport)
 {
 	memset(&rport->stats, 0, sizeof(rport->stats));
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index e2349d5..0e23c1b 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -500,30 +500,9 @@ void bfa_fcport_event_register(struct bfa_s *bfa,
 			void (*event_cbfn) (void *cbarg,
 			enum bfa_port_linkstate event), void *event_cbarg);
 bfa_boolean_t bfa_fcport_is_disabled(struct bfa_s *bfa);
-void bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
-void bfa_fcport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
-bfa_status_t bfa_fcport_cfg_ratelim_speed(struct bfa_s *bfa,
-					  enum bfa_port_speed speed);
 enum bfa_port_speed bfa_fcport_get_ratelim_speed(struct bfa_s *bfa);
 
 void bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
-void bfa_fcport_busy(struct bfa_s *bfa, bfa_boolean_t status);
-void bfa_fcport_beacon(void *dev, bfa_boolean_t beacon,
-		       bfa_boolean_t link_e2e_beacon);
-void bfa_fcport_qos_get_attr(struct bfa_s *bfa,
-			     struct bfa_qos_attr_s *qos_attr);
-void bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
-				struct bfa_qos_vc_attr_s *qos_vc_attr);
-bfa_status_t bfa_fcport_get_qos_stats(struct bfa_s *bfa,
-				      union bfa_fcport_stats_u *stats,
-				      bfa_cb_port_t cbfn, void *cbarg);
-bfa_status_t bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn,
-					void *cbarg);
-bfa_status_t bfa_fcport_get_fcoe_stats(struct bfa_s *bfa,
-				       union bfa_fcport_stats_u *stats,
-				       bfa_cb_port_t cbfn, void *cbarg);
-bfa_status_t bfa_fcport_clear_fcoe_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn,
-					 void *cbarg);
 bfa_boolean_t     bfa_fcport_is_ratelim(struct bfa_s *bfa);
 bfa_boolean_t	bfa_fcport_is_linkup(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
@@ -542,8 +521,6 @@ void bfa_rport_online(struct bfa_rport_s *rport,
 		      struct bfa_rport_info_s *rport_info);
 void bfa_rport_offline(struct bfa_rport_s *rport);
 void bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed);
-void bfa_rport_get_stats(struct bfa_rport_s *rport,
-			 struct bfa_rport_hal_stats_s *stats);
 void bfa_rport_clear_stats(struct bfa_rport_s *rport);
 void bfa_cb_rport_online(void *rport);
 void bfa_cb_rport_offline(void *rport);
@@ -553,8 +530,6 @@ void bfa_cb_rport_qos_scn_flowid(void *rport,
 void bfa_cb_rport_qos_scn_prio(void *rport,
 			       struct bfa_rport_qos_attr_s old_qos_attr,
 			       struct bfa_rport_qos_attr_s new_qos_attr);
-void bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
-			    struct bfa_rport_qos_attr_s *qos_attr);
 
 /*
  * bfa fcxp API functions
@@ -625,7 +600,6 @@ void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa,
 		   bfa_boolean_t auth_en);
 void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz,
 		   wwn_t pwwn, wwn_t nwwn);
-void bfa_lps_flogo(struct bfa_lps_s *lps);
 void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
 u8 bfa_lps_get_tag(struct bfa_lps_s *lps);
 bfa_boolean_t bfa_lps_is_npiv_en(struct bfa_lps_s *lps);
@@ -647,10 +621,4 @@ void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg);
 void bfa_cb_lps_cvl_event(void *bfad, void *uarg);
 
-void bfa_trunk_enable_cfg(struct bfa_s *bfa);
-bfa_status_t bfa_trunk_enable(struct bfa_s *bfa);
-bfa_status_t bfa_trunk_disable(struct bfa_s *bfa);
-bfa_status_t bfa_trunk_get_attr(struct bfa_s *bfa,
-		struct bfa_trunk_attr_s *attr);
-
 #endif /* __BFA_SVC_H__ */
-- 
1.7.2.1

