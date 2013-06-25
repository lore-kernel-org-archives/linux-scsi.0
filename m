From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 13/16] qla2xxx: Help Coverity with analyzing ct_sns_pkt initialization.
Date: Tue, 25 Jun 2013 11:27:28 -0400
Message-ID: <1372174051-4211-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:26541
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200Ab3FYPxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:53 -0400
Received: from mail218-co9 (localhost [127.0.0.1])	by
 mail218-co9-R.bigfish.com (Postfix) with ESMTP id 2E4C76019C	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:53 +0000 (UTC)
Received: from CO9EHSMHS026.bigfish.com (unknown [10.236.132.253])	by
 mail218-co9.bigfish.com (Postfix) with ESMTP id 7A8B83C0122	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:51 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Coverity reports "Overrunning struct type ct_sns_req of 1228 bytes
by passing it to a function which accesses it at byte offset 8207"
for each qla2x00_prep_ct_req(), qla2x00_prep_ct_fdmi_req() and
qla24xx_prep_ct_fm_req() call. Help Coverity to recognize that
these calls do not trigger a buffer overflow by making it explicit
that these three functions initializes both the request and reply
structures. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |   83 +++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f26442a..0926451 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -99,17 +99,17 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
  * Returns a pointer to the intitialized @ct_req.
  */
 static inline struct ct_sns_req *
-qla2x00_prep_ct_req(struct ct_sns_req *ct_req, uint16_t cmd, uint16_t rsp_size)
+qla2x00_prep_ct_req(struct ct_sns_pkt *p, uint16_t cmd, uint16_t rsp_size)
 {
-	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
+	memset(p, 0, sizeof(struct ct_sns_pkt));
 
-	ct_req->header.revision = 0x01;
-	ct_req->header.gs_type = 0xFC;
-	ct_req->header.gs_subtype = 0x02;
-	ct_req->command = cpu_to_be16(cmd);
-	ct_req->max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
+	p->p.req.header.revision = 0x01;
+	p->p.req.header.gs_type = 0xFC;
+	p->p.req.header.gs_subtype = 0x02;
+	p->p.req.command = cpu_to_be16(cmd);
+	p->p.req.max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
 
-	return (ct_req);
+	return &p->p.req;
 }
 
 static int
@@ -188,7 +188,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    GA_NXT_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GA_NXT_CMD,
+	ct_req = qla2x00_prep_ct_req(ha->ct_sns, GA_NXT_CMD,
 	    GA_NXT_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -284,8 +284,7 @@ qla2x00_gid_pt(scsi_qla_host_t *vha, sw_info_t *list)
 	    gid_pt_rsp_size);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GID_PT_CMD,
-	    gid_pt_rsp_size);
+	ct_req = qla2x00_prep_ct_req(ha->ct_sns, GID_PT_CMD, gid_pt_rsp_size);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- port_type */
@@ -359,7 +358,7 @@ qla2x00_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    GPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
-		ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GPN_ID_CMD,
+		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GPN_ID_CMD,
 		    GPN_ID_RSP_SIZE);
 		ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -421,7 +420,7 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    GNN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
-		ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GNN_ID_CMD,
+		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GNN_ID_CMD,
 		    GNN_ID_RSP_SIZE);
 		ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -495,7 +494,7 @@ qla2x00_rft_id(scsi_qla_host_t *vha)
 	    RFT_ID_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFT_ID_CMD,
+	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RFT_ID_CMD,
 	    RFT_ID_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -551,7 +550,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
 	    RFF_ID_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFF_ID_CMD,
+	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RFF_ID_CMD,
 	    RFF_ID_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -606,8 +605,7 @@ qla2x00_rnn_id(scsi_qla_host_t *vha)
 	    RNN_ID_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RNN_ID_CMD,
-	    RNN_ID_RSP_SIZE);
+	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RNN_ID_CMD, RNN_ID_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- port_id, node_name */
@@ -676,7 +674,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *vha)
 	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, 0, RSNN_NN_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RSNN_NN_CMD,
