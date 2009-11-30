From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/8] bfa: bfa header file changes
Date: Sun, 29 Nov 2009 17:40:49 -0800
Message-ID: <1259545249-4752-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:30859 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZK3Bko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 20:40:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Updates to bfa header files.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_cb_ioim_macros.h |    2 +-
 drivers/scsi/bfa/bfa_fcpim_priv.h     |   46 +++++++++---------
 drivers/scsi/bfa/bfa_fcxp_priv.h      |   34 +++++++-------
 drivers/scsi/bfa/bfa_ioc.h            |   80 +++++++++++++++++++++++++++-----
 drivers/scsi/bfa/bfa_iocfc.h          |   26 ++++++-----
 drivers/scsi/bfa/bfa_modules_priv.h   |   18 ++++----
 drivers/scsi/bfa/bfa_port_priv.h      |   57 ++++++++++++-----------
 drivers/scsi/bfa/bfa_priv.h           |    4 +-
 drivers/scsi/bfa/bfa_sgpg_priv.h      |   10 ++--
 drivers/scsi/bfa/bfa_trcmod_priv.h    |   62 ++++++++++++-------------
 10 files changed, 197 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_cb_ioim_macros.h b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
index 961fe43..0d4f749 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim_macros.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
@@ -129,7 +129,7 @@ bfa_cb_ioim_get_sgaddr(struct bfad_ioim_s *dio, int sgeid)
 	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
 	addr = (u64) sg_dma_address(sge);
 
-	return *((union bfi_addr_u *) &addr);
+	return *(union bfi_addr_u *) &addr;
 }
 
 static inline u32
diff --git a/drivers/scsi/bfa/bfa_fcpim_priv.h b/drivers/scsi/bfa/bfa_fcpim_priv.h
index 5cf4184..d921161 100644
--- a/drivers/scsi/bfa/bfa_fcpim_priv.h
+++ b/drivers/scsi/bfa/bfa_fcpim_priv.h
@@ -50,13 +50,13 @@ struct bfa_fcpim_mod_s {
 	u32		path_tov;
 	u16		q_depth;
 	u16		rsvd;
-	struct list_head 	itnim_q;        /*  queue of active itnim    */
-	struct list_head 	ioim_free_q;    /*  free IO resources        */
-	struct list_head 	ioim_resfree_q; /*  IOs waiting for f/w      */
-	struct list_head 	ioim_comp_q;    /*  IO global comp Q         */
-	struct list_head 	tskim_free_q;
-	u32	ios_active;	/*  current active IOs	      */
-	u32	delay_comp;
+	struct list_head 	itnim_q;        /*  queue of active itnim */
+	struct list_head 	ioim_free_q;    /*  free IO resources     */
+	struct list_head 	ioim_resfree_q; /*  IOs waiting for f/w   */
+	struct list_head 	ioim_comp_q;    /*  IO global comp Q      */
+	struct list_head	tskim_free_q;
+	u32		ios_active;	/*  current active IOs	*/
+	u32		delay_comp;
 	struct bfa_fcpim_stats_s stats;
 };
 
