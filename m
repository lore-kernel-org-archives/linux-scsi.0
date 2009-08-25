From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 27/64] libfc: make fc_rport_priv the primary rport interface.
Date: Tue, 25 Aug 2009 14:00:50 -0700
Message-ID: <20090825210050.1553.86854.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1598 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbZHYVAt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:49 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The rport and discovery modules deal with remote ports
before fc_remote_port_add() can be done, because the
full set of rport identifiers is not known at early stages.

In preparation for splitting the fc_rport/fc_rport_priv allocation,
make fc_rport_priv the primary interface for the remote port and
discovery engines.

The FCP / SCSI layers still deal with fc_rport and
fc_rport_libfc_priv, however.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   95 ++++-------
 drivers/scsi/libfc/fc_elsct.c |    4 
 drivers/scsi/libfc/fc_fcp.c   |    2 
 drivers/scsi/libfc/fc_lport.c |   26 +--
 drivers/scsi/libfc/fc_rport.c |  364 ++++++++++++++++++++---------------------
 include/scsi/fc_encode.h      |    7 +
 include/scsi/libfc.h          |   26 ++-
 7 files changed, 245 insertions(+), 279 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index ecc625c..448ffc3 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -49,7 +49,6 @@ static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static int fc_disc_new_target(struct fc_disc *, struct fc_rport *,
 			      struct fc_rport_identifiers *);
-static void fc_disc_del_target(struct fc_disc *, struct fc_rport *);
 static void fc_disc_done(struct fc_disc *);
 static void fc_disc_timeout(struct work_struct *);
 static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
@@ -60,27 +59,19 @@ static void fc_disc_restart(struct fc_disc *);
  * @lport: Fibre Channel host port instance
  * @port_id: remote port port_id to match
  */
-struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
-				      u32 port_id)
+struct fc_rport_priv *fc_disc_lookup_rport(const struct fc_lport *lport,
+					   u32 port_id)
 {
 	const struct fc_disc *disc = &lport->disc;
-	struct fc_rport *rport, *found = NULL;
+	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
-	int disc_found = 0;
 
 	list_for_each_entry(rdata, &disc->rports, peers) {
 		rport = PRIV_TO_RPORT(rdata);
-		if (rport->port_id == port_id) {
-			disc_found = 1;
-			found = rport;
-			break;
-		}
+		if (rport->port_id == port_id)
+			return rdata;
 	}
-
-	if (!disc_found)
-		found = NULL;
-
-	return found;
+	return NULL;
 }
 
 /**
@@ -93,21 +84,18 @@ struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
 void fc_disc_stop_rports(struct fc_disc *disc)
 {
 	struct fc_lport *lport;
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata, *next;
 
 	lport = disc->lport;
 
 	mutex_lock(&disc->disc_mutex);
 	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
-		rport = PRIV_TO_RPORT(rdata);
 		list_del(&rdata->peers);
-		lport->tt.rport_logoff(rport);
+		lport->tt.rport_logoff(rdata);
 	}
 
 	list_for_each_entry_safe(rdata, next, &disc->rogue_rports, peers) {
-		rport = PRIV_TO_RPORT(rdata);
-		lport->tt.rport_logoff(rport);
+		lport->tt.rport_logoff(rdata);
 	}
 
 	mutex_unlock(&disc->disc_mutex);
@@ -116,18 +104,18 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 /**
  * fc_disc_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
- * @rport: The rport which the event has occured on
+ * @rdata: private remote port data
  * @event: The event that occured
  *
  * Locking Note: The rport lock should not be held when calling
  *		 this function.
  */
 static void fc_disc_rport_callback(struct fc_lport *lport,
-				   struct fc_rport *rport,
+				   struct fc_rport_priv *rdata,
 				   enum fc_rport_event event)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_disc *disc = &lport->disc;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 
 	FC_DISC_DBG(disc, "Received a %d event for port (%6x)\n", event,
 		    rport->port_id);
@@ -169,7 +157,6 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 				  struct fc_disc *disc)
 {
 	struct fc_lport *lport;
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
 	struct fc_els_rscn *rp;
 	struct fc_els_rscn_page *pp;
@@ -249,11 +236,10 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			    redisc, lport->state, disc->pending);
 		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
 			list_del(&dp->peers);
-			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
-			if (rport) {
-				rdata = rport->dd_data;
+			rdata = lport->tt.rport_lookup(lport, dp->ids.port_id);
+			if (rdata) {
 				list_del(&rdata->peers);
-				lport->tt.rport_logoff(rport);
+				lport->tt.rport_logoff(rdata);
 			}
 			fc_disc_single(disc, dp);
 		}
@@ -308,16 +294,14 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
  */
 static void fc_disc_restart(struct fc_disc *disc)
 {
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata, *next;
 	struct fc_lport *lport = disc->lport;
 
 	FC_DISC_DBG(disc, "Restarting discovery\n");
 
 	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
-		rport = PRIV_TO_RPORT(rdata);
 		list_del(&rdata->peers);
-		lport->tt.rport_logoff(rport);
+		lport->tt.rport_logoff(rdata);
 	}
 
 	disc->requested = 1;
