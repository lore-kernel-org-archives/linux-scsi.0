From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 5/5] fcoe: removes sharing of fcoe_rx_list for both FCoE and
	FIP frames
Date: Wed, 04 Mar 2009 10:54:03 -0800
Message-ID: <20090304185403.22010.8443.stgit@vi2.jf.intel.com>
References: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43610 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbZCDSyF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 13:54:05 -0500
In-Reply-To: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Creates separate recv path for incoming FIP frames instead sharing
same fcoe_rx_list for both FCoE and FIP incoming frames and then
catching FIP frames from fcoe_percpu_receive_thread using FCPHF_FIP
flag to call fcoe_ctlr_recv.

Removed FCPHF_FIP and its checking in fast path.

Instead added separate fip_recv_list and modified fcoe_ctlr_recv to
only add incoming FIP frames to this list and then schedule added
new recv_work function fcoe_ctlr_recv_work to do rest of the incoming
frame processing same as what older fcoe_ctlr_recv use to do, added
fcoe_ctlr_recv_handler is called from fcoe_ctlr_recv_work for
each incoming FIP frame in work thread context for rest of the
incoming FIP frame processing.

Now fcoe_ctlr_recv is directly called from fcoe_fip_recv function and
modified fcoe_fip_recv simply calls fcoe_ctlr_recv after retrieving
fcoe_ctlr, so fcoe_fip_recv could be completely removed later if
similar to this func or fcoe_ctlr_recv is directly registered by
FIP code.

Any pending fcoe_ctlr_recv_work is flushed when interface is destroyed.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c      |   20 ++------------------
 drivers/scsi/libfcoe/fcoe_ctlr.c |   37 +++++++++++++++++++++++++++++++++++--
 include/scsi/fc_frame.h          |    1 -
 include/scsi/fcoe_ctlr.h         |    4 +++-
 4 files changed, 40 insertions(+), 22 deletions(-)


diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 90d0136..34b41a9 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -270,20 +270,9 @@ int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
 		  struct net_device *orig_dev)
 {
 	struct fcoe_softc *fc;
-	struct fcoe_rcv_info *fr;
-	struct fcoe_percpu_s *fps;
 
 	fc = container_of(ptype, struct fcoe_softc, fip_packet_type);
-	fr = fcoe_dev_from_skb(skb);
-	fr->fr_dev = fc->ctlr.lp;
-	fr->fr_flags = FCPHF_FIP;
-
-	fps = fcoe_percpu[smp_processor_id()];
-	spin_lock_bh(&fps->fcoe_rx_list.lock);
-	__skb_queue_tail(&fps->fcoe_rx_list, skb);
-	if (fps->fcoe_rx_list.qlen == 1)
-		wake_up_process(fps->thread);
-	spin_unlock_bh(&fps->fcoe_rx_list.lock);
+	fcoe_ctlr_recv(&fc->ctlr, skb);
 	return 0;
 }
 
@@ -568,12 +557,6 @@ int fcoe_percpu_receive_thread(void *arg)
 			kfree_skb(skb);
 			continue;
 		}
-		fc = fcoe_softc(lp);
-		if (fr->fr_flags & FCPHF_FIP) {
-			fcoe_ctlr_recv(&fc->ctlr, skb);
-			continue;
-		}
-
 		stats = lp->dev_stats[smp_processor_id()];
 
 		if (unlikely(debug_fcoe)) {
@@ -664,6 +647,7 @@ int fcoe_percpu_receive_thread(void *arg)
 			}
 			fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 		}
+		fc = fcoe_softc(lp);
 		if (unlikely(fc->ctlr.flogi_oxid != FC_XID_UNKNOWN) &&
 		    fcoe_ctlr_recv_flogi(&fc->ctlr, fp, mac)) {
 			fc_frame_free(fp);
diff --git a/drivers/scsi/libfcoe/fcoe_ctlr.c b/drivers/scsi/libfcoe/fcoe_ctlr.c
index d5a411b..9956083 100644
--- a/drivers/scsi/libfcoe/fcoe_ctlr.c
+++ b/drivers/scsi/libfcoe/fcoe_ctlr.c
@@ -49,6 +49,7 @@ MODULE_LICENSE("GPL");
 
 static void fcoe_ctlr_timeout(unsigned long);
 static void fcoe_ctlr_work(struct work_struct *);
+static void fcoe_ctlr_recv_work(struct work_struct *);
 
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
 
@@ -101,6 +102,8 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip)
 	fip->flogi_oxid = FC_XID_UNKNOWN;
 	setup_timer(&fip->timer, fcoe_ctlr_timeout, (unsigned long)fip);
 	INIT_WORK(&fip->work, fcoe_ctlr_work);
