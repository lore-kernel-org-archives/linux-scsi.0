From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.3-rc2
Date: Fri, 02 Aug 2019 08:39:17 -0700
Message-ID: <1564760357.3413.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Seven fixes to four drivers with no core changes.  The mpt3sas one is
theoretical until we get a CPU that goes up to 64 bits physical, the
qla2xxx one fixes an oops in a driver initialization error leg and the
others are mostly minor fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Don Brace (2):
      scsi: hpsa: remove printing internal cdb on tag collision
      scsi: hpsa: correct scsi command status issue after reset

Hannes Reinecke (3):
      scsi: fcoe: pass in fcoe_rport structure instead of fc_rport_priv
      scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure
      scsi: libfc: Whitespace cleanup in libfc.h

Jia-Ju Bai (1):
      scsi: qla2xxx: Fix possible fcport null-pointer dereferences

Suganath Prabu (1):
      scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

And the diffstat:

 drivers/scsi/fcoe/fcoe_ctlr.c       | 138 +++++++++++++++++-------------------
 drivers/scsi/hpsa.c                 |  14 +++-
 drivers/scsi/libfc/fc_rport.c       |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c |  12 ++--
 drivers/scsi/qla2xxx/qla_init.c     |   2 +-
 include/scsi/libfc.h                |  52 +++++++-------
 include/scsi/libfcoe.h              |   1 +
 7 files changed, 115 insertions(+), 109 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 1a85fe9e4b7b..1791a393795d 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2005,7 +2005,7 @@ EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
  */
 static inline struct fcoe_rport *fcoe_ctlr_rport(struct fc_rport_priv *rdata)
 {
-	return (struct fcoe_rport *)(rdata + 1);
+	return container_of(rdata, struct fcoe_rport, rdata);
 }
 
 /**
@@ -2269,7 +2269,7 @@ static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
  */
 static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
 			      struct sk_buff *skb,
