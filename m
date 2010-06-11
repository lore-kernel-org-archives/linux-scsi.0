From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/17] libfcoe: Handle duplicate critical descriptors
Date: Fri, 11 Jun 2010 16:44:25 -0700
Message-ID: <20100611234425.4616.61054.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab0FKXo0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:26 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

As per FC-BB-5 rev 2, section 7.8.6.2, malformed FIP frame shall be
discarded. Drop discovery adv, ELS and CLV's with duplicate critical
descriptors.

[Resending after incorporating Joe's review comments]

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 27c21ca..db7185c 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -640,6 +640,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 	unsigned long t;
 	size_t rlen;
 	size_t dlen;
+	u32 desc_mask;
 
 	memset(fcf, 0, sizeof(*fcf));
 	fcf->fka_period = msecs_to_jiffies(FCOE_CTLR_DEF_FKA);
@@ -647,6 +648,12 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 	fiph = (struct fip_header *)skb->data;
 	fcf->flags = ntohs(fiph->fip_flags);
 
+	/*
+	 * mask of required descriptors. validating each one clears its bit.
+	 */
+	desc_mask = BIT(FIP_DT_PRI) | BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME) |
+			BIT(FIP_DT_FAB) | BIT(FIP_DT_FKA);
+
 	rlen = ntohs(fiph->fip_dl_len) * 4;
 	if (rlen + sizeof(*fiph) > skb->len)
 		return -EINVAL;
@@ -656,11 +663,19 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 		dlen = desc->fip_dlen * FIP_BPW;
 		if (dlen < sizeof(*desc) || dlen > rlen)
 			return -EINVAL;
+		/* Drop Adv if there are duplicate critical descriptors */
+		if ((desc->fip_dtype < 32) &&
+		    !(desc_mask & 1U << desc->fip_dtype)) {
+			LIBFCOE_FIP_DBG(fip, "Duplicate Critical "
+					"Descriptors in FIP adv\n");
+			return -EINVAL;
+		}
 		switch (desc->fip_dtype) {
 		case FIP_DT_PRI:
 			if (dlen != sizeof(struct fip_pri_desc))
 				goto len_err;
 			fcf->pri = ((struct fip_pri_desc *)desc)->fd_pri;
+			desc_mask &= ~BIT(FIP_DT_PRI);
 			break;
 		case FIP_DT_MAC:
 			if (dlen != sizeof(struct fip_mac_desc))
@@ -673,12 +688,14 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 						"in FIP adv\n");
 				return -EINVAL;
 			}
+			desc_mask &= ~BIT(FIP_DT_MAC);
 			break;
 		case FIP_DT_NAME:
 			if (dlen != sizeof(struct fip_wwn_desc))
 				goto len_err;
 			wwn = (struct fip_wwn_desc *)desc;
 			fcf->switch_name = get_unaligned_be64(&wwn->fd_wwn);
+			desc_mask &= ~BIT(FIP_DT_NAME);
 			break;
 		case FIP_DT_FAB:
 			if (dlen != sizeof(struct fip_fab_desc))
@@ -687,6 +704,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 			fcf->fabric_name = get_unaligned_be64(&fab->fd_wwn);
 			fcf->vfid = ntohs(fab->fd_vfid);
 			fcf->fc_map = ntoh24(fab->fd_map);
+			desc_mask &= ~BIT(FIP_DT_FAB);
 			break;
 		case FIP_DT_FKA:
 			if (dlen != sizeof(struct fip_fka_desc))
@@ -697,6 +715,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 			t = ntohl(fka->fd_fka_period);
 			if (t >= FCOE_CTLR_MIN_FKA)
 				fcf->fka_period = msecs_to_jiffies(t);
+			desc_mask &= ~BIT(FIP_DT_FKA);
 			break;
 		case FIP_DT_MAP_OUI:
 		case FIP_DT_FCOE_SIZE:
@@ -719,6 +738,11 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 		return -EINVAL;
 	if (!fcf->switch_name || !fcf->fabric_name)
 		return -EINVAL;
+	if (desc_mask) {
+		LIBFCOE_FIP_DBG(fip, "adv missing descriptors mask %x\n",
+				desc_mask);
+		return -EINVAL;
+	}
 	return 0;
 
 len_err:
@@ -847,6 +871,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	size_t els_len = 0;
 	size_t rlen;
 	size_t dlen;
+	u32 dupl_desc = 0;
 
 	fiph = (struct fip_header *)skb->data;
 	sub = fiph->fip_subcode;
@@ -862,6 +887,15 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		dlen = desc->fip_dlen * FIP_BPW;
 		if (dlen < sizeof(*desc) || dlen > rlen)
 			goto drop;
+		/* Drop ELS if there are duplicate critical descriptors */
+		if (desc->fip_dtype < 32) {
+			if (dupl_desc & 1U << desc->fip_dtype) {
+				LIBFCOE_FIP_DBG(fip, "Duplicate Critical "
+						"Descriptors in FIP ELS\n");
+				goto drop;
+			}
+			dupl_desc |= (1 << desc->fip_dtype);
+		}
 		switch (desc->fip_dtype) {
 		case FIP_DT_MAC:
 			if (dlen != sizeof(struct fip_mac_desc))
@@ -973,6 +1007,13 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		dlen = desc->fip_dlen * FIP_BPW;
 		if (dlen > rlen)
 			return;
+		/* Drop CVL if there are duplicate critical descriptors */
+		if ((desc->fip_dtype < 32) &&
+		    !(desc_mask & 1U << desc->fip_dtype)) {
+			LIBFCOE_FIP_DBG(fip, "Duplicate Critical "
+					"Descriptors in FIP CVL\n");
+			return;
+		}
 		switch (desc->fip_dtype) {
 		case FIP_DT_MAC:
 			mp = (struct fip_mac_desc *)desc;

