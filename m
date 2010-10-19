From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 6/6] bfa: fix comments for c files
Date: Mon, 18 Oct 2010 17:17:23 -0700
Message-ID: <1287447443-32204-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43984 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188Ab0JSARp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:17:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch addresses the comments from Randy Dunlap (Randy.Dunlap@oracle.com)
regarding comment blocks that begining with "/**". bfa driver comments
currently do not follow kernel-doc convention, we hence replace all 
/** with /* and **/ with */. 

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c      |  112 ++++++------
 drivers/scsi/bfa/bfa_drv.c       |    6 +-
 drivers/scsi/bfa/bfa_fcbuild.c   |    2 +-
 drivers/scsi/bfa/bfa_fcpim.c     |  300 +++++++++++++++---------------
 drivers/scsi/bfa/bfa_fcs.c       |  134 +++++++-------
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   30 ++--
 drivers/scsi/bfa/bfa_fcs_lport.c |  368 ++++++++++++++++---------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |  170 +++++++++---------
 drivers/scsi/bfa/bfa_hw_cb.c     |    6 +-
 drivers/scsi/bfa/bfa_hw_ct.c     |    6 +-
 drivers/scsi/bfa/bfa_ioc.c       |  238 ++++++++++++------------
 drivers/scsi/bfa/bfa_ioc_cb.c    |   22 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |   42 ++--
 drivers/scsi/bfa/bfa_port.c      |   32 ++--
 drivers/scsi/bfa/bfa_svc.c       |  378 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfad.c          |   32 ++--
 drivers/scsi/bfa/bfad_attr.c     |   30 ++--
 drivers/scsi/bfa/bfad_im.c       |   38 ++--
 18 files changed, 943 insertions(+), 1003 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index f75c6be..2345f48 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -21,11 +21,11 @@
 
 BFA_TRC_FILE(HAL, CORE);
 
-/**
+/*
  * BFA IOC FC related definitions
  */
 
-/**
+/*
  * IOC local definitions
  */
 #define BFA_IOCFC_TOV		5000	/* msecs */
@@ -54,7 +54,7 @@ enum {
 #define DEF_CFG_NUM_SBOOT_TGTS		16
 #define DEF_CFG_NUM_SBOOT_LUNS		16
 
-/**
+/*
  * forward declaration for IOC FC functions
  */
 static void bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status);
@@ -63,7 +63,7 @@ static void bfa_iocfc_hbfail_cbfn(void *bfa_arg);
 static void bfa_iocfc_reset_cbfn(void *bfa_arg);
 static struct bfa_ioc_cbfn_s bfa_iocfc_cbfn;
 
-/**
+/*
  * BFA Interrupt handling functions
  */
 static void
@@ -86,7 +86,7 @@ bfa_reqq_resume(struct bfa_s *bfa, int qid)
 
 	waitq = bfa_reqq(bfa, qid);
 	list_for_each_safe(qe, qen, waitq) {
-		/**
+		/*
 		 * Callback only as long as there is room in request queue
 		 */
 		if (bfa_reqq_full(bfa, qid))
@@ -104,7 +104,7 @@ bfa_msix_all(struct bfa_s *bfa, int vec)
 	bfa_intx(bfa);
 }
 
-/**
+/*
  *  hal_intr_api
  */
 bfa_boolean_t
@@ -117,7 +117,7 @@ bfa_intx(struct bfa_s *bfa)
 	if (!intr)
 		return BFA_FALSE;
 
-	/**
+	/*
 	 * RME completion queue interrupt
 	 */
 	qintr = intr & __HFN_INT_RME_MASK;
@@ -131,7 +131,7 @@ bfa_intx(struct bfa_s *bfa)
 	if (!intr)
 		return BFA_TRUE;
 
-	/**
+	/*
 	 * CPE completion queue interrupt
 	 */
 	qintr = intr & __HFN_INT_CPE_MASK;
@@ -211,7 +211,7 @@ bfa_msix_reqq(struct bfa_s *bfa, int qid)
 
 	bfa->iocfc.hwif.hw_reqq_ack(bfa, qid);
 
-	/**
+	/*
 	 * Resume any pending requests in the corresponding reqq.
 	 */
 	waitq = bfa_reqq(bfa, qid);
@@ -259,14 +259,14 @@ bfa_msix_rspq(struct bfa_s *bfa, int qid)
 		}
 	}
 
-	/**
+	/*
 	 * update CI
 	 */
 	bfa_rspq_ci(bfa, qid) = pi;
 	writel(pi, bfa->iocfc.bfa_regs.rme_q_ci[qid]);
 	mmiowb();
 
-	/**
+	/*
 	 * Resume any pending requests in the corresponding reqq.
 	 */
 	waitq = bfa_reqq(bfa, qid);
@@ -289,7 +289,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 
 	if (intr) {
 		if (intr & __HFN_INT_LL_HALT) {
-			/**
+			/*
 			 * If LL_HALT bit is set then FW Init Halt LL Port
 			 * Register needs to be cleared as well so Interrupt
 			 * Status Register will be cleared.
@@ -300,7 +300,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 		}
 
 		if (intr & __HFN_INT_ERR_PSS) {
-			/**
+			/*
 			 * ERR_PSS bit needs to be cleared as well in case
 			 * interrups are shared so driver's interrupt handler is
 			 * still called eventhough it is already masked out.
@@ -323,11 +323,11 @@ bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func)
 	bfa_isrs[mc] = isr_func;
 }
 
-/**
+/*
  * BFA IOC FC related functions
  */
 
-/**
+/*
  *  hal_ioc_pvt BFA IOC private functions
  */
 
@@ -366,7 +366,7 @@ bfa_iocfc_fw_cfg_sz(struct bfa_iocfc_cfg_s *cfg, u32 *dm_len)
 			    BFA_CACHELINE_SZ);
 }
 
-/**
+/*
  * Use the Mailbox interface to send BFI_IOCFC_H2I_CFG_REQ
  */
 static void
@@ -384,14 +384,14 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 
 	bfa_iocfc_reset_queues(bfa);
 
-	/**
+	/*
 	 * initialize IOC configuration info
 	 */
 	cfg_info->endian_sig = BFI_IOC_ENDIAN_SIG;
 	cfg_info->num_cqs = cfg->fwcfg.num_cqs;
 
 	bfa_dma_be_addr_set(cfg_info->cfgrsp_addr, iocfc->cfgrsp_dma.pa);
-	/**
+	/*
 	 * dma map REQ and RSP circular queues and shadow pointers
 	 */
 	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
@@ -410,7 +410,7 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 			cpu_to_be16(cfg->drvcfg.num_rspq_elems);
 	}
 
-	/**
+	/*
 	 * Enable interrupt coalescing if it is driver init path
 	 * and not ioc disable/enable path.
 	 */
@@ -419,7 +419,7 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 
 	iocfc->cfgdone = BFA_FALSE;
 
-	/**
+	/*
 	 * dma map IOC configuration itself
 	 */
 	bfi_h2i_set(cfg_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CFG_REQ,
@@ -442,7 +442,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 	iocfc->cfg = *cfg;
 
-	/**
+	/*
 	 * Initialize chip specific handlers.
 	 */
 	if (bfa_asic_id_ct(bfa_ioc_devid(&bfa->ioc))) {
@@ -559,7 +559,7 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 	}
 }
 
-/**
+/*
  * Start BFA submodules.
  */
 static void
@@ -573,7 +573,7 @@ bfa_iocfc_start_submod(struct bfa_s *bfa)
 		hal_mods[i]->start(bfa);
 }
 
-/**
+/*
  * Disable BFA submodules.
  */
 static void
@@ -623,7 +623,7 @@ bfa_iocfc_disable_cb(void *bfa_arg, bfa_boolean_t compl)
 		complete(&bfad->disable_comp);
 }
 
-/**
+/*
  * Update BFA configuration from firmware configuration.
  */
 static void
@@ -642,7 +642,7 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 
 	iocfc->cfgdone = BFA_TRUE;
 
-	/**
+	/*
 	 * Configuration is complete - initialize/start submodules
 	 */
 	bfa_fcport_init(bfa);
@@ -665,7 +665,7 @@ bfa_iocfc_reset_queues(struct bfa_s *bfa)
 	}
 }
 
-/**
+/*
  * IOC enable request is complete
  */
 static void
@@ -684,7 +684,7 @@ bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status)
 	bfa_iocfc_send_cfg(bfa);
 }
 
-/**
+/*
  * IOC disable request is complete
  */
 static void
@@ -705,7 +705,7 @@ bfa_iocfc_disable_cbfn(void *bfa_arg)
 	}
 }
 
-/**
+/*
  * Notify sub-modules of hardware failure.
  */
 static void
@@ -723,7 +723,7 @@ bfa_iocfc_hbfail_cbfn(void *bfa_arg)
 			     bfa);
 }
 
-/**
+/*
  * Actions on chip-reset completion.
  */
 static void
@@ -735,11 +735,11 @@ bfa_iocfc_reset_cbfn(void *bfa_arg)
 	bfa_isr_enable(bfa);
 }
 
-/**
+/*
  *  hal_ioc_public
  */
 
-/**
+/*
  * Query IOC memory requirement information.
  */
 void
@@ -754,7 +754,7 @@ bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
 	*km_len += bfa_ioc_debug_trcsz(bfa_auto_recover);
 }
 
-/**
+/*
  * Query IOC memory requirement information.
  */
 void
@@ -772,7 +772,7 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	ioc->trcmod = bfa->trcmod;
 	bfa_ioc_attach(&bfa->ioc, bfa, &bfa_iocfc_cbfn, &bfa->timer_mod);
 
-	/**
+	/*
 	 * Set FC mode for BFA_PCI_DEVICE_ID_CT_FC.
 	 */
 	if (pcidev->device_id == BFA_PCI_DEVICE_ID_CT_FC)
@@ -790,7 +790,7 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		INIT_LIST_HEAD(&bfa->reqq_waitq[i]);
 }
 
-/**
+/*
  * Query IOC memory requirement information.
  */
 void
@@ -799,7 +799,7 @@ bfa_iocfc_detach(struct bfa_s *bfa)
 	bfa_ioc_detach(&bfa->ioc);
 }
 
-/**
+/*
  * Query IOC memory requirement information.
  */
 void
@@ -809,7 +809,7 @@ bfa_iocfc_init(struct bfa_s *bfa)
 	bfa_ioc_enable(&bfa->ioc);
 }
 
-/**
+/*
  * IOC start called from bfa_start(). Called to start IOC operations
  * at driver instantiation for this instance.
  */
@@ -820,7 +820,7 @@ bfa_iocfc_start(struct bfa_s *bfa)
 		bfa_iocfc_start_submod(bfa);
 }
 
-/**
+/*
  * IOC stop called from bfa_stop(). Called only when driver is unloaded
  * for this instance.
  */
@@ -924,7 +924,7 @@ bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa)
 	iocfc->cfginfo->sense_buf_len = (BFI_IOIM_SNSLEN - 1);
 	bfa_dma_be_addr_set(iocfc->cfginfo->ioim_snsbase, snsbase_pa);
 }
-/**
+/*
  * Enable IOC after it is disabled.
  */
 void
@@ -953,7 +953,7 @@ bfa_iocfc_is_operational(struct bfa_s *bfa)
 	return bfa_ioc_is_operational(&bfa->ioc) && bfa->iocfc.cfgdone;
 }
 
-/**
+/*
  * Return boot target port wwns -- read from boot information in flash.
  */
 void
@@ -998,11 +998,11 @@ bfa_iocfc_get_pbc_vports(struct bfa_s *bfa, struct bfi_pbc_vport_s *pbc_vport)
 	return cfgrsp->pbc_cfg.nvports;
 }
 
-/**
+/*
  *  hal_api
  */
 
-/**
+/*
  * Use this function query the memory requirement of the BFA library.
  * This function needs to be called before bfa_attach() to get the
  * memory required of the BFA layer for a given driver configuration.
@@ -1055,7 +1055,7 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
 	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_len = dm_len;
 }
 
-/**
+/*
  * Use this function to do attach the driver instance with the BFA
  * library. This function will not trigger any HW initialization
  * process (which will be done in bfa_init() call)
@@ -1092,7 +1092,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 
 	bfa_assert((cfg != NULL) && (meminfo != NULL));
 
-	/**
+	/*
 	 * initialize all memory pointers for iterative allocation
 	 */
 	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
@@ -1109,7 +1109,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_com_port_attach(bfa, meminfo);
 }
 
-/**
+/*
  * Use this function to delete a BFA IOC. IOC should be stopped (by
  * calling bfa_stop()) before this function call.
  *
@@ -1146,7 +1146,7 @@ bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog)
 	bfa->plog = plog;
 }
 
-/**
+/*
  * Initialize IOC.
  *
  * This function will return immediately, when the IOC initialization is
@@ -1169,7 +1169,7 @@ bfa_init(struct bfa_s *bfa)
 	bfa_iocfc_init(bfa);
 }
 
-/**
+/*
  * Use this function initiate the IOC configuration setup. This function
  * will return immediately.
  *
@@ -1183,7 +1183,7 @@ bfa_start(struct bfa_s *bfa)
 	bfa_iocfc_start(bfa);
 }
 
-/**
+/*
  * Use this function quiese the IOC. This function will return immediately,
  * when the IOC is actually stopped, the bfad->comp will be set.
  *
@@ -1243,7 +1243,7 @@ bfa_attach_fcs(struct bfa_s *bfa)
 	bfa->fcs = BFA_TRUE;
 }
 
-/**
+/*
  * Periodic timer heart beat from driver
  */
 void
@@ -1252,7 +1252,7 @@ bfa_timer_tick(struct bfa_s *bfa)
 	bfa_timer_beat(&bfa->timer_mod);
 }
 
-/**
+/*
  * Return the list of PCI vendor/device id lists supported by this
  * BFA instance.
  */
@@ -1270,7 +1270,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
 	*pciids = __pciids;
 }
 
-/**
+/*
  * Use this function query the default struct bfa_iocfc_cfg_s value (compiled
  * into BFA layer). The OS driver can then turn back and overwrite entries that
  * have been configured by the user.
@@ -1328,7 +1328,7 @@ bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr)
 	bfa_ioc_get_attr(&bfa->ioc, ioc_attr);
 }
 
-/**
+/*
  * Retrieve firmware trace information on IOC failure.
  */
 bfa_status_t
@@ -1337,7 +1337,7 @@ bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
 	return bfa_ioc_debug_fwsave(&bfa->ioc, trcdata, trclen);
 }
 
-/**
+/*
  * Clear the saved firmware trace information of an IOC.
  */
 void
@@ -1346,7 +1346,7 @@ bfa_debug_fwsave_clear(struct bfa_s *bfa)
 	bfa_ioc_debug_fwsave_clear(&bfa->ioc);
 }
 
-/**
+/*
  * Fetch firmware trace data.
  *
  * @param[in]		bfa			BFA instance
@@ -1362,7 +1362,7 @@ bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen)
 	return bfa_ioc_debug_fwtrc(&bfa->ioc, trcdata, trclen);
 }
 
-/**
+/*
  * Dump firmware memory.
  *
  * @param[in]		bfa		BFA instance
@@ -1378,7 +1378,7 @@ bfa_debug_fwcore(struct bfa_s *bfa, void *buf, u32 *offset, int *buflen)
 {
 	return bfa_ioc_debug_fwcore(&bfa->ioc, buf, offset, buflen);
 }
-/**
+/*
  * Reset hw semaphore & usage cnt regs and initialize.
  */
 void
@@ -1388,7 +1388,7 @@ bfa_chip_reset(struct bfa_s *bfa)
 	bfa_ioc_pll_init(&bfa->ioc);
 }
 
-/**
+/*
  * Fetch firmware statistics data.
  *
  * @param[in]		bfa		BFA instance
diff --git a/drivers/scsi/bfa/bfa_drv.c b/drivers/scsi/bfa/bfa_drv.c
index 1412764..0222d7c 100644
--- a/drivers/scsi/bfa/bfa_drv.c
+++ b/drivers/scsi/bfa/bfa_drv.c
@@ -17,7 +17,7 @@
 
 #include "bfa_modules.h"
 
-/**
+/*
  * BFA module list terminated by NULL
  */
 struct bfa_module_s *hal_mods[] = {
@@ -31,7 +31,7 @@ struct bfa_module_s *hal_mods[] = {
 	NULL
 };
 
-/**
+/*
  * Message handlers for various modules.
  */
 bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
@@ -70,7 +70,7 @@ bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
 };
 
 
-/**
+/*
  * Message handlers for mailbox command classes
  */
 bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 85b0050..9c72531 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -150,7 +150,7 @@ fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 	fchs->s_id = (s_id);
 	fchs->ox_id = cpu_to_be16(ox_id);
 
-	/**
+	/*
 	 * @todo no need to set ox_id for request
 	 *       no need to set rx_id for response
 	 */
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 8c585bd..135c442 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -26,7 +26,7 @@ BFA_MODULE(fcpim);
 	(__l->__stats += __r->__stats)
 
 
-/**
+/*
  *  BFA ITNIM Related definitions
  */
 static void bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim);
@@ -72,7 +72,7 @@ static void bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim);
 	}								\
 } while (0)
 
-/**
+/*
  *  bfa_itnim_sm BFA itnim state machine
  */
 
@@ -89,7 +89,7 @@ enum bfa_itnim_event {
 	BFA_ITNIM_SM_QRESUME = 9,	/*  queue space available */
 };
 
-/**
+/*
  *  BFA IOIM related definitions
  */
 #define bfa_ioim_move_to_comp_q(__ioim) do {				\
@@ -107,11 +107,11 @@ enum bfa_itnim_event {
 	if ((__fcpim)->profile_start)					\
 		(__fcpim)->profile_start(__ioim);			\
 } while (0)
-/**
+/*
  *  hal_ioim_sm
  */
 
-/**
+/*
  * IO state machine events
  */
 enum bfa_ioim_event {
@@ -136,11 +136,11 @@ enum bfa_ioim_event {
 };
 
 
-/**
+/*
  *  BFA TSKIM related definitions
  */
 
-/**
+/*
  * task management completion handling
  */
 #define bfa_tskim_qcomp(__tskim, __cbfn) do {				\
@@ -165,7 +165,7 @@ enum bfa_tskim_event {
 	BFA_TSKIM_SM_CLEANUP_DONE = 9,	/*  TM abort completion	*/
 };
 
-/**
+/*
  * forward declaration for BFA ITNIM functions
  */
 static void     bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim);
@@ -183,7 +183,7 @@ static void     bfa_itnim_iotov_start(struct bfa_itnim_s *itnim);
 static void     bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim);
 static void     bfa_itnim_iotov_delete(struct bfa_itnim_s *itnim);
 
-/**
+/*
  * forward declaration of ITNIM state machine
  */
 static void     bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim,
@@ -217,7 +217,7 @@ static void     bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
 static void     bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
 					enum bfa_itnim_event event);
 
-/**
+/*
  * forward declaration for BFA IOIM functions
  */
 static bfa_boolean_t	bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim);
@@ -233,7 +233,7 @@ static void __bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete);
 static bfa_boolean_t    bfa_ioim_is_abortable(struct bfa_ioim_s *ioim);
 
 
-/**
+/*
  * forward declaration of BFA IO state machine
  */
 static void     bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim,
@@ -261,7 +261,7 @@ static void     bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim,
 static void	bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim,
 					enum bfa_ioim_event event);
 
-/**
+/*
  * forward declaration for BFA TSKIM functions
  */
 static void     __bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete);
@@ -276,7 +276,7 @@ static bfa_boolean_t bfa_tskim_send_abort(struct bfa_tskim_s *tskim);
 static void     bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim);
 
 
-/**
+/*
  * forward declaration of BFA TSKIM state machine
  */
 static void     bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim,
@@ -294,11 +294,11 @@ static void     bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 static void     bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim,
 					enum bfa_tskim_event event);
 
-/**
+/*
  *  hal_fcpim_mod BFA FCP Initiator Mode module
  */
 
-/**
+/*
  *	Compute and return memory needed by FCP(im) module.
  */
 static void
@@ -307,7 +307,7 @@ bfa_fcpim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
 {
 	bfa_itnim_meminfo(cfg, km_len, dm_len);
 
-	/**
+	/*
 	 * IO memory
 	 */
 	if (cfg->fwcfg.num_ioim_reqs < BFA_IOIM_MIN)
@@ -320,7 +320,7 @@ bfa_fcpim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
 
 	*dm_len += cfg->fwcfg.num_ioim_reqs * BFI_IOIM_SNSLEN;
 
-	/**
+	/*
 	 * task management command memory
 	 */
 	if (cfg->fwcfg.num_tskim_reqs < BFA_TSKIM_MIN)
@@ -604,11 +604,11 @@ bfa_fcpim_set_ioredirect(struct bfa_s *bfa, bfa_boolean_t state)
 
 
 
-/**
+/*
  *  BFA ITNIM module state machine functions
  */
 
-/**
+/*
  *	Beginning/unallocated state - no events expected.
  */
 static void
@@ -629,7 +629,7 @@ bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 	}
 }
 
-/**
+/*
  *	Beginning state, only online event expected.
  */
 static void
@@ -660,7 +660,7 @@ bfa_itnim_sm_created(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 	}
 }
 
-/**
+/*
  *	Waiting for itnim create response from firmware.
  */
 static void
@@ -732,7 +732,7 @@ bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  *	Waiting for itnim create response from firmware, a delete is pending.
  */
 static void
@@ -760,7 +760,7 @@ bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  *	Online state - normal parking state.
  */
 static void
@@ -802,7 +802,7 @@ bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 	}
 }
 
-/**
+/*
  *	Second level error recovery need.
  */
 static void
@@ -833,7 +833,7 @@ bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 	}
 }
 
-/**
+/*
  *	Going offline. Waiting for active IO cleanup.
  */
 static void
@@ -870,7 +870,7 @@ bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  *	Deleting itnim. Waiting for active IO cleanup.
  */
 static void
@@ -898,7 +898,7 @@ bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  * Rport offline. Fimrware itnim is being deleted - awaiting f/w response.
  */
 static void
@@ -955,7 +955,7 @@ bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  *	Offline state.
  */
 static void
@@ -987,7 +987,7 @@ bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 	}
 }
 
-/**
+/*
  *	IOC h/w failed state.
  */
 static void
@@ -1023,7 +1023,7 @@ bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  *	Itnim is deleted, waiting for firmware response to delete.
  */
 static void
@@ -1068,7 +1068,7 @@ bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
 	}
 }
 
-/**
+/*
  *	Initiate cleanup of all IOs on an IOC failure.
  */
 static void
@@ -1088,7 +1088,7 @@ bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim)
 		bfa_ioim_iocdisable(ioim);
 	}
 
-	/**
+	/*
 	 * For IO request in pending queue, we pretend an early timeout.
 	 */
 	list_for_each_safe(qe, qen, &itnim->pending_q) {
@@ -1102,7 +1102,7 @@ bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  *	IO cleanup completion
  */
 static void
@@ -1114,7 +1114,7 @@ bfa_itnim_cleanp_comp(void *itnim_cbarg)
 	bfa_sm_send_event(itnim, BFA_ITNIM_SM_CLEANUP);
 }
 
-/**
+/*
  *	Initiate cleanup of all IOs.
  */
 static void
@@ -1129,7 +1129,7 @@ bfa_itnim_cleanup(struct bfa_itnim_s *itnim)
 	list_for_each_safe(qe, qen, &itnim->io_q) {
 		ioim = (struct bfa_ioim_s *) qe;
 
-		/**
+		/*
 		 * Move IO to a cleanup queue from active queue so that a later
 		 * TM will not pickup this IO.
 		 */
@@ -1176,7 +1176,7 @@ __bfa_cb_itnim_sler(void *cbarg, bfa_boolean_t complete)
 		bfa_cb_itnim_sler(itnim->ditn);
 }
 
-/**
+/*
  * Call to resume any I/O requests waiting for room in request queue.
  */
 static void
@@ -1190,7 +1190,7 @@ bfa_itnim_qresume(void *cbarg)
 
 
 
-/**
+/*
  *  bfa_itnim_public
  */
 
@@ -1210,7 +1210,7 @@ void
 bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
 		u32 *dm_len)
 {
-	/**
+	/*
 	 * ITN memory
 	 */
 	*km_len += cfg->fwcfg.num_rports * sizeof(struct bfa_itnim_s);
@@ -1264,7 +1264,7 @@ bfa_itnim_send_fwcreate(struct bfa_itnim_s *itnim)
 
 	itnim->msg_no++;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
@@ -1281,7 +1281,7 @@ bfa_itnim_send_fwcreate(struct bfa_itnim_s *itnim)
 	m->msg_no = itnim->msg_no;
 	bfa_stats(itnim, fw_create);
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(itnim->bfa, itnim->reqq);
@@ -1293,7 +1293,7 @@ bfa_itnim_send_fwdelete(struct bfa_itnim_s *itnim)
 {
 	struct bfi_itnim_delete_req_s *m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
@@ -1307,14 +1307,14 @@ bfa_itnim_send_fwdelete(struct bfa_itnim_s *itnim)
 	m->fw_handle = itnim->rport->fw_handle;
 	bfa_stats(itnim, fw_delete);
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(itnim->bfa, itnim->reqq);
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Cleanup all pending failed inflight requests.
  */
 static void
@@ -1329,7 +1329,7 @@ bfa_itnim_delayed_comp(struct bfa_itnim_s *itnim, bfa_boolean_t iotov)
 	}
 }
 
-/**
+/*
  * Start all pending IO requests.
  */
 static void
@@ -1339,12 +1339,12 @@ bfa_itnim_iotov_online(struct bfa_itnim_s *itnim)
 
 	bfa_itnim_iotov_stop(itnim);
 
-	/**
+	/*
 	 * Abort all inflight IO requests in the queue
 	 */
 	bfa_itnim_delayed_comp(itnim, BFA_FALSE);
 