+	INIT_WORK(&fip->recv_work, fcoe_ctlr_recv_work);
+	skb_queue_head_init(&fip->fip_recv_list);
 }
 EXPORT_SYMBOL(fcoe_ctlr_init);
 
@@ -127,6 +130,7 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
  */
 void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 {
+	flush_work(&fip->recv_work);
 	spin_lock_bh(&fip->lock);
 	fip->state = FIP_ST_DISABLED;
 	fcoe_ctlr_reset_fcfs(fip);
@@ -939,7 +943,19 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
  * Receive a FIP frame.
  * This is called from NET_RX_SOFTIRQ.
  */
-int fcoe_ctlr_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+void fcoe_ctlr_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	spin_lock_bh(&fip->fip_recv_list.lock);
+	__skb_queue_tail(&fip->fip_recv_list, skb);
+	spin_unlock_bh(&fip->fip_recv_list.lock);
+	schedule_work(&fip->recv_work);
+}
+EXPORT_SYMBOL(fcoe_ctlr_recv);
+
+/*
+ * Receive a FIP frame.
+ */
+static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fip_header *fiph;
 	struct ethhdr *eh;
@@ -994,7 +1010,6 @@ drop:
 	kfree_skb(skb);
 	return -1;
 }
-EXPORT_SYMBOL(fcoe_ctlr_recv);
 
 /*
  * Choose the best FCF, if possible.
@@ -1139,6 +1154,24 @@ static void fcoe_ctlr_work(struct work_struct *work)
 }
 
 /*
+ * Worker function to process received FIP frames.
+ */
+static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
+{
+	struct fcoe_ctlr *fip;
+	struct sk_buff *skb;
+
+	fip = container_of(recv_work, struct fcoe_ctlr, recv_work);
+	spin_lock_bh(&fip->fip_recv_list.lock);
+	while ((skb = __skb_dequeue(&fip->fip_recv_list))) {
+		spin_unlock_bh(&fip->fip_recv_list.lock);
+		fcoe_ctlr_recv_handler(fip, skb);
+		spin_lock_bh(&fip->fip_recv_list.lock);
+	}
+	spin_unlock_bh(&fip->fip_recv_list.lock);
+}
+
+/*
  * Pre-FIP FCoE-encapsulated FLOGI receive.
  *
  * Snoop potential response to FLOGI or even incoming FLOGI.
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 0c982a4..04d34a7 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -88,7 +88,6 @@ static inline struct fcoe_rcv_info *fcoe_dev_from_skb(const struct sk_buff *skb)
  * fr_flags.
  */
 #define	FCPHF_CRC_UNCHECKED	0x01	/* CRC not computed, still appended */
-#define	FCPHF_FIP		0x02	/* FIP protocol not FC */
 
 /*
  * Initialize a frame.
diff --git a/include/scsi/fcoe_ctlr.h b/include/scsi/fcoe_ctlr.h
index 6312f60..954110c 100644
--- a/include/scsi/fcoe_ctlr.h
+++ b/include/scsi/fcoe_ctlr.h
@@ -56,6 +56,8 @@ struct fcoe_ctlr {
 	unsigned long ctlr_ka_time;	/* time of next ctlr keep-alive */
 	struct timer_list timer;
 	struct work_struct work;
+	struct work_struct recv_work;
+	struct sk_buff_head fip_recv_list;
 	u16 user_mfs;			/* configured max frame size */
 	u16 flogi_oxid;			/* FLOGI OX_ID */
 	u8 flogi_count;			/* number of FLOGI attempts */
@@ -97,7 +99,7 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *);
 void fcoe_ctlr_start(struct fcoe_ctlr *);
 int fcoe_ctlr_stop(struct fcoe_ctlr *);
 int fcoe_ctlr_els_send(struct fcoe_ctlr *, struct sk_buff *);
-int fcoe_ctlr_recv(struct fcoe_ctlr *, struct sk_buff *);
+void fcoe_ctlr_recv(struct fcoe_ctlr *, struct sk_buff *);
 int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_frame *fp, u8 *sa);
 
 #endif /* _FCOE_CTLR_H_ */

