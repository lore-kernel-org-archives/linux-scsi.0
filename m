Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE8BC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E993E222B8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgJSMSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:18:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgJSMSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 08:18:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 01A9AB1DA;
        Mon, 19 Oct 2020 12:17:58 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] bfa: drop unused 'bfad' and 'pcidev' arguments
Date:   Mon, 19 Oct 2020 14:17:54 +0200
Message-Id: <20201019121756.74644-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201019121756.74644-1-hare@suse.de>
References: <20201019121756.74644-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The various bfa modules all have an 'attach' function, most of
which have two pointless arguments 'bfad' and 'pcidev'.
Remove them.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/bfa/bfa.h         |  3 ---
 drivers/scsi/bfa/bfa_core.c    | 30 +++++++++++++++---------------
 drivers/scsi/bfa/bfa_fcpim.c   |  8 +++-----
 drivers/scsi/bfa/bfa_ioc.c     |  3 +--
 drivers/scsi/bfa/bfa_ioc.h     |  1 -
 drivers/scsi/bfa/bfa_modules.h | 28 ++++++++++------------------
 drivers/scsi/bfa/bfa_svc.c     | 23 ++++++++---------------
 7 files changed, 37 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 7bd2ba1ad4d1..901e77b9c650 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -293,9 +293,6 @@ struct bfa_iocfc_s {
 void bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg,
 			struct bfa_meminfo_s *meminfo,
 			struct bfa_s *bfa);
-void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
-		      struct bfa_iocfc_cfg_s *cfg,
-		      struct bfa_pcidev_s *pcidev);
 void bfa_iocfc_init(struct bfa_s *bfa);
 void bfa_iocfc_start(struct bfa_s *bfa);
 void bfa_iocfc_stop(struct bfa_s *bfa);
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 6846ca8f7313..aa726fc7f7e1 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1033,12 +1033,11 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 }
 
 static void
-bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+bfa_iocfc_init_mem(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 		   struct bfa_pcidev_s *pcidev)
 {
 	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
 
-	bfa->bfad = bfad;
 	iocfc->bfa = bfa;
 	iocfc->cfg = *cfg;
 
@@ -1513,8 +1512,8 @@ bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 /*
  * Query IOC memory requirement information.
  */
-void
-bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+static void
+bfa_iocfc_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
 		 struct bfa_pcidev_s *pcidev)
 {
 	int		i;
@@ -1531,7 +1530,7 @@ bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_PCIFN_CLASS_FC);
 	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
 
-	bfa_iocfc_init_mem(bfa, bfad, cfg, pcidev);
+	bfa_iocfc_init_mem(bfa, cfg, pcidev);
 	bfa_iocfc_mem_claim(bfa, cfg);
 	INIT_LIST_HEAD(&bfa->timer_mod.timer_q);
 
@@ -1833,6 +1832,7 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct list_head *dm_qe, *km_qe;
 
 	bfa->fcs = BFA_FALSE;
+	bfa->bfad = bfad;
 
 	WARN_ON((cfg == NULL) || (meminfo == NULL));
 
@@ -1855,16 +1855,16 @@ bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		kva_elem->kva_curp = kva_elem->kva;
 	}
 
-	bfa_iocfc_attach(bfa, bfad, cfg, pcidev);
-	bfa_fcdiag_attach(bfa, bfad, cfg, pcidev);
-	bfa_sgpg_attach(bfa, bfad, cfg, pcidev);
-	bfa_fcport_attach(bfa, bfad, cfg, pcidev);
-	bfa_fcxp_attach(bfa, bfad, cfg, pcidev);
-	bfa_lps_attach(bfa, bfad, cfg, pcidev);
-	bfa_uf_attach(bfa, bfad, cfg, pcidev);
-	bfa_rport_attach(bfa, bfad, cfg, pcidev);
-	bfa_fcp_attach(bfa, bfad, cfg, pcidev);
-	bfa_dconf_attach(bfa, bfad, cfg);
+	bfa_iocfc_attach(bfa, cfg, pcidev);
+	bfa_fcdiag_attach(bfa, cfg);
+	bfa_sgpg_attach(bfa, cfg);
+	bfa_fcport_attach(bfa, cfg);
+	bfa_fcxp_attach(bfa, cfg);
+	bfa_lps_attach(bfa, cfg);
+	bfa_uf_attach(bfa, cfg);
+	bfa_rport_attach(bfa, cfg);
+	bfa_fcp_attach(bfa, cfg);
+	bfa_dconf_attach(bfa, cfg);
 	bfa_com_port_attach(bfa);
 	bfa_com_ablk_attach(bfa);
 	bfa_com_cee_attach(bfa);
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 29f99561dfc3..cc3203c52c4b 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -305,8 +305,7 @@ bfa_fcpim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len)
 
 
 static void
-bfa_fcpim_attach(struct bfa_fcp_mod_s *fcp, void *bfad,
-		struct bfa_iocfc_cfg_s *cfg, struct bfa_pcidev_s *pcidev)
+bfa_fcpim_attach(struct bfa_fcp_mod_s *fcp, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_fcpim_s *fcpim = &fcp->fcpim;
 	struct bfa_s *bfa = fcp->bfa;
@@ -3679,8 +3678,7 @@ bfa_fcp_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 }
 
 void
-bfa_fcp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_fcp_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_fcp_mod_s *fcp = BFA_FCP_MOD(bfa);
 	struct bfa_mem_dma_s *seg_ptr;
@@ -3710,7 +3708,7 @@ bfa_fcp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	}
 
 	fcp->throttle_update_required = 1;
