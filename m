From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 2/7] bfa: clean up one line functions
Date: Thu, 9 Dec 2010 19:08:43 -0800
Message-ID: <1291950523-11736-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56137 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab0LJDqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:46:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>, Jing Huang <huangj@brocade.com>

Cleaned up one line functions.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa.h           |   17 ---
 drivers/scsi/bfa/bfa_core.c      |  173 ++----------------------
 drivers/scsi/bfa/bfa_fcpim.c     |    2 +-
 drivers/scsi/bfa/bfa_fcs.c       |  172 ++++--------------------
 drivers/scsi/bfa/bfa_fcs.h       |   87 ++++++++++--
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   18 ++--
 drivers/scsi/bfa/bfa_fcs_lport.c |   65 +++++----
 drivers/scsi/bfa/bfa_fcs_rport.c |   97 ++------------
 drivers/scsi/bfa/bfa_ioc.c       |  280 +++++++-------------------------------
 drivers/scsi/bfa/bfa_ioc.h       |   19 +--
 drivers/scsi/bfa/bfa_ioc_cb.c    |    2 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |   12 +-
 drivers/scsi/bfa/bfa_plog.h      |    1 -
 drivers/scsi/bfa/bfa_port.c      |    2 +-
 drivers/scsi/bfa/bfa_svc.c       |  185 +------------------------
 drivers/scsi/bfa/bfa_svc.h       |   29 ++---
 drivers/scsi/bfa/bfad.c          |   22 ++--
 drivers/scsi/bfa/bfad_debugfs.c  |    4 +-
 drivers/scsi/bfa/bfad_im.c       |    2 +-
 19 files changed, 259 insertions(+), 930 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 7ed13ce..6231e5a 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -296,7 +296,6 @@ void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
 		      struct bfa_iocfc_cfg_s *cfg,
 		      struct bfa_meminfo_s *meminfo,
 		      struct bfa_pcidev_s *pcidev);
-void bfa_iocfc_detach(struct bfa_s *bfa);
 void bfa_iocfc_init(struct bfa_s *bfa);
 void bfa_iocfc_start(struct bfa_s *bfa);
 void bfa_iocfc_stop(struct bfa_s *bfa);
@@ -385,13 +384,7 @@ void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
 void bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_meminfo_s *meminfo,
 		struct bfa_pcidev_s *pcidev);
-void bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod);
-void bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog);
 void bfa_detach(struct bfa_s *bfa);
-void bfa_init(struct bfa_s *bfa);
-void bfa_start(struct bfa_s *bfa);
-void bfa_stop(struct bfa_s *bfa);
-void bfa_attach_fcs(struct bfa_s *bfa);
 void bfa_cb_init(void *bfad, bfa_status_t status);
 void bfa_cb_updateq(void *bfad, bfa_status_t status);
 
@@ -405,7 +398,6 @@ void bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q);
 
 typedef void (*bfa_cb_ioc_t) (void *cbarg, enum bfa_status status);
 void bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr);
-void bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr);
 
 
 bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
@@ -413,16 +405,7 @@ bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
 
 void bfa_iocfc_enable(struct bfa_s *bfa);
 void bfa_iocfc_disable(struct bfa_s *bfa);
-void bfa_timer_tick(struct bfa_s *bfa);
 #define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)		\
 	bfa_timer_begin(&(_bfa)->timer_mod, _timer, _timercb, _arg, _timeout)
 
-/*
- * BFA debug API functions
- */
-bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
-bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
-bfa_status_t bfa_debug_fwcore(struct bfa_s *bfa, void *buf,
-			      u32 *offset, int *buflen);
-
 #endif /* __BFA_H__ */
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 90e0f81..002907c 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -67,18 +67,6 @@ static struct bfa_ioc_cbfn_s bfa_iocfc_cbfn;
  * BFA Interrupt handling functions
  */
 static void
-bfa_msix_errint(struct bfa_s *bfa, u32 intr)
-{
-	bfa_ioc_error_isr(&bfa->ioc);
-}
-
-static void
-bfa_msix_lpu(struct bfa_s *bfa)
-{
-	bfa_ioc_mbox_isr(&bfa->ioc);
-}
-
-static void
 bfa_reqq_resume(struct bfa_s *bfa, int qid)
 {
 	struct list_head *waitq, *qe, *qen;
@@ -267,7 +255,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 	intr = readl(bfa->iocfc.bfa_regs.intr_status);
 
 	if (intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1))
-		bfa_msix_lpu(bfa);
+		 bfa_ioc_mbox_isr(&bfa->ioc);
 
 	intr &= (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
 		__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS | __HFN_INT_LL_HALT);
@@ -298,7 +286,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 		}
 
 		writel(intr, bfa->iocfc.bfa_regs.intr_status);
-		bfa_msix_errint(bfa, intr);
+		bfa_ioc_error_isr(&bfa->ioc);
 	}
 }
 
@@ -467,8 +455,8 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 	 * First allocate dma memory for IOC.
 	 */
 	bfa_ioc_mem_claim(&bfa->ioc, dm_kva, dm_pa);
-	dm_kva += bfa_ioc_meminfo();
-	dm_pa  += bfa_ioc_meminfo();
+	dm_kva += BFA_ROUNDUP(sizeof(struct bfi_ioc_attr_s), BFA_DMA_ALIGN_SZ);
+	dm_pa  += BFA_ROUNDUP(sizeof(struct bfi_ioc_attr_s), BFA_DMA_ALIGN_SZ);
 
 	/*
 	 * Claim DMA-able memory for the request/response queues and for shadow
@@ -531,7 +519,7 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 	bfa_meminfo_dma_virt(meminfo) = dm_kva;
 	bfa_meminfo_dma_phys(meminfo) = dm_pa;
 
-	dbgsz = bfa_ioc_debug_trcsz(bfa_auto_recover);
+	dbgsz = (bfa_auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 	if (dbgsz > 0) {
 		bfa_ioc_debug_memclaim(&bfa->ioc, bfa_meminfo_kva(meminfo));
 		bfa_meminfo_kva(meminfo) += dbgsz;
@@ -723,11 +711,11 @@ bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
 		  u32 *dm_len)
 {
 	/* dma memory for IOC */
-	*dm_len += bfa_ioc_meminfo();
+	*dm_len += BFA_ROUNDUP(sizeof(struct bfi_ioc_attr_s), BFA_DMA_ALIGN_SZ);
 
 	bfa_iocfc_fw_cfg_sz(cfg, dm_len);
 	bfa_iocfc_cqs_sz(cfg, dm_len);
-	*km_len += bfa_ioc_debug_trcsz(bfa_auto_recover);
+	*km_len += (bfa_auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 }
 
 /*
@@ -759,7 +747,7 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 	bfa_iocfc_init_mem(bfa, bfad, cfg, pcidev);
 	bfa_iocfc_mem_claim(bfa, cfg, meminfo);
-	bfa_timer_init(&bfa->timer_mod);
+	INIT_LIST_HEAD(&bfa->timer_mod.timer_q);
 
 	INIT_LIST_HEAD(&bfa->comp_q);
 	for (i = 0; i < BFI_IOC_MAX_CQS; i++)
@@ -770,15 +758,6 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
  * Query IOC memory requirement information.
  */
 void
-bfa_iocfc_detach(struct bfa_s *bfa)
-{
-	bfa_ioc_detach(&bfa->ioc);
-}
-
-/*
- * Query IOC memory requirement information.
- */
-void
 bfa_iocfc_init(struct bfa_s *bfa)
 {
 	bfa->iocfc.action = BFA_IOCFC_ACT_INIT;
@@ -1090,79 +1069,7 @@ bfa_detach(struct bfa_s *bfa)
 
 	for (i = 0; hal_mods[i]; i++)
 		hal_mods[i]->detach(bfa);
-
-	bfa_iocfc_detach(bfa);
-}
-
-
-void
-bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod)
-{
-	bfa->trcmod = trcmod;
-}
-
-void
-bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog)
-{
-	bfa->plog = plog;
-}
-
-/*
- * Initialize IOC.
- *
- * This function will return immediately, when the IOC initialization is
- * completed, the bfa_cb_init() will be called.
- *
- * @param[in]	bfa	instance
- *
- * @return void
- *
- * Special Considerations:
- *
- * @note
- * When this function returns, the driver should register the interrupt service
- * routine(s) and enable the device interrupts. If this is not done,
- * bfa_cb_init() will never get called
- */
-void
-bfa_init(struct bfa_s *bfa)
-{
-	bfa_iocfc_init(bfa);
-}
-
-/*
- * Use this function initiate the IOC configuration setup. This function
- * will return immediately.
- *
- * @param[in]	bfa	instance
- *
- * @return None
- */
-void
-bfa_start(struct bfa_s *bfa)
-{
-	bfa_iocfc_start(bfa);
-}
-
-/*
- * Use this function quiese the IOC. This function will return immediately,
- * when the IOC is actually stopped, the bfad->comp will be set.
- *
- * @param[in]bfa - pointer to bfa_t.
- *
- * @return None
- *
- * Special Considerations:
- * bfad->comp can be set before or after bfa_stop() returns.
- *
- * @note
- * In case of any failure, we could handle it automatically by doing a
- * reset and then succeed the bfa_stop() call.
- */
-void
-bfa_stop(struct bfa_s *bfa)
-{
-	bfa_iocfc_stop(bfa);
+	bfa_ioc_detach(&bfa->ioc);
 }
 
 void
@@ -1198,20 +1105,6 @@ bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q)
 	}
 }
 
-void
-bfa_attach_fcs(struct bfa_s *bfa)
-{
-	bfa->fcs = BFA_TRUE;
-}
-
-/*
- * Periodic timer heart beat from driver
- */
-void
-bfa_timer_tick(struct bfa_s *bfa)
-{
-	bfa_timer_beat(&bfa->timer_mod);
-}
 
 /*
  * Return the list of PCI vendor/device id lists supported by this
@@ -1282,51 +1175,3 @@ bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg)
 	cfg->drvcfg.num_rspq_elems = BFA_RSPQ_NELEMS_MIN;
 	cfg->drvcfg.min_cfg	   = BFA_TRUE;
 }
-
-void
-bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr)
-{
-	bfa_ioc_get_attr(&bfa->ioc, ioc_attr);
-}
-
-/*
- * Retrieve firmware trace information on IOC failure.
- */
-bfa_status_t
-bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
-{
-	return bfa_ioc_debug_fwsave(&bfa->ioc, trcdata, trclen);
-}
-
-/*
- * Fetch firmware trace data.
- *
- * @param[in]		bfa			BFA instance
- * @param[out]		trcdata		Firmware trace buffer
- * @param[in,out]	trclen		Firmware trace buffer len
- *
- * @retval BFA_STATUS_OK			Firmware trace is fetched.
- * @retval BFA_STATUS_INPROGRESS	Firmware trace fetch is in progress.
- */
-bfa_status_t
-bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen)
-{
-	return bfa_ioc_debug_fwtrc(&bfa->ioc, trcdata, trclen);
-}
-
-/*
- * Dump firmware memory.
- *
- * @param[in]		bfa		BFA instance
- * @param[out]		buf		buffer for dump
- * @param[in,out]	offset		smem offset to start read
- * @param[in,out]	buflen		length of buffer
- *
- * @retval BFA_STATUS_OK		Firmware memory is dumped.
- * @retval BFA_STATUS_INPROGRESS	Firmware memory dump is in progress.
- */
-bfa_status_t
-bfa_debug_fwcore(struct bfa_s *bfa, void *buf, u32 *offset, int *buflen)
-{
-	return bfa_ioc_debug_fwcore(&bfa->ioc, buf, offset, buflen);
-}
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 0e7f380..d6aea5d 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2567,7 +2567,7 @@ bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim)
 		}
 		bfa_itnim_iodone(ioim->itnim);
 	} else
