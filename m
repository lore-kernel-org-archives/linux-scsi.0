From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/30] libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
Date: Fri, 26 Aug 2016 14:01:38 +0200
Message-ID: <1472212913-39810-16-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752230AbcHZMCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:11 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Occasionally it might happen that we receive a PRLI while we're still
waiting for our PLOGI response. In that case we should return
'busy' LS status instead of 'plogi required' LS status.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 69c93c7..68d4c92 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1691,6 +1691,15 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	case RPORT_ST_READY:
 	case RPORT_ST_ADISC:
 		break;
+	case RPORT_ST_PLOGI:
+		if (fc_frame_payload_op(fp) == ELS_PRLI) {
+			FC_RPORT_DBG(rdata, "Reject ELS PRLI "
+				     "while in state %s\n",
+				     fc_rport_state(rdata));
+			mutex_unlock(&rdata->rp_mutex);
+			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			goto busy;
+		}
 	default:
 		FC_RPORT_DBG(rdata,
 			     "Reject ELS 0x%02x while in state %s\n",
@@ -1738,6 +1747,14 @@ reject:
 	els_data.explan = ELS_EXPL_PLOGI_REQD;
 	lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &els_data);
 	fc_frame_free(fp);
+	return;
+
+busy:
+	els_data.reason = ELS_RJT_BUSY;
+	els_data.explan = ELS_EXPL_NONE;
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &els_data);
+	fc_frame_free(fp);
+	return;
 }
 
 /**
-- 
1.8.5.6

