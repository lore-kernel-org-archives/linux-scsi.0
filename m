From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v2 PATCH 1/5] libfc: introduce LLD event callback
Date: Thu, 23 Dec 2010 22:02:31 -0800
Message-ID: <1293170551.4676.571.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3689 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab0LXGDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 01:03:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu

This patch enables LLD to listen to rport events and perform LLD
specific operations based on the rport event. This patch also stores
sp_features and spp_type in rdata for further reference by LLD.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/libfc/fc_npiv.c  |    1 +
 drivers/scsi/libfc/fc_rport.c |   19 ++++++++++++++++++-
 include/scsi/libfc.h          |   15 +++++++++++++++
 3 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index dd2b43b..076cd5f 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -86,6 +86,7 @@ struct fc_lport *fc_vport_id_lookup(struct fc_lport *n_port, u32 port_id)
 
 	return lport;
 }
+EXPORT_SYMBOL(fc_vport_id_lookup);
 
 /*
  * When setting the link state of vports during an lport state change, it's
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a7175ad..2f12f5c 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -145,8 +145,10 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
-	if (port_id != FC_FID_DIR_SERV)
+	if (port_id != FC_FID_DIR_SERV) {
+		rdata->lld_event_callback = lport->tt.rport_event_callback;
 		list_add_rcu(&rdata->peers, &lport->disc.rports);
+	}
 	return rdata;
 }
 
@@ -300,6 +302,10 @@ static void fc_rport_work(struct work_struct *work)
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
 		}
+		if (rdata->lld_event_callback) {
+			FC_RPORT_DBG(rdata, "lld callback ev %d\n", event);
+			rdata->lld_event_callback(lport, rdata, event);
+		}
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 		break;
 
@@ -313,6 +319,10 @@ static void fc_rport_work(struct work_struct *work)
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
 		}
+		if (rdata->lld_event_callback) {
+			FC_RPORT_DBG(rdata, "lld callback ev %d\n", event);
+			rdata->lld_event_callback(lport, rdata, event);
+		}
 		cancel_delayed_work_sync(&rdata->retry_work);
 
 		/*
@@ -878,6 +888,9 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rdata->ids.port_name = get_unaligned_be64(&plp->fl_wwpn);
 		rdata->ids.node_name = get_unaligned_be64(&plp->fl_wwnn);
 
+		/* save plogi response sp_features for further reference */
+		rdata->sp_features = ntohs(plp->fl_csp.sp_features);
+
 		if (lport->point_to_multipoint)
 			fc_rport_login_complete(rdata, fp);
 		csp_seq = ntohs(plp->fl_csp.sp_tot_seq);
@@ -983,6 +996,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
 		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x\n",
 			     pp->spp.spp_flags);
+		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
 				fc_rport_error(rdata, fp);
@@ -996,6 +1010,8 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fcp_parm = ntohl(pp->spp.spp_params);
 		if (fcp_parm & FCP_SPPF_RETRY)
 			rdata->flags |= FC_RP_FLAGS_RETRY;
+		if (fcp_parm & FCP_SPPF_CONF_COMPL)
+			rdata->flags |= FC_RP_FLAGS_CONF_REQ;
 
 		rdata->supported_classes = FC_COS_CLASS3;
 		if (fcp_parm & FCP_SPPF_INIT_FCN)
@@ -1688,6 +1704,7 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	 */
 	spp = &pp->spp;
 	while (len >= plen) {
+		rdata->spp_type = rspp->spp_type;
 		spp->spp_type = rspp->spp_type;
 		spp->spp_type_ext = rspp->spp_type_ext;
 		spp->spp_flags = rspp->spp_flags & FC_SPP_EST_IMG_PAIR;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 8d719e8..c1b613a 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -156,6 +156,7 @@ struct fc_rport_libfc_priv {
 	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
 	#define FC_RP_FLAGS_RETRY		(1 << 1)
 	#define FC_RP_STARTED			(1 << 2)
+	#define FC_RP_FLAGS_CONF_REQ		(1 << 3)
 	unsigned int	           e_d_tov;
 	unsigned int	           r_a_tov;
 };
@@ -203,6 +204,11 @@ struct fc_rport_priv {
 	struct work_struct          event_work;
 	u32			    supported_classes;
 	struct rcu_head		    rcu;
+	u16			    sp_features;
+	u8			    spp_type;
+	void			    (*lld_event_callback)(struct fc_lport *,
+						      struct fc_rport_priv *,
+						      enum fc_rport_event);
 };
 
 /**
@@ -656,6 +662,15 @@ struct libfc_function_template {
 	void (*rport_destroy)(struct kref *);
 
 	/*
+	 * Callback routine after the remote port is logged in
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	void (*rport_event_callback)(struct fc_lport *,
+				     struct fc_rport_priv *,
+				     enum fc_rport_event);
+
+	/*
 	 * Send a fcp cmd from fsp pkt.
 	 * Called with the SCSI host lock unlocked and irqs disabled.
 	 *
-- 
1.7.0.6