-	/**
+	/*
 	 * Start all pending IO requests.
 	 */
 	while (!list_empty(&itnim->pending_q)) {
@@ -1354,7 +1354,7 @@ bfa_itnim_iotov_online(struct bfa_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  * Fail all pending IO requests
  */
 static void
@@ -1362,12 +1362,12 @@ bfa_itnim_iotov_cleanup(struct bfa_itnim_s *itnim)
 {
 	struct bfa_ioim_s *ioim;
 
-	/**
+	/*
 	 * Fail all inflight IO requests in the queue
 	 */
 	bfa_itnim_delayed_comp(itnim, BFA_TRUE);
 
-	/**
+	/*
 	 * Fail any pending IO requests.
 	 */
 	while (!list_empty(&itnim->pending_q)) {
@@ -1377,7 +1377,7 @@ bfa_itnim_iotov_cleanup(struct bfa_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  * IO TOV timer callback. Fail any pending IO requests.
  */
 static void
@@ -1392,7 +1392,7 @@ bfa_itnim_iotov(void *itnim_arg)
 	bfa_cb_itnim_tov(itnim->ditn);
 }
 
-/**
+/*
  * Start IO TOV timer for failing back pending IO requests in offline state.
  */
 static void
@@ -1407,7 +1407,7 @@ bfa_itnim_iotov_start(struct bfa_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  * Stop IO TOV timer.
  */
 static void
@@ -1419,7 +1419,7 @@ bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  * Stop IO TOV timer.
  */
 static void
@@ -1459,11 +1459,11 @@ bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim)
 
 
 
-/**
+/*
  *  bfa_itnim_public
  */
 
-/**
+/*
  *	Itnim interrupt processing.
  */
 void
@@ -1509,7 +1509,7 @@ bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 
 
-/**
+/*
  *  bfa_itnim_api
  */
 
@@ -1552,7 +1552,7 @@ bfa_itnim_offline(struct bfa_itnim_s *itnim)
 	bfa_sm_send_event(itnim, BFA_ITNIM_SM_OFFLINE);
 }
 
-/**
+/*
  * Return true if itnim is considered offline for holding off IO request.
  * IO is not held if itnim is being deleted.
  */
@@ -1603,11 +1603,11 @@ bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
 		itnim->ioprofile.io_latency.min[j] = ~0;
 }
 
-/**
+/*
  *  BFA IO module state machine functions
  */
 
-/**
+/*
  *	IO is not started (unallocated).
  */
 static void
@@ -1657,7 +1657,7 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_ABORT:
-		/**
+		/*
 		 * IO in pending queue can get abort requests. Complete abort
 		 * requests immediately.
 		 */
@@ -1672,7 +1672,7 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  *	IO is waiting for SG pages.
  */
 static void
@@ -1719,7 +1719,7 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  *	IO is active.
  */
 static void
@@ -1803,7 +1803,7 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
 *	IO is retried with new tag.
 */
 static void
@@ -1844,7 +1844,7 @@ bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_ABORT:
-		/** in this state IO abort is done.
+		/* in this state IO abort is done.
 		 * Waiting for IO tag resource free.
 		 */
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
@@ -1857,7 +1857,7 @@ bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  *	IO is being aborted, waiting for completion from firmware.
  */
 static void
@@ -1919,7 +1919,7 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  * IO is being cleaned up (implicit abort), waiting for completion from
  * firmware.
  */
@@ -1937,7 +1937,7 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_ABORT:
-		/**
+		/*
 		 * IO is already being aborted implicitly
 		 */
 		ioim->io_cbfn = __bfa_cb_ioim_abort;
@@ -1969,7 +1969,7 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_CLEANUP:
-		/**
+		/*
 		 * IO can be in cleanup state already due to TM command.
 		 * 2nd cleanup request comes from ITN offline event.
 		 */
@@ -1980,7 +1980,7 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  *	IO is waiting for room in request CQ
  */
 static void
@@ -2024,7 +2024,7 @@ bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  *	Active IO is being aborted, waiting for room in request CQ.
  */
 static void
@@ -2075,7 +2075,7 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  *	Active IO is being cleaned up, waiting for room in request CQ.
  */
 static void
@@ -2091,7 +2091,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_ABORT:
-		/**
+		/*
 		 * IO is alraedy being cleaned up implicitly
 		 */
 		ioim->io_cbfn = __bfa_cb_ioim_abort;
@@ -2125,7 +2125,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  * IO bfa callback is pending.
  */
 static void
@@ -2152,7 +2152,7 @@ bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  * IO bfa callback is pending. IO resource cannot be freed.
  */
 static void
@@ -2185,7 +2185,7 @@ bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	}
 }
 
-/**
+/*
  * IO is completed, waiting resource free from firmware.
  */
 static void
@@ -2214,7 +2214,7 @@ bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 
 
-/**
+/*
  *  hal_ioim_private
  */
 
@@ -2247,7 +2247,7 @@ __bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete)
 
 	m = (struct bfi_ioim_rsp_s *) &ioim->iosp->comp_rspmsg;
 	if (m->io_status == BFI_IOIM_STS_OK) {
-		/**
+		/*
 		 * setup sense information, if present
 		 */
 		if ((m->scsi_status == SCSI_STATUS_CHECK_CONDITION) &&
@@ -2256,7 +2256,7 @@ __bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete)
 			snsinfo = ioim->iosp->snsinfo;
 		}
 
-		/**
+		/*
 		 * setup residue value correctly for normal completions
 		 */
 		if (m->resid_flags == FCP_RESID_UNDER) {
@@ -2327,7 +2327,7 @@ bfa_ioim_sgpg_alloced(void *cbarg)
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_SGALLOCED);
 }
 
-/**
+/*
  * Send I/O request to firmware.
  */
 static	bfa_boolean_t
@@ -2343,7 +2343,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	struct scatterlist *sg;
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(ioim->bfa, ioim->reqq);
@@ -2354,14 +2354,14 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 		return BFA_FALSE;
 	}
 
-	/**
+	/*
 	 * build i/o request message next
 	 */
 	m->io_tag = cpu_to_be16(ioim->iotag);
 	m->rport_hdl = ioim->itnim->rport->fw_handle;
 	m->io_timeout = bfa_cb_ioim_get_timeout(ioim->dio);
 
-	/**
+	/*
 	 * build inline IO SG element here
 	 */
 	sge = &m->sges[0];
@@ -2387,7 +2387,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	sge->flags = BFI_SGE_PGDLEN;
 	bfa_sge_to_be(sge);
 
-	/**
+	/*
 	 * set up I/O command parameters
 	 */
 	m->cmnd = cmnd_z0;
@@ -2397,7 +2397,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	fcp_dl = bfa_cb_ioim_get_size(ioim->dio);
 	m->cmnd.fcp_dl = cpu_to_be32(fcp_dl);
 
-	/**
+	/*
 	 * set up I/O message header
 	 */
 	switch (m->cmnd.iodir) {
@@ -2426,7 +2426,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	m->cmnd.priority = bfa_cb_ioim_get_priority(ioim->dio);
 	m->cmnd.taskattr = bfa_cb_ioim_get_taskattr(ioim->dio);
 
-	/**
+	/*
 	 * Handle large CDB (>16 bytes).
 	 */
 	m->cmnd.addl_cdb_len = (bfa_cb_ioim_get_cdblen(ioim->dio) -
@@ -2440,14 +2440,14 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	}
 #endif
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(ioim->bfa, ioim->reqq);
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Setup any additional SG pages needed.Inline SG element is setup
  * at queuing time.
  */
@@ -2458,7 +2458,7 @@ bfa_ioim_sge_setup(struct bfa_ioim_s *ioim)
 
 	bfa_assert(ioim->nsges > BFI_SGE_INLINE);
 
-	/**
+	/*
 	 * allocate SG pages needed
 	 */
 	nsgpgs = BFA_SGPG_NPAGE(ioim->nsges);
@@ -2507,7 +2507,7 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 			sge->sg_len = sg_dma_len(sg);
 			pgcumsz += sge->sg_len;
 
-			/**
+			/*
 			 * set flags
 			 */
 			if (i < (nsges - 1))
@@ -2522,7 +2522,7 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 
 		sgpg = (struct bfa_sgpg_s *) bfa_q_next(sgpg);
 
-		/**
+		/*
 		 * set the link element of each page
 		 */
 		if (sgeid == ioim->nsges) {
@@ -2539,7 +2539,7 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 	} while (sgeid < ioim->nsges);
 }
 
-/**
+/*
  * Send I/O abort request to firmware.
  */
 static	bfa_boolean_t
@@ -2548,14 +2548,14 @@ bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
 	struct bfi_ioim_abort_req_s *m;
 	enum bfi_ioim_h2i	msgop;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(ioim->bfa, ioim->reqq);
 	if (!m)
 		return BFA_FALSE;
 
-	/**
+	/*
 	 * build i/o request message next
 	 */
 	if (ioim->iosp->abort_explicit)
@@ -2567,14 +2567,14 @@ bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
 	m->io_tag    = cpu_to_be16(ioim->iotag);
 	m->abort_tag = ++ioim->abort_tag;
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(ioim->bfa, ioim->reqq);
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Call to resume any I/O requests waiting for room in request queue.
  */
 static void
@@ -2590,7 +2590,7 @@ bfa_ioim_qresume(void *cbarg)
 static void
 bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim)
 {
-	/**
+	/*
 	 * Move IO from itnim queue to fcpim global queue since itnim will be
 	 * freed.
 	 */
@@ -2623,13 +2623,13 @@ bfa_ioim_is_abortable(struct bfa_ioim_s *ioim)
 	return BFA_TRUE;
 }
 
-/**
+/*
  *	or after the link comes back.
  */
 void
 bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 {
-	/**
+	/*
 	 * If path tov timer expired, failback with PATHTOV status - these
 	 * IO requests are not normally retried by IO stack.
 	 *
@@ -2644,7 +2644,7 @@ bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 	}
 	bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
 
-	/**
+	/*
 	 * Move IO to fcpim global queue since itnim will be
 	 * freed.
 	 */
@@ -2654,11 +2654,11 @@ bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 
 
 
-/**
+/*
  *  hal_ioim_friend
  */
 
-/**
+/*
  * Memory allocation and initialization.
  */
 void
@@ -2670,7 +2670,7 @@ bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 	u8			*snsinfo;
 	u32		snsbufsz;
 
-	/**
+	/*
 	 * claim memory first
 	 */
 	ioim = (struct bfa_ioim_s *) bfa_meminfo_kva(minfo);
@@ -2681,7 +2681,7 @@ bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 	fcpim->ioim_sp_arr = iosp;
 	bfa_meminfo_kva(minfo) = (u8 *) (iosp + fcpim->num_ioim_reqs);
 
-	/**
+	/*
 	 * Claim DMA memory for per IO sense data.
 	 */
 	snsbufsz = fcpim->num_ioim_reqs * BFI_IOIM_SNSLEN;
@@ -2693,7 +2693,7 @@ bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 	snsinfo = fcpim->snsbase.kva;
 	bfa_iocfc_set_snsbase(fcpim->bfa, fcpim->snsbase.pa);
 
-	/**
+	/*
 	 * Initialize ioim free queues
 	 */
 	INIT_LIST_HEAD(&fcpim->ioim_free_q);
@@ -2722,7 +2722,7 @@ bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 	}
 }
 
-/**
+/*
  * Driver detach time call.
  */
 void
@@ -2858,7 +2858,7 @@ bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 		io_lat->max[index] : val;
 	io_lat->avg[index] += val;
 }
-/**
+/*
  * Called by itnim to clean up IO while going offline.
  */
 void
@@ -2881,7 +2881,7 @@ bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim, struct bfa_tskim_s *tskim)
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_CLEANUP);
 }
 
-/**
+/*
  * IOC failure handling.
  */
 void
@@ -2892,7 +2892,7 @@ bfa_ioim_iocdisable(struct bfa_ioim_s *ioim)
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_HWFAIL);
 }
 
-/**
+/*
  * IO offline TOV popped. Fail the pending IO.
  */
 void
@@ -2904,11 +2904,11 @@ bfa_ioim_tov(struct bfa_ioim_s *ioim)
 
 
 
-/**
+/*
  *  hal_ioim_api
  */
 
-/**
+/*
  * Allocate IOIM resource for initiator mode I/O request.
  */
 struct bfa_ioim_s *
@@ -2918,7 +2918,7 @@ bfa_ioim_alloc(struct bfa_s *bfa, struct bfad_ioim_s *dio,
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
 	struct bfa_ioim_s *ioim;
 
-	/**
+	/*
 	 * alocate IOIM resource
 	 */
 	bfa_q_deq(&fcpim->ioim_free_q, &ioim);
@@ -2969,7 +2969,7 @@ bfa_ioim_start(struct bfa_ioim_s *ioim)
 
 	bfa_ioim_cb_profile_start(ioim->fcpim, ioim);
 
-	/**
+	/*
 	 * Obtain the queue over which this request has to be issued
 	 */
 	ioim->reqq = bfa_fcpim_ioredirect_enabled(ioim->bfa) ?
@@ -2979,7 +2979,7 @@ bfa_ioim_start(struct bfa_ioim_s *ioim)
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_START);
 }
 
-/**
+/*
  * Driver I/O abort request.
  */
 bfa_status_t
@@ -2998,11 +2998,11 @@ bfa_ioim_abort(struct bfa_ioim_s *ioim)
 }
 
 
-/**
+/*
  *  BFA TSKIM state machine functions
  */
 
-/**
+/*
  *	Task management command beginning state.
  */
 static void
@@ -3015,7 +3015,7 @@ bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		bfa_sm_set_state(tskim, bfa_tskim_sm_active);
 		bfa_tskim_gather_ios(tskim);
 
-		/**
+		/*
 		 * If device is offline, do not send TM on wire. Just cleanup
 		 * any pending IO requests and complete TM request.
 		 */
@@ -3039,7 +3039,7 @@ bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 	}
 }
 
-/**
+/*
  * brief
  *	TM command is active, awaiting completion from firmware to
  *	cleanup IO requests in TM scope.
@@ -3076,7 +3076,7 @@ bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 	}
 }
 
-/**
+/*
  *	An active TM is being cleaned up since ITN is offline. Awaiting cleanup
  *	completion event from firmware.
  */
@@ -3087,7 +3087,7 @@ bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 
 	switch (event) {
 	case BFA_TSKIM_SM_DONE:
-		/**
+		/*
 		 * Ignore and wait for ABORT completion from firmware.
 		 */
 		break;
@@ -3120,7 +3120,7 @@ bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	case BFA_TSKIM_SM_CLEANUP:
-		/**
+		/*
 		 * Ignore, TM command completed on wire.
 		 * Notify TM conmpletion on IO cleanup completion.
 		 */
@@ -3137,7 +3137,7 @@ bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 	}
 }
 
-/**
+/*
  *	Task management command is waiting for room in request CQ
  */
 static void
@@ -3152,7 +3152,7 @@ bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 		break;
 
 	case BFA_TSKIM_SM_CLEANUP:
-		/**
+		/*
 		 * No need to send TM on wire since ITN is offline.
 		 */
 		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
@@ -3172,7 +3172,7 @@ bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 	}
 }
 
-/**
+/*
  *	Task management command is active, awaiting for room in request CQ
  *	to send clean up request.
  */
@@ -3185,7 +3185,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 	switch (event) {
 	case BFA_TSKIM_SM_DONE:
 		bfa_reqq_wcancel(&tskim->reqq_wait);
-		/**
+		/*
 		 *
 		 * Fall through !!!
 		 */
@@ -3207,7 +3207,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 	}
 }
 
-/**
+/*
  *	BFA callback is pending
  */
 static void
@@ -3235,7 +3235,7 @@ bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 
 
 
-/**
+/*
  *  hal_tskim_private
  */
 
@@ -3288,7 +3288,7 @@ bfa_tskim_match_scope(struct bfa_tskim_s *tskim, lun_t lun)
 	return BFA_FALSE;
 }
 
-/**
+/*
  *	Gather affected IO requests and task management commands.
  */
 static void
@@ -3300,7 +3300,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 
 	INIT_LIST_HEAD(&tskim->io_q);
 
-	/**
+	/*
 	 * Gather any active IO requests first.
 	 */
 	list_for_each_safe(qe, qen, &itnim->io_q) {
@@ -3312,7 +3312,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 		}
 	}
 
-	/**
+	/*
 	 * Failback any pending IO requests immediately.
 	 */
 	list_for_each_safe(qe, qen, &itnim->pending_q) {
@@ -3326,7 +3326,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 	}
 }
 
-/**
+/*
  *	IO cleanup completion
  */
 static void
@@ -3338,7 +3338,7 @@ bfa_tskim_cleanp_comp(void *tskim_cbarg)
 	bfa_sm_send_event(tskim, BFA_TSKIM_SM_IOS_DONE);
 }
 
-/**
+/*
  *	Gather affected IO requests and task management commands.
  */
 static void
@@ -3358,7 +3358,7 @@ bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim)
 	bfa_wc_wait(&tskim->wc);
 }
 
-/**
+/*
  *	Send task management request to firmware.
  */
 static bfa_boolean_t
@@ -3367,14 +3367,14 @@ bfa_tskim_send(struct bfa_tskim_s *tskim)
 	struct bfa_itnim_s *itnim = tskim->itnim;
 	struct bfi_tskim_req_s *m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(tskim->bfa, itnim->reqq);
 	if (!m)
 		return BFA_FALSE;
 
-	/**
+	/*
 	 * build i/o request message next
 	 */
 	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_TM_REQ,
@@ -3386,14 +3386,14 @@ bfa_tskim_send(struct bfa_tskim_s *tskim)
 	m->lun = tskim->lun;
 	m->tm_flags = tskim->tm_cmnd;
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(tskim->bfa, itnim->reqq);
 	return BFA_TRUE;
 }
 
-/**
+/*
  *	Send abort request to cleanup an active TM to firmware.
  */
 static bfa_boolean_t
@@ -3402,14 +3402,14 @@ bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
 	struct bfa_itnim_s	*itnim = tskim->itnim;
 	struct bfi_tskim_abortreq_s	*m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(tskim->bfa, itnim->reqq);
 	if (!m)
 		return BFA_FALSE;
 
-	/**
+	/*
 	 * build i/o request message next
 	 */
 	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_ABORT_REQ,
@@ -3417,14 +3417,14 @@ bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
 
 	m->tsk_tag  = cpu_to_be16(tskim->tsk_tag);
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(tskim->bfa, itnim->reqq);
 	return BFA_TRUE;
 }
 
-/**
+/*
  *	Call to resume task management cmnd waiting for room in request queue.
  */
 static void
@@ -3436,7 +3436,7 @@ bfa_tskim_qresume(void *cbarg)
 	bfa_sm_send_event(tskim, BFA_TSKIM_SM_QRESUME);
 }
 
-/**
+/*
  * Cleanup IOs associated with a task mangement command on IOC failures.
  */
 static void
@@ -3453,11 +3453,11 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 
 
 
-/**
+/*
  *  hal_tskim_friend
  */
 
-/**
+/*
  * Notification on completions from related ioim.
  */
 void
@@ -3466,7 +3466,7 @@ bfa_tskim_iodone(struct bfa_tskim_s *tskim)
 	bfa_wc_down(&tskim->wc);
 }
 
-/**
+/*
  * Handle IOC h/w failure notification from itnim.
  */
 void
@@ -3477,7 +3477,7 @@ bfa_tskim_iocdisable(struct bfa_tskim_s *tskim)
 	bfa_sm_send_event(tskim, BFA_TSKIM_SM_HWFAIL);
 }
 
-/**
+/*
  * Cleanup TM command and associated IOs as part of ITNIM offline.
  */
 void
@@ -3488,7 +3488,7 @@ bfa_tskim_cleanup(struct bfa_tskim_s *tskim)
 	bfa_sm_send_event(tskim, BFA_TSKIM_SM_CLEANUP);
 }
 
-/**
+/*
  *	Memory allocation and initialization.
  */
 void
@@ -3524,7 +3524,7 @@ bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
 void
 bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim)
 {
-	/**
+	/*
 	* @todo
 	*/
 }
@@ -3542,7 +3542,7 @@ bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 	tskim->tsk_status = rsp->tsk_status;
 
-	/**
+	/*
 	 * Firmware sends BFI_TSKIM_STS_ABORTED status for abort
 	 * requests. All other statuses are for normal completions.
 	 */
@@ -3557,7 +3557,7 @@ bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 
 
-/**
+/*
  *  hal_tskim_api
  */
 
@@ -3584,7 +3584,7 @@ bfa_tskim_free(struct bfa_tskim_s *tskim)
 	list_add_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
 }
 
-/**
+/*
  *	Start a task management command.
  *
  * @param[in]	tskim	BFA task management command instance
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 88eb91a..c94502d 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  bfa_fcs.c BFA FCS main
  */
 
@@ -25,7 +25,7 @@
 
 BFA_TRC_FILE(FCS, FCS);
 
-/**
+/*
  * FCS sub-modules
  */
 struct bfa_fcs_mod_s {
@@ -43,7 +43,7 @@ static struct bfa_fcs_mod_s fcs_modules[] = {
 	  bfa_fcs_fabric_modexit },
 };
 
-/**
+/*
  *  fcs_api BFA FCS API
  */
 
@@ -58,11 +58,11 @@ bfa_fcs_exit_comp(void *fcs_cbarg)
 
 
 
-/**
+/*
  *  fcs_api BFA FCS API
  */
 
-/**
+/*
  * fcs attach -- called once to initialize data structures at driver attach time
  */
 void
@@ -86,7 +86,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 	}
 }
 
-/**
+/*
  * fcs initialization, called once after bfa initialization is complete
  */
 void
@@ -110,7 +110,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
 	}
 }
 
-/**
+/*
  * Start FCS operations.
  */
 void
@@ -119,7 +119,7 @@ bfa_fcs_start(struct bfa_fcs_s *fcs)
 	bfa_fcs_fabric_modstart(fcs);
 }
 
-/**
+/*
  *	brief
  *		FCS driver details initialization.
  *
@@ -138,7 +138,7 @@ bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 	bfa_fcs_fabric_psymb_init(&fcs->fabric);
 }
 
-/**
+/*
  *	brief
  *		FCS FDMI Driver Parameter Initialization
  *
@@ -154,7 +154,7 @@ bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable)
 	fcs->fdmi_enabled = fdmi_enable;
 
 }
-/**
+/*
  *	brief
  *		FCS instance cleanup and exit.
  *
@@ -196,7 +196,7 @@ bfa_fcs_modexit_comp(struct bfa_fcs_s *fcs)
 	bfa_wc_down(&fcs->wc);
 }
 
-/**
+/*
  * Fabric module implementation.
  */
 
@@ -232,11 +232,11 @@ static void bfa_fcs_fabric_flogiacc_comp(void *fcsarg,
 					 u32 rsp_len,
 					 u32 resid_len,
 					 struct fchs_s *rspfchs);
-/**
+/*
  *  fcs_fabric_sm fabric state machine functions
  */
 
-/**
+/*
  * Fabric state machine events
  */
 enum bfa_fcs_fabric_event {
@@ -286,7 +286,7 @@ static void	bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
 static void	bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
 					   enum bfa_fcs_fabric_event event);
-/**
+/*
  *   Beginning state before fabric creation.
  */
 static void
@@ -312,7 +312,7 @@ bfa_fcs_fabric_sm_uninit(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Beginning state before fabric creation.
  */
 static void
@@ -345,7 +345,7 @@ bfa_fcs_fabric_sm_created(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Link is down, awaiting LINK UP event from port. This is also the
  *   first state at fabric creation.
  */
@@ -375,7 +375,7 @@ bfa_fcs_fabric_sm_linkdown(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   FLOGI is in progress, awaiting FLOGI reply.
  */
 static void
@@ -468,7 +468,7 @@ bfa_fcs_fabric_sm_flogi_retry(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Authentication is in progress, awaiting authentication results.
  */
 static void
@@ -508,7 +508,7 @@ bfa_fcs_fabric_sm_auth(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Authentication failed
  */
 static void
@@ -534,7 +534,7 @@ bfa_fcs_fabric_sm_auth_failed(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Port is in loopback mode.
  */
 static void
@@ -560,7 +560,7 @@ bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   There is no attached fabric - private loop or NPort-to-NPort topology.
  */
 static void
@@ -593,7 +593,7 @@ bfa_fcs_fabric_sm_nofabric(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Fabric is online - normal operating state.
  */
 static void
@@ -628,7 +628,7 @@ bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   Exchanging virtual fabric parameters.
  */
 static void
@@ -652,7 +652,7 @@ bfa_fcs_fabric_sm_evfp(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *   EVFP exchange complete and VFT tagging is enabled.
  */
 static void
@@ -663,7 +663,7 @@ bfa_fcs_fabric_sm_evfp_done(struct bfa_fcs_fabric_s *fabric,
 	bfa_trc(fabric->fcs, event);
 }
 
-/**
+/*
  *   Port is isolated after EVFP exchange due to VF_ID mismatch (N and F).
  */
 static void
@@ -684,7 +684,7 @@ bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
 		fabric->event_arg.swp_vfid);
 }
 
-/**
+/*
  *   Fabric is being deleted, awaiting vport delete completions.
  */
 static void
@@ -714,7 +714,7 @@ bfa_fcs_fabric_sm_deleting(struct bfa_fcs_fabric_s *fabric,
 
 
 
-/**
+/*
  *  fcs_fabric_private fabric private functions
  */
 
@@ -728,7 +728,7 @@ bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric)
 	port_cfg->pwwn = bfa_ioc_get_pwwn(&fabric->fcs->bfa->ioc);
 }
 
-/**
+/*
  * Port Symbolic Name Creation for base port.
  */
 void
@@ -789,7 +789,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
 }
 
-/**
+/*
  * bfa lps login completion callback
  */
 void
@@ -867,7 +867,7 @@ bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status)
 	bfa_trc(fabric->fcs, fabric->is_npiv);
 	bfa_trc(fabric->fcs, fabric->is_auth);
 }
-/**
+/*
  *		Allocate and send FLOGI.
  */
 static void
@@ -897,7 +897,7 @@ bfa_fcs_fabric_notify_online(struct bfa_fcs_fabric_s *fabric)
 	bfa_fcs_fabric_set_opertype(fabric);
 	fabric->stats.fabric_onlines++;
 
-	/**
+	/*
 	 * notify online event to base and then virtual ports
 	 */
 	bfa_fcs_lport_online(&fabric->bport);
@@ -917,7 +917,7 @@ bfa_fcs_fabric_notify_offline(struct bfa_fcs_fabric_s *fabric)
 	bfa_trc(fabric->fcs, fabric->fabric_name);
 	fabric->stats.fabric_offlines++;
 
-	/**
+	/*
 	 * notify offline event first to vports and then base port.
 	 */
 	list_for_each_safe(qe, qen, &fabric->vport_q) {
@@ -939,7 +939,7 @@ bfa_fcs_fabric_delay(void *cbarg)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELAYED);
 }
 
-/**
+/*
  * Delete all vports and wait for vport delete completions.
  */
 static void
@@ -965,11 +965,11 @@ bfa_fcs_fabric_delete_comp(void *cbarg)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELCOMP);
 }
 
-/**
+/*
  *  fcs_fabric_public fabric public functions
  */
 
-/**
+/*
  * Attach time initialization.
  */
 void
@@ -980,7 +980,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 	fabric = &fcs->fabric;
 	memset(fabric, 0, sizeof(struct bfa_fcs_fabric_s));
 
-	/**
+	/*
 	 * Initialize base fabric.
 	 */
 	fabric->fcs = fcs;
@@ -989,7 +989,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 	fabric->lps = bfa_lps_alloc(fcs->bfa);
 	bfa_assert(fabric->lps);
 
-	/**
+	/*
 	 * Initialize fabric delete completion handler. Fabric deletion is
 	 * complete when the last vport delete is complete.
 	 */
@@ -1007,7 +1007,7 @@ bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
 	bfa_trc(fcs, 0);
 }
 
-/**
+/*
  *   Module cleanup
  */
 void
@@ -1017,7 +1017,7 @@ bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs)
 
 	bfa_trc(fcs, 0);
 
-	/**
+	/*
 	 * Cleanup base fabric.
 	 */
 	fabric = &fcs->fabric;
@@ -1025,7 +1025,7 @@ bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELETE);
 }
 
-/**
+/*
  * Fabric module start -- kick starts FCS actions
  */
 void
@@ -1038,7 +1038,7 @@ bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_START);
 }
 
-/**
+/*
  *   Suspend fabric activity as part of driver suspend.
  */
 void
@@ -1064,7 +1064,7 @@ bfa_fcs_fabric_port_type(struct bfa_fcs_fabric_s *fabric)
 	return fabric->oper_type;
 }
 
-/**
+/*
  *   Link up notification from BFA physical port module.
  */
 void
@@ -1074,7 +1074,7 @@ bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_LINK_UP);
 }
 
-/**
+/*
  *   Link down notification from BFA physical port module.
  */
 void
@@ -1084,7 +1084,7 @@ bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric)
 	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_LINK_DOWN);
 }
 
-/**
+/*
  *   A child vport is being created in the fabric.
  *
  *   Call from vport module at vport creation. A list of base port and vports
@@ -1099,7 +1099,7 @@ void
 bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
 			struct bfa_fcs_vport_s *vport)
 {
-	/**
+	/*
 	 * - add vport to fabric's vport_q
 	 */
 	bfa_trc(fabric->fcs, fabric->vf_id);
@@ -1109,7 +1109,7 @@ bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
 	bfa_wc_up(&fabric->wc);
 }
 
-/**
+/*
  *   A child vport is being deleted from fabric.
  *
  *   Vport is being deleted.
@@ -1123,7 +1123,7 @@ bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
 	bfa_wc_down(&fabric->wc);
 }
 
-/**
+/*
  *   Base port is deleted.
  */
 void
@@ -1133,7 +1133,7 @@ bfa_fcs_fabric_port_delete_comp(struct bfa_fcs_fabric_s *fabric)
 }
 
 
-/**
+/*
  *    Check if fabric is online.
  *
  *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
@@ -1146,7 +1146,7 @@ bfa_fcs_fabric_is_online(struct bfa_fcs_fabric_s *fabric)
 	return bfa_sm_cmp_state(fabric, bfa_fcs_fabric_sm_online);
 }
 
-/**
+/*
  *	brief
  *
  */
@@ -1158,7 +1158,7 @@ bfa_fcs_fabric_addvf(struct bfa_fcs_fabric_s *vf, struct bfa_fcs_s *fcs,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Lookup for a vport withing a fabric given its pwwn
  */
 struct bfa_fcs_vport_s *
@@ -1176,7 +1176,7 @@ bfa_fcs_fabric_vport_lookup(struct bfa_fcs_fabric_s *fabric, wwn_t pwwn)
 	return NULL;
 }
 
-/**
+/*
  *    In a given fabric, return the number of lports.
  *
  *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
@@ -1214,7 +1214,7 @@ bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric)
 
 	return oui;
 }
-/**
+/*
  *		Unsolicited frame receive handling.
  */
 void
@@ -1230,7 +1230,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	bfa_trc(fabric->fcs, len);
 	bfa_trc(fabric->fcs, pid);
 
-	/**
+	/*
 	 * Look for our own FLOGI frames being looped back. This means an
 	 * external loopback cable is in place. Our own FLOGI frames are
 	 * sometimes looped back when switch port gets temporarily bypassed.
@@ -1242,7 +1242,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 		return;
 	}
 
-	/**
+	/*
 	 * FLOGI/EVFP exchanges should be consumed by base fabric.
 	 */
 	if (fchs->d_id == bfa_os_hton3b(FC_FABRIC_PORT)) {
@@ -1252,7 +1252,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	}
 
 	if (fabric->bport.pid == pid) {
-		/**
+		/*
 		 * All authentication frames should be routed to auth
 		 */
 		bfa_trc(fabric->fcs, els_cmd->els_code);
@@ -1266,7 +1266,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 		return;
 	}
 
-	/**
+	/*
 	 * look for a matching local port ID
 	 */
 	list_for_each(qe, &fabric->vport_q) {
@@ -1280,7 +1280,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	bfa_fcs_lport_uf_recv(&fabric->bport, fchs, len);
 }
 
-/**
+/*
  *		Unsolicited frames to be processed by fabric.
  */
 static void
@@ -1304,7 +1304,7 @@ bfa_fcs_fabric_process_uf(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	}
 }
 
-/**
+/*
  *	Process	incoming FLOGI
  */
 static void
@@ -1351,7 +1351,7 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 	struct fchs_s	fchs;
 
 	fcxp = bfa_fcs_fcxp_alloc(fabric->fcs);
-	/**
+	/*
 	 * Do not expect this failure -- expect remote node to retry
 	 */
 	if (!fcxp)
@@ -1370,7 +1370,7 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 		      FC_MAX_PDUSZ, 0);
 }
 
-/**
+/*
  *   Flogi Acc completion callback.
  */
 static void
@@ -1417,7 +1417,7 @@ bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 	}
 }
 
-/**
+/*
  *	Returns FCS vf structure for a given vf_id.
  *
  *	param[in]	vf_id - VF_ID
@@ -1435,7 +1435,7 @@ bfa_fcs_vf_lookup(struct bfa_fcs_s *fcs, u16 vf_id)
 	return NULL;
 }
 
-/**
+/*
  * BFA FCS PPORT ( physical port)
  */
 static void
@@ -1465,11 +1465,11 @@ bfa_fcs_port_attach(struct bfa_fcs_s *fcs)
 	bfa_fcport_event_register(fcs->bfa, bfa_fcs_port_event_handler, fcs);
 }
 
-/**
+/*
  * BFA FCS UF ( Unsolicited Frames)
  */
 
-/**
+/*
  *		BFA callback for unsolicited frame receive handler.
  *
  * @param[in]		cbarg		callback arg for receive handler
@@ -1486,7 +1486,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 	struct fc_vft_s *vft;
 	struct bfa_fcs_fabric_s *fabric;
 
-	/**
+	/*
 	 * check for VFT header
 	 */
 	if (fchs->routing == FC_RTG_EXT_HDR &&
@@ -1498,7 +1498,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 		else
 			fabric = bfa_fcs_vf_lookup(fcs, (u16) vft->vf_id);
 
-		/**
+		/*
 		 * drop frame if vfid is unknown
 		 */
 		if (!fabric) {
@@ -1508,7 +1508,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 			return;
 		}
 
-		/**
+		/*
 		 * skip vft header
 		 */
 		fchs = (struct fchs_s *) (vft + 1);
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index faca5f3..9662bcd 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  fcpim.c - FCP initiator mode i-t nexus state machine
  */
 
@@ -38,7 +38,7 @@ static void	bfa_fcs_itnim_prli_response(void *fcsarg,
 			    bfa_status_t req_status, u32 rsp_len,
 			    u32 resid_len, struct fchs_s *rsp_fchs);
 
-/**
+/*
  *  fcs_itnim_sm FCS itnim state machine events
  */
 
@@ -84,7 +84,7 @@ static struct bfa_sm_table_s itnim_sm_table[] = {
 	{BFA_SM(bfa_fcs_itnim_sm_initiator), BFA_ITNIM_INITIATIOR},
 };
 
-/**
+/*
  *  fcs_itnim_sm FCS itnim state machine
  */
 
@@ -494,11 +494,11 @@ bfa_fcs_itnim_free(struct bfa_fcs_itnim_s *itnim)
 
 
 
-/**
+/*
  *  itnim_public FCS ITNIM public interfaces
  */
 
-/**
+/*
  *	Called by rport when a new rport is created.
  *
  * @param[in] rport	-  remote port.
@@ -554,7 +554,7 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 	return itnim;
 }
 
-/**
+/*
  *	Called by rport to delete  the instance of FCPIM.
  *
  * @param[in] rport	-  remote port.
@@ -566,7 +566,7 @@ bfa_fcs_itnim_delete(struct bfa_fcs_itnim_s *itnim)
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_DELETE);
 }
 
-/**
+/*
  * Notification from rport that PLOGI is complete to initiate FC-4 session.
  */
 void
@@ -586,7 +586,7 @@ bfa_fcs_itnim_rport_online(struct bfa_fcs_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  * Called by rport to handle a remote device offline.
  */
 void
@@ -596,7 +596,7 @@ bfa_fcs_itnim_rport_offline(struct bfa_fcs_itnim_s *itnim)
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_OFFLINE);
 }
 
-/**
+/*
  * Called by rport when remote port is known to be an initiator from
  * PRLI received.
  */
@@ -608,7 +608,7 @@ bfa_fcs_itnim_is_initiator(struct bfa_fcs_itnim_s *itnim)
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_INITIATOR);
 }
 
-/**
+/*
  * Called by rport to check if the itnim is online.
  */
 bfa_status_t
@@ -625,7 +625,7 @@ bfa_fcs_itnim_get_online_state(struct bfa_fcs_itnim_s *itnim)
 	}
 }
 
-/**
+/*
  * BFA completion callback for bfa_itnim_online().
  */
 void
@@ -637,7 +637,7 @@ bfa_cb_itnim_online(void *cbarg)
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_HCB_ONLINE);
 }
 
-/**
+/*
  * BFA completion callback for bfa_itnim_offline().
  */
 void
@@ -649,7 +649,7 @@ bfa_cb_itnim_offline(void *cb_arg)
 	bfa_sm_send_event(itnim, BFA_FCS_ITNIM_SM_HCB_OFFLINE);
 }
 
-/**
+/*
  * Mark the beginning of PATH TOV handling. IO completion callbacks
  * are still pending.
  */
@@ -661,7 +661,7 @@ bfa_cb_itnim_tov_begin(void *cb_arg)
 	bfa_trc(itnim->fcs, itnim->rport->pwwn);
 }
 
-/**
+/*
  * Mark the end of PATH TOV handling. All pending IOs are already cleaned up.
  */
 void
@@ -674,7 +674,7 @@ bfa_cb_itnim_tov(void *cb_arg)
 	itnim_drv->state = ITNIM_STATE_TIMEOUT;
 }
 
-/**
+/*
  *		BFA notification to FCS/driver for second level error recovery.
  *
  * Atleast one I/O request has timedout and target is unresponsive to
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 263a7bf..377cbff 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -15,10 +15,6 @@
  * General Public License for more details.
  */
 
-/**
- *  bfa_fcs_lport.c BFA FCS port
- */
-
 #include "bfa_fcs.h"
 #include "bfa_fcbuild.h"
 #include "bfa_fc.h"
@@ -26,10 +22,6 @@
 
 BFA_TRC_FILE(FCS, PORT);
 
-/**
- * Forward declarations
- */
-
 static void     bfa_fcs_lport_send_ls_rjt(struct bfa_fcs_lport_s *port,
 					 struct fchs_s *rx_fchs, u8 reason_code,
 					 u8 reason_code_expl);
@@ -72,7 +64,7 @@ static struct {
 			bfa_fcs_lport_n2n_offline},
 	};
 
-/**
+/*
  *  fcs_port_sm FCS logical port state machine
  */
 
@@ -240,7 +232,7 @@ bfa_fcs_lport_sm_deleting(
 	}
 }
 
-/**
+/*
  *  fcs_port_pvt
  */
 
@@ -272,7 +264,7 @@ bfa_fcs_lport_send_ls_rjt(struct bfa_fcs_lport_s *port, struct fchs_s *rx_fchs,
 			  FC_MAX_PDUSZ, 0);
 }
 
-/**
+/*
  * Process incoming plogi from a remote port.
  */
 static void
@@ -303,7 +295,7 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 		return;
 	}
 
-	/**
+	/*
 	 * Direct Attach P2P mode : verify address assigned by the r-port.
 	 */
 	if ((!bfa_fcs_fabric_is_switched(port->fabric)) &&
@@ -319,12 +311,12 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 		port->pid  = rx_fchs->d_id;
 	}
 
-	/**
+	/*
 	 * First, check if we know the device by pwwn.
 	 */
 	rport = bfa_fcs_lport_get_rport_by_pwwn(port, plogi->port_name);
 	if (rport) {
-		/**
+		/*
 		 * Direct Attach P2P mode : handle address assigned by r-port.
 		 */
 		if ((!bfa_fcs_fabric_is_switched(port->fabric)) &&
@@ -337,37 +329,37 @@ bfa_fcs_lport_plogi(struct bfa_fcs_lport_s *port,
 		return;
 	}
 
-	/**
+	/*
 	 * Next, lookup rport by PID.
 	 */
 	rport = bfa_fcs_lport_get_rport_by_pid(port, rx_fchs->s_id);
 	if (!rport) {
-		/**
+		/*
 		 * Inbound PLOGI from a new device.
 		 */
 		bfa_fcs_rport_plogi_create(port, rx_fchs, plogi);
 		return;
 	}
 
-	/**
+	/*
 	 * Rport is known only by PID.
 	 */
 	if (rport->pwwn) {
-		/**
+		/*
 		 * This is a different device with the same pid. Old device
 		 * disappeared. Send implicit LOGO to old device.
 		 */
 		bfa_assert(rport->pwwn != plogi->port_name);
 		bfa_fcs_rport_logo_imp(rport);
 
-		/**
+		/*
 		 * Inbound PLOGI from a new device (with old PID).
 		 */
 		bfa_fcs_rport_plogi_create(port, rx_fchs, plogi);
 		return;
 	}
 
-	/**
+	/*
 	 * PLOGI crossing each other.
 	 */
 	bfa_assert(rport->pwwn == WWN_NULL);
@@ -598,10 +590,10 @@ bfa_fcs_lport_deleted(struct bfa_fcs_lport_s *port)
 
 
 
-/**
+/*
  *  fcs_lport_api BFA FCS port API
  */
-/**
+/*
  *   Module initialization
  */
 void
@@ -610,7 +602,7 @@ bfa_fcs_lport_modinit(struct bfa_fcs_s *fcs)
 
 }
 
-/**
+/*
  *   Module cleanup
  */
 void
@@ -619,7 +611,7 @@ bfa_fcs_lport_modexit(struct bfa_fcs_s *fcs)
 	bfa_fcs_modexit_comp(fcs);
 }
 
-/**
+/*
  * Unsolicited frame receive handling.
  */
 void
@@ -637,7 +629,7 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 		return;
 	}
 
-	/**
+	/*
 	 * First, handle ELSs that donot require a login.
 	 */
 	/*
@@ -673,7 +665,7 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 			bfa_fcs_lport_abts_acc(lport, fchs);
 		return;
 	}
-	/**
+	/*
 	 * look for a matching remote port ID
 	 */
 	rport = bfa_fcs_lport_get_rport_by_pid(lport, pid);
@@ -686,7 +678,7 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 		return;
 	}
 
-	/**
+	/*
 	 * Only handles ELS frames for now.
 	 */
 	if (fchs->type != FC_TYPE_ELS) {
@@ -702,20 +694,20 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 	}
 
 	if (els_cmd->els_code == FC_ELS_LOGO) {
-		/**
+		/*
 		 * @todo Handle LOGO frames received.
 		 */
 		return;
 	}
 
 	if (els_cmd->els_code == FC_ELS_PRLI) {
-		/**
+		/*
 		 * @todo Handle PRLI frames received.
 		 */
 		return;
 	}
 
-	/**
+	/*
 	 * Unhandled ELS frames. Send a LS_RJT.
 	 */
 	bfa_fcs_lport_send_ls_rjt(lport, fchs, FC_LS_RJT_RSN_CMD_NOT_SUPP,
@@ -723,7 +715,7 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 
 }
 
-/**
+/*
  *   PID based Lookup for a R-Port in the Port R-Port Queue
  */
 struct bfa_fcs_rport_s *
@@ -742,7 +734,7 @@ bfa_fcs_lport_get_rport_by_pid(struct bfa_fcs_lport_s *port, u32 pid)
 	return NULL;
 }
 
-/**
+/*
  *   PWWN based Lookup for a R-Port in the Port R-Port Queue
  */
 struct bfa_fcs_rport_s *
@@ -761,7 +753,7 @@ bfa_fcs_lport_get_rport_by_pwwn(struct bfa_fcs_lport_s *port, wwn_t pwwn)
 	return NULL;
 }
 
-/**
+/*
  *   NWWN based Lookup for a R-Port in the Port R-Port Queue
  */
 struct bfa_fcs_rport_s *
@@ -780,7 +772,7 @@ bfa_fcs_lport_get_rport_by_nwwn(struct bfa_fcs_lport_s *port, wwn_t nwwn)
 	return NULL;
 }
 
-/**
+/*
  * Called by rport module when new rports are discovered.
  */
 void
@@ -792,7 +784,7 @@ bfa_fcs_lport_add_rport(
 	port->num_rports++;
 }
 
-/**
+/*
  * Called by rport module to when rports are deleted.
  */
 void
@@ -807,7 +799,7 @@ bfa_fcs_lport_del_rport(
 	bfa_sm_send_event(port, BFA_FCS_PORT_SM_DELRPORT);
 }
 
-/**
+/*
  * Called by fabric for base port when fabric login is complete.
  * Called by vport for virtual ports when FDISC is complete.
  */
@@ -817,7 +809,7 @@ bfa_fcs_lport_online(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(port, BFA_FCS_PORT_SM_ONLINE);
 }
 
-/**
+/*
  * Called by fabric for base port when fabric goes offline.
  * Called by vport for virtual ports when virtual port becomes offline.
  */
@@ -827,7 +819,7 @@ bfa_fcs_lport_offline(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(port, BFA_FCS_PORT_SM_OFFLINE);
 }
 
-/**
+/*
  * Called by fabric to delete base lport and associated resources.
  *
  * Called by vport to delete lport and associated resources. Should call
@@ -839,7 +831,7 @@ bfa_fcs_lport_delete(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(port, BFA_FCS_PORT_SM_DELETE);
 }
 
-/**
+/*
  * Return TRUE if port is online, else return FALSE
  */
 bfa_boolean_t
@@ -848,7 +840,7 @@ bfa_fcs_lport_is_online(struct bfa_fcs_lport_s *port)
 	return bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online);
 }
 
-/**
+/*
   * Attach time initialization of logical ports.
  */
 void
@@ -865,7 +857,7 @@ bfa_fcs_lport_attach(struct bfa_fcs_lport_s *lport, struct bfa_fcs_s *fcs,
 	lport->num_rports = 0;
 }
 
-/**
+/*
  * Logical port initialization of base or virtual port.
  * Called by fabric for base port or by vport for virtual ports.
  */
@@ -894,7 +886,7 @@ bfa_fcs_lport_init(struct bfa_fcs_lport_s *lport,
 	bfa_sm_send_event(lport, BFA_FCS_PORT_SM_CREATE);
 }
 
-/**
+/*
  *  fcs_lport_api
  */
 
@@ -934,11 +926,11 @@ bfa_fcs_lport_get_attr(
 	}
 }
 
-/**
+/*
  *  bfa_fcs_lport_fab port fab functions
  */
 
-/**
+/*
  *   Called by port to initialize fabric services of the base port.
  */
 static void
@@ -949,7 +941,7 @@ bfa_fcs_lport_fab_init(struct bfa_fcs_lport_s *port)
 	bfa_fcs_lport_ms_init(port);
 }
 
-/**
+/*
  *   Called by port to notify transition to online state.
  */
 static void
@@ -959,7 +951,7 @@ bfa_fcs_lport_fab_online(struct bfa_fcs_lport_s *port)
 	bfa_fcs_lport_scn_online(port);
 }
 
-/**
+/*
  *   Called by port to notify transition to offline state.
  */
 static void
@@ -970,11 +962,11 @@ bfa_fcs_lport_fab_offline(struct bfa_fcs_lport_s *port)
 	bfa_fcs_lport_ms_offline(port);
 }
 
-/**
+/*
  *  bfa_fcs_lport_n2n  functions
  */
 
-/**
+/*
  *   Called by fcs/port to initialize N2N topology.
  */
 static void
@@ -982,7 +974,7 @@ bfa_fcs_lport_n2n_init(struct bfa_fcs_lport_s *port)
 {
 }
 
-/**
+/*
  *   Called by fcs/port to notify transition to online state.
  */
 static void
@@ -1006,7 +998,7 @@ bfa_fcs_lport_n2n_online(struct bfa_fcs_lport_s *port)
 	    ((void *)&pcfg->pwwn, (void *)&n2n_port->rem_port_wwn,
 	     sizeof(wwn_t)) > 0) {
 		port->pid = N2N_LOCAL_PID;
-		/**
+		/*
 		 * First, check if we know the device by pwwn.
 		 */
 		rport = bfa_fcs_lport_get_rport_by_pwwn(port,
@@ -1035,7 +1027,7 @@ bfa_fcs_lport_n2n_online(struct bfa_fcs_lport_s *port)
 	}
 }
 
-/**
+/*
  *   Called by fcs/port to notify transition to offline state.
  */
 static void
@@ -1094,11 +1086,11 @@ static void	bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 				 struct bfa_fcs_fdmi_hba_attr_s *hba_attr);
 static void	bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 				  struct bfa_fcs_fdmi_port_attr_s *port_attr);
-/**
+/*
  *  fcs_fdmi_sm FCS FDMI state machine
  */
 
-/**
+/*
  *  FDMI State Machine events
  */
 enum port_fdmi_event {
@@ -1143,7 +1135,7 @@ static void     bfa_fcs_lport_fdmi_sm_online(struct bfa_fcs_lport_fdmi_s *fdmi,
 static void     bfa_fcs_lport_fdmi_sm_disabled(
 				struct bfa_fcs_lport_fdmi_s *fdmi,
 				enum port_fdmi_event event);
-/**
+/*
  *	Start in offline state - awaiting MS to send start.
  */
 static void
@@ -1510,7 +1502,7 @@ bfa_fcs_lport_fdmi_sm_online(struct bfa_fcs_lport_fdmi_s *fdmi,
 		bfa_sm_fault(port->fcs, event);
 	}
 }
-/**
+/*
  *  FDMI is disabled state.
  */
 static void
@@ -1525,7 +1517,7 @@ bfa_fcs_lport_fdmi_sm_disabled(struct bfa_fcs_lport_fdmi_s *fdmi,
 	/* No op State. It can only be enabled at Driver Init. */
 }
 
-/**
+/*
 *  RHBA : Register HBA Attributes.
  */
 static void
@@ -1607,8 +1599,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1618,15 +1609,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MANUFACTURER);
 	attr->len = (u16) strlen(fcs_hba_attr->manufacturer);
 	memcpy(attr->value, fcs_hba_attr->manufacturer, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-								 *fields need
-								 *to be 4 byte
-								 *aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1636,15 +1623,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_SERIALNUM);
 	attr->len = (u16) strlen(fcs_hba_attr->serial_num);
 	memcpy(attr->value, fcs_hba_attr->serial_num, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-								 *fields need
-								 *to be 4 byte
-								 *aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1654,15 +1637,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MODEL);
 	attr->len = (u16) strlen(fcs_hba_attr->model);
 	memcpy(attr->value, fcs_hba_attr->model, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-								 *fields need
-								 *to be 4 byte
-								 *aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1672,15 +1651,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MODEL_DESC);
 	attr->len = (u16) strlen(fcs_hba_attr->model_desc);
 	memcpy(attr->value, fcs_hba_attr->model_desc, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-							 *fields need
-							 *to be 4 byte
-							 *aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1691,15 +1666,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_HW_VERSION);
 		attr->len = (u16) strlen(fcs_hba_attr->hw_version);
 		memcpy(attr->value, fcs_hba_attr->hw_version, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-								 *fields need
-								 *to be 4 byte
-								 *aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		count++;
-		attr->len =
-			cpu_to_be16(attr->len + sizeof(attr->type) +
+		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 					 sizeof(attr->len));
 	}
 
@@ -1710,15 +1681,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_DRIVER_VERSION);
 	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-							 *fields need
-							 *to be 4 byte
-							 *aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1729,15 +1696,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_ROM_VERSION);
 		attr->len = (u16) strlen(fcs_hba_attr->option_rom_ver);
 		memcpy(attr->value, fcs_hba_attr->option_rom_ver, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-								 *fields need
-								 *to be 4 byte
-								 *aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		count++;
-		attr->len =
-			cpu_to_be16(attr->len + sizeof(attr->type) +
+		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 					 sizeof(attr->len));
 	}
 
@@ -1748,15 +1711,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_FW_VERSION);
 	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-							 *fields need
-							 *to be 4 byte
-							 *aligned */
+	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1767,15 +1726,11 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_OS_NAME);
 		attr->len = (u16) strlen(fcs_hba_attr->os_name);
 		memcpy(attr->value, fcs_hba_attr->os_name, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-							     *fields need
-							     *to be 4 byte
-							     *aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		count++;
-		attr->len =
-			cpu_to_be16(attr->len + sizeof(attr->type) +
+		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 					sizeof(attr->len));
 	}
 
@@ -1788,15 +1743,13 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	memcpy(attr->value, &fcs_hba_attr->max_ct_pyld, attr->len);
 	len += attr->len;
 	count++;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
 	 * Update size of payload
 	 */
-	len += ((sizeof(attr->type) +
-		 sizeof(attr->len)) * count);
+	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
 
 	rhba->hba_attr_blk.attr_count = cpu_to_be32(count);
 	return len;
@@ -1837,7 +1790,7 @@ bfa_fcs_lport_fdmi_rhba_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
 }
 
-/**
+/*
 *  RPRT : Register Port
  */
 static void
@@ -1879,7 +1832,7 @@ bfa_fcs_lport_fdmi_send_rprt(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RPRT_SENT);
 }
 
-/**
+/*
  * This routine builds Port Attribute Block that used in RPA, RPRT commands.
  */
 static          u16
@@ -1943,8 +1896,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	++count;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1957,8 +1909,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 	len += attr->len;
 	++count;
-	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
+	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
 
 	/*
@@ -1969,15 +1920,11 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 		attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_DEV_NAME);
 		attr->len = (u16) strlen(fcs_port_attr.os_device_name);
 		memcpy(attr->value, fcs_port_attr.os_device_name, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-							     *fields need
-							     *to be 4 byte
-							     *aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		++count;
-		attr->len =
-			cpu_to_be16(attr->len + sizeof(attr->type) +
+		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 					sizeof(attr->len));
 	}
 	/*
@@ -1988,15 +1935,11 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 		attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_HOST_NAME);
 		attr->len = (u16) strlen(fcs_port_attr.host_name);
 		memcpy(attr->value, fcs_port_attr.host_name, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));	/* variable
-							     *fields need
-							     *to be 4 byte
-							     *aligned */
+		attr->len = fc_roundup(attr->len, sizeof(u32));
 		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
 		len += attr->len;
 		++count;
-		attr->len =
-			cpu_to_be16(attr->len + sizeof(attr->type) +
+		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 				sizeof(attr->len));
 	}
 
@@ -2004,8 +1947,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	 * Update size of payload
 	 */
 	port_attrib->attr_count = cpu_to_be32(count);
-	len += ((sizeof(attr->type) +
-		 sizeof(attr->len)) * count);
+	len += ((sizeof(attr->type) + sizeof(attr->len)) * count);
 	return len;
 }
 
@@ -2062,7 +2004,7 @@ bfa_fcs_lport_fdmi_rprt_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_RSP_ERROR);
 }
 
-/**
+/*
 *  RPA : Register Port Attributes.
  */
 static void
@@ -2091,10 +2033,8 @@ bfa_fcs_lport_fdmi_send_rpa(void *fdmi_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	len = fc_fdmi_reqhdr_build(&fchs, pyld, bfa_fcs_lport_get_fcid(port),
 				   FDMI_RPA);
 
-	attr_len =
-		bfa_fcs_lport_fdmi_build_rpa_pyld(fdmi,
-					 (u8 *) ((struct ct_hdr_s *) pyld
-						      + 1));
+	attr_len = bfa_fcs_lport_fdmi_build_rpa_pyld(fdmi,
+				(u8 *) ((struct ct_hdr_s *) pyld + 1));
 
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 			  FC_CLASS_3, len + attr_len, &fchs,
@@ -2321,11 +2261,11 @@ static void     bfa_fcs_lport_ms_gfn_response(void *fcsarg,
 					       u32 rsp_len,
 					       u32 resid_len,
 					       struct fchs_s *rsp_fchs);
-/**
+/*
  *  fcs_ms_sm FCS MS state machine
  */
 
-/**
+/*
  *  MS State Machine events
  */
 enum port_ms_event {
@@ -2360,7 +2300,7 @@ static void     bfa_fcs_lport_ms_sm_gfn_retry(struct bfa_fcs_lport_ms_s *ms,
 					       enum port_ms_event event);
 static void     bfa_fcs_lport_ms_sm_online(struct bfa_fcs_lport_ms_s *ms,
 					  enum port_ms_event event);
-/**
+/*
  *	Start in offline state - awaiting NS to send start.
  */
 static void
@@ -2432,7 +2372,7 @@ bfa_fcs_lport_ms_sm_plogi(struct bfa_fcs_lport_ms_s *ms,
 		 */
 		bfa_fcs_lport_fdmi_online(ms);
 
-		/**
+		/*
 		 * if this is a Vport, go to online state.
 		 */
 		if (ms->port->vport) {
@@ -2595,7 +2535,7 @@ bfa_fcs_lport_ms_sm_gmal_retry(struct bfa_fcs_lport_ms_s *ms,
 		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
-/**
+/*
  *  ms_pvt MS local functions
  */
 
@@ -2795,7 +2735,7 @@ bfa_fcs_lport_ms_sm_gfn_retry(struct bfa_fcs_lport_ms_s *ms,
 		bfa_sm_fault(ms->port->fcs, event);
 	}
 }
-/**
+/*
  *  ms_pvt MS local functions
  */
 
@@ -2871,7 +2811,7 @@ bfa_fcs_lport_ms_gfn_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	bfa_sm_send_event(ms, MSSM_EVENT_RSP_ERROR);
 }
 
-/**
+/*
  *  ms_pvt MS local functions
  */
 
@@ -3017,7 +2957,7 @@ bfa_fcs_lport_ms_fabric_rscn(struct bfa_fcs_lport_s *port)
 		bfa_sm_send_event(ms, MSSM_EVENT_PORT_FABRIC_RSCN);
 }
 
-/**
+/*
  * @page ns_sm_info VPORT NS State Machine
  *
  * @section ns_sm_interactions VPORT NS State Machine Interactions
@@ -3080,11 +3020,11 @@ static void     bfa_fcs_lport_ns_process_gidft_pids(
 				u32 *pid_buf, u32 n_pids);
 
 static void bfa_fcs_lport_ns_boot_target_disc(bfa_fcs_lport_t *port);
-/**
+/*
  *  fcs_ns_sm FCS nameserver interface state machine
  */
 
-/**
+/*
  * VPort NS State Machine events
  */
 enum vport_ns_event {
@@ -3139,7 +3079,7 @@ static void     bfa_fcs_lport_ns_sm_gid_ft_retry(struct bfa_fcs_lport_ns_s *ns,
 						enum vport_ns_event event);
 static void     bfa_fcs_lport_ns_sm_online(struct bfa_fcs_lport_ns_s *ns,
 					  enum vport_ns_event event);
-/**
+/*
  *	Start in offline state - awaiting linkup
  */
 static void
@@ -3628,7 +3568,7 @@ bfa_fcs_lport_ns_sm_online(struct bfa_fcs_lport_ns_s *ns,
 
 
 
-/**
+/*
  *  ns_pvt Nameserver local functions
  */
 
@@ -3724,7 +3664,7 @@ bfa_fcs_lport_ns_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 }
 
-/**
+/*
  * Register the symbolic port name.
  */
 static void
@@ -3755,7 +3695,7 @@ bfa_fcs_lport_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	 * for V-Port, form a Port Symbolic Name
 	 */
 	if (port->vport) {
-		/**
+		/*
 		 * For Vports, we append the vport's port symbolic name
 		 * to that of the base port.
 		 */
@@ -3829,7 +3769,7 @@ bfa_fcs_lport_ns_rspn_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
 }
 
-/**
+/*
  * Register FC4-Types
  */
 static void
@@ -3901,7 +3841,7 @@ bfa_fcs_lport_ns_rft_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
 }
 
-/**
+/*
  * Register FC4-Features : Should be done after RFT_ID
  */
 static void
@@ -3982,7 +3922,7 @@ bfa_fcs_lport_ns_rff_id_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	} else
 		bfa_sm_send_event(ns, NSSM_EVENT_RSP_ERROR);
 }
-/**
+/*
  * Query Fabric for FC4-Types Devices.
  *
 * TBD : Need to use a local (FCS private) response buffer, since the response
@@ -4102,7 +4042,7 @@ bfa_fcs_lport_ns_gid_ft_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 	}
 }
 
-/**
+/*
  *     This routine will be called by bfa_timer on timer timeouts.
  *
  *	param[in]	port - pointer to bfa_fcs_lport_t.
@@ -4166,7 +4106,7 @@ bfa_fcs_lport_ns_process_gidft_pids(struct bfa_fcs_lport_s *port, u32 *pid_buf,
 	}
 }
 
-/**
+/*
  *  fcs_ns_public FCS nameserver public interfaces
  */
 
@@ -4227,7 +4167,7 @@ bfa_fcs_lport_ns_boot_target_disc(bfa_fcs_lport_t *port)
 	}
 }
 
-/**
+/*
  * FCS SCN
  */
 
@@ -4250,11 +4190,11 @@ static void     bfa_fcs_lport_scn_send_ls_acc(struct bfa_fcs_lport_s *port,
 					     struct fchs_s *rx_fchs);
 static void     bfa_fcs_lport_scn_timeout(void *arg);
 
-/**
+/*
  *  fcs_scm_sm FCS SCN state machine
  */
 
-/**
+/*
  * VPort SCN State Machine events
  */
 enum port_scn_event {
@@ -4278,7 +4218,7 @@ static void     bfa_fcs_lport_scn_sm_scr_retry(struct bfa_fcs_lport_scn_s *scn,
 static void     bfa_fcs_lport_scn_sm_online(struct bfa_fcs_lport_scn_s *scn,
 					   enum port_scn_event event);
 
-/**
+/*
  *	Starting state - awaiting link up.
  */
 static void
@@ -4382,11 +4322,11 @@ bfa_fcs_lport_scn_sm_online(struct bfa_fcs_lport_scn_s *scn,
 
 
 
-/**
+/*
  *  fcs_scn_private FCS SCN private functions
  */
 
-/**
+/*
  * This routine will be called to send a SCR command.
  */
 static void
@@ -4499,7 +4439,7 @@ bfa_fcs_lport_scn_send_ls_acc(struct bfa_fcs_lport_s *port,
 			  FC_MAX_PDUSZ, 0);
 }
 
-/**
+/*
  *     This routine will be called by bfa_timer on timer timeouts.
  *
  *	param[in]	vport		- pointer to bfa_fcs_lport_t.
@@ -4522,7 +4462,7 @@ bfa_fcs_lport_scn_timeout(void *arg)
 
 
 
-/**
+/*
  *  fcs_scn_public FCS state change notification public interfaces
  */
 
@@ -4563,7 +4503,7 @@ bfa_fcs_lport_scn_portid_rscn(struct bfa_fcs_lport_s *port, u32 rpid)
 
 	bfa_trc(port->fcs, rpid);
 
-	/**
+	/*
 	 * If this is an unknown device, then it just came online.
 	 * Otherwise let rport handle the RSCN event.
 	 */
@@ -4579,7 +4519,7 @@ bfa_fcs_lport_scn_portid_rscn(struct bfa_fcs_lport_s *port, u32 rpid)
 		bfa_fcs_rport_scn(rport);
 }
 
-/**
+/*
  * rscn format based PID comparison
  */
 #define __fc_pid_match(__c0, __c1, __fmt)		\
@@ -4691,18 +4631,18 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 		}
 	}
 
-	/**
-	 * If any of area, domain or fabric RSCN is received, do a fresh discovery
-	 * to find new devices.
+	/*
+	 * If any of area, domain or fabric RSCN is received, do a fresh
+	 * discovery to find new devices.
 	 */
 	if (nsquery)
 		bfa_fcs_lport_ns_query(port);
 }
 
-/**
+/*
  * BFA FCS port
  */
-/**
+/*
  *  fcs_port_api BFA FCS port API
  */
 struct bfa_fcs_lport_s *
@@ -4946,7 +4886,7 @@ bfa_fcs_lport_clear_stats(struct bfa_fcs_lport_s *fcs_port)
 	memset(&fcs_port->stats, 0, sizeof(struct bfa_lport_stats_s));
 }
 
-/**
+/*
  * FCS virtual port state machine
  */
 
@@ -4967,11 +4907,11 @@ static void     bfa_fcs_vport_timeout(void *vport_arg);
 static void     bfa_fcs_vport_do_logo(struct bfa_fcs_vport_s *vport);
 static void     bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport);
 
-/**
+/*
  *  fcs_vport_sm FCS virtual port state machine
  */
 
-/**
+/*
  * VPort State Machine events
  */
 enum bfa_fcs_vport_event {
@@ -5024,7 +4964,7 @@ static struct bfa_sm_table_s  vport_sm_table[] = {
 	{BFA_SM(bfa_fcs_vport_sm_error), BFA_FCS_VPORT_ERROR}
 };
 
-/**
+/*
  * Beginning state.
  */
 static void
@@ -5045,7 +4985,7 @@ bfa_fcs_vport_sm_uninit(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * Created state - a start event is required to start up the state machine.
  */
 static void
@@ -5062,7 +5002,7 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
 			bfa_sm_set_state(vport, bfa_fcs_vport_sm_fdisc);
 			bfa_fcs_vport_do_fdisc(vport);
 		} else {
-			/**
+			/*
 			 * Fabric is offline or not NPIV capable, stay in
 			 * offline state.
 			 */
@@ -5078,7 +5018,7 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
 
 	case BFA_FCS_VPORT_SM_ONLINE:
 	case BFA_FCS_VPORT_SM_OFFLINE:
-		/**
+		/*
 		 * Ignore ONLINE/OFFLINE events from fabric
 		 * till vport is started.
 		 */
@@ -5089,7 +5029,7 @@ bfa_fcs_vport_sm_created(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * Offline state - awaiting ONLINE event from fabric SM.
  */
 static void
@@ -5127,7 +5067,7 @@ bfa_fcs_vport_sm_offline(struct bfa_fcs_vport_s *vport,
 }
 
 
-/**
+/*
  * FDISC is sent and awaiting reply from fabric.
  */
 static void
@@ -5174,7 +5114,7 @@ bfa_fcs_vport_sm_fdisc(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * FDISC attempt failed - a timer is active to retry FDISC.
  */
 static void
@@ -5208,7 +5148,7 @@ bfa_fcs_vport_sm_fdisc_retry(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * Vport is online (FDISC is complete).
  */
 static void
@@ -5235,7 +5175,7 @@ bfa_fcs_vport_sm_online(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * Vport is being deleted - awaiting lport delete completion to send
  * LOGO to fabric.
  */
@@ -5264,7 +5204,7 @@ bfa_fcs_vport_sm_deleting(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * Error State.
  * This state will be set when the Vport Creation fails due
  * to errors like Dup WWN. In this state only operation allowed
@@ -5288,7 +5228,7 @@ bfa_fcs_vport_sm_error(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * Lport cleanup is in progress since vport is being deleted. Fabric is
  * offline, so no LOGO is needed to complete vport deletion.
  */
@@ -5313,7 +5253,7 @@ bfa_fcs_vport_sm_cleanup(struct bfa_fcs_vport_s *vport,
 	}
 }
 
-/**
+/*
  * LOGO is sent to fabric. Vport delete is in progress. Lport delete cleanup
  * is done.
  */
@@ -5347,10 +5287,10 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
 
 
 
-/**
+/*
  *  fcs_vport_private FCS virtual port private functions
  */
-/**
+/*
  * This routine will be called to send a FDISC command.
  */
 static void
@@ -5397,7 +5337,7 @@ bfa_fcs_vport_fdisc_rejected(struct bfa_fcs_vport_s *vport)
 	}
 }
 
-/**
+/*
  *	Called to send a logout to the fabric. Used when a V-Port is
  *	deleted/stopped.
  */
@@ -5411,7 +5351,7 @@ bfa_fcs_vport_do_logo(struct bfa_fcs_vport_s *vport)
 }
 
 
-/**
+/*
  *     This routine will be called by bfa_timer on timer timeouts.
  *
  *	param[in]	vport		- pointer to bfa_fcs_vport_t.
@@ -5449,11 +5389,11 @@ bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport)
 
 
 
-/**
+/*
  *  fcs_vport_public FCS virtual port public interfaces
  */
 
-/**
+/*
  * Online notification from fabric SM.
  */
 void
@@ -5463,7 +5403,7 @@ bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_ONLINE);
 }
 
-/**
+/*
  * Offline notification from fabric SM.
  */
 void
@@ -5473,7 +5413,7 @@ bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_OFFLINE);
 }
 
-/**
+/*
  * Cleanup notification from fabric SM on link timer expiry.
  */
 void
@@ -5481,7 +5421,7 @@ bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport)
 {
 	vport->vport_stats.fab_cleanup++;
 }
-/**
+/*
  * delete notification from fabric SM. To be invoked from within FCS.
  */
 void
@@ -5490,7 +5430,7 @@ bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELETE);
 }
 
-/**
+/*
  * Delete completion callback from associated lport
  */
 void
@@ -5501,11 +5441,11 @@ bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport)
 
 
 
-/**
+/*
  *  fcs_vport_api Virtual port API
  */
 
-/**
+/*
  *	Use this function to instantiate a new FCS vport object. This
  *	function will not trigger any HW initialization process (which will be
  *	done in vport_start() call)
@@ -5555,7 +5495,7 @@ bfa_fcs_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  *	Use this function to instantiate a new FCS PBC vport object. This
  *	function will not trigger any HW initialization process (which will be
  *	done in vport_start() call)
@@ -5585,7 +5525,7 @@ bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 	return rc;
 }
 
-/**
+/*
  *	Use this function to findout if this is a pbc vport or not.
  *
  * @param[in] vport - pointer to bfa_fcs_vport_t.
@@ -5603,7 +5543,7 @@ bfa_fcs_is_pbc_vport(struct bfa_fcs_vport_s *vport)
 
 }
 
-/**
+/*
  * Use this function initialize the vport.
  *
  * @param[in] vport - pointer to bfa_fcs_vport_t.
@@ -5618,7 +5558,7 @@ bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  *	Use this function quiese the vport object. This function will return
  *	immediately, when the vport is actually stopped, the
  *	bfa_drv_vport_stop_cb() will be called.
@@ -5635,7 +5575,7 @@ bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  *	Use this function to delete a vport object. Fabric object should
  *	be stopped before this function call.
  *
@@ -5657,7 +5597,7 @@ bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  *	Use this function to get vport's current status info.
  *
  *	param[in] vport		pointer to bfa_fcs_vport_t.
@@ -5678,7 +5618,7 @@ bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
 	attr->vport_state = bfa_sm_to_state(vport_sm_table, vport->sm);
 }
 
-/**
+/*
  *	Use this function to get vport's statistics.
  *
  *	param[in]	vport	pointer to bfa_fcs_vport_t.
@@ -5693,7 +5633,7 @@ bfa_fcs_vport_get_stats(struct bfa_fcs_vport_s *vport,
 	*stats = vport->vport_stats;
 }
 
-/**
+/*
  *	Use this function to clear vport's statistics.
  *
  *	param[in]	vport	pointer to bfa_fcs_vport_t.
@@ -5706,7 +5646,7 @@ bfa_fcs_vport_clr_stats(struct bfa_fcs_vport_s *vport)
 	memset(&vport->vport_stats, 0, sizeof(struct bfa_vport_stats_s));
 }
 
-/**
+/*
  *	Lookup a virtual port. Excludes base port from lookup.
  */
 struct bfa_fcs_vport_s *
@@ -5728,7 +5668,7 @@ bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t vpwwn)
 	return vport;
 }
 
-/**
+/*
  * FDISC Response
  */
 void
@@ -5784,7 +5724,7 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 	}
 }
 
-/**
+/*
  * LOGO response
  */
 void
@@ -5794,7 +5734,7 @@ bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_RSP_OK);
 }
 
-/**
+/*
  * Received clear virtual link
  */
 void
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 12b50bd..47f35c0 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  rport.c Remote port implementation.
  */
 
@@ -75,7 +75,7 @@ static void	bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport,
 static void	bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 				struct fchs_s *rx_fchs, u16 len);
 static void bfa_fcs_rport_send_prlo_acc(struct bfa_fcs_rport_s *rport);
-/**
+/*
  *  fcs_rport_sm FCS rport state machine events
  */
 
@@ -172,7 +172,7 @@ static struct bfa_sm_table_s rport_sm_table[] = {
 	{BFA_SM(bfa_fcs_rport_sm_nsdisc_sent), BFA_RPORT_NSDISC},
 };
 
-/**
+/*
  *		Beginning state.
  */
 static void
@@ -210,7 +210,7 @@ bfa_fcs_rport_sm_uninit(struct bfa_fcs_rport_s *rport, enum rport_event event)
 	}
 }
 
-/**
+/*
  *		PLOGI is being sent.
  */
 static void
@@ -262,7 +262,7 @@ bfa_fcs_rport_sm_plogi_sending(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		PLOGI is being sent.
  */
 static void
@@ -287,7 +287,7 @@ bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_PLOGI_RCVD:
 	case RPSM_EVENT_SCN:
-		/**
+		/*
 		 * Ignore, SCN is possibly online notification.
 		 */
 		break;
@@ -309,7 +309,7 @@ bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_HCB_OFFLINE:
-		/**
+		/*
 		 * Ignore BFA callback, on a PLOGI receive we call bfa offline.
 		 */
 		break;
@@ -319,7 +319,7 @@ bfa_fcs_rport_sm_plogiacc_sending(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		PLOGI is sent.
  */
 static void
@@ -380,7 +380,7 @@ bfa_fcs_rport_sm_plogi_retry(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		PLOGI is sent.
  */
 static void
@@ -475,7 +475,7 @@ bfa_fcs_rport_sm_plogi(struct bfa_fcs_rport_s *rport, enum rport_event event)
 	}
 }
 
-/**
+/*
  *		PLOGI is complete. Awaiting BFA rport online callback. FC-4s
  *		are offline.
  */
@@ -519,7 +519,7 @@ bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_SCN:
-		/**
+		/*
 		 * @todo
 		 * Ignore SCN - PLOGI just completed, FC-4 login should detect
 		 * device failures.
@@ -531,7 +531,7 @@ bfa_fcs_rport_sm_hal_online(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport is ONLINE. FC-4s active.
  */
 static void
@@ -580,7 +580,7 @@ bfa_fcs_rport_sm_online(struct bfa_fcs_rport_s *rport, enum rport_event event)
 	}
 }
 
-/**
+/*
  *		An SCN event is received in ONLINE state. NS query is being sent
  *		prior to ADISC authentication with rport. FC-4s are paused.
  */
@@ -604,7 +604,7 @@ bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
 		break;
 
 	case RPSM_EVENT_SCN:
-		/**
+		/*
 		 * ignore SCN, wait for response to query itself
 		 */
 		break;
@@ -638,7 +638,7 @@ bfa_fcs_rport_sm_nsquery_sending(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *	An SCN event is received in ONLINE state. NS query is sent to rport.
  *	FC-4s are paused.
  */
@@ -697,7 +697,7 @@ bfa_fcs_rport_sm_nsquery(struct bfa_fcs_rport_s *rport, enum rport_event event)
 	}
 }
 
-/**
+/*
  *	An SCN event is received in ONLINE state. ADISC is being sent for
  *	authenticating with rport. FC-4s are paused.
  */
@@ -748,7 +748,7 @@ bfa_fcs_rport_sm_adisc_sending(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		An SCN event is received in ONLINE state. ADISC is to rport.
  *		FC-4s are paused.
  */
@@ -765,7 +765,7 @@ bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_PLOGI_RCVD:
-		/**
+		/*
 		 * Too complex to cleanup FC-4 & rport and then acc to PLOGI.
 		 * At least go offline when a PLOGI is received.
 		 */
@@ -787,7 +787,7 @@ bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
 		break;
 
 	case RPSM_EVENT_SCN:
-		/**
+		/*
 		 * already processing RSCN
 		 */
 		break;
@@ -810,7 +810,7 @@ bfa_fcs_rport_sm_adisc(struct bfa_fcs_rport_s *rport, enum rport_event event)
 	}
 }
 
-/**
+/*
  *		Rport has sent LOGO. Awaiting FC-4 offline completion callback.
  */
 static void
