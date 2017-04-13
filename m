From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] bfa: remove bfa_module_s madness
Date: Thu, 13 Apr 2017 10:02:56 +0200
Message-ID: <20170413080256.12451-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39729 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdDMIDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 04:03:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com
Cc: keescook@chromium.org, linux-scsi@vger.kernel.org

Just call the functions directly and remove a giant pile of boilerplate code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/bfa/bfa_core.c    |  66 ++++++++--------
 drivers/scsi/bfa/bfa_fcpim.c   |  37 ++-------
 drivers/scsi/bfa/bfa_ioc.c     |  30 ++-----
 drivers/scsi/bfa/bfa_modules.h | 101 +++++++++++-------------
 drivers/scsi/bfa/bfa_svc.c     | 172 +++++------------------------------------
 5 files changed, 108 insertions(+), 298 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 7209afad82f7..3e1caec82554 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -23,22 +23,6 @@
 BFA_TRC_FILE(HAL, CORE);
 
 /*
- * BFA module list terminated by NULL
- */
-static struct bfa_module_s *hal_mods[] = {
-	&hal_mod_fcdiag,
-	&hal_mod_sgpg,
-	&hal_mod_fcport,
-	&hal_mod_fcxp,
-	&hal_mod_lps,
-	&hal_mod_uf,
-	&hal_mod_rport,
-	&hal_mod_fcp,
-	&hal_mod_dconf,
-	NULL
-};
-
-/*
  * Message handlers for various modules.
  */
 static bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
@@ -1191,8 +1175,13 @@ bfa_iocfc_start_submod(struct bfa_s *bfa)
 	for (i = 0; i < BFI_IOC_MAX_CQS; i++)
 		bfa_isr_rspq_ack(bfa, i, bfa_rspq_ci(bfa, i));
 
-	for (i = 0; hal_mods[i]; i++)
-		hal_mods[i]->start(bfa);
+	bfa_fcport_start(bfa);
+	bfa_uf_start(bfa);
+	/*
+	 * bfa_init() with flash read is complete. now invalidate the stale
+	 * content of lun mask like unit attention, rp tag and lp tag.
+	 */
+	bfa_ioim_lm_init(BFA_FCP_MOD(bfa)->bfa);
 
 	bfa->iocfc.submod_enabled = BFA_TRUE;
 }
@@ -1203,13 +1192,16 @@ bfa_iocfc_start_submod(struct bfa_s *bfa)
 static void
 bfa_iocfc_disable_submod(struct bfa_s *bfa)
 {
-	int		i;
-
 	if (bfa->iocfc.submod_enabled == BFA_FALSE)
 		return;
 
-	for (i = 0; hal_mods[i]; i++)
-		hal_mods[i]->iocdisable(bfa);
+	bfa_fcdiag_iocdisable(bfa);
+	bfa_fcport_iocdisable(bfa);
+	bfa_fcxp_iocdisable(bfa);
+	bfa_lps_iocdisable(bfa);
+	bfa_rport_iocdisable(bfa);
+	bfa_fcp_iocdisable(bfa);
+	bfa_dconf_iocdisable(bfa);
 
 	bfa->iocfc.submod_enabled = BFA_FALSE;
 }
