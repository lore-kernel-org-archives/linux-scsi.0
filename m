From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/17] libfc: Don't violate transport template for rogue port
	creation
Date: Fri, 06 Feb 2009 10:56:05 -0800
Message-ID: <20090206185605.26188.69322.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZBFS4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:05 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |    6 +++---
 drivers/scsi/libfc/fc_lport.c |    4 ++--
 drivers/scsi/libfc/fc_rport.c |    3 +++
 include/scsi/libfc.h          |    5 +++++
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index dd1564c..15e3f84 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -430,7 +430,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 				dp.ids.port_name = ids->port_name;
 				dp.ids.node_name = ids->node_name;
 				dp.ids.roles = ids->roles;
-				rport = fc_rport_rogue_create(&dp);
+				rport = lport->tt.rport_create(&dp);
 			}
 			if (!rport)
 				error = -ENOMEM;
@@ -617,7 +617,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 
 		if ((dp.ids.port_id != fc_host_port_id(lport->host)) &&
 		    (dp.ids.port_name != lport->wwpn)) {
-			rport = fc_rport_rogue_create(&dp);
+			rport = lport->tt.rport_create(&dp);
 			if (rport) {
 				rdata = rport->dd_data;
 				rdata->ops = &fc_disc_rport_ops;
@@ -769,7 +769,7 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (rport)
 		fc_disc_del_target(disc, rport);
 
-	new_rport = fc_rport_rogue_create(dp);
+	new_rport = lport->tt.rport_create(dp);
 	if (new_rport) {
 		rdata = new_rport->dd_data;
 		rdata->ops = &fc_disc_rport_ops;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a60b919..60ac36f 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -232,7 +232,7 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 		lport->ptp_rp = NULL;
 	}
 
-	lport->ptp_rp = fc_rport_rogue_create(&dp);
+	lport->ptp_rp = lport->tt.rport_create(&dp);
 
 	lport->tt.rport_login(lport->ptp_rp);
 
@@ -1282,7 +1282,7 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
-	rport = fc_rport_rogue_create(&dp);
+	rport = lport->tt.rport_create(&dp);
 	if (!rport)
 		goto err;
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 600a8ff..81b3ca1 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1271,6 +1271,9 @@ static void fc_rport_flush_queue(void)
 
 int fc_rport_init(struct fc_lport *lport)
 {
+	if (!lport->tt.rport_create)
+		lport->tt.rport_create = fc_rport_rogue_create;
+
 	if (!lport->tt.rport_login)
 		lport->tt.rport_login = fc_rport_login;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b9e6c1c..37df48e 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -490,6 +490,11 @@ struct libfc_function_template {
 	 */
 
 	/*
+	 * Create a remote port
+	 */
+	struct fc_rport *(*rport_create)(struct fc_disc_port *);
+
+	/*
 	 * Initiates the RP state machine. It is called from the LP module.
 	 * This function will issue the following commands to the N_Port
 	 * identified by the FC ID provided.