@@ -841,7 +841,7 @@ bfa_fcs_rport_sm_fc4_logorcv(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		LOGO needs to be sent to rport. Awaiting FC-4 offline completion
  *		callback.
  */
@@ -864,7 +864,7 @@ bfa_fcs_rport_sm_fc4_logosend(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *	Rport is going offline. Awaiting FC-4 offline completion callback.
  */
 static void
@@ -886,7 +886,7 @@ bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 	case RPSM_EVENT_LOGO_RCVD:
 	case RPSM_EVENT_PRLO_RCVD:
 	case RPSM_EVENT_ADDRESS_CHANGE:
-		/**
+		/*
 		 * rport is already going offline.
 		 * SCN - ignore and wait till transitioning to offline state
 		 */
@@ -901,7 +901,7 @@ bfa_fcs_rport_sm_fc4_offline(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
  *		callback.
  */
@@ -945,7 +945,7 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 	case RPSM_EVENT_SCN:
 	case RPSM_EVENT_LOGO_RCVD:
 	case RPSM_EVENT_PRLO_RCVD:
-		/**
+		/*
 		 * Ignore, already offline.
 		 */
 		break;
@@ -955,7 +955,7 @@ bfa_fcs_rport_sm_hcb_offline(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport is offline. FC-4s are offline. Awaiting BFA rport offline
  *		callback to send LOGO accept.
  */
@@ -1009,7 +1009,7 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 
 	case RPSM_EVENT_LOGO_RCVD:
 	case RPSM_EVENT_PRLO_RCVD:
-		/**
+		/*
 		 * Ignore - already processing a LOGO.
 		 */
 		break;
@@ -1019,7 +1019,7 @@ bfa_fcs_rport_sm_hcb_logorcv(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport is being deleted. FC-4s are offline.
  *  Awaiting BFA rport offline
  *		callback to send LOGO.
@@ -1048,7 +1048,7 @@ bfa_fcs_rport_sm_hcb_logosend(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport is being deleted. FC-4s are offline. LOGO is being sent.
  */
 static void
@@ -1082,7 +1082,7 @@ bfa_fcs_rport_sm_logo_sending(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport is offline. FC-4s are offline. BFA rport is offline.
  *		Timer active to delete stale rport.
  */
@@ -1142,7 +1142,7 @@ bfa_fcs_rport_sm_offline(struct bfa_fcs_rport_s *rport, enum rport_event event)
 	}
 }
 
-/**
+/*
  *	Rport address has changed. Nameserver discovery request is being sent.
  */
 static void
@@ -1199,7 +1199,7 @@ bfa_fcs_rport_sm_nsdisc_sending(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Nameserver discovery failed. Waiting for timeout to retry.
  */
 static void
@@ -1263,7 +1263,7 @@ bfa_fcs_rport_sm_nsdisc_retry(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *		Rport address has changed. Nameserver discovery request is sent.
  */
 static void
@@ -1329,13 +1329,13 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 		bfa_fcs_rport_send_prlo_acc(rport);
 		break;
 	case RPSM_EVENT_SCN:
-		/**
+		/*
 		 * ignore, wait for NS query response
 		 */
 		break;
 
 	case RPSM_EVENT_LOGO_RCVD:
-		/**
+		/*
 		 * Not logged-in yet. Accept LOGO.
 		 */
 		bfa_fcs_rport_send_logo_acc(rport);
@@ -1354,7 +1354,7 @@ bfa_fcs_rport_sm_nsdisc_sent(struct bfa_fcs_rport_s *rport,
 
 
 
-/**
+/*
  *  fcs_rport_private FCS RPORT provate functions
  */
 
@@ -1415,7 +1415,7 @@ bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 
 	plogi_rsp = (struct fc_logi_s *) BFA_FCXP_RSP_PLD(fcxp);
 
-	/**
+	/*
 	 * Check for failure first.
 	 */
 	if (plogi_rsp->els_cmd.els_code != FC_ELS_ACC) {
@@ -1436,7 +1436,7 @@ bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 		return;
 	}
 
-	/**
+	/*
 	 * PLOGI is complete. Make sure this device is not one of the known
 	 * device with a new FC port address.
 	 */
@@ -1468,7 +1468,7 @@ bfa_fcs_rport_plogi_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 		}
 	}
 
-	/**
+	/*
 	 * Normal login path -- no evil twins.
 	 */
 	rport->stats.plogi_accs++;
@@ -1722,7 +1722,7 @@ bfa_fcs_rport_gpnid_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 	}
 }
 
-/**
+/*
  *	Called to send a logout to the rport.
  */
 static void
@@ -1759,7 +1759,7 @@ bfa_fcs_rport_send_logo(void *rport_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	bfa_sm_send_event(rport, RPSM_EVENT_FCXP_SENT);
 }
 
-/**
+/*
  *	Send ACC for a LOGO received.
  */
 static void
@@ -1788,7 +1788,7 @@ bfa_fcs_rport_send_logo_acc(void *rport_cbarg)
 			FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
 }
 
-/**
+/*
  *	brief
  *	This routine will be called by bfa_timer on timer timeouts.
  *
@@ -1961,7 +1961,7 @@ bfa_fcs_rport_alloc(struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 rpid)
 	struct bfa_fcs_rport_s *rport;
 	struct bfad_rport_s	*rport_drv;
 
-	/**
+	/*
 	 * allocate rport
 	 */
 	if (bfa_fcb_rport_alloc(fcs->bfad, &rport, &rport_drv)
@@ -1979,7 +1979,7 @@ bfa_fcs_rport_alloc(struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 rpid)
 	rport->pid = rpid;
 	rport->pwwn = pwwn;
 
-	/**
+	/*
 	 * allocate BFA rport
 	 */
 	rport->bfa_rport = bfa_rport_create(port->fcs->bfa, rport);
@@ -1989,7 +1989,7 @@ bfa_fcs_rport_alloc(struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 rpid)
 		return NULL;
 	}
 
-	/**
+	/*
 	 * allocate FC-4s
 	 */
 	bfa_assert(bfa_fcs_lport_is_initiator(port));
@@ -2021,7 +2021,7 @@ bfa_fcs_rport_free(struct bfa_fcs_rport_s *rport)
 {
 	struct bfa_fcs_lport_s *port = rport->port;
 
-	/**
+	/*
 	 * - delete FC-4s
 	 * - delete BFA rport
 	 * - remove from queue of rports
@@ -2093,7 +2093,7 @@ bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport)
 	}
 }
 
-/**
+/*
  * Update rport parameters from PLOGI or PLOGI accept.
  */
 static void
@@ -2101,14 +2101,14 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 {
 	bfa_fcs_lport_t *port = rport->port;
 
-	/**
+	/*
 	 * - port name
 	 * - node name
 	 */
 	rport->pwwn = plogi->port_name;
 	rport->nwwn = plogi->node_name;
 
-	/**
+	/*
 	 * - class of service
 	 */
 	rport->fc_cos = 0;
@@ -2118,7 +2118,7 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	if (plogi->class2.class_valid)
 		rport->fc_cos |= FC_CLASS_2;
 
-	/**
+	/*
 	 * - CISC
 	 * - MAX receive frame size
 	 */
@@ -2127,7 +2127,7 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 
 	bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
 	bfa_trc(port->fcs, port->fabric->bb_credit);
-	/**
+	/*
 	 * Direct Attach P2P mode :
 	 * This is to handle a bug (233476) in IBM targets in Direct Attach
 	 *  Mode. Basically, in FLOGI Accept the target would have
@@ -2148,7 +2148,7 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 
 }
 
-/**
+/*
  *	Called to handle LOGO received from an existing remote port.
  */
 static void
@@ -2164,11 +2164,11 @@ bfa_fcs_rport_process_logo(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs)
 
 
 
-/**
+/*
  *  fcs_rport_public FCS rport public interfaces
  */
 
-/**
+/*
  *	Called by bport/vport to create a remote port instance for a discovered
  *	remote device.
  *
@@ -2191,7 +2191,7 @@ bfa_fcs_rport_create(struct bfa_fcs_lport_s *port, u32 rpid)
 	return rport;
 }
 
-/**
+/*
  * Called to create a rport for which only the wwn is known.
  *
  * @param[in] port	- base port
@@ -2211,7 +2211,7 @@ bfa_fcs_rport_create_by_wwn(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	bfa_sm_send_event(rport, RPSM_EVENT_ADDRESS_DISC);
 	return rport;
 }
-/**
+/*
  * Called by bport in private loop topology to indicate that a
  * rport has been discovered and plogi has been completed.
  *
@@ -2233,7 +2233,7 @@ bfa_fcs_rport_start(struct bfa_fcs_lport_s *port, struct fchs_s *fchs,
 	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_COMP);
 }
 
-/**
+/*
  *	Called by bport/vport to handle PLOGI received from a new remote port.
  *	If an existing rport does a plogi, it will be handled separately.
  */
@@ -2272,7 +2272,7 @@ wwn_compare(wwn_t wwn1, wwn_t wwn2)
 	return 0;
 }
 
-/**
+/*
  *	Called by bport/vport to handle PLOGI received from an existing
  *	 remote port.
  */
@@ -2280,7 +2280,7 @@ void
 bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 			struct fc_logi_s *plogi)
 {
-	/**
+	/*
 	 * @todo Handle P2P and initiator-initiator.
 	 */
 
@@ -2289,7 +2289,7 @@ bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 	rport->reply_oxid = rx_fchs->ox_id;
 	bfa_trc(rport->fcs, rport->reply_oxid);
 
-	/**
+	/*
 	 * In Switched fabric topology,
 	 * PLOGI to each other. If our pwwn is smaller, ignore it,
 	 * if it is not a well known address.
@@ -2307,7 +2307,7 @@ bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_RCVD);
 }
 
-/**
+/*
  * Called by bport/vport to delete a remote port instance.
  *
  * Rport delete is called under the following conditions:
@@ -2321,7 +2321,7 @@ bfa_fcs_rport_delete(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_DELETE);
 }
 
-/**
+/*
  * Called by bport/vport to  when a target goes offline.
  *
  */
@@ -2331,7 +2331,7 @@ bfa_fcs_rport_offline(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
 }
 
-/**
+/*
  * Called by bport in n2n when a target (attached port) becomes online.
  *
  */
@@ -2340,7 +2340,7 @@ bfa_fcs_rport_online(struct bfa_fcs_rport_s *rport)
 {
 	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_SEND);
 }
-/**
+/*
  *	Called by bport/vport to notify SCN for the remote port
  */
 void
@@ -2350,7 +2350,7 @@ bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_SCN);
 }
 
-/**
+/*
  *	Called by	fcpim to notify that the ITN cleanup is done.
  */
 void
@@ -2359,7 +2359,7 @@ bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
 }
 
-/**
+/*
  *	Called by fcptm to notify that the ITN cleanup is done.
  */
 void
@@ -2368,7 +2368,7 @@ bfa_fcs_rport_tin_ack(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_FC4_OFFLINE);
 }
 
-/**
+/*
  *	brief
  *	This routine BFA callback for bfa_rport_online() call.
  *
@@ -2391,7 +2391,7 @@ bfa_cb_rport_online(void *cbarg)
 	bfa_sm_send_event(rport, RPSM_EVENT_HCB_ONLINE);
 }
 
-/**
+/*
  *	brief
  *	This routine BFA callback for bfa_rport_offline() call.
  *
@@ -2413,7 +2413,7 @@ bfa_cb_rport_offline(void *cbarg)
 	bfa_sm_send_event(rport, RPSM_EVENT_HCB_OFFLINE);
 }
 
-/**
+/*
  *	brief
  *	This routine is a static BFA callback when there is a QoS flow_id
  *	change notification
@@ -2437,7 +2437,7 @@ bfa_cb_rport_qos_scn_flowid(void *cbarg,
 	bfa_trc(rport->fcs, rport->pwwn);
 }
 
-/**
+/*
  *	brief
  *	This routine is a static BFA callback when there is a QoS priority
  *	change notification
@@ -2461,7 +2461,7 @@ bfa_cb_rport_qos_scn_prio(void *cbarg,
 	bfa_trc(rport->fcs, rport->pwwn);
 }
 
-/**
+/*
  *		Called to process any unsolicted frames from this remote port
  */
 void
@@ -2470,7 +2470,7 @@ bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport)
 	bfa_sm_send_event(rport, RPSM_EVENT_LOGO_IMP);
 }
 
-/**
+/*
  *		Called to process any unsolicted frames from this remote port
  */
 void
@@ -2577,7 +2577,7 @@ bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 			FC_MAX_PDUSZ, 0);
 }
 
-/**
+/*
  * Return state of rport.
  */
 int
@@ -2586,7 +2586,7 @@ bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport)
 	return bfa_sm_to_state(rport_sm_table, rport->sm);
 }
 
-/**
+/*
  *	brief
  *		 Called by the Driver to set rport delete/ageout timeout
  *
@@ -2613,15 +2613,15 @@ bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, u16 ox_id)
 
 
 
-/**
+/*
  * Remote port implementation.
  */
 
-/**
+/*
  *  fcs_rport_api FCS rport API.
  */
 
-/**
+/*
  *	Direct API to add a target by port wwn. This interface is used, for
  *	example, by bios when target pwwn is known from boot lun configuration.
  */
@@ -2634,7 +2634,7 @@ bfa_fcs_rport_add(struct bfa_fcs_lport_s *port, wwn_t *pwwn,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  *	Direct API to remove a target and its associated resources. This
  *	interface is used, for example, by driver to remove target
  *	ports from the target list for a VM.
@@ -2663,7 +2663,7 @@ bfa_fcs_rport_remove(struct bfa_fcs_rport_s *rport_in)
 
 }
 
-/**
+/*
  *	Remote device status for display/debug.
  */
 void
@@ -2704,7 +2704,7 @@ bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 	}
 }
 
-/**
+/*
  *	Per remote device statistics.
  */
 void
@@ -2767,7 +2767,7 @@ bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport, bfa_port_speed_t speed)
 
 
 
-/**
+/*
  * Remote port features (RPF) implementation.
  */
 
@@ -2786,7 +2786,7 @@ static void     bfa_fcs_rpf_rpsc2_response(void *fcsarg,
 
 static void     bfa_fcs_rpf_timeout(void *arg);
 
-/**
+/*
  *  fcs_rport_ftrs_sm FCS rport state machine events
  */
 
@@ -2981,7 +2981,7 @@ bfa_fcs_rpf_sm_offline(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 		bfa_sm_fault(rport->fcs, event);
 	}
 }
-/**
+/*
  * Called when Rport is created.
  */
 void
@@ -2995,7 +2995,7 @@ bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport)
 	bfa_sm_set_state(rpf, bfa_fcs_rpf_sm_uninit);
 }
 
-/**
+/*
  * Called when Rport becomes online
  */
 void
@@ -3010,7 +3010,7 @@ bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport)
 		bfa_sm_send_event(&rport->rpf, RPFSM_EVENT_RPORT_ONLINE);
 }
 
-/**
+/*
  * Called when Rport becomes offline
  */
 void
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index 422e44c..d8464ae 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -102,7 +102,7 @@ bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
 	*num_vecs = __HFN_NUMINTS;
 }
 
-/**
+/*
  * No special setup required for crossbow -- vector assignments are implicit.
  */
 void
@@ -129,7 +129,7 @@ bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs)
 		bfa->msix.handler[i] = bfa_msix_lpu_err;
 }
 
-/**
+/*
  * Crossbow -- dummy, interrupts are masked
  */
 void
@@ -142,7 +142,7 @@ bfa_hwcb_msix_uninstall(struct bfa_s *bfa)
 {
 }
 
-/**
+/*
  * No special enable/disable -- vector assignments are implicit.
  */
 void
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index 81e670e..b0efbc7 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -39,7 +39,7 @@ bfa_hwct_msix_lpu_err_set(struct bfa_s *bfa, bfa_boolean_t msix, int vec)
 		writel(0, kva + __ct_msix_err_vec_reg[fn]);
 }
 
-/**
+/*
  * Dummy interrupt handler for handling spurious interrupt during chip-reinit.
  */
 static void
@@ -110,7 +110,7 @@ bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
 	*num_vecs = BFA_MSIX_CT_MAX;
 }
 
-/**
+/*
  * Setup MSI-X vector for catapult
  */
 void
@@ -156,7 +156,7 @@ bfa_hwct_msix_uninstall(struct bfa_s *bfa)
 		bfa->msix.handler[i] = bfa_hwct_msix_dummy;
 }
 
-/**
+/*
  * Enable MSI-X vectors
  */
 void
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index fddab88..54475b5 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -23,7 +23,7 @@
 
 BFA_TRC_FILE(CNA, IOC);
 
-/**
+/*
  * IOC local definitions
  */
 #define BFA_IOC_TOV		3000	/* msecs */
@@ -49,7 +49,7 @@ BFA_TRC_FILE(CNA, IOC);
 	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
 #define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
 
-/**
+/*
  * Asic specific macros : see bfa_hw_cb.c and bfa_hw_ct.c for details.
  */
 
@@ -101,11 +101,11 @@ static void bfa_ioc_pf_disabled(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_failed(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc);
 
-/**
+/*
  *  hal_ioc_sm
  */
 
-/**
+/*
  * IOC state machine definitions/declarations
  */
 enum ioc_event {
@@ -144,7 +144,7 @@ static struct bfa_sm_table_s ioc_sm_table[] = {
 	{BFA_SM(bfa_ioc_sm_disabled), BFA_IOC_DISABLED},
 };
 
-/**
+/*
  * IOCPF state machine definitions/declarations
  */
 
@@ -174,7 +174,7 @@ static void bfa_iocpf_stop(struct bfa_ioc_s *ioc);
 static void bfa_iocpf_timeout(void *ioc_arg);
 static void bfa_iocpf_sem_timeout(void *ioc_arg);
 
-/**
+/*
  * IOCPF state machine events
  */
 enum iocpf_event {
@@ -191,7 +191,7 @@ enum iocpf_event {
 	IOCPF_E_TIMEOUT		= 11,	/*  f/w response timeout	*/
 };
 
-/**
+/*
  * IOCPF states
  */
 enum bfa_iocpf_state {
@@ -232,11 +232,11 @@ static struct bfa_sm_table_s iocpf_sm_table[] = {
 	{BFA_SM(bfa_iocpf_sm_disabled), BFA_IOCPF_DISABLED},
 };
 
-/**
+/*
  * IOC State Machine
  */
 
-/**
+/*
  * Beginning state. IOC uninit state.
  */
 
@@ -245,7 +245,7 @@ bfa_ioc_sm_uninit_entry(struct bfa_ioc_s *ioc)
 {
 }
 
-/**
+/*
  * IOC is in uninit state.
  */
 static void
@@ -262,7 +262,7 @@ bfa_ioc_sm_uninit(struct bfa_ioc_s *ioc, enum ioc_event event)
 		bfa_sm_fault(ioc, event);
 	}
 }
-/**
+/*
  * Reset entry actions -- initialize state machine
  */
 static void
@@ -271,7 +271,7 @@ bfa_ioc_sm_reset_entry(struct bfa_ioc_s *ioc)
 	bfa_fsm_set_state(&ioc->iocpf, bfa_iocpf_sm_reset);
 }
 
-/**
+/*
  * IOC is in reset state.
  */
 static void
@@ -304,7 +304,7 @@ bfa_ioc_sm_enabling_entry(struct bfa_ioc_s *ioc)
 	bfa_iocpf_enable(ioc);
 }
 
-/**
+/*
  * Host IOC function is being enabled, awaiting response from firmware.
  * Semaphore is acquired.
  */
@@ -352,7 +352,7 @@ bfa_ioc_sm_getattr_entry(struct bfa_ioc_s *ioc)
 	bfa_ioc_send_getattr(ioc);
 }
 
-/**
+/*
  * IOC configuration in progress. Timer is active.
  */
 static void
@@ -447,7 +447,7 @@ bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
 	BFA_LOG(KERN_INFO, bfad, log_level, "IOC disabled\n");
 }
 
-/**
+/*
  * IOC is being disabled
  */
 static void
@@ -474,7 +474,7 @@ bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 	}
 }
 
-/**
+/*
  * IOC disable completion entry.
  */
 static void
@@ -514,7 +514,7 @@ bfa_ioc_sm_initfail_entry(struct bfa_ioc_s *ioc)
 	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
 }
 
-/**
+/*
  * Hardware initialization failed.
  */
 static void
@@ -528,7 +528,7 @@ bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	case IOC_E_FAILED:
-		/**
+		/*
 		 * Initialization failure during iocpf init retry.
 		 */
 		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
@@ -556,7 +556,7 @@ bfa_ioc_sm_fail_entry(struct bfa_ioc_s *ioc)
 	struct bfa_ioc_hbfail_notify_s	*notify;
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
 
-	/**
+	/*
 	 * Notify driver and common modules registered for notification.
 	 */
 	ioc->cbfn->hbfail_cbfn(ioc->bfa);
@@ -569,7 +569,7 @@ bfa_ioc_sm_fail_entry(struct bfa_ioc_s *ioc)
 		"Heart Beat of IOC has failed\n");
 }
 
-/**
+/*
  * IOC failure.
  */
 static void
@@ -580,7 +580,7 @@ bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 	switch (event) {
 
 	case IOC_E_FAILED:
-		/**
+		/*
 		 * Initialization failure during iocpf recovery.
 		 * !!! Fall through !!!
 		 */
@@ -608,12 +608,12 @@ bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 
-/**
+/*
  * IOCPF State Machine
  */
 
 
-/**
+/*
  * Reset entry actions -- initialize state machine
  */
 static void
@@ -623,7 +623,7 @@ bfa_iocpf_sm_reset_entry(struct bfa_iocpf_s *iocpf)
 	iocpf->auto_recover = bfa_auto_recover;
 }
 
-/**
+/*
  * Beginning state. IOC is in reset state.
  */
 static void
@@ -646,7 +646,7 @@ bfa_iocpf_sm_reset(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-/**
+/*
  * Semaphore should be acquired for version check.
  */
 static void
@@ -655,7 +655,7 @@ bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
 
-/**
+/*
  * Awaiting h/w semaphore to continue with version check.
  */
 static void
@@ -692,7 +692,7 @@ bfa_iocpf_sm_fwcheck(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-/**
+/*
  * Notify enable completion callback.
  */
 static void
@@ -708,7 +708,7 @@ bfa_iocpf_sm_mismatch_entry(struct bfa_iocpf_s *iocpf)
 	bfa_iocpf_timer_start(iocpf->ioc);
 }
 
-/**
+/*
  * Awaiting firmware version match.
  */
 static void
@@ -739,7 +739,7 @@ bfa_iocpf_sm_mismatch(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-/**
+/*
  * Request for semaphore.
  */
 static void
@@ -748,7 +748,7 @@ bfa_iocpf_sm_semwait_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
 
-/**
+/*
  * Awaiting semaphore for h/w initialzation.
  */
 static void
@@ -782,7 +782,7 @@ bfa_iocpf_sm_hwinit_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_reset(iocpf->ioc, BFA_FALSE);
 }
 
-/**
+/*
  * Hardware is being initialized. Interrupts are enabled.
  * Holding hardware semaphore lock.
  */
@@ -839,7 +839,7 @@ bfa_iocpf_sm_enabling_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_send_enable(iocpf->ioc);
 }
 
-/**
+/*
  * Host IOC function is being enabled, awaiting response from firmware.
  * Semaphore is acquired.
  */
@@ -943,7 +943,7 @@ bfa_iocpf_sm_disabling_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_send_disable(iocpf->ioc);
 }
 
-/**
+/*
  * IOC is being disabled
  */
 static void
@@ -979,7 +979,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-/**
+/*
  * IOC disable completion entry.
  */
 static void
@@ -1017,7 +1017,7 @@ bfa_iocpf_sm_initfail_entry(struct bfa_iocpf_s *iocpf)
 	bfa_iocpf_timer_start(iocpf->ioc);
 }
 
-/**
+/*
  * Hardware initialization failed.
  */
 static void
@@ -1052,18 +1052,18 @@ bfa_iocpf_sm_initfail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
 {
-	/**
+	/*
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
 	bfa_ioc_lpu_stop(iocpf->ioc);
 	writel(BFI_IOC_FAIL, iocpf->ioc->ioc_regs.ioc_fwstate);
 
-	/**
+	/*
 	 * Notify other functions on HB failure.
 	 */
 	bfa_ioc_notify_hbfail(iocpf->ioc);
 
-	/**
+	/*
 	 * Flush any queued up mailbox requests.
 	 */
 	bfa_ioc_mbox_hbfail(iocpf->ioc);
@@ -1072,7 +1072,7 @@ bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
 		bfa_iocpf_recovery_timer_start(iocpf->ioc);
 }
 
-/**
+/*
  * IOC is in failed state.
  */
 static void
@@ -1100,7 +1100,7 @@ bfa_iocpf_sm_fail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 
 
-/**
+/*
  *  hal_ioc_pvt BFA IOC private functions
  */
 
@@ -1112,7 +1112,7 @@ bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 
 	ioc->cbfn->disable_cbfn(ioc->bfa);
 
-	/**
+	/*
 	 * Notify common modules registered for notification.
 	 */
 	list_for_each(qe, &ioc->hb_notify_q) {
@@ -1154,7 +1154,7 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 {
 	u32	r32;
 
-	/**
+	/*
 	 * First read to the semaphore register will return 0, subsequent reads
 	 * will return 1. Semaphore is released by writing 1 to the register
 	 */
@@ -1179,7 +1179,7 @@ bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
 	bfa_sem_timer_stop(ioc);
 }
 
-/**
+/*
  * Initialize LPU local memory (aka secondary memory / SRAM)
  */
 static void
@@ -1199,7 +1199,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 	pss_ctl |= __PSS_I2C_CLK_DIV(3UL);
 	writel(pss_ctl, ioc->ioc_regs.pss_ctl_reg);
 
-	/**
+	/*
 	 * wait for memory initialization to be complete
 	 */
 	i = 0;
@@ -1208,7 +1208,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 		i++;
 	} while (!(pss_ctl & __PSS_LMEM_INIT_DONE) && (i < PSS_LMEM_INIT_TIME));
 
-	/**
+	/*
 	 * If memory initialization is not successful, IOC timeout will catch
 	 * such failures.
 	 */
