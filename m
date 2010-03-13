From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/16] libfcoe: eliminate unused link and last_link fields
Date: Fri, 12 Mar 2010 16:08:23 -0800
Message-ID: <20100313000823.22251.11041.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41281 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:24 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The link and last_link fields in the fcoe_ctlr struct are no
longer useful, since they are always set to the same value,
and FIP always calls libfc to pass link information to the lport.

Eliminate those fields and rename link_work to timer_work, since
it no longer has any link change work to do.

Thanks to Brian Uchino for discovering this issue.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   40 +++++++++++-----------------------------
 include/scsi/libfcoe.h      |    8 ++------
 2 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index b2af53f..d60f332 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -50,7 +50,7 @@ MODULE_LICENSE("GPL v2");
 #define	FCOE_CTLR_DEF_FKA	FIP_DEF_FKA	/* default keep alive (mS) */
 
 static void fcoe_ctlr_timeout(unsigned long);
-static void fcoe_ctlr_link_work(struct work_struct *);
+static void fcoe_ctlr_timer_work(struct work_struct *);
 static void fcoe_ctlr_recv_work(struct work_struct *);
 
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
@@ -115,7 +115,7 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip)
 	spin_lock_init(&fip->lock);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
 	setup_timer(&fip->timer, fcoe_ctlr_timeout, (unsigned long)fip);
-	INIT_WORK(&fip->link_work, fcoe_ctlr_link_work);
+	INIT_WORK(&fip->timer_work, fcoe_ctlr_timer_work);
 	INIT_WORK(&fip->recv_work, fcoe_ctlr_recv_work);
 	skb_queue_head_init(&fip->fip_recv_list);
 }
@@ -163,7 +163,7 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 	fcoe_ctlr_reset_fcfs(fip);
 	spin_unlock_bh(&fip->lock);
 	del_timer_sync(&fip->timer);
-	cancel_work_sync(&fip->link_work);
+	cancel_work_sync(&fip->timer_work);
 }
 EXPORT_SYMBOL(fcoe_ctlr_destroy);
 
@@ -256,14 +256,10 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 {
 	spin_lock_bh(&fip->lock);
 	if (fip->state == FIP_ST_NON_FIP || fip->state == FIP_ST_AUTO) {
-		fip->last_link = 1;
-		fip->link = 1;
 		spin_unlock_bh(&fip->lock);
 		fc_linkup(fip->lp);
 	} else if (fip->state == FIP_ST_LINK_WAIT) {
 		fip->state = fip->mode;
-		fip->last_link = 1;
-		fip->link = 1;
 		spin_unlock_bh(&fip->lock);
 		if (fip->state == FIP_ST_AUTO)
 			LIBFCOE_FIP_DBG(fip, "%s", "setting AUTO mode.\n");
@@ -305,9 +301,7 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 	LIBFCOE_FIP_DBG(fip, "link down.\n");
 	spin_lock_bh(&fip->lock);
 	fcoe_ctlr_reset(fip);
-	link_dropped = fip->link;
-	fip->link = 0;
-	fip->last_link = 0;
+	link_dropped = fip->state != FIP_ST_LINK_WAIT;
 	fip->state = FIP_ST_LINK_WAIT;
 	spin_unlock_bh(&fip->lock);
 
@@ -1174,7 +1168,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 			       "Starting FCF discovery.\n",
 			       fip->lp->host->host_no);
 			fip->reset_req = 1;
-			schedule_work(&fip->link_work);
+			schedule_work(&fip->timer_work);
 		}
 	}
 
@@ -1200,43 +1194,31 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 		mod_timer(&fip->timer, next_timer);
 	}
 	if (fip->send_ctlr_ka || fip->send_port_ka)
-		schedule_work(&fip->link_work);
+		schedule_work(&fip->timer_work);
 	spin_unlock_bh(&fip->lock);
 }
 
 /**
- * fcoe_ctlr_link_work() - Worker thread function for link changes
+ * fcoe_ctlr_timer_work() - Worker thread function for timer work
  * @work: Handle to a FCoE controller
  *
- * See if the link status has changed and if so, report it.
- *
- * This is here because fc_linkup() and fc_linkdown() must not
+ * Sends keep-alives and resets which must not
  * be called from the timer directly, since they use a mutex.
  */
-static void fcoe_ctlr_link_work(struct work_struct *work)
+static void fcoe_ctlr_timer_work(struct work_struct *work)
 {
 	struct fcoe_ctlr *fip;
 	struct fc_lport *vport;
 	u8 *mac;
-	int link;
-	int last_link;
 	int reset;
 
-	fip = container_of(work, struct fcoe_ctlr, link_work);
+	fip = container_of(work, struct fcoe_ctlr, timer_work);
 	spin_lock_bh(&fip->lock);
-	last_link = fip->last_link;
-	link = fip->link;
-	fip->last_link = link;
 	reset = fip->reset_req;
 	fip->reset_req = 0;
 	spin_unlock_bh(&fip->lock);
 
-	if (last_link != link) {
-		if (link)
-			fc_linkup(fip->lp);
-		else
-			fc_linkdown(fip->lp);
-	} else if (reset && link)
+	if (reset)
 		fc_lport_reset(fip->lp);
 
 	if (fip->send_ctlr_ka) {
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index c603f4a..868ed26 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -65,14 +65,12 @@ enum fip_state {
  * @port_ka_time:  time of next port keep-alive.
  * @ctlr_ka_time:  time of next controller keep-alive.
  * @timer:	   timer struct used for all delayed events.
- * @link_work:	   &work_struct for doing FCF selection.
+ * @timer_work:	   &work_struct for doing keep-alives and resets.
  * @recv_work:	   &work_struct for receiving FIP frames.
  * @fip_recv_list: list of received FIP frames.
  * @user_mfs:	   configured maximum FC frame size, including FC header.
  * @flogi_oxid:    exchange ID of most recent fabric login.
  * @flogi_count:   number of FLOGI attempts in AUTO mode.
- * @link:	   current link status for libfc.
- * @last_link:	   last link state reported to libfc.
  * @map_dest:	   use the FC_MAP mode for destination MAC addresses.
  * @spma:	   supports SPMA server-provided MACs mode
  * @send_ctlr_ka:  need to send controller keep alive
@@ -100,14 +98,12 @@ struct fcoe_ctlr {
 	unsigned long port_ka_time;
 	unsigned long ctlr_ka_time;
 	struct timer_list timer;
-	struct work_struct link_work;
+	struct work_struct timer_work;
 	struct work_struct recv_work;
 	struct sk_buff_head fip_recv_list;
 	u16 user_mfs;
 	u16 flogi_oxid;
 	u8 flogi_count;
-	u8 link;
-	u8 last_link;
 	u8 reset_req;
 	u8 map_dest;
 	u8 spma;

