From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 41/64] libfc: move rport_lookup into fc_rport.c
Date: Tue, 25 Aug 2009 14:02:06 -0700
Message-ID: <20090825210206.1553.64396.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36718 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbZHYVCE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:04 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Move the libfc remote port lookup function into fc_rport.c.
This seems like the best place for it.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   22 ----------------------
 drivers/scsi/libfc/fc_rport.c |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 3fcbba1..f6762a5 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -53,25 +53,6 @@ static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
 static void fc_disc_restart(struct fc_disc *);
 
 /**
- * fc_disc_lookup_rport() - lookup a remote port by port_id
- * @lport: Fibre Channel host port instance
- * @port_id: remote port port_id to match
- */
-struct fc_rport_priv *fc_disc_lookup_rport(const struct fc_lport *lport,
-					   u32 port_id)
-{
-	const struct fc_disc *disc = &lport->disc;
-	struct fc_rport_priv *rdata;
-
-	list_for_each_entry(rdata, &disc->rports, peers) {
-		if (rdata->ids.port_id == port_id &&
-		    rdata->rp_state != RPORT_ST_DELETE)
-			return rdata;
-	}
-	return NULL;
-}
-
-/**
  * fc_disc_stop_rports() - delete all the remote ports associated with the lport
  * @disc: The discovery job to stop rports on
  *
@@ -714,9 +695,6 @@ int fc_disc_init(struct fc_lport *lport)
 	if (!lport->tt.disc_recv_req)
 		lport->tt.disc_recv_req = fc_disc_recv_req;
 
-	if (!lport->tt.rport_lookup)
-		lport->tt.rport_lookup = fc_disc_lookup_rport;
-
 	disc = &lport->disc;
 	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
 	mutex_init(&disc->disc_mutex);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 406049c..99ac056 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -87,6 +87,23 @@ static const char *fc_rport_state_names[] = {
 };
 
 /**
+ * fc_rport_lookup() - lookup a remote port by port_id
+ * @lport: Fibre Channel host port instance
+ * @port_id: remote port port_id to match
+ */
+static struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
+					     u32 port_id)
+{
+	struct fc_rport_priv *rdata;
+
+	list_for_each_entry(rdata, &lport->disc.rports, peers)
+		if (rdata->ids.port_id == port_id &&
+		    rdata->rp_state != RPORT_ST_DELETE)
+			return rdata;
+	return NULL;
+}
+
+/**
  * fc_rport_create() - create remote port in INIT state.
  * @lport: local port.
  * @ids: remote port identifiers.
@@ -1292,6 +1309,9 @@ static void fc_rport_flush_queue(void)
 
 int fc_rport_init(struct fc_lport *lport)
 {
+	if (!lport->tt.rport_lookup)
+		lport->tt.rport_lookup = fc_rport_lookup;
+
 	if (!lport->tt.rport_create)
 		lport->tt.rport_create = fc_rport_create;
 