@@ -1224,7 +1224,7 @@ bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
 {
 	u32	pss_ctl;
 
-	/**
+	/*
 	 * Take processor out of reset.
 	 */
 	pss_ctl = readl(ioc->ioc_regs.pss_ctl_reg);
@@ -1238,7 +1238,7 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 {
 	u32	pss_ctl;
 
-	/**
+	/*
 	 * Put processors in reset.
 	 */
 	pss_ctl = readl(ioc->ioc_regs.pss_ctl_reg);
@@ -1247,7 +1247,7 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 	writel(pss_ctl, ioc->ioc_regs.pss_ctl_reg);
 }
 
-/**
+/*
  * Get driver and firmware versions.
  */
 void
@@ -1270,7 +1270,7 @@ bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 	}
 }
 
-/**
+/*
  * Returns TRUE if same.
  */
 bfa_boolean_t
@@ -1295,7 +1295,7 @@ bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Return true if current running version is valid. Firmware signature and
  * execution context (driver/bios) must match.
  */
@@ -1304,7 +1304,7 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc, u32 boot_env)
 {
 	struct bfi_ioc_image_hdr_s fwhdr, *drv_fwhdr;
 
-	/**
+	/*
 	 * If bios/efi boot (flash based) -- return true
 	 */
 	if (bfa_ioc_is_bios_optrom(ioc))
@@ -1329,7 +1329,7 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc, u32 boot_env)
 	return bfa_ioc_fwver_cmp(ioc, &fwhdr);
 }
 
-/**
+/*
  * Conditionally flush any pending message from firmware at start.
  */
 static void
@@ -1361,7 +1361,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	boot_type = BFI_BOOT_TYPE_NORMAL;
 	boot_env = BFI_BOOT_LOADER_OS;
 
-	/**
+	/*
 	 * Flash based firmware boot BIOS env.
 	 */
 	if (bfa_ioc_is_bios_optrom(ioc)) {
@@ -1369,7 +1369,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 		boot_env = BFI_BOOT_LOADER_BIOS;
 	}
 
-	/**
+	/*
 	 * Flash based firmware boot UEFI env.
 	 */
 	if (bfa_ioc_is_uefi(ioc)) {
@@ -1377,7 +1377,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 		boot_env = BFI_BOOT_LOADER_UEFI;
 	}
 
-	/**
+	/*
 	 * check if firmware is valid
 	 */
 	fwvalid = (ioc_fwstate == BFI_IOC_UNINIT) ?
@@ -1388,7 +1388,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 		return;
 	}
 
-	/**
+	/*
 	 * If hardware initialization is in progress (initialized by other IOC),
 	 * just wait for an initialization completion interrupt.
 	 */
@@ -1397,7 +1397,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 		return;
 	}
 
-	/**
+	/*
 	 * If IOC function is disabled and firmware version is same,
 	 * just re-enable IOC.
 	 *
@@ -1408,7 +1408,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	if (ioc_fwstate == BFI_IOC_DISABLED ||
 	    (!bfa_ioc_is_bios_optrom(ioc) && ioc_fwstate == BFI_IOC_OP)) {
 
-		/**
+		/*
 		 * When using MSI-X any pending firmware ready event should
 		 * be flushed. Otherwise MSI-X interrupts are not delivered.
 		 */
@@ -1418,7 +1418,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 		return;
 	}
 
-	/**
+	/*
 	 * Initialize the h/w for any other states.
 	 */
 	bfa_ioc_boot(ioc, boot_type, boot_env);
@@ -1529,7 +1529,7 @@ bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
 }
 
 
-/**
+/*
  *	Initiate a full firmware download.
  */
 static void
@@ -1542,7 +1542,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	u32 chunkno = 0;
 	u32 i;
 
-	/**
+	/*
 	 * Initialize LMEM first before code download
 	 */
 	bfa_ioc_lmem_init(ioc);
@@ -1563,7 +1563,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 					BFA_IOC_FLASH_CHUNK_ADDR(chunkno));
 		}
 
-		/**
+		/*
 		 * write smem
 		 */
 		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff,
@@ -1571,7 +1571,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 		loff += sizeof(u32);
 
-		/**
+		/*
 		 * handle page offset wrap around
 		 */
 		loff = PSS_SMEM_PGOFF(loff);
@@ -1598,7 +1598,7 @@ bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	bfa_ioc_hwinit(ioc, force);
 }
 
-/**
+/*
  * Update BFA configuration from firmware configuration.
  */
 static void
@@ -1613,7 +1613,7 @@ bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
 	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
 }
 
-/**
+/*
  * Attach time initialization of mbox logic.
  */
 static void
@@ -1629,7 +1629,7 @@ bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
 	}
 }
 
-/**
+/*
  * Mbox poll timer -- restarts any pending mailbox requests.
  */
 static void
@@ -1639,27 +1639,27 @@ bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
 	struct bfa_mbox_cmd_s		*cmd;
 	u32			stat;
 
-	/**
+	/*
 	 * If no command pending, do nothing
 	 */
 	if (list_empty(&mod->cmd_q))
 		return;
 
-	/**
+	/*
 	 * If previous command is not yet fetched by firmware, do nothing
 	 */
 	stat = readl(ioc->ioc_regs.hfn_mbox_cmd);
 	if (stat)
 		return;
 
-	/**
+	/*
 	 * Enqueue command to firmware.
 	 */
 	bfa_q_deq(&mod->cmd_q, &cmd);
 	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
 }
 
-/**
+/*
  * Cleanup any pending requests.
  */
 static void
@@ -1672,7 +1672,7 @@ bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
 		bfa_q_deq(&mod->cmd_q, &cmd);
 }
 
-/**
+/*
  * Read data from SMEM to host through PCI memmap
  *
  * @param[in]	ioc	memory for IOC
@@ -1710,7 +1710,7 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 		buf[i] = be32_to_cpu(r32);
 		loff += sizeof(u32);
 
-		/**
+		/*
 		 * handle page offset wrap around
 		 */
 		loff = PSS_SMEM_PGOFF(loff);
@@ -1729,7 +1729,7 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Clear SMEM data from host through PCI memmap
  *
  * @param[in]	ioc	memory for IOC
@@ -1764,7 +1764,7 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff, 0);
 		loff += sizeof(u32);
 
-		/**
+		/*
 		 * handle page offset wrap around
 		 */
 		loff = PSS_SMEM_PGOFF(loff);
@@ -1783,7 +1783,7 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * hal iocpf to ioc interface
  */
 static void
@@ -1808,7 +1808,7 @@ static void
 bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 {
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
-	/**
+	/*
 	 * Provide enable completion callback.
 	 */
 	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
@@ -1819,7 +1819,7 @@ bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 
 
 
-/**
+/*
  *  hal_ioc_public
  */
 
@@ -1843,7 +1843,7 @@ bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Interface used by diag module to do firmware boot with memory test
  * as the entry vector.
  */
@@ -1857,7 +1857,7 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 	if (bfa_ioc_pll_init(ioc) != BFA_STATUS_OK)
 		return;
 
-	/**
+	/*
 	 * Initialize IOC state of all functions on a chip reset.
 	 */
 	rb = ioc->pcidev.pci_bar_kva;
@@ -1872,14 +1872,14 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 	bfa_ioc_msgflush(ioc);
 	bfa_ioc_download_fw(ioc, boot_type, boot_env);
 
-	/**
+	/*
 	 * Enable interrupts just before starting LPU
 	 */
 	ioc->cbfn->reset_cbfn(ioc->bfa);
 	bfa_ioc_lpu_start(ioc);
 }
 
-/**
+/*
  * Enable/disable IOC failure auto recovery.
  */
 void
@@ -1913,7 +1913,7 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 	u32	r32;
 	int		i;
 
-	/**
+	/*
 	 * read the MBOX msg
 	 */
 	for (i = 0; i < (sizeof(union bfi_ioc_i2h_msg_u) / sizeof(u32));
@@ -1923,7 +1923,7 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 		msgp[i] = cpu_to_be32(r32);
 	}
 
-	/**
+	/*
 	 * turn off mailbox interrupt by clearing mailbox status
 	 */
 	writel(1, ioc->ioc_regs.lpu_mbox_cmd);
@@ -1966,7 +1966,7 @@ bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
 	}
 }
 
-/**
+/*
  * IOC attach time initialization and setup.
  *
  * @param[in]	ioc	memory for IOC
@@ -1991,7 +1991,7 @@ bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa, struct bfa_ioc_cbfn_s *cbfn,
 	bfa_fsm_send_event(ioc, IOC_E_RESET);
 }
 
-/**
+/*
  * Driver detach time IOC cleanup.
  */
 void
@@ -2000,7 +2000,7 @@ bfa_ioc_detach(struct bfa_ioc_s *ioc)
 	bfa_fsm_send_event(ioc, IOC_E_DETACH);
 }
 
-/**
+/*
  * Setup IOC PCI properties.
  *
  * @param[in]	pcidev	PCI device information for this IOC
@@ -2014,7 +2014,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 	ioc->ctdev	= bfa_asic_id_ct(ioc->pcidev.device_id);
 	ioc->cna	= ioc->ctdev && !ioc->fcmode;
 
-	/**
+	/*
 	 * Set asic specific interfaces. See bfa_ioc_cb.c and bfa_ioc_ct.c
 	 */
 	if (ioc->ctdev)
@@ -2026,7 +2026,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 	bfa_ioc_reg_init(ioc);
 }
 
-/**
+/*
  * Initialize IOC dma memory
  *
  * @param[in]	dm_kva	kernel virtual address of IOC dma memory
@@ -2035,7 +2035,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 void
 bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa)
 {
-	/**
+	/*
 	 * dma memory for firmware attribute
 	 */
 	ioc->attr_dma.kva = dm_kva;
@@ -2043,7 +2043,7 @@ bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa)
 	ioc->attr = (struct bfi_ioc_attr_s *) dm_kva;
 }
 
-/**
+/*
  * Return size of dma memory required.
  */
 u32
@@ -2068,7 +2068,7 @@ bfa_ioc_disable(struct bfa_ioc_s *ioc)
 	bfa_fsm_send_event(ioc, IOC_E_DISABLE);
 }
 
-/**
+/*
  * Returns memory required for saving firmware trace in case of crash.
  * Driver must call this interface to allocate memory required for
  * automatic saving of firmware trace. Driver should call
@@ -2081,7 +2081,7 @@ bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover)
 	return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 }
 
-/**
+/*
  * Initialize memory for saving firmware trace. Driver must initialize
  * trace memory before call bfa_ioc_enable().
  */
@@ -2104,7 +2104,7 @@ bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr)
 	return PSS_SMEM_PGOFF(fmaddr);
 }
 
-/**
+/*
  * Register mailbox message handler functions
  *
  * @param[in]	ioc		IOC instance
@@ -2120,7 +2120,7 @@ bfa_ioc_mbox_register(struct bfa_ioc_s *ioc, bfa_ioc_mbox_mcfunc_t *mcfuncs)
 		mod->mbhdlr[mc].cbfn = mcfuncs[mc];
 }
 
-/**
+/*
  * Register mailbox message handler function, to be called by common modules
  */
 void
@@ -2133,7 +2133,7 @@ bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 	mod->mbhdlr[mc].cbarg	= cbarg;
 }
 
-/**
+/*
  * Queue a mailbox command request to firmware. Waits if mailbox is busy.
  * Responsibility of caller to serialize
  *
@@ -2146,7 +2146,7 @@ bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
 	u32			stat;
 
-	/**
+	/*
 	 * If a previous command is pending, queue new command
 	 */
 	if (!list_empty(&mod->cmd_q)) {
@@ -2154,7 +2154,7 @@ bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 		return;
 	}
 
-	/**
+	/*
 	 * If mailbox is busy, queue command for poll timer
 	 */
 	stat = readl(ioc->ioc_regs.hfn_mbox_cmd);
@@ -2163,13 +2163,13 @@ bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 		return;
 	}
 
-	/**
+	/*
 	 * mailbox is free -- queue command to firmware
 	 */
 	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
 }
 
-/**
+/*
  * Handle mailbox interrupts
  */
 void
@@ -2181,7 +2181,7 @@ bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 
 	bfa_ioc_msgget(ioc, &m);
 
-	/**
+	/*
 	 * Treat IOC message class as special.
 	 */
 	mc = m.mh.msg_class;
@@ -2209,7 +2209,7 @@ bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
 	ioc->port_id = bfa_ioc_pcifn(ioc);
 }
 
-/**
+/*
  * return true if IOC is disabled
  */
 bfa_boolean_t
@@ -2219,7 +2219,7 @@ bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
 		bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled);
 }
 
-/**
+/*
  * return true if IOC firmware is different.
  */
 bfa_boolean_t
@@ -2238,7 +2238,7 @@ bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 	 ((__sm) == BFI_IOC_FAIL) ||		\
 	 ((__sm) == BFI_IOC_CFG_DISABLED))
 
-/**
+/*
  * Check if adapter is disabled -- both IOCs should be in a disabled
  * state.
  */
@@ -2264,7 +2264,7 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Add to IOC heartbeat failure notification queue. To be used by common
  * modules such as cee, port, diag.
  */
@@ -2391,7 +2391,7 @@ bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 
 	ioc_attr = ioc->attr;
 
-	/**
+	/*
 	 * model name
 	 */
 	snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u",
@@ -2455,7 +2455,7 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 	bfa_ioc_get_pci_chip_rev(ioc, ioc_attr->pci_attr.chip_rev);
 }
 
-/**
+/*
  *  hal_wwn_public
  */
 wwn_t
@@ -2521,7 +2521,7 @@ bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 	return ioc->fcmode || !bfa_asic_id_ct(ioc->pcidev.device_id);
 }
 
-/**
+/*
  * Retrieve saved firmware trace from a prior IOC failure.
  */
 bfa_status_t
@@ -2541,7 +2541,7 @@ bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Clear saved firmware trace
  */
 void
@@ -2550,7 +2550,7 @@ bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc)
 	ioc->dbg_fwsave_once = BFA_TRUE;
 }
 
-/**
+/*
  * Retrieve saved firmware trace from a prior IOC failure.
  */
 bfa_status_t
@@ -2590,7 +2590,7 @@ bfa_ioc_fwsync(struct bfa_ioc_s *ioc)
 
 	bfa_ioc_send_fwsync(ioc);
 
-	/**
+	/*
 	 * After sending a fw sync mbox command wait for it to
 	 * take effect.  We will not wait for a response because
 	 *    1. fw_sync mbox cmd doesn't have a response.
@@ -2605,7 +2605,7 @@ bfa_ioc_fwsync(struct bfa_ioc_s *ioc)
 		fwsync_iter--;
 }
 
-/**
+/*
  * Dump firmware smem
  */
 bfa_status_t
@@ -2625,7 +2625,7 @@ bfa_ioc_debug_fwcore(struct bfa_ioc_s *ioc, void *buf,
 	loff = *offset;
 	dlen = *buflen;
 
-	/**
+	/*
 	 * First smem read, sync smem before proceeding
 	 * No need to sync before reading every chunk.
 	 */
@@ -2652,7 +2652,7 @@ bfa_ioc_debug_fwcore(struct bfa_ioc_s *ioc, void *buf,
 	return status;
 }
 
-/**
+/*
  * Firmware statistics
  */
 bfa_status_t
@@ -2697,7 +2697,7 @@ bfa_ioc_fw_stats_clear(struct bfa_ioc_s *ioc)
 	return status;
 }
 
-/**
+/*
  * Save firmware trace if configured.
  */
 static void
@@ -2711,7 +2711,7 @@ bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
 	}
 }
 
-/**
+/*
  * Firmware failure detected. Start recovery actions.
  */
 static void
@@ -2733,7 +2733,7 @@ bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc)
 		return;
 }
 
-/**
+/*
  *  hal_iocpf_pvt BFA IOC PF private functions
  */
 
@@ -2790,7 +2790,7 @@ bfa_iocpf_sem_timeout(void *ioc_arg)
 	bfa_ioc_hw_sem_get(ioc);
 }
 
-/**
+/*
  *  bfa timer function
  */
 void
@@ -2835,7 +2835,7 @@ bfa_timer_beat(struct bfa_timer_mod_s *mod)
 	}
 }
 
-/**
+/*
  * Should be called with lock protection
  */
 void
@@ -2853,7 +2853,7 @@ bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
 	list_add_tail(&timer->qe, &mod->timer_q);
 }
 
-/**
+/*
  * Should be called with lock protection
  */
 void
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 86210a5..9099450 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -34,7 +34,7 @@ static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
 
 struct bfa_ioc_hwif_s hwif_cb;
 
-/**
+/*
  * Called from bfa_ioc_attach() to map asic specific calls.
  */
 void
@@ -52,7 +52,7 @@ bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
 	ioc->ioc_hwif = &hwif_cb;
 }
 
-/**
+/*
  * Return true if firmware of current driver matches the running firmware.
  */
 static bfa_boolean_t
@@ -66,7 +66,7 @@ bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc)
 {
 }
 
-/**
+/*
  * Notify other functions on HB failure.
  */
 static void
@@ -76,7 +76,7 @@ bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc)
 	readl(ioc->ioc_regs.err_set);
 }
 
-/**
+/*
  * Host to LPU mailbox message addresses
  */
 static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
@@ -84,7 +84,7 @@ static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
 	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 }
 };
 
-/**
+/*
  * Host <-> LPU mailbox command/status registers
  */
 static struct { u32 hfn, lpu; } iocreg_mbcmd[] = {
@@ -113,7 +113,7 @@ bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
 	}
 
-	/**
+	/*
 	 * Host <-> LPU mailbox command/status registers
 	 */
 	ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd[pcifn].hfn;
@@ -133,7 +133,7 @@ bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
 	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
 
-	/**
+	/*
 	 * sram memory access
 	 */
 	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
@@ -145,14 +145,14 @@ bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 	ioc->ioc_regs.err_set = (rb + ERR_SET_REG);
 }
 
-/**
+/*
  * Initialize IOC to port mapping.
  */
 
 static void
 bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc)
 {
-	/**
+	/*
 	 * For crossbow, port id is same as pci function.
 	 */
 	ioc->port_id = bfa_ioc_pcifn(ioc);
@@ -160,7 +160,7 @@ bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc)
 	bfa_trc(ioc, ioc->port_id);
 }
 
-/**
+/*
  * Set interrupt mode for a function: INTX or MSIX
  */
 static void
@@ -168,7 +168,7 @@ bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 {
 }
 
-/**
+/*
  * Cleanup hw semaphore and usecnt registers
  */
 static void
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index c852d98..115730c 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -34,7 +34,7 @@ static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
 
 struct bfa_ioc_hwif_s hwif_ct;
 
-/**
+/*
  * Called from bfa_ioc_attach() to map asic specific calls.
  */
 void
@@ -52,7 +52,7 @@ bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
 	ioc->ioc_hwif = &hwif_ct;
 }
 
-/**
+/*
  * Return true if firmware of current driver matches the running firmware.
  */
 static bfa_boolean_t
@@ -62,13 +62,13 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	u32 usecnt;
 	struct bfi_ioc_image_hdr_s fwhdr;
 
-	/**
+	/*
 	 * Firmware match check is relevant only for CNA.
 	 */
 	if (!ioc->cna)
 		return BFA_TRUE;
 
-	/**
+	/*
 	 * If bios boot (flash based) -- do not increment usage count
 	 */
 	if (bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) <
@@ -78,7 +78,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
 	usecnt = readl(ioc->ioc_regs.ioc_usage_reg);
 
-	/**
+	/*
 	 * If usage count is 0, always return TRUE.
 	 */
 	if (usecnt == 0) {
@@ -91,12 +91,12 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	ioc_fwstate = readl(ioc->ioc_regs.ioc_fwstate);
 	bfa_trc(ioc, ioc_fwstate);
 
-	/**
+	/*
 	 * Use count cannot be non-zero and chip in uninitialized state.
 	 */
 	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
 
-	/**
+	/*
 	 * Check if another driver with a different firmware is active
 	 */
 	bfa_ioc_fwver_get(ioc, &fwhdr);
@@ -106,7 +106,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 		return BFA_FALSE;
 	}
 
-	/**
+	/*
 	 * Same firmware version. Increment the reference count.
 	 */
 	usecnt++;
@@ -121,20 +121,20 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 {
 	u32 usecnt;
 
-	/**
+	/*
 	 * Firmware lock is relevant only for CNA.
 	 */
 	if (!ioc->cna)
 		return;
 
-	/**
+	/*
 	 * If bios boot (flash based) -- do not decrement usage count
 	 */
 	if (bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) <
 						BFA_IOC_FWIMG_MINSZ)
 		return;
 
-	/**
+	/*
 	 * decrement usage count
 	 */
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
@@ -148,7 +148,7 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
 }
 
-/**
+/*
  * Notify other functions on HB failure.
  */
 static void
@@ -164,7 +164,7 @@ bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
 	}
 }
 
-/**
+/*
  * Host to LPU mailbox message addresses
  */
 static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
@@ -174,7 +174,7 @@ static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
 	{ HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3 }
 };
 
-/**
+/*
  * Host <-> LPU mailbox command/status registers - port 0
  */
 static struct { u32 hfn, lpu; } iocreg_mbcmd_p0[] = {
@@ -184,7 +184,7 @@ static struct { u32 hfn, lpu; } iocreg_mbcmd_p0[] = {
 	{ HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT }
 };
 
-/**
+/*
  * Host <-> LPU mailbox command/status registers - port 1
  */
 static struct { u32 hfn, lpu; } iocreg_mbcmd_p1[] = {
@@ -236,7 +236,7 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
 	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
 
-	/**
+	/*
 	 * sram memory access
 	 */
 	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
@@ -248,7 +248,7 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 	ioc->ioc_regs.err_set = (rb + ERR_SET_REG);
 }
 
-/**
+/*
  * Initialize IOC to port mapping.
  */
 
@@ -259,7 +259,7 @@ bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 	void __iomem *rb = ioc->pcidev.pci_bar_kva;
 	u32	r32;
 
-	/**
+	/*
 	 * For catapult, base port id on personality register and IOC type
 	 */
 	r32 = readl(rb + FNC_PERS_REG);
@@ -270,7 +270,7 @@ bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 	bfa_trc(ioc, ioc->port_id);
 }
 
-/**
+/*
  * Set interrupt mode for a function: INTX or MSIX
  */
 static void
@@ -285,7 +285,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
 		__F0_INTX_STATUS;
 
-	/**
+	/*
 	 * If already in desired mode, do not change anything
 	 */
 	if (!msix && mode)
@@ -303,7 +303,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	writel(r32, rb + FNC_PERS_REG);
 }
 
-/**
+/*
  * Cleanup hw semaphore and usecnt registers
  */
 static void
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 17834ff..fff9622 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -46,7 +46,7 @@ bfa_port_stats_swap(struct bfa_port_s *port, union bfa_port_stats_u *stats)
 	}
 }
 
-/**
+/*
  * bfa_port_enable_isr()
  *
  *
@@ -63,7 +63,7 @@ bfa_port_enable_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->endis_cbfn(port->endis_cbarg, status);
 }
 
-/**
+/*
  * bfa_port_disable_isr()
  *
  *
@@ -80,7 +80,7 @@ bfa_port_disable_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->endis_cbfn(port->endis_cbarg, status);
 }
 
-/**
+/*
  * bfa_port_get_stats_isr()
  *
  *
@@ -112,7 +112,7 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	}
 }
 
-/**
+/*
  * bfa_port_clear_stats_isr()
  *
  *
@@ -129,7 +129,7 @@ bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->stats_status = status;
 	port->stats_busy   = BFA_FALSE;
 
-	/**
+	/*
 	* re-initialize time stamp for stats reset
 	*/
 	bfa_os_gettimeofday(&tv);
@@ -141,7 +141,7 @@ bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	}
 }
 
-/**
+/*
  * bfa_port_isr()
  *
  *
@@ -189,7 +189,7 @@ bfa_port_isr(void *cbarg, struct bfi_mbmsg_s *m)
 	}
 }
 
-/**
+/*
  * bfa_port_meminfo()
  *
  *
@@ -203,7 +203,7 @@ bfa_port_meminfo(void)
 	return BFA_ROUNDUP(sizeof(union bfa_port_stats_u), BFA_DMA_ALIGN_SZ);
 }
 
-/**
+/*
  * bfa_port_mem_claim()
  *
  *
@@ -220,7 +220,7 @@ bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva, u64 dma_pa)
 	port->stats_dma.pa  = dma_pa;
 }
 
-/**
+/*
  * bfa_port_enable()
  *
  *   Send the Port enable request to the f/w
@@ -264,7 +264,7 @@ bfa_port_enable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * bfa_port_disable()
  *
  *   Send the Port disable request to the f/w
@@ -308,7 +308,7 @@ bfa_port_disable(struct bfa_port_s *port, bfa_port_endis_cbfn_t cbfn,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * bfa_port_get_stats()
  *
  *   Send the request to the f/w to fetch Port statistics.
@@ -348,7 +348,7 @@ bfa_port_get_stats(struct bfa_port_s *port, union bfa_port_stats_u *stats,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * bfa_port_clear_stats()
  *
  *
@@ -385,7 +385,7 @@ bfa_port_clear_stats(struct bfa_port_s *port, bfa_port_stats_cbfn_t cbfn,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * bfa_port_hbfail()
  *
  *
@@ -415,7 +415,7 @@ bfa_port_hbfail(void *arg)
 	}
 }
 
-/**
+/*
  * bfa_port_attach()
  *
  *
@@ -449,7 +449,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 	bfa_ioc_hbfail_init(&port->hbfail, bfa_port_hbfail, port);
 	bfa_ioc_hbfail_register(port->ioc, &port->hbfail);
 
-	/**
+	/*
 	 * initialize time stamp for stats reset
 	 */
 	bfa_os_gettimeofday(&tv);
@@ -458,7 +458,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 	bfa_trc(port, 0);
 }
 
