From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/30] libfc: Implement RTV responder
Date: Fri, 26 Aug 2016 14:01:36 +0200
Message-ID: <1472212913-39810-14-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35186 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbcHZMCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:11 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The libfc stack generates an RTV request, so we should be implementing
an RTV responder, too.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d392d45..a76f29d 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1258,7 +1258,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 }
 
 /**
- * fc_rport_els_rtv_resp() - Handler for Request Timeout Value (RTV) responses
+ * fc_rport_rtv_resp() - Handler for Request Timeout Value (RTV) responses
  * @sp:	       The sequence the RTV was on
  * @fp:	       The RTV response frame
  * @rdata_arg: The remote port that sent the RTV response
@@ -1358,6 +1358,41 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
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
+	rtv->rtv_r_a_tov = htonl(lport->r_a_tov);
+	rtv->rtv_e_d_tov = htonl(lport->e_d_tov);
+	rtv->rtv_toq = 0;
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
@@ -1662,6 +1697,9 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	case ELS_RLS:
 		fc_rport_recv_rls_req(rdata, fp);
 		break;
+	case ELS_RTV:
+		fc_rport_recv_rtv_req(rdata, fp);
+		break;
 	default:
 		fc_frame_free(fp);	/* can't happen */
 		break;
@@ -1713,6 +1751,7 @@ static void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 	case ELS_RRQ:
 	case ELS_REC:
 	case ELS_RLS:
+	case ELS_RTV:
 		fc_rport_recv_els_req(lport, fp);
 		break;
 	default:
-- 
1.8.5.6

