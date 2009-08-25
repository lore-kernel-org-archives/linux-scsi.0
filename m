From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 51/64] libfc: Initialize fc_rport_identifiers inside
	fc_rport_create
Date: Tue, 25 Aug 2009 14:02:59 -0700
Message-ID: <20090825210259.1553.92655.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbZHYVDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:10 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Currently these values are initialized by the callers. This was exposed
by a later patch that adds PLOGI request support. The patch failed to
initialize the new remote port's roles and it caused problems. This patch
has the rport_create routine initialize the identifiers and then the
callers can override them with real values.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   20 ++++++++------------
 drivers/scsi/libfc/fc_lport.c |   19 ++++---------------
 drivers/scsi/libfc/fc_rport.c |   18 +++++++++++-------
 include/scsi/libfc.h          |   17 +++++++++--------
 4 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 1a699f4..4242894 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -137,10 +137,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 				break;
 			}
 			dp->lp = lport;
-			dp->ids.port_id = ntoh24(pp->rscn_fid);
-			dp->ids.port_name = -1;
-			dp->ids.node_name = -1;
-			dp->ids.roles = FC_RPORT_ROLE_UNKNOWN;
+			dp->port_id = ntoh24(pp->rscn_fid);
 			list_add_tail(&dp->peers, &disc_ports);
 			break;
 		case ELS_ADDR_FMT_AREA:
@@ -162,7 +159,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			    redisc, lport->state, disc->pending);
 		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
 			list_del(&dp->peers);
-			rdata = lport->tt.rport_lookup(lport, dp->ids.port_id);
+			rdata = lport->tt.rport_lookup(lport, dp->port_id);
 			if (rdata) {
 				lport->tt.rport_logoff(rdata);
 			}