-/**
+/*
  * bfa_port_detach()
  *
  *
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 4d13688..c768143 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -29,7 +29,7 @@ BFA_MODULE(fcport);
 BFA_MODULE(rport);
 BFA_MODULE(uf);
 
-/**
+/*
  * LPS related definitions
  */
 #define BFA_LPS_MIN_LPORTS      (1)
@@ -41,7 +41,7 @@ BFA_MODULE(uf);
 #define BFA_LPS_MAX_VPORTS_SUPP_CB  255
 #define BFA_LPS_MAX_VPORTS_SUPP_CT  190
 
-/**
+/*
  *  lps_pvt BFA LPS private functions
  */
 
@@ -55,7 +55,7 @@ enum bfa_lps_event {
 	BFA_LPS_SM_RX_CVL	= 7,	/* Rx clear virtual link	*/
 };
 
-/**
+/*
  * FC PORT related definitions
  */
 /*
@@ -67,7 +67,7 @@ enum bfa_lps_event {
 	(bfa_ioc_is_disabled(&bfa->ioc) == BFA_TRUE))
 
 
-/**
+/*
  * BFA port state machine events
  */
 enum bfa_fcport_sm_event {
@@ -82,7 +82,7 @@ enum bfa_fcport_sm_event {
 	BFA_FCPORT_SM_HWFAIL	= 9,	/*  IOC h/w failure		*/
 };
 
-/**
+/*
  * BFA port link notification state machine events
  */
 
@@ -92,7 +92,7 @@ enum bfa_fcport_ln_sm_event {
 	BFA_FCPORT_LN_SM_NOTIFICATION	= 3	/*  done notification	*/
 };
 
-/**
+/*
  * RPORT related definitions
  */
 #define bfa_rport_offline_cb(__rp) do {					\
@@ -126,7 +126,7 @@ enum bfa_rport_event {
 	BFA_RPORT_SM_QRESUME	= 9,	/*  space in requeue queue	*/
 };
 
-/**
+/*
  * forward declarations FCXP related functions
  */
 static void	__bfa_fcxp_send_cbfn(void *cbarg, bfa_boolean_t complete);
@@ -138,7 +138,7 @@ static void	bfa_fcxp_qresume(void *cbarg);
 static void	bfa_fcxp_queue(struct bfa_fcxp_s *fcxp,
 				struct bfi_fcxp_send_req_s *send_req);
 
-/**
+/*
  * forward declarations for LPS functions
  */
 static void bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
@@ -163,7 +163,7 @@ static void bfa_lps_login_comp(struct bfa_lps_s *lps);
 static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
 static void bfa_lps_cvl_event(struct bfa_lps_s *lps);
 
-/**
+/*
  * forward declaration for LPS state machine
  */
 static void bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event);
@@ -175,7 +175,7 @@ static void bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event);
 static void bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event
 					event);
 
-/**
+/*
  * forward declaration for FC Port functions
  */
 static bfa_boolean_t bfa_fcport_send_enable(struct bfa_fcport_s *fcport);
@@ -193,7 +193,7 @@ static void bfa_fcport_stats_get_timeout(void *cbarg);
 static void bfa_fcport_stats_clr_timeout(void *cbarg);
 static void bfa_trunk_iocdisable(struct bfa_s *bfa);
 
-/**
+/*
  * forward declaration for FC PORT state machine
  */
 static void     bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
@@ -252,7 +252,7 @@ static struct bfa_sm_table_s hal_port_sm_table[] = {
 };
 
 
-/**
+/*
  * forward declaration for RPORT related functions
  */
 static struct bfa_rport_s *bfa_rport_alloc(struct bfa_rport_mod_s *rp_mod);
@@ -265,7 +265,7 @@ static void		__bfa_cb_rport_online(void *cbarg,
 static void		__bfa_cb_rport_offline(void *cbarg,
 						bfa_boolean_t complete);
 
-/**
+/*
  * forward declaration for RPORT state machine
  */
 static void     bfa_rport_sm_uninit(struct bfa_rport_s *rp,
@@ -295,7 +295,7 @@ static void     bfa_rport_sm_fwdelete_qfull(struct bfa_rport_s *rp,
 static void     bfa_rport_sm_deleting_qfull(struct bfa_rport_s *rp,
 					enum bfa_rport_event event);
 
-/**
+/*
  * PLOG related definitions
  */
 static int
@@ -461,7 +461,7 @@ bfa_plog_get_setting(struct bfa_plog_s *plog)
 	return (bfa_boolean_t)plog->plog_enabled;
 }
 
-/**
+/*
  *  fcxp_pvt BFA FCXP private functions
  */
 
@@ -562,7 +562,7 @@ bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	mod->bfa = bfa;
 	mod->num_fcxps = cfg->fwcfg.num_fcxp_reqs;
 
-	/**
+	/*
 	 * Initialize FCXP request and response payload sizes.
 	 */
 	mod->req_pld_sz = mod->rsp_pld_sz = BFA_FCXP_MAX_IBUF_SZ;
@@ -746,7 +746,7 @@ hal_fcxp_send_comp(struct bfa_s *bfa, struct bfi_fcxp_send_rsp_s *fcxp_rsp)
 
 	fcxp_rsp->rsp_len = be32_to_cpu(fcxp_rsp->rsp_len);
 
-	/**
+	/*
 	 * @todo f/w should not set residue to non-0 when everything
 	 *	 is received.
 	 */
@@ -855,7 +855,7 @@ hal_fcxp_rx_plog(struct bfa_s *bfa, struct bfa_fcxp_s *fcxp,
 	}
 }
 
-/**
+/*
  * Handler to resume sending fcxp when space in available in cpe queue.
  */
 static void
@@ -870,7 +870,7 @@ bfa_fcxp_qresume(void *cbarg)
 	bfa_fcxp_queue(fcxp, send_req);
 }
 
-/**
+/*
  * Queue fcxp send request to foimrware.
  */
 static void
@@ -954,11 +954,11 @@ bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
 	bfa_trc(bfa, bfa_reqq_ci(bfa, BFA_REQQ_FCXP));
 }
 
-/**
+/*
  *  hal_fcxp_api BFA FCXP API
  */
 
-/**
+/*
  * Allocate an FCXP instance to send a response or to send a request
  * that has a response. Request/response buffers are allocated by caller.
  *
@@ -1004,7 +1004,7 @@ bfa_fcxp_alloc(void *caller, struct bfa_s *bfa, int nreq_sgles,
 	return fcxp;
 }
 
-/**
+/*
  * Get the internal request buffer pointer
  *
  * @param[in]	fcxp	BFA fcxp pointer
@@ -1031,7 +1031,7 @@ bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp)
 	return mod->req_pld_sz;
 }
 
-/**
+/*
  * Get the internal response buffer pointer
  *
  * @param[in]	fcxp	BFA fcxp pointer
@@ -1051,7 +1051,7 @@ bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp)
 	return rspbuf;
 }
 
-/**
+/*
  *		Free the BFA FCXP
  *
  * @param[in]	fcxp			BFA fcxp pointer
@@ -1068,7 +1068,7 @@ bfa_fcxp_free(struct bfa_fcxp_s *fcxp)
 	bfa_fcxp_put(fcxp);
 }
 
-/**
+/*
  * Send a FCXP request
  *
  * @param[in]	fcxp	BFA fcxp pointer
@@ -1102,7 +1102,7 @@ bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 
 	bfa_trc(bfa, fcxp->fcxp_tag);
 
-	/**
+	/*
 	 * setup request/response info
 	 */
 	reqi->bfa_rport = rport;
@@ -1117,7 +1117,7 @@ bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 	fcxp->send_cbfn = cbfn ? cbfn : bfa_fcxp_null_comp;
 	fcxp->send_cbarg = cbarg;
 
-	/**
+	/*
 	 * If no room in CPE queue, wait for space in request queue
 	 */
 	send_req = bfa_reqq_next(bfa, BFA_REQQ_FCXP);
@@ -1131,7 +1131,7 @@ bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 	bfa_fcxp_queue(fcxp, send_req);
 }
 
-/**
+/*
  * Abort a BFA FCXP
  *
  * @param[in]	fcxp	BFA fcxp pointer
@@ -1185,7 +1185,7 @@ bfa_fcxp_walloc_cancel(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe)
 void
 bfa_fcxp_discard(struct bfa_fcxp_s *fcxp)
 {
-	/**
+	/*
 	 * If waiting for room in request queue, cancel reqq wait
 	 * and free fcxp.
 	 */
@@ -1201,7 +1201,7 @@ bfa_fcxp_discard(struct bfa_fcxp_s *fcxp)
 
 
 
-/**
+/*
  *  hal_fcxp_public BFA FCXP public functions
  */
 
@@ -1228,11 +1228,11 @@ bfa_fcxp_get_maxrsp(struct bfa_s *bfa)
 }
 
 
-/**
+/*
  *  BFA LPS state machine functions
  */
 
-/**
+/*
  * Init state -- no login
  */
 static void
@@ -1284,7 +1284,7 @@ bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	}
 }
 
-/**
+/*
  * login is in progress -- awaiting response from firmware
  */
 static void
@@ -1326,7 +1326,7 @@ bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	}
 }
 
-/**
+/*
  * login pending - awaiting space in request queue
  */
 static void
@@ -1358,7 +1358,7 @@ bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	}
 }
 
-/**
+/*
  * login complete
  */
 static void
@@ -1399,7 +1399,7 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	}
 }
 
-/**
+/*
  * logout in progress - awaiting firmware response
  */
 static void
@@ -1423,7 +1423,7 @@ bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	}
 }
 
-/**
+/*
  * logout pending -- awaiting space in request queue
  */
 static void
@@ -1450,11 +1450,11 @@ bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 
 
 
-/**
+/*
  *  lps_pvt BFA LPS private functions
  */
 
-/**
+/*
  * return memory requirement
  */
 static void
@@ -1467,7 +1467,7 @@ bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
 		*ndm_len += sizeof(struct bfa_lps_s) * BFA_LPS_MAX_LPORTS;
 }
 
-/**
+/*
  * bfa module attach at initialization time
  */
 static void
@@ -1515,7 +1515,7 @@ bfa_lps_stop(struct bfa_s *bfa)
 {
 }
 
-/**
+/*
  * IOC in disabled state -- consider all lps offline
  */
 static void
@@ -1531,7 +1531,7 @@ bfa_lps_iocdisable(struct bfa_s *bfa)
 	}
 }
 
-/**
+/*
  * Firmware login response
  */
 static void
@@ -1578,7 +1578,7 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
 }
 
-/**
+/*
  * Firmware logout response
  */
 static void
@@ -1593,7 +1593,7 @@ bfa_lps_logout_rsp(struct bfa_s *bfa, struct bfi_lps_logout_rsp_s *rsp)
 	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
 }
 
-/**
+/*
  * Firmware received a Clear virtual link request (for FCoE)
  */
 static void
@@ -1607,7 +1607,7 @@ bfa_lps_rx_cvl_event(struct bfa_s *bfa, struct bfi_lps_cvl_event_s *cvl)
 	bfa_sm_send_event(lps, BFA_LPS_SM_RX_CVL);
 }
 
-/**
+/*
  * Space is available in request queue, resume queueing request to firmware.
  */
 static void
@@ -1618,7 +1618,7 @@ bfa_lps_reqq_resume(void *lps_arg)
 	bfa_sm_send_event(lps, BFA_LPS_SM_RESUME);
 }
 
-/**
+/*
  * lps is freed -- triggered by vport delete
  */
 static void
@@ -1631,7 +1631,7 @@ bfa_lps_free(struct bfa_lps_s *lps)
 	list_add_tail(&lps->qe, &mod->lps_free_q);
 }
 
-/**
+/*
  * send login request to firmware
  */
 static void
@@ -1656,7 +1656,7 @@ bfa_lps_send_login(struct bfa_lps_s *lps)
 	bfa_reqq_produce(lps->bfa, lps->reqq);
 }
 
-/**
+/*
  * send logout request to firmware
  */
 static void
@@ -1675,7 +1675,7 @@ bfa_lps_send_logout(struct bfa_lps_s *lps)
 	bfa_reqq_produce(lps->bfa, lps->reqq);
 }
 
-/**
+/*
  * Indirect login completion handler for non-fcs
  */
 static void
@@ -1692,7 +1692,7 @@ bfa_lps_login_comp_cb(void *arg, bfa_boolean_t complete)
 		bfa_cb_lps_flogi_comp(lps->bfa->bfad, lps->uarg, lps->status);
 }
 
-/**
+/*
  * Login completion handler -- direct call for fcs, queue for others
  */
 static void
@@ -1710,7 +1710,7 @@ bfa_lps_login_comp(struct bfa_lps_s *lps)
 		bfa_cb_lps_flogi_comp(lps->bfa->bfad, lps->uarg, lps->status);
 }
 
-/**
+/*
  * Indirect logout completion handler for non-fcs
  */
 static void
@@ -1725,7 +1725,7 @@ bfa_lps_logout_comp_cb(void *arg, bfa_boolean_t complete)
 		bfa_cb_lps_fdisclogo_comp(lps->bfa->bfad, lps->uarg);
 }
 
-/**
+/*
  * Logout completion handler -- direct call for fcs, queue for others
  */
 static void
@@ -1740,7 +1740,7 @@ bfa_lps_logout_comp(struct bfa_lps_s *lps)
 		bfa_cb_lps_fdisclogo_comp(lps->bfa->bfad, lps->uarg);
 }
 
-/**
+/*
  * Clear virtual link completion handler for non-fcs
  */
 static void
@@ -1756,7 +1756,7 @@ bfa_lps_cvl_event_cb(void *arg, bfa_boolean_t complete)
 		bfa_cb_lps_cvl_event(lps->bfa->bfad, lps->uarg);
 }
 
-/**
+/*
  * Received Clear virtual link event --direct call for fcs,
  * queue for others
  */
@@ -1776,7 +1776,7 @@ bfa_lps_cvl_event(struct bfa_lps_s *lps)
 
 
 
-/**
+/*
  *  lps_public BFA LPS public functions
  */
 
@@ -1789,7 +1789,7 @@ bfa_lps_get_max_vport(struct bfa_s *bfa)
 		return BFA_LPS_MAX_VPORTS_SUPP_CB;
 }
 
-/**
+/*
  * Allocate a lport srvice tag.
  */
 struct bfa_lps_s  *
@@ -1809,7 +1809,7 @@ bfa_lps_alloc(struct bfa_s *bfa)
 	return lps;
 }
 
-/**
+/*
  * Free lport service tag. This can be called anytime after an alloc.
  * No need to wait for any pending login/logout completions.
  */
@@ -1819,7 +1819,7 @@ bfa_lps_delete(struct bfa_lps_s *lps)
 	bfa_sm_send_event(lps, BFA_LPS_SM_DELETE);
 }
 
-/**
+/*
  * Initiate a lport login.
  */
 void
@@ -1836,7 +1836,7 @@ bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa, u16 pdusz,
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
 }
 
-/**
+/*
  * Initiate a lport fdisc login.
  */
 void
@@ -1853,7 +1853,7 @@ bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
 }
 
-/**
+/*
  * Initiate a lport logout (flogi).
  */
 void
@@ -1862,7 +1862,7 @@ bfa_lps_flogo(struct bfa_lps_s *lps)
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
 }
 
-/**
+/*
  * Initiate a lport FDSIC logout.
  */
 void
@@ -1871,7 +1871,7 @@ bfa_lps_fdisclogo(struct bfa_lps_s *lps)
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
 }
 
-/**
+/*
  * Discard a pending login request -- should be called only for
  * link down handling.
  */
@@ -1881,7 +1881,7 @@ bfa_lps_discard(struct bfa_lps_s *lps)
 	bfa_sm_send_event(lps, BFA_LPS_SM_OFFLINE);
 }
 
-/**
+/*
  * Return lport services tag
  */
 u8
@@ -1890,7 +1890,7 @@ bfa_lps_get_tag(struct bfa_lps_s *lps)
 	return lps->lp_tag;
 }
 
-/**
+/*
  * Return lport services tag given the pid
  */
 u8
@@ -1909,7 +1909,7 @@ bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid)
 	return 0;
 }
 
-/**
+/*
  * return if fabric login indicates support for NPIV
  */
 bfa_boolean_t
@@ -1918,7 +1918,7 @@ bfa_lps_is_npiv_en(struct bfa_lps_s *lps)
 	return lps->npiv_en;
 }
 
-/**
+/*
  * Return TRUE if attached to F-Port, else return FALSE
  */
 bfa_boolean_t
@@ -1927,7 +1927,7 @@ bfa_lps_is_fport(struct bfa_lps_s *lps)
 	return lps->fport;
 }
 
-/**
+/*
  * Return TRUE if attached to a Brocade Fabric
  */
 bfa_boolean_t
@@ -1935,7 +1935,7 @@ bfa_lps_is_brcd_fabric(struct bfa_lps_s *lps)
 {
 	return lps->brcd_switch;
 }
-/**
+/*
  * return TRUE if authentication is required
  */
 bfa_boolean_t
@@ -1950,7 +1950,7 @@ bfa_lps_get_extstatus(struct bfa_lps_s *lps)
 	return lps->ext_status;
 }
 
-/**
+/*
  * return port id assigned to the lport
  */
 u32
@@ -1959,7 +1959,7 @@ bfa_lps_get_pid(struct bfa_lps_s *lps)
 	return lps->lp_pid;
 }
 
-/**
+/*
  * return port id assigned to the base lport
  */
 u32
@@ -1970,7 +1970,7 @@ bfa_lps_get_base_pid(struct bfa_s *bfa)
 	return BFA_LPS_FROM_TAG(mod, 0)->lp_pid;
 }
 
-/**
+/*
  * Return bb_credit assigned in FLOGI response
  */
 u16
@@ -1979,7 +1979,7 @@ bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps)
 	return lps->pr_bbcred;
 }
 
-/**
+/*
  * Return peer port name
  */
 wwn_t
@@ -1988,7 +1988,7 @@ bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps)
 	return lps->pr_pwwn;
 }
 
-/**
+/*
  * Return peer node name
  */
 wwn_t
@@ -1997,7 +1997,7 @@ bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps)
 	return lps->pr_nwwn;
 }
 
-/**
+/*
  * return reason code if login request is rejected
  */
 u8
@@ -2006,7 +2006,7 @@ bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps)
 	return lps->lsrjt_rsn;
 }
 
-/**
+/*
  * return explanation code if login request is rejected
  */
 u8
@@ -2015,7 +2015,7 @@ bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps)
 	return lps->lsrjt_expl;
 }
 
-/**
+/*
  * Return fpma/spma MAC for lport
  */
 mac_t
@@ -2024,7 +2024,7 @@ bfa_lps_get_lp_mac(struct bfa_lps_s *lps)
 	return lps->lp_mac;
 }
 
-/**
+/*
  * LPS firmware message class handler.
  */
 void
@@ -2054,7 +2054,7 @@ bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	}
 }
 
-/**
+/*
  * FC PORT state machine functions
  */
 static void
