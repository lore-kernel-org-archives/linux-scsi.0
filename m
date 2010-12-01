From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/27] libfcoe: update FIP FCF announcements
Date: Tue, 30 Nov 2010 16:19:40 -0800
Message-ID: <20101201001940.18369.73487.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25554 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0LAATl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:41 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Move the announcement code to a separate function for reuse in
a forthcoming patch.

For messages regarding FCF timeout and selection, use the
previously-announced FCF MAC address (dest_addr) in the fcoe_ctlr struct.
Only print (announce) the FCF if it is new.   Print MAC for
timed-out or deselected FCFs.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 58ad3c7..26381f0 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -231,6 +231,33 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 EXPORT_SYMBOL(fcoe_ctlr_destroy);
 
 /**
+ * fcoe_ctlr_announce() - announce new selection
+ * @fip: The FCoE controller
+ *
+ * Also sets the destination MAC for FCoE and control packets
+ */
+static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
+{
+	struct fcoe_fcf *sel = fip->sel_fcf;
+
+	if (sel && !compare_ether_addr(sel->fcf_mac, fip->dest_addr))
+		return;
+	if (!is_zero_ether_addr(fip->dest_addr)) {
+		printk(KERN_NOTICE "libfcoe: host%d: "
+		       "FIP Fibre-Channel Forwarder MAC %pM deselected\n",
+		       fip->lp->host->host_no, fip->dest_addr);
+		memset(fip->dest_addr, 0, ETH_ALEN);
+	}
+	if (sel) {
+		printk(KERN_INFO "libfcoe: host%d: FIP selected "
+		       "Fibre-Channel Forwarder MAC %pM\n",
+		       fip->lp->host->host_no, sel->fcf_mac);
+		memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
+		fip->map_dest = 0;
+	}
+}
+
+/**
  * fcoe_ctlr_fcoe_size() - Return the maximum FCoE size required for VN_Port
  * @fip: The FCoE controller to get the maximum FCoE size from
  *
@@ -1420,24 +1447,15 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 
 	if (sel != fcf) {
 		fcf = sel;		/* the old FCF may have been freed */
+		fcoe_ctlr_announce(fip);
 		if (sel) {
-			printk(KERN_INFO "libfcoe: host%d: FIP selected "
-			       "Fibre-Channel Forwarder MAC %pM\n",
-			       fip->lp->host->host_no, sel->fcf_mac);
-			memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
-			fip->map_dest = 0;
 			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
 			fip->ctlr_ka_time = jiffies + sel->fka_period;
 			if (time_after(next_timer, fip->ctlr_ka_time))
 				next_timer = fip->ctlr_ka_time;
-		} else {
-			printk(KERN_NOTICE "libfcoe: host%d: "
-			       "FIP Fibre-Channel Forwarder timed out.	"
-			       "Starting FCF discovery.\n",
-			       fip->lp->host->host_no);
+		} else
 			reset = 1;
-		}
 	}
 
 	if (sel && !sel->fd_flags) {