@@ -67,21 +67,21 @@ struct bfa_tskim_s;
  * BFA IO (initiator mode)
  */
 struct bfa_ioim_s {
-	struct list_head qe;		/*  queue elememt            */
-	bfa_sm_t		sm; 	/*  BFA ioim state machine   */
-	struct bfa_s 	        *bfa;	/*  BFA module               */
-	struct bfa_fcpim_mod_s	*fcpim;	/*  parent fcpim module      */
-	struct bfa_itnim_s 	*itnim;	/*  i-t-n nexus for this IO  */
-	struct bfad_ioim_s 	*dio;	/*  driver IO handle         */
-	u16	iotag;		/*  FWI IO tag               */
-	u16	abort_tag;	/*  unqiue abort request tag */
-	u16	nsges;		/*  number of SG elements    */
-	u16	nsgpgs;		/*  number of SG pages       */
-	struct bfa_sgpg_s *sgpg;	/*  first SG page            */
-	struct list_head sgpg_q;		/*  allocated SG pages       */
-	struct bfa_cb_qe_s hcb_qe;	/*  bfa callback qelem       */
-	bfa_cb_cbfn_t io_cbfn;		/*  IO completion handler    */
-	struct bfa_ioim_sp_s *iosp;	/*  slow-path IO handling    */
+	struct list_head 		qe;		/*  queue elememt */
+	bfa_sm_t		sm; 		/*  BFA ioim state machine   */
+	struct bfa_s 	        *bfa;		/*  BFA module               */
+	struct bfa_fcpim_mod_s	*fcpim;		/*  parent fcpim module      */
+	struct bfa_itnim_s 	*itnim;		/*  i-t-n nexus for this IO  */
+	struct bfad_ioim_s 	*dio;		/*  driver IO handle         */
+	u16		iotag;		/*  FWI IO tag               */
+	u16		abort_tag;	/*  unqiue abort request tag */
+	u16		nsges;		/*  number of SG elements    */
+	u16		nsgpgs;		/*  number of SG pages       */
+	struct bfa_sgpg_s	*sgpg;		/*  first SG page            */
+	struct list_head 		sgpg_q;	/*  allocated SG pages */
+	struct bfa_cb_qe_s	hcb_qe;		/*  bfa callback qelem       */
+	bfa_cb_cbfn_t		io_cbfn;	/*  IO completion handler    */
+	struct bfa_ioim_sp_s *iosp;		/*  slow-path IO handling    */
 };
 
 struct bfa_ioim_sp_s {
@@ -105,7 +105,7 @@ struct bfa_tskim_s {
 	struct bfad_tskim_s         *dtsk;   /*  driver task mgmt cmnd    */
 	bfa_boolean_t        notify;         /*  notify itnim on TM comp  */
 	lun_t                lun;            /*  lun if applicable        */
-	enum fcp_tm_cmnd        tm_cmnd;     /*  task management command  */
+	enum fcp_tm_cmnd     tm_cmnd;        /*  task management command  */
 	u16             tsk_tag;        /*  FWI IO tag               */
 	u8              tsecs;          /*  timeout in seconds       */
 	struct bfa_reqq_wait_s  reqq_wait;   /*  to wait for room in reqq */
diff --git a/drivers/scsi/bfa/bfa_fcxp_priv.h b/drivers/scsi/bfa/bfa_fcxp_priv.h
index 4cda493..4c2e220 100644
--- a/drivers/scsi/bfa/bfa_fcxp_priv.h
+++ b/drivers/scsi/bfa/bfa_fcxp_priv.h
@@ -29,15 +29,15 @@
 
 struct bfa_fcxp_mod_s {
 	struct bfa_s      *bfa;		/*  backpointer to BFA */
-	struct bfa_fcxp_s *fcxp_list;	/*  array of FCXPs */
+	struct bfa_fcxp_s	*fcxp_list;	/*  array of FCXPs */
 	u16        num_fcxps;	/*  max num FCXP requests */
-	struct list_head fcxp_free_q;	/*  free FCXPs */
-	struct list_head fcxp_active_q;	/*  active FCXPs */
-	void	*req_pld_list_kva;	/*  list of FCXP req pld */
-	u64 req_pld_list_pa;	/*  list of FCXP req pld */
-	void *rsp_pld_list_kva;		/*  list of FCXP resp pld */
-	u64 rsp_pld_list_pa;	/*  list of FCXP resp pld */
-	struct list_head  wait_q;		/*  wait queue for free fcxp */
+	struct list_head         fcxp_free_q;	/*  free FCXPs */
+	struct list_head         fcxp_active_q;	/*  active FCXPs */
+	void		*req_pld_list_kva; /*  list of FCXP req pld */
+	u64        req_pld_list_pa;	/*  list of FCXP req pld */
+	void		*rsp_pld_list_kva; /*  list of FCXP resp pld */
+	u64        rsp_pld_list_pa;	/*  list of FCXP resp pld */
+	struct list_head         wait_q;	/*  wait queue for free fcxp */
 	u32	req_pld_sz;
 	u32	rsp_pld_sz;
 };
@@ -60,18 +60,18 @@ struct bfa_fcxp_req_info_s {
 					 *FCXP interactions before the rport
 					 *nexus is established
 					 */
-	struct fchs_s   fchs;	/*  request FC header structure */
-	u8 cts;		/*  continous sequence */
-	u8 class;		/*  FC class for the request/response */
-	u16 max_frmsz;	/*  max send frame size */
-	u16 vf_id;		/*  vsan tag if applicable */
-	u8	lp_tag;		/*  lport tag */
-	u32 req_tot_len;	/*  request payload total length */
+	struct fchs_s          fchs;	/*  request FC header structure */
+	u8         cts;	/*  continous sequence */
+	u8         class;	/*  FC class for the request/response */
+	u16        max_frmsz;	/*  max send frame size */
+	u16        vf_id;	/*  vsan tag if applicable */
+	u8		lp_tag;	/*  lport tag */
+	u32        req_tot_len;	/*  request payload total length */
 };
 
 struct bfa_fcxp_rsp_info_s {
-	struct fchs_s rsp_fchs;		/*  Response frame's FC header will
-					 * be *sent back in this field */
+	struct fchs_s          rsp_fchs;/*  Response frame's FC header will
+					 *be *sent back in this field */
 	u8         rsp_timeout;	/*  timeout in seconds, 0-no response
 					 */
 	u8         rsvd2[3];
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 7c30f05..ad8e6f3 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -28,8 +28,8 @@
  * PCI device information required by IOC
  */
 struct bfa_pcidev_s {
-	int             pci_slot;
-	u8         pci_func;
+	int		pci_slot;
+	u8		pci_func;
 	u16	device_id;
 	bfa_os_addr_t   pci_bar_kva;
 };
@@ -39,8 +39,8 @@ struct bfa_pcidev_s {
  * Address
  */
 struct bfa_dma_s {
-	void		*kva;	/*! Kernel virtual address	*/
-	u64	pa;	/*! Physical address		*/
+	void		*kva;	/* ! Kernel virtual address	*/
+	u64	pa;	/* ! Physical address		*/
 };
 
 #define BFA_DMA_ALIGN_SZ	256
@@ -74,15 +74,18 @@ struct bfa_ioc_regs_s {
 	bfa_os_addr_t   lpu_mbox_cmd;
 	bfa_os_addr_t   lpu_mbox;
 	bfa_os_addr_t   pss_ctl_reg;
+	bfa_os_addr_t   pss_err_status_reg;
 	bfa_os_addr_t   app_pll_fast_ctl_reg;
 	bfa_os_addr_t   app_pll_slow_ctl_reg;
 	bfa_os_addr_t   ioc_sem_reg;
 	bfa_os_addr_t   ioc_usage_sem_reg;
+	bfa_os_addr_t   ioc_init_sem_reg;
 	bfa_os_addr_t   ioc_usage_reg;
 	bfa_os_addr_t   host_page_num_fn;
 	bfa_os_addr_t   heartbeat;
 	bfa_os_addr_t   ioc_fwstate;
 	bfa_os_addr_t   ll_halt;
+	bfa_os_addr_t   err_set;
 	bfa_os_addr_t   shirq_isr_next;
 	bfa_os_addr_t   shirq_msk_next;
 	bfa_os_addr_t   smem_page_start;
@@ -98,7 +101,7 @@ struct bfa_ioc_regs_s {
  * IOC Mailbox structures
  */
 struct bfa_mbox_cmd_s {
-	struct list_head		qe;
+	struct list_head	qe;
 	u32	msg[BFI_IOC_MSGSZ];
 };
 
@@ -107,8 +110,8 @@ struct bfa_mbox_cmd_s {
  */
 typedef void (*bfa_ioc_mbox_mcfunc_t)(void *cbarg, struct bfi_mbmsg_s *m);
 struct bfa_ioc_mbox_mod_s {
-	struct list_head	cmd_q;		/*  pending mbox queue	*/
-	int		nmclass;	/*  number of handlers */
+	struct list_head		cmd_q;	/*  pending mbox queue	*/
+	int			nmclass;	/*  number of handlers */
 	struct {
 		bfa_ioc_mbox_mcfunc_t	cbfn;	/*  message handlers	*/
 		void			*cbarg;
@@ -154,7 +157,6 @@ struct bfa_ioc_s {
 	struct bfa_timer_s 	ioc_timer;
 	struct bfa_timer_s 	sem_timer;
 	u32		hb_count;
-	u32		hb_fail;
 	u32		retry_count;
 	struct list_head		hb_notify_q;
 	void			*dbg_fwsave;
@@ -177,6 +179,22 @@ struct bfa_ioc_s {
 	struct bfi_ioc_attr_s	*attr;
 	struct bfa_ioc_cbfn_s	*cbfn;
 	struct bfa_ioc_mbox_mod_s mbox_mod;
+	struct bfa_ioc_hwif_s	*ioc_hwif;
+};
+
+struct bfa_ioc_hwif_s {
+	bfa_status_t	(*ioc_pll_init)	(struct bfa_ioc_s *ioc);
+	bfa_boolean_t	(*ioc_firmware_lock)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_firmware_unlock)	(struct bfa_ioc_s *ioc);
+	u32 *	(*ioc_fwimg_get_chunk)	(struct bfa_ioc_s *ioc,
+						u32 off);
+	u32	(*ioc_fwimg_get_size)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_reg_init)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_map_port)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_isr_mode_set)	(struct bfa_ioc_s *ioc,
+					bfa_boolean_t msix);
+	void		(*ioc_notify_hbfail)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_ownership_reset)	(struct bfa_ioc_s *ioc);
 };
 
 #define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
@@ -191,6 +209,15 @@ struct bfa_ioc_s {
 #define bfa_ioc_rx_bbcredit(__ioc)	((__ioc)->attr->rx_bbcredit)
 #define bfa_ioc_speed_sup(__ioc)	\
 	BFI_ADAPTER_GETP(SPEED, (__ioc)->attr->adapter_prop)
+#define bfa_ioc_get_nports(__ioc)	\
+	BFI_ADAPTER_GETP(NPORTS, (__ioc)->attr->adapter_prop)
+
+#define bfa_ioc_stats(_ioc, _stats)	((_ioc)->stats._stats++)
+#define BFA_IOC_FWIMG_MINSZ	(16 * 1024)
+
+#define BFA_IOC_FLASH_CHUNK_NO(off)		(off / BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)	(off % BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_IOC_FLASH_CHUNK_ADDR(chunkno)  (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
 
 /**
  * IOC mailbox interface
@@ -207,6 +234,17 @@ void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 /**
  * IOC interfaces
  */
+
+#define bfa_ioc_pll_init(__ioc) ((__ioc)->ioc_hwif->ioc_pll_init(__ioc))
+#define	bfa_ioc_isr_mode_set(__ioc, __msix)			\
+			((__ioc)->ioc_hwif->ioc_isr_mode_set(__ioc, __msix))
+#define	bfa_ioc_ownership_reset(__ioc)				\
+			((__ioc)->ioc_hwif->ioc_ownership_reset(__ioc))
+
+
+void bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc);
+void bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc);
+
 void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
 		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod,
 		struct bfa_trc_mod_s *trcmod,
@@ -220,16 +258,25 @@ void bfa_ioc_enable(struct bfa_ioc_s *ioc);
 void bfa_ioc_disable(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_intx_claim(struct bfa_ioc_s *ioc);
 
-void bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param);
+void bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type,
+		u32 boot_param);
 void bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *msg);
 void bfa_ioc_error_isr(struct bfa_ioc_s *ioc);
-void bfa_ioc_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t intx);
-bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc);
 void bfa_ioc_cfg_complete(struct bfa_ioc_s *ioc);
