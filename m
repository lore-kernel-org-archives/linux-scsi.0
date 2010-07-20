From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/28] libfcoe: fcoe: fnic: add FIP VN2VN point-to-multipoint
	support
Date: Tue, 20 Jul 2010 15:20:30 -0700
Message-ID: <20100720222030.17116.97974.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab0GTWUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:47 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

The FC-BB-6 committee is proposing a new FIP usage model called
VN_port to VN_port mode.  It allows VN_ports to discover each other
over a loss-free L2 Ethernet without any FCF or Fibre-channel fabric
services.  This is point-to-multipoint.  There is also a variant
of this called point-to-point which provides for making sure there
is just one pair of ports operating over the Ethernet fabric.

We add these new states:  VNMP_START, _PROBE1, _PROBE2, _CLAIM, and _UP.
These usually go quickly in that sequence.  After waiting a random
amount of time up to 100 ms in START, we select a pseudo-random
proposed locally-unique port ID and send out probes in states PROBE1
and PROBE2, 100 ms apart.  If no probe responses are heard, we
proceed to CLAIM state 400 ms later and send a claim notification.
We wait another 400 ms to receive claim responses, which give us
a list of the other nodes on the network, including their FC-4
capabilities.  After another 400 ms we go to VNMP_UP state and
should start interoperating with any of the nodes for whic we
receivec claim responses.  More details are in the spec.j

Add the new mode as FIP_MODE_VN2VN.  The driver must specify
explicitly that it wants to operate in this mode.  There is
no automatic detection between point-to-multipoint and fabric
mode, and the local port initialization is affected, so it isn't
anticipated that there will ever be any such automatic switchover.

It may eventually be possible to have both fabric and VN2VN
modes on the same L2 network, which may be done by two separate
local VN_ports (lports).

When in VN2VN mode, FIP replaces libfc's fabric-oriented discovery
module with its own simple code that adds remote ports as they
are discovered from incoming claim notifications and responses.
These hooks are placed by fcoe_disc_init().

A linear list of discovered vn_ports is maintained under the
fcoe_ctlr struct.  It is expected to be short for now, and
accessed infrequently.  It is kept under RCU for lock-ordering
reasons.  The lport and/or rport mutexes may be held when we
need to lookup a fcoe_vnport during an ELS send.

Change fcoe_ctlr_encaps() to lookup the destination vn_port in
the list of peers for the destination MAC address of the
FIP-encapsulated frame.

Add a new function fcoe_disc_init() to initialize just the
discovery portion of libfcoe for VN2VN mode.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |   16 -
 drivers/scsi/fcoe/libfcoe.c   | 1075 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/fnic/fnic_main.c |    7 
 include/scsi/libfcoe.h        |   42 ++
 4 files changed, 1071 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9d64e08..216aba3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -315,7 +315,11 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	dev_uc_add(netdev, flogi_maddr);
 	if (fip->spma)
 		dev_uc_add(netdev, fip->ctl_src_addr);
-	dev_mc_add(netdev, FIP_ALL_ENODE_MACS);
+	if (fip->mode == FIP_MODE_VN2VN) {
+		dev_mc_add(netdev, FIP_ALL_VN2VN_MACS);
+		dev_mc_add(netdev, FIP_ALL_P2P_MACS);
+	} else
+		dev_mc_add(netdev, FIP_ALL_ENODE_MACS);
 
 	/*
 	 * setup the receive function from ethernet driver
@@ -401,7 +405,11 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	dev_uc_del(netdev, flogi_maddr);
 	if (fip->spma)
 		dev_uc_del(netdev, fip->ctl_src_addr);
-	dev_mc_del(netdev, FIP_ALL_ENODE_MACS);
+	if (fip->mode == FIP_MODE_VN2VN) {
+		dev_mc_del(netdev, FIP_ALL_VN2VN_MACS);
+		dev_mc_del(netdev, FIP_ALL_P2P_MACS);
+	} else
+		dev_mc_del(netdev, FIP_ALL_ENODE_MACS);
 
 	/* Tell the LLD we are done w/ FCoE */
 	ops = netdev->netdev_ops;
@@ -967,7 +975,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 
 	/* Initialize the library */
-	rc = fcoe_libfc_config(lport, &fcoe_libfc_fcn_templ);
+	rc = fcoe_libfc_config(lport, &fcoe->ctlr, &fcoe_libfc_fcn_templ, 1);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
 				"interface\n");
@@ -2533,6 +2541,8 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
 	switch (op) {
 	case ELS_FLOGI:
 	case ELS_FDISC:
+		if (lport->point_to_multipoint)
+			break;
 		return fc_elsct_send(lport, did, fp, op, fcoe_flogi_resp,
 				     fip, timeout);
 	case ELS_LOGO:
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 11f3db5..79df78f 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -39,6 +39,7 @@
 #include <scsi/fc/fc_fip.h>
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fcoe.h>
+#include <scsi/fc/fc_fcp.h>
 
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
@@ -54,7 +55,15 @@ static void fcoe_ctlr_timeout(unsigned long);
 static void fcoe_ctlr_timer_work(struct work_struct *);
 static void fcoe_ctlr_recv_work(struct work_struct *);
 
+static void fcoe_ctlr_vn_start(struct fcoe_ctlr *);
+static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *, struct sk_buff *);
+static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *);
+static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *, u32, u8 *);
+
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
+static u8 fcoe_all_enode[ETH_ALEN] = FIP_ALL_ENODE_MACS;
+static u8 fcoe_all_vn2vn[ETH_ALEN] = FIP_ALL_VN2VN_MACS;
+static u8 fcoe_all_p2p[ETH_ALEN] = FIP_ALL_P2P_MACS;
 
 unsigned int libfcoe_debug_logging;
 module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
@@ -86,6 +95,11 @@ static const char *fcoe_ctlr_states[] = {
 	[FIP_ST_AUTO] =		"AUTO",
 	[FIP_ST_NON_FIP] =	"NON_FIP",
 	[FIP_ST_ENABLED] =	"ENABLED",
+	[FIP_ST_VNMP_START] =	"VNMP_START",
+	[FIP_ST_VNMP_PROBE1] =	"VNMP_PROBE1",
+	[FIP_ST_VNMP_PROBE2] =	"VNMP_PROBE2",
+	[FIP_ST_VNMP_CLAIM] =	"VNMP_CLAIM",
+	[FIP_ST_VNMP_UP] =	"VNMP_UP",
 };
 
 static const char *fcoe_ctlr_state(enum fip_state state)
@@ -295,11 +309,25 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 		fc_linkup(fip->lp);
 	} else if (fip->state == FIP_ST_LINK_WAIT) {
 		fcoe_ctlr_set_state(fip, fip->mode);
-		mutex_unlock(&fip->ctlr_mutex);
-		if (fip->state == FIP_ST_AUTO)
+		switch (fip->mode) {
+		default:
+			LIBFCOE_FIP_DBG(fip, "invalid mode %d\n", fip->mode);
+			/* fall-through */
+		case FIP_MODE_AUTO:
 			LIBFCOE_FIP_DBG(fip, "%s", "setting AUTO mode.\n");
-		fc_linkup(fip->lp);
-		fcoe_ctlr_solicit(fip, NULL);
+			/* fall-through */
+		case FIP_MODE_FABRIC:
+		case FIP_MODE_NON_FIP:
+			mutex_unlock(&fip->ctlr_mutex);
+			fc_linkup(fip->lp);
+			fcoe_ctlr_solicit(fip, NULL);
+			break;
+		case FIP_MODE_VN2VN:
+			fcoe_ctlr_vn_start(fip);
+			mutex_unlock(&fip->ctlr_mutex);
+			fc_linkup(fip->lp);
+			break;
+		}
 	} else
 		mutex_unlock(&fip->ctlr_mutex);
 }