@@ -1773,7 +1765,6 @@ void
 bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 		struct bfa_s *bfa)
 {
-	int		i;
 	struct bfa_mem_dma_s *port_dma = BFA_MEM_PORT_DMA(bfa);
 	struct bfa_mem_dma_s *ablk_dma = BFA_MEM_ABLK_DMA(bfa);
 	struct bfa_mem_dma_s *cee_dma = BFA_MEM_CEE_DMA(bfa);
@@ -1792,9 +1783,14 @@ bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 	INIT_LIST_HEAD(&meminfo->kva_info.qe);
 
 	bfa_iocfc_meminfo(cfg, meminfo, bfa);
-
-	for (i = 0; hal_mods[i]; i++)
-		hal_mods[i]->meminfo(cfg, meminfo, bfa);
+	bfa_sgpg_meminfo(cfg, meminfo, bfa);
+	bfa_fcport_meminfo(cfg, meminfo, bfa);
+	bfa_fcxp_meminfo(cfg, meminfo, bfa);
+	bfa_lps_meminfo(cfg, meminfo, bfa);
+	bfa_uf_meminfo(cfg, meminfo, bfa);
+	bfa_rport_meminfo(cfg, meminfo, bfa);
+	bfa_fcp_meminfo(cfg, meminfo, bfa);
+	bfa_dconf_meminfo(cfg, meminfo, bfa);
 
 	/* dma info setup */
 	bfa_mem_dma_setup(meminfo, port_dma, bfa_port_meminfo());
@@ -1840,7 +1836,6 @@ void
 bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	       struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
 {
-	int	i;
 	struct bfa_mem_dma_s *dma_info, *dma_elem;
 	struct bfa_mem_kva_s *kva_info, *kva_elem;
 	struct list_head *dm_qe, *km_qe;
@@ -1869,10 +1864,15 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	}
 
 	bfa_iocfc_attach(bfa, bfad, cfg, pcidev);
-
-	for (i = 0; hal_mods[i]; i++)
-		hal_mods[i]->attach(bfa, bfad, cfg, pcidev);
-
+	bfa_fcdiag_attach(bfa, bfad, cfg, pcidev);
+	bfa_sgpg_attach(bfa, bfad, cfg, pcidev);
+	bfa_fcport_attach(bfa, bfad, cfg, pcidev);
+	bfa_fcxp_attach(bfa, bfad, cfg, pcidev);
+	bfa_lps_attach(bfa, bfad, cfg, pcidev);
+	bfa_uf_attach(bfa, bfad, cfg, pcidev);
+	bfa_rport_attach(bfa, bfad, cfg, pcidev);
+	bfa_fcp_attach(bfa, bfad, cfg, pcidev);
+	bfa_dconf_attach(bfa, bfad, cfg);
 	bfa_com_port_attach(bfa);
 	bfa_com_ablk_attach(bfa);
 	bfa_com_cee_attach(bfa);
@@ -1899,10 +1899,6 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 void
 bfa_detach(struct bfa_s *bfa)
 {
-	int	i;
-
-	for (i = 0; hal_mods[i]; i++)
-		hal_mods[i]->detach(bfa);
 	bfa_ioc_detach(&bfa->ioc);
 }
 
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 20982e7cdd81..5f53b3276234 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -25,7 +25,6 @@ BFA_TRC_FILE(HAL, FCPIM);
  *  BFA ITNIM Related definitions
  */
 static void bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim);
-static void bfa_ioim_lm_init(struct bfa_s *bfa);
 
 #define BFA_ITNIM_FROM_TAG(_fcpim, _tag)                                \
 	(((_fcpim)->itnim_arr + ((_tag) & ((_fcpim)->num_itnims - 1))))
@@ -339,7 +338,7 @@ bfa_fcpim_attach(struct bfa_fcp_mod_s *fcp, void *bfad,
 	bfa_ioim_attach(fcpim);
 }
 
-static void
+void
 bfa_fcpim_iocdisable(struct bfa_fcp_mod_s *fcp)
 {
 	struct bfa_fcpim_s *fcpim = &fcp->fcpim;
@@ -2105,7 +2104,7 @@ bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
  * is complete by driver. now invalidate the stale content of lun mask
  * like unit attention, rp tag and lp tag.
  */
-static void
+void
 bfa_ioim_lm_init(struct bfa_s *bfa)
 {
 	struct bfa_lun_mask_s *lunm_list;
@@ -3634,11 +3633,7 @@ bfa_tskim_res_recfg(struct bfa_s *bfa, u16 num_tskim_fw)
 	}
 }
 
-/* BFA FCP module - parent module for fcpim */
-
-BFA_MODULE(fcp);
-
-static void
+void
 bfa_fcp_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		struct bfa_s *bfa)
 {
@@ -3696,7 +3691,7 @@ bfa_fcp_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 	bfa_mem_kva_setup(minfo, fcp_kva, km_len);
 }
 
