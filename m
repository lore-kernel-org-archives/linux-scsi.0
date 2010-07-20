From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/28] libfcoe: convert FIP to lock with mutex instead of spin
	lock
Date: Tue, 20 Jul 2010 15:19:47 -0700
Message-ID: <20100720221947.17116.51567.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2166 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab0GTWTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:48 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

It turns out most of the FIP work is now done from worker threads
or process context now, so there's no need to use a spin lock.

Change to use mutex instead of spin lock and delayed_work instead
of a timer.

This will make it nicer for the VN_port to VN_port feature that
will interact more with the libfc layers requiring that
spinlocks not be held.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |  116 ++++++++++++++++++++-----------------------
 include/scsi/libfcoe.h      |    9 +--
 2 files changed, 57 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f009191..e510888 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -113,7 +113,7 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip)
 	fip->state = FIP_ST_LINK_WAIT;
 	fip->mode = FIP_ST_AUTO;
 	INIT_LIST_HEAD(&fip->fcfs);
-	spin_lock_init(&fip->lock);
+	mutex_init(&fip->ctlr_mutex);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
 	setup_timer(&fip->timer, fcoe_ctlr_timeout, (unsigned long)fip);
 	INIT_WORK(&fip->timer_work, fcoe_ctlr_timer_work);
@@ -159,10 +159,10 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 	cancel_work_sync(&fip->recv_work);
 	skb_queue_purge(&fip->fip_recv_list);
 
-	spin_lock_bh(&fip->lock);
+	mutex_lock(&fip->ctlr_mutex);
 	fip->state = FIP_ST_DISABLED;
 	fcoe_ctlr_reset_fcfs(fip);
-	spin_unlock_bh(&fip->lock);
+	mutex_unlock(&fip->ctlr_mutex);
 	del_timer_sync(&fip->timer);
 	cancel_work_sync(&fip->timer_work);
 }
@@ -255,19 +255,19 @@ static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
  */
 void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 {
-	spin_lock_bh(&fip->lock);
+	mutex_lock(&fip->ctlr_mutex);
 	if (fip->state == FIP_ST_NON_FIP || fip->state == FIP_ST_AUTO) {
-		spin_unlock_bh(&fip->lock);
+		mutex_unlock(&fip->ctlr_mutex);
 		fc_linkup(fip->lp);
 	} else if (fip->state == FIP_ST_LINK_WAIT) {
 		fip->state = fip->mode;
-		spin_unlock_bh(&fip->lock);
+		mutex_unlock(&fip->ctlr_mutex);
 		if (fip->state == FIP_ST_AUTO)
 			LIBFCOE_FIP_DBG(fip, "%s", "setting AUTO mode.\n");
 		fc_linkup(fip->lp);
 		fcoe_ctlr_solicit(fip, NULL);
 	} else
-		spin_unlock_bh(&fip->lock);
+		mutex_unlock(&fip->ctlr_mutex);
 }
 EXPORT_SYMBOL(fcoe_ctlr_link_up);
 
@@ -300,11 +300,11 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 	int link_dropped;
 
 	LIBFCOE_FIP_DBG(fip, "link down.\n");
-	spin_lock_bh(&fip->lock);
+	mutex_lock(&fip->ctlr_mutex);
 	fcoe_ctlr_reset(fip);
 	link_dropped = fip->state != FIP_ST_LINK_WAIT;
 	fip->state = FIP_ST_LINK_WAIT;
-	spin_unlock_bh(&fip->lock);
+	mutex_unlock(&fip->ctlr_mutex);
 
 	if (link_dropped)
 		fc_linkdown(fip->lp);
@@ -577,12 +577,12 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 	unsigned long sel_time = 0;
 	struct fcoe_dev_stats *stats;
 
