From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/20] libfc: Replace ->rport_lookup callback with function call
Date: Tue, 18 Oct 2016 10:01:40 +0200
Message-ID: <1476777714-3543-7-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47323 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755524AbcJRIC2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:28 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->rport_lookup callback only ever had a single implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |  4 ++--
 drivers/scsi/libfc/fc_lport.c |  2 +-
 drivers/scsi/libfc/fc_rport.c | 16 +++++++---------
 include/scsi/libfc.h          |  9 ++-------
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 4fc7677..bae4e5a 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2561,7 +2561,7 @@ static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *fip, u32 port_id, u8 *mac)
 	struct fcoe_rport *frport;
 	int ret = -1;
 
-	rdata = lport->tt.rport_lookup(lport, port_id);
+	rdata = fc_rport_lookup(lport, port_id);
 	if (rdata) {
 		frport = fcoe_ctlr_rport(rdata);
 		memcpy(mac, frport->enode_mac, ETH_ALEN);
@@ -2663,7 +2663,7 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		return;
 	}
-	rdata = lport->tt.rport_lookup(lport, new->ids.port_id);
+	rdata = fc_rport_lookup(lport, new->ids.port_id);
 	if (rdata) {
 		if (rdata->ids.node_name == new->ids.node_name &&
 		    rdata->ids.port_name == new->ids.port_name) {
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ad45808..2da6c7c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2125,7 +2125,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 				break;
 			tov = rdata->e_d_tov;
 		} else {
-			rdata = lport->tt.rport_lookup(lport, did);
+			rdata = fc_rport_lookup(lport, did);
 			if (!rdata)
 				break;
 			tov = rdata->e_d_tov;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 47ab962..5f674fc 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -111,8 +111,8 @@
  * The reference count of the fc_rport_priv structure is
  * increased by one.
  */
-static struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
-					     u32 port_id)
+struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
+				      u32 port_id)
 {
 	struct fc_rport_priv *rdata = NULL, *tmp_rdata;
 
@@ -126,6 +126,7 @@ static struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 	rcu_read_unlock();
 	return rdata;
 }
+EXPORT_SYMBOL(fc_rport_lookup);
 
 /**
  * fc_rport_create() - Create a new remote port
@@ -141,7 +142,7 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 {
 	struct fc_rport_priv *rdata;
 
-	rdata = lport->tt.rport_lookup(lport, port_id);
+	rdata = fc_rport_lookup(lport, port_id);
 	if (rdata)
 		return rdata;
 
@@ -875,7 +876,7 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		goto reject;
 	}
 
-	rdata = lport->tt.rport_lookup(lport, sid);
+	rdata = fc_rport_lookup(lport, sid);
 	if (!rdata) {
 		rjt_data.reason = ELS_RJT_FIP;
 		rjt_data.explan = ELS_EXPL_NOT_NEIGHBOR;
@@ -1684,7 +1685,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	struct fc_rport_priv *rdata;
 	struct fc_seq_els_data els_data;
 
-	rdata = lport->tt.rport_lookup(lport, fc_frame_sid(fp));
+	rdata = fc_rport_lookup(lport, fc_frame_sid(fp));
 	if (!rdata) {
 		FC_RPORT_ID_DBG(lport, fc_frame_sid(fp),
 				"Received ELS 0x%02x from non-logged-in port\n",
@@ -2145,7 +2146,7 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 
 	sid = fc_frame_sid(fp);
 
-	rdata = lport->tt.rport_lookup(lport, sid);
+	rdata = fc_rport_lookup(lport, sid);
 	if (rdata) {
 		mutex_lock(&rdata->rp_mutex);
 		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
@@ -2174,9 +2175,6 @@ static void fc_rport_flush_queue(void)
  */
 int fc_rport_init(struct fc_lport *lport)
 {
-	if (!lport->tt.rport_lookup)
-		lport->tt.rport_lookup = fc_rport_lookup;
-
 	if (!lport->tt.rport_create)
 		lport->tt.rport_create = fc_rport_create;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index cec450f..683201f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -645,13 +645,6 @@ struct libfc_function_template {
 	void (*rport_recv_req)(struct fc_lport *, struct fc_frame *);
 
 	/*
-	 * lookup an rport by it's port ID.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	struct fc_rport_priv *(*rport_lookup)(const struct fc_lport *, u32);
-
-	/*
 	 * Callback routine after the remote port is logged in
 	 *
 	 * STATUS: OPTIONAL
@@ -1029,6 +1022,8 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
  *****************************/
 int fc_rport_init(struct fc_lport *);
 void fc_rport_terminate_io(struct fc_rport *);
+struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
+				      u32 port_id);
 void fc_rport_destroy(struct kref *kref);
 
 /*
-- 
1.8.5.6

