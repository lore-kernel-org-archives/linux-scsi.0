From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 25/64] libfc: change interface for rport_create
Date: Tue, 25 Aug 2009 14:00:39 -0700
Message-ID: <20090825210039.1553.84260.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105AbZHYVAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:38 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The interface for lport->tt.rport_create() takes a fc_disc_port arg,
which is unnatural for most calls.   The only reason for this was
to avoid passing in the local port as an argument, but otherwise
added to complexity.

Simplify by just using lport and fc_rport_identifiers.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   31 ++++++++++++-------------------
 drivers/scsi/libfc/fc_lport.c |   26 ++++++++++++--------------
 drivers/scsi/libfc/fc_rport.c |   17 +++++++++--------
 include/scsi/libfc.h          |    5 ++---
 4 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4c8d893..ecc625c 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -428,13 +428,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 		if (!rport) {
 			rport = lport->tt.rport_lookup(lport, ids->port_id);
 			if (!rport) {
-				struct fc_disc_port dp;
-				dp.lp = lport;
-				dp.ids.port_id = ids->port_id;
-				dp.ids.port_name = ids->port_name;
-				dp.ids.node_name = ids->node_name;
-				dp.ids.roles = ids->roles;
-				rport = lport->tt.rport_create(&dp);
+				rport = lport->tt.rport_create(lport, ids);
 			}
 			if (!rport)
 				error = -ENOMEM;
@@ -578,7 +572,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	size_t plen;
 	size_t tlen;
 	int error = 0;
-	struct fc_disc_port dp;
+	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
 
@@ -621,15 +615,14 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	 * After the first time through the loop, things return to "normal".
 	 */
 	while (plen >= sizeof(*np)) {
-		dp.lp = lport;
-		dp.ids.port_id = ntoh24(np->fp_fid);
-		dp.ids.port_name = ntohll(np->fp_wwpn);
-		dp.ids.node_name = -1;
-		dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
-
-		if ((dp.ids.port_id != fc_host_port_id(lport->host)) &&
-		    (dp.ids.port_name != lport->wwpn)) {
-			rport = lport->tt.rport_create(&dp);
+		ids.port_id = ntoh24(np->fp_fid);
+		ids.port_name = ntohll(np->fp_wwpn);
+		ids.node_name = -1;
+		ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
+		if (ids.port_id != fc_host_port_id(lport->host) &&
+		    ids.port_name != lport->wwpn) {
+			rport = lport->tt.rport_create(lport, &ids);
 			if (rport) {
 				rdata = rport->dd_data;
 				rdata->ops = &fc_disc_rport_ops;
@@ -640,7 +633,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 			} else
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
-				       "(%6x)\n", dp.ids.port_id);
+				       "(%6x)\n", ids.port_id);
 		}
 
 		if (np->fp_flags & FC_NS_FID_LAST) {
@@ -781,7 +774,7 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (dp->ids.port_id == fc_host_port_id(lport->host))
 		goto out;
 
-	new_rport = lport->tt.rport_create(dp);
+	new_rport = lport->tt.rport_create(lport, &dp->ids);
 	if (new_rport) {
 		rdata = new_rport->dd_data;
 		rdata->ops = &fc_disc_rport_ops;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index f7f328f..a78161c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -211,20 +211,19 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 			       u32 remote_fid, u64 remote_wwpn,
 			       u64 remote_wwnn)
 {
-	struct fc_disc_port dp;
+	struct fc_rport_identifiers ids;
 
-	dp.lp = lport;
-	dp.ids.port_id = remote_fid;
-	dp.ids.port_name = remote_wwpn;
-	dp.ids.node_name = remote_wwnn;
-	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
+	ids.port_id = remote_fid;
+	ids.port_name = remote_wwpn;
+	ids.node_name = remote_wwnn;
+	ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
 	if (lport->ptp_rp) {
 		lport->tt.rport_logoff(lport->ptp_rp);
 		lport->ptp_rp = NULL;
 	}
 
-	lport->ptp_rp = lport->tt.rport_create(&dp);
+	lport->ptp_rp = lport->tt.rport_create(lport, &ids);
 
 	lport->tt.rport_login(lport->ptp_rp);
 
@@ -1307,20 +1306,19 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 {
 	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
-	struct fc_disc_port dp;
+	struct fc_rport_identifiers ids;
 
-	dp.ids.port_id = FC_FID_DIR_SERV;
-	dp.ids.port_name = -1;
-	dp.ids.node_name = -1;
-	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
-	dp.lp = lport;
+	ids.port_id = FC_FID_DIR_SERV;
+	ids.port_name = -1;
+	ids.node_name = -1;
+	ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
 	FC_LPORT_DBG(lport, "Entered DNS state from %s state\n",
 		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
-	rport = lport->tt.rport_create(&dp);
+	rport = lport->tt.rport_create(lport, &ids);
 	if (!rport)
 		goto err;
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 5f8f437..2fbc94a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -93,7 +93,8 @@ static void fc_rport_rogue_destroy(struct device *dev)
 	kfree(rport);
 }
 
-struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
+struct fc_rport *fc_rport_rogue_create(struct fc_lport *lport,
+				       struct fc_rport_identifiers *ids)
 {
 	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
@@ -105,10 +106,10 @@ struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
 	rdata = RPORT_TO_PRIV(rport);
 
 	rport->dd_data = rdata;
-	rport->port_id = dp->ids.port_id;
-	rport->port_name = dp->ids.port_name;
-	rport->node_name = dp->ids.node_name;
-	rport->roles = dp->ids.roles;
+	rport->port_id = ids->port_id;
+	rport->port_name = ids->port_name;
+	rport->node_name = ids->node_name;
+	rport->roles = ids->roles;
 	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	/*
 	 * Note: all this libfc rogue rport code will be removed for
@@ -118,14 +119,14 @@ struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
 	rport->dev.release = fc_rport_rogue_destroy;
 
 	mutex_init(&rdata->rp_mutex);
-	rdata->local_port = dp->lp;
+	rdata->local_port = lport;
 	rdata->trans_state = FC_PORTSTATE_ROGUE;
 	rdata->rp_state = RPORT_ST_INIT;
 	rdata->event = RPORT_EV_NONE;
 	rdata->flags = FC_RP_FLAGS_REC_SUPPORTED;
 	rdata->ops = NULL;
-	rdata->e_d_tov = dp->lp->e_d_tov;
-	rdata->r_a_tov = dp->lp->r_a_tov;
+	rdata->e_d_tov = lport->e_d_tov;
+	rdata->r_a_tov = lport->r_a_tov;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
 	/*
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index aa21951..d888cbe 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -227,8 +227,6 @@ struct fc_rport_libfc_priv {
 #define RPORT_TO_PRIV(x)						\
 	(struct fc_rport_libfc_priv *)((void *)x + sizeof(struct fc_rport));
 
-struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *);
-
 static inline void fc_rport_set_name(struct fc_rport *rport, u64 wwpn, u64 wwnn)
 {
 	rport->node_name = wwnn;
@@ -569,7 +567,8 @@ struct libfc_function_template {
 	/*
 	 * Create a remote port
 	 */
-	struct fc_rport *(*rport_create)(struct fc_disc_port *);
+	struct fc_rport *(*rport_create)(struct fc_lport *,
+					 struct fc_rport_identifiers *);
 
 	/*
 	 * Initiates the RP state machine. It is called from the LP module.

