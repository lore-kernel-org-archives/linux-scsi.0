From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 58/64] libfc: re-login to remote ports that send us LOGO
Date: Tue, 25 Aug 2009 14:03:36 -0700
Message-ID: <20090825210336.1553.3151.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34695 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbZHYVDe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:34 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

After a quick link flap, a target was seen to send us a LOGO.
Apparently, it saw an RSCN reporting that we had dropped out of the
fabric after we had logged back into it.

This is likely in larger fabrics (more than 2 FC switches) after
a quick link flap at the initiator.  Each link transition causes
an port-specific RSCN to the target.  After the link comes back up,
the initiator successfully discovers and does a PLOGI to the target
before the target sees the first RSCN reporting the initiator is gone,
and it sends a LOGO.  The target may see a subsequent RSCN saying the
port is back, but probably wouldn't send a PLOGI and leaves it
up to the initiator to re-login.

An RSCN can be delayed by the switches due to software layers but a
PLOGI is forwarded in hardware causing the PLOGI to beat the RSCN.

If a remote port is in the discovered set and sends a LOGO, re-login to it.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 04e9846..dc97c60 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1340,6 +1340,8 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport,
 	struct fc_rport_priv *rdata;
 	u32 sid;
 
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+
 	fh = fc_frame_header_get(fp);
 	sid = ntoh24(fh->fh_s_id);
 
@@ -1349,13 +1351,20 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport,
 		mutex_lock(&rdata->rp_mutex);
 		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
 			     fc_rport_state(rdata));
-		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
+
+		/*
+		 * If the remote port was created due to discovery,
+		 * log back in.  It may have seen a stale RSCN about us.
+		 */
+		if (rdata->rp_state != RPORT_ST_DELETE && rdata->disc_id)
+			fc_rport_enter_plogi(rdata);
+		else
+			fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
 		mutex_unlock(&rdata->rp_mutex);
 	} else
 		FC_RPORT_ID_DBG(lport, sid,
 				"Received LOGO from non-logged-in port\n");
 	mutex_unlock(&lport->disc.disc_mutex);
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);
 }
 