@@ -435,15 +432,14 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	while (plen >= sizeof(*np)) {
 		ids.port_id = ntoh24(np->fp_fid);
 		ids.port_name = ntohll(np->fp_wwpn);
-		ids.node_name = -1;
-		ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
 		if (ids.port_id != fc_host_port_id(lport->host) &&
 		    ids.port_name != lport->wwpn) {
-			rdata = lport->tt.rport_create(lport, &ids);
-			if (rdata)
+			rdata = lport->tt.rport_create(lport, ids.port_id);
+			if (rdata) {
+				rdata->ids.port_name = ids.port_name;
 				rdata->disc_id = disc->disc_id;
-			else {
+			} else {
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
 				       "(%6x)\n", ids.port_id);
@@ -580,10 +576,10 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 
 	lport = disc->lport;
 
-	if (dp->ids.port_id == fc_host_port_id(lport->host))
+	if (dp->port_id == fc_host_port_id(lport->host))
 		goto out;
 
-	rdata = lport->tt.rport_create(lport, &dp->ids);
+	rdata = lport->tt.rport_create(lport, dp->port_id);
 	if (rdata) {
 		rdata->disc_id = disc->disc_id;
 		kfree(dp);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7000df5..caf6824 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -198,17 +198,12 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 			       u32 remote_fid, u64 remote_wwpn,
 			       u64 remote_wwnn)
 {
-	struct fc_rport_identifiers ids;
-
-	ids.port_id = remote_fid;
-	ids.port_name = remote_wwpn;
-	ids.node_name = remote_wwnn;
-	ids.roles = FC_RPORT_ROLE_UNKNOWN;
-
 	mutex_lock(&lport->disc.disc_mutex);
 	if (lport->ptp_rp)
 		lport->tt.rport_logoff(lport->ptp_rp);
-	lport->ptp_rp = lport->tt.rport_create(lport, &ids);
+	lport->ptp_rp = lport->tt.rport_create(lport, remote_fid);
+	lport->ptp_rp->ids.port_name = remote_wwpn;
+	lport->ptp_rp->ids.node_name = remote_wwnn;
 	mutex_unlock(&lport->disc.disc_mutex);
 
 	lport->tt.rport_login(lport->ptp_rp);
@@ -1287,12 +1282,6 @@ static struct fc_rport_operations fc_lport_rport_ops = {
 static void fc_lport_enter_dns(struct fc_lport *lport)
 {
 	struct fc_rport_priv *rdata;
-	struct fc_rport_identifiers ids;
-
-	ids.port_id = FC_FID_DIR_SERV;
-	ids.port_name = -1;
-	ids.node_name = -1;
-	ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
 	FC_LPORT_DBG(lport, "Entered DNS state from %s state\n",
 		     fc_lport_state(lport));
@@ -1300,7 +1289,7 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
 	mutex_lock(&lport->disc.disc_mutex);
-	rdata = lport->tt.rport_create(lport, &ids);
+	rdata = lport->tt.rport_create(lport, FC_FID_DIR_SERV);
 	mutex_unlock(&lport->disc.disc_mutex);
 	if (!rdata)
 		goto err;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 99ac056..c667be8 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -104,18 +104,18 @@ static struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 }
 
 /**
- * fc_rport_create() - create remote port in INIT state.
- * @lport: local port.
- * @ids: remote port identifiers.
+ * fc_rport_create() - Create a new remote port
+ * @lport:   The local port that the new remote port is for
+ * @port_id: The port ID for the new remote port
  *
  * Locking note:  must be called with the disc_mutex held.
  */
 static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
-					     struct fc_rport_identifiers *ids)
+					     u32 port_id)
 {
 	struct fc_rport_priv *rdata;
 
-	rdata = lport->tt.rport_lookup(lport, ids->port_id);
+	rdata = lport->tt.rport_lookup(lport, port_id);
 	if (rdata)
 		return rdata;
 
@@ -123,7 +123,11 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	if (!rdata)
 		return NULL;
 
-	rdata->ids = *ids;
+	rdata->ids.node_name = -1;
+	rdata->ids.port_name = -1;
+	rdata->ids.port_id = port_id;
+	rdata->ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
 	kref_init(&rdata->kref);
 	mutex_init(&rdata->rp_mutex);
 	rdata->local_port = lport;
@@ -135,7 +139,7 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
-	if (ids->port_id != FC_FID_DIR_SERV)
+	if (port_id != FC_FID_DIR_SERV)
 		list_add(&rdata->peers, &lport->disc.rports);
 	return rdata;
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 517dce5..cd410c1 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -148,16 +148,16 @@ enum fc_rport_state {
 
 /**
  * struct fc_disc_port - temporary discovery port to hold rport identifiers
- * @lp: Fibre Channel host port instance
- * @peers: node for list management during discovery and RSCN processing
- * @ids: identifiers structure to pass to fc_remote_port_add()
- * @rport_work: work struct for starting the rport state machine
+ * @lp:         Fibre Channel host port instance
+ * @peers:      Node for list management during discovery and RSCN processing
+ * @rport_work: Work struct for starting the rport state machine
+ * @port_id:    Port ID of the discovered port
  */
 struct fc_disc_port {
 	struct fc_lport             *lp;
 	struct list_head            peers;
-	struct fc_rport_identifiers ids;
 	struct work_struct	    rport_work;
+	u32                         port_id;
 };
 
 enum fc_rport_event {
@@ -565,10 +565,11 @@ struct libfc_function_template {
 	int (*lport_reset)(struct fc_lport *);
 
 	/*
-	 * Create a remote port
+	 * Create a remote port with a given port ID
+	 *
+	 * STATUS: OPTIONAL
 	 */
-	struct fc_rport_priv *(*rport_create)(struct fc_lport *,
-					      struct fc_rport_identifiers *);
+	struct fc_rport_priv *(*rport_create)(struct fc_lport *, u32);
 
 	/*
 	 * Initiates the RP state machine. It is called from the LP module.

