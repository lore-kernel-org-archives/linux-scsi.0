From: Robert Love <robert.w.love@intel.com>
Subject: [Open-FCoE PATCH 5/6] libfc,
	fcoe: fixed locking issues with lport->lp_mutex around
	lport->link_status
Date: Wed, 21 Jan 2009 12:45:06 -0800
Message-ID: <20090121204505.2468.59130.stgit@fritz>
References: <20090121204444.2468.66245.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45732 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZAUUpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 15:45:06 -0500
In-Reply-To: <20090121204444.2468.66245.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

The fcoe_xmit could call fc_pause in case the pending skb queue len is larger
than FCOE_MAX_QUEUE_DEPTH, the fc_pause was trying to grab lport->lp_muex to
change lport->link_status and that had these issues :-

1. The fcoe_xmit was getting called with bh disabled, thus causing
"BUG: scheduling while atomic" when grabbing lport->lp_muex with bh disabled.

2. fc_linkup and fc_linkdown function calls lport_enter function with
lport->lp_mutex held and these enter function in turn calls fcoe_xmit to send
lport related FC frame, e.g. fc_linkup => fc_lport_enter_flogi to send flogi
req. In this case grabbing the same lport->lp_mutex again in fc_puase from
fcoe_xmit would cause deadlock.

The lport->lp_mutex was used for setting FC_PAUSE in fcoe_xmit path but
FC_PAUSE bit was not used anywhere beside just setting and clear this
bit in lport->link_status, instead used a separate field qfull in fc_lport
to eliminate need for lport->lp_mutex to track pending queue full condition
and in turn avoid above described two locking issues.

Also added check for lp->qfull in fc_fcp_lport_queue_ready to trigger
SCSI_MLQUEUE_HOST_BUSY when lp->qfull is set to prevent more scsi-ml cmds
while lp->qfull is set.

This patch eliminated FC_LINK_UP and FC_PAUSE and instead used dedicated
fields in fc_lport for this, this simplified all related conditional
code.

Also removed fc_pause and fc_unpause functions and instead used newly added
lport->qfull directly in fcoe.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe_sw.c   |    6 +++---
 drivers/scsi/fcoe/libfcoe.c   |   41 +++++++++++++++++------------------------
 drivers/scsi/libfc/fc_fcp.c   |    4 ++--
 drivers/scsi/libfc/fc_lport.c |   36 ++++++------------------------------
 include/scsi/libfc.h          |   12 ++----------
 5 files changed, 30 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index dc4cd5e..cf83675 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -116,7 +116,8 @@ static int fcoe_sw_lport_config(struct fc_lport *lp)
 {
 	int i = 0;
 
-	lp->link_status = 0;
+	lp->link_up = 0;
+	lp->qfull = 0;
 	lp->max_retry_count = 3;
 	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
 	lp->r_a_tov = 2 * 2 * 1000;
@@ -181,9 +182,8 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	if (fc_set_mfs(lp, mfs))
 		return -EINVAL;
 
-	lp->link_status = ~FC_PAUSE & ~FC_LINK_UP;
 	if (!fcoe_link_ok(lp))
-		lp->link_status |= FC_LINK_UP;
+		lp->link_up = 1;
 
 	/* offload features support */
 	if (fc->real_dev->features & NETIF_F_SG)
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index e419f48..2960710 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -504,7 +504,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	if (rc) {
 		fcoe_insert_wait_queue(lp, skb);
 		if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-			fc_pause(lp);
+			lp->qfull = 1;
 	}
 
 	return 0;
@@ -718,7 +718,7 @@ static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
  * fcoe_watchdog - fcoe timer callback
  * @vp:
  *
- * This checks the pending queue length for fcoe and put fcoe to be paused state
+ * This checks the pending queue length for fcoe and set lport qfull
  * if the FCOE_MAX_QUEUE_DEPTH is reached. This is done for all fc_lport on the
  * fcoe_hostlist.
  *
@@ -728,17 +728,17 @@ void fcoe_watchdog(ulong vp)
 {
 	struct fc_lport *lp;
 	struct fcoe_softc *fc;
-	int paused = 0;
+	int qfilled = 0;
 
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
 		lp = fc->lp;
 		if (lp) {
 			if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-				paused = 1;
+				qfilled = 1;
 			if (fcoe_check_wait_queue(lp) <	 FCOE_MAX_QUEUE_DEPTH) {
-				if (paused)
-					fc_unpause(lp);
+				if (qfilled)
+					lp->qfull = 0;
 			}
 		}
 	}
@@ -767,8 +767,7 @@ void fcoe_watchdog(ulong vp)
  **/
 static int fcoe_check_wait_queue(struct fc_lport *lp)
 {
-	int rc, unpause = 0;
-	int paused = 0;
+	int rc;
 	struct sk_buff *skb;
 	struct fcoe_softc *fc;
 
@@ -776,10 +775,10 @@ static int fcoe_check_wait_queue(struct fc_lport *lp)
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
 
 	/*
-	 * is this interface paused?
+	 * if interface pending queue full then set qfull in lport.
 	 */
 	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-		paused = 1;
+		lp->qfull = 1;
 	if (fc->fcoe_pending_queue.qlen) {
 		while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
 			spin_unlock_bh(&fc->fcoe_pending_queue.lock);
@@ -791,11 +790,9 @@ static int fcoe_check_wait_queue(struct fc_lport *lp)
 			spin_lock_bh(&fc->fcoe_pending_queue.lock);
 		}
 		if (fc->fcoe_pending_queue.qlen < FCOE_MAX_QUEUE_DEPTH)
-			unpause = 1;
+			lp->qfull = 0;
 	}
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-	if ((unpause) && (paused))
-		fc_unpause(lp);
 	return fc->fcoe_pending_queue.qlen;
 }
 
