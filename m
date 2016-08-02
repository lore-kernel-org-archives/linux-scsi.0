From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/5] bfa: remove more unused functions
Date: Tue,  2 Aug 2016 17:22:50 +0200
Message-ID: <20160802152250.1964074-6-arnd@arndb.de>
References: <20160802152250.1964074-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160802152250.1964074-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Baoyou Xie <baoyou.xie@linaro.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

This is a collection of additional functions that are not called anywhere
in the driver, all being removed in this patch.

Alternatively, we could mark them as 'static __maybe_unused', to leave
the implementation around but not cause them to end up in the object
code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfa.h           |   2 -
 drivers/scsi/bfa/bfa_core.c      |  35 ----------
 drivers/scsi/bfa/bfa_fcpim.c     |   9 ---
 drivers/scsi/bfa/bfa_fcpim.h     |   1 -
 drivers/scsi/bfa/bfa_fcs.h       |  13 ----
 drivers/scsi/bfa/bfa_fcs_lport.c | 142 ---------------------------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |  36 ----------
 drivers/scsi/bfa/bfa_ioc.c       |  21 ------
 drivers/scsi/bfa/bfa_ioc.h       |   2 -
 drivers/scsi/bfa/bfa_svc.c       |  54 ---------------
 drivers/scsi/bfa/bfa_svc.h       |   5 --
 drivers/scsi/bfa/bfad.c          |  20 ------
 drivers/scsi/bfa/bfad_drv.h      |   1 -
 13 files changed, 341 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index c3b499d126d5..a61b23489e55 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -386,9 +386,7 @@ int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
 	(((&(_bfa)->modules.dconf_mod)->min_cfg)		\
 	 ? BFA_LUNMASK_MINCFG : ((bfa_get_lun_mask(_bfa))->status))
 
-void bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids);
 void bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg);
