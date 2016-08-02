From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/5] bfa: mark symbols static where possible
Date: Tue,  2 Aug 2016 17:22:46 +0200
Message-ID: <20160802152250.1964074-2-arnd@arndb.de>
References: <20160802152250.1964074-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160802152250.1964074-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Baoyou Xie <baoyou.xie@linaro.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

We get 128 warnings about global functions without a declaration
in the bfa scsi driver when building with W=1, more than any other
driver, e.g.

bfa/bfad.c:1502:1: error: no previous prototype for 'restart_bfa'
bfa/bfad_attr.c:447:1: error: no previous prototype for 'bfad_im_issue_fc_host_lip'
bfa/bfad_attr.c:575:1: error: no previous prototype for 'bfad_im_vport_set_symbolic_name'
bfa/bfad_bsg.c:27:1: error: no previous prototype for 'bfad_iocmd_ioc_enable'
bfa/bfad_bsg.c:50:1: error: no previous prototype for 'bfad_iocmd_ioc_disable'
bfa/bfad_bsg.c:148:1: error: no previous prototype for 'bfad_iocmd_ioc_get_stats'

In this case, all of those functions are only used in the file in
which they are declared and don't need a declaration, but can be
made static. A little more research reveals many more functions
in this driver that have a declaration but are also used only
in the same file, so this patch marks them all 'static' and moves
the declarations from a header file into the .c file where necessary.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfa.h           |  15 ---
 drivers/scsi/bfa/bfa_core.c      |  19 ++--
 drivers/scsi/bfa/bfa_fcbuild.c   |   2 +-
 drivers/scsi/bfa/bfa_fcbuild.h   |   3 -
 drivers/scsi/bfa/bfa_fcpim.c     |  66 ++++++++----
 drivers/scsi/bfa/bfa_fcpim.h     |  25 -----
 drivers/scsi/bfa/bfa_fcs.c       |  31 ++++--
 drivers/scsi/bfa/bfa_fcs.h       |  41 -------
 drivers/scsi/bfa/bfa_fcs_lport.c |  69 ++++++++----
 drivers/scsi/bfa/bfa_fcs_rport.c |   9 +-
 drivers/scsi/bfa/bfa_ioc.c       |  44 ++++----
 drivers/scsi/bfa/bfa_ioc.h       |  23 ----
 drivers/scsi/bfa/bfa_ioc_cb.c    |   3 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |  12 ++-
 drivers/scsi/bfa/bfa_plog.h      |   8 --
 drivers/scsi/bfa/bfa_port.c      |   6 +-
 drivers/scsi/bfa/bfa_port.h      |   1 -
 drivers/scsi/bfa/bfa_svc.c       |  38 ++++---
 drivers/scsi/bfa/bfa_svc.h       |  12 ---
 drivers/scsi/bfa/bfad.c          |  88 ++++++++-------
 drivers/scsi/bfa/bfad_attr.c     |   4 +-
 drivers/scsi/bfa/bfad_bsg.c      | 224 +++++++++++++++++++--------------------
 drivers/scsi/bfa/bfad_drv.h      |  44 +-------
 drivers/scsi/bfa/bfad_im.c       |  23 ++--
 drivers/scsi/bfa/bfad_im.h       |  10 --
 25 files changed, 372 insertions(+), 448 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 0e119d838e1b..c3b499d126d5 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -31,11 +31,6 @@ typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
 typedef void (*bfa_cb_cbfn_status_t) (void *cbarg, bfa_status_t status);
 
 /*
- * Interrupt message handlers
- */
-void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
-
-/*
  * Request and response queue related defines
  */
 #define BFA_REQQ_NELEMS_MIN	(4)
@@ -299,19 +294,11 @@ struct bfa_iocfc_s {
 /*
  * FC specific IOC functions.
  */
-void bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg,
-			struct bfa_meminfo_s *meminfo,
-			struct bfa_s *bfa);
-void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
-		      struct bfa_iocfc_cfg_s *cfg,
-		      struct bfa_pcidev_s *pcidev);
 void bfa_iocfc_init(struct bfa_s *bfa);
 void bfa_iocfc_start(struct bfa_s *bfa);
 void bfa_iocfc_stop(struct bfa_s *bfa);
-void bfa_iocfc_isr(void *bfa, struct bfi_mbmsg_s *msg);
 void bfa_iocfc_set_snsbase(struct bfa_s *bfa, int seg_no, u64 snsbase_pa);
 bfa_boolean_t bfa_iocfc_is_operational(struct bfa_s *bfa);
-void bfa_iocfc_reset_queues(struct bfa_s *bfa);
 
 void bfa_msix_all(struct bfa_s *bfa, int vec);
 void bfa_msix_reqq(struct bfa_s *bfa, int vec);
@@ -413,8 +400,6 @@ void bfa_cb_init(void *bfad, bfa_status_t status);
 void bfa_cb_updateq(void *bfad, bfa_status_t status);
 
 bfa_boolean_t bfa_intx(struct bfa_s *bfa);
-void bfa_isr_enable(struct bfa_s *bfa);
-void bfa_isr_disable(struct bfa_s *bfa);
 
 void bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q);
 void bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q);
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 7209afad82f7..75c6db27a399 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -22,6 +22,11 @@
 
 BFA_TRC_FILE(HAL, CORE);
 
+static void bfa_iocfc_reset_queues(struct bfa_s *bfa);
+static void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
+static void bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m);
+static void bfa_isr_disable(struct bfa_s *bfa);
+
 /*
  * BFA module list terminated by NULL
  */
@@ -732,7 +737,7 @@ bfa_reqq_resume(struct bfa_s *bfa, int qid)
 	}
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_isr_rspq(struct bfa_s *bfa, int qid)
 {
 	struct bfi_msg_s *m;
@@ -864,7 +869,7 @@ bfa_intx(struct bfa_s *bfa)
 	return BFA_TRUE;
 }
 
-void
+static void
 bfa_isr_enable(struct bfa_s *bfa)
 {
 	u32 umsk;
@@ -910,7 +915,7 @@ bfa_msix_reqq(struct bfa_s *bfa, int vec)
 	bfa_isr_reqq(bfa, vec - bfa->iocfc.hwif.cpe_vec_q0);
 }
 
-void
+static void
 bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
 {
 	bfa_trc(bfa, m->mhdr.msg_class);
@@ -1328,7 +1333,7 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 	}
 }
 
-void
+static void
 bfa_iocfc_reset_queues(struct bfa_s *bfa)
 {
 	int		q;
@@ -1483,7 +1488,7 @@ bfa_iocfc_reset_cbfn(void *bfa_arg)
 /*
  * Query IOC memory requirement information.
  */
-void
+static void
 bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 		  struct bfa_s *bfa)
 {
@@ -1529,7 +1534,7 @@ bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 /*
  * Query IOC memory requirement information.
  */
-void
+static void
 bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		 struct bfa_pcidev_s *pcidev)
 {
@@ -1591,7 +1596,7 @@ bfa_iocfc_stop(struct bfa_s *bfa)
 	bfa_fsm_send_event(&bfa->iocfc, IOCFC_E_STOP);
 }
 
-void
+static void
 bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m)
 {
 	struct bfa_s		*bfa = bfaarg;
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index b8dadc9cc993..baf22632ee96 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -172,7 +172,7 @@ fc_gsresp_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 	fchs->ox_id = ox_id;
 }
 
-void
+static void
 fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id)
 {
 	memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index b109a8813401..433316fa72fa 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -273,9 +273,6 @@ u16	fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn);
 
 void		fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
 
-void		fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-					 __be16 ox_id);
-
 enum fc_parse_status	fc_els_rsp_parse(struct fchs_s *fchs, int len);
 
 enum fc_parse_status	fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 20982e7cdd81..2132ab2ca88e 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -179,6 +179,8 @@ static void     bfa_itnim_iotov(void *itnim_arg);
 static void     bfa_itnim_iotov_start(struct bfa_itnim_s *itnim);
 static void     bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim);
 static void     bfa_itnim_iotov_delete(struct bfa_itnim_s *itnim);
+static bfa_boolean_t bfa_itnim_hold_io(struct bfa_itnim_s *itnim);
+
 
 /*
  * forward declaration of ITNIM state machine
@@ -213,6 +215,9 @@ static void     bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
 					enum bfa_itnim_event event);
 static void     bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
 					enum bfa_itnim_event event);
+static void	bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len);
+static void	bfa_itnim_iocdisable(struct bfa_itnim_s *itnim);
+static void	bfa_itnim_attach(struct bfa_fcpim_s *fcpim);
 
 /*
  * forward declaration for BFA IOIM functions
@@ -227,6 +232,13 @@ static void __bfa_cb_ioim_abort(void *cbarg, bfa_boolean_t complete);
 static void __bfa_cb_ioim_failed(void *cbarg, bfa_boolean_t complete);
 static void __bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete);
 static bfa_boolean_t    bfa_ioim_is_abortable(struct bfa_ioim_s *ioim);
+static void	bfa_ioim_attach(struct bfa_fcpim_s *fcpim);
+static void	bfa_ioim_tov(struct bfa_ioim_s *ioim);
+static void	bfa_ioim_cleanup(struct bfa_ioim_s *ioim);
+static void	bfa_ioim_iocdisable(struct bfa_ioim_s *ioim);
+static void	bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
+				      bfa_boolean_t iotov);
+static void	bfa_ioim_free(struct bfa_ioim_s *ioim);
 
 /*
  * forward declaration of BFA IO state machine
@@ -268,6 +280,9 @@ static void     bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim);
 static bfa_boolean_t bfa_tskim_send(struct bfa_tskim_s *tskim);
 static bfa_boolean_t bfa_tskim_send_abort(struct bfa_tskim_s *tskim);
 static void     bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim);
+static void	bfa_tskim_attach(struct bfa_fcpim_s *fcpim);
+static void	bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
+static void	bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
 
 /*
  * forward declaration of BFA TSKIM state machine
@@ -286,6 +301,11 @@ static void     bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 					enum bfa_tskim_event event);
 static void     bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim,
 					enum bfa_tskim_event event);
+
+static void bfa_itn_create(struct bfa_s *bfa, struct bfa_rport_s *rport,
+		void (*isr)(struct bfa_s *bfa, struct bfi_msg_s *m));
+static void bfa_iotag_attach(struct bfa_fcp_mod_s *fcp);
+static u16 bfa_fcpim_read_throttle(struct bfa_s *bfa);
 /*
  *  BFA FCP Initiator Mode module
  */
@@ -445,7 +465,7 @@ bfa_fcpim_port_iostats(struct bfa_s *bfa,
 	return BFA_STATUS_OK;
 }
 
-void
+static void
 bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 {
 	struct bfa_itnim_latency_s *io_lat =
@@ -462,7 +482,7 @@ bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 	io_lat->avg[idx] += val;
 }
 
-void
+static void
 bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
 {
 	ioim->start_time = jiffies;
@@ -1090,19 +1110,19 @@ bfa_itnim_qresume(void *cbarg)
  *  bfa_itnim_public
  */
 
-void
+static void
 bfa_itnim_iodone(struct bfa_itnim_s *itnim)
 {
 	bfa_wc_down(&itnim->wc);
 }
 
-void
+static void
 bfa_itnim_tskdone(struct bfa_itnim_s *itnim)
 {
 	bfa_wc_down(&itnim->wc);
 }
 
-void
+static void
 bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len)
 {
 	/*
@@ -1111,7 +1131,7 @@ bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len)
 	*km_len += cfg->fwcfg.num_rports * sizeof(struct bfa_itnim_s);
 }
 
-void
+static void
 bfa_itnim_attach(struct bfa_fcpim_s *fcpim)
 {
 	struct bfa_s	*bfa = fcpim->bfa;
@@ -1146,7 +1166,7 @@ bfa_itnim_attach(struct bfa_fcpim_s *fcpim)
 	bfa_mem_kva_curp(fcp) = (u8 *) itnim;
 }
 
-void
+static void
 bfa_itnim_iocdisable(struct bfa_itnim_s *itnim)
 {
 	bfa_stats(itnim, ioc_disabled);
@@ -1360,7 +1380,7 @@ bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim)
 /*
  * Itnim interrupt processing.
  */
-void
+static void
 bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 {
 	struct bfa_fcpim_s *fcpim = BFA_FCPIM(bfa);
@@ -1450,7 +1470,7 @@ bfa_itnim_offline(struct bfa_itnim_s *itnim)
  * Return true if itnim is considered offline for holding off IO request.
  * IO is not held if itnim is being deleted.
  */
-bfa_boolean_t
+static bfa_boolean_t
 bfa_itnim_hold_io(struct bfa_itnim_s *itnim)
 {
 	return itnim->fcpim->path_tov && itnim->iotov_active &&
@@ -2714,7 +2734,7 @@ bfa_ioim_is_abortable(struct bfa_ioim_s *ioim)
 	return BFA_TRUE;
 }
 
-void
+static void
 bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 {
 	/*
@@ -2744,7 +2764,7 @@ bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 /*
  * Memory allocation and initialization.
  */
-void
+static void
 bfa_ioim_attach(struct bfa_fcpim_s *fcpim)
 {
 	struct bfa_ioim_s		*ioim;
@@ -2893,7 +2913,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 /*
  * Called by itnim to clean up IO while going offline.
  */
-void
+static void
 bfa_ioim_cleanup(struct bfa_ioim_s *ioim)
 {
 	bfa_trc(ioim->bfa, ioim->iotag);
@@ -2903,7 +2923,7 @@ bfa_ioim_cleanup(struct bfa_ioim_s *ioim)
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_CLEANUP);
 }
 
-void
+static void
 bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim, struct bfa_tskim_s *tskim)
 {
 	bfa_trc(ioim->bfa, ioim->iotag);
@@ -2916,7 +2936,7 @@ bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim, struct bfa_tskim_s *tskim)
 /*
  * IOC failure handling.
  */
-void
+static void
 bfa_ioim_iocdisable(struct bfa_ioim_s *ioim)
 {
 	bfa_trc(ioim->bfa, ioim->iotag);
@@ -2927,7 +2947,7 @@ bfa_ioim_iocdisable(struct bfa_ioim_s *ioim)
 /*
  * IO offline TOV popped. Fail the pending IO.
  */
-void
+static void
 bfa_ioim_tov(struct bfa_ioim_s *ioim)
 {
 	bfa_trc(ioim->bfa, ioim->iotag);
@@ -2970,7 +2990,7 @@ bfa_ioim_alloc(struct bfa_s *bfa, struct bfad_ioim_s *dio,
 	return ioim;
 }
 
-void
+static void
 bfa_ioim_free(struct bfa_ioim_s *ioim)
 {
 	struct bfa_fcpim_s *fcpim = ioim->fcpim;
@@ -3489,7 +3509,7 @@ bfa_tskim_iodone(struct bfa_tskim_s *tskim)
 /*
  * Handle IOC h/w failure notification from itnim.
  */
-void
+static void
 bfa_tskim_iocdisable(struct bfa_tskim_s *tskim)
 {
 	tskim->notify = BFA_FALSE;
@@ -3500,7 +3520,7 @@ bfa_tskim_iocdisable(struct bfa_tskim_s *tskim)
 /*
  * Cleanup TM command and associated IOs as part of ITNIM offline.
  */
-void
+static void
 bfa_tskim_cleanup(struct bfa_tskim_s *tskim)
 {
 	tskim->notify = BFA_TRUE;
@@ -3511,7 +3531,7 @@ bfa_tskim_cleanup(struct bfa_tskim_s *tskim)
 /*
  * Memory allocation and initialization.
  */
-void
+static void
 bfa_tskim_attach(struct bfa_fcpim_s *fcpim)
 {
 	struct bfa_tskim_s *tskim;
@@ -3795,7 +3815,7 @@ bfa_fcp_res_recfg(struct bfa_s *bfa, u16 num_ioim_fw, u16 max_ioim_fw)
 	mod->throttle_update_required = 0;
 }
 
-void
+static void
 bfa_itn_create(struct bfa_s *bfa, struct bfa_rport_s *rport,
 		void (*isr)(struct bfa_s *bfa, struct bfi_msg_s *m))
 {
@@ -3825,7 +3845,7 @@ bfa_itn_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 		WARN_ON(1);
 }
 
-void
+static void
 bfa_iotag_attach(struct bfa_fcp_mod_s *fcp)
 {
 	struct bfa_iotag_s *iotag;
@@ -3879,7 +3899,7 @@ bfa_fcpim_get_throttle_cfg(struct bfa_s *bfa, u16 drv_cfg_param)
 	return tmp;
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_fcpim_write_throttle(struct bfa_s *bfa, u16 value)
 {
 	if (!bfa_dconf_get_min_cfg(bfa)) {
@@ -3891,7 +3911,7 @@ bfa_fcpim_write_throttle(struct bfa_s *bfa, u16 value)
 	return BFA_STATUS_FAILED;
 }
 
-u16
+static u16
 bfa_fcpim_read_throttle(struct bfa_s *bfa)
 {
 	struct bfa_throttle_cfg_s *throttle_cfg =
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index e93921dec347..c3dfd26350c2 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -39,10 +39,7 @@ struct bfa_itn_s {
 	bfa_isr_func_t isr;
 };
 
-void bfa_itn_create(struct bfa_s *bfa, struct bfa_rport_s *rport,
-		void (*isr)(struct bfa_s *bfa, struct bfi_msg_s *m));
 void bfa_itn_isr(struct bfa_s *bfa, struct bfi_msg_s *m);
-void bfa_iotag_attach(struct bfa_fcp_mod_s *fcp);
 void bfa_fcp_res_recfg(struct bfa_s *bfa, u16 num_ioim_fw, u16 max_ioim_fw);
 
 #define BFA_FCP_MOD(_hal)	(&(_hal)->modules.fcp_mod)
@@ -275,31 +272,14 @@ bfa_ioim_maxretry_reached(struct bfa_ioim_s *ioim)
 /*
  * function prototypes
  */
-void	bfa_ioim_attach(struct bfa_fcpim_s *fcpim);
 void	bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 void	bfa_ioim_good_comp_isr(struct bfa_s *bfa,
 					struct bfi_msg_s *msg);
-void	bfa_ioim_cleanup(struct bfa_ioim_s *ioim);
-void	bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim,
-					struct bfa_tskim_s *tskim);
-void	bfa_ioim_iocdisable(struct bfa_ioim_s *ioim);
-void	bfa_ioim_tov(struct bfa_ioim_s *ioim);
 
-void	bfa_tskim_attach(struct bfa_fcpim_s *fcpim);
 void	bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 void	bfa_tskim_iodone(struct bfa_tskim_s *tskim);
-void	bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
-void	bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
 void	bfa_tskim_res_recfg(struct bfa_s *bfa, u16 num_tskim_fw);
 
-void	bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len);
-void	bfa_itnim_attach(struct bfa_fcpim_s *fcpim);
-void	bfa_itnim_iocdisable(struct bfa_itnim_s *itnim);
-void	bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-void	bfa_itnim_iodone(struct bfa_itnim_s *itnim);
-void	bfa_itnim_tskdone(struct bfa_itnim_s *itnim);
-bfa_boolean_t   bfa_itnim_hold_io(struct bfa_itnim_s *itnim);
-
 /*
  * bfa fcpim module API functions
  */
@@ -368,11 +348,8 @@ struct bfa_ioim_s	*bfa_ioim_alloc(struct bfa_s *bfa,
 					struct bfa_itnim_s *itnim,
 					u16 nsgles);
 
-void		bfa_ioim_free(struct bfa_ioim_s *ioim);
 void		bfa_ioim_start(struct bfa_ioim_s *ioim);
 bfa_status_t	bfa_ioim_abort(struct bfa_ioim_s *ioim);
-void		bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
-				      bfa_boolean_t iotov);
 /*
  * I/O completion notification.
  *
@@ -421,8 +398,6 @@ bfa_status_t	bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id,
 bfa_status_t	bfa_fcpim_lunmask_add(struct bfa_s *bfa, u16 vf_id,
 				wwn_t *pwwn, wwn_t rpwwn, struct scsi_lun lun);
 bfa_status_t	bfa_fcpim_lunmask_clear(struct bfa_s *bfa);
-u16		bfa_fcpim_read_throttle(struct bfa_s *bfa);
-bfa_status_t	bfa_fcpim_write_throttle(struct bfa_s *bfa, u16 value);
 bfa_status_t	bfa_fcpim_throttle_set(struct bfa_s *bfa, u16 value);
 bfa_status_t	bfa_fcpim_throttle_get(struct bfa_s *bfa, void *buf);
 u16     bfa_fcpim_get_throttle_cfg(struct bfa_s *bfa, u16 drv_cfg_param);
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 1e7e139d71ea..7d50a610d6f8 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -38,6 +38,15 @@ struct bfa_fcs_mod_s {
 
 #define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
 
+static void bfa_fcs_port_attach(struct bfa_fcs_s *fcs);
+static void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
+static void bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
+static void bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
+static void bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
+static void bfa_fcs_fabric_modstop(struct bfa_fcs_s *fcs);
+static void bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
+static void bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric);
+
 static struct bfa_fcs_mod_s fcs_modules[] = {
 	{ bfa_fcs_port_attach, NULL, NULL },
 	{ bfa_fcs_uf_attach, NULL, NULL },
@@ -822,7 +831,7 @@ bfa_fcs_fabric_init(struct bfa_fcs_fabric_s *fabric)
 /*
  * Port Symbolic Name Creation for base port.
  */
-void
+static void
 bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_lport_cfg_s *port_cfg = &fabric->bport.port_cfg;
@@ -883,7 +892,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 /*
  * Node Symbolic Name Creation for base port and all vports
  */
-void
+static void
 bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric)
 {
 	struct bfa_lport_cfg_s *port_cfg = &fabric->bport.port_cfg;
@@ -1130,7 +1139,7 @@ bfa_fcs_fabric_stop_comp(void *cbarg)
 /*
  * Attach time initialization.
  */
-void
+static void
 bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_fabric_s *fabric;
@@ -1158,7 +1167,7 @@ bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 	bfa_fcs_lport_attach(&fabric->bport, fabric->fcs, FC_VF_ID_NULL, NULL);
 }
 
-void
+static void
 bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
 {
 	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_CREATE);
@@ -1168,7 +1177,7 @@ bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
 /*
  *   Module cleanup
  */
-void
+static void
 bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_fabric_s *fabric;
@@ -1186,7 +1195,7 @@ bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs)
 /*
  * Fabric module stop -- stop FCS actions
  */
-void
+static void
 bfa_fcs_fabric_modstop(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_fabric_s *fabric;
@@ -1213,7 +1222,7 @@ bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs)
 /*
  *   Link up notification from BFA physical port module.
  */
-void
+static void
 bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric)
 {
 	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
@@ -1223,7 +1232,7 @@ bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric)
 /*
  *   Link down notification from BFA physical port module.
  */
-void
+static void
 bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric)
 {
 	bfa_trc(fabric->fcs, fabric->bport.port_cfg.pwwn);
@@ -1317,7 +1326,7 @@ bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric)
 /*
  *		Unsolicited frame receive handling.
  */
-void
+static void
 bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 		       u16 len)
 {
@@ -1633,7 +1642,7 @@ bfa_fcs_port_event_handler(void *cbarg, enum bfa_port_linkstate event)
 	}
 }
 
-void
+static void
 bfa_fcs_port_attach(struct bfa_fcs_s *fcs)
 {
 	bfa_fcport_event_register(fcs->bfa, bfa_fcs_port_event_handler, fcs);
@@ -1706,7 +1715,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 	bfa_uf_free(uf);
 }
 
-void
+static void
 bfa_fcs_uf_attach(struct bfa_fcs_s *fcs)
 {
 	bfa_uf_recv_register(fcs->bfa, bfa_fcs_uf_recv, fcs);
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 0f797a55d504..5409a1cfb688 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -308,16 +308,7 @@ void bfa_fcs_lport_clear_stats(struct bfa_fcs_lport_s *fcs_port);
 enum bfa_port_speed bfa_fcs_lport_get_rport_max_speed(
 			struct bfa_fcs_lport_s *port);
 
-/* MS FCS routines */
-void bfa_fcs_lport_ms_init(struct bfa_fcs_lport_s *port);
-void bfa_fcs_lport_ms_offline(struct bfa_fcs_lport_s *port);
-void bfa_fcs_lport_ms_online(struct bfa_fcs_lport_s *port);
-void bfa_fcs_lport_ms_fabric_rscn(struct bfa_fcs_lport_s *port);
-
 /* FDMI FCS routines */
-void bfa_fcs_lport_fdmi_init(struct bfa_fcs_lport_ms_s *ms);
-void bfa_fcs_lport_fdmi_offline(struct bfa_fcs_lport_ms_s *ms);
-void bfa_fcs_lport_fdmi_online(struct bfa_fcs_lport_ms_s *ms);
 void bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport, struct fchs_s *fchs,
 				     u16 len);
 void bfa_fcs_lport_attach(struct bfa_fcs_lport_s *lport, struct bfa_fcs_s *fcs,
@@ -328,10 +319,6 @@ void            bfa_fcs_lport_online(struct bfa_fcs_lport_s *port);
 void            bfa_fcs_lport_offline(struct bfa_fcs_lport_s *port);
 void            bfa_fcs_lport_delete(struct bfa_fcs_lport_s *port);
 void		bfa_fcs_lport_stop(struct bfa_fcs_lport_s *port);
-struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_pid(
-		struct bfa_fcs_lport_s *port, u32 pid);
-struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_old_pid(
-		struct bfa_fcs_lport_s *port, u32 pid);
 struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_pwwn(
 		struct bfa_fcs_lport_s *port, wwn_t pwwn);
 struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_nwwn(
@@ -342,17 +329,6 @@ void            bfa_fcs_lport_add_rport(struct bfa_fcs_lport_s *port,
 				       struct bfa_fcs_rport_s *rport);
 void            bfa_fcs_lport_del_rport(struct bfa_fcs_lport_s *port,
 				       struct bfa_fcs_rport_s *rport);
-void            bfa_fcs_lport_ns_init(struct bfa_fcs_lport_s *vport);
-void            bfa_fcs_lport_ns_offline(struct bfa_fcs_lport_s *vport);
-void            bfa_fcs_lport_ns_online(struct bfa_fcs_lport_s *vport);
-void            bfa_fcs_lport_ns_query(struct bfa_fcs_lport_s *port);
-void		bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg,
-				struct bfa_fcxp_s *fcxp_alloced);
-void            bfa_fcs_lport_scn_init(struct bfa_fcs_lport_s *vport);
-void            bfa_fcs_lport_scn_offline(struct bfa_fcs_lport_s *vport);
-void            bfa_fcs_lport_fab_scn_online(struct bfa_fcs_lport_s *vport);
-void            bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
-					      struct fchs_s *rx_frame, u32 len);
 void		bfa_fcs_lport_lip_scn_online(bfa_fcs_lport_t *port);
 
 struct bfa_fcs_vport_s {
@@ -391,10 +367,8 @@ struct bfa_fcs_vport_s *bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs,
 void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
-void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_fcs_stop(struct bfa_fcs_vport_s *vport);
-void bfa_fcs_vport_stop_comp(struct bfa_fcs_vport_s *vport);
 
 #define BFA_FCS_RPORT_DEF_DEL_TIMEOUT	90	/* in secs */
 #define BFA_FCS_RPORT_MAX_RETRIES	(5)
@@ -494,9 +468,6 @@ void bfa_fcs_rport_fcptm_offline_done(struct bfa_fcs_rport_s *rport);
 int  bfa_fcs_rport_get_state(struct bfa_fcs_rport_s *rport);
 struct bfa_fcs_rport_s *bfa_fcs_rport_create_by_wwn(
 			struct bfa_fcs_lport_s *port, wwn_t wwn);
-void  bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport);
-void  bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport);
-void  bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport);
 
 /*
  * forward declarations
@@ -808,11 +779,6 @@ void bfa_fcs_vf_get_ports(bfa_fcs_vf_t *vf, wwn_t vpwwn[], int *nports);
 /*
  * fabric protected interface functions
  */