@@ -423,6 +451,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
  * @fip:   The FCoE controller for the ELS frame
  * @dtype: The FIP descriptor type for the frame
  * @skb:   The FCoE ELS frame including FC header but no FCoE headers
+ * @d_id:  The destination port ID.
  *
  * Returns non-zero error code on failure.
  *
@@ -433,7 +462,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
  * Ethernet header.  The tailroom is for the FIP MAC descriptor.
  */
 static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
-			    u8 dtype, struct sk_buff *skb)
+			    u8 dtype, struct sk_buff *skb, u32 d_id)
 {
 	struct fip_encaps_head {
 		struct ethhdr eth;
@@ -445,21 +474,24 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	size_t dlen;
 	u16 fip_flags;
 
-	fcf = fip->sel_fcf;
-	if (!fcf)
-		return -ENODEV;
-
-	/* set flags according to both FCF and lport's capability on SPMA */
-	fip_flags = fcf->flags;
-	fip_flags &= fip->spma ? FIP_FL_SPMA | FIP_FL_FPMA : FIP_FL_FPMA;
-	if (!fip_flags)
-		return -ENODEV;
-
 	dlen = sizeof(struct fip_encaps) + skb->len;	/* len before push */
 	cap = (struct fip_encaps_head *)skb_push(skb, sizeof(*cap));
-
 	memset(cap, 0, sizeof(*cap));
-	memcpy(cap->eth.h_dest, fcf->fcf_mac, ETH_ALEN);
+
+	if (lport->point_to_multipoint) {
+		if (fcoe_ctlr_vn_lookup(fip, d_id, cap->eth.h_dest))
+			return -ENODEV;
+	} else {
+		fcf = fip->sel_fcf;
+		if (!fcf)
+			return -ENODEV;
+		fip_flags = fcf->flags;
+		fip_flags &= fip->spma ? FIP_FL_SPMA | FIP_FL_FPMA :
+					 FIP_FL_FPMA;
+		if (!fip_flags)
+			return -ENODEV;
+		memcpy(cap->eth.h_dest, fcf->fcf_mac, ETH_ALEN);
+	}
 	memcpy(cap->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
 	cap->eth.h_proto = htons(ETH_P_FIP);
 
@@ -503,19 +535,22 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  *
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
+ * The the skb must also be an fc_frame.
  */
 int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		       struct sk_buff *skb)
 {
+	struct fc_frame *fp;
 	struct fc_frame_header *fh;
 	u16 old_xid;
 	u8 op;
 	u8 mac[ETH_ALEN];
 
+	fp = container_of(skb, struct fc_frame, skb);
 	fh = (struct fc_frame_header *)skb->data;
 	op = *(u8 *)(fh + 1);
 
-	if (op == ELS_FLOGI) {
+	if (op == ELS_FLOGI && fip->mode != FIP_MODE_VN2VN) {
 		old_xid = fip->flogi_oxid;
 		fip->flogi_oxid = ntohs(fh->fh_ox_id);
 		if (fip->state == FIP_ST_AUTO) {
@@ -533,9 +568,8 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 
 	if (fip->state == FIP_ST_NON_FIP)
 		return 0;
-	if (!fip->sel_fcf)
+	if (!fip->sel_fcf && fip->mode != FIP_MODE_VN2VN)
 		goto drop;
-
 	switch (op) {
 	case ELS_FLOGI:
 		op = FIP_DT_FLOGI;
@@ -546,36 +580,49 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		op = FIP_DT_FDISC;
 		break;
 	case ELS_LOGO:
-		if (fip->state != FIP_ST_ENABLED)
-			return 0;
-		if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
-			return 0;
+		if (fip->mode == FIP_MODE_VN2VN) {
+			if (fip->state != FIP_ST_VNMP_UP)
+				return -EINVAL;
+			if (ntoh24(fh->fh_d_id) == FC_FID_FLOGI)
+				return -EINVAL;
+		} else {
+			if (fip->state != FIP_ST_ENABLED)
+				return 0;
+			if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
+				return 0;
+		}
 		op = FIP_DT_LOGO;
 		break;
 	case ELS_LS_ACC:
-		if (fip->flogi_oxid == FC_XID_UNKNOWN)
-			return 0;
-		if (!ntoh24(fh->fh_s_id))
-			return 0;
-		if (fip->state == FIP_ST_AUTO)
-			return 0;
 		/*
-		 * Here we must've gotten an SID by accepting an FLOGI
+		 * If non-FIP, we may have gotten an SID by accepting an FLOGI
 		 * from a point-to-point connection.  Switch to using
 		 * the source mac based on the SID.  The destination
 		 * MAC in this case would have been set by receving the
 		 * FLOGI.
 		 */
-		fip->flogi_oxid = FC_XID_UNKNOWN;
-		fc_fcoe_set_mac(mac, fh->fh_d_id);
-		fip->update_mac(lport, mac);
+		if (fip->state == FIP_ST_NON_FIP) {
+			if (fip->flogi_oxid == FC_XID_UNKNOWN)
+				return 0;
+			fip->flogi_oxid = FC_XID_UNKNOWN;
+			fc_fcoe_set_mac(mac, fh->fh_d_id);
+			fip->update_mac(lport, mac);
+		}
+		/* fall through */
+	case ELS_LS_RJT:
+		op = fr_encaps(fp);
+		if (op)
+			break;
 		return 0;
 	default:
-		if (fip->state != FIP_ST_ENABLED)
+		if (fip->state != FIP_ST_ENABLED &&
+		    fip->state != FIP_ST_VNMP_UP)
 			goto drop;
 		return 0;
 	}
-	if (fcoe_ctlr_encaps(fip, lport, op, skb))
+	LIBFCOE_FIP_DBG(fip, "els_send op %u d_id %x\n",
+			op, ntoh24(fh->fh_d_id));
+	if (fcoe_ctlr_encaps(fip, lport, op, skb, ntoh24(fh->fh_d_id)))
 		goto drop;
 	fip->send(fip, skb);
 	return -EINPROGRESS;
@@ -717,8 +764,9 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 			       ((struct fip_mac_desc *)desc)->fd_mac,
 			       ETH_ALEN);
 			if (!is_valid_ether_addr(fcf->fcf_mac)) {
-				LIBFCOE_FIP_DBG(fip, "Invalid MAC address "
-						"in FIP adv\n");
+				LIBFCOE_FIP_DBG(fip,
+					"Invalid MAC addr %pM in FIP adv\n",
+					fcf->fcf_mac);
 				return -EINVAL;
 			}
 			desc_mask &= ~BIT(FIP_DT_MAC);
@@ -944,12 +992,6 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			memcpy(granted_mac,
 			       ((struct fip_mac_desc *)desc)->fd_mac,
 			       ETH_ALEN);
-			if (!is_valid_ether_addr(granted_mac)) {
-				LIBFCOE_FIP_DBG(fip, "Invalid MAC address "
-						"in FIP ELS\n");
-				goto drop;
-			}
-			memcpy(fr_cb(fp)->granted_mac, granted_mac, ETH_ALEN);
 			break;
 		case FIP_DT_FLOGI:
 		case FIP_DT_FDISC:
@@ -990,10 +1032,20 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		goto drop;
 	els_op = *(u8 *)(fh + 1);
 
-	if (els_dtype == FIP_DT_FLOGI && sub == FIP_SC_REP &&
-	    fip->flogi_oxid == ntohs(fh->fh_ox_id) &&
-	    els_op == ELS_LS_ACC && is_valid_ether_addr(granted_mac))
-		fip->flogi_oxid = FC_XID_UNKNOWN;
+	if ((els_dtype == FIP_DT_FLOGI || els_dtype == FIP_DT_FDISC) &&
+	    sub == FIP_SC_REP && els_op == ELS_LS_ACC &&
+	    fip->mode != FIP_MODE_VN2VN) {
+		if (!is_valid_ether_addr(granted_mac)) {
+			LIBFCOE_FIP_DBG(fip,
+				"Invalid MAC address %pM in FIP ELS\n",
+				granted_mac);
+			goto drop;
+		}
+		memcpy(fr_cb(fp)->granted_mac, granted_mac, ETH_ALEN);
+
+		if (fip->flogi_oxid == ntohs(fh->fh_ox_id))
+			fip->flogi_oxid = FC_XID_UNKNOWN;
+	}
 
 	if ((desc_cnt == 0) || ((els_op != ELS_LS_RJT) &&
 	    (!(1U << FIP_DT_MAC & desc_mask)))) {
@@ -1012,6 +1064,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	fr_sof(fp) = FC_SOF_I3;
 	fr_eof(fp) = FC_EOF_T;
 	fr_dev(fp) = lport;
+	fr_encaps(fp) = els_dtype;
 
 	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 	stats->RxFrames++;
@@ -1188,8 +1241,13 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	if (skb->len < sizeof(*fiph))
 		goto drop;
 	eh = eth_hdr(skb);
-	if (compare_ether_addr(eh->h_dest, fip->ctl_src_addr) &&
-	    compare_ether_addr(eh->h_dest, FIP_ALL_ENODE_MACS))
+	if (fip->mode == FIP_MODE_VN2VN) {
+		if (compare_ether_addr(eh->h_dest, fip->ctl_src_addr) &&
+		    compare_ether_addr(eh->h_dest, fcoe_all_vn2vn) &&
+		    compare_ether_addr(eh->h_dest, fcoe_all_p2p))
+			goto drop;
+	} else if (compare_ether_addr(eh->h_dest, fip->ctl_src_addr) &&
+		   compare_ether_addr(eh->h_dest, fcoe_all_enode))
 		goto drop;
 	fiph = (struct fip_header *)skb->data;
 	op = ntohs(fiph->fip_op);
@@ -1209,13 +1267,22 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		LIBFCOE_FIP_DBG(fip, "Using FIP mode\n");
 	}
 	mutex_unlock(&fip->ctlr_mutex);
-	if (state != FIP_ST_ENABLED)
+
+	if (fip->mode == FIP_MODE_VN2VN && op == FIP_OP_VN2VN)
+		return fcoe_ctlr_vn_recv(fip, skb);
+
+	if (state != FIP_ST_ENABLED && state != FIP_ST_VNMP_UP &&
+	    state != FIP_ST_VNMP_CLAIM)
 		goto drop;
 
 	if (op == FIP_OP_LS) {
 		fcoe_ctlr_recv_els(fip, skb);	/* consumes skb */
 		return 0;
 	}
+
+	if (state != FIP_ST_ENABLED)
+		goto drop;
+
 	if (op == FIP_OP_DISC && sub == FIP_SC_ADV)
 		fcoe_ctlr_recv_adv(fip, skb);
 	else if (op == FIP_OP_CTRL && sub == FIP_SC_CLR_VLINK)
@@ -1302,7 +1369,8 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 	unsigned long next_timer;
 
 	fip = container_of(work, struct fcoe_ctlr, timer_work);
-
+	if (fip->mode == FIP_MODE_VN2VN)
+		return fcoe_ctlr_vn_timeout(fip);
 	mutex_lock(&fip->ctlr_mutex);
 	if (fip->state == FIP_ST_DISABLED) {
 		mutex_unlock(&fip->ctlr_mutex);
@@ -1340,7 +1408,6 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 			       "Starting FCF discovery.\n",
 			       fip->lp->host->host_no);
 			reset = 1;
-			schedule_work(&fip->timer_work);
 		}
 	}
 
@@ -1515,26 +1582,916 @@ u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
 EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
 
 /**
+ * fcoe_ctlr_rport() - return the fcoe_rport for a given fc_rport_priv
+ * @rdata: libfc remote port
+ */
+static inline struct fcoe_rport *fcoe_ctlr_rport(struct fc_rport_priv *rdata)
+{
+	return (struct fcoe_rport *)(rdata + 1);
+}
+
+/**
+ * fcoe_ctlr_vn_send() - Send a FIP VN2VN Probe Request or Reply.
+ * @fip: The FCoE controller
+ * @sub: sub-opcode for probe request, reply, or advertisement.
+ * @dest: The destination Ethernet MAC address
+ * @min_len: minimum size of the Ethernet payload to be sent
+ */
+static void fcoe_ctlr_vn_send(struct fcoe_ctlr *fip,
+			      enum fip_vn2vn_subcode sub,
+			      const u8 *dest, size_t min_len)
+{
+	struct sk_buff *skb;
+	struct fip_frame {
+		struct ethhdr eth;
+		struct fip_header fip;
+		struct fip_mac_desc mac;
+		struct fip_wwn_desc wwnn;
+		struct fip_vn_desc vn;
+	} __attribute__((packed)) *frame;
+	struct fip_fc4_feat *ff;
+	struct fip_size_desc *size;
+	u32 fcp_feat;
+	size_t len;
+	size_t dlen;
+
+	len = sizeof(*frame);
+	dlen = 0;
+	if (sub == FIP_SC_VN_CLAIM_NOTIFY || sub == FIP_SC_VN_CLAIM_REP) {
+		dlen = sizeof(struct fip_fc4_feat) +
+		       sizeof(struct fip_size_desc);
+		len += dlen;
+	}
+	dlen += sizeof(frame->mac) + sizeof(frame->wwnn) + sizeof(frame->vn);
+	len = max(len, min_len + sizeof(struct ethhdr));
+
+	skb = dev_alloc_skb(len);
+	if (!skb)
+		return;
+
+	frame = (struct fip_frame *)skb->data;
+	memset(frame, 0, len);
+	memcpy(frame->eth.h_dest, dest, ETH_ALEN);
+	memcpy(frame->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
+	frame->eth.h_proto = htons(ETH_P_FIP);
+
+	frame->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
+	frame->fip.fip_op = htons(FIP_OP_VN2VN);
+	frame->fip.fip_subcode = sub;
+	frame->fip.fip_dl_len = htons(dlen / FIP_BPW);
+
+	frame->mac.fd_desc.fip_dtype = FIP_DT_MAC;
+	frame->mac.fd_desc.fip_dlen = sizeof(frame->mac) / FIP_BPW;
+	memcpy(frame->mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
+
+	frame->wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
+	frame->wwnn.fd_desc.fip_dlen = sizeof(frame->wwnn) / FIP_BPW;
+	put_unaligned_be64(fip->lp->wwnn, &frame->wwnn.fd_wwn);
+
+	frame->vn.fd_desc.fip_dtype = FIP_DT_VN_ID;
+	frame->vn.fd_desc.fip_dlen = sizeof(frame->vn) / FIP_BPW;
+	hton24(frame->vn.fd_mac, FIP_VN_FC_MAP);
+	hton24(frame->vn.fd_mac + 3, fip->port_id);
+	hton24(frame->vn.fd_fc_id, fip->port_id);
+	put_unaligned_be64(fip->lp->wwpn, &frame->vn.fd_wwpn);
+
+	/*
+	 * For claims, add FC-4 features.
+	 * TBD: Add interface to get fc-4 types and features from libfc.
+	 */
+	if (sub == FIP_SC_VN_CLAIM_NOTIFY || sub == FIP_SC_VN_CLAIM_REP) {
+		ff = (struct fip_fc4_feat *)(frame + 1);
+		ff->fd_desc.fip_dtype = FIP_DT_FC4F;
+		ff->fd_desc.fip_dlen = sizeof(*ff) / FIP_BPW;
+		ff->fd_fts = fip->lp->fcts;
+
+		fcp_feat = 0;
+		if (fip->lp->service_params & FCP_SPPF_INIT_FCN)
+			fcp_feat |= FCP_FEAT_INIT;
+		if (fip->lp->service_params & FCP_SPPF_TARG_FCN)
+			fcp_feat |= FCP_FEAT_TARG;
+		fcp_feat <<= (FC_TYPE_FCP * 4) % 32;
+		ff->fd_ff.fd_feat[FC_TYPE_FCP * 4 / 32] = htonl(fcp_feat);
+
+		size = (struct fip_size_desc *)(ff + 1);
+		size->fd_desc.fip_dtype = FIP_DT_FCOE_SIZE;
+		size->fd_desc.fip_dlen = sizeof(*size) / FIP_BPW;
+		size->fd_size = htons(fcoe_ctlr_fcoe_size(fip));
+	}
+
+	skb_put(skb, len);
+	skb->protocol = htons(ETH_P_FIP);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+
+	fip->send(fip, skb);
+}
+
+/**
+ * fcoe_ctlr_vn_rport_callback - Event handler for rport events.
+ * @lport: The lport which is receiving the event
+ * @rdata: remote port private data
+ * @event: The event that occured
+ *
+ * Locking Note:  The rport lock must not be held when calling this function.
+ */
+static void fcoe_ctlr_vn_rport_callback(struct fc_lport *lport,
+					struct fc_rport_priv *rdata,
+					enum fc_rport_event event)
+{
+	struct fcoe_ctlr *fip = lport->disc.priv;
+	struct fcoe_rport *frport = fcoe_ctlr_rport(rdata);
+
+	LIBFCOE_FIP_DBG(fip, "vn_rport_callback %x event %d\n",
+			rdata->ids.port_id, event);
+
+	mutex_lock(&fip->ctlr_mutex);
+	switch (event) {
+	case RPORT_EV_READY:
+		frport->login_count = 0;
+		break;
+	case RPORT_EV_LOGO:
+	case RPORT_EV_FAILED:
+	case RPORT_EV_STOP:
+		frport->login_count++;
+		if (frport->login_count > FCOE_CTLR_VN2VN_LOGIN_LIMIT) {
+			LIBFCOE_FIP_DBG(fip,
+					"rport FLOGI limited port_id %6.6x\n",
+					rdata->ids.port_id);
+			lport->tt.rport_logoff(rdata);
+		}
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&fip->ctlr_mutex);
+}
+
+static struct fc_rport_operations fcoe_ctlr_vn_rport_ops = {
+	.event_callback = fcoe_ctlr_vn_rport_callback,
+};
+
+/**
+ * fcoe_ctlr_disc_stop_locked() - stop discovery in VN2VN mode
+ * @fip: The FCoE controller
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
+{
+	mutex_lock(&lport->disc.disc_mutex);
+	lport->disc.disc_callback = NULL;
+	mutex_unlock(&lport->disc.disc_mutex);
+}
+
+/**
+ * fcoe_ctlr_disc_stop() - stop discovery in VN2VN mode
+ * @fip: The FCoE controller
+ *
+ * Called through the local port template for discovery.
+ * Called without the ctlr_mutex held.
+ */
+static void fcoe_ctlr_disc_stop(struct fc_lport *lport)
+{
+	struct fcoe_ctlr *fip = lport->disc.priv;
+
+	mutex_lock(&fip->ctlr_mutex);
+	fcoe_ctlr_disc_stop_locked(lport);
+	mutex_unlock(&fip->ctlr_mutex);
+}
+
+/**
+ * fcoe_ctlr_disc_stop_final() - stop discovery for shutdown in VN2VN mode
+ * @fip: The FCoE controller
+ *
+ * Called through the local port template for discovery.
+ * Called without the ctlr_mutex held.
+ */
+static void fcoe_ctlr_disc_stop_final(struct fc_lport *lport)
+{
+	fcoe_ctlr_disc_stop(lport);
+	lport->tt.rport_flush_queue();
+	synchronize_rcu();
+}
+
+/**
+ * fcoe_ctlr_vn_restart() - VN2VN probe restart with new port_id
+ * @fip: The FCoE controller
+ *
+ * Called with fcoe_ctlr lock held.
+ */
+static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
+{
+	unsigned long wait;
+	u32 port_id;
+
+	fcoe_ctlr_disc_stop_locked(fip->lp);
+
+	/*
+	 * Get proposed port ID.
+	 * If this is the first try after link up, use any previous port_id.
+	 * If there was none, use the low bits of the port_name.
+	 * On subsequent tries, get the next random one.
+	 * Don't use reserved IDs, use another non-zero value, just as random.
+	 */
+	port_id = fip->port_id;
+	if (fip->probe_tries)
+		port_id = prandom32(&fip->rnd_state) & 0xffff;
+	else if (!port_id)
+		port_id = fip->lp->wwpn & 0xffff;
+	if (!port_id || port_id == 0xffff)
+		port_id = 1;
+	fip->port_id = port_id;
+
+	if (fip->probe_tries < FIP_VN_RLIM_COUNT) {
+		fip->probe_tries++;
+		wait = random32() % FIP_VN_PROBE_WAIT;
+	} else
+		wait = FIP_VN_RLIM_INT;
+	mod_timer(&fip->timer, jiffies + msecs_to_jiffies(wait));
+	fcoe_ctlr_set_state(fip, FIP_ST_VNMP_START);
+}
+
+/**
+ * fcoe_ctlr_vn_start() - Start in VN2VN mode
+ * @fip: The FCoE controller
+ *
+ * Called with fcoe_ctlr lock held.
+ */
+static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
+{
+	fip->probe_tries = 0;
+	prandom32_seed(&fip->rnd_state, fip->lp->wwpn);
+	fcoe_ctlr_vn_restart(fip);
+}
+
+/**
+ * fcoe_ctlr_vn_parse - parse probe request or response
+ * @fip: The FCoE controller
+ * @skb: incoming packet
+ * @rdata: buffer for resulting parsed VN entry plus fcoe_rport
+ *
+ * Returns non-zero error number on error.
+ * Does not consume the packet.
+ */
+static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
+			      struct sk_buff *skb,
+			      struct fc_rport_priv *rdata)
+{
+	struct fip_header *fiph;
+	struct fip_desc *desc = NULL;
+	struct fip_mac_desc *macd = NULL;
+	struct fip_wwn_desc *wwn = NULL;
+	struct fip_vn_desc *vn = NULL;
+	struct fip_size_desc *size = NULL;
+	struct fcoe_rport *frport;
+	size_t rlen;
+	size_t dlen;
+	u32 desc_mask = 0;
+	u32 dtype;
+	u8 sub;
+
+	memset(rdata, 0, sizeof(*rdata) + sizeof(*frport));
+	frport = fcoe_ctlr_rport(rdata);
+
+	fiph = (struct fip_header *)skb->data;
+	frport->flags = ntohs(fiph->fip_flags);
+
+	sub = fiph->fip_subcode;
+	switch (sub) {
+	case FIP_SC_VN_PROBE_REQ:
+	case FIP_SC_VN_PROBE_REP:
+	case FIP_SC_VN_BEACON:
+		desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME) |
+			    BIT(FIP_DT_VN_ID);
+		break;
+	case FIP_SC_VN_CLAIM_NOTIFY:
+	case FIP_SC_VN_CLAIM_REP:
+		desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME) |
+			    BIT(FIP_DT_VN_ID) | BIT(FIP_DT_FC4F) |
+			    BIT(FIP_DT_FCOE_SIZE);
+		break;
+	default:
+		LIBFCOE_FIP_DBG(fip, "vn_parse unknown subcode %u\n", sub);
+		return -EINVAL;
+	}
+
+	rlen = ntohs(fiph->fip_dl_len) * 4;
+	if (rlen + sizeof(*fiph) > skb->len)
+		return -EINVAL;
+
+	desc = (struct fip_desc *)(fiph + 1);
+	while (rlen > 0) {
+		dlen = desc->fip_dlen * FIP_BPW;
+		if (dlen < sizeof(*desc) || dlen > rlen)
+			return -EINVAL;
+
+		dtype = desc->fip_dtype;
+		if (dtype < 32) {
+			if (!(desc_mask & BIT(dtype))) {
+				LIBFCOE_FIP_DBG(fip,
+						"unexpected or duplicated desc "
+						"desc type %u in "
+						"FIP VN2VN subtype %u\n",
+						dtype, sub);
+				return -EINVAL;
+			}
+			desc_mask &= ~BIT(dtype);
+		}
+
+		switch (dtype) {
+		case FIP_DT_MAC:
+			if (dlen != sizeof(struct fip_mac_desc))
+				goto len_err;
+			macd = (struct fip_mac_desc *)desc;
+			if (!is_valid_ether_addr(macd->fd_mac)) {
+				LIBFCOE_FIP_DBG(fip,
+					"Invalid MAC addr %pM in FIP VN2VN\n",
+					 macd->fd_mac);
+				return -EINVAL;
+			}
+			memcpy(frport->enode_mac, macd->fd_mac, ETH_ALEN);
+			break;
+		case FIP_DT_NAME:
+			if (dlen != sizeof(struct fip_wwn_desc))
+				goto len_err;
+			wwn = (struct fip_wwn_desc *)desc;
+			rdata->ids.node_name = get_unaligned_be64(&wwn->fd_wwn);
+			break;
+		case FIP_DT_VN_ID:
+			if (dlen != sizeof(struct fip_vn_desc))
+				goto len_err;
+			vn = (struct fip_vn_desc *)desc;
+			memcpy(frport->vn_mac, vn->fd_mac, ETH_ALEN);
+			rdata->ids.port_id = ntoh24(vn->fd_fc_id);
+			rdata->ids.port_name = get_unaligned_be64(&vn->fd_wwpn);
+			break;
+		case FIP_DT_FC4F:
+			if (dlen != sizeof(struct fip_fc4_feat))
+				goto len_err;
+			break;
+		case FIP_DT_FCOE_SIZE:
+			if (dlen != sizeof(struct fip_size_desc))
+				goto len_err;
+			size = (struct fip_size_desc *)desc;
+			frport->fcoe_len = ntohs(size->fd_size);
+			break;
+		default:
+			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
+					"in FIP probe\n", dtype);
+			/* standard says ignore unknown descriptors >= 128 */
+			if (dtype < FIP_DT_VENDOR_BASE)
+				return -EINVAL;
+			break;
+		}
+		desc = (struct fip_desc *)((char *)desc + dlen);
+		rlen -= dlen;
+	}
+	return 0;
+
+len_err:
+	LIBFCOE_FIP_DBG(fip, "FIP length error in descriptor type %x len %zu\n",
+			dtype, dlen);
+	return -EINVAL;
+}
+
+/**
+ * fcoe_ctlr_vn_send_claim() - send multicast FIP VN2VN Claim Notification.
+ * @fip: The FCoE controller
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_send_claim(struct fcoe_ctlr *fip)
+{
+	fcoe_ctlr_vn_send(fip, FIP_SC_VN_CLAIM_NOTIFY, fcoe_all_vn2vn, 0);
+	fip->sol_time = jiffies;
+}
+
+/**
+ * fcoe_ctlr_vn_probe_req() - handle incoming VN2VN probe request.
+ * @fip: The FCoE controller
+ * @rdata: parsed remote port with frport from the probe request
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_probe_req(struct fcoe_ctlr *fip,
+				   struct fc_rport_priv *rdata)
+{
+	struct fcoe_rport *frport = fcoe_ctlr_rport(rdata);
+
+	if (rdata->ids.port_id != fip->port_id)
+		return;
+
+	switch (fip->state) {
+	case FIP_ST_VNMP_CLAIM:
+	case FIP_ST_VNMP_UP:
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
+				  frport->enode_mac, 0);
+		break;
+	case FIP_ST_VNMP_PROBE1:
+	case FIP_ST_VNMP_PROBE2:
+		/*
+		 * Decide whether to reply to the Probe.
+		 * Our selected address is never a "recorded" one, so
+		 * only reply if our WWPN is greater and the
+		 * Probe's REC bit is not set.
+		 * If we don't reply, we will change our address.
+		 */
+		if (fip->lp->wwpn > rdata->ids.port_name &&
+		    !(frport->flags & FIP_FL_REC_OR_P2P)) {
+			fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
+					  frport->enode_mac, 0);
+			break;
+		}
+		/* fall through */
+	case FIP_ST_VNMP_START:
+		fcoe_ctlr_vn_restart(fip);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * fcoe_ctlr_vn_probe_reply() - handle incoming VN2VN probe reply.
+ * @fip: The FCoE controller
+ * @rdata: parsed remote port with frport from the probe request
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_probe_reply(struct fcoe_ctlr *fip,
+				   struct fc_rport_priv *rdata)
+{
+	if (rdata->ids.port_id != fip->port_id)
+		return;
+	switch (fip->state) {
+	case FIP_ST_VNMP_START:
+	case FIP_ST_VNMP_PROBE1:
+	case FIP_ST_VNMP_PROBE2:
+	case FIP_ST_VNMP_CLAIM:
+		fcoe_ctlr_vn_restart(fip);
+		break;
+	case FIP_ST_VNMP_UP:
+		fcoe_ctlr_vn_send_claim(fip);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * fcoe_ctlr_vn_add() - Add a VN2VN entry to the list, based on a claim reply.
+ * @fip: The FCoE controller
+ * @new: newly-parsed remote port with frport as a template for new rdata
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_add(struct fcoe_ctlr *fip, struct fc_rport_priv *new)
+{
+	struct fc_lport *lport = fip->lp;
+	struct fc_rport_priv *rdata;
+	struct fc_rport_identifiers *ids;
+	struct fcoe_rport *frport;
+	u32 port_id;
+
+	port_id = new->ids.port_id;
+	if (port_id == fip->port_id)
+		return;
+
+	mutex_lock(&lport->disc.disc_mutex);
+	rdata = lport->tt.rport_create(lport, port_id);
+	if (!rdata) {
+		mutex_unlock(&lport->disc.disc_mutex);
+		return;
+	}
+
+	rdata->ops = &fcoe_ctlr_vn_rport_ops;
+	rdata->disc_id = lport->disc.disc_id;
+
+	ids = &rdata->ids;
+	if ((ids->port_name != -1 && ids->port_name != new->ids.port_name) ||
+	    (ids->node_name != -1 && ids->node_name != new->ids.node_name))
+		lport->tt.rport_logoff(rdata);
+	ids->port_name = new->ids.port_name;
+	ids->node_name = new->ids.node_name;
+	mutex_unlock(&lport->disc.disc_mutex);
+
+	frport = fcoe_ctlr_rport(rdata);
+	LIBFCOE_FIP_DBG(fip, "vn_add rport %6.6x %s\n",
+			port_id, frport->fcoe_len ? "old" : "new");
+	*frport = *fcoe_ctlr_rport(new);
+	frport->time = 0;
+}
+
+/**
+ * fcoe_ctlr_vn_lookup() - Find VN remote port's MAC address
+ * @fip: The FCoE controller
+ * @port_id:  The port_id of the remote VN_node
+ * @mac: buffer which will hold the VN_NODE destination MAC address, if found.
+ *
+ * Returns non-zero error if no remote port found.
+ */
+static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *fip, u32 port_id, u8 *mac)
+{
+	struct fc_lport *lport = fip->lp;
+	struct fc_rport_priv *rdata;
+	struct fcoe_rport *frport;
+	int ret = -1;
+
+	rcu_read_lock();
+	rdata = lport->tt.rport_lookup(lport, port_id);
+	if (rdata) {
+		frport = fcoe_ctlr_rport(rdata);
+		memcpy(mac, frport->enode_mac, ETH_ALEN);
+		ret = 0;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+/**
+ * fcoe_ctlr_vn_claim_notify() - handle received FIP VN2VN Claim Notification
+ * @fip: The FCoE controller
+ * @new: newly-parsed remote port with frport as a template for new rdata
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_claim_notify(struct fcoe_ctlr *fip,
+				      struct fc_rport_priv *new)
+{
+	struct fcoe_rport *frport = fcoe_ctlr_rport(new);
+
+	if (frport->flags & FIP_FL_REC_OR_P2P) {
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
+		return;
+	}
+	switch (fip->state) {
+	case FIP_ST_VNMP_START:
+	case FIP_ST_VNMP_PROBE1:
+	case FIP_ST_VNMP_PROBE2:
+		if (new->ids.port_id == fip->port_id)
+			fcoe_ctlr_vn_restart(fip);
+		break;
+	case FIP_ST_VNMP_CLAIM:
+	case FIP_ST_VNMP_UP:
+		if (new->ids.port_id == fip->port_id) {
+			if (new->ids.port_name > fip->lp->wwpn) {
+				fcoe_ctlr_vn_restart(fip);
+				break;
+			}
+			fcoe_ctlr_vn_send_claim(fip);
+			break;
+		}
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_CLAIM_REP, frport->enode_mac,
+				  min((u32)frport->fcoe_len,
+				      fcoe_ctlr_fcoe_size(fip)));
+		fcoe_ctlr_vn_add(fip, new);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * fcoe_ctlr_vn_claim_resp() - handle received Claim Response
+ * @fip: The FCoE controller that received the frame
+ * @new: newly-parsed remote port with frport from the Claim Response
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_claim_resp(struct fcoe_ctlr *fip,
+				    struct fc_rport_priv *new)
+{
+	LIBFCOE_FIP_DBG(fip, "claim resp from from rport %x - state %s\n",
+			new->ids.port_id, fcoe_ctlr_state(fip->state));
+	if (fip->state == FIP_ST_VNMP_UP || fip->state == FIP_ST_VNMP_CLAIM)
+		fcoe_ctlr_vn_add(fip, new);
+}
+
+/**
+ * fcoe_ctlr_vn_beacon() - handle received beacon.
+ * @fip: The FCoE controller that received the frame
+ * @new: newly-parsed remote port with frport from the Beacon
+ *
+ * Called with ctlr_mutex held.
+ */
+static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
+				struct fc_rport_priv *new)
+{
+	struct fc_lport *lport = fip->lp;
+	struct fc_rport_priv *rdata;
+	struct fcoe_rport *frport;
+
+	frport = fcoe_ctlr_rport(new);
+	if (frport->flags & FIP_FL_REC_OR_P2P) {
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
+		return;
+	}
+	mutex_lock(&lport->disc.disc_mutex);
+	rdata = lport->tt.rport_lookup(lport, new->ids.port_id);
+	if (rdata)
+		kref_get(&rdata->kref);
+	mutex_unlock(&lport->disc.disc_mutex);
+	if (rdata) {
+		if (rdata->ids.node_name == new->ids.node_name &&
+		    rdata->ids.port_name == new->ids.port_name) {
+			frport = fcoe_ctlr_rport(rdata);
+			if (!frport->time && fip->state == FIP_ST_VNMP_UP)
+				lport->tt.rport_login(rdata);
+			frport->time = jiffies;
+		}
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		return;
+	}
+	if (fip->state != FIP_ST_VNMP_UP)
+		return;
+
+	/*
+	 * Beacon from a new neighbor.
+	 * Send a claim notify if one hasn't been sent recently.
+	 * Don't add the neighbor yet.
+	 */
+	LIBFCOE_FIP_DBG(fip, "beacon from new rport %x. sending claim notify\n",
+			new->ids.port_id);
+	if (time_after(jiffies,
+		       fip->sol_time + msecs_to_jiffies(FIP_VN_ANN_WAIT)))
+		fcoe_ctlr_vn_send_claim(fip);
+}
+
+/**
+ * fcoe_ctlr_vn_age() - Check for VN_ports without recent beacons
+ * @fip: The FCoE controller
+ *
+ * Called with ctlr_mutex held.
+ * Called only in state FIP_ST_VNMP_UP.
+ * Returns the soonest time for next age-out or a time far in the future.
+ */
+static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
+{
+	struct fc_lport *lport = fip->lp;
+	struct fc_rport_priv *rdata;
+	struct fcoe_rport *frport;
+	unsigned long next_time;
+	unsigned long deadline;
+
+	next_time = jiffies + msecs_to_jiffies(FIP_VN_BEACON_INT * 10);
+	mutex_lock(&lport->disc.disc_mutex);
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
+		frport = fcoe_ctlr_rport(rdata);
+		if (!frport->time)
+			continue;
+		deadline = frport->time +
+			   msecs_to_jiffies(FIP_VN_BEACON_INT * 25 / 10);
+		if (time_after_eq(jiffies, deadline)) {
+			frport->time = 0;
+			LIBFCOE_FIP_DBG(fip,
+				"port %16.16llx fc_id %6.6x beacon expired\n",
+				rdata->ids.port_name, rdata->ids.port_id);
+			lport->tt.rport_logoff(rdata);
+		} else if (time_before(deadline, next_time))
+			next_time = deadline;
+	}
+	mutex_unlock(&lport->disc.disc_mutex);
+	return next_time;
+}
+
+/**
+ * fcoe_ctlr_vn_recv() - Receive a FIP frame
+ * @fip: The FCoE controller that received the frame
+ * @skb: The received FIP frame
+ *
+ * Returns non-zero if the frame is dropped.
+ * Always consumes the frame.
+ */
+static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fip_header *fiph;
+	enum fip_vn2vn_subcode sub;
+	union {
+		struct fc_rport_priv rdata;
+		struct fcoe_rport frport;
+	} buf;
+	int rc;
+
+	fiph = (struct fip_header *)skb->data;
+	sub = fiph->fip_subcode;
+
+	rc = fcoe_ctlr_vn_parse(fip, skb, &buf.rdata);
+	if (rc) {
+		LIBFCOE_FIP_DBG(fip, "vn_recv vn_parse error %d\n", rc);
+		goto drop;
+	}
+
+	mutex_lock(&fip->ctlr_mutex);
+	switch (sub) {
+	case FIP_SC_VN_PROBE_REQ:
+		fcoe_ctlr_vn_probe_req(fip, &buf.rdata);
+		break;
+	case FIP_SC_VN_PROBE_REP:
+		fcoe_ctlr_vn_probe_reply(fip, &buf.rdata);
+		break;
+	case FIP_SC_VN_CLAIM_NOTIFY:
+		fcoe_ctlr_vn_claim_notify(fip, &buf.rdata);
+		break;
+	case FIP_SC_VN_CLAIM_REP:
+		fcoe_ctlr_vn_claim_resp(fip, &buf.rdata);
+		break;
+	case FIP_SC_VN_BEACON:
+		fcoe_ctlr_vn_beacon(fip, &buf.rdata);
+		break;
+	default:
+		LIBFCOE_FIP_DBG(fip, "vn_recv unknown subcode %d\n", sub);
+		rc = -1;
+		break;
+	}
+	mutex_unlock(&fip->ctlr_mutex);
+drop:
+	kfree_skb(skb);
+	return rc;
+}
+
+/**
+ * fcoe_ctlr_disc_recv - discovery receive handler for VN2VN mode.
+ * @fip: The FCoE controller
+ *
+ * This should never be called since we don't see RSCNs or other
+ * fabric-generated ELSes.
+ */
+static void fcoe_ctlr_disc_recv(struct fc_seq *seq, struct fc_frame *fp,
+				struct fc_lport *lport)
+{
+	struct fc_seq_els_data rjt_data;
+
+	rjt_data.fp = NULL;
+	rjt_data.reason = ELS_RJT_UNSUP;
+	rjt_data.explan = ELS_EXPL_NONE;
+	lport->tt.seq_els_rsp_send(seq, ELS_LS_RJT, &rjt_data);
+	fc_frame_free(fp);
+}
+
+/**
+ * fcoe_ctlr_disc_recv - start discovery for VN2VN mode.
+ * @fip: The FCoE controller
+ *
+ * This sets a flag indicating that remote ports should be created
+ * and started for the peers we discover.  We use the disc_callback
+ * pointer as that flag.  Peers already discovered are created here.
+ *
+ * The lport lock is held during this call. The callback must be done
+ * later, without holding either the lport or discovery locks.
+ * The fcoe_ctlr lock may also be held during this call.
+ */
+static void fcoe_ctlr_disc_start(void (*callback)(struct fc_lport *,
+						  enum fc_disc_event),
+				 struct fc_lport *lport)
+{
+	struct fc_disc *disc = &lport->disc;
+	struct fcoe_ctlr *fip = disc->priv;
+
+	mutex_lock(&disc->disc_mutex);
+	disc->disc_callback = callback;
+	disc->disc_id = (disc->disc_id + 2) | 1;
+	disc->pending = 1;
+	schedule_work(&fip->timer_work);
+	mutex_unlock(&disc->disc_mutex);
+}
+
+/**
+ * fcoe_ctlr_vn_disc() - report FIP VN_port discovery results after claim state.
+ * @fip: The FCoE controller
+ *
+ * Starts the FLOGI and PLOGI login process to each discovered rport for which
+ * we've received at least one beacon.
+ * Performs the discovery complete callback.
+ */
+static void fcoe_ctlr_vn_disc(struct fcoe_ctlr *fip)
+{
+	struct fc_lport *lport = fip->lp;
+	struct fc_disc *disc = &lport->disc;
+	struct fc_rport_priv *rdata;
+	struct fcoe_rport *frport;
+	void (*callback)(struct fc_lport *, enum fc_disc_event);
+
+	mutex_lock(&disc->disc_mutex);
+	callback = disc->pending ? disc->disc_callback : NULL;
+	disc->pending = 0;
+	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
+		frport = fcoe_ctlr_rport(rdata);
+		if (frport->time)
+			lport->tt.rport_login(rdata);
+	}
+	mutex_unlock(&disc->disc_mutex);
+	if (callback)
+		callback(lport, DISC_EV_SUCCESS);
+}
+
+/**
+ * fcoe_ctlr_vn_timeout - timer work function for VN2VN mode.
+ * @fip: The FCoE controller
+ */
+static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
+{
+	unsigned long next_time;
+	u8 mac[ETH_ALEN];
+	u32 new_port_id = 0;
+
+	mutex_lock(&fip->ctlr_mutex);
+	switch (fip->state) {
+	case FIP_ST_VNMP_START:
+		fcoe_ctlr_set_state(fip, FIP_ST_VNMP_PROBE1);
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
+		next_time = jiffies + msecs_to_jiffies(FIP_VN_PROBE_WAIT);
+		break;
+	case FIP_ST_VNMP_PROBE1:
+		fcoe_ctlr_set_state(fip, FIP_ST_VNMP_PROBE2);
+		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ, fcoe_all_vn2vn, 0);
+		next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);
+		break;
+	case FIP_ST_VNMP_PROBE2:
+		fcoe_ctlr_set_state(fip, FIP_ST_VNMP_CLAIM);
+		new_port_id = fip->port_id;
+		hton24(mac, FIP_VN_FC_MAP);
+		hton24(mac + 3, new_port_id);
+		fip->update_mac(fip->lp, mac);
+		fcoe_ctlr_vn_send_claim(fip);
+		next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);
+		break;
+	case FIP_ST_VNMP_CLAIM:
+		/*
+		 * This may be invoked either by starting discovery so don't
+		 * go to the next state unless it's been long enough.
+		 */
+		next_time = fip->sol_time + msecs_to_jiffies(FIP_VN_ANN_WAIT);
+		if (time_after_eq(jiffies, next_time)) {
+			fcoe_ctlr_set_state(fip, FIP_ST_VNMP_UP);
+			fcoe_ctlr_vn_send(fip, FIP_SC_VN_BEACON,
+					  fcoe_all_vn2vn, 0);
+			next_time = jiffies + msecs_to_jiffies(FIP_VN_ANN_WAIT);
+			fip->port_ka_time = next_time;
+		}
+		fcoe_ctlr_vn_disc(fip);
+		break;
+	case FIP_ST_VNMP_UP:
+		next_time = fcoe_ctlr_vn_age(fip);
+		if (time_after_eq(jiffies, fip->port_ka_time)) {
+			fcoe_ctlr_vn_send(fip, FIP_SC_VN_BEACON,
+					  fcoe_all_vn2vn, 0);
+			fip->port_ka_time = jiffies +
+				 msecs_to_jiffies(FIP_VN_BEACON_INT +
+					(random32() % FIP_VN_BEACON_FUZZ));
+		}
+		if (time_before(fip->port_ka_time, next_time))
+			next_time = fip->port_ka_time;
+		break;
+	case FIP_ST_LINK_WAIT:
+		goto unlock;
+	default:
+		WARN(1, "unexpected state %d", fip->state);
+		goto unlock;
+	}
+	mod_timer(&fip->timer, next_time);
+unlock:
+	mutex_unlock(&fip->ctlr_mutex);
+
+	/* If port ID is new, notify local port after dropping ctlr_mutex */
+	if (new_port_id)
+		fc_lport_set_local_id(fip->lp, new_port_id);
+}
+
+/**
  * fcoe_libfc_config() - Sets up libfc related properties for local port
  * @lp: The local port to configure libfc for
+ * @fip: The FCoE controller in use by the local port
  * @tt: The libfc function template
+ * @init_fcp: If non-zero, the FCP portion of libfc should be initialized
  *
  * Returns : 0 for success
  */