-void bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg);
 void bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg,
 			struct bfa_meminfo_s *meminfo,
 			struct bfa_s *bfa);
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 75c6db27a399..5385c277b49d 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1953,24 +1953,6 @@ bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q)
 }
 
 /*
- * Return the list of PCI vendor/device id lists supported by this
- * BFA instance.
- */
-void
-bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
-{
-	static struct bfa_pciid_s __pciids[] = {
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G2P},
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G1P},
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
-		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT_FC},
-	};
-
-	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
-	*pciids = __pciids;
-}
-
-/*
  * Use this function query the default struct bfa_iocfc_cfg_s value (compiled
  * into BFA layer). The OS driver can then turn back and overwrite entries that
  * have been configured by the user.
@@ -2006,20 +1988,3 @@ bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg)
 	cfg->drvcfg.delay_comp = BFA_FALSE;
 
 }
-
-void
-bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg)
-{
-	bfa_cfg_get_default(cfg);
-	cfg->fwcfg.num_ioim_reqs   = BFA_IOIM_MIN;
-	cfg->fwcfg.num_tskim_reqs  = BFA_TSKIM_MIN;
-	cfg->fwcfg.num_fcxp_reqs   = BFA_FCXP_MIN;
-	cfg->fwcfg.num_uf_bufs     = BFA_UF_MIN;
-	cfg->fwcfg.num_rports      = BFA_RPORT_MIN;
-	cfg->fwcfg.num_fwtio_reqs = 0;
-
-	cfg->drvcfg.num_sgpgs      = BFA_SGPG_MIN;
-	cfg->drvcfg.num_reqq_elems = BFA_REQQ_NELEMS_MIN;
-	cfg->drvcfg.num_rspq_elems = BFA_RSPQ_NELEMS_MIN;
-	cfg->drvcfg.min_cfg	   = BFA_TRUE;
-}
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 6dc3e8afa652..5853c163f8cf 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -3494,15 +3494,6 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 }
 
 /*
- * Notification on completions from related ioim.
- */
-void
-bfa_tskim_iodone(struct bfa_tskim_s *tskim)
-{
-	bfa_wc_down(&tskim->wc);
-}
-
-/*
  * Handle IOC h/w failure notification from itnim.
  */
 static void
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index c3dfd26350c2..9dbd300bd84d 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -277,7 +277,6 @@ void	bfa_ioim_good_comp_isr(struct bfa_s *bfa,
 					struct bfi_msg_s *msg);
 
 void	bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-void	bfa_tskim_iodone(struct bfa_tskim_s *tskim);
 void	bfa_tskim_res_recfg(struct bfa_s *bfa, u16 num_tskim_fw);
 
 /*
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 5409a1cfb688..f60039e95c78 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -291,15 +291,10 @@ bfa_boolean_t   bfa_fcs_lport_is_online(struct bfa_fcs_lport_s *port);
 struct bfa_fcs_lport_s *bfa_fcs_get_base_port(struct bfa_fcs_s *fcs);
 void bfa_fcs_lport_get_rport_quals(struct bfa_fcs_lport_s *port,
 			struct bfa_rport_qualifier_s rport[], int *nrports);
-wwn_t bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn,
-			      int index, int nrports, bfa_boolean_t bwwn);
-
 struct bfa_fcs_lport_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
 					    u16 vf_id, wwn_t lpwwn);
 
 void bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port, char *symname);
-void bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
-			    struct bfa_lport_info_s *port_info);
 void bfa_fcs_lport_get_attr(struct bfa_fcs_lport_s *port,
 			    struct bfa_lport_attr_s *port_attr);
 void bfa_fcs_lport_get_stats(struct bfa_fcs_lport_s *fcs_port,
@@ -321,8 +316,6 @@ void            bfa_fcs_lport_delete(struct bfa_fcs_lport_s *port);
 void		bfa_fcs_lport_stop(struct bfa_fcs_lport_s *port);
 struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_pwwn(
 		struct bfa_fcs_lport_s *port, wwn_t pwwn);
-struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_nwwn(
-		struct bfa_fcs_lport_s *port, wwn_t nwwn);
 struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_qualifier(
 		struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 pid);
 void            bfa_fcs_lport_add_rport(struct bfa_fcs_lport_s *port,
@@ -356,7 +349,6 @@ bfa_status_t bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport,
 				      struct bfa_fcs_s *fcs, u16 vf_id,
 				      struct bfa_lport_cfg_s *port_cfg,
 				      struct bfad_vport_s *vport_drv);
-bfa_boolean_t bfa_fcs_is_pbc_vport(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport);
@@ -364,7 +356,6 @@ void bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
 			    struct bfa_vport_attr_s *vport_attr);
 struct bfa_fcs_vport_s *bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs,
 					     u16 vf_id, wwn_t vpwwn);
-void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_fcs_delete(struct bfa_fcs_vport_s *vport);
@@ -444,8 +435,6 @@ void bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 			struct bfa_rport_attr_s *attr);
 struct bfa_fcs_rport_s *bfa_fcs_rport_lookup(struct bfa_fcs_lport_s *port,
 					     wwn_t rpwwn);
-struct bfa_fcs_rport_s *bfa_fcs_rport_lookup_by_nwwn(
-	struct bfa_fcs_lport_s *port, wwn_t rnwwn);
 void bfa_fcs_rport_set_del_timeout(u8 rport_tmo);
 void bfa_fcs_rport_set_max_logins(u32 max_logins);
 void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport,
@@ -454,8 +443,6 @@ void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
 
 struct bfa_fcs_rport_s *bfa_fcs_rport_create(struct bfa_fcs_lport_s *port,
 	 u32 pid);
-void bfa_fcs_rport_start(struct bfa_fcs_lport_s *port, struct fchs_s *rx_fchs,
-			 struct fc_logi_s *plogi_rsp);
 void bfa_fcs_rport_plogi_create(struct bfa_fcs_lport_s *port,
 				struct fchs_s *rx_fchs,
 				struct fc_logi_s *plogi);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 7870baedb9bd..b7e6183a016f 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -970,25 +970,6 @@ bfa_fcs_lport_get_rport_by_pwwn(struct bfa_fcs_lport_s *port, wwn_t pwwn)
 }
 
 /*
- *   NWWN based Lookup for a R-Port in the Port R-Port Queue
- */
-struct bfa_fcs_rport_s *
-bfa_fcs_lport_get_rport_by_nwwn(struct bfa_fcs_lport_s *port, wwn_t nwwn)
-{
-	struct bfa_fcs_rport_s *rport;
-	struct list_head	*qe;
-
-	list_for_each(qe, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *) qe;
-		if (wwn_is_equal(rport->nwwn, nwwn))
-			return rport;
-	}
-
-	bfa_trc(port->fcs, nwwn);
-	return NULL;
-}
-
-/*
  * PWWN & PID based Lookup for a R-Port in the Port R-Port Queue
  */
 struct bfa_fcs_rport_s *
