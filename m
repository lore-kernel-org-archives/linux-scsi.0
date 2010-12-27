From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/3] bfa: remove unused defintions and misc cleanups
Date: Sun, 26 Dec 2010 21:50:10 -0800
Message-ID: <1293429010-20500-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:45599 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab0L0FuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2010 00:50:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch removes unused functions, data strucutres, and definitions.  It
also includes misc comment and formatting cleanups.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa.h        |    2 -
 drivers/scsi/bfa/bfa_core.c   |   12 -
 drivers/scsi/bfa/bfa_fc.h     |  582 ++++++++++-------------------------------
 drivers/scsi/bfa/bfa_fcpim.c  |    2 +-
 drivers/scsi/bfa/bfa_ioc.c    |   38 +---
 drivers/scsi/bfa/bfa_ioc.h    |    9 -
 drivers/scsi/bfa/bfa_ioc_cb.c |    9 +-
 drivers/scsi/bfa/bfa_ioc_ct.c |    6 +-
 drivers/scsi/bfa/bfa_svc.c    |    6 +-
 9 files changed, 155 insertions(+), 511 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index ed156c5..563e617 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -334,8 +334,6 @@ void bfa_hwct_msix_get_rme_range(struct bfa_s *bfa, u32 *start,
 void bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns);
 wwn_t bfa_iocfc_get_pwwn(struct bfa_s *bfa);
 wwn_t bfa_iocfc_get_nwwn(struct bfa_s *bfa);
-void bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa,
-				struct bfa_boot_pbc_s *pbcfg);
 int bfa_iocfc_get_pbc_vports(struct bfa_s *bfa,
 				struct bfi_pbc_vport_s *pbc_vport);
 
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index d6c7e05..1cd5c8b 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -998,18 +998,6 @@ bfa_iocfc_get_bootwwns(struct bfa_s *bfa, u8 *nwwns, wwn_t *wwns)
 	memcpy(wwns, cfgrsp->bootwwns.wwn, sizeof(cfgrsp->bootwwns.wwn));
 }
 
-void
-bfa_iocfc_get_pbc_boot_cfg(struct bfa_s *bfa, struct bfa_boot_pbc_s *pbcfg)
-{
-	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
-	struct bfi_iocfc_cfgrsp_s *cfgrsp = iocfc->cfgrsp;
-
-	pbcfg->enable = cfgrsp->pbc_cfg.boot_enabled;
-	pbcfg->nbluns = cfgrsp->pbc_cfg.nbluns;
-	pbcfg->speed = cfgrsp->pbc_cfg.port_speed;
-	memcpy(pbcfg->pblun, cfgrsp->pbc_cfg.blun, sizeof(pbcfg->pblun));
-}
-
 int
 bfa_iocfc_get_pbc_vports(struct bfa_s *bfa, struct bfi_pbc_vport_s *pbc_vport)
 {
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 0d04ba9..f63c3b5 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -24,7 +24,6 @@ typedef u64 wwn_t;
 
 #define WWN_NULL	(0)
 #define FC_SYMNAME_MAX	256	/*  max name server symbolic name size */
-#define FC_ALPA_MAX	128
 
 #pragma pack(1)
 
@@ -39,7 +38,6 @@ struct mac_s { u8 mac[MAC_ADDRLEN]; };
 struct scsi_cdb_s {
 	u8         scsi_cdb[SCSI_MAX_CDBLEN];
 };
-#define scsi_cdb_t struct scsi_cdb_s
 
 /* ------------------------------------------------------------
  * SCSI status byte values
@@ -74,34 +72,19 @@ struct fchs_s {
 	u32        cs_ctl:8;	/* class specific control */
 	u32        s_id:24;	/* source identifier */
 
-	u32        type:8;		/* data structure type */
+	u32        type:8;	/* data structure type */
 	u32        f_ctl:24;	/* initial frame control */
 
-	u8         seq_id;		/* sequence identifier */
-	u8         df_ctl;		/* data field control */
+	u8         seq_id;	/* sequence identifier */
+	u8         df_ctl;	/* data field control */
 	u16        seq_cnt;	/* sequence count */
 
-	__be16     ox_id;		/* originator exchange ID */
-	u16        rx_id;		/* responder exchange ID */
+	__be16     ox_id;	/* originator exchange ID */
+	u16        rx_id;	/* responder exchange ID */
 
 	u32        ro;		/* relative offset */
 };
 
-#define FC_SOF_LEN		4
-#define FC_EOF_LEN		4
-#define FC_CRC_LEN		4
-
-/*
- * Fibre Channel BB_E Header Structure
- */
-struct fcbbehs_s {
-	u16	ver_rsvd;
-	u32	rsvd[2];
-	u32	rsvd__sof;
-};
-
-#define FC_SEQ_ID_MAX		256
-
 /*
  * routing bit definitions
  */
