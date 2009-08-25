From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 29/64] libfc: make rport structure optional
Date: Tue, 25 Aug 2009 14:01:01 -0700
Message-ID: <20090825210101.1553.33016.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbZHYVA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:59 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Allow a struct fc_rport_priv to have no fc_rport associated with it.
This sets up to remove the need for "rogue" rports.

Add a few fields to fc_rport_priv that are needed before the fc_rport
is created.  These are the ids, maxframe_size, classes, and rport pointer.

Remove the macro PRIV_TO_RPORT().  Just use rdata->rport where appropriate.

To take the place of the get_device()/put_device ops that were used to
hold both the rport and rdata, add a reference count to rdata structures
using kref.  When kref_get decrements the refcount to zero, a new template
function releasing the rdata should be called.  This will take care of
freeing the rdata and releasing the hold on the rport (for now).  After
subsequent patches make the rport truly optional, this release function
will simply free the rdata.

Remove the simple inline function fc_rport_set_name(), which becomes
semanticly ambiguous otherwise.  The caller will set the port_name and
node_name in the rdata->Ids, which will later be copied to the rport
when it its created.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   54 ++++++++--------------
 drivers/scsi/libfc/fc_lport.c |   14 ++----
 drivers/scsi/libfc/fc_rport.c |  102 +++++++++++++++++++++++------------------
 include/scsi/libfc.h          |   29 ++++++------
 4 files changed, 98 insertions(+), 101 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4b1f9fa..5f839b6 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -47,7 +47,7 @@
 
 static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
