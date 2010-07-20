From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/28] libfcoe: add state change debugging
Date: Tue, 20 Jul 2010 15:20:24 -0700
Message-ID: <20100720222024.17116.37796.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab0GTWUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:36 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Enhancement: add debug messages at all state transitions.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   48 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 76056e4..11f3db5 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -80,6 +80,40 @@ do {							\
 			      printk(KERN_INFO "host%d: fip: " fmt, 	\
 				     (fip)->lp->host->host_no, ##args);)
 
+static const char *fcoe_ctlr_states[] = {
+	[FIP_ST_DISABLED] =	"DISABLED",
+	[FIP_ST_LINK_WAIT] =	"LINK_WAIT",
+	[FIP_ST_AUTO] =		"AUTO",
+	[FIP_ST_NON_FIP] =	"NON_FIP",
+	[FIP_ST_ENABLED] =	"ENABLED",
+};
+
+static const char *fcoe_ctlr_state(enum fip_state state)
+{
+	const char *cp = "unknown";
+
+	if (state < ARRAY_SIZE(fcoe_ctlr_states))
+		cp = fcoe_ctlr_states[state];
+	if (!cp)
+		cp = "unknown";
+	return cp;
+}
+
+/**
+ * fcoe_ctlr_set_state() - Set and do debug printing for the new FIP state.
+ * @fip: The FCoE controller
+ * @state: The new state
+ */
+static void fcoe_ctlr_set_state(struct fcoe_ctlr *fip, enum fip_state state)
+{
+	if (state == fip->state)
+		return;
+	if (fip->lp)
+		LIBFCOE_FIP_DBG(fip, "state %s -> %s\n",
+			fcoe_ctlr_state(fip->state), fcoe_ctlr_state(state));
+	fip->state = state;
+}
+
 /**
  * fcoe_ctlr_mtu_valid() - Check if a FCF's MTU is valid
  * @fcf: The FCF to check
@@ -110,7 +144,7 @@ static inline int fcoe_ctlr_fcf_usable(struct fcoe_fcf *fcf)
  */
 void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
 {
-	fip->state = FIP_ST_LINK_WAIT;
+	fcoe_ctlr_set_state(fip, FIP_ST_LINK_WAIT);
 	fip->mode = mode;
 	INIT_LIST_HEAD(&fip->fcfs);
 	mutex_init(&fip->ctlr_mutex);
@@ -160,7 +194,7 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 	skb_queue_purge(&fip->fip_recv_list);
 
 	mutex_lock(&fip->ctlr_mutex);
-	fip->state = FIP_ST_DISABLED;
+	fcoe_ctlr_set_state(fip, FIP_ST_DISABLED);
 	fcoe_ctlr_reset_fcfs(fip);
 	mutex_unlock(&fip->ctlr_mutex);
 	del_timer_sync(&fip->timer);
@@ -260,7 +294,7 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 		mutex_unlock(&fip->ctlr_mutex);
 		fc_linkup(fip->lp);
 	} else if (fip->state == FIP_ST_LINK_WAIT) {
-		fip->state = fip->mode;
+		fcoe_ctlr_set_state(fip, fip->mode);
 		mutex_unlock(&fip->ctlr_mutex);
 		if (fip->state == FIP_ST_AUTO)
 			LIBFCOE_FIP_DBG(fip, "%s", "setting AUTO mode.\n");
@@ -303,7 +337,7 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 	mutex_lock(&fip->ctlr_mutex);
 	fcoe_ctlr_reset(fip);
 	link_dropped = fip->state != FIP_ST_LINK_WAIT;
-	fip->state = FIP_ST_LINK_WAIT;
+	fcoe_ctlr_set_state(fip, FIP_ST_LINK_WAIT);
 	mutex_unlock(&fip->ctlr_mutex);
 
 	if (link_dropped)
@@ -1170,7 +1204,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	state = fip->state;
 	if (state == FIP_ST_AUTO) {
 		fip->map_dest = 0;
-		fip->state = FIP_ST_ENABLED;
+		fcoe_ctlr_set_state(fip, FIP_ST_ENABLED);
 		state = FIP_ST_ENABLED;
 		LIBFCOE_FIP_DBG(fip, "Using FIP mode\n");
 	}
@@ -1401,7 +1435,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			mutex_unlock(&fip->ctlr_mutex);
 			return -EINVAL;
 		}
-		fip->state = FIP_ST_NON_FIP;
+		fcoe_ctlr_set_state(fip, FIP_ST_NON_FIP);
 		LIBFCOE_FIP_DBG(fip,
 				"received FLOGI LS_ACC using non-FIP mode\n");
 
@@ -1431,7 +1465,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			if (fip->state == FIP_ST_AUTO)
 				LIBFCOE_FIP_DBG(fip, "received non-FIP FLOGI. "
 						"Setting non-FIP mode\n");
-			fip->state = FIP_ST_NON_FIP;
+			fcoe_ctlr_set_state(fip, FIP_ST_NON_FIP);
 		}
 		mutex_unlock(&fip->ctlr_mutex);
 	}