+	stats = per_cpu_ptr(fip->lp->dev_stats, get_cpu());
+
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
 		deadline = fcf->time + fcf->fka_period + fcf->fka_period / 2;
 		if (fip->sel_fcf == fcf) {
 			if (time_after(jiffies, deadline)) {
-				stats = per_cpu_ptr(fip->lp->dev_stats,
-						    smp_processor_id());
 				stats->MissDiscAdvCount++;
 				printk(KERN_INFO "libfcoe: host%d: "
 				       "Missing Discovery Advertisement "
@@ -601,8 +601,6 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 			WARN_ON(!fip->fcf_count);
 			fip->fcf_count--;
 			kfree(fcf);
-			stats = per_cpu_ptr(fip->lp->dev_stats,
-					    smp_processor_id());
 			stats->VLinkFailureCount++;
 		} else {
 			if (time_after(next_timer, deadline))
@@ -612,6 +610,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 				sel_time = fcf->time;
 		}
 	}
+	put_cpu();
 	if (sel_time && !fip->sel_fcf && !fip->sel_time) {
 		sel_time += msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		fip->sel_time = sel_time;
@@ -768,7 +767,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	if (fcoe_ctlr_parse_adv(fip, skb, &new))
 		return;
 
-	spin_lock_bh(&fip->lock);
+	mutex_lock(&fip->ctlr_mutex);
 	first = list_empty(&fip->fcfs);
 	found = NULL;
 	list_for_each_entry(fcf, &fip->fcfs, list) {
@@ -847,7 +846,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			mod_timer(&fip->timer, fip->sel_time);
 	}
 out:
-	spin_unlock_bh(&fip->lock);
+	mutex_unlock(&fip->ctlr_mutex);
 }
 
 /**
@@ -1108,11 +1107,12 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		if (is_vn_port)
 			fc_lport_reset(vn_port);
 		else {
-			spin_lock_bh(&fip->lock);
+			mutex_lock(&fip->ctlr_mutex);
 			per_cpu_ptr(lport->dev_stats,
-				    smp_processor_id())->VLinkFailureCount++;
+				    get_cpu())->VLinkFailureCount++;
+			put_cpu();
 			fcoe_ctlr_reset(fip);
-			spin_unlock_bh(&fip->lock);
+			mutex_unlock(&fip->ctlr_mutex);
 
 			fc_lport_reset(fip->lp);
 			fcoe_ctlr_solicit(fip, NULL);
@@ -1166,7 +1166,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	if (ntohs(fiph->fip_dl_len) * FIP_BPW + sizeof(*fiph) > skb->len)
 		goto drop;
 
-	spin_lock_bh(&fip->lock);
+	mutex_lock(&fip->ctlr_mutex);
 	state = fip->state;
 	if (state == FIP_ST_AUTO) {
 		fip->map_dest = 0;
@@ -1174,7 +1174,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		state = FIP_ST_ENABLED;
 		LIBFCOE_FIP_DBG(fip, "Using FIP mode\n");
 	}
-	spin_unlock_bh(&fip->lock);
+	mutex_unlock(&fip->ctlr_mutex);
 	if (state != FIP_ST_ENABLED)
 		goto drop;
 
@@ -1240,19 +1240,38 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 /**
  * fcoe_ctlr_timeout() - FIP timeout handler
  * @arg: The FCoE controller that timed out
- *
- * Ages FCFs.  Triggers FCF selection if possible.  Sends keep-alives.
  */
 static void fcoe_ctlr_timeout(unsigned long arg)
 {
 	struct fcoe_ctlr *fip = (struct fcoe_ctlr *)arg;
+
+	schedule_work(&fip->timer_work);
+}
+
+/**
+ * fcoe_ctlr_timer_work() - Worker thread function for timer work
+ * @work: Handle to a FCoE controller
+ *
+ * Ages FCFs.  Triggers FCF selection if possible.
+ * Sends keep-alives and resets.
+ */
+static void fcoe_ctlr_timer_work(struct work_struct *work)
+{
+	struct fcoe_ctlr *fip;
+	struct fc_lport *vport;
+	u8 *mac;
+	u8 reset = 0;
+	u8 send_ctlr_ka = 0;
+	u8 send_port_ka = 0;
 	struct fcoe_fcf *sel;
 	struct fcoe_fcf *fcf;
 	unsigned long next_timer;
 
-	spin_lock_bh(&fip->lock);
+	fip = container_of(work, struct fcoe_ctlr, timer_work);
+
+	mutex_lock(&fip->ctlr_mutex);
 	if (fip->state == FIP_ST_DISABLED) {
-		spin_unlock_bh(&fip->lock);
+		mutex_unlock(&fip->ctlr_mutex);
 		return;
 	}
 
@@ -1286,7 +1305,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 			       "FIP Fibre-Channel Forwarder timed out.	"
 			       "Starting FCF discovery.\n",
 			       fip->lp->host->host_no);
-			fip->reset_req = 1;
+			reset = 1;
 			schedule_work(&fip->timer_work);
 		}
 	}
@@ -1294,7 +1313,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 	if (sel && !sel->fd_flags) {
 		if (time_after_eq(jiffies, fip->ctlr_ka_time)) {
 			fip->ctlr_ka_time = jiffies + sel->fka_period;
-			fip->send_ctlr_ka = 1;
+			send_ctlr_ka = 1;
 		}
 		if (time_after(next_timer, fip->ctlr_ka_time))
 			next_timer = fip->ctlr_ka_time;
@@ -1302,37 +1321,14 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 		if (time_after_eq(jiffies, fip->port_ka_time)) {
 			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
-			fip->send_port_ka = 1;
+			send_port_ka = 1;
 		}
 		if (time_after(next_timer, fip->port_ka_time))
 			next_timer = fip->port_ka_time;
 	}
 	if (!list_empty(&fip->fcfs))
 		mod_timer(&fip->timer, next_timer);
