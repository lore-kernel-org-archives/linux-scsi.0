From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/22] libfc: Implement RTV responder
Date: Wed,  3 Aug 2016 15:13:19 +0200
Message-ID: <1470230002-37737-20-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbcHCNNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:36 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The libfc stack generates an RTV request, so we should be implementing
an RTV responder, too.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6a25771..7fb6685 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1330,6 +1330,40 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 }
 
 /**
+ * fc_rport_recv_rtv_req() - Handler for Read Timeout Value (RTV) requests
+ * @rdata: The remote port that sent the RTV request
+ * @in_fp: The RTV request frame
+ *
+ * Locking Note:  Called with the lport and rport locks held.
+ */
+static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
+				  struct fc_frame *in_fp)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+	struct fc_els_rtv_acc *rtv;
+	struct fc_seq_els_data rjt_data;
+
+	FC_RPORT_DBG(rdata, "Received RTV request\n");
+
+	fp = fc_frame_alloc(lport, sizeof(*rtv));
+	if (!fp) {
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.reason = ELS_EXPL_INSUF_RES;
+		lport->tt.seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
+		goto drop;
+	}
+	rtv = fc_frame_payload_get(fp, sizeof(*rtv));
+	rtv->rtv_cmd = ELS_LS_ACC;
+	rtv->rtv_r_a_tov = lport->r_a_tov;
+	rtv->rtv_e_d_tov = lport->e_d_tov;
+	fc_fill_reply_hdr(fp, in_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
+drop:
+	fc_frame_free(in_fp);
+}
+
+/**
  * fc_rport_logo_resp() - Handler for logout (LOGO) responses
  * @sp:	       The sequence the LOGO was on
  * @fp:	       The LOGO response frame
@@ -1627,6 +1661,9 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	case ELS_RLS:
 		fc_rport_recv_rls_req(rdata, fp);
 		break;
+	case ELS_RTV:
+		fc_rport_recv_rtv_req(rdata, fp);
+		break;
 	default:
 		fc_frame_free(fp);	/* can't happen */
 		break;
-- 
1.8.5.6