-	bfa_fcpim_attach(fcp, bfad, cfg, pcidev);
+	bfa_fcpim_attach(fcp, cfg);
 
 	bfa_iotag_attach(fcp);
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index dd5821dfcac2..b2ba89c81c65 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -6066,11 +6066,10 @@ bfa_dconf_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
 }
 
 void
-bfa_dconf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg)
+bfa_dconf_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_dconf_mod_s *dconf = BFA_DCONF_MOD(bfa);
 
-	dconf->bfad = bfad;
 	dconf->bfa = bfa;
 	dconf->instance = bfa->ioc.port_id;
 	bfa_trc(bfa, dconf->instance);
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 933a1c3890ff..402f7b6a3df4 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -782,7 +782,6 @@ struct bfa_dconf_mod_s {
 	bfa_boolean_t		min_cfg;
 	struct bfa_timer_s	timer;
 	struct bfa_s		*bfa;
-	void			*bfad;
 	void			*trcmod;
 	struct bfa_dconf_s	*dconf;
 	struct bfa_mem_kva_s	kva_seg;
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 578e7678b056..299b41a7b540 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -56,7 +56,7 @@ enum {
 #define BFA_CACHELINE_SZ	(256)
 
 struct bfa_s {
-	void			*bfad;		/*  BFA driver instance    */
+	struct bfad_s		*bfad;		/*  BFA driver instance    */
 	struct bfa_plog_s	*plog;		/*  portlog buffer	    */
 	struct bfa_trc_mod_s	*trcmod;	/*  driver tracing	    */
 	struct bfa_ioc_s	ioc;		/*  IOC module		    */
@@ -74,12 +74,11 @@ struct bfa_s {
 
 extern bfa_boolean_t bfa_auto_recover;
 
-void bfa_dconf_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *);
+void bfa_dconf_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_dconf_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		  struct bfa_s *);
 void bfa_dconf_iocdisable(struct bfa_s *);
-void bfa_fcp_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_fcp_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_fcp_iocdisable(struct bfa_s *bfa);
 void bfa_fcp_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
@@ -88,36 +87,29 @@ void bfa_fcport_start(struct bfa_s *);
 void bfa_fcport_iocdisable(struct bfa_s *);
 void bfa_fcport_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		   struct bfa_s *);
-void bfa_fcport_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_fcport_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_fcxp_iocdisable(struct bfa_s *);
 void bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
-void bfa_fcxp_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_fcxp_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_fcdiag_iocdisable(struct bfa_s *);
-void bfa_fcdiag_attach(struct bfa_s *bfa, void *, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_fcdiag_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *);
 void bfa_ioim_lm_init(struct bfa_s *);
 void bfa_lps_iocdisable(struct bfa_s *bfa);
 void bfa_lps_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
-void bfa_lps_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
-	struct bfa_pcidev_s *);
+void bfa_lps_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_rport_iocdisable(struct bfa_s *bfa);
 void bfa_rport_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
-void bfa_rport_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_rport_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
-void bfa_sgpg_attach(struct bfa_s *, void *bfad, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_sgpg_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_uf_iocdisable(struct bfa_s *);
 void bfa_uf_meminfo(struct bfa_iocfc_cfg_s *, struct bfa_meminfo_s *,
 		struct bfa_s *);
-void bfa_uf_attach(struct bfa_s *, void *, struct bfa_iocfc_cfg_s *,
-		struct bfa_pcidev_s *);
+void bfa_uf_attach(struct bfa_s *, struct bfa_iocfc_cfg_s *);
 void bfa_uf_start(struct bfa_s *);
 
 #endif /* __BFA_MODULES_H__ */
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 1e266c1ef793..c47c7e45b733 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -487,8 +487,7 @@ bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 }
 
 void
-bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_fcxp_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
 
@@ -1477,8 +1476,7 @@ bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
  * bfa module attach at initialization time
  */
 void
-bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-	struct bfa_pcidev_s *pcidev)
+bfa_lps_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
 	struct bfa_lps_s	*lps;
@@ -3021,8 +3019,7 @@ bfa_fcport_mem_claim(struct bfa_fcport_s *fcport)
  * Memory initialization.
  */
 void
-bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_fcport_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	struct bfa_port_cfg_s *port_cfg = &fcport->cfg;
@@ -4810,8 +4807,7 @@ bfa_rport_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 }
 
 void
-bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_rport_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
 	struct bfa_rport_s *rp;
@@ -5176,8 +5172,7 @@ bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 }
 
 void
-bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_sgpg_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
 	struct bfa_sgpg_s *hsgpg;
@@ -5450,8 +5445,7 @@ bfa_uf_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *minfo,
 }
 
 void
-bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_uf_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
 
@@ -5707,13 +5701,12 @@ bfa_fcdiag_set_busy_status(struct bfa_fcdiag_s *fcdiag)
 }
 
 void
-bfa_fcdiag_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
-		struct bfa_pcidev_s *pcidev)
+bfa_fcdiag_attach(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg)
 {
 	struct bfa_fcdiag_s *fcdiag = BFA_FCDIAG_MOD(bfa);
 	struct bfa_dport_s  *dport = &fcdiag->dport;
 
-	fcdiag->bfa             = bfa;
+	fcdiag->bfa = bfa;
 	fcdiag->trcmod  = bfa->trcmod;
 	/* The common DIAG attach bfa_diag_attach() will do all memory claim */
 	dport->bfa = bfa;
-- 
2.16.4