-			      struct fc_rport_priv *rdata)
+			      struct fcoe_rport *frport)
 {
 	struct fip_header *fiph;
 	struct fip_desc *desc = NULL;
@@ -2277,16 +2277,12 @@ static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
 	struct fip_wwn_desc *wwn = NULL;
 	struct fip_vn_desc *vn = NULL;
 	struct fip_size_desc *size = NULL;
-	struct fcoe_rport *frport;
 	size_t rlen;
 	size_t dlen;
 	u32 desc_mask = 0;
 	u32 dtype;
 	u8 sub;
 
-	memset(rdata, 0, sizeof(*rdata) + sizeof(*frport));
-	frport = fcoe_ctlr_rport(rdata);
-
 	fiph = (struct fip_header *)skb->data;
 	frport->flags = ntohs(fiph->fip_flags);
 
@@ -2349,15 +2345,17 @@ static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
 			if (dlen != sizeof(struct fip_wwn_desc))
 				goto len_err;
 			wwn = (struct fip_wwn_desc *)desc;
-			rdata->ids.node_name = get_unaligned_be64(&wwn->fd_wwn);
+			frport->rdata.ids.node_name =
+				get_unaligned_be64(&wwn->fd_wwn);
 			break;
 		case FIP_DT_VN_ID:
 			if (dlen != sizeof(struct fip_vn_desc))
 				goto len_err;
 			vn = (struct fip_vn_desc *)desc;
 			memcpy(frport->vn_mac, vn->fd_mac, ETH_ALEN);
-			rdata->ids.port_id = ntoh24(vn->fd_fc_id);
-			rdata->ids.port_name = get_unaligned_be64(&vn->fd_wwpn);
+			frport->rdata.ids.port_id = ntoh24(vn->fd_fc_id);
+			frport->rdata.ids.port_name =
+				get_unaligned_be64(&vn->fd_wwpn);
 			break;
 		case FIP_DT_FC4F:
 			if (dlen != sizeof(struct fip_fc4_feat))
@@ -2403,16 +2401,14 @@ static void fcoe_ctlr_vn_send_claim(struct fcoe_ctlr *fip)
 /**
  * fcoe_ctlr_vn_probe_req() - handle incoming VN2VN probe request.
  * @fip: The FCoE controller
- * @rdata: parsed remote port with frport from the probe request
+ * @frport: parsed FCoE rport from the probe request
  *
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
-				   struct fc_rport_priv *rdata)
+				   struct fcoe_rport *frport)
 {
-	struct fcoe_rport *frport = fcoe_ctlr_rport(rdata);
-
-	if (rdata->ids.port_id != fip->port_id)
+	if (frport->rdata.ids.port_id != fip->port_id)
 		return;
 
 	switch (fip->state) {
@@ -2432,7 +2428,7 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
 		 * Probe's REC bit is not set.
 		 * If we don't reply, we will change our address.
 		 */
-		if (fip->lp->wwpn > rdata->ids.port_name &&
+		if (fip->lp->wwpn > frport->rdata.ids.port_name &&
 		    !(frport->flags & FIP_FL_REC_OR_P2P)) {
 			LIBFCOE_FIP_DBG(fip, "vn_probe_req: "
 					"port_id collision\n");
@@ -2456,14 +2452,14 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
 /**
  * fcoe_ctlr_vn_probe_reply() - handle incoming VN2VN probe reply.
  * @fip: The FCoE controller
- * @rdata: parsed remote port with frport from the probe request
+ * @frport: parsed FCoE rport from the probe request
  *
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_probe_reply(struct fcoe_ctlr *fip,
-				   struct fc_rport_priv *rdata)
+				     struct fcoe_rport *frport)
 {
-	if (rdata->ids.port_id != fip->port_id)
+	if (frport->rdata.ids.port_id != fip->port_id)
 		return;
 	switch (fip->state) {
 	case FIP_ST_VNMP_START:
@@ -2486,11 +2482,11 @@ static void fcoe_ctlr_vn_probe_reply(struct fcoe_ctlr *fip,
 /**
  * fcoe_ctlr_vn_add() - Add a VN2VN entry to the list, based on a claim reply.
  * @fip: The FCoE controller
- * @new: newly-parsed remote port with frport as a template for new rdata
+ * @new: newly-parsed FCoE rport as a template for new rdata
  *
  * Called with ctlr_mutex held.
  */
-static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
+static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fcoe_rport *new)
 {
 	struct fc_lport *lport = fip->lp;
 	struct fc_rport_priv *rdata;
@@ -2498,7 +2494,7 @@ static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
 	struct fcoe_rport *frport;
 	u32 port_id;
 
-	port_id = new->ids.port_id;
+	port_id = new->rdata.ids.port_id;
 	if (port_id == fip->port_id)
 		return;
 
@@ -2515,22 +2511,28 @@ static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
 	rdata->disc_id = lport->disc.disc_id;
 
 	ids = &rdata->ids;
-	if ((ids->port_name != -1 && ids->port_name != new->ids.port_name) ||
-	    (ids->node_name != -1 && ids->node_name != new->ids.node_name)) {
+	if ((ids->port_name != -1 &&
+	     ids->port_name != new->rdata.ids.port_name) ||
+	    (ids->node_name != -1 &&
+	     ids->node_name != new->rdata.ids.node_name)) {
 		mutex_unlock(&rdata->rp_mutex);
 		LIBFCOE_FIP_DBG(fip, "vn_add rport logoff %6.6x\n", port_id);
 		fc_rport_logoff(rdata);
 		mutex_lock(&rdata->rp_mutex);
 	}
-	ids->port_name = new->ids.port_name;
-	ids->node_name = new->ids.node_name;
+	ids->port_name = new->rdata.ids.port_name;
+	ids->node_name = new->rdata.ids.node_name;
 	mutex_unlock(&rdata->rp_mutex);
 
 	frport = fcoe_ctlr_rport(rdata);
 	LIBFCOE_FIP_DBG(fip, "vn_add rport %6.6x %s state %d\n",
 			port_id, frport->fcoe_len ? "old" : "new",
 			rdata->rp_state);
-	*frport = *fcoe_ctlr_rport(new);
+	frport->fcoe_len = new->fcoe_len;
+	frport->flags = new->flags;
+	frport->login_count = new->login_count;
+	memcpy(frport->enode_mac, new->enode_mac, ETH_ALEN);
+	memcpy(frport->vn_mac, new->vn_mac, ETH_ALEN);
 	frport->time = 0;
 }
 
@@ -2562,16 +2564,14 @@ static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *fip, u32 port_id, u8 *mac)
 /**
  * fcoe_ctlr_vn_claim_notify() - handle received FIP VN2VN Claim Notification
  * @fip: The FCoE controller
- * @new: newly-parsed remote port with frport as a template for new rdata
+ * @new: newly-parsed FCoE rport as a template for new rdata
  *
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
-				      struct fc_rport_priv *new)
+				      struct fcoe_rport *new)
 {
-	struct fcoe_rport *frport = fcoe_ctlr_rport(new);
-
-	if (frport->flags & FIP_FL_REC_OR_P2P) {
+	if (new->flags & FIP_FL_REC_OR_P2P) {
 		LIBFCOE_FIP_DBG(fip, "send probe req for P2P/REC\n");
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		return;
@@ -2580,7 +2580,7 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 	case FIP_ST_VNMP_START:
 	case FIP_ST_VNMP_PROBE1:
 	case FIP_ST_VNMP_PROBE2:
-		if (new->ids.port_id == fip->port_id) {
+		if (new->rdata.ids.port_id == fip->port_id) {
 			LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
 					"restart, state %d\n",
 					fip->state);
@@ -2589,8 +2589,8 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 		break;
 	case FIP_ST_VNMP_CLAIM:
 	case FIP_ST_VNMP_UP:
-		if (new->ids.port_id == fip->port_id) {
-			if (new->ids.port_name > fip->lp->wwpn) {
+		if (new->rdata.ids.port_id == fip->port_id) {
+			if (new->rdata.ids.port_name > fip->lp->wwpn) {
 				LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
 						"restart, port_id collision\n");
 				fcoe_ctlr_vn_restart(fip);
@@ -2602,15 +2602,16 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 			break;
 		}
 		LIBFCOE_FIP_DBG(fip, "vn_claim_notify: send reply to %x\n",
-				new->ids.port_id);
-		fcoe_ctlr_vn_send(fip, FIP_SC_VN_CLAIM_REP, frport->enode_mac,
-				  min((u32)frport->fcoe_len,
+				new->rdata.ids.port_id);
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_CLAIM_REP, new->enode_mac,
+				  min((u32)new->fcoe_len,
 				      fcoe_ctlr_fcoe_size(fip)));
 		fcoe_ctlr_vn_add(fip, new);
 		break;
 	default:
 		LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
-				"ignoring claim from %x\n", new->ids.port_id);
+				"ignoring claim from %x\n",
+				new->rdata.ids.port_id);
 		break;
 	}
 }
@@ -2618,15 +2619,15 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 /**
  * fcoe_ctlr_vn_claim_resp() - handle received Claim Response
  * @fip: The FCoE controller that received the frame
- * @new: newly-parsed remote port with frport from the Claim Response
+ * @new: newly-parsed FCoE rport from the Claim Response
  *
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_claim_resp(struct fcoe_ctlr *fip,
-				    struct fc_rport_priv *new)
+				    struct fcoe_rport *new)
 {
 	LIBFCOE_FIP_DBG(fip, "claim resp from from rport %x - state %s\n",
-			new->ids.port_id, fcoe_ctlr_state(fip->state));
+			new->rdata.ids.port_id, fcoe_ctlr_state(fip->state));
 	if (fip->state == FIP_ST_VNMP_UP || fip->state == FIP_ST_VNMP_CLAIM)
 		fcoe_ctlr_vn_add(fip, new);
 }
@@ -2634,28 +2635,28 @@ static void fcoe_ctlr_vn_claim_resp(struct fcoe_ctlr *fip,
 /**
  * fcoe_ctlr_vn_beacon() - handle received beacon.
  * @fip: The FCoE controller that received the frame
- * @new: newly-parsed remote port with frport from the Beacon
+ * @new: newly-parsed FCoE rport from the Beacon
  *
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
-				struct fc_rport_priv *new)
+				struct fcoe_rport *new)
 {
 	struct fc_lport *lport = fip->lp;
 	struct fc_rport_priv *rdata;
 	struct fcoe_rport *frport;
 
-	frport = fcoe_ctlr_rport(new);
-	if (frport->flags & FIP_FL_REC_OR_P2P) {
+	if (new->flags & FIP_FL_REC_OR_P2P) {
 		LIBFCOE_FIP_DBG(fip, "p2p beacon while in vn2vn mode\n");
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		return;
 	}
-	rdata = fc_rport_lookup(lport, new->ids.port_id);
+	rdata = fc_rport_lookup(lport, new->rdata.ids.port_id);
 	if (rdata) {
-		if (rdata->ids.node_name == new->ids.node_name &&
-		    rdata->ids.port_name == new->ids.port_name) {
+		if (rdata->ids.node_name == new->rdata.ids.node_name &&
+		    rdata->ids.port_name == new->rdata.ids.port_name) {
 			frport = fcoe_ctlr_rport(rdata);
+
 			LIBFCOE_FIP_DBG(fip, "beacon from rport %x\n",
 					rdata->ids.port_id);
 			if (!frport->time && fip->state == FIP_ST_VNMP_UP) {
@@ -2678,7 +2679,7 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 	 * Don't add the neighbor yet.
 	 */
 	LIBFCOE_FIP_DBG(fip, "beacon from new rport %x. sending claim notify\n",
-			new->ids.port_id);
+			new->rdata.ids.port_id);
 	if (time_after(jiffies,
 		       fip->sol_time + msecs_to_jiffies(FIP_VN_ANN_WAIT)))
 		fcoe_ctlr_vn_send_claim(fip);
@@ -2738,10 +2739,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fip_header *fiph;
 	enum fip_vn2vn_subcode sub;
-	struct {
-		struct fc_rport_priv rdata;
-		struct fcoe_rport frport;
-	} buf;
+	struct fcoe_rport frport = { };
 	int rc, vlan_id = 0;
 
 	fiph = (struct fip_header *)skb->data;
@@ -2757,7 +2755,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		goto drop;
 	}
 
