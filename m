From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/17] libfcoe: Check for order and missing critical
	descriptors for FIP ELS requests
Date: Fri, 11 Jun 2010 16:44:36 -0700
Message-ID: <20100611234436.4616.72173.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab0FKXoh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:37 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

As per FC-BB-5 rev.2, section 7.8.7.1, strict ordering of FIP descriptors
is required for ELS requests. Also, look for missing and duplicate critical
descriptors.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index ce651ca..f009191 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -871,7 +871,8 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	size_t els_len = 0;
 	size_t rlen;
 	size_t dlen;
-	u32 dupl_desc = 0;
+	u32 desc_mask = 0;
+	u32 desc_cnt = 0;
 
 	fiph = (struct fip_header *)skb->data;
 	sub = fiph->fip_subcode;
@@ -884,20 +885,27 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 
 	desc = (struct fip_desc *)(fiph + 1);
 	while (rlen > 0) {
+		desc_cnt++;
 		dlen = desc->fip_dlen * FIP_BPW;
 		if (dlen < sizeof(*desc) || dlen > rlen)
 			goto drop;
 		/* Drop ELS if there are duplicate critical descriptors */
 		if (desc->fip_dtype < 32) {
-			if (dupl_desc & 1U << desc->fip_dtype) {
+			if (desc_mask & 1U << desc->fip_dtype) {
 				LIBFCOE_FIP_DBG(fip, "Duplicate Critical "
 						"Descriptors in FIP ELS\n");
 				goto drop;
 			}
-			dupl_desc |= (1 << desc->fip_dtype);
+			desc_mask |= (1 << desc->fip_dtype);
 		}
 		switch (desc->fip_dtype) {
 		case FIP_DT_MAC:
+			if (desc_cnt == 1) {
+				LIBFCOE_FIP_DBG(fip, "FIP descriptors "
+						"received out of order\n");
+				goto drop;
+			}
+
 			if (dlen != sizeof(struct fip_mac_desc))
 				goto len_err;
 			memcpy(granted_mac,
@@ -914,6 +922,11 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		case FIP_DT_FDISC:
 		case FIP_DT_LOGO:
 		case FIP_DT_ELP:
+			if (desc_cnt != 1) {
+				LIBFCOE_FIP_DBG(fip, "FIP descriptors "
+						"received out of order\n");
+				goto drop;
+			}
 			if (fh)
 				goto drop;
 			if (dlen < sizeof(*els) + sizeof(*fh) + 1)
@@ -929,6 +942,11 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
 				goto drop;
+			if (desc_cnt <= 2) {
+				LIBFCOE_FIP_DBG(fip, "FIP descriptors "
+						"received out of order\n");
+				goto drop;
+			}
 			break;
 		}
 		desc = (struct fip_desc *)((char *)desc + dlen);
@@ -944,6 +962,13 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	    els_op == ELS_LS_ACC && is_valid_ether_addr(granted_mac))
 		fip->flogi_oxid = FC_XID_UNKNOWN;
 
+	if ((desc_cnt == 0) || ((els_op != ELS_LS_RJT) &&
+	    (!(1U << FIP_DT_MAC & desc_mask)))) {
+		LIBFCOE_FIP_DBG(fip, "Missing critical descriptors "
+				"in FIP ELS\n");
+		goto drop;
+	}
+
 	/*
 	 * Convert skb into an fc_frame containing only the ELS.
 	 */