-	if (fip->send_ctlr_ka || fip->send_port_ka)
-		schedule_work(&fip->timer_work);
-	spin_unlock_bh(&fip->lock);
-}
-
-/**
- * fcoe_ctlr_timer_work() - Worker thread function for timer work
- * @work: Handle to a FCoE controller
- *
- * Sends keep-alives and resets which must not
- * be called from the timer directly, since they use a mutex.
- */
-static void fcoe_ctlr_timer_work(struct work_struct *work)
-{
-	struct fcoe_ctlr *fip;
-	struct fc_lport *vport;
-	u8 *mac;
-	int reset;
-
-	fip = container_of(work, struct fcoe_ctlr, timer_work);
-	spin_lock_bh(&fip->lock);
-	reset = fip->reset_req;
-	fip->reset_req = 0;
-	spin_unlock_bh(&fip->lock);
+	mutex_unlock(&fip->ctlr_mutex);
 
 	if (reset) {
 		fc_lport_reset(fip->lp);
@@ -1340,12 +1336,10 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 		fcoe_ctlr_solicit(fip, NULL);
 	}
 
-	if (fip->send_ctlr_ka) {
-		fip->send_ctlr_ka = 0;
+	if (send_ctlr_ka)
 		fcoe_ctlr_send_keep_alive(fip, NULL, 0, fip->ctl_src_addr);
-	}
-	if (fip->send_port_ka) {
-		fip->send_port_ka = 0;
+
+	if (send_port_ka) {
 		mutex_lock(&fip->lp->lp_mutex);
 		mac = fip->get_src_addr(fip->lp);
 		fcoe_ctlr_send_keep_alive(fip, fip->lp, 1, mac);
@@ -1402,9 +1396,9 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	if (op == ELS_LS_ACC && fh->fh_r_ctl == FC_RCTL_ELS_REP &&
 	    fip->flogi_oxid == ntohs(fh->fh_ox_id)) {
 
-		spin_lock_bh(&fip->lock);
+		mutex_lock(&fip->ctlr_mutex);
 		if (fip->state != FIP_ST_AUTO && fip->state != FIP_ST_NON_FIP) {
-			spin_unlock_bh(&fip->lock);
+			mutex_unlock(&fip->ctlr_mutex);
 			return -EINVAL;
 		}
 		fip->state = FIP_ST_NON_FIP;
@@ -1424,13 +1418,13 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			fip->map_dest = 0;
 		}
 		fip->flogi_oxid = FC_XID_UNKNOWN;
-		spin_unlock_bh(&fip->lock);
+		mutex_unlock(&fip->ctlr_mutex);
 		fc_fcoe_set_mac(fr_cb(fp)->granted_mac, fh->fh_d_id);
 	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa) {
 		/*
 		 * Save source MAC for point-to-point responses.
 		 */
-		spin_lock_bh(&fip->lock);
+		mutex_lock(&fip->ctlr_mutex);
 		if (fip->state == FIP_ST_AUTO || fip->state == FIP_ST_NON_FIP) {
 			memcpy(fip->dest_addr, sa, ETH_ALEN);
 			fip->map_dest = 0;
@@ -1439,7 +1433,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 						"Setting non-FIP mode\n");
 			fip->state = FIP_ST_NON_FIP;
 		}
-		spin_unlock_bh(&fip->lock);
+		mutex_unlock(&fip->ctlr_mutex);
 	}
 	return 0;
 }
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 81aee1c..7d18b50 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -75,14 +75,12 @@ enum fip_state {
  * @flogi_count:   number of FLOGI attempts in AUTO mode.
  * @map_dest:	   use the FC_MAP mode for destination MAC addresses.
  * @spma:	   supports SPMA server-provided MACs mode
- * @send_ctlr_ka:  need to send controller keep alive
- * @send_port_ka:  need to send port keep alives
  * @dest_addr:	   MAC address of the selected FC forwarder.
  * @ctl_src_addr:  the native MAC address of our local port.
  * @send:	   LLD-supplied function to handle sending FIP Ethernet frames
  * @update_mac:    LLD-supplied function to handle changes to MAC addresses.
  * @get_src_addr:  LLD-supplied function to supply a source MAC address.
- * @lock:	   lock protecting this structure.
+ * @ctlr_mutex:	   lock protecting this structure.
  *
  * This structure is used by all FCoE drivers.  It contains information
  * needed by all FCoE low-level drivers (LLDs) as well as internal state
@@ -106,18 +104,15 @@ struct fcoe_ctlr {
 	u16 user_mfs;
 	u16 flogi_oxid;
 	u8 flogi_count;
-	u8 reset_req;
 	u8 map_dest;
 	u8 spma;
-	u8 send_ctlr_ka;
-	u8 send_port_ka;
 	u8 dest_addr[ETH_ALEN];
 	u8 ctl_src_addr[ETH_ALEN];
 
 	void (*send)(struct fcoe_ctlr *, struct sk_buff *);
 	void (*update_mac)(struct fc_lport *, u8 *addr);
 	u8 * (*get_src_addr)(struct fc_lport *);
-	spinlock_t lock;
+	struct mutex ctlr_mutex;
 };
 
 /**