@@ -5742,54 +5723,6 @@ bfa_fcs_get_base_port(struct bfa_fcs_s *fcs)
 	return &fcs->fabric.bport;
 }
 
-wwn_t
-bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn, int index,
-		int nrports, bfa_boolean_t bwwn)
-{
-	struct list_head	*qh, *qe;
-	struct bfa_fcs_rport_s *rport = NULL;
-	int	i;
-	struct bfa_fcs_s	*fcs;
-
-	if (port == NULL || nrports == 0)
-		return (wwn_t) 0;
-
-	fcs = port->fcs;
-	bfa_trc(fcs, (u32) nrports);
-
-	i = 0;
-	qh = &port->rport_q;
-	qe = bfa_q_first(qh);
-
-	while ((qe != qh) && (i < nrports)) {
-		rport = (struct bfa_fcs_rport_s *) qe;
-		if (bfa_ntoh3b(rport->pid) > 0xFFF000) {
-			qe = bfa_q_next(qe);
-			bfa_trc(fcs, (u32) rport->pwwn);
-			bfa_trc(fcs, rport->pid);
-			bfa_trc(fcs, i);
-			continue;
-		}
-
-		if (bwwn) {
-			if (!memcmp(&wwn, &rport->pwwn, 8))
-				break;
-		} else {
-			if (i == index)
-				break;
-		}
-
-		i++;
-		qe = bfa_q_next(qe);
-	}
-
-	bfa_trc(fcs, i);
-	if (rport)
-		return rport->pwwn;
-	else
-		return (wwn_t) 0;
-}
-
 void
 bfa_fcs_lport_get_rport_quals(struct bfa_fcs_lport_s *port,
 		struct bfa_rport_qualifier_s rports[], int *nrports)
@@ -5920,54 +5853,6 @@ bfa_fcs_lookup_port(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t lpwwn)
 	return NULL;
 }
 
-/*
- *  API corresponding to NPIV_VPORT_GETINFO.
- */
-void
-bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
-	 struct bfa_lport_info_s *port_info)
-{
-
-	bfa_trc(port->fcs, port->fabric->fabric_name);
-
-	if (port->vport == NULL) {
-		/*
-		 * This is a Physical port
-		 */
-		port_info->port_type = BFA_LPORT_TYPE_PHYSICAL;
-
-		/*
-		 * @todo : need to fix the state & reason
-		 */
-		port_info->port_state = 0;
-		port_info->offline_reason = 0;
-
-		port_info->port_wwn = bfa_fcs_lport_get_pwwn(port);
-		port_info->node_wwn = bfa_fcs_lport_get_nwwn(port);
-
-		port_info->max_vports_supp =
-			bfa_lps_get_max_vport(port->fcs->bfa);
-		port_info->num_vports_inuse =
-			port->fabric->num_vports;
-		port_info->max_rports_supp = BFA_FCS_MAX_RPORTS_SUPP;
-		port_info->num_rports_inuse = port->num_rports;
-	} else {
-		/*
-		 * This is a virtual port
-		 */
-		port_info->port_type = BFA_LPORT_TYPE_VIRTUAL;
-
-		/*
-		 * @todo : need to fix the state & reason
-		 */
-		port_info->port_state = 0;
-		port_info->offline_reason = 0;
-
-		port_info->port_wwn = bfa_fcs_lport_get_pwwn(port);
-		port_info->node_wwn = bfa_fcs_lport_get_nwwn(port);
-	}
-}
-
 void
 bfa_fcs_lport_get_stats(struct bfa_fcs_lport_s *fcs_port,
 	 struct bfa_lport_stats_s *port_stats)
@@ -6674,15 +6559,6 @@ bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport)
 }
 
 /*
- * Cleanup notification from fabric SM on link timer expiry.
- */
-void
-bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport)
-{
-	vport->vport_stats.fab_cleanup++;
-}
-
-/*
  * Stop notification from fabric SM. To be invoked from within FCS.
  */
 void
