From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 06/23] bfa: statistics and typo fix
Date: Tue, 15 Jun 2010 11:35:52 -0700
Message-ID: <1276626952-4571-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:41911 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648Ab0FOSgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:36:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

- Added time stamp for fcport stats reset
- Added new fileds to the statistics data structures.
- Typo removal and minor cleanup.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcpim_priv.h               |    1 +
 drivers/scsi/bfa/bfa_fcport.c                   |   25 +++++++++++++++++++-
 drivers/scsi/bfa/bfa_port.c                     |   27 +++++++++++++++++++++-
 drivers/scsi/bfa/bfa_port_priv.h                |    3 +-
 drivers/scsi/bfa/bfad_drv.h                     |   13 -----------
 drivers/scsi/bfa/fcpim.c                        |    1 +
 drivers/scsi/bfa/include/bfa.h                  |    2 +
 drivers/scsi/bfa/include/cna/port/bfa_port.h    |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h   |    6 ++--
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h |   26 ++++++++-------------
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h  |   12 ++++++---
 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h  |   10 ++++++++
 drivers/scsi/bfa/include/defs/bfa_defs_port.h   |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h  |    4 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |   24 +++++++++++---------
 drivers/scsi/bfa/ms.c                           |    3 ++
 16 files changed, 105 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim_priv.h b/drivers/scsi/bfa/bfa_fcpim_priv.h
index 5cf4184..3db39da 100644
--- a/drivers/scsi/bfa/bfa_fcpim_priv.h
+++ b/drivers/scsi/bfa/bfa_fcpim_priv.h
@@ -141,6 +141,7 @@ struct bfa_itnim_s {
 	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
 	struct bfa_fcpim_mod_s *fcpim;	/*  fcpim module                */
 	struct bfa_itnim_hal_stats_s	stats;
+	struct bfa_itnim_latency_s  io_latency;
 };
 
 #define bfa_itnim_is_online(_itnim) ((_itnim)->is_online)
diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index d28b721..18d3307 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -888,6 +888,7 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	struct bfa_pport_cfg_s *port_cfg = &fcport->cfg;
 	struct bfa_fcport_ln_s *ln = &fcport->ln;
+	struct bfa_timeval_s tv;
 
 	bfa_os_memset(fcport, 0, sizeof(struct bfa_fcport_s));
 	fcport->bfa = bfa;
@@ -899,6 +900,12 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_sm_set_state(ln, bfa_fcport_ln_sm_dn);
 
 	/**
+	 * initialize time stamp for stats reset
+	 */
+	bfa_os_gettimeofday(&tv);
+	fcport->stats_reset_time = tv.tv_sec;
+
+	/**
 	 * initialize and set default configuration
 	 */
 	port_cfg->topology = BFA_PPORT_TOPOLOGY_P2P;
