From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 24/27] libfcoe: add debug message for FCF destination MAC
Date: Tue, 30 Nov 2010 16:20:02 -0800
Message-ID: <20101201002002.18369.64833.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0LAAUP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:20:15 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When multiple FCFs to the same fabric exist, the debug messages
all look alike.   Change the message to include the MAC address.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index c90622c..dcccb0b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -979,11 +979,9 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
 	fcf->time = jiffies;
-	if (!found) {
-		LIBFCOE_FIP_DBG(fip, "New FCF for fab %16.16llx "
-				"map %x val %d\n",
-				fcf->fabric_name, fcf->fc_map, mtu_valid);
-	}
+	if (!found)
+		LIBFCOE_FIP_DBG(fip, "New FCF fab %16.16llx mac %pM\n",
+				fcf->fabric_name, fcf->fcf_mac);
 
 	/*
 	 * If this advertisement is not solicited and our max receive size
@@ -1405,10 +1403,12 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 	first = list_first_entry(&fip->fcfs, struct fcoe_fcf, list);
 
 	list_for_each_entry(fcf, &fip->fcfs, list) {
-		LIBFCOE_FIP_DBG(fip, "consider FCF for fab %16.16llx "
-				"VFID %d map %x val %d\n",
-				fcf->fabric_name, fcf->vfid,
-				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf));
+		LIBFCOE_FIP_DBG(fip, "consider FCF fab %16.16llx "
+				"VFID %d mac %pM map %x val %d "
+				"sent %u pri %u\n",
+				fcf->fabric_name, fcf->vfid, fcf->fcf_mac,
+				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf),
+				fcf->flogi_sent, fcf->pri);
 		if (fcf->fabric_name != first->fabric_name ||
 		    fcf->vfid != first->vfid ||
 		    fcf->fc_map != first->fc_map) {
@@ -1432,6 +1432,7 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 	}
 	fip->sel_fcf = best;
 	if (best) {
+		LIBFCOE_FIP_DBG(fip, "using FCF mac %pM\n", best->fcf_mac);
 		fip->port_ka_time = jiffies +
 			msecs_to_jiffies(FIP_VN_KA_PERIOD);
 		fip->ctlr_ka_time = jiffies + best->fka_period;