-		bfa_tskim_iodone(ioim->iosp->tskim);
+		bfa_wc_down(&ioim->iosp->tskim->wc);
 }
 
 static bfa_boolean_t
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 5e192f3..6c1f446 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -76,7 +76,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 	fcs->bfad = bfad;
 	fcs->min_cfg = min_cfg;
 
-	bfa_attach_fcs(bfa);
+	bfa->fcs = BFA_TRUE;
 	fcbuild_init();
 
 	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
@@ -110,14 +110,6 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
 	}
 }
 
-/*
- * Start FCS operations.
- */
-void
-bfa_fcs_start(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_fabric_modstart(fcs);
-}
 
 /*
  *	brief
@@ -140,22 +132,6 @@ bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 
 /*
  *	brief
- *		FCS FDMI Driver Parameter Initialization
- *
- *	param[in]		fcs		FCS instance
- *	param[in]		fdmi_enable	TRUE/FALSE
- *
- *	return None
- */
-void
-bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable)
-{
-
-	fcs->fdmi_enabled = fdmi_enable;
-
-}
-/*
- *	brief
  *		FCS instance cleanup and exit.
  *
  *	param[in]		fcs			FCS instance
@@ -184,18 +160,6 @@ bfa_fcs_exit(struct bfa_fcs_s *fcs)
 }
 
 
-void
-bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod)
-{
-	fcs->trcmod = trcmod;
-}
-
-void
-bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs)
-{
-	bfa_wc_down(&fcs->wc);
-}
-
 /*
  * Fabric module implementation.
  */
@@ -232,31 +196,6 @@ static void bfa_fcs_fabric_flogiacc_comp(void *fcsarg,
 					 u32 rsp_len,
 					 u32 resid_len,
 					 struct fchs_s *rspfchs);
-/*
- *  fcs_fabric_sm fabric state machine functions
- */
-
-/*
- * Fabric state machine events
- */
-enum bfa_fcs_fabric_event {
-	BFA_FCS_FABRIC_SM_CREATE	= 1,	/*  create from driver	      */
-	BFA_FCS_FABRIC_SM_DELETE	= 2,	/*  delete from driver	      */
-	BFA_FCS_FABRIC_SM_LINK_DOWN	= 3,	/*  link down from port      */
-	BFA_FCS_FABRIC_SM_LINK_UP	= 4,	/*  link up from port	      */
-	BFA_FCS_FABRIC_SM_CONT_OP	= 5,	/*  flogi/auth continue op   */
-	BFA_FCS_FABRIC_SM_RETRY_OP	= 6,	/*  flogi/auth retry op      */
-	BFA_FCS_FABRIC_SM_NO_FABRIC	= 7,	/*  from flogi/auth	      */
-	BFA_FCS_FABRIC_SM_PERF_EVFP	= 8,	/*  from flogi/auth	      */
-	BFA_FCS_FABRIC_SM_ISOLATE	= 9,	/*  from EVFP processing     */
-	BFA_FCS_FABRIC_SM_NO_TAGGING	= 10,	/*  no VFT tagging from EVFP */
-	BFA_FCS_FABRIC_SM_DELAYED	= 11,	/*  timeout delay event      */
-	BFA_FCS_FABRIC_SM_AUTH_FAILED	= 12,	/*  auth failed	      */
-	BFA_FCS_FABRIC_SM_AUTH_SUCCESS	= 13,	/*  auth successful	      */
-	BFA_FCS_FABRIC_SM_DELCOMP	= 14,	/*  all vports deleted event */
-	BFA_FCS_FABRIC_SM_LOOPBACK	= 15,	/*  Received our own FLOGI   */
-	BFA_FCS_FABRIC_SM_START		= 16,	/*  from driver	      */
-};
 
 static void	bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
 					 enum bfa_fcs_fabric_event event);
@@ -270,14 +209,8 @@ static void	bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
 					      enum bfa_fcs_fabric_event event);
 static void	bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
 				       enum bfa_fcs_fabric_event event);
-static void	bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
-					      enum bfa_fcs_fabric_event event);
-static void	bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
-					   enum bfa_fcs_fabric_event event);
 static void	bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
-static void	bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
-					 enum bfa_fcs_fabric_event event);
 static void	bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
 				       enum bfa_fcs_fabric_event event);
 static void	bfa_fcs_fabric_sm_evfp_done(struct bfa_fcs_fabric_s *fabric,
@@ -337,7 +270,7 @@ bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_DELETE:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
-		bfa_fcs_modexit_comp(fabric->fcs);
+		bfa_wc_down(&fabric->fcs->wc);
 		break;
 
 	default:
@@ -410,7 +343,7 @@ bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_LOOPBACK:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_loopback);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		bfa_fcs_fabric_set_opertype(fabric);
 		break;
 
@@ -424,12 +357,12 @@ bfa_fcs_fabric_sm_flogi(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_LINK_DOWN:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		break;
 
 	case BFA_FCS_FABRIC_SM_DELETE:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_deleting);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		bfa_fcs_fabric_delete(fabric);
 		break;
 
@@ -481,7 +414,7 @@ bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_AUTH_FAILED:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_auth_failed);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		break;
 
 	case BFA_FCS_FABRIC_SM_AUTH_SUCCESS:
@@ -495,7 +428,7 @@ bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_LINK_DOWN:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		break;
 
 	case BFA_FCS_FABRIC_SM_DELETE:
@@ -511,7 +444,7 @@ bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
 /*
  *   Authentication failed
  */
-static void
+void
 bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
 			      enum bfa_fcs_fabric_event event)
 {
@@ -537,7 +470,7 @@ bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
 /*
  *   Port is in loopback mode.
  */
-static void
+void
 bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
 			   enum bfa_fcs_fabric_event event)
 {
@@ -573,7 +506,7 @@ bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_LINK_DOWN:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		bfa_fcs_fabric_notify_offline(fabric);
 		break;
 
@@ -596,7 +529,7 @@ bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 /*
  *   Fabric is online - normal operating state.
  */
-static void
+void
 bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 			 enum bfa_fcs_fabric_event event)
 {
@@ -606,7 +539,7 @@ bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_LINK_DOWN:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_linkdown);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		bfa_fcs_fabric_notify_offline(fabric);
 		break;
 
@@ -617,7 +550,7 @@ bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 
 	case BFA_FCS_FABRIC_SM_AUTH_FAILED:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_auth_failed);
-		bfa_lps_discard(fabric->lps);
+		bfa_sm_send_event(fabric->lps, BFA_LPS_SM_OFFLINE);
 		break;
 
 	case BFA_FCS_FABRIC_SM_AUTH_SUCCESS:
@@ -697,7 +630,7 @@ bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
 	switch (event) {
 	case BFA_FCS_FABRIC_SM_DELCOMP:
 		bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
-		bfa_fcs_modexit_comp(fabric->fcs);
+		bfa_wc_down(&fabric->fcs->wc);
 		break;
 
 	case BFA_FCS_FABRIC_SM_LINK_UP:
@@ -724,8 +657,8 @@ bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric)
 	struct bfa_lport_cfg_s *port_cfg = &fabric->bport.port_cfg;
 
 	port_cfg->roles = BFA_LPORT_ROLE_FCP_IM;
-	port_cfg->nwwn = bfa_ioc_get_nwwn(&fabric->fcs->bfa->ioc);
-	port_cfg->pwwn = bfa_ioc_get_pwwn(&fabric->fcs->bfa->ioc);
+	port_cfg->nwwn = fabric->fcs->bfa->ioc.attr->nwwn;
+	port_cfg->pwwn = fabric->fcs->bfa->ioc.attr->pwwn;
 }
 
 /*
@@ -813,7 +746,7 @@ bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
 		return;
 
 	case BFA_STATUS_EPROTOCOL:
-		switch (bfa_lps_get_extstatus(fabric->lps)) {
+		switch (fabric->lps->ext_status) {
 		case BFA_EPROTO_BAD_ACCEPT:
 			fabric->stats.flogi_acc_err++;
 			break;
@@ -840,26 +773,26 @@ bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
 		return;
 	}
 
-	fabric->bb_credit = bfa_lps_get_peer_bbcredit(fabric->lps);
+	fabric->bb_credit = fabric->lps->pr_bbcred;
 	bfa_trc(fabric->fcs, fabric->bb_credit);
 
-	if (!bfa_lps_is_brcd_fabric(fabric->lps))
-		fabric->fabric_name =  bfa_lps_get_peer_nwwn(fabric->lps);
+	if (!(fabric->lps->brcd_switch))
+		fabric->fabric_name =  fabric->lps->pr_nwwn;
 
 	/*
 	 * Check port type. It should be 1 = F-port.
 	 */
-	if (bfa_lps_is_fport(fabric->lps)) {
-		fabric->bport.pid = bfa_lps_get_pid(fabric->lps);
-		fabric->is_npiv = bfa_lps_is_npiv_en(fabric->lps);
-		fabric->is_auth = bfa_lps_is_authreq(fabric->lps);
+	if (fabric->lps->fport) {
+		fabric->bport.pid = fabric->lps->lp_pid;
+		fabric->is_npiv = fabric->lps->npiv_en;
+		fabric->is_auth = fabric->lps->auth_req;
 		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_CONT_OP);
 	} else {
 		/*
 		 * Nport-2-Nport direct attached
 		 */
 		fabric->bport.port_topo.pn2n.rem_port_wwn =
-			bfa_lps_get_peer_pwwn(fabric->lps);
+			fabric->lps->pr_pwwn;
 		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_NO_FABRIC);
 	}
 
@@ -1038,23 +971,6 @@ bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_START);
 }
 
-bfa_boolean_t
-bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric)
-{
-	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_loopback);
-}
-
-bfa_boolean_t
-bfa_fcs_fabric_is_auth_failed(struct bfa_fcs_fabric_s *fabric)
-{
-	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_auth_failed);
-}
-
-enum bfa_port_type
-bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric)
-{
-	return fabric->oper_type;
-}
 
 /*
  *   Link up notification from BFA physical port module.
@@ -1115,28 +1031,6 @@ bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
 	bfa_wc_down(&fabric->wc);
 }
 
-/*
- *   Base port is deleted.
- */
-void
-bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric)
-{
-	bfa_wc_down(&fabric->wc);
-}
-
-
-/*
- *    Check if fabric is online.
- *
- *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
- *
- *   @return  TRUE/FALSE
- */
-int
-bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric)
-{
-	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_online);
-}
 
 /*
  * Lookup for a vport withing a fabric given its pwwn
@@ -1156,18 +1050,6 @@ bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn)
 	return NULL;
 }
 
-/*
- *    In a given fabric, return the number of lports.
- *
- *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
- *
- *   @return : 1 or more.
- */
-u16
-bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric)
-{
-	return fabric->num_vports;
-}
 
 /*
  *  Get OUI of the attached switch.
@@ -1187,7 +1069,7 @@ bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric)
 	u8 *tmp;
 	u16 oui;
 
-	fab_nwwn = bfa_lps_get_peer_nwwn(fabric->lps);
+	fab_nwwn = fabric->lps->pr_nwwn;
 
 	tmp = (u8 *)&fab_nwwn;
 	oui = (tmp[3] << 8) | tmp[4];
@@ -1344,7 +1226,7 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 				    bfa_fcport_get_maxfrsize(bfa),
 				    bfa_fcport_get_rx_bbcredit(bfa));
 
-	bfa_fcxp_send(fcxp, NULL, fabric->vf_id, bfa_lps_get_tag(fabric->lps),
+	bfa_fcxp_send(fcxp, NULL, fabric->vf_id, fabric->lps->lp_tag,
 		      BFA_FALSE, FC_CLASS_3,
 		      reqlen, &fchs, bfa_fcs_fabric_flogiacc_comp, fabric,
 		      FC_MAX_PDUSZ, 0);
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index fcb54e5..e7977ee 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -27,6 +27,21 @@
 #define BFA_FCS_OS_STR_LEN		64
 
 /*
+ *  lps_pvt BFA LPS private functions
+ */
+
+enum bfa_lps_event {
+	BFA_LPS_SM_LOGIN	= 1,	/* login request from user      */
+	BFA_LPS_SM_LOGOUT	= 2,	/* logout request from user     */
+	BFA_LPS_SM_FWRSP	= 3,	/* f/w response to login/logout */
+	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue  */
+	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user         */
+	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline              */
+	BFA_LPS_SM_RX_CVL	= 7,	/* Rx clear virtual link        */
+};
+
+
+/*
  * !!! Only append to the enums defined here to avoid any versioning
  * !!! needed between trace utility and driver version
  */