@@ -148,22 +131,6 @@ enum {
 };
 
 /*
- * information category for Link Control
- */
-enum {
-	FC_CAT_ACK_1		= 0x00,
-	FC_CAT_ACK_0_N		= 0x01,
-	FC_CAT_P_RJT		= 0x02,
-	FC_CAT_F_RJT		= 0x03,
-	FC_CAT_P_BSY		= 0x04,
-	FC_CAT_F_BSY_DATA	= 0x05,
-	FC_CAT_F_BSY_LINK_CTL	= 0x06,
-	FC_CAT_F_LCR		= 0x07,
-	FC_CAT_NTY		= 0x08,
-	FC_CAT_END		= 0x09,
-};
-
-/*
  * Type Field Definitions. FC-PH Section 18.5 pg. 165
  */
 enum {
@@ -181,10 +148,6 @@ enum {
 	FC_TYPE_MAX		= 256,	/* 256 FC-4 types */
 };
 
-struct fc_fc4types_s {
-	u8         bits[FC_TYPE_MAX / 8];
-};
-
 /*
  * Frame Control Definitions. FC-PH Table-45. pg. 168
  */
@@ -287,7 +250,6 @@ enum {
 	FC_ELS_AUTH = 0x90,	/* Authentication. Ref FC-SP */
 	FC_ELS_RFCN = 0x97,	/* Request Fabric Change Notification. Ref
 				 *FC-SP */
-
 };
 
 /*
@@ -313,12 +275,12 @@ enum {
  * FC-PH-x. Figure-76. pg. 308.
  */
 struct fc_plogi_csp_s {
-	u8         verhi;	/* FC-PH high version */
-	u8         verlo;	/* FC-PH low version */
-	__be16        bbcred;	/* BB_Credit */
+	u8         	verhi;		/* FC-PH high version */
+	u8		verlo;		/* FC-PH low version */
+	__be16		bbcred;		/* BB_Credit */
 
 #ifdef __BIG_ENDIAN
-	u8         ciro:1,		/* continuously increasing RO */
+	u8		ciro:1,		/* continuously increasing RO */
 			rro:1,		/* random relative offset */
 			npiv_supp:1,	/* NPIV supported */
 			port_type:1,	/* N_Port/F_port */
@@ -327,7 +289,7 @@ struct fc_plogi_csp_s {
 			vvl_info:1,	/* VVL Info included */
 			reserved1:1;
 
-	u8         hg_supp:1,
+	u8		hg_supp:1,
 			query_dbc:1,
 			security:1,
 			sync_cap:1,
@@ -336,7 +298,7 @@ struct fc_plogi_csp_s {
 			cisc:1,		/* continuously increasing seq count */
 			payload:1;
 #else
-	u8         reserved2:2,
+	u8		reserved2:2,
 			resolution:1,	/* ms/ns ED_TOV resolution */
 			altbbcred:1,	/* alternate BB_Credit */
 			port_type:1,	/* N_Port/F_port */
@@ -344,7 +306,7 @@ struct fc_plogi_csp_s {
 			rro:1,		/* random relative offset */
 			ciro:1;		/* continuously increasing RO */
 
-	u8         payload:1,
+	u8		payload:1,
 			cisc:1,		/* continuously increasing seq count */
 			dh_dup_supp:1,
 			r_t_tov:1,
@@ -353,13 +315,10 @@ struct fc_plogi_csp_s {
 			query_dbc:1,
 			hg_supp:1;
 #endif
-
-	__be16        rxsz;		/* recieve data_field size */
-
-	__be16        conseq;
-	__be16        ro_bitmap;
-
-	__be32        e_d_tov;
+	__be16		rxsz;		/* recieve data_field size */
+	__be16		conseq;
+	__be16		ro_bitmap;
+	__be32		e_d_tov;
 };
 
 /*
@@ -370,9 +329,8 @@ struct fc_plogi_clp_s {
 #ifdef __BIG_ENDIAN
 	u32        class_valid:1;
 	u32        intermix:1;	/* class intermix supported if set =1.
-					 * valid only for class1. Reserved for
-					 * class2 & class3
-					 */
+				 * valid only for class1. Reserved for
+				 * class2 & class3 */
 	u32        reserved1:2;
 	u32        sequential:1;
 	u32        reserved2:3;
@@ -381,12 +339,10 @@ struct fc_plogi_clp_s {
 	u32        sequential:1;
 	u32        reserved1:2;
 	u32        intermix:1;	/* class intermix supported if set =1.
-					 * valid only for class1. Reserved for
-					 * class2 & class3
-					 */
+				 * valid only for class1. Reserved for
+				 * class2 & class3 */
 	u32        class_valid:1;
 #endif
-
 	u32        reserved3:24;
 
 	u32        reserved4:16;
@@ -394,7 +350,7 @@ struct fc_plogi_clp_s {
 
 	u32        reserved5:8;
 	u32        conseq:8;
-	u32        e2e_credit:16;	/* end to end credit */
+	u32        e2e_credit:16; /* end to end credit */
 
 	u32        reserved7:8;
 	u32        ospx:8;
@@ -408,24 +364,24 @@ struct fc_plogi_clp_s {
  * PLOGI els command and reply payload
  */
 struct fc_logi_s {
-	struct fc_els_cmd_s els_cmd;	/* ELS command code */
-	struct fc_plogi_csp_s csp;		/* common service params */
-	wwn_t           port_name;
-	wwn_t           node_name;
-	struct fc_plogi_clp_s class1;		/* class 1 service parameters */
-	struct fc_plogi_clp_s class2;		/* class 2 service parameters */
-	struct fc_plogi_clp_s class3;		/* class 3 service parameters */
-	struct fc_plogi_clp_s class4;		/* class 4 service parameters */
-	u8         vvl[16];	/* vendor version level */
+	struct fc_els_cmd_s	els_cmd;	/* ELS command code */
+	struct fc_plogi_csp_s	csp;		/* common service params */
+	wwn_t			port_name;
+	wwn_t			node_name;
+	struct fc_plogi_clp_s	class1;		/* class 1 service parameters */
+	struct fc_plogi_clp_s	class2;		/* class 2 service parameters */
+	struct fc_plogi_clp_s	class3;		/* class 3 service parameters */
+	struct fc_plogi_clp_s	class4;		/* class 4 service parameters */
+	u8			vvl[16];	/* vendor version level */
 };
 
 /*
  * LOGO els command payload
  */
 struct fc_logo_s {
-	struct fc_els_cmd_s els_cmd;	/* ELS command code */
-	u32        res1:8;
-	u32        nport_id:24;	/* N_Port identifier of source */
+	struct fc_els_cmd_s	els_cmd;	/* ELS command code */
+	u32			res1:8;
+	u32		nport_id:24;	/* N_Port identifier of source */
 	wwn_t           orig_port_name;	/* Port name of the LOGO originator */
 };
 
@@ -434,12 +390,12 @@ struct fc_logo_s {
  */
 struct fc_adisc_s {
 	struct fc_els_cmd_s els_cmd;	/* ELS command code */
-	u32        res1:8;
-	u32        orig_HA:24;	/* originator hard address */
-	wwn_t           orig_port_name;	/* originator port name */
-	wwn_t           orig_node_name;	/* originator node name */
-	u32        res2:8;
-	u32        nport_id:24;	/* originator NPortID */
+	u32		res1:8;
+	u32		orig_HA:24;	/* originator hard address */
+	wwn_t		orig_port_name;	/* originator port name */
+	wwn_t		orig_node_name;	/* originator node name */
+	u32		res2:8;
+	u32		nport_id:24;	/* originator NPortID */
 };
 
 /*
@@ -465,7 +421,7 @@ struct fc_exch_status_blk_s {
 struct fc_res_s {
 	struct fc_els_cmd_s els_cmd;	/* ELS command code */
 	u32        res1:8;
-	u32        nport_id:24;	/* N_Port identifier of source */
+	u32        nport_id:24;		/* N_Port identifier of source */
 	u32        oxid:16;
 	u32        rxid:16;
 	u8         assoc_hdr[32];
@@ -511,8 +467,8 @@ struct fc_rec_acc_s {
 	u32        orig_id:24;	/* N_Port id of exchange originator */
 	u32        res2:8;
 	u32        resp_id:24;	/* N_Port id of exchange responder */
-	u32        count;		/* data transfer count */
-	u32        e_stat;		/* exchange status */
+	u32        count;	/* data transfer count */
+	u32        e_stat;	/* exchange status */
 };
 
 /*
@@ -611,17 +567,13 @@ struct fc_prlo_params_page_s {
 	u32        type:8;
 	u32        type_ext:8;
 #ifdef __BIG_ENDIAN
-	u32        opa_valid:1;	/* originator process associator
-					 * valid
-					 */
+	u32        opa_valid:1;	/* originator process associator valid */
 	u32        rpa_valid:1;	/* responder process associator valid */
 	u32        res1:14;
 #else
 	u32        res1:14;
 	u32        rpa_valid:1;	/* responder process associator valid */
-	u32        opa_valid:1;	/* originator process associator
-					 * valid
-					 */
+	u32        opa_valid:1;	/* originator process associator valid */
 #endif
 	u32        orig_process_assc;
 	u32        resp_process_assc;
@@ -647,17 +599,13 @@ struct fc_prlo_acc_params_page_s {
 	u32        type_ext:8;
 
 #ifdef __BIG_ENDIAN
-	u32        opa_valid:1;	/* originator process associator
-					 * valid
-					 */
+	u32        opa_valid:1;	/* originator process associator valid */
 	u32        rpa_valid:1;	/* responder process associator valid */
 	u32        res1:14;
 #else
 	u32        res1:14;
 	u32        rpa_valid:1;	/* responder process associator valid */
-	u32        opa_valid:1;	/* originator process associator
-					 * valid
-					 */
+	u32        opa_valid:1;	/* originator process associator valid */
 #endif
 	u32        orig_process_assc;
 	u32        resp_process_assc;
@@ -714,9 +662,9 @@ enum {
  * LS_RJT els reply payload
  */
 struct fc_ls_rjt_s {
-	struct fc_els_cmd_s els_cmd;		/* ELS command code */
+	struct fc_els_cmd_s els_cmd;	/* ELS command code */
 	u32        res1:8;
-	u32        reason_code:8;		/* Reason code for reject */
+	u32        reason_code:8;	/* Reason code for reject */
 	u32        reason_code_expl:8;	/* Reason code explanation */
 	u32        vendor_unique:8;	/* Vendor specific */
 };
@@ -778,12 +726,12 @@ struct fc_rrq_s {
  */
 struct fc_ba_acc_s {
 	u32        seq_id_valid:8;	/* set to 0x00 for Abort Exchange */
-	u32        seq_id:8;	/* invalid for Abort Exchange */
+	u32        seq_id:8;		/* invalid for Abort Exchange */
 	u32        res2:16;
-	u32        ox_id:16;	/* OX_ID from ABTS frame */
-	u32        rx_id:16;	/* RX_ID from ABTS frame */
+	u32        ox_id:16;		/* OX_ID from ABTS frame */
+	u32        rx_id:16;		/* RX_ID from ABTS frame */
 	u32        low_seq_cnt:16;	/* set to 0x0000 for Abort Exchange */
-	u32        high_seq_cnt:16;/* set to 0xFFFF for Abort Exchange */
+	u32        high_seq_cnt:16;	/* set to 0xFFFF for Abort Exchange */
 };
 
 /*
@@ -793,15 +741,15 @@ struct fc_ba_rjt_s {
 	u32        res1:8;		/* Reserved */
 	u32        reason_code:8;	/* reason code for reject */
 	u32        reason_expl:8;	/* reason code explanation */
-	u32        vendor_unique:8;/* vendor unique reason code,set to 0 */
+	u32        vendor_unique:8; /* vendor unique reason code,set to 0 */
 };
 
 /*
  * TPRLO logout parameter page
  */
 struct fc_tprlo_params_page_s {
-u32        type:8;
-u32        type_ext:8;
+	u32        type:8;
+	u32        type_ext:8;
 
 #ifdef __BIG_ENDIAN
 	u32        opa_valid:1;
@@ -863,16 +811,16 @@ enum fc_rscn_format {
 };
 
 struct fc_rscn_event_s {
-	u32        format:2;
-	u32        qualifier:4;
-	u32        resvd:2;
-	u32        portid:24;
+	u32	format:2;
+	u32	qualifier:4;
+	u32	resvd:2;
+	u32	portid:24;
 };
 
 struct fc_rscn_pl_s {
-	u8         command;
-	u8         pagelen;
-	__be16        payldlen;
+	u8	command;
+	u8	pagelen;
+	__be16	payldlen;
 	struct fc_rscn_event_s event[1];
 };
 
@@ -886,7 +834,6 @@ struct fc_echo_s {
 /*
  * RNID els command
  */
-
 #define RNID_NODEID_DATA_FORMAT_COMMON			0x00
 #define RNID_NODEID_DATA_FORMAT_FCP3			0x08
 #define RNID_NODEID_DATA_FORMAT_DISCOVERY		0xDF
@@ -919,15 +866,15 @@ struct fc_rnid_cmd_s {
  */
 
 struct fc_rnid_common_id_data_s {
-	wwn_t           port_name;
+	wwn_t		port_name;
 	wwn_t           node_name;
 };
 
 struct fc_rnid_general_topology_data_s {
 	u32        vendor_unique[4];
-	__be32        asso_type;
+	__be32     asso_type;
 	u32        phy_port_num;
-	__be32        num_attached_nodes;
+	__be32     num_attached_nodes;
 	u32        node_mgmt:8;
 	u32        ip_version:8;
 	u32        udp_tcp_port_num:16;
@@ -979,59 +926,17 @@ enum fc_rpsc_op_speed {
 	RPSC_OP_SPEED_8G = 0x0800,
 	RPSC_OP_SPEED_16G = 0x0400,
 
-	RPSC_OP_SPEED_NOT_EST = 0x0001,	/*! speed not established */
+	RPSC_OP_SPEED_NOT_EST = 0x0001,	/* speed not established */
 };
 
 struct fc_rpsc_speed_info_s {
-	__be16        port_speed_cap;	/*! see enum fc_rpsc_speed_cap */
-	__be16        port_op_speed;	/*! see enum fc_rpsc_op_speed */
-};
-
-enum link_e2e_beacon_subcmd {
-	LINK_E2E_BEACON_ON = 1,
-	LINK_E2E_BEACON_OFF = 2
-};
-
-enum beacon_type {
-	BEACON_TYPE_NORMAL	= 1,	/*! Normal Beaconing. Green */
-	BEACON_TYPE_WARN	= 2,	/*! Warning Beaconing. Yellow/Amber */
-	BEACON_TYPE_CRITICAL	= 3	/*! Critical Beaconing. Red */
-};
-
-struct link_e2e_beacon_param_s {
-	u8         beacon_type;	/* Beacon Type. See enum beacon_type */
-	u8         beacon_frequency;
-					/* Beacon frequency. Number of blinks
-					 * per 10 seconds
-					 */
-	u16        beacon_duration;/* Beacon duration (in Seconds). The
-					 * command operation should be
-					 * terminated at the end of this
-					 * timeout value.
-					 *
-					 * Ignored if diag_sub_cmd is
-					 * LINK_E2E_BEACON_OFF.
-					 *
-					 * If 0, beaconing will continue till a
-					 * BEACON OFF request is received
-					 */
-};
-
-/*
- * Link E2E beacon request/good response format.
- * For LS_RJTs use struct fc_ls_rjt_s
- */
-struct link_e2e_beacon_req_s {
-	u32        ls_code;	/*! FC_ELS_E2E_LBEACON in requests *
-					 *or FC_ELS_ACC in good replies */
-	u32        ls_sub_cmd;	/*! See enum link_e2e_beacon_subcmd */
-	struct link_e2e_beacon_param_s beacon_parm;
+	__be16        port_speed_cap;	/* see enum fc_rpsc_speed_cap */
+	__be16        port_op_speed;	/* see enum fc_rpsc_op_speed */
 };
 
 /*
  * If RPSC request is sent to the Domain Controller, the request is for
- * all the ports within that domain (TODO - I don't think FOS implements
- * this...).
+ * all the ports within that domain.
  */
 struct fc_rpsc_cmd_s {
 	struct fc_els_cmd_s els_cmd;
@@ -1057,7 +962,7 @@ struct fc_rpsc2_cmd_s {
 	struct fc_els_cmd_s els_cmd;
 	__be32	token;
 	u16	resvd;
-	__be16	num_pids;	/* Number of pids in the request */
+	__be16	num_pids;		/* Number of pids in the request */
 	struct  {
 		u32	rsvd1:8;
 		u32	pid:24;		/* port identifier */
@@ -1071,16 +976,17 @@ enum fc_rpsc2_port_type {
 	RPSC2_PORT_TYPE_NPIV_PORT  = 0x5f,
 	RPSC2_PORT_TYPE_NPORT_TRUNK  = 0x6f,
 };
+
 /*
  * RPSC2 portInfo entry structure
  */
 struct fc_rpsc2_port_info_s {
-	__be32	pid;        /* PID */
+	__be32	pid;		/* PID */
 	u16	resvd1;
-	__be16	index;      /* port number / index */
+	__be16	index;		/* port number / index */
 	u8	resvd2;
-	u8	type;	/* port type N/NL/... */
-	__be16	speed;      /* port Operating Speed */
+	u8	type;		/* port type N/NL/... */
+	__be16	speed;		/* port Operating Speed */
 };
 
 /*
@@ -1089,8 +995,8 @@ struct fc_rpsc2_port_info_s {
 struct fc_rpsc2_acc_s {
 	u8        els_cmd;
 	u8        resvd;
-	__be16    num_pids;  /* Number of pids in the request */
-    struct fc_rpsc2_port_info_s port_info[1];    /* port information */
+	__be16    num_pids; /* Number of pids in the request */
+	struct fc_rpsc2_port_info_s port_info[1]; /* port information */
 };
 
 /*
@@ -1109,18 +1015,14 @@ struct fc_symname_s {
 	u8         symname[FC_SYMNAME_MAX];
 };
 
-struct fc_alpabm_s {
-	u8         alpa_bm[FC_ALPA_MAX / 8];
-};
-
 /*
  * protocol default timeout values
  */
-#define FC_ED_TOV		2
-#define FC_REC_TOV		(FC_ED_TOV + 1)
-#define FC_RA_TOV		10
-#define FC_ELS_TOV		(2 * FC_RA_TOV)
-#define FC_FCCT_TOV		(3 * FC_RA_TOV)
+#define FC_ED_TOV	2
+#define FC_REC_TOV	(FC_ED_TOV + 1)
+#define FC_RA_TOV	10
+#define FC_ELS_TOV	(2 * FC_RA_TOV)
+#define FC_FCCT_TOV	(3 * FC_RA_TOV)
 
 /*
  * virtual fabric related defines
@@ -1156,49 +1058,33 @@ enum {
 };
 
 /*
- * SRR FC-4 LS payload
- */
-struct fc_srr_s {
-	u32	ls_cmd;
-	u32        ox_id:16;	/* ox-id */
-	u32        rx_id:16;	/* rx-id */
-	u32        ro;		/* relative offset */
-	u32        r_ctl:8;		/* R_CTL for I.U. */
-	u32        res:24;
-};
-
-
-/*
  * FCP_CMND definitions
  */
 #define FCP_CMND_CDB_LEN    16
 #define FCP_CMND_LUN_LEN    8
 
 struct fcp_cmnd_s {
-	struct scsi_lun		lun;	/* 64-bit LU number */
-	u8			crn;	/* command reference number */
+	struct scsi_lun	lun;		/* 64-bit LU number */
+	u8		crn;		/* command reference number */
 #ifdef __BIG_ENDIAN
-	u8         resvd:1,
+	u8         	resvd:1,
 			priority:4,	/* FCP-3: SAM-3 priority */
 			taskattr:3;	/* scsi task attribute */
 #else
-	u8         taskattr:3,	/* scsi task attribute */
+	u8         	taskattr:3,	/* scsi task attribute */
 			priority:4,	/* FCP-3: SAM-3 priority */
 			resvd:1;
 #endif
-	u8         tm_flags;	/* task management flags */
+	u8		tm_flags;	/* task management flags */
 #ifdef __BIG_ENDIAN
-	u8         addl_cdb_len:6,	/* additional CDB length words */
+	u8		addl_cdb_len:6,	/* additional CDB length words */
 			iodir:2;	/* read/write FCP_DATA IUs */
 #else
-	u8         iodir:2,	/* read/write FCP_DATA IUs */
+	u8		iodir:2,	/* read/write FCP_DATA IUs */
 			addl_cdb_len:6;	/* additional CDB length */
 #endif
-	scsi_cdb_t      cdb;
+	struct scsi_cdb_s      cdb;
 
-	/*
-	 * !!! additional cdb bytes follows here!!!
-	 */
 	__be32        fcp_dl;	/* bytes to be transferred */
 };
 
@@ -1209,21 +1095,10 @@ struct fcp_cmnd_s {
  * struct fcp_cmnd_s .iodir field values
  */
 enum fcp_iodir {
-	FCP_IODIR_NONE	= 0,
+	FCP_IODIR_NONE  = 0,
 	FCP_IODIR_WRITE = 1,
-	FCP_IODIR_READ	= 2,
-	FCP_IODIR_RW	= 3,
-};
-
-/*
- * Task attribute field
- */
-enum {
-	FCP_TASK_ATTR_SIMPLE	= 0,
-	FCP_TASK_ATTR_HOQ	= 1,
-	FCP_TASK_ATTR_ORDERED	= 2,
-	FCP_TASK_ATTR_ACA	= 4,
-	FCP_TASK_ATTR_UNTAGGED	= 5,	/* obsolete in FCP-3 */
+	FCP_IODIR_READ  = 2,
+	FCP_IODIR_RW    = 3,
 };
 
 /*
@@ -1238,58 +1113,40 @@ enum fcp_tm_cmnd {
 };
 
 /*
- * FCP_XFER_RDY IU defines
- */
-struct fcp_xfer_rdy_s {
-	u32        data_ro;
-	u32        burst_len;
-	u32        reserved;
-};
-
-/*
  * FCP_RSP residue flags
  */
 enum fcp_residue {
-	FCP_NO_RESIDUE = 0,	/* no residue */
-	FCP_RESID_OVER = 1,	/* more data left that was not sent */
-	FCP_RESID_UNDER = 2,	/* less data than requested */
-};
-
-enum {
-	FCP_RSPINFO_GOOD = 0,
-	FCP_RSPINFO_DATALEN_MISMATCH = 1,
-	FCP_RSPINFO_CMND_INVALID = 2,
-	FCP_RSPINFO_ROLEN_MISMATCH = 3,
-	FCP_RSPINFO_TM_NOT_SUPP = 4,
-	FCP_RSPINFO_TM_FAILED = 5,
+	FCP_NO_RESIDUE = 0,     /* no residue */
+	FCP_RESID_OVER = 1,     /* more data left that was not sent */
+	FCP_RESID_UNDER = 2,    /* less data than requested */
 };
 
 struct fcp_rspinfo_s {
 	u32        res0:24;
-	u32        rsp_code:8;	/* response code (as above) */
+	u32        rsp_code:8;		/* response code (as above) */
 	u32        res1;
 };
 
 struct fcp_resp_s {
-	u32        reserved[2];	/* 2 words reserved */
+	u32        reserved[2];		/* 2 words reserved */
 	u16        reserved2;
 #ifdef __BIG_ENDIAN
 	u8         reserved3:3;
 	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
 	u8         resid_flags:2;	/* underflow/overflow */
-	u8         sns_len_valid:1;/* sense len is valid */
-	u8         rsp_len_valid:1;/* response len is valid */
+	u8         sns_len_valid:1;	/* sense len is valid */
+	u8         rsp_len_valid:1;	/* response len is valid */
 #else
-	u8         rsp_len_valid:1;/* response len is valid */
-	u8         sns_len_valid:1;/* sense len is valid */
+	u8         rsp_len_valid:1;	/* response len is valid */
+	u8         sns_len_valid:1;	/* sense len is valid */
 	u8         resid_flags:2;	/* underflow/overflow */
 	u8         fcp_conf_req:1;	/* FCP_CONF is requested */
 	u8         reserved3:3;
 #endif
-	u8         scsi_status;	/* one byte SCSI status */
-	u32        residue;	/* residual data bytes */
-	u32        sns_len;	/* length od sense info */
-	u32        rsp_len;	/* length of response info */
+	u8         scsi_status;		/* one byte SCSI status */
+	u32        residue;		/* residual data bytes */
+	u32        sns_len;		/* length od sense info */
+	u32        rsp_len;		/* length of response info */
 };
 
 #define fcp_snslen(__fcprsp)	((__fcprsp)->sns_len_valid ?		\
@@ -1299,12 +1156,6 @@ struct fcp_resp_s {
 #define fcp_rspinfo(__fcprsp)	((struct fcp_rspinfo_s *)((__fcprsp) + 1))
 #define fcp_snsinfo(__fcprsp)	(((u8 *)fcp_rspinfo(__fcprsp)) +	\
 						fcp_rsplen(__fcprsp))
-
-struct fcp_cmnd_fr_s {
-	struct fchs_s fchs;
-	struct fcp_cmnd_s fcp;
-};
-
 /*
  * CT
  */
@@ -1378,7 +1229,7 @@ enum {
 	CT_RSN_LOGICAL_BUSY	= 0x05,
 	CT_RSN_PROTO_ERR	= 0x07,
 	CT_RSN_UNABLE_TO_PERF	= 0x09,
-	CT_RSN_NOT_SUPP			= 0x0B,
+	CT_RSN_NOT_SUPP		= 0x0B,
 	CT_RSN_SERVER_NOT_AVBL  = 0x0D,
 	CT_RSN_SESSION_COULD_NOT_BE_ESTBD = 0x0E,
 	CT_RSN_VENDOR_SPECIFIC  = 0xFF,
@@ -1418,10 +1269,10 @@ enum {
  * defintions for the explanation code for all servers
  */
 enum {
-	CT_EXP_AUTH_EXCEPTION			= 0xF1,
-	CT_EXP_DB_FULL					= 0xF2,
-	CT_EXP_DB_EMPTY					= 0xF3,
-	CT_EXP_PROCESSING_REQ			= 0xF4,
+	CT_EXP_AUTH_EXCEPTION		= 0xF1,
+	CT_EXP_DB_FULL			= 0xF2,
+	CT_EXP_DB_EMPTY			= 0xF3,
+	CT_EXP_PROCESSING_REQ		= 0xF4,
 	CT_EXP_UNABLE_TO_VERIFY_CONN	= 0xF5,
 	CT_EXP_DEVICES_NOT_IN_CMN_ZONE  = 0xF6
 };
@@ -1445,7 +1296,7 @@ enum {
 	GS_RFF_ID	= 0x021F,	/* Register FC4 Feature		*/
 };
 
-struct fcgs_id_req_s{
+struct fcgs_id_req_s {
 	u32 rsvd:8;
 	u32 dap:24; /* port identifier */
 };
@@ -1459,7 +1310,7 @@ struct fcgs_gidpn_req_s {
 
 struct fcgs_gidpn_resp_s {
 	u32	rsvd:8;
-	u32	dap:24;	/* port identifier */
+	u32	dap:24;		/* port identifier */
 };
 
 /*
@@ -1474,15 +1325,14 @@ struct fcgs_rftid_req_s {
 /*
  * RFF_ID : Register FC4 features.
  */
-
 #define FC_GS_FCP_FC4_FEATURE_INITIATOR  0x02
 #define FC_GS_FCP_FC4_FEATURE_TARGET	 0x01
 
 struct fcgs_rffid_req_s {
     u32    rsvd:8;
-    u32    dap:24;		/* port identifier	*/
+    u32    dap:24;		/* port identifier */
     u32    rsvd1:16;
-    u32    fc4ftr_bits:8;		/* fc4 feature bits	*/
+    u32    fc4ftr_bits:8;	/* fc4 feature bits */
     u32    fc4_type:8;		/* corresponding FC4 Type */
 };
 
@@ -1494,16 +1344,16 @@ struct fcgs_gidft_req_s {
 	u8	domain_id;	/* domain, 0 - all fabric */
 	u8	area_id;	/* area, 0 - whole domain */
 	u8	fc4_type;	/* FC_TYPE_FCP for SCSI devices */
-};		/* GID_FT Request */
+};
 
 /*
  * GID_FT Response
  */
 struct fcgs_gidft_resp_s {
-	u8		last:1;	/* last port identifier flag */
-	u8		reserved:7;
-	u32	pid:24;	/* port identifier */
-};		/* GID_FT Response */
+	u8	last:1;		/* last port identifier flag */
+	u8	reserved:7;
+	u32	pid:24;		/* port identifier */
+};
 
 /*
  * RSPN_ID
@@ -1511,8 +1361,8 @@ struct fcgs_gidft_resp_s {
 struct fcgs_rspnid_req_s {
 	u32	rsvd:8;
 	u32	dap:24;		/* port identifier */
-	u8		spn_len;	/* symbolic port name length */
-	u8		spn[256];	/* symbolic port name */
+	u8	spn_len;	/* symbolic port name length */
+	u8	spn[256];	/* symbolic port name */
 };
 
 /*
@@ -1521,7 +1371,7 @@ struct fcgs_rspnid_req_s {
 struct fcgs_rpnid_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
-	wwn_t		port_name;
+	wwn_t	port_name;
 };
 
 /*
@@ -1530,7 +1380,7 @@ struct fcgs_rpnid_req_s {
 struct fcgs_rnnid_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
-	wwn_t		node_name;
+	wwn_t	node_name;
 };
 
 /*
@@ -1564,8 +1414,8 @@ struct fcgs_ganxt_req_s {
  * GA_NXT Response
  */
 struct fcgs_ganxt_rsp_s {
-	u32	port_type:8;	/* Port Type */
-	u32	port_id:24;	/* Port Identifier */
+	u32		port_type:8;	/* Port Type */
+	u32		port_id:24;	/* Port Identifier */
 	wwn_t		port_name;	/* Port Name */
 	u8		spn_len;	/* Length of Symbolic Port Name */
 	char		spn[255];	/* Symbolic Port Name */
@@ -1574,19 +1424,14 @@ struct fcgs_ganxt_rsp_s {
 	char		snn[255];	/* Symbolic Node Name */
 	u8		ipa[8];		/* Initial Process Associator */
 	u8		ip[16];		/* IP Address */
-	u32	cos;		/* Class of Service */
-	u32	fc4types[8];	/* FC-4 TYPEs */
-	wwn_t		fabric_port_name;
-					/* Fabric Port Name */
-	u32	rsvd:8;		/* Reserved */
-	u32	hard_addr:24;	/* Hard Address */
+	u32		cos;		/* Class of Service */
+	u32		fc4types[8];	/* FC-4 TYPEs */
+	wwn_t		fabric_port_name; /* Fabric Port Name */
+	u32		rsvd:8;		/* Reserved */
+	u32		hard_addr:24;	/* Hard Address */
 };
 
 /*
- * Fabric Config Server
- */
-
-/*
  * Command codes for Fabric Configuration Server
  */
 enum {
@@ -1597,159 +1442,9 @@ enum {
 };
 
 /*
- * Source or Destination Port Tags.
- */
-enum {
-	GS_FTRACE_TAG_NPORT_ID		= 1,
-	GS_FTRACE_TAG_NPORT_NAME	= 2,
-};
-
-/*
-* Port Value : Could be a Port id or wwn
- */
-union fcgs_port_val_u {
-	u32	nport_id;
-	wwn_t		nport_wwn;
-};
-
-#define GS_FTRACE_MAX_HOP_COUNT	20
-#define GS_FTRACE_REVISION	1
-
-/*
- * Ftrace Related Structures.
- */
-
-/*
- * STR (Switch Trace) Reject Reason Codes. From FC-SW.
- */
-enum {
-	GS_FTRACE_STR_CMD_COMPLETED_SUCC	= 0,
-	GS_FTRACE_STR_CMD_NOT_SUPP_IN_NEXT_SWITCH,
-	GS_FTRACE_STR_NO_RESP_FROM_NEXT_SWITCH,
-	GS_FTRACE_STR_MAX_HOP_CNT_REACHED,
-	GS_FTRACE_STR_SRC_PORT_NOT_FOUND,
-	GS_FTRACE_STR_DST_PORT_NOT_FOUND,
-	GS_FTRACE_STR_DEVICES_NOT_IN_COMMON_ZONE,
-	GS_FTRACE_STR_NO_ROUTE_BW_PORTS,
-	GS_FTRACE_STR_NO_ADDL_EXPLN,
-	GS_FTRACE_STR_FABRIC_BUSY,
-	GS_FTRACE_STR_FABRIC_BUILD_IN_PROGRESS,
-	GS_FTRACE_STR_VENDOR_SPECIFIC_ERR_START = 0xf0,
-	GS_FTRACE_STR_VENDOR_SPECIFIC_ERR_END = 0xff,
-};
-
-/*
- * Ftrace Request
- */
-struct fcgs_ftrace_req_s {
-	u32	revision;
-	u16	src_port_tag;	/* Source Port tag */
-	u16	src_port_len;	/* Source Port len */
-	union fcgs_port_val_u src_port_val;	/* Source Port value */
-	u16	dst_port_tag;	/* Destination Port tag */
-	u16	dst_port_len;	/* Destination Port len */
-	union fcgs_port_val_u dst_port_val;	/* Destination Port value */
-	u32	token;
-	u8		vendor_id[8];	/* T10 Vendor Identifier */
-	u8		vendor_info[8];	/* Vendor specific Info */
-	u32	max_hop_cnt;	/* Max Hop Count */
-};
-
-/*
- * Path info structure
- */
-struct fcgs_ftrace_path_info_s {
-	wwn_t		switch_name;		/* Switch WWN */
-	u32	domain_id;
-	wwn_t		ingress_port_name;	/* Ingress ports wwn */
-	u32	ingress_phys_port_num;	/* Ingress ports physical port
-						 * number
-						 */
-	wwn_t		egress_port_name;	/* Ingress ports wwn */
-	u32	egress_phys_port_num;	/* Ingress ports physical port
-						 * number
-						 */
-};
-
-/*
- * Ftrace Acc Response
- */
-struct fcgs_ftrace_resp_s {
-	u32	revision;
-	u32	token;
-	u8		vendor_id[8];		/* T10 Vendor Identifier */
-	u8		vendor_info[8];		/* Vendor specific Info */
-	u32	str_rej_reason_code;	/* STR Reject Reason Code */
-	u32	num_path_info_entries;	/* No. of path info entries */
-	/*
-	 * path info entry/entries.
-	 */
-	struct fcgs_ftrace_path_info_s path_info[1];
-
-};
-
-/*
-* Fabric Config Server : FCPing
- */
-
-/*
- * FC Ping Request
- */
-struct fcgs_fcping_req_s {
-	u32	revision;
-	u16	port_tag;
-	u16	port_len;	/* Port len */
-	union fcgs_port_val_u port_val;	/* Port value */
-	u32	token;
-};
-
-/*
- * FC Ping Response
- */
-struct fcgs_fcping_resp_s {
-	u32	token;
-};
-
-/*
- * Command codes for zone server query.
- */
-enum {
-	ZS_GZME = 0x0124,	/* Get zone member extended */
-};
-
-/*
- * ZS GZME request
- */
-#define ZS_GZME_ZNAMELEN	32
-struct zs_gzme_req_s {
-	u8	znamelen;
-	u8	rsvd[3];
-	u8	zname[ZS_GZME_ZNAMELEN];
-};
-
-enum zs_mbr_type {
-	ZS_MBR_TYPE_PWWN	= 1,
-	ZS_MBR_TYPE_DOMPORT	= 2,
-	ZS_MBR_TYPE_PORTID	= 3,
-	ZS_MBR_TYPE_NWWN	= 4,
-};
-
-struct zs_mbr_wwn_s {
-	u8	mbr_type;
-	u8	rsvd[3];
-	wwn_t	wwn;
-};
-
-struct zs_query_resp_s {
-	u32	nmbrs;	/*  number of zone members */
-	struct zs_mbr_wwn_s	mbr[1];
-};
-
-/*
  * GMAL Command ( Get ( interconnect Element) Management Address List)
  * To retrieve the IP Address of a Switch.
  */
-
 #define CT_GMAL_RESP_PREFIX_TELNET	 "telnet://"
 #define CT_GMAL_RESP_PREFIX_HTTP	 "http://"
 
@@ -1774,9 +1469,6 @@ struct fcgs_gmal_entry_s {
 };
 
 /*
- * FDMI
- */
-/*
  * FDMI Command Codes
  */
 #define	FDMI_GRHL		0x0100
@@ -1872,8 +1564,8 @@ struct fdmi_hba_attr_s {
  * Registered Port List
  */
 struct fdmi_port_list_s {
-	__be32        num_ports;	/* number Of Port Entries */
-	wwn_t           port_entry;	/* one or more */
+	__be32		num_ports;	/* number Of Port Entries */
+	wwn_t		port_entry;	/* one or more */
 };
 
 /*
@@ -1888,7 +1580,7 @@ struct fdmi_port_attr_s {
  * FDMI Register HBA Attributes
  */
 struct fdmi_rhba_s {
-	wwn_t           hba_id;		/* HBA Identifier */
+	wwn_t			hba_id;		/* HBA Identifier */
 	struct fdmi_port_list_s port_list;	/* Registered Port List */
 	struct fdmi_hba_attr_s hba_attr_blk;	/* HBA attribute block */
 };
@@ -1897,8 +1589,8 @@ struct fdmi_rhba_s {
  * FDMI Register Port
  */
 struct fdmi_rprt_s {
-	wwn_t           hba_id;		/* HBA Identifier */
-	wwn_t           port_name;	/* Port wwn */
+	wwn_t			hba_id;		/* HBA Identifier */
+	wwn_t			port_name;	/* Port wwn */
 	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
 };
 
@@ -1906,7 +1598,7 @@ struct fdmi_rprt_s {
  * FDMI Register Port Attributes
  */
 struct fdmi_rpa_s {
-	wwn_t           port_name;	/* port wwn */
+	wwn_t			port_name;	/* port wwn */
 	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
 };
 
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index a4989a0..9c410b2 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2180,7 +2180,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	else
 		m->cmnd.iodir = FCP_IODIR_NONE;
 
-	m->cmnd.cdb = *(scsi_cdb_t *) cmnd->cmnd;
+	m->cmnd.cdb = *(struct scsi_cdb_s *) cmnd->cmnd;
 	fcp_dl = scsi_bufflen(cmnd);
 	m->cmnd.fcp_dl = cpu_to_be32(fcp_dl);
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 431cf72..c1f72c4 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -957,7 +957,7 @@ bfa_iocpf_sm_disabling_sync_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
 
-/**
+/*
  * IOC hb ack request is being removed.
  */
 static void
@@ -1020,8 +1020,7 @@ bfa_iocpf_sm_initfail_sync_entry(struct bfa_iocpf_s *iocpf)
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
 
-/**
- * @brief
+/*
  * Hardware initialization failed.
  */
 static void
@@ -1103,12 +1102,12 @@ bfa_iocpf_sm_initfail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_fail_sync_entry(struct bfa_iocpf_s *iocpf)
 {
-	/**
+	/*
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
 	bfa_ioc_lpu_stop(iocpf->ioc);
 
-	/**
+	/*
 	 * Flush any queued up mailbox requests.
 	 */
 	bfa_ioc_mbox_hbfail(iocpf->ioc);
@@ -1366,12 +1365,6 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc, u32 boot_env)
 {
 	struct bfi_ioc_image_hdr_s fwhdr, *drv_fwhdr;
 
-	/*
-	 * If bios/efi boot (flash based) -- return true
-	 */
-	if (bfa_ioc_is_bios_optrom(ioc))
-		return BFA_TRUE;
-
 	bfa_ioc_fwver_get(ioc, &fwhdr);
 	drv_fwhdr = (struct bfi_ioc_image_hdr_s *)
 		bfa_cb_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
@@ -1423,22 +1416,6 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	boot_env = BFI_BOOT_LOADER_OS;
 
 	/*
-	 * Flash based firmware boot BIOS env.
-	 */
-	if (bfa_ioc_is_bios_optrom(ioc)) {
-		boot_type = BFI_BOOT_TYPE_FLASH;
-		boot_env = BFI_BOOT_LOADER_BIOS;
-	}
-
-	/*
-	 * Flash based firmware boot UEFI env.
-	 */
-	if (bfa_ioc_is_uefi(ioc)) {
-		boot_type = BFI_BOOT_TYPE_FLASH;
-		boot_env = BFI_BOOT_LOADER_UEFI;
-	}
-
-	/*
 	 * check if firmware is valid
 	 */
 	fwvalid = (ioc_fwstate == BFI_IOC_UNINIT) ?
@@ -1466,8 +1443,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	 * convergence, IOC will be in operational state when 2nd driver
 	 * is loaded.
 	 */
-	if (ioc_fwstate == BFI_IOC_DISABLED ||
-	    (!bfa_ioc_is_bios_optrom(ioc) && ioc_fwstate == BFI_IOC_OP)) {
+	if (ioc_fwstate == BFI_IOC_DISABLED || ioc_fwstate == BFI_IOC_OP) {
 
 		/*
 		 * When using MSI-X any pending firmware ready event should
@@ -1842,7 +1818,7 @@ bfa_ioc_fail_notify(struct bfa_ioc_s *ioc)
 	struct bfa_ioc_hbfail_notify_s	*notify;
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
 
-	/**
+	/*
 	 * Notify driver and common modules registered for notification.
 	 */
 	ioc->cbfn->hbfail_cbfn(ioc->bfa);
@@ -2279,7 +2255,7 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 	return BFA_TRUE;
 }
 
-/**
+/*
  * Reset IOC fwstate registers.
  */
 void
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 5d2f342..ec9cf08 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -296,15 +296,6 @@ struct bfa_ioc_hwif_s {
 #define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)	(off % BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_IOC_FLASH_CHUNK_ADDR(chunkno)  (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
 
-#ifdef BFA_IOC_IS_UEFI
-#define bfa_ioc_is_bios_optrom(__ioc) (0)
-#define bfa_ioc_is_uefi(__ioc) BFA_IOC_IS_UEFI
-#else
-#define bfa_ioc_is_bios_optrom(__ioc)   \
-	(bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(__ioc)) < BFA_IOC_FWIMG_MINSZ)
-#define bfa_ioc_is_uefi(__ioc) (0)
-#endif
-
 /*
  * IOC mailbox interface
  */
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 788ecca..e4a0713 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -61,7 +61,7 @@ bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
 	ioc->ioc_hwif = &hwif_cb;
 }
 
-/**
+/*
  * Return true if firmware of current driver matches the running firmware.
  */
 static bfa_boolean_t
@@ -70,8 +70,7 @@ bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc)
 	struct bfi_ioc_image_hdr_s fwhdr;
 	uint32_t fwstate = readl(ioc->ioc_regs.ioc_fwstate);
 
-	if ((fwstate == BFI_IOC_UNINIT) || bfa_ioc_is_uefi(ioc) ||
-				bfa_ioc_is_bios_optrom(ioc))
+	if (fwstate == BFI_IOC_UNINIT)
 		return BFA_TRUE;
 
 	bfa_ioc_fwver_get(ioc, &fwhdr);
@@ -211,7 +210,7 @@ bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
 	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
-/**
+/*
  * Synchronized IOC failure processing routines
  */
 static void
@@ -236,7 +235,7 @@ bfa_ioc_cb_sync_complete(struct bfa_ioc_s *ioc)
 	uint32_t fwstate, alt_fwstate;
 	fwstate = readl(ioc->ioc_regs.ioc_fwstate);
 
-	/**
+	/*
 	 * At this point, this IOC is hoding the hw sem in the
 	 * start path (fwcheck) OR in the disable/enable path
 	 * OR to check if the other IOC has acknowledged failure.
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index ccfecfc..008d129 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -351,7 +351,7 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
-/**
+/*
  * Synchronized IOC failure processing routines
  */
 static void
@@ -393,7 +393,7 @@ bfa_ioc_ct_sync_complete(struct bfa_ioc_s *ioc)
 	if (sync_ackd == 0)
 		return BFA_TRUE;
 
-	/**
+	/*
 	 * The check below is to see whether any other PCI fn
 	 * has reinitialized the ASIC (reset sync_ackd bits)
 	 * and failed again while this IOC was waiting for hw
@@ -412,7 +412,7 @@ bfa_ioc_ct_sync_complete(struct bfa_ioc_s *ioc)
 		return BFA_TRUE;
 	}
 
-	/**
+	/*
 	 * If another PCI fn reinitialized and failed again while
 	 * this IOC was waiting for hw sem, the sync_ackd bit for
 	 * this IOC need to be set again to allow reinitialization.
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 6577d0d..1d34921 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -1372,7 +1372,7 @@ bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
 	}
 }
 
-/**
+/*
  * login complete
  */
 static void
@@ -1691,7 +1691,7 @@ bfa_lps_send_logout(struct bfa_lps_s *lps)
 	bfa_reqq_produce(lps->bfa, lps->reqq);
 }
 
-/**
+/*
  * send n2n pid set request to firmware
  */
 static void
@@ -1930,7 +1930,7 @@ bfa_lps_get_base_pid(struct bfa_s *bfa)
 	return BFA_LPS_FROM_TAG(mod, 0)->lp_pid;
 }
 
-/**
+/*
  * Set PID in case of n2n (which is assigned during PLOGI)
  */
 void
-- 
1.6.5.2