@@ -1126,16 +1133,22 @@ __bfa_cb_fcport_stats_get(void *cbarg, bfa_boolean_t complete)
 
 	if (complete) {
 		if (fcport->stats_status == BFA_STATUS_OK) {
+			struct bfa_timeval_s tv;
 
 			/* Swap FC QoS or FCoE stats */
-			if (bfa_ioc_get_fcmode(&fcport->bfa->ioc))
+			if (bfa_ioc_get_fcmode(&fcport->bfa->ioc)) {
 				bfa_fcport_qos_stats_swap(
 					&fcport->stats_ret->fcqos,
 					&fcport->stats->fcqos);
-			else
+			} else {
 				bfa_fcport_fcoe_stats_swap(
 					&fcport->stats_ret->fcoe,
 					&fcport->stats->fcoe);
+
+				bfa_os_gettimeofday(&tv);
+				fcport->stats_ret->fcoe.secs_reset =
+					tv.tv_sec - fcport->stats_reset_time;
+			}
 		}
 		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
 	} else {
@@ -1191,6 +1204,14 @@ __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete)
 	struct bfa_fcport_s *fcport = cbarg;
 
 	if (complete) {
+		struct bfa_timeval_s tv;
+
+		/**
+		 * re-initialize time stamp for stats reset
+		 */
+		bfa_os_gettimeofday(&tv);
+		fcport->stats_reset_time = tv.tv_sec;
+
 		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
 	} else {
 		fcport->stats_busy = BFA_FALSE;
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index cab1902..6773e22 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -102,9 +102,14 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->stats_busy = BFA_FALSE;
 
 	if (status == BFA_STATUS_OK) {
+		struct bfa_timeval_s tv;
+
 		memcpy(port->stats, port->stats_dma.kva,
 		       sizeof(union bfa_pport_stats_u));
 		bfa_port_stats_swap(port, port->stats);
+
+		bfa_os_gettimeofday(&tv);
+		port->stats->fc.secs_reset = tv.tv_sec - port->stats_reset_time;
 	}
 
 	if (port->stats_cbfn) {
@@ -125,9 +130,17 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 static void
 bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 {
+	struct bfa_timeval_s tv;
+
 	port->stats_status = status;
 	port->stats_busy = BFA_FALSE;
 
+	/**
+	 * re-initialize time stamp for stats reset
+	 */
+	bfa_os_gettimeofday(&tv);
+	port->stats_reset_time = tv.tv_sec;
+
 	if (port->stats_cbfn) {
 		port->stats_cbfn(port->stats_cbarg, status);
 		port->stats_cbfn = NULL;
@@ -428,6 +441,8 @@ void
 bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc, void *dev,
 		struct bfa_trc_mod_s *trcmod, struct bfa_log_mod_s *logmod)
 {
+	struct bfa_timeval_s tv;
+
 	bfa_assert(port);
 
 	port->dev = dev;
@@ -435,13 +450,21 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc, void *dev,
 	port->trcmod = trcmod;
 	port->logmod = logmod;
 
-	port->stats_busy = port->endis_pending = BFA_FALSE;
-	port->stats_cbfn = port->endis_cbfn = NULL;
+	port->stats_busy = BFA_FALSE;
+	port->endis_pending = BFA_FALSE;
+	port->stats_cbfn = NULL;
+	port->endis_cbfn = NULL;
 
 	bfa_ioc_mbox_regisr(port->ioc, BFI_MC_PORT, bfa_port_isr, port);
 	bfa_ioc_hbfail_init(&port->hbfail, bfa_port_hbfail, port);
 	bfa_ioc_hbfail_register(port->ioc, &port->hbfail);
 
+	/**
+	 * initialize time stamp for stats reset
+	 */
+	bfa_os_gettimeofday(&tv);
+	port->stats_reset_time = tv.tv_sec;
+
 	bfa_trc(port, 0);
 }
 
diff --git a/drivers/scsi/bfa/bfa_port_priv.h b/drivers/scsi/bfa/bfa_port_priv.h
index c52fe56..c9ebe04 100644
--- a/drivers/scsi/bfa/bfa_port_priv.h
+++ b/drivers/scsi/bfa/bfa_port_priv.h
@@ -75,8 +75,9 @@ struct bfa_fcport_s {
 	bfa_status_t            stats_status; /*  stats/statsclr status */
 	bfa_boolean_t           stats_busy; /*  outstanding stats/statsclr */
 	bfa_boolean_t           stats_qfull;
+	u32                	stats_reset_time; /* stats reset time stamp */
 	bfa_cb_pport_t          stats_cbfn; /*  driver callback function */
-	void                    *stats_cbarg; /* *!< user callback arg */
+	void                    *stats_cbarg; /* user callback arg */
 	bfa_boolean_t           diag_busy; /*  diag busy status */
 	bfa_boolean_t           beacon; /*  port beacon status */
 	bfa_boolean_t           link_e2e_beacon; /*  link beacon status */
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 5de43c3..0d3bfba 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -141,18 +141,6 @@ struct bfad_cfg_param_s {
 	u32        binding_method;
 };
 
-union bfad_tmp_buf {
-	/* From struct bfa_adapter_attr_s */
-	char            manufacturer[BFA_ADAPTER_MFG_NAME_LEN];
-	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
-	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
-	char            fw_ver[BFA_VERSION_LEN];
-	char            optrom_ver[BFA_VERSION_LEN];
-
-	/* From struct bfa_ioc_pci_attr_s */
-	u8         chip_rev[BFA_IOC_CHIP_REV_LEN];  /*  chip revision */
-};
-
 /*
  * BFAD (PCI function) data structure
  */
@@ -195,7 +183,6 @@ struct bfad_s {
 	struct bfa_plog_s      plog_buf;
 	int             ref_count;
 	bfa_boolean_t	ipfc_enabled;
-	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
 	struct list_head pbc_pcfg_list;
 	u32 fwtrc_len;
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 8ae4a2c..4120181 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -738,6 +738,7 @@ bfa_fcs_itnim_attr_get(struct bfa_fcs_port_s *port, wwn_t rpwwn,
 	attr->rec_support = itnim->rec_support;
 	attr->conf_comp = itnim->conf_comp;
 	attr->task_retry_id = itnim->task_retry_id;
+	bfa_os_memset(&attr->io_latency, 0, sizeof(struct bfa_itnim_latency_s));
 
 	return BFA_STATUS_OK;
 }
diff --git a/drivers/scsi/bfa/include/bfa.h b/drivers/scsi/bfa/include/bfa.h
index 1f5966c..9519a6d 100644
--- a/drivers/scsi/bfa/include/bfa.h
+++ b/drivers/scsi/bfa/include/bfa.h
@@ -126,6 +126,8 @@ struct bfa_sge_s {
 	bfa_ioc_get_type(&(__bfa)->ioc)
 #define bfa_get_mac(__bfa)  \
 	bfa_ioc_get_mac(&(__bfa)->ioc)
+#define bfa_get_fw_clock_res(__bfa)    \
+	((__bfa)->iocfc.cfgrsp->fwcfg.fw_tick_res)
 
 /*
  * bfa API functions
diff --git a/drivers/scsi/bfa/include/cna/port/bfa_port.h b/drivers/scsi/bfa/include/cna/port/bfa_port.h
index 7cbf17d..d7babaf 100644
--- a/drivers/scsi/bfa/include/cna/port/bfa_port.h
+++ b/drivers/scsi/bfa/include/cna/port/bfa_port.h
@@ -37,6 +37,7 @@ struct bfa_port_s {
 	bfa_port_stats_cbfn_t stats_cbfn;
 	void           *stats_cbarg;
 	bfa_status_t    stats_status;
+	u32             stats_reset_time;
 	union bfa_pport_stats_u *stats;
 	struct bfa_dma_s stats_dma;
 	bfa_boolean_t   endis_pending;
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_auth.h b/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
index 45df328..f56ed87 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
@@ -125,10 +125,10 @@ struct bfa_auth_attr_s {
 	enum bfa_auth_status 	status;
 	enum bfa_auth_algo 	algo;
 	enum bfa_auth_group 	dh_grp;
-	u16		rjt_code;
-	u16		rjt_code_exp;
+	enum bfa_auth_rej_code  rjt_code;
+	enum bfa_auth_rej_code_exp rjt_code_exp;
 	u8			secret_set;
-	u8			resv[7];
+	u8			resv[3];
 };
 
 #endif /* __BFA_DEFS_AUTH_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h b/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
index a07ef4a..af86a63 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
@@ -48,7 +48,7 @@ struct bfa_fcoe_stats_s {
 	u64	disc_fcf_unavail; /*  Discovery FCF not avail	     */
 	u64	linksvc_unsupp;	/*  FIP link service req unsupp.    */
 	u64	linksvc_err;	/*  FIP link service req errors     */
-	u64	logo_req;	/*  FIP logo			     */
+	u64	logo_req;	/*  FIP logos received			     */
 	u64	clrvlink_req;	/*  Clear virtual link requests     */
 	u64	op_unsupp;	/*  FIP operation unsupp.	     */
 	u64	untagged;	/*  FIP untagged frames	     */
@@ -64,21 +64,15 @@ struct bfa_fcoe_stats_s {
 	u64	txf_timeout;	/*  Tx timeouts		     */
 	u64	txf_parity_errors; /*  Transmit parity err	     */
 	u64	txf_fid_parity_errors; /*  Transmit FID parity err  */
-	u64	tx_pause;	/*  Tx pause frames		     */
-	u64	tx_zero_pause;	/*  Tx zero pause frames	     */
-	u64	tx_first_pause;	/*  Tx first pause frames	     */
-	u64	rx_pause;	/*  Rx pause frames		     */
-	u64	rx_zero_pause;	/*  Rx zero pause frames	     */
-	u64	rx_first_pause;	/*  Rx first pause frames	     */
-	u64	rxf_ucast_octets; /*  Rx unicast octets	     */
-	u64	rxf_ucast;	/*  Rx unicast frames		     */
-	u64	rxf_ucast_vlan;	/*  Rx unicast vlan frames	     */
-	u64	rxf_mcast_octets; /*  Rx multicast octets	     */
-	u64	rxf_mcast;	/*  Rx multicast frames	     */
-	u64	rxf_mcast_vlan;	/*  Rx multicast vlan frames	     */
-	u64	rxf_bcast_octets; /*  Rx broadcast octests	     */
-	u64	rxf_bcast;	/*  Rx broadcast frames	     */
-	u64	rxf_bcast_vlan;	/*  Rx broadcast vlan frames	     */
+	u64     rxf_ucast_octets; /* Rx FCoE unicast octets        */
+	u64     rxf_ucast;      /* Rx FCoE unicast frames          */
+	u64     rxf_ucast_vlan; /* Rx FCoE unicast vlan frames     */
+	u64     rxf_mcast_octets; /* Rx FCoE multicast octets      */
+	u64     rxf_mcast;      /* Rx FCoE multicast frames        */
+	u64     rxf_mcast_vlan; /* Rx FCoE multicast vlan frames   */
+	u64     rxf_bcast_octets; /* Rx FCoE broadcast octets      */
+	u64     rxf_bcast;      /* Rx FCoE broadcast frames        */
+	u64     rxf_bcast_vlan; /* Rx FCoE broadcast vlan frames   */
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
index c290fb1..31e728a 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
@@ -51,8 +51,10 @@ struct bfa_iocfc_fwcfg_s {
 	u16        num_tsktm_reqs;	/*  TM task management requests*/
 	u16        num_fcxp_reqs;	/*  unassisted FC exchanges	*/
 	u16        num_uf_bufs;	/*  unsolicited recv buffers	*/
-	u8		num_cqs;
-	u8		rsvd[5];
+	u8	   num_cqs;
+	u8         fw_tick_res;    /*!< FW clock resolution in ms */
+	u8         rsvd[4];
+
 };
 
 struct bfa_iocfc_drvcfg_s {
@@ -176,10 +178,10 @@ struct bfa_fw_port_fpg_stats_s {
     u32    nos_rx;
     u32    lip_rx;
     u32    arbf0_rx;
+    u32    arb_rx;
     u32    mrk_rx;
     u32    const_mrk_rx;
     u32    prim_unknown;
-    u32    rsvd;
 };
 
 
@@ -200,6 +202,8 @@ struct bfa_fw_port_lksm_stats_s {
     u32    lrr_tx;             /*  No. of times LRR tx started         */
     u32    ols_tx;             /*  No. of times OLS tx started         */
     u32    nos_tx;             /*  No. of times NOS tx started         */
+    u32    hwsm_lrr_rx;        /*  No. of times LRR rx-ed by HWSM      */
+    u32    hwsm_lr_rx;         /* No. of times LR rx-ed by HWSM        */
 };
 
 
@@ -239,7 +243,7 @@ struct bfa_fw_fip_stats_s {
     u32    disc_fcf_unavail;   /*  Discovery FCF Not Avail.            */
     u32    linksvc_unsupp;     /*  Unsupported link service req        */
     u32    linksvc_err;        /*  Parse error in link service req     */
-    u32    logo_req;           /*  Number of FIP logos received        */
+    u32    logo_req;           /*  FIP logos received	               */
     u32    clrvlink_req;       /*  Clear virtual link req              */
     u32    op_unsupp;          /*  Unsupported FIP operation           */
     u32    untagged;           /*  Untagged frames (ignored)           */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h b/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h
index 2ec7699..d77788b 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_itnim.h
@@ -34,6 +34,15 @@ enum bfa_itnim_state {
 	BFA_ITNIM_INITIATIOR 	= 7,	/*  initiator */
 };
 
+struct bfa_itnim_latency_s {
+	u32	min;
+	u32	max;
+	u32	count;
+	u32	clock_res;
+	u32	avg;
+	u32	rsvd;
+};
+
 struct bfa_itnim_hal_stats_s {
 	u32	onlines;	/*  ITN nexus onlines (PRLI done) */
 	u32	offlines;	/*  ITN Nexus offlines 	*/
@@ -91,6 +100,7 @@ struct bfa_itnim_attr_s {
 	u8	task_retry_id;  /*  task retry ident support   */
 	u8 rec_support;    /*  REC supported              */
 	u8 conf_comp;      /*  confirmed completion supp  */
+	struct bfa_itnim_latency_s  io_latency; /* IO latency  */
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_port.h b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
index 752a812..ebdf0d1 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_port.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
@@ -159,7 +159,7 @@ struct bfa_port_stats_s {
 	u32        ms_plogi_rsp_err;
 	u32        ms_plogi_acc_err;
 	u32        ms_plogi_accepts;
-	u32        ms_rejects;	/* NS command rejects */
+	u32        ms_rejects;	/* MS command rejects */
 	u32        ms_plogi_unknown_rsp;
 	u32        ms_plogi_alloc_wait;
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index de6181c..2c2cec5 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -246,7 +246,7 @@ struct bfa_pport_fc_stats_s {
 	u64    secs_reset; /* Seconds since stats is reset     */
 	u64    tx_frames;  /* Tx frames                */
 	u64    tx_words;   /* Tx words                 */
-	u64    tx_lip;     /* TX LIP               */
+	u64    tx_lip;     /* Tx LIP               */
 	u64    tx_nos;     /* Tx NOS               */
 	u64    tx_ols;     /* Tx OLS               */
 	u64    tx_lr;      /* Tx LR                */
@@ -312,7 +312,7 @@ struct bfa_pport_eth_stats_s {
 	u64    rx_zero_pause;    /* Rx zero pause              */
 	u64    tx_pause;     /* Tx pause               */
 	u64    tx_zero_pause;    /* Tx zero pause              */
-	u64    rx_fcoe_pause;    /* Rx fcoe pause              */
+	u64    rx_fcoe_pause;    /* Rx FCoE pause              */
 	u64    rx_fcoe_zero_pause; /* Rx FCoE zero pause       */
 	u64    tx_fcoe_pause;    /* Tx FCoE pause              */
 	u64    tx_fcoe_zero_pause; /* Tx FCoE zero pause       */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index 819db5a..7cef900 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -84,8 +84,9 @@ enum bfa_status {
 	BFA_STATUS_BADFRMHDR 	= 48,	/*  Bad frame header */
 	BFA_STATUS_BADFRMSZ 	= 49,	/*  Bad frame size check and replace
 					 * SFP/cable */
-	BFA_STATUS_MISSINGFRM 	= 50,	/*  Missing frame check and replace
-					 * SFP/cable */
+	BFA_STATUS_MISSINGFRM 	= 50,   /* Missing frame check and replace
+					 * SFP/cable or for Mezz card check and
+					 * replace pass through module */
 	BFA_STATUS_LINKTIMEOUT 	= 51,	/*  Link timeout check and replace
 					 * SFP/cable */
 	BFA_STATUS_NO_FCPIM_NEXUS = 52,	/*  No FCP Nexus exists with the
@@ -173,7 +174,7 @@ enum bfa_status {
 	BFA_STATUS_LEDTEST_OP = 109, /*  LED test is operating */
 	BFA_STATUS_CEE_NOT_DN = 110, /*  eth port is not at down state, please
 				      * bring down first */
-	BFA_STATUS_10G_SPD = 111, /*  Speed setting not valid for 10G HBA */
+	BFA_STATUS_10G_SPD = 111, /*  Speed setting not valid for 10G CNA */
 	BFA_STATUS_IM_INV_TEAM_NAME = 112, /*  Invalid team name */
 	BFA_STATUS_IM_DUP_TEAM_NAME = 113, /*  Given team name already
 					    * exists */
@@ -215,11 +216,11 @@ enum bfa_status {
 	BFA_STATUS_BAD_ASICBLK = 132, /*  Bad ASIC block */
 	BFA_STATUS_NO_DRIVER = 133, /*  Brocade adapter/driver not installed
 				     *  or loaded */
-	BFA_STATUS_INVALID_MAC = 134, /*  Invalid mac address */
+	BFA_STATUS_INVALID_MAC = 134, /*  Invalid MAC address */
 	BFA_STATUS_IM_NO_VLAN = 135, /*  No VLANs configured on the adapter */
 	BFA_STATUS_IM_ETH_LB_FAILED = 136, /*  Ethernet loopback test failed */
-	BFA_STATUS_IM_PVID_REMOVE = 137, /*  Cannot remove port vlan (PVID) */
-	BFA_STATUS_IM_PVID_EDIT = 138, /*  Cannot edit port vlan (PVID) */
+	BFA_STATUS_IM_PVID_REMOVE = 137, /* Cannot remove port VLAN (PVID) */
+	BFA_STATUS_IM_PVID_EDIT = 138, /* Cannot edit port VLAN (PVID) */
 	BFA_STATUS_CNA_NO_BOOT = 139, /*  Boot upload not allowed for CNA */
 	BFA_STATUS_IM_PVID_NON_ZERO = 140, /*  Port VLAN ID (PVID) is Set to
 					    * Non-Zero Value */
@@ -233,14 +234,15 @@ enum bfa_status {
 	BFA_STATUS_INSUFFICIENT_PERMS = 144, /*  User doesn't have sufficient
 					      * permissions to execute the BCU
 					      * application */
-	BFA_STATUS_IM_INV_VLAN_NAME = 145, /*  Invalid/Reserved Vlan name
+	BFA_STATUS_IM_INV_VLAN_NAME = 145, /* Invalid/Reserved VLAN name
 					    * string. The name is not allowed
-					    * for the normal Vlans */
+					    * for the normal VLAN */
 	BFA_STATUS_CMD_NOTSUPP_CNA = 146, /*  Command not supported for CNA */
-	BFA_STATUS_IM_PASSTHRU_EDIT = 147, /*  Can not edit passthru vlan id */
-	BFA_STATUS_IM_BIND_FAILED = 148, /*! < IM Driver bind operation
+	BFA_STATUS_IM_PASSTHRU_EDIT = 147, /* Can not edit passthrough VLAN
+					    * id */
+	BFA_STATUS_IM_BIND_FAILED = 148, /* IM Driver bind operation
 					  * failed */
-	BFA_STATUS_IM_UNBIND_FAILED = 149, /* ! < IM Driver unbind operation
+	BFA_STATUS_IM_UNBIND_FAILED = 149, /* IM Driver unbind operation
 					    * failed */
 	BFA_STATUS_IM_PORT_IN_TEAM = 150, /*  Port is already part of the
 					   * team */
diff --git a/drivers/scsi/bfa/ms.c b/drivers/scsi/bfa/ms.c
index 5e8c8de..e776bcb 100644
--- a/drivers/scsi/bfa/ms.c
+++ b/drivers/scsi/bfa/ms.c
@@ -157,6 +157,7 @@ bfa_fcs_port_ms_sm_plogi(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		 * Start timer for a delayed retry
 		 */
 		bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_plogi_retry);
+		ms->port->stats.ms_retries++;
 		bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port), &ms->timer,
 				bfa_fcs_port_ms_timeout, ms,
 				BFA_FCS_RETRY_TIMEOUT);
@@ -279,6 +280,7 @@ bfa_fcs_port_ms_sm_gmal(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		 */
 		if (ms->retry_cnt++ < BFA_FCS_MS_CMD_MAX_RETRIES) {
 			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gmal_retry);
+			ms->port->stats.ms_retries++;
 			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
 					&ms->timer, bfa_fcs_port_ms_timeout, ms,
 					BFA_FCS_RETRY_TIMEOUT);
@@ -479,6 +481,7 @@ bfa_fcs_port_ms_sm_gfn(struct bfa_fcs_port_ms_s *ms, enum port_ms_event event)
 		 */
 		if (ms->retry_cnt++ < BFA_FCS_MS_CMD_MAX_RETRIES) {
 			bfa_sm_set_state(ms, bfa_fcs_port_ms_sm_gfn_retry);
+			ms->port->stats.ms_retries++;
 			bfa_timer_start(BFA_FCS_GET_HAL_FROM_PORT(ms->port),
 					&ms->timer, bfa_fcs_port_ms_timeout, ms,
 					BFA_FCS_RETRY_TIMEOUT);
-- 
1.6.5.2