-static int fc_disc_new_target(struct fc_disc *, struct fc_rport *,
+static int fc_disc_new_target(struct fc_disc *, struct fc_rport_priv *,
 			      struct fc_rport_identifiers *);
 static void fc_disc_done(struct fc_disc *);
 static void fc_disc_timeout(struct work_struct *);
@@ -63,12 +63,10 @@ struct fc_rport_priv *fc_disc_lookup_rport(const struct fc_lport *lport,
 					   u32 port_id)
 {
 	const struct fc_disc *disc = &lport->disc;
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
 
 	list_for_each_entry(rdata, &disc->rports, peers) {
-		rport = PRIV_TO_RPORT(rdata);
-		if (rport->port_id == port_id)
+		if (rdata->ids.port_id == port_id)
 			return rdata;
 	}
 	return NULL;
@@ -115,10 +113,9 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 				   enum fc_rport_event event)
 {
 	struct fc_disc *disc = &lport->disc;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 
 	FC_DISC_DBG(disc, "Received a %d event for port (%6x)\n", event,
-		    rport->port_id);
+		    rdata->ids.port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
@@ -320,8 +317,6 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 			  struct fc_lport *lport)
 {
 	struct fc_rport_priv *rdata;
-	struct fc_rport *rport;
-	struct fc_rport_identifiers ids;
 	struct fc_disc *disc = &lport->disc;
 
 	/*
@@ -349,18 +344,12 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 	 */
 	rdata = disc->lport->ptp_rp;
 	if (rdata) {
-		rport = PRIV_TO_RPORT(rdata);
-		ids.port_id = rport->port_id;
-		ids.port_name = rport->port_name;
-		ids.node_name = rport->node_name;
-		ids.roles = FC_RPORT_ROLE_UNKNOWN;
-		get_device(&rport->dev);
-
-		if (!fc_disc_new_target(disc, rport, &ids)) {
+		kref_get(&rdata->kref);
+		if (!fc_disc_new_target(disc, rdata, &rdata->ids)) {
 			disc->event = DISC_EV_SUCCESS;
 			fc_disc_done(disc);
 		}
-		put_device(&rport->dev);
+		kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	} else {
 		fc_disc_gpn_ft_req(disc);	/* get ports by FC-4 type */
 	}
@@ -375,28 +364,27 @@ static struct fc_rport_operations fc_disc_rport_ops = {
 /**
  * fc_disc_new_target() - Handle new target found by discovery
  * @lport: FC local port
- * @rport: The previous FC remote port (NULL if new remote port)
+ * @rdata: The previous FC remote port priv (NULL if new remote port)
  * @ids: Identifiers for the new FC remote port
  *
  * Locking Note: This function expects that the disc_mutex is locked
  *		 before it is called.
  */
 static int fc_disc_new_target(struct fc_disc *disc,
-			      struct fc_rport *rport,
+			      struct fc_rport_priv *rdata,
 			      struct fc_rport_identifiers *ids)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_priv *rdata;
 	int error = 0;
 
-	if (rport && ids->port_name) {
-		if (rport->port_name == -1) {
+	if (rdata && ids->port_name) {
+		if (rdata->ids.port_name == -1) {
 			/*
 			 * Set WWN and fall through to notify of create.
 			 */
-			fc_rport_set_name(rport, ids->port_name,
-					  rport->node_name);
-		} else if (rport->port_name != ids->port_name) {
+			rdata->ids.port_name = ids->port_name;
+			rdata->ids.node_name = ids->node_name;
+		} else if (rdata->ids.port_name != ids->port_name) {
 			/*
 			 * This is a new port with the same FCID as
 			 * a previously-discovered port.  Presumably the old
@@ -404,27 +392,23 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			 * assigned the same FCID.  This should be rare.
 			 * Delete the old one and fall thru to re-create.
 			 */
-			rdata = rport->dd_data;
 			list_del(&rdata->peers);
 			lport->tt.rport_logoff(rdata);
-			rport = NULL;
+			rdata = NULL;
 		}
 	}
 	if (((ids->port_name != -1) || (ids->port_id != -1)) &&
 	    ids->port_id != fc_host_port_id(lport->host) &&
 	    ids->port_name != lport->wwpn) {
-		if (!rport) {
+		if (!rdata) {
 			rdata = lport->tt.rport_lookup(lport, ids->port_id);
-			if (!rport) {
+			if (!rdata) {
 				rdata = lport->tt.rport_create(lport, ids);
+				if (!rdata)
+					error = -ENOMEM;
 			}
-			if (!rdata)
-				error = -ENOMEM;
-			else
-				rport = PRIV_TO_RPORT(rdata);
 		}
-		if (rport) {
-			rdata = rport->dd_data;
+		if (rdata) {
 			rdata->ops = &fc_disc_rport_ops;
 			rdata->rp_state = RPORT_ST_INIT;
 			list_add_tail(&rdata->peers, &disc->rogue_rports);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index aa605d2..a7fe6b8 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -143,14 +143,12 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				    struct fc_rport_priv *rdata,
 				    enum fc_rport_event event)
 {
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
-
 	FC_LPORT_DBG(lport, "Received a %d event for port (%6x)\n", event,
-		     rport->port_id);
+		     rdata->ids.port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
-		if (rport->port_id == FC_FID_DIR_SERV) {
+		if (rdata->ids.port_id == FC_FID_DIR_SERV) {
 			mutex_lock(&lport->lp_mutex);
 			if (lport->state == LPORT_ST_DNS) {
 				lport->dns_rp = rdata;
@@ -160,7 +158,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 					     "on port (%6x) for the directory "
 					     "server, but the lport is not "
 					     "in the DNS state, it's in the "
-					     "%d state", rport->port_id,
+					     "%d state", rdata->ids.port_id,
 					     lport->state);
 				lport->tt.rport_logoff(rdata);
 			}
@@ -168,12 +166,12 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 		} else
 			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
 				     "which is not the directory server\n",
-				     rport->port_id);
+				     rdata->ids.port_id);
 		break;
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
 	case RPORT_EV_STOP:
-		if (rport->port_id == FC_FID_DIR_SERV) {
+		if (rdata->ids.port_id == FC_FID_DIR_SERV) {
 			mutex_lock(&lport->lp_mutex);
 			lport->dns_rp = NULL;
 			mutex_unlock(&lport->lp_mutex);
@@ -181,7 +179,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 		} else
 			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
 				     "which is not the directory server\n",
-				     rport->port_id);
+				     rdata->ids.port_id);
 		break;
 	case RPORT_EV_NONE:
 		break;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 20371b4..69f6e58 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -120,7 +120,10 @@ struct fc_rport_priv *fc_rport_rogue_create(struct fc_lport *lport,
 	device_initialize(&rport->dev);
 	rport->dev.release = fc_rport_rogue_destroy;
 
+	rdata->ids = *ids;
+	kref_init(&rdata->kref);
 	mutex_init(&rdata->rp_mutex);
+	rdata->rport = rport;
 	rdata->local_port = lport;
 	rdata->trans_state = FC_PORTSTATE_ROGUE;
 	rdata->rp_state = RPORT_ST_INIT;
@@ -129,6 +132,7 @@ struct fc_rport_priv *fc_rport_rogue_create(struct fc_lport *lport,
 	rdata->ops = NULL;
 	rdata->e_d_tov = lport->e_d_tov;
 	rdata->r_a_tov = lport->r_a_tov;
+	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
 	/*
@@ -141,6 +145,20 @@ struct fc_rport_priv *fc_rport_rogue_create(struct fc_lport *lport,
 }
 
 /**
+ * fc_rport_destroy() - free a remote port after last reference is released.
+ * @kref: pointer to kref inside struct fc_rport_priv
+ */
+static void fc_rport_destroy(struct kref *kref)
+{
+	struct fc_rport_priv *rdata;
+	struct fc_rport *rport;
+
+	rdata = container_of(kref, struct fc_rport_priv, kref);
+	rport = rdata->rport;
+	put_device(&rport->dev);
+}
+
+/**
  * fc_rport_state() - return a string for the state the rport is in
  * @rdata: remote port private data
  */
@@ -215,22 +233,19 @@ static void fc_rport_work(struct work_struct *work)
 	enum fc_rport_trans_state trans_state;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_rport_operations *rport_ops;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
+	struct fc_rport *rport;
 
 	mutex_lock(&rdata->rp_mutex);
 	event = rdata->event;
 	rport_ops = rdata->ops;
+	rport = rdata->rport;
 
 	if (event == RPORT_EV_CREATED) {
 		struct fc_rport *new_rport;
 		struct fc_rport_priv *new_rdata;
 		struct fc_rport_identifiers ids;
 
-		ids.port_id = rport->port_id;
-		ids.roles = rport->roles;
-		ids.port_name = rport->port_name;
-		ids.node_name = rport->node_name;
-
+		ids = rdata->ids;
 		rdata->event = RPORT_EV_NONE;
 		mutex_unlock(&rdata->rp_mutex);
 
@@ -240,15 +255,20 @@ static void fc_rport_work(struct work_struct *work)
 			 * Switch from the rogue rport to the rport
 			 * returned by the FC class.
 			 */
-			new_rport->maxframe_size = rport->maxframe_size;
+			new_rport->maxframe_size = rdata->maxframe_size;
 
 			new_rdata = new_rport->dd_data;
+			new_rdata->rport = new_rport;
+			new_rdata->ids = ids;
 			new_rdata->e_d_tov = rdata->e_d_tov;
 			new_rdata->r_a_tov = rdata->r_a_tov;
 			new_rdata->ops = rdata->ops;
 			new_rdata->local_port = rdata->local_port;
 			new_rdata->flags = FC_RP_FLAGS_REC_SUPPORTED;
 			new_rdata->trans_state = FC_PORTSTATE_REAL;
+			new_rdata->maxframe_size = rdata->maxframe_size;
+			new_rdata->supported_classes = rdata->supported_classes;
+			kref_init(&new_rdata->kref);
 			mutex_init(&new_rdata->rp_mutex);
 			INIT_DELAYED_WORK(&new_rdata->retry_work,
 					  fc_rport_timeout);
@@ -261,12 +281,11 @@ static void fc_rport_work(struct work_struct *work)
 			       " memory for rport (%6x)\n", ids.port_id);
 			event = RPORT_EV_FAILED;
 		}
-		if (rport->port_id != FC_FID_DIR_SERV)
+		if (rdata->ids.port_id != FC_FID_DIR_SERV)
 			if (rport_ops->event_callback)
 				rport_ops->event_callback(lport, rdata,
 							  RPORT_EV_FAILED);
-		put_device(&rport->dev);
-		rport = new_rport;
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
 		rdata = new_rport->dd_data;
 		if (rport_ops->event_callback)
 			rport_ops->event_callback(lport, rdata, event);
@@ -279,7 +298,7 @@ static void fc_rport_work(struct work_struct *work)
 			rport_ops->event_callback(lport, rdata, event);
 		cancel_delayed_work_sync(&rdata->retry_work);
 		if (trans_state == FC_PORTSTATE_ROGUE)
-			put_device(&rport->dev);
+			kref_put(&rdata->kref, lport->tt.rport_destroy);
 		else {
 			port_id = rport->port_id;
 			fc_remote_port_delete(rport);
@@ -505,7 +524,6 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				void *rdata_arg)
 {
 	struct fc_rport_priv *rdata = rdata_arg;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_els_flogi *plp = NULL;
 	unsigned int tov;
@@ -533,8 +551,8 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC &&
 	    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
-		rport->port_name = get_unaligned_be64(&plp->fl_wwpn);
-		rport->node_name = get_unaligned_be64(&plp->fl_wwnn);
+		rdata->ids.port_name = get_unaligned_be64(&plp->fl_wwpn);
+		rdata->ids.node_name = get_unaligned_be64(&plp->fl_wwnn);
 
 		tov = ntohl(plp->fl_csp.sp_e_d_tov);
 		if (ntohs(plp->fl_csp.sp_features) & FC_SP_FT_EDTR)
@@ -546,14 +564,13 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		if (cssp_seq < csp_seq)
 			csp_seq = cssp_seq;
 		rdata->max_seq = csp_seq;
-		rport->maxframe_size =
-			fc_plogi_get_maxframe(plp, lport->mfs);
+		rdata->maxframe_size = fc_plogi_get_maxframe(plp, lport->mfs);
 
 		/*
 		 * If the rport is one of the well known addresses
 		 * we skip PRLI and RTV and go straight to READY.
 		 */
-		if (rport->port_id >= FC_FID_DOM_MGR)
+		if (rdata->ids.port_id >= FC_FID_DOM_MGR)
 			fc_rport_enter_ready(rdata);
 		else
 			fc_rport_enter_prli(rdata);
@@ -564,7 +581,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
-	put_device(&rport->dev);
+	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
 /**
@@ -577,7 +594,6 @@ err:
 static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 {
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_frame *fp;
 
 	FC_RPORT_DBG(rdata, "Port entered PLOGI state from %s state\n",
@@ -585,7 +601,7 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 
 	fc_rport_state_enter(rdata, RPORT_ST_PLOGI);
 
-	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
+	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp) {
 		fc_rport_error_retry(rdata, fp);
@@ -593,11 +609,11 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 	}
 	rdata->e_d_tov = lport->e_d_tov;
 
-	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_PLOGI,
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_PLOGI,
 				  fc_rport_plogi_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
-		get_device(&rport->dev);
+		kref_get(&rdata->kref);
 }
 
 /**
@@ -614,7 +630,6 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       void *rdata_arg)
 {
 	struct fc_rport_priv *rdata = rdata_arg;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct {
 		struct fc_els_prli prli;
 		struct fc_els_spp spp;
@@ -649,13 +664,13 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 				rdata->flags |= FC_RP_FLAGS_RETRY;
 		}
 
-		rport->supported_classes = FC_COS_CLASS3;
+		rdata->supported_classes = FC_COS_CLASS3;
 		if (fcp_parm & FCP_SPPF_INIT_FCN)
 			roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 		if (fcp_parm & FCP_SPPF_TARG_FCN)
 			roles |= FC_RPORT_ROLE_FCP_TARGET;
 
-		rport->roles = roles;
+		rdata->ids.roles = roles;
 		fc_rport_enter_rtv(rdata);
 
 	} else {
@@ -667,7 +682,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
-	put_device(&rport->dev);
+	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
 /**
@@ -684,7 +699,6 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       void *rdata_arg)
 {
 	struct fc_rport_priv *rdata = rdata_arg;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	u8 op;
 
 	mutex_lock(&rdata->rp_mutex);
@@ -716,7 +730,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
-	put_device(&rport->dev);
+	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
 /**
@@ -728,7 +742,6 @@ err:
  */
 static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 {
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct {
 		struct fc_els_prli prli;
@@ -747,11 +760,11 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_PRLI,
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_PRLI,
 				  fc_rport_prli_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
-		get_device(&rport->dev);
+		kref_get(&rdata->kref);
 }
 
 /**
@@ -770,7 +783,6 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 			      void *rdata_arg)
 {
 	struct fc_rport_priv *rdata = rdata_arg;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	u8 op;
 
 	mutex_lock(&rdata->rp_mutex);
@@ -818,7 +830,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
-	put_device(&rport->dev);
+	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
 /**
@@ -832,7 +844,6 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 {
 	struct fc_frame *fp;
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 
 	FC_RPORT_DBG(rdata, "Port entered RTV state from %s state\n",
 		     fc_rport_state(rdata));
@@ -845,11 +856,11 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_RTV,
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_RTV,
 				     fc_rport_rtv_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
-		get_device(&rport->dev);
+		kref_get(&rdata->kref);
 }
 
 /**
@@ -862,7 +873,6 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 {
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_frame *fp;
 
 	FC_RPORT_DBG(rdata, "Port entered LOGO state from %s state\n",
@@ -876,11 +886,11 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_LOGO,
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_LOGO,
 				  fc_rport_logo_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
-		get_device(&rport->dev);
+		kref_get(&rdata->kref);
 }
 
 
@@ -956,7 +966,6 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 static void fc_rport_recv_plogi_req(struct fc_rport_priv *rdata,
 				    struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp = rx_fp;
 	struct fc_exch *ep;
@@ -1041,12 +1050,13 @@ static void fc_rport_recv_plogi_req(struct fc_rport_priv *rdata,
 		} else {
 			sp = lport->tt.seq_start_next(sp);
 			WARN_ON(!sp);
-			fc_rport_set_name(rport, wwpn, wwnn);
+			rdata->ids.port_name = wwpn;
+			rdata->ids.node_name = wwnn;
 
 			/*
 			 * Get session payload size from incoming PLOGI.
 			 */
-			rport->maxframe_size =
+			rdata->maxframe_size =
 				fc_plogi_get_maxframe(pl, lport->mfs);
 			fc_frame_free(rx_fp);
 			fc_plogi_fill(lport, fp, ELS_LS_ACC);
@@ -1079,7 +1089,6 @@ static void fc_rport_recv_plogi_req(struct fc_rport_priv *rdata,
 static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 				   struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_exch *ep;
 	struct fc_frame *fp;
@@ -1173,12 +1182,12 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 				fcp_parm = ntohl(rspp->spp_params);
 				if (fcp_parm * FCP_SPPF_RETRY)
 					rdata->flags |= FC_RP_FLAGS_RETRY;
-				rport->supported_classes = FC_COS_CLASS3;
+				rdata->supported_classes = FC_COS_CLASS3;
 				if (fcp_parm & FCP_SPPF_INIT_FCN)
 					roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 				if (fcp_parm & FCP_SPPF_TARG_FCN)
 					roles |= FC_RPORT_ROLE_FCP_TARGET;
-				rport->roles = roles;
+				rdata->ids.roles = roles;
 
 				spp->spp_params =
 					htonl(lport->service_params);
@@ -1310,6 +1319,9 @@ int fc_rport_init(struct fc_lport *lport)
 	if (!lport->tt.rport_flush_queue)
 		lport->tt.rport_flush_queue = fc_rport_flush_queue;
 
+	if (!lport->tt.rport_destroy)
+		lport->tt.rport_destroy = fc_rport_destroy;
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_rport_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 2473167..a94d216 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -76,11 +76,7 @@ do {								\
 				(port_id), ##args))
 
 #define FC_RPORT_DBG(rdata, fmt, args...)				\
-do {									\
-	struct fc_lport *lport = rdata->local_port;			\
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);			\
-	FC_RPORT_ID_DBG(lport, rport->port_id, fmt, ##args);		\
-} while (0)
+	FC_RPORT_ID_DBG((rdata)->local_port, (rdata)->ids.port_id, fmt, ##args)
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
@@ -195,9 +191,13 @@ struct fc_rport_operations {
 /**
  * struct fc_rport_libfc_priv - libfc internal information about a remote port
  * @local_port: Fibre Channel host port instance
+ * @rport: transport remote port
+ * @kref: reference counter
  * @rp_state: state tracks progress of PLOGI, PRLI, and RTV exchanges
+ * @ids: remote port identifiers and roles
  * @flags: REC and RETRY supported flags
  * @max_seq: maximum number of concurrent sequences
+ * @maxframe_size: maximum frame size
  * @retries: retry count in current state
  * @e_d_tov: error detect timeout value (in msec)
  * @r_a_tov: resource allocation timeout value (in msec)
@@ -207,11 +207,15 @@ struct fc_rport_operations {
  */
 struct fc_rport_libfc_priv {
 	struct fc_lport		   *local_port;
+	struct fc_rport		   *rport;
+	struct kref		   kref;
 	enum fc_rport_state        rp_state;
+	struct fc_rport_identifiers ids;
 	u16			   flags;
 	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
 	#define FC_RP_FLAGS_RETRY		(1 << 1)
 	u16		           max_seq;
+	u16			   maxframe_size;
 	unsigned int	           retries;
 	unsigned int	           e_d_tov;
 	unsigned int	           r_a_tov;
@@ -222,19 +226,12 @@ struct fc_rport_libfc_priv {
 	struct fc_rport_operations *ops;
 	struct list_head           peers;
 	struct work_struct         event_work;
+	u32			   supported_classes;
 };
 
-#define PRIV_TO_RPORT(x)						\
-	((struct fc_rport *)((void *)(x) - sizeof(struct fc_rport)))
 #define RPORT_TO_PRIV(x)						\
 	((struct fc_rport_libfc_priv *)((void *)(x) + sizeof(struct fc_rport)))
 
-static inline void fc_rport_set_name(struct fc_rport *rport, u64 wwpn, u64 wwnn)
-{
-	rport->node_name = wwnn;
-	rport->port_name = wwpn;
-}
-
 /*
  * fcoe stats structure
  */
@@ -609,6 +606,12 @@ struct libfc_function_template {
 	struct fc_rport_priv *(*rport_lookup)(const struct fc_lport *, u32);
 
 	/*
+	 * Destroy an rport after final kref_put().
+	 * The argument is a pointer to the kref inside the fc_rport_priv.
+	 */
+	void (*rport_destroy)(struct kref *);
+
+	/*
 	 * Send a fcp cmd from fsp pkt.
 	 * Called with the SCSI host lock unlocked and irqs disabled.
 	 *

