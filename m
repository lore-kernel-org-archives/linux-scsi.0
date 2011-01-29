From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/28] libfc: use PRLI hook to get parameters when sending
	outgoing PRLI
Date: Fri, 28 Jan 2011 16:04:23 -0800
Message-ID: <20110129000423.1784.77442.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56994 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab1A2AEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:24 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When sending an outgoing PRLI as an initiator, get the parameters
from registered providers so that they all get a chance to decide
on roles.

The passive provider is called last, and could override the
initiator role.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a92954c..9ded612 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -961,6 +961,8 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		struct fc_els_prli prli;
 		struct fc_els_spp spp;
 	} *pp;
+	struct fc_els_spp temp_spp;
+	struct fc4_prov *prov;
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 	u32 fcp_parm = 0;
 	u8 op;
@@ -1009,6 +1011,13 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		if (fcp_parm & FCP_SPPF_RETRY)
 			rdata->flags |= FC_RP_FLAGS_RETRY;
 
+		prov = fc_passive_prov[FC_TYPE_FCP];
+		if (prov) {
+			memset(&temp_spp, 0, sizeof(temp_spp));
+			prov->prli(rdata, pp->prli.prli_spp_len,
+				   &pp->spp, &temp_spp);
+		}
+
 		rdata->supported_classes = FC_COS_CLASS3;
 		if (fcp_parm & FCP_SPPF_INIT_FCN)
 			roles |= FC_RPORT_ROLE_FCP_INITIATOR;
@@ -1045,6 +1054,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 		struct fc_els_spp spp;
 	} *pp;
 	struct fc_frame *fp;
+	struct fc4_prov *prov;
 
 	/*
 	 * If the rport is one of the well known addresses
@@ -1066,9 +1076,20 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_PRLI,
-				  fc_rport_prli_resp, rdata,
-				  2 * lport->r_a_tov))
+	fc_prli_fill(lport, fp);
+
+	prov = fc_passive_prov[FC_TYPE_FCP];
+	if (prov) {
+		pp = fc_frame_payload_get(fp, sizeof(*pp));
+		prov->prli(rdata, sizeof(pp->spp), NULL, &pp->spp);
+	}
+
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rdata->ids.port_id,
+		       fc_host_port_id(lport->host), FC_TYPE_ELS,
+		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+
+	if (!lport->tt.exch_seq_send(lport, fp, fc_rport_prli_resp,
+				    NULL, rdata, 2 * lport->r_a_tov))
 		fc_rport_error_retry(rdata, NULL);
 	else
 		kref_get(&rdata->kref);

