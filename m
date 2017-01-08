From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] bfa: remove bfa_fcs_mod_s
Date: Sun,  8 Jan 2017 10:41:15 +0100
Message-ID: <1483868475-2949-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934808AbdAHJlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2017 04:41:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, keescook@chromium.org

Just call the functions directly instead of obsfucating the call chain.
This was in reply to a patch from Kees Cook to constify the function
pointer struct bfa_fcs_mod_s, but it turns out there is no reason to
have this indirection at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/bfa/bfa_fcs.c | 181 ++++++++++++---------------------------------
 drivers/scsi/bfa/bfa_fcs.h |   4 -
 2 files changed, 46 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 1e7e139..4aa61e2 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -28,24 +28,6 @@
 BFA_TRC_FILE(FCS, FCS);
 
 /*
- * FCS sub-modules
- */
-struct bfa_fcs_mod_s {
-	void		(*attach) (struct bfa_fcs_s *fcs);
-	void		(*modinit) (struct bfa_fcs_s *fcs);
-	void		(*modexit) (struct bfa_fcs_s *fcs);
-};
-
-#define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
-
-static struct bfa_fcs_mod_s fcs_modules[] = {
-	{ bfa_fcs_port_attach, NULL, NULL },
-	{ bfa_fcs_uf_attach, NULL, NULL },
-	{ bfa_fcs_fabric_attach, bfa_fcs_fabric_modinit,
-	  bfa_fcs_fabric_modexit },
-};
-
-/*
  *  fcs_api BFA FCS API
  */
 
@@ -58,52 +40,19 @@ bfa_fcs_exit_comp(void *fcs_cbarg)
 	complete(&bfad->comp);
 }
 
-
-
 /*
- *  fcs_api BFA FCS API
- */
-
-/*
- * fcs attach -- called once to initialize data structures at driver attach time
+ * fcs initialization, called once after bfa initialization is complete
  */
 void
-bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
-	       bfa_boolean_t min_cfg)
+bfa_fcs_init(struct bfa_fcs_s *fcs)
 {
-	int		i;
-	struct bfa_fcs_mod_s  *mod;
-
-	fcs->bfa = bfa;
-	fcs->bfad = bfad;
-	fcs->min_cfg = min_cfg;
-	fcs->num_rport_logins = 0;
-
-	bfa->fcs = BFA_TRUE;
-	fcbuild_init();
-
-	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
-		mod = &fcs_modules[i];
-		if (mod->attach)
-			mod->attach(fcs);
-	}
+	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_CREATE);
+	bfa_trc(fcs, 0);
 }
 
 /*
- * fcs initialization, called once after bfa initialization is complete
+ *  fcs_api BFA FCS API
  */
-void
-bfa_fcs_init(struct bfa_fcs_s *fcs)
-{
-	int	i;
-	struct bfa_fcs_mod_s  *mod;
-
-	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
-		mod = &fcs_modules[i];
-		if (mod->modinit)
-			mod->modinit(fcs);
-	}
-}
 
 /*
  * FCS update cfg - reset the pwwn/nwwn of fabric base logical port
@@ -180,26 +129,14 @@ bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 void
 bfa_fcs_exit(struct bfa_fcs_s *fcs)
 {
-	struct bfa_fcs_mod_s  *mod;
-	int		nmods, i;
-
 	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
-
-	nmods = ARRAY_SIZE(fcs_modules);
-
-	for (i = 0; i < nmods; i++) {
-
-		mod = &fcs_modules[i];
-		if (mod->modexit) {
-			bfa_wc_up(&fcs->wc);
-			mod->modexit(fcs);
-		}
-	}
-
+	bfa_wc_up(&fcs->wc);
+	bfa_trc(fcs, 0);
+	bfa_lps_delete(fcs->fabric.lps);
+	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_DELETE);
 	bfa_wc_wait(&fcs->wc);
 }
 
-
 /*
  * Fabric module implementation.
  */
