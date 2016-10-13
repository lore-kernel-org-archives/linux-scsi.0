From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/24] libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
Date: Thu, 13 Oct 2016 15:10:47 +0200
Message-ID: <1476364260-12191-12-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40747 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755563AbcJMNXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:47 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Occasionally it might happen that we receive a PRLI while we're still
waiting for our PLOGI response. In that case we should return
'busy' LS status instead of 'plogi required' LS status.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 2b8214f..a867874 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1705,6 +1705,15 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
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
@@ -1752,6 +1761,14 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
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

