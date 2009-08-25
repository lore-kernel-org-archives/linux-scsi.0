From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 38/64] libfc: make rport module maintain the rport list
Date: Tue, 25 Aug 2009 14:01:50 -0700
Message-ID: <20090825210150.1553.80911.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbZHYVBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:48 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The list of remote ports (struct fc_rport_priv) has been
maintained by the discovery module.  In preparation for having
lport->tt.rport_create() do a lookup first, maintain the
rports list in the rport module.  It will still be protected
by the disc_mutex.

The DNS rport is an exception for until after further patches.
For now, do not add it to the list.

The point-to-point rport will be in the discovery list.
So at shutdown, it doesn't need to be separately logged out.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |    8 --------
 drivers/scsi/libfc/fc_lport.c |   14 ++++++--------
 drivers/scsi/libfc/fc_rport.c |   11 +++++++++--
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 8427396..e6b13bf 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -115,9 +115,6 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
 	case RPORT_EV_STOP:
-		mutex_lock(&disc->disc_mutex);
-		list_del(&rdata->peers);
-		mutex_unlock(&disc->disc_mutex);
 		break;
 	default:
 		break;
@@ -385,9 +382,6 @@ static int fc_disc_new_target(struct fc_disc *disc,
 				rdata = lport->tt.rport_create(lport, ids);
 				if (!rdata)
 					error = -ENOMEM;
-				else
-					list_add_tail(&rdata->peers,
-						      &disc->rports);
 			}
 		}
 		if (rdata) {
@@ -562,7 +556,6 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 			rdata = lport->tt.rport_create(lport, &ids);
 			if (rdata) {
 				rdata->ops = &fc_disc_rport_ops;
-				list_add_tail(&rdata->peers, &disc->rports);
 				lport->tt.rport_login(rdata);
 			} else
 				printk(KERN_WARNING "libfc: Failed to allocate "
@@ -709,7 +702,6 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (rdata) {
 		rdata->ops = &fc_disc_rport_ops;
 		kfree(dp);
-		list_add_tail(&rdata->peers, &disc->rports);
 		lport->tt.rport_login(rdata);
 	}
 	return;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 22c0f7b..f33e573 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -205,12 +205,11 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 	ids.node_name = remote_wwnn;
 	ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
-	if (lport->ptp_rp) {
+	mutex_lock(&lport->disc.disc_mutex);
+	if (lport->ptp_rp)
 		lport->tt.rport_logoff(lport->ptp_rp);
-		lport->ptp_rp = NULL;
-	}
-
 	lport->ptp_rp = lport->tt.rport_create(lport, &ids);
+	mutex_unlock(&lport->disc.disc_mutex);
 
 	lport->tt.rport_login(lport->ptp_rp);
 
@@ -931,10 +930,7 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	if (lport->dns_rp)
 		lport->tt.rport_logoff(lport->dns_rp);
 
-	if (lport->ptp_rp) {
-		lport->tt.rport_logoff(lport->ptp_rp);
-		lport->ptp_rp = NULL;
-	}
+	lport->ptp_rp = NULL;
 
 	lport->tt.disc_stop(lport);
 
@@ -1304,7 +1300,9 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
+	mutex_lock(&lport->disc.disc_mutex);
 	rdata = lport->tt.rport_create(lport, &ids);
+	mutex_unlock(&lport->disc.disc_mutex);
 	if (!rdata)
 		goto err;
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6ecf36d..a9087b3 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -91,8 +91,7 @@ static const char *fc_rport_state_names[] = {
  * @lport: local port.
  * @ids: remote port identifiers.
  *
- * Locking note: this may be called without locks held, but
- * is usually called from discovery with the disc_mutex held.
+ * Locking note:  must be called with the disc_mutex held.
  */
 static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 					     struct fc_rport_identifiers *ids)
@@ -115,6 +114,8 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
+	if (ids->port_id != FC_FID_DIR_SERV)
+		list_add(&rdata->peers, &lport->disc.rports);
 	return rdata;
 }
 
@@ -258,6 +259,12 @@ static void fc_rport_work(struct work_struct *work)
 		port_id = rdata->ids.port_id;
 		mutex_unlock(&rdata->rp_mutex);
 
+		if (port_id != FC_FID_DIR_SERV) {
+			mutex_lock(&lport->disc.disc_mutex);
+			list_del(&rdata->peers);
+			mutex_unlock(&lport->disc.disc_mutex);
+		}
+
 		if (rport_ops->event_callback) {
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
 			rport_ops->event_callback(lport, rdata, event);