-	rc = fcoe_ctlr_vn_parse(fip, skb, &buf.rdata);
+	rc = fcoe_ctlr_vn_parse(fip, skb, &frport);
 	if (rc) {
 		LIBFCOE_FIP_DBG(fip, "vn_recv vn_parse error %d\n", rc);
 		goto drop;
@@ -2766,19 +2764,19 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	mutex_lock(&fip->ctlr_mutex);
 	switch (sub) {
 	case FIP_SC_VN_PROBE_REQ:
-		fcoe_ctlr_vn_probe_req(fip, &buf.rdata);
+		fcoe_ctlr_vn_probe_req(fip, &frport);
 		break;
 	case FIP_SC_VN_PROBE_REP:
-		fcoe_ctlr_vn_probe_reply(fip, &buf.rdata);
+		fcoe_ctlr_vn_probe_reply(fip, &frport);
 		break;
 	case FIP_SC_VN_CLAIM_NOTIFY:
-		fcoe_ctlr_vn_claim_notify(fip, &buf.rdata);
+		fcoe_ctlr_vn_claim_notify(fip, &frport);
 		break;
 	case FIP_SC_VN_CLAIM_REP:
-		fcoe_ctlr_vn_claim_resp(fip, &buf.rdata);
+		fcoe_ctlr_vn_claim_resp(fip, &frport);
 		break;
 	case FIP_SC_VN_BEACON:
-		fcoe_ctlr_vn_beacon(fip, &buf.rdata);
+		fcoe_ctlr_vn_beacon(fip, &frport);
 		break;
 	default:
 		LIBFCOE_FIP_DBG(fip, "vn_recv unknown subcode %d\n", sub);
@@ -2802,22 +2800,18 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
  */
 static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *fip,
 			      struct sk_buff *skb,
-			      struct fc_rport_priv *rdata)
+			      struct fcoe_rport *frport)
 {
 	struct fip_header *fiph;
 	struct fip_desc *desc = NULL;
 	struct fip_mac_desc *macd = NULL;
 	struct fip_wwn_desc *wwn = NULL;
-	struct fcoe_rport *frport;
 	size_t rlen;
 	size_t dlen;
 	u32 desc_mask = 0;
 	u32 dtype;
 	u8 sub;
 
-	memset(rdata, 0, sizeof(*rdata) + sizeof(*frport));
-	frport = fcoe_ctlr_rport(rdata);
-
 	fiph = (struct fip_header *)skb->data;
 	frport->flags = ntohs(fiph->fip_flags);
 
@@ -2871,7 +2865,8 @@ static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *fip,
 			if (dlen != sizeof(struct fip_wwn_desc))
 				goto len_err;
 			wwn = (struct fip_wwn_desc *)desc;
-			rdata->ids.node_name = get_unaligned_be64(&wwn->fd_wwn);
+			frport->rdata.ids.node_name =
+				get_unaligned_be64(&wwn->fd_wwn);
 			break;
 		default:
 			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
@@ -2957,13 +2952,13 @@ static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
 /**
  * fcoe_ctlr_vlan_disk_reply() - send FIP VLAN Discovery Notification.
  * @fip: The FCoE controller
+ * @frport: The newly-parsed FCoE rport from the Discovery Request
  *
  * Called with ctlr_mutex held.
  */
 static void fcoe_ctlr_vlan_disc_reply(struct fcoe_ctlr *fip,
-				      struct fc_rport_priv *rdata)
+				      struct fcoe_rport *frport)
 {
-	struct fcoe_rport *frport = fcoe_ctlr_rport(rdata);
 	enum fip_vlan_subcode sub = FIP_SC_VL_NOTE;
 
 	if (fip->mode == FIP_MODE_VN2VN)
@@ -2982,22 +2977,19 @@ static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fip_header *fiph;
 	enum fip_vlan_subcode sub;
-	struct {
-		struct fc_rport_priv rdata;
-		struct fcoe_rport frport;
-	} buf;
+	struct fcoe_rport frport = { };
 	int rc;
 
 	fiph = (struct fip_header *)skb->data;
 	sub = fiph->fip_subcode;
-	rc = fcoe_ctlr_vlan_parse(fip, skb, &buf.rdata);
+	rc = fcoe_ctlr_vlan_parse(fip, skb, &frport);
 	if (rc) {
 		LIBFCOE_FIP_DBG(fip, "vlan_recv vlan_parse error %d\n", rc);
 		goto drop;
 	}
 	mutex_lock(&fip->ctlr_mutex);
 	if (sub == FIP_SC_VL_REQ)
-		fcoe_ctlr_vlan_disc_reply(fip, &buf.rdata);
+		fcoe_ctlr_vlan_disc_reply(fip, &frport);
 	mutex_unlock(&fip->ctlr_mutex);
 
 drop:
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 43a6b5350775..bba099e53266 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2334,6 +2334,8 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 	case IOACCEL2_SERV_RESPONSE_COMPLETE:
 		switch (c2->error_data.status) {
 		case IOACCEL2_STATUS_SR_TASK_COMP_GOOD:
+			if (cmd)
+				cmd->result = 0;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_CHK_COND:
 			cmd->result |= SAM_STAT_CHECK_CONDITION;
@@ -2483,8 +2485,10 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 
 	/* check for good status */
 	if (likely(c2->error_data.serv_response == 0 &&
-			c2->error_data.status == 0))
+			c2->error_data.status == 0)) {
+		cmd->result = 0;
 		return hpsa_cmd_free_and_done(h, c, cmd);
+	}
 
 	/*
 	 * Any RAID offload error results in retry which will use
@@ -5653,6 +5657,12 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	if (c == NULL)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
+	/*
+	 * This is necessary because the SML doesn't zero out this field during
+	 * error recovery.
+	 */
+	cmd->result = 0;
+
 	/*
 	 * Call alternate submit routine for I/O accelerated commands.
 	 * Retries always go down the normal I/O path.
@@ -6081,8 +6091,6 @@ static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 		if (idx != h->last_collision_tag) { /* Print once per tag */
 			dev_warn(&h->pdev->dev,
 				"%s: tag collision (tag=%d)\n", __func__, idx);