-int fcoe_libfc_config(struct fc_lport *lport,
-		      struct libfc_function_template *tt)
+int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
+		      const struct libfc_function_template *tt, int init_fcp)
 {
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lport->tt, tt, sizeof(*tt));
-	if (fc_fcp_init(lport))
+	if (init_fcp && fc_fcp_init(lport))
 		return -ENOMEM;
 	fc_exch_init(lport);
 	fc_elsct_init(lport);
 	fc_lport_init(lport);
+	if (fip->mode == FIP_MODE_VN2VN)
+		lport->rport_priv_size = sizeof(struct fcoe_rport);
 	fc_rport_init(lport);
-	fc_disc_init(lport);
-
+	if (fip->mode == FIP_MODE_VN2VN) {
+		lport->point_to_multipoint = 1;
+		lport->tt.disc_recv_req = fcoe_ctlr_disc_recv;
+		lport->tt.disc_start = fcoe_ctlr_disc_start;
+		lport->tt.disc_stop = fcoe_ctlr_disc_stop;
+		lport->tt.disc_stop_final = fcoe_ctlr_disc_stop_final;
+		mutex_init(&lport->disc.disc_mutex);
+		INIT_LIST_HEAD(&lport->disc.rports);
+		lport->disc.priv = fip;
+	} else {
+		fc_disc_init(lport);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
-
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index d0fe1c3..9eb7a9e 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -673,7 +673,6 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	/* Start local port initiatialization */
 
 	lp->link_up = 0;
-	lp->tt = fnic_transport_template;
 
 	lp->max_retry_count = fnic->config.flogi_retries;
 	lp->max_rport_retry_count = fnic->config.plogi_retries;
@@ -689,11 +688,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	fc_set_wwnn(lp, fnic->config.node_wwn);
 	fc_set_wwpn(lp, fnic->config.port_wwn);
 
-	fc_lport_init(lp);
-	fc_exch_init(lp);
-	fc_elsct_init(lp);
-	fc_rport_init(lp);
-	fc_disc_init(lp);
+	fcoe_libfc_config(lp, &fnic->ctlr, &fnic_transport_template, 0);
 
 	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCPIO_HOST_EXCH_RANGE_START,
 			       FCPIO_HOST_EXCH_RANGE_END, NULL)) {
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 1a84a31..06f1b5a 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -26,6 +26,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/random.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
 
@@ -37,6 +38,7 @@
 #define FCOE_CTLR_START_DELAY	2000	/* mS after first adv. to choose FCF */
 #define FCOE_CTRL_SOL_TOV	2000	/* min. solicitation interval (mS) */
 #define FCOE_CTLR_FCF_LIMIT	20	/* max. number of FCF entries */
+#define FCOE_CTLR_VN2VN_LOGIN_LIMIT 3	/* max. VN2VN rport login retries */
 
 /**
  * enum fip_state - internal state of FCoE controller.
@@ -45,6 +47,11 @@
  * @FIP_ST_AUTO:	determining whether to use FIP or non-FIP mode.
  * @FIP_ST_NON_FIP:	non-FIP mode selected.
  * @FIP_ST_ENABLED:	FIP mode selected.
+ * @FIP_ST_VNMP_START:	VN2VN multipath mode start, wait
+ * @FIP_ST_VNMP_PROBE1:	VN2VN sent first probe, listening
+ * @FIP_ST_VNMP_PROBE2:	VN2VN sent second probe, listening
+ * @FIP_ST_VNMP_CLAIM:	VN2VN sent claim, waiting for responses
+ * @FIP_ST_VNMP_UP:	VN2VN multipath mode operation
  */
 enum fip_state {
 	FIP_ST_DISABLED,
@@ -52,6 +59,11 @@ enum fip_state {
 	FIP_ST_AUTO,
 	FIP_ST_NON_FIP,
 	FIP_ST_ENABLED,
+	FIP_ST_VNMP_START,
+	FIP_ST_VNMP_PROBE1,
+	FIP_ST_VNMP_PROBE2,
+	FIP_ST_VNMP_CLAIM,
+	FIP_ST_VNMP_UP,
 };
 
 /*
@@ -62,6 +74,7 @@ enum fip_state {
 #define FIP_MODE_AUTO		FIP_ST_AUTO
 #define FIP_MODE_NON_FIP	FIP_ST_NON_FIP
 #define FIP_MODE_FABRIC		FIP_ST_ENABLED
+#define FIP_MODE_VN2VN		FIP_ST_VNMP_START
 
 /**
  * struct fcoe_ctlr - FCoE Controller and FIP state
@@ -79,11 +92,14 @@ enum fip_state {
  * @timer_work:	   &work_struct for doing keep-alives and resets.
  * @recv_work:	   &work_struct for receiving FIP frames.
  * @fip_recv_list: list of received FIP frames.
+ * @rnd_state:	   state for pseudo-random number generator.
+ * @port_id:	   proposed or selected local-port ID.
  * @user_mfs:	   configured maximum FC frame size, including FC header.
  * @flogi_oxid:    exchange ID of most recent fabric login.
  * @flogi_count:   number of FLOGI attempts in AUTO mode.
  * @map_dest:	   use the FC_MAP mode for destination MAC addresses.
  * @spma:	   supports SPMA server-provided MACs mode
+ * @probe_tries:   number of FC_IDs probed
  * @dest_addr:	   MAC address of the selected FC forwarder.
  * @ctl_src_addr:  the native MAC address of our local port.
  * @send:	   LLD-supplied function to handle sending FIP Ethernet frames
@@ -110,11 +126,16 @@ struct fcoe_ctlr {
 	struct work_struct timer_work;
 	struct work_struct recv_work;
 	struct sk_buff_head fip_recv_list;
+
+	struct rnd_state rnd_state;
+	u32 port_id;
+
 	u16 user_mfs;
 	u16 flogi_oxid;
 	u8 flogi_count;
 	u8 map_dest;
 	u8 spma;
+	u8 probe_tries;
 	u8 dest_addr[ETH_ALEN];
 	u8 ctl_src_addr[ETH_ALEN];
 
@@ -160,6 +181,24 @@ struct fcoe_fcf {
 	u8 fd_flags:1;
 };
 
+/**
+ * struct fcoe_rport - VN2VN remote port
+ * @time:	time of create or last beacon packet received from node
+ * @fcoe_len:	max FCoE frame size, not including VLAN or Ethernet headers
+ * @flags:	flags from probe or claim
+ * @login_count: number of unsuccessful rport logins to this port
+ * @enode_mac:	E_Node control MAC address
+ * @vn_mac:	VN_Node assigned MAC address for data
+ */
+struct fcoe_rport {
+	unsigned long time;
+	u16 fcoe_len;
+	u16 flags;
+	u8 login_count;
+	u8 enode_mac[ETH_ALEN];
+	u8 vn_mac[ETH_ALEN];
+};
+
 /* FIP API functions */
 void fcoe_ctlr_init(struct fcoe_ctlr *, enum fip_state);
 void fcoe_ctlr_destroy(struct fcoe_ctlr *);
@@ -172,7 +211,8 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 
 /* libfcoe funcs */
 u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
-int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
+int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
+		      const struct libfc_function_template *, int init_fcp);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.