-static void
+void
 bfa_fcp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -3739,29 +3734,7 @@ bfa_fcp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 			(fcp->num_itns * sizeof(struct bfa_itn_s)));
 }
 
-static void
-bfa_fcp_detach(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_fcp_start(struct bfa_s *bfa)
-{
-	struct bfa_fcp_mod_s *fcp = BFA_FCP_MOD(bfa);
-
-	/*
-	 * bfa_init() with flash read is complete. now invalidate the stale
-	 * content of lun mask like unit attention, rp tag and lp tag.
-	 */
-	bfa_ioim_lm_init(fcp->bfa);
-}
-
-static void
-bfa_fcp_stop(struct bfa_s *bfa)
-{
-}
-
-static void
+void
 bfa_fcp_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_fcp_mod_s *fcp = BFA_FCP_MOD(bfa);
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a1ada4a31c97..256f4afaccf9 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -5822,12 +5822,6 @@ bfa_phy_intr(void *phyarg, struct bfi_mbmsg_s *msg)
 }
 
 /*
- *	DCONF module specific
- */
-
-BFA_MODULE(dconf);
-
-/*
  * DCONF state machine events
  */
 enum bfa_dconf_event {
@@ -6073,7 +6067,7 @@ bfa_dconf_sm_iocdown_dirty(struct bfa_dconf_mod_s *dconf,
 /*
  * Compute and return memory needed by DRV_CFG module.
  */
-static void
+void
 bfa_dconf_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 		  struct bfa_s *bfa)
 {
@@ -6087,9 +6081,8 @@ bfa_dconf_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 				sizeof(struct bfa_dconf_s));
 }
 
-static void
-bfa_dconf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+void
+bfa_dconf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_dconf_mod_s *dconf = BFA_DCONF_MOD(bfa);
 
@@ -6134,33 +6127,20 @@ bfa_dconf_modinit(struct bfa_s *bfa)
 	struct bfa_dconf_mod_s *dconf = BFA_DCONF_MOD(bfa);
 	bfa_sm_send_event(dconf, BFA_DCONF_SM_INIT);
 }
-static void
-bfa_dconf_start(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_dconf_stop(struct bfa_s *bfa)
-{
-}
 
 static void bfa_dconf_timer(void *cbarg)
 {
 	struct bfa_dconf_mod_s *dconf = cbarg;
 	bfa_sm_send_event(dconf, BFA_DCONF_SM_TIMEOUT);
 }
-static void
+
+void
 bfa_dconf_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_dconf_mod_s *dconf = BFA_DCONF_MOD(bfa);
 	bfa_sm_send_event(dconf, BFA_DCONF_SM_IOCDISABLE);
 }
 
-static void
-bfa_dconf_detach(struct bfa_s *bfa)
-{
-}
-
 static bfa_status_t
 bfa_dconf_flash_write(struct bfa_dconf_mod_s *dconf)
 {
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 53135f21fa0e..1c2ab395e616 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -61,54 +61,8 @@ enum {
 	BFA_TRC_HAL_IOCFC_CB	= 5,
 };
 
-/*
- * Macro to define a new BFA module
- */
-#define BFA_MODULE(__mod)						\
-	static void bfa_ ## __mod ## _meminfo(				\
-			struct bfa_iocfc_cfg_s *cfg,			\
-			struct bfa_meminfo_s *meminfo,			\
-			struct bfa_s *bfa);				\
-	static void bfa_ ## __mod ## _attach(struct bfa_s *bfa,		\
-			void *bfad, struct bfa_iocfc_cfg_s *cfg,	\
-			struct bfa_pcidev_s *pcidev);      \
-	static void bfa_ ## __mod ## _detach(struct bfa_s *bfa);      \
-	static void bfa_ ## __mod ## _start(struct bfa_s *bfa);      \
-	static void bfa_ ## __mod ## _stop(struct bfa_s *bfa);      \
-	static void bfa_ ## __mod ## _iocdisable(struct bfa_s *bfa);      \
-									\
-	extern struct bfa_module_s hal_mod_ ## __mod;			\
-	struct bfa_module_s hal_mod_ ## __mod = {			\
-		bfa_ ## __mod ## _meminfo,				\
-		bfa_ ## __mod ## _attach,				\
-		bfa_ ## __mod ## _detach,				\
-		bfa_ ## __mod ## _start,				\
-		bfa_ ## __mod ## _stop,					\
-		bfa_ ## __mod ## _iocdisable,				\
-	}
-
 #define BFA_CACHELINE_SZ	(256)
 
