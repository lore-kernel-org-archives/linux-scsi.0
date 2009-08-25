From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 32/64] libfc: don't create dummy (rogue) remote ports
Date: Tue, 25 Aug 2009 14:01:18 -0700
Message-ID: <20090825210118.1553.77228.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21722 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188AbZHYVBQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:16 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Don't create a "dummy" remote port to go with fc_rport_priv.

Make the rport truly optional by allocating fc_rport_priv separately
and not requiring a dummy rport to be there if we haven't yet done
fc_remote_port_add().

The fc_rport_libfc_priv remains as a structure attached to the
rport for I/O purposes.

Be sure to hold references on rdata when the lock is dropped in
fc_rport_work().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   40 +++--------
 drivers/scsi/libfc/fc_rport.c |  154 +++++++++++++++++------------------------
 include/scsi/libfc.h          |   40 +++++------
 3 files changed, 92 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index e5e5b26..bbea41e 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -66,7 +66,8 @@ struct fc_rport_priv *fc_disc_lookup_rport(const struct fc_lport *lport,
 	struct fc_rport_priv *rdata;
 
 	list_for_each_entry(rdata, &disc->rports, peers) {
-		if (rdata->ids.port_id == port_id)
+		if (rdata->ids.port_id == port_id &&
+		    rdata->rp_state != RPORT_ST_DELETE)
 			return rdata;
 	}
 	return NULL;
@@ -87,15 +88,8 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 	lport = disc->lport;
 
 	mutex_lock(&disc->disc_mutex);
-	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
-		list_del(&rdata->peers);
+	list_for_each_entry_safe(rdata, next, &disc->rports, peers)
 		lport->tt.rport_logoff(rdata);
-	}
-
-	list_for_each_entry_safe(rdata, next, &disc->rogue_rports, peers) {
-		lport->tt.rport_logoff(rdata);
-	}
-
 	mutex_unlock(&disc->disc_mutex);
 }
 
@@ -119,20 +113,12 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 
 	switch (event) {
 	case RPORT_EV_READY:
-		if (disc) {
-			mutex_lock(&disc->disc_mutex);
-			list_add_tail(&rdata->peers, &disc->rports);
-			mutex_unlock(&disc->disc_mutex);
-		}
 		break;
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
 	case RPORT_EV_STOP:
 		mutex_lock(&disc->disc_mutex);
-		mutex_lock(&rdata->rp_mutex);
-		if (rdata->trans_state == FC_PORTSTATE_ROGUE)
-			list_del(&rdata->peers);
-		mutex_unlock(&rdata->rp_mutex);
+		list_del(&rdata->peers);
 		mutex_unlock(&disc->disc_mutex);
 		break;
 	default:
@@ -235,7 +221,6 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			list_del(&dp->peers);
 			rdata = lport->tt.rport_lookup(lport, dp->ids.port_id);
 			if (rdata) {
-				list_del(&rdata->peers);
 				lport->tt.rport_logoff(rdata);
 			}
 			fc_disc_single(disc, dp);
@@ -296,10 +281,8 @@ static void fc_disc_restart(struct fc_disc *disc)
 
 	FC_DISC_DBG(disc, "Restarting discovery\n");
 
-	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
-		list_del(&rdata->peers);
+	list_for_each_entry_safe(rdata, next, &disc->rports, peers)
 		lport->tt.rport_logoff(rdata);
-	}
 
 	disc->requested = 1;
 	if (!disc->pending)
@@ -392,7 +375,6 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			 * assigned the same FCID.  This should be rare.
 			 * Delete the old one and fall thru to re-create.
 			 */
-			list_del(&rdata->peers);
 			lport->tt.rport_logoff(rdata);
 			rdata = NULL;
 		}
@@ -406,12 +388,13 @@ static int fc_disc_new_target(struct fc_disc *disc,
 				rdata = lport->tt.rport_create(lport, ids);
 				if (!rdata)
 					error = -ENOMEM;
+				else
+					list_add_tail(&rdata->peers,
+						      &disc->rports);
 			}
 		}
 		if (rdata) {
 			rdata->ops = &fc_disc_rport_ops;
-			rdata->rp_state = RPORT_ST_INIT;
-			list_add_tail(&rdata->peers, &disc->rogue_rports);
 			lport->tt.rport_login(rdata);
 		}
 	}
