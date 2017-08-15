From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 3/6] qedf: Corrent VLAN tag insertion in fallback VLAN case.
Date: Tue, 15 Aug 2017 10:08:18 -0700
Message-ID: <20170815170821.20806-4-chad.dupuis@cavium.com>
References: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:46160
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751702AbdHORI6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:08:58 -0400
In-Reply-To: <20170815170821.20806-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Currently in the driver the qedf_ctx attribute vlan_hw_insert is used to
which whether to insert a VLAN tag in FIP frames (except for FIP VLAN
request which is explicitly sent out untagged at least from the driver's
point of view).

When we receive a FIP VLAN response, we set qedf->vlan_hw_insert to 0 which
makes the qedf_fip_send function insert the VLAN.  However when we exhaust
our FIP VLAN retries, we do not set qedf->vlan_hw_insert to 0 which means
that the driver will not tag the FIP frame with the correct VLAN ID.  The
result that was observed on the wire is that some entity either int he LL2
or L2 firmware is adding a NULL VLAN tag which can cause FIP solicitation
to fail.

The offload FCoE frame function, qedf_xmit, does not use the vlan_hw_insert
attribute to decide whether to tag frames with the FIP/FCoE VLAN.  Instead
it unilaterially tags the offload frames with the VLAN ID stored in
qedf->vlan_id. This is the correct behavior so the driver can guarantee
that non-offload FIP frames go out with the correct VLAN ID.

Also use the Linux network layer helpers instead of doing the VLAN insert
manually.

Also fix setting the fallback VLAN so that it used the module parameter and
is not hardcoded to 1002 (though 1002 is the default).

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf.h      |  1 -
 drivers/scsi/qedf/qedf_fip.c  | 18 +++++++-----------
 drivers/scsi/qedf/qedf_main.c | 12 ++++++++----
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index e05ec331557b..9bf7b227e69a 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -300,7 +300,6 @@ struct qedf_ctx {
 #define QEDF_FALLBACK_VLAN	1002
 #define QEDF_DEFAULT_PRIO	3
 	int vlan_id;
-	uint vlan_hw_insert:1;
 	struct qed_dev *cdev;
 	struct qed_dev_fcoe_info dev_info;
 	struct qed_int_info int_info;
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index 28ce0f7ffc7b..773558fc0697 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -108,7 +108,6 @@ void qedf_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct qedf_ctx *qedf = container_of(fip, struct qedf_ctx, ctlr);
 	struct ethhdr *eth_hdr;
-	struct vlan_ethhdr *vlan_hdr;
 	struct fip_header *fiph;
 	u16 op, vlan_tci = 0;
 	u8 sub;
@@ -124,16 +123,14 @@ void qedf_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	op = ntohs(fiph->fip_op);
 	sub = fiph->fip_subcode;
 
-	if (!qedf->vlan_hw_insert) {
-		vlan_hdr = skb_push(skb, sizeof(*vlan_hdr) - sizeof(*eth_hdr));
-		memcpy(vlan_hdr, eth_hdr, 2 * ETH_ALEN);
-		vlan_hdr->h_vlan_proto = htons(ETH_P_8021Q);
-		vlan_hdr->h_vlan_encapsulated_proto = eth_hdr->h_proto;
-		vlan_hdr->h_vlan_TCI = vlan_tci =  htons(qedf->vlan_id);
-	}
+	/*
+	 * Add VLAN tag to non-offload FIP frame based on current stored VLAN
+	 * for FIP/FCoE traffic.
+	 */
+	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), qedf->vlan_id);
 
-	/* Update eth_hdr since we added a VLAN tag */
-	eth_hdr = (struct ethhdr *)skb_mac_header(skb);
+	/* Get VLAN ID from skb for printing purposes */
+	__vlan_hwaccel_get_tag(skb, &vlan_tci);
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2, "FIP frame send: "
 	    "dest=%pM op=%x sub=%x vlan=%04x.", eth_hdr->h_dest, op, sub,
@@ -174,7 +171,6 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 	/* Handle FIP VLAN resp in the driver */
 	if (op == FIP_OP_VLAN && sub == FIP_SC_VL_NOTE) {
 		qedf_fcoe_process_vlan_resp(qedf, skb);
-		qedf->vlan_hw_insert = 0;
 		kfree_skb(skb);
 	} else if (op == FIP_OP_CTRL && sub == FIP_SC_CLR_VLINK) {
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "Clear virtual "
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 1df80aa03da1..0520dd1be749 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -164,7 +164,7 @@ static void qedf_handle_link_update(struct work_struct *work)
 		QEDF_WARN(&(qedf->dbg_ctx), "Did not receive FIP VLAN "
 			   "response, falling back to default VLAN %d.\n",
 			   qedf_fallback_vlan);
-		qedf_set_vlan_id(qedf, QEDF_FALLBACK_VLAN);
+		qedf_set_vlan_id(qedf, qedf_fallback_vlan);
 
 		/*
 		 * Zero out data_src_addr so we'll update it with the new
@@ -361,8 +361,9 @@ static void qedf_link_recovery(struct work_struct *work)
 	/* Since the link when down and up to verify which vlan we're on */
 	qedf->fipvlan_retries = qedf_fipvlan_retries;
 	rc = qedf_initiate_fipvlan_req(qedf);
+	/* If getting the VLAN fails, set the VLAN to the fallback one */
 	if (!rc)
-		return;
+		qedf_set_vlan_id(qedf, qedf_fallback_vlan);
 
 	/*
 	 * We need to wait for an FCF to be selected due to the
@@ -964,6 +965,10 @@ static int qedf_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	skb->mac_len = elen;
 	skb->protocol = htons(ETH_P_FCOE);
 
+	/*
+	 * Add VLAN tag to non-offload FCoE frame based on current stored VLAN
+	 * for FIP/FCoE traffic.
+	 */
 	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), qedf->vlan_id);
 
 	/* fill up mac and fcoe headers */
@@ -3172,8 +3177,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 	set_bit(QEDF_LL2_STARTED, &qedf->flags);
 
-	/* hw will be insterting vlan tag*/
-	qedf->vlan_hw_insert = 1;
+	/* Set initial FIP/FCoE VLAN to NULL */
 	qedf->vlan_id = 0;
 
 	/*
-- 
2.12.3