@@ -873,7 +870,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	struct net_device *real_dev = ptr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *stats;
-	u16 new_status;
+	u32 new_link_up;
 	u32 mfs;
 	int rc = NOTIFY_OK;
 
@@ -890,17 +887,15 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		goto out;
 	}
 
-	new_status = lp->link_status;
+	new_link_up = lp->link_up;
 	switch (event) {
 	case NETDEV_DOWN:
 	case NETDEV_GOING_DOWN:
-		new_status &= ~FC_LINK_UP;
+		new_link_up = 0;
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		new_status &= ~FC_LINK_UP;
-		if (!fcoe_link_ok(lp))
-			new_status |= FC_LINK_UP;
+		new_link_up = !fcoe_link_ok(lp);
 		break;
 	case NETDEV_CHANGEMTU:
 		mfs = fc->real_dev->mtu -
@@ -908,17 +903,15 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 			 sizeof(struct fcoe_crc_eof));
 		if (mfs >= FC_MIN_MAX_FRAME)
 			fc_set_mfs(lp, mfs);
-		new_status &= ~FC_LINK_UP;
-		if (!fcoe_link_ok(lp))
-			new_status |= FC_LINK_UP;
+		new_link_up = !fcoe_link_ok(lp);
 		break;
 	case NETDEV_REGISTER:
 		break;
 	default:
 		FC_DBG("unknown event %ld call", event);
 	}
