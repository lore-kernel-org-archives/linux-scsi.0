From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 02/23] bfa: enable basic PBC support
Date: Tue, 15 Jun 2010 11:20:59 -0700
Message-ID: <1276626059-816-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:41323 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab0FOSVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:21:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

The patch includes the driver side changes to enable basic PBC (PreBoot
Configuration) feature.
- Data structure changes and new definitions for PBC.
- APIs to access PBC info.
- Remove unused code.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcpim.c                     |    5 --
 drivers/scsi/bfa/bfa_fcport.c                    |   42 ++++++++-------
 drivers/scsi/bfa/bfa_fcxp.c                      |   14 +----
 drivers/scsi/bfa/bfa_ioc.c                       |   41 ++++-----------
 drivers/scsi/bfa/bfa_ioc.h                       |    1 -
 drivers/scsi/bfa/bfa_iocfc.c                     |   27 +++++-----
 drivers/scsi/bfa/bfa_iocfc.h                     |    5 ++-
 drivers/scsi/bfa/bfa_lps.c                       |    6 --
 drivers/scsi/bfa/bfa_port_priv.h                 |    4 +-
 drivers/scsi/bfa/bfa_priv.h                      |    3 -
 drivers/scsi/bfa/bfa_rport.c                     |    5 --
 drivers/scsi/bfa/bfa_sgpg.c                      |    5 --
 drivers/scsi/bfa/bfa_uf.c                        |    5 --
 drivers/scsi/bfa/include/bfi/bfi_iocfc.h         |    2 +
 drivers/scsi/bfa/include/bfi/bfi_pbc.h           |   62 ++++++++++++++++++++++
 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_boot.h    |   10 ++++
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h     |   38 ++++++-------
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h   |    3 +
 19 files changed, 154 insertions(+), 127 deletions(-)
 create mode 100644 drivers/scsi/bfa/include/bfi/bfi_pbc.h

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 790c945..12849e9 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -80,11 +80,6 @@ bfa_fcpim_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_fcpim_initdone(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_fcpim_detach(struct bfa_s *bfa)
 {
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index c589488..4961b8d 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -912,25 +912,6 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_fcport_initdone(struct bfa_s *bfa)
-{
-	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
-
-	/**
-	 * Initialize port attributes from IOC hardware data.
-	 */
-	bfa_fcport_set_wwns(fcport);
-	if (fcport->cfg.maxfrsize == 0)
-		fcport->cfg.maxfrsize = bfa_ioc_maxfrsize(&bfa->ioc);
-	fcport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
-	fcport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
-
-	bfa_assert(fcport->cfg.maxfrsize);
-	bfa_assert(fcport->cfg.rx_bbcredit);
-	bfa_assert(fcport->speed_sup);
-}
-
-static void
 bfa_fcport_detach(struct bfa_s *bfa)
 {
 }
@@ -1263,6 +1244,29 @@ bfa_fcport_send_stats_clear(void *cbarg)
  */
 
 /**
+ * Called to initialize port attributes
+ */
+void
+bfa_fcport_init(struct bfa_s *bfa)
+{
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
+
+	/**
+	 * Initialize port attributes from IOC hardware data.
+	 */
+	bfa_fcport_set_wwns(fcport);
+	if (fcport->cfg.maxfrsize == 0)
+		fcport->cfg.maxfrsize = bfa_ioc_maxfrsize(&bfa->ioc);
+	fcport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
+	fcport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
+
+	bfa_assert(fcport->cfg.maxfrsize);
+	bfa_assert(fcport->cfg.rx_bbcredit);
+	bfa_assert(fcport->speed_sup);
+}
+
+
+/**
  * Firmware message handler.
  */
 void
diff --git a/drivers/scsi/bfa/bfa_fcxp.c b/drivers/scsi/bfa/bfa_fcxp.c
index cf0ad67..8258f88 100644
--- a/drivers/scsi/bfa/bfa_fcxp.c
+++ b/drivers/scsi/bfa/bfa_fcxp.c
@@ -149,11 +149,6 @@ bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_fcxp_initdone(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_fcxp_detach(struct bfa_s *bfa)
 {
 }
@@ -225,7 +220,7 @@ bfa_fcxp_null_comp(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 		       bfa_status_t req_status, u32 rsp_len,
 		       u32 resid_len, struct fchs_s *rsp_fchs)
 {
-	/**discarded fcxp completion */
+	/* discarded fcxp completion */
 }
 
 static void
@@ -527,11 +522,8 @@ bfa_fcxp_alloc(void *caller, struct bfa_s *bfa, int nreq_sgles,
 		if (nreq_sgles > BFI_SGE_INLINE) {
 			nreq_sgpg = BFA_SGPG_NPAGE(nreq_sgles);
 
-			if (bfa_sgpg_malloc
-			    (bfa, &fcxp->req_sgpg_q, nreq_sgpg)
+			if (bfa_sgpg_malloc(bfa, &fcxp->req_sgpg_q, nreq_sgpg)
 			    != BFA_STATUS_OK) {
-				/* bfa_sgpg_wait(bfa, &fcxp->req_sgpg_wqe,
-				nreq_sgpg); */
 				/*
 				 * TODO
 				 */
@@ -685,7 +677,7 @@ bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
 	fcxp->send_cbarg = cbarg;
 
 	/**
-	 * If no room in CPE queue, wait for
+	 * If no room in CPE queue, wait for space in request queue
 	 */
 	send_req = bfa_reqq_next(bfa, BFA_REQQ_FCXP);
 	if (!send_req) {
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index ef3b3fe..268c071 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1608,6 +1608,13 @@ bfa_ioc_error_isr(struct bfa_ioc_s *ioc)
 	bfa_fsm_send_event(ioc, IOC_E_HWERROR);
 }
 
+void
+bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
+{
+	ioc->fcmode  = BFA_TRUE;
+	ioc->port_id = bfa_ioc_pcifn(ioc);
+}
+
 #ifndef BFA_BIOS_BUILD
 
 /**
@@ -1697,6 +1704,9 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	/* For now, model descr uses same model string */
 	bfa_ioc_get_adapter_model(ioc, ad_attr->model_descr);
 
+	ad_attr->card_type = ioc_attr->card_type;
+	ad_attr->is_mezz = bfa_mfg_is_mezz(ioc_attr->card_type);
+
 	if (BFI_ADAPTER_IS_SPECIAL(ioc_attr->adapter_prop))
 		ad_attr->prototype = 1;
 	else
@@ -1866,30 +1876,6 @@ bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc)
 	return w.wwn;
 }
 
-wwn_t
-bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst)
-{
-	union {
-		wwn_t           wwn;
-		u8         byte[sizeof(wwn_t)];
-	}
-	w              , w5;
-
-	bfa_trc(ioc, inst);
-
-	w.wwn = ioc->attr->mfg_wwn;
-	w5.byte[0] = 0x50 | w.byte[2] >> 4;
-	w5.byte[1] = w.byte[2] << 4 | w.byte[3] >> 4;
-	w5.byte[2] = w.byte[3] << 4 | w.byte[4] >> 4;
-	w5.byte[3] = w.byte[4] << 4 | w.byte[5] >> 4;
-	w5.byte[4] = w.byte[5] << 4 | w.byte[6] >> 4;
-	w5.byte[5] = w.byte[6] << 4 | w.byte[7] >> 4;
-	w5.byte[6] = w.byte[7] << 4 | (inst & 0x0f00) >> 8;
-	w5.byte[7] = (inst & 0xff);
-
-	return w5.wwn;
-}
-
 u64
 bfa_ioc_get_adid(struct bfa_ioc_s *ioc)
 {
@@ -1907,13 +1893,6 @@ bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 	return mac;
 }
 
-void
-bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
-{
-	ioc->fcmode = BFA_TRUE;
-	ioc->port_id = bfa_ioc_pcifn(ioc);
-}
-
 bfa_boolean_t
 bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 {
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 2fbb6b2..df15ecc 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -303,7 +303,6 @@ bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
  */
 wwn_t bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc);
 wwn_t bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc);
-wwn_t bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst);
 mac_t bfa_ioc_get_mac(struct bfa_ioc_s *ioc);
 u64 bfa_ioc_get_adid(struct bfa_ioc_s *ioc);
 
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index 273ecec..afa3da0 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -291,18 +291,6 @@ bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 }
 
 /**
- * BFA submodules initialization completion notification.
- */
-static void
-bfa_iocfc_initdone_submod(struct bfa_s *bfa)
-{
-	int             i;
-
-	for (i = 0; hal_mods[i]; i++)
-		hal_mods[i]->initdone(bfa);
-}
-
-/**
  * Start BFA submodules.
  */
 static void
@@ -394,6 +382,8 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 	/**
 	 * Configuration is complete - initialize/start submodules
 	 */
+	bfa_fcport_init(bfa);
+
 	if (iocfc->action == BFA_IOCFC_ACT_INIT)
 		bfa_cb_queue(bfa, &iocfc->init_hcb_qe, bfa_iocfc_init_cb, bfa);
 	else
@@ -531,7 +521,6 @@ bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status)
 		return;
 	}
 
