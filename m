From: <kgudipat@brocade.com>
Subject: [PATCH 07/32] bfa: New interface to handle firmware upgrade scenario
Date: Wed, 3 Mar 2010 17:43:30 -0800
Message-ID: <1267667010-21081-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47651 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:43:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Split bfa_fcs_init() into bfa_fcs_attach() and bfa_fcs_init().
	- Removed empty function definitions in FCS modules
	- Modified driver to call bfa_fcs_attach() and bfa_fcs_init() as needed.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.c             |   46 ++++++++++++++++++++------------
 drivers/scsi/bfa/bfa_fcs_port.c        |   11 +------
 drivers/scsi/bfa/bfa_fcs_uf.c          |    8 +-----
 drivers/scsi/bfa/bfad.c                |    3 +-
 drivers/scsi/bfa/fabric.c              |   11 +++++--
 drivers/scsi/bfa/fcpim.c               |   19 -------------
 drivers/scsi/bfa/fcs_fabric.h          |    1 +
 drivers/scsi/bfa/fcs_fcpim.h           |    5 ---
 drivers/scsi/bfa/fcs_port.h            |    3 +-
 drivers/scsi/bfa/fcs_rport.h           |    3 --
 drivers/scsi/bfa/fcs_uf.h              |    3 +-
 drivers/scsi/bfa/fcs_vport.h           |    7 -----
 drivers/scsi/bfa/include/fcs/bfa_fcs.h |    3 +-
 drivers/scsi/bfa/rport.c               |   17 ------------
 drivers/scsi/bfa/vport.c               |   17 ------------
 15 files changed, 47 insertions(+), 110 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 50120c2..3516172 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -36,6 +36,7 @@
  * FCS sub-modules
  */
 struct bfa_fcs_mod_s {
+	void		(*attach) (struct bfa_fcs_s *fcs);
 	void            (*modinit) (struct bfa_fcs_s *fcs);
 	void            (*modexit) (struct bfa_fcs_s *fcs);
 };
@@ -43,12 +44,10 @@ struct bfa_fcs_mod_s {
 #define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
 
 static struct bfa_fcs_mod_s fcs_modules[] = {
-	BFA_FCS_MODULE(bfa_fcs_pport),
-	BFA_FCS_MODULE(bfa_fcs_uf),
-	BFA_FCS_MODULE(bfa_fcs_fabric),
-	BFA_FCS_MODULE(bfa_fcs_vport),
-	BFA_FCS_MODULE(bfa_fcs_rport),
-	BFA_FCS_MODULE(bfa_fcs_fcpim),
+	{ bfa_fcs_pport_attach, NULL, NULL },
+	{ bfa_fcs_uf_attach, NULL, NULL },
+	{ bfa_fcs_fabric_attach, bfa_fcs_fabric_modinit,
+	 bfa_fcs_fabric_modexit },
 };
 
 /**
@@ -71,16 +70,10 @@ bfa_fcs_exit_comp(void *fcs_cbarg)
  */
 
 /**
- * 		FCS instance initialization.
- *
- * 	param[in]		fcs		FCS instance
- * 	param[in]		bfa		BFA instance
- * 	param[in]		bfad		BFA driver instance
- *
- * 	return None
+ * fcs attach -- called once to initialize data structures at driver attach time
  */
 void
-bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 			bfa_boolean_t min_cfg)
 {
 	int             i;
@@ -95,7 +88,24 @@ bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 
 	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
 		mod = &fcs_modules[i];
-		mod->modinit(fcs);
+		if (mod->attach)
+			mod->attach(fcs);
+	}
+}
+
+/**
+ * fcs initialization, called once after bfa initialization is complete
+ */
+void
+bfa_fcs_init(struct bfa_fcs_s *fcs)
+{
+	int             i;
+	struct bfa_fcs_mod_s  *mod;
+
+	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+		mod = &fcs_modules[i];
+		if (mod->modinit)
+			mod->modinit(fcs);
 	}
 }
 
@@ -160,10 +170,12 @@ bfa_fcs_exit(struct bfa_fcs_s *fcs)
 	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
 
 	for (i = 0; i < nmods; i++) {
-		bfa_wc_up(&fcs->wc);
 
 		mod = &fcs_modules[i];
-		mod->modexit(fcs);
+		if (mod->modexit) {
+			bfa_wc_up(&fcs->wc);
+			mod->modexit(fcs);
+		}
 	}
 
 	bfa_wc_wait(&fcs->wc);
