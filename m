From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/28] libfcoe: Fix FIP ELS encapsulation details for FLOGI
	responses
Date: Tue, 20 Jul 2010 15:20:35 -0700
Message-ID: <20100720222035.17116.66903.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46553 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795Ab0GTWUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:36 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When sending a FLOGI LS_ACC, which we only do in point-to-multipoint
mode, the MAC descriptor should have the granted MAC set to
0x0efd00 || D_ID.

When sending an LS_RJT, there should be no MAC descriptor.

When sending either an LS_ACC or LS_RJT, the subcode should indicate
an reply, not a request.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 79df78f..4865e81 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -469,11 +469,15 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
 		struct fip_header fip;
 		struct fip_encaps encaps;
 	} __attribute__((packed)) *cap;
+	struct fc_frame_header *fh;
 	struct fip_mac_desc *mac;
 	struct fcoe_fcf *fcf;
 	size_t dlen;
 	u16 fip_flags;
+	u8 op;
 
+	fh = (struct fc_frame_header *)skb->data;
+	op = *(u8 *)(fh + 1);
 	dlen = sizeof(struct fip_encaps) + skb->len;	/* len before push */
 	cap = (struct fip_encaps_head *)skb_push(skb, sizeof(*cap));
 	memset(cap, 0, sizeof(*cap));
@@ -481,6 +485,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	if (lport->point_to_multipoint) {
 		if (fcoe_ctlr_vn_lookup(fip, d_id, cap->eth.h_dest))
 			return -ENODEV;
+		fip_flags = 0;
 	} else {
 		fcf = fip->sel_fcf;
 		if (!fcf)
@@ -497,26 +502,35 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
 
 	cap->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
 	cap->fip.fip_op = htons(FIP_OP_LS);
-	cap->fip.fip_subcode = FIP_SC_REQ;
-	cap->fip.fip_dl_len = htons((dlen + sizeof(*mac)) / FIP_BPW);
+	if (op == ELS_LS_ACC || op == ELS_LS_RJT)
+		cap->fip.fip_subcode = FIP_SC_REP;
+	else
+		cap->fip.fip_subcode = FIP_SC_REQ;
 	cap->fip.fip_flags = htons(fip_flags);
 
 	cap->encaps.fd_desc.fip_dtype = dtype;
 	cap->encaps.fd_desc.fip_dlen = dlen / FIP_BPW;
 
-	mac = (struct fip_mac_desc *)skb_put(skb, sizeof(*mac));
-	memset(mac, 0, sizeof(*mac));
-	mac->fd_desc.fip_dtype = FIP_DT_MAC;
-	mac->fd_desc.fip_dlen = sizeof(*mac) / FIP_BPW;
-	if (dtype != FIP_DT_FLOGI && dtype != FIP_DT_FDISC) {
-		memcpy(mac->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
-	} else if (fip_flags & FIP_FL_SPMA) {
-		LIBFCOE_FIP_DBG(fip, "FLOGI/FDISC sent with SPMA\n");
-		memcpy(mac->fd_mac, fip->ctl_src_addr, ETH_ALEN);
-	} else {
-		LIBFCOE_FIP_DBG(fip, "FLOGI/FDISC sent with FPMA\n");
-		/* FPMA only FLOGI must leave the MAC desc set to all 0s */
+	if (op != ELS_LS_RJT) {
+		dlen += sizeof(*mac);
+		mac = (struct fip_mac_desc *)skb_put(skb, sizeof(*mac));
+		memset(mac, 0, sizeof(*mac));
+		mac->fd_desc.fip_dtype = FIP_DT_MAC;
+		mac->fd_desc.fip_dlen = sizeof(*mac) / FIP_BPW;
+		if (dtype != FIP_DT_FLOGI && dtype != FIP_DT_FDISC) {
+			memcpy(mac->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
+		} else if (fip->mode == FIP_MODE_VN2VN) {
+			hton24(mac->fd_mac, FIP_VN_FC_MAP);
+			hton24(mac->fd_mac + 3, fip->port_id);
+		} else if (fip_flags & FIP_FL_SPMA) {
+			LIBFCOE_FIP_DBG(fip, "FLOGI/FDISC sent with SPMA\n");
+			memcpy(mac->fd_mac, fip->ctl_src_addr, ETH_ALEN);
+		} else {
+			LIBFCOE_FIP_DBG(fip, "FLOGI/FDISC sent with FPMA\n");
+			/* FPMA only FLOGI.  Must leave the MAC desc zeroed. */
+		}
 	}
+	cap->fip.fip_dl_len = htons(dlen / FIP_BPW);
 
 	skb->protocol = htons(ETH_P_FIP);
 	skb_reset_mac_header(skb);

