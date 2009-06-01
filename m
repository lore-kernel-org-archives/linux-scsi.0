From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/6] libfcoe: Add runtime debugging with module param
	debug_logging
Date: Mon, 01 Jun 2009 10:50:14 -0700
Message-ID: <20090601175014.12911.99567.stgit@fritz>
References: <20090601174948.12911.35446.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZFARuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 13:50:12 -0400
In-Reply-To: <20090601174948.12911.35446.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This patch adds a 'debug_logging' module parameter to
libfcoe.ko. It is an unsigned int that represents a bitmask of
available debug logging levels, each of which can be tuned at
runtime. Currently there are only two logging levels for this
module-

   bit
LSB 0 = libfcoe general logging
    1 = FIP logging

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   94 +++++++++++++++++++++++++------------------
 1 files changed, 54 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 2f5bc7f..f544340 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -56,15 +56,28 @@ static void fcoe_ctlr_recv_work(struct work_struct *);
 
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
 
-static u32 fcoe_ctlr_debug;	/* 1 for basic, 2 for noisy debug */
+unsigned int libfcoe_debug_logging;
+module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
-#define FIP_DBG_LVL(level, fmt, args...) 				\
+#define LIBFCOE_LOGGING     0x01 /* General logging, not categorized */
+#define LIBFCOE_FIP_LOGGING 0x02 /* FIP logging */
+
+#define LIBFCOE_CHECK_LOGGING(LEVEL, CMD)				\
+do {                                                            	\
+	if (unlikely(libfcoe_debug_logging & LEVEL))			\
 		do {							\
-			if (fcoe_ctlr_debug >= (level))			\
-				FC_DBG(fmt, ##args);			\
-		} while (0)
+			CMD;						\
+		} while (0);						\
+} while (0);
+
+#define LIBFCOE_DBG(fmt, args...)					\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_LOGGING,				\
+			      printk(KERN_INFO "libfcoe: " fmt, ##args);)
 
-#define FIP_DBG(fmt, args...)	FIP_DBG_LVL(1, fmt, ##args)
+#define LIBFCOE_FIP_DBG(fmt, args...)					\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_FIP_LOGGING,			\
+			      printk(KERN_INFO "fip: " fmt, ##args);)
 
 /*
  * Return non-zero if FCF fcoe_size has been validated.
@@ -243,7 +256,7 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 		fip->last_link = 1;
 		fip->link = 1;
 		spin_unlock_bh(&fip->lock);
-		FIP_DBG("%s", "setting AUTO mode.\n");
+		LIBFCOE_FIP_DBG("%s", "setting AUTO mode.\n");
 		fc_linkup(fip->lp);
 		fcoe_ctlr_solicit(fip, NULL);
 	} else
@@ -614,7 +627,8 @@ static int fcoe_ctlr_parse_adv(struct sk_buff *skb, struct fcoe_fcf *fcf)
 			       ((struct fip_mac_desc *)desc)->fd_mac,
 			       ETH_ALEN);
 			if (!is_valid_ether_addr(fcf->fcf_mac)) {
-				FIP_DBG("invalid MAC addr in FIP adv\n");
+				LIBFCOE_FIP_DBG("Invalid MAC address "
+						"in FIP adv\n");
 				return -EINVAL;
 			}
 			break;
@@ -647,8 +661,8 @@ static int fcoe_ctlr_parse_adv(struct sk_buff *skb, struct fcoe_fcf *fcf)
 		case FIP_DT_LOGO:
 		case FIP_DT_ELP:
 		default:
-			FIP_DBG("unexpected descriptor type %x in FIP adv\n",
-				desc->fip_dtype);
+			LIBFCOE_FIP_DBG("unexpected descriptor type %x "
+					"in FIP adv\n", desc->fip_dtype);
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
 				return -EINVAL;
@@ -664,8 +678,8 @@ static int fcoe_ctlr_parse_adv(struct sk_buff *skb, struct fcoe_fcf *fcf)
 	return 0;
 
 len_err:
-	FIP_DBG("FIP length error in descriptor type %x len %zu\n",
-		desc->fip_dtype, dlen);
+	LIBFCOE_FIP_DBG("FIP length error in descriptor type %x len %zu\n",
+			desc->fip_dtype, dlen);
 	return -EINVAL;
 }
 
@@ -728,9 +742,10 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
 	fcf->time = jiffies;
-	FIP_DBG_LVL(found ? 2 : 1, "%s FCF for fab %llx map %x val %d\n",
-		    found ? "old" : "new",
-		    fcf->fabric_name, fcf->fc_map, mtu_valid);
+	if (!found) {
+		LIBFCOE_FIP_DBG("New FCF for fab %llx map %x val %d\n",
+				fcf->fabric_name, fcf->fc_map, mtu_valid);
+	}
 
 	/*
 	 * If this advertisement is not solicited and our max receive size
@@ -807,7 +822,8 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			       ((struct fip_mac_desc *)desc)->fd_mac,
 			       ETH_ALEN);
 			if (!is_valid_ether_addr(granted_mac)) {
-				FIP_DBG("invalid MAC addrs in FIP ELS\n");
+				LIBFCOE_FIP_DBG("Invalid MAC address "
+						"in FIP ELS\n");
 				goto drop;
 			}
 			break;
@@ -825,8 +841,8 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			els_dtype = desc->fip_dtype;
 			break;
 		default:
-			FIP_DBG("unexpected descriptor type %x "
-				"in FIP adv\n", desc->fip_dtype);
+			LIBFCOE_FIP_DBG("unexpected descriptor type %x "
+					"in FIP adv\n", desc->fip_dtype);
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
 				goto drop;
@@ -867,8 +883,8 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	return;
 
 len_err:
-	FIP_DBG("FIP length error in descriptor type %x len %zu\n",
-		desc->fip_dtype, dlen);
+	LIBFCOE_FIP_DBG("FIP length error in descriptor type %x len %zu\n",
+			desc->fip_dtype, dlen);
 drop:
 	kfree_skb(skb);
 }
@@ -894,7 +910,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	struct fc_lport *lp = fip->lp;
 	u32	desc_mask;
 
-	FIP_DBG("Clear Virtual Link received\n");
+	LIBFCOE_FIP_DBG("Clear Virtual Link received\n");
 	if (!fcf)
 		return;
 	if (!fcf || !fc_host_port_id(lp->host))
@@ -952,9 +968,9 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	 * reset only if all required descriptors were present and valid.
 	 */
 	if (desc_mask) {
-		FIP_DBG("missing descriptors mask %x\n", desc_mask);
+		LIBFCOE_FIP_DBG("missing descriptors mask %x\n", desc_mask);
 	} else {
-		FIP_DBG("performing Clear Virtual Link\n");
+		LIBFCOE_FIP_DBG("performing Clear Virtual Link\n");
 		fcoe_ctlr_reset(fip, FIP_ST_ENABLED);
 	}
 }
@@ -1002,10 +1018,6 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	op = ntohs(fiph->fip_op);
 	sub = fiph->fip_subcode;
 
-	FIP_DBG_LVL(2, "ver %x op %x/%x dl %x fl %x\n",
-		    FIP_VER_DECAPS(fiph->fip_ver), op, sub,
-		    ntohs(fiph->fip_dl_len), ntohs(fiph->fip_flags));
-
 	if (FIP_VER_DECAPS(fiph->fip_ver) != FIP_VER)
 		goto drop;
 	if (ntohs(fiph->fip_dl_len) * FIP_BPW + sizeof(*fiph) > skb->len)
@@ -1017,7 +1029,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		fip->map_dest = 0;
 		fip->state = FIP_ST_ENABLED;
 		state = FIP_ST_ENABLED;
-		FIP_DBG("using FIP mode\n");
+		LIBFCOE_FIP_DBG("Using FIP mode\n");
 	}
 	spin_unlock_bh(&fip->lock);
 	if (state != FIP_ST_ENABLED)