-/*
- * Structure used to interact between different BFA sub modules
- *
- * Each sub module needs to implement only the entry points relevant to it (and
- * can leave entry points as NULL)
- */
-struct bfa_module_s {
-	void (*meminfo) (struct bfa_iocfc_cfg_s *cfg,
-			 struct bfa_meminfo_s *meminfo,
-			 struct bfa_s *bfa);
-	void (*attach) (struct bfa_s *bfa, void *bfad,
-			struct bfa_iocfc_cfg_s *cfg,
-			struct bfa_pcidev_s *pcidev);
-	void (*detach) (struct bfa_s *bfa);
-	void (*start) (struct bfa_s *bfa);
-	void (*stop) (struct bfa_s *bfa);
-	void (*iocdisable) (struct bfa_s *bfa);
-};
-
-
 struct bfa_s {
 	void			*bfad;		/*  BFA driver instance    */
 	struct bfa_plog_s	*plog;		/*  portlog buffer	    */
@@ -127,14 +81,51 @@ struct bfa_s {
 };
 
 extern bfa_boolean_t bfa_auto_recover;
-extern struct bfa_module_s hal_mod_fcdiag;
-extern struct bfa_module_s hal_mod_sgpg;
-extern struct bfa_module_s hal_mod_fcport;
-extern struct bfa_module_s hal_mod_fcxp;
-extern struct bfa_module_s hal_mod_lps;
-extern struct bfa_module_s hal_mod_uf;
-extern struct bfa_module_s hal_mod_rport;
-extern struct bfa_module_s hal_mod_fcp;
-extern struct bfa_module_s hal_mod_dconf;
+
+void bfa_dconf_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *);
+void bfa_dconf_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		  struct bfa_s *);
+void bfa_dconf_iocdisable(struct bfa_s *);
+void bfa_fcp_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_fcp_iocdisable(struct bfa_s *bfa);
+void bfa_fcp_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		struct bfa_s *);
+void bfa_fcpim_iocdisable(struct bfa_fcp_mod_s *);
+void bfa_fcport_start(struct bfa_s *);
+void bfa_fcport_iocdisable(struct bfa_s *);
+void bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		   struct bfa_s *);
+void bfa_fcport_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_fcxp_iocdisable(struct bfa_s *);
+void bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		struct bfa_s *);
+void bfa_fcxp_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_fcdiag_iocdisable(struct bfa_s *);
+void bfa_fcdiag_attach(struct bfa_s *bfa, void *, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_ioim_lm_init(struct bfa_s *);
+void bfa_lps_iocdisable(struct bfa_s *bfa);
+void bfa_lps_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		struct bfa_s *);
+void bfa_lps_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
+	struct bfa_pcidev_s *);
+void bfa_rport_iocdisable(struct bfa_s *bfa);
+void bfa_rport_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		struct bfa_s *);
+void bfa_rport_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		struct bfa_s *);
+void bfa_sgpg_attach(struct bfa_s *, void *bfad, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_uf_iocdisable(struct bfa_s *);
+void bfa_uf_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
+		struct bfa_s *);
+void bfa_uf_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
+		struct bfa_pcidev_s *);
+void bfa_uf_start(struct bfa_s *);
 
 #endif /* __BFA_MODULES_H__ */
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 12de292175ef..e640223bab3c 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -23,13 +23,6 @@
 #include "bfa_modules.h"
 
 BFA_TRC_FILE(HAL, FCXP);
