From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/24] fcoe: FIP debugging
Date: Thu, 13 Oct 2016 15:10:58 +0200
Message-ID: <1476364260-12191-23-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41163 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbcJMNeC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:34:02 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add additional statements for debugging FIP frames.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 48 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 05573c3..d773b46 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -801,6 +801,8 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	return -EINPROGRESS;
 drop:
 	kfree_skb(skb);
+	LIBFCOE_FIP_DBG(fip, "drop els_send op %u d_id %x\n",
+			op, ntoh24(fh->fh_d_id));
 	return -EINVAL;
 }
 EXPORT_SYMBOL(fcoe_ctlr_els_send);
@@ -2428,6 +2430,8 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
 	switch (fip->state) {
 	case FIP_ST_VNMP_CLAIM:
 	case FIP_ST_VNMP_UP:
+		LIBFCOE_FIP_DBG(fip, "vn_probe_req: send reply, state %x\n",
+				fip->state);
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
 				  frport->enode_mac, 0);
 		break;
@@ -2442,15 +2446,21 @@ static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
 		 */
 		if (fip->lp->wwpn > rdata->ids.port_name &&
 		    !(frport->flags & FIP_FL_REC_OR_P2P)) {
+			LIBFCOE_FIP_DBG(fip, "vn_probe_req: "
+					"port_id collision\n");
 			fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
 					  frport->enode_mac, 0);
 			break;
 		}
 		/* fall through */
 	case FIP_ST_VNMP_START:
+		LIBFCOE_FIP_DBG(fip, "vn_probe_req: "
+				"restart VN2VN negotiation\n");
 		fcoe_ctlr_vn_restart(fip);
 		break;
 	default:
+		LIBFCOE_FIP_DBG(fip, "vn_probe_req: ignore state %x\n",
+				fip->state);
 		break;
 	}
 }
@@ -2472,9 +2482,12 @@ static void fcoe_ctlr_vn_probe_reply(struct fcoe_ctlr *fip,
 	case FIP_ST_VNMP_PROBE1:
 	case FIP_ST_VNMP_PROBE2:
 	case FIP_ST_VNMP_CLAIM:
+		LIBFCOE_FIP_DBG(fip, "vn_probe_reply: restart state %x\n",
+				fip->state);
 		fcoe_ctlr_vn_restart(fip);
 		break;
 	case FIP_ST_VNMP_UP:
+		LIBFCOE_FIP_DBG(fip, "vn_probe_reply: send claim notify\n");
 		fcoe_ctlr_vn_send_claim(fip);
 		break;
 	default:
@@ -2517,6 +2530,7 @@ static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
 	if ((ids->port_name != -1 && ids->port_name != new->ids.port_name) ||
 	    (ids->node_name != -1 && ids->node_name != new->ids.node_name)) {
 		mutex_unlock(&rdata->rp_mutex);
+		LIBFCOE_FIP_DBG(fip, "vn_add rport logoff %6.6x\n", port_id);
 		lport->tt.rport_logoff(rdata);
 		mutex_lock(&rdata->rp_mutex);
 	}
@@ -2525,8 +2539,9 @@ static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
 	mutex_unlock(&rdata->rp_mutex);
 
 	frport = fcoe_ctlr_rport(rdata);
-	LIBFCOE_FIP_DBG(fip, "vn_add rport %6.6x %s\n",
-			port_id, frport->fcoe_len ? "old" : "new");
+	LIBFCOE_FIP_DBG(fip, "vn_add rport %6.6x %s state %d\n",
+			port_id, frport->fcoe_len ? "old" : "new",
+			rdata->rp_state);
 	*frport = *fcoe_ctlr_rport(new);
 	frport->time = 0;
 }
@@ -2569,6 +2584,7 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 	struct fcoe_rport *frport = fcoe_ctlr_rport(new);
 
 	if (frport->flags & FIP_FL_REC_OR_P2P) {
+		LIBFCOE_FIP_DBG(fip, "send probe req for P2P/REC\n");
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		return;
 	}
@@ -2576,25 +2592,37 @@ static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
 	case FIP_ST_VNMP_START:
 	case FIP_ST_VNMP_PROBE1:
 	case FIP_ST_VNMP_PROBE2:
-		if (new->ids.port_id == fip->port_id)
+		if (new->ids.port_id == fip->port_id) {
+			LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
+					"restart, state %d\n",
+					fip->state);
 			fcoe_ctlr_vn_restart(fip);
