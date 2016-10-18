From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/20] libfc: Replace ->rport_logoff callback with function call
Date: Tue, 18 Oct 2016 10:01:44 +0200
Message-ID: <1476777714-3543-11-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752339AbcJRICb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:31 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->rport_logoff callback only ever had one implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |  3 +--
 drivers/scsi/fcoe/fcoe_ctlr.c    |  8 ++++----
 drivers/scsi/libfc/fc_disc.c     |  8 ++++----
 drivers/scsi/libfc/fc_lport.c    | 10 +++++-----
 drivers/scsi/libfc/fc_rport.c    |  8 +++-----
 include/scsi/libfc.h             |  9 +--------
 6 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 08ec318..739bfb6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -80,7 +80,6 @@ static void bnx2fc_offload_session(struct fcoe_port *port,
 					struct bnx2fc_rport *tgt,
 					struct fc_rport_priv *rdata)
 {
-	struct fc_lport *lport = rdata->local_port;
 	struct fc_rport *rport = rdata->rport;
 	struct bnx2fc_interface *interface = port->priv;
 	struct bnx2fc_hba *hba = interface->hba;
@@ -160,7 +159,7 @@ static void bnx2fc_offload_session(struct fcoe_port *port,
 tgt_init_err:
 	if (tgt->fcoe_conn_id != -1)
 		bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
-	lport->tt.rport_logoff(rdata);
+	fc_rport_logoff(rdata);
 }
 
 void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index ff0eca3..12aecf3 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2153,7 +2153,7 @@ static void fcoe_ctlr_vn_rport_callback(struct fc_lport *lport,
 			LIBFCOE_FIP_DBG(fip,
 					"rport FLOGI limited port_id %6.6x\n",
 					rdata->ids.port_id);
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 		}
 		break;
 	default:
@@ -2179,7 +2179,7 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
 	rcu_read_lock();
 	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
 		if (kref_get_unless_zero(&rdata->kref)) {
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 			kref_put(&rdata->kref, fc_rport_destroy);
 		}
 	}
@@ -2531,7 +2531,7 @@ static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
 	    (ids->node_name != -1 && ids->node_name != new->ids.node_name)) {
 		mutex_unlock(&rdata->rp_mutex);
 		LIBFCOE_FIP_DBG(fip, "vn_add rport logoff %6.6x\n", port_id);
-		lport->tt.rport_logoff(rdata);
+		fc_rport_logoff(rdata);
 		mutex_lock(&rdata->rp_mutex);
 	}
 	ids->port_name = new->ids.port_name;
@@ -2729,7 +2729,7 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
 			LIBFCOE_FIP_DBG(fip,
 				"port %16.16llx fc_id %6.6x beacon expired\n",
 				rdata->ids.port_name, rdata->ids.port_id);
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 		} else if (time_before(deadline, next_time))
 			next_time = deadline;
 		kref_put(&rdata->kref, fc_rport_destroy);
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 8d0aa19..7efa5a6 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -71,7 +71,7 @@ static void fc_disc_stop_rports(struct fc_disc *disc)
 	rcu_read_lock();
 	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
 		if (kref_get_unless_zero(&rdata->kref)) {
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 			kref_put(&rdata->kref, fc_rport_destroy);
 		}
 	}
@@ -301,7 +301,7 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 			if (rdata->disc_id == disc->disc_id)
 				fc_rport_login(rdata);
 			else
-				lport->tt.rport_logoff(rdata);
+				fc_rport_logoff(rdata);
 		}
 		kref_put(&rdata->kref, fc_rport_destroy);
 	}
@@ -622,7 +622,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 				    "Port-id %6.6x wwpn %16.16llx\n",
 				    rdata->ids.port_id, port_name);
 			mutex_unlock(&rdata->rp_mutex);
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 			mutex_lock(&lport->disc.disc_mutex);
 			new_rdata = fc_rport_create(lport, rdata->ids.port_id);
 			mutex_unlock(&lport->disc.disc_mutex);
@@ -638,7 +638,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
 		FC_DISC_DBG(disc, "GPN_ID rejected reason %x exp %x\n",
 			    cp->ct_reason, cp->ct_explan);