-BFA_MODULE(fcdiag);
-BFA_MODULE(fcxp);
-BFA_MODULE(sgpg);
-BFA_MODULE(lps);
-BFA_MODULE(fcport);
-BFA_MODULE(rport);
-BFA_MODULE(uf);
 
 /*
  * LPS related definitions
@@ -121,15 +114,6 @@ static void	bfa_fcxp_queue(struct bfa_fcxp_s *fcxp,
 /*
  * forward declarations for LPS functions
  */
-static void bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_meminfo_s *minfo, struct bfa_s *bfa);
-static void bfa_lps_attach(struct bfa_s *bfa, void *bfad,
-				struct bfa_iocfc_cfg_s *cfg,
-				struct bfa_pcidev_s *pcidev);
-static void bfa_lps_detach(struct bfa_s *bfa);
-static void bfa_lps_start(struct bfa_s *bfa);
-static void bfa_lps_stop(struct bfa_s *bfa);
-static void bfa_lps_iocdisable(struct bfa_s *bfa);
 static void bfa_lps_login_rsp(struct bfa_s *bfa,
 				struct bfi_lps_login_rsp_s *rsp);
 static void bfa_lps_no_res(struct bfa_lps_s *first_lps, u8 count);
@@ -484,7 +468,7 @@ claim_fcxps_mem(struct bfa_fcxp_mod_s *mod)
 	bfa_mem_kva_curp(mod) = (void *)fcxp;
 }
 
-static void
+void
 bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		struct bfa_s *bfa)
 {
@@ -522,7 +506,7 @@ bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		cfg->fwcfg.num_fcxp_reqs * sizeof(struct bfa_fcxp_s));
 }
 
-static void
+void
 bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -544,22 +528,7 @@ bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	claim_fcxps_mem(mod);
 }
 
-static void
-bfa_fcxp_detach(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_fcxp_start(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_fcxp_stop(struct bfa_s *bfa)
-{
-}
-
-static void
+void
 bfa_fcxp_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
@@ -1510,7 +1479,7 @@ bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
 /*
  * return memory requirement
  */
-static void
+void
 bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		struct bfa_s *bfa)
 {
@@ -1527,7 +1496,7 @@ bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 /*
  * bfa module attach at initialization time
  */
-static void
+void
 bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct bfa_pcidev_s *pcidev)
 {
@@ -1557,25 +1526,10 @@ bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	}
 }
 
-static void
-bfa_lps_detach(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_lps_start(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_lps_stop(struct bfa_s *bfa)
-{
-}
-
 /*
  * IOC in disabled state -- consider all lps offline
  */
-static void
+void
 bfa_lps_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
@@ -3055,7 +3009,7 @@ bfa_fcport_queue_cb(struct bfa_fcport_ln_s *ln, enum bfa_port_linkstate event)
 #define FCPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(union bfa_fcport_stats_u), \
 							BFA_CACHELINE_SZ))
 
-static void
+void
 bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		   struct bfa_s *bfa)
 {
@@ -3086,7 +3040,7 @@ bfa_fcport_mem_claim(struct bfa_fcport_s *fcport)
 /*
  * Memory initialization.
  */
-static void
+void
 bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -3131,34 +3085,16 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_reqq_winit(&fcport->reqq_wait, bfa_fcport_qresume, fcport);
 }
 
-static void
-bfa_fcport_detach(struct bfa_s *bfa)
-{
-}
-
-/*
- * Called when IOC is ready.
- */
-static void
+void
 bfa_fcport_start(struct bfa_s *bfa)
 {
 	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_START);
 }
 
 /*
- * Called before IOC is stopped.
- */
-static void
-bfa_fcport_stop(struct bfa_s *bfa)
-{
-	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_STOP);
-	bfa_trunk_iocdisable(bfa);
-}
-
-/*
  * Called when IOC failure is detected.
  */
-static void
+void
 bfa_fcport_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -4886,7 +4822,7 @@ bfa_rport_qresume(void *cbarg)
 	bfa_sm_send_event(rp, BFA_RPORT_SM_QRESUME);
 }
 
