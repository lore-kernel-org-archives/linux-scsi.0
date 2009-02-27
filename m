From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/24] libfc: when rport goes away (re-plogi),
	clean up exchanges to/from rport
Date: Fri, 27 Feb 2009 10:54:41 -0800
Message-ID: <20090227185441.25509.8577.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42188 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbZB0Sym (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:54:42 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Abhijeet Joglekar <abjoglek@cisco.com>

When a rport goes away, libFC does a plogi which will reset exchanges
    at the rport. Clean exchanges at our end, both in transport and libFC.
    If transport hooks into exch_mgr_reset, it will call back into
    fc_exch_mgr_reset() to clean up libFC exchanges.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index dec7bae..7175759 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -214,6 +214,7 @@ static void fc_rport_state_enter(struct fc_rport *rport,
 
 static void fc_rport_work(struct work_struct *work)
 {
+	u32 port_id;
 	struct fc_rport_libfc_priv *rdata =
 		container_of(work, struct fc_rport_libfc_priv, event_work);
 	enum fc_rport_event event;
@@ -279,8 +280,12 @@ static void fc_rport_work(struct work_struct *work)
 			rport_ops->event_callback(lport, rport, event);
 		if (trans_state == FC_PORTSTATE_ROGUE)
 			put_device(&rport->dev);
-		else
+		else {
+			port_id = rport->port_id;
 			fc_remote_port_delete(rport);
+			lport->tt.exch_mgr_reset(lport, 0, port_id);
+			lport->tt.exch_mgr_reset(lport, port_id, 0);
+		}
 	} else
 		mutex_unlock(&rdata->rp_mutex);
 }