+	ct_req = qla2x00_prep_ct_req(ha->ct_sns, RSNN_NN_CMD,
 	    RSNN_NN_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -1262,18 +1260,18 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size)
  * Returns a pointer to the intitialized @ct_req.
  */
 static inline struct ct_sns_req *
-qla2x00_prep_ct_fdmi_req(struct ct_sns_req *ct_req, uint16_t cmd,
+qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, uint16_t cmd,
     uint16_t rsp_size)
 {
-	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
+	memset(p, 0, sizeof(struct ct_sns_pkt));
 
-	ct_req->header.revision = 0x01;
-	ct_req->header.gs_type = 0xFA;
-	ct_req->header.gs_subtype = 0x10;
-	ct_req->command = cpu_to_be16(cmd);
-	ct_req->max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
+	p->p.req.header.revision = 0x01;
+	p->p.req.header.gs_type = 0xFA;
+	p->p.req.header.gs_subtype = 0x10;
+	p->p.req.command = cpu_to_be16(cmd);
+	p->p.req.max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
 
-	return ct_req;
+	return &p->p.req;
 }
 
 /**
@@ -1301,8 +1299,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RHBA_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RHBA_CMD,
-	    RHBA_RSP_SIZE);
+	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RHBA_CMD, RHBA_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare FDMI command arguments -- attribute block, attributes. */
@@ -1490,8 +1487,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 	    DHBA_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, DHBA_CMD,
-	    DHBA_RSP_SIZE);
+	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, DHBA_CMD, DHBA_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare FDMI command arguments -- portname. */
@@ -1547,8 +1543,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RPA_RSP_SIZE);
 
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RPA_CMD,
-	    RPA_RSP_SIZE);
+	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RPA_CMD, RPA_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare FDMI command arguments -- attribute block, attributes. */
@@ -1775,7 +1770,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    GFPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
-		ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFPN_ID_CMD,
+		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GFPN_ID_CMD,
 		    GFPN_ID_RSP_SIZE);
 		ct_rsp = &ha->ct_sns->p.rsp;
 
@@ -1842,18 +1837,18 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *vha, uint32_t req_size,
 
 
 static inline struct ct_sns_req *
-qla24xx_prep_ct_fm_req(struct ct_sns_req *ct_req, uint16_t cmd,
+qla24xx_prep_ct_fm_req(struct ct_sns_pkt *p, uint16_t cmd,
     uint16_t rsp_size)
 {
-	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
+	memset(p, 0, sizeof(struct ct_sns_pkt));
 
-	ct_req->header.revision = 0x01;
-	ct_req->header.gs_type = 0xFA;
-	ct_req->header.gs_subtype = 0x01;
-	ct_req->command = cpu_to_be16(cmd);
-	ct_req->max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
+	p->p.req.header.revision = 0x01;
+	p->p.req.header.gs_type = 0xFA;
+	p->p.req.header.gs_subtype = 0x01;
+	p->p.req.command = cpu_to_be16(cmd);
+	p->p.req.max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
 
-	return ct_req;
+	return &p->p.req;
 }
 
 /**
@@ -1889,8 +1884,8 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 		    GPSC_RSP_SIZE);
 
 		/* Prepare CT request */
-		ct_req = qla24xx_prep_ct_fm_req(&ha->ct_sns->p.req,
-		    GPSC_CMD, GPSC_RSP_SIZE);
+		ct_req = qla24xx_prep_ct_fm_req(ha->ct_sns, GPSC_CMD,
+		    GPSC_RSP_SIZE);
 		ct_rsp = &ha->ct_sns->p.rsp;
 
 		/* Prepare CT arguments -- port_name */
@@ -2000,7 +1995,7 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    GFF_ID_RSP_SIZE);
 
 		/* Prepare CT request */
-		ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFF_ID_CMD,
+		ct_req = qla2x00_prep_ct_req(ha->ct_sns, GFF_ID_CMD,
 		    GFF_ID_RSP_SIZE);
 		ct_rsp = &ha->ct_sns->p.rsp;
 
-- 
1.7.7