@@ -6805,24 +6681,6 @@ bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 }
 
 /*
- *	Use this function to findout if this is a pbc vport or not.
- *
- * @param[in] vport - pointer to bfa_fcs_vport_t.
- *
- * @returns None
- */
-bfa_boolean_t
-bfa_fcs_is_pbc_vport(struct bfa_fcs_vport_s *vport)
-{
-
-	if (vport && (vport->lport.port_cfg.preboot_vp == BFA_TRUE))
-		return BFA_TRUE;
-	else
-		return BFA_FALSE;
-
-}
-
-/*
  * Use this function initialize the vport.
  *
  * @param[in] vport - pointer to bfa_fcs_vport_t.
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 24e6a126edb0..ec896fa0a219 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2646,27 +2646,6 @@ bfa_fcs_rport_create_by_wwn(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	bfa_sm_send_event(rport, RPSM_EVENT_ADDRESS_DISC);
 	return rport;
 }
-/*
- * Called by bport in private loop topology to indicate that a
- * rport has been discovered and plogi has been completed.
- *
- * @param[in] port	- base port or vport
- * @param[in] rpid	- remote port ID
- */
-void
-bfa_fcs_rport_start(struct bfa_fcs_lport_s *port, struct fchs_s *fchs,
-	 struct fc_logi_s *plogi)
-{
-	struct bfa_fcs_rport_s *rport;
-
-	rport = bfa_fcs_rport_alloc(port, WWN_NULL, fchs->s_id);
-	if (!rport)
-		return;
-
-	bfa_fcs_rport_update(rport, plogi);
-
-	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_COMP);
-}
 
 /*
  *	Called by bport/vport to handle PLOGI received from a new remote port.
@@ -3089,21 +3068,6 @@ bfa_fcs_rport_lookup(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	return rport;
 }
 
-struct bfa_fcs_rport_s *
-bfa_fcs_rport_lookup_by_nwwn(struct bfa_fcs_lport_s *port, wwn_t rnwwn)
-{
-	struct bfa_fcs_rport_s *rport;
-
-	rport = bfa_fcs_lport_get_rport_by_nwwn(port, rnwwn);
-	if (rport == NULL) {
-		/*
-		 * TBD Error handling
-		 */
-	}
-
-	return rport;
-}
-
 /*
  * Remote port features (RPF) implementation.
  */
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a503a1a0f44d..992f1e7b42b8 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2274,33 +2274,12 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 	return status;
 }
 
-/*
- * Enable/disable IOC failure auto recovery.
- */
-void
-bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
-{
-	bfa_auto_recover = auto_recover;
-}
-
-
-
 bfa_boolean_t
 bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
 {
 	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op);
 }
 
-bfa_boolean_t
-bfa_ioc_is_initialized(struct bfa_ioc_s *ioc)
-{
-	u32 r32 = bfa_ioc_get_cur_ioc_fwstate(ioc);
-
-	return ((r32 != BFI_IOC_UNINIT) &&
-		(r32 != BFI_IOC_INITING) &&
-		(r32 != BFI_IOC_MEMTEST));
-}
-
 static bfa_boolean_t
 bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 {
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index a2df03dc420a..523fb02109b6 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -869,7 +869,6 @@ void bfa_ioc_ct2_poweron(struct bfa_ioc_s *ioc);
 
 void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
 		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod);
-void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
 void bfa_ioc_detach(struct bfa_ioc_s *ioc);
 void bfa_ioc_suspend(struct bfa_ioc_s *ioc);
 void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
@@ -881,7 +880,6 @@ bfa_boolean_t bfa_ioc_intx_claim(struct bfa_ioc_s *ioc);
 
 void bfa_ioc_error_isr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
-bfa_boolean_t bfa_ioc_is_initialized(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_acq_addr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 9804768c8bba..37d5c2449479 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -992,14 +992,6 @@ bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp)
 	return reqbuf;
 }
 
-u32
-bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp)
-{
-	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
-
-	return mod->req_pld_sz;
-}
-
 /*
  * Get the internal response buffer pointer
  *
@@ -1102,21 +1094,6 @@ bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 	bfa_fcxp_queue(fcxp, send_req);
 }
 
-/*
- * Abort a BFA FCXP
- *
- * @param[in]	fcxp	BFA fcxp pointer
- *
- * @return		void
- */
-bfa_status_t
-bfa_fcxp_abort(struct bfa_fcxp_s *fcxp)
-{
-	bfa_trc(fcxp->fcxp_mod->bfa, fcxp->fcxp_tag);
-	WARN_ON(1);
-	return BFA_STATUS_OK;
-}
-
 void
 bfa_fcxp_req_rsp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
 	       bfa_fcxp_alloc_cbfn_t alloc_cbfn, void *alloc_cbarg,
