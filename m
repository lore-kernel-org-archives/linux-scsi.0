From: Maggie <xmzhang@brocade.com>
Subject: [PATCH 2/2] bfa: fix endianess sparse check warnings
Date: Mon, 29 Nov 2010 18:26:32 -0800
Message-ID: <1291083992-26517-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44042 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab0K3C0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2010 21:26:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie <xmzhang@brocade.com>

First round of fix for the endianess check warnings from make C=2 CF="-D__CHECK_ENDIAN__". 

Signed-off-by: Maggie <xmzhang@brocade.com>
---
 drivers/scsi/bfa/bfa_cb_ioim.h   |    2 +-
 drivers/scsi/bfa/bfa_defs_svc.h  |    8 +-
 drivers/scsi/bfa/bfa_fc.h        |   50 ++++----
 drivers/scsi/bfa/bfa_fcbuild.c   |   44 ++++----
 drivers/scsi/bfa/bfa_fcbuild.h   |   28 +++---
 drivers/scsi/bfa/bfa_fcs.h       |   14 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |  226 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |    2 +-
 drivers/scsi/bfa/bfa_ioc.c       |    5 +-
 drivers/scsi/bfa/bfa_ioc.h       |    8 +-
 drivers/scsi/bfa/bfa_port.c      |    2 +-
 drivers/scsi/bfa/bfa_svc.c       |    4 +-
 drivers/scsi/bfa/bfi.h           |    4 +-
 drivers/scsi/bfa/bfi_ms.h        |   50 ++++----
 14 files changed, 225 insertions(+), 222 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_cb_ioim.h b/drivers/scsi/bfa/bfa_cb_ioim.h