-void bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
 	struct bfa_fcs_vport_s *vport);
 void bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
@@ -820,16 +786,9 @@ void bfa_fcs_fabric_delvport(struct bfa_fcs_fabric_s *fabric,
 struct bfa_fcs_vport_s *bfa_fcs_fabric_vport_lookup(
 		struct bfa_fcs_fabric_s *fabric, wwn_t pwwn);
 void bfa_fcs_fabric_modstart(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric,
-		struct fchs_s *fchs, u16 len);
-void	bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric);
-void	bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 	       wwn_t fabric_name);
 u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
-void bfa_fcs_port_attach(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_modstop(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 			enum bfa_fcs_fabric_event event);
 void bfa_fcs_fabric_sm_loopback(struct bfa_fcs_fabric_s *fabric,
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 7733ad5305d4..7870baedb9bd 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -84,6 +84,28 @@ static void	bfa_fcs_lport_loop_init(struct bfa_fcs_lport_s *port);
 static void	bfa_fcs_lport_loop_online(struct bfa_fcs_lport_s *port);
 static void	bfa_fcs_lport_loop_offline(struct bfa_fcs_lport_s *port);
 
+static void	bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
+					       struct fchs_s *fchs, u32 len);
+static void	bfa_fcs_lport_scn_init(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_scn_offline(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_fab_scn_online(struct bfa_fcs_lport_s *port);
+
+static void	bfa_fcs_lport_ns_init(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_ns_offline(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_ns_online(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg,
+					   struct bfa_fcxp_s *fcxp_alloced);
+
+static void	bfa_fcs_lport_ms_init(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_ms_offline(struct bfa_fcs_lport_s *port);
+static void	bfa_fcs_lport_ms_online(struct bfa_fcs_lport_s *port);
+
+static struct bfa_fcs_rport_s *
+		bfa_fcs_lport_get_rport_by_pid(struct bfa_fcs_lport_s *port,
+					       u32 pid);
+
+static void	bfa_fcs_vport_stop_comp(struct bfa_fcs_vport_s *vport);
+static void	bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
 static struct {
 	void		(*init) (struct bfa_fcs_lport_s *port);
 	void		(*online) (struct bfa_fcs_lport_s *port);
@@ -893,7 +915,7 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 /*
  *   PID based Lookup for a R-Port in the Port R-Port Queue
  */
-struct bfa_fcs_rport_s *
+static struct bfa_fcs_rport_s *
 bfa_fcs_lport_get_rport_by_pid(struct bfa_fcs_lport_s *port, u32 pid)
 {
 	struct bfa_fcs_rport_s *rport;
@@ -912,7 +934,7 @@ bfa_fcs_lport_get_rport_by_pid(struct bfa_fcs_lport_s *port, u32 pid)
 /*
  * OLD_PID based Lookup for a R-Port in the Port R-Port Queue
  */
-struct bfa_fcs_rport_s *
+static struct bfa_fcs_rport_s *
 bfa_fcs_lport_get_rport_by_old_pid(struct bfa_fcs_lport_s *port, u32 pid)
 {
 	struct bfa_fcs_rport_s *rport;
@@ -1280,7 +1302,7 @@ bfa_fcs_lport_n2n_offline(struct bfa_fcs_lport_s *port)
 	n2n_port->reply_oxid = 0;
 }
 
-void
+static void
 bfa_fcport_get_loop_attr(struct bfa_fcs_lport_s *port)
 {
 	int i = 0, j = 0, bit = 0, alpa_bit = 0;
@@ -1417,7 +1439,7 @@ static void	bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 				 struct bfa_fcs_fdmi_hba_attr_s *hba_attr);
 static void	bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 				  struct bfa_fcs_fdmi_port_attr_s *port_attr);
-u32	bfa_fcs_fdmi_convert_speed(enum bfa_port_speed pport_speed);
+static u32	bfa_fcs_fdmi_convert_speed(enum bfa_port_speed pport_speed);
 
 /*
  *  fcs_fdmi_sm FCS FDMI state machine
@@ -2751,7 +2773,7 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 /*
  * Convert BFA speed to FDMI format.
  */
-u32
+static u32
 bfa_fcs_fdmi_convert_speed(bfa_port_speed_t pport_speed)
 {
 	u32	ret;
@@ -2784,7 +2806,7 @@ bfa_fcs_fdmi_convert_speed(bfa_port_speed_t pport_speed)
 	return ret;
 }
 
-void
+static void
 bfa_fcs_lport_fdmi_init(struct bfa_fcs_lport_ms_s *ms)
 {
 	struct bfa_fcs_lport_fdmi_s *fdmi = &ms->fdmi;
@@ -2796,7 +2818,7 @@ bfa_fcs_lport_fdmi_init(struct bfa_fcs_lport_ms_s *ms)
 		bfa_sm_set_state(fdmi, bfa_fcs_lport_fdmi_sm_disabled);
 }
 
-void
+static void
 bfa_fcs_lport_fdmi_offline(struct bfa_fcs_lport_ms_s *ms)
 {
 	struct bfa_fcs_lport_fdmi_s *fdmi = &ms->fdmi;
@@ -2805,7 +2827,7 @@ bfa_fcs_lport_fdmi_offline(struct bfa_fcs_lport_ms_s *ms)
 	bfa_sm_send_event(fdmi, FDMISM_EVENT_PORT_OFFLINE);
 }
 
-void
+static void
 bfa_fcs_lport_fdmi_online(struct bfa_fcs_lport_ms_s *ms)
 {
 	struct bfa_fcs_lport_fdmi_s *fdmi = &ms->fdmi;
@@ -3506,7 +3528,7 @@ bfa_fcs_lport_ms_timeout(void *arg)
 }
 
 
-void
+static void
 bfa_fcs_lport_ms_init(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
@@ -3520,7 +3542,7 @@ bfa_fcs_lport_ms_init(struct bfa_fcs_lport_s *port)
 	bfa_fcs_lport_fdmi_init(ms);
 }
 
-void
+static void
 bfa_fcs_lport_ms_offline(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
@@ -3530,7 +3552,7 @@ bfa_fcs_lport_ms_offline(struct bfa_fcs_lport_s *port)
 	bfa_fcs_lport_fdmi_offline(ms);
 }
 
-void
+static void
 bfa_fcs_lport_ms_online(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
@@ -3538,7 +3560,8 @@ bfa_fcs_lport_ms_online(struct bfa_fcs_lport_s *port)
 	ms->port = port;
 	bfa_sm_send_event(ms, MSSM_EVENT_PORT_ONLINE);
 }
-void
+
+static void
 bfa_fcs_lport_ms_fabric_rscn(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ms_s *ms = BFA_FCS_GET_MS_FROM_PORT(port);
@@ -5100,7 +5123,7 @@ bfa_fcs_lport_ns_process_gidft_pids(struct bfa_fcs_lport_s *port, u32 *pid_buf,
  * Functions called by port/fab.
  * These will send relevant Events to the ns state machine.
  */
-void
+static void
 bfa_fcs_lport_ns_init(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
@@ -5109,7 +5132,7 @@ bfa_fcs_lport_ns_init(struct bfa_fcs_lport_s *port)
 	bfa_sm_set_state(ns, bfa_fcs_lport_ns_sm_offline);
 }
 
-void
+static void
 bfa_fcs_lport_ns_offline(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
@@ -5118,7 +5141,7 @@ bfa_fcs_lport_ns_offline(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(ns, NSSM_EVENT_PORT_OFFLINE);
 }
 
-void
+static void
 bfa_fcs_lport_ns_online(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
@@ -5127,7 +5150,7 @@ bfa_fcs_lport_ns_online(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(ns, NSSM_EVENT_PORT_ONLINE);
 }
 
-void
+static void
 bfa_fcs_lport_ns_query(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_ns_s *ns = BFA_FCS_GET_NS_FROM_PORT(port);
@@ -5154,7 +5177,7 @@ bfa_fcs_lport_ns_boot_target_disc(bfa_fcs_lport_t *port)
 	}
 }
 
-void
+static void
 bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 {
 	struct bfa_fcs_lport_ns_s *ns = cbarg;
@@ -5518,7 +5541,7 @@ bfa_fcs_lport_scn_timeout(void *arg)
 /*
  * Functions called by port/fab
  */
-void
+static void
 bfa_fcs_lport_scn_init(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_scn_s *scn = BFA_FCS_GET_SCN_FROM_PORT(port);
@@ -5527,7 +5550,7 @@ bfa_fcs_lport_scn_init(struct bfa_fcs_lport_s *port)
 	bfa_sm_set_state(scn, bfa_fcs_lport_scn_sm_offline);
 }
 
-void
+static void
 bfa_fcs_lport_scn_offline(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_scn_s *scn = BFA_FCS_GET_SCN_FROM_PORT(port);
@@ -5536,7 +5559,7 @@ bfa_fcs_lport_scn_offline(struct bfa_fcs_lport_s *port)
 	bfa_sm_send_event(scn, SCNSM_EVENT_PORT_OFFLINE);
 }
 
-void
+static void
 bfa_fcs_lport_fab_scn_online(struct bfa_fcs_lport_s *port)
 {
 	struct bfa_fcs_lport_scn_s *scn = BFA_FCS_GET_SCN_FROM_PORT(port);
@@ -5621,7 +5644,7 @@ bfa_fcs_lport_scn_multiport_rscn(struct bfa_fcs_lport_s *port,
 }
 
 
-void
+static void
 bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 			struct fchs_s *fchs, u32 len)
 {
@@ -6680,7 +6703,7 @@ bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport)
 /*
  * Stop completion callback from associated lport
  */
-void
+static void
 bfa_fcs_vport_stop_comp(struct bfa_fcs_vport_s *vport)
 {
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_STOPCOMP);
@@ -6689,7 +6712,7 @@ bfa_fcs_vport_stop_comp(struct bfa_fcs_vport_s *vport)
 /*
  * Delete completion callback from associated lport
  */
-void
+static void
 bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport)
 {
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELCOMP);
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index de50349a39ce..1d722e272f18 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -143,6 +143,9 @@ static void	bfa_fcs_rport_sm_fc4_off_delete(struct bfa_fcs_rport_s *rport,
 						enum rport_event event);
 static void	bfa_fcs_rport_sm_delete_pending(struct bfa_fcs_rport_s *rport,
 						enum rport_event event);
+static void bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport);
+static void bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport);
+static void bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport);
 
 static struct bfa_sm_table_s rport_sm_table[] = {
 	{BFA_SM(bfa_fcs_rport_sm_uninit), BFA_RPORT_UNINIT},
@@ -3321,7 +3324,7 @@ bfa_fcs_rpf_sm_offline(struct bfa_fcs_rpf_s *rpf, enum rpf_event event)
 /*
  * Called when Rport is created.
  */
-void
+static void
 bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport)
 {
 	struct bfa_fcs_rpf_s *rpf = &rport->rpf;
@@ -3335,7 +3338,7 @@ bfa_fcs_rpf_init(struct bfa_fcs_rport_s *rport)
 /*
  * Called when Rport becomes online
  */
-void
+static void
 bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport)
 {
 	bfa_trc(rport->fcs, rport->pid);
@@ -3350,7 +3353,7 @@ bfa_fcs_rpf_rport_online(struct bfa_fcs_rport_s *rport)
 /*
  * Called when Rport becomes offline
  */
-void
+static void
 bfa_fcs_rpf_rport_offline(struct bfa_fcs_rport_s *rport)
 {
 	bfa_trc(rport->fcs, rport->pid);
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a1ada4a31c97..d2974797e52d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -118,6 +118,14 @@ static enum bfi_ioc_img_ver_cmp_e bfa_ioc_fw_ver_patch_cmp(
 static enum bfi_ioc_img_ver_cmp_e bfa_ioc_flash_fwver_cmp(
 				struct bfa_ioc_s *ioc,
 				struct bfi_ioc_image_hdr_s *base_fwhdr);
+static void bfa_ioc_aen_post(struct bfa_ioc_s *ioc,
+			     enum bfa_ioc_aen_event event);
+static bfa_status_t bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type,
+				 u32 boot_env);
+static bfa_status_t bfa_flash_raw_read(void __iomem *pci_bar, u32 offset,
+				       char *buf, u32 len);
+static void bfa_phy_intr(void *phyarg, struct bfi_mbmsg_s *msg);
+static void bfa_fru_intr(void *fruarg, struct bfi_mbmsg_s *msg);
 
 /*
  * IOC state machine definitions/declarations
@@ -1638,7 +1646,7 @@ bfa_ioc_fw_ver_patch_cmp(struct bfi_ioc_image_hdr_s *base_fwhdr,
 
 #define BFA_FLASH_PART_FWIMG_ADDR	0x100000 /* fw image address */
 
-bfa_status_t
+static bfa_status_t
 bfa_ioc_flash_img_get_chnk(struct bfa_ioc_s *ioc, u32 off,
 				u32 *fwimg)
 {
@@ -2192,7 +2200,7 @@ bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_FWMISMATCH);
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 {
 
@@ -2223,7 +2231,7 @@ bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
  * Interface used by diag module to do firmware boot with memory test
  * as the entry vector.
  */
-bfa_status_t
+static bfa_status_t
 bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 {
 	struct bfi_ioc_image_hdr_s *drv_fwhdr;
@@ -2297,7 +2305,7 @@ bfa_ioc_is_initialized(struct bfa_ioc_s *ioc)
 		(r32 != BFI_IOC_MEMTEST));
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 {
 	__be32	*msgp = mbmsg;
@@ -2327,7 +2335,7 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 	return BFA_TRUE;
 }
 
-void
+static void
 bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
 {
 	union bfi_ioc_i2h_msg_u	*msg;
@@ -2667,7 +2675,7 @@ bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
  * Check if adapter is disabled -- both IOCs should be in a disabled
  * state.
  */
-bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 {
 	u32	ioc_state;
@@ -2691,7 +2699,7 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 /*
  * Reset IOC fwstate registers.
  */
-void
+static void
 bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc)
 {
 	bfa_ioc_set_cur_ioc_fwstate(ioc, BFI_IOC_UNINIT);
@@ -2699,7 +2707,7 @@ bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc)
 }
 
 #define BFA_MFG_NAME "QLogic"
-void
+static void
 bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 			 struct bfa_adapter_attr_s *ad_attr)
 {
@@ -2826,7 +2834,7 @@ bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 			BFA_MFG_NAME, ioc_attr->card_type);
 }
 
-enum bfa_ioc_state
+static enum bfa_ioc_state
 bfa_ioc_get_state(struct bfa_ioc_s *ioc)
 {
 	enum bfa_iocpf_state iocpf_st;
@@ -2917,7 +2925,7 @@ bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc)
 /*
  * Send AEN notification
  */
-void
+static void
 bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 {
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
@@ -3996,7 +4004,7 @@ bfa_sfp_speed_valid(struct bfa_sfp_s *sfp, enum bfa_port_speed portspeed)
 /*
  *	SFP hmbox handler
  */
-void
+static void
 bfa_sfp_intr(void *sfparg, struct bfi_mbmsg_s *msg)
 {
 	struct bfa_sfp_s *sfp = sfparg;
@@ -5036,7 +5044,7 @@ diag_portbeacon_comp(struct bfa_diag_s *diag)
 /*
  *	Diag hmbox handler
  */
-void
+static void
 bfa_diag_intr(void *diagarg, struct bfi_mbmsg_s *msg)
 {
 	struct bfa_diag_s *diag = diagarg;
@@ -5515,7 +5523,7 @@ bfa_phy_memclaim(struct bfa_phy_s *phy, u8 *dm_kva, u64 dm_pa,
 	dm_pa += BFA_ROUNDUP(BFA_PHY_DMA_BUF_SZ, BFA_DMA_ALIGN_SZ);
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_phy_busy(struct bfa_ioc_s *ioc)
 {
 	void __iomem	*rb;
@@ -5710,7 +5718,7 @@ bfa_phy_read(struct bfa_phy_s *phy, u8 instance,
  * @param[in] phyarg - phy structure
  * @param[in] msg - message structure
  */
-void
+static void
 bfa_phy_intr(void *phyarg, struct bfi_mbmsg_s *msg)
 {
 	struct bfa_phy_s *phy = phyarg;
@@ -6582,7 +6590,7 @@ bfa_tfru_read(struct bfa_fru_s *fru, void *buf, u32 len, u32 offset,
  * @param[in] fruarg - fru structure
  * @param[in] msg - message structure
  */
-void
+static void
 bfa_fru_intr(void *fruarg, struct bfi_mbmsg_s *msg)
 {
 	struct bfa_fru_s *fru = fruarg;
@@ -6999,7 +7007,7 @@ bfa_raw_sem_get(void __iomem *bar)
 
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_flash_sem_get(void __iomem *bar)
 {
 	u32 n = FLASH_BLOCKING_OP_MAX;
@@ -7012,13 +7020,13 @@ bfa_flash_sem_get(void __iomem *bar)
 	return BFA_STATUS_OK;
 }
 
-void
+static void
 bfa_flash_sem_put(void __iomem *bar)
 {
 	writel(0, (bar + FLASH_SEM_LOCK_REG));
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_flash_raw_read(void __iomem *pci_bar, u32 offset, char *buf,
 		       u32 len)
 {
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 713745da44c6..a2df03dc420a 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -454,7 +454,6 @@ void	bfa_sfp_attach(struct bfa_sfp_s *sfp, struct bfa_ioc_s *ioc,
 			void *dev, struct bfa_trc_mod_s *trcmod);
 
 void	bfa_sfp_memclaim(struct bfa_sfp_s *diag, u8 *dm_kva, u64 dm_pa);
-void	bfa_sfp_intr(void *bfaarg, struct bfi_mbmsg_s *msg);
 
 bfa_status_t	bfa_sfp_show(struct bfa_sfp_s *sfp, struct sfp_mem_s *sfpmem,
 			     bfa_cb_sfp_t cbfn, void *cbarg);
@@ -516,8 +515,6 @@ void bfa_flash_attach(struct bfa_flash_s *flash, struct bfa_ioc_s *ioc,
 		void *dev, struct bfa_trc_mod_s *trcmod, bfa_boolean_t mincfg);
 void bfa_flash_memclaim(struct bfa_flash_s *flash,
 		u8 *dm_kva, u64 dm_pa, bfa_boolean_t mincfg);
-bfa_status_t    bfa_flash_raw_read(void __iomem *pci_bar_kva,
-				u32 offset, char *buf, u32 len);
 
 /*
  *	DIAG module specific
@@ -689,7 +686,6 @@ struct bfa_phy_s {
 #define BFA_PHY(__bfa)	(&(__bfa)->modules.phy)
 #define BFA_MEM_PHY_DMA(__bfa)	(&(BFA_PHY(__bfa)->phy_dma))
 
-bfa_boolean_t bfa_phy_busy(struct bfa_ioc_s *ioc);
 bfa_status_t bfa_phy_get_attr(struct bfa_phy_s *phy, u8 instance,
 			struct bfa_phy_attr_s *attr,
 			bfa_cb_phy_t cbfn, void *cbarg);
@@ -708,7 +704,6 @@ void bfa_phy_attach(struct bfa_phy_s *phy, struct bfa_ioc_s *ioc,
 		void *dev, struct bfa_trc_mod_s *trcmod, bfa_boolean_t mincfg);
 void bfa_phy_memclaim(struct bfa_phy_s *phy,
 		u8 *dm_kva, u64 dm_pa, bfa_boolean_t mincfg);
-void bfa_phy_intr(void *phyarg, struct bfi_mbmsg_s *msg);
 
 /*
  * FRU module specific
@@ -758,7 +753,6 @@ void bfa_fru_attach(struct bfa_fru_s *fru, struct bfa_ioc_s *ioc,
 		void *dev, struct bfa_trc_mod_s *trcmod, bfa_boolean_t mincfg);
 void bfa_fru_memclaim(struct bfa_fru_s *fru,
 		u8 *dm_kva, u64 dm_pa, bfa_boolean_t mincfg);
-void bfa_fru_intr(void *fruarg, struct bfi_mbmsg_s *msg);
 
 /*
  * Driver Config( dconf) specific
@@ -845,7 +839,6 @@ void bfa_ioc_mbox_register(struct bfa_ioc_s *ioc,
 		bfa_ioc_mbox_mcfunc_t *mcfuncs);
 void bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc);
 void bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len);
-bfa_boolean_t bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg);
 void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 		bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg);
 
@@ -857,11 +850,6 @@ void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 	((__ioc)->ioc_hwif->ioc_pll_init((__ioc)->pcidev.pci_bar_kva, \
 			   (__ioc)->asic_mode))
 
-bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
-bfa_status_t bfa_ioc_cb_pll_init(void __iomem *rb, enum bfi_asic_mode mode);
-bfa_status_t bfa_ioc_ct_pll_init(void __iomem *rb, enum bfi_asic_mode mode);
-bfa_status_t bfa_ioc_ct2_pll_init(void __iomem *rb, enum bfi_asic_mode mode);
-
 #define bfa_ioc_isr_mode_set(__ioc, __msix) do {			\
 	if ((__ioc)->ioc_hwif->ioc_isr_mode_set)			\
 		((__ioc)->ioc_hwif->ioc_isr_mode_set(__ioc, __msix));	\
@@ -891,17 +879,12 @@ void bfa_ioc_enable(struct bfa_ioc_s *ioc);
 void bfa_ioc_disable(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_intx_claim(struct bfa_ioc_s *ioc);
 
-bfa_status_t bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type,
-		u32 boot_env);
-void bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *msg);
 void bfa_ioc_error_isr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_initialized(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_acq_addr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
-bfa_boolean_t bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc);
-void bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc);
 enum bfa_ioc_type_e bfa_ioc_get_type(struct bfa_ioc_s *ioc);
 void bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num);
 void bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver);
@@ -910,11 +893,8 @@ void bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model);
 void bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc,
 		char *manufacturer);
 void bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev);
-enum bfa_ioc_state bfa_ioc_get_state(struct bfa_ioc_s *ioc);
 
 void bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr);
-void bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
-		struct bfa_adapter_attr_s *ad_attr);
 void bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave);
 bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
 		int *trclen);
@@ -928,7 +908,6 @@ void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
 bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
-void bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event);
 bfa_status_t bfa_ioc_fw_stats_get(struct bfa_ioc_s *ioc, void *stats);
 bfa_status_t bfa_ioc_fw_stats_clear(struct bfa_ioc_s *ioc);
 void bfa_ioc_debug_save_ftrc(struct bfa_ioc_s *ioc);
@@ -960,8 +939,6 @@ bfa_status_t bfa_ablk_optrom_en(struct bfa_ablk_s *ablk,
 bfa_status_t bfa_ablk_optrom_dis(struct bfa_ablk_s *ablk,
 		bfa_ablk_cbfn_t cbfn, void *cbarg);
 
-bfa_status_t bfa_ioc_flash_img_get_chnk(struct bfa_ioc_s *ioc, u32 off,
-				u32 *fwimg);
 /*
  * bfa mfg wwn API functions
  */
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index f1b80da298c8..f1fc469d60cc 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -46,6 +46,7 @@ static enum bfi_ioc_state bfa_ioc_cb_get_cur_ioc_fwstate(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_set_alt_ioc_fwstate(
 			struct bfa_ioc_s *ioc, enum bfi_ioc_state fwstate);
 static enum bfi_ioc_state bfa_ioc_cb_get_alt_ioc_fwstate(struct bfa_ioc_s *ioc);
+static bfa_status_t bfa_ioc_cb_pll_init(void __iomem *rb, enum bfi_asic_mode fcmode);
 
 static struct bfa_ioc_hwif_s hwif_cb;
 
@@ -361,7 +362,7 @@ bfa_ioc_cb_sync_complete(struct bfa_ioc_s *ioc)
 	}
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_ioc_cb_pll_init(void __iomem *rb, enum bfi_asic_mode fcmode)
 {
 	u32	pll_sclk, pll_fclk, join_bits;
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 651a8fb93037..12a9529b525f 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -50,6 +50,10 @@ static enum bfi_ioc_state bfa_ioc_ct_get_cur_ioc_fwstate(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_set_alt_ioc_fwstate(
 			struct bfa_ioc_s *ioc, enum bfi_ioc_state fwstate);
 static enum bfi_ioc_state bfa_ioc_ct_get_alt_ioc_fwstate(struct bfa_ioc_s *ioc);
+static bfa_status_t bfa_ioc_ct_pll_init(void __iomem *rb,
+					enum bfi_asic_mode mode);
+static bfa_status_t bfa_ioc_ct2_pll_init(void __iomem *rb,
+					 enum bfi_asic_mode mode);
 
 static struct bfa_ioc_hwif_s hwif_ct;
 static struct bfa_ioc_hwif_s hwif_ct2;
@@ -372,7 +376,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	writel(r32, rb + FNC_PERS_REG);
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_ct2_lpu_read_stat(struct bfa_ioc_s *ioc)
 {
 	u32	r32;
@@ -586,7 +590,7 @@ bfa_ioc_ct2_poweron(struct bfa_ioc_s *ioc)
 		rb + HOSTFN_MSIX_VT_INDEX_MBOX_ERR);
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_ioc_ct_pll_init(void __iomem *rb, enum bfi_asic_mode mode)
 {
 	u32	pll_sclk, pll_fclk, r32;
@@ -752,7 +756,7 @@ bfa_ioc_ct2_mem_init(void __iomem *rb)
 	writel(0, (rb + CT2_MBIST_CTL_REG));
 }
 
-void
+static void
 bfa_ioc_ct2_mac_reset(void __iomem *rb)
 {
 	/* put port0, port1 MAC & AHB in reset */
@@ -892,7 +896,7 @@ bfa_ioc_ct2_wait_till_nfc_running(void __iomem *rb)
 	WARN_ON(!(r32 == CT2_NFC_STATE_RUNNING));
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_ioc_ct2_pll_init(void __iomem *rb, enum bfi_asic_mode mode)
 {
 	u32 wgn, r32, nfc_ver;
diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.h
index da570c0b8275..57c27f14a4f6 100644
--- a/drivers/scsi/bfa/bfa_plog.h
+++ b/drivers/scsi/bfa/bfa_plog.h
@@ -144,13 +144,5 @@ struct bfa_plog_s {
 void bfa_plog_init(struct bfa_plog_s *plog);
 void bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 			enum bfa_plog_eid event, u16 misc, char *log_str);
-void bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
-			enum bfa_plog_eid event, u16 misc,
-			u32 *intarr, u32 num_ints);
-void bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
-		enum bfa_plog_eid event, u16 misc, struct fchs_s *fchdr);
-void bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
-			enum bfa_plog_eid event, u16 misc,
-			struct fchs_s *fchdr, u32 pld_w0);
 
 #endif /* __BFA_PORTLOG_H__ */
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index da1721e0d167..fa59395a5257 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -419,7 +419,7 @@ bfa_port_clear_stats(struct bfa_port_s *port, bfa_port_stats_cbfn_t cbfn,
  *
  * @return void
  */
-void
+static void
 bfa_port_notify(void *arg, enum bfa_ioc_event_e event)
 {
 	struct bfa_port_s *port = (struct bfa_port_s *) arg;
@@ -773,7 +773,7 @@ bfa_cee_reset_stats(struct bfa_cee_s *cee,
  * @return void
  */
 
-void
+static void
 bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
 {
 	union bfi_cee_i2h_msg_u *msg;
@@ -809,7 +809,7 @@ bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
  * @return void
  */
 
-void
+static void
 bfa_cee_notify(void *arg, enum bfa_ioc_event_e event)
 {
 	struct bfa_cee_s *cee = (struct bfa_cee_s *) arg;
diff --git a/drivers/scsi/bfa/bfa_port.h b/drivers/scsi/bfa/bfa_port.h
index 26dc1bf14c85..6587bcf064da 100644
--- a/drivers/scsi/bfa/bfa_port.h
+++ b/drivers/scsi/bfa/bfa_port.h
@@ -54,7 +54,6 @@ struct bfa_port_s {
 
 void	     bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 				void *dev, struct bfa_trc_mod_s *trcmod);
-void	bfa_port_notify(void *arg, enum bfa_ioc_event_e event);
 
 bfa_status_t bfa_port_get_stats(struct bfa_port_s *port,
 				 union bfa_port_stats_u *stats,
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 12de292175ef..5345ebb81646 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -117,6 +117,8 @@ static void	hal_fcxp_tx_plog(struct bfa_s *bfa, u32 reqlen,
 static void	bfa_fcxp_qresume(void *cbarg);
 static void	bfa_fcxp_queue(struct bfa_fcxp_s *fcxp,
 				struct bfi_fcxp_send_req_s *send_req);
+static void bfa_fcxp_free(struct bfa_fcxp_s *fcxp);
+
 
 /*
  * forward declarations for LPS functions
@@ -143,6 +145,7 @@ static void bfa_lps_send_set_n2n_pid(struct bfa_lps_s *lps);
 static void bfa_lps_login_comp(struct bfa_lps_s *lps);
 static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
 static void bfa_lps_cvl_event(struct bfa_lps_s *lps);
+static u8 bfa_lps_get_fwtag(struct bfa_s *bfa, u8 lp_tag);
 
 /*
  * forward declaration for LPS state machine
@@ -175,6 +178,10 @@ static void __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete);
 static void bfa_fcport_stats_get_timeout(void *cbarg);
 static void bfa_fcport_stats_clr_timeout(void *cbarg);
 static void bfa_trunk_iocdisable(struct bfa_s *bfa);
+static bfa_boolean_t bfa_fcport_is_qos_enabled(struct bfa_s *bfa);
+static bfa_boolean_t bfa_fcport_is_ddport(struct bfa_s *bfa);
+static bfa_boolean_t bfa_fcport_is_trunk_enabled(struct bfa_s *bfa);
+static bfa_status_t bfa_fcport_is_pbcdisabled(struct bfa_s *bfa);
 
 /*
  * forward declaration for FC PORT state machine
@@ -256,6 +263,7 @@ static void		__bfa_cb_rport_online(void *cbarg,
 						bfa_boolean_t complete);
 static void		__bfa_cb_rport_offline(void *cbarg,
 						bfa_boolean_t complete);
+static void bfa_rport_set_lunmask(struct bfa_s *bfa, struct bfa_rport_s *rp);
 
 /*
  * forward declaration for RPORT state machine
@@ -373,7 +381,7 @@ bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	}
 }
 
-void
+static void
 bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 		enum bfa_plog_eid event,
 		u16 misc, u32 *intarr, u32 num_ints)
@@ -400,7 +408,7 @@ bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	}
 }
 
-void
+static void
 bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 			enum bfa_plog_eid event,
 			u16 misc, struct fchs_s *fchdr)
@@ -420,7 +428,7 @@ bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 	}
 }
 
-void
+static void
 bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 		      enum bfa_plog_eid event, u16 misc, struct fchs_s *fchdr,
 		      u32 pld_w0)
@@ -1021,7 +1029,7 @@ bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp)
  *
  * @return		void
  */
-void
+static void
 bfa_fcxp_free(struct bfa_fcxp_s *fcxp)
 {
 	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
@@ -1983,7 +1991,7 @@ bfa_lps_fdisclogo(struct bfa_lps_s *lps)
 	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
 }
 
-u8
+static u8
 bfa_lps_get_fwtag(struct bfa_s *bfa, u8 lp_tag)
 {
 	struct bfa_lps_mod_s    *mod = BFA_LPS_MOD(bfa);
@@ -3803,7 +3811,7 @@ bfa_fcport_disable(struct bfa_s *bfa)
 }
 
 /* If PBC is disabled on port, return error */
-bfa_status_t
+static bfa_status_t
 bfa_fcport_is_pbcdisabled(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -3865,7 +3873,7 @@ bfa_fcport_cfg_speed(struct bfa_s *bfa, enum bfa_port_speed speed)
 /*
  * Get current speed.
  */
-enum bfa_port_speed
+static enum bfa_port_speed
 bfa_fcport_get_speed(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -3933,7 +3941,7 @@ bfa_fcport_get_topology(struct bfa_s *bfa)
 /**
  * Get config topology.
  */
-enum bfa_port_topology
+static enum bfa_port_topology
 bfa_fcport_get_cfg_topology(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -4173,7 +4181,7 @@ bfa_fcport_is_dport(struct bfa_s *bfa)
 		BFA_PORT_ST_DPORT);
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_fcport_is_ddport(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -4268,7 +4276,7 @@ bfa_fcport_is_linkup(struct bfa_s *bfa)
 		 fcport->trunk.attr.state == BFA_TRUNK_ONLINE);
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_fcport_is_qos_enabled(struct bfa_s *bfa)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
@@ -4355,7 +4363,7 @@ bfa_fcport_get_bbcr_attr(struct bfa_s *bfa,
 	return BFA_STATUS_OK;
 }
 
-void
+static void
 bfa_fcport_dportenable(struct bfa_s *bfa)
 {
 	/*
@@ -4365,7 +4373,7 @@ bfa_fcport_dportenable(struct bfa_s *bfa)
 	bfa_port_set_dportenabled(&bfa->modules.port, BFA_TRUE);
 }
 
-void
+static void
 bfa_fcport_dportdisable(struct bfa_s *bfa)
 {
 	/*
@@ -4375,7 +4383,7 @@ bfa_fcport_dportdisable(struct bfa_s *bfa)
 	bfa_port_set_dportenabled(&bfa->modules.port, BFA_FALSE);
 }
 
-void
+static void
 bfa_fcport_ddportenable(struct bfa_s *bfa)
 {
 	/*
@@ -4384,7 +4392,7 @@ bfa_fcport_ddportenable(struct bfa_s *bfa)
 	bfa_sm_send_event(BFA_FCPORT_MOD(bfa), BFA_FCPORT_SM_DDPORTENABLE);
 }
 
-void
+static void
 bfa_fcport_ddportdisable(struct bfa_s *bfa)
 {
 	/*
@@ -5208,7 +5216,7 @@ bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_port_speed speed)
 }
 
 /* Set Rport LUN Mask */
-void
+static void
 bfa_rport_set_lunmask(struct bfa_s *bfa, struct bfa_rport_s *rp)
 {
 	struct bfa_lps_mod_s	*lps_mod = BFA_LPS_MOD(bfa);
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index ea2278bc78a8..69222cc946e4 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -533,11 +533,9 @@ bfa_status_t bfa_fcport_enable(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_disable(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_speed(struct bfa_s *bfa,
 				  enum bfa_port_speed speed);
-enum bfa_port_speed bfa_fcport_get_speed(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_topology(struct bfa_s *bfa,
 				     enum bfa_port_topology topo);
 enum bfa_port_topology bfa_fcport_get_topology(struct bfa_s *bfa);
-enum bfa_port_topology bfa_fcport_get_cfg_topology(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
 bfa_boolean_t bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
 u8 bfa_fcport_get_myalpa(struct bfa_s *bfa);
@@ -552,7 +550,6 @@ void bfa_fcport_event_register(struct bfa_s *bfa,
 			enum bfa_port_linkstate event), void *event_cbarg);
 bfa_boolean_t bfa_fcport_is_disabled(struct bfa_s *bfa);
 bfa_boolean_t bfa_fcport_is_dport(struct bfa_s *bfa);
-bfa_boolean_t bfa_fcport_is_ddport(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_set_qos_bw(struct bfa_s *bfa,
 				   struct bfa_qos_bw_s *qos_bw);
 enum bfa_port_speed bfa_fcport_get_ratelim_speed(struct bfa_s *bfa);
@@ -566,11 +563,6 @@ bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
 			struct bfa_cb_pending_q_s *cb);
 bfa_status_t bfa_fcport_clear_stats(struct bfa_s *bfa,
 			struct bfa_cb_pending_q_s *cb);
-bfa_boolean_t bfa_fcport_is_qos_enabled(struct bfa_s *bfa);
-bfa_boolean_t bfa_fcport_is_trunk_enabled(struct bfa_s *bfa);
-void bfa_fcport_dportenable(struct bfa_s *bfa);
-void bfa_fcport_dportdisable(struct bfa_s *bfa);
-bfa_status_t bfa_fcport_is_pbcdisabled(struct bfa_s *bfa);
 void bfa_fcport_cfg_faa(struct bfa_s *bfa, u8 state);
 bfa_status_t bfa_fcport_cfg_bbcr(struct bfa_s *bfa,
 			bfa_boolean_t on_off, u8 bb_scn);
@@ -601,7 +593,6 @@ void bfa_cb_rport_qos_scn_prio(void *rport,
  */
 #define BFA_RPORT_TAG_INVALID	0xffff
 #define BFA_LP_TAG_INVALID	0xff
-void	bfa_rport_set_lunmask(struct bfa_s *bfa, struct bfa_rport_s *rp);
 void	bfa_rport_unset_lunmask(struct bfa_s *bfa, struct bfa_rport_s *rp);
 
 /*
@@ -630,8 +621,6 @@ void bfa_fcxp_discard(struct bfa_fcxp_s *fcxp);
 void *bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp);
 void *bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp);
 
-void bfa_fcxp_free(struct bfa_fcxp_s *fcxp);
-
 void bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 		   u16 vf_id, u8 lp_tag,
 		   bfa_boolean_t cts, enum fc_cos cos,
@@ -677,7 +666,6 @@ void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz,
 		   wwn_t pwwn, wwn_t nwwn);
 void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
 void bfa_lps_set_n2n_pid(struct bfa_lps_s *lps, u32 n2n_pid);
-u8 bfa_lps_get_fwtag(struct bfa_s *bfa, u8 lp_tag);
 u32 bfa_lps_get_base_pid(struct bfa_s *bfa);
 u8 bfa_lps_get_tag_from_pid(struct bfa_s *bfa, u32 pid);
 void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 9d253cb83ee7..9b010b999825 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -38,27 +38,27 @@
 
 BFA_TRC_FILE(LDRV, BFAD);
 DEFINE_MUTEX(bfad_mutex);
-LIST_HEAD(bfad_list);
+static LIST_HEAD(bfad_list);
 
-static int	bfad_inst;
+int	bfad_inst;
 static int      num_sgpgs_parm;
 int		supported_fc4s;
-char		*host_name, *os_name, *os_patch;
-int		num_rports, num_ios, num_tms;
-int		num_fcxps, num_ufbufs;
-int		reqq_size, rspq_size, num_sgpgs;
-int		rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
+static char	*host_name, *os_name, *os_patch;
+static int	num_rports, num_ios, num_tms;
+static int	num_fcxps, num_ufbufs;
+static int	reqq_size, rspq_size, num_sgpgs;
+static int	rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
 int		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
-int		bfa_io_max_sge = BFAD_IO_MAX_SGE;
+static int	bfa_io_max_sge = BFAD_IO_MAX_SGE;
 int		bfa_log_level = 3; /* WARNING log level */
-int		ioc_auto_recover = BFA_TRUE;
+static int	ioc_auto_recover = BFA_TRUE;
 int		bfa_linkup_delay = -1;
-int		fdmi_enable = BFA_TRUE;
-int		pcie_max_read_reqsz;
+static int	fdmi_enable = BFA_TRUE;
+static int	pcie_max_read_reqsz;
 int		bfa_debugfs_enable = 1;
-int		msix_disable_cb = 0, msix_disable_ct = 0;
+static int	msix_disable_cb = 0, msix_disable_ct = 0;
 int		max_xfer_size = BFAD_MAX_SECTORS >> 1;
-int		max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
+static int	max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 
 /* Firmware releated */
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
@@ -164,6 +164,19 @@ bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event event);
 static void
 bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event event);
 
+static bfa_status_t
+bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role);
+static bfa_status_t bfad_start_ops(struct bfad_s *bfad);
+
+static void bfad_fcs_stop(struct bfad_s *bfad);
+static void bfad_init_timer(struct bfad_s *bfad);
+static int  bfad_install_msix_handler(struct bfad_s *bfad);
+static void bfad_stop(struct bfad_s *bfad);
+static void bfad_uncfg_pport(struct bfad_s *bfad);
+static int  bfad_worker(void *ptr);
+static int  bfad_setup_intr(struct bfad_s *bfad);
+static void bfad_remove_intr(struct bfad_s *bfad);
+
 /*
  * Beginning state for the driver instance, awaiting the pci_probe event
  */
@@ -527,7 +540,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
 	list_add_tail(&vport->list_entry, &bfad->pbc_vport_list);
 }
 
-void
+static void
 bfad_hal_mem_release(struct bfad_s *bfad)
 {
 	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
@@ -555,7 +568,7 @@ bfad_hal_mem_release(struct bfad_s *bfad)
 	memset(hal_meminfo, 0, sizeof(struct bfa_meminfo_s));
 }
 
-void
+static void
 bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg)
 {
 	if (num_rports > 0)
@@ -589,7 +602,7 @@ bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg)
 	num_sgpgs = bfa_cfg->drvcfg.num_sgpgs;
 }
 
-bfa_status_t
+static bfa_status_t
 bfad_hal_mem_alloc(struct bfad_s *bfad)
 {
 	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
@@ -691,7 +704,7 @@ ext:
 	return rc;
 }
 
-void
+static void
 bfad_bfa_tmo(unsigned long data)
 {
 	struct bfad_s	      *bfad = (struct bfad_s *) data;
@@ -716,7 +729,7 @@ bfad_bfa_tmo(unsigned long data)
 		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
 }
 
-void
+static void
 bfad_init_timer(struct bfad_s *bfad)
 {
 	init_timer(&bfad->hal_tmo);
@@ -727,7 +740,7 @@ bfad_init_timer(struct bfad_s *bfad)
 		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
 }
 
-int
+static int
 bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 {
 	int		rc = -ENODEV;
@@ -808,7 +821,7 @@ out:
 	return rc;
 }
 
-void
+static void
 bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 {
 	pci_iounmap(pdev, bfad->pci_bar0_kva);
@@ -819,7 +832,7 @@ bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 	pci_disable_device(pdev);
 }
 
-bfa_status_t
+static bfa_status_t
 bfad_drv_init(struct bfad_s *bfad)
 {
 	bfa_status_t	rc;
@@ -880,7 +893,7 @@ bfad_drv_uninit(struct bfad_s *bfad)
 	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
 }
 
-void
+static void
 bfad_drv_start(struct bfad_s *bfad)
 {
 	unsigned long	flags;
@@ -896,7 +909,7 @@ bfad_drv_start(struct bfad_s *bfad)
 		flush_workqueue(bfad->im->drv_workq);
 }
 
-void
+static void
 bfad_fcs_stop(struct bfad_s *bfad)
 {
 	unsigned long	flags;
@@ -911,7 +924,7 @@ bfad_fcs_stop(struct bfad_s *bfad)
 	bfa_sm_send_event(bfad, BFAD_E_FCS_EXIT_COMP);
 }
 
-void
+static void
 bfad_stop(struct bfad_s *bfad)
 {
 	unsigned long	flags;
@@ -926,7 +939,7 @@ bfad_stop(struct bfad_s *bfad)
 	bfa_sm_send_event(bfad, BFAD_E_EXIT_COMP);
 }
 
-bfa_status_t
+static bfa_status_t
 bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role)
 {
 	int		rc = BFA_STATUS_OK;
@@ -953,7 +966,7 @@ out:
 	return rc;
 }
 
-void
+static void
 bfad_uncfg_pport(struct bfad_s *bfad)
 {
 	if ((supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
@@ -967,8 +980,9 @@ bfad_uncfg_pport(struct bfad_s *bfad)
 	bfad->bfad_flags &= ~BFAD_CFG_PPORT_DONE;
 }
 
-bfa_status_t
-bfad_start_ops(struct bfad_s *bfad) {
+static bfa_status_t
+bfad_start_ops(struct bfad_s *bfad)
+{
 
 	int	retval;
 	unsigned long	flags;
@@ -1072,7 +1086,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 	return BFA_STATUS_OK;
 }
 
-int
+static int
 bfad_worker(void *ptr)
 {
 	struct bfad_s *bfad = ptr;
@@ -1094,7 +1108,7 @@ bfad_worker(void *ptr)
 /*
  *  BFA driver interrupt functions
  */
-irqreturn_t
+static irqreturn_t
 bfad_intx(int irq, void *dev_id)
 {
 	struct bfad_s	*bfad = dev_id;
@@ -1172,7 +1186,7 @@ bfad_init_msix_entry(struct bfad_s *bfad, struct msix_entry *msix_entries,
 
 }
 
-int
+static int
 bfad_install_msix_handler(struct bfad_s *bfad)
 {
 	int i, error = 0;
@@ -1208,7 +1222,7 @@ bfad_install_msix_handler(struct bfad_s *bfad)
 /*
  * Setup MSIX based interrupt.
  */
-int
+static int
 bfad_setup_intr(struct bfad_s *bfad)
 {
 	int error;
@@ -1277,7 +1291,7 @@ line_based:
 	return 0;
 }
 
-void
+static void
 bfad_remove_intr(struct bfad_s *bfad)
 {
 	int	i;
@@ -1297,7 +1311,7 @@ bfad_remove_intr(struct bfad_s *bfad)
 /*
  * PCI probe entry.
  */
-int
+static int
 bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 {
 	struct bfad_s	*bfad;
@@ -1398,7 +1412,7 @@ out:
 /*
  * PCI remove entry.
  */
-void
+static void
 bfad_pci_remove(struct pci_dev *pdev)
 {
 	struct bfad_s	      *bfad = pci_get_drvdata(pdev);
@@ -1498,7 +1512,7 @@ bfad_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	return ret;
 }
 
-int
+static int
 restart_bfa(struct bfad_s *bfad)
 {
 	unsigned long flags;
@@ -1629,7 +1643,7 @@ bfad_pci_resume(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-struct pci_device_id bfad_id_table[] = {
+static struct pci_device_id bfad_id_table[] = {
 	{
 		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
 		.device = BFA_PCI_DEVICE_ID_FC_8G2P,
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 13db3b7bc873..3668b02168f9 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -443,7 +443,7 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 	return status;
 }
 
-int
+static int
 bfad_im_issue_fc_host_lip(struct Scsi_Host *shost)
 {
 	struct bfad_im_port_s *im_port =
@@ -571,7 +571,7 @@ bfad_im_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
-void
+static void
 bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
 {
 	struct bfad_vport_s *vport = (struct bfad_vport_s *)fc_vport->dd_data;
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index d1ad0208dfe7..44cf38b9c2a5 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -23,7 +23,7 @@
 
 BFA_TRC_FILE(LDRV, BSG);
 
-int
+static int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -46,7 +46,7 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -144,7 +144,7 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ioc_stats_s *iocmd = (struct bfa_bsg_ioc_stats_s *)cmd;
@@ -154,7 +154,7 @@ bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_fwstats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -184,7 +184,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -202,7 +202,7 @@ bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_ioc_name_s *iocmd = (struct bfa_bsg_ioc_name_s *) cmd;
@@ -216,7 +216,7 @@ bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_attr_s *iocmd = (struct bfa_bsg_iocfc_attr_s *)cmd;
@@ -227,7 +227,7 @@ bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -239,7 +239,7 @@ bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_intr_s *iocmd = (struct bfa_bsg_iocfc_intr_s *)cmd;
@@ -252,7 +252,7 @@ bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -273,7 +273,7 @@ bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -323,7 +323,7 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -357,7 +357,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -378,7 +378,7 @@ bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_port_cfg_s *cmd = (struct bfa_bsg_port_cfg_s *)iocmd;
@@ -398,7 +398,7 @@ bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_maxfrsize_s *iocmd =
@@ -412,7 +412,7 @@ bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_bbcr_enable_s *iocmd =
@@ -435,7 +435,7 @@ bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_get_bbcr_attr(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_bbcr_attr_s *iocmd = (struct bfa_bsg_bbcr_attr_s *) pcmd;
@@ -473,7 +473,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -497,7 +497,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -531,7 +531,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_iostats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -556,7 +556,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -598,7 +598,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_attr_s *iocmd = (struct bfa_bsg_rport_attr_s *)cmd;
@@ -684,7 +684,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_stats_s *iocmd =
@@ -725,7 +725,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_reset_stats_s *iocmd =
@@ -761,7 +761,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_set_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_set_speed_s *iocmd =
@@ -797,7 +797,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -820,7 +820,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -848,7 +848,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -915,7 +915,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_qos_bw_s *iocmd = (struct bfa_bsg_qos_bw_s *)pcmd;
@@ -928,7 +928,7 @@ bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -957,7 +957,7 @@ bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_trl_speed_s *iocmd = (struct bfa_bsg_trl_speed_s *)pcmd;
@@ -986,7 +986,7 @@ bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_s *iocmd = (struct bfa_bsg_fcpim_s *)cmd;
@@ -999,7 +999,7 @@ bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstats_s *iocmd =
@@ -1021,7 +1021,7 @@ bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstatsclr_s *iocmd =
@@ -1043,7 +1043,7 @@ bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_get_del_itn_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_del_itn_stats_s *iocmd =
@@ -1168,7 +1168,7 @@ bfad_iocmd_itnim_get_itnstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1181,7 +1181,7 @@ bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1194,7 +1194,7 @@ bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_cfg_s *iocmd = (struct bfa_bsg_pcifn_cfg_s *)cmd;
@@ -1216,7 +1216,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_create(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1239,7 +1239,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_delete(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1261,7 +1261,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_bw(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1285,7 +1285,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_adapter_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_adapter_cfg_mode_s *iocmd =
@@ -1308,7 +1308,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_mode_s *iocmd =
@@ -1332,7 +1332,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ablk_optrom(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -1358,7 +1358,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_faa_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_faa_attr_s *iocmd = (struct bfa_bsg_faa_attr_s *)cmd;
@@ -1381,7 +1381,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_attr(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_cee_attr_s *iocmd =
@@ -1417,7 +1417,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1454,7 +1454,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1468,7 +1468,7 @@ bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_sfp_media(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_media_s *iocmd = (struct bfa_bsg_sfp_media_s *)cmd;
@@ -1490,7 +1490,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_sfp_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_speed_s *iocmd = (struct bfa_bsg_sfp_speed_s *)cmd;
@@ -1511,7 +1511,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_attr_s *iocmd =
@@ -1532,7 +1532,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_erase_part(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_s *iocmd = (struct bfa_bsg_flash_s *)cmd;
@@ -1552,7 +1552,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_update_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1584,7 +1584,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_read_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1616,7 +1616,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_temp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_get_temp_s *iocmd =
@@ -1638,7 +1638,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_memtest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_memtest_s *iocmd =
@@ -1661,7 +1661,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_loopback(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_loopback_s *iocmd =
@@ -1684,7 +1684,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_fwping(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_fwping_s *iocmd =
@@ -1708,7 +1708,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_queuetest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_qtest_s *iocmd = (struct bfa_bsg_diag_qtest_s *)cmd;
@@ -1729,7 +1729,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_sfp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_show_s *iocmd =
@@ -1752,7 +1752,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_led_s *iocmd = (struct bfa_bsg_diag_led_s *)cmd;
@@ -1765,7 +1765,7 @@ bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_beacon_s *iocmd =
@@ -1780,7 +1780,7 @@ bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_lb_stat_s *iocmd =
@@ -1795,7 +1795,7 @@ bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =
@@ -1817,7 +1817,7 @@ bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -1837,7 +1837,7 @@ bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =
@@ -1862,7 +1862,7 @@ bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_diag_dport_show_s *iocmd =
@@ -1877,7 +1877,7 @@ bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 }
 
 
-int
+static int
 bfad_iocmd_phy_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_attr_s *iocmd =
@@ -1898,7 +1898,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_stats_s *iocmd =
@@ -1919,7 +1919,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_read(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_phy_s *iocmd = (struct bfa_bsg_phy_s *)cmd;
@@ -1951,7 +1951,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vhba_attr_s *iocmd =
@@ -1970,7 +1970,7 @@ bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_update(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_phy_s *iocmd = (struct bfa_bsg_phy_s *)cmd;
@@ -2000,7 +2000,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_porglog_get(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_debug_s *iocmd = (struct bfa_bsg_debug_s *)cmd;
@@ -2020,7 +2020,7 @@ out:
 }
 
 #define BFA_DEBUG_FW_CORE_CHUNK_SZ	0x4000U /* 16K chunks for FW dump */
-int
+static int
 bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -2054,7 +2054,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2075,7 +2075,7 @@ bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_portlogctl_s *iocmd = (struct bfa_bsg_portlogctl_s *)cmd;
@@ -2089,7 +2089,7 @@ bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_cfg_profile(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_profile_s *iocmd =
@@ -2135,7 +2135,7 @@ bfad_iocmd_itnim_get_ioprofile(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =
@@ -2160,7 +2160,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2184,7 +2184,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
@@ -2206,7 +2206,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
@@ -2228,7 +2228,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_preboot_s *iocmd = (struct bfa_bsg_preboot_s *)cmd;
@@ -2247,7 +2247,7 @@ bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
@@ -2270,7 +2270,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
@@ -2293,7 +2293,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2333,7 +2333,7 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_trunk_attr_s *iocmd = (struct bfa_bsg_trunk_attr_s *)cmd;
@@ -2356,7 +2356,7 @@ bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2384,7 +2384,7 @@ bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_attr_s *iocmd = (struct bfa_bsg_qos_attr_s *)cmd;
@@ -2410,7 +2410,7 @@ bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_vc_attr_s *iocmd =
@@ -2442,7 +2442,7 @@ bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =
@@ -2474,7 +2474,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2505,7 +2505,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_stats_s *iocmd =
@@ -2528,7 +2528,7 @@ out:
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_reset_stats_s *iocmd =
@@ -2565,7 +2565,7 @@ bfad_iocmd_lunmask_reset_lunscan_mode(struct bfad_s *bfad, int lunmask_cfg)
 		bfad_reset_sdev_bflags(vport->drv_port.im_port, lunmask_cfg);
 }
 
-int
+static int
 bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -2588,7 +2588,7 @@ bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_query_s *iocmd =
@@ -2602,7 +2602,7 @@ bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_s *iocmd =
@@ -2621,7 +2621,7 @@ bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =
@@ -2636,7 +2636,7 @@ bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =
@@ -2651,7 +2651,7 @@ bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =
@@ -2673,7 +2673,7 @@ bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =
@@ -2695,7 +2695,7 @@ bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =
@@ -2717,7 +2717,7 @@ bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =
@@ -2739,7 +2739,7 @@ bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_get_max_size(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_max_size_s *iocmd =
@@ -3191,7 +3191,7 @@ out:
 }
 
 /* FC passthru call backs */
-u64
+static u64
 bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3203,7 +3203,7 @@ bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 	return addr;
 }
 
-u32
+static u32
 bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3213,7 +3213,7 @@ bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 	return sge->sg_len;
 }
 
-u64
+static u64
 bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3225,7 +3225,7 @@ bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 	return addr;
 }
 
-u32
+static u32
 bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3235,7 +3235,7 @@ bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 	return sge->sg_len;
 }
 
-void
+static void
 bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 		bfa_status_t req_status, u32 rsp_len, u32 resid_len,
 		struct fchs_s *rsp_fchs)
@@ -3250,7 +3250,7 @@ bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 	complete(&drv_fcxp->comp);
 }
 
-struct bfad_buf_info *
+static struct bfad_buf_info *
 bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 		 uint32_t payload_len, uint32_t *num_sgles)
 {
@@ -3293,7 +3293,7 @@ out_free_mem:
 	return NULL;
 }
 
-void
+static void
 bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 		   uint32_t num_sgles)
 {
@@ -3311,7 +3311,7 @@ bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 	}
 }
 
-int
+static int
 bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
@@ -3351,7 +3351,7 @@ bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 	return BFA_STATUS_OK;
 }
 
-int
+static int
 bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index f9e862093a25..b70870411af6 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -299,61 +299,19 @@ bfa_status_t	bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 				  struct device *dev);
 bfa_status_t	bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
 			       struct bfa_lport_cfg_s *port_cfg);
-bfa_status_t	bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role);
-bfa_status_t	bfad_drv_init(struct bfad_s *bfad);
-bfa_status_t	bfad_start_ops(struct bfad_s *bfad);
-void		bfad_drv_start(struct bfad_s *bfad);
-void		bfad_uncfg_pport(struct bfad_s *bfad);
-void		bfad_stop(struct bfad_s *bfad);
-void		bfad_fcs_stop(struct bfad_s *bfad);
-void		bfad_remove_intr(struct bfad_s *bfad);
-void		bfad_hal_mem_release(struct bfad_s *bfad);
 void		bfad_hcb_comp(void *arg, bfa_status_t status);
 
-int		bfad_setup_intr(struct bfad_s *bfad);
-void		bfad_remove_intr(struct bfad_s *bfad);
-void		bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg);
-bfa_status_t	bfad_hal_mem_alloc(struct bfad_s *bfad);
-void		bfad_bfa_tmo(unsigned long data);
-void		bfad_init_timer(struct bfad_s *bfad);
-int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad);
-void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad);
 void		bfad_drv_uninit(struct bfad_s *bfad);
-int		bfad_worker(void *ptr);
 void		bfad_debugfs_init(struct bfad_port_s *port);
 void		bfad_debugfs_exit(struct bfad_port_s *port);
 
-void bfad_pci_remove(struct pci_dev *pdev);
-int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid);
 void bfad_rport_online_wait(struct bfad_s *bfad);
 int bfad_get_linkup_delay(struct bfad_s *bfad);
-int bfad_install_msix_handler(struct bfad_s *bfad);
-
-extern struct idr bfad_im_port_index;
-extern struct pci_device_id bfad_id_table[];
-extern struct list_head bfad_list;
-extern char	*os_name;
-extern char	*os_patch;
-extern char	*host_name;
-extern int	num_rports;
-extern int	num_ios;
-extern int	num_tms;
-extern int	num_fcxps;
-extern int	num_ufbufs;
-extern int	reqq_size;
-extern int	rspq_size;
-extern int	num_sgpgs;
-extern int      rport_del_timeout;
+
 extern int      bfa_lun_queue_depth;
-extern int      bfa_io_max_sge;
 extern int      bfa_log_level;
-extern int      ioc_auto_recover;
 extern int      bfa_linkup_delay;
-extern int      msix_disable_cb;
-extern int      msix_disable_ct;
-extern int      fdmi_enable;
 extern int      supported_fc4s;
-extern int	pcie_max_read_reqsz;
 extern int	max_xfer_size;
 extern int bfa_debugfs_enable;
 extern struct mutex bfad_mutex;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 02d806012fa1..f56a22a640ea 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -28,7 +28,8 @@
 
 BFA_TRC_FILE(LDRV, IM);
 
-DEFINE_IDR(bfad_im_port_index);
+static DEFINE_IDR(bfad_im_port_index);
+static struct scsi_host_template bfad_im_vport_template;
 struct scsi_transport_template *bfad_im_scsi_transport_template;
 struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
@@ -36,6 +37,14 @@ static int bfad_im_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmnd);
 static int bfad_im_slave_alloc(struct scsi_device *sdev);
 static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 				struct bfad_itnim_s *itnim);
+static void bfad_destroy_workq(struct bfad_im_s *im);
+static void bfad_handle_qfull(struct bfad_itnim_s *itnim,
+			      struct scsi_device *sdev);
+static struct Scsi_Host * bfad_scsi_host_alloc(struct bfad_im_port_s *im_port,
+					       struct bfad_s *bfad);
+static bfa_status_t bfad_thread_workq(struct bfad_s *bfad);
+static void bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim,
+				struct scsi_device *sdev);
 
 void
 bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
@@ -740,7 +749,7 @@ bfad_im_probe_undo(struct bfad_s *bfad)
 	}
 }
 
-struct Scsi_Host *
+static struct Scsi_Host *
 bfad_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 {
 	struct scsi_host_template *sht;
@@ -768,7 +777,7 @@ bfad_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 	kfree(im_port);
 }
 
-void
+static void
 bfad_destroy_workq(struct bfad_im_s *im)
 {
 	if (im && im->drv_workq) {
@@ -778,7 +787,7 @@ bfad_destroy_workq(struct bfad_im_s *im)
 	}
 }
 
-bfa_status_t
+static bfa_status_t
 bfad_thread_workq(struct bfad_s *bfad)
 {
 	struct bfad_im_s      *im = bfad->im;
@@ -830,7 +839,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
 };
 
-struct scsi_host_template bfad_im_vport_template = {
+static struct scsi_host_template bfad_im_vport_template = {
 	.module = THIS_MODULE,
 	.name = BFAD_DRIVER_NAME,
 	.info = bfad_im_info,
@@ -881,7 +890,7 @@ bfad_im_module_exit(void)
 	idr_destroy(&bfad_im_port_index);
 }
 
-void
+static void
 bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 {
 	struct scsi_device *tmp_sdev;
@@ -903,7 +912,7 @@ bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 	}
 }
 
-void
+static void
 bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 {
 	struct scsi_device *tmp_sdev;
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 836fdc221edd..10761786287a 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -142,20 +142,12 @@ struct bfad_im_s {
 			   &(_drv)->im->aen_im_notify_work);		      \
 } while (0)
 
-struct Scsi_Host *bfad_scsi_host_alloc(struct bfad_im_port_s *im_port,
-				struct bfad_s *);
-bfa_status_t bfad_thread_workq(struct bfad_s *bfad);
-void bfad_destroy_workq(struct bfad_im_s *im);
 void bfad_fc_host_init(struct bfad_im_port_s *im_port);
 void bfad_scsi_host_free(struct bfad_s *bfad,
 				 struct bfad_im_port_s *im_port);
-void bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim,
-				 struct scsi_device *sdev);
-void bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev);
 struct bfad_itnim_s *bfad_get_itnim(struct bfad_im_port_s *im_port, int id);
 
 extern struct scsi_host_template bfad_im_scsi_host_template;
-extern struct scsi_host_template bfad_im_vport_template;
 extern struct fc_function_template bfad_im_fc_function_template;
 extern struct fc_function_template bfad_im_vport_fc_function_template;
 extern struct scsi_transport_template *bfad_im_scsi_transport_template;
@@ -164,8 +156,6 @@ extern struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 extern struct device_attribute *bfad_im_host_attrs[];
 extern struct device_attribute *bfad_im_vport_attrs[];
 
-irqreturn_t bfad_intx(int irq, void *dev_id);
-
 int bfad_im_bsg_request(struct fc_bsg_job *job);
 int bfad_im_bsg_timeout(struct fc_bsg_job *job);
 
-- 
2.9.0