-static void
+void
 bfa_rport_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		struct bfa_s *bfa)
 {
@@ -4900,7 +4836,7 @@ bfa_rport_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		cfg->fwcfg.num_rports * sizeof(struct bfa_rport_s));
 }
 
-static void
+void
 bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -4940,22 +4876,7 @@ bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_mem_kva_curp(mod) = (u8 *) rp;
 }
 
-static void
-bfa_rport_detach(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_rport_start(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_rport_stop(struct bfa_s *bfa)
-{
-}
-
-static void
+void
 bfa_rport_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
@@ -5246,7 +5167,7 @@ bfa_rport_unset_lunmask(struct bfa_s *bfa, struct bfa_rport_s *rp)
 /*
  * Compute and return memory needed by FCP(im) module.
  */
-static void
+void
 bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		struct bfa_s *bfa)
 {
@@ -5281,7 +5202,7 @@ bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		cfg->drvcfg.num_sgpgs * sizeof(struct bfa_sgpg_s));
 }
 
-static void
+void
 bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -5344,26 +5265,6 @@ bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_mem_kva_curp(mod) = (u8 *) hsgpg;
 }
 
-static void
-bfa_sgpg_detach(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_sgpg_start(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_sgpg_stop(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_sgpg_iocdisable(struct bfa_s *bfa)
-{
-}
-
 bfa_status_t
 bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpgs)
 {
@@ -5547,7 +5448,7 @@ uf_mem_claim(struct bfa_uf_mod_s *ufm)
 	claim_uf_post_msgs(ufm);
 }
 
-static void
+void
 bfa_uf_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		struct bfa_s *bfa)
 {
@@ -5575,7 +5476,7 @@ bfa_uf_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 		(sizeof(struct bfa_uf_s) + sizeof(struct bfi_uf_buf_post_s)));
 }
 
-static void
+void
 bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -5590,11 +5491,6 @@ bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	uf_mem_claim(ufm);
 }
 
-static void
-bfa_uf_detach(struct bfa_s *bfa)
-{
-}
-
 static struct bfa_uf_s *
 bfa_uf_get(struct bfa_uf_mod_s *uf_mod)
 {
@@ -5682,12 +5578,7 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 		bfa_cb_queue(bfa, &uf->hcb_qe, __bfa_cb_uf_recv, uf);
 }
 
-static void
-bfa_uf_stop(struct bfa_s *bfa)
-{
-}
-
-static void
+void
 bfa_uf_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
@@ -5704,7 +5595,7 @@ bfa_uf_iocdisable(struct bfa_s *bfa)
 	}
 }
 
-static void
+void
 bfa_uf_start(struct bfa_s *bfa)
 {
 	bfa_uf_post_all(BFA_UF_MOD(bfa));
@@ -5845,13 +5736,7 @@ bfa_fcdiag_set_busy_status(struct bfa_fcdiag_s *fcdiag)
 		fcport->diag_busy = BFA_FALSE;
 }
 
-static void
-bfa_fcdiag_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
-		struct bfa_s *bfa)
-{
-}
-
-static void
+void
 bfa_fcdiag_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		struct bfa_pcidev_s *pcidev)
 {
@@ -5870,7 +5755,7 @@ bfa_fcdiag_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	memset(&dport->result, 0, sizeof(struct bfa_diag_dport_result_s));
 }
 
-static void
+void
 bfa_fcdiag_iocdisable(struct bfa_s *bfa)
 {
 	struct bfa_fcdiag_s *fcdiag = BFA_FCDIAG_MOD(bfa);
@@ -5888,21 +5773,6 @@ bfa_fcdiag_iocdisable(struct bfa_s *bfa)
 }
 
 static void
-bfa_fcdiag_detach(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_fcdiag_start(struct bfa_s *bfa)
-{
-}
-
-static void
-bfa_fcdiag_stop(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_fcdiag_queuetest_timeout(void *cbarg)
 {
 	struct bfa_fcdiag_s       *fcdiag = cbarg;
-- 
2.11.0
