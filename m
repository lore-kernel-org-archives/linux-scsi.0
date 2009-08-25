From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 40/64] libfc: change to make remote port callback optional
Date: Tue, 25 Aug 2009 14:02:01 -0700
Message-ID: <20090825210201.1553.45113.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbZHYVCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:13 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Since the rport list maintenance is now done in the rport module,
the callback (and ops) are usually not necessary.

Allow rdata->ops to be left NULL if nothing needs
to be done in an event callback.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   45 +++--------------------------------------
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 2 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 266aa1e..3fcbba1 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -92,37 +92,6 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_rport_callback() - Event handler for rport events
- * @lport: The lport which is receiving the event
- * @rdata: private remote port data
- * @event: The event that occured
- *
- * Locking Note: The rport lock should not be held when calling
- *		 this function.
- */
-static void fc_disc_rport_callback(struct fc_lport *lport,
-				   struct fc_rport_priv *rdata,
-				   enum fc_rport_event event)
-{
-	struct fc_disc *disc = &lport->disc;
-
-	FC_DISC_DBG(disc, "Received a %d event for port (%6x)\n", event,
-		    rdata->ids.port_id);
-
-	switch (event) {
-	case RPORT_EV_READY:
-		break;
-	case RPORT_EV_LOGO:
-	case RPORT_EV_FAILED:
-	case RPORT_EV_STOP:
-		break;
-	default:
-		break;
-	}
-
-}
-
-/**
  * fc_disc_recv_rscn_req() - Handle Registered State Change Notification (RSCN)
  * @sp: Current sequence of the RSCN exchange
  * @fp: RSCN Frame
@@ -334,10 +303,6 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 	mutex_unlock(&disc->disc_mutex);
 }
 
-static struct fc_rport_operations fc_disc_rport_ops = {
-	.event_callback = fc_disc_rport_callback,
-};
-
 /**
  * fc_disc_new_target() - Handle new target found by discovery
  * @lport: FC local port
@@ -381,10 +346,8 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			if (!rdata)
 				error = -ENOMEM;
 		}
-		if (rdata) {
-			rdata->ops = &fc_disc_rport_ops;
+		if (rdata)
 			lport->tt.rport_login(rdata);
-		}
 	}
 	return error;
 }
@@ -551,10 +514,9 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		if (ids.port_id != fc_host_port_id(lport->host) &&
 		    ids.port_name != lport->wwpn) {
 			rdata = lport->tt.rport_create(lport, &ids);
-			if (rdata) {
-				rdata->ops = &fc_disc_rport_ops;
+			if (rdata)
 				lport->tt.rport_login(rdata);
-			} else
+			else
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
 				       "(%6x)\n", ids.port_id);
@@ -697,7 +659,6 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 
 	rdata = lport->tt.rport_create(lport, &dp->ids);
 	if (rdata) {
-		rdata->ops = &fc_disc_rport_ops;
 		kfree(dp);
 		lport->tt.rport_login(rdata);
 	}
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 29bb6fd..406049c 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -250,7 +250,7 @@ static void fc_rport_work(struct work_struct *work)
 		rp->r_a_tov = rdata->r_a_tov;
 		mutex_unlock(&rdata->rp_mutex);
 
-		if (rport_ops->event_callback) {
+		if (rport_ops && rport_ops->event_callback) {
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
 		}
@@ -269,7 +269,7 @@ static void fc_rport_work(struct work_struct *work)
 			mutex_unlock(&lport->disc.disc_mutex);
 		}
 
-		if (rport_ops->event_callback) {
+		if (rport_ops && rport_ops->event_callback) {
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
 		}

