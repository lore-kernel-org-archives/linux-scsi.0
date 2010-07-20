From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/28] libfc: convert rport lookup to be RCU safe
Date: Tue, 20 Jul 2010 15:19:37 -0700
Message-ID: <20100720221937.17116.35940.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab0GTWTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:38 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

To allow LLD to do lookups on rports without grabbing a mutex,
make them RCU-safe.  The caller of lport->tt.rport_lookup will
have the choice of holding disc_mutex or the rcu_read_lock().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_disc.c  |    6 +++---
 drivers/scsi/libfc/fc_rport.c |   22 ++++++++++++++++++----
 include/scsi/libfc.h          |    2 ++
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index c7985da..d0fa9a0 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -63,12 +63,12 @@ static void fc_disc_restart(struct fc_disc *);
 void fc_disc_stop_rports(struct fc_disc *disc)
 {
 	struct fc_lport *lport;
-	struct fc_rport_priv *rdata, *next;
+	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
 
 	mutex_lock(&disc->disc_mutex);
-	list_for_each_entry_safe(rdata, next, &disc->rports, peers)
+	list_for_each_entry_rcu(rdata, &disc->rports, peers)
 		lport->tt.rport_logoff(rdata);
 	mutex_unlock(&disc->disc_mutex);
 }
@@ -292,7 +292,7 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 	 * Skip ports which were never discovered.  These are the dNS port
 	 * and ports which were created by PLOGI.
 	 */
-	list_for_each_entry(rdata, &disc->rports, peers) {
+	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
 		if (!rdata->disc_id)
 			continue;
 		if (rdata->disc_id == disc->disc_id)
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 363cde3..6b56973 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -95,13 +95,15 @@ static const char *fc_rport_state_names[] = {
  * fc_rport_lookup() - Lookup a remote port by port_id
  * @lport:   The local port to lookup the remote port on
  * @port_id: The remote port ID to look up
+ *
+ * The caller must hold either disc_mutex or rcu_read_lock().
  */
 static struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 					     u32 port_id)
 {
 	struct fc_rport_priv *rdata;
 
-	list_for_each_entry(rdata, &lport->disc.rports, peers)
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers)
 		if (rdata->ids.port_id == port_id)
 			return rdata;
 	return NULL;
@@ -146,11 +148,23 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
 	if (port_id != FC_FID_DIR_SERV)
-		list_add(&rdata->peers, &lport->disc.rports);
+		list_add_rcu(&rdata->peers, &lport->disc.rports);
 	return rdata;
 }
 
 /**
+ * fc_rport_free_rcu() - Free a remote port
+ * @rcu: The rcu_head structure inside the remote port
+ */
+static void fc_rport_free_rcu(struct rcu_head *rcu)
+{
+	struct fc_rport_priv *rdata;
+
+	rdata = container_of(rcu, struct fc_rport_priv, rcu);
+	kfree(rdata);
+}
+
+/**
  * fc_rport_destroy() - Free a remote port after last reference is released
  * @kref: The remote port's kref
  */
@@ -159,7 +173,7 @@ static void fc_rport_destroy(struct kref *kref)
 	struct fc_rport_priv *rdata;
 
 	rdata = container_of(kref, struct fc_rport_priv, kref);
-	kfree(rdata);
+	call_rcu(&rdata->rcu, fc_rport_free_rcu);
 }
 
 /**
@@ -334,7 +348,7 @@ static void fc_rport_work(struct work_struct *work)
 				mutex_unlock(&rdata->rp_mutex);
 			} else {
 				FC_RPORT_DBG(rdata, "work delete\n");
-				list_del(&rdata->peers);
+				list_del_rcu(&rdata->peers);
 				mutex_unlock(&rdata->rp_mutex);
 				kref_put(&rdata->kref, lport->tt.rport_destroy);
 			}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 6d78df7..b0310b9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -195,6 +195,7 @@ struct fc_rport_libfc_priv {
  * @rp_mutex:       The mutex that protects the remote port
  * @retry_work:     Handle for retries
  * @event_callback: Callback when READY, FAILED or LOGO states complete
+ * @rcu:	    Structure used for freeing in an RCU-safe manner
  */
 struct fc_rport_priv {
 	struct fc_lport		    *local_port;
@@ -217,6 +218,7 @@ struct fc_rport_priv {
 	struct list_head            peers;
 	struct work_struct          event_work;
 	u32			    supported_classes;
+	struct rcu_head		    rcu;
 };
 
 /**