@@ -1128,62 +1065,6 @@ bfa_fcs_fabric_stop_comp(void *cbarg)
  */
 
 /*
- * Attach time initialization.
- */
-void
-bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
-{
-	struct bfa_fcs_fabric_s *fabric;
-
-	fabric = &fcs->fabric;
-	memset(fabric, 0, sizeof(struct bfa_fcs_fabric_s));
-
-	/*
-	 * Initialize base fabric.
-	 */
-	fabric->fcs = fcs;
-	INIT_LIST_HEAD(&fabric->vport_q);
-	INIT_LIST_HEAD(&fabric->vf_q);
-	fabric->lps = bfa_lps_alloc(fcs->bfa);
-	WARN_ON(!fabric->lps);
-
-	/*
-	 * Initialize fabric delete completion handler. Fabric deletion is
-	 * complete when the last vport delete is complete.
-	 */
-	bfa_wc_init(&fabric->wc, bfa_fcs_fabric_delete_comp, fabric);
-	bfa_wc_up(&fabric->wc); /* For the base port */
-
-	bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
-	bfa_fcs_lport_attach(&fabric->bport, fabric->fcs, FC_VF_ID_NULL, NULL);
-}
-
-void
-bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
-{
-	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_CREATE);
-	bfa_trc(fcs, 0);
-}
-
-/*
- *   Module cleanup
- */
-void
-bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs)
-{
-	struct bfa_fcs_fabric_s *fabric;
-
-	bfa_trc(fcs, 0);
-
-	/*
-	 * Cleanup base fabric.
-	 */
-	fabric = &fcs->fabric;
-	bfa_lps_delete(fabric->lps);
-	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_DELETE);
-}
-
-/*
  * Fabric module stop -- stop FCS actions
  */
 void
@@ -1633,12 +1514,6 @@ bfa_fcs_port_event_handler(void *cbarg, enum bfa_port_linkstate event)
 	}
 }
 
-void
-bfa_fcs_port_attach(struct bfa_fcs_s *fcs)
-{
-	bfa_fcport_event_register(fcs->bfa, bfa_fcs_port_event_handler, fcs);
-}
-
 /*
  * BFA FCS UF ( Unsolicited Frames)
  */
@@ -1706,8 +1581,44 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 	bfa_uf_free(uf);
 }
 
+/*
+ * fcs attach -- called once to initialize data structures at driver attach time
+ */
 void
-bfa_fcs_uf_attach(struct bfa_fcs_s *fcs)
+bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+	       bfa_boolean_t min_cfg)
 {
+	struct bfa_fcs_fabric_s *fabric = &fcs->fabric;
+
+	fcs->bfa = bfa;
+	fcs->bfad = bfad;
+	fcs->min_cfg = min_cfg;
+	fcs->num_rport_logins = 0;
+
+	bfa->fcs = BFA_TRUE;
+	fcbuild_init();
+
+	bfa_fcport_event_register(fcs->bfa, bfa_fcs_port_event_handler, fcs);
 	bfa_uf_recv_register(fcs->bfa, bfa_fcs_uf_recv, fcs);
+
+	memset(fabric, 0, sizeof(struct bfa_fcs_fabric_s));
+
+	/*
+	 * Initialize base fabric.
+	 */
+	fabric->fcs = fcs;
+	INIT_LIST_HEAD(&fabric->vport_q);
+	INIT_LIST_HEAD(&fabric->vf_q);
+	fabric->lps = bfa_lps_alloc(fcs->bfa);
+	WARN_ON(!fabric->lps);
+
+	/*
+	 * Initialize fabric delete completion handler. Fabric deletion is
+	 * complete when the last vport delete is complete.
+	 */
+	bfa_wc_init(&fabric->wc, bfa_fcs_fabric_delete_comp, fabric);
+	bfa_wc_up(&fabric->wc); /* For the base port */
+
+	bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
+	bfa_fcs_lport_attach(&fabric->bport, fabric->fcs, FC_VF_ID_NULL, NULL);
 }
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 0f797a5..e60f72b 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -808,9 +808,7 @@ void bfa_fcs_vf_get_ports(bfa_fcs_vf_t *vf, wwn_t vpwwn[], int *nports);
 /*
  * fabric protected interface functions
  */
-void bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_link_up(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_link_down(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_addvport(struct bfa_fcs_fabric_s *fabric,
@@ -827,8 +825,6 @@ void	bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric);
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 	       wwn_t fabric_name);
 u16 bfa_fcs_fabric_get_switch_oui(struct bfa_fcs_fabric_s *fabric);
-void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
-void bfa_fcs_port_attach(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_modstop(struct bfa_fcs_s *fcs);
 void bfa_fcs_fabric_sm_online(struct bfa_fcs_fabric_s *fabric,
 			enum bfa_fcs_fabric_event event);
-- 
2.1.4

