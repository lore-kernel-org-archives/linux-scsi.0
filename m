From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 02/17] bfa: Forward Error Correction status query
Date: Mon, 13 May 2013 02:33:20 -0700
Message-ID: <1368437615-9867-3-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50332 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab3EMJu6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:50:58 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

This patch includes changes to get FC HBA feature Forward Error
Correction (FEC) (enabled at 16Gig speed) status from firmware and to
return to brocade HBA management utility.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_defs_svc.h | 15 +++++++++++++--
 drivers/scsi/bfa/bfa_svc.c      |  8 ++++++++
 drivers/scsi/bfa/bfa_svc.h      |  1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index efbf0a9..8522475 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -882,6 +882,15 @@ enum bfa_lunmask_state_s {
 	BFA_LUNMASK_UNINITIALIZED = 0xff,
 };
 
+/**
+ * FEC states
+ */
+enum bfa_fec_state_s {
+	BFA_FEC_ONLINE = 1,		/*!< FEC is online */
+	BFA_FEC_OFFLINE = 2,		/*!< FEC is offline */
+	BFA_FEC_OFFLINE_NOT_16G = 3,	/*!< FEC is offline (speed not 16Gig) */
+};
+
 #pragma pack(1)
 /*
  * LUN mask configuration
@@ -978,6 +987,7 @@ struct bfa_port_attr_s {
 	bfa_boolean_t		link_e2e_beacon; /* link beacon is on */
 	bfa_boolean_t		bbsc_op_status;	/* fc credit recovery oper
 						 * state */
+	enum bfa_fec_state_s	fec_state;	/*!< current FEC state */
 
 	/*
 	 * Dynamic field - info from FCS
@@ -989,7 +999,7 @@ struct bfa_port_attr_s {
 
 	/* FCoE specific  */
 	u16			fcoe_vlan;
-	u8			rsvd1[6];
+	u8			rsvd1[2];
 };
 
 /*
@@ -1076,7 +1086,8 @@ struct bfa_port_link_s {
 	u8	 speed;		/*  Link speed (1/2/4/8 G) */
 	u32	 linkstate_opt; /*  Linkstate optional data (debug) */
 	u8	 trunked;	/*  Trunked or not (1 or 0) */
-	u8	 resvd[7];
+	u8	 fec_state;	/*!< State of FEC */
+	u8	 resvd[6];
 	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
 	union {
 		struct bfa_fcport_loop_info_s loop_info;
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 0fff5ec..60ebcc9 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -3079,6 +3079,8 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	port_cfg->qos_bw.med = BFA_QOS_BW_MED;
 	port_cfg->qos_bw.low = BFA_QOS_BW_LOW;
 
+	fcport->fec_state = BFA_FEC_OFFLINE;
+
 	INIT_LIST_HEAD(&fcport->stats_pending_q);
 	INIT_LIST_HEAD(&fcport->statsclr_pending_q);
 
@@ -3157,6 +3159,9 @@ bfa_fcport_update_linkinfo(struct bfa_fcport_s *fcport)
 
 	if (fcport->cfg.bb_cr_enabled)
 		fcport->bbcr_attr = pevent->link_state.attr.bbcr_attr;
+
+	fcport->fec_state = pevent->link_state.fec_state;
+
 	/*
 	 * update trunk state if applicable
 	 */
@@ -3176,6 +3181,7 @@ bfa_fcport_reset_linkinfo(struct bfa_fcport_s *fcport)
 {
 	fcport->speed = BFA_PORT_SPEED_UNKNOWN;
 	fcport->topology = BFA_PORT_TOPOLOGY_NONE;
+	fcport->fec_state = BFA_FEC_OFFLINE;
 }
 
 /*
@@ -4027,6 +4033,8 @@ bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_port_attr_s *attr)
 	attr->pport_cfg.q_depth  = bfa_fcpim_qdepth_get(bfa);
 	attr->port_state = bfa_sm_to_state(hal_port_sm_table, fcport->sm);
 
+	attr->fec_state = fcport->fec_state;
+
 	/* PBC Disabled State */
 	if (bfa_fcport_is_pbcdisabled(bfa))
 		attr->port_state = BFA_PORT_ST_PREBOOT_DISABLED;
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index c2fb834..810bd9c 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -513,6 +513,7 @@ struct bfa_fcport_s {
 	struct bfa_mem_dma_s	fcport_dma;
 	bfa_boolean_t		stats_dma_ready;
 	struct bfa_bbcr_attr_s	bbcr_attr;
+	enum bfa_fec_state_s	fec_state;
 };
 
 #define BFA_FCPORT_MOD(__bfa)	(&(__bfa)->modules.fcport)
-- 
1.7.12