-			if (c->scsi_cmd != NULL)
-				scsi_print_command(c->scsi_cmd);
 			if (scmd)
 				scsi_print_command(scmd);
 			h->last_collision_tag = idx;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e0f3852fdad1..da6e97d8dc3b 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -128,6 +128,7 @@ EXPORT_SYMBOL(fc_rport_lookup);
 struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 {
 	struct fc_rport_priv *rdata;
+	size_t rport_priv_size = sizeof(*rdata);
 
 	lockdep_assert_held(&lport->disc.disc_mutex);
 
@@ -135,7 +136,9 @@ struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 	if (rdata)
 		return rdata;
 
-	rdata = kzalloc(sizeof(*rdata) + lport->rport_priv_size, GFP_KERNEL);
+	if (lport->rport_priv_size > 0)
+		rport_priv_size = lport->rport_priv_size;
+	rdata = kzalloc(rport_priv_size, GFP_KERNEL);
 	if (!rdata)
 		return NULL;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 684662888792..050c0f029ef9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2703,6 +2703,8 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	u64 required_mask, coherent_mask;
 	struct sysinfo s;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
 
 	if (ioc->is_mcpu_endpoint)
 		goto try_32bit;
@@ -2712,17 +2714,17 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 		goto try_32bit;
 
 	if (ioc->dma_mask)
-		coherent_mask = DMA_BIT_MASK(64);
+		coherent_mask = DMA_BIT_MASK(dma_mask);
 	else
 		coherent_mask = DMA_BIT_MASK(32);
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) ||
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)) ||
 	    dma_set_coherent_mask(&pdev->dev, coherent_mask))
 		goto try_32bit;
 
 	ioc->base_add_sg_single = &_base_add_sg_single_64;
 	ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-	ioc->dma_mask = 64;