@@ -585,9 +568,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 			rdata = lport->tt.rport_create(lport, &ids);
 			if (rdata) {
 				rdata->ops = &fc_disc_rport_ops;
-				rdata->local_port = lport;
-				list_add_tail(&rdata->peers,
-					      &disc->rogue_rports);
+				list_add_tail(&rdata->peers, &disc->rports);
 				lport->tt.rport_login(rdata);
 			} else
 				printk(KERN_WARNING "libfc: Failed to allocate "
@@ -736,7 +717,7 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (rdata) {
 		rdata->ops = &fc_disc_rport_ops;
 		kfree(dp);
-		list_add_tail(&rdata->peers, &disc->rogue_rports);
+		list_add_tail(&rdata->peers, &disc->rports);
 		lport->tt.rport_login(rdata);
 	}
 	return;
@@ -798,7 +779,6 @@ int fc_disc_init(struct fc_lport *lport)
 	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
 	mutex_init(&disc->disc_mutex);
 	INIT_LIST_HEAD(&disc->rports);
-	INIT_LIST_HEAD(&disc->rogue_rports);
 
 	disc->lport = lport;
 	disc->delay = FC_DISC_DELAY;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 50959ba..a1794a3 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -86,61 +86,35 @@ static const char *fc_rport_state_names[] = {
 	[RPORT_ST_DELETE] = "Delete",
 };
 
-static void fc_rport_rogue_destroy(struct device *dev)
-{
-	struct fc_rport *rport = dev_to_rport(dev);
-	struct fc_rport_priv *rdata = RPORT_TO_PRIV(rport);
-
-	FC_RPORT_DBG(rdata, "Destroying rogue rport\n");
-	kfree(rport);
-}
-
-struct fc_rport_priv *fc_rport_rogue_create(struct fc_lport *lport,
-					    struct fc_rport_identifiers *ids)
+/**
+ * fc_rport_create() - create remote port in INIT state.
+ * @lport: local port.
+ * @ids: remote port identifiers.
+ *
+ * Locking note: this may be called without locks held, but
+ * is usually called from discovery with the disc_mutex held.
+ */
+static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
+					     struct fc_rport_identifiers *ids)
 {
-	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
-	rport = kzalloc(sizeof(*rport) + sizeof(*rdata), GFP_KERNEL);
 
-	if (!rport)
+	rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
+	if (!rdata)
 		return NULL;
 
-	rdata = RPORT_TO_PRIV(rport);
-
-	rport->dd_data = rdata;
-	rport->port_id = ids->port_id;
-	rport->port_name = ids->port_name;
-	rport->node_name = ids->node_name;
-	rport->roles = ids->roles;
-	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
-	/*
-	 * Note: all this libfc rogue rport code will be removed for
-	 * upstream so it fine that this is really ugly and hacky right now.
-	 */
-	device_initialize(&rport->dev);
-	rport->dev.release = fc_rport_rogue_destroy;
-
 	rdata->ids = *ids;
 	kref_init(&rdata->kref);
 	mutex_init(&rdata->rp_mutex);
-	rdata->rport = rport;
 	rdata->local_port = lport;
-	rdata->trans_state = FC_PORTSTATE_ROGUE;
 	rdata->rp_state = RPORT_ST_INIT;
 	rdata->event = RPORT_EV_NONE;
 	rdata->flags = FC_RP_FLAGS_REC_SUPPORTED;
-	rdata->ops = NULL;
 	rdata->e_d_tov = lport->e_d_tov;
 	rdata->r_a_tov = lport->r_a_tov;
 	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
-	/*
-	 * For good measure, but not necessary as we should only
-	 * add REAL rport to the lport list.
-	 */
-	INIT_LIST_HEAD(&rdata->peers);
-
 	return rdata;
 }
 
