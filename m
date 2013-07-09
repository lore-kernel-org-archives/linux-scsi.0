From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/8] libfc: Reject PLOGI from nodes with incompatible role
Date: Tue, 09 Jul 2013 12:47:10 -0700
Message-ID: <20130709194710.10724.48550.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46894 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab3GITrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:13 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Mark Rustad <mark.d.rustad@intel.com>, Yi Zou <yi.zou@intel.com>

From: Mark Rustad <mark.d.rustad@intel.com>

Reject a PLOGI from a node with an incompatible role,
that is, initiator-to-initiator or target-to-target.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Yi Zou <yi.zou@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6bbb944..c710d90 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -926,6 +926,20 @@ err:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
+static bool
+fc_rport_compatible_roles(struct fc_lport *lport, struct fc_rport_priv *rdata)
+{
+	if (rdata->ids.roles == FC_PORT_ROLE_UNKNOWN)
+		return true;
+	if ((rdata->ids.roles & FC_PORT_ROLE_FCP_TARGET) &&
+	    (lport->service_params & FCP_SPPF_INIT_FCN))
+		return true;
+	if ((rdata->ids.roles & FC_PORT_ROLE_FCP_INITIATOR) &&
+	    (lport->service_params & FCP_SPPF_TARG_FCN))
+		return true;
+	return false;
+}
+
 /**
  * fc_rport_enter_plogi() - Send Port Login (PLOGI) request
  * @rdata: The remote port to send a PLOGI to
@@ -938,6 +952,12 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
+	if (!fc_rport_compatible_roles(lport, rdata)) {
+		FC_RPORT_DBG(rdata, "PLOGI suppressed for incompatible role\n");
+		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
+		return;
+	}
+
 	FC_RPORT_DBG(rdata, "Port entered PLOGI state from %s state\n",
 		     fc_rport_state(rdata));
 
@@ -1646,6 +1666,13 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		rjt_data.explan = ELS_EXPL_NONE;
 		goto reject;
 	}
+	if (!fc_rport_compatible_roles(lport, rdata)) {
+		FC_RPORT_DBG(rdata, "Received PLOGI for incompatible role\n");
+		mutex_unlock(&rdata->rp_mutex);
+		rjt_data.reason = ELS_RJT_LOGIC;
+		rjt_data.explan = ELS_EXPL_NONE;
+		goto reject;
+	}
 
 	/*
 	 * Get session payload size from incoming PLOGI.

