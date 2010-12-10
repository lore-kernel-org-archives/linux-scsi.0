From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 6/7] bfa: remove all OS wrappers
Date: Thu, 9 Dec 2010 19:12:32 -0800
Message-ID: <1291950752-16212-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55151 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab0LJDMk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:12:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>, Jing Huang <huangj@brocade.com>

Remove OS wrapper functions/macros, and as a result remove bfa_os_inc.h.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa.h           |    2 +-
 drivers/scsi/bfa/bfa_core.c      |    2 +-
 drivers/scsi/bfa/bfa_cs.h        |   51 +++++++++++++-
 drivers/scsi/bfa/bfa_defs.h      |    2 +-
 drivers/scsi/bfa/bfa_fc.h        |   24 +++---
 drivers/scsi/bfa/bfa_fcbuild.c   |   58 ++++++++--------
 drivers/scsi/bfa/bfa_fcbuild.h   |    2 +-
 drivers/scsi/bfa/bfa_fcpim.c     |   24 +------
 drivers/scsi/bfa/bfa_fcs.c       |    8 +-
 drivers/scsi/bfa/bfa_fcs.h       |    2 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c |    2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |   12 ++--
 drivers/scsi/bfa/bfa_fcs_rport.c |    2 +-
 drivers/scsi/bfa/bfa_hw_cb.c     |    1 +
 drivers/scsi/bfa/bfa_hw_ct.c     |    1 +
 drivers/scsi/bfa/bfa_ioc.c       |    6 +-
 drivers/scsi/bfa/bfa_ioc.h       |    8 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |    1 +
 drivers/scsi/bfa/bfa_ioc_ct.c    |    1 +
 drivers/scsi/bfa/bfa_os_inc.h    |  143 --------------------------------------
 drivers/scsi/bfa/bfa_port.c      |   15 ++--
 drivers/scsi/bfa/bfa_svc.c       |   37 ++++++----
 drivers/scsi/bfa/bfad.c          |    9 +--
 drivers/scsi/bfa/bfad_attr.c     |   10 ++--
 drivers/scsi/bfa/bfad_drv.h      |   37 ++++++----
 drivers/scsi/bfa/bfad_im.c       |   38 +++++-----
 drivers/scsi/bfa/bfad_im.h       |   16 ++--
 drivers/scsi/bfa/bfi.h           |    2 +-
 28 files changed, 211 insertions(+), 305 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfa_os_inc.h

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 8f17186..cabc6b9 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -17,7 +17,7 @@
 #ifndef __BFA_H__
 #define __BFA_H__
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 #include "bfa_cs.h"
 #include "bfa_plog.h"
 #include "bfa_defs_svc.h"
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index d417864..02a5e04 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -15,9 +15,9 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_modules.h"
 #include "bfi_ctreg.h"
-#include "bfad_drv.h"
 
 BFA_TRC_FILE(HAL, CORE);
 
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 99f242b..493009d 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -22,7 +22,7 @@
 #ifndef __BFA_CS_H__
 #define __BFA_CS_H__
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 
 /*
  * BFA TRC
@@ -32,12 +32,20 @@
 #define BFA_TRC_MAX	(4 * 1024)
 #endif
 
+#define BFA_TRC_TS(_trcm)                               \
+	({                                              \
+		struct timeval tv;                      \
+							\
+		do_gettimeofday(&tv);                   \
+		(tv.tv_sec*1000000+tv.tv_usec);         \
+	})
+
 #ifndef BFA_TRC_TS
 #define BFA_TRC_TS(_trcm)	((_trcm)->ticks++)
 #endif
 
 struct bfa_trc_s {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u16	fileno;
 	u16	line;
 #else
@@ -361,4 +369,43 @@ bfa_wc_wait(struct bfa_wc_s *wc)
 	bfa_wc_down(wc);
 }
 
+static inline void
+wwn2str(char *wwn_str, u64 wwn)
+{
+	union {
+		u64 wwn;
+		u8 byte[8];
+	} w;
+
+	w.wwn = wwn;
+	sprintf(wwn_str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", w.byte[0],
+		w.byte[1], w.byte[2], w.byte[3], w.byte[4], w.byte[5],
+		w.byte[6], w.byte[7]);
+}
+
+static inline void
+fcid2str(char *fcid_str, u32 fcid)
+{
+	union {
+		u32 fcid;
+		u8 byte[4];
+	} f;
+
+	f.fcid = fcid;
+	sprintf(fcid_str, "%02x:%02x:%02x", f.byte[1], f.byte[2], f.byte[3]);
+}
+
+#define bfa_swap_3b(_x)				\
+	((((_x) & 0xff) << 16) |		\
+	((_x) & 0x00ff00) |			\
+	(((_x) & 0xff0000) >> 16))
+
+#ifndef __BIG_ENDIAN
+#define bfa_hton3b(_x)  bfa_swap_3b(_x)
+#else
+#define bfa_hton3b(_x)  (_x)
+#endif
+
+#define bfa_ntoh3b(_x)  bfa_hton3b(_x)
+
 #endif /* __BFA_CS_H__ */
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index 07b57c4..d85f93a 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -19,7 +19,7 @@
 #define __BFA_DEFS_H__
 
 #include "bfa_fc.h"
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 
 #define BFA_MFG_SERIALNUM_SIZE                  11
 #define STRSZ(_n)                               (((_n) + 4) & ~3)
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index a478311..580ab03 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -18,7 +18,7 @@
 #ifndef __BFA_FC_H__
 #define __BFA_FC_H__
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 
 typedef u64 wwn_t;
 