+	ioc->dma_mask = dma_mask;
 	goto out;
 
  try_32bit:
@@ -2744,7 +2746,7 @@ static int
 _base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
 				      struct pci_dev *pdev)
 {
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
 		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 	}
@@ -4989,7 +4991,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
-	if (ioc->dma_mask == 64) {
+	if (ioc->dma_mask > 32) {
 		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
 			ioc_warn(ioc, "no suitable consistent DMA mask for %s\n",
 				 pci_name(ioc->pdev));
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4059655639d9..da83034d4759 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4877,7 +4877,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 		ql_log(ql_log_warn, vha, 0xd049,
 		    "Failed to allocate ct_sns request.\n");
 		kfree(fcport);
-		fcport = NULL;
+		return NULL;
 	}
 
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 2d64b53f947c..9b87e1a1c646 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -115,7 +115,7 @@ struct fc_disc_port {
 	struct fc_lport    *lp;
 	struct list_head   peers;
 	struct work_struct rport_work;
-	u32                port_id;
+	u32		   port_id;
 };
 
 /**
@@ -155,14 +155,14 @@ struct fc_rport_operations {
  */
 struct fc_rport_libfc_priv {
 	struct fc_lport		   *local_port;
-	enum fc_rport_state        rp_state;
+	enum fc_rport_state	   rp_state;
 	u16			   flags;
 	#define FC_RP_FLAGS_REC_SUPPORTED	(1 << 0)
 	#define FC_RP_FLAGS_RETRY		(1 << 1)
 	#define FC_RP_STARTED			(1 << 2)
 	#define FC_RP_FLAGS_CONF_REQ		(1 << 3)
-	unsigned int	           e_d_tov;
-	unsigned int	           r_a_tov;
+	unsigned int		   e_d_tov;
+	unsigned int		   r_a_tov;
 };
 
 /**
@@ -191,24 +191,24 @@ struct fc_rport_priv {
 	struct fc_lport		    *local_port;
 	struct fc_rport		    *rport;
 	struct kref		    kref;
-	enum fc_rport_state         rp_state;
+	enum fc_rport_state	    rp_state;
 	struct fc_rport_identifiers ids;
 	u16			    flags;
-	u16		            max_seq;
+	u16			    max_seq;
 	u16			    disc_id;
 	u16			    maxframe_size;
-	unsigned int	            retries;
-	unsigned int	            major_retries;
-	unsigned int	            e_d_tov;
-	unsigned int	            r_a_tov;
-	struct mutex                rp_mutex;
+	unsigned int		    retries;
+	unsigned int		    major_retries;
+	unsigned int		    e_d_tov;
+	unsigned int		    r_a_tov;
+	struct mutex		    rp_mutex;
 	struct delayed_work	    retry_work;
-	enum fc_rport_event         event;
+	enum fc_rport_event	    event;
 	struct fc_rport_operations  *ops;
-	struct list_head            peers;
-	struct work_struct          event_work;
+	struct list_head	    peers;
+	struct work_struct	    event_work;
 	u32			    supported_classes;
-	u16                         prli_count;
+	u16			    prli_count;
 	struct rcu_head		    rcu;
 	u16			    sp_features;
 	u8			    spp_type;
@@ -618,12 +618,12 @@ struct libfc_function_template {
  * @disc_callback: Callback routine called when discovery completes
  */
 struct fc_disc {
-	unsigned char         retry_count;
-	unsigned char         pending;
-	unsigned char         requested;
-	unsigned short        seq_count;
-	unsigned char         buf_len;
-	u16                   disc_id;
+	unsigned char	      retry_count;
+	unsigned char	      pending;
+	unsigned char	      requested;
+	unsigned short	      seq_count;
+	unsigned char	      buf_len;
+	u16		      disc_id;
 
 	struct list_head      rports;
 	void		      *priv;
@@ -697,7 +697,7 @@ struct fc_lport {
 	struct fc_rport_priv	       *ms_rdata;
 	struct fc_rport_priv	       *ptp_rdata;
 	void			       *scsi_priv;
-	struct fc_disc                 disc;
+	struct fc_disc		       disc;
 
 	/* Virtual port information */
 	struct list_head	       vports;
@@ -715,7 +715,7 @@ struct fc_lport {
 	u8			       retry_count;
 
 	/* Fabric information */
-	u32                            port_id;
+	u32			       port_id;
 	u64			       wwpn;
 	u64			       wwnn;
 	unsigned int		       service_params;
@@ -743,11 +743,11 @@ struct fc_lport {
 	struct fc_ns_fts	       fcts;
 
 	/* Miscellaneous */
-	struct mutex                   lp_mutex;
-	struct list_head               list;
+	struct mutex		       lp_mutex;
+	struct list_head	       list;
 	struct delayed_work	       retry_work;
 	void			       *prov[FC_FC4_PROV_SIZE];
-	struct list_head               lport_list;
+	struct list_head	       lport_list;
 };
 
 /**
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index dc14b52577f7..2568cb0627ec 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -229,6 +229,7 @@ struct fcoe_fcf {
  * @vn_mac:	VN_Node assigned MAC address for data
  */
 struct fcoe_rport {
+	struct fc_rport_priv rdata;
 	unsigned long time;
 	u16 fcoe_len;
 	u16 flags;