@@ -41,7 +56,6 @@ enum {
 struct bfa_fcs_s;
 
 #define __fcs_min_cfg(__fcs)       ((__fcs)->min_cfg)
-void bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs);
 
 #define BFA_FCS_BRCD_SWITCH_OUI  0x051e
 #define N2N_LOCAL_PID	    0x010000
@@ -444,9 +458,6 @@ void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
 
 struct bfa_fcs_rport_s *bfa_fcs_rport_create(struct bfa_fcs_lport_s *port,
 	 u32 pid);
-void bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_start(struct bfa_fcs_lport_s *port, struct fchs_s *rx_fchs,
 			 struct fc_logi_s *plogi_rsp);
 void bfa_fcs_rport_plogi_create(struct bfa_fcs_lport_s *port,
@@ -454,10 +465,8 @@ void bfa_fcs_rport_plogi_create(struct bfa_fcs_lport_s *port,
 				struct fc_logi_s *plogi);
 void bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
 			 struct fc_logi_s *plogi);
-void bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, __be16 ox_id);
 
-void bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_itntm_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_fcptm_offline_done(struct bfa_fcs_rport_s *rport);
 int  bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport);
@@ -648,6 +657,57 @@ struct bfa_fcs_s {
 };
 
 /*
+ *  fcs_fabric_sm fabric state machine functions
+ */
+
+/*
+ * Fabric state machine events
+ */
+enum bfa_fcs_fabric_event {
+	BFA_FCS_FABRIC_SM_CREATE        = 1,    /*  create from driver        */
+	BFA_FCS_FABRIC_SM_DELETE        = 2,    /*  delete from driver        */
+	BFA_FCS_FABRIC_SM_LINK_DOWN     = 3,    /*  link down from port      */
+	BFA_FCS_FABRIC_SM_LINK_UP       = 4,    /*  link up from port         */
+	BFA_FCS_FABRIC_SM_CONT_OP       = 5,    /*  flogi/auth continue op   */
+	BFA_FCS_FABRIC_SM_RETRY_OP      = 6,    /*  flogi/auth retry op      */
+	BFA_FCS_FABRIC_SM_NO_FABRIC     = 7,    /*  from flogi/auth           */
+	BFA_FCS_FABRIC_SM_PERF_EVFP     = 8,    /*  from flogi/auth           */
+	BFA_FCS_FABRIC_SM_ISOLATE       = 9,    /*  from EVFP processing     */
+	BFA_FCS_FABRIC_SM_NO_TAGGING    = 10,   /*  no VFT tagging from EVFP */
+	BFA_FCS_FABRIC_SM_DELAYED       = 11,   /*  timeout delay event      */
+	BFA_FCS_FABRIC_SM_AUTH_FAILED   = 12,   /*  auth failed       */
+	BFA_FCS_FABRIC_SM_AUTH_SUCCESS  = 13,   /*  auth successful           */
+	BFA_FCS_FABRIC_SM_DELCOMP       = 14,   /*  all vports deleted event */
+	BFA_FCS_FABRIC_SM_LOOPBACK      = 15,   /*  Received our own FLOGI   */
+	BFA_FCS_FABRIC_SM_START         = 16,   /*  from driver       */
+};
+
+/*
+ *  fcs_rport_sm FCS rport state machine events
+ */
+
+enum rport_event {
+	RPSM_EVENT_PLOGI_SEND   = 1,    /*  new rport; start with PLOGI */
+	RPSM_EVENT_PLOGI_RCVD   = 2,    /*  Inbound PLOGI from remote port */
+	RPSM_EVENT_PLOGI_COMP   = 3,    /*  PLOGI completed to rport    */
+	RPSM_EVENT_LOGO_RCVD    = 4,    /*  LOGO from remote device     */
+	RPSM_EVENT_LOGO_IMP     = 5,    /*  implicit logo for SLER      */
+	RPSM_EVENT_FCXP_SENT    = 6,    /*  Frame from has been sent    */
+	RPSM_EVENT_DELETE       = 7,    /*  RPORT delete request        */
+	RPSM_EVENT_SCN          = 8,    /*  state change notification   */
+	RPSM_EVENT_ACCEPTED     = 9,    /*  Good response from remote device */
+	RPSM_EVENT_FAILED       = 10,   /*  Request to rport failed.    */
+	RPSM_EVENT_TIMEOUT      = 11,   /*  Rport SM timeout event      */
+	RPSM_EVENT_HCB_ONLINE  = 12,    /*  BFA rport online callback   */
+	RPSM_EVENT_HCB_OFFLINE = 13,    /*  BFA rport offline callback  */
+	RPSM_EVENT_FC4_OFFLINE = 14,    /*  FC-4 offline complete       */
+	RPSM_EVENT_ADDRESS_CHANGE = 15, /*  Rport's PID has changed     */
+	RPSM_EVENT_ADDRESS_DISC = 16,   /*  Need to Discover rport's PID */
+	RPSM_EVENT_PRLO_RCVD   = 17,    /*  PRLO from remote device     */
+	RPSM_EVENT_PLOGI_RETRY = 18,    /*  Retry PLOGI continously */
+};
+
+/*
  * bfa fcs API functions
  */
 void bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa,
@@ -656,16 +716,12 @@ void bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa,
 void bfa_fcs_init(struct bfa_fcs_s *fcs);
 void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 			      struct bfa_fcs_driver_info_s *driver_info);
-void bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable);
 void bfa_fcs_exit(struct bfa_fcs_s *fcs);
-void bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod);
-void		bfa_fcs_start(struct bfa_fcs_s *fcs);
 
 /*
  * bfa fcs vf public functions
  */
 bfa_fcs_vf_t *bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id);
-u16 bfa_fcs_fabric_vport_count(struct bfa_fcs_fabric_s *fabric);
 
 /*
  * fabric protected interface functions
@@ -679,22 +735,23 @@ void bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
 	struct bfa_fcs_vport_s *vport);
 void bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
 	struct bfa_fcs_vport_s *vport);
-int bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric);
 struct bfa_fcs_vport_s *bfa_fcs_fabric_vport_lookup(
 		struct bfa_fcs_fabric_s *fabric, wwn_t pwwn);
 void bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric,
 		struct fchs_s *fchs, u16 len);
-bfa_boolean_t	bfa_fcs_fabric_is_loopback(struct bfa_fcs_fabric_s *fabric);
-bfa_boolean_t	bfa_fcs_fabric_is_auth_failed(struct bfa_fcs_fabric_s *fabric);
-enum bfa_port_type bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric);
 void	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
-void	bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 	       wwn_t fabric_name);
 u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
 void bfa_fcs_port_attach(struct bfa_fcs_s *fcs);
+void bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
+			enum bfa_fcs_fabric_event event);
+void bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
+			enum bfa_fcs_fabric_event event);
+void bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
+			enum bfa_fcs_fabric_event event);
 
 /*
  * BFA FCS callback interfaces
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 9662bcd..561a557 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -103,7 +103,7 @@ bfa_fcs_itnim_sm_offline(struct bfa_fcs_itnim_s *itnim,
 		break;
 
 	case BFA_FCS_ITNIM_SM_OFFLINE:
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_INITIATOR:
@@ -140,7 +140,7 @@ bfa_fcs_itnim_sm_prli_send(struct bfa_fcs_itnim_s *itnim,
 	case BFA_FCS_ITNIM_SM_OFFLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
 		bfa_fcxp_walloc_cancel(itnim->fcs->bfa, &itnim->fcxp_wqe);
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_DELETE:
@@ -181,7 +181,7 @@ bfa_fcs_itnim_sm_prli(struct bfa_fcs_itnim_s *itnim,
 	case BFA_FCS_ITNIM_SM_OFFLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
 		bfa_fcxp_discard(itnim->fcxp);
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_INITIATOR:
@@ -217,7 +217,7 @@ bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
 		} else {
 			/* invoke target offline */
 			bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
-			bfa_fcs_rport_logo_imp(itnim->rport);
+			bfa_sm_send_event(itnim->rport, RPSM_EVENT_LOGO_IMP);
 		}
 		break;
 