-		lport->tt.rport_logoff(rdata);
+		fc_rport_logoff(rdata);
 	} else {
 		FC_DISC_DBG(disc, "GPN_ID unexpected response code %x\n",
 			    ntohs(cp->ct_cmd));
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e20c151..a391cb1 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -200,7 +200,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				     "in the DNS or FDMI state, it's in the "
 				     "%d state", rdata->ids.port_id,
 				     lport->state);
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 		}
 		break;
 	case RPORT_EV_LOGO:
@@ -246,7 +246,7 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 			       u64 remote_wwnn)
 {
 	if (lport->ptp_rdata) {
-		lport->tt.rport_logoff(lport->ptp_rdata);
+		fc_rport_logoff(lport->ptp_rdata);
 		kref_put(&lport->ptp_rdata->kref, fc_rport_destroy);
 	}
 	mutex_lock(&lport->disc.disc_mutex);
@@ -623,7 +623,7 @@ int fc_fabric_logoff(struct fc_lport *lport)
 	lport->tt.disc_stop_final(lport);
 	mutex_lock(&lport->lp_mutex);
 	if (lport->dns_rdata)
-		lport->tt.rport_logoff(lport->dns_rdata);
+		fc_rport_logoff(lport->dns_rdata);
 	mutex_unlock(&lport->lp_mutex);
 	lport->tt.rport_flush_queue();
 	mutex_lock(&lport->lp_mutex);
@@ -1011,12 +1011,12 @@ int fc_lport_reset(struct fc_lport *lport)
 static void fc_lport_reset_locked(struct fc_lport *lport)
 {
 	if (lport->dns_rdata) {
-		lport->tt.rport_logoff(lport->dns_rdata);
+		fc_rport_logoff(lport->dns_rdata);
 		lport->dns_rdata = NULL;
 	}
 
 	if (lport->ptp_rdata) {
-		lport->tt.rport_logoff(lport->ptp_rdata);
+		fc_rport_logoff(lport->ptp_rdata);
 		kref_put(&lport->ptp_rdata->kref, fc_rport_destroy);
 		lport->ptp_rdata = NULL;
 	}
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c045bc4..22c8c92 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -295,7 +295,7 @@ static void fc_rport_work(struct work_struct *work)
 		}
 		if (!rport) {
 			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
-			lport->tt.rport_logoff(rdata);
+			fc_rport_logoff(rdata);
 			kref_put(&rdata->kref, fc_rport_destroy);
 			return;
 		}
@@ -504,7 +504,7 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
  */
-static int fc_rport_logoff(struct fc_rport_priv *rdata)
+int fc_rport_logoff(struct fc_rport_priv *rdata)
 {
 	struct fc_lport *lport = rdata->local_port;
 	u32 port_id = rdata->ids.port_id;
@@ -538,6 +538,7 @@ static int fc_rport_logoff(struct fc_rport_priv *rdata)
 	mutex_unlock(&rdata->rp_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(fc_rport_logoff);
 
 /**
  * fc_rport_enter_ready() - Transition to the RPORT_ST_READY state
@@ -2184,9 +2185,6 @@ static void fc_rport_flush_queue(void)
  */
 int fc_rport_init(struct fc_lport *lport)
 {
-	if (!lport->tt.rport_logoff)
-		lport->tt.rport_logoff = fc_rport_logoff;
-
 	if (!lport->tt.rport_recv_req)
 		lport->tt.rport_recv_req = fc_rport_recv_req;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 6404577..b75a182 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -610,14 +610,6 @@ struct libfc_function_template {
 				  struct fc_frame *);
 
 	/*
-	 * Logoff, and remove the rport from the transport if
-	 * it had been added. This will send a LOGO to the target.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	int (*rport_logoff)(struct fc_rport_priv *);
-
-	/*
 	 * Receive a request from a remote port.
 	 *
 	 * STATUS: OPTIONAL
@@ -1007,6 +999,7 @@ struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 struct fc_rport_priv *fc_rport_create(struct fc_lport *, u32);
 void fc_rport_destroy(struct kref *kref);
 int fc_rport_login(struct fc_rport_priv *rdata);
+int fc_rport_logoff(struct fc_rport_priv *rdata);
 
 /*
  * DISCOVERY LAYER
-- 
1.8.5.6