@@ -335,6 +319,7 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 						enum fc_disc_event),
 			  struct fc_lport *lport)
 {
+	struct fc_rport_priv *rdata;
 	struct fc_rport *rport;
 	struct fc_rport_identifiers ids;
 	struct fc_disc *disc = &lport->disc;
@@ -362,8 +347,9 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 	 * Handle point-to-point mode as a simple discovery
 	 * of the remote port. Yucky, yucky, yuck, yuck!
 	 */
-	rport = disc->lport->ptp_rp;
-	if (rport) {
+	rdata = disc->lport->ptp_rp;
+	if (rdata) {
+		rport = PRIV_TO_RPORT(rdata);
 		ids.port_id = rport->port_id;
 		ids.port_name = rport->port_name;
 		ids.node_name = rport->node_name;
@@ -418,7 +404,9 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			 * assigned the same FCID.  This should be rare.
 			 * Delete the old one and fall thru to re-create.
 			 */
-			fc_disc_del_target(disc, rport);
+			rdata = rport->dd_data;
+			list_del(&rdata->peers);
+			lport->tt.rport_logoff(rdata);
 			rport = NULL;
 		}
 	}
@@ -426,38 +414,27 @@ static int fc_disc_new_target(struct fc_disc *disc,
 	    ids->port_id != fc_host_port_id(lport->host) &&
 	    ids->port_name != lport->wwpn) {
 		if (!rport) {
-			rport = lport->tt.rport_lookup(lport, ids->port_id);
+			rdata = lport->tt.rport_lookup(lport, ids->port_id);
 			if (!rport) {
-				rport = lport->tt.rport_create(lport, ids);
+				rdata = lport->tt.rport_create(lport, ids);
 			}
-			if (!rport)
+			if (!rdata)
 				error = -ENOMEM;
+			else
+				rport = PRIV_TO_RPORT(rdata);
 		}
 		if (rport) {
 			rdata = rport->dd_data;
 			rdata->ops = &fc_disc_rport_ops;
 			rdata->rp_state = RPORT_ST_INIT;
 			list_add_tail(&rdata->peers, &disc->rogue_rports);
-			lport->tt.rport_login(rport);
+			lport->tt.rport_login(rdata);
 		}
 	}
 	return error;
 }
 
 /**
- * fc_disc_del_target() - Delete a target
- * @disc: FC discovery context
- * @rport: The remote port to be removed
- */
-static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
-{
-	struct fc_lport *lport = disc->lport;
-	struct fc_rport_priv *rdata = rport->dd_data;
-	list_del(&rdata->peers);
-	lport->tt.rport_logoff(rport);
-}
-
-/**
  * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
  * Locking Note: This function expects that the disc mutex is locked before
@@ -573,7 +550,6 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	size_t tlen;
 	int error = 0;
 	struct fc_rport_identifiers ids;
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
@@ -622,14 +598,13 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 
 		if (ids.port_id != fc_host_port_id(lport->host) &&
 		    ids.port_name != lport->wwpn) {
-			rport = lport->tt.rport_create(lport, &ids);
-			if (rport) {
-				rdata = rport->dd_data;
+			rdata = lport->tt.rport_create(lport, &ids);
+			if (rdata) {
 				rdata->ops = &fc_disc_rport_ops;
 				rdata->local_port = lport;
 				list_add_tail(&rdata->peers,
 					      &disc->rogue_rports);
-				lport->tt.rport_login(rport);
+				lport->tt.rport_login(rdata);
 			} else
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
@@ -766,7 +741,6 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 {
 	struct fc_lport *lport;
-	struct fc_rport *new_rport;
 	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
@@ -774,13 +748,12 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (dp->ids.port_id == fc_host_port_id(lport->host))
 		goto out;
 
-	new_rport = lport->tt.rport_create(lport, &dp->ids);
-	if (new_rport) {
-		rdata = new_rport->dd_data;
+	rdata = lport->tt.rport_create(lport, &dp->ids);
+	if (rdata) {
 		rdata->ops = &fc_disc_rport_ops;
 		kfree(dp);
 		list_add_tail(&rdata->peers, &disc->rogue_rports);
-		lport->tt.rport_login(new_rport);
+		lport->tt.rport_login(rdata);
 	}
 	return;
 out:
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index 5878b34..2b8a3bb 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -32,7 +32,7 @@
  * fc_elsct_send - sends ELS/CT frame
  */
 static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