@@ -225,7 +225,7 @@ bfa_fcs_itnim_sm_prli_retry(struct bfa_fcs_itnim_s *itnim,
 	case BFA_FCS_ITNIM_SM_OFFLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
 		bfa_timer_stop(&itnim->timer);
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_INITIATOR:
@@ -269,7 +269,7 @@ bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
 	case BFA_FCS_ITNIM_SM_OFFLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
 		bfa_itnim_offline(itnim->bfa_itnim);
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_DELETE:
@@ -330,7 +330,7 @@ bfa_fcs_itnim_sm_hcb_offline(struct bfa_fcs_itnim_s *itnim,
 	switch (event) {
 	case BFA_FCS_ITNIM_SM_HCB_OFFLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_DELETE:
@@ -358,7 +358,7 @@ bfa_fcs_itnim_sm_initiator(struct bfa_fcs_itnim_s *itnim,
 	switch (event) {
 	case BFA_FCS_ITNIM_SM_OFFLINE:
 		bfa_sm_set_state(itnim, bfa_fcs_itnim_sm_offline);
-		bfa_fcs_rport_itnim_ack(itnim->rport);
+		bfa_sm_send_event(itnim->rport, RPSM_EVENT_FC4_OFFLINE);
 		break;
 
 	case BFA_FCS_ITNIM_SM_RSP_ERROR:
@@ -688,7 +688,7 @@ bfa_cb_itnim_sler(void *cb_arg)
 
 	itnim->stats.sler++;
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
-	bfa_fcs_rport_logo_imp(itnim->rport);
+	bfa_sm_send_event(itnim->rport, RPSM_EVENT_LOGO_IMP);
 }
 
 struct bfa_fcs_itnim_s *
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index d3e2ad4..c2381c7 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -159,7 +159,7 @@ bfa_fcs_lport_sm_online(
 			bfa_sm_set_state(port, bfa_fcs_lport_sm_deleting);
 			list_for_each_safe(qe, qen, &port->rport_q) {
 				rport = (struct bfa_fcs_rport_s *) qe;
-				bfa_fcs_rport_delete(rport);
+				bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
 			}
 		}
 		break;
@@ -197,7 +197,7 @@ bfa_fcs_lport_sm_offline(
 			bfa_sm_set_state(port, bfa_fcs_lport_sm_deleting);
 			list_for_each_safe(qe, qen, &port->rport_q) {
 				rport = (struct bfa_fcs_rport_s *) qe;
-				bfa_fcs_rport_delete(rport);
+				bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
 			}
 		}
 		break;
@@ -350,7 +350,7 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 		 * disappeared. Send implicit LOGO to old device.
 		 */
 		bfa_assert(rport->pwwn != plogi->port_name);
-		bfa_fcs_rport_logo_imp(rport);
+		bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
 
 		/*
 		 * Inbound PLOGI from a new device (with old PID).
@@ -511,7 +511,8 @@ bfa_fcs_lport_offline_actions(struct bfa_fcs_lport_s *port)
 	__port_action[port->fabric->fab_type].offline(port);
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
-	if (bfa_fcs_fabric_is_online(port->fabric) == BFA_TRUE)
+	if (bfa_sm_cmp_state(port->fabric,
+			bfa_fcs_fabric_sm_online) == BFA_TRUE)
 		BFA_LOG(KERN_ERR, bfad, log_level,
 		"Logical port lost fabric connectivity: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
@@ -522,7 +523,7 @@ bfa_fcs_lport_offline_actions(struct bfa_fcs_lport_s *port)
 
 	list_for_each_safe(qe, qen, &port->rport_q) {
 		rport = (struct bfa_fcs_rport_s *) qe;
-		bfa_fcs_rport_offline(rport);
+		bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
 	}
 }
 
@@ -584,7 +585,7 @@ bfa_fcs_lport_deleted(struct bfa_fcs_lport_s *port)
 				port->vport ? port->vport->vport_drv : NULL);
 		bfa_fcs_vport_delete_comp(port->vport);
 	} else {
-		 bfa_fcs_fabric_port_delete_comp(port->fabric);
+		bfa_wc_down(&port->fabric->wc);
 	}
 }
 
@@ -828,8 +829,8 @@ bfa_fcs_lport_attach(struct bfa_fcs_lport_s *lport, struct bfa_fcs_s *fcs,
 	lport->fcs = fcs;
 	lport->fabric = bfa_fcs_vf_lookup(fcs, vf_id);
 	lport->vport = vport;
-	lport->lp_tag = (vport) ? bfa_lps_get_tag(vport->lps) :
-				  bfa_lps_get_tag(lport->fabric->lps);
+	lport->lp_tag = (vport) ? vport->lps->lp_tag :
+				  lport->fabric->lps->lp_tag;
 
 	INIT_LIST_HEAD(&lport->rport_q);
 	lport->num_rports = 0;
@@ -881,10 +882,11 @@ bfa_fcs_lport_get_attr(
 	port_attr->port_cfg = port->port_cfg;
 
 	if (port->fabric) {
-		port_attr->port_type = bfa_fcs_fabric_port_type(port->fabric);
-		port_attr->loopback = bfa_fcs_fabric_is_loopback(port->fabric);
+		port_attr->port_type = port->fabric->oper_type;
+		port_attr->loopback = bfa_sm_cmp_state(port->fabric, bfa_fcs_fabric_sm_loopback);
 		port_attr->authfail =
-			bfa_fcs_fabric_is_auth_failed(port->fabric);
+			bfa_sm_cmp_state(port->fabric,
+				bfa_fcs_fabric_sm_auth_failed);
 		port_attr->fabric_name  = bfa_fcs_lport_get_fabric_name(port);
 		memcpy(port_attr->fabric_ip_addr,
 			bfa_fcs_lport_get_fabric_ipaddr(port),
@@ -893,10 +895,10 @@ bfa_fcs_lport_get_attr(
 		if (port->vport != NULL) {
 			port_attr->port_type = BFA_PORT_TYPE_VPORT;
 			port_attr->fpma_mac =
-				bfa_lps_get_lp_mac(port->vport->lps);
+				port->vport->lps->lp_mac;
 		} else {
 			port_attr->fpma_mac =
-				bfa_lps_get_lp_mac(port->fabric->lps);
+				port->fabric->lps->lp_mac;
 		}
 	} else {
 		port_attr->port_type = BFA_PORT_TYPE_UNKNOWN;
@@ -985,7 +987,7 @@ bfa_fcs_lport_n2n_online(struct bfa_fcs_lport_s *port)
 			bfa_trc(port->fcs, rport->pid);
 			bfa_trc(port->fcs, rport->pwwn);
 			rport->pid = N2N_REMOTE_PID;
-			bfa_fcs_rport_online(rport);
+			bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_SEND);
 			return;
 		}
 
@@ -998,7 +1000,7 @@ bfa_fcs_lport_n2n_online(struct bfa_fcs_lport_s *port)
 			bfa_assert(rport != NULL);
 			if (rport) {
 				bfa_trc(port->fcs, rport->pwwn);
-				bfa_fcs_rport_delete(rport);
+				bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
 			}
 		}
 		bfa_fcs_rport_create(port, N2N_REMOTE_PID);
@@ -2540,7 +2542,7 @@ bfa_fcs_lport_ms_send_gmal(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	len = fc_gmal_req_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
 			     bfa_fcs_lport_get_fcid(port),
-				 bfa_lps_get_peer_nwwn(port->fabric->lps));
+				 port->fabric->lps->pr_nwwn);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, len, &fchs,
@@ -2740,7 +2742,7 @@ bfa_fcs_lport_ms_send_gfn(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 
 	len = fc_gfn_req_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
 			     bfa_fcs_lport_get_fcid(port),
-				 bfa_lps_get_peer_nwwn(port->fabric->lps));
+				 port->fabric->lps->pr_nwwn);
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, len, &fchs,
@@ -4332,8 +4334,8 @@ bfa_fcs_lport_scn_send_scr(void *scn_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	/* Handle VU registrations for Base port only */
 	if ((!port->vport) && bfa_ioc_get_fcmode(&port->fcs->bfa->ioc)) {
 		len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-				bfa_lps_is_brcd_fabric(port->fabric->lps),
-							port->pid, 0);
+				port->fabric->lps->brcd_switch,
+				port->pid, 0);
 	} else {
 	    len = fc_scr_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
 				    BFA_FALSE,
@@ -4833,7 +4835,7 @@ bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
 		port_info->max_vports_supp =
 			bfa_lps_get_max_vport(port->fcs->bfa);
 		port_info->num_vports_inuse =
-			bfa_fcs_fabric_vport_count(port->fabric);
+			port->fabric->num_vports;
 		port_info->max_rports_supp = BFA_FCS_MAX_RPORTS_SUPP;
 		port_info->num_rports_inuse = port->num_rports;
 	} else {
@@ -4977,7 +4979,8 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
 
 	switch (event) {
 	case BFA_FCS_VPORT_SM_START:
-		if (bfa_fcs_fabric_is_online(__vport_fabric(vport))
+		if (bfa_sm_cmp_state(__vport_fabric(vport),
+					bfa_fcs_fabric_sm_online)
 		    && bfa_fcs_fabric_npiv_capable(__vport_fabric(vport))) {
 			bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc);
 			bfa_fcs_vport_do_fdisc(vport);
@@ -5060,13 +5063,13 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 	switch (event) {
 	case BFA_FCS_VPORT_SM_DELETE:
 		bfa_sm_set_state(vport, bfa_fcs_vport_sm_cleanup);
-		bfa_lps_discard(vport->lps);
+		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
 		bfa_fcs_lport_delete(&vport->lport);
 		break;
 
 	case BFA_FCS_VPORT_SM_OFFLINE:
 		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
-		bfa_lps_discard(vport->lps);
+		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
 		break;
 
 	case BFA_FCS_VPORT_SM_RSP_OK:
@@ -5146,7 +5149,7 @@ bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
 
 	case BFA_FCS_VPORT_SM_OFFLINE:
 		bfa_sm_set_state(vport, bfa_fcs_vport_sm_offline);
-		bfa_lps_discard(vport->lps);
+		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
 		bfa_fcs_lport_offline(&vport->lport);
 		break;
 
@@ -5246,7 +5249,7 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 
 	switch (event) {
 	case BFA_FCS_VPORT_SM_OFFLINE:
-		bfa_lps_discard(vport->lps);
+		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
 		/*
 		 * !!! fall through !!!
 		 */
@@ -5285,14 +5288,14 @@ bfa_fcs_vport_do_fdisc(struct bfa_fcs_vport_s *vport)
 static void
 bfa_fcs_vport_fdisc_rejected(struct bfa_fcs_vport_s *vport)
 {
-	u8		lsrjt_rsn = bfa_lps_get_lsrjt_rsn(vport->lps);
-	u8		lsrjt_expl = bfa_lps_get_lsrjt_expl(vport->lps);
+	u8		lsrjt_rsn = vport->lps->lsrjt_rsn;
+	u8		lsrjt_expl = vport->lps->lsrjt_expl;
 
 	bfa_trc(__vport_fcs(vport), lsrjt_rsn);
 	bfa_trc(__vport_fcs(vport), lsrjt_expl);
 
 	/* For certain reason codes, we don't want to retry. */
-	switch (bfa_lps_get_lsrjt_expl(vport->lps)) {
+	switch (vport->lps->lsrjt_expl) {
 	case FC_LS_RJT_EXP_INV_PORT_NAME: /* by brocade */
 	case FC_LS_RJT_EXP_INVALID_NPORT_ID: /* by Cisco */
 		if (vport->fdisc_retries < BFA_FCS_VPORT_MAX_RETRIES)
@@ -5456,7 +5459,7 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 	if (bfa_fcs_vport_lookup(fcs, vf_id, vport_cfg->pwwn) != NULL)
 		return BFA_STATUS_VPORT_EXISTS;
 
-	if (bfa_fcs_fabric_vport_count(&fcs->fabric) ==
+	if (fcs->fabric.num_vports ==
 			bfa_lps_get_max_vport(fcs->bfa))
 		return BFA_STATUS_VPORT_MAX;
 
@@ -5637,7 +5640,7 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 		/*
 		 * Initialiaze the V-Port fields
 		 */
-		__vport_fcid(vport) = bfa_lps_get_pid(vport->lps);
+		__vport_fcid(vport) = vport->lps->lp_pid;
 		vport->vport_stats.fdisc_accepts++;
 		bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_OK);
 		break;
@@ -5650,7 +5653,7 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 		break;
 
 	case BFA_STATUS_EPROTOCOL:
-		switch (bfa_lps_get_extstatus(vport->lps)) {
+		switch (vport->lps->ext_status) {
 		case BFA_EPROTO_BAD_ACCEPT:
 			vport->vport_stats.fdisc_acc_bad++;
 			break;
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index ecf8dd7..b6332fd 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -75,30 +75,6 @@ static void	bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport,
 static void	bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 				struct fchs_s *rx_fchs, u16 len);
 static void bfa_fcs_rport_send_prlo_acc(struct bfa_fcs_rport_s *rport);
-/*
- *  fcs_rport_sm FCS rport state machine events
- */
-
-enum rport_event {
-	RPSM_EVENT_PLOGI_SEND	= 1,	/*  new rport; start with PLOGI */
-	RPSM_EVENT_PLOGI_RCVD	= 2,	/*  Inbound PLOGI from remote port */
-	RPSM_EVENT_PLOGI_COMP	= 3,	/*  PLOGI completed to rport	*/
-	RPSM_EVENT_LOGO_RCVD	= 4,	/*  LOGO from remote device	*/
-	RPSM_EVENT_LOGO_IMP	= 5,	/*  implicit logo for SLER	*/
-	RPSM_EVENT_FCXP_SENT	= 6,	/*  Frame from has been sent	*/
-	RPSM_EVENT_DELETE	= 7,	/*  RPORT delete request	*/
-	RPSM_EVENT_SCN		= 8,	/*  state change notification	*/
-	RPSM_EVENT_ACCEPTED	= 9,	/*  Good response from remote device */
-	RPSM_EVENT_FAILED	= 10,	/*  Request to rport failed.	*/
-	RPSM_EVENT_TIMEOUT	= 11,	/*  Rport SM timeout event	*/
-	RPSM_EVENT_HCB_ONLINE  = 12,	/*  BFA rport online callback	*/
-	RPSM_EVENT_HCB_OFFLINE = 13,	/*  BFA rport offline callback	*/
-	RPSM_EVENT_FC4_OFFLINE = 14,	/*  FC-4 offline complete	*/
-	RPSM_EVENT_ADDRESS_CHANGE = 15,	/*  Rport's PID has changed	*/
-	RPSM_EVENT_ADDRESS_DISC = 16,	/*  Need to Discover rport's PID */
-	RPSM_EVENT_PRLO_RCVD   = 17,	/*  PRLO from remote device	*/
-	RPSM_EVENT_PLOGI_RETRY = 18,	/*  Retry PLOGI continously */
-};
 
 static void	bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport,
 					enum rport_event event);
@@ -498,24 +474,24 @@ bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_LOGO_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logorcv);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		break;
 
 	case RPSM_EVENT_LOGO_IMP:
 	case RPSM_EVENT_ADDRESS_CHANGE:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_offline);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		break;
 
 	case RPSM_EVENT_PLOGI_RCVD:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_plogiacc_sending);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		bfa_fcs_rport_send_plogiacc(rport, NULL);
 		break;
 
 	case RPSM_EVENT_DELETE:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logosend);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		break;
 
 	case RPSM_EVENT_SCN:
@@ -824,7 +800,7 @@ bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
 	switch (event) {
 	case RPSM_EVENT_FC4_OFFLINE:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logorcv);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		break;
 
 	case RPSM_EVENT_DELETE:
@@ -856,7 +832,7 @@ bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
 	switch (event) {
 	case RPSM_EVENT_FC4_OFFLINE:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_logosend);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		break;
 
 	default:
@@ -878,7 +854,7 @@ bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 	switch (event) {
 	case RPSM_EVENT_FC4_OFFLINE:
 		bfa_sm_set_state(rport, bfa_fcs_rport_sm_hcb_offline);
-		bfa_rport_offline(rport->bfa_rport);
+		bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_OFFLINE);
 		break;
 
 	case RPSM_EVENT_SCN:
@@ -1459,7 +1435,7 @@ bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			twin->stats.plogi_rcvd	  += rport->stats.plogi_rcvd;
 			twin->stats.plogi_accs++;
 
-			bfa_fcs_rport_delete(rport);
+			bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
 
 			bfa_fcs_rport_update(twin, plogi_rsp);
 			twin->pid = rsp_fchs->s_id;
@@ -1998,7 +1974,7 @@ bfa_fcs_rport_alloc(struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 rpid)
 		rport->itnim = bfa_fcs_itnim_create(rport);
 		if (!rport->itnim) {
 			bfa_trc(fcs, rpid);
-			bfa_rport_delete(rport->bfa_rport);
+			bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_DELETE);
 			kfree(rport_drv);
 			return NULL;
 		}
@@ -2032,7 +2008,7 @@ bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport)
 			bfa_fcs_rpf_rport_offline(rport);
 	}
 
-	bfa_rport_delete(rport->bfa_rport);
+	bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_DELETE);
 	bfa_fcs_lport_del_rport(port, rport);
 	kfree(rport->rp_drv);
 }
@@ -2307,40 +2283,8 @@ bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_RCVD);
 }
 