+		}
 		break;
 	case FIP_ST_VNMP_CLAIM:
 	case FIP_ST_VNMP_UP:
 		if (new->ids.port_id == fip->port_id) {
 			if (new->ids.port_name > fip->lp->wwpn) {
+				LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
+						"restart, port_id collision\n");
 				fcoe_ctlr_vn_restart(fip);
 				break;
 			}
+			LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
+					"send claim notify\n");
 			fcoe_ctlr_vn_send_claim(fip);
 			break;
 		}
+		LIBFCOE_FIP_DBG(fip, "vn_claim_notify: send reply to %x\n",
+				new->ids.port_id);
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_CLAIM_REP, frport->enode_mac,
 				  min((u32)frport->fcoe_len,
 				      fcoe_ctlr_fcoe_size(fip)));
 		fcoe_ctlr_vn_add(fip, new);
 		break;
 	default:
+		LIBFCOE_FIP_DBG(fip, "vn_claim_notify: "
+				"ignoring claim from %x\n", new->ids.port_id);
 		break;
 	}
 }
@@ -2631,6 +2659,7 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 
 	frport = fcoe_ctlr_rport(new);
 	if (frport->flags & FIP_FL_REC_OR_P2P) {
+		LIBFCOE_FIP_DBG(fip, "p2p beacon while in vn2vn mode\n");
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		return;
 	}
@@ -2639,8 +2668,14 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 		if (rdata->ids.node_name == new->ids.node_name &&
 		    rdata->ids.port_name == new->ids.port_name) {
 			frport = fcoe_ctlr_rport(rdata);
-			if (!frport->time && fip->state == FIP_ST_VNMP_UP)
+			LIBFCOE_FIP_DBG(fip, "beacon from rport %x\n",
+					rdata->ids.port_id);
+			if (!frport->time && fip->state == FIP_ST_VNMP_UP) {
+				LIBFCOE_FIP_DBG(fip, "beacon expired "
+						"for rport %x\n",
+						rdata->ids.port_id);
 				lport->tt.rport_login(rdata);
+			}
 			frport->time = jiffies;
 		}
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
@@ -3065,11 +3100,13 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 	switch (fip->state) {
 	case FIP_ST_VNMP_START:
 		fcoe_ctlr_set_state(fip, FIP_ST_VNMP_PROBE1);
+		LIBFCOE_FIP_DBG(fip, "vn_timeout: send 1st probe request\n");
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		next_time = jiffies + msecs_to_jiffies(FIP_VN_PROBE_WAIT);
 		break;
 	case FIP_ST_VNMP_PROBE1:
 		fcoe_ctlr_set_state(fip, FIP_ST_VNMP_PROBE2);
+		LIBFCOE_FIP_DBG(fip, "vn_timeout: send 2nd probe request\n");
 		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
 		next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);
 		break;
@@ -3080,6 +3117,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 		hton24(mac + 3, new_port_id);
 		fcoe_ctlr_map_dest(fip);
 		fip->update_mac(fip->lp, mac);
+		LIBFCOE_FIP_DBG(fip, "vn_timeout: send claim notify\n");
 		fcoe_ctlr_vn_send_claim(fip);
 		next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);
 		break;
@@ -3091,6 +3129,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 		next_time = fip->sol_time + msecs_to_jiffies(FIP_VN_ANN_WAIT);
 		if (time_after_eq(jiffies, next_time)) {
 			fcoe_ctlr_set_state(fip, FIP_ST_VNMP_UP);
+			LIBFCOE_FIP_DBG(fip, "vn_timeout: send vn2vn beacon\n");
 			fcoe_ctlr_vn_send(fip, FIP_SC_VN_BEACON,
 					  fcoe_all_vn2vn, 0);
 			next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);
@@ -3101,6 +3140,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 	case FIP_ST_VNMP_UP:
 		next_time = fcoe_ctlr_vn_age(fip);
 		if (time_after_eq(jiffies, fip->port_ka_time)) {
+			LIBFCOE_FIP_DBG(fip, "vn_timeout: send vn2vn beacon\n");
 			fcoe_ctlr_vn_send(fip, FIP_SC_VN_BEACON,
 					  fcoe_all_vn2vn, 0);
 			fip->port_ka_time = jiffies +
-- 
1.8.5.6