-				    struct fc_rport *rport,
+				    struct fc_rport_priv *rdata,
 				    struct fc_frame *fp,
 				    unsigned int op,
 				    void (*resp)(struct fc_seq *,
@@ -47,7 +47,7 @@ static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
 
 	/* ELS requests */
 	if ((op >= ELS_LS_RJT) && (op <= ELS_AUTH_ELS))
-		rc = fc_els_fill(lport, rport, fp, op, &r_ctl, &did, &fh_type);
+		rc = fc_els_fill(lport, rdata, fp, op, &r_ctl, &did, &fh_type);
 	else
 		/* CT requests */
 		rc = fc_ct_fill(lport, fp, op, &r_ctl, &did, &fh_type);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 7d5ffcb..a622096 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1308,7 +1308,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rport->port_id,
 		       fc_host_port_id(rp->local_port->host), FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
-	if (lp->tt.elsct_send(lp, rport, fp, ELS_REC, fc_fcp_rec_resp,
+	if (lp->tt.elsct_send(lp, rport->dd_data, fp, ELS_REC, fc_fcp_rec_resp,
 			      fsp, jiffies_to_msecs(FC_SCSI_REC_TOV))) {
 		fc_fcp_pkt_hold(fsp);		/* hold while REC outstanding */
 		return;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a78161c..3c15abd 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -133,16 +133,18 @@ static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
 /**
  * fc_lport_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
- * @rport: The rport which the event has occured on
+ * @rdata: private remote port data
  * @event: The event that occured
  *
  * Locking Note: The rport lock should not be held when calling
  *		 this function.
  */
 static void fc_lport_rport_callback(struct fc_lport *lport,
-				    struct fc_rport *rport,
+				    struct fc_rport_priv *rdata,
 				    enum fc_rport_event event)
 {
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
+
 	FC_LPORT_DBG(lport, "Received a %d event for port (%6x)\n", event,
 		     rport->port_id);
 
@@ -151,7 +153,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 		if (rport->port_id == FC_FID_DIR_SERV) {
 			mutex_lock(&lport->lp_mutex);
 			if (lport->state == LPORT_ST_DNS) {
-				lport->dns_rp = rport;
+				lport->dns_rp = rdata;
 				fc_lport_enter_rpn_id(lport);
 			} else {
 				FC_LPORT_DBG(lport, "Received an CREATED event "
@@ -160,7 +162,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 					     "in the DNS state, it's in the "
 					     "%d state", rport->port_id,
 					     lport->state);
-				lport->tt.rport_logoff(rport);
+				lport->tt.rport_logoff(rdata);
 			}
 			mutex_unlock(&lport->lp_mutex);
 		} else
@@ -832,7 +834,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	void (*recv) (struct fc_seq *, struct fc_frame *, struct fc_lport *);
-	struct fc_rport *rport;
+	struct fc_rport_priv *rdata;
 	u32 s_id;
 	u32 d_id;
 	struct fc_seq_els_data rjt_data;
@@ -888,9 +890,9 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 			s_id = ntoh24(fh->fh_s_id);
 			d_id = ntoh24(fh->fh_d_id);
 
-			rport = lport->tt.rport_lookup(lport, s_id);
-			if (rport)
-				lport->tt.rport_recv_req(sp, fp, rport);
+			rdata = lport->tt.rport_lookup(lport, s_id);
+			if (rdata)
+				lport->tt.rport_recv_req(sp, fp, rdata);
 			else {
 				rjt_data.fp = NULL;
 				rjt_data.reason = ELS_RJT_UNAB;
@@ -1304,7 +1306,6 @@ static struct fc_rport_operations fc_lport_rport_ops = {
  */
 static void fc_lport_enter_dns(struct fc_lport *lport)
 {
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
 	struct fc_rport_identifiers ids;
 
@@ -1318,13 +1319,12 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
-	rport = lport->tt.rport_create(lport, &ids);
-	if (!rport)
+	rdata = lport->tt.rport_create(lport, &ids);
+	if (!rdata)
 		goto err;
 
-	rdata = rport->dd_data;
 	rdata->ops = &fc_lport_rport_ops;
-	lport->tt.rport_login(rport);
+	lport->tt.rport_login(rdata);
 	return;
 
 err:
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 2fbc94a..13d3d75 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -57,23 +57,23 @@
 
 struct workqueue_struct *rport_event_queue;
 
-static void fc_rport_enter_plogi(struct fc_rport *);
-static void fc_rport_enter_prli(struct fc_rport *);
-static void fc_rport_enter_rtv(struct fc_rport *);
-static void fc_rport_enter_ready(struct fc_rport *);
-static void fc_rport_enter_logo(struct fc_rport *);
+static void fc_rport_enter_plogi(struct fc_rport_priv *);
+static void fc_rport_enter_prli(struct fc_rport_priv *);
+static void fc_rport_enter_rtv(struct fc_rport_priv *);
+static void fc_rport_enter_ready(struct fc_rport_priv *);
+static void fc_rport_enter_logo(struct fc_rport_priv *);
 
-static void fc_rport_recv_plogi_req(struct fc_rport *,
+static void fc_rport_recv_plogi_req(struct fc_rport_priv *,
 				    struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_prli_req(struct fc_rport *,
+static void fc_rport_recv_prli_req(struct fc_rport_priv *,
 				   struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_prlo_req(struct fc_rport *,
+static void fc_rport_recv_prlo_req(struct fc_rport_priv *,
 				   struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_logo_req(struct fc_rport *,
+static void fc_rport_recv_logo_req(struct fc_rport_priv *,
 				   struct fc_seq *, struct fc_frame *);
 static void fc_rport_timeout(struct work_struct *);
-static void fc_rport_error(struct fc_rport *, struct fc_frame *);
-static void fc_rport_error_retry(struct fc_rport *, struct fc_frame *);
+static void fc_rport_error(struct fc_rport_priv *, struct fc_frame *);
+static void fc_rport_error_retry(struct fc_rport_priv *, struct fc_frame *);
 static void fc_rport_work(struct work_struct *);
 
 static const char *fc_rport_state_names[] = {
@@ -89,12 +89,14 @@ static const char *fc_rport_state_names[] = {
 static void fc_rport_rogue_destroy(struct device *dev)
 {
 	struct fc_rport *rport = dev_to_rport(dev);
-	FC_RPORT_DBG(rport, "Destroying rogue rport\n");
+	struct fc_rport_priv *rdata = RPORT_TO_PRIV(rport);
+
+	FC_RPORT_DBG(rdata, "Destroying rogue rport\n");
 	kfree(rport);
 }
 
-struct fc_rport *fc_rport_rogue_create(struct fc_lport *lport,
-				       struct fc_rport_identifiers *ids)
+struct fc_rport_priv *fc_rport_rogue_create(struct fc_lport *lport,
+					    struct fc_rport_identifiers *ids)
 {
 	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
@@ -135,17 +137,16 @@ struct fc_rport *fc_rport_rogue_create(struct fc_lport *lport,
 	 */
 	INIT_LIST_HEAD(&rdata->peers);
 
-	return rport;
+	return rdata;
 }
 
 /**
  * fc_rport_state() - return a string for the state the rport is in
- * @rport: The rport whose state we want to get a string for
+ * @rdata: remote port private data
  */
-static const char *fc_rport_state(struct fc_rport *rport)
+static const char *fc_rport_state(struct fc_rport_priv *rdata)
 {
 	const char *cp;
-	struct fc_rport_priv *rdata = rport->dd_data;
 
 	cp = fc_rport_state_names[rdata->rp_state];
 	if (!cp)
@@ -192,15 +193,14 @@ static unsigned int fc_plogi_get_maxframe(struct fc_els_flogi *flp,
 
 /**
  * fc_rport_state_enter() - Change the rport's state
- * @rport: The rport whose state should change
+ * @rdata: The rport whose state should change
  * @new: The new state of the rport
  *
  * Locking Note: Called with the rport lock held
  */
-static void fc_rport_state_enter(struct fc_rport *rport,
+static void fc_rport_state_enter(struct fc_rport_priv *rdata,
 				 enum fc_rport_state new)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	if (rdata->rp_state != new)
 		rdata->retries = 0;
 	rdata->rp_state = new;
@@ -255,7 +255,7 @@ static void fc_rport_work(struct work_struct *work)
 			INIT_LIST_HEAD(&new_rdata->peers);
 			INIT_WORK(&new_rdata->event_work, fc_rport_work);
 
-			fc_rport_state_enter(new_rport, RPORT_ST_READY);
+			fc_rport_state_enter(new_rdata, RPORT_ST_READY);
 		} else {
 			printk(KERN_WARNING "libfc: Failed to allocate "
 			       " memory for rport (%6x)\n", ids.port_id);
@@ -263,20 +263,20 @@ static void fc_rport_work(struct work_struct *work)
 		}
 		if (rport->port_id != FC_FID_DIR_SERV)
 			if (rport_ops->event_callback)
-				rport_ops->event_callback(lport, rport,
+				rport_ops->event_callback(lport, rdata,
 							  RPORT_EV_FAILED);
 		put_device(&rport->dev);
 		rport = new_rport;
 		rdata = new_rport->dd_data;
 		if (rport_ops->event_callback)
-			rport_ops->event_callback(lport, rport, event);
+			rport_ops->event_callback(lport, rdata, event);
 	} else if ((event == RPORT_EV_FAILED) ||
 		   (event == RPORT_EV_LOGO) ||
 		   (event == RPORT_EV_STOP)) {
 		trans_state = rdata->trans_state;
 		mutex_unlock(&rdata->rp_mutex);
 		if (rport_ops->event_callback)
-			rport_ops->event_callback(lport, rport, event);
+			rport_ops->event_callback(lport, rdata, event);
 		cancel_delayed_work_sync(&rdata->retry_work);
 		if (trans_state == FC_PORTSTATE_ROGUE)
 			put_device(&rport->dev);
@@ -292,21 +292,19 @@ static void fc_rport_work(struct work_struct *work)
 
 /**
  * fc_rport_login() - Start the remote port login state machine
- * @rport: Fibre Channel remote port
+ * @rdata: private remote port
  *
  * Locking Note: Called without the rport lock held. This
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
  */
-int fc_rport_login(struct fc_rport *rport)
+int fc_rport_login(struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
-
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rport, "Login to port\n");
+	FC_RPORT_DBG(rdata, "Login to port\n");
 
-	fc_rport_enter_plogi(rport);
+	fc_rport_enter_plogi(rdata);
 
 	mutex_unlock(&rdata->rp_mutex);
 
@@ -315,7 +313,7 @@ int fc_rport_login(struct fc_rport *rport)
 
 /**
  * fc_rport_enter_delete() - schedule a remote port to be deleted.
- * @rport: Fibre Channel remote port
+ * @rdata: private remote port
  * @event: event to report as the reason for deletion
  *
  * Locking Note: Called with the rport lock held.
@@ -327,17 +325,15 @@ int fc_rport_login(struct fc_rport *rport)
  * Since we have the mutex, even if fc_rport_work() is already started,
  * it'll see the new event.
  */
-static void fc_rport_enter_delete(struct fc_rport *rport,
+static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 				  enum fc_rport_event event)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
-
 	if (rdata->rp_state == RPORT_ST_DELETE)
 		return;
 
-	FC_RPORT_DBG(rport, "Delete port\n");
+	FC_RPORT_DBG(rdata, "Delete port\n");
 
-	fc_rport_state_enter(rport, RPORT_ST_DELETE);
+	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 
 	if (rdata->event == RPORT_EV_NONE)
 		queue_work(rport_event_queue, &rdata->event_work);
@@ -346,33 +342,31 @@ static void fc_rport_enter_delete(struct fc_rport *rport,
 
 /**
  * fc_rport_logoff() - Logoff and remove an rport
- * @rport: Fibre Channel remote port to be removed
+ * @rdata: private remote port
  *
  * Locking Note: Called without the rport lock held. This
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
  */
-int fc_rport_logoff(struct fc_rport *rport)
+int fc_rport_logoff(struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
-
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rport, "Remove port\n");
+	FC_RPORT_DBG(rdata, "Remove port\n");
 
 	if (rdata->rp_state == RPORT_ST_DELETE) {
-		FC_RPORT_DBG(rport, "Port in Delete state, not removing\n");
+		FC_RPORT_DBG(rdata, "Port in Delete state, not removing\n");
 		mutex_unlock(&rdata->rp_mutex);
 		goto out;
 	}
 
-	fc_rport_enter_logo(rport);
+	fc_rport_enter_logo(rdata);
 
 	/*
 	 * Change the state to Delete so that we discard
 	 * the response.
 	 */
-	fc_rport_enter_delete(rport, RPORT_EV_STOP);
+	fc_rport_enter_delete(rdata, RPORT_EV_STOP);
 	mutex_unlock(&rdata->rp_mutex);
 
 out:
@@ -381,18 +375,16 @@ out:
 
 /**
  * fc_rport_enter_ready() - The rport is ready
- * @rport: Fibre Channel remote port that is ready
+ * @rdata: private remote port
  *
  * Locking Note: The rport lock is expected to be held before calling
  * this routine.
  */
-static void fc_rport_enter_ready(struct fc_rport *rport)
+static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
-
-	fc_rport_state_enter(rport, RPORT_ST_READY);
+	fc_rport_state_enter(rdata, RPORT_ST_READY);
 
-	FC_RPORT_DBG(rport, "Port is Ready\n");
+	FC_RPORT_DBG(rdata, "Port is Ready\n");
 
 	if (rdata->event == RPORT_EV_NONE)
 		queue_work(rport_event_queue, &rdata->event_work);
@@ -411,22 +403,21 @@ static void fc_rport_timeout(struct work_struct *work)
 {
 	struct fc_rport_priv *rdata =
 		container_of(work, struct fc_rport_priv, retry_work.work);
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 
 	mutex_lock(&rdata->rp_mutex);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
-		fc_rport_enter_plogi(rport);
+		fc_rport_enter_plogi(rdata);
 		break;
 	case RPORT_ST_PRLI:
-		fc_rport_enter_prli(rport);
+		fc_rport_enter_prli(rdata);
 		break;
 	case RPORT_ST_RTV:
-		fc_rport_enter_rtv(rport);
+		fc_rport_enter_rtv(rdata);
 		break;
 	case RPORT_ST_LOGO:
-		fc_rport_enter_logo(rport);
+		fc_rport_enter_logo(rdata);
 		break;
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
@@ -439,27 +430,25 @@ static void fc_rport_timeout(struct work_struct *work)
 
 /**
  * fc_rport_error() - Error handler, called once retries have been exhausted
- * @rport: The fc_rport object
+ * @rdata: private remote port
  * @fp: The frame pointer
  *
  * Locking Note: The rport lock is expected to be held before
  * calling this routine
  */
-static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
+static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
-
-	FC_RPORT_DBG(rport, "Error %ld in state %s, retries %d\n",
-		     PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
+	FC_RPORT_DBG(rdata, "Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_rport_state(rdata), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
 	case RPORT_ST_PRLI:
 	case RPORT_ST_LOGO:
-		fc_rport_enter_delete(rport, RPORT_EV_FAILED);
+		fc_rport_enter_delete(rdata, RPORT_EV_FAILED);
 		break;
 	case RPORT_ST_RTV:
-		fc_rport_enter_ready(rport);
+		fc_rport_enter_ready(rdata);
 		break;
 	case RPORT_ST_DELETE:
 	case RPORT_ST_READY:
@@ -470,7 +459,7 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 
 /**
  * fc_rport_error_retry() - Error handler when retries are desired
- * @rport: The fc_rport object
+ * @rdata: private remote port data
  * @fp: The frame pointer
  *
  * If the error was an exchange timeout retry immediately,
@@ -479,18 +468,18 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
  * Locking Note: The rport lock is expected to be held before
  * calling this routine
  */
-static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
+static void fc_rport_error_retry(struct fc_rport_priv *rdata,
+				 struct fc_frame *fp)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	unsigned long delay = FC_DEF_E_D_TOV;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
-		return fc_rport_error(rport, fp);
+		return fc_rport_error(rdata, fp);
 
 	if (rdata->retries < rdata->local_port->max_rport_retry_count) {
-		FC_RPORT_DBG(rport, "Error %ld in state %s, retrying\n",
-			     PTR_ERR(fp), fc_rport_state(rport));
+		FC_RPORT_DBG(rdata, "Error %ld in state %s, retrying\n",
+			     PTR_ERR(fp), fc_rport_state(rdata));
 		rdata->retries++;
 		/* no additional delay on exchange timeouts */
 		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
@@ -499,24 +488,24 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 		return;
 	}
 
-	return fc_rport_error(rport, fp);
+	return fc_rport_error(rdata, fp);
 }
 
 /**
  * fc_rport_plogi_recv_resp() - Handle incoming ELS PLOGI response
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
- * @rp_arg: Fibre Channel remote port
+ * @rdata_arg: private remote port data
  *
  * Locking Note: This function will be called without the rport lock
  * held, but it will lock, call an _enter_* function or fc_rport_error
  * and then unlock the rport.
  */
 static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
-				void *rp_arg)
+				void *rdata_arg)
 {
-	struct fc_rport *rport = rp_arg;
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rdata_arg;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_els_flogi *plp = NULL;
 	unsigned int tov;
@@ -526,18 +515,18 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rport, "Received a PLOGI response\n");
+	FC_RPORT_DBG(rdata, "Received a PLOGI response\n");
 
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
-		FC_RPORT_DBG(rport, "Received a PLOGI response, but in state "
-			     "%s\n", fc_rport_state(rport));
+		FC_RPORT_DBG(rdata, "Received a PLOGI response, but in state "
+			     "%s\n", fc_rport_state(rdata));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		goto err;
 	}
 
@@ -565,11 +554,11 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		 * we skip PRLI and RTV and go straight to READY.
 		 */
 		if (rport->port_id >= FC_FID_DOM_MGR)
-			fc_rport_enter_ready(rport);
+			fc_rport_enter_ready(rdata);
 		else
-			fc_rport_enter_prli(rport);
+			fc_rport_enter_prli(rdata);
 	} else
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 
 out:
 	fc_frame_free(fp);
@@ -580,33 +569,33 @@ err:
 
 /**
  * fc_rport_enter_plogi() - Send Port Login (PLOGI) request to peer
- * @rport: Fibre Channel remote port to send PLOGI to
+ * @rdata: private remote port data
  *
  * Locking Note: The rport lock is expected to be held before calling
  * this routine.
  */
-static void fc_rport_enter_plogi(struct fc_rport *rport)
+static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_frame *fp;
 
-	FC_RPORT_DBG(rport, "Port entered PLOGI state from %s state\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Port entered PLOGI state from %s state\n",
+		     fc_rport_state(rdata));
 
-	fc_rport_state_enter(rport, RPORT_ST_PLOGI);
+	fc_rport_state_enter(rdata, RPORT_ST_PLOGI);
 
 	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		return;
 	}
 	rdata->e_d_tov = lport->e_d_tov;
 
-	if (!lport->tt.elsct_send(lport, rport, fp, ELS_PLOGI,
-				  fc_rport_plogi_resp, rport, lport->e_d_tov))
-		fc_rport_error_retry(rport, fp);
+	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_PLOGI,
+				  fc_rport_plogi_resp, rdata, lport->e_d_tov))
+		fc_rport_error_retry(rdata, fp);
 	else
 		get_device(&rport->dev);
 }
@@ -615,17 +604,17 @@ static void fc_rport_enter_plogi(struct fc_rport *rport)
  * fc_rport_prli_resp() - Process Login (PRLI) response handler
  * @sp: current sequence in the PRLI exchange
  * @fp: response frame
- * @rp_arg: Fibre Channel remote port
+ * @rdata_arg: private remote port data
  *
  * Locking Note: This function will be called without the rport lock
  * held, but it will lock, call an _enter_* function or fc_rport_error
  * and then unlock the rport.
  */
 static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
-			       void *rp_arg)
+			       void *rdata_arg)
 {
-	struct fc_rport *rport = rp_arg;
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rdata_arg;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct {
 		struct fc_els_prli prli;
 		struct fc_els_spp spp;
@@ -636,18 +625,18 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rport, "Received a PRLI response\n");
+	FC_RPORT_DBG(rdata, "Received a PRLI response\n");
 
 	if (rdata->rp_state != RPORT_ST_PRLI) {
-		FC_RPORT_DBG(rport, "Received a PRLI response, but in state "
-			     "%s\n", fc_rport_state(rport));
+		FC_RPORT_DBG(rdata, "Received a PRLI response, but in state "
+			     "%s\n", fc_rport_state(rdata));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		goto err;
 	}
 
@@ -667,11 +656,11 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 			roles |= FC_RPORT_ROLE_FCP_TARGET;
 
 		rport->roles = roles;
-		fc_rport_enter_rtv(rport);
+		fc_rport_enter_rtv(rdata);
 
 	} else {
-		FC_RPORT_DBG(rport, "Bad ELS response for PRLI command\n");
-		fc_rport_enter_delete(rport, RPORT_EV_FAILED);
+		FC_RPORT_DBG(rdata, "Bad ELS response for PRLI command\n");
+		fc_rport_enter_delete(rdata, RPORT_EV_FAILED);
 	}
 
 out:
@@ -685,42 +674,42 @@ err:
  * fc_rport_logo_resp() - Logout (LOGO) response handler
  * @sp: current sequence in the LOGO exchange
  * @fp: response frame
- * @rp_arg: Fibre Channel remote port
+ * @rdata_arg: private remote port data
  *
  * Locking Note: This function will be called without the rport lock
  * held, but it will lock, call an _enter_* function or fc_rport_error
  * and then unlock the rport.
  */
 static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
-			       void *rp_arg)
+			       void *rdata_arg)
 {
-	struct fc_rport *rport = rp_arg;
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rdata_arg;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	u8 op;
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rport, "Received a LOGO response\n");
+	FC_RPORT_DBG(rdata, "Received a LOGO response\n");
 
 	if (rdata->rp_state != RPORT_ST_LOGO) {
-		FC_RPORT_DBG(rport, "Received a LOGO response, but in state "
-			     "%s\n", fc_rport_state(rport));
+		FC_RPORT_DBG(rdata, "Received a LOGO response, but in state "
+			     "%s\n", fc_rport_state(rdata));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		goto err;
 	}
 
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
-		fc_rport_enter_rtv(rport);
+		fc_rport_enter_rtv(rdata);
 	} else {
-		FC_RPORT_DBG(rport, "Bad ELS response for LOGO command\n");
-		fc_rport_enter_delete(rport, RPORT_EV_LOGO);
+		FC_RPORT_DBG(rdata, "Bad ELS response for LOGO command\n");
+		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
 	}
 
 out:
@@ -732,14 +721,14 @@ err:
 
 /**
  * fc_rport_enter_prli() - Send Process Login (PRLI) request to peer
- * @rport: Fibre Channel remote port to send PRLI to
+ * @rdata: private remote port data
  *
  * Locking Note: The rport lock is expected to be held before calling
  * this routine.
  */
-static void fc_rport_enter_prli(struct fc_rport *rport)
+static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct {
 		struct fc_els_prli prli;
@@ -747,20 +736,20 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
 	} *pp;
 	struct fc_frame *fp;
 
-	FC_RPORT_DBG(rport, "Port entered PRLI state from %s state\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Port entered PRLI state from %s state\n",
+		     fc_rport_state(rdata));
 
-	fc_rport_state_enter(rport, RPORT_ST_PRLI);
+	fc_rport_state_enter(rdata, RPORT_ST_PRLI);
 
 	fp = fc_frame_alloc(lport, sizeof(*pp));
 	if (!fp) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rport, fp, ELS_PRLI,
-				  fc_rport_prli_resp, rport, lport->e_d_tov))
-		fc_rport_error_retry(rport, fp);
+	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_PRLI,
+				  fc_rport_prli_resp, rdata, lport->e_d_tov))
+		fc_rport_error_retry(rdata, fp);
 	else
 		get_device(&rport->dev);
 }
@@ -769,7 +758,7 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
  * fc_rport_els_rtv_resp() - Request Timeout Value response handler
  * @sp: current sequence in the RTV exchange
  * @fp: response frame
- * @rp_arg: Fibre Channel remote port
+ * @rdata_arg: private remote port data
  *
  * Many targets don't seem to support this.
  *
@@ -778,26 +767,26 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
  * and then unlock the rport.
  */
 static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
-			      void *rp_arg)
+			      void *rdata_arg)
 {
-	struct fc_rport *rport = rp_arg;
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rdata_arg;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	u8 op;
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rport, "Received a RTV response\n");
+	FC_RPORT_DBG(rdata, "Received a RTV response\n");
 
 	if (rdata->rp_state != RPORT_ST_RTV) {
-		FC_RPORT_DBG(rport, "Received a RTV response, but in state "
-			     "%s\n", fc_rport_state(rport));
+		FC_RPORT_DBG(rdata, "Received a RTV response, but in state "
+			     "%s\n", fc_rport_state(rdata));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
+		fc_rport_error(rdata, fp);
 		goto err;
 	}
 
@@ -823,7 +812,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 		}
 	}
 
-	fc_rport_enter_ready(rport);
+	fc_rport_enter_ready(rdata);
 
 out:
 	fc_frame_free(fp);
@@ -834,62 +823,62 @@ err:
 
 /**
  * fc_rport_enter_rtv() - Send Request Timeout Value (RTV) request to peer
- * @rport: Fibre Channel remote port to send RTV to
+ * @rdata: private remote port data
  *
  * Locking Note: The rport lock is expected to be held before calling
  * this routine.
  */
-static void fc_rport_enter_rtv(struct fc_rport *rport)
+static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 {
 	struct fc_frame *fp;
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 
-	FC_RPORT_DBG(rport, "Port entered RTV state from %s state\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Port entered RTV state from %s state\n",
+		     fc_rport_state(rdata));
 
-	fc_rport_state_enter(rport, RPORT_ST_RTV);
+	fc_rport_state_enter(rdata, RPORT_ST_RTV);
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_rtv));
 	if (!fp) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rport, fp, ELS_RTV,
-				     fc_rport_rtv_resp, rport, lport->e_d_tov))
-		fc_rport_error_retry(rport, fp);
+	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_RTV,
+				     fc_rport_rtv_resp, rdata, lport->e_d_tov))
+		fc_rport_error_retry(rdata, fp);
 	else
 		get_device(&rport->dev);
 }
 
 /**
  * fc_rport_enter_logo() - Send Logout (LOGO) request to peer
- * @rport: Fibre Channel remote port to send LOGO to
+ * @rdata: private remote port data
  *
  * Locking Note: The rport lock is expected to be held before calling
  * this routine.
  */
