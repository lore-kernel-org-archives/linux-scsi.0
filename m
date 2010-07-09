From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 05/24] bfa: ioc attributes fix
Date: Thu, 8 Jul 2010 19:48:12 -0700
Message-ID: <1278643692-28837-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36152 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab0GICsQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:48:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

This patch fixes the APIs to obtain ioc attributes
- fix API to obtain wwpn, wwnn, and mac.
- add API to get mfg wwpn, wwnn, and mac.
- fix API to obtain wwn of boot target.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcport.c          |    3 ++
 drivers/scsi/bfa/bfa_ioc.c             |   58 ++++++++++++++++----------------
 drivers/scsi/bfa/bfa_ioc.h             |    3 ++
 drivers/scsi/bfa/bfa_iocfc.c           |   18 ++++++++--
 drivers/scsi/bfa/bfa_iocfc.h           |    2 +-
 drivers/scsi/bfa/bfad_im.c             |    8 ++--
 drivers/scsi/bfa/fabric.c              |   16 +++++++++
 drivers/scsi/bfa/fcs_fabric.h          |    2 +
 drivers/scsi/bfa/include/bfi/bfi_ioc.h |   19 ++++++----
 drivers/scsi/bfa/ns.c                  |    4 +-
 10 files changed, 86 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
index 4961b8d..d28b721 100644
--- a/drivers/scsi/bfa/bfa_fcport.c
+++ b/drivers/scsi/bfa/bfa_fcport.c
@@ -1569,6 +1569,9 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
 	attr->nwwn = fcport->nwwn;
 	attr->pwwn = fcport->pwwn;
 
+	attr->factorypwwn =  bfa_ioc_get_mfg_pwwn(&bfa->ioc);
+	attr->factorynwwn =  bfa_ioc_get_mfg_nwwn(&bfa->ioc);
+
 	bfa_os_memcpy(&attr->pport_cfg, &fcport->cfg,
 		      sizeof(struct bfa_pport_cfg_s));
 	/*
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 268c071..1600f74 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1838,54 +1838,54 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 }
 
 /**
- *  hal_wwn_public
+ *  bfa_wwn_public
  */
 wwn_t
 bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
 {
-	union {
-		wwn_t           wwn;
-		u8         byte[sizeof(wwn_t)];
-	}
-	w;
-
-	w.wwn = ioc->attr->mfg_wwn;
-
-	if (bfa_ioc_portid(ioc) == 1)
-		w.byte[7]++;
-
-	return w.wwn;
+	return ioc->attr->pwwn;
 }
 
 wwn_t
 bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc)
 {
-	union {
-		wwn_t           wwn;
-		u8         byte[sizeof(wwn_t)];
-	}
-	w;
-
-	w.wwn = ioc->attr->mfg_wwn;
-
-	if (bfa_ioc_portid(ioc) == 1)
-		w.byte[7]++;
-
-	w.byte[0] = 0x20;
-
-	return w.wwn;
+	return ioc->attr->nwwn;
 }
 
 u64
 bfa_ioc_get_adid(struct bfa_ioc_s *ioc)
 {
-	return ioc->attr->mfg_wwn;
+	return ioc->attr->mfg_pwwn;
 }
 
 mac_t
 bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 {
-	mac_t           mac;
+	/*
+	 * Currently mfg mac is used as FCoE enode mac (not configured by PBC)
+	 */
+	if (bfa_ioc_get_type(ioc) == BFA_IOC_TYPE_FCoE)
+		return bfa_ioc_get_mfg_mac(ioc);
+	else
+		return ioc->attr->mac;
+}
+
+wwn_t
+bfa_ioc_get_mfg_pwwn(struct bfa_ioc_s *ioc)
+{
+	return ioc->attr->mfg_pwwn;
+}
+
+wwn_t
+bfa_ioc_get_mfg_nwwn(struct bfa_ioc_s *ioc)
+{
+	return ioc->attr->mfg_nwwn;
+}
+
+mac_t
+bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc)
+{
+	mac_t   mac;
 
 	mac = ioc->attr->mfg_mac;
 	mac.mac[MAC_ADDRLEN - 1] += bfa_ioc_pcifn(ioc);
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index df15ecc..2425c00 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -304,6 +304,9 @@ bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
 wwn_t bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc);
 wwn_t bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc);
 mac_t bfa_ioc_get_mac(struct bfa_ioc_s *ioc);
+wwn_t bfa_ioc_get_mfg_pwwn(struct bfa_ioc_s *ioc);
+wwn_t bfa_ioc_get_mfg_nwwn(struct bfa_ioc_s *ioc);
+mac_t bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc);
 u64 bfa_ioc_get_adid(struct bfa_ioc_s *ioc);
 
 #endif /* __BFA_IOC_H__ */
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index d3f1052..6f54bea 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -861,13 +861,23 @@ bfa_iocfc_is_operational(struct bfa_s *bfa)
  * Return boot target port wwns -- read from boot information in flash.
  */
 void
-bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns)
+bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns)
 {
-	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
-	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
+	int i;
+
+	if (cfgrsp->pbc_cfg.boot_enabled && cfgrsp->pbc_cfg.nbluns) {
+		bfa_trc(bfa, cfgrsp->pbc_cfg.nbluns);
+		*nwwns = cfgrsp->pbc_cfg.nbluns;
+		for (i = 0; i < cfgrsp->pbc_cfg.nbluns; i++)
+			wwns[i] = cfgrsp->pbc_cfg.blun[i].tgt_pwwn;
+
+		return;
+	}
 
 	*nwwns = cfgrsp->bootwwns.nwwns;
-	*wwns = cfgrsp->bootwwns.wwn;
+	memcpy(wwns, cfgrsp->bootwwns.wwn, sizeof(cfgrsp->bootwwns.wwn));
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
index a08309f..2b28103 100644
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ b/drivers/scsi/bfa/bfa_iocfc.h
@@ -167,7 +167,7 @@ void bfa_hwct_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
 void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
 void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
 		bfa_boolean_t mincfg);
