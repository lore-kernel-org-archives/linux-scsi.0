From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/17] libfc: Fix remote port restart problem
Date: Fri, 11 Jun 2010 16:44:51 -0700
Message-ID: <20100611234451.4616.92234.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760253Ab0FKXoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:55 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Bhanu Gollapudi <bprakash@broadcom.com>

From: Joe Eykholt <jeykholt@cisco.com>

This patch somewhat combines two fixes to remote port handing in libfc.

The first problem was that rport work could be queued on a deleted
and freed rport.  This is handled by not resetting rdata->event
ton NONE if the rdata is about to be deleted.

However, that fix led to the second problem, described by
Bhanu Gollapudi, as follows:
> Here is the sequence of events. T1 is first LOGO receive thread, T2 is
> fc_rport_work() scheduled by T1 and T3 is second LOGO receive thread and
> T4 is fc_rport_work scheduled by T3.
>
> 1. (T1)Received 1st LOGO in state Ready
> 2. (T1)Delete port & enter to RESTART state.
> 3. (T1)schdule event_work, since event is RPORT_EV_NONE.
> 4. (T1)set event = RPORT_EV_LOGO
> 5. (T1)Enter RESTART state as disc_id is set.
> 6. (T2)remember to PLOGI, and set event = RPORT_EV_NONE
> 6. (T3)Received 2nd LOGO
> 7. (T3)Delete Port & enter to RESTART state.
> 8. (T3)schedule event_work, since event is RPORT_EV_NONE.
> 9. (T3)Enter RESTART state as disc_id is set.
> 9. (T3)set event = RPORT_EV_LOGO
> 10.(T2)work restart, enter PLOGI state and issues PLOGI
> 11.(T4)Since state is not RESTART anymore, restart is not set, and the
> event is not reset to RPORT_EV_NONE. (current event is RPORT_EV_LOGO).
> 12. Now, PLOGI succeeds and fc_rport_enter_ready() will not schedule
> event_work, and hence the rport will never be created, eventually losing
> the target after dev_loss_tmo.

So, the problem here is that we were tracking the desire for
the rport be restarted by state RESTART, which was otherwise
equivalent to DELETE.  A contributing factor is that we dropped
the lock between steps 6 and 10 in thread T2, which allows the
state to change, and we didn't completely re-evaluate then.

This is hopefully corrected by the following minor redesign:

Simplify the rport restart logic by making the decision to
restart after deleting the transport rport.  That decision
is based on a new STARTED flag that indicates fc_rport_login()
has been called and fc_rport_logoff() has not been called
since then.  This replaces the need for the RESTART state.

Only restart if the rdata is still in DELETED state
and only if it still has the STARTED flag set.

Also now, since we clear the event code much later in the
work thread, allow for the possibility that the rport may
have become READY again via incoming PLOGI, and if so,
queue another event to handle that.

In the problem scenario, the second LOGO received will
cause the LOGO event to occur again.

Reported-by: Bhanu Gollapudi <bprakash@broadcom.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |   75 +++++++++++++++++------------------------
 include/scsi/libfc.h          |    5 +--
 2 files changed, 33 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index df85e19..d385efc 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -89,7 +89,6 @@ static const char *fc_rport_state_names[] = {
 	[RPORT_ST_LOGO] = "LOGO",
 	[RPORT_ST_ADISC] = "ADISC",
 	[RPORT_ST_DELETE] = "Delete",
-	[RPORT_ST_RESTART] = "Restart",
 };
 
 /**
@@ -246,7 +245,6 @@ static void fc_rport_work(struct work_struct *work)
 	struct fc_rport_operations *rport_ops;
 	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
-	int restart = 0;
 
 	mutex_lock(&rdata->rp_mutex);
 	event = rdata->event;
@@ -298,24 +296,6 @@ static void fc_rport_work(struct work_struct *work)
 		port_id = rdata->ids.port_id;
 		mutex_unlock(&rdata->rp_mutex);
 
-		if (port_id != FC_FID_DIR_SERV) {
-			/*
-			 * We must drop rp_mutex before taking disc_mutex.
-			 * Re-evaluate state to allow for restart.
-			 * A transition to RESTART state must only happen
-			 * while disc_mutex is held and rdata is on the list.
-			 */
-			mutex_lock(&lport->disc.disc_mutex);
-			mutex_lock(&rdata->rp_mutex);
-			if (rdata->rp_state == RPORT_ST_RESTART)
-				restart = 1;
-			else
-				list_del(&rdata->peers);
-			rdata->event = RPORT_EV_NONE;
-			mutex_unlock(&rdata->rp_mutex);
-			mutex_unlock(&lport->disc.disc_mutex);
-		}
-
 		if (rport_ops && rport_ops->event_callback) {
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
@@ -336,13 +316,34 @@ static void fc_rport_work(struct work_struct *work)
 			mutex_unlock(&rdata->rp_mutex);
 			fc_remote_port_delete(rport);
 		}