@@ -1052,14 +1064,15 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 	struct fcoe_fcf *best = NULL;
 
 	list_for_each_entry(fcf, &fip->fcfs, list) {
-		FIP_DBG("consider FCF for fab %llx VFID %d map %x val %d\n",
-			fcf->fabric_name, fcf->vfid,
-			fcf->fc_map, fcoe_ctlr_mtu_valid(fcf));
+		LIBFCOE_FIP_DBG("consider FCF for fab %llx VFID %d map %x "
+				"val %d\n", fcf->fabric_name, fcf->vfid,
+				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf));
 		if (!fcoe_ctlr_fcf_usable(fcf)) {
-			FIP_DBG("FCF for fab %llx map %x %svalid %savailable\n",
-				fcf->fabric_name, fcf->fc_map,
-				(fcf->flags & FIP_FL_SOL) ? "" : "in",
-				(fcf->flags & FIP_FL_AVAIL) ? "" : "un");
+			LIBFCOE_FIP_DBG("FCF for fab %llx map %x %svalid "
+					"%savailable\n", fcf->fabric_name,
+					fcf->fc_map, (fcf->flags & FIP_FL_SOL)
+					? "" : "in", (fcf->flags & FIP_FL_AVAIL)
+					? "" : "un");
 			continue;
 		}
 		if (!best) {
@@ -1069,7 +1082,8 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 		if (fcf->fabric_name != best->fabric_name ||
 		    fcf->vfid != best->vfid ||
 		    fcf->fc_map != best->fc_map) {
-			FIP_DBG("conflicting fabric, VFID, or FC-MAP\n");
+			LIBFCOE_FIP_DBG("Conflicting fabric, VFID, "
+					"or FC-MAP\n");
 			return;
 		}
 		if (fcf->pri < best->pri)
@@ -1113,7 +1127,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 	if (sel != fcf) {
 		fcf = sel;		/* the old FCF may have been freed */
 		if (sel) {
-			printk(KERN_INFO "host%d: FIP selected "
+			printk(KERN_INFO "libfcoe: host%d: FIP selected "
 			       "Fibre-Channel Forwarder MAC %s\n",
 			       fip->lp->host->host_no,
 			       print_mac(buf, sel->fcf_mac));
@@ -1123,7 +1137,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 			fip->ctlr_ka_time = jiffies + sel->fka_period;
 			fip->link = 1;
 		} else {
-			printk(KERN_NOTICE "host%d: "
+			printk(KERN_NOTICE "libfcoe: host%d: "
 			       "FIP Fibre-Channel Forwarder timed out.  "
 			       "Starting FCF discovery.\n",
 			       fip->lp->host->host_no);
@@ -1247,7 +1261,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_frame *fp, u8 *sa)
 			return -EINVAL;
 		}
 		fip->state = FIP_ST_NON_FIP;
-		FIP_DBG("received FLOGI LS_ACC using non-FIP mode\n");
+		LIBFCOE_FIP_DBG("received FLOGI LS_ACC using non-FIP mode\n");
 
 		/*
 		 * FLOGI accepted.
@@ -1276,7 +1290,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_frame *fp, u8 *sa)
 			memcpy(fip->dest_addr, sa, ETH_ALEN);
 			fip->map_dest = 0;
 			if (fip->state == FIP_ST_NON_FIP)
-				FIP_DBG("received FLOGI REQ, "
+				LIBFCOE_FIP_DBG("received FLOGI REQ, "
 						"using non-FIP mode\n");
 			fip->state = FIP_ST_NON_FIP;
 		}

