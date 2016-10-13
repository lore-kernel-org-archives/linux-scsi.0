From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/24] libfc: Rework PRLI handling
Date: Thu, 13 Oct 2016 15:10:46 +0200
Message-ID: <1476364260-12191-11-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755519AbcJMNXs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:48 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

PRLI is only required if the port is acting as an initiator; ports
which support target functionality only do not need to send PRLI.
At the same time the PRLI state is only used if the port initiated
a PRLI transfer; if we received a PRLI request we should _not_
change the state as this would cause our PRLI response to be dropped.
And when we receive a PRLI response we need to check if an image
pair has been established; if not the remote port cannot act as a
target for us and we need to disable target functionality.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 56 +++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 426c399..2b8214f 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1126,7 +1126,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 	u32 fcp_parm = 0;
 	u8 op;
-	u8 resp_code = 0;
+	enum fc_els_spp_resp resp_code;
 
 	FC_RPORT_DBG(rdata, "Received a PRLI %s\n", fc_els_resp_type(fp));
 
@@ -1158,8 +1158,8 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 			goto out;
 
 		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
-		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x\n",
-			     pp->spp.spp_flags);
+		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x spp_type 0x%x\n",
+			     pp->spp.spp_flags, pp->spp.spp_type);
 		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
@@ -1177,13 +1177,26 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		if (fcp_parm & FCP_SPPF_CONF_COMPL)
 			rdata->flags |= FC_RP_FLAGS_CONF_REQ;
 
-		prov = fc_passive_prov[FC_TYPE_FCP];
+		/*
+		 * Call prli provider if we should act as a target
+		 */
+		prov = fc_passive_prov[rdata->spp_type];
 		if (prov) {
 			memset(&temp_spp, 0, sizeof(temp_spp));
 			prov->prli(rdata, pp->prli.prli_spp_len,
 				   &pp->spp, &temp_spp);
 		}
-
+		/*
+		 * Check if the image pair could be established
+		 */
+		if (rdata->spp_type != FC_TYPE_FCP ||
+		    resp_code != FC_SPP_RESP_ACK ||
+		    !(pp->spp.spp_flags & FC_SPP_EST_IMG_PAIR)) {
+			/*
+			 * Nope; we can't use this port as a target.
+			 */
+			fcp_parm &= ~FCP_SPPF_TARG_FCN;
+		}
 		rdata->supported_classes = FC_COS_CLASS3;
 		if (fcp_parm & FCP_SPPF_INIT_FCN)
 			roles |= FC_RPORT_ROLE_FCP_INITIATOR;
@@ -1236,6 +1249,15 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 		return;
 	}
 
+	/*
+	 * And if the local port does not support the initiator function
+	 * there's no need to send a PRLI, either.
+	 */
+	if (!(lport->service_params & FCP_SPPF_INIT_FCN)) {
+		    fc_rport_enter_ready(rdata);
+		    return;
+	}
+
 	FC_RPORT_DBG(rdata, "Port entered PRLI state from %s state\n",
 		     fc_rport_state(rdata));
 
@@ -1926,7 +1948,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	unsigned int len;
 	unsigned int plen;
 	enum fc_els_spp_resp resp;
-	enum fc_els_spp_resp passive;
 	struct fc_seq_els_data rjt_data;
 	struct fc4_prov *prov;
 
@@ -1976,15 +1997,21 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 		resp = 0;
 
 		if (rspp->spp_type < FC_FC4_PROV_SIZE) {
+			enum fc_els_spp_resp active = 0, passive = 0;
+
 			prov = fc_active_prov[rspp->spp_type];
 			if (prov)
-				resp = prov->prli(rdata, plen, rspp, spp);
+				active = prov->prli(rdata, plen, rspp, spp);
 			prov = fc_passive_prov[rspp->spp_type];
-			if (prov) {
+			if (prov)
 				passive = prov->prli(rdata, plen, rspp, spp);
-				if (!resp || passive == FC_SPP_RESP_ACK)
-					resp = passive;
-			}
+			if (!active || passive == FC_SPP_RESP_ACK)
+				resp = passive;
+			else
+				resp = active;
+			FC_RPORT_DBG(rdata, "PRLI rspp type %x "
+				     "active %x passive %x\n",
+				     rspp->spp_type, active, passive);
 		}
 		if (!resp) {
 			if (spp->spp_flags & FC_SPP_EST_IMG_PAIR)
@@ -2005,13 +2032,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
 	lport->tt.frame_send(lport, fp);
 
-	switch (rdata->rp_state) {
-	case RPORT_ST_PRLI:
-		fc_rport_enter_ready(rdata);
-		break;
-	default:
-		break;
-	}
 	goto drop;
 
 reject_len:
-- 
1.8.5.6