index 6f02101..afb5738 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim.h
@@ -32,7 +32,7 @@ static inline lun_t
 bfad_int_to_lun(u32 luno)
 {
 	union {
-		u16	scsi_lun[4];
+		__be16	scsi_lun[4];
 		lun_t		bfa_lun;
 	} lun;
 
diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index e24e9f7..648c841 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -34,8 +34,8 @@
 struct bfa_iocfc_intr_attr_s {
 	u8		coalesce;	/*  enable/disable coalescing */
 	u8		rsvd[3];
-	u16	latency;	/*  latency in microseconds   */
-	u16	delay;		/*  delay in microseconds     */
+	__be16	latency;	/*  latency in microseconds   */
+	__be16	delay;		/*  delay in microseconds     */
 };
 
 /*
@@ -743,7 +743,7 @@ struct bfa_port_cfg_s {
 	u8	 qos_enabled;	/*  qos enabled or not		*/
 	u8	 cfg_hardalpa;	/*  is hard alpa configured	*/
 	u8	 hardalpa;	/*  configured hard alpa	*/
-	u16 maxfrsize;	/*  maximum frame size		*/
+	__be16	 maxfrsize;	/*  maximum frame size		*/
 	u8	 rx_bbcredit;	/*  receive buffer credits	*/
 	u8	 tx_bbcredit;	/*  transmit buffer credits	*/
 	u8	 ratelimit;	/*  ratelimit enabled or not	*/
@@ -843,7 +843,7 @@ struct bfa_fcport_fcf_s {
 	u8	 fka_disabled;   /*  FKA is disabled	  */
 	u8	 maxsz_verified; /*  FCoE max size verified   */
 	u8	 fc_map[3];      /*  FC map		   */
-	u16	vlan;	   /*  FCoE vlan tag/priority   */
+	__be16	 vlan;	   /*  FCoE vlan tag/priority   */
 	u32	fka_adv_per;    /*  FIP  ka advert. period   */
 	mac_t	   mac;	    /*  FCF mac		  */
 };
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index e929d25..7dd0caf 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -82,7 +82,7 @@ struct fchs_s {
 	u8         df_ctl;		/* data field control */
 	u16        seq_cnt;	/* sequence count */
 
-	u16        ox_id;		/* originator exchange ID */
+	__be16     ox_id;		/* originator exchange ID */
 	u16        rx_id;		/* responder exchange ID */
 
 	u32        ro;		/* relative offset */
@@ -316,7 +316,7 @@ enum {
 struct fc_plogi_csp_s {
 	u8         verhi;	/* FC-PH high version */
 	u8         verlo;	/* FC-PH low version */
-	u16        bbcred;	/* BB_Credit */
+	__be16        bbcred;	/* BB_Credit */
 
 #ifdef __BIGENDIAN
 	u8         ciro:1,		/* continuously increasing RO */
@@ -355,12 +355,12 @@ struct fc_plogi_csp_s {
 			hg_supp:1;
 #endif
 
-	u16        rxsz;		/* recieve data_field size */
+	__be16        rxsz;		/* recieve data_field size */
 
-	u16        conseq;
-	u16        ro_bitmap;
+	__be16        conseq;
+	__be16        ro_bitmap;
 
-	u32        e_d_tov;
+	__be32        e_d_tov;
 };
 
 /*
@@ -873,7 +873,7 @@ struct fc_rscn_event_s {
 struct fc_rscn_pl_s {
 	u8         command;
 	u8         pagelen;
-	u16        payldlen;
+	__be16        payldlen;
 	struct fc_rscn_event_s event[1];
 };
 
@@ -926,9 +926,9 @@ struct fc_rnid_common_id_data_s {
 
 struct fc_rnid_general_topology_data_s {
 	u32        vendor_unique[4];
-	u32        asso_type;
+	__be32        asso_type;
 	u32        phy_port_num;
-	u32        num_attached_nodes;
+	__be32        num_attached_nodes;
 	u32        node_mgmt:8;
 	u32        ip_version:8;
 	u32        udp_tcp_port_num:16;
@@ -984,8 +984,8 @@ enum fc_rpsc_op_speed {
 };
 
 struct fc_rpsc_speed_info_s {
-	u16        port_speed_cap;	/*! see enum fc_rpsc_speed_cap */
-	u16        port_op_speed;	/*! see enum fc_rpsc_op_speed */
+	__be16        port_speed_cap;	/*! see enum fc_rpsc_speed_cap */
+	__be16        port_op_speed;	/*! see enum fc_rpsc_op_speed */
 };
 
 enum link_e2e_beacon_subcmd {
@@ -1056,9 +1056,9 @@ struct fc_rpsc_acc_s {
 
 struct fc_rpsc2_cmd_s {
 	struct fc_els_cmd_s els_cmd;
-	u32	token;
+	__be32	token;
 	u16	resvd;
-	u16	num_pids;	/* Number of pids in the request */
+	__be16	num_pids;	/* Number of pids in the request */
 	struct  {
 		u32	rsvd1:8;
 		u32	pid:24;		/* port identifier */
@@ -1076,12 +1076,12 @@ enum fc_rpsc2_port_type {
  * RPSC2 portInfo entry structure
  */
 struct fc_rpsc2_port_info_s {
-    u32    pid;        /* PID */
+    __be32    pid;        /* PID */
     u16    resvd1;
-    u16    index;      /* port number / index */
+    __be16    index;      /* port number / index */
     u8     resvd2;
     u8	   type;	/* port type N/NL/... */
-    u16    speed;      /* port Operating Speed */
+    __be16    speed;      /* port Operating Speed */
 };
 
 /*
@@ -1090,7 +1090,7 @@ struct fc_rpsc2_port_info_s {
 struct fc_rpsc2_acc_s {
 	u8        els_cmd;
 	u8        resvd;
-    u16       num_pids;  /* Number of pids in the request */
+    	__be16    num_pids;  /* Number of pids in the request */
     struct fc_rpsc2_port_info_s port_info[1];    /* port information */
 };
 
@@ -1200,7 +1200,7 @@ struct fcp_cmnd_s {
 	/*
 	 * !!! additional cdb bytes follows here!!!
 	 */
-	u32        fcp_dl;	/* bytes to be transferred */
+	__be32        fcp_dl;	/* bytes to be transferred */
 };
 
 #define fcp_cmnd_cdb_len(_cmnd) ((_cmnd)->addl_cdb_len * 4 + FCP_CMND_CDB_LEN)
@@ -1469,7 +1469,7 @@ struct fcgs_gidpn_resp_s {
 struct fcgs_rftid_req_s {
 	u32	rsvd:8;
 	u32	dap:24;		/* port identifier */
-	u32	fc4_type[8];	/* fc4 types */
+	__be32	fc4_type[8];	/* fc4 types */
 };
 
 /*
@@ -1764,7 +1764,7 @@ struct fcgs_req_s {
 
 /* Accept Response to GMAL */
 struct fcgs_gmal_resp_s {
-	u32	ms_len;   /* Num of entries */
+	__be32	ms_len;   /* Num of entries */
 	u8	ms_ma[256];
 };
 
@@ -1856,8 +1856,8 @@ enum fdmi_port_attribute_type {
  * FDMI attribute
  */
 struct fdmi_attr_s {
-	u16        type;
-	u16        len;
+	__be16        type;
+	__be16        len;
 	u8         value[1];
 };
 
@@ -1865,7 +1865,7 @@ struct fdmi_attr_s {
  * HBA Attribute Block
  */
 struct fdmi_hba_attr_s {
-	u32        attr_count;	/* # of attributes */
+	__be32        attr_count;	/* # of attributes */
 	struct fdmi_attr_s hba_attr;	/* n attributes */
 };
 
@@ -1873,7 +1873,7 @@ struct fdmi_hba_attr_s {
  * Registered Port List
  */
 struct fdmi_port_list_s {
-	u32        num_ports;	/* number Of Port Entries */
+	__be32        num_ports;	/* number Of Port Entries */
 	wwn_t           port_entry;	/* one or more */
 };
 
@@ -1881,7 +1881,7 @@ struct fdmi_port_list_s {
  * Port Attribute Block
  */
 struct fdmi_port_attr_s {
-	u32        attr_count;	/* # of attributes */
+	__be32        attr_count;	/* # of attributes */
 	struct fdmi_attr_s port_attr;	/* n attributes */
 };
 
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 9c72531..322b11e 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -25,9 +25,9 @@
  * static build functions
  */
 static void     fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-				 u16 ox_id);
+				 __be16 ox_id);
 static void     fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-				 u16 ox_id);
+				 __be16 ox_id);
 static struct fchs_s fc_els_req_tmpl;
 static struct fchs_s fc_els_rsp_tmpl;
 static struct fchs_s fc_bls_req_tmpl;
@@ -157,7 +157,7 @@ fc_gs_fchdr_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u32 ox_id)
 }
 
 void
-fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
+fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id)
 {
 	memcpy(fchs, &fc_els_req_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = (d_id);
@@ -166,7 +166,7 @@ fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 }
 
 static void
-fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
+fc_els_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id)
 {
 	memcpy(fchs, &fc_els_rsp_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = d_id;
@@ -196,7 +196,7 @@ fc_els_rsp_parse(struct fchs_s *fchs, int len)
 }
 
 static void
-fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
+fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id)
 {
 	memcpy(fchs, &fc_bls_rsp_tmpl, sizeof(struct fchs_s));
 	fchs->d_id = d_id;
@@ -206,7 +206,7 @@ fc_bls_rsp_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id)
 
 static          u16
 fc_plogi_x_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
-		 u16 ox_id, wwn_t port_name, wwn_t node_name,
+		 __be16 ox_id, wwn_t port_name, wwn_t node_name,
 		 u16 pdu_size, u8 els_code)
 {
 	struct fc_logi_s *plogi = (struct fc_logi_s *) (pld);
@@ -233,7 +233,7 @@ fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 	       u8 set_npiv, u8 set_auth, u16 local_bb_credits)
 {
 	u32        d_id = bfa_os_hton3b(FC_FABRIC_PORT);
-	u32	*vvl_info;
+	__be32	*vvl_info;
 
 	memcpy(flogi, &plogi_tmpl, sizeof(struct fc_logi_s));
 
@@ -267,7 +267,7 @@ fc_flogi_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
 
 u16
 fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi, u32 s_id,
-		   u16 ox_id, wwn_t port_name, wwn_t node_name,
+		   __be16 ox_id, wwn_t port_name, wwn_t node_name,
 		   u16 pdu_size, u16 local_bb_credits)
 {
 	u32        d_id = 0;
@@ -392,7 +392,7 @@ fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 
 u16
 fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
-		  u16 ox_id, enum bfa_lport_role role)
+		  __be16 ox_id, enum bfa_lport_role role)
 {
 	struct fc_prli_s *prli = (struct fc_prli_s *) (pld);
 
@@ -458,7 +458,7 @@ fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
 
 static          u16
 fc_adisc_x_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
-		 u32 s_id, u16 ox_id, wwn_t port_name,
+		 u32 s_id, __be16 ox_id, wwn_t port_name,
 		 wwn_t node_name, u8 els_code)
 {
 	memset(adisc, '\0', sizeof(struct fc_adisc_s));
@@ -480,7 +480,7 @@ fc_adisc_x_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
 
 u16
 fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
-		u32 s_id, u16 ox_id, wwn_t port_name, wwn_t node_name)
+		u32 s_id, __be16 ox_id, wwn_t port_name, wwn_t node_name)
 {
 	return fc_adisc_x_build(fchs, adisc, d_id, s_id, ox_id, port_name,
 				node_name, FC_ELS_ADISC);
@@ -488,7 +488,7 @@ fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
 
 u16
 fc_adisc_acc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
-		   u32 s_id, u16 ox_id, wwn_t port_name,
+		   u32 s_id, __be16 ox_id, wwn_t port_name,
 		   wwn_t node_name)
 {
 	return fc_adisc_x_build(fchs, adisc, d_id, s_id, ox_id, port_name,
@@ -592,7 +592,7 @@ fc_rrq_build(struct fchs_s *fchs, struct fc_rrq_s *rrq, u32 d_id, u32 s_id,
 
 u16
 fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
-		  u16 ox_id)
+		  __be16 ox_id)
 {
 	struct fc_els_cmd_s *acc = pld;
 
@@ -606,7 +606,7 @@ fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 
 u16
 fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt, u32 d_id,
-		u32 s_id, u16 ox_id, u8 reason_code,
+		u32 s_id, __be16 ox_id, u8 reason_code,
 		u8 reason_code_expl)
 {
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
@@ -622,7 +622,7 @@ fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt, u32 d_id,
 
 u16
 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
-		u32 s_id, u16 ox_id, u16 rx_id)
+		u32 s_id, __be16 ox_id, u16 rx_id)
 {
 	fc_bls_rsp_build(fchs, d_id, s_id, ox_id);
 
@@ -638,7 +638,7 @@ fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 
 u16
 fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd, u32 d_id,
-		u32 s_id, u16 ox_id)
+		u32 s_id, __be16 ox_id)
 {
 	fc_els_rsp_build(fchs, d_id, s_id, ox_id);
 	memset(els_cmd, 0, sizeof(struct fc_els_cmd_s));
@@ -666,7 +666,7 @@ fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code)
 
 u16
 fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, u16 ox_id, int num_pages)
