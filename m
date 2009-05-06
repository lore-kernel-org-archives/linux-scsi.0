From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/8] fcoe: use ETH_P_FIP for skb->protocol of FIP frames
Date: Wed, 06 May 2009 10:52:18 -0700
Message-ID: <20090506175218.26695.65639.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZEFRwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:18 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>

From: Chris Leech <christopher.leech@intel.com>

FIP frames should leave the fcoe layer with skb->protocol set to
ETH_P_FIP, not ETH_P_802_3.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index a7ecafb..9294118 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -213,7 +213,7 @@ static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
 	sol->desc.size.fd_size = htons(fcoe_size);
 
 	skb_put(skb, sizeof(*sol));
-	skb->protocol = htons(ETH_P_802_3);
+	skb->protocol = htons(ETH_P_FIP);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	fip->send(fip, skb);
@@ -365,7 +365,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip, int ports, u8 *sa)
 	}
 
 	skb_put(skb, len);
-	skb->protocol = htons(ETH_P_802_3);
+	skb->protocol = htons(ETH_P_FIP);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	fip->send(fip, skb);
@@ -424,7 +424,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip,
 	if (dtype != ELS_FLOGI)
 		memcpy(mac->fd_mac, fip->data_src_addr, ETH_ALEN);
 
-	skb->protocol = htons(ETH_P_802_3);
+	skb->protocol = htons(ETH_P_FIP);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	return 0;