-/*
- * Called by bport/vport to delete a remote port instance.
- *
- * Rport delete is called under the following conditions:
- *		- vport is deleted
- *		- vf is deleted
- *		- explicit request from OS to delete rport
- */
-void
-bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
-}
 
 /*
- * Called by bport/vport to  when a target goes offline.
- *
- */
-void
-bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
-}
-
-/*
- * Called by bport in n2n when a target (attached port) becomes online.
- *
- */
-void
-bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_SEND);
-}
-/*
  *	Called by bport/vport to notify SCN for the remote port
  */
 void
@@ -2350,15 +2294,6 @@ bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_SCN);
 }
 
-/*
- *	Called by	fcpim to notify that the ITN cleanup is done.
- */
-void
-bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
-}
-
 
 /*
  *	brief
@@ -2457,15 +2392,6 @@ bfa_cb_rport_qos_scn_prio(void *cbarg,
  *		Called to process any unsolicted frames from this remote port
  */
 void
-bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport)
-{
-	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
-}
-
-/*
- *		Called to process any unsolicted frames from this remote port
- */
-void
 bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport,
 			struct fchs_s *fchs, u16 len)
 {
@@ -2578,6 +2504,7 @@ bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport)
 	return bfa_sm_to_state(rport_sm_table, rport->sm);
 }
 
+
 /*
  *	brief
  *		 Called by the Driver to set rport delete/ageout timeout
@@ -2703,7 +2630,7 @@ bfa_fcs_rpf_sm_uninit(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 	case RPFSM_EVENT_RPORT_ONLINE:
 		/* Send RPSC2 to a Brocade fabric only. */
 		if ((!BFA_FCS_PID_IS_WKA(rport->pid)) &&
-			((bfa_lps_is_brcd_fabric(rport->port->fabric->lps)) ||
+			((rport->port->fabric->lps->brcd_switch) ||
 			(bfa_fcs_fabric_get_switch_oui(fabric) ==
 						BFA_FCS_BRCD_SWITCH_OUI))) {
 			bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_rpsc_sending);
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index efd4c76..d23c114 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -42,11 +42,6 @@ BFA_TRC_FILE(CNA, IOC);
 			bfa_ioc_hb_check, (__ioc), BFA_IOC_HB_TOV)
 #define bfa_hb_timer_stop(__ioc)	bfa_timer_stop(&(__ioc)->hb_timer)
 
-#define BFA_DBG_FWTRC_ENTS	(BFI_IOC_TRC_ENTS)
-#define BFA_DBG_FWTRC_LEN					\
-	(BFA_DBG_FWTRC_ENTS * sizeof(struct bfa_trc_s) +	\
-	 (sizeof(struct bfa_trc_mod_s) -			\
-	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
 #define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
 
 /*
@@ -81,24 +76,18 @@ bfa_boolean_t bfa_auto_recover = BFA_TRUE;
  * forward declarations
  */
 static void bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
-static void bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
 static void bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
 static void bfa_ioc_timeout(void *ioc);
 static void bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
 static void bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
 static void bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
 static void bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
-static void bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
-static void bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
 static void bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
 static void bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_recover(struct bfa_ioc_s *ioc);
 static void bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc);
 static void bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
 static void bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
-static void bfa_ioc_pf_enabled(struct bfa_ioc_s *ioc);
-static void bfa_ioc_pf_disabled(struct bfa_ioc_s *ioc);
-static void bfa_ioc_pf_failed(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc);
 
 
@@ -162,12 +151,6 @@ static struct bfa_sm_table_s ioc_sm_table[] = {
 /*
  * Forward declareations for iocpf state machine
  */
-static void bfa_iocpf_enable(struct bfa_ioc_s *ioc);
-static void bfa_iocpf_disable(struct bfa_ioc_s *ioc);
-static void bfa_iocpf_fail(struct bfa_ioc_s *ioc);
-static void bfa_iocpf_initfail(struct bfa_ioc_s *ioc);
-static void bfa_iocpf_getattrfail(struct bfa_ioc_s *ioc);
-static void bfa_iocpf_stop(struct bfa_ioc_s *ioc);
 static void bfa_iocpf_timeout(void *ioc_arg);
 static void bfa_iocpf_sem_timeout(void *ioc_arg);
 
@@ -298,7 +281,7 @@ bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
 static void
 bfa_ioc_sm_enabling_entry(struct bfa_ioc_s *ioc)
 {
-	bfa_iocpf_enable(ioc);
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_ENABLE);
 }
 
 /*
@@ -321,7 +304,7 @@ bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_HWERROR:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
-		bfa_iocpf_initfail(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
 		break;
 
 	case IOC_E_DISABLE:
@@ -330,7 +313,7 @@ bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_DETACH:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
-		bfa_iocpf_stop(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_STOP);
 		break;
 
 	case IOC_E_ENABLE:
@@ -375,7 +358,7 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_TIMEOUT:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
-		bfa_iocpf_getattrfail(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_GETATTRFAIL);
 		break;
 
 	case IOC_E_DISABLE:
@@ -412,22 +395,22 @@ bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	case IOC_E_DISABLE:
-		bfa_ioc_hb_stop(ioc);
+		bfa_hb_timer_stop(ioc);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
 		break;
 
 	case IOC_E_FAILED:
-		bfa_ioc_hb_stop(ioc);
+		bfa_hb_timer_stop(ioc);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
 		break;
 
 	case IOC_E_HWERROR:
-		bfa_ioc_hb_stop(ioc);
+		bfa_hb_timer_stop(ioc);
 		/* !!! fall through !!! */
 
 	case IOC_E_HBFAIL:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
-		bfa_iocpf_fail(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FAIL);
 		break;
 
 	default:
@@ -440,7 +423,7 @@ static void
 bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
 {
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
-	bfa_iocpf_disable(ioc);
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_DISABLE);
 	BFA_LOG(KERN_INFO, bfad, log_level, "IOC disabled\n");
 }
 
@@ -463,7 +446,7 @@ bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 		 * after iocpf sm completes failure processing and
 		 * moves to disabled state.
 		 */
-		bfa_iocpf_fail(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FAIL);
 		break;
 
 	default:
@@ -496,7 +479,7 @@ bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_DETACH:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
-		bfa_iocpf_stop(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_STOP);
 		break;
 
 	default:
@@ -537,7 +520,7 @@ bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	case IOC_E_DETACH:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
-		bfa_iocpf_stop(ioc);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_STOP);
 		break;
 
 	default:
@@ -668,19 +651,19 @@ bfa_iocpf_sm_fwcheck(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 			iocpf->retry_count = 0;
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
 		} else {
-			bfa_ioc_hw_sem_release(ioc);
+			writel(1, ioc->ioc_regs.ioc_sem_reg);
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_mismatch);
 		}
 		break;
 
 	case IOCPF_E_DISABLE:
-		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_sem_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
-		bfa_ioc_pf_disabled(ioc);
+		bfa_fsm_send_event(ioc, IOC_E_DISABLED);
 		break;
 
 	case IOCPF_E_STOP:
-		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_sem_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
 		break;
 