-static void fc_rport_enter_logo(struct fc_rport *rport)
+static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_frame *fp;
 
-	FC_RPORT_DBG(rport, "Port entered LOGO state from %s state\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Port entered LOGO state from %s state\n",
+		     fc_rport_state(rdata));
 
-	fc_rport_state_enter(rport, RPORT_ST_LOGO);
+	fc_rport_state_enter(rdata, RPORT_ST_LOGO);
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_logo));
 	if (!fp) {
-		fc_rport_error_retry(rport, fp);
+		fc_rport_error_retry(rdata, fp);
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rport, fp, ELS_LOGO,
-				  fc_rport_logo_resp, rport, lport->e_d_tov))
-		fc_rport_error_retry(rport, fp);
+	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_LOGO,
+				  fc_rport_logo_resp, rdata, lport->e_d_tov))
+		fc_rport_error_retry(rdata, fp);
 	else
 		get_device(&rport->dev);
 }
@@ -899,16 +888,15 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
  * fc_rport_recv_req() - Receive a request from a rport
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
- * @rp_arg: Fibre Channel remote port
+ * @rdata_arg: private remote port data
  *
  * Locking Note: Called without the rport lock held. This
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
  */
 void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
-		       struct fc_rport *rport)
+		       struct fc_rport_priv *rdata)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	struct fc_frame_header *fh;
@@ -927,16 +915,16 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		op = fc_frame_payload_op(fp);
 		switch (op) {
 		case ELS_PLOGI:
-			fc_rport_recv_plogi_req(rport, sp, fp);
+			fc_rport_recv_plogi_req(rdata, sp, fp);
 			break;
 		case ELS_PRLI:
-			fc_rport_recv_prli_req(rport, sp, fp);
+			fc_rport_recv_prli_req(rdata, sp, fp);
 			break;
 		case ELS_PRLO:
-			fc_rport_recv_prlo_req(rport, sp, fp);
+			fc_rport_recv_prlo_req(rdata, sp, fp);
 			break;
 		case ELS_LOGO:
-			fc_rport_recv_logo_req(rport, sp, fp);
+			fc_rport_recv_logo_req(rdata, sp, fp);
 			break;
 		case ELS_RRQ:
 			els_data.fp = fp;
@@ -958,17 +946,17 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 
 /**
  * fc_rport_recv_plogi_req() - Handle incoming Port Login (PLOGI) request
- * @rport: Fibre Channel remote port that initiated PLOGI
+ * @rdata: private remote port data
  * @sp: current sequence in the PLOGI exchange
  * @fp: PLOGI request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
-static void fc_rport_recv_plogi_req(struct fc_rport *rport,
+static void fc_rport_recv_plogi_req(struct fc_rport_priv *rdata,
 				    struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp = rx_fp;
 	struct fc_exch *ep;
@@ -984,13 +972,13 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_RPORT_DBG(rport, "Received PLOGI request while in state %s\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Received PLOGI request while in state %s\n",
+		     fc_rport_state(rdata));
 
 	sid = ntoh24(fh->fh_s_id);
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
-		FC_RPORT_DBG(rport, "Received PLOGI too short\n");
+		FC_RPORT_DBG(rdata, "Received PLOGI too short\n");
 		WARN_ON(1);
 		/* XXX TBD: send reject? */
 		fc_frame_free(fp);
@@ -1012,25 +1000,25 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	 */
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
-		FC_RPORT_DBG(rport, "Received PLOGI, wwpn %llx state INIT "
+		FC_RPORT_DBG(rdata, "Received PLOGI, wwpn %llx state INIT "
 			     "- reject\n", (unsigned long long)wwpn);
 		reject = ELS_RJT_UNSUP;
 		break;
 	case RPORT_ST_PLOGI:
-		FC_RPORT_DBG(rport, "Received PLOGI in PLOGI state %d\n",
+		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state %d\n",
 			     rdata->rp_state);
 		if (wwpn < lport->wwpn)
 			reject = ELS_RJT_INPROG;
 		break;
 	case RPORT_ST_PRLI:
 	case RPORT_ST_READY:
-		FC_RPORT_DBG(rport, "Received PLOGI in logged-in state %d "
+		FC_RPORT_DBG(rdata, "Received PLOGI in logged-in state %d "
 			     "- ignored for now\n", rdata->rp_state);
 		/* XXX TBD - should reset */
 		break;
 	case RPORT_ST_DELETE:
 	default:
-		FC_RPORT_DBG(rport, "Received PLOGI in unexpected "
+		FC_RPORT_DBG(rdata, "Received PLOGI in unexpected "
 			     "state %d\n", rdata->rp_state);
 		fc_frame_free(fp);
 		return;
@@ -1074,24 +1062,24 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 				       FC_TYPE_ELS, f_ctl, 0);
 			lport->tt.seq_send(lport, sp, fp);
 			if (rdata->rp_state == RPORT_ST_PLOGI)
-				fc_rport_enter_prli(rport);
+				fc_rport_enter_prli(rdata);
 		}
 	}
 }
 
 /**
  * fc_rport_recv_prli_req() - Handle incoming Process Login (PRLI) request
- * @rport: Fibre Channel remote port that initiated PRLI
+ * @rdata: private remote port data
  * @sp: current sequence in the PRLI exchange
  * @fp: PRLI request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
-static void fc_rport_recv_prli_req(struct fc_rport *rport,
+static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 				   struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_exch *ep;
 	struct fc_frame *fp;
@@ -1115,8 +1103,8 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(rx_fp);
 
-	FC_RPORT_DBG(rport, "Received PRLI request while in state %s\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Received PRLI request while in state %s\n",
+		     fc_rport_state(rdata));
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PRLI:
@@ -1220,7 +1208,7 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 		 */
 		switch (rdata->rp_state) {
 		case RPORT_ST_PRLI:
-			fc_rport_enter_ready(rport);
+			fc_rport_enter_ready(rdata);
 			break;
 		case RPORT_ST_READY:
 			break;
@@ -1233,17 +1221,17 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 
 /**
  * fc_rport_recv_prlo_req() - Handle incoming Process Logout (PRLO) request
- * @rport: Fibre Channel remote port that initiated PRLO
+ * @rdata: private remote port data
  * @sp: current sequence in the PRLO exchange
  * @fp: PRLO request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
-static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
+static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
+				   struct fc_seq *sp,
 				   struct fc_frame *fp)
 {
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	struct fc_frame_header *fh;
@@ -1251,8 +1239,8 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_RPORT_DBG(rport, "Received PRLO request while in state %s\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Received PRLO request while in state %s\n",
+		     fc_rport_state(rdata));
 
 	if (rdata->rp_state == RPORT_ST_DELETE) {
 		fc_frame_free(fp);
@@ -1268,24 +1256,24 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 /**
  * fc_rport_recv_logo_req() - Handle incoming Logout (LOGO) request
- * @rport: Fibre Channel remote port that initiated LOGO
+ * @rdata: private remote port data
  * @sp: current sequence in the LOGO exchange
  * @fp: LOGO request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
-static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
+static void fc_rport_recv_logo_req(struct fc_rport_priv *rdata,
+				   struct fc_seq *sp,
 				   struct fc_frame *fp)
 {
 	struct fc_frame_header *fh;
-	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	fh = fc_frame_header_get(fp);
 
-	FC_RPORT_DBG(rport, "Received LOGO request while in state %s\n",
-		     fc_rport_state(rport));
+	FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
+		     fc_rport_state(rdata));
 
 	if (rdata->rp_state == RPORT_ST_DELETE) {
 		fc_frame_free(fp);
@@ -1293,7 +1281,7 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 	}
 
 	rdata->event = RPORT_EV_LOGO;
-	fc_rport_state_enter(rport, RPORT_ST_DELETE);
+	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 	queue_work(rport_event_queue, &rdata->event_work);
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index a0ff61c..3ede1ab 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -249,10 +249,13 @@ static inline void fc_scr_fill(struct fc_lport *lport, struct fc_frame *fp)
 /**
  * fc_els_fill - Fill in an ELS  request frame
  */
-static inline int fc_els_fill(struct fc_lport *lport, struct fc_rport *rport,
+static inline int fc_els_fill(struct fc_lport *lport,
+		       struct fc_rport_priv *rdata,
 		       struct fc_frame *fp, unsigned int op,
 		       enum fc_rctl *r_ctl, u32 *did, enum fc_fh_type *fh_type)
 {
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
+
 	switch (op) {
 	case ELS_PLOGI:
 		fc_plogi_fill(lport, fp, ELS_PLOGI);
@@ -272,7 +275,7 @@ static inline int fc_els_fill(struct fc_lport *lport, struct fc_rport *rport,
 		 * is port logo, therefore
 		 * set did to rport id.
 		 */
-		if (rport)
+		if (rdata)
 			*did = rport->port_id;
 		break;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 2fdd8ac..df57cb7 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -75,10 +75,10 @@ do {								\
 				(lport)->host->host_no,			\
 				(port_id), ##args))
 
-#define FC_RPORT_DBG(rport, fmt, args...)				\
+#define FC_RPORT_DBG(rdata, fmt, args...)				\
 do {									\
-	struct fc_rport_priv *rdata = rport->dd_data;			\
 	struct fc_lport *lport = rdata->local_port;			\
+	struct fc_rport *rport = PRIV_TO_RPORT(rdata);			\
 	FC_RPORT_ID_DBG(lport, rport->port_id, fmt, ##args);		\
 } while (0)
 
@@ -185,8 +185,10 @@ enum fc_rport_event {
  */
 #define fc_rport_priv fc_rport_libfc_priv
 
+struct fc_rport_priv;
+
 struct fc_rport_operations {
-	void (*event_callback)(struct fc_lport *, struct fc_rport *,
+	void (*event_callback)(struct fc_lport *, struct fc_rport_priv *,
 			       enum fc_rport_event);
 };
 
@@ -422,7 +424,7 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*elsct_send)(struct fc_lport *lport,
-				     struct fc_rport *rport,
+				     struct fc_rport_priv *,
 				     struct fc_frame *fp,
 				     unsigned int op,
 				     void (*resp)(struct fc_seq *,
@@ -567,8 +569,8 @@ struct libfc_function_template {
 	/*
 	 * Create a remote port
 	 */
-	struct fc_rport *(*rport_create)(struct fc_lport *,
-					 struct fc_rport_identifiers *);
+	struct fc_rport_priv *(*rport_create)(struct fc_lport *,
+					      struct fc_rport_identifiers *);
 
 	/*
 	 * Initiates the RP state machine. It is called from the LP module.
@@ -581,7 +583,7 @@ struct libfc_function_template {
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	int (*rport_login)(struct fc_rport *rport);
+	int (*rport_login)(struct fc_rport_priv *);
 
 	/*
 	 * Logoff, and remove the rport from the transport if
@@ -589,7 +591,7 @@ struct libfc_function_template {
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	int (*rport_logoff)(struct fc_rport *rport);
+	int (*rport_logoff)(struct fc_rport_priv *);
 
 	/*
 	 * Recieve a request from a remote port.
@@ -597,14 +599,14 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	void (*rport_recv_req)(struct fc_seq *, struct fc_frame *,
-			       struct fc_rport *);
+			       struct fc_rport_priv *);
 
 	/*
 	 * lookup an rport by it's port ID.
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	struct fc_rport *(*rport_lookup)(const struct fc_lport *, u32);
+	struct fc_rport_priv *(*rport_lookup)(const struct fc_lport *, u32);
 
 	/*
 	 * Send a fcp cmd from fsp pkt.
@@ -694,8 +696,8 @@ struct fc_lport {
 	/* Associations */
 	struct Scsi_Host	*host;
 	struct list_head	ema_list;
-	struct fc_rport		*dns_rp;
-	struct fc_rport		*ptp_rp;
+	struct fc_rport_priv	*dns_rp;
+	struct fc_rport_priv	*ptp_rp;
 	void			*scsi_priv;
 	struct fc_disc          disc;
 

