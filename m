From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/10] libfcoe: Support extra MAC descriptor to be used as
 FCoE MAC
Date: Fri, 09 Mar 2012 14:50:03 -0800
Message-ID: <20120309225003.6515.11520.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964908Ab2CIWuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:51 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Some switch implementations (eg., HP virtual connect FlexFabric) send two MAC
descriptors in FIP FLOGI response, with first MAC descriptor (granted_mac) used
as FPMA, and the second one (fcoe_mac) used as destination address for
sending/receiving FCoE packets. fip_mac continues to be used for FIP traffic.
This patch introduces fcoe_mac in fcoe_fcf structure. For regular switches,
both fcoe_mac and fip_mac will be the same. For the switches that send
additional MAC descriptor, fcoe_mac is updated.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   28 +++++++++++++++++++++++-----
 include/scsi/libfcoe.h        |    4 +++-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index a43dad2..249a106 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -242,7 +242,7 @@ static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
 		printk(KERN_INFO "libfcoe: host%d: FIP selected "
 		       "Fibre-Channel Forwarder MAC %pM\n",
 		       fip->lp->host->host_no, sel->fcf_mac);
-		memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
+		memcpy(fip->dest_addr, sel->fcoe_mac, ETH_ALEN);
 		fip->map_dest = 0;
 	}
 unlock:
@@ -824,6 +824,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 			memcpy(fcf->fcf_mac,
 			       ((struct fip_mac_desc *)desc)->fd_mac,
 			       ETH_ALEN);
+			memcpy(fcf->fcoe_mac, fcf->fcf_mac, ETH_ALEN);
 			if (!is_valid_ether_addr(fcf->fcf_mac)) {
 				LIBFCOE_FIP_DBG(fip,
 					"Invalid MAC addr %pM in FIP adv\n",
@@ -1013,6 +1014,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	struct fip_desc *desc;
 	struct fip_encaps *els;
 	struct fcoe_dev_stats *stats;
+	struct fcoe_fcf *sel;
 	enum fip_desc_type els_dtype = 0;
 	u8 els_op;
 	u8 sub;
@@ -1040,7 +1042,8 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			goto drop;
 		/* Drop ELS if there are duplicate critical descriptors */
 		if (desc->fip_dtype < 32) {
-			if (desc_mask & 1U << desc->fip_dtype) {
+			if ((desc->fip_dtype != FIP_DT_MAC) &&
+			    (desc_mask & 1U << desc->fip_dtype)) {
 				LIBFCOE_FIP_DBG(fip, "Duplicate Critical "
 						"Descriptors in FIP ELS\n");
 				goto drop;
@@ -1049,17 +1052,32 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		}
 		switch (desc->fip_dtype) {
 		case FIP_DT_MAC:
+			sel = fip->sel_fcf;
 			if (desc_cnt == 1) {
 				LIBFCOE_FIP_DBG(fip, "FIP descriptors "
 						"received out of order\n");
 				goto drop;
 			}
+			/*
+			 * Some switch implementations send two MAC descriptors,
+			 * with first MAC(granted_mac) being the FPMA, and the
+			 * second one(fcoe_mac) is used as destination address
+			 * for sending/receiving FCoE packets. FIP traffic is
+			 * sent using fip_mac. For regular switches, both
+			 * fip_mac and fcoe_mac would be the same.
+			 */
+			if (desc_cnt == 2)
+				memcpy(granted_mac,
+				       ((struct fip_mac_desc *)desc)->fd_mac,
+				       ETH_ALEN);
 
 			if (dlen != sizeof(struct fip_mac_desc))
 				goto len_err;
-			memcpy(granted_mac,
-			       ((struct fip_mac_desc *)desc)->fd_mac,
-			       ETH_ALEN);
+
+			if ((desc_cnt == 3) && (sel))
+				memcpy(sel->fcoe_mac,
+				       ((struct fip_mac_desc *)desc)->fd_mac,
+				       ETH_ALEN);
 			break;
 		case FIP_DT_FLOGI:
 		case FIP_DT_FDISC:
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 5a35a2a..cfdb55f 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -165,7 +165,8 @@ struct fcoe_ctlr {
  * @switch_name: WWN of switch from advertisement
  * @fabric_name: WWN of fabric from advertisement
  * @fc_map:	 FC_MAP value from advertisement
- * @fcf_mac:	 Ethernet address of the FCF
+ * @fcf_mac:	 Ethernet address of the FCF for FIP traffic
+ * @fcoe_mac:	 Ethernet address of the FCF for FCoE traffic
  * @vfid:	 virtual fabric ID
  * @pri:	 selection priority, smaller values are better
  * @flogi_sent:	 current FLOGI sent to this FCF
@@ -188,6 +189,7 @@ struct fcoe_fcf {
 	u32 fc_map;
 	u16 vfid;
 	u8 fcf_mac[ETH_ALEN];
+	u8 fcoe_mac[ETH_ALEN];
 
 	u8 pri;
 	u8 flogi_sent;

