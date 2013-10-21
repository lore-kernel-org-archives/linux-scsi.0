From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/19] scsi: Convert uses of compare_ether_addr to
 ether_addr_equal
Date: Mon, 21 Oct 2013 11:02:11 -0700
Message-ID: <20131021180211.31563.30764.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3JUSCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:02:13 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Perches <joe@perches.com>

From: Joe Perches <joe@perches.com>

Preliminary to removing compare_ether_addr altogether:

Use the new bool function ether_addr_equal to add
some clarity and reduce the likelihood for misuse
of compare_ether_addr for sorting.

Done via cocci script:

$ cat compare_ether_addr.cocci
@@
expression a,b;
@@
-	!compare_ether_addr(a, b)
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	compare_ether_addr(a, b)
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) == 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) != 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) == 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) != 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!!ether_addr_equal(a, b)
+	ether_addr_equal(a, b)

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    3 +--
 drivers/scsi/fcoe/fcoe.c          |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c     |   22 +++++++++++-----------
 drivers/scsi/fcoe/fcoe_sysfs.c    |    2 +-
 drivers/scsi/fnic/fnic_fcs.c      |    6 +++---
 5 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 27f2cc4..23f6eea 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -542,8 +542,7 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	vn_port = fc_vport_id_lookup(lport, ntoh24(fh->fh_d_id));
 	if (vn_port) {
 		port = lport_priv(vn_port);
-		if (compare_ether_addr(port->data_src_addr, dest_mac)
-		    != 0) {
+		if (!ether_addr_equal(port->data_src_addr, dest_mac)) {
 			BNX2FC_HBA_DBG(lport, "fpma mismatch\n");
 			put_cpu();
 			kfree_skb(skb);
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8626988..f317000 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1462,7 +1462,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	eh = eth_hdr(skb);
 
 	if (is_fip_mode(ctlr) &&
-	    compare_ether_addr(eh->h_source, ctlr->dest_addr)) {
+	    !ether_addr_equal(eh->h_source, ctlr->dest_addr)) {
 		FCOE_NETDEV_DBG(netdev, "wrong source mac address:%pM\n",
 				eh->h_source);
 		goto err;
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 2aba32f..34a1b1f 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -339,7 +339,7 @@ static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
 	spin_unlock_bh(&fip->ctlr_lock);
 	sel = fip->sel_fcf;
 
-	if (sel && !compare_ether_addr(sel->fcf_mac, fip->dest_addr))
+	if (sel && ether_addr_equal(sel->fcf_mac, fip->dest_addr))
 		goto unlock;
 	if (!is_zero_ether_addr(fip->dest_addr)) {
 		printk(KERN_NOTICE "libfcoe: host%d: "
@@ -1039,7 +1039,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		if (fcf->switch_name == new.switch_name &&
 		    fcf->fabric_name == new.fabric_name &&
 		    fcf->fc_map == new.fc_map &&
-		    compare_ether_addr(fcf->fcf_mac, new.fcf_mac) == 0) {
+		    ether_addr_equal(fcf->fcf_mac, new.fcf_mac)) {
 			found = 1;
 			break;
 		}
@@ -1379,7 +1379,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 			mp = (struct fip_mac_desc *)desc;
 			if (dlen < sizeof(*mp))
 				goto err;
-			if (compare_ether_addr(mp->fd_mac, fcf->fcf_mac))
+			if (!ether_addr_equal(mp->fd_mac, fcf->fcf_mac))
 				goto err;
 			desc_mask &= ~BIT(FIP_DT_MAC);
 			break;
@@ -1457,8 +1457,8 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 			 * 'port_id' is already validated, check MAC address and
 			 * wwpn
 			 */
-			if (compare_ether_addr(fip->get_src_addr(vn_port),
-						vp->fd_mac) != 0 ||
+			if (!ether_addr_equal(fip->get_src_addr(vn_port),
+					      vp->fd_mac) ||
 				get_unaligned_be64(&vp->fd_wwpn) !=
 							vn_port->wwpn)
 				continue;
@@ -1521,12 +1521,12 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		goto drop;
 	eh = eth_hdr(skb);
 	if (fip->mode == FIP_MODE_VN2VN) {
-		if (compare_ether_addr(eh->h_dest, fip->ctl_src_addr) &&
-		    compare_ether_addr(eh->h_dest, fcoe_all_vn2vn) &&
-		    compare_ether_addr(eh->h_dest, fcoe_all_p2p))
+		if (!ether_addr_equal(eh->h_dest, fip->ctl_src_addr) &&
+		    !ether_addr_equal(eh->h_dest, fcoe_all_vn2vn) &&
+		    !ether_addr_equal(eh->h_dest, fcoe_all_p2p))
 			goto drop;
-	} else if (compare_ether_addr(eh->h_dest, fip->ctl_src_addr) &&
-		   compare_ether_addr(eh->h_dest, fcoe_all_enode))
+	} else if (!ether_addr_equal(eh->h_dest, fip->ctl_src_addr) &&
+		   !ether_addr_equal(eh->h_dest, fcoe_all_enode))
 		goto drop;
 	fiph = (struct fip_header *)skb->data;
 	op = ntohs(fiph->fip_op);
@@ -1898,7 +1898,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		 * address_mode flag to use FC_OUI-based Ethernet DA.
 		 * Otherwise we use the FCoE gateway addr
 		 */
-		if (!compare_ether_addr(sa, (u8[6])FC_FCOE_FLOGI_MAC)) {
+		if (ether_addr_equal(sa, (u8[6])FC_FCOE_FLOGI_MAC)) {
 			fcoe_ctlr_map_dest(fip);
 		} else {
 			memcpy(fip->dest_addr, sa, ETH_ALEN);
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 922c9de..d0d9a2d 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -653,7 +653,7 @@ static int fcoe_fcf_device_match(struct fcoe_fcf_device *new,
 	if (new->switch_name == old->switch_name &&
 	    new->fabric_name == old->fabric_name &&
 	    new->fc_map == old->fc_map &&
-	    compare_ether_addr(new->mac, old->mac) == 0)
+	    ether_addr_equal(new->mac, old->mac))
 		return 1;
 	return 0;
 }
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 006fa92..902520c 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -651,13 +651,13 @@ void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
 
 	if (is_zero_ether_addr(new))
 		new = ctl;
-	if (!compare_ether_addr(data, new))
+	if (ether_addr_equal(data, new))
 		return;
 	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "update_mac %pM\n", new);
-	if (!is_zero_ether_addr(data) && compare_ether_addr(data, ctl))
+	if (!is_zero_ether_addr(data) && !ether_addr_equal(data, ctl))
 		vnic_dev_del_addr(fnic->vdev, data);
 	memcpy(data, new, ETH_ALEN);
-	if (compare_ether_addr(new, ctl))
+	if (!ether_addr_equal(new, ctl))
 		vnic_dev_add_addr(fnic->vdev, new);
 }
 