-		if (restart) {
-			mutex_lock(&rdata->rp_mutex);
-			FC_RPORT_DBG(rdata, "work restart\n");
-			fc_rport_enter_plogi(rdata);
+
+		mutex_lock(&lport->disc.disc_mutex);
+		mutex_lock(&rdata->rp_mutex);
+		if (rdata->rp_state == RPORT_ST_DELETE) {
+			if (port_id == FC_FID_DIR_SERV) {
+				rdata->event = RPORT_EV_NONE;
+				mutex_unlock(&rdata->rp_mutex);
+			} else if (rdata->flags & FC_RP_STARTED) {
+				rdata->event = RPORT_EV_NONE;
+				FC_RPORT_DBG(rdata, "work restart\n");
+				fc_rport_enter_plogi(rdata);
+				mutex_unlock(&rdata->rp_mutex);
+			} else {
+				FC_RPORT_DBG(rdata, "work delete\n");
+				list_del(&rdata->peers);
+				mutex_unlock(&rdata->rp_mutex);
+				kref_put(&rdata->kref, lport->tt.rport_destroy);
+			}
+		} else {
+			/*
+			 * Re-open for events.  Reissue READY event if ready.
+			 */
+			rdata->event = RPORT_EV_NONE;
+			if (rdata->rp_state == RPORT_ST_READY)
+				fc_rport_enter_ready(rdata);
 			mutex_unlock(&rdata->rp_mutex);
-		} else
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+		}
+		mutex_unlock(&lport->disc.disc_mutex);
 		break;
 
 	default:
@@ -367,16 +368,14 @@ int fc_rport_login(struct fc_rport_priv *rdata)
 {
 	mutex_lock(&rdata->rp_mutex);
 
+	rdata->flags |= FC_RP_STARTED;
 	switch (rdata->rp_state) {
 	case RPORT_ST_READY:
 		FC_RPORT_DBG(rdata, "ADISC port\n");
 		fc_rport_enter_adisc(rdata);
 		break;
-	case RPORT_ST_RESTART:
-		break;
 	case RPORT_ST_DELETE:
 		FC_RPORT_DBG(rdata, "Restart deleted port\n");
-		fc_rport_state_enter(rdata, RPORT_ST_RESTART);
 		break;
 	default:
 		FC_RPORT_DBG(rdata, "Login to port\n");
@@ -431,15 +430,12 @@ int fc_rport_logoff(struct fc_rport_priv *rdata)
 
 	FC_RPORT_DBG(rdata, "Remove port\n");
 
+	rdata->flags &= ~FC_RP_STARTED;
 	if (rdata->rp_state == RPORT_ST_DELETE) {
 		FC_RPORT_DBG(rdata, "Port in Delete state, not removing\n");
 		goto out;
 	}
-
-	if (rdata->rp_state == RPORT_ST_RESTART)
-		FC_RPORT_DBG(rdata, "Port in Restart state, deleting\n");
-	else
-		fc_rport_enter_logo(rdata);
+	fc_rport_enter_logo(rdata);
 
 	/*
 	 * Change the state to Delete so that we discard
@@ -503,7 +499,6 @@ static void fc_rport_timeout(struct work_struct *work)
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
 	case RPORT_ST_DELETE:
-	case RPORT_ST_RESTART:
 		break;
 	}
 
@@ -527,6 +522,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
 	case RPORT_ST_LOGO:
+		rdata->flags &= ~FC_RP_STARTED;
 		fc_rport_enter_delete(rdata, RPORT_EV_FAILED);
 		break;
 	case RPORT_ST_RTV:
@@ -537,7 +533,6 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 		fc_rport_enter_logo(rdata);
 		break;
 	case RPORT_ST_DELETE:
-	case RPORT_ST_RESTART:
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
 		break;
@@ -1392,7 +1387,6 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		break;
 	case RPORT_ST_DELETE:
 	case RPORT_ST_LOGO:
-	case RPORT_ST_RESTART:
 		FC_RPORT_DBG(rdata, "Received PLOGI in state %s - send busy\n",
 			     fc_rport_state(rdata));
 		mutex_unlock(&rdata->rp_mutex);
@@ -1684,13 +1678,6 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport,
 			     fc_rport_state(rdata));
 
 		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
-
-		/*
-		 * If the remote port was created due to discovery, set state
-		 * to log back in.  It may have seen a stale RSCN about us.
-		 */
-		if (rdata->disc_id)
-			fc_rport_state_enter(rdata, RPORT_ST_RESTART);
 		mutex_unlock(&rdata->rp_mutex);
 	} else
 		FC_RPORT_ID_DBG(lport, sid,
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7495c0b..db54c4a 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -104,7 +104,6 @@ enum fc_disc_event {
  * @RPORT_ST_LOGO:    Remote port logout (LOGO) sent
  * @RPORT_ST_ADISC:   Discover Address sent
  * @RPORT_ST_DELETE:  Remote port being deleted
- * @RPORT_ST_RESTART: Remote port being deleted and will restart
 */
 enum fc_rport_state {
 	RPORT_ST_INIT,
@@ -115,7 +114,6 @@ enum fc_rport_state {
 	RPORT_ST_LOGO,
 	RPORT_ST_ADISC,
 	RPORT_ST_DELETE,
-	RPORT_ST_RESTART,
 };
 
 /**
@@ -173,6 +171,7 @@ struct fc_rport_libfc_priv {
 	u16			   flags;
 	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
 	#define FC_RP_FLAGS_RETRY		(1 << 1)
+	#define FC_RP_STARTED			(1 << 2)
 	unsigned int	           e_d_tov;
 	unsigned int	           r_a_tov;
 };
@@ -185,7 +184,7 @@ struct fc_rport_libfc_priv {
  * @rp_state:       Enumeration that tracks progress of PLOGI, PRLI,
  *                  and RTV exchanges
  * @ids:            The remote port identifiers and roles
- * @flags:          REC and RETRY supported flags
+ * @flags:          STARTED, REC and RETRY_SUPPORTED flags
  * @max_seq:        Maximum number of concurrent sequences
  * @disc_id:        The discovery identifier
  * @maxframe_size:  The maximum frame size

