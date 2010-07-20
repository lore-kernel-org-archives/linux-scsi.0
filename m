From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/28] fcoe libfcoe: use correct FC-MAP for VN2VN mode
Date: Tue, 20 Jul 2010 15:20:40 -0700
Message-ID: <20100720222040.17116.62416.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60657 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab0GTWUl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:41 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

In VN2VN mode, map_dest means to use the default VN2VN OUI.
Change code that uses the default FCoE OUI to use the one
set in the fcoe_ctlr struct.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c    |    6 ++----
 drivers/scsi/fcoe/libfcoe.c |   24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 216aba3..4d3e70a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1534,11 +1534,9 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	/* fill up mac and fcoe headers */
 	eh = eth_hdr(skb);
 	eh->h_proto = htons(ETH_P_FCOE);
+	memcpy(eh->h_dest, fcoe->ctlr.dest_addr, ETH_ALEN);
 	if (fcoe->ctlr.map_dest)
-		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
-	else
-		/* insert GW address */
-		memcpy(eh->h_dest, fcoe->ctlr.dest_addr, ETH_ALEN);
+		memcpy(eh->h_dest + 3, fh->fh_d_id, 3);
 
 	if (unlikely(fcoe->ctlr.flogi_oxid != FC_XID_UNKNOWN))
 		memcpy(eh->h_source, fcoe->ctlr.ctl_src_addr, ETH_ALEN);
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 4865e81..4de8ced 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -153,6 +153,20 @@ static inline int fcoe_ctlr_fcf_usable(struct fcoe_fcf *fcf)
 }
 
 /**
+ * fcoe_ctlr_map_dest() - Set flag and OUI for mapping destination addresses
+ * @fip: The FCoE controller
+ */
+static void fcoe_ctlr_map_dest(struct fcoe_ctlr *fip)
+{
+	if (fip->mode == FIP_MODE_VN2VN)
+		hton24(fip->dest_addr, FIP_VN_FC_MAP);
+	else
+		hton24(fip->dest_addr, FIP_DEF_FC_MAP);
+	hton24(fip->dest_addr + 3, 0);
+	fip->map_dest = 1;
+}
+
+/**
  * fcoe_ctlr_init() - Initialize the FCoE Controller instance
  * @fip: The FCoE controller to initialize
  */
@@ -345,7 +359,7 @@ static void fcoe_ctlr_reset(struct fcoe_ctlr *fip)
 	fip->port_ka_time = 0;
 	fip->sol_time = 0;
 	fip->flogi_oxid = FC_XID_UNKNOWN;
-	fip->map_dest = 0;
+	fcoe_ctlr_map_dest(fip);
 }
 
 /**
@@ -573,11 +587,11 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			fip->flogi_count++;
 			if (fip->flogi_count < 3)
 				goto drop;
-			fip->map_dest = 1;
+			fcoe_ctlr_map_dest(fip);
 			return 0;
 		}
 		if (fip->state == FIP_ST_NON_FIP)
-			fip->map_dest = 1;
+			fcoe_ctlr_map_dest(fip);
 	}
 
 	if (fip->state == FIP_ST_NON_FIP)
@@ -1411,6 +1425,7 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 			       "Fibre-Channel Forwarder MAC %pM\n",
 			       fip->lp->host->host_no, sel->fcf_mac);
 			memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
+			fip->map_dest = 0;
 			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
 			fip->ctlr_ka_time = jiffies + sel->fka_period;
@@ -1527,7 +1542,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		 * Otherwise we use the FCoE gateway addr
 		 */
 		if (!compare_ether_addr(sa, (u8[6])FC_FCOE_FLOGI_MAC)) {
-			fip->map_dest = 1;
+			fcoe_ctlr_map_dest(fip);
 		} else {
 			memcpy(fip->dest_addr, sa, ETH_ALEN);
 			fip->map_dest = 0;
@@ -2426,6 +2441,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 		new_port_id = fip->port_id;
 		hton24(mac, FIP_VN_FC_MAP);
 		hton24(mac + 3, new_port_id);
+		fcoe_ctlr_map_dest(fip);
 		fip->update_mac(fip->lp, mac);
 		fcoe_ctlr_vn_send_claim(fip);
 		next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);

