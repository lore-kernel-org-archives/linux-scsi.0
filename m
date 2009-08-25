From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 37/64] libfc: simplify fc_lport_rport_callback
Date: Tue, 25 Aug 2009 14:01:44 -0700
Message-ID: <20090825210144.1553.17750.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27829 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105AbZHYVBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:43 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The lport rport callback can only be called for the dNS rport,
since its the only rport who's ops point to that function.

Remove unnecessary checking and debug messages.
Put the locking outside the switch statement as a simplification.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   43 ++++++++++++++---------------------------
 1 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 016f771..22c0f7b 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -146,44 +146,31 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 	FC_LPORT_DBG(lport, "Received a %d event for port (%6x)\n", event,
 		     rdata->ids.port_id);
 
+	mutex_lock(&lport->lp_mutex);
 	switch (event) {
 	case RPORT_EV_READY:
-		if (rdata->ids.port_id == FC_FID_DIR_SERV) {
-			mutex_lock(&lport->lp_mutex);
-			if (lport->state == LPORT_ST_DNS) {
-				lport->dns_rp = rdata;
-				fc_lport_enter_rpn_id(lport);
-			} else {
-				FC_LPORT_DBG(lport, "Received an READY event "
-					     "on port (%6x) for the directory "
-					     "server, but the lport is not "
-					     "in the DNS state, it's in the "
-					     "%d state", rdata->ids.port_id,
-					     lport->state);
-				lport->tt.rport_logoff(rdata);
-			}
-			mutex_unlock(&lport->lp_mutex);
-		} else
-			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
-				     "which is not the directory server\n",
-				     rdata->ids.port_id);
+		if (lport->state == LPORT_ST_DNS) {
+			lport->dns_rp = rdata;
+			fc_lport_enter_rpn_id(lport);
+		} else {
+			FC_LPORT_DBG(lport, "Received an READY event "
+				     "on port (%6x) for the directory "
+				     "server, but the lport is not "
+				     "in the DNS state, it's in the "
+				     "%d state", rdata->ids.port_id,
+				     lport->state);
+			lport->tt.rport_logoff(rdata);
+		}
 		break;
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
 	case RPORT_EV_STOP:
-		if (rdata->ids.port_id == FC_FID_DIR_SERV) {
-			mutex_lock(&lport->lp_mutex);
-			lport->dns_rp = NULL;
-			mutex_unlock(&lport->lp_mutex);
-
-		} else
-			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
-				     "which is not the directory server\n",
-				     rdata->ids.port_id);
+		lport->dns_rp = NULL;
 		break;
 	case RPORT_EV_NONE:
 		break;
 	}
+	mutex_unlock(&lport->lp_mutex);
 }
 
 /**