@@ -3976,15 +3953,6 @@ bfa_fcport_clr_hardalpa(struct bfa_s *bfa)
 	return BFA_STATUS_OK;
 }
 
-bfa_boolean_t
-bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	*alpa = fcport->cfg.hardalpa;
-	return fcport->cfg.cfg_hardalpa;
-}
-
 u8
 bfa_fcport_get_myalpa(struct bfa_s *bfa)
 {
@@ -4043,16 +4011,6 @@ bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
  * Get port attributes.
  */
 
-wwn_t
-bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-	if (node)
-		return fcport->nwwn;
-	else
-		return fcport->pwwn;
-}
-
 void
 bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 {
@@ -4225,18 +4183,6 @@ bfa_fcport_is_ratelim(struct bfa_s *bfa)
 }
 
 /*
- *	Enable/Disable FAA feature in port config
- */
-void
-bfa_fcport_cfg_faa(struct bfa_s *bfa, u8 state)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	bfa_trc(bfa, state);
-	fcport->cfg.faa_state = state;
-}
-
-/*
  * Get default minimum ratelim speed
  */
 enum bfa_port_speed
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 69222cc946e4..526292ce7da3 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -537,14 +537,12 @@ bfa_status_t bfa_fcport_cfg_topology(struct bfa_s *bfa,
 				     enum bfa_port_topology topo);
 enum bfa_port_topology bfa_fcport_get_topology(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
-bfa_boolean_t bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
 u8 bfa_fcport_get_myalpa(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_clr_hardalpa(struct bfa_s *bfa);
 bfa_status_t bfa_fcport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
 u16 bfa_fcport_get_maxfrsize(struct bfa_s *bfa);
 u8 bfa_fcport_get_rx_bbcredit(struct bfa_s *bfa);
 void bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr);
-wwn_t bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
 void bfa_fcport_event_register(struct bfa_s *bfa,
 			void (*event_cbfn) (void *cbarg,
 			enum bfa_port_linkstate event), void *event_cbarg);
@@ -563,7 +561,6 @@ bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
 			struct bfa_cb_pending_q_s *cb);
 bfa_status_t bfa_fcport_clear_stats(struct bfa_s *bfa,
 			struct bfa_cb_pending_q_s *cb);
-void bfa_fcport_cfg_faa(struct bfa_s *bfa, u8 state);
 bfa_status_t bfa_fcport_cfg_bbcr(struct bfa_s *bfa,
 			bfa_boolean_t on_off, u8 bb_scn);
 bfa_status_t bfa_fcport_get_bbcr_attr(struct bfa_s *bfa,
@@ -628,8 +625,6 @@ void bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 		   bfa_cb_fcxp_send_t cbfn,
 		   void *cbarg,
 		   u32 rsp_maxlen, u8 rsp_timeout);
-bfa_status_t bfa_fcxp_abort(struct bfa_fcxp_s *fcxp);
-u32 bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp);
 u32 bfa_fcxp_get_maxrsp(struct bfa_s *bfa);
 void bfa_fcxp_res_recfg(struct bfa_s *bfa, u16 num_fcxp_fw);
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 3cb11f6c0b28..c08cd287cfde 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -873,26 +873,6 @@ bfad_drv_init(struct bfad_s *bfad)
 	return BFA_STATUS_OK;
 }
 
-void
-bfad_drv_uninit(struct bfad_s *bfad)
-{
-	unsigned long   flags;
-
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	init_completion(&bfad->comp);
-	bfa_iocfc_stop(&bfad->bfa);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	wait_for_completion(&bfad->comp);
-
-	del_timer_sync(&bfad->hal_tmo);
-	bfa_isr_disable(&bfad->bfa);
-	bfa_detach(&bfad->bfa);
-	bfad_remove_intr(bfad);
-	bfad_hal_mem_release(bfad);
-
-	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
-}
-
 static void
 bfad_drv_start(struct bfad_s *bfad)
 {
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 6c5b81708a08..68d72410a131 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -301,7 +301,6 @@ bfa_status_t	bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
 			       struct bfa_lport_cfg_s *port_cfg);
 void		bfad_hcb_comp(void *arg, bfa_status_t status);
 
-void		bfad_drv_uninit(struct bfad_s *bfad);
 void		bfad_debugfs_init(struct bfad_port_s *port);
 void		bfad_debugfs_exit(struct bfad_port_s *port);
 
-- 
2.9.0