@@ -2065,7 +2065,7 @@ bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
 
 	switch (event) {
 	case BFA_FCPORT_SM_START:
-		/**
+		/*
 		 * Start event after IOC is configured and BFA is started.
 		 */
 		if (bfa_fcport_send_enable(fcport)) {
@@ -2079,7 +2079,7 @@ bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_ENABLE:
-		/**
+		/*
 		 * Port is persistently configured to be in enabled state. Do
 		 * not change state. Port enabling is done when START event is
 		 * received.
@@ -2087,7 +2087,7 @@ bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_DISABLE:
-		/**
+		/*
 		 * If a port is persistently configured to be disabled, the
 		 * first event will a port disable request.
 		 */
@@ -2123,13 +2123,13 @@ bfa_fcport_sm_enabling_qwait(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_ENABLE:
-		/**
+		/*
 		 * Already enable is in progress.
 		 */
 		break;
 
 	case BFA_FCPORT_SM_DISABLE:
-		/**
+		/*
 		 * Just send disable request to firmware when room becomes
 		 * available in request queue.
 		 */
@@ -2144,7 +2144,7 @@ bfa_fcport_sm_enabling_qwait(struct bfa_fcport_s *fcport,
 
 	case BFA_FCPORT_SM_LINKUP:
 	case BFA_FCPORT_SM_LINKDOWN:
-		/**
+		/*
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
@@ -2183,7 +2183,7 @@ bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_ENABLE:
-		/**
+		/*
 		 * Already being enabled.
 		 */
 		break;
@@ -2256,13 +2256,13 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_LINKDOWN:
-		/**
+		/*
 		 * Possible to get link down event.
 		 */
 		break;
 
 	case BFA_FCPORT_SM_ENABLE:
-		/**
+		/*
 		 * Already enabled.
 		 */
 		break;
@@ -2305,7 +2305,7 @@ bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
 
 	switch (event) {
 	case BFA_FCPORT_SM_ENABLE:
-		/**
+		/*
 		 * Already enabled.
 		 */
 		break;
@@ -2398,14 +2398,14 @@ bfa_fcport_sm_disabling_qwait(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_DISABLE:
-		/**
+		/*
 		 * Already being disabled.
 		 */
 		break;
 
 	case BFA_FCPORT_SM_LINKUP:
 	case BFA_FCPORT_SM_LINKDOWN:
-		/**
+		/*
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
@@ -2452,7 +2452,7 @@ bfa_fcport_sm_toggling_qwait(struct bfa_fcport_s *fcport,
 
 	case BFA_FCPORT_SM_LINKUP:
 	case BFA_FCPORT_SM_LINKDOWN:
-		/**
+		/*
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
@@ -2482,7 +2482,7 @@ bfa_fcport_sm_disabling(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_DISABLE:
-		/**
+		/*
 		 * Already being disabled.
 		 */
 		break;
@@ -2507,7 +2507,7 @@ bfa_fcport_sm_disabling(struct bfa_fcport_s *fcport,
 
 	case BFA_FCPORT_SM_LINKUP:
 	case BFA_FCPORT_SM_LINKDOWN:
-		/**
+		/*
 		 * Possible to get link events when doing back-to-back
 		 * enable/disables.
 		 */
@@ -2532,7 +2532,7 @@ bfa_fcport_sm_disabled(struct bfa_fcport_s *fcport,
 
 	switch (event) {
 	case BFA_FCPORT_SM_START:
-		/**
+		/*
 		 * Ignore start event for a port that is disabled.
 		 */
 		break;
@@ -2556,7 +2556,7 @@ bfa_fcport_sm_disabled(struct bfa_fcport_s *fcport,
 		break;
 
 	case BFA_FCPORT_SM_DISABLE:
-		/**
+		/*
 		 * Already disabled.
 		 */
 		break;
@@ -2586,14 +2586,14 @@ bfa_fcport_sm_stopped(struct bfa_fcport_s *fcport,
 		break;
 
 	default:
-		/**
+		/*
 		 * Ignore all other events.
 		 */
 		;
 	}
 }
 
-/**
+/*
  * Port is enabled. IOC is down/failed.
  */
 static void
@@ -2612,14 +2612,14 @@ bfa_fcport_sm_iocdown(struct bfa_fcport_s *fcport,
 		break;
 
 	default:
-		/**
+		/*
 		 * Ignore all events.
 		 */
 		;
 	}
 }
 
-/**
+/*
  * Port is disabled. IOC is down/failed.
  */
 static void
@@ -2638,14 +2638,14 @@ bfa_fcport_sm_iocfail(struct bfa_fcport_s *fcport,
 		break;
 
 	default:
-		/**
+		/*
 		 * Ignore all events.
 		 */
 		;
 	}
 }
 
-/**
+/*
  * Link state is down
  */
 static void
@@ -2665,7 +2665,7 @@ bfa_fcport_ln_sm_dn(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-/**
+/*
  * Link state is waiting for down notification
  */
 static void
@@ -2688,7 +2688,7 @@ bfa_fcport_ln_sm_dn_nf(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-/**
+/*
  * Link state is waiting for down notification and there is a pending up
  */
 static void
@@ -2712,7 +2712,7 @@ bfa_fcport_ln_sm_dn_up_nf(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-/**
+/*
  * Link state is up
  */
 static void
@@ -2732,7 +2732,7 @@ bfa_fcport_ln_sm_up(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-/**
+/*
  * Link state is waiting for up notification
  */
 static void
@@ -2755,7 +2755,7 @@ bfa_fcport_ln_sm_up_nf(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-/**
+/*
  * Link state is waiting for up notification and there is a pending down
  */
 static void
@@ -2779,7 +2779,7 @@ bfa_fcport_ln_sm_up_dn_nf(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-/**
+/*
  * Link state is waiting for up notification and there are pending down and up
  */
 static void
@@ -2805,7 +2805,7 @@ bfa_fcport_ln_sm_up_dn_up_nf(struct bfa_fcport_ln_s *ln,
 
 
 
-/**
+/*
  *  hal_port_private
  */
 
@@ -2820,7 +2820,7 @@ __bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete)
 		bfa_sm_send_event(ln, BFA_FCPORT_LN_SM_NOTIFICATION);
 }
 
-/**
+/*
  * Send SCN notification to upper layers.
  * trunk - false if caller is fcport to ignore fcport event in trunked mode
  */
@@ -2896,7 +2896,7 @@ bfa_fcport_mem_claim(struct bfa_fcport_s *fcport, struct bfa_meminfo_s *meminfo)
 	bfa_meminfo_dma_phys(meminfo) = dm_pa;
 }
 
-/**
+/*
  * Memory initialization.
  */
 static void
@@ -2917,13 +2917,13 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_sm_set_state(fcport, bfa_fcport_sm_uninit);
 	bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn);
 
-	/**
+	/*
 	 * initialize time stamp for stats reset
 	 */
 	bfa_os_gettimeofday(&tv);
 	fcport->stats_reset_time = tv.tv_sec;
 
-	/**
+	/*
 	 * initialize and set default configuration
 	 */
 	port_cfg->topology = BFA_PORT_TOPOLOGY_P2P;
@@ -2941,7 +2941,7 @@ bfa_fcport_detach(struct bfa_s *bfa)
 {
 }
 
-/**
+/*
  * Called when IOC is ready.
  */
 static void
@@ -2950,7 +2950,7 @@ bfa_fcport_start(struct bfa_s *bfa)
 	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_START);
 }
 
-/**
+/*
  * Called before IOC is stopped.
  */
 static void
@@ -2960,7 +2960,7 @@ bfa_fcport_stop(struct bfa_s *bfa)
 	bfa_trunk_iocdisable(bfa);
 }
 
-/**
+/*
  * Called when IOC failure is detected.
  */
 static void
@@ -2988,7 +2988,7 @@ bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 	fcport->qos_attr = pevent->link_state.qos_attr;
 	fcport->qos_vc_attr = pevent->link_state.vc_fcf.qos_vc_attr;
 
-	/**
+	/*
 	 * update trunk state if applicable
 	 */
 	if (!fcport->cfg.trunked)
@@ -3008,7 +3008,7 @@ bfa_fcport_reset_linkinfo(struct bfa_fcport_s *fcport)
 	fcport->topology = BFA_PORT_TOPOLOGY_NONE;
 }
 
-/**
+/*
  * Send port enable message to firmware.
  */
 static bfa_boolean_t
@@ -3016,13 +3016,13 @@ bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 {
 	struct bfi_fcport_enable_req_s *m;
 
-	/**
+	/*
 	 * Increment message tag before queue check, so that responses to old
 	 * requests are discarded.
 	 */
 	fcport->msgtag++;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
@@ -3043,14 +3043,14 @@ bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Send port disable message to firmware.
  */
 static	bfa_boolean_t
@@ -3058,13 +3058,13 @@ bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 {
 	struct bfi_fcport_req_s *m;
 
-	/**
+	/*
 	 * Increment message tag before queue check, so that responses to old
 	 * requests are discarded.
 	 */
 	fcport->msgtag++;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
@@ -3078,7 +3078,7 @@ bfa_fcport_send_disable(struct bfa_fcport_s *fcport)
 			bfa_lpuid(fcport->bfa));
 	m->msgtag = fcport->msgtag;
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
@@ -3103,7 +3103,7 @@ bfa_fcport_send_txcredit(void *port_cbarg)
 	struct bfa_fcport_s *fcport = port_cbarg;
 	struct bfi_fcport_set_svc_params_req_s *m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(fcport->bfa, BFA_REQQ_PORT);
@@ -3116,7 +3116,7 @@ bfa_fcport_send_txcredit(void *port_cbarg)
 			bfa_lpuid(fcport->bfa));
 	m->tx_bbcredit = cpu_to_be16((u16)fcport->cfg.tx_bbcredit);
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
@@ -3235,7 +3235,7 @@ __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete)
 	if (complete) {
 		struct bfa_timeval_s tv;
 
-		/**
+		/*
 		 * re-initialize time stamp for stats reset
 		 */
 		bfa_os_gettimeofday(&tv);
@@ -3289,7 +3289,7 @@ bfa_fcport_send_stats_clear(void *cbarg)
 	bfa_reqq_produce(fcport->bfa, BFA_REQQ_PORT);
 }
 
-/**
+/*
  * Handle trunk SCN event from firmware.
  */
 static void
@@ -3310,7 +3310,7 @@ bfa_trunk_scn(struct bfa_fcport_s *fcport, struct bfi_fcport_trunk_scn_s *scn)
 	bfa_trc(fcport->bfa, scn->trunk_state);
 	bfa_trc(fcport->bfa, scn->trunk_speed);
 
-	/**
+	/*
 	 * Save off new state for trunk attribute query
 	 */
 	state_prev = trunk->attr.state;
@@ -3358,7 +3358,7 @@ bfa_trunk_scn(struct bfa_fcport_s *fcport, struct bfi_fcport_trunk_scn_s *scn)
 			BFA_PL_EID_TRUNK_SCN, 0, "Trunk down");
 	}
 
-	/**
+	/*
 	 * Notify upper layers if trunk state changed.
 	 */
 	if ((state_prev != trunk->attr.state) ||
@@ -3374,7 +3374,7 @@ bfa_trunk_iocdisable(struct bfa_s *bfa)
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	int i = 0;
 
-	/**
+	/*
 	 * In trunked mode, notify upper layers that link is down
 	 */
 	if (fcport->cfg.trunked) {
@@ -3398,11 +3398,11 @@ bfa_trunk_iocdisable(struct bfa_s *bfa)
 
 
 
-/**
+/*
  *  hal_port_public
  */
 
-/**
+/*
  * Called to initialize port attributes
  */
 void
@@ -3410,7 +3410,7 @@ bfa_fcport_init(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 
-	/**
+	/*
 	 * Initialize port attributes from IOC hardware data.
 	 */
 	bfa_fcport_set_wwns(fcport);
@@ -3424,7 +3424,7 @@ bfa_fcport_init(struct bfa_s *bfa)
 	bfa_assert(fcport->speed_sup);
 }
 
-/**
+/*
  * Firmware message handler.
  */
 void
@@ -3505,11 +3505,11 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 
 
 
-/**
+/*
  *  hal_port_api
  */
 
-/**
+/*
  * Registered callback for port events.
  */
 void
@@ -3550,7 +3550,7 @@ bfa_fcport_disable(struct bfa_s *bfa)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Configure port speed.
  */
 bfa_status_t
@@ -3572,7 +3572,7 @@ bfa_fcport_cfg_speed(struct bfa_s *bfa, enum bfa_port_speed speed)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Get current speed.
  */
 enum bfa_port_speed
@@ -3583,7 +3583,7 @@ bfa_fcport_get_speed(struct bfa_s *bfa)
 	return fcport->speed;
 }
 
-/**
+/*
  * Configure port topology.
  */
 bfa_status_t
@@ -3608,7 +3608,7 @@ bfa_fcport_cfg_topology(struct bfa_s *bfa, enum bfa_port_topology topology)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Get current topology.
  */
 enum bfa_port_topology
@@ -3708,7 +3708,7 @@ bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
 	bfa_fcport_send_txcredit(fcport);
 }
 
-/**
+/*
  * Get port attributes.
  */
 
@@ -3768,7 +3768,7 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 
 #define BFA_FCPORT_STATS_TOV	1000
 
-/**
+/*
  * Fetch port statistics (FCQoS or FCoE).
  */
 bfa_status_t
@@ -3794,7 +3794,7 @@ bfa_fcport_get_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Reset port statistics (FCQoS or FCoE).
  */
 bfa_status_t
@@ -3818,7 +3818,7 @@ bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn, void *cbarg)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Fetch FCQoS port statistics
  */
 bfa_status_t
@@ -3831,7 +3831,7 @@ bfa_fcport_get_qos_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
 	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
 }
 
-/**
+/*
  * Reset FCoE port statistics
  */
 bfa_status_t
@@ -3843,7 +3843,7 @@ bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_port_t cbfn, void *cbarg)
 	return bfa_fcport_clear_stats(bfa, cbfn, cbarg);
 }
 
-/**
+/*
  * Fetch FCQoS port statistics
  */
 bfa_status_t
@@ -3856,7 +3856,7 @@ bfa_fcport_get_fcoe_stats(struct bfa_s *bfa, union bfa_fcport_stats_u *stats,
 	return bfa_fcport_get_stats(bfa, stats, cbfn, cbarg);
 }
 
-/**
+/*
  * Reset FCoE port statistics
  */
 bfa_status_t
@@ -3902,7 +3902,7 @@ bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 	}
 }
 
-/**
+/*
  * Fetch port attributes.
  */
 bfa_boolean_t
@@ -3937,7 +3937,7 @@ bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
 
 	if (ioc_type == BFA_IOC_TYPE_FC) {
 		fcport->cfg.qos_enabled = on_off;
-		/**
+		/*
 		 * Notify fcpim of the change in QoS state
 		 */
 		bfa_fcpim_update_ioredirect(bfa);
@@ -3957,7 +3957,7 @@ bfa_fcport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off)
 		fcport->cfg.trl_def_speed = BFA_PORT_SPEED_1GBPS;
 }
 
-/**
+/*
  * Configure default minimum ratelim speed
  */
 bfa_status_t
@@ -3978,7 +3978,7 @@ bfa_fcport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_port_speed speed)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Get default minimum ratelim speed
  */
 enum bfa_port_speed
@@ -4093,10 +4093,10 @@ bfa_trunk_disable(struct bfa_s *bfa)
 }
 
 
-/**
+/*
  * Rport State machine functions
  */
-/**
+/*
  * Beginning state, only online event expected.
  */
 static void
@@ -4149,7 +4149,7 @@ bfa_rport_sm_created(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Waiting for rport create response from firmware.
  */
 static void
@@ -4186,7 +4186,7 @@ bfa_rport_sm_fwcreate(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Request queue is full, awaiting queue resume to send create request.
  */
 static void
@@ -4227,7 +4227,7 @@ bfa_rport_sm_fwcreate_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Online state - normal parking state.
  */
 static void
@@ -4295,7 +4295,7 @@ bfa_rport_sm_online(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Firmware rport is being deleted - awaiting f/w response.
  */
 static void
@@ -4358,7 +4358,7 @@ bfa_rport_sm_fwdelete_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Offline state.
  */
 static void
@@ -4393,7 +4393,7 @@ bfa_rport_sm_offline(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Rport is deleted, waiting for firmware response to delete.
  */
 static void
@@ -4445,7 +4445,7 @@ bfa_rport_sm_deleting_qfull(struct bfa_rport_s *rp, enum bfa_rport_event event)
 	}
 }
 
-/**
+/*
  * Waiting for rport create response from firmware. A delete is pending.
  */
 static void
@@ -4476,7 +4476,7 @@ bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
 	}
 }
 
-/**
+/*
  * Waiting for rport create response from firmware. Rport offline is pending.
  */
 static void
@@ -4511,7 +4511,7 @@ bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
 	}
 }
 
-/**
+/*
  * IOC h/w failed.
  */
 static void
@@ -4551,7 +4551,7 @@ bfa_rport_sm_iocdisable(struct bfa_rport_s *rp, enum bfa_rport_event event)
 
 
 
-/**
+/*
  *  bfa_rport_private BFA rport private functions
  */
 
@@ -4615,7 +4615,7 @@ bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		rp->rport_tag = i;
 		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
 
-		/**
+		/*
 		 *  - is unused
 		 */
 		if (i)
@@ -4624,7 +4624,7 @@ bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		bfa_reqq_winit(&rp->reqq_wait, bfa_rport_qresume, rp);
 	}
 
-	/**
+	/*
 	 * consume memory
 	 */
 	bfa_meminfo_kva(meminfo) = (u8 *) rp;
@@ -4685,7 +4685,7 @@ bfa_rport_send_fwcreate(struct bfa_rport_s *rp)
 {
 	struct bfi_rport_create_req_s *m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
@@ -4706,7 +4706,7 @@ bfa_rport_send_fwcreate(struct bfa_rport_s *rp)
 	m->vf_id = rp->rport_info.vf_id;
 	m->cisc = rp->rport_info.cisc;
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
@@ -4718,7 +4718,7 @@ bfa_rport_send_fwdelete(struct bfa_rport_s *rp)
 {
 	struct bfi_rport_delete_req_s *m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
@@ -4731,7 +4731,7 @@ bfa_rport_send_fwdelete(struct bfa_rport_s *rp)
 			bfa_lpuid(rp->bfa));
 	m->fw_handle = rp->fw_handle;
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
@@ -4743,7 +4743,7 @@ bfa_rport_send_fwspeed(struct bfa_rport_s *rp)
 {
 	struct bfa_rport_speed_req_s *m;
 
-	/**
+	/*
 	 * check for room in queue to send request now
 	 */
 	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
@@ -4757,7 +4757,7 @@ bfa_rport_send_fwspeed(struct bfa_rport_s *rp)
 	m->fw_handle = rp->fw_handle;
 	m->speed = (u8)rp->rport_info.speed;
 
-	/**
+	/*
 	 * queue I/O message to firmware
 	 */
 	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
@@ -4766,11 +4766,11 @@ bfa_rport_send_fwspeed(struct bfa_rport_s *rp)
 
 
 
-/**
+/*
  *  bfa_rport_public
  */
 
-/**
+/*
  * Rport interrupt processing.
  */
 void
@@ -4812,7 +4812,7 @@ bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 
 
 
-/**
+/*
  *  bfa_rport_api
  */
 
@@ -4847,7 +4847,7 @@ bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
 {
 	bfa_assert(rport_info->max_frmsz != 0);
 
-	/**
+	/*
 	 * Some JBODs are seen to be not setting PDU size correctly in PLOGI
 	 * responses. Default to minimum size.
 	 */
@@ -4899,11 +4899,11 @@ bfa_rport_clear_stats(struct bfa_rport_s *rport)
 }
 
 
-/**
+/*
  * SGPG related functions
  */
 
-/**
+/*
  * Compute and return memory needed by FCP(im) module.
  */
 static void
@@ -4995,7 +4995,7 @@ bfa_sgpg_iocdisable(struct bfa_s *bfa)
 
 
 
-/**
+/*
  *  hal_sgpg_public BFA SGPG public functions
  */
 
@@ -5037,7 +5037,7 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
 	if (list_empty(&mod->sgpg_wait_q))
 		return;
 
-	/**
+	/*
 	 * satisfy as many waiting requests as possible
 	 */
 	do {
@@ -5065,11 +5065,11 @@ bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe, int nsgpg)
 
 	wqe->nsgpg_total = wqe->nsgpg = nsgpg;
 
-	/**
+	/*
 	 * allocate any left to this one first
 	 */
 	if (mod->free_sgpgs) {
-		/**
+		/*
 		 * no one else is waiting for SGPG
 		 */
 		bfa_assert(list_empty(&mod->sgpg_wait_q));
@@ -5103,7 +5103,7 @@ bfa_sgpg_winit(struct bfa_sgpg_wqe_s *wqe, void (*cbfn) (void *cbarg),
 	wqe->cbarg = cbarg;
 }
 
-/**
+/*
  *  UF related functions
  */
 /*
@@ -5171,7 +5171,7 @@ claim_uf_post_msgs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
 		bfa_sge_to_be(&sge[1]);
 	}
 
-	/**
+	/*
 	 * advance pointer beyond consumed memory
 	 */
 	bfa_meminfo_kva(mi) = (u8 *) uf_bp_msg;
@@ -5201,7 +5201,7 @@ claim_ufs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
 		list_add_tail(&uf->qe, &ufm->uf_free_q);
 	}
 
-	/**
+	/*
 	 * advance memory pointer
 	 */
 	bfa_meminfo_kva(mi) = (u8 *) uf;
@@ -5363,11 +5363,11 @@ bfa_uf_start(struct bfa_s *bfa)
 
 
 
-/**
+/*
  *  hal_uf_api
  */
 
-/**
+/*
  * Register handler for all unsolicted recieve frames.
  *
  * @param[in]	bfa		BFA instance
@@ -5383,7 +5383,7 @@ bfa_uf_recv_register(struct bfa_s *bfa, bfa_cb_uf_recv_t ufrecv, void *cbarg)
 	ufm->cbarg = cbarg;
 }
 
-/**
+/*
  *	Free an unsolicited frame back to BFA.
  *
  * @param[in]		uf		unsolicited frame to be freed
@@ -5399,7 +5399,7 @@ bfa_uf_free(struct bfa_uf_s *uf)
 
 
 
-/**
+/*
  *  uf_pub BFA uf module public functions
  */
 void
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 79f8b86..1f93897 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  bfad.c Linux driver PCI interface module.
  */
 #include <linux/module.h>
@@ -151,7 +151,7 @@ bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event event);
 static void
 bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event event);
 
-/**
+/*
  * Beginning state for the driver instance, awaiting the pci_probe event
  */
 static void
@@ -181,7 +181,7 @@ bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event event)
 	}
 }
 
-/**
+/*
  * Driver Instance is created, awaiting event INIT to initialize the bfad
  */
 static void
@@ -364,7 +364,7 @@ bfad_sm_stopping(struct bfad_s *bfad, enum bfad_sm_event event)
 	}
 }
 
-/**
+/*
  *  BFA callbacks
  */
 void
@@ -376,7 +376,7 @@ bfad_hcb_comp(void *arg, bfa_status_t status)
 	complete(&fcomp->comp);
 }
 
-/**
+/*
  * bfa_init callback
  */
 void
@@ -401,7 +401,7 @@ bfa_cb_init(void *drv, bfa_status_t init_status)
 	complete(&bfad->comp);
 }
 
-/**
+/*
  *  BFA_FCS callbacks
  */
 struct bfad_port_s *
@@ -457,7 +457,7 @@ bfa_fcb_lport_delete(struct bfad_s *bfad, enum bfa_lport_role roles,
 	}
 }
 
-/**
+/*
  * FCS RPORT alloc callback, after successful PLOGI by FCS
  */
 bfa_status_t
@@ -478,7 +478,7 @@ ext:
 	return rc;
 }
 
-/**
+/*
  * FCS PBC VPORT Create
  */
 void
@@ -663,7 +663,7 @@ ext:
 	return rc;
 }
 
-/**
+/*
  * Create a vport under a vf.
  */
 bfa_status_t
@@ -1140,7 +1140,7 @@ bfad_worker(void *ptr)
 	return 0;
 }
 
-/**
+/*
  *  BFA driver interrupt functions
  */
 irqreturn_t
@@ -1199,7 +1199,7 @@ bfad_msix(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/**
+/*
  * Initialize the MSIX entry table.
  */
 static void
@@ -1252,7 +1252,7 @@ bfad_install_msix_handler(struct bfad_s *bfad)
 	return 0;
 }
 
-/**
+/*
  * Setup MSIX based interrupt.
  */
 int
@@ -1333,7 +1333,7 @@ bfad_remove_intr(struct bfad_s *bfad)
 	}
 }
 
-/**
+/*
  * PCI probe entry.
  */
 int
@@ -1419,7 +1419,7 @@ out:
 	return error;
 }
 
-/**
+/*
  * PCI remove entry.
  */
 void
@@ -1500,7 +1500,7 @@ static struct pci_driver bfad_pci_driver = {
 	.remove = __devexit_p(bfad_pci_remove),
 };
 
-/**
+/*
  * Driver module init.
  */
 static int __init
@@ -1540,7 +1540,7 @@ ext:
 	return error;
 }
 
-/**
+/*
  * Driver module exit.
  */
 static void __exit
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 27dd06f..ed9fff4 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -15,14 +15,14 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  bfa_attr.c Linux driver configuration interface module.
  */
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
 
-/**
+/*
  * FC transport template entry, get SCSI target port ID.
  */
 void
@@ -48,7 +48,7 @@ bfad_im_get_starget_port_id(struct scsi_target *starget)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-/**
+/*
  * FC transport template entry, get SCSI target nwwn.
  */
 void
@@ -74,7 +74,7 @@ bfad_im_get_starget_node_name(struct scsi_target *starget)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-/**
+/*
  * FC transport template entry, get SCSI target pwwn.
  */
 void
@@ -100,7 +100,7 @@ bfad_im_get_starget_port_name(struct scsi_target *starget)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-/**
+/*
  * FC transport template entry, get SCSI host port ID.
  */
 void
@@ -114,7 +114,7 @@ bfad_im_get_host_port_id(struct Scsi_Host *shost)
 			bfa_os_hton3b(bfa_fcs_lport_get_fcid(port->fcs_port));
 }
 
-/**
+/*
  * FC transport template entry, get SCSI host port type.
  */
 static void
@@ -146,7 +146,7 @@ bfad_im_get_host_port_type(struct Scsi_Host *shost)
 	}
 }
 
-/**
+/*
  * FC transport template entry, get SCSI host port state.
  */
 static void
@@ -183,7 +183,7 @@ bfad_im_get_host_port_state(struct Scsi_Host *shost)
 	}
 }
 
-/**
+/*
  * FC transport template entry, get SCSI host active fc4s.
  */
 static void
@@ -202,7 +202,7 @@ bfad_im_get_host_active_fc4s(struct Scsi_Host *shost)
 	fc_host_active_fc4s(shost)[7] = 1;
 }
 
-/**
+/*
  * FC transport template entry, get SCSI host link speed.
  */
 static void
@@ -236,7 +236,7 @@ bfad_im_get_host_speed(struct Scsi_Host *shost)
 	}
 }
 
-/**
+/*
  * FC transport template entry, get SCSI host port type.
  */
 static void
@@ -253,7 +253,7 @@ bfad_im_get_host_fabric_name(struct Scsi_Host *shost)
 
 }
 
-/**
+/*
  * FC transport template entry, get BFAD statistics.
  */
 static struct fc_host_statistics *
@@ -304,7 +304,7 @@ bfad_im_get_stats(struct Scsi_Host *shost)
 	return hstats;
 }
 
-/**
+/*
  * FC transport template entry, reset BFAD statistics.
  */
 static void
@@ -331,7 +331,7 @@ bfad_im_reset_stats(struct Scsi_Host *shost)
 	return;
 }
 
-/**
+/*
  * FC transport template entry, get rport loss timeout.
  */
 static void
@@ -347,7 +347,7 @@ bfad_im_get_rport_loss_tmo(struct fc_rport *rport)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-/**
+/*
  * FC transport template entry, set rport loss timeout.
  */
 static void
@@ -633,7 +633,7 @@ struct fc_function_template bfad_im_vport_fc_function_template = {
 	.set_rport_dev_loss_tmo = bfad_im_set_rport_loss_tmo,
 };
 
-/**
+/*
  *  Scsi_Host_attrs SCSI host attributes
  */
 static ssize_t
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 7a6f48b..8daa716 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -15,7 +15,7 @@
  * General Public License for more details.
  */
 
-/**
+/*
  *  bfad_im.c Linux driver IM module.
  */
 
@@ -164,10 +164,10 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 		wake_up(wq);
 }
 
-/**
+/*
  *  Scsi_Host_template SCSI host template
  */
-/**
+/*
  * Scsi_Host template entry, returns BFAD PCI info.
  */
 static const char *
@@ -196,7 +196,7 @@ bfad_im_info(struct Scsi_Host *shost)
 	return bfa_buf;
 }
 
-/**
+/*
  * Scsi_Host template entry, aborts the specified SCSI command.
  *
  * Returns: SUCCESS or FAILED.
@@ -280,7 +280,7 @@ out:
 	return rc;
 }
 
-/**
+/*
  * Scsi_Host template entry, resets a LUN and abort its all commands.
  *
  * Returns: SUCCESS or FAILED.
@@ -319,7 +319,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 		goto out;
 	}
 
-	/**
+	/*
 	 * Set host_scribble to NULL to avoid aborting a task command
 	 * if happens.
 	 */
@@ -346,7 +346,7 @@ out:
 	return rc;
 }
 
-/**
+/*
  * Scsi_Host template entry, resets the bus and abort all commands.
  */
 static int
@@ -396,7 +396,7 @@ bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
 	return SUCCESS;
 }
 
-/**
+/*
  * Scsi_Host template entry slave_destroy.
  */
 static void
@@ -406,11 +406,11 @@ bfad_im_slave_destroy(struct scsi_device *sdev)
 	return;
 }
 
-/**
+/*
  *  BFA FCS itnim callbacks
  */
 
-/**
+/*
  * BFA FCS itnim alloc callback, after successful PRLI
  * Context: Interrupt
  */
@@ -433,7 +433,7 @@ bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
 	bfad->bfad_flags |= BFAD_RPORT_ONLINE;
 }
 
-/**
+/*
  * BFA FCS itnim free callback.
  * Context: Interrupt. bfad_lock is held
  */
@@ -471,7 +471,7 @@ bfa_fcb_itnim_free(struct bfad_s *bfad, struct bfad_itnim_s *itnim_drv)
 		queue_work(im->drv_workq, &itnim_drv->itnim_work);
 }
 
-/**
+/*
  * BFA FCS itnim online callback.
  * Context: Interrupt. bfad_lock is held
  */
@@ -492,7 +492,7 @@ bfa_fcb_itnim_online(struct bfad_itnim_s *itnim_drv)
 		queue_work(im->drv_workq, &itnim_drv->itnim_work);
 }
 
-/**
+/*
  * BFA FCS itnim offline callback.
  * Context: Interrupt. bfad_lock is held
  */
@@ -519,7 +519,7 @@ bfa_fcb_itnim_offline(struct bfad_itnim_s *itnim_drv)
 		queue_work(im->drv_workq, &itnim_drv->itnim_work);
 }
 
-/**
+/*
  * Allocate a Scsi_Host for a port.
  */
 int
@@ -751,7 +751,7 @@ bfad_os_thread_workq(struct bfad_s *bfad)
 	return BFA_STATUS_OK;
 }
 
-/**
+/*
  * Scsi_Host template entry.
  *
  * Description:
@@ -896,7 +896,7 @@ bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id)
 	return NULL;
 }
 
-/**
+/*
  * Scsi_Host template entry slave_alloc
  */
 static int
@@ -973,7 +973,7 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	sprintf(fc_host_symbolic_name(host), "%s", symname);
 
 	fc_host_supported_speeds(host) = bfad_im_supported_speeds(&bfad->bfa);
-	fc_host_maxframe_size(host) = fcport->cfg.maxfrsize;  
+	fc_host_maxframe_size(host) = fcport->cfg.maxfrsize;
 }
 
 static void
@@ -1016,7 +1016,7 @@ bfad_im_fc_rport_add(struct bfad_im_port_s *im_port, struct bfad_itnim_s *itnim)
 	return;
 }
 
-/**
+/*
  * Work queue handler using FC transport service
 * Context: kernel
  */
@@ -1116,7 +1116,7 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-/**
+/*
  * Scsi_Host template entry, queue a SCSI command to the BFAD.
  */
 static int
-- 
1.6.5.2