@@ -723,7 +706,7 @@ bfa_iocpf_sm_mismatch(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	case IOCPF_E_DISABLE:
 		bfa_iocpf_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
-		bfa_ioc_pf_disabled(ioc);
+		bfa_fsm_send_event(ioc, IOC_E_DISABLED);
 		break;
 
 	case IOCPF_E_STOP:
@@ -762,7 +745,7 @@ bfa_iocpf_sm_semwait(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	case IOCPF_E_DISABLE:
-		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_sem_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
@@ -776,7 +759,7 @@ static void
 bfa_iocpf_sm_hwinit_entry(struct bfa_iocpf_s *iocpf)
 {
 	bfa_iocpf_timer_start(iocpf->ioc);
-	bfa_ioc_reset(iocpf->ioc, BFA_FALSE);
+	bfa_ioc_hwinit(iocpf->ioc, BFA_FALSE);
 }
 
 /*
@@ -806,19 +789,19 @@ bfa_iocpf_sm_hwinit(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		iocpf->retry_count++;
 		if (iocpf->retry_count < BFA_IOC_HWINIT_MAX) {
 			bfa_iocpf_timer_start(ioc);
-			bfa_ioc_reset(ioc, BFA_TRUE);
+			bfa_ioc_hwinit(ioc, BFA_TRUE);
 			break;
 		}
 
-		bfa_ioc_hw_sem_release(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
 		if (event == IOCPF_E_TIMEOUT)
-			bfa_ioc_pf_failed(ioc);
+			bfa_fsm_send_event(ioc, IOC_E_FAILED);
 		break;
 
 	case IOCPF_E_DISABLE:
-		bfa_ioc_hw_sem_release(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_iocpf_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
@@ -850,7 +833,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	switch (event) {
 	case IOCPF_E_FWRSP_ENABLE:
 		bfa_iocpf_timer_stop(ioc);
-		bfa_ioc_hw_sem_release(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_ready);
 		break;
 
@@ -868,16 +851,16 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 			break;
 		}
 
-		bfa_ioc_hw_sem_release(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
 		if (event == IOCPF_E_TIMEOUT)
-			bfa_ioc_pf_failed(ioc);
+			bfa_fsm_send_event(ioc, IOC_E_FAILED);
 		break;
 
 	case IOCPF_E_DISABLE:
 		bfa_iocpf_timer_stop(ioc);
-		bfa_ioc_hw_sem_release(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling);
 		break;
 
@@ -895,7 +878,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_ready_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_pf_enabled(iocpf->ioc);
+	bfa_fsm_send_event(iocpf->ioc, IOC_E_ENABLED);
 }
 
 static void
@@ -919,12 +902,12 @@ bfa_iocpf_sm_ready(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	case IOCPF_E_FWREADY:
-		if (bfa_ioc_is_operational(ioc))
+		if (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op))
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail);
 		else
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
-		bfa_ioc_pf_failed(ioc);
+		bfa_fsm_send_event(ioc, IOC_E_FAILED);
 		break;
 
 	default:
@@ -982,7 +965,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_disabled_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_pf_disabled(iocpf->ioc);
+	bfa_fsm_send_event(iocpf->ioc, IOC_E_DISABLED);	
 }
 
 static void
@@ -1140,11 +1123,6 @@ bfa_ioc_sem_get(void __iomem *sem_reg)
 	return BFA_FALSE;
 }
 
-void
-bfa_ioc_sem_release(void __iomem *sem_reg)
-{
-	writel(1, sem_reg);
-}
 
 static void
 bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
@@ -1164,18 +1142,6 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 	bfa_sem_timer_start(ioc);
 }
 
-void
-bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
-{
-	writel(1, ioc->ioc_regs.ioc_sem_reg);
-}
-
-static void
-bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
-{
-	bfa_sem_timer_stop(ioc);
-}
-
 /*
  * Initialize LPU local memory (aka secondary memory / SRAM)
  */
@@ -1255,8 +1221,8 @@ bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 	int		i;
 	u32	*fwsig = (u32 *) fwhdr;
 
-	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
-	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
+	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
@@ -1519,13 +1485,6 @@ bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
 	bfa_hb_timer_start(ioc);
 }
 
-static void
-bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
-{
-	bfa_hb_timer_stop(ioc);
-}
-
-
 /*
  *	Initiate a full firmware download.
  */
@@ -1547,8 +1506,8 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	bfa_trc(ioc, bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)));
 	fwimg = bfa_cb_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), chunkno);
 
-	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
-	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
+	pgoff = PSS_SMEM_PGOFF(loff);
 
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
@@ -1578,7 +1537,8 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		}
 	}
 
-	writel(bfa_ioc_smem_pgnum(ioc, 0), ioc->ioc_regs.host_page_num_fn);
+	writel(PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, 0),
+			ioc->ioc_regs.host_page_num_fn);
 
 	/*
 	 * Set boot type and boot param at the end.
@@ -1589,11 +1549,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 			swab32(boot_env));
 }
 
-static void
-bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
-{
-	bfa_ioc_hwinit(ioc, force);
-}
 
 /*
  * Update BFA configuration from firmware configuration.
@@ -1685,8 +1640,8 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 	int i, len;
 	u32 *buf = tbuf;
 
-	pgnum = bfa_ioc_smem_pgnum(ioc, soff);
-	loff = bfa_ioc_smem_pgoff(ioc, soff);
+	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, soff);
+	loff = PSS_SMEM_PGOFF(soff);
 	bfa_trc(ioc, pgnum);
 	bfa_trc(ioc, loff);
 	bfa_trc(ioc, sz);
@@ -1717,11 +1672,12 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 			writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 		}
 	}
-	writel(bfa_ioc_smem_pgnum(ioc, 0), ioc->ioc_regs.host_page_num_fn);
+	writel(PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, 0),
+			ioc->ioc_regs.host_page_num_fn);
 	/*
 	 *  release semaphore.
 	 */
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+	writel(1, ioc->ioc_regs.ioc_init_sem_reg);
 
 	bfa_trc(ioc, pgnum);
 	return BFA_STATUS_OK;
@@ -1740,8 +1696,8 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 	int i, len;
 	u32 pgnum, loff;
 
-	pgnum = bfa_ioc_smem_pgnum(ioc, soff);
-	loff = bfa_ioc_smem_pgoff(ioc, soff);
+	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, soff);
+	loff = PSS_SMEM_PGOFF(soff);
 	bfa_trc(ioc, pgnum);
 	bfa_trc(ioc, loff);
 	bfa_trc(ioc, sz);
@@ -1771,36 +1727,17 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 			writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 		}
 	}
-	writel(bfa_ioc_smem_pgnum(ioc, 0), ioc->ioc_regs.host_page_num_fn);
+	writel(PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, 0),
+			ioc->ioc_regs.host_page_num_fn);
 
 	/*
 	 *  release semaphore.
 	 */
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+	writel(1, ioc->ioc_regs.ioc_init_sem_reg);
 	bfa_trc(ioc, pgnum);
 	return BFA_STATUS_OK;
 }
 
-/*
- * hal iocpf to ioc interface
- */
-static void
-bfa_ioc_pf_enabled(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(ioc, IOC_E_ENABLED);
-}
-
-static void
-bfa_ioc_pf_disabled(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(ioc, IOC_E_DISABLED);
-}
-
-static void
-bfa_ioc_pf_failed(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(ioc, IOC_E_FAILED);
-}
 
 static void
 bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
@@ -1831,7 +1768,7 @@ bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 	/*
 	 *  release semaphore.
 	 */
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+	writel(1, ioc->ioc_regs.ioc_init_sem_reg);
 
 	return BFA_STATUS_OK;
 }
@@ -2036,15 +1973,6 @@ bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa)
 	ioc->attr = (struct bfi_ioc_attr_s *) dm_kva;
 }
 
-/*
- * Return size of dma memory required.
- */
-u32
-bfa_ioc_meminfo(void)
-{
-	return BFA_ROUNDUP(sizeof(struct bfi_ioc_attr_s), BFA_DMA_ALIGN_SZ);
-}
-
 void
 bfa_ioc_enable(struct bfa_ioc_s *ioc)
 {
@@ -2061,18 +1989,6 @@ bfa_ioc_disable(struct bfa_ioc_s *ioc)
 	bfa_fsm_send_event(ioc, IOC_E_DISABLE);
 }
 
-/*
- * Returns memory required for saving firmware trace in case of crash.
- * Driver must call this interface to allocate memory required for
- * automatic saving of firmware trace. Driver should call
- * bfa_ioc_debug_memclaim() right after bfa_ioc_attach() to setup this
- * trace memory.
- */
-int
-bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover)
-{
-	return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
-}
 
 /*
  * Initialize memory for saving firmware trace. Driver must initialize
@@ -2082,19 +1998,7 @@ void
 bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave)
 {
 	ioc->dbg_fwsave	    = dbg_fwsave;
-	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->iocpf.auto_recover);
-}
-
-u32
-bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr)
-{
-	return PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, fmaddr);
-}
-
-u32
-bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr)
-{
-	return PSS_SMEM_PGOFF(fmaddr);
+	ioc->dbg_fwsave_len = (ioc->iocpf.auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 }
 
 /*
@@ -2257,17 +2161,6 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 	return BFA_TRUE;
 }
 
-/*
- * Add to IOC heartbeat failure notification queue. To be used by common
- * modules such as cee, port, diag.
- */
-void
-bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
-			struct bfa_ioc_hbfail_notify_s *notify)
-{
-	list_add_tail(&notify->qe, &ioc->hb_notify_q);
-}
-
 #define BFA_MFG_NAME "Brocade"
 void
 bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
@@ -2299,7 +2192,7 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	else
 		ad_attr->prototype = 0;
 
-	ad_attr->pwwn = bfa_ioc_get_pwwn(ioc);
+	ad_attr->pwwn = ioc->attr->pwwn;
 	ad_attr->mac  = bfa_ioc_get_mac(ioc);
 
 	ad_attr->pcie_gen = ioc_attr->pcie_gen;
@@ -2448,24 +2341,6 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 	bfa_ioc_get_pci_chip_rev(ioc, ioc_attr->pci_attr.chip_rev);
 }
 
-wwn_t
-bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
-{
-	return ioc->attr->pwwn;
-}
-
-wwn_t
-bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc)
-{
-	return ioc->attr->nwwn;
-}
-
-u64
-bfa_ioc_get_adid(struct bfa_ioc_s *ioc)
-{
-	return ioc->attr->mfg_pwwn;
-}
-
 mac_t
 bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 {
@@ -2478,18 +2353,6 @@ bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 		return ioc->attr->mac;
 }
 
-wwn_t
-bfa_ioc_get_mfg_pwwn(struct bfa_ioc_s *ioc)
-{
-	return ioc->attr->mfg_pwwn;
-}
-
-wwn_t
-bfa_ioc_get_mfg_nwwn(struct bfa_ioc_s *ioc)
-{
-	return ioc->attr->mfg_nwwn;
-}
-
 mac_t
 bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc)
 {
@@ -2718,43 +2581,6 @@ bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc)
 /*
  *  BFA IOC PF private functions
  */