@@ -151,11 +125,9 @@ struct fc_rport_priv *fc_rport_rogue_create(struct fc_lport *lport,
 static void fc_rport_destroy(struct kref *kref)
 {
 	struct fc_rport_priv *rdata;
-	struct fc_rport *rport;
 
 	rdata = container_of(kref, struct fc_rport_priv, kref);
-	rport = rdata->rport;
-	put_device(&rport->dev);
+	kfree(rdata);
 }
 
 /**
@@ -229,12 +201,10 @@ static void fc_rport_work(struct work_struct *work)
 	u32 port_id;
 	struct fc_rport_priv *rdata =
 		container_of(work, struct fc_rport_priv, event_work);
+	struct fc_rport_libfc_priv *rp;
 	enum fc_rport_event event;
-	enum fc_rport_trans_state trans_state;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_rport_operations *rport_ops;
-	struct fc_rport *new_rport;
-	struct fc_rport_priv *new_rdata;
 	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
 
@@ -243,70 +213,72 @@ static void fc_rport_work(struct work_struct *work)
 	rport_ops = rdata->ops;
 	rport = rdata->rport;
 
+	FC_RPORT_DBG(rdata, "work event %u\n", event);
+
 	switch (event) {
 	case RPORT_EV_READY:
 		ids = rdata->ids;
 		rdata->event = RPORT_EV_NONE;
+		kref_get(&rdata->kref);
 		mutex_unlock(&rdata->rp_mutex);
 
-		new_rport = fc_remote_port_add(lport->host, 0, &ids);
-		if (new_rport) {
-			/*
-			 * Switch from the rogue rport to the rport
-			 * returned by the FC class.
-			 */
-			new_rport->maxframe_size = rdata->maxframe_size;
-
-			new_rdata = new_rport->dd_data;
-			new_rdata->rport = new_rport;
-			new_rdata->ids = ids;
-			new_rdata->e_d_tov = rdata->e_d_tov;
-			new_rdata->r_a_tov = rdata->r_a_tov;
-			new_rdata->ops = rdata->ops;
-			new_rdata->local_port = rdata->local_port;
-			new_rdata->flags = FC_RP_FLAGS_REC_SUPPORTED;
-			new_rdata->trans_state = FC_PORTSTATE_REAL;
-			new_rdata->maxframe_size = rdata->maxframe_size;
-			new_rdata->supported_classes = rdata->supported_classes;
-			kref_init(&new_rdata->kref);
-			mutex_init(&new_rdata->rp_mutex);
-			INIT_DELAYED_WORK(&new_rdata->retry_work,
-					  fc_rport_timeout);
-			INIT_LIST_HEAD(&new_rdata->peers);
-			INIT_WORK(&new_rdata->event_work, fc_rport_work);
-
-			fc_rport_state_enter(new_rdata, RPORT_ST_READY);
-		} else {
-			printk(KERN_WARNING "libfc: Failed to allocate "
-			       " memory for rport (%6x)\n", ids.port_id);
-			event = RPORT_EV_FAILED;
+		if (!rport)
+			rport = fc_remote_port_add(lport->host, 0, &ids);
+		if (!rport) {
+			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
+			lport->tt.rport_logoff(rdata);
+			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			return;
 		}
-		if (rdata->ids.port_id != FC_FID_DIR_SERV)
-			if (rport_ops->event_callback)
-				rport_ops->event_callback(lport, rdata,
-							  RPORT_EV_FAILED);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
-		rdata = new_rport->dd_data;
-		if (rport_ops->event_callback)
+		mutex_lock(&rdata->rp_mutex);
+		if (rdata->rport)
+			FC_RPORT_DBG(rdata, "rport already allocated\n");
+		rdata->rport = rport;
+		rport->maxframe_size = rdata->maxframe_size;
+		rport->supported_classes = rdata->supported_classes;
+
+		rp = rport->dd_data;
+		rp->local_port = lport;
+		rp->rp_state = rdata->rp_state;
+		rp->flags = rdata->flags;
+		rp->e_d_tov = rdata->e_d_tov;
+		rp->r_a_tov = rdata->r_a_tov;
+		mutex_unlock(&rdata->rp_mutex);
+
+		if (rport_ops->event_callback) {
+			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
+		}
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
 		break;
 
 	case RPORT_EV_FAILED:
 	case RPORT_EV_LOGO:
 	case RPORT_EV_STOP:
-		trans_state = rdata->trans_state;
+		port_id = rdata->ids.port_id;
 		mutex_unlock(&rdata->rp_mutex);
-		if (rport_ops->event_callback)
+
+		if (rport_ops->event_callback) {
+			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);
+		}
 		cancel_delayed_work_sync(&rdata->retry_work);