+enum bfa_ioc_type_e bfa_ioc_get_type(struct bfa_ioc_s *ioc);
+void bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num);
+void bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver);
+void bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver);
+void bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model);
+void bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc,
+		char *manufacturer);
+void bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev);
+enum bfa_ioc_state bfa_ioc_get_state(struct bfa_ioc_s *ioc);
+
 void bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr);
 void bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 		struct bfa_adapter_attr_s *ad_attr);
@@ -237,6 +284,7 @@ int bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover);
 void bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave);
 bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
 		int *trclen);
+void bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc);
 bfa_status_t bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata,
 				 int *trclen);
 u32 bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr);
@@ -245,6 +293,13 @@ void bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc);
 void bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
 	struct bfa_ioc_hbfail_notify_s *notify);
+bfa_boolean_t bfa_ioc_sem_get(bfa_os_addr_t sem_reg);
+void bfa_ioc_sem_release(bfa_os_addr_t sem_reg);
+void bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
+void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
+			struct bfi_ioc_image_hdr_s *fwhdr);
+bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
+			struct bfi_ioc_image_hdr_s *fwhdr);
 
 /*
  * bfa mfg wwn API functions
@@ -252,8 +307,7 @@ void bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
 wwn_t bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc);
 wwn_t bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc);
 wwn_t bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst);
-mac_t bfa_ioc_get_mac(struct bfa_ioc_s *ioc);
+struct mac_s bfa_ioc_get_mac(struct bfa_ioc_s *ioc);
 u64 bfa_ioc_get_adid(struct bfa_ioc_s *ioc);
 
 #endif /* __BFA_IOC_H__ */
-
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
index ce9a830..7726fb1 100644
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ b/drivers/scsi/bfa/bfa_iocfc.h
@@ -54,6 +54,7 @@ struct bfa_msix_s {
  */
 struct bfa_hwif_s {
 	void (*hw_reginit)(struct bfa_s *bfa);
+	void (*hw_reqq_ack)(struct bfa_s *bfa, int reqq);
 	void (*hw_rspq_ack)(struct bfa_s *bfa, int rspq);
 	void (*hw_msix_init)(struct bfa_s *bfa, int nvecs);
 	void (*hw_msix_install)(struct bfa_s *bfa);
@@ -69,8 +70,8 @@ struct bfa_iocfc_s {
 	struct bfa_iocfc_cfg_s 	cfg;
 	int			action;
 
-	u32        	req_cq_pi[BFI_IOC_MAX_CQS];
-	u32        	rsp_cq_ci[BFI_IOC_MAX_CQS];
+	u32		req_cq_pi[BFI_IOC_MAX_CQS];
+	u32		rsp_cq_ci[BFI_IOC_MAX_CQS];
 
 	struct bfa_cb_qe_s	init_hcb_qe;
 	struct bfa_cb_qe_s	stop_hcb_qe;
@@ -92,7 +93,7 @@ struct bfa_iocfc_s {
 	bfa_status_t		stats_status;	/*  stats/statsclr status */
 	bfa_boolean_t   	stats_busy;	/*  outstanding stats */
 	bfa_cb_ioc_t		stats_cbfn;	/*  driver callback function */
-	void           		*stats_cbarg;	/*  user callback arg */
+	void			*stats_cbarg;	/*  user callback arg */
 
 	struct bfa_dma_s   	req_cq_ba[BFI_IOC_MAX_CQS];
 	struct bfa_dma_s   	req_cq_shadow_ci[BFI_IOC_MAX_CQS];
@@ -102,7 +103,7 @@ struct bfa_iocfc_s {
 	struct bfa_hwif_s	hwif;
 
 	bfa_cb_iocfc_t		updateq_cbfn; /*  bios callback function */
-	void				*updateq_cbarg;	/*  bios callback arg */
+	void			*updateq_cbarg;	/*  bios callback arg */
 };
 
 #define bfa_lpuid(__bfa)		bfa_ioc_portid(&(__bfa)->ioc)
@@ -115,7 +116,8 @@ struct bfa_iocfc_s {
 #define bfa_isr_mode_set(__bfa, __msix)	\
 	((__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix))
 #define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)	\
-	(__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)
+	((__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap,	\
+					__nvecs, __maxvec))
 
 /*
  * FC specific IOC functions.
@@ -134,8 +136,7 @@ void bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa);
 bfa_boolean_t bfa_iocfc_is_operational(struct bfa_s *bfa);
 void bfa_iocfc_reset_queues(struct bfa_s *bfa);
 void bfa_iocfc_updateq(struct bfa_s *bfa, u32 reqq_ba, u32 rspq_ba,
-			u32 reqq_sci, u32 rspq_spi,
-			bfa_cb_iocfc_t cbfn, void *cbarg);
+	u32 reqq_sci, u32 rspq_spi, bfa_cb_iocfc_t cbfn, void *cbarg);
 
 void bfa_msix_all(struct bfa_s *bfa, int vec);
 void bfa_msix_reqq(struct bfa_s *bfa, int vec);
@@ -143,21 +144,23 @@ void bfa_msix_rspq(struct bfa_s *bfa, int vec);
 void bfa_msix_lpu_err(struct bfa_s *bfa, int vec);
 
 void bfa_hwcb_reginit(struct bfa_s *bfa);
+void bfa_hwcb_reqq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs);
 void bfa_hwcb_msix_install(struct bfa_s *bfa);
 void bfa_hwcb_msix_uninstall(struct bfa_s *bfa);
 void bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
-void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
-			u32 *nvecs, u32 *maxvec);
+void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap, u32 *nvecs,
+	u32 *maxvec);
 void bfa_hwct_reginit(struct bfa_s *bfa);
+void bfa_hwct_reqq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs);
 void bfa_hwct_msix_install(struct bfa_s *bfa);
 void bfa_hwct_msix_uninstall(struct bfa_s *bfa);
 void bfa_hwct_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
-void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
-			u32 *nvecs, u32 *maxvec);
+void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap, u32 *nvecs,
+	u32 *maxvec);
 
 void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
 void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
@@ -165,4 +168,3 @@ void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
 void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns);
 
 #endif /* __BFA_IOCFC_H__ */
-
diff --git a/drivers/scsi/bfa/bfa_modules_priv.h b/drivers/scsi/bfa/bfa_modules_priv.h
index 96f7053..654ed38 100644
--- a/drivers/scsi/bfa/bfa_modules_priv.h
+++ b/drivers/scsi/bfa/bfa_modules_priv.h
@@ -29,15 +29,15 @@
 
 
 struct bfa_modules_s {
-	struct bfa_pport_s	pport;	/*  physical port module	*/
-	struct bfa_fcxp_mod_s fcxp_mod; /*  fcxp module		*/
-	struct bfa_lps_mod_s lps_mod;   /*  fcxp module		*/
-	struct bfa_uf_mod_s uf_mod;	/*  unsolicited frame module	*/
-	struct bfa_rport_mod_s rport_mod; /*  remote port module	*/
-	struct bfa_fcpim_mod_s fcpim_mod; /*  FCP initiator module	*/
-	struct bfa_sgpg_mod_s sgpg_mod; /*  SG page module		*/
-	struct bfa_cee_s cee;   	/*  CEE Module                 */
-	struct bfa_port_s port;		/*  Physical port module	*/
+	struct bfa_fcport_s	fcport;		/*  fc port module	      */
+	struct bfa_fcxp_mod_s	fcxp_mod;	/*  fcxp module	      */
+	struct bfa_lps_mod_s	lps_mod;	/*  fcxp module	      */
+	struct bfa_uf_mod_s	uf_mod;		/*  unsolicited frame module */
+	struct bfa_rport_mod_s	rport_mod;	/*  remote port module	      */
+	struct bfa_fcpim_mod_s	fcpim_mod;	/*  FCP initiator module     */
+	struct bfa_sgpg_mod_s	sgpg_mod;	/*  SG page module	      */
+	struct bfa_cee_s        cee;            /*  CEE Module               */
+	struct bfa_port_s	port;		/*  Physical port module     */
 };
 
 #endif /* __BFA_MODULES_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_port_priv.h b/drivers/scsi/bfa/bfa_port_priv.h
index 51f698a..9cc0c70 100644
--- a/drivers/scsi/bfa/bfa_port_priv.h
+++ b/drivers/scsi/bfa/bfa_port_priv.h
@@ -23,9 +23,19 @@
 #include "bfa_intr_priv.h"
 
 /**
- * BFA physical port data structure
+ * Link notification data structure
  */
-struct bfa_pport_s {
+struct bfa_fcport_ln_s {
+	struct bfa_fcport_s	*fcport;
+	bfa_sm_t		sm;
+	struct bfa_cb_qe_s	ln_qe;	/*  BFA callback queue elem for ln */
+	enum bfa_pport_linkstate ln_event; /*  ln event for callback */
+};
+
+/**
+ * BFA FC port data structure
+ */
+struct bfa_fcport_s {
 	struct bfa_s 		*bfa;	/*  parent BFA instance */
 	bfa_sm_t		sm;	/*  port state machine */
 	wwn_t			nwwn;	/*  node wwn of physical port */
@@ -36,6 +46,8 @@ struct bfa_pport_s {
 	enum bfa_pport_topology topology;	/*  current topology */
 	u8			myalpa;	/*  my ALPA in LOOP topology */
 	u8			rsvd[3];
+	u32		mypid:24;
+	u32		rsvd_b:8;
 	struct bfa_pport_cfg_s	cfg;	/*  current port configuration */
 	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
 	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
@@ -49,42 +61,31 @@ struct bfa_pport_s {
 	void			(*event_cbfn) (void *cbarg,
 						bfa_pport_event_t event);
 	union {
-		union bfi_pport_i2h_msg_u i2hmsg;
+		union bfi_fcport_i2h_msg_u i2hmsg;
 	} event_arg;
 	void			*bfad;	/*  BFA driver handle */
-	struct bfa_cb_qe_s		hcb_qe;	/*  BFA callback queue elem */
-	enum bfa_pport_linkstate	hcb_event;
-					/*  link event for callback */
+	struct bfa_fcport_ln_s	ln; /*  Link Notification */
+	struct bfa_cb_qe_s	hcb_qe;	/*  BFA callback queue elem */
+	struct bfa_timer_s 	timer;	/*  timer */
 	u32		msgtag;	/*  fimrware msg tag for reply */
 	u8			*stats_kva;
 	u64		stats_pa;
-	union bfa_pport_stats_u *stats;	/*  pport stats */
-	u32		mypid:24;
-	u32		rsvd_b:8;
-	struct bfa_timer_s 	timer;	/*  timer */
-	union bfa_pport_stats_u 	*stats_ret;
-					/*  driver stats location */
-	bfa_status_t		stats_status;
-					/*  stats/statsclr status */
-	bfa_boolean_t   	stats_busy;
-					/*  outstanding stats/statsclr */
+	union bfa_fcport_stats_u *stats;
+	union bfa_fcport_stats_u *stats_ret; /*  driver stats location */
+	bfa_status_t		stats_status; /*  stats/statsclr status */
+	bfa_boolean_t   	stats_busy; /*  outstanding stats/statsclr */
 	bfa_boolean_t   	stats_qfull;
-	bfa_boolean_t   	diag_busy;
-					/*  diag busy status */
-	bfa_boolean_t   	beacon;
-					/*  port beacon status */
-	bfa_boolean_t   	link_e2e_beacon;
-					/*  link beacon status */
-	bfa_cb_pport_t		stats_cbfn;
-					/*  driver callback function */
-	void			*stats_cbarg;
-					/* *!< user callback arg */
+	bfa_cb_pport_t		stats_cbfn; /*  driver callback function */
+	void			*stats_cbarg; /* *!< user callback arg */
+	bfa_boolean_t   	diag_busy; /*  diag busy status */
+	bfa_boolean_t   	beacon; /*  port beacon status */
+	bfa_boolean_t   	link_e2e_beacon; /*  link beacon status */
 };
 
-#define BFA_PORT_MOD(__bfa)	(&(__bfa)->modules.pport)
+#define BFA_FCPORT_MOD(__bfa)	(&(__bfa)->modules.fcport)
 
 /*
  * public functions
  */
-void	bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void	bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 #endif /* __BFA_PORT_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_priv.h b/drivers/scsi/bfa/bfa_priv.h
index 0747a6b..e67254f 100644
--- a/drivers/scsi/bfa/bfa_priv.h
+++ b/drivers/scsi/bfa/bfa_priv.h
@@ -88,7 +88,7 @@ struct bfa_s {
 	struct bfa_iocfc_s	iocfc;		/*  IOCFC module	    */
 	struct bfa_timer_mod_s	timer_mod;	/*  timer module	    */
 	struct bfa_modules_s	modules;	/*  BFA modules	    */
-	struct list_head	comp_q;		/*  pending completions    */
+	struct list_head		comp_q;	/*  pending completions    */
 	bfa_boolean_t		rme_process;	/*  RME processing enabled */
 	struct list_head		reqq_waitq[BFI_IOC_MAX_CQS];
 	bfa_boolean_t		fcs;		/*  FCS is attached to BFA */
@@ -101,7 +101,7 @@ extern bfa_boolean_t bfa_auto_recover;
 extern struct bfa_module_s hal_mod_flash;
 extern struct bfa_module_s hal_mod_fcdiag;
 extern struct bfa_module_s hal_mod_sgpg;
-extern struct bfa_module_s hal_mod_pport;
+extern struct bfa_module_s hal_mod_fcport;
 extern struct bfa_module_s hal_mod_fcxp;
 extern struct bfa_module_s hal_mod_lps;
 extern struct bfa_module_s hal_mod_uf;
diff --git a/drivers/scsi/bfa/bfa_sgpg_priv.h b/drivers/scsi/bfa/bfa_sgpg_priv.h
index 9c2a8cb..03b1bd7 100644
--- a/drivers/scsi/bfa/bfa_sgpg_priv.h
+++ b/drivers/scsi/bfa/bfa_sgpg_priv.h
@@ -33,7 +33,7 @@
 			& ~(sizeof(struct bfi_sgpg_s) - 1))
 
 struct bfa_sgpg_wqe_s {
-	struct list_head qe;	/*  queue sg page element	*/
+	struct list_head qe;		/*  queue sg page element	*/
 	int	nsgpg;		/*  pages to be allocated	*/
 	int	nsgpg_total;	/*  total pages required	*/
 	void	(*cbfn) (void *cbarg);
@@ -44,7 +44,7 @@ struct bfa_sgpg_wqe_s {
 
 struct bfa_sgpg_s {
 	struct list_head 	qe;	/*  queue sg page element	*/
-	struct bfi_sgpg_s *sgpg; /*  va of SG page		*/
+	struct bfi_sgpg_s *sgpg;	/*  va of SG page		*/
 	union bfi_addr_u sgpg_pa;/*  pa of SG page		*/
 };
 
@@ -58,11 +58,11 @@ struct bfa_sgpg_mod_s {
 	struct bfa_s *bfa;
 	int		num_sgpgs;	/*  number of SG pages		*/
 	int		free_sgpgs;	/*  number of free SG pages	*/
-	struct bfa_sgpg_s *hsgpg_arr;	/*  BFA SG page array	*/
+	struct bfa_sgpg_s	*hsgpg_arr;	/*  BFA SG page array	*/
 	struct bfi_sgpg_s *sgpg_arr;	/*  actual SG page array	*/
 	u64	sgpg_arr_pa;	/*  SG page array DMA addr	*/
-	struct list_head sgpg_q;	/*  queue of free SG pages	*/
-	struct list_head sgpg_wait_q; /*  wait queue for SG pages	*/
+	struct list_head 	sgpg_q;		/*  queue of free SG pages */
+	struct list_head 	sgpg_wait_q;	/*  wait queue for SG pages */
 };
 #define BFA_SGPG_MOD(__bfa)	(&(__bfa)->modules.sgpg_mod)
 
diff --git a/drivers/scsi/bfa/bfa_trcmod_priv.h b/drivers/scsi/bfa/bfa_trcmod_priv.h
index b3562dc..a7a8261 100644
--- a/drivers/scsi/bfa/bfa_trcmod_priv.h
+++ b/drivers/scsi/bfa/bfa_trcmod_priv.h
@@ -29,38 +29,36 @@
  * !!! needed between trace utility and driver version
  */
 enum {
-	BFA_TRC_HAL_IOC		= 1,
-	BFA_TRC_HAL_INTR	= 2,
-	BFA_TRC_HAL_FCXP	= 3,
-	BFA_TRC_HAL_UF		= 4,
-	BFA_TRC_HAL_DIAG	= 5,
-	BFA_TRC_HAL_RPORT	= 6,
-	BFA_TRC_HAL_FCPIM	= 7,
-	BFA_TRC_HAL_IOIM	= 8,
-	BFA_TRC_HAL_TSKIM	= 9,
-	BFA_TRC_HAL_ITNIM	= 10,
-	BFA_TRC_HAL_PPORT	= 11,
-	BFA_TRC_HAL_SGPG	= 12,
-	BFA_TRC_HAL_FLASH	= 13,
-	BFA_TRC_HAL_DEBUG	= 14,
-	BFA_TRC_HAL_WWN		= 15,
-	BFA_TRC_HAL_FLASH_RAW	= 16,
-	BFA_TRC_HAL_SBOOT	= 17,
-	BFA_TRC_HAL_SBOOT_IO	= 18,
-	BFA_TRC_HAL_SBOOT_INTR	= 19,
-	BFA_TRC_HAL_SBTEST	= 20,
-	BFA_TRC_HAL_IPFC	= 21,
-	BFA_TRC_HAL_IOCFC	= 22,
-	BFA_TRC_HAL_FCPTM	= 23,
-	BFA_TRC_HAL_IOTM	= 24,
-	BFA_TRC_HAL_TSKTM	= 25,
-	BFA_TRC_HAL_TIN		= 26,
-	BFA_TRC_HAL_LPS		= 27,
-	BFA_TRC_HAL_FCDIAG	= 28,
-	BFA_TRC_HAL_PBIND	= 29,
-	BFA_TRC_HAL_IOCFC_CT	= 30,
-	BFA_TRC_HAL_IOCFC_CB	= 31,
-	BFA_TRC_HAL_IOCFC_Q	= 32,
+	BFA_TRC_HAL_INTR	= 1,
+	BFA_TRC_HAL_FCXP	= 2,
+	BFA_TRC_HAL_UF		= 3,
+	BFA_TRC_HAL_RPORT	= 4,
+	BFA_TRC_HAL_FCPIM	= 5,
+	BFA_TRC_HAL_IOIM	= 6,
+	BFA_TRC_HAL_TSKIM	= 7,
+	BFA_TRC_HAL_ITNIM	= 8,
+	BFA_TRC_HAL_FCPORT	= 9,
+	BFA_TRC_HAL_SGPG	= 10,
+	BFA_TRC_HAL_FLASH	= 11,
+	BFA_TRC_HAL_DEBUG	= 12,
+	BFA_TRC_HAL_WWN		= 13,
+	BFA_TRC_HAL_FLASH_RAW	= 14,
+	BFA_TRC_HAL_SBOOT	= 15,
+	BFA_TRC_HAL_SBOOT_IO	= 16,
+	BFA_TRC_HAL_SBOOT_INTR	= 17,
+	BFA_TRC_HAL_SBTEST	= 18,
+	BFA_TRC_HAL_IPFC	= 19,
+	BFA_TRC_HAL_IOCFC	= 20,
+	BFA_TRC_HAL_FCPTM	= 21,
+	BFA_TRC_HAL_IOTM	= 22,
+	BFA_TRC_HAL_TSKTM	= 23,
+	BFA_TRC_HAL_TIN		= 24,
+	BFA_TRC_HAL_LPS		= 25,
+	BFA_TRC_HAL_FCDIAG	= 26,
+	BFA_TRC_HAL_PBIND	= 27,
+	BFA_TRC_HAL_IOCFC_CT	= 28,
+	BFA_TRC_HAL_IOCFC_CB	= 29,
+	BFA_TRC_HAL_IOCFC_Q	= 30,
 };
 
 #endif /* __BFA_TRCMOD_PRIV_H__ */
-- 
1.6.5.2

