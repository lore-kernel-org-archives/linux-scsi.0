From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/20] libfc: Replace ->rport_login callback with function call
Date: Tue, 18 Oct 2016 10:01:43 +0200
Message-ID: <1476777714-3543-10-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758292AbcJRIC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:29 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->rport_login callback only ever had one implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |  4 ++--
 drivers/scsi/libfc/fc_disc.c  |  6 +++---
 drivers/scsi/libfc/fc_lport.c |  6 +++---
 drivers/scsi/libfc/fc_rport.c | 14 ++++++++++----
 include/scsi/libfc.h          | 14 +-------------
 5 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 38e6779..ff0eca3 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2674,7 +2674,7 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 				LIBFCOE_FIP_DBG(fip, "beacon expired "
 						"for rport %x\n",
 						rdata->ids.port_id);
-				lport->tt.rport_login(rdata);
+				fc_rport_login(rdata);
 			}
 			frport->time = jiffies;
 		}
@@ -3088,7 +3088,7 @@ static void fcoe_ctlr_vn_disc(struct fcoe_ctlr *fip)
 			continue;
 		frport = fcoe_ctlr_rport(rdata);
 		if (frport->time)
-			lport->tt.rport_login(rdata);
+			fc_rport_login(rdata);
 		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 	rcu_read_unlock();
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 305dd85..8d0aa19 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -299,7 +299,7 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 			continue;
 		if (rdata->disc_id) {
 			if (rdata->disc_id == disc->disc_id)
-				lport->tt.rport_login(rdata);
+				fc_rport_login(rdata);
 			else
 				lport->tt.rport_logoff(rdata);
 		}
@@ -628,13 +628,13 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 			mutex_unlock(&lport->disc.disc_mutex);
 			if (new_rdata) {
 				new_rdata->disc_id = disc->disc_id;
-				lport->tt.rport_login(new_rdata);
+				fc_rport_login(new_rdata);
 			}
 			goto out;
 		}
 		rdata->disc_id = disc->disc_id;
 		mutex_unlock(&rdata->rp_mutex);
-		lport->tt.rport_login(rdata);
+		fc_rport_login(rdata);
 	} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
 		FC_DISC_DBG(disc, "GPN_ID rejected reason %x exp %x\n",
 			    cp->ct_reason, cp->ct_explan);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a16936a..e20c151 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -256,7 +256,7 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 	lport->ptp_rdata->ids.node_name = remote_wwnn;
 	mutex_unlock(&lport->disc.disc_mutex);
 
-	lport->tt.rport_login(lport->ptp_rdata);
+	fc_rport_login(lport->ptp_rdata);
 
 	fc_lport_enter_ready(lport);
 }
@@ -1437,7 +1437,7 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 		goto err;
 
 	rdata->ops = &fc_lport_rport_ops;
-	lport->tt.rport_login(rdata);
+	fc_rport_login(rdata);
 	return;
 
 err:
@@ -1554,7 +1554,7 @@ static void fc_lport_enter_fdmi(struct fc_lport *lport)
 		goto err;
 
 	rdata->ops = &fc_lport_rport_ops;
-	lport->tt.rport_login(rdata);
+	fc_rport_login(rdata);
 	return;
 
 err:
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b05fa99..c045bc4 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -412,6 +412,14 @@ static void fc_rport_work(struct work_struct *work)
  * fc_rport_login() - Start the remote port login state machine
  * @rdata: The remote port to be logged in to
  *
+ * Initiates the RP state machine. It is called from the LP module.
+ * This function will issue the following commands to the N_Port
+ * identified by the FC ID provided.
+ *
+ * - PLOGI
+ * - PRLI
+ * - RTV
+ *
  * Locking Note: Called without the rport lock held. This
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
@@ -420,7 +428,7 @@ static void fc_rport_work(struct work_struct *work)
  * If it appears we are already logged in, ADISC is used to verify
  * the setup.
  */
-static int fc_rport_login(struct fc_rport_priv *rdata)
+int fc_rport_login(struct fc_rport_priv *rdata)
 {
 	mutex_lock(&rdata->rp_mutex);
 
@@ -452,6 +460,7 @@ static int fc_rport_login(struct fc_rport_priv *rdata)
 
 	return 0;
 }
+EXPORT_SYMBOL(fc_rport_login);
 
 /**
  * fc_rport_enter_delete() - Schedule a remote port to be deleted
@@ -2175,9 +2184,6 @@ static void fc_rport_flush_queue(void)
  */
 int fc_rport_init(struct fc_lport *lport)
 {
-	if (!lport->tt.rport_login)
-		lport->tt.rport_login = fc_rport_login;
-
 	if (!lport->tt.rport_logoff)
 		lport->tt.rport_logoff = fc_rport_logoff;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 47b69d2..6404577 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -610,19 +610,6 @@ struct libfc_function_template {
 				  struct fc_frame *);
 
 	/*
-	 * Initiates the RP state machine. It is called from the LP module.
-	 * This function will issue the following commands to the N_Port
-	 * identified by the FC ID provided.
-	 *
-	 * - PLOGI
-	 * - PRLI
-	 * - RTV
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	int (*rport_login)(struct fc_rport_priv *);
-
-	/*
 	 * Logoff, and remove the rport from the transport if
 	 * it had been added. This will send a LOGO to the target.
 	 *
@@ -1019,6 +1006,7 @@ struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 				      u32 port_id);
 struct fc_rport_priv *fc_rport_create(struct fc_lport *, u32);
 void fc_rport_destroy(struct kref *kref);
+int fc_rport_login(struct fc_rport_priv *rdata);
 
 /*
  * DISCOVERY LAYER
-- 
1.8.5.6