-
-static void
-bfa_iocpf_enable(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_ENABLE);
-}
-
-static void
-bfa_iocpf_disable(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_DISABLE);
-}
-
-static void
-bfa_iocpf_fail(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FAIL);
-}
-
-static void
-bfa_iocpf_initfail(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
-}
-
-static void
-bfa_iocpf_getattrfail(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_GETATTRFAIL);
-}
-
-static void
-bfa_iocpf_stop(struct bfa_ioc_s *ioc)
-{
-	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_STOP);
-}
-
 static void
 bfa_iocpf_timeout(void *ioc_arg)
 {
@@ -2776,12 +2602,6 @@ bfa_iocpf_sem_timeout(void *ioc_arg)
  *  bfa timer function
  */
 void
-bfa_timer_init(struct bfa_timer_mod_s *mod)
-{
-	INIT_LIST_HEAD(&mod->timer_q);
-}
-
-void
 bfa_timer_beat(struct bfa_timer_mod_s *mod)
 {
 	struct list_head *qh = &mod->timer_q;
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index ff012f7..3c5bdd1 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -22,6 +22,11 @@
 #include "bfa_cs.h"
 #include "bfi.h"
 
+#define BFA_DBG_FWTRC_ENTS	(BFI_IOC_TRC_ENTS)
+#define BFA_DBG_FWTRC_LEN					\
+	(BFA_DBG_FWTRC_ENTS * sizeof(struct bfa_trc_s) +	\
+	(sizeof(struct bfa_trc_mod_s) -				\
+	BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
 /*
  * BFA timer declarations
  */
@@ -47,7 +52,6 @@ struct bfa_timer_mod_s {
 #define BFA_TIMER_FREQ 200 /* specified in millisecs */
 
 void bfa_timer_beat(struct bfa_timer_mod_s *mod);
-void bfa_timer_init(struct bfa_timer_mod_s *mod);
 void bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
 			bfa_timer_cbfn_t timercb, void *arg,
 			unsigned int timeout);
@@ -325,7 +329,6 @@ void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
 void bfa_ioc_detach(struct bfa_ioc_s *ioc);
 void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 		enum bfi_mclass mc);
-u32 bfa_ioc_meminfo(void);
 void bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa);
 void bfa_ioc_enable(struct bfa_ioc_s *ioc);
 void bfa_ioc_disable(struct bfa_ioc_s *ioc);
@@ -353,7 +356,6 @@ enum bfa_ioc_state bfa_ioc_get_state(struct bfa_ioc_s *ioc);
 void bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr);
 void bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 		struct bfa_adapter_attr_s *ad_attr);
-int bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover);
 void bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave);
 bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
 		int *trclen);
@@ -361,15 +363,9 @@ bfa_status_t bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata,
 				 int *trclen);
 bfa_status_t bfa_ioc_debug_fwcore(struct bfa_ioc_s *ioc, void *buf,
 	u32 *offset, int *buflen);
-u32 bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr);
-u32 bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr);
 void bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc);
-void bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
-	struct bfa_ioc_hbfail_notify_s *notify);
 bfa_boolean_t bfa_ioc_sem_get(void __iomem *sem_reg);
-void bfa_ioc_sem_release(void __iomem *sem_reg);
-void bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
 void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
 bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
@@ -380,13 +376,8 @@ bfa_status_t bfa_ioc_fw_stats_clear(struct bfa_ioc_s *ioc);
 /*
  * bfa mfg wwn API functions
  */
-wwn_t bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc);
-wwn_t bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc);
 mac_t bfa_ioc_get_mac(struct bfa_ioc_s *ioc);
-wwn_t bfa_ioc_get_mfg_pwwn(struct bfa_ioc_s *ioc);
-wwn_t bfa_ioc_get_mfg_nwwn(struct bfa_ioc_s *ioc);
 mac_t bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc);
-u64 bfa_ioc_get_adid(struct bfa_ioc_s *ioc);
 
 /*
  * F/W Image Size & Chunk
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 61f03cb..e9c8554 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -181,7 +181,7 @@ bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
 	 * will lock it instead of clearing it.
 	 */
 	readl(ioc->ioc_regs.ioc_sem_reg);
-	bfa_ioc_hw_sem_release(ioc);
+	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
 
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 79fb312..45d0ddc 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -83,7 +83,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	 */
 	if (usecnt == 0) {
 		writel(1, ioc->ioc_regs.ioc_usage_reg);
-		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		writel(1, ioc->ioc_regs.ioc_usage_sem_reg);
 		bfa_trc(ioc, usecnt);
 		return BFA_TRUE;
 	}
@@ -101,7 +101,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	 */
 	bfa_ioc_fwver_get(ioc, &fwhdr);
 	if (!bfa_ioc_fwver_cmp(ioc, &fwhdr)) {
-		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		writel(1, ioc->ioc_regs.ioc_usage_sem_reg);
 		bfa_trc(ioc, usecnt);
 		return BFA_FALSE;
 	}
@@ -111,7 +111,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	 */
 	usecnt++;
 	writel(usecnt, ioc->ioc_regs.ioc_usage_reg);
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	writel(1, ioc->ioc_regs.ioc_usage_sem_reg);
 	bfa_trc(ioc, usecnt);
 	return BFA_TRUE;
 }
@@ -145,7 +145,7 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 	writel(usecnt, ioc->ioc_regs.ioc_usage_reg);
 	bfa_trc(ioc, usecnt);
 
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	writel(1, ioc->ioc_regs.ioc_usage_sem_reg);
 }
 
 /*
@@ -313,7 +313,7 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 	if (ioc->cna) {
 		bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
 		writel(0, ioc->ioc_regs.ioc_usage_reg);
-		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		writel(1, ioc->ioc_regs.ioc_usage_sem_reg);
 	}
 
 	/*
@@ -322,7 +322,7 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 	 * will lock it instead of clearing it.
 	 */
 	readl(ioc->ioc_regs.ioc_sem_reg);
-	bfa_ioc_hw_sem_release(ioc);
+	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
 
diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.h
index bdcd8ec..1c9baa6 100644
--- a/drivers/scsi/bfa/bfa_plog.h
+++ b/drivers/scsi/bfa/bfa_plog.h
@@ -151,6 +151,5 @@ void bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 void bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 			enum bfa_plog_eid event, u16 misc,
 			struct fchs_s *fchdr, u32 pld_w0);
-bfa_boolean_t	bfa_plog_get_setting(struct bfa_plog_s *plog);
 
 #endif /* __BFA_PORTLOG_H__ */
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index fa57b12..76efb9a 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -447,7 +447,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 
 	bfa_ioc_mbox_regisr(port->ioc, BFI_MC_PORT, bfa_port_isr, port);
 	bfa_ioc_hbfail_init(&port->hbfail, bfa_port_hbfail, port);
-	bfa_ioc_hbfail_register(port->ioc, &port->hbfail);
+	list_add_tail(&port->hbfail.qe, &port->ioc->hb_notify_q);
 
 	/*
 	 * initialize time stamp for stats reset
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index ef223ad..a708d95 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -41,19 +41,6 @@ BFA_MODULE(uf);
 #define BFA_LPS_MAX_VPORTS_SUPP_CB  255
 #define BFA_LPS_MAX_VPORTS_SUPP_CT  190
 
-/*
- *  lps_pvt BFA LPS private functions
- */
-
-enum bfa_lps_event {
-	BFA_LPS_SM_LOGIN	= 1,	/* login request from user	*/
-	BFA_LPS_SM_LOGOUT	= 2,	/* logout request from user	*/
-	BFA_LPS_SM_FWRSP	= 3,	/* f/w response to login/logout	*/
-	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue	*/
-	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user		*/
-	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline		*/
-	BFA_LPS_SM_RX_CVL	= 7,	/* Rx clear virtual link	*/
-};
 
 /*
  * FC PORT related definitions
@@ -113,19 +100,6 @@ enum bfa_fcport_ln_sm_event {
 		}							\
 } while (0)
 
-
-enum bfa_rport_event {
-	BFA_RPORT_SM_CREATE	= 1,	/*  rport create event		*/
-	BFA_RPORT_SM_DELETE	= 2,	/*  deleting an existing rport	*/
-	BFA_RPORT_SM_ONLINE	= 3,	/*  rport is online		*/
-	BFA_RPORT_SM_OFFLINE	= 4,	/*  rport is offline		*/
-	BFA_RPORT_SM_FWRSP	= 5,	/*  firmware response		*/
-	BFA_RPORT_SM_HWFAIL	= 6,	/*  IOC h/w failure		*/
-	BFA_RPORT_SM_QOS_SCN	= 7,	/*  QoS SCN from firmware	*/
-	BFA_RPORT_SM_SET_SPEED	= 8,	/*  Set Rport Speed		*/
-	BFA_RPORT_SM_QRESUME	= 9,	/*  space in requeue queue	*/
-};
-
 /*
  * forward declarations FCXP related functions
  */
@@ -438,12 +412,6 @@ bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 }
 
 
-bfa_boolean_t
-bfa_plog_get_setting(struct bfa_plog_s *plog)
-{
-	return (bfa_boolean_t)plog->plog_enabled;
-}
-
 /*
  *  fcxp_pvt BFA FCXP private functions
  */
@@ -1846,24 +1814,6 @@ bfa_lps_fdisclogo(struct bfa_lps_s *lps)
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
 }
 
-/*
- * Discard a pending login request -- should be called only for
- * link down handling.
- */
-void
-bfa_lps_discard(struct bfa_lps_s *lps)
-{
-	bfa_sm_send_event(lps, BFA_LPS_SM_OFFLINE);
-}
-
-/*
- * Return lport services tag
- */
-u8
-bfa_lps_get_tag(struct bfa_lps_s *lps)
-{
-	return lps->lp_tag;
-}
 
 /*
  * Return lport services tag given the pid
@@ -1884,55 +1834,6 @@ bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid)
 	return 0;
 }
 
-/*
- * return if fabric login indicates support for NPIV
- */
-bfa_boolean_t
-bfa_lps_is_npiv_en(struct bfa_lps_s *lps)
-{
-	return lps->npiv_en;
-}
-
-/*
- * Return TRUE if attached to F-Port, else return FALSE
- */
-bfa_boolean_t
-bfa_lps_is_fport(struct bfa_lps_s *lps)
-{
-	return lps->fport;
-}
-
-/*
- * Return TRUE if attached to a Brocade Fabric
- */
-bfa_boolean_t
-bfa_lps_is_brcd_fabric(struct bfa_lps_s *lps)
-{
-	return lps->brcd_switch;
-}
-/*
- * return TRUE if authentication is required
- */
-bfa_boolean_t
-bfa_lps_is_authreq(struct bfa_lps_s *lps)
-{
-	return lps->auth_req;
-}
-
-bfa_eproto_status_t
-bfa_lps_get_extstatus(struct bfa_lps_s *lps)
-{
-	return lps->ext_status;
-}
-
-/*
- * return port id assigned to the lport
- */
-u32
-bfa_lps_get_pid(struct bfa_lps_s *lps)
-{
-	return lps->lp_pid;
-}
 
 /*
  * return port id assigned to the base lport
@@ -1946,60 +1847,6 @@ bfa_lps_get_base_pid(struct bfa_s *bfa)
 }
 
 /*
- * Return bb_credit assigned in FLOGI response
- */
-u16
-bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps)
-{
-	return lps->pr_bbcred;
-}
-
-/*
- * Return peer port name
- */
-wwn_t
-bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps)
-{
-	return lps->pr_pwwn;
-}
-
-/*
- * Return peer node name
- */
-wwn_t
-bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps)
-{
-	return lps->pr_nwwn;
-}
-
-/*
- * return reason code if login request is rejected
- */
-u8
-bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps)
-{
-	return lps->lsrjt_rsn;
-}
-
-/*
- * return explanation code if login request is rejected
- */
-u8
-bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps)
-{
-	return lps->lsrjt_expl;
-}
-
-/*
- * Return fpma/spma MAC for lport
- */
-mac_t
-bfa_lps_get_lp_mac(struct bfa_lps_s *lps)
-{
-	return lps->lp_mac;
-}
-
-/*
  * LPS firmware message class handler.
  */
 void