diff --git a/drivers/scsi/bfa/bfa_fcs_port.c b/drivers/scsi/bfa/bfa_fcs_port.c
index 9c4b24e..53808d0 100644
--- a/drivers/scsi/bfa/bfa_fcs_port.c
+++ b/drivers/scsi/bfa/bfa_fcs_port.c
@@ -55,14 +55,7 @@ bfa_fcs_pport_event_handler(void *cbarg, bfa_pport_event_t event)
 }
 
 void
-bfa_fcs_pport_modinit(struct bfa_fcs_s *fcs)
+bfa_fcs_pport_attach(struct bfa_fcs_s *fcs)
 {
-	bfa_pport_event_register(fcs->bfa, bfa_fcs_pport_event_handler,
-				     fcs);
-}
-
-void
-bfa_fcs_pport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
+	bfa_pport_event_register(fcs->bfa, bfa_fcs_pport_event_handler, fcs);
 }
diff --git a/drivers/scsi/bfa/bfa_fcs_uf.c b/drivers/scsi/bfa/bfa_fcs_uf.c
index ad01db6..3d57d48 100644
--- a/drivers/scsi/bfa/bfa_fcs_uf.c
+++ b/drivers/scsi/bfa/bfa_fcs_uf.c
@@ -93,13 +93,7 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 }
 
 void
-bfa_fcs_uf_modinit(struct bfa_fcs_s *fcs)
+bfa_fcs_uf_attach(struct bfa_fcs_s *fcs)
 {
 	bfa_uf_recv_register(fcs->bfa, bfa_fcs_uf_recv, fcs);
 }
-
-void
-bfa_fcs_uf_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 8e2b2a2..965dfb5 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -748,7 +748,8 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_fcs_log_init(&bfad->bfa_fcs, bfad->logmod);
 	bfa_fcs_trc_init(&bfad->bfa_fcs, bfad->trcmod);
 	bfa_fcs_aen_init(&bfad->bfa_fcs, bfad->aen);
-	bfa_fcs_init(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
+	bfa_fcs_attach(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
+	bfa_fcs_init(&bfad->bfa_fcs);
 	bfa_fcs_driver_info_init(&bfad->bfa_fcs, &driver_info);
 	bfa_fcs_set_fdmi_param(&bfad->bfa_fcs, fdmi_enable);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index a4b5dd4..e229898 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -814,10 +814,10 @@ bfa_fcs_fabric_delete_comp(void *cbarg)
  */
 
 /**
- *   Module initialization
+ *   Attach time initialization
  */
 void
-bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
+bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs)
 {
 	struct bfa_fcs_fabric_s *fabric;
 
@@ -841,7 +841,12 @@ bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
 	bfa_wc_up(&fabric->wc);	/* For the base port */
 
 	bfa_sm_set_state(fabric, bfa_fcs_fabric_sm_uninit);
-	bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_CREATE);
+}
+
+void
+bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs)
+{
+	bfa_sm_send_event(&fcs->fabric, BFA_FCS_FABRIC_SM_CREATE);
 	bfa_trc(fcs, 0);
 }
 
diff --git a/drivers/scsi/bfa/fcpim.c b/drivers/scsi/bfa/fcpim.c
index 1f3c06e..06f8a46 100644
--- a/drivers/scsi/bfa/fcpim.c
+++ b/drivers/scsi/bfa/fcpim.c
@@ -822,22 +822,3 @@ void
 bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim)
 {
 }
-
-/**
- *   Module initialization
- */
-void
-bfa_fcs_fcpim_modinit(struct bfa_fcs_s *fcs)
-{
-}
-
-/**
- *   Module cleanup
- */
-void
-bfa_fcs_fcpim_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
-
-
diff --git a/drivers/scsi/bfa/fcs_fabric.h b/drivers/scsi/bfa/fcs_fabric.h
index eee9608..8237bd5 100644
--- a/drivers/scsi/bfa/fcs_fabric.h
+++ b/drivers/scsi/bfa/fcs_fabric.h
@@ -29,6 +29,7 @@
 /*
 * fcs friend functions: only between fcs modules
  */
+void		bfa_fcs_fabric_attach(struct bfa_fcs_s *fcs);
 void            bfa_fcs_fabric_modinit(struct bfa_fcs_s *fcs);
 void            bfa_fcs_fabric_modexit(struct bfa_fcs_s *fcs);
 void            bfa_fcs_fabric_modsusp(struct bfa_fcs_s *fcs);