-	bfa_iocfc_initdone_submod(bfa);
 	bfa_iocfc_send_cfg(bfa);
 }
 
@@ -881,6 +870,18 @@ bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns)
 	*wwns = cfgrsp->bootwwns.wwn;
 }
 
+void
+bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa, struct bfa_boot_pbc_s *pbcfg)
+{
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
+
+	pbcfg->enable = cfgrsp->pbc_cfg.boot_enabled;
+	pbcfg->nbluns = cfgrsp->pbc_cfg.nbluns;
+	pbcfg->speed = cfgrsp->pbc_cfg.port_speed;
+	memcpy(pbcfg->pblun, cfgrsp->pbc_cfg.blun, sizeof(pbcfg->pblun));
+}
+
 #endif
 
 
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
index fbb4bdc..3ee9fe7 100644
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ b/drivers/scsi/bfa/bfa_iocfc.h
@@ -116,7 +116,8 @@ struct bfa_iocfc_s {
 #define bfa_isr_mode_set(__bfa, __msix)	\
 	((__bfa)->iocfc.hwif.hw_isr_mode_set(__bfa, __msix))
 #define bfa_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)	\
-	(__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap, __nvecs, __maxvec)
+	((__bfa)->iocfc.hwif.hw_msix_getvecs(__bfa, __vecmap,	\
+		 __nvecs, __maxvec))
 
 /*
  * FC specific IOC functions.
@@ -166,6 +167,8 @@ void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
 void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
 		bfa_boolean_t mincfg);
 void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns);
+void bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa,
+		struct bfa_boot_pbc_s *pbcfg);
 
 #endif /* __BFA_IOCFC_H__ */
 
diff --git a/drivers/scsi/bfa/bfa_lps.c b/drivers/scsi/bfa/bfa_lps.c
index ad06f61..acabb44 100644
--- a/drivers/scsi/bfa/bfa_lps.c
+++ b/drivers/scsi/bfa/bfa_lps.c
@@ -41,7 +41,6 @@ static void bfa_lps_attach(struct bfa_s *bfa, void *bfad,
 			   struct bfa_iocfc_cfg_s *cfg,
 			   struct bfa_meminfo_s *meminfo,
 			   struct bfa_pcidev_s *pcidev);
-static void bfa_lps_initdone(struct bfa_s *bfa);
 static void bfa_lps_detach(struct bfa_s *bfa);
 static void bfa_lps_start(struct bfa_s *bfa);
 static void bfa_lps_stop(struct bfa_s *bfa);
@@ -347,11 +346,6 @@ bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_lps_initdone(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_lps_detach(struct bfa_s *bfa)
 {
 }
diff --git a/drivers/scsi/bfa/bfa_port_priv.h b/drivers/scsi/bfa/bfa_port_priv.h
index 40e256e..c52fe56 100644
--- a/drivers/scsi/bfa/bfa_port_priv.h
+++ b/drivers/scsi/bfa/bfa_port_priv.h
@@ -87,5 +87,7 @@ struct bfa_fcport_s {
 /*
  * public functions
  */
-void	bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void bfa_fcport_init(struct bfa_s *bfa);
+void bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
 #endif /* __BFA_PORT_PRIV_H__ */
diff --git a/drivers/scsi/bfa/bfa_priv.h b/drivers/scsi/bfa/bfa_priv.h
index be80fc7..bf4939b 100644
--- a/drivers/scsi/bfa/bfa_priv.h
+++ b/drivers/scsi/bfa/bfa_priv.h
@@ -37,7 +37,6 @@
 			void *bfad, struct bfa_iocfc_cfg_s *cfg, 	\
 			struct bfa_meminfo_s *meminfo,			\
 			struct bfa_pcidev_s *pcidev);      \
-	static void bfa_ ## __mod ## _initdone(struct bfa_s *bfa);      \
 	static void bfa_ ## __mod ## _detach(struct bfa_s *bfa);      \
 	static void bfa_ ## __mod ## _start(struct bfa_s *bfa);      \
 	static void bfa_ ## __mod ## _stop(struct bfa_s *bfa);      \
@@ -47,7 +46,6 @@
 	struct bfa_module_s hal_mod_ ## __mod = {			\
 		bfa_ ## __mod ## _meminfo,				\
 		bfa_ ## __mod ## _attach,				\
-		bfa_ ## __mod ## _initdone,				\
 		bfa_ ## __mod ## _detach,				\
 		bfa_ ## __mod ## _start,				\
 		bfa_ ## __mod ## _stop,					\
@@ -69,7 +67,6 @@ struct bfa_module_s {
 			struct bfa_iocfc_cfg_s *cfg,
 			struct bfa_meminfo_s *meminfo,
 			struct bfa_pcidev_s *pcidev);
-	void (*initdone) (struct bfa_s *bfa);
 	void (*detach) (struct bfa_s *bfa);
 	void (*start) (struct bfa_s *bfa);
 	void (*stop) (struct bfa_s *bfa);
diff --git a/drivers/scsi/bfa/bfa_rport.c b/drivers/scsi/bfa/bfa_rport.c
index 7c509fa..ccd0680 100644
--- a/drivers/scsi/bfa/bfa_rport.c
+++ b/drivers/scsi/bfa/bfa_rport.c
@@ -636,11 +636,6 @@ bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_rport_initdone(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_rport_detach(struct bfa_s *bfa)
 {
 }
diff --git a/drivers/scsi/bfa/bfa_sgpg.c b/drivers/scsi/bfa/bfa_sgpg.c
index 279d8f9..ae452c4 100644
--- a/drivers/scsi/bfa/bfa_sgpg.c
+++ b/drivers/scsi/bfa/bfa_sgpg.c
@@ -94,11 +94,6 @@ bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_sgpg_initdone(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_sgpg_detach(struct bfa_s *bfa)
 {
 }
diff --git a/drivers/scsi/bfa/bfa_uf.c b/drivers/scsi/bfa/bfa_uf.c
index 4b3c241..b2a37fc 100644
--- a/drivers/scsi/bfa/bfa_uf.c
+++ b/drivers/scsi/bfa/bfa_uf.c
@@ -170,11 +170,6 @@ bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 }
 
 static void
-bfa_uf_initdone(struct bfa_s *bfa)
-{
-}
-
-static void
 bfa_uf_detach(struct bfa_s *bfa)
 {
 }
diff --git a/drivers/scsi/bfa/include/bfi/bfi_iocfc.h b/drivers/scsi/bfa/include/bfi/bfi_iocfc.h
index c3760df..ccdfcc5 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_iocfc.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_iocfc.h
@@ -19,6 +19,7 @@
 #define __BFI_IOCFC_H__
 
 #include "bfi.h"
+#include <bfi/bfi_pbc.h>
 #include <defs/bfa_defs_ioc.h>
 #include <defs/bfa_defs_iocfc.h>
 #include <defs/bfa_defs_boot.h>
@@ -78,6 +79,7 @@ struct bfi_iocfc_cfgrsp_s {
 	struct bfa_iocfc_fwcfg_s	fwcfg;
 	struct bfa_iocfc_intr_attr_s	intr_attr;
 	struct bfi_iocfc_bootwwns	bootwwns;
+	struct bfi_pbc_s                pbc_cfg;
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/bfi/bfi_pbc.h b/drivers/scsi/bfa/include/bfi/bfi_pbc.h
new file mode 100644
index 0000000..88a4154
--- /dev/null
+++ b/drivers/scsi/bfa/include/bfi/bfi_pbc.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFI_PBC_H__
+#define __BFI_PBC_H__
+
+#pragma pack(1)
+
+#define BFI_PBC_MAX_BLUNS	8
+#define BFI_PBC_MAX_VPORTS	16
+
+#define BFI_PBC_PORT_DISABLED	 2
+/**
+ * PBC boot lun configuration
+ */
+struct bfi_pbc_blun_s {
+	wwn_t		tgt_pwwn;
+	lun_t		tgt_lun;
+};
+
+/**
+ * PBC virtual port configuration
+ */
+struct bfi_pbc_vport_s {
+	wwn_t		vp_pwwn;
+	wwn_t		vp_nwwn;
+};
+
+/**
+ * BFI pre-boot configuration information
+ */
+struct bfi_pbc_s {
+	u8		port_enabled;
+	u8		boot_enabled;
+	u8		nbluns;
+	u8		nvports;
+	u8		port_speed;
+	u8		rsvd_a;
+	u16		hss;
+	wwn_t		pbc_pwwn;
+	wwn_t		pbc_nwwn;
+	struct bfi_pbc_blun_s blun[BFI_PBC_MAX_BLUNS];
+	struct bfi_pbc_vport_s vport[BFI_PBC_MAX_VPORTS];
+};
+
+#pragma pack()
+
+#endif /* __BFI_PBC_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h b/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h
index 8c208fc..aea0360 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_adapter.h
@@ -39,7 +39,7 @@ enum {
 struct bfa_adapter_attr_s {
 	char            manufacturer[BFA_ADAPTER_MFG_NAME_LEN];
 	char            serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
-	u32	rsvd1;
+	u32		card_type;
 	char            model[BFA_ADAPTER_MODEL_NAME_LEN];
 	char            model_descr[BFA_ADAPTER_MODEL_DESCR_LEN];
 	wwn_t           pwwn;
@@ -60,6 +60,7 @@ struct bfa_adapter_attr_s {
 	u8         pcie_lanes_orig;
 	u8         pcie_lanes;
 	u8	        cna_capable;
+	u8         is_mezz;
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_boot.h b/drivers/scsi/bfa/include/defs/bfa_defs_boot.h
index 6f4aa52..0fca10b 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_boot.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_boot.h
@@ -24,6 +24,8 @@
 
 enum {
 	BFA_BOOT_BOOTLUN_MAX = 4,	/*  maximum boot lun per IOC */
+	BFA_PREBOOT_BOOTLUN_MAX = 8,    /*  maximum preboot lun per IOC */
+
 };
 
 #define BOOT_CFG_REV1	1
@@ -67,5 +69,13 @@ struct bfa_boot_cfg_s {
 	struct bfa_boot_bootlun_s blun_disc[BFA_BOOT_BOOTLUN_MAX];
 };
 
+struct bfa_boot_pbc_s {
+	u8         enable;         /* enable/disable SAN boot */
+	u8         speed;          /* boot speed settings */
+	u8         topology;       /* boot topology setting */
+	u8         rsvd1;
+	u32        nbluns;         /* number of boot luns */
+	struct bfa_boot_bootlun_s pblun[BFA_PREBOOT_BOOTLUN_MAX];
+};
 
 #endif /* __BFA_DEFS_BOOT_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
index bfb50eb..d22fb79 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
@@ -45,26 +45,6 @@
 #define BFA_MFG_CHKSUM_SIZE			16
 
 /**
- * Manufacturing block encrypted version
- */
-#define BFA_MFG_ENC_VER				2
-
-/**
- * Manufacturing block version 1 length
- */
-#define BFA_MFG_VER1_LEN			128
-
-/**
- * Manufacturing block header length
- */
-#define BFA_MFG_HDR_LEN				4
-
-/**
- * Checksum size
- */
-#define BFA_MFG_CHKSUM_SIZE			16
-
-/**
  * Manufacturing block format
  */
 #define BFA_MFG_SERIALNUM_SIZE			11
@@ -98,6 +78,24 @@ enum {
  */
 #define bfa_mfg_type2port_num(card_type) (((card_type) / 10) % 10)
 
+/**
+ * Check if Mezz card
+ */
+#define bfa_mfg_is_mezz(type) (( \
+	(type) == BFA_MFG_TYPE_JAYHAWK || \
+	(type) == BFA_MFG_TYPE_WANCHESE))
+
+/**
+ * Check if card type valid
+ */
+#define bfa_mfg_is_card_type_valid(type) (( \
+	(type) == BFA_MFG_TYPE_FC8P2 || \
+	(type) == BFA_MFG_TYPE_FC8P1 || \
+	(type) == BFA_MFG_TYPE_FC4P2 || \
+	(type) == BFA_MFG_TYPE_FC4P1 || \
+	(type) == BFA_MFG_TYPE_CNA10P2 || \
+	(type) == BFA_MFG_TYPE_CNA10P1 || \
+	bfa_mfg_is_mezz(type)))
 
 /**
  * All numerical fields are in big-endian format.
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index 26e5cc7..de6181c 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -38,6 +38,7 @@ enum bfa_pport_states {
 	BFA_PPORT_ST_IOCDOWN 		= 10,
 	BFA_PPORT_ST_IOCDIS 		= 11,
 	BFA_PPORT_ST_FWMISMATCH		= 12,
+	BFA_PPORT_ST_PREBOOT_DISABLED   = 13,
 	BFA_PPORT_ST_MAX_STATE,
 };
 
@@ -203,6 +204,8 @@ struct bfa_pport_attr_s {
 	 */
 	wwn_t           nwwn;		/*  node wwn */
 	wwn_t           pwwn;		/*  port wwn */
+	wwn_t           factorynwwn;    /*  factory node wwn */
+	wwn_t           factorypwwn;    /*  factory port wwn */
 	enum fc_cos     cos_supported;	/*  supported class of services */
 	u32        rsvd;
 	struct fc_symname_s    port_symname;	/*  port symbolic name */
-- 
1.6.5.2

