From: <kgudipat@brocade.com>
Subject: [PATCH 2/6] bfa: Store port configuration in flash for persistency.
Date: Mon, 13 Dec 2010 16:16:50 -0800
Message-ID: <1292285810-7327-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:35632 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758057Ab0LNARO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- When the bfa driver is loaded a flogi is sent without the knowledge
	  of trunking configuration. This normal flogi causes the switch ports
	  which had trunking enabled to go to persistent offline.
	  Solution is to store the port configuration (which has trunking info) in
	  the flash for persistency. The firmware will read this configuration when
	  the very first fcport enable is received.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_svc.c |   25 ++++++++++++++++++++++++-
 drivers/scsi/bfa/bfa_svc.h |    1 +
 drivers/scsi/bfa/bfi_ms.h  |    6 ++++--
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index d5e5bfd..bbd8fbb 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -1890,6 +1890,8 @@ bfa_fcport_sm_uninit(struct bfa_fcport_s *fcport,
 		/*
 		 * Start event after IOC is configured and BFA is started.
 		 */
+		fcport->use_flash_cfg = BFA_TRUE;
+
 		if (bfa_fcport_send_enable(fcport)) {
 			bfa_trc(fcport->bfa, BFA_TRUE);
 			bfa_sm_set_state(fcport, bfa_fcport_sm_enabling);
@@ -2855,6 +2857,7 @@ bfa_fcport_send_enable(struct bfa_fcport_s *fcport)
 	m->port_cfg = fcport->cfg;
 	m->msgtag = fcport->msgtag;
 	m->port_cfg.maxfrsize = cpu_to_be16(fcport->cfg.maxfrsize);
+	 m->use_flash_cfg = fcport->use_flash_cfg;
 	bfa_dma_be_addr_set(m->stats_dma_addr, fcport->stats_pa);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_lo);
 	bfa_trc(fcport->bfa, m->stats_dma_addr.a32.addr_hi);
@@ -3251,8 +3254,28 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 
 	switch (msg->mhdr.msg_id) {
 	case BFI_FCPORT_I2H_ENABLE_RSP:
-		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag) {
+
+			if (fcport->use_flash_cfg) {
+				fcport->cfg = i2hmsg.penable_rsp->port_cfg;
+				fcport->cfg.maxfrsize =
+					cpu_to_be16(fcport->cfg.maxfrsize);
+				fcport->cfg.path_tov =
+					cpu_to_be16(fcport->cfg.path_tov);
+				fcport->cfg.q_depth =
+					cpu_to_be16(fcport->cfg.q_depth);
+
+				if (fcport->cfg.trunked)
+					fcport->trunk.attr.state =
+						BFA_TRUNK_OFFLINE;
+				else
+					fcport->trunk.attr.state =
+						BFA_TRUNK_DISABLED;
+				fcport->use_flash_cfg = BFA_FALSE;
+			}
+
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
+		}
 		break;
 
 	case BFI_FCPORT_I2H_DISABLE_RSP:
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index 29b0918..36c81c7 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -444,6 +444,7 @@ struct bfa_fcport_s {
 	u8			myalpa;	/*  my ALPA in LOOP topology */
 	u8			rsvd[3];
 	struct bfa_port_cfg_s	cfg;	/*  current port configuration */
+	bfa_boolean_t		use_flash_cfg; /* get port cfg from flash */
 	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
 	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
 	struct bfa_reqq_wait_s	reqq_wait;
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index e0e5318..8f22ef1 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -188,7 +188,8 @@ struct bfi_fcport_rsp_s {
 	struct bfi_mhdr_s  mh;		/*  common msg header		    */
 	u8		   status;	/*  port enable status		    */
 	u8		   rsvd[3];
-	u32	   msgtag;	/*  msgtag for reply		    */
+	struct	bfa_port_cfg_s port_cfg;/* port configuration	*/
+	u32	msgtag;			/* msgtag for reply	*/
 };
 
 /*
@@ -202,7 +203,8 @@ struct bfi_fcport_enable_req_s {
 	struct bfa_port_cfg_s port_cfg; /*  port configuration	    */
 	union bfi_addr_u   stats_dma_addr; /*  DMA address for stats	    */
 	u32	   msgtag;	/*  msgtag for reply		    */
-	u32	   rsvd2;
+	u8	use_flash_cfg;	/* get prot cfg from flash */
+	u8	rsvd2[3];
 };
 
 /*
-- 
1.7.3.rc1