diff --git a/drivers/scsi/bfa/fcs_fcpim.h b/drivers/scsi/bfa/fcs_fcpim.h
index 61e9e26..11e6e7b 100644
--- a/drivers/scsi/bfa/fcs_fcpim.h
+++ b/drivers/scsi/bfa/fcs_fcpim.h
@@ -34,11 +34,6 @@ void bfa_fcs_itnim_is_initiator(struct bfa_fcs_itnim_s *itnim);
 void bfa_fcs_itnim_pause(struct bfa_fcs_itnim_s *itnim);
 void bfa_fcs_itnim_resume(struct bfa_fcs_itnim_s *itnim);
 
-/*
- * Modudle init/cleanup routines.
- */
-void bfa_fcs_fcpim_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_fcpim_modexit(struct bfa_fcs_s *fcs);
 void bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim, struct fchs_s *fchs,
 			u16 len);
 #endif /* __FCS_FCPIM_H__ */
diff --git a/drivers/scsi/bfa/fcs_port.h b/drivers/scsi/bfa/fcs_port.h
index abb6519..408c06a 100644
--- a/drivers/scsi/bfa/fcs_port.h
+++ b/drivers/scsi/bfa/fcs_port.h
@@ -26,7 +26,6 @@
 /*
  * fcs friend functions: only between fcs modules
  */
-void bfa_fcs_pport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_pport_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_pport_attach(struct bfa_fcs_s *fcs);
 
 #endif /* __FCS_PPORT_H__ */
diff --git a/drivers/scsi/bfa/fcs_rport.h b/drivers/scsi/bfa/fcs_rport.h
index f601e9d..9c8d1d2 100644
--- a/drivers/scsi/bfa/fcs_rport.h
+++ b/drivers/scsi/bfa/fcs_rport.h
@@ -24,9 +24,6 @@
 
 #include <fcs/bfa_fcs_rport.h>
 
-void bfa_fcs_rport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_rport_modexit(struct bfa_fcs_s *fcs);
-
 void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
 			u16 len);
 void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
diff --git a/drivers/scsi/bfa/fcs_uf.h b/drivers/scsi/bfa/fcs_uf.h
index 96f1bdc..f591072 100644
--- a/drivers/scsi/bfa/fcs_uf.h
+++ b/drivers/scsi/bfa/fcs_uf.h
@@ -26,7 +26,6 @@
 /*
  * fcs friend functions: only between fcs modules
  */
-void bfa_fcs_uf_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_uf_modexit(struct bfa_fcs_s *fcs);
+void bfa_fcs_uf_attach(struct bfa_fcs_s *fcs);
 
 #endif /* __FCS_UF_H__ */
diff --git a/drivers/scsi/bfa/fcs_vport.h b/drivers/scsi/bfa/fcs_vport.h
index 9e80b6a..32565ba 100644
--- a/drivers/scsi/bfa/fcs_vport.h
+++ b/drivers/scsi/bfa/fcs_vport.h
@@ -22,13 +22,6 @@
 #include <fcs/bfa_fcs_vport.h>
 #include <defs/bfa_defs_pci.h>
 
-/*
- * Modudle init/cleanup routines.
- */
-
-void bfa_fcs_vport_modinit(struct bfa_fcs_s *fcs);
-void bfa_fcs_vport_modexit(struct bfa_fcs_s *fcs);
-
 void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs.h b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
index 0396ec4..f2fd35f 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
@@ -61,8 +61,9 @@ struct bfa_fcs_s {
 /*
  * bfa fcs API functions
  */
-void bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
+void bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 			bfa_boolean_t min_cfg);
+void bfa_fcs_init(struct bfa_fcs_s *fcs);
 void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 			struct bfa_fcs_driver_info_s *driver_info);
 void bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable);
diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 9cf58bb..df714dc 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -2575,23 +2575,6 @@ bfa_fcs_rport_send_ls_rjt(struct bfa_fcs_rport_s *rport, struct fchs_s *rx_fchs,
 }
 
 /**
- *   Module initialization
- */
-void
-bfa_fcs_rport_modinit(struct bfa_fcs_s *fcs)
-{
-}
-
-/**
- *   Module cleanup
- */
-void
-bfa_fcs_rport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
-
-/**
  * Return state of rport.
  */
 int
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 8d18589..75d6f05 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -616,23 +616,6 @@ bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_DELCOMP);
 }
 
-/**
- *   Module initialization
- */
-void
-bfa_fcs_vport_modinit(struct bfa_fcs_s *fcs)
-{
-}
-
-/**
- *   Module cleanup
- */
-void
-bfa_fcs_vport_modexit(struct bfa_fcs_s *fcs)
-{
-	bfa_fcs_modexit_comp(fcs);
-}
-
 u32
 bfa_fcs_vport_get_max(struct bfa_fcs_s *fcs)
 {
-- 
1.6.5.3