+		u32 d_id, u32 s_id, __be16 ox_id, int num_pages)
 {
 	int             page;
 
@@ -690,7 +690,7 @@ fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
 
 u16
 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc, u32 d_id,
-		  u32 s_id, u16 ox_id, int num_pages)
+		  u32 s_id, __be16 ox_id, int num_pages)
 {
 	int             page;
 
@@ -728,7 +728,7 @@ fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid, u32 d_id,
 
 u16
 fc_rnid_acc_build(struct fchs_s *fchs, struct fc_rnid_acc_s *rnid_acc, u32 d_id,
-		  u32 s_id, u16 ox_id, u32 data_format,
+		  u32 s_id, __be16 ox_id, u32 data_format,
 		  struct fc_rnid_common_id_data_s *common_id_data,
 		  struct fc_rnid_general_topology_data_s *gen_topo_data)
 {
@@ -788,7 +788,7 @@ fc_rpsc2_build(struct fchs_s *fchs, struct fc_rpsc2_cmd_s *rpsc2, u32 d_id,
 
 u16
 fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
-		u32 d_id, u32 s_id, u16 ox_id,
+		u32 d_id, u32 s_id, __be16 ox_id,
 		  struct fc_rpsc_speed_info_s *oper_speed)
 {
 	memset(rpsc_acc, 0, sizeof(struct fc_rpsc_acc_s));
@@ -995,7 +995,7 @@ fc_rrq_rsp_parse(struct fchs_s *fchs, int len)
 }
 
 u16
-fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id, u16 ox_id,
+fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id, __be16 ox_id,
 		u32 reason_code, u32 reason_expl)
 {
 	struct fc_ba_rjt_s *ba_rjt = (struct fc_ba_rjt_s *) (fchs + 1);
@@ -1356,7 +1356,7 @@ void
 fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask)
 {
 	u8         index;
-	u32       *ptr = (u32 *) bit_mask;
+	__be32       *ptr = (__be32 *) bit_mask;
 	u32        type_value;
 
 	/*
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 73abd02..1737e08 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -138,7 +138,7 @@ u16        fc_fdisc_build(struct fchs_s *buf, struct fc_logi_s *flogi, u32 s_id,
 			       u16 pdu_size);
 
 u16        fc_flogi_acc_build(struct fchs_s *fchs, struct fc_logi_s *flogi,
-				   u32 s_id, u16 ox_id,
+				   u32 s_id, __be16 ox_id,
 				   wwn_t port_name, wwn_t node_name,
 				   u16 pdu_size,
 				   u16 local_bb_credits);
@@ -186,7 +186,7 @@ u16        fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
 				   u16 pdu_size);
 
 u16        fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
-			u32 d_id, u32 s_id, u16 ox_id, wwn_t port_name,
+			u32 d_id, u32 s_id, __be16 ox_id, wwn_t port_name,
 			       wwn_t node_name);
 
 enum fc_parse_status fc_adisc_parse(struct fchs_s *fchs, void *pld,
@@ -196,20 +196,20 @@ enum fc_parse_status fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len,
 				 wwn_t port_name, wwn_t node_name);
 
 u16        fc_adisc_acc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
-				   u32 d_id, u32 s_id, u16 ox_id,
+				   u32 d_id, u32 s_id, __be16 ox_id,
 				   wwn_t port_name, wwn_t node_name);
 u16        fc_ls_rjt_build(struct fchs_s *fchs, struct fc_ls_rjt_s *ls_rjt,
-				u32 d_id, u32 s_id, u16 ox_id,
+				u32 d_id, u32 s_id, __be16 ox_id,
 				u8 reason_code, u8 reason_code_expl);
 u16        fc_ls_acc_build(struct fchs_s *fchs, struct fc_els_cmd_s *els_cmd,
-				u32 d_id, u32 s_id, u16 ox_id);
+				u32 d_id, u32 s_id, __be16 ox_id);
 u16        fc_prli_build(struct fchs_s *fchs, void *pld, u32 d_id,
 			      u32 s_id, u16 ox_id);
 
 enum fc_parse_status fc_prli_rsp_parse(struct fc_prli_s *prli, int len);
 
 u16        fc_prli_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
-				  u32 s_id, u16 ox_id,
+				  u32 s_id, __be16 ox_id,
 				  enum bfa_lport_role role);
 
 u16        fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
@@ -218,7 +218,7 @@ u16        fc_rnid_build(struct fchs_s *fchs, struct fc_rnid_cmd_s *rnid,
 
 u16        fc_rnid_acc_build(struct fchs_s *fchs,
 			struct fc_rnid_acc_s *rnid_acc, u32 d_id, u32 s_id,
-			u16 ox_id, u32 data_format,
+			__be16 ox_id, u32 data_format,
 			struct fc_rnid_common_id_data_s *common_id_data,
 			struct fc_rnid_general_topology_data_s *gen_topo_data);
 
@@ -228,7 +228,7 @@ u16        fc_rpsc_build(struct fchs_s *fchs, struct fc_rpsc_cmd_s *rpsc,
 			      u32 d_id, u32 s_id, u16 ox_id);
 u16        fc_rpsc_acc_build(struct fchs_s *fchs,
 			struct fc_rpsc_acc_s *rpsc_acc, u32 d_id, u32 s_id,
-			u16 ox_id, struct fc_rpsc_speed_info_s *oper_speed);
+			__be16 ox_id, struct fc_rpsc_speed_info_s *oper_speed);
 u16        fc_gid_ft_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u8 fc4_type);
 
@@ -251,7 +251,7 @@ u16        fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id,
 			      u32 s_id, u16 ox_id, wwn_t port_name);
 
 u16        fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id,
-				  u32 s_id, u16 ox_id);
+				  u32 s_id, __be16 ox_id);
 
 u16        fc_fdmi_reqhdr_build(struct fchs_s *fchs, void *pyld, u32 s_id,
 				     u16 cmd_code);
@@ -261,7 +261,7 @@ u16	fc_gfn_req_build(struct fchs_s *fchs, void *pyld, u32 s_id, wwn_t wwn);
 void		fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
 
 void		fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-					 u16 ox_id);
+					 __be16 ox_id);
 
 enum fc_parse_status	fc_els_rsp_parse(struct fchs_s *fchs, int len);
 
@@ -274,15 +274,15 @@ enum fc_parse_status	fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
 					wwn_t port_name);
 
 u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
-		u32 s_id, u16 ox_id, u16 rx_id);
+		u32 s_id, __be16 ox_id, u16 rx_id);
 
 int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
 
 u16 fc_tprlo_acc_build(struct fchs_s *fchs, struct fc_tprlo_acc_s *tprlo_acc,
-		u32 d_id, u32 s_id, u16 ox_id, int num_pages);
+		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
 
 u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
-		u32 d_id, u32 s_id, u16 ox_id, int num_pages);
+		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
 
 u16 fc_logo_rsp_parse(struct fchs_s *fchs, int len);
 
@@ -304,7 +304,7 @@ u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 u16 fc_tprlo_rsp_parse(struct fchs_s *fchs, int len);
 
 u16 fc_ba_rjt_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
-		u16 ox_id, u32 reason_code, u32 reason_expl);
+		__be16 ox_id, u32 reason_code, u32 reason_expl);
 
 u16 fc_gnnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 		u32 port_id);
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 9cb6a55..5a8b928 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -109,7 +109,7 @@ struct bfa_fcs_lport_loop_s {
 
 struct bfa_fcs_lport_n2n_s {
 	u32        rsvd;
-	u16        reply_oxid;	/*  ox_id from the req flogi to be
+	__be16     reply_oxid;	/*  ox_id from the req flogi to be
 					 *used in flogi acc */
 	wwn_t           rem_port_wwn;	/*  Attached port's wwn */
 };
@@ -406,7 +406,7 @@ struct bfa_fcs_rport_s {
 	struct bfad_rport_s	*rp_drv;	/*  driver peer instance */
 	u32	pid;	/*  port ID of rport */
 	u16	maxfrsize;	/*  maximum frame size */
-	u16	reply_oxid;	/*  OX_ID of inbound requests */
+	__be16	reply_oxid;	/*  OX_ID of inbound requests */
 	enum fc_cos	fc_cos;	/*  FC classes of service supp */
 	bfa_boolean_t	cisc;	/*  CISC capable device */
 	bfa_boolean_t	prlo;	/*  processing prlo or LOGO */
@@ -471,7 +471,7 @@ void bfa_fcs_rport_plogi_create(struct bfa_fcs_lport_s *port,
 void bfa_fcs_rport_plogi(struct bfa_fcs_rport_s *rport, struct fchs_s *fchs,
 			 struct fc_logi_s *plogi);
 void bfa_fcs_rport_logo_imp(struct bfa_fcs_rport_s *rport);
-void bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, u16 ox_id);
+void bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, __be16 ox_id);
 
 void bfa_fcs_rport_itnim_ack(struct bfa_fcs_rport_s *rport);
 void bfa_fcs_rport_itntm_ack(struct bfa_fcs_rport_s *rport);
@@ -618,7 +618,7 @@ struct bfa_fcs_fdmi_hba_attr_s {
 	u8         option_rom_ver[BFA_VERSION_LEN];
 	u8         fw_version[8];
 	u8         os_name[256];
-	u32        max_ct_pyld;
+	__be32        max_ct_pyld;
 };
 
 /*
@@ -626,9 +626,9 @@ struct bfa_fcs_fdmi_hba_attr_s {
  */
 struct bfa_fcs_fdmi_port_attr_s {
 	u8         supp_fc4_types[32];	/* supported FC4 types */
-	u32        supp_speed;	/* supported speed */
-	u32        curr_speed;	/* current Speed */
-	u32        max_frm_size;	/* max frame size */
+	__be32        supp_speed;	/* supported speed */
+	__be32        curr_speed;	/* current Speed */
+	__be32        max_frm_size;	/* max frame size */
 	u8         os_device_name[256];	/* OS device Name */
 	u8         host_name[256];	/* host name */
 };
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 372ed14..bf85ca7 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1569,6 +1569,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	struct fdmi_attr_s *attr;
 	u8        *curr_ptr;
 	u16        len, count;
+	u16	templen;
 
 	/*
 	 * get hba attributes
@@ -1594,69 +1595,69 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_NODENAME);
-	attr->len = sizeof(wwn_t);
-	memcpy(attr->value, &bfa_fcs_lport_get_nwwn(port), attr->len);
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = sizeof(wwn_t);
+	memcpy(attr->value, &bfa_fcs_lport_get_nwwn(port), templen);
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Manufacturer
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MANUFACTURER);
-	attr->len = (u16) strlen(fcs_hba_attr->manufacturer);
-	memcpy(attr->value, fcs_hba_attr->manufacturer, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = (u16) strlen(fcs_hba_attr->manufacturer);
+	memcpy(attr->value, fcs_hba_attr->manufacturer, templen);
+	templen = fc_roundup(templen, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Serial Number
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_SERIALNUM);
-	attr->len = (u16) strlen(fcs_hba_attr->serial_num);
-	memcpy(attr->value, fcs_hba_attr->serial_num, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = (u16) strlen(fcs_hba_attr->serial_num);
+	memcpy(attr->value, fcs_hba_attr->serial_num, templen);
+	templen = fc_roundup(templen, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Model
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MODEL);
-	attr->len = (u16) strlen(fcs_hba_attr->model);
-	memcpy(attr->value, fcs_hba_attr->model, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = (u16) strlen(fcs_hba_attr->model);
+	memcpy(attr->value, fcs_hba_attr->model, templen);
+	templen = fc_roundup(templen, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Model Desc
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MODEL_DESC);
-	attr->len = (u16) strlen(fcs_hba_attr->model_desc);
-	memcpy(attr->value, fcs_hba_attr->model_desc, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = (u16) strlen(fcs_hba_attr->model_desc);
+	memcpy(attr->value, fcs_hba_attr->model_desc, templen);
+	templen = fc_roundup(templen, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * H/W Version
@@ -1664,14 +1665,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	if (fcs_hba_attr->hw_version[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
 		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_HW_VERSION);
-		attr->len = (u16) strlen(fcs_hba_attr->hw_version);
-		memcpy(attr->value, fcs_hba_attr->hw_version, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));
-		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-		len += attr->len;
+		templen = (u16) strlen(fcs_hba_attr->hw_version);
+		memcpy(attr->value, fcs_hba_attr->hw_version, templen);
+		templen = fc_roundup(templen, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+		len += templen;
 		count++;
-		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-					 sizeof(attr->len));
+		attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+					 sizeof(templen));
 	}
 
 	/*
@@ -1679,14 +1680,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_DRIVER_VERSION);
-	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
-	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;;
+	templen = (u16) strlen(fcs_hba_attr->driver_version);
+	memcpy(attr->value, fcs_hba_attr->driver_version, templen);
+	templen = fc_roundup(templen, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Option Rom Version
@@ -1694,14 +1695,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	if (fcs_hba_attr->option_rom_ver[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
 		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_ROM_VERSION);
-		attr->len = (u16) strlen(fcs_hba_attr->option_rom_ver);
-		memcpy(attr->value, fcs_hba_attr->option_rom_ver, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));
-		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-		len += attr->len;
+		templen = (u16) strlen(fcs_hba_attr->option_rom_ver);
+		memcpy(attr->value, fcs_hba_attr->option_rom_ver, templen);
+		templen = fc_roundup(templen, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+		len += templen;
 		count++;
-		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-					 sizeof(attr->len));
+		attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+					 sizeof(templen));
 	}
 
 	/*
@@ -1709,14 +1710,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_FW_VERSION);
-	attr->len = (u16) strlen(fcs_hba_attr->driver_version);
-	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
-	attr->len = fc_roundup(attr->len, sizeof(u32));
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = (u16) strlen(fcs_hba_attr->driver_version);
+	memcpy(attr->value, fcs_hba_attr->driver_version, templen);
+	templen = fc_roundup(templen, sizeof(u32));
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * OS Name
@@ -1724,14 +1725,14 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	if (fcs_hba_attr->os_name[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
 		attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_OS_NAME);
-		attr->len = (u16) strlen(fcs_hba_attr->os_name);
-		memcpy(attr->value, fcs_hba_attr->os_name, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));
-		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-		len += attr->len;
+		templen = (u16) strlen(fcs_hba_attr->os_name);
+		memcpy(attr->value, fcs_hba_attr->os_name, templen);
+		templen = fc_roundup(templen, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+		len += templen;
 		count++;
-		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-					sizeof(attr->len));
+		attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+					sizeof(templen));
 	}
 
 	/*
@@ -1739,12 +1740,12 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_HBA_ATTRIB_MAX_CT);
-	attr->len = sizeof(fcs_hba_attr->max_ct_pyld);
-	memcpy(attr->value, &fcs_hba_attr->max_ct_pyld, attr->len);
-	len += attr->len;
+	templen = sizeof(fcs_hba_attr->max_ct_pyld);
+	memcpy(attr->value, &fcs_hba_attr->max_ct_pyld, templen);
+	len += templen;
 	count++;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Update size of payload
@@ -1845,6 +1846,7 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	u8        *curr_ptr;
 	u16        len;
 	u8	count = 0;
+	u16	templen;
 
 	/*
 	 * get port attributes
@@ -1863,54 +1865,54 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_FC4_TYPES);
-	attr->len = sizeof(fcs_port_attr.supp_fc4_types);
-	memcpy(attr->value, fcs_port_attr.supp_fc4_types, attr->len);
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = sizeof(fcs_port_attr.supp_fc4_types);
+	memcpy(attr->value, fcs_port_attr.supp_fc4_types, templen);
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	++count;
 	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+		cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * Supported Speed
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_SUPP_SPEED);
-	attr->len = sizeof(fcs_port_attr.supp_speed);
-	memcpy(attr->value, &fcs_port_attr.supp_speed, attr->len);
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = sizeof(fcs_port_attr.supp_speed);
+	memcpy(attr->value, &fcs_port_attr.supp_speed, templen);
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	++count;
 	attr->len =
-		cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+		cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * current Port Speed
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_PORT_SPEED);
-	attr->len = sizeof(fcs_port_attr.curr_speed);
-	memcpy(attr->value, &fcs_port_attr.curr_speed, attr->len);
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = sizeof(fcs_port_attr.curr_speed);
+	memcpy(attr->value, &fcs_port_attr.curr_speed, templen);
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	++count;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * max frame size
 	 */
 	attr = (struct fdmi_attr_s *) curr_ptr;
 	attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_FRAME_SIZE);