@@ -62,7 +62,7 @@ struct scsi_cdb_s {
  * Fibre Channel Header Structure (FCHS) definition
  */
 struct fchs_s {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        routing:4;	/* routing bits */
 	u32        cat_info:4;	/* category info */
 #else
@@ -317,7 +317,7 @@ struct fc_plogi_csp_s {
 	u8         verlo;	/* FC-PH low version */
 	__be16        bbcred;	/* BB_Credit */
 
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u8         ciro:1,		/* continuously increasing RO */
 			rro:1,		/* random relative offset */
 			npiv_supp:1,	/* NPIV supported */
@@ -367,7 +367,7 @@ struct fc_plogi_csp_s {
  * FC-PH-x. Figure 78. pg. 318.
  */
 struct fc_plogi_clp_s {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        class_valid:1;
 	u32        intermix:1;	/* class intermix supported if set =1.
 					 * valid only for class1. Reserved for
@@ -532,7 +532,7 @@ struct fc_rsi_s {
  */
 struct fc_prli_params_s {
 	u32        reserved:16;
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        reserved1:5;
 	u32        rec_support:1;
 	u32        task_retry_id:1;
@@ -574,7 +574,7 @@ enum {
 struct fc_prli_params_page_s {
 	u32        type:8;
 	u32        codext:8;
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        origprocasv:1;
 	u32        rsppav:1;
 	u32        imagepair:1;
@@ -610,7 +610,7 @@ struct fc_prli_s {
 struct fc_prlo_params_page_s {
 	u32        type:8;
 	u32        type_ext:8;
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        opa_valid:1;	/* originator process associator
 					 * valid
 					 */
@@ -646,7 +646,7 @@ struct fc_prlo_acc_params_page_s {
 	u32        type:8;
 	u32        type_ext:8;
 
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        opa_valid:1;	/* originator process associator
 					 * valid
 					 */
@@ -803,7 +803,7 @@ struct fc_tprlo_params_page_s {
 u32        type:8;
 u32        type_ext:8;
 
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32        opa_valid:1;
 	u32        rpa_valid:1;
 	u32        tpo_nport_valid:1;
@@ -1177,7 +1177,7 @@ struct fc_srr_s {
 struct fcp_cmnd_s {
 	struct scsi_lun		lun;	/* 64-bit LU number */
 	u8			crn;	/* command reference number */
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u8         resvd:1,
 			priority:4,	/* FCP-3: SAM-3 priority */
 			taskattr:3;	/* scsi task attribute */
@@ -1187,7 +1187,7 @@ struct fcp_cmnd_s {
 			resvd:1;
 #endif
 	u8         tm_flags;	/* task management flags */
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u8         addl_cdb_len:6,	/* additional CDB length words */
 			iodir:2;	/* read/write FCP_DATA IUs */
 #else
@@ -1273,7 +1273,7 @@ struct fcp_rspinfo_s {
 struct fcp_resp_s {
 	u32        reserved[2];	/* 2 words reserved */
 	u16        reserved2;
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u8         reserved3:3;
 	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
 	u8         resid_flags:2;	/* underflow/overflow */
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 322b11e..1ca5af7 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -18,7 +18,7 @@
  * fcbuild.c - FC link service frame building and parsing routines
  */
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 #include "bfa_fcbuild.h"
 
 /*
@@ -48,7 +48,7 @@ fcbuild_init(void)
 	fc_els_req_tmpl.cat_info = FC_CAT_LD_REQUEST;
 	fc_els_req_tmpl.type = FC_TYPE_ELS;
 	fc_els_req_tmpl.f_ctl =
-		bfa_os_hton3b(FCTL_SEQ_INI | FCTL_FS_EXCH | FCTL_END_SEQ |
+		bfa_hton3b(FCTL_SEQ_INI | FCTL_FS_EXCH | FCTL_END_SEQ |
 			      FCTL_SI_XFER);
 	fc_els_req_tmpl.rx_id = FC_RXID_ANY;
 
@@ -59,7 +59,7 @@ fcbuild_init(void)
 	fc_els_rsp_tmpl.cat_info = FC_CAT_LD_REPLY;
 	fc_els_rsp_tmpl.type = FC_TYPE_ELS;
 	fc_els_rsp_tmpl.f_ctl =
-		bfa_os_hton3b(FCTL_EC_RESP | FCTL_SEQ_INI | FCTL_LS_EXCH |
+		bfa_hton3b(FCTL_EC_RESP | FCTL_SEQ_INI | FCTL_LS_EXCH |
 			      FCTL_END_SEQ | FCTL_SI_XFER);
 	fc_els_rsp_tmpl.rx_id = FC_RXID_ANY;
 
@@ -68,7 +68,7 @@ fcbuild_init(void)
 	 */
 	fc_bls_req_tmpl.routing = FC_RTG_BASIC_LINK;
 	fc_bls_req_tmpl.type = FC_TYPE_BLS;
-	fc_bls_req_tmpl.f_ctl = bfa_os_hton3b(FCTL_END_SEQ | FCTL_SI_XFER);
+	fc_bls_req_tmpl.f_ctl = bfa_hton3b(FCTL_END_SEQ | FCTL_SI_XFER);
 	fc_bls_req_tmpl.rx_id = FC_RXID_ANY;
 
 	/*
@@ -78,7 +78,7 @@ fcbuild_init(void)
 	fc_bls_rsp_tmpl.cat_info = FC_CAT_BA_ACC;
 	fc_bls_rsp_tmpl.type = FC_TYPE_BLS;
 	fc_bls_rsp_tmpl.f_ctl =
-		bfa_os_hton3b(FCTL_EC_RESP | FCTL_SEQ_INI | FCTL_LS_EXCH |
+		bfa_hton3b(FCTL_EC_RESP | FCTL_SEQ_INI | FCTL_LS_EXCH |
 			      FCTL_END_SEQ | FCTL_SI_XFER);
 	fc_bls_rsp_tmpl.rx_id = FC_RXID_ANY;
 
@@ -129,7 +129,7 @@ fcbuild_init(void)
 	fcp_fchs_tmpl.cat_info = FC_CAT_UNSOLICIT_CMD;
 	fcp_fchs_tmpl.type = FC_TYPE_FCP;
 	fcp_fchs_tmpl.f_ctl =
-		bfa_os_hton3b(FCTL_FS_EXCH | FCTL_END_SEQ | FCTL_SI_XFER);
+		bfa_hton3b(FCTL_FS_EXCH | FCTL_END_SEQ | FCTL_SI_XFER);
 	fcp_fchs_tmpl.seq_id = 1;
 	fcp_fchs_tmpl.rx_id = FC_RXID_ANY;
 }
@@ -143,7 +143,7 @@ fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 	fchs->cat_info = FC_CAT_UNSOLICIT_CTRL;
 	fchs->type = FC_TYPE_SERVICES;
 	fchs->f_ctl =
-		bfa_os_hton3b(FCTL_SEQ_INI | FCTL_FS_EXCH | FCTL_END_SEQ |
+		bfa_hton3b(FCTL_SEQ_INI | FCTL_FS_EXCH | FCTL_END_SEQ |
 			      FCTL_SI_XFER);
 	fchs->rx_id = FC_RXID_ANY;
 	fchs->d_id = (d_id);
@@ -232,7 +232,7 @@ fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 		u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size,
 	       u8 set_npiv, u8 set_auth, u16 local_bb_credits)
 {
-	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
+	u32        d_id = bfa_hton3b(FC_FABRIC_PORT);
 	__be32	*vvl_info;
 
 	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
@@ -289,7 +289,7 @@ u16
 fc_fdisc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 		u16 ox_id, wwn_t port_name, wwn_t node_name, u16 pdu_size)
 {
-	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
+	u32        d_id = bfa_hton3b(FC_FABRIC_PORT);
 
 	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
 
@@ -770,10 +770,10 @@ u16
 fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 		u32 s_id, u32 *pid_list, u16 npids)
 {
-	u32 dctlr_id = FC_DOMAIN_CTRLR(bfa_os_hton3b(d_id));
+	u32 dctlr_id = FC_DOMAIN_CTRLR(bfa_hton3b(d_id));
 	int i = 0;
 
-	fc_els_req_build(fchs, bfa_os_hton3b(dctlr_id), s_id, 0);
+	fc_els_req_build(fchs, bfa_hton3b(dctlr_id), s_id, 0);
 
 	memset(rpsc2, 0, sizeof(struct fc_rpsc2_cmd_s));
 
@@ -1045,7 +1045,7 @@ fc_gidpn_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_gidpn_req_s *gidpn = (struct fcgs_gidpn_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GID_PN);
@@ -1061,7 +1061,7 @@ fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	fcgs_gpnid_req_t *gpnid = (fcgs_gpnid_req_t *) (cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GPN_ID);
@@ -1077,7 +1077,7 @@ fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	fcgs_gnnid_req_t *gnnid = (fcgs_gnnid_req_t *) (cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GNN_ID);
@@ -1104,7 +1104,7 @@ u16
 fc_scr_build(struct fchs_s *fchs, struct fc_scr_s *scr,
 		u8 set_br_reg, u32 s_id, u16 ox_id)
 {
-	u32        d_id = bfa_os_hton3b(FC_FABRIC_CONTROLLER);
+	u32        d_id = bfa_hton3b(FC_FABRIC_CONTROLLER);
 
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
 
@@ -1121,7 +1121,7 @@ u16
 fc_rscn_build(struct fchs_s *fchs, struct fc_rscn_pl_s *rscn,
 		u32 s_id, u16 ox_id)
 {
-	u32        d_id = bfa_os_hton3b(FC_FABRIC_CONTROLLER);
+	u32        d_id = bfa_hton3b(FC_FABRIC_CONTROLLER);
 	u16        payldlen;
 
 	fc_els_req_build(fchs, d_id, s_id, ox_id);
@@ -1143,7 +1143,7 @@ fc_rftid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rftid_req_s *rftid = (struct fcgs_rftid_req_s *)(cthdr + 1);
-	u32        type_value, d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        type_value, d_id = bfa_hton3b(FC_NAME_SERVER);
 	u8         index;
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
@@ -1167,7 +1167,7 @@ fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rftid_req_s *rftid = (struct fcgs_rftid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RFT_ID);
@@ -1187,7 +1187,7 @@ fc_rffid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rffid_req_s *rffid = (struct fcgs_rffid_req_s *)(cthdr + 1);
-	u32         d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32         d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RFF_ID);
@@ -1209,7 +1209,7 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rspnid_req_s *rspnid =
 			(struct fcgs_rspnid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, ox_id);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RSPN_ID);
@@ -1229,7 +1229,7 @@ fc_gid_ft_build(struct fchs_s *fchs, void *pyld, u32 s_id, u8 fc4_type)
 
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_gidft_req_s *gidft = (struct fcgs_gidft_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 
@@ -1249,7 +1249,7 @@ fc_rpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rpnid_req_s *rpnid = (struct fcgs_rpnid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RPN_ID);
@@ -1267,7 +1267,7 @@ fc_rnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rnnid_req_s *rnnid = (struct fcgs_rnnid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RNN_ID);
@@ -1286,7 +1286,7 @@ fc_rcsid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rcsid_req_s *rcsid =
 			(struct fcgs_rcsid_req_s *) (cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RCS_ID);
@@ -1304,7 +1304,7 @@ fc_rptid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id,
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_rptid_req_s *rptid = (struct fcgs_rptid_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_RPT_ID);
@@ -1321,7 +1321,7 @@ fc_ganxt_build(struct fchs_s *fchs, void *pyld, u32 s_id, u32 port_id)
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	struct fcgs_ganxt_req_s *ganxt = (struct fcgs_ganxt_req_s *)(cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_NAME_SERVER);
+	u32        d_id = bfa_hton3b(FC_NAME_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_cthdr_build(cthdr, s_id, GS_GA_NXT);
@@ -1341,7 +1341,7 @@ fc_fdmi_reqhdr_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 {
 
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
-	u32        d_id = bfa_os_hton3b(FC_MGMT_SERVER);
+	u32        d_id = bfa_hton3b(FC_MGMT_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_fdmi_cthdr_build(cthdr, s_id, cmd_code);
@@ -1377,7 +1377,7 @@ fc_gmal_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	fcgs_gmal_req_t *gmal = (fcgs_gmal_req_t *) (cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_MGMT_SERVER);
+	u32        d_id = bfa_hton3b(FC_MGMT_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GMAL_CMD,
@@ -1397,7 +1397,7 @@ fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn)
 {
 	struct ct_hdr_s *cthdr = (struct ct_hdr_s *) pyld;
 	fcgs_gfn_req_t *gfn = (fcgs_gfn_req_t *) (cthdr + 1);
-	u32        d_id = bfa_os_hton3b(FC_MGMT_SERVER);
+	u32        d_id = bfa_hton3b(FC_MGMT_SERVER);
 
 	fc_gs_fchdr_build(fchs, d_id, s_id, 0);
 	fc_gs_ms_cthdr_build(cthdr, s_id, GS_FC_GFN_CMD,
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 1737e08..ece51ec 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -21,7 +21,7 @@
 #ifndef __FCBUILD_H__
 #define __FCBUILD_H__
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 #include "bfa_fc.h"
 #include "bfa_defs_fcs.h"
 
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 01d86ef..5977adb 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -15,8 +15,8 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_modules.h"
-#include "bfa_os_inc.h"
 
 BFA_TRC_FILE(HAL, FCPIM);
 BFA_MODULE(fcpim);
@@ -1560,24 +1560,6 @@ bfa_itnim_hold_io(struct bfa_itnim_s *itnim)
 		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_iocdisable));
 }
 
-bfa_status_t
-bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
-		struct bfa_itnim_ioprofile_s *ioprofile)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(itnim->bfa);
-	if (!fcpim->io_profile)
-		return BFA_STATUS_IOPROFILE_OFF;
-
-	itnim->ioprofile.index = BFA_IOBUCKET_MAX;
-	itnim->ioprofile.io_profile_start_time =
-		bfa_io_profile_start_time(itnim->bfa);
-	itnim->ioprofile.clock_res_mul = bfa_io_lat_clock_res_mul;
-	itnim->ioprofile.clock_res_div = bfa_io_lat_clock_res_div;
-	*ioprofile = itnim->ioprofile;
-
-	return BFA_STATUS_OK;
-}
-
 void
 bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
 {
@@ -2352,7 +2334,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	scsi_for_each_sg(cmnd, sg, ioim->nsges, i) {
 		if (i == 0) {
 			/* build inline IO SG element */
-			addr = bfa_os_sgaddr(sg_dma_address(sg));
+			addr = bfa_sgaddr_le(sg_dma_address(sg));
 			sge->sga = *(union bfi_addr_u *) &addr;
 			pgdlen = sg_dma_len(sg);
 			sge->sg_len = pgdlen;
@@ -2364,7 +2346,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 			if (sge_id == 0)
 				sgpge = sgpg->sgpg->sges;
 
-			addr = bfa_os_sgaddr(sg_dma_address(sg));
+			addr = bfa_sgaddr_le(sg_dma_address(sg));
 			sgpge->sga = *(union bfi_addr_u *) &addr;
 			sgpge->sg_len = sg_dma_len(sg);
 			pgcumsz += sgpge->sg_len;
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 6c1f446..4b90d34 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -19,9 +19,9 @@
  *  bfa_fcs.c BFA FCS main
  */
 
+#include "bfad_drv.h"
 #include "bfa_fcs.h"
 #include "bfa_fcbuild.h"
-#include "bfad_drv.h"
 
 BFA_TRC_FILE(FCS, FCS);
 
@@ -1097,7 +1097,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	 * external loopback cable is in place. Our own FLOGI frames are
 	 * sometimes looped back when switch port gets temporarily bypassed.
 	 */
-	if ((pid == bfa_os_ntoh3b(FC_FABRIC_PORT)) &&
+	if ((pid == bfa_ntoh3b(FC_FABRIC_PORT)) &&
 	    (els_cmd->els_code == FC_ELS_FLOGI) &&
 	    (flogi->port_name == bfa_fcs_lport_get_pwwn(&fabric->bport))) {
 		bfa_sm_send_event(fabric, BFA_FCS_FABRIC_SM_LOOPBACK);
@@ -1107,7 +1107,7 @@ bfa_fcs_fabric_uf_recv(struct bfa_fcs_fabric_s *fabric, struct fchs_s *fchs,
 	/*
 	 * FLOGI/EVFP exchanges should be consumed by base fabric.
 	 */
-	if (fchs->d_id == bfa_os_hton3b(FC_FABRIC_PORT)) {
+	if (fchs->d_id == bfa_hton3b(FC_FABRIC_PORT)) {
 		bfa_trc(fabric->fcs, pid);
 		bfa_fcs_fabric_process_uf(fabric, fchs, len);
 		return;
@@ -1220,7 +1220,7 @@ bfa_fcs_fabric_send_flogi_acc(struct bfa_fcs_fabric_s *fabric)
 		return;
 
 	reqlen = fc_flogi_acc_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-				    bfa_os_hton3b(FC_FABRIC_PORT),
+				    bfa_hton3b(FC_FABRIC_PORT),
 				    n2n_port->reply_oxid, pcfg->pwwn,
 				    pcfg->nwwn,
 				    bfa_fcport_get_maxfrsize(bfa),
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index e7977ee..f0e652b 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -61,7 +61,7 @@ struct bfa_fcs_s;
 #define N2N_LOCAL_PID	    0x010000
 #define N2N_REMOTE_PID		0x020000
 #define	BFA_FCS_RETRY_TIMEOUT 2000
-#define BFA_FCS_PID_IS_WKA(pid)  ((bfa_os_ntoh3b(pid) > 0xFFF000) ?  1 : 0)
+#define BFA_FCS_PID_IS_WKA(pid)  ((bfa_ntoh3b(pid) > 0xFFF000) ?  1 : 0)
 
 
 
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 561a557..bceb75c 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -19,9 +19,9 @@
  *  fcpim.c - FCP initiator mode i-t nexus state machine
  */
 
+#include "bfad_drv.h"
 #include "bfa_fcs.h"
 #include "bfa_fcbuild.h"
-#include "bfad_drv.h"
 #include "bfad_im.h"
 
 BFA_TRC_FILE(FCS, FCPIM);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index c2381c7..9eb47b8 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -15,10 +15,10 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_fcs.h"
 #include "bfa_fcbuild.h"
 #include "bfa_fc.h"
-#include "bfad_drv.h"
 
 BFA_TRC_FILE(FCS, PORT);
 
@@ -2818,7 +2818,7 @@ bfa_fcs_lport_ms_send_plogi(void *ms_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	ms->fcxp = fcxp;
 
 	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-			     bfa_os_hton3b(FC_MGMT_SERVER),
+			     bfa_hton3b(FC_MGMT_SERVER),
 			     bfa_fcs_lport_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
 				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
@@ -3575,7 +3575,7 @@ fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
 	ns->fcxp = fcxp;
 
 	len = fc_plogi_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-			     bfa_os_hton3b(FC_NAME_SERVER),
+			     bfa_hton3b(FC_NAME_SERVER),
 			     bfa_fcs_lport_get_fcid(port), 0,
 			     port->port_cfg.pwwn, port->port_cfg.nwwn,
 				 bfa_fcport_get_maxfrsize(port->fcs->bfa));
@@ -4654,7 +4654,7 @@ bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn, int index,
 
 	while ((qe != qh) && (i < nrports)) {
 		rport = (struct bfa_fcs_rport_s *) qe;
-		if (bfa_os_ntoh3b(rport->pid) > 0xFFF000) {
+		if (bfa_ntoh3b(rport->pid) > 0xFFF000) {
 			qe = bfa_q_next(qe);
 			bfa_trc(fcs, (u32) rport->pwwn);
 			bfa_trc(fcs, rport->pid);
@@ -4702,7 +4702,7 @@ bfa_fcs_lport_get_rports(struct bfa_fcs_lport_s *port,
 
 	while ((qe != qh) && (i < *nrports)) {
 		rport = (struct bfa_fcs_rport_s *) qe;
-		if (bfa_os_ntoh3b(rport->pid) > 0xFFF000) {
+		if (bfa_ntoh3b(rport->pid) > 0xFFF000) {
 			qe = bfa_q_next(qe);
 			bfa_trc(fcs, (u32) rport->pwwn);
 			bfa_trc(fcs, rport->pid);
@@ -4753,7 +4753,7 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
 
 	while (qe != qh) {
 		rport = (struct bfa_fcs_rport_s *) qe;
-		if ((bfa_os_ntoh3b(rport->pid) > 0xFFF000) ||
+		if ((bfa_ntoh3b(rport->pid) > 0xFFF000) ||
 			(bfa_fcs_rport_get_state(rport) ==
 			  BFA_RPORT_OFFLINE)) {
 			qe = bfa_q_next(qe);
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index b6332fd..110940c 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -19,9 +19,9 @@
  *  rport.c Remote port implementation.
  */
 
+#include "bfad_drv.h"
 #include "bfa_fcs.h"
 #include "bfa_fcbuild.h"
-#include "bfad_drv.h"
 
 BFA_TRC_FILE(FCS, RPORT);
 
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index d8464ae..1fa15ed 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_modules.h"
 #include "bfi_cbreg.h"
 
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index b0efbc7..68077c4 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_modules.h"
 #include "bfi_ctreg.h"
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index d23c114..97b36018 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -15,11 +15,11 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_ioc.h"
 #include "bfi_ctreg.h"
 #include "bfa_defs.h"
 #include "bfa_defs_svc.h"
-#include "bfad_drv.h"
 
 BFA_TRC_FILE(CNA, IOC);
 
@@ -1428,12 +1428,12 @@ static void
 bfa_ioc_send_enable(struct bfa_ioc_s *ioc)
 {
 	struct bfi_ioc_ctrl_req_s enable_req;
-	struct bfa_timeval_s tv;
+	struct timeval tv;
 
 	bfi_h2i_set(enable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_ENABLE_REQ,
 		    bfa_ioc_portid(ioc));
 	enable_req.ioc_class = ioc->ioc_mc;
-	bfa_os_gettimeofday(&tv);
+	do_gettimeofday(&tv);
 	enable_req.tv_sec = be32_to_cpu(tv.tv_sec);
 	bfa_ioc_mbox_send(ioc, &enable_req, sizeof(struct bfi_ioc_ctrl_req_s));
 }
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 3c5bdd1..62153f2 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -18,7 +18,7 @@
 #ifndef __BFA_IOC_H__
 #define __BFA_IOC_H__
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 #include "bfa_cs.h"
 #include "bfi.h"
 
@@ -74,7 +74,7 @@ struct bfa_sge_s {
 #define bfa_swap_words(_x)  (	\
 	((_x) << 32) | ((_x) >> 32))
 
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 #define bfa_sge_to_be(_x)
 #define bfa_sge_to_le(_x)	bfa_sge_word_swap(_x)
 #define bfa_sgaddr_le(_x)	bfa_swap_words(_x)
@@ -120,7 +120,7 @@ static inline void
 __bfa_dma_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 {
 	dma_addr->a32.addr_lo = (__be32) pa;
-	dma_addr->a32.addr_hi = (__be32) (bfa_os_u32(pa));
+	dma_addr->a32.addr_hi = (__be32) (pa >> 32);
 }
 
 
@@ -130,7 +130,7 @@ static inline void
 __bfa_dma_be_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 {
 	dma_addr->a32.addr_lo = cpu_to_be32(pa);
-	dma_addr->a32.addr_hi = cpu_to_be32(bfa_os_u32(pa));
+	dma_addr->a32.addr_hi = cpu_to_be32(pa >> 32);
 }
 
 struct bfa_ioc_regs_s {
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index e9c8554..a0e05da 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_ioc.h"
 #include "bfi_cbreg.h"
 #include "bfa_defs.h"
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 45d0ddc..25a5d3c 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_ioc.h"
 #include "bfi_ctreg.h"
 #include "bfa_defs.h"
diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
deleted file mode 100644
index 65df62e..0000000
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ /dev/null
@@ -1,143 +0,0 @@
-/*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_OS_INC_H__
-#define __BFA_OS_INC_H__
-
-#include <linux/types.h>
-#include <linux/version.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
-#include <linux/idr.h>
-#include <linux/interrupt.h>
-#include <linux/cdev.h>
-#include <linux/fs.h>
-#include <linux/delay.h>
-#include <linux/vmalloc.h>
-#include <linux/workqueue.h>
-#include <linux/bitops.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_transport_fc.h>
-#include <scsi/scsi_transport.h>
-
-#ifdef __BIG_ENDIAN
-#define __BIGENDIAN
-#endif
-
-static inline u64 bfa_os_get_log_time(void)
-{
-	u64 system_time = 0;
-	struct timeval tv;
-	do_gettimeofday(&tv);
-
-	/* We are interested in seconds only. */
-	system_time = tv.tv_sec;
-	return system_time;
-}
-
-#define bfa_io_lat_clock_res_div HZ
-#define bfa_io_lat_clock_res_mul 1000
-
-#define BFA_LOG(level, bfad, mask, fmt, arg...)				\
-do {									\
-	if (((mask) == 4) || (level[1] <= '4'))				\
-		dev_printk(level, &((bfad)->pcidev)->dev, fmt, ##arg);	\
-} while (0)
-
-#define bfa_swap_3b(_x)				\
-	((((_x) & 0xff) << 16) |		\
-	((_x) & 0x00ff00) |			\
-	(((_x) & 0xff0000) >> 16))
-
-#define bfa_os_swap_sgaddr(_x)  ((u64)(                                 \
-	(((u64)(_x) & (u64)0x00000000000000ffull) << 32)        |       \
-	(((u64)(_x) & (u64)0x000000000000ff00ull) << 32)        |       \
-	(((u64)(_x) & (u64)0x0000000000ff0000ull) << 32)        |       \
-	(((u64)(_x) & (u64)0x00000000ff000000ull) << 32)        |       \
-	(((u64)(_x) & (u64)0x000000ff00000000ull) >> 32)        |       \
-	(((u64)(_x) & (u64)0x0000ff0000000000ull) >> 32)        |       \
-	(((u64)(_x) & (u64)0x00ff000000000000ull) >> 32)        |       \
-	(((u64)(_x) & (u64)0xff00000000000000ull) >> 32)))
-
-#ifndef __BIGENDIAN
-#define bfa_os_hton3b(_x)  bfa_swap_3b(_x)
-#define bfa_os_sgaddr(_x)  (_x)
-#else
-#define bfa_os_hton3b(_x)  (_x)
-#define bfa_os_sgaddr(_x)  bfa_os_swap_sgaddr(_x)
-#endif
-
-#define bfa_os_ntoh3b(_x)  bfa_os_hton3b(_x)
-#define bfa_os_u32(__pa64) ((__pa64) >> 32)
-
-#define BFA_TRC_TS(_trcm)				\
-	({						\
-		struct timeval tv;			\
-							\
-		do_gettimeofday(&tv);			\
-		(tv.tv_sec*1000000+tv.tv_usec);		\
-	 })
-
-#define boolean_t int
-
-/*
- * For current time stamp, OS API will fill-in
- */
-struct bfa_timeval_s {
-	u32	tv_sec;		/*  seconds        */
-	u32	tv_usec;	/*  microseconds   */
-};
-
-static inline void
-bfa_os_gettimeofday(struct bfa_timeval_s *tv)
-{
-	struct timeval  tmp_tv;
-
-	do_gettimeofday(&tmp_tv);
-	tv->tv_sec = (u32) tmp_tv.tv_sec;
-	tv->tv_usec = (u32) tmp_tv.tv_usec;
-}
-
-static inline void
-wwn2str(char *wwn_str, u64 wwn)
-{
-	union {
-		u64 wwn;
-		u8 byte[8];
-	} w;
-
-	w.wwn = wwn;
-	sprintf(wwn_str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", w.byte[0],
-		w.byte[1], w.byte[2], w.byte[3], w.byte[4], w.byte[5],
-		w.byte[6], w.byte[7]);
-}
-
-static inline void
-fcid2str(char *fcid_str, u32 fcid)
-{
-	union {
-		u32 fcid;
-		u8 byte[4];
-	} f;
-
-	f.fcid = fcid;
-	sprintf(fcid_str, "%02x:%02x:%02x", f.byte[1], f.byte[2], f.byte[3]);
-}
-
-#endif /* __BFA_OS_INC_H__ */
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 76efb9a..45b3486 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include "bfad_drv.h"
 #include "bfa_defs_svc.h"
 #include "bfa_port.h"
 #include "bfi.h"
@@ -36,7 +37,7 @@ bfa_port_stats_swap(struct bfa_port_s *port, union bfa_port_stats_u *stats)
 		i += 2) {
 		t0 = dip[i];
 		t1 = dip[i + 1];
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 		dip[i] = be32_to_cpu(t0);
 		dip[i + 1] = be32_to_cpu(t1);
 #else
@@ -96,13 +97,13 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->stats_busy = BFA_FALSE;
 
 	if (status == BFA_STATUS_OK) {
-		struct bfa_timeval_s tv;
+		struct timeval tv;
 
 		memcpy(port->stats, port->stats_dma.kva,
 		       sizeof(union bfa_port_stats_u));
 		bfa_port_stats_swap(port, port->stats);
 
-		bfa_os_gettimeofday(&tv);
+		do_gettimeofday(&tv);
 		port->stats->fc.secs_reset = tv.tv_sec - port->stats_reset_time;
 	}
 
@@ -124,7 +125,7 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 static void
 bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 {
-	struct bfa_timeval_s tv;
+	struct timeval tv;
 
 	port->stats_status = status;
 	port->stats_busy   = BFA_FALSE;
@@ -132,7 +133,7 @@ bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	/*
 	* re-initialize time stamp for stats reset
 	*/
-	bfa_os_gettimeofday(&tv);
+	do_gettimeofday(&tv);
 	port->stats_reset_time = tv.tv_sec;
 
 	if (port->stats_cbfn) {
@@ -432,7 +433,7 @@ void
 bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 		 void *dev, struct bfa_trc_mod_s *trcmod)
 {
-	struct bfa_timeval_s tv;
+	struct timeval tv;
 
 	bfa_assert(port);
 
@@ -452,7 +453,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 	/*
 	 * initialize time stamp for stats reset
 	 */
-	bfa_os_gettimeofday(&tv);
+	do_gettimeofday(&tv);
 	port->stats_reset_time = tv.tv_sec;
 
 	bfa_trc(port, 0);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index a708d95..5dfe6d4 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -15,11 +15,10 @@
  * General Public License for more details.
  */
 
-#include "bfa_os_inc.h"
+#include "bfad_drv.h"
 #include "bfa_plog.h"
 #include "bfa_cs.h"
 #include "bfa_modules.h"
-#include "bfad_drv.h"
 
 BFA_TRC_FILE(HAL, FCXP);
 BFA_MODULE(fcxp);
@@ -286,6 +285,18 @@ plkd_validate_logrec(struct bfa_plog_rec_s *pl_rec)
 	return 0;
 }
 
+static u64 
+bfa_get_log_time(void)
+{
+	u64 system_time = 0;
+	struct timeval tv;
+	do_gettimeofday(&tv);
+
+	/* We are interested in seconds only. */
+	system_time = tv.tv_sec;
+	return system_time;
+}
+
 static void
 bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 {
@@ -306,7 +317,7 @@ bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
 
 	memcpy(pl_recp, pl_rec, sizeof(struct bfa_plog_rec_s));
 
-	pl_recp->tv = bfa_os_get_log_time();
+	pl_recp->tv = bfa_get_log_time();
 	BFA_PL_LOG_REC_INCR(plog->tail);
 
 	if (plog->head == plog->tail)
@@ -2728,7 +2739,7 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	struct bfa_port_cfg_s *port_cfg = &fcport->cfg;
 	struct bfa_fcport_ln_s *ln = &fcport->ln;
-	struct bfa_timeval_s tv;
+	struct timeval tv;
 
 	memset(fcport, 0, sizeof(struct bfa_fcport_s));
 	fcport->bfa = bfa;
@@ -2742,7 +2753,7 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	/*
 	 * initialize time stamp for stats reset
 	 */
-	bfa_os_gettimeofday(&tv);
+	do_gettimeofday(&tv);
 	fcport->stats_reset_time = tv.tv_sec;
 
 	/*
@@ -2967,7 +2978,7 @@ bfa_fcport_fcoe_stats_swap(struct bfa_fcoe_stats_s *d,
 
 	for (i = 0; i < ((sizeof(struct bfa_fcoe_stats_s))/sizeof(u32));
 	     i = i + 2) {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 		dip[i] = be32_to_cpu(sip[i]);
 		dip[i + 1] = be32_to_cpu(sip[i + 1]);
 #else
@@ -2984,7 +2995,7 @@ __bfa_cb_fcport_stats_get(void *cbarg, bfa_boolean_t complete)
 
 	if (complete) {
 		if (fcport->stats_status == BFA_STATUS_OK) {
-			struct bfa_timeval_s tv;
+			struct timeval tv;
 
 			/* Swap FC QoS or FCoE stats */
 			if (bfa_ioc_get_fcmode(&fcport->bfa->ioc)) {
@@ -2996,7 +3007,7 @@ __bfa_cb_fcport_stats_get(void *cbarg, bfa_boolean_t complete)
 					&fcport->stats_ret->fcoe,
 					&fcport->stats->fcoe);
 
-				bfa_os_gettimeofday(&tv);
+				do_gettimeofday(&tv);
 				fcport->stats_ret->fcoe.secs_reset =
 					tv.tv_sec - fcport->stats_reset_time;
 			}
@@ -3055,12 +3066,12 @@ __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete)
 	struct bfa_fcport_s *fcport = cbarg;
 
 	if (complete) {
-		struct bfa_timeval_s tv;
+		struct timeval tv;
 
 		/*
 		 * re-initialize time stamp for stats reset
 		 */
-		bfa_os_gettimeofday(&tv);
+		do_gettimeofday(&tv);
 		fcport->stats_reset_time = tv.tv_sec;
 
 		fcport->stats_cbfn(fcport->stats_cbarg, fcport->stats_status);
@@ -4929,11 +4940,7 @@ bfa_uf_start(struct bfa_s *bfa)
 {
 	bfa_uf_post_all(BFA_UF_MOD(bfa));
 }
-
-/*
- *  hal_uf_api
- */
-
+ 
 /*
  * Register handler for all unsolicted recieve frames.
  *
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index ac21d31..fdcb340 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -32,7 +32,6 @@
 #include "bfad_drv.h"
 #include "bfad_im.h"
 #include "bfa_fcs.h"
-#include "bfa_os_inc.h"
 #include "bfa_defs.h"
 #include "bfa.h"
 
@@ -1102,15 +1101,15 @@ bfad_start_ops(struct bfad_s *bfad) {
 
 	/*
 	 * If bfa_linkup_delay is set to -1 default; try to retrive the
-	 * value using the bfad_os_get_linkup_delay(); else use the
+	 * value using the bfad_get_linkup_delay(); else use the
 	 * passed in module param value as the bfa_linkup_delay.
 	 */
 	if (bfa_linkup_delay < 0) {
-		bfa_linkup_delay = bfad_os_get_linkup_delay(bfad);
-		bfad_os_rport_online_wait(bfad);
+		bfa_linkup_delay = bfad_get_linkup_delay(bfad);
+		bfad_rport_online_wait(bfad);
 		bfa_linkup_delay = -1;
 	} else
-		bfad_os_rport_online_wait(bfad);
+		bfad_rport_online_wait(bfad);
 
 	BFA_LOG(KERN_INFO, bfad, log_level, "bfa device claimed\n");
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index d727f05..a94ea42 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -40,7 +40,7 @@ bfad_im_get_starget_port_id(struct scsi_target *starget)
 	bfad = im_port->bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	itnim = bfad_os_get_itnim(im_port, starget->id);
+	itnim = bfad_get_itnim(im_port, starget->id);
 	if (itnim)
 		fc_id = bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim);
 
@@ -66,7 +66,7 @@ bfad_im_get_starget_node_name(struct scsi_target *starget)
 	bfad = im_port->bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	itnim = bfad_os_get_itnim(im_port, starget->id);
+	itnim = bfad_get_itnim(im_port, starget->id);
 	if (itnim)
 		node_name = bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim);
 
@@ -92,7 +92,7 @@ bfad_im_get_starget_port_name(struct scsi_target *starget)
 	bfad = im_port->bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	itnim = bfad_os_get_itnim(im_port, starget->id);
+	itnim = bfad_get_itnim(im_port, starget->id);
 	if (itnim)
 		port_name = bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim);
 
@@ -111,7 +111,7 @@ bfad_im_get_host_port_id(struct Scsi_Host *shost)
 	struct bfad_port_s    *port = im_port->port;
 
 	fc_host_port_id(shost) =
-			bfa_os_hton3b(bfa_fcs_lport_get_fcid(port->fcs_port));
+			bfa_hton3b(bfa_fcs_lport_get_fcid(port->fcs_port));
 }
 
 /*
@@ -487,7 +487,7 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	wait_for_completion(vport->comp_del);
 
 free_scsi_host:
-	bfad_os_scsi_host_free(bfad, im_port);
+	bfad_scsi_host_free(bfad, im_port);
 
 	kfree(vport);
 
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 732c29d..09c347f 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -26,7 +26,23 @@
 #ifndef __BFAD_DRV_H__
 #define __BFAD_DRV_H__
 
-#include "bfa_os_inc.h"
+#include <linux/types.h>
+#include <linux/version.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/idr.h>
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/bitops.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_transport.h>
 
 #include "bfa_modules.h"
 #include "bfa_fcs.h"
@@ -272,19 +288,12 @@ do {                                            \
 } while (0)
 
 
-#define list_remove_head(list, entry, type, member)		\
-do {								\
-	entry = NULL;                                           \
-	if (!list_empty(list)) {                                \
-		entry = list_entry((list)->next, type, member);	\
-		list_del_init(&entry->member);			\
-	}							\
+#define BFA_LOG(level, bfad, mask, fmt, arg...)				\
+do {									\
+	if (((mask) == 4) || (level[1] <= '4'))				\
+		dev_printk(level, &((bfad)->pcidev)->dev, fmt, ##arg);	\
 } while (0)
 
-#define list_get_first(list, type, member)				\
-((list_empty(list)) ? NULL :						\
-	list_entry((list)->next, type, member))
-
 bfa_status_t	bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 				  struct bfa_lport_cfg_s *port_cfg,
 				  struct device *dev);
@@ -316,8 +325,8 @@ void		bfad_debugfs_exit(struct bfad_port_s *port);
 
 void bfad_pci_remove(struct pci_dev *pdev);
 int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid);
-void bfad_os_rport_online_wait(struct bfad_s *bfad);
-int bfad_os_get_linkup_delay(struct bfad_s *bfad);
+void bfad_rport_online_wait(struct bfad_s *bfad);
+int bfad_get_linkup_delay(struct bfad_s *bfad);
 int bfad_install_msix_handler(struct bfad_s *bfad);
 
 extern struct idr bfad_im_port_index;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8cc4451..95761ca 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -92,10 +92,10 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 		if (!cmnd->result && itnim &&
 			 (bfa_lun_queue_depth > cmnd->device->queue_depth)) {
 			/* Queue depth adjustment for good status completion */
-			bfad_os_ramp_up_qdepth(itnim, cmnd->device);
+			bfad_ramp_up_qdepth(itnim, cmnd->device);
 		} else if (cmnd->result == SAM_STAT_TASK_SET_FULL && itnim) {
 			/* qfull handling */
-			bfad_os_handle_qfull(itnim, cmnd->device);
+			bfad_handle_qfull(itnim, cmnd->device);
 		}
 	}
 
@@ -123,7 +123,7 @@ bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)
 		if (itnim_data) {
 			itnim = itnim_data->itnim;
 			if (itnim)
-				bfad_os_ramp_up_qdepth(itnim, cmnd->device);
+				bfad_ramp_up_qdepth(itnim, cmnd->device);
 		}
 	}
 
@@ -365,7 +365,7 @@ bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	for (i = 0; i < MAX_FCP_TARGET; i++) {
-		itnim = bfad_os_get_itnim(im_port, i);
+		itnim = bfad_get_itnim(im_port, i);
 		if (itnim) {
 			cmnd->SCp.ptr = (char *)&wq;
 			rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
@@ -546,7 +546,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 
 	mutex_unlock(&bfad_mutex);
 
-	im_port->shost = bfad_os_scsi_host_alloc(im_port, bfad);
+	im_port->shost = bfad_scsi_host_alloc(im_port, bfad);
 	if (!im_port->shost) {
 		error = 1;
 		goto out_free_idr;
@@ -572,7 +572,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 	}
 
 	/* setup host fixed attribute if the lk supports */
-	bfad_os_fc_host_init(im_port);
+	bfad_fc_host_init(im_port);
 
 	return 0;
 
@@ -683,7 +683,7 @@ bfad_im_probe(struct bfad_s *bfad)
 	bfad->im = im;
 	im->bfad = bfad;
 
-	if (bfad_os_thread_workq(bfad) != BFA_STATUS_OK) {
+	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
 		rc = BFA_STATUS_FAILED;
 	}
@@ -696,14 +696,14 @@ void
 bfad_im_probe_undo(struct bfad_s *bfad)
 {
 	if (bfad->im) {
-		bfad_os_destroy_workq(bfad->im);
+		bfad_destroy_workq(bfad->im);
 		kfree(bfad->im);
 		bfad->im = NULL;
 	}
 }
 
 struct Scsi_Host *
-bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
+bfad_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 {
 	struct scsi_host_template *sht;
 
@@ -718,7 +718,7 @@ bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 }
 
 void
-bfad_os_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
+bfad_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 {
 	if (!(im_port->flags & BFAD_PORT_DELETE))
 		flush_workqueue(bfad->im->drv_workq);
@@ -728,7 +728,7 @@ bfad_os_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 }
 
 void
-bfad_os_destroy_workq(struct bfad_im_s *im)
+bfad_destroy_workq(struct bfad_im_s *im)
 {
 	if (im && im->drv_workq) {
 		flush_workqueue(im->drv_workq);
@@ -738,7 +738,7 @@ bfad_os_destroy_workq(struct bfad_im_s *im)
 }
 
 bfa_status_t
-bfad_os_thread_workq(struct bfad_s *bfad)
+bfad_thread_workq(struct bfad_s *bfad)
 {
 	struct bfad_im_s      *im = bfad->im;
 
@@ -842,7 +842,7 @@ bfad_im_module_exit(void)
 }
 
 void
-bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
+bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 {
 	struct scsi_device *tmp_sdev;
 
@@ -870,7 +870,7 @@ bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 }
 
 void
-bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
+bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 {
 	struct scsi_device *tmp_sdev;
 
@@ -884,7 +884,7 @@ bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 }
 
 struct bfad_itnim_s *
-bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id)
+bfad_get_itnim(struct bfad_im_port_s *im_port, int id)
 {
 	struct bfad_itnim_s   *itnim = NULL;
 
@@ -945,7 +945,7 @@ bfad_im_supported_speeds(struct bfa_s *bfa)
 }
 
 void
-bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
+bfad_fc_host_init(struct bfad_im_port_s *im_port)
 {
 	struct Scsi_Host *host = im_port->shost;
 	struct bfad_s         *bfad = im_port->bfad;
@@ -989,7 +989,7 @@ bfad_im_fc_rport_add(struct bfad_im_port_s *im_port, struct bfad_itnim_s *itnim)
 	rport_ids.port_name =
 		cpu_to_be64(bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
 	rport_ids.port_id =
-		bfa_os_hton3b(bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim));
+		bfa_hton3b(bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim));
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
 	itnim->fc_rport = fc_rport =
@@ -1191,7 +1191,7 @@ out_fail_cmd:
 static DEF_SCSI_QCMD(bfad_im_queuecommand)
 
 void
-bfad_os_rport_online_wait(struct bfad_s *bfad)
+bfad_rport_online_wait(struct bfad_s *bfad)
 {
 	int i;
 	int rport_delay = 10;
@@ -1219,7 +1219,7 @@ bfad_os_rport_online_wait(struct bfad_s *bfad)
 }
 
 int
-bfad_os_get_linkup_delay(struct bfad_s *bfad)
+bfad_get_linkup_delay(struct bfad_s *bfad)
 {
 	u8		nwwns = 0;
 	wwn_t		wwns[BFA_PREBOOT_BOOTLUN_MAX];
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index b038c0e..bfee63b 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -117,17 +117,17 @@ struct bfad_im_s {
 	char            drv_workq_name[KOBJ_NAME_LEN];
 };
 
-struct Scsi_Host *bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port,
+struct Scsi_Host *bfad_scsi_host_alloc(struct bfad_im_port_s *im_port,
 				struct bfad_s *);
-bfa_status_t bfad_os_thread_workq(struct bfad_s *bfad);
-void bfad_os_destroy_workq(struct bfad_im_s *im);
-void bfad_os_fc_host_init(struct bfad_im_port_s *im_port);
-void bfad_os_scsi_host_free(struct bfad_s *bfad,
+bfa_status_t bfad_thread_workq(struct bfad_s *bfad);
+void bfad_destroy_workq(struct bfad_im_s *im);
+void bfad_fc_host_init(struct bfad_im_port_s *im_port);
+void bfad_scsi_host_free(struct bfad_s *bfad,
 				 struct bfad_im_port_s *im_port);
-void bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim,
+void bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim,
 				 struct scsi_device *sdev);
-void bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev);
-struct bfad_itnim_s *bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id);
+void bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev);
+struct bfad_itnim_s *bfad_get_itnim(struct bfad_im_port_s *im_port, int id);
 
 extern struct scsi_host_template bfad_im_scsi_host_template;
 extern struct scsi_host_template bfad_im_vport_template;
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index e194484..72b69a0 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -104,7 +104,7 @@ union bfi_addr_u {
  * Scatter Gather Element
  */
 struct bfi_sge_s {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32	flags:2,
 			rsvd:2,
 			sg_len:28;
-- 
1.7.2.1