-	if (lp->link_status != new_status) {
-		if ((new_status & FC_LINK_UP) == FC_LINK_UP)
+	if (lp->link_up != new_link_up) {
+		if (new_link_up)
 			fc_linkup(lp);
 		else {
 			stats = lp->dev_stats[smp_processor_id()];
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 404e63f..f440aac 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1621,7 +1621,7 @@ out:
 static inline int fc_fcp_lport_queue_ready(struct fc_lport *lp)
 {
 	/* lock ? */
-	return (lp->state == LPORT_ST_READY) && (lp->link_status & FC_LINK_UP);
+	return (lp->state == LPORT_ST_READY) && lp->link_up && !lp->qfull;
 }
 
 /**
@@ -1890,7 +1890,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	lp = shost_priv(sc_cmd->device->host);
 	if (lp->state != LPORT_ST_READY)
 		return rc;
-	else if (!(lp->link_status & FC_LINK_UP))
+	else if (!lp->link_up)
 		return rc;
 
 	spin_lock_irqsave(lp->host->host_lock, flags);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 5db223c..a6ab692 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -250,7 +250,7 @@ void fc_get_host_port_state(struct Scsi_Host *shost)
 {
 	struct fc_lport *lp = shost_priv(shost);
 
-	if ((lp->link_status & FC_LINK_UP) == FC_LINK_UP)
+	if (lp->link_up)
 		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
 	else
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
@@ -577,8 +577,8 @@ void fc_linkup(struct fc_lport *lport)
 		       fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
-	if ((lport->link_status & FC_LINK_UP) != FC_LINK_UP) {
-		lport->link_status |= FC_LINK_UP;
+	if (!lport->link_up) {
+		lport->link_up = 1;
 
 		if (lport->state == LPORT_ST_RESET)
 			fc_lport_enter_flogi(lport);
@@ -597,8 +597,8 @@ void fc_linkdown(struct fc_lport *lport)
 	FC_DEBUG_LPORT("Link is down for port (%6x)\n",
 		       fc_host_port_id(lport->host));
 
-	if ((lport->link_status & FC_LINK_UP) == FC_LINK_UP) {
-		lport->link_status &= ~(FC_LINK_UP);
+	if (lport->link_up) {
+		lport->link_up = 0;
 		fc_lport_enter_reset(lport);
 		lport->tt.fcp_cleanup(lport);
 	}
@@ -607,30 +607,6 @@ void fc_linkdown(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_linkdown);
 
 /**
- * fc_pause - Pause the flow of frames
- * @lport: The lport to be paused
- */
-void fc_pause(struct fc_lport *lport)
-{
-	mutex_lock(&lport->lp_mutex);
-	lport->link_status |= FC_PAUSE;
-	mutex_unlock(&lport->lp_mutex);
-}
-EXPORT_SYMBOL(fc_pause);
-
-/**
- * fc_unpause - Unpause the flow of frames
- * @lport: The lport to be unpaused
- */
-void fc_unpause(struct fc_lport *lport)
-{
-	mutex_lock(&lport->lp_mutex);
-	lport->link_status &= ~(FC_PAUSE);
-	mutex_unlock(&lport->lp_mutex);
-}
-EXPORT_SYMBOL(fc_unpause);
-
-/**
  * fc_fabric_logoff - Logout of the fabric
  * @lport:	      fc_lport pointer to logoff the fabric
  *
@@ -977,7 +953,7 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 	fc_host_fabric_name(lport->host) = 0;
 	fc_host_port_id(lport->host) = 0;
 
-	if ((lport->link_status & FC_LINK_UP) == FC_LINK_UP)
+	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
 }
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 042f4ad..b9e6c1c 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -68,9 +68,6 @@
 /*
  * FC HBA status
  */
-#define FC_PAUSE		    (1 << 1)
-#define FC_LINK_UP		    (1 << 0)
-
 enum fc_lport_state {
 	LPORT_ST_NONE = 0,
 	LPORT_ST_FLOGI,
@@ -603,7 +600,8 @@ struct fc_lport {
 
 	/* Operational Information */
 	struct libfc_function_template tt;
-	u16			link_status;
+	u8			link_up;
+	u8			qfull;
 	enum fc_lport_state	state;
 	unsigned long		boot_time;
 
@@ -704,12 +702,6 @@ void fc_linkup(struct fc_lport *);
 void fc_linkdown(struct fc_lport *);
 
 /*
- * Pause and unpause traffic.
- */
-void fc_pause(struct fc_lport *);
-void fc_unpause(struct fc_lport *);
-
-/*
  * Configure the local port.
  */
 int fc_lport_config(struct fc_lport *);