-		if (trans_state == FC_PORTSTATE_ROGUE)
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
-		else {
-			port_id = rport->port_id;
+
+		/*
+		 * Reset any outstanding exchanges before freeing rport.
+		 */
+		lport->tt.exch_mgr_reset(lport, 0, port_id);
+		lport->tt.exch_mgr_reset(lport, port_id, 0);
+
+		if (rport) {
+			rp = rport->dd_data;
+			rp->rp_state = RPORT_ST_DELETE;
+			mutex_lock(&rdata->rp_mutex);
+			rdata->rport = NULL;
+			mutex_unlock(&rdata->rp_mutex);
 			fc_remote_port_delete(rport);
-			lport->tt.exch_mgr_reset(lport, 0, port_id);
-			lport->tt.exch_mgr_reset(lport, port_id, 0);
 		}
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
 		break;
 
 	default:
@@ -1311,7 +1283,7 @@ static void fc_rport_flush_queue(void)
 int fc_rport_init(struct fc_lport *lport)
 {
 	if (!lport->tt.rport_create)
-		lport->tt.rport_create = fc_rport_rogue_create;
+		lport->tt.rport_create = fc_rport_create;
 
 	if (!lport->tt.rport_login)
 		lport->tt.rport_login = fc_rport_login;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index d324df8..bf4b1c2 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -146,11 +146,6 @@ enum fc_rport_state {
 	RPORT_ST_DELETE,	/* port being deleted */
 };
 
-enum fc_rport_trans_state {
-	FC_PORTSTATE_ROGUE,
-	FC_PORTSTATE_REAL,
-};
-
 /**
  * struct fc_disc_port - temporary discovery port to hold rport identifiers
  * @lp: Fibre Channel host port instance
@@ -173,14 +168,6 @@ enum fc_rport_event {
 	RPORT_EV_LOGO
 };
 
-/*
- * Temporary definition to prepare for split off from fc_rport_libfc_priv
- * of a separately-allocated structure called fc_rport_priv.  This will
- * be the primary object for the discovery and rport state machines.
- * This definition is just to make this patch series easier to review.
- */
-#define fc_rport_priv fc_rport_libfc_priv
-
 struct fc_rport_priv;
 
 struct fc_rport_operations {
@@ -191,6 +178,24 @@ struct fc_rport_operations {
 /**
  * struct fc_rport_libfc_priv - libfc internal information about a remote port
  * @local_port: Fibre Channel host port instance
+ * @rp_state: indicates READY for I/O or DELETE when blocked.
+ * @flags: REC and RETRY supported flags
+ * @e_d_tov: error detect timeout value (in msec)
+ * @r_a_tov: resource allocation timeout value (in msec)
+ */
+struct fc_rport_libfc_priv {
+	struct fc_lport		   *local_port;
+	enum fc_rport_state        rp_state;
+	u16			   flags;
+	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
+	#define FC_RP_FLAGS_RETRY		(1 << 1)
+	unsigned int	           e_d_tov;
+	unsigned int	           r_a_tov;
+};
+
+/**
+ * struct fc_rport_priv - libfc rport and discovery info about a remote port
+ * @local_port: Fibre Channel host port instance
  * @rport: transport remote port
  * @kref: reference counter
  * @rp_state: state tracks progress of PLOGI, PRLI, and RTV exchanges
@@ -205,21 +210,18 @@ struct fc_rport_operations {
  * @retry_work:
  * @event_callback: Callback for rport READY, FAILED or LOGO
  */
-struct fc_rport_libfc_priv {
+struct fc_rport_priv {
 	struct fc_lport		   *local_port;
 	struct fc_rport		   *rport;
 	struct kref		   kref;
 	enum fc_rport_state        rp_state;
 	struct fc_rport_identifiers ids;
 	u16			   flags;
-	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
-	#define FC_RP_FLAGS_RETRY		(1 << 1)
 	u16		           max_seq;
 	u16			   maxframe_size;
 	unsigned int	           retries;
 	unsigned int	           e_d_tov;
 	unsigned int	           r_a_tov;
-	enum fc_rport_trans_state  trans_state;
 	struct mutex               rp_mutex;
 	struct delayed_work	   retry_work;
 	enum fc_rport_event        event;
@@ -229,9 +231,6 @@ struct fc_rport_libfc_priv {
 	u32			   supported_classes;
 };
 
-#define RPORT_TO_PRIV(x)						\
-	((struct fc_rport_libfc_priv *)((void *)(x) + sizeof(struct fc_rport)))
-
 /*
  * fcoe stats structure
  */
@@ -686,7 +685,6 @@ struct fc_disc {
 			      enum fc_disc_event);
 
 	struct list_head	 rports;
-	struct list_head	 rogue_rports;
 	struct fc_lport		*lport;
 	struct mutex		disc_mutex;
 	struct fc_gpn_ft_resp	partial_buf;	/* partial name buffer */