-	attr->len = sizeof(fcs_port_attr.max_frm_size);
-	memcpy(attr->value, &fcs_port_attr.max_frm_size, attr->len);
-	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;
+	templen = sizeof(fcs_port_attr.max_frm_size);
+	memcpy(attr->value, &fcs_port_attr.max_frm_size, templen);
+	curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+	len += templen;
 	++count;
-	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-			     sizeof(attr->len));
+	attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+			     sizeof(templen));
 
 	/*
 	 * OS Device Name
@@ -1918,14 +1920,14 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	if (fcs_port_attr.os_device_name[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
 		attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_DEV_NAME);
-		attr->len = (u16) strlen(fcs_port_attr.os_device_name);
-		memcpy(attr->value, fcs_port_attr.os_device_name, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));
-		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-		len += attr->len;
+		templen = (u16) strlen(fcs_port_attr.os_device_name);
+		memcpy(attr->value, fcs_port_attr.os_device_name, templen);
+		templen = fc_roundup(templen, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+		len += templen;
 		++count;
-		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-					sizeof(attr->len));
+		attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+					sizeof(templen));
 	}
 	/*
 	 * Host Name
@@ -1933,14 +1935,14 @@ bfa_fcs_lport_fdmi_build_portattr_block(struct bfa_fcs_lport_fdmi_s *fdmi,
 	if (fcs_port_attr.host_name[0] != '\0') {
 		attr = (struct fdmi_attr_s *) curr_ptr;
 		attr->type = cpu_to_be16(FDMI_PORT_ATTRIB_HOST_NAME);
-		attr->len = (u16) strlen(fcs_port_attr.host_name);
-		memcpy(attr->value, fcs_port_attr.host_name, attr->len);
-		attr->len = fc_roundup(attr->len, sizeof(u32));
-		curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-		len += attr->len;
+		templen = (u16) strlen(fcs_port_attr.host_name);
+		memcpy(attr->value, fcs_port_attr.host_name, templen);
+		templen = fc_roundup(templen, sizeof(u32));
+		curr_ptr += sizeof(attr->type) + sizeof(templen) + templen;
+		len += templen;
 		++count;
-		attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
-				sizeof(attr->len));
+		attr->len = cpu_to_be16(templen + sizeof(attr->type) +
+				sizeof(templen));
 	}
 
 	/*
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 7272688..1717d1d 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2594,7 +2594,7 @@ bfa_fcs_rport_set_del_timeout(u8 rport_tmo)
 		bfa_fcs_rport_del_timeout = rport_tmo * 1000;
 }
 void
-bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, u16 ox_id)
+bfa_fcs_rport_prlo(struct bfa_fcs_rport_s *rport, __be16 ox_id)
 {
 	bfa_trc(rport->fcs, rport->pid);
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 54475b5..23c2ef6 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1683,7 +1683,8 @@ bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
 static bfa_status_t
 bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 {
-	u32 pgnum, loff, r32;
+	u32 pgnum, loff;
+	__be32 r32;
 	int i, len;
 	u32 *buf = tbuf;
 
@@ -1909,7 +1910,7 @@ bfa_ioc_is_initialized(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 {
-	u32	*msgp = mbmsg;
+	__be32	*msgp = mbmsg;
 	u32	r32;
 	int		i;
 
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index eb1b005..f8ac050 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -115,8 +115,8 @@ struct bfa_dma_s {
 static inline void
 __bfa_dma_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 {
-	dma_addr->a32.addr_lo = (u32) pa;
-	dma_addr->a32.addr_hi = (u32) (bfa_os_u32(pa));
+	dma_addr->a32.addr_lo = (__be32) pa;
+	dma_addr->a32.addr_hi = (__be32) (bfa_os_u32(pa));
 }
 
 
@@ -125,8 +125,8 @@ __bfa_dma_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 static inline void
 __bfa_dma_be_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 {
-	dma_addr->a32.addr_lo = (u32) cpu_to_be32(pa);
-	dma_addr->a32.addr_hi = (u32) cpu_to_be32(bfa_os_u32(pa));
+	dma_addr->a32.addr_lo = cpu_to_be32(pa);
+	dma_addr->a32.addr_hi = cpu_to_be32(bfa_os_u32(pa));
 }
 
 struct bfa_ioc_regs_s {
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index fff9622..35277cb 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -29,7 +29,7 @@ static void
 bfa_port_stats_swap(struct bfa_port_s *port, union bfa_port_stats_u *stats)
 {
 	u32    *dip = (u32 *) stats;
-	u32    t0, t1;
+	__be32    t0, t1;
 	int	    i;
 
 	for (i = 0; i < sizeof(union bfa_port_stats_u)/sizeof(u32);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index c768143..71b9281 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -3127,7 +3127,7 @@ bfa_fcport_qos_stats_swap(struct bfa_qos_stats_s *d,
 	struct bfa_qos_stats_s *s)
 {
 	u32	*dip = (u32 *) d;
-	u32	*sip = (u32 *) s;
+	__be32	*sip = (__be32 *) s;
 	int		i;
 
 	/* Now swap the 32 bit fields */
@@ -3140,7 +3140,7 @@ bfa_fcport_fcoe_stats_swap(struct bfa_fcoe_stats_s *d,
 	struct bfa_fcoe_stats_s *s)
 {
 	u32	*dip = (u32 *) d;
-	u32	*sip = (u32 *) s;
+	__be32	*sip = (__be32 *) s;
 	int		i;
 
 	for (i = 0; i < ((sizeof(struct bfa_fcoe_stats_s))/sizeof(u32));
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 58796d1..27b33c7 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -95,8 +95,8 @@ enum {
  */
 union bfi_addr_u {
 	struct {
-		u32	addr_lo;
-		u32	addr_hi;
+		__be32	addr_lo;
+		__be32	addr_hi;
 	} a32;
 };
 
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index fa9f6fb..1028876 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -47,10 +47,10 @@ struct bfi_iocfc_cfg_s {
 	 */
 	union bfi_addr_u  req_cq_ba[BFI_IOC_MAX_CQS];
 	union bfi_addr_u  req_shadow_ci[BFI_IOC_MAX_CQS];
-	u16    req_cq_elems[BFI_IOC_MAX_CQS];
+	__be16    req_cq_elems[BFI_IOC_MAX_CQS];
 	union bfi_addr_u  rsp_cq_ba[BFI_IOC_MAX_CQS];
 	union bfi_addr_u  rsp_shadow_pi[BFI_IOC_MAX_CQS];
-	u16    rsp_cq_elems[BFI_IOC_MAX_CQS];
+	__be16    rsp_cq_elems[BFI_IOC_MAX_CQS];
 
 	union bfi_addr_u  stats_addr;	/*  DMA-able address for stats	  */
 	union bfi_addr_u  cfgrsp_addr;	/*  config response dma address  */
@@ -102,8 +102,8 @@ struct bfi_iocfc_set_intr_req_s {
 	struct bfi_mhdr_s mh;		/*  common msg header		*/
 	u8		coalesce;	/*  enable intr coalescing	*/
 	u8		rsvd[3];
-	u16	delay;		/*  delay timer 0..1125us	*/
-	u16	latency;	/*  latency timer 0..225us	*/
+	__be16	delay;		/*  delay timer 0..1125us	*/
+	__be16	latency;	/*  latency timer 0..225us	*/
 };
 
 
@@ -210,7 +210,7 @@ struct bfi_fcport_enable_req_s {
  */
 struct bfi_fcport_set_svc_params_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header */
-	u16	   tx_bbcredit;	/*  Tx credits */
+	__be16	   tx_bbcredit;	/*  Tx credits */
 	u16	   rsvd;
 };
 
@@ -231,7 +231,7 @@ struct bfi_fcport_trunk_link_s {
 	u8			state;		/* bfa_trunk_link_state_t */
 	u8			speed;		/* bfa_port_speed_t */
 	u8			rsvd;
-	u32		deskew;
+	__be32		deskew;
 };
 
 #define BFI_FCPORT_MAX_LINKS	2
@@ -284,17 +284,17 @@ enum bfi_fcxp_i2h {
  */
 struct bfi_fcxp_send_req_s {
 	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
-	u16	fcxp_tag;	/*  driver request tag		    */
-	u16	max_frmsz;	/*  max send frame size	    */
-	u16	vf_id;		/*  vsan tag if applicable	    */
+	__be16	fcxp_tag;	/*  driver request tag		    */
+	__be16	max_frmsz;	/*  max send frame size	    */
+	__be16	vf_id;		/*  vsan tag if applicable	    */
 	u16	rport_fw_hndl;	/*  FW Handle for the remote port  */
 	u8	 class;		/*  FC class used for req/rsp	    */
 	u8	 rsp_timeout;	/*  timeout in secs, 0-no response */
 	u8	 cts;		/*  continue sequence		    */
 	u8	 lp_tag;	/*  lport tag			    */
 	struct fchs_s	fchs;	/*  request FC header structure    */
-	u32	req_len;	/*  request payload length	    */
-	u32	rsp_maxlen;	/*  max response length expected   */
+	__be32	req_len;	/*  request payload length	    */
+	__be32	rsp_maxlen;	/*  max response length expected   */
 	struct bfi_sge_s   req_sge[BFA_FCXP_MAX_SGES];	/*  request buf    */
 	struct bfi_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];	/*  response buf   */
 };
@@ -304,11 +304,11 @@ struct bfi_fcxp_send_req_s {
  */
 struct bfi_fcxp_send_rsp_s {
 	struct bfi_mhdr_s  mh;		/*  Common msg header		    */
-	u16	fcxp_tag;	/*  send request tag		    */
+	__be16	fcxp_tag;	/*  send request tag		    */
 	u8	 req_status;	/*  request status		    */
 	u8	 rsvd;
-	u32	rsp_len;	/*  actual response length	    */
-	u32	residue_len;	/*  residual response length	    */
+	__be32	rsp_len;	/*  actual response length	    */
+	__be32	residue_len;	/*  residual response length	    */
 	struct fchs_s	fchs;	/*  response FC header structure   */
 };
 
@@ -325,7 +325,7 @@ enum bfi_uf_i2h {
 struct bfi_uf_buf_post_s {
 	struct bfi_mhdr_s  mh;		/*  Common msg header		*/
 	u16	buf_tag;	/*  buffer tag			*/
-	u16	buf_len;	/*  total buffer length	*/
+	__be16	buf_len;	/*  total buffer length	*/
 	struct bfi_sge_s   sge[BFA_UF_MAX_SGES]; /*  buffer DMA SGEs	*/
 };
 
@@ -352,7 +352,7 @@ struct bfi_lps_login_req_s {
 	struct bfi_mhdr_s  mh;		/*  common msg header		*/
 	u8		lp_tag;
 	u8		alpa;
-	u16	pdu_size;
+	__be16		pdu_size;
 	wwn_t		pwwn;
 	wwn_t		nwwn;
 	u8		fdisc;
@@ -368,7 +368,7 @@ struct bfi_lps_login_rsp_s {
 	u8		lsrjt_expl;
 	wwn_t		port_name;
 	wwn_t		node_name;
-	u16	bb_credit;
+	__be16		bb_credit;
 	u8		f_port;
 	u8		npiv_en;
 	u32	lp_pid:24;
@@ -427,7 +427,7 @@ enum bfi_rport_i2h_msgs {
 struct bfi_rport_create_req_s {
 	struct bfi_mhdr_s  mh;		/*  common msg header		*/
 	u16	bfa_handle;	/*  host rport handle		*/
-	u16	max_frmsz;	/*  max rcv pdu size		*/
+	__be16	max_frmsz;	/*  max rcv pdu size		*/
 	u32	pid:24,	/*  remote port ID		*/
 		lp_tag:8;	/*  local port tag		*/
 	u32	local_pid:24,	/*  local port ID		*/
@@ -583,7 +583,7 @@ struct bfi_ioim_dif_s {
  */
 struct bfi_ioim_req_s {
 	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
-	u16	io_tag;		/*  I/O tag			 */
+	__be16	io_tag;		/*  I/O tag			 */
 	u16	rport_hdl;	/*  itnim/rport firmware handle */
 	struct fcp_cmnd_s	cmnd;	/*  IO request info	*/
 
@@ -689,7 +689,7 @@ enum bfi_ioim_status {
  */
 struct bfi_ioim_rsp_s {
 	struct bfi_mhdr_s	mh;	/*  common msg header		*/
-	u16	io_tag;		/*  completed IO tag		 */
+	__be16	io_tag;		/*  completed IO tag		 */
 	u16	bfa_rport_hndl;	/*  releated rport handle	 */
 	u8	io_status;	/*  IO completion status	 */
 	u8	reuse_io_tag;	/*  IO tag can be reused	*/
@@ -698,13 +698,13 @@ struct bfi_ioim_rsp_s {
 	u8		sns_len;	/*  scsi sense length		 */
 	u8		resid_flags;	/*  IO residue flags		 */
 	u8		rsvd_a;
-	u32	residue;	/*  IO residual length in bytes */
+	__be32	residue;	/*  IO residual length in bytes */
 	u32	rsvd_b[3];
 };
 
 struct bfi_ioim_abort_req_s {
 	struct bfi_mhdr_s  mh;	/*  Common msg header  */
-	u16	io_tag;	/*  I/O tag	*/
+	__be16	io_tag;	/*  I/O tag	*/
 	u16	abort_tag;	/*  unique request tag */
 };
 
@@ -723,7 +723,7 @@ enum bfi_tskim_i2h {
 
 struct bfi_tskim_req_s {
 	struct bfi_mhdr_s  mh;	/*  Common msg header	*/
-	u16	tsk_tag;	/*  task management tag	*/
+	__be16	tsk_tag;	/*  task management tag	*/
 	u16	itn_fhdl;	/*  itn firmware handle	*/
 	lun_t	lun;	/*  LU number	*/
 	u8	tm_flags;	/*  see enum fcp_tm_cmnd	*/
@@ -733,7 +733,7 @@ struct bfi_tskim_req_s {
 
 struct bfi_tskim_abortreq_s {
 	struct bfi_mhdr_s  mh;	/*  Common msg header	*/
-	u16	tsk_tag;	/*  task management tag	*/
+	__be16	tsk_tag;	/*  task management tag	*/
 	u16	rsvd;
 };
 
@@ -755,7 +755,7 @@ enum bfi_tskim_status {
 
 struct bfi_tskim_rsp_s {
 	struct bfi_mhdr_s  mh;		/*  Common msg header		 */
-	u16	tsk_tag;	/*  task mgmt cmnd tag		 */
+	__be16	tsk_tag;	/*  task mgmt cmnd tag		 */
 	u8	tsk_status;	/*  @ref bfi_tskim_status */
 	u8	rsvd;
 };
-- 
1.7.2.1