@@ -3064,8 +2911,8 @@ bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 static void
 bfa_fcport_set_wwns(struct bfa_fcport_s *fcport)
 {
-	fcport->pwwn = bfa_ioc_get_pwwn(&fcport->bfa->ioc);
-	fcport->nwwn = bfa_ioc_get_nwwn(&fcport->bfa->ioc);
+	fcport->pwwn = fcport->bfa->ioc.attr->pwwn;
+	fcport->nwwn = fcport->bfa->ioc.attr->nwwn;
 
 	bfa_trc(fcport->bfa, fcport->pwwn);
 	bfa_trc(fcport->bfa, fcport->nwwn);
@@ -3707,8 +3554,8 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 	attr->nwwn = fcport->nwwn;
 	attr->pwwn = fcport->pwwn;
 
-	attr->factorypwwn =  bfa_ioc_get_mfg_pwwn(&bfa->ioc);
-	attr->factorynwwn =  bfa_ioc_get_mfg_nwwn(&bfa->ioc);
+	attr->factorypwwn =  bfa->ioc.attr->mfg_pwwn;
+	attr->factorynwwn =  bfa->ioc.attr->mfg_nwwn;
 
 	memcpy(&attr->pport_cfg, &fcport->cfg,
 		sizeof(struct bfa_port_cfg_s));
@@ -3726,7 +3573,7 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 	/* beacon attributes */
 	attr->beacon = fcport->beacon;
 	attr->link_e2e_beacon = fcport->link_e2e_beacon;
-	attr->plog_enabled = bfa_plog_get_setting(fcport->bfa->plog);
+	attr->plog_enabled = (bfa_boolean_t)fcport->bfa->plog->plog_enabled;
 	attr->io_profile = bfa_fcpim_get_io_profile(fcport->bfa);
 
 	attr->pport_cfg.path_tov  = bfa_fcpim_path_tov_get(bfa);
@@ -4584,7 +4431,7 @@ bfa_rport_create(struct bfa_s *bfa, void *rport_drv)
 
 	rp->bfa = bfa;
 	rp->rport_drv = rport_drv;
-	bfa_rport_clear_stats(rp);
+	memset(&rp->stats, 0, sizeof(rp->stats));
 
 	bfa_assert(bfa_sm_cmp_state(rp, bfa_rport_sm_uninit));
 	bfa_sm_send_event(rp, BFA_RPORT_SM_CREATE);
@@ -4593,12 +4440,6 @@ bfa_rport_create(struct bfa_s *bfa, void *rport_drv)
 }
 
 void
-bfa_rport_delete(struct bfa_rport_s *rport)
-{
-	bfa_sm_send_event(rport, BFA_RPORT_SM_DELETE);
-}
-
-void
 bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
 {
 	bfa_assert(rport_info->max_frmsz != 0);
@@ -4617,12 +4458,6 @@ bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
 }
 
 void
-bfa_rport_offline(struct bfa_rport_s *rport)
-{
-	bfa_sm_send_event(rport, BFA_RPORT_SM_OFFLINE);
-}
-
-void
 bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed)
 {
 	bfa_assert(speed != 0);
@@ -4632,12 +4467,6 @@ bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed)
 	bfa_sm_send_event(rport, BFA_RPORT_SM_SET_SPEED);
 }
 
-void
-bfa_rport_clear_stats(struct bfa_rport_s *rport)
-{
-	memset(&rport->stats, 0, sizeof(rport->stats));
-}
-
 
 /*
  * SGPG related functions
@@ -5101,8 +4930,6 @@ bfa_uf_start(struct bfa_s *bfa)
 	bfa_uf_post_all(BFA_UF_MOD(bfa));
 }
 
-
-
 /*
  *  hal_uf_api
  */
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 0e23c1b..29b0918 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -220,6 +220,18 @@ void	bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 /*
  * RPORT related defines
  */
+enum bfa_rport_event {
+	BFA_RPORT_SM_CREATE	= 1,	/*  rport create event          */
+	BFA_RPORT_SM_DELETE	= 2,	/*  deleting an existing rport  */
+	BFA_RPORT_SM_ONLINE	= 3,	/*  rport is online             */
+	BFA_RPORT_SM_OFFLINE	= 4,	/*  rport is offline            */
+	BFA_RPORT_SM_FWRSP	= 5,	/*  firmware response           */
+	BFA_RPORT_SM_HWFAIL	= 6,	/*  IOC h/w failure             */
+	BFA_RPORT_SM_QOS_SCN	= 7,	/*  QoS SCN from firmware       */
+	BFA_RPORT_SM_SET_SPEED	= 8,	/*  Set Rport Speed             */
+	BFA_RPORT_SM_QRESUME	= 9,	/*  space in requeue queue      */
+};
+
 #define BFA_RPORT_MIN	4
 
 struct bfa_rport_mod_s {
@@ -516,12 +528,9 @@ bfa_boolean_t bfa_fcport_is_qos_enabled(struct bfa_s *bfa);
  * bfa rport API functions
  */
 struct bfa_rport_s *bfa_rport_create(struct bfa_s *bfa, void *rport_drv);
-void bfa_rport_delete(struct bfa_rport_s *rport);
 void bfa_rport_online(struct bfa_rport_s *rport,
 		      struct bfa_rport_info_s *rport_info);
-void bfa_rport_offline(struct bfa_rport_s *rport);
 void bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed);
-void bfa_rport_clear_stats(struct bfa_rport_s *rport);
 void bfa_cb_rport_online(void *rport);
 void bfa_cb_rport_offline(void *rport);
 void bfa_cb_rport_qos_scn_flowid(void *rport,
@@ -594,28 +603,14 @@ void bfa_uf_free(struct bfa_uf_s *uf);
 u32 bfa_lps_get_max_vport(struct bfa_s *bfa);
 struct bfa_lps_s *bfa_lps_alloc(struct bfa_s *bfa);
 void bfa_lps_delete(struct bfa_lps_s *lps);
-void bfa_lps_discard(struct bfa_lps_s *lps);
 void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa,
 		   u16 pdusz, wwn_t pwwn, wwn_t nwwn,
 		   bfa_boolean_t auth_en);
 void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz,
 		   wwn_t pwwn, wwn_t nwwn);
 void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
-u8 bfa_lps_get_tag(struct bfa_lps_s *lps);
-bfa_boolean_t bfa_lps_is_npiv_en(struct bfa_lps_s *lps);
-bfa_boolean_t bfa_lps_is_fport(struct bfa_lps_s *lps);
-bfa_boolean_t bfa_lps_is_brcd_fabric(struct bfa_lps_s *lps);
-bfa_boolean_t bfa_lps_is_authreq(struct bfa_lps_s *lps);
-bfa_eproto_status_t bfa_lps_get_extstatus(struct bfa_lps_s *lps);
-u32 bfa_lps_get_pid(struct bfa_lps_s *lps);
 u32 bfa_lps_get_base_pid(struct bfa_s *bfa);
 u8 bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid);
-u16 bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps);
-wwn_t bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps);
-wwn_t bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps);
-u8 bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps);
-u8 bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps);
-mac_t bfa_lps_get_lp_mac(struct bfa_lps_s *lps);
 void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg);
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index ff7af36a..ac21d31 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -206,7 +206,7 @@ bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
 		}
 
 		spin_lock_irqsave(&bfad->bfad_lock, flags);
-		bfa_init(&bfad->bfa);
+		bfa_iocfc_init(&bfad->bfa);
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 		/* Set up interrupt handler for each vectors */
@@ -725,7 +725,7 @@ bfad_bfa_tmo(unsigned long data)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	bfa_timer_tick(&bfad->bfa);
+	bfa_timer_beat(&bfad->bfa.timer_mod);
 
 	bfa_comp_deq(&bfad->bfa, &doneq);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -882,8 +882,8 @@ bfad_drv_init(struct bfad_s *bfad)
 		goto out_hal_mem_alloc_failure;
 	}
 
-	bfa_init_trc(&bfad->bfa, bfad->trcmod);
-	bfa_init_plog(&bfad->bfa, &bfad->plog_buf);
+	bfad->bfa.trcmod = bfad->trcmod;
+	bfad->bfa.plog = &bfad->plog_buf;
 	bfa_plog_init(&bfad->plog_buf);
 	bfa_plog_str(&bfad->plog_buf, BFA_PL_MID_DRVR, BFA_PL_EID_DRIVER_START,
 		     0, "Driver Attach");
@@ -893,9 +893,9 @@ bfad_drv_init(struct bfad_s *bfad)
 
 	/* FCS INIT */
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	bfa_fcs_trc_init(&bfad->bfa_fcs, bfad->trcmod);
+	bfad->bfa_fcs.trcmod = bfad->trcmod;
 	bfa_fcs_attach(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
-	bfa_fcs_set_fdmi_param(&bfad->bfa_fcs, fdmi_enable);
+	bfad->bfa_fcs.fdmi_enabled = fdmi_enable;
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	bfad->bfad_flags |= BFAD_DRV_INIT_DONE;
@@ -913,7 +913,7 @@ bfad_drv_uninit(struct bfad_s *bfad)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	init_completion(&bfad->comp);
-	bfa_stop(&bfad->bfa);
+	bfa_iocfc_stop(&bfad->bfa);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	wait_for_completion(&bfad->comp);
 
@@ -932,8 +932,8 @@ bfad_drv_start(struct bfad_s *bfad)
 	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	bfa_start(&bfad->bfa);
-	bfa_fcs_start(&bfad->bfa_fcs);
+	bfa_iocfc_start(&bfad->bfa);
+	bfa_fcs_fabric_modstart(&bfad->bfa_fcs);
 	bfad->bfad_flags |= BFAD_HAL_START_DONE;
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
@@ -963,7 +963,7 @@ bfad_stop(struct bfad_s *bfad)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	init_completion(&bfad->comp);
-	bfa_stop(&bfad->bfa);
+	bfa_iocfc_stop(&bfad->bfa);
 	bfad->bfad_flags &= ~BFAD_HAL_START_DONE;
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	wait_for_completion(&bfad->comp);
@@ -1524,7 +1524,7 @@ bfad_init(void)
 	if (strcmp(FCPI_NAME, " fcpim") == 0)
 		supported_fc4s |= BFA_LPORT_ROLE_FCP_IM;
 
-	bfa_ioc_auto_recover(ioc_auto_recover);
+	bfa_auto_recover = ioc_auto_recover;
 	bfa_fcs_rport_set_del_timeout(rport_del_timeout);
 
 	error = pci_register_driver(&bfad_pci_driver);
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 144602c..c76eec0 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -90,7 +90,7 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	rc = bfa_debug_fwtrc(&bfad->bfa,
+	rc = bfa_ioc_debug_fwtrc(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
 			&fw_debug->buffer_len);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -134,7 +134,7 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	rc = bfa_debug_fwsave(&bfad->bfa,
+	rc = bfa_ioc_debug_fwsave(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
 			&fw_debug->buffer_len);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8ca967d..d24b7e4 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -921,7 +921,7 @@ bfad_im_supported_speeds(struct bfa_s *bfa)
 	if (!ioc_attr)
 		return 0;
 
-	bfa_get_attr(bfa, ioc_attr);
+	bfa_ioc_get_attr(&bfa->ioc, ioc_attr);
 	if (ioc_attr->adapter_attr.max_speed == BFA_PORT_SPEED_8GBPS) {
 		if (ioc_attr->adapter_attr.is_mezz) {
 			supported_speed |= FC_PORTSPEED_8GBIT |
-- 
1.7.2.1