-void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t **wwns);
+void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns);
 void bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa,
 		struct bfa_boot_pbc_s *pbcfg);
 int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 0dff0d4..943bc4b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1205,9 +1205,9 @@ int
 bfad_os_get_linkup_delay(struct bfad_s *bfad)
 {
 
-	u8         nwwns = 0;
-	wwn_t           *wwns;
-	int             ldelay;
+	u8      nwwns = 0;
+	wwn_t	wwns[BFA_PREBOOT_BOOTLUN_MAX];
+	int     ldelay;
 
 	/*
 	 * Querying for the boot target port wwns
@@ -1216,7 +1216,7 @@ bfad_os_get_linkup_delay(struct bfad_s *bfad)
 	 * else => local boot machine set bfa_linkup_delay = 10
 	 */
 
-	bfa_iocfc_get_bootwwns(&bfad->bfa, &nwwns, &wwns);
+	bfa_iocfc_get_bootwwns(&bfad->bfa, &nwwns, wwns);
 
 	if (nwwns > 0) {
 		/* If boot over SAN; linkup_delay = 30sec */
diff --git a/drivers/scsi/bfa/fabric.c b/drivers/scsi/bfa/fabric.c
index 9315383..c646d6d 100644
--- a/drivers/scsi/bfa/fabric.c
+++ b/drivers/scsi/bfa/fabric.c
@@ -1271,6 +1271,22 @@ bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 }
 
 /**
+ *
+ * @param[in] fabric - fabric
+ * @param[in] node_symname -
+ *              Caller allocated buffer to receive the symbolic name
+ *
+ * @return - none
+ */
+void
+bfa_fcs_get_sym_name(const struct bfa_fcs_s *fcs, char *node_symname)
+{
+	bfa_os_memcpy(node_symname,
+			fcs->fabric.bport.port_cfg.sym_name.symname,
+			BFA_SYMNAME_MAXLEN);
+}
+
+/**
  * Not used by FCS.
  */
 void
diff --git a/drivers/scsi/bfa/fcs_fabric.h b/drivers/scsi/bfa/fcs_fabric.h
index 244c3f0..ed532db 100644
--- a/drivers/scsi/bfa/fcs_fabric.h
+++ b/drivers/scsi/bfa/fcs_fabric.h
@@ -60,4 +60,6 @@ void bfa_fcs_auth_finished(struct bfa_fcs_fabric_s *fabric,
 
 void bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 			wwn_t fabric_name);
+void bfa_fcs_get_sym_name(const struct bfa_fcs_s *fcs, char *node_symname);
+
 #endif /* __FCS_FABRIC_H__ */
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ioc.h b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
index 03a9c94..7c5e6d5 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ioc.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
@@ -48,9 +48,14 @@ struct bfi_ioc_getattr_req_s {
 };
 
 struct bfi_ioc_attr_s {
-	wwn_t           mfg_wwn;
+	wwn_t           mfg_pwwn;       /* Mfg port wwn */
+	wwn_t           mfg_nwwn;       /* Mfg node wwn */
 	mac_t		mfg_mac;
-	u16	rsvd_a;
+	u16		rsvd_a;
+	wwn_t           pwwn;
+	wwn_t           nwwn;
+	mac_t           mac;            /* PBC or Mfg mac */
+	u16        	rsvd_b;
 	char            brcd_serialnum[STRSZ(BFA_MFG_SERIALNUM_SIZE)];
 	u8         pcie_gen;
 	u8         pcie_lanes_orig;
@@ -58,12 +63,12 @@ struct bfi_ioc_attr_s {
 	u8         rx_bbcredit;	/*  receive buffer credits */
 	u32        adapter_prop;	/*  adapter properties     */
 	u16        maxfrsize;	/*  max receive frame size */
-	char         	asic_rev;
-	u8         rsvd_b;
-	char            fw_version[BFA_VERSION_LEN];
-	char            optrom_version[BFA_VERSION_LEN];
+	char       asic_rev;
+	u8         rsvd_c;
+	char       fw_version[BFA_VERSION_LEN];
+	char       optrom_version[BFA_VERSION_LEN];
 	struct bfa_mfg_vpd_s	vpd;
-	uint32_t        card_type;	/* card type */
+	u32        card_type;	/* card type */
 };
 
 /**
diff --git a/drivers/scsi/bfa/ns.c b/drivers/scsi/bfa/ns.c
index d20dd7e..2d6d2d6 100644
--- a/drivers/scsi/bfa/ns.c
+++ b/drivers/scsi/bfa/ns.c
@@ -1228,10 +1228,10 @@ bfa_fcs_port_ns_boot_target_disc(struct bfa_fcs_port_s *port)
 
 	struct bfa_fcs_rport_s *rport;
 	u8         nwwns;
-	wwn_t          *wwns;
+	wwn_t  wwns[BFA_PREBOOT_BOOTLUN_MAX];
 	int             ii;
 
-	bfa_iocfc_get_bootwwns(port->fcs->bfa, &nwwns, &wwns);
+	bfa_iocfc_get_bootwwns(port->fcs->bfa, &nwwns, wwns);
 
 	for (ii = 0; ii < nwwns; ++ii) {
 		rport = bfa_fcs_rport_create_by_wwn(port, wwns[ii]);
-- 
1.6.5.2

