From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 49/64] libfc: clean up point-to-point discovery code.
Date: Tue, 25 Aug 2009 14:02:49 -0700
Message-ID: <20090825210249.1553.49289.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093AbZHYVCr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:47 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The discovery code had a special-case for the point-to-point mode,
which used a bunch of code that wasn't really needed.

Now that rport_create adds the rport to the discovery list,
completely skip discovery for the point-to-point case.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   84 +----------------------------------------
 drivers/scsi/libfc/fc_lport.c |   13 +-----
 2 files changed, 4 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index a2410dc..4284218 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -45,8 +45,6 @@
 
 static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
-static int fc_disc_new_target(struct fc_disc *, struct fc_rport_priv *,
-			      struct fc_rport_identifiers *);
 static void fc_disc_done(struct fc_disc *, enum fc_disc_event);
 static void fc_disc_timeout(struct work_struct *);
 static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
@@ -240,14 +238,12 @@ static void fc_disc_restart(struct fc_disc *disc)
 /**
  * fc_disc_start() - Fibre Channel Target discovery
  * @lport: FC local port
- *
- * Returns non-zero if discovery cannot be started.
+ * @disc_callback: function to be called when discovery is complete
  */
 static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 						enum fc_disc_event),
 			  struct fc_lport *lport)
 {
-	struct fc_rport_priv *rdata;
 	struct fc_disc *disc = &lport->disc;
 
 	/*
@@ -256,88 +252,12 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 	 * and send the GPN_FT request.
 	 */
 	mutex_lock(&disc->disc_mutex);
-
 	disc->disc_callback = disc_callback;
-
-	/*
-	 * If not ready, or already running discovery, just set request flag.
-	 */
-	disc->requested = 1;
-
-	if (disc->pending) {
-		mutex_unlock(&disc->disc_mutex);
-		return;
-	}
-
-	/*
-	 * Handle point-to-point mode as a simple discovery
-	 * of the remote port. Yucky, yucky, yuck, yuck!
-	 */
-	rdata = disc->lport->ptp_rp;
-	if (rdata) {
-		kref_get(&rdata->kref);
-		if (!fc_disc_new_target(disc, rdata, &rdata->ids)) {
-			fc_disc_done(disc, DISC_EV_SUCCESS);
-		}
-		kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
-	} else {
-		disc->disc_id = (disc->disc_id + 2) | 1;
-		fc_disc_gpn_ft_req(disc);	/* get ports by FC-4 type */
-	}
-
+	fc_disc_restart(disc);
 	mutex_unlock(&disc->disc_mutex);
 }
 
 /**
- * fc_disc_new_target() - Handle new target found by discovery
- * @lport: FC local port
- * @rdata: The previous FC remote port priv (NULL if new remote port)
- * @ids: Identifiers for the new FC remote port
- *
- * Locking Note: This function expects that the disc_mutex is locked
- *		 before it is called.
- */
-static int fc_disc_new_target(struct fc_disc *disc,
-			      struct fc_rport_priv *rdata,
-			      struct fc_rport_identifiers *ids)
-{
-	struct fc_lport *lport = disc->lport;
-	int error = 0;
-
-	if (rdata && ids->port_name) {
-		if (rdata->ids.port_name == -1) {
-			/*
-			 * Set WWN and fall through to notify of create.
-			 */
-			rdata->ids.port_name = ids->port_name;
-			rdata->ids.node_name = ids->node_name;
-		} else if (rdata->ids.port_name != ids->port_name) {
-			/*
-			 * This is a new port with the same FCID as
-			 * a previously-discovered port.  Presumably the old
-			 * port logged out and a new port logged in and was
-			 * assigned the same FCID.  This should be rare.
-			 * Delete the old one and fall thru to re-create.
-			 */
-			lport->tt.rport_logoff(rdata);
-			rdata = NULL;
-		}
-	}
-	if (((ids->port_name != -1) || (ids->port_id != -1)) &&
-	    ids->port_id != fc_host_port_id(lport->host) &&
-	    ids->port_name != lport->wwpn) {
-		if (!rdata) {
-			rdata = lport->tt.rport_create(lport, ids);
-			if (!rdata)
-				error = -ENOMEM;
-		}
-		if (rdata)
-			lport->tt.rport_login(rdata);
-	}
-	return error;
-}
-
-/**
  * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
  * @event: discovery completion status
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index f33e573..7000df5 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -708,7 +708,8 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
 
-	lport->tt.disc_start(fc_lport_disc_callback, lport);
+	if (!lport->ptp_rp)
+		lport->tt.disc_start(fc_lport_disc_callback, lport);
 }
 
 /**
@@ -794,8 +795,6 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	fc_lport_ptp_setup(lport, remote_fid, remote_wwpn,
 			   get_unaligned_be64(&flp->fl_wwnn));
 
-	lport->tt.disc_start(fc_lport_disc_callback, lport);
-
 out:
 	sp = fr_seq(rx_fp);
 	fc_frame_free(rx_fp);
@@ -1512,14 +1511,6 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				fc_lport_enter_dns(lport);
 			}
 		}
-
-		if (flp) {
-			csp_flags = ntohs(flp->fl_csp.sp_features);
-			if ((csp_flags & FC_SP_FT_FPORT) == 0) {
-				lport->tt.disc_start(fc_lport_disc_callback,
-						     lport);
-			}
-		}
 	} else {
 		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
 	}

