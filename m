From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/8] libfcoe: fip: fix non-FIP-mode FLOGI state after reset.
Date: Wed, 06 May 2009 10:52:12 -0700
Message-ID: <20090506175212.26695.71266.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63157 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbZEFRwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:13 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When a reset is sent using fcoeadm on a non-FIP mode NIC,
there's no link flap, so the fcoe_ctlr stays in non-FIP mode.

In that case, FIP wasn't setting the flogi_oxid or map_dest flag,
causing the FLOGI to be sent with the both wrong source MAC and
the wrong destination MAC address, causing it to fail.

This leads to a non-functioning HBA until a link flap or
instance delete/create.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---

 drivers/scsi/fcoe/libfcoe.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 62ba0f3..a7ecafb 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -447,14 +447,10 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	u16 old_xid;
 	u8 op;
 
-	if (fip->state == FIP_ST_NON_FIP)
-		return 0;
-
 	fh = (struct fc_frame_header *)skb->data;
 	op = *(u8 *)(fh + 1);
 
-	switch (op) {
-	case ELS_FLOGI:
+	if (op == ELS_FLOGI) {
 		old_xid = fip->flogi_oxid;
 		fip->flogi_oxid = ntohs(fh->fh_ox_id);
 		if (fip->state == FIP_ST_AUTO) {
@@ -466,6 +462,15 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			fip->map_dest = 1;
 			return 0;
 		}
+		if (fip->state == FIP_ST_NON_FIP)
+			fip->map_dest = 1;
+	}
+
+	if (fip->state == FIP_ST_NON_FIP)
+		return 0;
+
+	switch (op) {
+	case ELS_FLOGI:
 		op = FIP_DT_FLOGI;
 		break;
 	case ELS_FDISC:

